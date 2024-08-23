<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
	<script>
	// 투찰정보 팝업
	function fnBidJoinCustListPop(biNo){
		$.post(
			'/api/v1/bidComplete/joinCustList',
			{
				biNo : biNo
			}
		).done(function(arg){
			$("#biNo").text('');
			$("#biName").text('');
			$("#custName").text('');
			
			$("#bidJoinCustListTbl tbody").empty();

			let text = "";
			if(arg.code == "ERROR") {
				Swal.fire('', arg.msg, 'error');
			} else {
				let result = arg.data;

				for(let i = 0; i < result.length; i++){
					if(result.length > 0){
						text += "<tr>"
						
						text += "	<td class='text-left "+(result[i].succYn == "Y" ? 'textHighlight' : '')+"'>"+result[i].custName+"</td>"
						text += "	<td class='text-right "+(result[i].succYn == "Y" ? 'textHighlight' : '')+"'>"+parseInt(result[i].esmtAmt).toLocaleString()+"</td>"
						text += "	<td class='end "+(result[i].succYn == "Y" ? 'textHighlight' : '')+"'>"+result[i].submitDate+"</td>"
						text += "</tr>"
						
						if(result[i].succYn == "Y"){
							$("#biNo").text(result[i].biNo);
							$("#biName").text(result[i].biName);
							$("#custName").text(result[i].custName);
						}
					}
				}
			}
			$("#bidJoinCustListTbl tbody").html(text);
		});
	}
	</script>
<!-- 	투찰 정보 팝업 -->
	<div class="modal fade modalStyle" id="bidJoinCustListPop" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:550px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle">투찰 정보</h2>
					<div class="modalBoxSt mt10">
						<div class="flex align-items-center">
							<div class="formTit flex-shrink0 width120px">입찰번호</div>
							<div class="width100" id="biNo"></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width120px">입찰명</div>
							<div class="width100" id="biName"></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width120px">낙찰업체</div>
							<div class="width100" id="custName"></div>
						</div>
					</div>
					<table class="tblSkin1 mt20" id="bidJoinCustListTbl">
						<colgroup>
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>업체명</th>
								<th>투찰가</th>
								<th class="end">투찰 일시</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
					<div class="modalFooter">
						<a data-dismiss="modal" title="닫기" class="modalBtnClose">닫기</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
