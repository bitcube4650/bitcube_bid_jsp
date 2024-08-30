<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="bitcube.framework.ebid.etc.util.Constances" %>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%@ page import="bitcube.framework.ebid.dto.UserDto" %>
<%
	UserDto userDto = (UserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String custCode = userDto.getCustCode();
	
	Map<String, Object> params = (Map<String, Object>) request.getAttribute("params");
	String flag = CommonUtils.getString(params.get("flag"));
	String flagNm = "";
	if("save".equals(flag)) {
		flagNm = "등록";
	} else {
		flagNm = "수정";
	}
%>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
	<script>
		$(document).ready(function() {
			fnInit();
			
			$("#spotDay").datepicker();
			//minDate={bidContent.minDate}
			
			
			$("input[name='biModeCode']").on('change', function() {
				alert("TEST!!!");
				//onChangeBiModeCode();
			});
			
			$("#spotTime").on('change', function() {
				alert("DFDSFSDF");
				//onChangeBasicInfo();
			});
			
			$("#succDeciMethCode").on('change', function() {
				//onChangeBasicInfo();
			});
		});
		
		function fnInit() {
			var custCode = "<%= custCode%>";
			// 분류군 세팅
			if(custCode == "02") {
				$.post(
					"/api/v1/bid/progressCodeList",
					{
					},
					function(response){
						if(response.code === 'OK') {
							$("#matDept").empty();
							$("#matProc").empty();
							$("#matCls").empty();
							var deptStr = "<option value=''>사업부를 선택 하세요.</option>";
							var procStr = "<option value=''>공정을 선택 하세요.</option>";
							var matStr = "<option value=''>분류를 선택 하세요.</option>";
							
							var list = response.data;
							
							for(var i=0; i<list.length; i++) {
								if(list[i].colCode == "MAT_DEPT") {
									deptStr += "<option value="+ list[i].codeVal +">"+ list[i].codeName +"</option>";
								} else if(list[i].colCode == "MAT_PROC") {
									procStr += "<option value="+ list[i].codeVal +">"+ list[i].codeName +"</option>";
								} else if(list[i].colCode == "MAT_CLS") {
									matStr += "<option value="+ list[i].codeVal +">"+ list[i].codeName +"</option>";
								}
							}
							
							$("#matDept").append(deptStr);
							$("#matProc").append(procStr);
							$("#matCls").append(matStr);
						} else {
							
						}
					},
					"json"
				);
			}
		}
	</script>
	<div>
		<h3 class="h3Tit">입찰 기본 정보</h3>
			<div class="boxSt mt20">
				<div class="flex align-items-center">
					<div class="formTit flex-shrink0 width170px">
						<% if(flagNm.equals("등록")) { %>
							과거입찰
						<% } else { %>
							입찰번호
						<% } %>
					</div>
					<div class="width100">
						<% if(flagNm.equals("등록")) { %>
						<button class="btnStyle btnOutlineBlue" title="과거입찰 가져오기" style="marginLeft:0px" onClick=onBidPastModal()>과거입찰 가져오기</button>
						<% } else { %>
					<div>
<!--						{bidContent.biNo}-->
					</div>
						<% } %>
				</div>
			</div>

			<div class="flex align-items-center mt10">
				<div class="formTit flex-shrink0 width170px">
					입찰명 <span class="star">*</span>
				</div>
				<div class="width100">
					<input type="text" class="inputStyle" name="biName" id="biName" maxlength="10">
				</div>
			</div>

			<div class="flex align-items-center mt10">
				<div class="formTit flex-shrink0 width170px">
					품목 <span class="star">*</span>
				</div>
				<div class="flex align-items-center width100">
					<input type="text" class="inputStyle" name="itemName" id="itemName">
					<button class="btnStyle btnSecondary ml10" title="조회" onClick=onItemPopModal() >조회</button>
				</div>
			</div>

			<div class="flex align-items-center mt20">
				<div class="formTit flex-shrink0 width170px">
					입찰방식 <span class="star">*</span>
				</div>
				<div class="width100">
					<input type="radio" id="bm1_1" name="biModeCode" class="radioStyle" value="invited" />
						<label for="bm1_1">지명경쟁입찰</label>
					<input type="radio" id="bm1_2" name="biModeCode" class="radioStyle" value="general" />
						<label for="bm1_2">일반경쟁입찰</label>
				</div>
			</div>

			<div class="flex align-items-center mt20">
				<div class="formTit flex-shrink0 width170px">
					입찰참가자격 <span class="star">*</span>
				</div>
				<div class="width100">
					<input type="text" class="inputStyle" name="bidJoinSpec" id="bidJoinSpec" maxlength="100" />
				</div>
			</div>

			<div class="flex mt20">
				<div class="formTit flex-shrink0 width170px">특수조건</div>
				<div class="width100">
					<textArea class="textareaStyle notiBox overflow-y-auto boxOverflowY" id="specialCond" name="specialCond">
					</textArea>
				</div>
			</div>
			<div class="flex align-items-center mt20">
				<div class="formTit flex-shrink0 width170px">
					현장설명일시 <span class="star">*</span>
				</div>
				<div class="flex align-items-center width100">
					<input type="text" class="datepicker inputStyle" id="spotDay">
					<select class="inputStyle ml10" name="spotTime" id="spotTime" style="background: url('../../images/selectArw.png') no-repeat right 15px center, maxWidth: 110px">
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
			
			<div class="flex align-items-center mt10">
				<div class="formTit flex-shrink0 width170px">
					현장설명장소 <span class="star">*</span>
				</div>
				<div class="width100">
					<input type="text" class="inputStyle" name="spotArea" id="spotArea" maxlength="100" />
				</div>
			</div>

			<div class="flex align-items-center mt10">
				<div class="formTit flex-shrink0 width170px">
					낙찰자결정방법 <span class="star">*</span>
				</div>
				<div class="width100">
					<select name="succDeciMethCode" id="succDeciMethCode" class="selectStyle maxWidth200px" >
						<option value="1">최저가</option>
						<option value="2">최고가</option>
						<option value="3">내부적격심사</option>
						<option value="4">최고가&내부적격심사</option>
						<option value="5">최저가&내부적격심사</option>
					</select>
				</div>
			</div>
			
			<div class="flex align-items-center mt20">
				<div class="formTit flex-shrink0 width170px">
					입찰참가업체 <span class="star">*</span>
				</div>
				<div class="flex align-items-center width100">
					<div class="overflow-y-scroll boxStSm width100" style="display:'inline'">
						<button>선택된 참가업체 없음</button>
					</div>
				</div>
			</div>
			
			<div class="flex align-items-center mt20">
				<div class="formTit flex-shrink0 width170px">
					금액기준 <span class="star">*</span>
				</div>
				<div class="width100">
					<input type="text" class="inputStyle" name="amtBasis" id="amtBasis" maxlength="100" />
				</div>
			</div>
			
			<div class="flex align-items-center mt10">
				<div class="formTit flex-shrink0 width170px">결제조건</div>
				<div class="width100">
					<input type="text" class="inputStyle" name="payCond" id="payCond" maxlength="50" />
				</div>
			</div>
			<div class="flex align-items-center mt10">
				<div class="formTit flex-shrink0 width170px">예산금액</div>
					<div class="flex align-items-center width100">
						<input type="text" class="inputStyle maxWidth200px" name="bdAmt" id="bdAmt" />
					<div class="ml10">원</div>
				</div>
			</div>
			<div class="flex align-items-center mt20">
				<div class="formTit flex-shrink0 width170px">입찰담당자</div>
				<div class="width100">입찰담당자</div>
			</div>

			<% if(custCode.equals("02")) { %>
		<h3 class="h3Tit mt50" >입찰분류</h3>
			<div class="boxSt mt20" >
				<div class="flex align-items-center">
					<div class="formTit flex-shrink0 width170px">
						분류군 <span class="star">*</span>
					</div>
					<div class="flex align-items-center width100">
						<select name="matDept" id="matDept" class="selectStyle">
						</select>
						<select name="matProc" id="matProc" class="selectStyle" style="margin:0 10px">
						</select>
						<select name="matCls" id="matCls" class="selectStyle" >
						</select>
					</div>
				</div>
				
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width170px">공장동</div>
					<div class="width100">
						<input type="text" class="inputStyle" name="matFactory" id="matFactory" maxlength="50" />
					</div>
				</div>
				
				<div class="flex align-items-center mt10">
					<div class="flex align-items-center width100">
						<div class="formTit flex-shrink0 width170px">라인</div>
						<div class="width100">
							<input type="text" class="inputStyle" name="matFactoryLine" id="matFactoryLine" maxlength="25" />
						</div>
					</div>
					
					<div class="flex align-items-center width100 ml80">
						<div class="formTit flex-shrink0 width170px">호기</div>
						<div class="width100">
							<input type="text" class="inputStyle" name="bidContent" id="bidContent" maxlength="25" />
						</div>
					</div>
				</div>
				
			</div>
			<% } %>

	</div>