<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="org.apache.poi.hpsf.Decimal"%>
<%@page import="java.util.List"%>
<%@page import="bitcube.framework.ebid.etc.util.CommonUtils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.Map"%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
<%
		Map<String, Object> biInfo = (Map<String, Object>) request.getAttribute("biInfo");
		List<Map<String, Object>> custList = (List<Map<String, Object>>) biInfo.get("custList");
		
		String title = (String) request.getParameter("title");
		String flag = "";
		if(request.getParameter("flag") != null && !"".equals(request.getParameter("flag"))){
			flag = request.getParameter("flag");
		}
%>
	<script>
		$(document).ready(function() {
			$("#popBiModeDiv").text(Ft.ftBiMode("<%=biInfo.get("biMode")%>"));
		});
	</script>
		<!-- 입찰결과 보고서 -->
	<div class="modal fade modalStyle printDiv" id="resultsReport" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:800px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle"><%= title %></h2>
					<h4 class="h4Tit mt20">입찰정보</h4>
					<div class="modalBoxSt mt10">
						<div class="flex align-items-center">
							<div class="formTit flex-shrink0 width170px">입찰번호</div>
							<div class="width100"><%= biInfo.get("biNo") %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">입찰명</div>
							<div class="width100"><%= biInfo.get("biName") %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">입찰방식</div>
							<div class="width100" id="popBiModeDiv"></div>
						</div>
<%
	if(!"".equals(flag)){
%>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">입찰참가자격</div>
							<div class="width100"><%= biInfo.get("bidJoinSpec") %></div>
						</div>
<%
	}
%>
						<div class="flex mt10">
							<div class="formTit flex-shrink0 width170px">특수조건</div>
							<div class="width100">
								<pre style="background-color: white;"><%= biInfo.get("specialCond") %></pre>
							</div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">현장설명일시</div>
							<div class="width100"><%= biInfo.get("spotDate") %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">현장설명장소</div>
							<div class="width100"><%= biInfo.get("spotArea") %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">낙찰자결정방법</div>
							<div class="width100"><%= biInfo.get("succDeciMeth") %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">입찰일시</div>
							<div class="width100"><%= biInfo.get("estStartDate") %> ~ <%= biInfo.get("estCloseDate") %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">납품조건</div>
							<div class="width100"><%= biInfo.get("supplyCond") %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">금액기준</div>
							<div class="width100"><%= biInfo.get("amtBasis") %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">예산금액</div>
							<div class="width100"><%= CommonUtils.getFormatNumber(CommonUtils.getString(biInfo.get("bdAmt"))) %> 원</div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">입찰담당자</div>
							<div class="width100"><%= biInfo.get("damdangName") %></div>
						</div>
					</div>

					<h4 class="h4Tit mt20">투찰 내역</h4>
					<table class="tblSkin1 mt10">
						<colgroup>
							<col style="">
						</colgroup>
						<thead>
							<tr>
								<th>순위</th>
								<th>업체명</th>
								<th>대표자</th>
								<th>낙찰금액</th>
								<th>예산대비</th>
								<th class="end">구분</th>
							</tr>
						</thead>
						<tbody>
<%
	for(int i = 0; i < custList.size(); i++){
		BigDecimal bdAmt = (BigDecimal) biInfo.get("bdAmt") != null ? (BigDecimal) biInfo.get("bdAmt") : BigDecimal.ZERO;
		BigDecimal esmtAmt = (BigDecimal) custList.get(i).get("esmtAmt") != null ? (BigDecimal) custList.get(i).get("esmtAmt") : BigDecimal.ZERO;
		
		BigDecimal result = BigDecimal.ZERO.setScale(1, RoundingMode.HALF_UP);
		if(bdAmt.compareTo(BigDecimal.ZERO) > 0 && esmtAmt.compareTo(BigDecimal.ZERO) > 0){
			result = bdAmt.subtract(bdAmt.subtract(esmtAmt))
					.divide(bdAmt, 3, RoundingMode.HALF_UP)
					.multiply(new BigDecimal("100"))
					.setScale(1, RoundingMode.HALF_UP);
		}
		String  resultStr = result + "%";
%>
							<tr>
								<td><%= i+1 %></td>
								<td class="text-left"><%= custList.get(i).get("custName") %></td>
								<td><%= custList.get(i).get("presName") %></td>
								<td class="text-right"><%= CommonUtils.getString(custList.get(i).get("esmtCurr")) %> <%= CommonUtils.getFormatNumber(CommonUtils.getString(custList.get(i).get("esmtAmt"))) %></td>
								<td class="text-right"><%= resultStr %></td>
								<td class="end"><%= ("Y".equals(custList.get(i).get("succYn")) ? "낙찰" : "") %></td>
							</tr>

<%
	}
%>
						</tbody>
					</table>

					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
						<a @click="fnPrint" class="modalBtnCheck" title="인쇄하기">인쇄하기</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- //입찰결과 보고서 -->
</body>
</html>
