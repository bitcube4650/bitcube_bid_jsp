<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	function custUserPopOnSearch(page) {
		$.post(
				"/api/v1/cust/userListForCust",
				{
					custCode : $("#custUserPopCustCode").val(),
					userName : $('#custUserPopUserNm').val(),
					userId : $('#custUserPopLoginId').val(), 
					useYn : 'Y',
					size : 5,
					page : page
				}
				).done(function(response){
					$("#custUserPopBody").empty();
					let html = ''
					
					if(response.code === 'OK') {
						const list = response.data.content;
						custUserUpdatePagination(response.data);
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
		$("#custUserPop").modal('show');
	}
	
	function onClosePop() {
		$("#custUserPopUserNm").val('');
		$("#custUserPopLoginId").val('');
		$("#custUserPopCustCode").val('');
		$("#custUserPopCustName").val('');
		
		$("#custUserPop").modal('hide');
	}
	
	function custUserUpdatePagination(data) {
		var curr = Math.floor(data.number / 5);
		var lastGroup = Math.floor((data.totalPages - 1) / 5);
		var pageList = [];
	
		// 현재 그룹의 페이지들을 계산하여 pageList에 추가
		var startPage = curr * 5 + 1;
		var endPage = Math.min(startPage + 4, data.totalPages);
		for (var i = startPage; i <= endPage; i++) {
		    pageList.push(i);
		}
	
		// 이전 페이지와 다음 페이지 계산
		var beforePage = data.number === 0 ? 0 : data.number - 1;
		var afterPage = data.number === data.totalPages - 1 ? data.number : data.number + 1;
	
		// 첫 페이지와 마지막 페이지 계산
		var firstPage = 0;
		var lastPage = data.totalPages - 1;
	
		// 페이지 네비게이션 HTML 생성
		var paginationHtml = "";
	
		// 첫 페이지로 이동
		paginationHtml += '<a onClick="custOnPage(' + firstPage + ')" title="첫 페이지로 이동"><i class="fa-light fa-chevrons-left"></i></a>';
	
		// 이전 페이지로 이동
		paginationHtml += '<a onClick="custOnPage(' + beforePage + ')" title="이전 페이지로 이동"><i class="fa-light fa-chevron-left"></i></a>';
	
		// 페이지 번호 링크 생성
		for (var i of pageList) {
			paginationHtml += '<a onClick="custOnPage(' + (i - 1) + ')" title="' + i + '페이지로 이동" class="' + (data.number + 1 === i ? 'number active' : 'number') + '">' + i + '</a>';
		}
	
		// 다음 페이지로 이동
		paginationHtml += '<a onClick="custOnPage(' + afterPage + ')" title="다음 페이지로 이동"><i class="fa-light fa-chevron-right"></i></a>';
	
		// 마지막 페이지로 이동
		paginationHtml += '<a onClick="custOnPage(' + lastPage + ')" title="마지막 페이지로 이동"><i class="fa-light fa-chevrons-right"></i></a>';
	
		$("#custPageNumbers").html(paginationHtml);
	}

	
	function custOnPage(page){
		custUserPopOnSearch(page);
	}
</script>
<div class="modal fade modalStyle" id="custUserPop" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:1100px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">협력사 사용자</h2>
				
				<div class="modalSearchBox mt20">
					<div class="flex align-items-center">
						<div class="sbTit mr30">사용자명</div>
						<div class="width150px">
							<input type="text" id="custUserPopUserNm" class="inputStyle" autocomplete="off" onKeyUp="javascript:if(event.keyCode==13) {custUserPopOnSearch(0)}">
						</div>
						<div class="sbTit mr30 ml50">로그인 ID</div>
						<div class="width150px">
							<input type="text" id="custUserPopLoginId" class="inputStyle" autocomplete="off" onKeyUp="javascript:if(event.keyCode==13) {custUserPopOnSearch(0)}">
						</div>
						<button class="btnStyle btnSearch" onclick="custUserPopOnSearch(0)">검색</button>
						
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
						<div class="pagination1 text-center">
							<span id="custPageNumbers"></span>
						</div>
					</div>
				</div>
				
				<div class="modalFooter">
					<button class="modalBtnClose" title="닫기" onClick="onClosePop()" >닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>
