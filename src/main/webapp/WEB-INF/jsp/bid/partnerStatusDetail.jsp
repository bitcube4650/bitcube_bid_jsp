<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
<%
	Map<String, Object> biInfo = (Map<String, Object>) request.getAttribute("biInfo");

	List<Map<String, Object>> specInput = (List<Map<String, Object>>) biInfo.get("specInput") != null ? (List<Map<String, Object>>) biInfo.get("specInput") : new ArrayList() ;

	DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

	// 현재 날짜와 시간을 LocalDateTime으로 가져옴
	LocalDateTime now = LocalDateTime.now();
	LocalDateTime estCloseDate = LocalDateTime.parse(CommonUtils.getString(biInfo.get("estCloseDate")), dateFormat);
	
	boolean esmtPossible = now.compareTo(estCloseDate) > 0 ? false : true;
%>
	<script>
		$(document).ready(function() {
			$("#biMode").text(Ft.ftBiMode('<%= CommonUtils.getString(biInfo.get("biMode")) %>'));
			
			fnCurrList();
		});
		
		function fnCurrList(){
			$.post(
				'/api/v1/bidPtStatus/currList',
				{}
			).done(function(arg){
				if(arg.code == 'fail'){
					Swal.fire('', arg.msg, 'error');
				} else {
					let result = arg.data;
					
					let str = "";
					if(result.length > 0){
						for(let i = 0; i < result.length; i++){
							str += "<option value='"+result[i].codeVal+"'>"+result[i].codeName+"</option>"
						}
					}
					$("#esmtCurr").html(str)
				}
			})
		}
		
		// 금액 한글 표기
		function fnAmtStr(){
			if(event.target.value.length > 0){
				let number = Number(event.target.value);
				
				// 숫자 외의 문자가 들어간 경우 공백문자 처리
				if(isNaN(number)){
					$("#amtStr").val("")
					return;
				}
				
				const units = ["", "십", "백", "천"];
				const bigUnits = ["", "만", "억", "조", "경"];
				const digits = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"];

				let korean = "";
				let numStr = number.toString();
				let len = numStr.length;

				for (let i = 0; i < len; i++) {
					let digit = parseInt(numStr[i], 10);
					let unitIndex = (len - 1 - i) % 4;
					let bigUnitIndex = Math.floor((len - 1 - i) / 4);

					if (digit > 0) {
						korean += digits[digit] + units[unitIndex];
					}

					if (unitIndex === 0 && korean.length > 0) {
						korean += bigUnits[bigUnitIndex] + " ";
					}
				}

				// '일십', '일백', '일천'에서 '일' 생략
				korean = korean.replace(/일(?=십|백|천)/g, "");

				$("#amtStr").val(korean);
			}
		}
		
		// 견적금액
		function fnTotalAmt(){
			let total = 0;			// 총 견적금액
			
			for(let i = 0; i < <%=specInput.size()%>; i++){
				let esmtUc = $("#submitData_"+i+"_input").val().toString();			// 견적금액
				esmtUc = esmtUc.replace(/[^-0-9]/g, '');
				
				total += Number(esmtUc)
				
				$("#submitData_"+i+"_span").text(Ft.ftCalcOrderUc(esmtUc, $("#submitData_"+i+"_orderQty").val()) )		// 견적단가
			}
			
			$("#totalAmt").val(Ft.ftRoundComma(total))
		}
		
		function fnAlert(){
			Swal.fire('', '재입찰 대상이아닙니다.', 'error');
			return;
		}
		
		function fnValid(insMode){
			if(insMode == '1'){							// 파일등록
				let esmtCurr =  $("#esmtCurr").val();
				let amt = $("#amt").val();
				
				if(esmtCurr == ''){
					Swal.fire('', '견적금액 단위를 선택해주세요.', 'warning');
					return false;
				}
				if(amt == ''){
					Swal.fire('', '견적금액을 입력해주세요.', 'warning');
					return false;
				}
				
				// 견적첨부파일
				let files = document.getElementById('file-input').files;
				if(files.length == 0){
					Swal.fire('', '견적내역파일을 등록해주세요.', 'warning');
					return false;
				}
				
			} else if (insMode == '2'){					// 직접등록

				if(esmtCurr == ''){
					Swal.fire('', '견적금액 단위를 선택해주세요.', 'warning');
					return false;
				}

				let bool = false
				for(let i = 0; i < <%= specInput.size() %>; i++){
					let esmtUc = $("#submitData_"+i+"_input").val();
					if(esmtUc != '' && esmtUc != null){
					} else {
						bool = true;
						break;
					}
				}
				
				if(bool){
					Swal.fire('', '품목의 견적금액을 모두 입력해주세요.', 'warning');
					return false;
				}
			}
			
			return true;
		}
		
		// 견적서 제출
		function fnCheck(){
			const insMode = "<%= biInfo.get("insMode")%>";
			
			if(!fnValid(insMode)) return;			// 유효성체크
			
			const now = new Date();
			const estCloseDate = new Date("<%= estCloseDate %>");
			const estStartDate = new Date("<%= biInfo.get("estStartDate") %>");
			
			// 현재 시간과 제출시작/마감일시 비교
			if(estStartDate.getTime() > now.getTime() || estCloseDate.getTime() < now.getTime()){
				Swal.fire('', '견적제출시간이 아닙니다.<br>제출시작일시 및 제출마감일시를 확인해주세요.', 'warning');
				return;
			}

			let amt = $("#esmtCurr").val() + " " + Ft.numberWithCommas((insMode == '1' ? $("#amt").val() : $("#totalAmt").val()));

			Swal.fire({
				type : 'info',
				icon : 'info',
				text : "총 견적금액 "+ amt +" 으로 견적서를 제출하시겠습니까?",
				showCancelButton : true,
				confirmButtonText : '투찰',
				cancelButtonText : '취소',
			}).then((result) => {
				if (result.isConfirmed) {
					fnSign();
				}
			})
		}
		
		function fnSign(){
			var src = $("#src").val();
			if (src == "") {
				Swal.fire("", "서명할 원문이 없습니다.", "warning");
				return;
			}

			unisign.SignDataNonEnveloped( src, null, "", function( resultObject ) {
				$("#signed_data").val(resultObject.signedData);
				if( !resultObject || resultObject.resultCode != 0 ) {
					alert( resultObject.resultMessage + "\n오류코드 : " + resultObject.resultCode );
					return;
				} else {
					// 공동인증서 인증 내부로직 
					unisign.GetRValueFromKey(resultObject.certAttrs.subjectName, "", function( resultObject2 ) {
						if( !resultObject2 || resultObject2.resultCode != 0 ) {
							alert( resultObject2.resultMessage + "\n오류코드 : " + resultObject2.resultCode );
							return;
						} else {
							let validFrom = resultObject.certAttrs.validateFrom;
							let validTo = resultObject.certAttrs.validateTo;
							
							//인증서 유효기간 체크
							let validDate = fnCheckCertDate(validFrom, validTo);
							
							if(!validDate){
								Swal.fire('','인증서 유효기간이 아닙니다.', 'warning');
								return;
							} else {
								$("#userDn").val(resultObject2.RValue);
								fnSignCallback();
							}
						}
					})
					
				}
			});
			
		}
		
		// 인증서 유효기간 체크
		function fnCheckCertDate(startDate, endDate){
			const currentDate = new Date();
			
			let start = new Date(startDate);
			let end = new Date(endDate);
			if(currentDate < start || end < currentDate ){//인증서 유효기간이 아닌 경우
				return false;
			} else {
				return true;
			}
		}
		
		function fnSignCallback(){
			const insMode = "<%= biInfo.get("insMode")%>";
			
			// 직접입력 data
			let submitArr = new Array();
			let itemData = '';
			for(let i = 0; i < <%= specInput.size() %>; i++){
				let submitObj = new Object();
				
				let esmtUc = $("#submitData_"+i+"_input").val();
				if(esmtUc != '' && esmtUc != null){
					if(i > 0 && itemData.length > 0){
						itemData += '$';
					}
					itemData += i + '=' + esmtUc.replace(/[^-0-9]/g, '');

					submitObj.seq = i+1;
					submitObj.name = $("#submitData_"+i+"_name").val();
					submitObj.unitcode = $("#submitData_"+i+"_unitcode").val();
					submitObj.ssize = $("#submitData_"+i+"_ssize").val();
					submitObj.orderQty = $("#submitData_"+i+"_orderQty").val();
					submitObj.esmtUc = esmtUc.replace(/[^-0-9]/g, '');
					
				}
				submitArr.push(submitObj);
			}
			
			// 총 견적금액
			let totalPrice = '';
			if(insMode == '2'){
				totalPrice = itemData
			} else {
				totalPrice = $("#amt").val().replace(/[^-0-9]/g, '')
			}

			let formData = new FormData();

			let params = {
				biNo : "<%= biInfo.get("biNo") %>",
				submitData : Ft.isEmpty(submitArr) ? "" : submitArr,
				amt : totalPrice,
				certInfo : '',
				esmtCurr : $("#esmtCurr").val(),
				insModeCode : insMode
			}

			formData.append('data', JSON.stringify(params));

			// 견적첨부파일
			let detailFiles = document.getElementById('file-input').files;
			if(detailFiles.length > 0){
				formData.append('detailFile', detailFiles[0]);
			}

			// 기타 첨부파일
			let etcFiles = document.getElementById('file-input2').files;
			if(etcFiles.length > 0){
				formData.append('etcFile', etcFiles[0]);
			}

			$.ajax({
				url : '/api/v1/bidPtStatus/bidSubmitting',
				type : 'POST',
				data : formData,
				processData: false,
				contentType: false,
			}).done(function(arg){
				if (arg.code == "OK") {
					Swal.fire({
						type : 'success',
						icon : 'success',
						text : "투찰했습니다",
						showCancelButton : false,
						confirmButtonText : '확인',
					}).then((result) => {
						if (result.isConfirmed) {
							location.href='/bid/partnerStatus'
						}
					})
				} else if(arg.code == 'LESSTIME'){
					Swal.fire('', '견적제출시간이 아닙니다. 제출시작일시를 확인해주세요.', 'warning');
				} else if(arg.code == 'TIMEOUT'){
					Swal.fire('', '견적제출시간이 지났습니다. 제출마감일시를 확인해주세요.', 'warning');
				} else {
					if(arg.msg !== undefined && arg.msg !== null && arg.msg !== ''){
						Swal.fire('', arg.msg, 'error');
					}else{
						Swal.fire('', '투찰 중 오류가 발생했습니다.', 'error');
					}
				}
			})
		}
		
		// 첨부파일
		function fnFileInputChange(preDivid){
			$("#"+preDivid).innerHTML = '';
			const mainEvent = event.target;
			
			let file = mainEvent.files[0];
			if(file){
				mainEvent.parentElement.style.display = 'none';
				
				const p = document.createElement('p');
				const fileNameSpan = document.createElement('span');
				fileNameSpan.textContent = file.name;
				p.appendChild(fileNameSpan);
				
				const removeButton = document.createElement('button');
				removeButton.className = 'file-remove';
				removeButton.textContent = '삭제';
				removeButton.onclick = function(event) {
					mainEvent.value = ''; 
					$("#"+preDivid).empty();
					mainEvent.parentElement.style.display = '';
				}

				p.appendChild(removeButton);
				
				$("#"+preDivid).append(p);
			}
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
						<li>입찰진행 상세</li>
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
									<div class="width100"><%= CommonUtils.getString(biInfo.get("itemName")) %>
										품목류
									</div>
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
										<div class="overflow-y-scroll boxStSm width100"
											style="height: 100px;">
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
													<th>단위</th>
													<th class="end">수량</th>
												</tr>
											</thead>
											<tbody>

<%
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
%>
										<div class="<%= "1".equals(fileList.get(i).get("fileFlag")) ? "textHighlight" : "" %>">
											<span class="mr20"><%= fileList.get(i).get("fileFlagStr") %></span>
											<a class=textUnderline onclick="fnfileDownload('<%= fileList.get(i).get("filePath") %>', '<%= (fileList.get(i)).get("fileNm") %>')"><%= fileList.get(i).get("fileNm") %></a>
										</div>
<%
	}
