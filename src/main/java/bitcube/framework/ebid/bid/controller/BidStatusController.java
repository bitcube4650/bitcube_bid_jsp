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
}
