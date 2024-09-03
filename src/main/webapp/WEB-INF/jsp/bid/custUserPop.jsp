<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	function onSearch() {
		$.post(
				"/api/v1/cust/userListForCust",
				{
					custCode : $("#custUserPopCustCode").val(),
					userName : $('#custUserPopUserNm').val(),
					userId : $('#custUserPopLoginId').val(), 
					useYn : 'Y',
					size : 20,
					page : 0
				}
				).done(function(response){
					$("#custUserPopBody").empty();
					let html = ''
					
					if(response.code === 'OK') {
						const list = response.data.content;
						if(list.length > 0){
							for(var i=0;i<list.length;i++) {
								html += '<tr>';
								html += '	<td>'+ list[i].userName +'</td>';
								html += '	<td>'+ list[i].userId +'</td>';
								html += '	<td>'+ Ft.defaultIfEmpty(list[i].userBuseo,'')  +'</td>';
								html += '	<td>'+ Ft.defaultIfEmpty(list[i].userPosition,'') +'</td>';
								html += '	<td>'+ list[i].userEmail +'</td>';
								html += '	<td>'+ Ft.onAddDashTel(list[i].userTel) +'</td>';
								html += '	<td>'+ Ft.onAddDashTel(list[i].userHp) +'</td>';
								html += '	<td class="end">'+ (list[i].userType === '1' ? '업체관리자' : '사용자') +'</td>';
								html += '</tr>';
								
								$("#custUserPopBody").html(html);
							}
						} else {
							html += '<tr>';
							html += '	<td colspan="8">조회된 결과가 없습니다.</td>';
							html += '</tr>';
							$("#custUserPopBody").html(html);
						}
					} else {
						html += '<tr>';
						html += '	<td colspan="8">조회된 결과가 없습니다.</td>';
						html += '</tr>';
						$("#custUserPopBody").html(html);
						
						Swal.fire('', response.msg, 'warning')
					}
				});
	}
	
	function onClosePop() {
		$("#custUserPopUserNm").val();
		$("#custUserPopLoginId").val();
		$("#custUserPopCustCode").val();
		$("#custUserPopCustName").val();
		
		$("#custUserPop").hide();
	}
	
</script>
<div class="modal fade modalStyle" id="custUserPop" data-backdrop="static" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:1100px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">협력사 사용자</h2>
				
				<div class="modalSearchBox mt20">
					<div class="flex align-items-center">
						<div class="sbTit mr30">사용자명</div>
						<div class="width150px">
							<input type="text" id="custUserPopUserNm" class="inputStyle" autocomplete="off">
						</div>
						<div class="sbTit mr30 ml50">로그인 ID</div>
						<div className="width150px">
							<input type="text" id="custUserPopLoginId" class="inputStyle" autocomplete="off">
						</div>
						<button class="btnStyle btnSearch" onclick="onSearch()">검색</button>
						
						<input type="hidden" id="custUserPopCustCode">
						<input type="hidden" id="custUserPopCustName">
					</div>
				</div>
				
				<table class="tblSkin1 mt30">
					<colgroup>
						<col/>
					</colgroup>
					<thead>
						<tr>
							<th>사용자명</th>
							<th>로그인ID</th>
							<th>부서</th>
							<th>직급</th>
							<th>이메일</th>
							<th>전화번호</th>
							<th>휴대폰</th>
							<th class="end">권한</th>
						</tr>
					</thead>
					<tbody id="custUserPopBody">
					</tbody>
				</table>

				<div class="row mt30">
					<div class="col-xs-12">
						<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
					</div>
				</div>
				
				<div class="modalFooter">
					<button class="modalBtnClose" title="닫기" onClick="onClosePop()" >닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>
