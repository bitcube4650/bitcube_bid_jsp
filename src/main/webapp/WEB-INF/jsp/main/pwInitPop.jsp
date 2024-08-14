<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>

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
						<input type="password" name="password" id="editPw" />
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width120px">비밀번호 확인</div>
					<div class="width100">
						<input type="password" name="confirmPassword" id="editConfirmPw" />
					</div>
				</div>
		
				<div class="modalFooter">
					<a href="javascript:void(0)" id="pwInitModalClose" class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
					<a href="javascript:savePwd()" class="modalBtnCheck" data-toggle="modal" title="저장">저장</a>
				</div>
			</div>
		</div>
	</div>
</div>