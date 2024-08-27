package bitcube.framework.ebid.common.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.CommonUtils;
import bitcube.framework.ebid.etc.util.Constances;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@RestController
@CrossOrigin
@Slf4j
public class GeneralController {
	
	/**
	 * 페이지 이동 generalController
	 * @param request
	 * @param modelAndView
	 * @param params 
	 * 			(필수) viewName : 이동 jsp 경로
	 * 			(선택) 그 외 파라미터 키 : 같이 보낼 값
	 * @param redirectAttr
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/api/v1/move")
	public ModelAndView movePage(HttpServletRequest request, ModelAndView modelAndView, @RequestParam Map<String, Object> params
			, RedirectAttributes redirectAttr) throws Exception {
		
		String viewName = CommonUtils.getString(params.get("viewName"));
		params.remove("viewName");
		
		HttpSession		session		= request.getSession();
		UserDto user = (UserDto) session.getAttribute(Constances.SESSION_NAME);
		if(viewName.indexOf("join") < 0 && user == null) {
			modelAndView.setViewName("redirect:/");
			return modelAndView;
		}
		
		redirectAttr.addFlashAttribute("params", params);
		modelAndView.setViewName("redirect:/" + viewName);
		return modelAndView;
	}
	
	/**
	 * 1단계 경로
	 * @param step1
	 * @param request
	 * @param modelAndView
	 * @param redirectAttr
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({"unchecked"})
	@RequestMapping(value = "/{step1:^(?:(?!api$|resources$|CC_WSTD_home$|favicon.ico$).)*}")
	public ModelAndView generalPageMove(
			@PathVariable(value="step1") String step1,
			HttpServletRequest request, ModelAndView modelAndView,
			RedirectAttributes redirectAttr) throws Exception {
		
		HttpSession		session		= request.getSession();
		UserDto user = (UserDto) session.getAttribute(Constances.SESSION_NAME);
		if(!step1.equals("join") && user == null) {
			modelAndView.setViewName("redirect:/");
			return modelAndView;
		}
		
		log.info("step1 : " + step1);
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		
		Map<String, Object> params = inputFlashMap != null ? (Map<String, Object>) inputFlashMap.get("params") : null;
		redirectAttr.addFlashAttribute("params", params);
		modelAndView.setViewName(step1);
		return modelAndView;
	}
	
	/**
	 * 2단계 견로
	 * @param step1
	 * @param step2
	 * @param request
	 * @param modelAndView
	 * @param redirectAttr
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({"unchecked"})
	@RequestMapping(value = "/{step1:^(?:(?!api$|resources$|CC_WSTD_home$|install$|favicon.ico$).)*}/{step2}")
	public ModelAndView generalPageMove(
			@PathVariable(value="step1") String step1,
			@PathVariable(value="step2") String step2,
			HttpServletRequest request, ModelAndView modelAndView,
			RedirectAttributes redirectAttr) throws Exception {
		
		HttpSession		session		= request.getSession();
		UserDto user = (UserDto) session.getAttribute(Constances.SESSION_NAME);
		if(!step1.equals("join") && user == null) {
			modelAndView.setViewName("redirect:/");
			return modelAndView;
		}
		
		log.info("step2 : " + step1+"/"+step2);
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		
		Map<String, Object> params = inputFlashMap != null ? (Map<String, Object>) inputFlashMap.get("params") : null;
		redirectAttr.addFlashAttribute("params", params);
		modelAndView.setViewName(step1+"/"+step2);
		return modelAndView;
	}
	
	/**
	 * 3단계 경로
	 * @param step1
	 * @param step2
	 * @param step3
	 * @param request
	 * @param modelAndView
	 * @param redirectAttr
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({"unchecked"})
	@RequestMapping(value = "/{step1:^(?:(?!api$|resources$|CC_WSTD_home$|favicon.ico$).)*}/{step2}/{step3}")
	public ModelAndView generalPageMove(
			@PathVariable(value="step1") String step1,
			@PathVariable(value="step2") String step2,
			@PathVariable(value="step3") String step3,
			HttpServletRequest request, ModelAndView modelAndView,
			RedirectAttributes redirectAttr) throws Exception {
		
		HttpSession		session		= request.getSession();
		UserDto user = (UserDto) session.getAttribute(Constances.SESSION_NAME);
		if(!step1.equals("join") && user == null) {
			modelAndView.setViewName("redirect:/");
			return modelAndView;
		}
		
		log.info("step3 : " + step1+"/"+step2+"/"+step3);
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		
		Map<String, Object> params = inputFlashMap != null ? (Map<String, Object>) inputFlashMap.get("params") : null;
		redirectAttr.addFlashAttribute("params", params);
		modelAndView.setViewName(step1+"/"+step2+"/"+step3);
		return modelAndView;
	}
}