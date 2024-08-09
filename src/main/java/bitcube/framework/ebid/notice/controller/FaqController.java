package bitcube.framework.ebid.notice.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/api/faq")
public class FaqController {
	
	@RequestMapping("/faqViews")
	public ModelAndView viewFaq() {
		
		ModelAndView mav = new ModelAndView();
		
		
		mav.setViewName("/system/faq");
		
		return mav;
		
	}
}
