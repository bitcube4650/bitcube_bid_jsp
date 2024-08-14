package bitcube.framework.ebid.common.service;


import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import bitcube.framework.ebid.dao.GeneralDao;
import jakarta.servlet.http.HttpServletResponse;

@Service
public class ExcelService {

	@Autowired
	public GeneralDao generalDao;
	
	@SuppressWarnings("unchecked")
	public void downloadExcel(String sqlMapperId, Map<String, Object> params, HttpServletResponse response) throws Exception {
		// 데이터 조회
		Page listPage = generalDao.selectGernalListPage(sqlMapperId, params);
		List<Map<String, Object>> dataList = listPage.getContent();  // 데이터 목록
		
		// 엑셀 워크북 생성
		Workbook workbook = new XSSFWorkbook();
		Sheet sheet = workbook.createSheet("Data");
		
		// 파일명
		String fileName = (String) params.get("fileName");
		
		// 헤더 작성
		List<String> headers = (List<String>) params.get("headers");
		if (!dataList.isEmpty()) {
			if(headers != null) {
				Row headerRow = sheet.createRow(0);
				for (int i = 0; i < headers.size(); i++) {
					Cell cell = headerRow.createCell(i);
					cell.setCellValue(headers.get(i));
				}
			} else {
				Map<String, Object> firstRow = dataList.get(0);
				Row headerRow = sheet.createRow(0);
				int headerCellIndex = 0;
				for (String key : firstRow.keySet()) {
					Cell cell = headerRow.createCell(headerCellIndex++);
					cell.setCellValue(key);
				}
			}
		}
		
		// 데이터 작성
		int rowIndex = 1;
		for (Map<String, Object> rowData : dataList) {
			Row row = sheet.createRow(rowIndex++);
			int cellIndex = 0;
			for (Object value : rowData.values()) {
				Cell cell = row.createCell(cellIndex++);
				cell.setCellValue(value != null ? value.toString() : "");
			}
		}
		
		// 엑셀 파일을 HTTP 응답으로 반환
		try (ByteArrayOutputStream bos = new ByteArrayOutputStream()) {
			workbook.write(bos);
			workbook.close();
			
			// HTTP 헤더 설정
			response.setHeader("Content-Disposition", "attachment; filename="+fileName+".xlsx");
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.getOutputStream().write(bos.toByteArray());
			response.flushBuffer();
		} catch (IOException e) {
		    e.printStackTrace();
		}
	}
}