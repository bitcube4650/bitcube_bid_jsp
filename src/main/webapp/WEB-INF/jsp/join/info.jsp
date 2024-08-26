<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%
	Map<String, Object> params = (Map<String, Object>) request.getAttribute("params");
	String agree = params != null ? CommonUtils.getString(params.get("agree")) : "";
	
	if(!agree.equals("1")){
		response.sendRedirect("/");
	}
%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<script>
$(function(){
	init();

	$("#userId").keydown(function(e){
		$('#idcheck').prop('checked', false);
	});
	
});

function init() {
	$.post(
		'/api/v1/login/interrelatedList', 
		{}
	)
	.done(function(arg) {
		if(arg.code === "OK") {
			let html = "<option value=''>계열사를 선택해 주세요</option>";
			let data = arg.data;
			for(let i = 0 ; i < data.length; i++){
				html += "<option value=" + data[i].interrelatedCustCode + ">" + data[i].interrelatedNm + "</option>";
			}
			
			$("#interrelatedCustCode").html(html);
		}else{
			Swal.fire('', '계열사 불러오기에 실패하였습니다.', 'error');
		}
	})
	
};

//업체유형 팝업 콜백
function itemSelectCallback(itemCode, itemName) {
	$("#custTypePop").modal('hide');
	let type = $("#itemType").val();
	if("type1" === type) {
		
		$("#custType1").val(itemCode);
		$("#custTypeNm1").val(itemName);
		
	} else if("type2" === type) {
		
		$("#custType2").val(itemCode);
		$("#custTypeNm2").val(itemName);
		
	}
}

//주소팝업 콜백
function addrPopCallback(data){
	$("#zipcode").val(data.zipcode);
	$("#addr").val(data.addr);
	$("#addrDetail").val('');
}

//업체유형 팝업 오픈
function openCustTypePop(type) {
	$("#itemType").val(type);
	$("#custTypePop").modal('show');
}


function fnAddrPopOpen(){
	initModal();
}

function fnIdcheck() {
	let userId = $("#userId").val();
	if (userId == null || userId == '') {
		Swal.fire('', '아이디를 입력해주세요.', 'warning');
		return;
	}
	
	$.post(
		'/api/v1/login/idcheck', 
		{ 'userId' : userId }
	)
	.done(function(arg) {
		if (arg.code === "OK") {
			Swal.fire('', '입력한 아이디를 사용할 수 있습니다.', 'info');
			$('#idcheck').prop('checked', true);
		}else{
			Swal.fire('', '입력한 아이디를 사용할 수 없습니다.', 'warning');
			$('#idcheck').prop('checked', false);
		}
	})
	
}

