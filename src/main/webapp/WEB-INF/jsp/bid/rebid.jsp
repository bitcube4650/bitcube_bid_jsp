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
	String							reCustCodeStr = CommonUtils.getString(request.getAttribute("reCustCode"));
	Map<String, Object>				data = (Map<String, Object>) request.getAttribute("biInfo");
	ArrayList<Map<String, Object>>	custList = new ArrayList<Map<String, Object>>();
									custList = (ArrayList) data.get("custList");
	ObjectMapper					objectMapper = new ObjectMapper();
	String							jsonCustList = objectMapper.writeValueAsString(custList);
	String							jsonData = objectMapper.writeValueAsString(data);
	
	String							spotDate = CommonUtils.getString(data.get("spotDate"));
	String							estStartDate = CommonUtils.getString(data.get("estStartDate"));
	String							estCloseDate = CommonUtils.getString(data.get("estCloseDate"));
	String							spotDay = spotDate.substring(0, 10);
	String							spotTime = spotDate.substring(11, 16);
	String							estStartDay = estStartDate.substring(0, 10);
	String							estStartTime = estStartDate.substring(11, 16);
	String							estCloseDay = estCloseDate.substring(0, 10);
	String							estCloseTime = estCloseDate.substring(11, 16);
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
			$("#estCloseDay").datepicker();
			
			var bdAmtValue = "<%= CommonUtils.getString(data.get("bdAmt")) %>";
			$("#bdAmt").val(Ft.ftRoundComma(bdAmtValue));
			
			var estCloseTime = "<%= estCloseTime %>";
			$("#estCloseTime").val(estCloseTime);
		}
		
		function onMovePage() {
			
		}
		
		function onValidation() {
			
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
						<li>재입찰</li>
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
							<div class="flex align-items-center mt10">
								<div class="formTit flex-shrink0 width170px">입찰명</div>
								<div class="width100">
									<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("biName")) %>" maxLength="50" disabled/>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="formTit flex-shrink0 width170px">품목</div>
								<div class="flex align-items-center width100">
									<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("itemName")) %>" disabled/>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰방식</div>
								<div class="width100">
									<input type="radio" class="radioStyle" checked id="bm1_1" />
									<label for="bm1_1">지명경쟁입찰</label>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰참가자격</div>
								<div class="width100">
									<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("bidJoinSpec")) %>" disabled/>
								</div>
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">특수조건</div>
								<div class="width100">
									<div class="width100">
										<textarea class="textareaStyle boxOverflowY" disabled><%= CommonUtils.getString(data.get("specialCond")) %></textarea>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">현장설명일시</div>
								<div class="width100">
									<input type="text" class="inputStyle maxWidth140px" value="<%= spotDay %>" disabled />
									<input type="time" class="inputStyle maxWidth140px ml10" value="<%= spotTime %>" disabled />
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="formTit flex-shrink0 width170px">현장설명장소</div>
								<div class="width100">
									<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("spotArea")) %>" disabled/>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="formTit flex-shrink0 width170px">낙찰자결정방법</div>
								<div class="width100">
									<input type="text" class="inputStyle maxWidth200px" value="<%= CommonUtils.getString(data.get("succDeciMeth")) %>" disabled/>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰참가업체</div>
								<div class="flex align-items-center width100">
									<div class="overflow-y-scroll boxStSm width100" style="display: inline" >
										<div>
											<div>
												<a>참가업체1 , 참가업체 2, 참가업체 3, 작업 해야됨.</a>
												<span>,</span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">금액기준</div>
								<div class="width100">
									<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("amtBasis")) %>" disabled/>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="formTit flex-shrink0 width170px">결제조건</div>
								<div class="width100">
									<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("payCond")) %>" disabled/>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="formTit flex-shrink0 width170px">예산금액</div>
								<div class="flex align-items-center width100">
									<input type="text" class="inputStyle maxWidth200px" id="bdAmt" disabled/>
									<div class="ml10">원</div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">입찰담당자</div>
									<div class="width100"><%= CommonUtils.getString(data.get("damdangName")) %></div>
								</div>
							</div>
						</div>
						
						<% if("02".equals(CommonUtils.getString(data.get("interrelatedCustCode")))) { %>
						<h3 class="h3Tit mt50" >입찰분류</h3>
						<div class="boxSt mt20" >
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">분류군</div>
								<div class="flex align-items-center width100">
									<input type="text" class="selectStyle" value="<%= CommonUtils.getString(data.get("matDept")) %>" disabled/>
									<input type="text" class="selectStyle ml5" value="<%= CommonUtils.getString(data.get("matProc")) %>" disabled/>
									<input type="text" class="selectStyle ml5" value="<%= CommonUtils.getString(data.get("matCls")) %>" disabled/>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="formTit flex-shrink0 width170px">공장동</div>
								<div class="width100">
									<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("matFactory")) %>" disabled/>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">라인</div>
									<div class="width100">
										<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("matFactoryLine")) %>" disabled/>
									</div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">호기</div>
									<div class="width100">
										<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("matFactoryCnt")) %>" disabled/>
									</div>
								</div>
							</div>
						</div>
						<% } %>
						
						<h3 class="h3Tit mt50">입찰공고 추가등록 사항</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">제출시작일시</div>
									<div class="flex align-items-center width100">
										<input type="text" class="inputStyle readonly" value="<%= estStartDay %>" disabled />
										<input type="time" class="readonly inputStyle ml10" value="<%= estStartTime %>" disabled />
									</div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">제출마감일시 <span class="star">*</span></div>
									<div class="flex align-items-center width100">
										<input type="text" class="datepicker inputStyle" id="estCloseDay" value="<%= estCloseDay %>">
										<select class="inputStyle ml10" id="estCloseTime" style="background:url('/images/selectArw.png') no-repeat right 15px center;maxWidth: 110px;" >
											<option value="">시간 선택</option>
											<option value="01:00">01:00</option>
											<option value="02:00">02:00</option>
											<option value="03:00">03:00</option>
											<option value="04:00">04:00</option>
											<option value="05:00">05:00</option>
											<option value="06:00">06:00</option>
											<option value="07:00">07:00</option>
											<option value="08:00">08:00</option>
											<option value="09:00">09:00</option>
											<option value="10:00">10:00</option>
											<option value="11:00">11:00</option>
											<option value="12:00">12:00</option>
											<option value="13:00">13:00</option>
											<option value="14:00">14:00</option>
											<option value="15:00">15:00</option>
											<option value="16:00">16:00</option>
											<option value="17:00">17:00</option>
											<option value="18:00">18:00</option>
											<option value="19:00">19:00</option>
											<option value="20:00">20:00</option>
											<option value="21:00">21:00</option>
											<option value="22:00">22:00</option>
											<option value="23:00">23:00</option>
										</select>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">개찰자</div>
									<div class="flex align-items-center width100">
										<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("estOpener")) %>" disabled/>
									</div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">입찰공고자</div>
									<div class="flex align-items-center width100">
										<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("gongoName")) %>" disabled/>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">낙찰자</div>
									<div class="flex align-items-center width270px">
										<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("estBidder")) %>" disabled/>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">입회자1</div>
									<div class="flex align-items-center width100">
										<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("openAtt1")) %>" disabled/>
									</div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">입회자2</div>
									<div class="flex align-items-center width100">
										<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("openAtt2")) %>" disabled/>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt10">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">내역방식</div>
									<div class="width100">
										<input type="radio" name="bm2" id="bm2_1" class="radioStyle" checked />
										<label for="bm2_1"><%= "1".equals(CommonUtils.getString(data.get("insMode"))) ? "파일등록" : "직접입력" %></label>
									</div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">납품조건</div>
									<div class="width100">
										<input type="text" class="inputStyle" value="<%= CommonUtils.getString(data.get("supplyCond")) %>" disabled/>
									</div>
								</div>
							</div>
							<% if("1".equals(CommonUtils.getString(data.get("insMode")))) { %>
							<div class="flex mt10">
								<div class="formTit flex-shrink0 width170px">세부내역
									<i class="fas fa-question-circle toolTipSt ml5">
										<div class="toolTipText" style="width: 370px">
											<ul class="dList">
												<li><div>내역방식이 파일등록 일 경우 필수로 파일을 등록해야합니다.</div></li>
												<li><div>파일이 암호화 되어 있는지 확인해 주십시오</div></li>
											</ul>
										</div>
									</i>
								</div>
								<div class="width100">
									<div class="upload-boxWrap">
										<div class="upload-box">
											<div class="uploadTxt">
												<%
												List<Map<String, Object>> specFile = (List<Map<String, Object>>) data.get("specFile");
												for(int i = 0; i < specFile.size(); i++){
												%>
												<i class="fa-regular fa-upload"></i> 
												<div><%= (specFile.get(i)).get("fileNm") %></div>
												<% } %>
											</div>
										</div>
									<div class="uploadPreview" id="preview"></div>
									</div>
								</div>
							</div>
							<% } %>
							<% if("2".equals(CommonUtils.getString(data.get("insMode")))) { %>
							<div class="flex mt10">
								<div class="formTit flex-shrink0 width170px">세부내역 <span class="star">*</span>
								</div>
								<div class="width100">
									<table class="tblSkin1">
										<colgroup>
											<col style="width:17%" />
											<col style="width:16%" />
											<col style="width:16%" />
											<col style="width:16%" />
											<col style="width:17%" />
											<col style="width:18%" />
										</colgroup>
										<thead>
											<tr>
												<th>품목명</th>
												<th>규격</th>
												<th>수량</th>
												<th>단위</th>
												<th>예정단가</th>
												<th classclassName="end">합계</th>
											</tr>
										</thead>
										<tbody>
											<%
											List<Map<String, Object>> specInput = (List<Map<String, Object>>) data.get("specInput");
											for(int i = 0; i < specInput.size(); i++){
												BigDecimal orderQty = new BigDecimal(CommonUtils.getInt(specInput.get(i).get("orderQty")));
												BigDecimal orderUc = new BigDecimal(CommonUtils.getInt(specInput.get(i).get("orderUc")));
											%>
											<tr>
												<td><input type="text" class="inputStyle inputSm" value="<%= CommonUtils.getString(specInput.get(i).get("name")) %>" disabled/> </td>
												<td><input type="text" class="inputStyle inputSm" value="<%= CommonUtils.getString(specInput.get(i).get("ssize")) %>" disabled/></td>
												<td><input type="text" class="inputStyle inputSm" value="<%= CommonUtils.getString(specInput.get(i).get("orderQty")) %>" disabled/></td>
												<td><input type="text" class="inputStyle inputSm" value="<%= CommonUtils.getString(specInput.get(i).get("unitcode")) %>" disabled/></td>
												<td><input type="text" class="inputStyle inputSm text-right" value="<%= CommonUtils.getString(specInput.get(i).get("orderUc")) %>" disabled/></td>
												<td class="text-right"><%= CommonUtils.numberWithCommas(orderQty.multiply(orderUc)) %></td>
											</tr>
											<% } %>
										</tbody>
									</table>
									<p class="text-right mt10">
										<strong id="specInput"></strong>
									</p>
								</div>
							</div>
							<% } %>
							
							<div class="flex mt10">
								<div class="formTit flex-shrink0 width170px">첨부파일(대내용)
									<i class="fas fa-question-circle toolTipSt ml5">
										<div class="toolTipText" style="width: 320px">
											<ul class="dList">
												<li><div>그룹사 내부 입찰관계자가 확인하는 첨부파일 입니다.</div></li>
												<li><div>파일이 암호화 되어 있는지 확인해 주십시오</div></li>
											</ul>
										</div>
									</i>
								</div>
								<div class="width100">
									<div class="upload-boxWrap">
										<div class="upload-box">
											<div class="uploadTxt">
												<%
												List<Map<String, Object>> fileList = (List<Map<String, Object>>) data.get("fileList");
												for(Map<String, Object> fileMap : fileList){
												%>
													<%
													if("0".equals(CommonUtils.getString(fileMap.get("fileFlag")))) {
													%>
												<i class="fa-regular fa-upload"></i><div><%= CommonUtils.getString(fileMap.get("fileNm")) %></div>
													<% } %>
												<% } %>
											</div>
										</div>
										<div class="uploadPreview" id="preview2"></div>
									</div>
								</div>
							</div>
							<div class="flex mt10">
								<div class="formTit flex-shrink0 width170px">첨부파일(대외용)
									<i class="fas fa-question-circle toolTipSt ml5">
										<div class="toolTipText" style="width: 300px">
											<ul class="dList">
												<li><div>입찰 참가업체들이 확인하는 첨부파일 입니다.</div></li>
												<li><div>파일이 암호화 되어 있는지 확인해 주십시오</div></li>
											</ul>
										</div>
									</i>
								</div>
								<div class="width100">
									<div class="upload-boxWrap">
										<div class="upload-box">
											<div class="uploadTxt">
												<%
												for(Map<String, Object> fileMap : fileList){
												%>
													<%
													if("1".equals(CommonUtils.getString(fileMap.get("fileFlag")))) {
													%>
												<i class="fa-regular fa-upload"></i><div><%= CommonUtils.getString(fileMap.get("fileNm")) %></div>
													<% } %>
												<% } %>
											</div>
										</div>
										<div class="uploadPreview" id="preview3"></div>
									</div>
								</div>
							</div>
						</div>
						<div class="text-center mt50">
							<a class="btnStyle btnOutline" title="목록" onclick="onMovePage()">목록</a>
							<a onclick="onValidation()" class="btnStyle btnPrimary" title="재입찰">재입찰</a>
						</div>
					</div>
				</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
