<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	function submitHistoryPopInit(biNo, custCode, custName, userName){
		$("#popList").empty();
		$.post(
				'/api/v1/bidstatus/submitHist', 
				{
					biNo		: biNo,
					custCode	: custCode,
					size		: 10,
					page		: 0
				}
			)
			.done(function(arg) {
				if(arg.code === "OK") {
					updatePagination(arg.data);
					
					var str = "";
					var data = arg.data.content;
					for(var i=0; i<data.length; i++) {
						str += "<tr>";
						str += "<td>"+ data[i].biOrder +"</td>";
						str += "<td>"+ custName +"</td>";
						str += "<td>"+ Ft.numberWithCommas(data[i].esmtAmt) +"</td>";
						str += "<td>"+ userName +"</td>";
						str += "<td class='end'>"+ data[i].submitDate +"</td>";
						str += "</tr>";
					}
					$("#popList").append(str);
				} else {
					Swal.fire('', arg.msg, 'error');
				}
			});
	}
</script>
<div class="modal fade modalStyle" id="submitHistPop" data-backdrop="static" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:800px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">제출 이력</h2>
				<table class="tblSkin1 mt20">
					<colgroup>
						<col />
					</colgroup>
					<thead>
						<tr>
							<th>차수</th>
							<th>입찰참가업체명</th>
							<th>견적금액(총액)</th>
							<th>담당자</th>
							<th class="end">제출일시</th>
						</tr>
					</thead>
					<tbody id="popList">
					</tbody>
				</table>
				
<!--				페이징-->
				<div class="row mt40">
					<div class="col-xs-12">
						<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
					</div>
				</div>
				
				<div class="modalFooter">
					<a class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
				</div>
				
			</div>
		</div>
	</div>
</div>
