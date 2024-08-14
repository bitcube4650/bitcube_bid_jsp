package bitcube.framework.ebid.bid.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.CommonUtils;
import bitcube.framework.ebid.etc.util.consts.DB;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class BidStatusService {
	@Autowired
	private GeneralDao generalDao;

	/**
	 * 입찰진행 리스트
	 * @param params
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public ResultBody statuslist(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody(); 
		
		UserDto userDto = (UserDto) params.get("userDto");
		String userAuth = CommonUtils.getString(userDto.getUserAuth());
		String userId = CommonUtils.getString(userDto.getLoginId());
		String interrelatedCode = CommonUtils.getString(userDto.getCustCode());
		String openBidYn = CommonUtils.getString(params.get("openBidYn"));
		String rebidYn = CommonUtils.getString(params.get("rebidYn"));
		String dateOverYn = CommonUtils.getString(params.get("dateOverYn"));
		
		params.put("userAuth", userAuth);
		params.put("userId", userId);
		params.put("interrelatedCustCode", interrelatedCode);
		params.put("openBidYn", openBidYn.equals("Y") ? true : false);
		params.put("rebidYn", rebidYn.equals("Y") ? true : false);
		params.put("dateOverYn", dateOverYn.equals("Y") ? true : false);
		
		Page listPage = generalDao.selectGernalListPage(DB.QRY_SELECT_EBID_STATUS_LIST, params);
		resultBody.setData(listPage);
		
		return resultBody;
	}
}
