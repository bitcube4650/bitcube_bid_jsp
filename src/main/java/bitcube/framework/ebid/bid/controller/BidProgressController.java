package bitcube.framework.ebid.bid.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import bitcube.framework.ebid.bid.service.BidProgressService;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.CommonUtils;
import bitcube.framework.ebid.etc.util.Constances;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
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
	
	@PostMapping("/custList")
	public ResultBody custList(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) throws Exception {
			return bidProgressService.custList(params);
	}
	
	@PostMapping("/userList")
	public ResultBody selectUserList(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) throws Exception {
		return bidProgressService.userList(params);
	}
	
	@PostMapping("/insertBid")
	public ResultBody insertBid(
			HttpServletRequest httpServletRequest,
			@RequestParam("bidContent") String bidContent,
			@RequestParam(value = "insFile", required = false) MultipartFile insFile,
			@RequestParam(value = "innerFiles", required = false) List<MultipartFile> innerFiles,
			@RequestParam(value = "outerFiles", required = false) List<MultipartFile> outerFiles) {
		ResultBody resultBody = new ResultBody();
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> params = null;
		
		HttpSession session		= httpServletRequest.getSession();
		UserDto user = (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		try {
			params = mapper.readValue(bidContent, Map.class);
			params.put("userDto", user);
			resultBody = bidProgressService.insertBid(params, insFile, innerFiles, outerFiles);
		} catch (Exception e) {
			log.error("insertBid  error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰 공고 등록을 실패하였습니다.");
		}
		return resultBody;
	}
	
	@PostMapping("/updateBid")
	public ResultBody updateBid(
			HttpServletRequest httpServletRequest,
			@RequestParam("bidContent") String bidContent,
			@RequestParam(value = "insFile", required = false) MultipartFile insFile,
			@RequestParam(value = "innerFiles", required = false) List<MultipartFile> innerFiles,
			@RequestParam(value = "outerFiles", required = false) List<MultipartFile> outerFiles) {
		ResultBody resultBody = new ResultBody();
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> params = null;
		
		HttpSession session		= httpServletRequest.getSession();
		UserDto user = (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		try {
			params = mapper.readValue(bidContent, Map.class);
			params.put("userDto", user);
			resultBody = bidProgressService.updateBid(params, insFile, innerFiles, outerFiles);
		} catch (Exception e) {
			log.error("updateBid  error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰 공고 수정을 실패하였습니다.");
		}
		return resultBody;
	}
	
	@PostMapping("/pastBidList")
	public ResultBody pastBidList(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params){
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = bidProgressService.pastBidList(params);
		} catch (Exception e) {
			log.error("progressCodeList error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("과거입찰 조회를 실패하였습니다.");
		}
		return resultBody;
	}
	
	@PostMapping("/progresslistDetail")
	public ResultBody progresslistDetail(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params){
		ResultBody resultBody = new ResultBody();
		try {
			resultBody =  bidProgressService.progresslistDetail(params);
		} catch (Exception e) {
			log.error("progresslistDetail error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰 상세 조회를 실패하였습니다.");
		}
		return resultBody;
	}

}
