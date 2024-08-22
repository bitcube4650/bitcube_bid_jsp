package bitcube.framework.ebid.bid.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;

import bitcube.framework.ebid.bid.service.BidPartnerStatusService;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.Constances;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/v1/bidPtStatus")
@CrossOrigin
@Slf4j
public class BidPartnerStatusController {
	@Autowired
	private BidPartnerStatusService bidPtStatusService;
	
	/**
	 * 입찰진행 리스트
	 * @param params
	 * @return
	 */
	@PostMapping("/statuslist")
	public ResultBody statuslist(
			@RequestParam(name="page",			defaultValue="0") int page,
			@RequestParam(name="size",			defaultValue="10") int size,
			@RequestParam(name="bidNo",			defaultValue="") String bidNo,
			@RequestParam(name="bidName",		defaultValue="") String bidName,
			@RequestParam(name="bidModeA",		required=false) boolean bidModeA,
			@RequestParam(name="bidModeB",		required=false) boolean bidModeB,
			@RequestParam(name="esmtYnY",		required=false) boolean esmtYnY,
			@RequestParam(name="esmtYnN",		required=false) boolean esmtYnN,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("page",		page);
		params.put("size",		size);
		
		// 조회조건
		params.put("bidNo",		bidNo);
		params.put("bidName",	bidName);
		params.put("bidModeA",	bidModeA);			// 입찰방식 - 지명 
		params.put("bidModeB",	bidModeB);			// 입찰방식 - 일반 
		params.put("esmtYnY",	esmtYnY);			// 투찰상태 - 투찰 
		params.put("esmtYnN",	esmtYnN);			// 투찰상태 - 미투찰
		
		try {
			resultBody = bidPtStatusService.statuslist(params, user); 
		}catch(Exception e) {
			log.error("statuslist list error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰 진행 리스트를 가져오는것을 실패하였습니다.");	
		}
		return resultBody;
	}
	

	/**
	 * 견적금액 단위 코드
	 * @return
	 */
	@PostMapping("/currList")
	public ResultBody currList(HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = bidPtStatusService.currList();
		}catch(Exception e) {
			log.error("currList error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("견적금액 단위 리스트를 가져오는것을 실패하였습니다.");	
		}
		return resultBody;
	}

	/**
	 * 투찰
	 * @param jsonData
	 * @param file1
	 * @param file2
	 * @param user
	 * @return
	 */
	@SuppressWarnings({ "unchecked" })
	@PostMapping("/bidSubmitting")
	public ResultBody bidSubmitting(
			@RequestPart("data") String jsonData,
			@RequestPart(value = "detailFile", required = false) MultipartFile detailFile, 
			@RequestPart(value = "etcFile", required = false) MultipartFile etcFile,
			HttpServletRequest request
		) {
		
		ResultBody resultBody = new ResultBody();

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> params = null;
		try {
			params = mapper.readValue(jsonData, Map.class);
			resultBody = bidPtStatusService.bidSubmitting(params, detailFile, etcFile, user);
		} catch (Exception e) {
			log.error("bidSubmitting error : {}", e);
			resultBody.setCode("ERROR");
			resultBody.setStatus(999);
		} 
		return resultBody;
	}
}
