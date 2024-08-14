package bitcube.framework.ebid.common.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import bitcube.framework.ebid.common.service.ExcelService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/api/v1")
@SuppressWarnings("rawtypes")
public class ExcelController {

	@Autowired
	private ExcelService excelService;
	
	@PostMapping("/{path1}/{path2}/excel")
	public ResponseEntity downloadExcel(	
								HttpServletRequest request,
								@PathVariable String path1,
								@PathVariable String path2,
								@RequestBody Map<String, Object> params,
								HttpServletResponse response) {
		// SQL 매퍼 ID 생성
		String sqlMapperId = path1 + "." + path2;
		
		try {
			excelService.downloadExcel(sqlMapperId, params, response);
		} catch (Exception e) {
			// 대충 엑셀 다운에 실패했다는거
			e.printStackTrace();
		}
		return ResponseEntity.status(HttpStatus.OK).body(null);
	}
}
