package bitcube.framework.ebid.statistics.controller;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.Constances;
import bitcube.framework.ebid.statistics.service.StatisticsService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@RestController
@CrossOrigin
@Slf4j
@RequestMapping("/api/v1/statistics")
public class StatisticsContoller {
	
	@Autowired StatisticsService statisticsService;

	@Autowired GeneralDao generalDao;
	/**
	 * 계열사 리스트 조회
	 * @param userAuth
	 * @param request
	 * @return
	 */
	@PostMapping("/coInterList")
	public ResultBody selectCoInterList(
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();
		
		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userAuth",	user.getUserAuth());		// 사용자 권한 정보
		params.put("userId",	user.getLoginId());
		try {
			resultBody = statisticsService.selectCoInterList(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("계열사 리스트 조회 중 오류가 발생하였습니다.");
			log.error("{} Error : {}", this.getClass(), e.getMessage());
		}
		
		return resultBody;
	}
	
	/**
	 * 통계 > 회사별 입찰실적 조회
	 * @param startDay
	 * @param endDay
	 * @param srcCoInter
	 * @param request
	 * @return
	 */
	@PostMapping("/biInfoList")
	public ResultBody selectBiInfoList(
			@RequestParam(name="startDay",		defaultValue="") String startDay,
			@RequestParam(name="endDay",		defaultValue="") String endDay,
			@RequestParam(name="srcCoInter",	defaultValue="") String srcCoInter,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("startDay",		startDay);
		params.put("endDay",		endDay);
		params.put("srcCoInter",	srcCoInter);
		try {
			resultBody = statisticsService.selectBiInfoList(params, user);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("회사별 입찰실적 리스트 조회 중 오류가 발생하였습니다.");
			log.error("{} Error : {}", this.getClass(), e.getMessage());
		}
		return resultBody;
	}
	
	/**
	 * 통계 > 입찰실적 상세내역 조회
	 * @param page
	 * @param size
	 * @param startDay
	 * @param endDay
	 * 
	 * @param srcCoInter
	 * @param srcCustType
	 * @param request
	 * @return
	 */
	@PostMapping("/biInfoDetailList")
	public ResultBody biInfoDetailList(
			@RequestParam(name="page",			defaultValue="0") int page,
			@RequestParam(name="size",			defaultValue="10") int size,
			@RequestParam(name="startDay",		defaultValue="") String startDay,
			@RequestParam(name="endDay",		defaultValue="") String endDay,
			@RequestParam(name="srcCoInter",	defaultValue="") String srcCoInter,
			@RequestParam(name="srcCustType",	defaultValue="") String srcCustType,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();
		
		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("page",			page);
		params.put("size",			size);
		params.put("startDay",		startDay);
		params.put("endDay",		endDay);
		params.put("srcCoInter",	srcCoInter);
		params.put("srcCustType",	srcCustType);
		try {
			resultBody = statisticsService.biInfoDetailList(params, user);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("입찰실적 상세내역 리스트 조회 중 오류가 발생하였습니다.");
			log.error("{} Error : {}", this.getClass(), e.getMessage());
		}
		return resultBody;
	}
	
	/**
	 * 통계 > 입찰현황 조회
	 * @param page
	 * @param size
	 * @param startDay
	 * @param endDay
	 * @param srcCoInter
	 * @param srcCustType
	 * @param request
	 * @return
	 */
	@PostMapping("/bidPresentList")
	public ResultBody bidPresentList(
			@RequestParam(name="startDay",		defaultValue="") String startDay,
			@RequestParam(name="endDay",		defaultValue="") String endDay,
			@RequestParam(name="srcCoInter",	defaultValue="") String srcCoInter,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("startDay",		startDay);
		params.put("endDay",		endDay);
		params.put("srcCoInter",	srcCoInter);
		
		try {
			resultBody = statisticsService.bidPresentList(params, user);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("입찰현황 리스트 조회 중 오류가 발생하였습니다.");
			log.error("{} Error : {}", this.getClass(), e.getMessage());
		}
		return resultBody;
	}
	
	/**
	 * 통계 > 입찰 상세내역 조회
	 * @param page
	 * @param size
	 * @param startDay
	 * @param endDay
	 * @param srcCoInter
	 * @param request
	 * @return
	 */
	@PostMapping("/bidDetailList")
	public ResultBody bidDetailList(
			@RequestParam(name="page",			defaultValue="0") int page,
			@RequestParam(name="size",			defaultValue="10") int size,
			@RequestParam(name="startDay",		defaultValue="") String startDay,
			@RequestParam(name="endDay",		defaultValue="") String endDay,
			@RequestParam(name="srcCoInter",	defaultValue="") String srcCoInter,
			HttpServletRequest request) {
		ResultBody resultBody = new ResultBody();

		// 로그인 세션정보
		HttpSession session	= request.getSession();
		UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId",		user.getLoginId());
		params.put("page",			page);
		params.put("size",			size);
		params.put("startDay",		startDay);
		params.put("endDay",		endDay);
		params.put("srcCoInter",	srcCoInter);
		
		try {
			Page listPage = generalDao.selectGernalListPage("statistics.bidDetailList", params);
			
			resultBody.setData(listPage);
		}catch(Exception e) {
			log.error("bidDetailList list error : {}", e);
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("입찰상세내역 리스트를 가져오는것을 실패하였습니다.");	
		}
		
		return resultBody;
	}
}