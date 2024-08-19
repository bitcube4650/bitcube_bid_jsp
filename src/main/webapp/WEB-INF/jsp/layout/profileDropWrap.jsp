<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bitcube.framework.ebid.etc.util.Constances" %>
<%@ page import="bitcube.framework.ebid.dto.UserDto" %>
<%
	UserDto userDto = (UserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String custType = userDto.getCustType();
%>
<script type="text/javascript">
	$(function(){
		$("#confirmPassword").keydown(function(e){
			if(e.keyCode==13) {
				fnCheckPwd();
			}
		});
		
		$("#info_userHp").keydown(function(e){
			let text = e.target.value;
			text= text.replace(/[^0-9]/g, '');
			$("#info_userHp").val(text);
		});
		
		$("#info_userTel").keydown(function(e){
			let text = e.target.value;
			text= text.replace(/[^0-9]/g, '');
			$("#info_userTel").val(text);
		});
		
	});

	function fnCheckPwd(){
		let loginInfo = localStorage.getItem("loginInfo") == null ? {} : JSON.parse(localStorage.getItem("loginInfo"));
		let modPop = $("#modPop").val();
		
		$.post(
			"/api/v1/main/checkPwd",
			{ password : $("#confirmPassword").val() }
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				if(arg.data){
					if("info" === modPop) {
						fnUserInfo();
					} else if ("pwd" === modPop) {
						// 비밀번호 변경
						$("#modPwd").modal('show');
					} else {
						Swal.fire('', '잘못된 접근입니다.', 'warning');
					}
				} else {
					Swal.fire('', '비밀번호가 일치하지 않습니다.', 'warning');
				}
			}
		})
		.always(function(arg){
			$("#checkPwdPop").modal('hide');
			$("#confirmPassword").val('');
		})
	}
	
	function fnUserInfo(){
		let loginInfo = localStorage.getItem("loginInfo") == null ? {} : JSON.parse(localStorage.getItem("loginInfo"));
		$.post(
			"/api/v1/main/selectUserInfo",
			{}
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				let data = arg.data;
				
				$("#info_userId").text(loginInfo.userId);
				$("#info_userName").text(loginInfo.userName);
				$("#info_pwdEditDate").text(data.pwdEditDate);
				$("#info_userHp").val(data.userHp);
				$("#info_userTel").val(data.userTel);
				$("#info_userEmail").val(data.userEmail);
				$("#info_userPosition").val(data.userPosition);
				$("#info_deptName").val(data.deptName);
				
				if(loginInfo.custType === 'inter'){
					$("#info_custName").text(loginInfo.custName);
					
					let ko_userAuth = loginInfo.userAuth === '1' ? '시스템관리자' : (loginInfo.userAuth === '2' ? '각사관리자' : (loginInfo.userAuth === '3' ? '일반관리자' : (loginInfo.userAuth === '4' ? '감사사용자' : '')));
					$("#info_userAuth").text(ko_userAuth);
					
					if(data.bidauth === "1") $('#info_bidauth').prop('checked',true);
					if(data.openauth === "1") $('#info_openauth').prop('checked',true);
				}
				
				$("#infoPop").modal('show');
			}else{
				Swal.fire('', '사용자 정보를 불러오지 못했습니다.', 'warning');
			}
		})
		.always(function(arg){
			$("#checkPwdPop").modal('hide');
			$("#confirmPassword").val('');
		})
		
	}
	
	function fnInfoSave(){
		let userHp = $("#info_userHp").val();
		let userTel = $("#info_userTel").val();
		let userEmail = $("#info_userEmail").val();
		let userPosition = $("#info_userPosition").val();
		let userBuseo = $("#info_userBuseo").val();
		
		if(userHp == null || userHp == ''){
			Swal.fire('', '휴대폰 번호를 입력해주세요', 'warning');
			return false;
		}else if(userTel == null || userTel == ''){
			Swal.fire('', '유선전화 번호를 입력해주세요', 'warning');
			return false;
		}else if(userEmail == null || userEmail == ''){
			Swal.fire('', '이메일을 입력해주세요', 'warning');
			return false;
		}else if(!validateEmail(userEmail)){
			Swal.fire('', '이메일 형식에 맞게 입력해주세요', 'warning');
			return false;
		}
		
		userHp = userHp.replace(/[^0-9]/g, '');
		userTel = userTel.replace(/[^0-9]/g, '');
		
		let params = {
			"userHp" : userHp
		,	"userTel" : userTel
		,	"userEmail" : userEmail
		,	"userPosition" : userPosition
		,	"userBuseo" : userBuseo
		}
		
		console.log(params);
		
		$.post(
			"/api/v1/main/saveUserInfo",
			params
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				$("#infoPop").modal('hide');
				Swal.fire('', '개인정보를 수정하였습니다.', 'info');
			}else{
				Swal.fire('', '개인정보를 수정하지 못했습니다.', 'warning');
			}
		})
	}
	
	function validateEmail(email) {
		// 이메일 주소를 검사하기 위한 정규 표현식
		let regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/; 
		// 정규 표현식을 사용하여 이메일 주소를 검사하고 결과를 반환
		return regex.test(email);
	}
	
	function fnSavePwd(){
		
		let password = $("#savePwd").val();
		let checkSavePwd = $("#checkSavePwd").val();
		let hasUpperCase = /[A-Z]/.test(password);//대문자
		let hasLowerCase = /[a-z]/.test(password);//소문자
		let hasDigit = /\d/.test(password);//숫자
		let hasSpecialChar = /[!@#$%^&*()\-_=+{};:,<.>]/.test(password);//특수문자

		var isValidPassword = (hasUpperCase && hasLowerCase && hasDigit) || (hasUpperCase && hasLowerCase && hasSpecialChar) || (hasDigit && hasSpecialChar);
		var isValidLength = password.length >= 8 && password.length <= 16;
		var isSame = password == checkSavePwd 

		if(!isValidPassword){
			Swal.fire('', '비밀번호는 대/소문자, 숫자, 특수문자중에서 2가지 이상 조합되어야 합니다.', 'warning');
			return false;
		}else if(!isValidLength){
			Swal.fire('', '비밀번호는 8자 이상 16자 이하로 작성해주세요.', 'warning');
			return false;
		}else if(!isSame){
			Swal.fire('', '비밀번호 확인이 일치하지 않습니다.', 'warning');
			return false;
		}
		
		let params = {
			'password' : $("#savePwd").val()
		}
		$.post(
			"/api/v1/main/changePwd",
			params
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				Swal.fire('', '비밀번호를 저장하였습니다.', 'info');
			}else{
				Swal.fire('', '비밀번호가 일치하지 않습니다.', 'warning');
			}
		})
		.always(function(res){
			$("#modPwd").modal('hide');
		})
		
	}
