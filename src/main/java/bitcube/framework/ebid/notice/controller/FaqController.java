package bitcube.framework.ebid.notice.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.notice.service.FaqService;

@Controller
@RequestMapping("/api/v1/faq")
public class FaqController {
	
	@Autowired
	FaqService faqService;
	
	@PostMapping(value="/faqList", produces = "application/json")
	@ResponseBody
	public ResultBody faqList(@RequestParam Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		try {
			resultBody = faqService.faqList(params);
		} catch (Exception e) {
			e.printStackTrace();
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("An error occurred while selecting faqList.");
			resultBody.setData(e.getMessage());
		}	
		return resultBody;
	}

}
