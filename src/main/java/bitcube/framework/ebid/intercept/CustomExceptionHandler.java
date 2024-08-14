package bitcube.framework.ebid.intercept;

import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import bitcube.framework.ebid.etc.util.CommonUtils;

@ControllerAdvice
public class CustomExceptionHandler {
	
	@ExceptionHandler(UserInfoEmptyException.class)
	public ResponseEntity<?> handleCustomException(UserInfoEmptyException ex) {
		// JSON 응답 생성
		String jsonResponse = "";
		int code = CommonUtils.getInt(ex.getMessage());
		if(ex.getMessage().equals("999")) {
			jsonResponse = "{\"error\":\"로그인 세션이 만료되었습니다.\"}";
		}else {
			jsonResponse = "{\"error\":\"문제가 발생하였습니다.\"}";
		}
		
		// 응답 헤더에 Content-Type과 Charset 설정
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.CONTENT_TYPE, "application/json; charset=UTF-8");

		return new ResponseEntity<>(jsonResponse, headers, code);
	}
}