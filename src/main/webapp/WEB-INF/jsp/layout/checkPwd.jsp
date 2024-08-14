<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<script type="text/javascript">
	function fnCloseCheckPwdPop(){
		$("#checkPwdPop").hide();
		modalType = '';
	}
	
	function fnCheckPwd(){
		console.log(modalType);
	}
</script>

<!-- 비밀번호 확인 모달 -->
<div class="modal fade modalStyle" id="checkPwdPop" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:510px">
		<div class="modal-content">
			<div class="modal-Body">
				<a href="#" onclick="fnCloseCheckPwdPop()" class="ModalClose" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">비밀번호 확인</h2>
				<div class="flex align-items-center">
					<div class="formTit flex-shrink0 width100px">비밀번호</div>
					<div class="width100">
						<input type="password" name="password" class="srcInput"/>
					</div>
				</div>
				<p class="text-center mt20"><i class="fa-light fa-circle-info"></i> 안전을 위해서 비밀번호를 입력해 주십시오</p>
				<div class="modalFooter">
					<a href="#" onclick="fnCloseCheckPwdPop()" class="modalBtnClose" title="닫기">닫기</a>
					<a href="#" onclick="fnCheckPwd()" class="modalBtnCheck" title="확인">확인</a>
				</div>
			</div>
		</div>
	</div>
</div>

</html>