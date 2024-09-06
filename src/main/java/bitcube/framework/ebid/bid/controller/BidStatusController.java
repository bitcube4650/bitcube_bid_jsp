package bitcube.framework.ebid.bid.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import bitcube.framework.ebid.bid.service.BidStatusService;
import bitcube.framework.ebid.dto.ResultBody;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/v1/bidstatus")
@CrossOrigin
@Slf4j
public class BidStatusController {
	@Autowired
	private BidStatusService bidStatusService;
	
	/**
	 * 입찰진행 리스트
	 * @param params
	 * @return
	 */
	@PostMapping("/statuslist")
	public ResultBody statuslist(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = bidStatusService.statuslist(params);
		}catch(Exception e) {
			log.error("statuslist list error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("입찰 진행 리스트를 가져오는것을 실패하였습니다.");	
		}
		return resultBody;
	}
	
	/**
	 * 낙찰
	 * @param params
	 * @return
	 */
	@PostMapping("/bidSucc")
	public ResultBody bidSucc(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		
		try {
			resultBody = bidStatusService.bidSucc(params); 
		}catch(Exception e) {
			log.error("bidSucc error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("낙찰 처리중 오류가 발생했습니다.");	
		}
		return resultBody;
	}
	
	/**
	 * 유찰
	 * @param params
	 * @return
	 */
	@PostMapping("/bidFailure")
	public ResultBody bidFailure(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		
		try {
			resultBody = bidStatusService.bidFailure(params); 
		}catch(Exception e) {
			log.error("bidFailure error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("유찰 처리중 오류가 발생했습니다.");
		}
		return resultBody;
	}
	
	/**
	 * 개찰하기
	 * @param params
	 * @return
	 */
	@PostMapping("/bidOpening")
	public ResultBody bidOpening(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		
		try {
			resultBody = bidStatusService.bidOpening(params); 
		}catch(Exception e) {
			log.error("bidOpening error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("개찰 처리중 오류가 발생했습니다.");	
		}
		return resultBody;
	}
	
	/**
	 * 제출이력
	 * @param params
	 * @return
	 */
	@PostMapping("/submitHist")
	public ResultBody submitHist(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = bidStatusService.submitHist(params); 
		}catch(Exception e) {
			log.error("bidSucc error : {}", e);
			resultBody.setCode("fail");
			resultBody.setMsg("제출 이력을 가져오는 도중 오류가 발생했습니다.");	
		}
		return resultBody;
	}
	
}
