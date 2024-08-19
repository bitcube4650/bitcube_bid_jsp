package bitcube.framework.ebid.main.controller;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.main.service.MainService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/v1/main")
@CrossOrigin
@Slf4j
public class MainController {
	@Autowired 
	private MainService mainService;
	
	//전자입찰 건수 조회
	@PostMapping("/selectBidCnt")
	@ResponseBody
	public ResultBody selectBidCnt(HttpServletRequest request, @RequestParam Map<String, Object> params) throws IOException {
		ResultBody resultBody = new ResultBody();
		try { 
			resultBody = mainService.selectBidCnt(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("전자입찰 건수 조회에 실패하였습니다.");
			log.error("{} Error : {}", this.getClass(), e.getMessage());
		}
		return resultBody;
	}
	
	//협력사 업채수 조회
	@PostMapping("/selectPartnerCnt")
	@ResponseBody
	public ResultBody selectPartnerCnt(HttpServletRequest request, @RequestParam Map<String, Object> params) throws IOException {
		ResultBody resultBody = new ResultBody();
		try { 
			resultBody = mainService.selectPartnerCnt(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("협력사 업채수 조회에 실패하였습니다.");
			log.error("{} Error : {}", this.getClass(), e.getMessage());
		}
		return resultBody;
	}
	
	//협력사 전자입찰 건수 조회
	@PostMapping("/selectPartnerBidCnt")
	public ResultBody selectPartnerBidCnt(@RequestParam Map<String, Object> params) throws IOException {
		ResultBody resultBody = new ResultBody();
//		try {
//			resultBody = mainService.selectPartnerBidCnt(params);
//		} catch (Exception e) {
//			resultBody.setCode("ERROR");
//			resultBody.setStatus(500);
//			resultBody.setMsg("전자입찰 건수 조회에 실패하였습니다.");
//			log.error("{} Error : {}", this.getClass(), e.getMessage());
//		}
		return resultBody;
	}
	
	//입찰완료 조회
	@PostMapping("/selectCompletedBidCnt")
	public ResultBody selectCompletedBidCnt(@RequestParam Map<String, Object> params) throws IOException {
		ResultBody resultBody = new ResultBody();
//		try {
//			resultBody = mainService.selectCompletedBidCnt(params);
//		} catch (Exception e) {
//			resultBody.setCode("ERROR");
//			resultBody.setStatus(500);
//			resultBody.setMsg("입찰완료 조회에 실패하였습니다.");
//			log.error("{} Error : {}", this.getClass(), e.getMessage());
//		}
		return resultBody;
	}
	
	//비밀번호 확인
	@PostMapping("/checkPwd")
	@ResponseBody
	public ResultBody checkPwd(HttpServletRequest request, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = mainService.checkPwd(params);
		} catch(Exception e) {
			resultBody.setCode("Fail");
		}
		return resultBody;
	}
	
	//비밀번호 변경
	@PostMapping("/changePwd")
	@ResponseBody
	public ResultBody changePwd(HttpServletRequest request, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		
		try {
			mainService.changePwd(params);
		}catch(Exception e) {
			log.error(e.getMessage());
			resultBody.setCode("Fail");
		}
		return resultBody;
	}
	
	//유저 정보 조회
	@PostMapping("/selectUserInfo")
	@ResponseBody
	public ResultBody selectUserInfo(HttpServletRequest request, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = mainService.selectUserInfo(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("An error occurred while selecting the user info.");
			resultBody.setData(e.getMessage());
			
			log.error("{} Error : {}", this.getClass(), e.getMessage());
		}
		return resultBody;
	}
	
	//유저 정보 변경
	@PostMapping("/saveUserInfo")
	@ResponseBody
	public ResultBody saveUserInfo(HttpServletRequest request, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = mainService.saveUserInfo(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("An error occurred while updating the user info.");
			resultBody.setData(e.getMessage());
			
			log.error("{} Error : {}", this.getClass(), e.getMessage());
		}
		return resultBody;
	}
	
	//계열사 정보 조회 (사용하지 않음)
	@Deprecated
	@PostMapping("/selectCompInfo")
	public ResultBody selectCompInfo(@RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		//return mainService.selectCompInfo(params);
		return resultBody;		
	}

	//비밀번호 변경 권장 플래그
	@PostMapping("/chkPwChangeEncourage")
	@ResponseBody
	public ResultBody chkPwChangeEncourage(HttpServletRequest request, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		
		try {
			resultBody = mainService.chkPwChangeEncourage(params);
		}catch(Exception e) {
			log.error("chkPwChangeEncourage error : {}", e);
			resultBody.setCode("fail");
		}
		
		return resultBody;
				
	}
	

	// 초기 계열사 사용자 비밀번호 변경 처리 (호출 메소드를 못찾음 확인 필요)
	@PostMapping("/chgPwdFirst")
	public void chgPwdFirst() {
		log.info("-----------------------chgPwdFirst start----------------------");
//		try {
			//mainService.chgPwdFirst();
//		}catch(Exception e) {
//		}
		log.info("-----------------------chgPwdFirst end----------------------");
	}
}
