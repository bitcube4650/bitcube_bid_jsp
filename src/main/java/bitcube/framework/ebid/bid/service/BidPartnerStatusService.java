package bitcube.framework.ebid.bid.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.consts.DB;

@Service
public class BidPartnerStatusService {
	@Autowired
	private GeneralDao generalDao;

	/**
	 * 입찰진행 리스트
	 * @param params
	 * @param user 
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public ResultBody statuslist(Map<String, Object> params, UserDto user) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		params.put("custCode", user.getCustCode());
		Page listPage = generalDao.selectGernalListPage(DB.QRY_SELECT_PARTNER_EBID_STATUS_LIST, params);
		resultBody.setData(listPage);
		
		return resultBody;
	}
	
//	/**
//	 * 입찰진행 상세
//	 * @param param
//	 * @return
//	 */
//	@SuppressWarnings({ "unchecked" })
//	public ResultBody bidStatusDetail(Map<String, Object> params,UserDto user) throws Exception {
//		ResultBody resultBody = new ResultBody();
//		
//		params.put("custCode", user.getCustCode());
//		
//		Map<String, Object> detailMap = (Map<String, Object>) generalDao.selectGernalObject(DB.QRY_SELECT_PARTNER_EBID_STATUS_DETAIL, params);
//		
//		// ************ 데이터 검색 -- 세부내역 ************
//		if(CommonUtils.getString(detailMap.get("insMode")).equals("1")) {		//내역방식이 파일등록일 경우
//			
//			ArrayList<String> fileFlagArr = new ArrayList<String>();
//			fileFlagArr.add("K");
//			
//			Map<String, Object> innerParams = new HashMap<String, Object>();
//			innerParams.put("biNo", params.get("biNo"));
//			innerParams.put("fileFlag", fileFlagArr);
//			List<Object> specfile = generalDao.selectGernalList(DB.QRY_SELECT_EBID_STATUS_DETAIL_FILE, innerParams);
//			
//			detailMap.put("spec_File", specfile);
//			
//		}else if(CommonUtils.getString(detailMap.get("insMode")).equals("2")) {		//내역방식이 직접입력일 경우
//			List<Object> specInput = generalDao.selectGernalList(DB.QRY_SELECT_EBID_STATUS_DETAIL_SPEC, params);
//			
//			detailMap.put("spec_Input", specInput);
//		}
//		
//		// ************ 데이터 검색 -- 첨부파일 ************
//		ArrayList<String> fileFlagArr = new ArrayList<String>();
//		fileFlagArr.add("1");
//		
//		Map<String, Object> innerParams = new HashMap<String, Object>();
//		innerParams.put("biNo", params.get("biNo"));
//		innerParams.put("fileFlag", fileFlagArr);
//		List<Object> fileList = generalDao.selectGernalList(DB.QRY_SELECT_EBID_STATUS_DETAIL_FILE, innerParams);
//		
//		detailMap.put("file_list", fileList);
//		
//		resultBody.setData(detailMap);
//			
//		return resultBody;
//	}
}
