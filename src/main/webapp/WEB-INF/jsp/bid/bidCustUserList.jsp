<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(document).ready(function() {
		$('#allChk').change(function() {
			$('input[name="userDetail"]').prop('checked', this.checked);
		});
	});
	
	function onSearchBidCustUserList (page) {
		$.post(
			"/api/v1/custuser/userListForCust",
			{
				userName	: $("#bidCustUserListPopUserName").val()
			,	userId		: $("#bidCustUserListPopUserId").val()
			,	custCode	: $("#bidCustUserListCustCode").val()
			,	size		: 20
			,	page		: page
			,	useYn		: "Y"
			},
			function(response){
				if(response.code === 'OK') {
					var list = response.data.content;
					bidCustUserListUpdatePagination(response.data);
					$("#bidCustUserListPopTable").empty();
					
					if(list.length > 0) {
						for(var i=0;i<list.length;i++) {
							var str = "";
							str += "<tr>";
							str += "<td>";
							str += "<input type='checkbox' id="+ i + " name='userDetail'>";
							str += "</td>";
							str += "<td>"+ list[i].userName +"</td>";
							str += "<td>"+ list[i].userId +"</td>";
							str += "<td>"+ list[i].userBuseo +"</td>";
							str += "<td>"+ list[i].userPosition +"</td>";
							str += "<td>"+ list[i].userEmail +"</td>";
							str += "<td>"+ list[i].userTel +"</td>";
							str += "<td>"+ list[i].userHp +"</td>";
							str += "<td class='end'>";
							if(list[i].userType === "1") {
								str += "업체관리자";
							} else {
								str += "사용자";
							}
							str += "";
							str += "</td>";
							str += "</tr>";
							
							$("#bidCustUserListPopTable").append(str);
						}
					} else {
						$("#bidCustUserListPopTable").append(
							"<tr>" + 
								"<td class='end' colSpan=8>조회된 데이터가 없습니다.</td>" +
							"</tr>"
						)
					}
				} else {
					
				}
			},
			"json"
		);
	}
	
	// 저장
	function onSaveCustUser() {
		
	}
	
	function bidCustUserListUpdatePagination(data) {
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
	
		$("#bidCustUserListPageNumbers").html(paginationHtml);
	}

	
	function custOnPage(page){
		onSearchBidCustUserList(page);
	}
</script>
<div class="modal fade modalStyle" id="bidCustUserListPop" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog" style="width:100%; max-width:1200px">
		<div class="modal-content">
			<div class="modal-body">
				<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">협력사 사용자</h2>
				<div class="modalSearchBox mt20">
					<div class="flex align-items-center">
						<div class="sbTit mr30">사용자명</div>
						<div class="width150px">
							<input class="inputStyle" id="bidCustUserListPopUserName" />
						</div>
						<div class="sbTit mr30 ml50">로그인 ID</div>
						<div class="width150px">
							<input class="inputStyle" id="bidCustUserListPopUserId" />
						</div>
						<input type="hidden" id="bidCustUserListCustCode" />
						<input type="hidden" id="bidCustUserListCustName" />
						<button class="btnStyle btnSearch" onclick="onSearchBidCustUserList(0)">검색</button>
					</div>
				</div>
				<table class="tblSkin1 mt30">
					<colgroup>
						<col />
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" id="allChk" /></th>
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
					<tbody id="bidCustUserListPopTable">
					</tbody>
				</table>
				<div class="row mt30">
					<div class="col-xs-12">
						<div class="pagination1 text-center">
							<span id="bidCustUserListPageNumbers"></span>
						</div>
					</div>
				</div>
				<div class="modalFooter">
					<button class="modalBtnClose" title="닫기" onClick="onBidCustListModalHide()">닫기</button>
					<button class="btnStyle btnSecondary" title="저장" onClick="onSaveCustUser()">저장</button>
				</div>
			</div>
		</div>
	</div>
</div>
