<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
function onClosePop(){
	// 파라미터 초기화 및 팝업 닫기
	$("#succPopBiNo").val("");
	$("#succPopCustCode").val("");
	$("#succPopBiName").val("");
	$("#succPopSuccDetail").val("");
	
	$("#bidSuccessPop").hide();
}

function bidSucc() {
	var biNo		= $("#succPopBiNo").val();
	var custCode	= $("#succPopCustCode").val();
	var biName		= $("#succPopBiName").val();
	var succDetail	= $("#succPopSuccDetail").val();
	
	$.post(
			'/api/v1/bidstatus/bidSucc', 
			{
				biNo		: biNo,
				succCust	: custCode,
				succDetail	: succDetail,
				biName		: biName
			}
		)
		.done(function(arg) {
			if(arg.code === "OK") {
				Swal.fire({
					title: '',
					text: "낙찰 처리했습니다.",
					icon: 'success',
					confirmButtonText: '확인',
				}).then((result) => {
					if (result.isConfirmed) {
						onClosePop();
						onMovePage();
					}
				});
			} else {
				Swal.fire('', "낙찰 처리중 오류가 발생했습니다.", 'warning');
			}
		});
}

function onMovePage() {
	location.href="/api/v1/move?viewName=bid/status";
}

</script>
<div class="modal fade modalStyle" id="bidSuccessPop" data-backdrop="static" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:800px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">낙찰</h2>
				<div class="modalTopBox">
					<ul>
						<li>
							<div><span id="succPopCustName"></span> 업체로 낙찰 처리합니다.<br /> 아래 낙찰 시 추가합의 사항이 있을 경우 입력해 주십시오.<br />낙찰 하시겠습니까?</div>
						</li>
					</ul>
				</div>
				<textarea class="textareaStyle height150px mt20" placeholder="추가합의 사항(필수아님)" id="succPopSuccDetail"></textarea>
				<input type="hidden" id="succPopBiNo" />
				<input type="hidden" id="succPopCustCode" />
				<input type="hidden" id="succPopBiName" />
				<div class="modalFooter">
					<a class="modalBtnClose" data-dismiss="modal" onClick="onClosePop()" title="취소">취소</a>
					<a class="modalBtnCheck" title="낙찰" onClick="bidSucc()">낙찰</a>
				</div>
			</div>
		</div>
	</div>
</div>
