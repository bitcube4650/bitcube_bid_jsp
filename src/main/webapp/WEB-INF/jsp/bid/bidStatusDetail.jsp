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
	Map<String, Object>				data = (Map<String, Object>) request.getAttribute("biInfo");
	ArrayList<Map<String, Object>>	custList = new ArrayList<Map<String, Object>>();
									custList = (ArrayList) data.get("custList");
	ObjectMapper					objectMapper = new ObjectMapper();
	String							jsonCustList = objectMapper.writeValueAsString(custList);
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
		}
		
		function onRejectDetail(value) {
			if(value === '2'){
				Swal.fire('', '개찰 전 견적 내용은 확인할 수 없습니다.', 'warning');
			}
		}
		
		function onMovePage() {
			location.href="/api/v1/move?viewName=bid/status";
		}
		
		function onOpenCustUserPop(index) {
			
		}
				
		// 유찰
		function onOpenBidSaveFailPop() {
			var data		= <%= jsonData %>;
			$("#bidSaveFailPopBiNo").val(data.biNo);
			$("#bidSaveFailPopBiName").val(data.biName);
			$("#bidSaveFailPop").modal("show");
		}
		
		// 선택업체 재입찰
		function onRebid() {
			
		}
		
		function onCheck() {
			var data		= <%= jsonData %>;
			
			if(!Ft.isEmpty(data.openAtt1Id) && data.openAtt1Sign !== 'Y'){
				Swal.fire('', '입회자1의 서명이 필요합니다.', 'warning');
				return false;
			}

			if(!Ft.isEmpty(data.openAtt2Id) && data.openAtt2Sign !== 'Y'){
				Swal.fire('', '입회자2의 서명이 필요합니다.', 'warning');
				return false;
			}

			Swal.fire({
				title: '',						// 타이틀
				text: "개찰하시겠습니까?",		// 내용
				icon: 'question',				// success / error / warning / info / question
				confirmButtonColor: '#3085d6',	// 기본옵션
				confirmButtonText: '개찰',		// 기본옵션
				showCancelButton: true,			// conrifm 으로 하고싶을떄
				cancelButtonColor: '#d33',		// conrifm 에 나오는 닫기버튼 옵션
				cancelButtonText: '취소',		// conrifm 에 나오는 닫기버튼 옵션
			}).then((result) => {
				if(result.value){
					//비밀번호 입력하지 않고 바로 개찰 처리
					onOpenBid();
				}
			});
			
		}
		
		function onOpenBid() {
			var data		= <%= jsonData %>;
			var params = {
				biNo : data.biNo,
				certPwd : ''
			}
			
			$.post(
					"/api/v1/bidstatus/bidOpening",
					params
					)
					.done(function(arg) {
						if (arg.code === "OK") {
							
							Swal.fire({
								title: '',
								text: "개찰했습니다.",
								icon: 'success',
								confirmButtonText: '확인',
							}).then((result) => {
								if (result.isConfirmed) {
									onMovePage();
								}
							});
							
						} else {
							Swal.fire('', '개찰 처리중 오류 가 발생했습니다.', 'error');
							return;
						}
					});
		}
		
		function onShowCustSubmitHist(index) {
			var data		= <%= jsonData %>;
			var custList	= <%= jsonCustList %>;
			var cust		= custList[index];
			
			$("#submitHistPop").modal('show');
			submitHistoryPopInit(data.biNo, cust.custCode, cust.custName, cust.damdangName);
		}
		
		function onSuccSelect(index) {
			var data		= <%= jsonData %>;
			var custList	= <%= jsonCustList %>;
			var cust		= custList[index];
			$("#succPopBiNo").val(data.biNo);
			$("#succPopCustCode").val(cust.custCode);
			$("#succPopBiName").val(data.biName);
			$("#succPopCustName").html(cust.custName);
			$("#bidSuccessPop").modal('show');
		}
		
		function onEvent(index, e) {
			var custList	= <%= jsonCustList %>;
			var data		= <%= jsonData %>;
			var cust		= custList[index];
			var insMode		= data.insMode;
			
			if(insMode === "1" && cust.esmtYn === "2") {
				fnCustSpecFileDown(cust.fileNm, cust.filePath)
			} else if (insMode === "2" && cust.esmtYn === "2") {
				if ($("#subTr" + index).css('display') === 'none' || $("#subTr" + index).css('display') === '') {
					$("#subTr" + index).css('display', 'table-row');
				} else {
					$("#subTr" + index).css('display', 'none');
				}
			}
			
		}
		
		//파일 다운로드 파라미터 셋팅
		function fnCustSpecFileDown(fileNm, filePath){
			if(!Ft.isEmpty(fileNm) && !Ft.isEmpty(filePath)){
				downloadFile(fileNm, filePath);
			}
		}
		
		function downloadFile(fileNm,filePath){
			var params = {
					fileId : filePath,
					responseType: "blob"
			}
			$.post(
					"/api/v1/bidComplete/fileDown",
					params
					)
					.done(function(arg) {
						if (arg.code === "OK") {
							const url = window.URL.createObjectURL(new Blob([arg.data]));
							const link = document.createElement("a");
							link.href = url;
							link.setAttribute("download", fileNm);
							document.body.appendChild(link);
							link.click();
							document.body.removeChild(link);
						} else {
							Swal.fire('', '파일 다운로드를 실패하였습니다.', 'warning');
							return;
						}
					});
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
		
		function onOpenAttSignPop(a,b,c) {
			alert(a);
			alert(b);
			alert(c);
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
						<li>입찰진행 상세</li>
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
						
						<% if("02".equals(CommonUtils.getString(data.get("interrelateCustCode")))) { %>
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
									<%-- 	<% if(userId.equals(CommonUtils.getString(data.get("openAtt1Id")))) { %> --%>
											<% if("Y".equals(CommonUtils.getString(data.get("openAtt1Sign")))) { %>
										<span onclick="onOpenAttSignPop('1', '<%= CommonUtils.getString(data.get("openAtt1Id")) %>', '<%= CommonUtils.getString(data.get("openAtt1Sign")) %>')">[서명 확인]</span>
											<% } else { %>
										<span style="color: red; cursor: pointer; textDecoration: underline;" onclick="onOpenAttSignPop('1', '<%= CommonUtils.getString(data.get("openAtt1Id")) %>', '<%= CommonUtils.getString(data.get("openAtt1Sign")) %>')">[서명 미확인]</span>
											<% } %>
									<%-- 	<% } %> --%>
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
							
							<div class="flex mt20">
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
					
						<h3 class="h3Tit mt50">업체견적 사항 <strong class="textHighlight">(개찰 전까지 견적금액 및 내역파일은 암호화되어 보호됩니다)</strong></h3>
						<div class="conTopBox mt20">
							<ul class="dList">
								<li><div>재 입찰일 경우 참가업체명을 클릭하면 차수 별 견적제출 이력을 볼 수 있습니다.</div></li>
								<li><div>견적 상세 확인은 상세를 클릭하시면 확인하실 수 있습니다.</div></li>
							</ul>
						</div>
					
						<% if(CommonUtils.getString(data.get("ingTag")).equals("A1") || CommonUtils.getString(data.get("ingTag")).equals("A3")) { %>
						<div class="boxSt mt20">
							<table class="tblSkin1">
								<colgroup>
									<col />
								</colgroup>
								<thead>
									<tr>
										<th>입찰참가업체명</th>
										<th>견적금액(총액)</th>
										<th>확인</th>
										<th>제출일시</th>
										<th>담당자</th>
										<th class="end">기타첨부파일</th>
									</tr>
									</thead>
									<tbody>
										<% for(Map<String, Object> map : custList) { %>
										<tr>
											<td class="text-left">
												<%= CommonUtils.getString(map.get("custName")) %>
											</td>
											<td class="text-overflow">
												<%= CommonUtils.getFormatNumber(CommonUtils.getString(map.get("esmtAmt"))) %>
											</td>
											<td>
												<a onClick="onRejectDetail('<%= CommonUtils.getString(map.get("esmtYn")) %>')">
													<%= CommonUtils.ftEsmtYn(CommonUtils.getString(map.get("esmtYn"))) %>
												</a>
											</td>
											<td>
												<%= CommonUtils.getString(map.get("submitDate")) %>
											</td>
											<td>
												<%= CommonUtils.getString(map.get("damdangName")) %>
											</td>
											<td class="end">
												<% if(!CommonUtils.getString(map.get("etcPath")).equals("")) { %>
													<img src='/resources/images/icon_etc.svg' onclick="fnCustSpecFileDown('<%= map.get("etcFile") %>', '<%= map.get("etcPath") %>')" class='iconImg' alt='etc' />
												<% } %>
											</td>
										</tr>
										<% } %>
									</tbody>
							</table>
						</div>

						<div class="text-center mt50">
							<a class="btnStyle btnOutline" title="목록" onClick="onMovePage()">목록</a>
								<% if( (CommonUtils.getString(data.get("ingTag")).equals("A1")) && ((boolean) data.get("bidAuth") || (boolean) data.get("openAuth") || CommonUtils.getString(data.get("createUser")).equals(userId))) { %>
								<% } %>
								<% if( (CommonUtils.getString(data.get("ingTag")).equals("A1")) && ((boolean) data.get("bidAuth")) && (CommonUtils.getString(data.get("estCloseCheck")).equals("1"))) { %>
							<a onClick="onCheck()" class="btnStyle btnPrimary" title="개찰">개찰</a>
								<% } %>
						</div>
						<% } %>
						
						<% if(CommonUtils.getString(data.get("ingTag")).equals("A2")) { %>
						<div class="boxSt mt20">
							<%
										if(custList.size() > 0) {
							%>
							<table class="tblSkin1">
								<colgroup>
									<col/>
								</colgroup>
								<thead>
									<tr>
										<th>
											<input type="checkbox" id="allChk" class="checkStyle checkOnly"/>
											<label for="allChk"></label>
										</th>
										<th>입찰참가업체명</th>
										<th>견적금액(총액)</th>
										<th>견적</th>
										<th>제출일시</th>
										<th>담당자</th>
										<th>기타첨부파일</th>
										<th class="end">선정</th>
									</tr>
								</thead>
								<tbody>
									<%
											int index = 0;
											for(Map<String, Object> map : custList) { 
									%>
									<tr id="mainTr<%= index %>">
										<td>
											<input type="checkbox" id="'<%= index %>'" class="checkStyle checkOnly"/>
											<label for="'<%= index %>'"></label>
										</td>
										<td class="text-left">
											<a onClick="onShowCustSubmitHist(<%= index %>)">
												<%= CommonUtils.getString(map.get("custName")) %>
											</a>
										</td>
										<td class="text-overflow"><%= CommonUtils.getString(map.get("esmtAmt")) %></td>
										<td>
											<% if(CommonUtils.getString(map.get("esmtYn")).equals("2")) { %>
												<a onClick="onEvent(<%= index %> , event)" class="textUnderline textMainColor"><%= CommonUtils.getString(map.get("esmtYn")) %></a>
											<% } else { %>
												<a onClick="onEvent(<%= index %> , event)"><%= CommonUtils.getString(map.get("esmtYn")) %></a>
											<% } %>
										</td>
										<td><%= CommonUtils.getString(map.get("submitDate")) %></td>
										<td><%= CommonUtils.getString(map.get("damdangName")) %></td>
										<td>
											<% if(CommonUtils.getString(map.get("etcPath")).equals("")) { %>
												<img src='/resources/images/icon_etc.svg' onclick="fnCustSpecFileDown('<%= map.get("etcFile") %>', '<%= map.get("etcPath") %>')" class='iconImg' alt='etc' />
											<% } %>
										</td>
										<td>
											<% if( CommonUtils.getString(map.get("esmtYn")).equals("2") && ((boolean) data.get("openAuth") || (boolean) data.get("bidAuth")) ) { %>
												<a onClick="onSuccSelect(<%= index %>)" class="btnStyle btnSecondary btnSm" title="낙찰">낙찰</a>
											<% } %>
										</td>
									</tr>
									<tr id="subTr<%= index %>" class="detailView">
										<td colSpan="8" class="end">
											<%
													ArrayList<Map<String, Object>>	bidSpec = (ArrayList) map.get("bidSpec");
													if(bidSpec != null && bidSpec.size() > 0) {
											%>
											<table class="tblSkin2">
												<colgroup>
													<col />
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
															for(Map<String, Object> bidSpecMap : bidSpec) {
													%>
													<tr>
														<td class="text-left"><%= CommonUtils.getString(bidSpecMap.get("name")) %></td>
														<td class="text-left"><%= CommonUtils.getString(bidSpecMap.get("ssize")) %></td>
														<td class="text-right"><%= CommonUtils.numberWithCommas(new BigDecimal(CommonUtils.getInt(bidSpecMap.get("orderQty")))) %></td>
														<td><%= CommonUtils.getString(bidSpecMap.get("unitcode")) %></td>
														<td class="text-right"><%= CommonUtils.numberWithCommas(new BigDecimal(CommonUtils.getInt(bidSpecMap.get("esmtUc"))).divide(new BigDecimal(CommonUtils.getInt(bidSpecMap.get("orderQty"))), 2, RoundingMode.HALF_UP)) %></td>
														<td class="text-right end"><%= CommonUtils.numberWithCommas(new BigDecimal(CommonUtils.getInt(bidSpecMap.get("esmtUc")))) %></td>
													</tr>
													<%
															}
														}
													%>
												</tbody>
											</table>
										</td>
									</tr>
									<%
											index++;
											}
									%>
									<%
										}
									%>
								</tbody>
							</table>
							<div class="text-center mt50">
								<a class="btnStyle btnOutline" title="목록" onClick="onMovePage()">목록</a>
								<a data-toggle="modal" data-target="#resultsReport" class="btnStyle btnOutline" title="개찰결과 보고서">개찰결과 보고서</a>
								<% if( ((boolean) data.get("openAuth")) || ((boolean) data.get("bidAuth")) || CommonUtils.getString(data.get("createUser")).equals(userId) ) { %>
								<a onClick="onOpenBidSaveFailPop()" class="btnStyle btnSecondary" title="유찰">유찰</a>
								<% } %>
								<% if( ((boolean) data.get("openAuth")) || CommonUtils.getString(data.get("createUser")).equals(userId) ) { %>
								<a onClick="onRebid()" class="btnStyle btnOutlineRed" title="선택업체 재입찰">선택업체 재입찰하러 가기</a>
								<% } %>
							</div>
						</div>
						<% } %>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
	
	
	<!-- 낙찰 팝업 -->
	<jsp:include page="/WEB-INF/jsp/bid/bidSuccessPop.jsp" />
	
	<!-- 유찰 팝업 -->
	<jsp:include page="/WEB-INF/jsp/bid/bidSaveFailPop.jsp" />
	
	<!-- 제출이력 팝업 -->
	<jsp:include page="/WEB-INF/jsp/bid/bidSubmitHistoryPop.jsp" />
	
	<!-- 개찰결과 보고서 -->
	<jsp:include page="/WEB-INF/jsp/bid/bidResultReport.jsp">
		<jsp:param name="title" value="입찰결과 보고서" />
	</jsp:include>
</body>
</html>
