<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.math.RoundingMode"%>
<%@ page import="bitcube.framework.ebid.etc.util.Constances" %>
<%@ page import="bitcube.framework.ebid.dto.UserDto" %>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%
	Map<String, Object>				data = (Map<String, Object>) request.getAttribute("biInfo");
	ObjectMapper					objectMapper = new ObjectMapper();
	String							jsonData = objectMapper.writeValueAsString(data);
%>
<!DOCTYPE html>
<script>
function onClosePop(){
	$("#bidProgressDel").modal("hide");
}

function onBidProgressDel() {
	var delReason = $("#bidProgressDelDelReason").val().trim();
	if(delReason == "") {
		Swal.fire('', '삭제 사유를 입력해 주세요.', 'warning');
		return;
	}
	
	var data = <%= jsonData %>;
	var params = {
		biNo : data.biNo,
		biName : data.biName,
		type : "del",
		cuserCode : data.createUser,
		gongoIdCode : data.gongoId,
		biModeCode : data.biMode,
		reason : delReason
	}
	
	$.post(
			"/api/v1/bid/delete",
			params
			)
			.done(function(arg) {
				if (arg.code === "OK") {
					
					Swal.fire({
						title: '',
						text: "입찰계획이 삭제되었습니다.",
						icon: 'success',
						confirmButtonText: '확인',
					}).then((result) => {
						if (result.isConfirmed) {
							onClosePop();
							onMovePage();
						}
					});
					
				} else {
					Swal.fire('입찰계획 삭제를 실패하였습니다.', '', 'error');
					return;
				}
			});
}

</script>
<div class="modal fade modalStyle" id="bidProgressDel" data-backdrop="static" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:576px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">입찰계획 삭제</h2>
				<div class="modalTopBox">
					<ul>
						<li>
							입찰 계획 삭제 시 지정된 사용자에게 삭제 메일이 발송됩니다.
						</li>
						<li>
							아래 삭제 사유 내용으로 공지자에게 발송됩니다.
						</li>
					</ul>
				</div>
				<textarea class="textareaStyle height150px mt20" id="bidProgressDelDelReason"></textarea>
				<div class="modalFooter">
					<a class="modalBtnClose" data-dismiss="modal" onClick="onClosePop()" title="취소">취소</a>
					<a class="modalBtnCheck" title="삭제" onClick="onBidProgressDel()">삭제</a>
				</div>
			</div>
		</div>
	</div>
</div>
