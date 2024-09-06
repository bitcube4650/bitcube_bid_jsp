package bitcube.framework.ebid.custom.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import bitcube.framework.ebid.core.CustomUserDetails;
import bitcube.framework.ebid.custom.service.UserService;
import bitcube.framework.ebid.dto.ResultBody;
import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/api/v1/couser")
public class CoUserController {

	@Autowired
	private UserService userService;

	// 계열사 리스트
	@PostMapping("/interrelatedList")
	public ResultBody interrelatedList() {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = userService.interrelatedList();
		}catch(Exception e) {
			resultBody.setCode("fail");
			resultBody.setMsg("계열사 가져오기를 실패했습니다.");
		}
		return resultBody;
	}

	/**
	 * 사용자 리스트
	 * @param params interrelatedCustCode
	 * @param params useYn
	 * @param params userName
	 * @param params userId
	 * @return
	 */
	@PostMapping("/userList")
	@ResponseBody
	public ResultBody userList(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = userService.userList(params);
		}catch(Exception e) {
			resultBody.setCode("fail");
			resultBody.setMsg("사용자관리 리스트를 가져오는것을 실패하였습니다.");
		}
		return resultBody;
	}
	
	/**
	 * login Id 체크
	 * @param params
	 * @return
	 */
	@PostMapping("/idcheck")
	@ResponseBody
	public ResultBody idcheck(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = userService.idcheck(params);
		} catch (Exception e) {
			resultBody.setCode("fail");
			resultBody.setMsg("로그인 ID 체크를 실패하였습니다.");
		}
		return resultBody;
	}

	/**
	 * 사용자 상세
	 * @param params userId
	 * @return
	 */
    @PostMapping("/userDetail")
	@ResponseBody
	public ResultBody userDetail(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = userService.userDetail(params);
		}catch(Exception e) {
			resultBody.setCode("fail");
			resultBody.setMsg("사용자 상세를 가져오는것을 실패하였습니다.");
		}
		return resultBody;
	}

    
    
    /**
     * 사용자 저장/수정
     * @param httpServletRequest
     * @param params
     * @return
     */
    @PostMapping("/userSave")
	@ResponseBody
    public ResultBody userSave(HttpServletRequest httpServletRequest, @RequestPart("data")  String data) {
		ResultBody resultBody = new ResultBody();
		try {
			ObjectMapper mapper = new ObjectMapper();
	        Map<String, Object> params = mapper.readValue(data, Map.class);
			resultBody = userService.userSave(params);
		}catch(Exception e) {
			resultBody.setCode("fail");
			resultBody.setMsg("사용자 저장에 실패하였습니다.");
		}
		return resultBody;
    }
    
    
	/**
	 * 비밀번호 변경
	 * @param params userId
	 * @param params chgPassword
	 * @return
	 */
	@PostMapping("/saveChgPwd")
	@ResponseBody
	public ResultBody saveChgPwd(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = userService.saveChgPwd(params);
		}catch(Exception e) {
			resultBody.setCode("fail");
			resultBody.setMsg("비밀번호 변경에 실패하였습니다.");
		}
		return resultBody;
    }


}