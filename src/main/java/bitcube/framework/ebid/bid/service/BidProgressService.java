package bitcube.framework.ebid.bid.service;

import java.util.ArrayList;
import java.util.HashMap;
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
	
	public ResultBody progressCodeList() throws Exception {
		ResultBody resultBody = new ResultBody();

		List<Object> list = generalDao.selectGernalList("bid.selectProgressCodeList", null);
		
		resultBody.setData(list);
		
		return resultBody;
	}
	
	/**
	 * 메일전송
	 * @param params : (String) type, (String) biName, (String) reason, (String) interNm, (List<SendDto>) sendList
	 * @throws Exception 
	 */
	public void updateEmail(Map<String, Object> params) throws Exception {
		List<Map<String,Object>> sendList = (List<Map<String, Object>>) params.get("sendList");		//수신인/발송인 메일 리스트

		//메일 내용 셋팅
		Map<String, String> emailContent = this.emailContent(params);
		params.put("title", emailContent.get("title"));
		params.put("content", emailContent.get("content"));
		if (sendList != null) {
			for (Map<String,Object> recvInfo : sendList) {
				params.put("userEmail", recvInfo.get("userEmail"));
				params.put("fromMail", recvInfo.get("fromEmail"));
				generalDao.insertGernal("bid.insertTEmail", params);
			}
		}
	}
	
	//메일 제목 및 내용 셋팅
		public Map<String, String> emailContent(Map<String, Object> params){
			Map<String, String> result = new HashMap<String, String>();
			
			String type = CommonUtils.getString(params.get("type"));			// del : 입찰삭제 , notice : 입찰공고, insert: 입찰등록, fail: 유찰, rebid:재입찰,succ:낙찰
			String biName = CommonUtils.getString(params.get("biName"));		//입찰명
			String reason = CommonUtils.getString(params.get("reason"));		//사유
			String interNm = CommonUtils.getString(params.get("interNm"));		//계열사명
			
			String title = "";
			String content = "";
			
			//입찰 계획 삭제
			if(type.equals("del")) {
				title = "[일진그룹 e-bidding] 입찰 계획 삭제(" + biName + ")";
				content = "입찰명 [" + biName + "] 입찰계획을\n삭제하였습니다.\n아래 삭제사유를 확인해 주십시오.\n\n"+
							"-삭제사유\n" + reason;
				
			//입찰 공고
			}else if(type.equals("notice")) {
				title = "[일진그룹 e-bidding] 입찰 공고(" + biName + ")";
				content = "[" + interNm + "]에서 입찰공고 하였습니다.\n입찰명은 [" + biName + "] 입니다.\n\n";

				
			//입찰 계획 등록
			}else if(type.equals("insert")) {
				title = "[일진그룹 e-bidding] 계획 등록(" + biName + ")";
				content = "[" + interNm + "]에서 입찰계획을 등록하였습니다.\n입찰명은 [" + biName + "] 입니다.\n\n";

			//입찰 계획 수정
			}else if(type.equals("update")) {
				title = "[일진그룹 e-bidding] 계획 수정(" + biName + ")";
				content = "[" + interNm + "]에서 입찰계획을 수정하였습니다.\n입찰명은 [" + biName + "] 입니다.\n\n";
		
			//입찰 유찰처리
			}else if(type.equals("fail")) {
				title = "[일진그룹 e-bidding] 유찰 처리(" + biName + ")";
				content = "입찰명 [" + biName + "]를 유찰처리 하였습니다.\n" +
						"아래 유찰사유를 확인해 주십시오.\n\n"+
						"-유찰사유\n" + reason;
				
			//재입찰
			}else if(type.equals("rebid")) {
				title = "[일진그룹 e-bidding] 재입찰(" + biName + ")";
				content = "입찰명 [" + biName + "]이 재입찰되었습니다.\n" +
						"아래 재입찰사유를 확인해 주시고 e-bidding 시스템에 로그인하여 다시 한번 투찰해 주십시오\n\n"+
						"-재입찰사유\n" + reason;
				
			//낙찰
			}else if(type.equals("succ")) {
				title = "[일진그룹 e-bidding] 낙찰(" + biName + ")";
				content = "입찰명 [" + biName + "]에 업체선정 되었습니다.\n" +
						"자세한 사항은 e-bidding 시스템에  로그인하여 입찰내용 확인 및 낙찰확인을 하시기 바랍니다.\n(낙찰확인은 계약과 관련없는 내부절차 입니다.)\n\n"+
						"-추가합의사항\n" + reason;
			
			//입찰독촉메일
			}else if(type.equals("push")) {
				title = "[일진그룹 e-bidding] 입찰 마감임박";
				content = "["+interNm+"]에서 공고한 [" + biName + "] 입찰 마감시간이 다가오고 있습니다.\r\n"
						+ "마감시간 전 전자입찰 e-bidding 시스템에 접속하여 투찰을 진행해 주십시오\r\n"
						+ "투찰기간 : "+ CommonUtils.getString(params.get("estStartDate")) + " ~ " + CommonUtils.getString(params.get("estCloseDate"));
			}
			
			result.put("title", title);
			result.put("content", content);
			return result;
		}

}
