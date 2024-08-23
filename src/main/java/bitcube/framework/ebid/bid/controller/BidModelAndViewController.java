package bitcube.framework.ebid.bid.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import bitcube.framework.ebid.bid.service.BidCompleteService;
import bitcube.framework.ebid.bid.service.BidPartnerStatusService;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.Constances;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RestController
@CrossOrigin
public class BidModelAndViewController {
	
	@Autowired
	private BidCompleteService bidCompleteSvc;

	@Autowired
	private BidPartnerStatusService bidPtStatusService;

	
	/**
	 * 협력사 > 입찰완료 상세
	 * @param params
	 * @return
	 * @throws Exception 
	 */
	@PostMapping("/api/v1/bidComplete/partnerDetail")
	public ModelAndView complateBidPartnerDetail(
			@RequestParam(name="biNo",			defaultValue="") String biNo,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		if(user == null) {
			modelAndView.setViewName("redirect:/");
			return modelAndView;
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("biNo", biNo);
		
		// 입찰정보 setting
		modelAndView.addObject("biInfo", bidCompleteSvc.complateBidPartnerDetail(params, user));
		
		modelAndView.setViewName("bid/partnerCompleteDetail");
		return modelAndView;
	}
	
	/**
	 * 협력사 > 입찰진행 상세
	 * @return
	 */
	@PostMapping("/api/v1/bidPtStatus/bidStatusDetail")
	public ModelAndView bidStatusDetail(
			@RequestParam(name="biNo",			defaultValue="") String biNo,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		if(user == null) {
			modelAndView.setViewName("redirect:/");
			return modelAndView;
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("biNo", biNo);
		
		// 입찰정보 setting
		modelAndView.addObject("biInfo", bidPtStatusService.bidStatusDetail(params, user));
		
		modelAndView.setViewName("bid/partnerStatusDetail");
		return modelAndView;
	}
	
	/**
	 * 입찰완료 상세
	 * @param params
	 * @return
	 * @throws Exception 
	 */
	@PostMapping("/api/v1/bidComplete/detail")
	public ModelAndView complateBidDetail(
			@RequestParam(name="biNo",			defaultValue="") String biNo,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		if(user == null) {
			modelAndView.setViewName("redirect:/");
			return modelAndView;
		}
		
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("biNo", biNo);
		
		// 입찰정보 setting
		modelAndView.addObject("biInfo", bidCompleteSvc.complateBidDetail(params));
		
		modelAndView.setViewName("bid/completeDetail");
		return modelAndView;
	}
}