%>
									</div>
								</div>
							</div>
<%
	// 견적을 제출 했을 경우
	if("2".equals(biInfo.get("custEsmtYn"))){
%>
							<h3 class="h3Tit mt50">견적 제출 정보</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="flex align-items-center width100">
										<div class="formTit flex-shrink0 width170px">견적제출일시</div>
										<div class="width100"><%= biInfo.get("custEsmtUpdateDate") %></div>
									</div>
								</div>
							</div>
<%
	} else {
%>
							<h3 class="h3Tit mt50">견적 제출</h3>
							<div class="conTopBox mt20">
								<ul class="dList">
									<li>
										<div>견적 제출 후 수정할 수 없으니 꼼꼼히 확인하시고 제출하시기 바랍니다.</div>
									</li>
								</ul>
							</div>
							<div class="boxSt mt20">
<%
		if("2".equals(CommonUtils.getString(biInfo.get("insMode")))){
%>
								<table class="tblSkin1">
									<colgroup>
										<col style="" />
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
		for(int i = 0; i < specInput.size(); i++){
%>
												<tr>
													<td class="text-left">
														<input type="hidden" id="submitData_<%= i %>_name" value="<%= specInput.get(i).get("name") %>">
														<%= specInput.get(i).get("name") %>
													</td>
													<td class="text-left">
														<input type="hidden" id="submitData_<%= i %>_ssize" value="<%= specInput.get(i).get("ssize") %>">
														<%= specInput.get(i).get("ssize") %>
													</td>
													<td class="text-left">
														<input type="hidden" id="submitData_<%= i %>_unitcode" value="<%= specInput.get(i).get("unitcode") %>">
														<%= specInput.get(i).get("unitcode") %>
													</td>
													<td class="text-left">
														<input type="hidden" id="submitData_<%= i %>_orderQty" value="<%= specInput.get(i).get("orderQty") %>">
														<%= CommonUtils.getFormatNumber(CommonUtils.getString(specInput.get(i).get("orderQty"))) %>
													</td>
													<td class="text-right">
														<div class="inputStyle readonly">
															<span id="submitData_<%= i %>_span" v-text="fnCalcOrderUc(val.esmtUc, val.orderQty)"></span>
														</div>
													</td>
													<td class="text-right">
														<input type="text" id="submitData_<%= i %>_input" class="inputStyle inputSm text-right" placeholder="" onkeyup="fnTotalAmt(this)" />
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
											<select class="selectStyle maxWidth140px" id="esmtCurr"></select>
											<input type="text" class="inputStyle readonly ml10" id="totalAmt" readonly />
										</div>
									</div>
								</div>
<%
		} else if("1".equals(CommonUtils.getString(biInfo.get("insMode")))){
%>

								<div class="flex align-items-center width100 mt10">
									<div class="formTit flex-shrink0 width170px">
										견적금액 <span class="star">*</span>
									</div>
									<div class="flex align-items-center width100">
										<select class="selectStyle maxWidth140px" id="esmtCurr"></select>
										<input type="text" class="inputStyle" placeholder="숫자만 입력" style="margin: 0 10px" id="amt" onkeyup="fnAmtStr(this)" />
										<input type="text" class="inputStyle readonly" value="" id="amtStr" readonly />
									</div>
								</div>
								<div class="flex mt10">
									<div class="formTit flex-shrink0 width170px">
										견적내역파일 <span class="star">*</span>
										<!-- 툴팁 -->
										<i class="fas fa-question-circle toolTipSt ml5">
											<div class="toolTipText" style="width: 370px">
												<ul class="dList">
													<li>
														<div>전자입찰 등록서류의 세부내역 파일을 다운받아 내역 작성후 첨부해주십시오</div>
													</li>
													<li class="textHighlight">
														<div>파일형식은 세부내역과 같은 형식으로 작성해 주십시오</div>
													</li>
												</ul>
											</div>
										</i>
										<!-- //툴팁 -->
									</div>
									<div class="width100">
										<!-- 다중파일 업로드 -->
										<div class="upload-boxWrap">
											<div class="upload-box">
												<input type="file" id="file-input" onchange="javascript:fnFileInputChange('preview')">
												<div class="uploadTxt">
													<i class="fa-regular fa-upload"></i>
													<div>
														클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제)<br>파일 최대 10MB (등록 파일 개수 최대 1개)
													</div>
												</div>
											</div>
											<div class="uploadPreview" id="preview"></div>
										</div>
										<!-- //다중파일 업로드 -->
									</div>
								</div>
<%
		}
%>
								<div class="flex mt10">
									<div class="formTit flex-shrink0 width170px">기타첨부</div>
									<div class="width100">
										<!-- 다중파일 업로드 -->
										<div class="upload-boxWrap">
											<div class="upload-box">
												<input type="file" id="file-input2" onchange="javascript:fnFileInputChange('preview2')">
												<div class="uploadTxt">
													<i class="fa-regular fa-upload"></i>
													<div>
														클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제)<br>파일 최대 10MB (등록 파일 개수 최대 1개)
													</div>
												</div>
											</div>
											<div class="uploadPreview" id="preview2" v-if="etcFile"></div>
										</div>
										<!-- //다중파일 업로드 -->
									</div>
								</div>
							</div>
