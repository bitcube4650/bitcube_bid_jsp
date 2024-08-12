package bitcube.framework.ebid.etc.notice.controller;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;

import bitcube.framework.ebid.core.CustomUserDetails;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.notice.service.NoticeService;
import bitcube.framework.ebid.etc.util.Constances;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/v1/notice")
@CrossOrigin
@Slf4j
public class NoticeController {

	@Autowired
	private NoticeService noticeService;

	/**
	 * 공지사항 목록 조회 및 상세 조회
	 * @param params
	 * @param user
	 * @return
	 */
	@PostMapping("/noticeList")
	public ResultBody noticeList(HttpServletRequest request, @RequestParam Map<String, Object> params) {

		HttpSession		session		= request.getSession();
		UserDto user = (UserDto) session.getAttribute(Constances.SESSION_NAME);
		params.put("custCode", user.getCustCode());	// 계열사 사용자 - 소속 계열사/ 협력사 사용자 - 본인 협력사
		params.put("custType", user.getCustType());	// 사용자 업체 타입
		params.put("userAuth", user.getUserAuth()); // 계열사사용자 권한
		params.put("userId", user.getUserName()); // 계열사사용자 권한
		
		return noticeService.noticeList(params);
	}

	/**
	 * 공지사항 조회수 증가
	 * @param params
	 * @return
	 */
	@PostMapping("/updateClickNum")
	public ResultBody updateClickNum(@RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();

		try {
			noticeService.updateClickNum(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("An error occurred while updating the click count.");
			log.error(e.getMessage());
		}
		return resultBody;
	}

	/**
	 * 공지사항 삭제
	 * @param params
	 * @return
	 */
	@PostMapping("/deleteNotice")
	public ResultBody deleteNotice(@RequestParam Map<String, Object> params) {
		ResultBody resultBody = new ResultBody();
		try {
			// 공지사항 삭제
			noticeService.deleteNotice(params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("삭제 중 오류가 발생하였습니다.");
			log.error(e.getMessage());
		}
		return resultBody;
	}

	/**
	 * 공지사항 수정
	 * @param file
	 * @param jsonData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@PostMapping("/updateNotice")
	public ResultBody updateNotice(@RequestPart(value = "file", required = false) MultipartFile file, @RequestPart("data") String jsonData) {
		ResultBody resultBody = new ResultBody();
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> params = null;
		try {
			params = mapper.readValue(jsonData, Map.class);
			
			// 공지사항 수정
			noticeService.updateNotice(file, params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("공지사항 수정 시 오류가 발생하였습니다.");
			log.error(e.getMessage());
		}
		return resultBody;
	}

	/**
	 * 공지사항 등록
	 * @param file
	 * @param jsonData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@PostMapping("/insertNotice")
	public ResultBody insertNotice(@RequestPart(value = "file", required = false) MultipartFile file, @RequestPart("data") String jsonData) {
		ResultBody resultBody = new ResultBody();
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> params = null;
		try {
			params = mapper.readValue(jsonData, Map.class);
			
			// 공지사항 등록
			noticeService.insertNotice(file, params);
		} catch (Exception e) {
			resultBody.setCode("ERROR");
			resultBody.setStatus(500);
			resultBody.setMsg("공지사항 등록 시 오류가 발생하였습니다.");
			log.error(e.getMessage());
		}
		return resultBody;
	}

	/**
	 * 첨부파일 다운로드
	 * @param params
	 * @return
	 * @throws IOException
	 */
	@PostMapping("/downloadFile")
	public ByteArrayResource downloadFile(@RequestParam Map<String, Object> params) throws IOException {
		return noticeService.downloadFile(params);
	}

}
