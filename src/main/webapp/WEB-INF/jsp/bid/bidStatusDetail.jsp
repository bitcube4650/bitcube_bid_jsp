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
	Map<String, Object>				data = (Map<String, Object>) request.getAttribute("data");
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
		
		// 개찰결과 보고서
		function onOpenReportPop() {
			
		}
		
		// 유찰
		function onOpenBidSaveFailPop() {
			setBidSaveFailPop(true);
		}
		
		// 선택업체 재입찰
		function onRebid() {
			
		}
		
		function onCheck() {
		//	if(!Ft.isEmpty(data.openAtt1Id) && data.openAtt1Sign !== 'Y'){
		//	            Swal.fire('', '입회자1의 서명이 필요합니다.', 'warning');
		//	            return false;
		//	        }

		//	        if(!Ft.isEmpty(data.openAtt2Id) && data.openAtt2Sign !== 'Y'){
		//	            Swal.fire('', '입회자2의 서명이 필요합니다.', 'warning');
		//	            return false;
		//	        }

		//	        Swal.fire({
		//	            title: '',              // 타이틀
		//	            text: "개찰하시겠습니까?",  // 내용
		//	            icon: 'question',                        // success / error / warning / info / question
		//	            confirmButtonColor: '#3085d6',  // 기본옵션
		//	            confirmButtonText: '개찰',      // 기본옵션
		//	            showCancelButton: true,         // conrifm 으로 하고싶을떄
		//	            cancelButtonColor: '#d33',      // conrifm 에 나오는 닫기버튼 옵션
		//	            cancelButtonText: '취소',       // conrifm 에 나오는 닫기버튼 옵션
		//	        }).then((result) => {
		//	            if(result.value){
		//	                onOpenBid();
		//	            }
		//	        });
		}
		
		function onShowCustSubmitHist(cust) {
			
		}
		
		function onEvent(index, e) {
			var custList	= <%= jsonCustList %>;
			var data		= <%= jsonData %>;
			var cust		= custList[index];
			var insMode		= data.insMode;
			
			if(insMode === "1" && cust.esmyYn === "2") {
		//		Api.fnCustSpecFileDown(cust.fileNm, cust.filePath)
			} else if (insMode === "2" && cust.esmtYn === "2") {
				if ($("#subTr" + index).css('display') === 'none' || $("#subTr" + index).css('display') === '') {
					$("#subTr" + index).css('display', 'table-row');
				} else {
					$("#subTr" + index).css('display', 'none');
				}
			}
			
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
						
<!--						<CmmnInfo key={'info_'+data.biNo} data={data} attSign="Y" />-->
					
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
													<img className="iconImg" alt="etc" onClick="onRejectDetail('<%= CommonUtils.getString(map.get("esmtYn")) %>')"/>
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
							<a onClick="onOpenBidSaveFailPop()" class="btnStyle btnSecondary" title="유찰">유찰</a>
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
												ObjectMapper mapper = new ObjectMapper();
												String jsonStr = mapper.writeValueAsString(map);
									%>
									<tr id="mainTr<%= index %>">
										<td>
											<input type="checkbox" id="'<%= index %>'" class="checkStyle checkOnly"/>
											<label for="'<%= index %>'"></label>
										</td>
										<td class="text-left">
											<a onClick="onShowCustSubmitHist('<%= CommonUtils.getString(map.get("custName")) %>')">
												<%= CommonUtils.getString(map.get("custName")) %>
											</a>
	<!--											<a onClick={()=>onShowCustSubmitHist(cust)} class="textUnderline">{ cust.custName }</a>-->
										</td>
	<!--									<td class="text-overflow">{ Ft.ftEsmtAmt(cust) }</td>-->
										<td class="text-overflow"><%= CommonUtils.getString(map.get("esmtAmt")) %></td>
										<td>
											<% if(CommonUtils.getString(map.get("esmtYn")).equals("2")) { %>
												<a onClick="onEvent(<%= index %> , event)" class="textUnderline textMainColor"><%= CommonUtils.getString(map.get("esmtYn")) %></a>
											<% } else { %>
												<a onClick="onEvent(<%= index %>)", event><%= CommonUtils.getString(map.get("esmtYn")) %></a>
											<% } %>
										</td>
										<td><%= CommonUtils.getString(map.get("submitDate")) %></td>
										<td><%= CommonUtils.getString(map.get("damdangName")) %></td>
										<td>
	<!--											{cust.etcPath &&-->
	<!--											<img onClick={ () => Api.fnCustSpecFileDown(cust.etcFile, cust.etcPath)} src="/images/icon_etc.svg" class="iconImg" alt="etc"/>-->
	<!--											}-->
										</td>
										<td>
	<!--											{(cust.esmtYn === '2' && (data.openAuth || data.bidAuth)) &&-->
	<!--											<a onClick={()=>onSuccSelect(cust)} class="btnStyle btnSecondary btnSm" title="낙찰">낙찰</a>-->
	<!--											}-->
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
														<td class="text-right"><%= CommonUtils.numberWithCommas(new BigDecimal(CommonUtils.getString(bidSpecMap.get("orderQty")))) %></td>
														<td><%= CommonUtils.getString(bidSpecMap.get("unitcode")) %></td>
														<td class="text-right"><%= CommonUtils.numberWithCommas(new BigDecimal(CommonUtils.getString(bidSpecMap.get("esmtUc"))).divide(new BigDecimal(CommonUtils.getString(bidSpecMap.get("orderQty"))), 2, RoundingMode.HALF_UP)) %></td>
														<td class="text-right end"><%= CommonUtils.numberWithCommas(new BigDecimal(CommonUtils.getString(bidSpecMap.get("esmtUc")))) %></td>
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
								<a class="btnStyle btnOutline" title="개찰결과 보고서" onClick="onOpenReportPop()" >개찰결과 보고서</a>
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
</body>
</html>
