<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.HashMap"%>
<%@page import="bitcube.framework.ebid.dto.UserDto"%>
<%@page import="bitcube.framework.ebid.etc.util.Constances"%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>

<%
	Map<String, Object> biInfo = (Map<String, Object>) request.getAttribute("biInfo");
	List<Map<String, Object>> custList = (List<Map<String, Object>>) biInfo.get("custList");
	
	// 로그인 세션정보
	UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
%>
	<script>
		$(document).ready(function() {
			$("#biModeDiv").text(Ft.ftBiMode("<%=biInfo.get("biMode")%>"));
			$("#insModeDiv").text(Ft.ftInsMode("<%=biInfo.get("insMode")%>"));				// 내역방식

			$("#srcCustUserNm").keydown(function(e) {
				if(e.key === "Enter" || e.keyCode === 13) {
					fnDetailBi('');
				}
			});
			
			$("#srcCustLogin").keydown(function(e) {
				if(e.key === "Enter" || e.keyCode === 13) {
					fnDetailBi('');
				}
			});
		});
		
		function fnOpenDetailBiPop(custCode){
			fnDetailBi(custCode);
			$("#custUserPop").modal('show');
		}
		
		// 입찰 참가 업체 협력사 사용자 팝업 호출
		function fnDetailBi(custCode){
			if(custCode != ''){
				// 업체 선택시 협력사 사용자 내 팝업 조회조건 초기화
				$("#srcCustCode").val(custCode);
				$('#srcCustUserNm').val('');
				$('#srcCustLogin').val('');
			} else {
				custCode = $("#srcCustCode").val();
			}
			
			$.post(
				"/api/v1/cust/userListForCust",
				{
					custCode : custCode,
					userName : $('#srcCustUserNm').val(),
					userId : $('#srcCustLogin').val(), 
					useYn : 'Y'
				}
			).done(function(response){
				$("#custUserListTbl tbody").empty();
				let html = ''
				
				if(response.code === 'OK') {
					const list = response.data.content;
					if(list.length > 0){
						for(var i=0;i<list.length;i++) {
							html += '<tr>';
							html += '	<td>'+ list[i].userName +'</td>';
							html += '	<td>'+ list[i].userId +'</td>';
							html += '	<td>'+ Ft.defaultIfEmpty(list[i].userBuseo,'')  +'</td>';
							html += '	<td>'+ Ft.defaultIfEmpty(list[i].userPosition,'') +'</td>';
							html += '	<td>'+ list[i].userEmail +'</td>';
							html += '	<td>'+ Ft.onAddDashTel(list[i].userTel) +'</td>';
							html += '	<td>'+ Ft.onAddDashTel(list[i].userHp) +'</td>';
							html += '	<td class="end">'+ (list[i].userType === '1' ? '업체관리자' : '사용자') +'</td>';
							html += '</tr>';
							
							$("#custUserListTbl tbody").html(html);
						}
					} else {
						html += '<tr>';
						html += '	<td colspan="8">조회된 결과가 없습니다.</td>';
						html += '</tr>';
						$("#custUserListTbl tbody").html(html);
					}
				} else {
					html += '<tr>';
					html += '	<td colspan="8">조회된 결과가 없습니다.</td>';
					html += '</tr>';
					$("#custUserListTbl tbody").html(html);
					
					Swal.fire('', response.msg, 'warning')
				}
			})
		}
		
		// 업체견적사항 상세 테이블
		function fnCheck(esmtYn, fileName, filePath){
			if((esmtYn == '2' || esmtYn == '3') && <%= !biInfo.containsKey("estOpenDate") %>){
				Swal.fire('','복호화되지 않아 상세를 불러올 수 없습니다', 'warning');
			}else if((esmtYn == '2' || esmtYn == '3') && <%= !"".equals(CommonUtils.getString(biInfo.get("estOpenDate"))) %>){
				if(<%= "1".equals(biInfo.get("insMode"))%>){
					// 파일 다운로드
					fnfileDownload(filePath, fileName);
				} else if(<%= "2".equals(biInfo.get("insMode"))%>){
					$(event.target).closest('tr').next('.detailView').toggle();
				}
			}
		}
		
		// 실제계약금액 입력시 콤마 처리
		function fnComma(obj){
			let num = $(obj).val().replaceAll(",", "");
			$(obj).val(Ft.ftRoundComma(num));
		}
		
		// 실계약금액 저장 confirm
		function fnSaveConfirm(){
			if(realAmt == ""){
				Swal.fire("", "실제계약금액을 입력해주세요.", "warning");
			} else {
				Swal.fire({
					text : '실제계약금액을 저장하시겠습니까?',
					icon : 'info',
					type : 'info',
					showCancelButton: true,
					confirmButtonText: '저장',
					cancelButtonText: '취소'
				}).then((result) => {
					if (result.isConfirmed) {
						fnSave();
					}
					
				})
			}
		}
		
		// 실계약금액 저장
		function fnSave(){
			let realAmt = $("#realAmt").val();
			
			$.post(
				'/api/v1/bidComplete/updRealAmt',
				{
					realAmt : realAmt.replace(/[^-0-9]/g, ''),
					biNo : "<%= biInfo.get("biNo") %>"
				}
			).done(function(arg){
				if(arg.code == "OK"){
					Swal.fire({
						text : '실제계약금액을 저장하였습니다.',
						icon: "info",
						type : 'info',
						showCancelButton: false,
						confirmButtonText: 'OK',
					}).then((result) => {
						if (result.isConfirmed) {
							$("#realAmtSave").modal('hide');
						}
					})
				} else {
					Swal.fire('', arg.msg, 'error');
				}
			})
		}
		
		// 첨부파일 다운로드
		function fnfileDownload(filePath, fileName){
			let params = {
					fileId : filePath
			}
			
			$.ajax({
				url: '/api/v1/notice/downloadFile',
				data: params,
				type: 'POST',
				xhrFields: {
					responseType: "blob",
				},
				error: function(jqXHR, textStatus, errorThrown) {
					Swal.fire('', '파일 다운로드를 실패했습니다.', 'error');
				},
				success: function(data, status, xhr) {
					var blob = new Blob([data], { type: xhr.getResponseHeader('Content-Type') });

					// 링크 생성
					var link = document.createElement('a');
					link.href = window.URL.createObjectURL(blob);
					link.download = fileName;

					// 링크를 클릭하여 다운로드를 실행
					document.body.appendChild(link);
					link.click();

					// 링크 제거
					document.body.removeChild(link);
				}
			});
		}
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			<div class="conRight">
				<!-- conHeader -->
				<div class="conHeader">
					<ul class="conHeaderCate">
						<li>전자입찰</li>
						<li>입찰완료 상세</li>
					</ul>
				</div>
				<!-- //conHeader -->
				<!-- contents -->
				<div class="contents">
					<div class="formWidth">
						<h3 class="h3Tit">입찰기본정보</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">입찰번호</div>
								<div class="width100"><%= biInfo.get("biNo") %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰명</div>
								<div class="width100"><%= biInfo.get("biName") %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">품목</div>
								<div class="width100"><%= biInfo.get("itemName") %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰방식</div>
								<div class="width100" id="biModeDiv"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰참가자격</div>
								<div class="width100"><%= biInfo.get("bidJoinSpec") %></div>
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">특수조건</div>
								<div class="width100">
									<div class="overflow-y-scroll boxStSm width100" style="height:100px">
										<pre style="background-color: white;"><%= biInfo.get("specialCond") %></pre>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">현장설명일시</div>
								<div class="width100"><%= biInfo.get("spotDate") %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">현장설명장소</div>
								<div class="width100"><%= biInfo.get("spotArea") %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">낙찰자결정방법</div>
								<div class="width100"><%= biInfo.get("succDeciMeth") %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰참가업체</div>
								<div class="width100">
