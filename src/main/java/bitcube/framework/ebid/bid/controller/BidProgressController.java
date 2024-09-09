package bitcube.framework.ebid.bid.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import bitcube.framework.ebid.bid.service.BidProgressService;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.etc.util.CommonUtils;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/v1/bid")
@CrossOrigin
@Slf4j
public class BidProgressController {
	
	@Autowired
	private BidProgressService bidProgressService;

	@PostMapping(value = "/progressList", produces = "application/json")
	public ResultBody progresslist(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		
		try {
			return bidProgressService.progressList(params);
		} catch (Exception e) {
			log.error("BidProgressService selectProgressList error : ", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰 계획 리스트를 가져오는것을 실패하였습니다.");
			return resultBody;
		}
	}
	
	@PostMapping("/progressCodeList")
	public ResultBody progressCodeList(HttpServletRequest httpServletRequest){
		ResultBody resultBody = new ResultBody();
		
		try {
			resultBody = bidProgressService.progressCodeList();
		} catch (Exception e) {
			log.error("progressCodeList error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰분류 코드 조회를 실패하였습니다.");
		}
		return resultBody;
	}
	
	@PostMapping("/delete")
	public ResultBody delete(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		try {
			resultBody = bidProgressService.delete(params);
		} catch (Exception e) {
			log.error("bid delete error : {}", e);
			resultBody.setCode("fail");
		}
		return resultBody;
	}
	
	@PostMapping("/bidNotice")
	public ResultBody bidNotice(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		ObjectMapper mapper = new ObjectMapper();
		String custUserIdsStr = CommonUtils.getString(params.get("custUserIds"));
		String custCodeArr = CommonUtils.getString(params.get("custCode"));
		
		List<String> custUserIds = mapper.readValue(custUserIdsStr, new TypeReference<List<String>>() {});
		List<String> custCode = mapper.readValue(custCodeArr, new TypeReference<List<String>>() {});
		
		params.put("custUserIds", custUserIds);
		params.put("custCode", custCode);
		
		try {
			bidProgressService.bidNotice(params);
		} catch (Exception e) {
			log.error("bidNotice error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰 공고를 실패하였습니다.");
		}
		return resultBody;
	}
	
}
