package bitcube.framework.ebid.bid.controller;


import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import bitcube.framework.ebid.bid.service.BidCompleteService;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.Constances;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/v1/bidComplete")
@CrossOrigin
@Slf4j
public class BidCompleteController {
	
	@Autowired
	private BidCompleteService bidCompleteSvc;
	
	/**
	 * 입찰완료 리스트
	 * @param params
	 * @return
	 */
	@PostMapping(value="/list", produces = "application/json")
	@ResponseBody
	public ResultBody complateBidList(
			@RequestParam(name="page",			defaultValue="0") int page,
			@RequestParam(name="size",			defaultValue="10") int size,
			@RequestParam(name="startDate",		defaultValue="") String startDate,
			@RequestParam(name="endDate",		defaultValue="") String endDate,
			@RequestParam(name="biNo",			defaultValue="") String biNo,
			@RequestParam(name="biName",		defaultValue="") String biName,
			@RequestParam(name="succBi",		required = false) boolean succBi,
			@RequestParam(name="failBi",		required = false) boolean failBi,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("page",		page);
		params.put("size",		size);
		params.put("startDate",	startDate);
		params.put("endDate",	endDate);
		params.put("biNo",		biNo);
		params.put("biName",	biName);
		params.put("succBi",	succBi);
		params.put("failBi",	failBi);
		
		try {
			
			resultBody = bidCompleteSvc.complateBidList(params, user); 
			
		}catch(Exception e) {
			System.out.println(e);
			log.error("bidComplete list error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰 완료 리스트를 가져오는것을 실패하였습니다.");	
		}
		return resultBody;
	}
	
	/**
	 * 암호화 안된 파일 다운로드
	 * @param params
	 * @return
	 * @throws IOException
	 */
	@PostMapping("/fileDown")
	public ByteArrayResource downloadFile(HttpServletRequest request, @RequestParam Map<String, Object> params) throws IOException {
		ByteArrayResource result = null;
		try {
			
			result = bidCompleteSvc.fileDown(params); 
		}catch(Exception e) {
			log.error("downloadFile error : {}", e);
		}
		return result;

	}
	
	/**
	 * 실제계약금액 업데이트
	 * @param params
	 * @return
	 * @throws IOException
	 */
	@PostMapping("/updRealAmt")
	public ResultBody updRealAmt(
			@RequestParam(name="realAmt",		defaultValue="") String realAmt,
			@RequestParam(name="biNo",			defaultValue="") String biNo,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("realAmt", realAmt);
		params.put("biNo", biNo);
		try {
			resultBody = bidCompleteSvc.updRealAmt(params); 
		}catch(Exception e) {
			log.error("updRealAmt error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("실제계약금액 업데이트를 실패했습니다.");
		}
		return resultBody;
	}
//	
//	/**
//	 * 롯데에너지머티리얼즈 코드값
//	 * @param params
//	 * @return
//	 * @throws IOException
//	 */
//	@PostMapping("/lotteMatCode")
//	public ResultBody lotteMatCode(@RequestBody Map<String, Object> params) throws IOException {
//		ResultBody resultBody = new ResultBody();
//		try {
//			resultBody = bidCompleteSvc.lotteMatCode(params); 
//		}catch(Exception e) {
//			log.error("lotteMatCode list error : {}", e);
//			resultBody.setCode("fail");
//			resultBody.setMsg("코드값을 가져오는것을 실패하였습니다.");
//		}
//		return resultBody;
//	}
	
	/**
	 * 낙찰이력 리스트
	 * @param params
	 * @return
	 */
	@PostMapping("/history")
	public ResultBody complateBidhistory(
			@RequestParam(name="page",			defaultValue="0") int page,
			@RequestParam(name="size",			defaultValue="10") int size,
			@RequestParam(name="startDate",		defaultValue="") String startDate,
			@RequestParam(name="endDate",		defaultValue="") String endDate,
			@RequestParam(name="biNo",			defaultValue="") String biNo,
			@RequestParam(name="biName",		defaultValue="") String biName,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("page",		page);
		params.put("size",		size);
		params.put("startDate",	startDate);
		params.put("endDate",	endDate);
		params.put("biNo",		biNo);
		params.put("biName",	biName);
		
		try {
			resultBody = bidCompleteSvc.complateBidhistory(params, user); 
		}catch(Exception e) {
			log.error("complateBidhistory list error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("낙찰 이력 리스트를 가져오는것을 실패하였습니다.");
		}
		return resultBody;
	}
	
	/**
	 * 낙찰이력 내 투찰업체 팝업 리스트
	 * @param params
	 * @return
	 */
	@PostMapping("/joinCustList")
	public ResultBody joinCustList(
			@RequestParam(name="biNo",		required = true) String biNo,
			HttpServletRequest request
		) {
		ResultBody resultBody = new ResultBody();
		
		Map<String, Object> params = new HashMap();
		params.put("biNo", biNo);
		try {
			resultBody = bidCompleteSvc.joinCustList(params); 
		}catch(Exception e) {
			log.error("joinCustList list error : {}", e);
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("투찰 정보를 가져오는것을 실패하였습니다.");
		}
		return resultBody;
	}
	
	/**
	 * 협력사 입찰완료 리스트
	 * @param params
	 * @return
	 */
	@PostMapping("/partnerList")
	public ResultBody complateBidPartnerList(
			@RequestParam(name="page",			defaultValue="0") int page,
			@RequestParam(name="size",			defaultValue="10") int size,
			@RequestParam(name="startDate",		defaultValue="") String startDate,
			@RequestParam(name="endDate",		defaultValue="") String endDate,
			@RequestParam(name="biNo",			defaultValue="") String biNo,
			@RequestParam(name="biName",		defaultValue="") String biName,
			@RequestParam(name="succYn_Y",		required = false) boolean succYn_Y,
			@RequestParam(name="succYn_N",		required = false) boolean succYn_N,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("page",		page);
		params.put("size",		size);
		params.put("startDate",	startDate);
		params.put("endDate",	endDate);
		params.put("biNo",		biNo);
		params.put("biName",	biName);
		params.put("succYn_Y",	succYn_Y);
		params.put("succYn_N",	succYn_N);
		
		try {
			resultBody = bidCompleteSvc.complateBidPartnerList(params, user); 
		}catch(Exception e) {
			log.error("complateBidPartnerList list error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰 완료 리스트를 가져오는것을 실패하였습니다.");	
		}
		return resultBody;
	}
	
	/**
	 * 협력사 낙찰확인 업데이트
	 * @param params
	 * @return
	 */
	@PostMapping("/updBiCustFlag")
	public ResultBody updBiCustFlag(
			@RequestParam(name="biNo",			defaultValue="") String biNo,
			@RequestParam(name="esmtYn",		defaultValue="3") String esmtYn,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();
		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("biNo",		biNo);
		params.put("esmtYn",	esmtYn);
		try {
			resultBody = bidCompleteSvc.updBiCustFlag(params, user); 
		}catch(Exception e) {
			log.error("updBiCustFlag error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("낙찰승인 저장을 실패하였습니다.");
		}
		return resultBody;
	}
}