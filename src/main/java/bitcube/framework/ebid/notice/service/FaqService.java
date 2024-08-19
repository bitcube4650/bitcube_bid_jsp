package bitcube.framework.ebid.notice.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import bitcube.framework.ebid.core.CustomUserDetails;
import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.etc.util.consts.DB;

@SuppressWarnings("rawtypes")
@Service
public class FaqService {
	
	@Autowired
	GeneralDao generalDao;
	
	public ResultBody faqList(Map<String, Object> params) throws Exception {

		ResultBody resultBody = new ResultBody();
		Page listPage = generalDao.selectGernalListPage(DB.QRY_SELECT_FAQ_LIST, params);
		resultBody.setData(listPage);
		
		return resultBody;
	}
	
	//faq 저장
	@Transactional
	public void save(Map<String, Object> params) throws Exception {
		String updateInsert = params.get("updateInsert").toString();
		//String userId = user.getUsername();
		
		//params.put("userId" , userId);
		
		if(updateInsert.equals("update")) {
			// 수정
			generalDao.updateGernal(DB.QRY_UPDATE_FAQ, params);
		}else {
			// 등록
			generalDao.insertGernal(DB.QRY_INSERT_FAQ, params);
		}
	}

	//faq 삭제
	@Transactional
	public void delete(Map<String, Object> params) throws Exception {
		generalDao.deleteGernal(DB.QRY_DELETE_FAQ, params);
	}
		
}
