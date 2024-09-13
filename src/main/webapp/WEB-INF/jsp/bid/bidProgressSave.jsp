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
		var insFile;
		$(document).ready(function() {
			fnInit();
						
			$("#spotDay").datepicker();
			$("#estStartDay").datepicker();
			$("#estCloseDay").datepicker();
			//minDate={bidContent.minDate}
			
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
			$("#bidPast").modal("show");
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
				$("#estOpenerCode").val(userId);
			} else if (type === '입찰공고자'){
				$("#gongoId").val(userName);
				$("#gongoIdCode").val(userId);
			} else if (type === '낙찰자'){
				$("#estBidder").val(userName);
				$("#estOpenerCode").val(userId);
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
				custContent = {}; 
				str += "<div id='joinCustDetail' class='overflow-y-scroll boxStSm width100' style='display:inline'>";
				str += "<button>가입회원사 전체</button>";
				str += "<div>";
			}
			$("#joinCustList").append(str);
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
			var spotDay		= $("#spotDay").val();
			var spotTime		= $("#spotTime").val();
			var estStartDay	= $("#estStartDay").val();
			var estStartTime	= $("#estStartTime").val();
			var estCloseDay	= $("#estCloseDay").val();
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
			
			//if($("input[name='biModeCode']").val() === 'A' && custContent.length === 0){
			//	Swal.fire('', '입찰 참가업체를 선택해 주세요.', 'warning')
			//	return false;
			//}
			
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
			if ($("input[name='insModeCode']").val() === '1') {
				if (!insFile) {
					Swal.fire('', '세부내역파일을 업로드해 주세요.', 'warning')
					return false;
				}
			} else {
			//	// 세부내역이 직접 입력인 경우
			//	if(tableContent.length === 0){
			//		Swal.fire('', '세부내역을 추가해 주세요.', 'warning')
			//		return false;
			//	} else {
			//	//내역직접등록에서 입력하지 않은 값이 있는지 확인
			//		var nameCheck = tableContent.filter(item => !item.name.trim())
			//		var ssizeCheck = tableContent.filter(item => !item.ssize.trim())
			//		var unitcodeCheck = tableContent.filter(item => !item.unitcode.trim())
			//		var orderUcCheck = tableContent.filter(item => !item.orderUc.trim())
			//		var orderQtyCheck = tableContent.filter(item => !item.orderQty.trim())
			//		
			//		if(nameCheck.length > 0){
			//			Swal.fire('', '세부내역 품목명을 입력해 주세요.', 'warning')
			//			return false;
			//		}
			//		if(ssizeCheck.length > 0){
			//			Swal.fire('', '세부내역 규격명을 입력해 주세요.', 'warning')
			//			return false;
			//		}
			//		if(unitcodeCheck.length > 0){
			//			Swal.fire('', '세부내역 단위를 입력해 주세요.', 'warning')
			//			return false;
			//		}
			//		if(orderUcCheck.length > 0){
			//			Swal.fire('', '세부내역 예정단가를 입력해 주세요.', 'warning')
			//			return false;
			//		}
			//		if(orderQtyCheck.length > 0){
			//			Swal.fire('', '세부내역 수량을 입력해 주세요.', 'warning')
			//			return false;
			//		}
			//	}
			}
			return true;
		}
		
		function onSaveBid() {
			var custUserInfoData = {}

			if ($("input[name='biModeCode']").val() === 'A') {
				//등록되는 입찰 bino로 set
		//		var custUserInfoFilter: CustUserInfoFilter = {};
		//		custUserInfo.forEach(info => {
		//			if (!custUserInfoFilter[info.custCode]) {
		//				custUserInfoFilter[info.custCode] = '';
		//			} else {
		//				custUserInfoFilter[info.custCode] += ',';
		//			}
		//			custUserInfoFilter[info.custCode] += info.userId;
		//		});

		//		custUserInfoData = Object.keys(custUserInfoFilter).map(custCode => ({
		//			custCode: custCode,
		//			usemailId: custUserInfoFilter[custCode]
		//		}));
			}


			var fd = new FormData()
			
			var tableContentData = [];

			if($("input[name='insModeCode']").val() === "1"){
				fd.append("insFile", insFile)
			} else {
			//	tableContentData = tableContent.map((item, idx) => {
			//		return { ...item, seq: idx + 1, orderQty : Number(item.orderQty.replace(/,/g, '')),orderUc: Number(item.orderUc.replace(/,/g, ''))}
			//	});
			}

			//     const type = sessionViewType === '등록' ? 'insert' : 'update'
			//     let insFileCheck :string = ''
			//     let delInnerFiles : string[] = []
			//     let delOuterFiles : string[] = []
            //
			//     const updatedBidContent = {
			//       ...bidContent,
			//       custUserInfo: custUserInfoData,
			//       userId: loginInfo.userId,
			//       bdAmt : bidContent.bdAmt.replace(/[^\d-]/g, ''),
			//       type : type,
			//       insFileCheck : '',
			//       delInnerFiles : [] as string[],
			//       delInnerFilesAll : '',
			//       delOuterFiles : [] as string[],
			//       delOuterFilesAll : '',
			//     };
            //
			//       if(innerFiles.length > 0){
			//         innerFiles.forEach(file => {
			//           fd.append("innerFiles", file)
			//         })
			//       }
			//       if(outerFiles.length > 0){
			//         outerFiles.forEach(file => {
			//           fd.append("outerFiles", file)
			//         })
			//       }
			//     
			//     const params = {
			//       bidContent : updatedBidContent,
			//       custContent : custContent,
			//       tableContent : tableContentData
			//     }
			//     fd.append("bidContent", JSON.stringify(params))
			//     
			//     
			//     try {
			//       const response : MapType = await axios.post(`/api/v1/bid/${type}Bid`, fd);
			//       if(response.data.code === 'OK'){
			//         Swal.fire('입찰계획이 저장되었습니다.', '', 'success');
			//         onMoveBidProgress()
			//       }else{
			//         Swal.fire(response.msg, '', 'error');
			//         console.log(response.msg);
			//       }
			//       
			//     } catch (error) {
			//         Swal.fire('입찰계획 저장을 실패하였습니다.', '', 'error');
			//         console.log(error);
			//     }
			
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
									<input type="text" class="inputStyle" name="progressItemName" id="progressItemName">
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
							</div>
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
