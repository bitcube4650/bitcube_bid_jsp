package bitcube.framework.ebid.common.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class GeneralCtl {
	
	/**
	 * 단순 페이지 이동(메뉴을 클릭했을때 페이지로 이동) : 2 Depth 이동
	 * @param bigId : jsp(대 폴더)
	 * @param smallId : jsp(페이지 명)
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "menu/{bigId}/{smallId}")
	public ModelAndView generalPageMove(
			@PathVariable String bigId,
			@PathVariable String smallId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return generalPageMove(bigId, "", smallId, request, modelAndView);
	}
	
	/**
	 * 단순 페이지 이동(메뉴을 클릭했을때 페이지로 이동) : 3 Depth 이동
	 * @param bigId : jsp(대 폴더)
	 * @param middleId : jsp(중 폴더)
	 * @param smallId : jsp(페이지 명)
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "menu/{bigId}/{middleId}/{smallId}")
	public ModelAndView generalPageMove(
			@PathVariable String bigId,
			@PathVariable String middleId,
			@PathVariable String smallId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView(bigId+"/"+middleId+"/"+smallId);
	}
}
