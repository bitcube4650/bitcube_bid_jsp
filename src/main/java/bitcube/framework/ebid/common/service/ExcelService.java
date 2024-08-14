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
		
		// 헤더, 컬럼
		List<Map<String, String>> dataJson = (List<Map<String, String>>) params.get("dataJson");
		
		if (dataJson != null && !dataJson.isEmpty()) {
			// 헤더 작성
			Row headerRow = sheet.createRow(0);
			for (int i = 0; i < dataJson.size(); i++) {
				Map<String, String> columnMapping = dataJson.get(i);
				String header = columnMapping.get("header");
				Cell cell = headerRow.createCell(i);
				cell.setCellValue(header);
			}
			
			// 데이터 작성
			int rowIndex = 1;
			for (Map<String, Object> rowData : dataList) {
				Row row = sheet.createRow(rowIndex++);
				int cellIndex = 0;
				for (Map<String, String> columnMapping : dataJson) {
					String columnName = columnMapping.get("column");
					Object value = rowData.get(columnName);
					Cell cell = row.createCell(cellIndex++);
					cell.setCellValue(value != null ? value.toString() : "");
				}
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