package bitcube.framework.ebid.test;

import java.util.Map;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import bitcube.framework.ebid.dto.ResultBody;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/v1")
@CrossOrigin
@Slf4j
public class TestController {
	
	@PostMapping(value="/test2", produces = "application/json")
	@ResponseBody
	public ResultBody test2(@RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		log.info("test2");
		log.info("params : {}", params);
		System.out.println("api/v1/test2");
		System.out.println(params);
		resultBody.setCode("success");
		resultBody.setMsg("리턴 메시지");	
		return resultBody;
	}
	
}