function validate() {
	let interrelatedCustCode = $("#interrelatedCustCode").val();
	let custType1 = $("#custType1").val();
	let custName = $("#custName").val();
	let presName = $("#presName").val();
	let regnum1 = $("#regnum1").val();
	let regnum2 = $("#regnum2").val();
	let regnum3 = $("#regnum3").val();
	let presJuminNo1 = $("#presJuminNo1").val();
	let presJuminNo2 = $("#presJuminNo2").val();
	let capital = $("#capital").val();
	let foundYear = $("#foundYear").val();
	let tel = $("#tel").val();
	let addrDetail = $("#addrDetail").val();
	let regnumFile = $("#regnumFile").val();
	let userName = $("#userName").val();
	let userEmail = $("#userEmail").val();
	let userId = $("#userId").val();
	let idcheck = $('input[id=idcheck]').is(':checked');
	let userPwd = $("#userPwd").val();
	let userPwdConfirm = $("#userPwdConfirm").val();
	let userHp = $("#userHp").val();
	let userTel = $("#userTel").val();
	
	if (!interrelatedCustCode) {
		Swal.fire('', '가입희망 계열사를 선택해주세요.', 'warning');
		return;
	}
	if (!custType1) {
		Swal.fire('', '업체유형1을 선택해주세요.', 'warning');
		return;
	}
	if (!custName) {
		Swal.fire('', '회사명을 입력해주세요.', 'warning');
		return;
	}
	if (!presName) {
		Swal.fire('', '대표자명을 입력해주세요.', 'warning');
		return;
	}
	if (!regnum1 || !regnum2 || !regnum3) {
		Swal.fire('', '사업자등록번호를 입력해주세요.', 'warning');
		return;
	}
	if (regnum1.length !== 3 || regnum2.length !== 2 || regnum3.length !== 5) {
		Swal.fire('', '사업자등록번호를 정확히 입력해주세요.', 'warning');
		return;
	}
	
	if (presJuminNo1 || presJuminNo2) {
		if (presJuminNo1.length !== 6 || presJuminNo2.length !== 7) {
			Swal.fire('', '법인번호를 정확히 입력해주세요.', 'warning');
			return;
		}
	}
	
	if (!capital || capital === 0) {
		Swal.fire('', '자본금을 입력해주세요.', 'warning');
		return;
	}
	if (!foundYear) {
		Swal.fire('', '설립년도를 입력해주세요.', 'warning');
		return;
	}
	if (foundYear.length !== 4) {
		Swal.fire('', '설립년도를 정확히 입력해주세요.', 'warning');
		return;
	}
	if (!tel) {
		Swal.fire('', '대표전화를 입력해주세요.', 'warning');
		return;
	}
	if (!addrDetail) {
		Swal.fire('', '회사주소를 입력해주세요.', 'warning');
		return;
	}
	if (!regnumFile) {
		Swal.fire('', '사업자등록증을 선택해주세요.', 'warning');
		return;
	}
	if (!userName) {
		Swal.fire('', '이름을 입력해주세요.', 'warning');
		return;
	}
	if (!userEmail) {
		Swal.fire('', '이메일을 입력해주세요.', 'warning');
		return;
	} else {
		const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
		if (!emailRegex.test(userEmail)) {
			Swal.fire('', '입력한 이메일 형식이 올바르지 않습니다.', 'warning');
			return;
		}
	}
  
	if (!userId) {
		Swal.fire('', '아이디를 입력해주세요.', 'warning');
		return;
	}
	if (!idcheck) {
		Swal.fire('', '아이디 중복확인을 확인해주세요.', 'warning');
		return;
	}
	if (!userPwd) {
		Swal.fire('', '비밀번호를 입력해주세요.', 'warning');
		return;
	}
	if (!userPwdConfirm) {
		Swal.fire('', '비밀번호 확인을 입력해주세요.', 'warning');
		return;
	}
	if (userPwd !== userPwdConfirm) {
		Swal.fire('', '비밀번호를 정확히 입력해주세요.', 'warning');
		return;
	}
	  // 비밀번호 유효성 검사를 위한 함수 호출 (예시)
	if (!fnPwdvaildation(userPwd)) {
		return;
	}

	if (!userHp) {
		Swal.fire('', '휴대폰번호를 입력해주세요.', 'warning');
		return;
	} else {
		const phoneNumberRegex = /^\d{3}-\d{3,4}-\d{4}$/;
		if (!phoneNumberRegex.test(onAddDashTel(userHp))) {
			Swal.fire('', '휴대폰번호 형식에 맞게 입력해주세요.', 'warning');
			return;
		}
	}
	if (!userTel) {
		Swal.fire('', '유선전화를 입력해주세요.', 'warning');
		return;
	} else {
		const telNumberRegex = /^\d{2,3}-\d{3,4}-\d{4}$/;
		if (!telNumberRegex.test(onAddDashTel(userTel))) {
			Swal.fire('', '유선전화 형식에 맞게 입력해주세요.', 'warning');
			return;
		}
	}
	
	Swal.fire({
		title: '',			  // 타이틀
		html: "입력하신 정보로 회원가입을 신청합니다.<br/>신정 후 승인까지 최대 3일 소요됩니다.<br/><br/>회원가입을 신청하시겠습니까?",  // 내용
		icon: 'question',						// success / error / warning / info / question
		confirmButtonColor: '#3085d6',  // 기본옵션
		confirmButtonText: '신청',	  // 기본옵션
		showCancelButton: true,		 // conrifm 으로 하고싶을떄
		cancelButtonColor: '#d33',	  // conrifm 에 나오는 닫기버튼 옵션
		cancelButtonText: '취소',	   // conrifm 에 나오는 닫기버튼 옵션
	}).then((result) => {
		if(result.isConfirmed){
			save();
		}
	});
};

