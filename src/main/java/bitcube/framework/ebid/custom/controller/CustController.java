package bitcube.framework.ebid.custom.controller;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;

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
		//params.put("interrelatedCustCode", user.getCustCode());
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
	
	
	/**
	 * 업체 사용자 리스트
	 * 
	 * @param params
	 * @param user
	 * @return
	 * @throws Exception 
	 */
	@PostMapping("/userListForCust")
	@ResponseBody
	public ResultBody userListForCust(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		try {

			resultBody = custService.userList(params);
		}catch(Exception e) {

			resultBody.setCode("fail");
			resultBody.setMsg("사용자관리 리스트를 가져오는것을 실패하였습니다.");
		}
		return resultBody;
	}
	
	
	/**
	 * 타 계열사 업체 리스트
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/otherCustList")
	@ResponseBody
	public ResultBody otherCustList(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody= custService.otherCustList(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("타 계열사 업체 리스트 조회 중 오류가 발생하였습니다.");
		}
		return resultBody;
	}
	
	/**
	 * 업체 등록(회원가입) 및 수정
	 * @param regnumFile
	 * @param bFile
	 * @param params
	 * @param user
	 * @return
	 */
	@PostMapping("/save")
	@ResponseBody
	public ResultBody save(HttpServletRequest httpServletRequest,
			@RequestPart(value = "regnumFile", required = false) MultipartFile regnumFile,
			@RequestPart(value = "bFile", required = false) MultipartFile bFile,
			@RequestPart("data")  String data) {
		ResultBody resultBody = new ResultBody();

		try {
			ObjectMapper mapper = new ObjectMapper();
	        Map<String, Object> params = mapper.readValue(data, Map.class);
			custService.save(params, regnumFile, bFile);
		} catch (IOException e) {
			resultBody.setCode("UPLOAD");
			resultBody.setStatus(500);
			resultBody.setMsg("파일 업로드시 오류가 발생했습니다.");
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("업체 저장 중 오류가 발생하였습니다.");
		}
		return resultBody;
	}
	
	/**
	 * 업체 삭제 처리
	 * @param params
	 * @param user
	 * @return
	 */
	@PostMapping("/del")
	@ResponseBody
	public ResultBody del(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		
		try {
			custService.del(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("업체 삭제 중 오류가 발생하였습니다.");
		}
		
		return resultBody;
	}

	
	/**
	 * 업체 사용자 등록 및 수정
	 * @param params
	 * @param user
	 * @return
	 */
	@PostMapping("/custUserSave")
	@ResponseBody
	public ResultBody custUserSave(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			custService.custUserSave(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("업체 상세 내용 조회 중 오류가 발생하였습니다.");
		}
		
		return resultBody;
	}

	/**
	 * 업체 사용자 삭제
	 * @param params
	 * @param user
	 * @return
	 */
	@PostMapping("custUserDel")
	@ResponseBody
	public ResultBody custUserDel(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			custService.custUserDel(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("업체 상세 내용 조회 중 오류가 발생하였습니다.");
		}
		
		return resultBody;
	}
	
	/**
	 * 업체 상세 조회
	 * @param httpServletRequest
	 * @param params
	 * @return
	 */
	@PostMapping("/otherCustDetail")
	@ResponseBody
	public ResultBody selectOtherCustDetail(HttpServletRequest httpServletRequest,  @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = custService.otherCustDetail(params);
		}catch(Exception e) {
			resultBody.setCode("fail");
			resultBody.setMsg("타계열사 업체 정보를 가져오는 것을 실패하였습니다.");
		}
		return resultBody;
	}
		
}