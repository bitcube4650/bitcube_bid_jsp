<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	function onSearch() {
		$.post(
				"/api/v1/cust/userListForCust",
				{
					custCode : $("#custUserPopCustCode").val(),
				}
				).done(function(response){
					$("#custUserPopBody").empty();
					let html = ''
					
					if(response.code === 'OK') {
						const list = response.data.content;
					//	updatePagination(response.data);
						if(list.length > 0){
							for(var i=0;i<list.length;i++) {
								html += '<tr>';
								html += '</tr>';
								
								$("#custUserPopBody").html(html);
							}
						} else {
							html += '<tr>';
							html += '	<td colspan="7">조회된 결과가 없습니다.</td>';
							html += '</tr>';
							$("#custUserPopBody").html(html);
						}
					} else {
						html += '<tr>';
						html += '	<td colspan="7">조회된 결과가 없습니다.</td>';
						html += '</tr>';
						$("#custUserPopBody").html(html);
						
						Swal.fire('', response.msg, 'warning')
					}
				});
	}
	
	function onClosePop() {
		$("#bisPastBiNo").val();
		$("#bisPastBiName").val();
		
	//	$("#bidPast").hide();
	}
	
</script>
<div class="modal fade modalStyle" id="bidPast" data-backdrop="static" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:1100px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">과거입찰내역</h2>
				
				<div class="modalSearchBox mt20">
					<div class="flex align-items-center">
						<div class="sbTit mr30">입찰번호</div>
						<div class="width150px">
							<input type="text" id="bisPastBiNo" class="inputStyle">
						</div>
						<div class="sbTit mr30 ml50">입찰명</div>
						<div className="width150px">
							<input type="text" id="bisPastBiName" class="inputStyle">
						</div>
						<button class="btnStyle btnSearch" onclick="onSearch()">검색</button>
					</div>
				</div>
				
				<table class="tblSkin1 mt30">
					<colgroup>
						<col style="width: 123px"/>
						<col style="width: auto"/>
						<col style="width: 170px"/>
						<col style="width: 120px"/>
						<col style="width: 77px"/>
						<col style="width: 77px"/>
						<col style="width: 107px"/>
					</colgroup>
					<thead>
						<tr>
							<th>입찰번호</th>
							<th>입찰명</th>
							<th>제출마감일시</th>
							<th>입찰방식</th>
							<th>상태</th>
							<th>내역</th>
							<th class="end">선택</th>
						</tr>
					</thead>
					<tbody id="bidPastBody">
					</tbody>
				</table>

				<div class="row mt30">
					<div class="col-xs-12">
						<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
					</div>
				</div>
				
				<div class="modalFooter">
					<button class="modalBtnClose" title="닫기" data-dismiss="modal" onClick="onClosePop()" >닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>