function fnPwdvaildation(userPwd) {
	const password = userPwd;
	const hasUpperCase = /[A-Z]/.test(password);//대문자
	const hasLowerCase = /[a-z]/.test(password);//소문자
	const hasDigit = /\d/.test(password);//숫자
	const hasSpecialChar = /[!@#$%^&*()\-_=+{};:,<.>]/.test(password);//특수문자

	var isValidPassword = (hasUpperCase && hasLowerCase && hasDigit) || (hasUpperCase && hasLowerCase && hasSpecialChar) || (hasDigit && hasSpecialChar);
	var isValidLength = password.length >= 8 && password.length <= 16;

	if (!isValidPassword) {
		Swal.fire('', '비밀번호는 대/소문자, 숫자, 특수문자중에서 2가지 이상 조합되어야 합니다.', 'warning');
		return;
	} else if (!isValidLength) {
		Swal.fire('', '비밀번호는 8자 이상 16자 이하로 작성해주세요.', 'warning');
		return;
	}
	return true;
};

function save() {
	let regnumFile = document.getElementById('regnumFile').files[0];
	let bFile = document.getElementById('bFile').files[0];
	
	let srcData = {
		interrelatedCustCode: $("#interrelatedCustCode").val()
	,	custTypeNm1			: $("#custTypeNm1").val()
	,	custType1			: $("#custType1").val()
	,	custTypeNm2			: $("#custTypeNm2").val()
	,	custType2			: $("#custType2").val()
	,	custName			: $("#custName").val()
	,	presName			: $("#presName").val()
	,	regnum1				: $("#regnum1").val()
	,	regnum2				: $("#regnum2").val()
	,	regnum3				: $("#regnum3").val()
	,	presJuminNo1		: $("#presJuminNo1").val()
	,	presJuminNo2		: $("#presJuminNo2").val()
	,	capital				: $("#capital").val()
	,	foundYear			: $("#foundYear").val()
	,	tel					: $("#tel").val()
	,	fax					: $("#fax").val()
	,	zipcode				: $("#zipcode").val()
	,	addr				: $("#addr").val()
	,	addrDetail			: $("#addrDetail").val()
	,	userName			: $("#userName").val()
	,	userEmail			: $("#userEmail").val()
	,	userId				: $("#userId").val()
	,	idcheck				: $('input[id=idcheck]').is(':checked')
	,	userPwd				: $("#userPwd").val()
	,	userPwdConfirm		: $("#userPwdConfirm").val()
	,	userHp				: $("#userHp").val()
	,	userTel				: $("#userTel").val()
	,	userPosition		: $("#userPosition").val()
	,	userBuseo			: $("#userBuseo").val()
	}
	var formData = new FormData();

	if(regnumFile) {
		formData.append('regnumFile', regnumFile);
	}
	if(bFile) {
		formData.append('bFile', bFile);
	}
	formData.append('data', new Blob([JSON.stringify(srcData)], { type: 'application/json' }));
	
	$.ajax({
		url : '/api/v1/login/custSave', 
		type : 'POST',
		data : formData,
		processData: false,
		contentType: false,
	})
	.done(function(arg) {
		if (arg.code === "OK") {
			Swal.fire({
				title: '',			  // 타이틀
				html: "회원가입을 신청하였습니다.",  // 내용
				icon: 'info',						// success / error / warning / info / question
				confirmButtonColor: '#3085d6',  // 기본옵션
				confirmButtonText: '확인',	  // 기본옵션
			}).then((result) => {
				location.href="/";
			});
			
		} else {
			Swal.fire('', response.data.msg, 'error');
		}
	})
	
}

//첨부파일
function fnFileInputChange(id){
	let file = event.target.files[0];
	
	$("#emptyFile" + id).css("display", "none");
	$("#preview" + id).css("display", "block");
	
	$("#fileName" + id).text(file.name);
	
}

function fnEmptyFile(id){
	$("#emptyFile" + id).css("display", "flex");
	$("#preview" + id).css("display", "none");
	
	if(id === 1){
		$("#regnumFile").val('');
	}else{
		$("#bFile").val('');
	}
}
</script>
<body>
<!-- wrap -->
	<div id="wrap">
		<!-- header -->
		<div class="header">
			<div class="headerLeft">
				<a href="/" class="headerLogo" title="메인 페이지로 이동"><img src="/resources/images/bitcube_logo.png" class="img-responsive" alt="로고" style="width: 150px;"><span>e-Bidding System</span></a>
				<p>편하고 빠른 전자입찰시스템</p>
			</div>
		</div>
		<!-- //header -->

		<div class="joinWrap">
			<div class="inner">
				<div class="joinTop">
					<ul class="conHeaderCate">
						<li>회원가입</li>
						<li>회원가입</li>
					</ul>
				</div>
				<div class="conTopBox">
					<ul class="dList">
						<li><div>회원가입은 가입 신청 후 승인과정을 통해 정식으로 가입이 됩니다.<br>(가입 승인은 최대 3일 소요됩니다)</div></li>
						<li><div>가입 승인이 완료되면 관리자에게 이메일로 승인 되었음을 알려드립니다.</div></li>
						<li><div>회원가입 <span class="star">*</span> 부분은 필수 입력 정보 입니다.</div></li>
					</ul>
				</div>

				<h3 class="h3Tit mt50">회사 정보</h3>
				<div class="boxSt mt20">
					<div class="flex align-items-center">
						<div class="formTit flex-shrink0 width170px">가입희망 계열사 <span class="star">*</span></div>
						<div class="width100">
							<select name="interrelatedCustCode" id="interrelatedCustCode" class="selectStyle">
								<option value="">계열사를 선택해 주세요</option>
							</select>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">업체유형 1 <span class="star">*</span></div>
						<div class="flex align-items-center width100">
							<input type="text" name="custTypeNm1" id="custTypeNm1" class="inputStyle readonly" placeholder="우측 검색 버튼을 클릭해 주세요" readonly>
							<input type="text" name="custType1" id="custType1" class="inputStyle readonly" style="display:none;">
							<a href="javascript:openCustTypePop('type1')" class="btnStyle btnSecondary ml10" title="조회">조회</a>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">업체유형 2</div>
						<div class="flex align-items-center width100">
							<input type="text" name="custTypeNm2" id="custTypeNm2" class="inputStyle readonly" placeholder="우측 검색 버튼을 클릭해 주세요" readonly>
							<input type="text" name="custType2" id="custType2" class="inputStyle readonly" style="display:none;">
							<a href="javascript:openCustTypePop('type2')" class="btnStyle btnSecondary ml10" title="조회">조회</a>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">회사명 <span class="star">*</span></div>
						<div class="width100">
							<input type="text" name="custName" id="custName" class="inputStyle" placeholder="" maxLength="100">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">대표자명 <span class="star">*</span></div>
						<div class="width100">
							<input type="text" name="presName" id="presName" class="inputStyle" placeholder="" maxLength="100">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">사업자등록번호 <span class="star">*</span></div>
						<div class="flex align-items-center width100">
							<input type="text" name="regnum1" id="regnum1" class="inputStyle" placeholder="">
							<span style="margin:0 10px">-</span>
							<input type="text" name="regnum2" id="regnum2" class="inputStyle" placeholder="">
							<span style="margin:0 10px">-</span>
							<input type="text" name="regnum3" id="regnum3" class="inputStyle" placeholder="">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">법인번호 </div>
						<div class="flex align-items-center width100">
							<input type="text" name="presJuminNo1" id="presJuminNo1" class="inputStyle" placeholder="">
							<span style="margin:0 10px">-</span>
							<input type="text" name="presJuminNo2" id="presJuminNo2" class="inputStyle" placeholder="">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">자본금 <span class="star">*</span></div>
						<div class="flex align-items-center width100">
							<input type="text" name="capital" id="capital" class="inputStyle" placeholder="ex) 10,000,000">
							<div class="ml10">원</div>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">설립년도 <span class="star">*</span></div>
						<div class="flex align-items-center width100">
							<input type="text" name="foundYear" id="foundYear" class="inputStyle" placeholder="ex) 2021">
							<div class="ml10">년</div>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">대표전화 <span class="star">*</span></div>
						<div class="width100">
							<input type="text" name="tel" id="tel" class="inputStyle" placeholder="">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">팩스</div>
						<div class="width100">
							<input type="text" name="fax" id="fax" class="inputStyle" placeholder="">
						</div>
					</div>
					<div class="flex mt10">
						<div class="formTit flex-shrink0 width170px">회사주소 <span class="star">*</span></div>
						<div class="width100">
							<div class="flex align-items-center width100">
								<input type="text" name="zipcode" id="zipcode" class="inputStyle readonly" placeholder="주소 조회 클릭" readonly>
								<a href="javascript:fnAddrPopOpen()" class="btnStyle btnSecondary flex-shrink0 ml10" title="주소 조회">주소 조회</a>
							</div>
							<div class="mt5"><input type="text" name="addr" id="addr" class="inputStyle readonly" placeholder="" readonly></div>
							<div class="mt5"><input type="text" name="addrDetail" id="addrDetail" class="inputStyle" placeholder="상세 주소 입력"></div>
						</div>
					</div>
					<div class="flex mt10">
						<div class="formTit flex-shrink0 width170px">사업자등록증 <span class="star">*</span></div>
						<div class="width100">
							<div class="upload-boxWrap">
							<!-- 다중파일 업로드 -->
								<div class="upload-box" id="emptyFile1">
									<input type="file" id="regnumFile" onchange="fnFileInputChange(1)">
									<div class="uploadTxt">
										<i class="fa-regular fa-upload"></i>
										<div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제)<br>파일 최대 10MB (등록 파일 개수 최대 1개)</div>
									</div>
								</div>
								<div class="uploadPreview" id="preview1" style="display:none;">
								<p style="line-height:80px;"><span id="fileName1"></span><button id="removeBtn" class="file-remove" onClick="fnEmptyFile(1)">삭제</button></p>
							</div>
							</div>
							<!-- //다중파일 업로드 -->
						</div>
					</div>
					<div class="flex mt10">
						<div class="formTit flex-shrink0 width170px">첨부파일 
							<!-- 툴팁 -->
							<i class="fas fa-question-circle toolTipSt ml5">
								<div class="toolTipText" style="width:420px;">
									<ul class="dList">
										<li><div>첨부파일은 간단한 업체 소개 자료 등의 파일을 첨부해 주십시오.</div></li>
										<li><div>1개  이상의 파일을 첨부하실 경우 Zip으로 압축하여 첨부해 주십시오</div></li>
										<li><div>파일은 10M 이상을 초과할 수 없습니다.</div></li>
									</ul>
								</div>
							</i>
							<!-- //툴팁 -->
						</div>
						<div class="width100">
							<!-- 다중파일 업로드 -->
							<div class="upload-boxWrap">
								<div class="upload-box" id="emptyFile2">
									<input type="file" id="bFile" onchange="fnFileInputChange(2)">
									<div class="uploadTxt">
										<i class="fa-regular fa-upload"></i>
										<div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제)<br>파일 최대 10MB (등록 파일 개수 최대 1개)</div>
									</div>
								</div>
								<div class="uploadPreview" id="preview2" style="display:none;">
									<p style="line-height:80px;"><span id="fileName2"></span><button id="removeBtn" class="file-remove" onClick="fnEmptyFile(2)">삭제</button></p>
								</div>
							</div>
							<!-- //다중파일 업로드 -->
						</div>
						
						<input type="text" class="inputStyle" id="itemType" style="display:none;" />
					</div>
				</div>



				<h3 class="h3Tit mt50">관리자 정보</h3>
				<div class="boxSt mt20">
					<div class="flex align-items-center">
						<div class="formTit flex-shrink0 width170px">이름 <span class="star">*</span></div>
						<div class="width100">
							<input type="text" name="userName" id="userName" class="inputStyle" maxLength="50">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">이메일 <span class="star">*</span></div>
						<div class="width100">
							<input type="text" name="userEmail" id="userEmail" class="inputStyle" placeholder="ex) sample@iljin.co.kr"  maxLength="100">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">아이디 <span class="star">*</span></div>
						<div class="flex align-items-center width100">
							<input type="text" name="userId" id="userId" class="inputStyle" placeholder="영문, 숫자 입력(8자 이내) 후 중복확인"  maxLength="100">
							<a href="javascript:fnIdcheck()" class="btnStyle btnSecondary flex-shrink0 ml10" title="중복 확인">중복 확인</a>
							<input type="checkbox" id="idcheck" style="display:none;"/>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">비밀번호 <span class="star">*</span></div>
						<div class="width100">
							<input type="password" name="userPwd" id="userPwd" class="inputStyle" placeholder="대/소문자, 숫자, 특수문자 2 이상 조합(길이 8~16자리)"  maxLength="100">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">비밀번호 확인 <span class="star">*</span></div>
						<div class="width100">
							<input type="password" name="userPwdConfirm" id="userPwdConfirm" class="inputStyle" placeholder="비밀번호와 동일해야 합니다.">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">휴대폰 <span class="star">*</span></div>
						<div class="width100">
							<input type="text" name="userHp" id="userHp" class="inputStyle" placeholder="">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">유선전화 <span class="star">*</span></div>
						<div class="width100">
							<input type="text" name="userTel" id="userTel" class="inputStyle" placeholder="">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">직급</div>
						<div class="width100">
							<input type="text" name="userPosition" id="userPosition" class="inputStyle" placeholder="">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width170px">부서</div>
						<div class="width100">
							<input type="text" name="userBuseo" id="userBuseo" class="inputStyle" placeholder="">
						</div>
					</div>
				</div>

				<div class="text-center mt50">
					<a href="javascript:validate()" class="btnStyle btnPrimary btnMd" title="회원가입 신청">회원가입 신청</a>
				</div>

				
			</div>
			<div class="subFooter mt50">
				© ILJIN ALL RIGHTS RESERVED.
				<div class="subFooterUtill">
					<a href="/#" title="공동인증서">공동인증서</a>
					<a href="/#" data-toggle="modal" data-target="#regProcess" title="업체등록절차">업체등록절차</a>
					<a href="/#" data-toggle="modal" data-target="#biddingInfo" title="입찰업무안내">입찰업무안내</a>
				</div>
			</div>
		</div>

	</div>
	<!-- //wrap -->
	
	<!-- 업체유형 팝업 -->
	<jsp:include page="/WEB-INF/jsp/join/custTypePop.jsp" />
	
	<!-- 주소 팝업 -->
	<jsp:include page="/WEB-INF/jsp/join/addrPop.jsp" />
	
	<!-- 업체등록절차 팝업 -->
	<jsp:include page="/WEB-INF/jsp/layout/regProcessPop.jsp" />
	
	<!-- 입찰업무안내 팝업 -->
	<jsp:include page="/WEB-INF/jsp/layout/biddingInfoPop.jsp" />
</body>
</html>