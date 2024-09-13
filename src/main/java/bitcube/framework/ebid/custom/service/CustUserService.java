package bitcube.framework.ebid.custom.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.etc.util.consts.DB;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class CustUserService {
	
	@Autowired
	private GeneralDao generalDao;

	@SuppressWarnings({ "unused", "rawtypes" })
	public ResultBody userList(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();

		Page listPage = generalDao.selectGernalListPage(DB.QRY_SELECT_CUST_USER_LIST, params);
		resultBody.setData(listPage);

		return resultBody;
	}
}
