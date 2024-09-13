package bitcube.framework.ebid.custom.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import bitcube.framework.ebid.custom.service.CustUserService;
import bitcube.framework.ebid.dto.ResultBody;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/v1/custuser")
@CrossOrigin
@Slf4j
public class CustUserController {

	@Autowired
	private CustUserService custUserService;
	
	/**
	 * 업체 사용자 리스트
	 * 
	 * @param params
	 * @param user
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("rawtypes")
	@PostMapping("/userListForCust")
	public ResultBody userListForCust(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = custUserService.userList(params);
		}catch(Exception e) {
			log.error("userList error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("사용자관리 리스트를 가져오는것을 실패하였습니다.");
		}
		return resultBody;
	}
}
