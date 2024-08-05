package bitcubeBid.system.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/api/system")
public class SystemController {
	
	@RequestMapping("/faqViews")
	public ModelAndView viewFaq() {
		
		System.out.println("--------------------------------------??????????????????????????????????????");
		
		ModelAndView mav = new ModelAndView();
		
		
		mav.setViewName("/system/faq");
		
		return mav;
		
	}
}
