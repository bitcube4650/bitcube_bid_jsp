package bitcube.framework.ebid.notice.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import bitcube.framework.ebid.core.CustomUserDetails;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.notice.service.FaqService;
import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/api/v1/faq")
public class FaqController {
	
	@Autowired
	FaqService faqService;
	
	@PostMapping(value="/faqList", produces = "application/json")
	@ResponseBody
	public ResultBody faqList(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) throws Exception {
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
	
	/**
	 * FAQ 등록 및 수정
	 * @param params
	 * @param user
	 * @return
	 */
	@PostMapping("/save")
	@ResponseBody
	public ResultBody save(HttpServletRequest request, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		
		try {
			faqService.save(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("FAQ 저장시 오류가 발생하였습니다.");
		}
		
		return resultBody;
	}

	/**
	 * FAQ 삭제
	 * @param params
	 * @return
	 */
	@PostMapping("/delete")
	@ResponseBody
	public ResultBody delete(HttpServletRequest request, @RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();

		try {
			faqService.delete(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("FAQ 등록 및 수정시 오류가 발생하였습니다.");
		}
		
		return resultBody;
	}

}