<%
	}
%>
						</div>
						<div class="text-center mt50">
							<a href="/bid/partnerStatus" title="목록" class="btnStyle btnOutline"> 목록 </a>
							<a data-toggle="modal" data-target="#biddingPreview" class="btnStyle btnOutline" title="공고문 미리보기" >공고문 미리보기</a>
<%
	if(esmtPossible && "1".equals(biInfo.get("custEsmtYn")) && ("A1".equals(biInfo.get("ingTag")) || ("A2".equals(biInfo.get("ingTag")) && "Y".equals(biInfo.get("data.custRebidYn"))))){
%>
							<a onclick="fnCheck()" class="btnStyle btnPrimary" title="견적서 제출">견적서 제출</a>
<%
	} else if(esmtPossible && "1".equals(biInfo.get("data.custEsmtYn")) && "A3".equals(biInfo.get("ingTag")) && "N".equals(biInfo.get("custRebidYn")) ){
%>
							<a onclick="fnAlert()" class="btnStyle btnPrimary" style="opacity: 0.5; cursor: not-allowed;" title="견적서 제출">견적서 제출</a>
<%
	}
%>
						</div>
					</div>
				</div>
				<!-- 				공고문 미리보기 팝업 -->
				<!-- 				// 공고문 미리보기 팝업 끝-->
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
