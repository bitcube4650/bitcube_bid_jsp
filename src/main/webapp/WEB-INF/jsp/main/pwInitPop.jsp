<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
function fnPwInitSave() {
	const password = $("#editPw").val();
	const passwordChk = $("#editConfirmPw").val();
	const hasUpperCase = /[A-Z]/.test(password);//대문자
	const hasLowerCase = /[a-z]/.test(password);//소문자
	const hasDigit = /\d/.test(password);//숫자
	const hasSpecialChar = /[!@#$%^&*()\-_=+{};:,<.>]/.test(password);//특수문자

	const isValidPassword = (hasUpperCase && hasLowerCase && hasDigit) || (hasUpperCase && hasLowerCase && hasSpecialChar) || (hasDigit && hasSpecialChar);
	const isValidLength = password.length >= 8 && password.length <= 16;
	const isSame = password == passwordChk

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
	
	$.post(
		"/api/v1/main/changePwd",
		{}
	)
	.done(function(arg) {
		$("#editPw").val('');
		$("#editConfirmPw").val('');
		
		if (arg.code === "OK") {
			Swal.fire('', '비밀번호를 저장하였습니다.', 'info');
			$("#pwInitModalClose").click();
		}else{
			Swal.fire('', '비밀번호 변경에 실패하였습니다.', 'warning');
		}
	})
}

</script>
<div class="modal fade modalStyle" id="pwInit" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:510px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">비밀번호 변경</h2>
				<div class="modalTopBox" style="margin-bottom:15px">
					<ul>
						<li>
							<div>비밀번호가 초기화 되었거나 1년 이상 암호를<br/>변경하지 않았을 경우 비밀번호를 변경 하셔야 합니다.</div>
						</li>
					</ul>
				</div>
				<div class="flex align-items-center">
					<div class="formTit flex-shrink0 width120px">비밀번호</div>
					<div class="width100">
						<input type="password" name="password" id="editPw" class="inputStyle"/>
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width120px">비밀번호 확인</div>
					<div class="width100">
						<input type="password" name="confirmPassword" id="editConfirmPw" class="inputStyle"/>
					</div>
				</div>
				<div class="modalFooter">
					<a href="javascript:void(0)" id="pwInitModalClose" class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
					<a href="javascript:fnPwInitSave()" class="modalBtnCheck" title="저장">저장</a>
				</div>
			</div>
		</div>
	</div>
</div>