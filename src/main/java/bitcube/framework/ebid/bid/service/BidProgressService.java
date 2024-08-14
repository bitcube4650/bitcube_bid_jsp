package bitcube.framework.ebid.bid.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.CommonUtils;
import bitcube.framework.ebid.etc.util.consts.DB;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class BidProgressService {
	
	@Autowired
	private GeneralDao generalDao;
	
	public ResultBody progressList(@RequestBody Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		UserDto userDto = (UserDto) params.get("userDto");
		String userAuth = CommonUtils.getString(userDto.getUserAuth());
		String userId = CommonUtils.getString(userDto.getLoginId());
		String interrelatedCode = CommonUtils.getString(userDto.getCustCode());
	
		params.put("interrelatedCustCode"	, interrelatedCode);
		params.put("userId"					, userId);
		params.put("userAuth"				, userAuth);
		if (userAuth.equals("4")) {
			
			List<Object> userInfoList = generalDao.selectGernalList("bid.selectInterCustCode", params);
			List<String> custCodes = new ArrayList<>();
			for (Object userInfo : userInfoList) {
				Map<String,Object> userInfoMap = (Map<String, Object>) userInfo;
				custCodes.add(userInfoMap.get("interrelatedCustCode").toString());
			}
			
			params.put("custCodes", custCodes);
		}
		
		Page listPage = generalDao.selectGernalListPage(DB.QRY_SELECT_PROGRESS_LIST, params);
		resultBody.setData(listPage);
		
		return resultBody;
	}

}
