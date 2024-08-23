package bitcube.framework.ebid.custom.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import bitcube.framework.ebid.core.CustomUserDetails;
import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.etc.util.CommonUtils;
import bitcube.framework.ebid.etc.util.consts.DB;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class UserService {

	@Autowired
	private GeneralDao generalDao;
	
	@Autowired
	private PasswordEncoder passwordEncoder;

	public ResultBody interrelatedList() throws Exception {
		ResultBody resultBody = new ResultBody();
		Map<String, Object> params = new HashMap<String, Object>();
		List<Object> list = generalDao.selectGernalList("user.selectInterrelatedList", params);
		resultBody.setData(list);

		return resultBody;
	}

	public ResultBody userList(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();

		Page listPage = generalDao.selectGernalListPage("user.selectUserList", params);
		resultBody.setData(listPage);

		return resultBody;
	}

	/**
	 * @param params : userId
	 * @return
	 * @throws Exception
	 */
	public ResultBody userDetail(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		Map<String, Object> userDetail = (Map<String, Object>) generalDao.selectGernalObject("user.selectUserDetail", params);

		// 감사사용자의 경우 감사 계열사 조회
		String userAuthCode = (String) userDetail.get("userAuth");
		if("4".equals(userAuthCode)){
			List<Object> userInterrelated = generalDao.selectGernalList("selectInterrelatedListByUser", userDetail);
			userDetail.put("user_interrelated", userInterrelated);
		}

		resultBody.setData(userDetail);

		return resultBody;
	}

    public ResultBody idcheck(Map<String, Object> params) throws Exception {
        ResultBody resultBody = new ResultBody();
        
        int cnt = (int) generalDao.selectGernalCount(DB.QRY_SELECT_DUP_USER_CNT, params);
        if (cnt > 0) {
            resultBody.setCode("DUP"); // 아이디중복됨
        }
        return resultBody;
    }
    
	@Transactional
	public ResultBody userSave(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		// 등록/수정자
		String userId = params.get("userId").toString();

		// 저장
		if ("Y".equals(params.get("insertYn").toString())) {
			// 비밀번호 암호화
			String userPwd = params.get("userPwd").toString();
			String encodedPassword = passwordEncoder.encode(userPwd);
			params.put("encodedPassword", encodedPassword);
			params.put("createUser", userId);
			generalDao.insertGernal("insertUserSave", params);
		}
		// 수정
		else {
			params.put("updateUser", userId);
			generalDao.updateGernal("updateUserSave", params);
		}
		// 계열사 등록
		// 고유 키가 없기에 매번 지워야 한다.
		generalDao.deleteGernal("deleteUserInterrelated", params);
		// 감사사용자의 경우 감사계열사 정보를 저장 처리
		Map<String, Object> dataMap = new HashMap<>();
		if ("4".equals(params.get("userAuth"))) {
				List<String> list = (List<String>) params.get("userInterrelatedList");
				for (String userInterrelatedCode : list) {
					dataMap.put("interrelatedCustCode", userInterrelatedCode);
					dataMap.put("userId", userId);
					generalDao.insertGernal("insertUserInterrelated", dataMap);
				}
			
		}
		return resultBody;
	}
	
    // 비밀번호 변경
    @Transactional
	public ResultBody saveChgPwd(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();

		// 비밀번호 암호화
		String chgPassword = CommonUtils.getString(params.get("userPwd"), "");
		String encodedPassword = passwordEncoder.encode(chgPassword);
		params.put("userPwd", encodedPassword);

		generalDao.updateGernal("user.updateUserChgPwd",params);

		return resultBody;
	}
	
}
