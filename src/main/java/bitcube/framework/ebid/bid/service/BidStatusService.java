package bitcube.framework.ebid.bid.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
	
	/**
	 * 입찰진행 상세
	 * @param param
	 * @return
	 */
	@SuppressWarnings({ "unchecked" })
	public Map<String, Object> statusDetail(Map<String, Object> params, UserDto user) throws Exception {
		String userId = CommonUtils.getString(user.getLoginId());
		params.put("userId", userId);
		
		Map<String, Object> detailObj = (Map<String, Object>) generalDao.selectGernalObject(DB.QRY_SELECT_EBID_STATUS_DETAIL, params);
		
		// ************ 로그인 당사자 개찰권한, 낙찰권한 확인 ************
		
		detailObj.put("bid_Auth", CommonUtils.getString(detailObj.get("estBidderId")).equals(userId));
		detailObj.put("open_Auth", CommonUtils.getString(detailObj.get("estOpenerId")).equals(userId));
		
		// ************ 데이터 검색 -- 입찰참가업체 ************
		
		List<Object> custData = generalDao.selectGernalList(DB.QRY_SELECT_EBID_STATUS_JOIN_CUST_LIST, params);
		
		//내역방식이 직접등록일 경우
		if(CommonUtils.getString(detailObj.get("insMode")).equals("2")) {
			for(Object custObj : custData) {
				Map<String, Object> custObjMap = (Map<String, Object>) custObj;
				
				Map<String, Object> innerParams = new HashMap<String, Object>();
				innerParams.put("biNo", params.get("biNo"));
				innerParams.put("custCode", custObjMap.get("custCode"));
				List<Object> specObj = generalDao.selectGernalList(DB.QRY_SELECT_EBID_STATUS_JOIN_CUST_SPEC, innerParams);
				
				custObjMap.put("bid_Spec", specObj);
			}
		}
		
		detailObj.put("cust_List", custData);
		
		int custDataSize = custData.size();
		
		if(custDataSize >0) {
			Map<String,Object> paramMap = new HashMap<>();
			String usemailIdFilter = "";
			for (int i = 0; i < custDataSize; i++) {
				Map<String,Object> selectProgressDetaiCustListMap = (Map<String, Object>) custData.get(i);
	
				if (i < custDataSize - 1) {
					usemailIdFilter +=(selectProgressDetaiCustListMap.get("usemailId").toString()+ ",");
				} else {
					usemailIdFilter += (selectProgressDetaiCustListMap.get("usemailId").toString());
				}
			}

			paramMap.put("usemailIds", usemailIdFilter.split(","));
			List<Object> selectProgressDetaiCustUserList = generalDao.selectGernalList("bid.selectProgressDetaiCustUserList", paramMap);
			detailObj.put("cust_user_info", selectProgressDetaiCustUserList);
		}
		
		// ************ 데이터 검색 -- 세부내역 ************
		if(CommonUtils.getString(detailObj.get("insMode")).equals("1")) {		//내역방식이 파일등록일 경우
			ArrayList<String> fileFlagArr = new ArrayList<String>();
			fileFlagArr.add("K");
			
			Map<String, Object> innerParams = new HashMap<String, Object>();
			innerParams.put("biNo", params.get("biNo"));
			innerParams.put("fileFlag", fileFlagArr);
			List<Object> specfile = generalDao.selectGernalList(DB.QRY_SELECT_EBID_STATUS_DETAIL_FILE, innerParams);
			
			detailObj.put("spec_File", specfile);
			
		}else if(CommonUtils.getString(detailObj.get("insMode")).equals("2")) {		//내역방식이 직접입력일 경우
			List<Object> specInput = generalDao.selectGernalList(DB.QRY_SELECT_EBID_STATUS_DETAIL_SPEC, params);
			
			detailObj.put("spec_Input", specInput);
			
		}
		
		// ************ 데이터 검색 -- 첨부파일 ************
		ArrayList<String> fileFlagArr = new ArrayList<String>();
		fileFlagArr.add("0");
		fileFlagArr.add("1");
		
		Map<String, Object> innerParams = new HashMap<String, Object>();
		innerParams.put("biNo", params.get("biNo"));
		innerParams.put("fileFlag", fileFlagArr);
		List<Object> fileData = generalDao.selectGernalList(DB.QRY_SELECT_EBID_STATUS_DETAIL_FILE, innerParams);
		
		detailObj.put("file_List", fileData);
		
		return detailObj;
	}
}
