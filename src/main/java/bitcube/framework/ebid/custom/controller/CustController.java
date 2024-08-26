package bitcube.framework.ebid.custom.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import bitcube.framework.ebid.core.CustomUserDetails;
import bitcube.framework.ebid.custom.service.CustService;
import bitcube.framework.ebid.dto.ResultBody;
import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/api/v1/cust")
public class CustController {

	@Autowired
	private CustService custService;

	/**
	 * 업체 승인 리스트
	 * @param params
	 * @param user
	 * @return
	 * @throws Exception 
	 */
	@PostMapping("/approvalList")
	@ResponseBody
	public ResultBody approvalList(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params, @AuthenticationPrincipal CustomUserDetails user) {
		ResultBody resultBody = new ResultBody();
		params.put("interrelatedCustCode", user.getCustCode());
		try {
			resultBody= custService.custList(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("업체 승인 리스트 조회 중 오류가 발생하였습니다.");
		}
		return resultBody;
	}
	
	/**
	 * 업체 상세 조회
	 * @param httpServletRequest
	 * @param params
	 * @return
	 */
	@PostMapping("/CustDetail")
	@ResponseBody
	public ResultBody selectCustDetail(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = custService.custDetail(params);
		}catch(Exception e) {
			resultBody.setCode("fail");
			resultBody.setMsg("사용자관리 리스트를 가져오는것을 실패하였습니다.");
		}
		return resultBody;
	}
	
	/**
	 * 업체 반려 처리
	 * @param params
	 * @param user
	 * @return
	 */
	@PostMapping("/back")
	@ResponseBody
	public ResultBody back(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			custService.back(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("업체 반려 중 오류가 발생하였습니다.");
		}
		
		return resultBody;
	}
	
	/**
	 * 업체 승인 처리
	 * @param params
	 * @return
	 */
	@PostMapping("/approval")
	@ResponseBody
	public ResultBody approval(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			custService.approval(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("업체 승인 중 오류가 발생하였습니다.");
		}
		return resultBody;
	}
	
}