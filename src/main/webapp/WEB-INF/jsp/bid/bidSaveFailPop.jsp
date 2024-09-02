<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	function onCloseSaveFailPop() {
		$("#bidSaveFailPopBiNo").val("");
		$("#bidSaveFailPopBiName").val("");
		$("#bidSaveFailePopReason").val("");
		
		$("#bidSaveFailPop").hide();
	}
	
	function bidFailure() {
		var biNo	= $("#bidSaveFailPopBiNo").val();
		var reason	= $("#bidSaveFailePopReason").val().trim();
		var biName	= $("#bidSaveFailPopBiName").val();
		
		if(reason == "") {
			Swal.fire('', '유찰사유를 입력해주세요.', 'warning');
			return;
		}
		
		$.post(
				'/api/v1/bidstatus/bidFailure', 
				{
					biNo		: biNo,
					reason		: reason,
					type		: 'fail',
					biName		: biName
				}
			)
			.done(function(arg) {
				if(arg.code === "OK") {
					Swal.fire({
						title: '',
						text: "유찰 처리 되었습니다.",
						icon: 'success',
						confirmButtonText: '확인',
					}).then((result) => {
						if (result.isConfirmed) {
							onCloseSaveFailPop();
							onMovePage();
						}
					});
				}else{
					Swal.fire('', arg.data.msg, 'warning');
				}
			});
	}
	
	function onMovePage() {
		location.href="/api/v1/move?viewName=bid/status";
	}
</script>
<div class="modal fade modalStyle" id="bidSaveFailPop" data-backdrop="static" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:800px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">유찰</h2>
				<div class="modalTopBox">
					<ul>
						<li>
							<div>유찰처리 합니다.<br/>유찰처리 시 참가업체에게 유찰 메일이 발송됩니다.<br />유찰 처리 시 유찰 사유 내용으로 업체에게 발송 됩니다.</div>
						</li>
					</ul>
				</div>
				<textarea class="textareaStyle height150px mt20" placeholder="유찰사유 필수 입력" id="bidSaveFailePopReason"></textarea>
				<input type="hidden" id="bidSaveFailPopBiNo" />
				<input type="hidden" id="bidSaveFailPopBiName" />
				<div class="modalFooter">
					<a class="modalBtnClose" onClick="onCloseSaveFailPop()" title="취소">취소</a>
					<a class="modalBtnCheck" onClick="bidFailure()" title="유찰">유찰</a>
				</div>
			</div>
		</div>
	</div>
</div>
