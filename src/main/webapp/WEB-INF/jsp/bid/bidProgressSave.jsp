<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="bitcube.framework.ebid.etc.util.Constances" %>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%@ page import="bitcube.framework.ebid.dto.UserDto" %>
<%
	UserDto userDto = (UserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String custCode = userDto.getCustCode();
%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		var custContent = [];
		var custUserInfo = [];
		var sebuDetailCnt = 1;
		var insFile;
		var insInnerFile = [];
		var insOuterFile = [];
		
		$(document).ready(function() {
			fnInit();
						
			$("#spotDay").datepicker();
			$("#estStartDay").datepicker();
			$("#estCloseDay").datepicker();
			
			$('body').on('keyup', 'input[name="orderUc"]', function() {
				var replaceVal = Ft.fnComma($(this).val());
				$(this).val(replaceVal);
				onSetTableHtml();
			});
			
			$('body').on('keyup', 'input[name="orderQty"]', function() {
				var replaceVal = Ft.fnComma($(this).val());
				$(this).val(replaceVal);
				onSetTableHtml();
			});
			
			$('#bdAmt').on('keyup', function() {
				var value = $(this).val();
				$(this).val(Ft.fnComma(value));
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
			// 세부내역 case처리
			fnSetInsModeHtml('1');
			
			// 입찰참가내역 case처리
			fnSetbiModeHtml('A');
		}
		
		// 입찰방식 변경 이벤트
		function onChangeBiModeCode(code) {
			if(code === 'B'){
				Swal.fire({
					title: '입찰방식 변경',
					text: '일반경쟁입찰을 선택하면 입찰 등록되어 있는 \n모든 협력업체를 대상으로 하고 선택된 입찰참가업체가 초기화 됩니다.\n일반경쟁입찰으로 변경하시겠습니까?',  
					icon: 'question',
					confirmButtonColor: '#3085d6',
					confirmButtonText: '변경',
					showCancelButton: true,
					cancelButtonColor: '#d33',
					cancelButtonText: '취소'
				}).then(result => {
					if (result.isConfirmed) {	// 만약 모달창에서 confirm 버튼을 눌렀다면
						//지명경쟁입찰에서 일반경쟁입찰로 변경 시 입찰참가업체 정보 초기화
						$("#bm1_2").prop("checked", true);
						fnSetbiModeHtml('B');
					} else {
						if(code === 'A'){
							$("#bm1_2").prop("checked", true);
						} else {
							$("#bm1_1").prop("checked", true);
						}
					}
				});
			} else {
				fnSetbiModeHtml('A');
			}
		}
		
		// 과거입찰 가져오기 팝업
		function onBidPastModal() {
			bidPastInit();
			$("#bidPast").modal("show");
		}
		
		// 과거입찰 가져오기 콜백
		function onselectBidPastCallback(biNo) {
			var custCode = "<%= custCode%>";
			$.post(
				"/api/v1/bid/progresslistDetail",
				{
					biNo : biNo
				}
				).done(function(response){
					if(response.code === 'OK') {
						var bidContent = response.data[0][0];
						// 기본정보 세팅
						$("#biName").val(bidContent.biName);
						$("#progressItemCode").val(bidContent.itemCode);
						$("#progressItemName").val(bidContent.itemName);
						if(bidContent.biModeCode === "A") {
							$("#bm1_1").prop('checked', true);
						} else {
							$("#bm1_2").prop('checked', true);
						}
						$("#bidJoinSpec").val(bidContent.bidJoinSpec);
						$("#specialCond").val(bidContent.specialCond);
						$("#spotDay").val('');
						$("#spotArea").val(bidContent.spotArea);
						$("#succDeciMethCode").val(bidContent.succDeciMethCode);
						$("#amtBasis").val(bidContent.amtBasis);
						$("#payCond").val(bidContent.payCond);
						$("#bdAmt").val(bidContent.bdAmt ? bidContent.bdAmt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '');
						$("#estStartDay").val('');
						$("#estCloseDay").val('');
						$("#estOpener").val(bidContent.estOpener);
						$("#estOpenerCode").val(bidContent.estOpenerCode);
						$("#gongoId").val(bidContent.gongoId);
						$("#gongoIdCode").val(bidContent.gongoIdCode);
						$("#estBidder").val(bidContent.estBidder);
						$("#estBidderCode").val(bidContent.estBidderCode);
						$("#openAtt1").val(bidContent.openAtt1);
						$("#openAtt1Code").val(bidContent.openAtt1Code);
						$("#openAtt2").val(bidContent.openAtt2);
						$("#openAtt2Code").val(bidContent.openAtt2Code);
						if(bidContent.insModeCode === "1") {
							$("#bm2_1").prop('checked', true);
						} else {
							$("#bm2_2").prop('checked', true);
						}
						$("#supplyCond").val(bidContent.supplyCond);
						$("#matDept").val('');
						$("#matProc").val('');
						$("#matCls").val('');
						$("#matFactory").val('');
						$("#matFactoryLine").val('');
						$("#matFactoryCnt").val('');
						
						if(custCode == '02') {
							$("#matDept").val(bidContent.matDept);
							$("#matProc").val(bidContent.matProc);
							$("#matCls").val(bidContent.matCls);
							$("#matFactory").val(bidContent.matFactory);
							$("#matFactoryLine").val(bidContent.matFactoryLine);
							$("#matFactoryCnt").val(bidContent.matFactoryCnt);
						}
						
						// 입찰 방식에 따른 세팅
						if(bidContent.biModeCode === 'A'){
							// 세부내역 세팅
							fnSetbiModeHtml(bidContent.biModeCode);
							
							if(response.data[4].length > 0) {
								custUserInfo = response.data[4];
								custContent = response.data[3];
								var custCodeUserName = custUserInfo.reduce((acc, userInfo) => {
								var custCodeItem = acc.find(item => item.custCode === userInfo.custCode);
								if (custCodeItem) {
									custCodeItem.userName += ', ' + userInfo.userName;
								} else {
									acc.push({ custCode: userInfo.custCode, userName: userInfo.userName, custName : userInfo.custName });
								}
									return acc;
								}, []);
								custContent = custCodeUserName;
								
								$("#joinCustList").empty();
								var str = "";
									str += "<div id='joinCustDetail' class='overflow-y-scroll boxStSm width100' style='display:inline'>";
									
									for(var i=0; i<custContent.length; i++) {
										str += "<div>";
										str += "<button class='textUnderline' onclick='onCustUserDetail(" + custContent[i].custCode +")'>"+ custContent[i].custName +"</button>";
										str += "<span>"+ custContent[i].userName +"</span>";
										str += "<i class='fa-regular fa-xmark textHighlight ml5' onclick='onRemoveCust("+ custContent[i].custCode +")'></i>";
										str += "</div>";
									}
									str += "</div>";
									str += "<button class='btnStyle btnSecondary ml10' title='업체선택' onclick='onBidCustListModal()'>업체선택</button>";
								$("#joinCustList").append(str);
								
							} else {
								custUserInfo = [];
								custContent = [];
							}
						} else {
							fnSetbiModeHtml(bidContent.biModeCode);
						}
						
						// 내역방식에 따른 세팅
						if(bidContent.insModeCode === '1'){
							fnSetInsModeHtml(bidContent.insModeCode);
						} else {
							var tableContent = response.data[1];
							sebuDetailCnt = tableContent.length;
							fnSetInsModeHtml(bidContent.insModeCode);
							for(var i=0; i<sebuDetailCnt; i++) {
								$("#name"+i).val(tableContent[i].name);
								$("#ssize"+i).val(tableContent[i].ssize);
								$("#unitcode"+i).val(tableContent[i].unitcode);
								$("#orderUc"+i).val(Ft.fnComma(tableContent[i].orderUc.toString()));
								$("#orderQty"+i).val(Ft.fnComma(tableContent[i].orderQty.toString()));
							}
							// 총합계 세팅
							onSetTableHtml();
						}
					}
			});
		}
		
		// 품목 팝업
		function onItemPopModal() {
			$("#custTypePop").modal('show');
		}
		
		// 입찰찹가업체 팝업
		function onBidCustListModal() {
			$("#bidCustListPop").modal("show");
			fnInitBidCustListPop();
		}
		
		function itemSelectCallback(itemCode, itemName) {
			$("#custTypePop").modal('hide')
			$('#progressItemCode').val(itemCode)
			$('#progressItemName').val(itemName)
		}
		
		function onUserListSelect(str){
			$("#type").val(str);
			$("#bidUserListPop").modal("show");
			fnInitBidUserListPop();
		}
		
		function onUserListPopCallback(type, userId, userName) {
			if(type === '개찰자'){
				$("#estOpener").val(userName);
				$("#estOpenerCode").val(userId);
				$("#estBidder").val(userName);
				$("#estBidderCode").val(userId);
			} else if (type === '입찰공고자'){
				$("#gongoId").val(userName);
				$("#gongoIdCode").val(userId);
			} else if (type === '낙찰자'){
				$("#estBidder").val(userName);
				$("#estBidderCode").val(userId);
			} else if (type === '입회자1'){
				$("#openAtt1").val(userName);
				$("#openAtt1Code").val(userId);
				$("#att1Span").empty();
				var str = "";
				str += "<i onclick=onRemoveOpenAtt('att1') class='fa-regular fa-xmark textHighlight ml5'></i>";
				$("#att1Span").append(str);
			} else if (type === '입회자2'){
				$("#openAtt2").val(userName);
				$("#openAtt2Code").val(userId);
				var str = "";
				str += "<i onclick=onRemoveOpenAtt('att2') class='fa-regular fa-xmark textHighlight ml5'></i>";
				$("#att2Span").append(str);
			}
		}
		
		function onRemoveOpenAtt(openAtt) {
			if(openAtt === "att1") {
				$("#openAtt1").val("");
				$("#openAtt1Code").val("");
				$("#att1Span").empty();
			} else if (openAtt === "att2") {
				$("#openAtt2").val("");
				$("#openAtt2Code").val("");
				$("#att2Span").empty();
			}
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
		
		function fnSetbiModeHtml(code) {
			$("#joinCustList").empty();
			var str = "";
			if(code === "A") {
				str += "<div id='joinCustDetail' class='overflow-y-scroll boxStSm width100' style='display:inline'>";
				str += "<button>선택된 참가업체 없음</button>";
				str += "</div>";
				str += "<button class='btnStyle btnSecondary ml10' title='업체선택' onclick='onBidCustListModal()'>업체선택</button>";
			} else if (code === "B") {
				// 입찰참가업체 초기화
				custContent = []; 
				custUserInfo = [];
				str += "<div id='joinCustDetail' class='overflow-y-scroll boxStSm width100' style='display:inline'>";
				str += "<button>가입회원사 전체</button>";
				str += "<div>";
			}
			$("#joinCustList").append(str);
		}
		
		function onAddRow() {
			var str = "";
			str += "<tr>";
			str += "<input type='hidden' id='seq" + sebuDetailCnt + "' value='"+ (sebuDetailCnt+1) +"'>";
			str += "<td><input type='text' id='name" + sebuDetailCnt + "' name='name' class='inputStyle inputSm' maxlength='100' /></td>";
			str += "<td><input type='text' id='ssize" + sebuDetailCnt + "' name='ssize' class='inputStyle inputSm' maxlength='25' /></td>";
			str += "<td><input type='text' id='unitcode" + sebuDetailCnt + "' name='unitcode' class='inputStyle inputSm' maxlength='25' /></td>";
			str += "<td><input type='text' id='orderUc" + sebuDetailCnt + "' name='orderUc' class='inputStyle inputSm' maxlength='15' /></td>";
			str += "<td><input type='text' id='orderQty" + sebuDetailCnt + "' name='orderQty' class='inputStyle inputSm' maxlength='15' /></td>";
			str += "<td class='text-right' id='total" + sebuDetailCnt + "' >0</td>";
			str += "<td class='text-right end'><button class='btnStyle btnSecondary btnSm deleteBtn' onclick='deleteSebuRow(" + sebuDetailCnt + ")'>삭제</button></td>";
			str += "</tr>";
			$("#sebuDetailBody").append(str);
			sebuDetailCnt++;
		}
		
		function deleteSebuRow(row) {
			sebuDetailCnt--;
			var str = "";
			var sebuList = [];
			for(var i=0; i<sebuDetailCnt; i++) {
				if(i<row) {
					var obj = {
						seq : $("#seq"+i).val(),
						name : $("#name"+i).val(),
						ssize : $("#ssize"+i).val(),
						unitcode : $("#unitcode"+i).val(),
						orderUc : $("#orderUc"+i).val(),
						orderQty : $("#orderQty"+i).val(),
						total : $("#orderUc"+i).val() * $("#orderQty"+i).val()
					}
					sebuList.push(obj);
				} else if(i>=row) {
					var j = i+1;
					var obj = {
						seq : $("#seq"+j).val(),
						name : $("#name"+j).val(),
						ssize : $("#ssize"+j).val(),
						unitcode : $("#unitcode"+j).val(),
						orderUc : $("#orderUc"+j).val(),
						orderQty : $("#orderQty"+j).val(),
						total : $("#orderUc"+j).val() * $("#orderQty"+j).val()
					}
					sebuList.push(obj);
				}
			}
				
			$("#sebuDetailBody").empty();
			for(var i=0; i<sebuList.length; i++) {
				str += "<tr>";
				str += "<input type='hidden' id='seq"+ i +"' value='"+ (i+1) +"'>";
				str += "<td><input type='text' value='"+ sebuList[i].name + "' id='name" + i + "' name='name' class='inputStyle inputSm' maxlength='100' /></td>";
				str += "<td><input type='text' value='"+ sebuList[i].ssize + "' id='ssize" + i + "' name='ssize' class='inputStyle inputSm' maxlength='25' /></td>";
				str += "<td><input type='text' value='"+ sebuList[i].unitcode + "' id='unitcode" + i + "' name='unitcode' class='inputStyle inputSm' maxlength='25' /></td>";
				str += "<td><input type='text' value='"+ sebuList[i].orderUc + "' id='orderUc" + i + "' name='orderUc' class='inputStyle inputSm' maxlength='15' /></td>";
				str += "<td><input type='text' value='"+ sebuList[i].orderQty + "' id='orderQty" + i + "' name='orderQty' class='inputStyle inputSm' maxlength='15' /></td>";
				str += "<td class='text-right' id='total" + i + "' >"+ sebuList[i].total +"</td>";
				str += "<td class='text-right end'><button class='btnStyle btnSecondary btnSm deleteBtn' onclick='deleteSebuRow(" + i + ")'>삭제</button></td>";
				str += "</tr>";
			}
			
			$("#sebuDetailBody").append(str);
		}
		
		function fnSetDetailSet(num) {
			$("#fileTable").empty();
			var str = "";
			if(num == '1') {
				str += "<div class='upload-boxWrap'>";
				str += "<div class='upload-box'>";
				str += "<input type='file' ref='uploadedFile' id='insFile' onChange='handleFileChange(event)' />";
				str += "<div class='uploadTxt'>";
				str += "<i class='fa-regular fa-upload'></i>";
				str += "<div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제) <br/>파일 최대 10MB (등록 파일 개수 최대 1개)</div>";
				str += "</div>";
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
				str += "<tbody id='sebuDetailBody'>";
				for(var i=0; i<sebuDetailCnt; i++) {
					str += "<tr>";
					str += "<input type='hidden' id='seq"+ i +"' value='"+ (i+1) +"'>";
					str += "<td><input type='text' id='name" + i + "' name='name' class='inputStyle inputSm' maxlength='100' /></td>";
					str += "<td><input type='text' id='ssize" + i + "' name='ssize' class='inputStyle inputSm' maxlength='25' /></td>";
					str += "<td><input type='text' id='unitcode" + i + "' name='unitcode' class='inputStyle inputSm' maxlength='25' /></td>";
					str += "<td><input type='text' id='orderUc" + i + "' name='orderUc' class='inputStyle inputSm' maxlength='15' /></td>";
					str += "<td><input type='text' id='orderQty" + i + "' name='orderQty' class='inputStyle inputSm' maxlength='15' /></td>";
					str += "<td class='text-right' id='total" + i + "' >0</td>";
					str += "<td class='text-right end'><button class='btnStyle btnSecondary btnSm deleteBtn' onclick='deleteSebuRow(" + i + ")'>삭제</button></td>";
					str += "</tr>";
				}
				str += "</tbody>";
				str += "</table>";
				str += "<p class='mt10' style='text-align: right'><strong id='totalCount'>총합계 : 0</strong></p>";
				
			}
			$("#fileTable").append(str);
			
		}
		
		function handleFileChange(event) {
			var fileInput = event.target;
			var file = fileInput.files[0]; // 선택된 첫 번째 파일
			insFile = fileInput.files[0]; // 선택된 첫 번째 파일
			
			if (file) {
				if(file.size > 10485760) {
					event.target.value = "";
					Swal.fire('', '파일 크기는 최대 10MB까지입니다.\n파일 크기를 확인해 주세요.', 'warning');
					return;
				}
				
				$("#fileTable").empty();
				var str = "";
				str += "<div class='upload-boxWrap'>";
				str += "<div class='uploadPreview'>";
				str += "<p style='lineHeight:80px;'>" + file.name + "";
				str += "<button onclick='onRemoveInsFile()' class='file-remove'>삭제</button>";
				str += "</p>";
				str += "</div>";
				str += "</div>";
				$("#fileTable").append(str);
			} 
		}
		
		function handleInnerFileChange(event) {
			var fileInput = event.target;
			var file = fileInput.files[0]; // 선택된 첫 번째 파일
			insFile = fileInput.files[0]; // 선택된 첫 번째 파일
			
			if (file) {
				if(file.size > 10485760) {
					event.target.value = "";
					Swal.fire('', '파일 크기는 최대 10MB까지입니다.\n파일 크기를 확인해 주세요.', 'warning');
					return;
				}
				
				$("#fileTable").empty();
				var str = "";
				str += "<div class='upload-boxWrap'>";
				str += "<div class='uploadPreview'>";
				str += "<p style='lineHeight:80px;'>" + file.name + "";
				str += "<button onclick='onRemoveInsFile()' class='file-remove'>삭제</button>";
				str += "</p>";
				str += "</div>";
				str += "</div>";
				$("#fileTable").append(str);
			} 
		}
		
		function handleOuterFileChange(event) {
			var fileInput = event.target;
			var fileLength = fileInput.files.length;
			
			if(fileLength > 20) {
				Swal.fire('', '대외용 파일은 최대 20개까지 추가 가능합니다.', 'warning');
				return;
			}
			
			for(var i=0; i<fileLength; i++) {
				var file = fileInput.files[i];
				if (file) {
					if(file.size > 10485760) {
						event.target.value = "";
						Swal.fire('', '파일 크기는 최대 10MB까지입니다.\n파일 크기를 확인해 주세요.', 'warning');
						return;
					}
				}
			}
			
			var str = "";
			$("#outerFileTable").empty();
			str += "<div class='upload-boxWrap' style='min-height:80px; max-height:190px; overflow:auto;'>";
			str += "<div class='uploadPreview'>";
			str += "<p style='line-height:20px'>파일 개수 : " + fileLength + "개";
			str += "<button onclick='removeInnerFiles('ALL')' class='file-remove' style='padding-left:10px;padding-right:10px'>전체삭제</button>";
			str += "</p>";
				for(var i=0; i<fileLength; i++) {
					var file = fileInput.files[i];
					str += "<p style='line-height:20px;'>" + file.name + "";
					str += "<button onclick='removeInnerFiles("+ i +")' class='file-remove'>삭제</button>";
					str += "</p>";
					insOuterFile.push(file);
				}
			str += "</div>";
			str += "</div>";
			
			$("#outerFileTable").append(str);
		}
		
		function removeInnerFiles(idx) {
			if(idx === "ALL") {
				insOuterFile = [];
				$("#outerFileTable").empty();
				
				
				$("#outerFileTable").append(str);
			} else {
				
			}
			
		}
		
		function onRemoveInsFile() {
			// 파일 초기화
			insFile = "";
			
			$("#fileTable").empty();
			var str = "";
			str += "<div class='upload-boxWrap'>";
			str += "<div class='upload-box'>";
			str += "<input type='file' ref='uploadedFile' id='insFile' onChange='handleFileChange(event)' />";
			str += "<div class='uploadTxt'>";
			str += "<i class='fa-regular fa-upload'></i>";
			str += "<div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제) <br/>파일 최대 10MB (등록 파일 개수 최대 1개)</div>";
			str += "</div>";
			str += "</div>";
			$("#fileTable").append(str);
		}
		
		function onMoveBidProgress() {
			location.href="/api/v1/move?viewName=bid/progress";
		}
		
		function onSaveConfirm () {
			if(onSaveVali()) {
				Swal.fire({
					title: '입찰 계획 저장',
					text: '작성하신 내용으로 입찰계획을 저장합니다. 저장하시겠습니까?',
					icon: 'question',
					confirmButtonColor: '#3085d6',
					confirmButtonText: '저장',
					showCancelButton: true,
					cancelButtonColor: '#d33',
					cancelButtonText: '취소'
				}).then(result => {
					if (result.isConfirmed) { 
						onSaveBid()
					}
				})
			}
		}
		
		function onSaveVali() {
			var spotDay			= $("#spotDay").val();
			var spotTime		= $("#spotTime").val();
			var estStartDay		= $("#estStartDay").val();
			var estStartTime	= $("#estStartTime").val();
			var estCloseDay		= $("#estCloseDay").val();
			var estCloseTime	= $("#estCloseTime").val();
			
			if ("" === $("#biName").val()) {
				Swal.fire('', '입찰명을 입력해 주세요.', 'warning')
				return false;
			}
			
			if ("" === $("#progressItemCode").val()) {
				Swal.fire('', '품목을 선택해 주세요.', 'warning')
				return false;
			}
			
			if ("" === $("#bidJoinSpec").val()) {
				Swal.fire('', '입찰참가자격을 입력해 주세요.', 'warning')
				return false;
			}
			
			if (!spotDay) {
				Swal.fire('', '현장설명일시 날짜를 선택해 주세요.', 'warning')
				return false;
			}
			
			if (!spotTime) {
				Swal.fire('', '현장설명일시 시간을 선택해 주세요.', 'warning')
				return false;
			}

			var spotDateTime = new Date(spotDay + "T" + spotTime);
			var currentTime = new Date(new Date().toLocaleString("en-US", {timeZone: "Asia/Seoul"}));
			
			if (currentTime > spotDateTime) {
				Swal.fire('', '현장설명일시는 현재 시간보다 큰 시간을 선택해야 합니다.', 'warning')
				return false
			}
			
			if ("" === $("#spotArea").val()) {
				Swal.fire('', '현장설명장소를 입력해 주세요.', 'warning')
				return false;
			}
			
			if($('input[name="biModeCode"]:checked').val() === 'A' && custContent.length === 0){
				Swal.fire('', '입찰 참가업체를 선택해 주세요.', 'warning')
				return false;
			}
			
			if ("" === $("#amtBasis").val()) {
				Swal.fire('', '금액기준을 입력해 주세요.', 'warning')
				return false;
			}
			
			if (!estStartDay) {
				Swal.fire('', '제출시작일시 날짜를 선택해 주세요.', 'warning')
				return false;
			}
			
			if (!estStartTime) {
				Swal.fire('', '제출시작일시 시간을 선택해 주세요', 'warning')
				return false;
			}
			
			if (!estCloseDay) {
				Swal.fire('', '제출마감일시 날짜를 선택해 주세요.', 'warning')
				return false;
			}
			
			if (!estCloseTime) {
				Swal.fire('', '제출마감일시 시간을 선택해 주세요.', 'warning')
				return false;
			}
			
			var startDateTime = new Date(estStartDay + "T" + estStartTime);
			var closeDateTime = new Date(estCloseDay + "T" + estCloseTime);
			
			if (currentTime > closeDateTime) {
				Swal.fire('', '제출마감일시는 현재 시간보다 큰 시간을 선택해야 합니다.', 'warning')
				return false
			}
			
			if (startDateTime > closeDateTime) {
				Swal.fire('', '제출시작일시가 제출마감일시보다 큽니다.', 'warning')
				return false;
			}
			
			if ("" === $("#estOpenerCode").val()) {
				Swal.fire('', '개찰자를 선택해 주세요.', 'warning')
				return false;
			}
		
			if ("" === $("#gongoIdCode").val()) {
				Swal.fire('', '입찰공고자를 선택해 주세요.', 'warning')
				return false;
			}
			
			if ("" === $("#estBidderCode").val()) {
				Swal.fire('', '낙찰자를 선택해 주세요.', 'warning')
				return false;
			}
			
			if ("" === $("#supplyCond").val()) {
				Swal.fire('', '납품조건을 입력해 주세요.', 'warning')
				return false;
			}
			
			//세부내역 파일등록 경우
			if ($('input[name="insModeCode"]:checked').val() === '1') {
				if (!insFile) {
					Swal.fire('', '세부내역파일을 업로드해 주세요.', 'warning')
					return false;
				}
			} else {
				// 세부내역이 직접 입력인 경우
				if(sebuDetailCnt === 0){
					Swal.fire('', '세부내역을 추가해 주세요.', 'warning')
					return false;
				} else {
				//내역직접등록에서 입력하지 않은 값이 있는지 확인
					for(var i=0; i<sebuDetailCnt; i++) {
						if($("#name"+i).val().trim() === "") {
							Swal.fire('', '세부내역 품목명을 입력해 주세요.', 'warning');
							return false;
						}
						if($("#ssize"+i).val().trim() === "") {
							Swal.fire('', '세부내역 규격명을 입력해 주세요.', 'warning');
							return false;
						}
						if($("#unitcode"+i).val().trim() === "") {
							Swal.fire('', '세부내역 단위를 입력해 주세요.', 'warning');
							return false;
						}
						if($("#orderUc"+i).val().trim() === "") {
							Swal.fire('', '세부내역 예정단가를 입력해 주세요.', 'warning');
							return false;
						}
						if($("#orderQty"+i).val().trim() === "") {
							Swal.fire('', '세부내역 수량을 입력해 주세요.', 'warning');
							return false;
						}
					}
				}
			}
			return true;
		}
		
		function onSaveBid() {
			var custUserInfoData = {}

			if ($("input[name='biModeCode']:checked").val() === 'A') {
				//등록되는 입찰 bino로 set
				var custUserInfoFilter = {};
				custUserInfo.forEach(info => {
					if (!custUserInfoFilter[info.custCode]) {
						custUserInfoFilter[info.custCode] = '';
					} else {
						custUserInfoFilter[info.custCode] += ',';
					}
					custUserInfoFilter[info.custCode] += info.userId;
				});

				custUserInfoData = Object.keys(custUserInfoFilter).map(custCode => ({
					custCode: custCode,
					usemailId: custUserInfoFilter[custCode]
				}));
			}

			var fd = new FormData()
			
			var tableContentData = [];

			if($("input[name='insModeCode']:checked").val() === "1"){
				fd.append("insFile", insFile)
			} else {
				for(var i=0; i<sebuDetailCnt; i++) {
					var map = {
						seq : "",
						name : "",
						ssize : "",
						unitcode : "",
						orderUc : "",
						orderQty : ""
					}
					map.seq = $("#seq"+i).val();
					map.name = $("#name"+i).val();
					map.ssize = $("#ssize"+i).val();
					map.unitcode = $("#unitcode"+i).val();
					map.orderUc = $("#orderUc"+i).val().replace(/,/g, '');
					map.orderQty = $("#orderQty"+i).val().replace(/,/g, '');
					tableContentData.push(map);
				}
			}
			
			var spotDay			= $("#spotDay").val();
			var spotTime		= $("#spotTime").val();
			var estStartDay		= $("#estStartDay").val();
			var estStartTime	= $("#estStartTime").val();
			var estCloseDay		= $("#estCloseDay").val();
			var estCloseTime	= $("#estCloseTime").val();

			var updatedBidContent = {
				custUserInfo		: custUserInfo,
				type				: "insert",
				biName				: $("#biName").val(),
				itemCode			: $("#progressItemCode").val(),
				itemName			: $("#progressItemName").val(),
				biModeCode			: $("input[name='biModeCode']:checked").val(),
				insModeCode			: $("input[name='insModeCode']:checked").val(),
				bidJoinSpec			: $("#bidJoinSpec").val(),
				specialCond			: $("#specialCond").val(),
				supplyCond			: $("#supplyCond").val(),
				spotDate			: spotDay + spotTime,
				spotArea			: $("#spotArea").val(),
				succDeciMethCode	: $("#succDeciMethCode").val(),
				amtBasis			: $("#amtBasis").val(),
				bdAmt				: $("#bdAmt").val().replace(/,/g, ''),
				estStartDate		: estStartDay + estStartTime,
				estCloseDate		: estCloseDay + estCloseTime,
				estOpenerCode		: $("#estOpenerCode").val(),
				estBidderCode		: $("#estBidderCode").val(),
				openAtt1Code		: $("#openAtt1Code").val(),
				openAtt2Code		: $("#openAtt2Code").val(),
				gongoIdCode			: $("#gongoIdCode").val(),
				payCond				: $("#payCond").val(),
				matDept				: $("#matDept").val(),
				matProc				: $("#matProc").val(),
				matCls				: $("#matCls").val(),
				matFactory			: $("#matFactory").val(),
				matFactoryLine		: $("#matFactoryLine").val(),
				matFactoryCnt		: $("#matFactoryCnt").val()
			};
			
		//	if(innerFiles.length > 0){
		//		innerFiles.forEach(file => {
		//			fd.append("innerFiles", file)
		//		})
		//	}
		//	if(outerFiles.length > 0){
		//		outerFiles.forEach(file => {
		//			fd.append("outerFiles", file)
		//		})
		//	}
			
			var param = {
				bidContent : updatedBidContent,
				custContent : custContent,
				tableContent : tableContentData
			}
			fd.append("bidContent", JSON.stringify(param));
			
			
			$.ajax({
				url: "/api/v1/bid/insertBid",
				type: "POST",
				data: fd,
				processData: false,  // FormData를 처리하지 않음
				contentType: false,  // multipart/form-data 형식을 사용
				success: function(response) {
					if (response.code === 'OK') {
						Swal.fire('입찰계획이 저장되었습니다.', '', 'success');
						onMoveBidProgress();
					} else {
						Swal.fire('입찰계획 저장을 실패하였습니다.', '', 'error');
					}
				},
				error: function(error) {
					Swal.fire('입찰계획 저장 중 오류가 발생했습니다.', '', 'error');
				}
			});
			
		}
		
		function selectCustUserCallback(selectUserList, custMap) {
			custContent.push(custMap);
			for(var i=0; i<selectUserList.length; i++) {
				var objMap = {
					userId : "",
					userName : "",
					custCode : ""
				};
				objMap.userId = selectUserList[i].userId;
				objMap.userName = selectUserList[i].userName;
				objMap.custCode = custMap.custCode;
				custUserInfo.push(objMap);
			}
			
			$("#joinCustList").empty();
			var str = "";
				str += "<div id='joinCustDetail' class='overflow-y-scroll boxStSm width100' style='display:inline'>";
				
				for(var i=0; i<custContent.length; i++) {
					str += "<div>";
					str += "<button class='textUnderline' onclick='onCustUserDetail(" + custContent[i].custCode +")'>"+ custContent[i].custName +"</button>";
					str += "<span>"+ custContent[i].userName +"</span>";
					str += "<i class='fa-regular fa-xmark textHighlight ml5' onclick='onRemoveCust("+ custContent[i].custCode +")'></i>";
					str += "</div>";
				}
				str += "</div>";
				str += "<button class='btnStyle btnSecondary ml10' title='업체선택' onclick='onBidCustListModal()'>업체선택</button>";
			$("#joinCustList").append(str);
		}
		
		function onRemoveCust(custCode) {
			custContent = custContent.filter(item => item.custCode != custCode);
			var str = "";
			$("#joinCustList").empty();
			if(custContent > 0) {
				str += "<div id='joinCustDetail' class='overflow-y-scroll boxStSm width100' style='display:inline'>";
				str += "<button>선택된 참가업체 없음</button>";
				str += "</div>";
				str += "<button class='btnStyle btnSecondary ml10' title='업체선택' onclick='onBidCustListModal()'>업체선택</button>";
			} else {
				str += "<div id='joinCustDetail' class='overflow-y-scroll boxStSm width100' style='display:inline'>";
				for(var i=0; i<custContent.length; i++) {
					str += "<div>";
					str += "<button class='textUnderline' onclick='onCustUserDetail(" + custContent[i].custCode +")'>"+ custContent[i].custName +"</button>";
					str += "<span>"+ custContent[i].userName +"</span>";
					str += "<i class='fa-regular fa-xmark textHighlight ml5' onclick='onRemoveCust("+ custContent[i].custCode +")'></i>";
					str += "</div>";
				}
				str += "</div>";
				str += "<button class='btnStyle btnSecondary ml10' title='업체선택' onclick='onBidCustListModal()'>업체선택</button>";
			}
			$("#joinCustList").append(str);
		}
		
		function innerFilesPop() {
			$("#innerFilesInput").click();
		}
		
		function outerFilesPop() {
			$("#outerFilesInput").click();
		}
		
		function onSetTableHtml() {
			var spec = [];
			for(var i=0; i<sebuDetailCnt; i++) {
				var orderUc = $("#orderUc"+i).val() === "" ? 0 : $("#orderUc"+i).val().replace(/,/g, '');
				var orderQty = $("#orderQty"+i).val() === "" ? 0 : $("#orderQty"+i).val().replace(/,/g, '');
				$("#total"+i).html(Ft.fnComma((orderUc * orderQty).toString()));
				
				spec[i] = spec[i] || {};
				spec[i].orderUc = orderUc;
				spec[i].orderQty = orderQty;
			}
			var totalCount = Ft.ftAllSum(spec);
			$("#totalCount").html(totalCount);
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
						<li>입찰계획 등록 </li>
					</ul>
				</div>
				
				<div class="contents">
					<div class="formWidth">
						<h3 class="h3Tit">입찰 기본 정보</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">
									과거입찰
								</div>
								<div class="width100">
									<button class="btnStyle btnOutlineBlue" title="과거입찰 가져오기" style="marginLeft:0px" onclick=onBidPastModal()>과거입찰 가져오기</button>
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
									<input type="hidden" id="progressItemCode">
									<input type="text" class="inputStyle" name="progressItemName" id="progressItemName" disabled>
									<button class="btnStyle btnSecondary ml10" title="조회" onClick=onItemPopModal() >조회</button>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">
									입찰방식 <span class="star">*</span>
								</div>
								<div class="width100">
									<input type="radio" id="bm1_1" value="A" name="biModeCode" class="radioStyle" checked onChange="onChangeBiModeCode('A')" />
										<label for="bm1_1">지명경쟁입찰</label>
									<input type="radio" id="bm1_2" value="B" name="biModeCode" class="radioStyle" onChange="onChangeBiModeCode('B')" />
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
								<div id="joinCustList" class="flex align-items-center width100">
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
								<div class="width100"></div>
							</div>
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
										<input type="hidden" id="estOpenerCode" />
										<button class="btnStyle btnSecondary ml10" title="선택" onClick=onUserListSelect('개찰자')>선택</button>
									</div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">입찰공고자 <span class="star">*</span></div>
									<div class="flex align-items-center width100">
										<input type="text" class="inputStyle" id="gongoId" name="gongoId" disabled />
										<input type="hidden" id="gongoIdCode" />
										<button class="btnStyle btnSecondary ml10" title="선택" onClick=onUserListSelect('입찰공고자')>선택</button>
									</div>
								</div>
							</div>

							<div class="flex align-items-center mt10">
								<div class="flex align-items-center width100">
									<div class="formTit flex-shrink0 width170px">낙찰자 <span class="star">*</span></div>
									<div class="flex align-items-center width100">
										<input type="text" class="inputStyle" id="estBidder" name="estBidder" disabled />
										<input type="hidden" id="estBidderCode" />
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
										<input type="hidden" id="openAtt1Code" />
										<span id="att1Span"></span>
										<button class="btnStyle btnSecondary ml10" title="선택" onClick=onUserListSelect('입회자1')>선택</button>
									</div>
								</div>
								<div class="flex align-items-center width100 ml80">
									<div class="formTit flex-shrink0 width170px">입회자2</div>
									<div class="flex align-items-center width100">
										<input type="text" class="inputStyle" id="openAtt2" name="openAtt2" disabled />
										<input type="hidden" id="openAtt2Code" />
										<span id="att2Span"></span>
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
								
<!--								<div class="flex mt10">-->
<!--									<div class="formTit flex-shrink0 width170px">-->
<!--										첨부파일(대내용)-->
<!--										<i class="fas fa-question-circle toolTipSt ml5">-->
<!--											<div class="toolTipText" style="width: 320px">-->
<!--												<ul class="dList">-->
<!--													<li>-->
<!--														<div>그룹사 내부 입찰관계자가 확인하는 첨부파일 입니다.</div>-->
<!--													</li>-->
<!--													<li>-->
<!--														<div>파일이 암호화 되어 있는지 확인해 주십시오</div>-->
<!--													</li>-->
<!--												</ul>-->
<!--											</div>-->
<!--										</i>-->
<!--										<button class="modalBtnCheck" title="파일 추가(대내용)" style="marginLeft:0;marginRight:0;marginTop:5px;" onclick="innerFilesPop()">파일 추가(대내용)</button>-->
<!--									</div>-->
<!--									<input type='file' style='display:none' ref='uploadedInnerFile' id='innerFilesInput' onchange='handleInnerFileChange(event)' multiple/>-->
<!--									<div id="innerFileTable" class="width100">-->
<!--										<div class='upload-boxWrap'>-->
<!--											<div class='upload-box'>-->
												
<!--												<div class='uploadTxt'>-->
<!--													<i class='fa-regular fa-upload'></i>-->
<!--													<div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제) <br/>파일 최대 10MB (등록 파일 개수 최대 20개)</div>-->
<!--												</div>-->
<!--											</div>-->
<!--										</div>-->
<!--									</div>-->
<!--								</div>-->
								
<!--								<div class="flex mt10">-->
<!--									<div class="formTit flex-shrink0 width170px">-->
<!--										첨부파일(대외용)-->
<!--										<i class="fas fa-question-circle toolTipSt ml5">-->
<!--											<div class="toolTipText" style="width: 320px">-->
<!--												<ul class="dList">-->
<!--													<li>-->
<!--														<div>그룹사 내부 입찰관계자가 확인하는 첨부파일 입니다.</div>-->
<!--													</li>-->
<!--													<li>-->
<!--														<div>파일이 암호화 되어 있는지 확인해 주십시오</div>-->
<!--													</li>-->
<!--												</ul>-->
<!--											</div>-->
<!--										</i>-->
<!--										<button class="modalBtnCheck" title="파일 추가(대외용)" style="marginLeft:0;marginRight:0;marginTop:5px;" onclick="outerFilesPop()">파일 추가(대외용)</button>-->
<!--									</div>-->
<!--									<input type='file' style='display:none' ref='uploadedOuterFile' id='outerFilesInput' onchange='handleOuterFileChange(event)' multiple/>-->
<!--									<div id="outerFileTable" class="width100">-->
<!--										<div class='upload-boxWrap'>-->
<!--											<div class='upload-box'>-->
												
<!--												<div class='uploadTxt'>-->
<!--													<i class='fa-regular fa-upload'></i>-->
<!--													<div onclick="outerFilesPop()">클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제) <br/>파일 최대 10MB (등록 파일 개수 최대 20개)</div>-->
<!--												</div>-->
<!--											</div>-->
<!--										</div>-->
<!--									</div>-->
<!--								</div>-->
						</div>
						
						<div class="text-center mt50">
							<button title="목록" class="btnStyle btnOutline" onclick="onMoveBidProgress()">목록 </button> 
							<button class="btnStyle btnPrimary" onclick="onSaveConfirm()">저장</button></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 과거입찰 가져오기 -->
		<jsp:include page="/WEB-INF/jsp/bid/bidPast.jsp" />
		
		<!-- 품목 조회 -->
		<jsp:include page="/WEB-INF/jsp/join/custTypePop.jsp" />
		
		<!-- 업체 조회 -->
		<jsp:include page="/WEB-INF/jsp/bid/bidCustList.jsp" />
		
		<!-- 개찰자,입찰공고자,낙찰자,입회자1,입회자2 공통 사용자 조회 -->
		<jsp:include page="/WEB-INF/jsp/bid/bidUserList.jsp" />
		
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
