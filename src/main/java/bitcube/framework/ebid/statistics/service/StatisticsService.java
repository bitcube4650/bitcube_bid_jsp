package bitcube.framework.ebid.statistics.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.CommonUtils;

@Service
public class StatisticsService {

	@Autowired GeneralDao generalDao;
	
	public ResultBody selectCoInterList(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		List<Object> list = generalDao.selectGernalList("statistics.selectCoInterList", params);
		resultBody.setData(list);
		
		return resultBody;
	}

	public ResultBody selectBiInfoList(Map<String, Object> params, UserDto user) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		// coInters setting
		this.setCoInterList(params, user);
		
		List<Object> list = generalDao.selectGernalList("statistics.selectBiInfoList", params);
		resultBody.setData(list);
		
		return resultBody;
	}

	@SuppressWarnings("unchecked")
	public void setCoInterList(Map<String, Object> params, UserDto user) throws Exception {

		params.put("userAuth",	user.getUserAuth());		// 사용자 권한 정보
		params.put("userId",	user.getLoginId());

		String srcCoInter = CommonUtils.getString(params.get("srcCoInter"));						// 조회조건 계열사
		
		// 감사사용자 : 본인이 속한 계열사 리스트 조회 / 시스템사용자 전체 계열사 조회
		List<Object> coInterList = generalDao.selectGernalList("statistics.selectCoInterList", params);
		List<String> coInters = new ArrayList<>();
		
		// 조회조건 '계열사'의 값이 있는 경우 해당 계열사만 조회
		if("".equals(srcCoInter)) {
			for(Object obj : coInterList) {
				Map<String, Object> coInterMap = (Map<String, Object>) obj;
				coInters.add(CommonUtils.getString(coInterMap.get("interrelatedCustCode")));
			}
		} else {
			coInters.add(srcCoInter);
		}
		
		params.put("coInters", coInters);
	}

	public ResultBody biInfoDetailList(Map<String, Object> params, UserDto user) throws Exception {
		ResultBody resultBody = new ResultBody();

		// coInters setting
		this.setCoInterList(params, user);
		
		Page listPage = generalDao.selectGernalListPage("statistics.biInfoDetailList", params);
		resultBody.setData(listPage);
		
		return resultBody;
	}

	public ResultBody bidPresentList(Map<String, Object> params, UserDto user) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		// 조회조건 중에서 계열사를 선택한 경우 해당 계열사만 보여줌
		String srcCoInter = CommonUtils.getString(params.get("srcCoInter"));
		if(!srcCoInter.equals("")) {
			List<String> coInters = new ArrayList<String>();		// 계열사 array
			coInters.add(srcCoInter);
			params.put("coInters",		coInters);
		} else {
			// 시스템 관리자가 아닌 경우 본인이 소속된 계열사 정보만 보여준다.
			if(!user.getUserAuth().equals(("1"))){
				this.setCoInterList(params, user);
			}
		}
		
		List<Object> list = generalDao.selectGernalList("statistics.bidPresentList", params);
		resultBody.setData(list);
		
		return resultBody;
	}
}
