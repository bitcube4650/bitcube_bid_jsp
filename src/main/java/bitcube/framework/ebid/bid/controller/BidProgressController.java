package bitcube.framework.ebid.bid.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import bitcube.framework.ebid.bid.service.BidProgressService;
import bitcube.framework.ebid.dto.ResultBody;
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
	
}
