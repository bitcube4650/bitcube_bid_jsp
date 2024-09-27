<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.HashMap"%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
<%
	Map<String, Object> biInfo = (Map<String, Object>) request.getAttribute("biInfo");
	List<Map<String, Object>> custList = (List<Map<String, Object>>) biInfo.get("custList");
%>
	<script>
		$(document).ready(function() {
			$("#biMode").text(Ft.ftBiMode('<%= CommonUtils.getString(biInfo.get("biMode")) %>'));
		});
		
		// 낙찰 확인
		function fnSave(){
			$.post(
				'/api/v1/bidComplete/updBiCustFlag',
				{
					biNo : "<%= biInfo.get("biNo") %>",
					esmtYn : '3'
				}
			).done(function(arg){
				if(arg.code == 'fail'){
					Swal.fire('', arg.msg, 'error');
				} else {
					Swal.fire({
						text : '승인하였습니다',
						icon: "info",
						type : 'info',
						showCancelButton: false,
						confirmButtonText: 'OK'
					}).then((result) => {
						if (result.isConfirmed) {
							location.href="/bid/partnerComplete"
						}
					})
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
				<div class="conHeader">
					<ul class="conHeaderCate">
						<li>전자입찰</li>
						<li>입찰완료 상세</li>
					</ul>
				</div>
				<div class="contents">
					<div class="formWidth">
						<div>
							<h3 class="h3Tit">입찰에 부치는 사람</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="formTit flex-shrink0 width170px">입찰번호</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("biNo")) %></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">입찰명</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("biName")) %></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">품목</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("itemName")) %> 품목류</div>
								</div>
							</div>
							<h3 class="h3Tit mt50">입찰방식 및 낙찰자 결정방법</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="formTit flex-shrink0 width170px">입찰방식</div>
									<div class="width100" id="biMode"></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">낙찰자 결정방법</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("succDeciMeth")) %></div>
								</div>
							</div>
							<h3 class="h3Tit mt50">입찰 참가정보</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="formTit flex-shrink0 width170px">입찰참가자격</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("bidJoinSpec")) %></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">현장설명일시</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("spotDate")) %></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">현장설명장소</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("spotArea")) %></div>
								</div>
								<div class="flex mt20">
									<div class="formTit flex-shrink0 width170px">특수조건</div>
									<div class="width100">
										<div class="overflow-y-scroll boxStSm width100" style="height: 100px;">
											<pre style="background-color: white;"><%= CommonUtils.getString(biInfo.get("specialCond")) %></pre>
										</div>
									</div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">납품조건</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("supplyCond")) %></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">금액기준</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("amtBasis")) %></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">결제조건</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("payCond")) %></div>
								</div>
							</div>
							<h3 class="h3Tit mt50">참고사항</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="flex align-items-center width100">
										<div class="formTit flex-shrink0 width170px">입찰담당자</div>
										<div class="width100"><%= CommonUtils.getString(biInfo.get("damdangName")) %></div>
									</div>
									<div class="flex align-items-center width100 ml80">
										<div class="formTit flex-shrink0 width170px">입찰담당부서</div>
										<div class="width100"><%= CommonUtils.getString(biInfo.get("deptName")) %></div>
									</div>
								</div>
<%
	if("A3".equals(CommonUtils.getString(biInfo.get("ingTag"))) && !"".equals(CommonUtils.getString(biInfo.get("whyA3")))){
%>	
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">재입찰사유</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("whyA3")) %></div>
								</div>
<%
	}
%>
							</div>
							<h3 class="h3Tit mt50">전자입찰 제출 내역</h3>
							<div class="conTopBox mt20">
								<ul class="dList">
									<li><div>세부내역파일을 다운받아 내역 작성 후 제출기한 내 등록해 주시기 바랍니다.</div></li>
									<li><div>첨부파일은 세부내역 작성에 참고 될 자료들입니다.</div></li>
								</ul>
							</div>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="flex align-items-center width100">
										<div class="formTit flex-shrink0 width170px">제출시작일시</div>
										<div class="width100"><%= biInfo.get("estStartDate") %></div>
									</div>
									<div class="flex align-items-center width100 ml80">
										<div class="formTit flex-shrink0 width170px">제출마감일시</div>
										<div class="width100"><%= biInfo.get("estCloseDate") %></div>
									</div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">세부내역</div>
									<div class="width100">
