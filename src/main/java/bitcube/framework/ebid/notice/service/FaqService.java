package bitcube.framework.ebid.notice.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

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
		
}