</script>

<!-- 비밀번호 확인 모달 -->
<div class="modal fade modalStyle" id="checkPwdPop" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:510px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">비밀번호 확인</h2>
				<div class="flex align-items-center">
					<div class="formTit flex-shrink0 width100px">비밀번호</div>
					<div class="width100">
						<input type="password" name="password" id="confirmPassword" class="inputStyle"/>
					</div>
				</div>
				<p class="text-center mt20"><i class="fa-light fa-circle-info"></i> 안전을 위해서 비밀번호를 입력해 주십시오</p>
				<div class="modalFooter">
					<a href="javascript:void(0)" class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
					<a href="javascript:fnCheckPwd()" class="modalBtnCheck" title="확인">확인</a>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade modalStyle" id="infoPop" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:510px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">개인정보</h2>
				<div class="flex align-items-center">
					<div class="formTit flex-shrink0 width120px">로그인ID</div>
					<div class="width100"><span id="info_userId"></span></div>
				</div>
				<div class="flex align-items-center mt20">
					<div class="formTit flex-shrink0 width120px">이름</div>
					<div class="width100"><span id="info_userName"></span></div>
				</div>
<% if(custType.equals("inter")){ %>
				<div class="flex align-items-center mt20">
					<div class="formTit flex-shrink0 width120px">소속 계열사</div>
					<div class="width100"><span id="info_custName"></span></div>
				</div>
				<div class="flex align-items-center mt20">
					<div class="formTit flex-shrink0 width120px">사용자 권한</div>
					<div class="width100"><span id="info_userAuth"></span></div>
				</div>
				<div class="flex align-items-center mt20">
					<div class="formTit flex-shrink0 width120px">입찰권한</div>
					<div class="width100">
						<input type="checkbox" id="info_openauth" class="checkStyle" disabled />
						<label for="openauth">개찰</label>&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" id="info_bidauth" class="checkStyle" disabled />
						<label for="bidauth">낙찰</label>
					</div>
				</div>
<% } %>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width120px">비밀번호</div>
					<div class="flex align-items-center width100">
						<div class="width100">최종변경일 : <span id="info_pwdEditDate"></span></div>
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width120px">휴대폰 <span class="star">*</span></div>
					<div class="width100">
						<input type="text" name="userHp" id="info_userHp" class="inputStyle" maxLength="20"/>
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width120px">유선전화 <span class="star">*</span></div>
					<div class="width100">
					<input type="text" name="userTel" id="info_userTel" class="inputStyle" maxLength="20"/>
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width120px">이메일 <span class="star">*</span></div>
					<div class="width100">
						<input type="text" name="userEmail" id="info_userEmail" class="inputStyle" maxLength="100"/>
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width120px">직급</div>
					<div class="width100">
						<input type="text" name="userPosition" id="info_userPosition" class="inputStyle" maxLength="50" />
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width120px">부서</div>
					<div class="width100">
						<input type="text" name="deptName" id="info_deptName" class="inputStyle" maxLength="50" />
					</div>
				</div>
		
				<div class="modalFooter">
					<a href="javascript:void(0)" class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
					<a href="javascript:fnInfoSave()" class="modalBtnCheck" title="저장">저장</a>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade modalStyle" id="modPwd" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:510px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">비밀번호 변경</h2>
				<div class="flex align-items-center">
					<div class="formTit flex-shrink0 width120px">비밀번호</div>
					<div class="width100">
						<input type="password" id="savePwd" name="savePwd" class="inputStyle"/>
						<!-- <SrcInput name="savePwd" type="password" srcData={ srcData } setSrcData={ setSrcData } onSearch={ fnSavePwd } /> -->
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width120px">비밀번호 확인</div>
					<div class="width100">
						<input type="password" id="checkSavePwd" name="checkSavePwd" class="inputStyle"/>
						<!-- <SrcInput name="checkSavePwd" type="password" srcData={ srcData } setSrcData={ setSrcData } onSearch={ fnSavePwd } /> -->
					</div>
				</div>
				<div class="modalFooter">
					<a href="javascript:void(0)" class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
					<a href="javascript:fnSavePwd()" class="modalBtnCheck" title="확인">확인</a>
				</div>
			</div>
		</div>
	</div>
</div>