<%
	if("1".equals(CommonUtils.getString(biInfo.get("insMode")))){
		List<Map<String, Object>> specFile = (List<Map<String, Object>>) biInfo.get("specFile");
		
		for(int i = 0; i < specFile.size(); i++){
			String filePath = CommonUtils.getString((specFile.get(i)).get("filePath"));
			if(filePath.indexOf("\\") > -1){
				filePath = filePath.replaceAll("\\\\", "\\\\\\\\");
			}
%>
										<a class="textUnderline" onclick="fnfileDownload('<%= filePath %>', '<%= specFile.get(i).get("fileNm") %>')"><%= specFile.get(i).get("fileNm") %></a>
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
													<th>단위</th>
													<th class="end">수량</th>
												</tr>
											</thead>
											<tbody>

<%
		List<Map<String, Object>> specInput = (List<Map<String, Object>>) biInfo.get("specInput");
		
		for(int i = 0; i < specInput.size(); i++){
%>
												<tr>
													<td class="text-left"><%= specInput.get(i).get("name") %></td>
													<td class="text-left"><%= specInput.get(i).get("ssize") %></td>
													<td class="text-left"><%= specInput.get(i).get("unitcode") %></td>
													<td class="text-right end"><%= CommonUtils.getFormatNumber(CommonUtils.getString(specInput.get(i).get("orderQty"))) %></td>
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
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">첨부파일</div>
									<div class="width100">
<%
	List<Map<String, Object>> fileList = (List<Map<String, Object>>) biInfo.get("fileList");
	for(int i = 0; i < fileList.size(); i++){
		String filePath = CommonUtils.getString((fileList.get(i)).get("filePath"));
		if(filePath.indexOf("\\") > -1){
			filePath = filePath.replaceAll("\\\\", "\\\\\\\\");
		}
%>
											<a class="textUnderline" onclick="fnfileDownload('<%= filePath %>', '<%= (fileList.get(i)).get("fileNm") %>')"><%= fileList.get(i).get("fileNm") %></a>
<%
	}
%>
									</div>
								</div>
							</div>
						</div>
						<h3 class="h3Tit mt50">
							<%= "A5".equals(biInfo.get("ingTag")) && "Y".equals(custList.get(0).get("succYn")) ? "낙찰 정보" : ("A5".equals(biInfo.get("ingTag")) && "N".equals(custList.get(0).get("succYn")) ? "견적 정보" : "유찰") %>
						</h3>
						<div class="conTopBox mt20">
							<ul class="dList">
								<li class="textHighlight">
									<div>
										<%= "A5".equals(biInfo.get("ingTag")) && "Y".equals(custList.get(0).get("succYn")) ? "입찰에 선정 되셨습니다. 입찰에 참여하셨던 내역 정보를 확인해 주십시오." : ("A5".equals(biInfo.get("ingTag")) && "N".equals(custList.get(0).get("succYn")) ? "입찰에 선정되지 못했습니다." : "아쉽게도 이번 입찰에는 선정되지못했습니다. 아래 유찰사유 내용을 확인하십시오.") %>
									</div>
								</li>
							</ul>
						</div>
<%
	// 낙찰
	if("A5".equals(biInfo.get("ingTag"))){
		if("1".equals(CommonUtils.getString(biInfo.get("insMode")))){
			String filePath = CommonUtils.getString(custList.get(0).get("filePath"));
			if(filePath.indexOf("\\") > -1){
				filePath = filePath.replaceAll("\\\\", "\\\\\\\\");
			}
			String etcPath = CommonUtils.getString(custList.get(0).get("etcPath"));
			if(etcPath.indexOf("\\") > -1){
				etcPath = etcPath.replaceAll("\\\\", "\\\\\\\\");
			}
%>
						<div class="boxSt mt20">
							<div class="flex align-items-center width100">
								<div class="formTit flex-shrink0 width170px">
									견적금액 <span class="star">*</span>
								</div>
								<div class="flex align-items-center width100">
									<select class="selectStyle maxWidth140px" disabled>
										<option value=""><%= custList.get(0).get("esmtCurr") %></option>
									</select>
									<input type="text" class="inputStyle text-right readonly maxWidth-max-content ml10" value="<%= CommonUtils.getFormatNumber(CommonUtils.getString(custList.get(0).get("esmtAmt"))) %>" readonly>
								</div>
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">견적내역파일</div>
								<div class="width100">
									<a class="textUnderline" onclick="fnfileDownload('<%= filePath %>', '<%= CommonUtils.getString(custList.get(0).get("fileNm")) %>')"><%= CommonUtils.getString(custList.get(0).get("fileNm")) %></a>
								</div>
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">기타첨부</div>
								<div class="width100">
									<a class="textUnderline" onclick="fnfileDownload('<%= etcPath %>', '<%= CommonUtils.getString(custList.get(0).get("etcFile")) %>')"><%= CommonUtils.getString(custList.get(0).get("etcFile")) %></a>
								</div>
							</div>
<%
			if("Y".equals(custList.get(0).get("succYn"))){
%>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">낙찰 추가 합의사항</div>
								<div class="width100"><%= CommonUtils.getString(biInfo.get("addAccept")) %></div>
							</div>
<%
			}
%>
						</div>
<%
		} else {
%>
						<div class="boxSt mt20">
							<table class="tblSkin1">
								<colgroup>
									<col style="">
								</colgroup>
								<thead>
									<tr>
										<th>품목명</th>
										<th>규격</th>
										<th>단위</th>
										<th>수량</th>
										<th>견적단가</th>
										<th class="end">견적금액</th>
									</tr>
								</thead>
								<tbody>
<%
			List<Map<String, Object>> bidSpec = (List<Map<String, Object>>) custList.get(0).get("bidSpec");
			
			for(int i = 0; i < bidSpec.size(); i++){
				BigDecimal esmtUc = (BigDecimal) bidSpec.get(i).get("esmtUc");
				BigDecimal orderQty = (BigDecimal) bidSpec.get(i).get("orderQty");
				BigDecimal result = esmtUc.divide(orderQty, 2, RoundingMode.HALF_UP);
%>
									<tr>
										<td class="text-left"><%= bidSpec.get(i).get("name") %></td>
										<td class="text-left"><%= bidSpec.get(i).get("ssize") %></td>
										<td class="text-left"><%= bidSpec.get(i).get("unitcode") %></td>
										<td class="text-right"><%= CommonUtils.getFormatNumber(CommonUtils.getString(orderQty)) %></td>
										<td>
											<input type="text" class="inputStyle inputSm text-right readonly" value="<%= CommonUtils.getFormatNumber(CommonUtils.getString(result)) %>" readonly>
										</td>
										<td class="end">
											<input type="text" class="inputStyle inputSm text-right readonly" value="<%= CommonUtils.getFormatNumber(CommonUtils.getString(esmtUc)) %>" readonly>
										</td>
									</tr>
<%
			}
%>
								</tbody>
							</table>
							<div class="flex align-items-center justify-space-end mt10">
								<div class="flex align-items-center">
									<div class="formTit flex-shrink0 mr20">총 견적금액</div>
									<div class="flex align-items-center width100">
										<select class="selectStyle maxWidth140px" disabled>
											<option value=""><%= CommonUtils.getString(custList.get(0).get("esmtCurr")) %></option>
										</select>
										<input type="text" class="inputStyle text-right readonly maxWidth-max-content ml10" value="<%= CommonUtils.getFormatNumber(CommonUtils.getString(custList.get(0).get("esmtAmt"))) %>" readonly>
									</div>
								</div>
							</div>

							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">기타첨부</div>
								<div class="width100">
									<a class="textUnderline"><%= CommonUtils.getString(custList.get(0).get("etcFile")) %></a>
								</div>
							</div>
<%
			if("Y".equals(custList.get(0).get("succYn"))){
%>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">낙찰 추가 합의사항</div>
								<div class="width100"><%= CommonUtils.getString(biInfo.get("addAccept")) %></div>
							</div>
						</div>
<%
			}
		}
	} else if("A7".equals(biInfo.get("ingTag"))){
%>
							<div class="boxSt mt20">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">유찰사유</div>
									<div class="width100"><%= CommonUtils.getString(biInfo.get("whyA7")) %></div>
								</div>
							</div>
<%
	}
%>
						<div class="text-center mt50">
							<a href="/bid/partnerComplete" title="목록" class="btnStyle btnOutline">목록</a>
<%
	if("A5".equals(biInfo.get("ingTag")) && "Y".equals(custList.get(0).get("succYn")) && "2".equals(custList.get(0).get("esmtYn"))){
%>
							<a data-toggle="modal" data-target="#biddingCheck" class="btnStyle btnPrimary" title="낙찰확인">낙찰확인</a>
<%
	}
%>
						</div>
					</div>
				</div>
			</div>

			<!-- 낙찰확인 -->
			<div class="modal fade modalStyle" id="biddingCheck" tabindex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog" style="width: 100%; max-width: 420px">
					<div class="modal-content">
						<div class="modal-body">
							<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
							<div class="alertText2">
								본 입찰의 업체선정 됨을 확인합니다.<br>낙찰된 건에 대해 승인하시겠습니까?
							</div>
							<div class="modalFooter">
								<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
								<a class="modalBtnCheck" data-toggle="modal" title="승인" onclick="fnSave()">승인</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- //낙찰확인 -->
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
