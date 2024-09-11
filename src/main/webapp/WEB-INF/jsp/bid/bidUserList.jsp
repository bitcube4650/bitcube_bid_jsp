<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="bitcube.framework.ebid.etc.util.Constances" %>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%@ page import="bitcube.framework.ebid.dto.UserDto" %>
<%
	UserDto userDto = (UserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String custCode = userDto.getCustCode();
%>
<!DOCTYPE html>
<script>
	function fnInitBidUserListPop() {
		var type = $("#type").val();
		
		$("#bidUserTitle").html(type + " 조회");
		
		$("#bidUserTopBox").empty();
		var str = "";
		if(type === "개찰자") {
			str += "<ul>";
			str += "<li>소속사의 낙찰권한을 가진 사용자만 조회됩니다. (사용자 조회 후 선택버튼을 누르십시오)</li>";
			str += "<li>개찰자가 조회되지 않을 경우 관리자에게 연락해 주십시오</li>";
			str += "</ul>";
		} else if(type === "낙찰자") {
			str += "<ul>";
			str += "<li>소속사의 낙찰권한을 가진 사용자만 조회됩니다. (사용자 조회 후 선택버튼을 누르십시오)</li>";
			str += "</ul>";
		} else {
			str += "<ul>";
			str += "<li>소속사 사용자를 조회합니다. (사용자 조회 후 선택버튼을 누르십시오)</li>";
			str += "</ul>";
		}
		$("#bidUserTopBox").append(str);
		
		bidUserListSearch(0);
	}
	
	function bidUserListSearch(page) {
		var custCode = "<%= custCode%>";
		var params = {
			userName : $("#bidUserListPopUserName").val(),
			deptName : $("#bidUserListPopDeptName").val(),
			type : $("#type").val() === '개찰자' ? 'openBidUser' : $("#type").val() === '낙찰자' ? 'biddingUser' : 'normalUser',
			interrelatedCD : custCode,
			size : 5,
			page : page
		}
		
		$.post(
			"/api/v1/bid/userList",
			params,
			function(response){
				if(response.code === 'OK') {
					var list = response.data.content;
					updatePagination(response.data);
					$("#bidUserListTable").empty();
					
					if(list.length > 0) {
						for(var i=0;i<list.length;i++) {
							var str = "";
							str += "<tr>";
							str += "<td>"+ list[i].deptName +"</td>";
							str += "<td>"+ list[i].userName +"</td>";
							str += "<td class='end'>";
							str += "<button class='btnStyle btnSecondary btnSm' title='선택' onclick='onUserSelect(\"" + list[i].userId + "\",\"" + list[i].userName + "\")'>선택</button>";
							str += "</td>";
							str += "</tr>";
							
							$("#bidUserListTable").append(str);
						}
					} else {
						$("#bidUserListTable").append(
							"<tr>" + 
								"<td class='end' colSpan=3>조회된 데이터가 없습니다.</td>" +
							"</tr>"
						)
					}
				} else {
					Swal.fire('조회에 실패하였습니다.', '', 'error');
				}
			},
			"json"
		);
	}
	
	function onUserSelect(userId, userName) {
		var type = $("#type").val();
		onUserListPopCallback(type, userId, userName);
		onCloseBidUserListPop();
	}
	
	function updatePagination(data) {
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
		paginationHtml += '<a onClick="onPage(' + firstPage + ')" title="첫 페이지로 이동"><i class="fa-light fa-chevrons-left"></i></a>';
	
		// 이전 페이지로 이동
		paginationHtml += '<a onClick="onPage(' + beforePage + ')" title="이전 페이지로 이동"><i class="fa-light fa-chevron-left"></i></a>';
	
		// 페이지 번호 링크 생성
		for (var i of pageList) {
			paginationHtml += '<a onClick="onPage(' + (i - 1) + ')" title="' + i + '페이지로 이동" class="' + (data.number + 1 === i ? 'number active' : 'number') + '">' + i + '</a>';
		}
	
		// 다음 페이지로 이동
		paginationHtml += '<a onClick="onPage(' + afterPage + ')" title="다음 페이지로 이동"><i class="fa-light fa-chevron-right"></i></a>';
	
		// 마지막 페이지로 이동
		paginationHtml += '<a onClick="onPage(' + lastPage + ')" title="마지막 페이지로 이동"><i class="fa-light fa-chevrons-right"></i></a>';
		
		$("#pageSpan").html(paginationHtml);
	}

	
	function onPage(page){
		bidUserListSearch(page);
	}
	
	function onCloseBidUserListPop() {
		$("#bidUserListPop").modal("hide");
	}
	
</script>
<div class="modal fade modalStyle" id="bidUserListPop" data-backdrop="static" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:800px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 id="bidUserTitle" class="modalTitle"></h2>
				
				<div id="bidUserTopBox" class="modalTopBox">
				</div>
				
				<div class="modalSearchBox mt20">
					<div class="flex align-items-center">
						<div class="sbTit mr30">사원명</div>
						<div class="width150px">
							<input type="text" id="bidUserListPopUserName" class="inputStyle" autocomplete="off">
						</div>
						<div class="sbTit mr30 ml50">부서명</div>
						<div className="width150px">
							<input type="text" id="bidUserListPopDeptName" class="inputStyle" autocomplete="off">
						</div>
						<button class="btnStyle btnSearch" onclick="bidUserListSearch(0)">검색</button>
						
						<input type="hidden" id="type">
					</div>
				</div>
				
				<table class="tblSkin1 mt30">
					<colgroup>
						<col/>
					</colgroup>
					<thead>
						<tr>
							<th>부서명</th>
							<th>사원명</th>
							<th class="end">선택</th>
						</tr>
					</thead>
					<tbody id="bidUserListTable">
					</tbody>
				</table>

				<div class="row mt30">
					<div class="col-xs-12">
						<div class="pagination1 text-center">
							<span id="pageSpan"></span>
						</div>
					</div>
				</div>
				
				<div class="modalFooter">
					<button class="modalBtnClose" title="닫기" onClick="onCloseBidUserListPop()" >닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>
