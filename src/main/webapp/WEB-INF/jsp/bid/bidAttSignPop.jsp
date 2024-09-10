<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
	<script>
		$(document).ready(function() {
			$("#attPw").keydown(function(e) {
				if(e.key === "Enter" || e.keyCode === 13) {
					onAttSign();
				}
			});
		});
		
		function onAttSign() {
			var attPw		= $("#attPw").val();
			var biNo		= $("#bidAttSignPopBiNo").val();
			var whoAtt		= $("#bidAttSignPopAtt").val();
			var attSignId	= $("#bidAttSignPopAttSignId").val();
			if (attPw === null || attPw === "") {
				Swal.fire('', '비밀번호를 입력해주세요.', 'error');
				return false;
			}
			
			var params = {
				biNo : biNo,
				whoAtt : whoAtt,			//몇번 입회자
				attSignId : attSignId,		//입회자 아이디
				attPw : attPw				//입회자 비밀번호
			}
			$.post(
					'/api/v1/bidstatus/attSign',
					params
			).done(function(arg) {
					if(arg.code === "OK") {
						onAttSignUpdate(whoAtt);
						Swal.fire('', '서명이 완료되었습니다.', 'success');
						onCloseAttSignPop();
					} else if(arg.code === "inValid") {
						Swal.fire('', '입회자 비밀번호가 올바르지 않습니다.', 'warning');
					} else {
						Swal.fire('', '입회자 서명 중 오류가 발생하였습니다.', 'error');
					}
			})
		}
		
		function onCloseAttSignPop() {
			$("#bidAttSignPopAtt").val("");
			$("#bidAttSignPopAttSignId").val("");
			$("#bidAttSignPop").modal("hide");
		}
		
	</script>
	<div class="modal fade modalStyle" id="bidAttSignPop" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:550px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle">입회자 확인</h2>
					<div class="modalTopBox">
						<ul>
							<div>개찰참석자의 로그인 비밀번호를 입력해주세요.</div>
						</ul>
					</div>
					<div class="flex align-items-center mt20">
						<div class="formTit flex-shrink0 width100px">비밀번호</div>
						<div class="width100">
							<input type="password" id="attPw" class="inputStyle" />
						</div>
					</div>
					<div class="modalFooter">
						<a onClick="onCloseAttSignPop()" class="modalBtnClose" data-bs-dismiss="modal" title="취소">취소</a>
						<a onClick="onAttSign()" class="modalBtnCheck" title="확인">확인</a>
					</div>
					
					<input type="hidden" id="bidAttSignPopAtt" />
					<input type="hidden" id="bidAttSignPopAttSignId" />
					<input type="hidden" id="bidAttSignPopBiNo" />
				</div>
			</div>
		</div>
	</div>
</body>
</html>