<%
	if("A".equals(biInfo.get("biMode"))){
%>
									<div class="overflow-y-scroll boxStSm width100" style="height:50px">
<%
		for(int i = 0; i < custList.size(); i++){
%>
										<a onclick="fnOpenDetailBiPop('<%= custList.get(i).get("custCode") %>')"><span class="textUnderline"><%= custList.get(i).get("custName") %></span><%= (i == (custList.size() - 1)) ? "" : "," %></a>
<%
		}
%>
									</div>
<%
	} else if("B".equals(biInfo.get("biMode"))){
%>
									<div class="boxStSm width100 boxOverflowY">
										<a>가입회원사 전체</a>
									</div>
<%
	}
%>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">금액기준</div>
								<div class="width100"><%= biInfo.get("amtBasis") %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">결제조건</div>
								<div class="width100"><%= CommonUtils.getString(biInfo.get("payCond")) %></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">예산금액</div>
								<div class="width100">
									<%= CommonUtils.getFormatNumber(CommonUtils.getString(biInfo.get("bdAmt"))) %> <%= ("".equals(CommonUtils.getString(biInfo.get("bdAmt"))) ? "" : "원") %>
<%
	if("A5".equals(biInfo.get("ingTag")) && !"".equals(CommonUtils.getString(biInfo.get("realAmt"))) && (user.getLoginId().equals(biInfo.get("createUser")) || user.getLoginId().equals(biInfo.get("gongoId")))){
%>
									<span> ( 실제 계약금액 : <%= CommonUtils.getFormatNumber(CommonUtils.getString(biInfo.get("realAmt"))) %> 원) </span>
<%
	}
