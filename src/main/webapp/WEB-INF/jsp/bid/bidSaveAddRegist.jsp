<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="bitcube.framework.ebid.etc.util.Constances" %>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%@ page import="bitcube.framework.ebid.dto.UserDto" %>
<%
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
		});
		
		function fnInit() {
			// 세부내역 case처리
			fnSetInsModeHtml('1');
		}
		
		function onUserListSelect(str){
			alert(str);
			
		}
		
		function onRemoveOpenAtt(openAtt) {
			alert("TEST!!!");
		}
		
		function onChangeInsModeCode(num) {
			Swal.fire({
					title: '내역방식 변경',
					text: '내역방식을 변경하면 이전에 선택한 세부내역이 초기화됩니다.\n 변경 하시겠습니까?',
					icon: 'question',				// success / error / warning / info / question
					confirmButtonColor: '#3085d6',	// 기본옵션
					confirmButtonText: '변경',		// 기본옵션
					showCancelButton: true,			// conrifm 으로 하고싶을떄
					cancelButtonColor: '#d33',		// conrifm 에 나오는 닫기버튼 옵션
					cancelButtonText: '취소'		// conrifm 에 나오는 닫기버튼 옵션
					}).then(result => {
						if (result.isConfirmed) {	// 만약 모달창에서 confirm 버튼을 눌렀다면
							if(num === '1'){
								fnSetInsModeHtml('1');
							} else {
								fnSetInsModeHtml('2');
							}
						} else {
							if(num === '1'){
								$("#bm2_2").prop("checked", true);
							} else {
								$("#bm2_1").prop("checked", true);
							}
						}
					});
		}
		
		function fnSetInsModeHtml(num) {
			$("#sebu").empty();
			var str = "";
			if(num == '1') {
				str += "<i class='fas fa-question-circle toolTipSt ml5'>";
				str += "<div class='toolTipText' style='width: 370px'>";
				str += "<ul class='dList'>";
				str += "<li>";
				str += "<div>";
				str += "내역방식이 파일등록 일 경우 필수로 파일을 등록해야 합니다.";
				str += "</div>";
				str += "</li>";
				str += "<li>";
				str += "<div>파일이 암호화 되어 있는지 확인해 주십시오</div>";
				str += "</li>";
				str += "</ul>";
				str += "</div>";
				str += "</i>";
			} else {
				str += "<button title='추가' class='btnStyle btnSecondary ml10' onClick='onAddRow()'>추가</button>";
			}
			$("#sebu").append(str);
			
			// 세부내역 세팅
			fnSetDetailSet(num);
		}
		
		function onAddRow() {
			alert("TEST!!!!");
		}
		
		function fnSetDetailSet(num) {
			$("#fileTable").empty();
			var str = "";
			if(num == '1') {
				str += "<div class='upload-boxWrap'>";
				str += "<div class='upload-box'>";
				str += "<input type='file' ref='uploadedFile' id='insFile' />";
				str += "<div class='uploadTxt'>";
				str += "<i class='fa-regular fa-upload'></i>";
				str += "<div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제) <br/>파일 최대 10MB (등록 파일 개수 최대 1개)</div>";
				str += "</div>";
				str += "</div>";
				str += "<div class='uploadPreview' id='insFilePreview'></div>";
				str += "</div>";
			} else {
				str += "<table class='tblSkin1'>";
				str += "<colgroup>";
				str += "<col />";
				str += "</colgroup>";
				str += "<thead>";
				str += "<tr>";
				str += "<th>품목명</th>";
				str += "<th>규격</th>";
				str += "<th>단위</th>";
				str += "<th>예정단가</th>";
				str += "<th>수량</th>";
				str += "<th>합계</th>";
				str += "<th class='end''>삭제</th>";
				str += "</tr>";
				str += "</thead>";
				str += "<tbody>";
				str += "<tr>";
				str += "<td><input type='text' name='name' class='inputStyle inputSm' maxlength='100' /></td>";
				str += "<td><input type='text' name='ssize' class='inputStyle inputSm' maxlength='25' /></td>";
				str += "<td><input type='text' name='unitcode' class='inputStyle inputSm' maxlength='25' /></td>";
				str += "<td><input type='text' name='orderUc' class='inputStyle inputSm' maxlength='15' /></td>";
				str += "<td><input type='text' name='orderQty' class='inputStyle inputSm' maxlength='15' /></td>";
				str += "<td class='text-right'>0</td>";
				str += "<td class='text-right end'><button class='btnStyle btnSecondary btnSm deleteBtn'>삭제</button></td>";
				str += "</tr>";
				str += "</tbody>";
				str += "</table>";
				str += "<p class='mt10' style='textAlign: right'><strong>총합계 : 0</strong></p>";
				
			}
			$("#fileTable").append(str);
			
		}
	</script>
	<div>
		<h3 class="h3Tit mt50">입찰공고 추가 등록 사항</h3>
			<div class="boxSt mt20">
				<div class="flex align-items-center">
					<div class="flex align-items-center width100">
						<div class="formTit flex-shrink0 width170px">
							제출시작일시 <span class="star">*</span>
						</div>
						<div class="flex align-items-center width100">
							<input type="text" class="datepicker inputStyle" id="estStartDay">
							<select class="inputStyle ml10" name="estStartTime" id="estStartTime" style="background: url('../../images/selectArw.png') no-repeat right 15px center, maxWidth: 110px">
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
					
					<div class="flex align-items-center width100 ml80">
						<div class="formTit flex-shrink0 width170px">
							제출마감일시 <span class="star">*</span>
						</div>
						<div class="flex align-items-center width100">
							<input type="text" class="datepicker inputStyle" id="estCloseDay">
							<select class="inputStyle ml10" name="estCloseTime" id="estCloseTime" style="background: url('../../images/selectArw.png') no-repeat right 15px center, maxWidth: 110px">
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
						<div class="formTit flex-shrink0 width170px">개찰자 <span class="star">*</span></div>
						<div class="flex align-items-center width100">
							<input type="text" class="inputStyle" id="estOpener" name="estOpener" disabled />
							<button class="btnStyle btnSecondary ml10" title="선택" onClick=onUserListSelect('개찰자')>선택</button>
						</div>
					</div>
					<div class="flex align-items-center width100 ml80">
						<div class="formTit flex-shrink0 width170px">입찰공고자 <span class="star">*</span></div>
						<div class="flex align-items-center width100">
							<input type="text" class="inputStyle" id="gongoId" name="gongoId" disabled />
							<button class="btnStyle btnSecondary ml10" title="선택" onClick=onUserListSelect('입찰공고자')>선택</button>
						</div>
					</div>
				</div>

				<div class="flex align-items-center mt10">
					<div class="flex align-items-center width100">
						<div class="formTit flex-shrink0 width170px">낙찰자 <span class="star">*</span></div>
						<div class="flex align-items-center width100">
							<input type="text" class="inputStyle" id="estBidder" name="estBidder" disabled />
							<button class="btnStyle btnSecondary ml10" title="선택" onClick=onUserListSelect('낙찰자')>선택</button>
						</div>
					</div>
					<div class="flex align-items-center width100 ml80"></div> 
				</div>

				<div class="flex align-items-center mt10">
					<div class="flex align-items-center width100">
						<div class="formTit flex-shrink0 width170px">입회자1</div>
						<div class="flex align-items-center width100">
							<input type="text" class="inputStyle" id="openAtt1" name="openAtt1" disabled />
							<i onClick=onRemoveOpenAtt('openAtt1') class="fa-regular fa-xmark textHighlight ml5"></i>
							<button class="btnStyle btnSecondary ml10" title="선택" onClick=onUserListSelect('입회자1')>선택</button>
						</div>
					</div>
					<div class="flex align-items-center width100 ml80">
						<div class="formTit flex-shrink0 width170px">입회자2</div>
						<div class="flex align-items-center width100">
							<input type="text" class="inputStyle" id="openAtt2" name="openAtt2" disabled />
							<i onClick=onRemoveOpenAtt('openAtt2') class="fa-regular fa-xmark textHighlight ml5"></i>
							<button class="btnStyle btnSecondary ml10" title="선택" onClick=onUserListSelect('입회자2')>선택</button>
						</div>
					</div>
				</div>

				<div class="flex align-items-center mt10">
					<div class="flex align-items-center width100">
						<div class="formTit flex-shrink0 width170px">
							내역방식 <span class="star">*</span>
						</div>
						<div class="width100">
							<input type="radio" name="insModeCode" id="bm2_1" value="1" class="radioStyle" checked onChange="onChangeInsModeCode('1')" />
								<label for="bm2_1">파일등록</label>
							<input type="radio" name="insModeCode" id="bm2_2" value="2" class="radioStyle" onChange="onChangeInsModeCode('2')" />
								<label for="bm2_2">내역직접등록</label>
						</div>
					</div>
					<div class="flex align-items-center width100 ml80">
						<div class="formTit flex-shrink0 width170px">납품조건 <span class="star">*</span></div>
							<div class="width100">
								<input type="text" class="inputStyle" id="supplyCond" name="supplyCond" />
							</div>
						</div>
					</div>

					<div class="flex mt10">
						<div class="formTit flex-shrink0 width170px">
							세부내역 <span class="star">*</span>
							<span id="sebu">
							</span>
						</div>
						
						<div id="fileTable" class="width100">
						</div>
					</div>
				</div>

<!--				        <BidSaveExtraFile/>-->
<!--				          {/* 개찰자,입찰공고자,낙찰자,입회자1,입회자2 공통 사용자 조회*/}-->
<!--				          <BidUserList isBidUserListModal={isBidUserListModal} setIsBidUserListModal={setIsBidUserListModal} type={userType}/> -->
<!--				        </div>-->
			</div>
	</div>