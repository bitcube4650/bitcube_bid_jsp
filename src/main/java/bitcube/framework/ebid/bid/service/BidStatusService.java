package bitcube.framework.ebid.bid.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.dto.ResultBody;
import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.service.MessageService;
import bitcube.framework.ebid.etc.util.CommonUtils;
import bitcube.framework.ebid.etc.util.consts.DB;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class BidStatusService {
	@Autowired
	private GeneralDao generalDao;
	
	@Autowired
	private BidProgressService bidProgressService;
	
	@Autowired
	private MessageService messageService;

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
	
	/**
	 * 낙찰
	 * @param params
	 * @return
	 */
	@Transactional
	@SuppressWarnings({ "unchecked" })
	public ResultBody bidSucc(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		UserDto userDto = (UserDto) params.get("userDto");
		String userId = userDto.getLoginId();
		String biNo = CommonUtils.getString(params.get("biNo"));
		Map<String, Object> biInfo = this.selectTBiInfoMatInfomation(biNo, "bi_mode");
		String biMode = CommonUtils.getString(biInfo.get("biMode"));
		
		params.put("userId", userId);
		
		generalDao.updateGernal(DB.QRY_UPDATE_EBID_SUCCESS_T_BI_INFO_MAT, params);
		
		
		//입찰 hist 테이블 insert
		this.bidHist(CommonUtils.getString(params.get("biNo")));

		// 낙찰 업체정보 업데이트
		generalDao.updateGernal(DB.QRY_UPDATE_EBID_SUCCESS_T_BI_INFO_MAT_CUST, params);
		
		//업체정보차수 업데이트
		generalDao.updateGernal(DB.QRY_UPDATE_EBID_SUCCESS_T_BI_INFO_MAT_CUST_TEMP, params);
		
		//로그입력
		this.insertTBiLog("[본사] 낙찰", biNo, userId);
		
		//메일, 문자 전송
		try {
			List<Object> list = null;
			ArrayList<Integer> arr = new ArrayList<Integer>();
			arr.add(CommonUtils.getInt(params.get("succCust")));
			params.put("custList", arr);
			
			if(biMode.equals("A")) {
				list = generalDao.selectGernalList(DB.QRY_SELECT_EBID_BI_MODE_A_SEND_INFO_CUST_LIST, params);
				
			}else if(biMode.equals("B")) {
				list = generalDao.selectGernalList(DB.QRY_SELECT_EBID_BI_MODE_B_SEND_INFO_CUST_LIST, params);
			}
			
			if(list.size() != 0) {
				Map<String, Object> emailParam = new HashMap<String, Object>();
				emailParam.put("type", "succ");
				emailParam.put("biName", params.get("biName"));
				emailParam.put("reason", params.get("succDetail"));
				emailParam.put("sendList", list);
				emailParam.put("biNo", biNo);
				
				bidProgressService.updateEmail(emailParam);
				
				//문자
				for(Object obj : list) {
					Map<String, Object> map = (Map<String, Object>) obj;
					messageService.send("일진그룹", CommonUtils.getString(map.get("userHp")), CommonUtils.getString(map.get("userName")), "[일진그룹 전자입찰시스템] 참여하신 입찰에("+biNo+") 낙찰되었습니다.\r\n확인바랍니다.", biNo);
				}
				
			}
			
		}catch(Exception e) {
			log.error("bidSucc sendMsg error : {}", e);
		}

		return resultBody;
	}
	
	/**
	 * 유찰처리
	 * @param params
	 * @return
	 */
	@Transactional
	public ResultBody bidFailure(Map<String, Object> params) throws Exception{
		ResultBody resultBody = new ResultBody();
		
		UserDto userDto = (UserDto) params.get("userDto");
		String userId = userDto.getLoginId();
		
		String biNo = CommonUtils.getString(params.get("biNo"));
		Map<String, Object> biInfo = this.selectTBiInfoMatInfomation(biNo, "bi_mode");
		String biMode = CommonUtils.getString(biInfo.get("biMode"));
		
		Map<String, Object> innerParams = new HashMap<String, Object>();
		innerParams.put("biNo", biNo);
		innerParams.put("ingTag", "A7");
		innerParams.put("whyA7", params.get("reason"));
		innerParams.put("userId", userId);
		generalDao.selectGernalList(DB.QRY_UPDATE_EBID_STATUS, innerParams);
		
		//입찰 hist 입력
		this.bidHist(biNo);
		
		//로그입력
		this.insertTBiLog("[본사] 유찰", biNo, userId);
		
		//메일 전송
		try {
			List<Object> list = null;
			if(biMode.equals("A")) {
				list = generalDao.selectGernalList(DB.QRY_SELECT_EBID_BI_MODE_A_SEND_INFO, params);
			}else if(biMode.equals("B")) {
				list = generalDao.selectGernalList(DB.QRY_SELECT_EBID_BI_MODE_B_SEND_INFO, params);
			}
			
			if(list.size() != 0) {
				Map<String, Object> emailParam = new HashMap<String, Object>();
				emailParam.put("type", "fail");
				emailParam.put("biName", params.get("biName"));
				emailParam.put("reason", params.get("reason"));
				emailParam.put("sendList", list);
				emailParam.put("biNo", biNo);
				
				bidProgressService.updateEmail(emailParam);
			}
		}catch(Exception e) {
			log.error("bidFailure sendMail error : {}", e);
		}
		
		return resultBody;
	}
	
	/**
	 * 개찰
	 * @param params : (String) biNo
	 * @return
	 */
	@Transactional
	@SuppressWarnings({ "unchecked" })
	public ResultBody bidOpening(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		//입찰 메인 테이블 업데이트
		UserDto userDto = (UserDto) params.get("userDto");
		String userId = userDto.getLoginId();
		String biNo = CommonUtils.getString(params.get("biNo"));
		
		params.put("userId", userId);
		
		//복호화 대상 협력사
		List<Object> custList = generalDao.selectGernalList(DB.QRY_SELECT_DECRYPT_EBID_CUST_LIST, params);
		
		for(Object obj : custList) {
			Map<String, Object> custDto = (Map<String, Object>) obj;
			//복호화
			String encQutn = null;//파일입력
			String encEsmtSpec = null;//직접입력
			String decryptData = null;//복호화 할 데이터(파일입력 방식은 encQutn, 직접입력 방식은 encEsmtSpec)
			
			if(custDto.get("encQutn") != null) {
				encQutn = CommonUtils.getString(custDto.get("encQutn"));
			};
			
			if(custDto.get("encEsmtSpec") != null) {
				encEsmtSpec = CommonUtils.getString(custDto.get("encEsmtSpec"));
			};
			
			//파일입력 방식은 encQutn, 직접입력 방식은 encEsmtSpec 복호화
			if(CommonUtils.getString(custDto.get("insMode")).equals("1")) {//파일등록 방식
				decryptData = encQutn;
			}else{//직접입력 방식
				decryptData = encEsmtSpec;
			}
			
			//만약 데이터가 없으면 continue
			if(decryptData == null || decryptData.equals("")) {
				continue;
			}
			
			//원래 암호화된 금액 복호화 후 데이터 검증된 결과가 fixedResult에 나와야 하는데 복호화 부분 제거로 new ResultBody()로 넣어줌 
			//====================================================================================================
			ResultBody fixedResult = new ResultBody();
			fixedResult.setData(decryptData);
			//====================================================================================================
			
			
			if(fixedResult.getCode().equals("ERROR")) {//복호화 한 데이터 검증 실패
				return fixedResult;
			}else {//검증 성공
				decryptData = (String) fixedResult.getData();
				decryptData = decryptData.replaceAll(",", "");// 금액에서 , 빼기
				
				if(CommonUtils.getString(custDto.get("insMode")).equals("2")) {//직접입력 방식인 경우
					//직접입력 총 견적액 구하기
					String[] esmtSpecArr = decryptData.split("\\$");//정규표현식에서 메타 문자로 사용되기 때문에 \\를 붙여줘야함
					
					//각 항목의 가격을 더해서 총 견적액 계산
					int specTotal = 0;
					for(String esmtSpec : esmtSpecArr) {
						String[] info = esmtSpec.split("=");
						Map<String, Object> innerParams = new HashMap<String, Object>();
						innerParams.put("biNo", custDto.get("biNo"));
						innerParams.put("seq", CommonUtils.getInt(info[0])+1);
						innerParams.put("custCode", CommonUtils.getInt(custDto.get("custCode")));
						innerParams.put("esmtUc", new BigDecimal(info[1]));
						innerParams.put("biOrder", custDto.get("biOrder"));
						
						//입찰 직접입력 테이블(t_bi_detail_mat_cust)에 insert
						generalDao.insertGernal(DB.QRY_INSERT_T_BI_DETAIL_MAT_CUST, params);
						
						//입찰 직접입력 이력 테이블(t_bi_detail_mat_cust_temp)에 insert
						generalDao.insertGernal(DB.QRY_INSERT_T_BI_DETAIL_MAT_CUST_TEMP, params);
						
						int itemPrice = Integer.parseInt(info[1]);
						specTotal += itemPrice;
						
					}
					
					decryptData = String.valueOf(specTotal);
				}
				
				
			}
			//데이터 검증 끝
			
			//총견적액 업데이트
			Map<String, Object> innerParams = new HashMap<String, Object>();
			innerParams.put("esmtAmt", decryptData);
			innerParams.put("userId", userId);
			innerParams.put("biNo", custDto.get("biNo"));
			innerParams.put("custCode", custDto.get("custCode"));
			
			generalDao.updateGernal(DB.QRY_UPDATE_OPEN_EBID_T_BI_INFO_MAT_CUST, innerParams);
			
			//협력사 입찰 temp 테이블 insert
			this.insertBiInfoMatCustTemp(CommonUtils.getString(custDto.get("biNo")), CommonUtils.getInt(custDto.get("custCode")));
		
		}
		//입찰 메인 업데이트
		generalDao.updateGernal(DB.QRY_UPDATE_OPEN_EBID_T_BI_INFO_MAT, params);
		
		//입찰 이력 업데이트
		this.bidHist(biNo);
		
		//로그입력
		this.insertTBiLog("[본사] 개찰", biNo, userId);
		
		return resultBody;
	}
	
	/**
	 * t_bi_info_mat 에서 필요한 컬럼 정보 가져오기
	 * @param biNo
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked" })
	public Map<String, Object> selectTBiInfoMatInfomation(String biNo, String columns) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("biNo", biNo);
		params.put("columns", columns);
		
		Map<String, Object> resultMap = (Map<String, Object>) generalDao.selectGernalObject(DB.QRY_SELECT_T_BI_INFO_MAT_INFOMATION, params);
		
		return resultMap;
	}
	
	/**
	 * 입찰 hist 입력
	 * @param biNo
	 */
	public void bidHist(String biNo) throws Exception{
		
		if(!"".equals(biNo)) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("biNo", biNo);
			
			generalDao.insertGernal(DB.QRY_INSERT_T_BI_INFO_MAT_HIST, params);
		}
	}
	
	/**
	 * t_bi_log 입력
	 * @param msg
	 * @param biNo
	 * @param userId
	 * @throws Exception
	 */
	public void insertTBiLog(String msg, String biNo, String userId) throws Exception {
		Map<String, String> logParams = new HashMap<>();
		logParams.put("msg", msg);
		logParams.put("biNo", biNo);
		logParams.put("userId", userId);
		generalDao.insertGernal(DB.QRY_BID_STATUS_INSERT_T_BI_LOG, logParams);
	}
	
	/**
	 * 입찰 협력업체 차수 등록
	 */
	public void insertBiInfoMatCustTemp(String biNo, Integer custCode) throws Exception {
		if(!StringUtils.isEmpty(biNo) && !StringUtils.isEmpty(custCode)) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("biNo", biNo);
			params.put("custCode", custCode);
			generalDao.insertGernal(DB.QRY_INSERT_T_BI_INFO_MAT_CUST_TEMP, params);
		}
	}
	
	/**
	 * 제출이력
	 * @param params
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public ResultBody submitHist(Map<String, Object> params) throws Exception {
		ResultBody resultBody = new ResultBody();
		
		Page listPage = generalDao.selectGernalListPage(DB.QRY_SELECT_T_BI_INFO_MAT_CUST_TEMP_CUST_CODE, params);
		resultBody.setData(listPage);
		
		return resultBody;
	}
}