%>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰담당자</div>
								<div class="width100"><%= biInfo.get("damdangName") %></div>
							</div>
						</div>
		
						<h3 class="h3Tit mt50">입찰공고 추가등록 사항</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">제출시작일시</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("estStartDate")) %></div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">제출마감일시</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("estCloseDate")) %></div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">개찰자</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("estOpener")) %></div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">입찰공고자</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("gongoName")) %></div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">낙찰자</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("estBidder")) %></div>
								</div>
								
							</div>
							<div class="flex align-items-center mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">입회자1</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("openAtt1")) %></div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">입회자2</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("openAtt2")) %></div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">내역방식</div>
									<div class="width100" id="insModeDiv"></div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">납품조건</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("supplyCond")) %></div>
								</div>
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">세부내역</div>
								<div class="width100">
									<div>
<%
	if("1".equals(biInfo.get("insMode"))){
		List<Map<String, Object>> specFile = (List<Map<String, Object>>) biInfo.get("specFile");
		
		for(int i = 0; i < specFile.size(); i++){
%>
										<a class=textUnderline onclick="fnfileDownload('<%= (specFile.get(i)).get("filePath") %>', '<%= (specFile.get(i)).get("fileNm") %>')"><%= (specFile.get(i)).get("fileNm") %></a>
<%
		}
	} else if("2".equals(CommonUtils.getString(biInfo.get("insMode")))){
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
		List<Map<String, Object>> specInput = (List<Map<String, Object>>) biInfo.get("specInput");
		
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
	List<Map<String, Object>> fileList = (List<Map<String, Object>>) biInfo.get("fileList");
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
	if("A3".equals(biInfo.get("ingTag")) && !"".equals(CommonUtils.getString(biInfo.get("whyA3")))){
%>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">재입찰사유</div>
								<div class="width100"><%= CommonUtils.getString(biInfo.get("whyA3")) %></div>
							</div>
<%
	}
	if(!"".equals(CommonUtils.getString(biInfo.get("whyA7")))){
%>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">유찰사유</div>
								<div class="width100"><%= CommonUtils.getString(biInfo.get("whyA7")) %></div>
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
						<div class="boxSt mt20">
							<table class="tblSkin1">
								<colgroup>
									<col style="">
								</colgroup>
								<thead>
									<tr>
										<th>입찰참가업체명</th>
										<th>견적금액(총액)</th>
										<th>견적</th>
										<th>제출일시</th>
										<th>대표자</th>
										<th>기타첨부파일</th>
										<th>구분</th>
										<th class="end">낙찰일시</th>
									</tr>
								</thead>
								<tbody>
<%
	for(int i = 0; i < custList.size(); i++){
		Map<String, Object> cust = custList.get(i);
%>
									<tr>
										<td class='text-left'>
											<a onclick="submitHistoryPopInit('<%= biInfo.get("biNo") %>', '<%= cust.get("custCode") %>', '<%= cust.get("custName") %>', '<%= cust.get("damdangName") %>')" class='textUnderline' data-toggle='modal' data-target='#submitHistPop'><%= cust.get("custName") %></a>
										</td>
										<td class='text-overflow'><%= CommonUtils.getString(cust.get("esmtCurr")) %> <%= CommonUtils.getFormatNumber(CommonUtils.getString(cust.get("esmtAmt"))) %></td>
										<td>
											<a onclick="fnCheck('<%= cust.get("esmtYn") %>', '<%=cust.get("fileNm") %>', '<%= cust.get("filePath") %>');" class="<%= ("2".equals(cust.get("esmtYn")) ? ("2".equals(biInfo.get("insMode")) && !"".equals(CommonUtils.getString(biInfo.get("estOpenDate"))) ? "textUnderline textMainColor detailBtn" : "textUnerline textMainColor" ) : "") %>"><%= ( "1".equals(cust.get("esmtYn")) ? "공고확인" : ("2".equals(cust.get("esmtYn")) || "3".equals(cust.get("esmtYn")) ? "상세" : "") ) %> </a>
											
										</td>
										<td><%= CommonUtils.getString(cust.get("submitDate")) %></td>
										<td><%= CommonUtils.getString(cust.get("presName")) %></td>
										<td><img src='/resources/images/icon_etc.svg' onclick="fnfileDownload('<%= cust.get("etcPath") %>', '<%= cust.get("etcFile") %>')" class='iconImg' alt='etc' style='<%= "".equals(CommonUtils.getString(cust.get("etcPath"))) ? "display:none" : "" %>'></td>
										<td class='textHighlight'><%= ("Y".equals(CommonUtils.getString(cust.get("succYn"))) ? "낙찰" : "") %></td>
										<td class='end'><%= CommonUtils.getString(cust.get("updateDate")) %></td>
									</tr>

<%
		if(cust.containsKey("bidSpec")){
			List<Map<String, Object>> bidSpecList = (List<Map<String, Object>>) custList.get(i).get("bidSpec");
%>
<!-- 							업체별 상세 조회 -->
									<tr class='detailView'>
										<td colspan='8' class='end'>
											<table class='tblSkin2'>
												<colgroup>
													<col style=''>
												</colgroup>
												<thead>
													<tr>
														<th>품목명</th>
														<th>규격</th>
														<th>수량</th>
														<th>단위</th>
														<th>예정단가</th>
														<th class='end'>합계</th>
													</tr>
												</thead>
												<tbody>
<%
			for(int j = 0; j < bidSpecList.size(); j++){
	
				BigDecimal esmtUc = (BigDecimal) bidSpecList.get(j).get("esmtUc");
				BigDecimal orderQty = (BigDecimal) bidSpecList.get(j).get("orderQty");
				BigDecimal result = esmtUc.divide(orderQty, 2, RoundingMode.HALF_UP);
%>
													<tr>
														<td class='text-left'><%= bidSpecList.get(j).get("name") %></td>
														<td class='text-left'><%= bidSpecList.get(j).get("ssize") %></td>
														<td class="text-right"><%= CommonUtils.getFormatNumber(CommonUtils.getString(orderQty)) %></td>
														<td><%= bidSpecList.get(j).get("unitcode") %></td>
														<td class="text-right"><%= CommonUtils.getFormatNumber(CommonUtils.getString(result)) %></td>
														<td class="text-right end"><%= CommonUtils.getFormatNumber(CommonUtils.getString(esmtUc)) %></td>
													</tr>
<%
			}
%>
												</tbody>
											</table>
										</td>
									</tr>
<%
		}
	}
%>
								</tbody>
							</table>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">낙찰 추가 합의사항</div>
								<div class="width100"><%= CommonUtils.getString(biInfo.get("addAccept")) %></div>
							</div>
						</div>
		
						<div class="text-center mt50">
							<a href="/bid/complete" class="btnStyle btnOutline" title="목록">목록</a>
							<a data-toggle="modal" data-target="#resultsReport" class="btnStyle btnSecondary" title="입찰결과 보고서">입찰결과 보고서</a>
<%
	if("A5".equals(biInfo.get("ingTag")) && user.getLoginId().equals(biInfo.get("data.createUser"))){
%>
							<a data-toggle="modal" data-target="#realAmtSave" class="btnStyle btnPrimary" title="실제 계약금액">실제 계약금액
								<i class="fas fa-question-circle toolTipSt ml5">
									<div class="toolTipText" style="width: 480px">
										<ul class="dList">
											<li><div>낙찰 금액과 실제계약금액이 다를 경우 실제 계약금액을 입력합니다. </div></li>
											<li><div>실제계약금액과 낙찰금액이 같을 경우 입력하지 않아도 됩니다. </div></li>
											<li><div class="textHighlight">낙찰금액과 실제계약금액이 다를 경우 클릭하여 실제 계약금액을 입력해 주십시오. </div></li>
										</ul>
									</div>
								</i>
							</a>
<%
	}
%>
						</div>
					</div>
				</div>
				<!-- //contents -->
		
				<!-- 실제 계약금액 -->
				<div class="modal fade modalStyle" id="realAmtSave" tabindex="-1" role="dialog" aria-hidden="true">
					<div class="modal-dialog" style="width: 100%; max-width: 550px">
						<div class="modal-content">
							<div class="modal-body">
								<a href="javascript:return false;" class="ModalClose" data-dismiss="modal" title="닫기">
									<i class="fa-solid fa-xmark"></i>
								</a>
								<h2 class="modalTitle">실제 계약금액</h2>
								<div class="modalTopBox">
									<ul>
										<li>
										<div>
											낙찰금액과 실제계약금액이 다를 경우 실제계약금액을 작성해 주십시오
										</div>
										</li>
									</ul>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px" style="padding-left:20px;">실제계약금액</div>
									<div class="width100">
										<input type="text" class="inputStyle inputSm" id="realAmt" placeholder="숫자만 입력" onkeyup="javascript:fnComma(this)"/>
									</div>
								</div>
								<div class="modalFooter">
									<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
									<a class="modalBtnCheck" data-toggle="modal" title="저장" onclick="fnSaveConfirm()">저장</a>
								</div>
							</div>
						</div>
					</div>
				</div>
		
				<!--입찰결과보고서-->
				<jsp:include page="/WEB-INF/jsp/bid/bidResultReport.jsp">
					<jsp:param name="title" value="입찰결과 보고서" />
				</jsp:include>
				<!-- 입찰이력 -->
				<jsp:include page="/WEB-INF/jsp/bid/bidSubmitHistoryPop.jsp" />
				<!--// 입찰이력 끝 -->
				<!-- 협력사 사용자 -->
				<div class="modal fade modalStyle" id="custUserPop" tabindex="-1" role="dialog" aria-hidden="true">
					<div class="modal-dialog" style="width:100%; max-width:1100px">
						<div class="modal-content">
							<div class="modal-body">
								<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
								<h2 class="modalTitle">협력사 사용자</h2>
								
								<div class="modalSearchBox mt20">
									<div class="flex align-items-center">
										<div class="sbTit mr30">사용자명</div>
										<div class="width150px">
											<input type="hidden" id="srcCustCode">
											<input type="text" id="srcCustUserNm" class="inputStyle" autocomplete="off">
										</div> 
										<div class="sbTit mr30 ml50">로그인 ID</div>
										<div class="width150px">
											<input type="text" id="srcCustLogin" class="inputStyle" autocomplete="off">
										</div>
										<a onclick="fnDetailBi('')" class="btnStyle btnSearch">검색</a>
									</div>
								</div>
								<table class="tblSkin1 mt30" id="custUserListTbl">
									<colgroup>
										<col>
									</colgroup>
									<thead>
									<tr>
										<th>사용자명</th>
										<th>로그인ID</th>
										<th>부서</th>
										<th>직급</th>
										<th>이메일</th>
										<th>전화번호</th>
										<th>휴대폰</th>
										<th>권한</th>
									</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
								<div class="modalFooter">
									<a class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
								</div>
							</div>				
						</div>
					</div>
				</div>
				<!-- //협력사 사용자 -->
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
