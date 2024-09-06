<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%
	Map<String, Object>				data = (Map<String, Object>) request.getAttribute("biInfo");
	ArrayList<Map<String, Object>>	custList = new ArrayList<Map<String, Object>>();
									custList = (ArrayList) data.get("custList");
%>
<!DOCTYPE html>
<script>
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
	
	function onPrint() {
		var printContents = document.getElementById('bidBiddingPreviewPop').innerHTML;  // 모달 내용 가져오기
		var originalContents = document.body.innerHTML;  // 전체 페이지 내용 저장

		// 임시로 body 내용을 모달 내용으로 변경
		document.body.innerHTML = printContents;

		// 프린트 실행
		window.print();

		// 원래 페이지로 복구
		document.body.innerHTML = originalContents;
	}
	
</script>
<div class="modal fade modalStyle" id="bidBiddingPreviewPop" data-backdrop="static" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:800px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">입찰공고</h2>
					<h4 class="h4Tit mt20">가. 입찰에 부치는 사항</h4>
					<div class="modalBoxSt mt10">
						<div class="flex align-items-center">
							<div class="formTit flex-shrink0 width170px">입찰번호</div>
							<div class="width100"><%= CommonUtils.getString(data.get("biNo")) %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">입찰명</div>
							<div style="width:'550px';wordWrap: break-word;"><%= CommonUtils.getString(data.get("biName")) %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">품명</div>
							<div class="width100"><%= CommonUtils.getString(data.get("itemName")) %> 품목류</div>
						</div>
					</div>
					
					<h4 class="h4Tit mt20">나. 입찰 및 낙찰자 결정방식</h4>
					<div class="modalBoxSt mt10">
						<div class="flex align-items-center">
							<div class="formTit flex-shrink0 width170px">입찰방식</div>
							<div class="width100"><%= CommonUtils.getString(data.get("biMode")).equals("A") ? "지명경쟁입찰" : "일반경쟁입찰" %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">낙찰자결정방법</div>
							<div class="width100"><%= CommonUtils.getString(data.get("succDeciMeth")) %></div>
						</div>
					</div>
					
					<h4 class="h4Tit mt20">다. 입찰참가정보</h4>
					<div class="modalBoxSt mt10">
						<div class="flex align-items-center">
							<div class="formTit flex-shrink0 width170px">입찰참가자격</div>
							<div style="width: 550px; wordWrap: break-word"><%= CommonUtils.getString(data.get("bidJoinSpec")) %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">현장설명일시</div>
							<div style="width: 550px; wordWrap: break-word"><%= CommonUtils.getString(data.get("spotDate")) %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">현장설명장소</div>
							<div style="width: 550px; wordWrap: break-word"><%= CommonUtils.getString(data.get("spotArea")) %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">특수조건</div>
							<div style="width: 550px; wordWrap: break-word">
								<pre style="backgroundColor: white "><%= CommonUtils.getString(data.get("specialCond")) %></pre>
							</div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">납품조건</div>
							<div style="width: 550px; wordWrap: break-word"><%= CommonUtils.getString(data.get("supplyCond")) %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">금액기준</div>
							<div class="width100"><%= CommonUtils.getString(data.get("amtBasis")) %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">결제조건</div>
							<div style="width: 550px; wordWrap: break-word"><%= CommonUtils.getString(data.get("payCond")) %></div>
						</div>
					</div>
					
					<h4 class="h4Tit mt20">라. 참고사항</h4>
					<div class="modalBoxSt mt10">
						<div class="flex align-items-center">
							<div class="formTit flex-shrink0 width170px">입찰담당자</div>
							<div class="width100"><%= CommonUtils.getString(data.get("damdangName")).equals("") ? CommonUtils.getString(data.get("cuser")) : CommonUtils.getString(data.get("damdangName")) %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">입찰담당부서</div>
							<div class="width100"><%= CommonUtils.getString(data.get("deptName")) %></div>
						</div>
					</div>
					
					<h4 class="h4Tit mt20">마. 전자입찰 등록서류</h4>
					<div class="modalBoxSt mt10">
						<div class="flex align-items-center">
							<div class="formTit flex-shrink0 width170px">제출시작일시</div>
							<div class="width100"><%= CommonUtils.getString(data.get("estStartDate")) %></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">제출마감일시</div>
							<div class="width100"><%= CommonUtils.getString(data.get("estCloseDate")) %></div>
						</div>
						<% if(CommonUtils.getString(data.get("insMode")).equals("2")) { %>
						<div class="flex mt10">
							<div class="formTit flex-shrink0 width170px">세부내역</div>
							<div class="width100">
								<table class="tblSkin1">
									<colgroup>
										<col />
									</colgroup>
									<thead>
										<tr>
											<th>품목명</th>
											<th>규격</th>
											<th>수량</th>
											<th>단위</th>
										</tr>
									</thead>
									<tbody>
									<%
											List<Map<String, Object>> specInput = (List<Map<String, Object>>) data.get("specInput");
											for(int i = 0; i < specInput.size(); i++){
												BigDecimal orderQty = (BigDecimal) specInput.get(i).get("orderQty");
									%>
										<tr>
											<td class="text-left"><%= specInput.get(i).get("name") %></td>
											<td class="text-left"><%= specInput.get(i).get("ssize") %></td>
											<td class="text-right"><%= CommonUtils.getFormatNumber(CommonUtils.getString(specInput.get(i).get("orderQty"))) %></td>
											<td class="text-left"><%= specInput.get(i).get("unitcode") %></td>
										</tr>
									<% } %>
									</tbody>
								</table>
							</div>
						</div>
						<% } %>
						<% if(CommonUtils.getString(data.get("insMode")).equals("1")) { %>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width170px">세부내역</div>
							<div class="width100">
								<%
									List<Map<String, Object>> specFile = (List<Map<String, Object>>) data.get("specFile");
									for(int i = 0; i < specFile.size(); i++) {
								%>
								<div onclick="downloadFile('<%= (specFile.get(i)).get("filePath") %>', '<%= (specFile.get(i)).get("fileNm") %>')">
									<%
										if("K".equals(CommonUtils.getString(specFile.get(i).get("fileFlag")))) {
									%>
										<button class="textUnderline"><%= CommonUtils.getString(specFile.get(i).get("fileNm")) %></button>
									<% } %>
								</div>
								<% } %>
							</div>
						</div>
						<% } %>
				
						<div class="flex mt10">
							<div class="formTit flex-shrink0 width170px">첨부파일</div>
							<div class="width100">
								<%
									List<Map<String, Object>> fileList = (List<Map<String, Object>>) data.get("fileList");
									for(int i = 0; i < fileList.size(); i++) {
								%>
								<div onclick="downloadFile('<%= (fileList.get(i)).get("filePath") %>', '<%= (fileList.get(i)).get("fileNm") %>')">
									<%
										if("1".equals(CommonUtils.getString(fileList.get(i).get("fileFlag")))) {
									%>
									<span>대외용 </span> 
									<button class="textUnderline mt5"><%= CommonUtils.getString(fileList.get(i).get("fileNm")) %></button>
									<% } %>
								</div>
								<% } %>
							</div>
						</div>
					</div>
				
				
					<div class="modalFooter">
						<button class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</button>
						<button class="modalBtnCheck" title="인쇄하기" onclick="onPrint()">인쇄하기</button>
					</div>
				
			</div>
		</div>
	</div>
</div>
