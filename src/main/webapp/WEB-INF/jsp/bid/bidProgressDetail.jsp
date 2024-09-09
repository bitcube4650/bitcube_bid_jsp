<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.math.RoundingMode"%>
<%@ page import="bitcube.framework.ebid.etc.util.Constances" %>
<%@ page import="bitcube.framework.ebid.dto.UserDto" %>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%
	UserDto							userDto = (UserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String							userId = userDto.getLoginId();
	String							custName = userDto.getCustName();
	Map<String, Object>				data = (Map<String, Object>) request.getAttribute("biInfo");
	ArrayList<Map<String, Object>>	custList = new ArrayList<Map<String, Object>>();
									custList = (ArrayList) data.get("custList");
	ArrayList<Map<String, Object>>	custUserInfo = new ArrayList<Map<String, Object>>();
									custUserInfo = (ArrayList) data.get("custUserInfo");
	ObjectMapper					objectMapper = new ObjectMapper();
	String							jsonCustList = objectMapper.writeValueAsString(custList);
	String							jsonCustUserInfo = objectMapper.writeValueAsString(custUserInfo);
	String							jsonData = objectMapper.writeValueAsString(data);
%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		$(document).ready(function() {
			fnInit();
		});
		
		function fnInit() {
			var data		= <%= jsonData %>;
			var createUser	= data.createUser;
			var gongoId		= data.gongoId;
			var loginInfo	= JSON.parse(localStorage.getItem("loginInfo"))
			var loginId		= loginInfo.userId;
			
			if(createUser === loginId) {
				var str = "";
				str += '<button class="btnStyle btnSecondary" title="삭제" onclick="onBidProgressDelModal()">삭제</button>';
				str += '<button class="btnStyle btnSecondary" title="수정" onclick="onMoveSave()">수정</button>';
				$("#buttonList").append(str);
			}
			
			if(createUser === loginId || gongoId === loginId) {
				var str = "";
				str += '<button class="btnStyle btnPrimary" title="입찰공고" onclick="onBidNoticeConfirm()">입찰공고</button>';
				$("#buttonList").append(str);
			}
		}
		
		// 목록 이동
		function onMovePage() {
			location.href="/api/v1/move?viewName=bid/progress";
		}
		
		// 입찰 참가업체 팝업
		function onOpenCustUserPop(index) {
			var custList	= <%= jsonCustList %>;
			var cust		= custList[index];
			
			$("#custUserPopCustCode").val(cust.custCode);
			$("#custUserPopCustName").val(cust.custName);
			$("#custUserPop").modal('show');
			onSearch();
		}
		
		// 공고문 미리 보기
		function onBidBiddingPreviewModal() {
			$("#bidBiddingPreviewPop").modal("show");
		}
		
		// 삭제
		function onBidProgressDelModal() {
			$("#bidProgressDel").modal("show");
		}
		
		// 수정 페이지 이동
		function onMoveSave() {
			
		}
		
		// 입찰 공고 confirm
		function onBidNoticeConfirm() {
			Swal.fire({
				title: '입찰 공고',
				text: '입찰공고를 하면 입찰 참가업체에게 입찰공고 메일이 발송되고 수정이 불가하게 됩니다.\n 입찰공고 하시겠습니까?',
				icon: 'question',				// success / error / warning / info / question
				confirmButtonColor: '#3085d6',	// 기본옵션
				confirmButtonText: '입찰 공고',	// 기본옵션
				showCancelButton: true,			// conrifm 으로 하고싶을떄
				cancelButtonColor: '#d33',		// conrifm 에 나오는 닫기버튼 옵션
				cancelButtonText: '취소'		// conrifm 에 나오는 닫기버튼 옵션
			}).then(result => {
				if (result.isConfirmed) { 
					onBidNotice();
				}
			})
		}
		
		// 입찰 공고
		function onBidNotice() {
			var data = <%= jsonData %>;
			var custList = <%= jsonCustList %>;
			var custUserInfo = <%= jsonCustUserInfo %>;
			var custName = "<%= custName %>";
			
			var params = {
				biNo : data.biNo,
				biName : data.biName,
				interNm : custName,
				biModeCode : data.biMode,
				cuserCode : data.createUser,
				custCode : {},
				custUserIds : {},
			}
			
			var custCodeArr = [];
			var custUserIds = [];
			
			if(data.biMode === 'A'){
				for(var i=0; i<custUserInfo.length; i++) {
					custCodeArr.push(custUserInfo[i].custCode);
				}
				for(var i=0; i<custUserInfo.length; i++) {
					custUserIds.push(custUserInfo[i].userId);
				}
				params.custCode = JSON.stringify(custCodeArr);
				params.custUserIds = JSON.stringify(custUserIds);
			}
			
			$.post(
				'/api/v1/bid/bidNotice',
				params
			).done(function(arg) {
				if (arg.code === "OK") {
					Swal.fire('입찰 공고가 완료되었습니다.', '', 'success');
					onMovePage();
				}
				else{
					Swal.fire('입찰 공고를 실패하였습니다.', '', 'error');
					return;
				}
			})
		}
		
		// 첨부파일 다운로드
		function fnfileDownload(filePath, fileName){
			$.post(
				'/api/v1/notice/downloadFile',
				{
					fileId : filePath,
					responseType: "blob"
				}
			).done(function(arg) {
				if (arg.code === "OK") {
					const url = window.URL.createObjectURL(new Blob([arg.data]));
					const link = document.createElement("a");
					link.href = url;
					link.setAttribute("download", fileName);
					document.body.appendChild(link);
					link.click();
					document.body.removeChild(link);
				}
				else{
					Swal.fire('', '파일 다운로드를 실패하였습니다.', 'warning');
					return
				}
			})
		}
		
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			<div class="conRight">
				<div class="conHeader">
					<ul class="conHeaderCate">
						<li>전자입찰</li>
						<li>입찰계획 상세</li>
					</ul>
				</div>
				
				<div class="contents">
					<div class="formWidth">
						<h3 class="h3Tit">입찰기본정보</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">입찰번호</div>
								<div class="width100"><%= CommonUtils.getString(data.get("biNo")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰명</div>
								<div class="width100"><%= CommonUtils.getString(data.get("biName")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">품목</div>
								<div class="width100"><%= CommonUtils.getString(data.get("itemName")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰방식</div>
								<div class="width100"><%= "A".equals(CommonUtils.getString(data.get("biMode"))) ? "지명경쟁입찰" : "일반경쟁입찰" %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰참가자격</div>
								<div class="width100"><%= CommonUtils.getString(data.get("bidJoinSpec")) %></div>
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">특수조건</div>
								<div class="width100">
									<div class="boxStSm width100 boxOverflowY" style="height:100px"><pre style="backgroundColor: white"><%= CommonUtils.getString(data.get("specialCond")) %></pre></div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">현장설명일시</div>
								<div class="width100"><%= CommonUtils.getString(data.get("spotDate")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">현장설명장소</div>
								<div class="width100"><%= CommonUtils.getString(data.get("spotArea")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">낙찰자결정방법</div>
								<div class="width100"><%= CommonUtils.getString(data.get("succDeciMeth")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰참가업체</div>
									<% if(CommonUtils.getString(data.get("biMode")).equals("A")) { %>
									<div class="width100">
										<div class="overflow-y-scroll boxStSm width100" style="height:50px">
											<% 
												for(int i=0; i<custList.size(); i++) {
													Map<String, Object> custMap = custList.get(i);
											%>
											<a class="textUnderline" onClick="onOpenCustUserPop(<%= i %>)"><%= CommonUtils.getString(custMap.get("custName")) %>
												<% if((i+1) != custList.size()) { %>
												<span>, </span>
												<% } %>
											</a>
											<% } %>
										</div>
									</div>
									<% } %>
									<% if(CommonUtils.getString(data.get("biMode")).equals("B")) { %>
									<div class="flex align-items-center width100">
										<div class="boxStSm width100 boxOverflowY">
											<a>가입회원사 전체</a>
										</div>
									</div>
									<% } %>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">금액기준</div>
								<div class="width100"><%= CommonUtils.getString(data.get("amtBasis")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">결제조건</div>
								<div class="width100"><%= CommonUtils.getString(data.get("payCond")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">예산금액</div>
								<div class="width100"><%= CommonUtils.numberWithCommas(new BigDecimal(CommonUtils.getInt(data.get("bdAmt")))) %>
								<% if(!CommonUtils.getString(data.get("bdAmt")).equals("")) { %>
									<span>원</span>
								<% } %>
								<% if(!CommonUtils.getString(data.get("bdAmt")).equals("") && CommonUtils.getString(data.get("ingTag")).equals("A5") && (CommonUtils.getString(data.get("createUser")).equals(userId) || CommonUtils.getString(data.get("gongoId")).equals(userId))) { %>
									<span> ( 실제 계약금액 : <%= CommonUtils.numberWithCommas(new BigDecimal(CommonUtils.getInt(data.get("realAmt")))) %> 원 )</span>
									<% } %>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰담당자</div>
								<div class="width100"><%= CommonUtils.getString(data.get("damdangName")) %></div>
							</div>
						</div>
						
						<% if("02".equals(CommonUtils.getString(data.get("interrelatedCustCode")))) { %>
						<h3 class="h3Tit mt50">입찰분류</h3>
						<div class="boxSt mt20" >
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">분류군</div>
								<div class="flex align-items-center width100">
									<select class="selectStyle" disabled>
										<option value=""><%= CommonUtils.getString(data.get("matDept")) %></option>
									</select>
									<select class="selectStyle" style="margin: 0 10px" disabled>
										<option value=""><%= CommonUtils.getString(data.get("matProc")) %></option>
									</select>
									<select class="selectStyle" disabled>
										<option value=""><%= CommonUtils.getString(data.get("matCls")) %></option>
									</select>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">공장동</div>
								<div class="width100"><%= CommonUtils.getString(data.get("matFactory")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">라인</div>
									<div class="width100"><%= CommonUtils.getString(data.get("matFactoryLine")) %></div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">호기</div>
									<div class="width100"><%= CommonUtils.getString(data.get("matFactoryCnt")) %></div>
								</div>
							</div>
						</div>
						<% } %>
						
						<h3 class="h3Tit mt50">입찰공고 추가등록 사항</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">제출시작일시</div>
									<div class="width100"><%= CommonUtils.getString(data.get("estStartDate")) %></div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">제출마감일시</div>
									<div class="width100"><%= CommonUtils.getString(data.get("estCloseDate")) %></div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">개찰자</div>
									<div class="width100"><%= CommonUtils.getString(data.get("estOpener")) %></div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">입찰공고자</div>
									<div class="width100"><%= CommonUtils.getString(data.get("gongoName")) %></div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">낙찰자</div>
									<div class="width100"><%= CommonUtils.getString(data.get("estBidder")) %></div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">입회자1</div>
									<div class="width100"><%= CommonUtils.getString(data.get("openAtt1")) %> 
										<% if(userId.equals(CommonUtils.getString(data.get("openAtt1Id")))) { %>
											<% if("Y".equals(CommonUtils.getString(data.get("openAtt1Sign")))) { %>
										<span onclick="onOpenAttSignPop('1', '<%= CommonUtils.getString(data.get("openAtt1Id")) %>', '<%= CommonUtils.getString(data.get("openAtt1Sign")) %>')">[서명 확인]</span>
											<% } else { %>
										<span style="color: red; cursor: pointer; textDecoration: underline;" onclick="onOpenAttSignPop('1', '<%= CommonUtils.getString(data.get("openAtt1Id")) %>', '<%= CommonUtils.getString(data.get("openAtt1Sign")) %>')">[서명 미확인]</span>
											<% } %>
										<% } %>
									</div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">입회자2</div>
									<div class="width100"><%= CommonUtils.getString(data.get("openAtt2")) %> 
										<% if(userId.equals(CommonUtils.getString(data.get("openAtt2Id")))) { %>
											<% if("Y".equals(CommonUtils.getString(data.get("openAtt2Sign")))) { %>
										<span onclick="onOpenAttSignPop('2', '<%= CommonUtils.getString(data.get("openAtt2Id")) %>', '<%= CommonUtils.getString(data.get("openAtt2Sign")) %>')">[서명 확인]</span>
											<% } else { %>
										<span style="color: red; cursor: pointer; textDecoration: underline;" onclick="onOpenAttSignPop('2', '<%= CommonUtils.getString(data.get("openAtt2Id")) %>', '<%= CommonUtils.getString(data.get("openAtt2Sign")) %>')">[서명 미확인]</span>
											<% } %>
										<% } %>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">내역방식</div>
									<div class="width100"><%= "1".equals(CommonUtils.getString(data.get("insMode"))) ? "파일등록" : "직접입력" %></div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">납품조건</div>
									<div class="width100"><%= CommonUtils.getString(data.get("supplyCond")) %></div>
								</div>
							</div>
							
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">세부내역</div>
								<div class="width100">
									<div>
									<%
										if("1".equals(CommonUtils.getString(data.get("insMode")))){
											List<Map<String, Object>> specFile = (List<Map<String, Object>>) data.get("specFile");
											for(int i = 0; i < specFile.size(); i++){
									%>
										<a class=textUnderline onclick="fnfileDownload('<%= (specFile.get(i)).get("filePath") %>', '<%= (specFile.get(i)).get("fileNm") %>')"><%= (specFile.get(i)).get("fileNm") %></a>
									<%
											}
										} else if("2".equals(CommonUtils.getString(data.get("insMode")))){
									%>
										<table class="tblSkin1">
											<colgroup>
												<col style="">
											</colgroup>
											<thead>
												<tr>
													<th>품목명</th>
													<th>규격</th>
													<th>수량</th>
													<th>단위</th>
													<th>예정단가</th>
													<th class="end">합계</th>
												</tr>
											</thead>
											<tbody>
									<%
											List<Map<String, Object>> specInput = (List<Map<String, Object>>) data.get("specInput");
											
											for(int i = 0; i < specInput.size(); i++){
									
												BigDecimal orderUc = (BigDecimal) specInput.get(i).get("orderUc");
												BigDecimal orderQty = (BigDecimal) specInput.get(i).get("orderQty");
												BigDecimal result = orderUc.multiply(orderQty);
									%>
												<tr>
													<td class="text-left"><%= specInput.get(i).get("name") %></td>
													<td class="text-right"><%= specInput.get(i).get("ssize") %></td>
													<td class="text-right"><%= CommonUtils.getFormatNumber(CommonUtils.getString(specInput.get(i).get("orderQty"))) %></td>
													<td class="text-right"><%= specInput.get(i).get("unitcode") %></td>
													<td class="text-right"><%= CommonUtils.getFormatNumber(CommonUtils.getString(specInput.get(i).get("orderUc"))) %></td>
													<td class="text-right end"><%= CommonUtils.getFormatNumber(CommonUtils.getString(result)) %></td>
												</tr>
									<%
											}
									%>
											</tbody>
										</table>
									<%
										}
									%>
									</div>
								</div>
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">첨부파일</div>
								<div class="width100">
<%
	List<Map<String, Object>> fileList = (List<Map<String, Object>>) data.get("fileList");
	for(int i = 0; i < fileList.size(); i++){
%>
									<div class="<%= ( "1".equals(fileList.get(i).get("fileFlag")) ? "textHighlight" : "" ) %>">
										<span class="mr20"> <%= ( "1".equals(fileList.get(i).get("fileFlag")) ? "대내용" : "대외용" ) %> </span>
										<a class=textUnderline onclick="fnfileDownload('<%= fileList.get(i).get("filePath") %>', '<%= (fileList.get(i)).get("fileNm") %>')"><%= fileList.get(i).get("fileNm") %></a>
									</div>
<%
	}
%>
								</div>
							</div>
<%
	if("A3".equals(data.get("ingTag")) && !"".equals(CommonUtils.getString(data.get("whyA3")))){
%>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">재입찰사유</div>
								<div class="width100"><%= CommonUtils.getString(data.get("whyA3")) %></div>
							</div>
<%
	}
	if(!"".equals(CommonUtils.getString(data.get("whyA7")))){
%>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">유찰사유</div>
								<div class="width100"><%= CommonUtils.getString(data.get("whyA7")) %></div>
							</div>
<%
	}
%>
						</div>
					</div>
					
					<div id="buttonList" class="text-center mt50">
						<button class="btnStyle btnOutline" title="목록" onclick="onMovePage()">목록</button>
<!--						<button class="btnStyle btnOutline" title="엑셀변환" onclick="onExcel()">엑셀변환</button>-->
						<button class="btnStyle btnOutline" title="공고문 미리보기" onclick="onBidBiddingPreviewModal()">공고문 미리보기</button>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
	
	<!-- 공고문 미리보기 팝업 -->
	<jsp:include page="/WEB-INF/jsp/bid/bidBiddingPreview.jsp" />
	
	<!-- 삭제 팝업 -->
	<jsp:include page="/WEB-INF/jsp/bid/bidProgressDel.jsp" />
	
	<!-- 협력사 사용자 팝업 -->
	<jsp:include page="/WEB-INF/jsp/bid/custUserPop.jsp" />
		
</body>
</html>
