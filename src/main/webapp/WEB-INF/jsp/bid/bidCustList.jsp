<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(document).ready(function() {
		$("#bidCustListPopCustName").keydown(function(event) {
			if (event.key === "Enter") {
				onSearchBidCustList(0);
			}
		});
		
		$("#bidCustListPopChairman").keydown(function(event) {
			if (event.key === "Enter") {
				onSearchBidCustList(0);
			}
		});
	});
	
	// init
	function fnInitBidCustListPop() {
		onSearchBidCustList(0);
	}
	
	function onSearchBidCustList(page) {
		var custName	= $("#bidCustListPopCustName").val();
		var chairman	= $("#bidCustListPopChairman").val();
		
		$.post(
			"/api/v1/bid/custList",
			{
				custName	: custName
			,	chairman	: chairman
			,	size		: 5
			,	page		: page
			},
			function(response){
				if(response.code === 'OK') {
					var list = response.data.content;
					bidCustListUpdatePagination(response.data);
					$("#bidCustListPopTable").empty();
					
					if(list.length > 0) {
						for(var i=0;i<list.length;i++) {
							var str = "";
							str += "<tr>";
							str += "<td>"+ list[i].custName +"</td>";
							str += "<td>"+ list[i].combinedAddr +"</td>";
							str += "<td>"+ list[i].presName +"</td>";
							str += "<td class='end'>";
							str += "<button class='btnStyle btnSecondary btnSm' title='선택' onclick='onBidCustSelect(\"" + list[i].custCode + "\",\"" + list[i].custName + "\")'>선택</button>";
							str += "</td>";
							str += "</tr>";
							
							$("#bidCustListPopTable").append(str);
						}
					} else {
						$("#bidCustListPopTable").append(
							"<tr>" + 
								"<td class='end' colSpan=4>조회된 데이터가 없습니다.</td>" +
							"</tr>"
						)
					}
				} else {
					
				}
			},
			"json"
		);
	}
	
	function onBidCustSelect(srcCustCode, srcCustName) {
		const hasCustCode = custContent.some(item => item.custCode == srcCustCode);
		if (!hasCustCode) {
			onBidCustUserListModal(srcCustCode, srcCustName);
		} else {
			Swal.fire('이미 등록된 업체입니다.', '', 'error');
		}
	}
	
	function onBidCustUserListModal(srcCustCode, srcCustName) {
		$("#bidCustUserListCustCode").val(srcCustCode);
		$("#bidCustUserListCustName").val(srcCustName);
		$("#bidCustUserListPop").modal("show");
		onSearchBidCustUserList(0);
	}
	
	function onBidCustListClose() {
		$("#bidCustListPop").modal("hide");
	}
	
	function bidCustListUpdatePagination(data) {
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
		paginationHtml += '<a onClick="bidCustListOnPage(' + firstPage + ')" title="첫 페이지로 이동"><i class="fa-light fa-chevrons-left"></i></a>';
	
		// 이전 페이지로 이동
		paginationHtml += '<a onClick="bidCustListOnPage(' + beforePage + ')" title="이전 페이지로 이동"><i class="fa-light fa-chevron-left"></i></a>';
	
		// 페이지 번호 링크 생성
		for (var i of pageList) {
			paginationHtml += '<a onClick="bidCustListOnPage(' + (i - 1) + ')" title="' + i + '페이지로 이동" class="' + (data.number + 1 === i ? 'number active' : 'number') + '">' + i + '</a>';
		}
	
		// 다음 페이지로 이동
		paginationHtml += '<a onClick="bidCustListOnPage(' + afterPage + ')" title="다음 페이지로 이동"><i class="fa-light fa-chevron-right"></i></a>';
	
		// 마지막 페이지로 이동
		paginationHtml += '<a onClick="bidCustListOnPage(' + lastPage + ')" title="마지막 페이지로 이동"><i class="fa-light fa-chevrons-right"></i></a>';
	
		$("#bidCustListPageNumbers").html(paginationHtml);
	}

	
	function bidCustListOnPage(page){
		onSearchBidCustList(page);
	}
</script>
<div class="modal fade modalStyle" id="bidCustListPop" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog" style="width:100%; max-width:1200px">
		<div class="modal-content">
			<div class="modal-body">
				<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">업체조회</h2>
				<div class="modalTopBox">
					<ul>
						<li>
							<div>계열사에 등록되어 있는 업체리스트를 조회합니다</div>
						</li>
					</ul>
				</div>
				<div class="modalSearchBox mt20">
					<div class="flex align-items-center">
						<div class="sbTit mr30">업체명</div>
						<div class="width150px">
							<input class="inputStyle" id="bidCustListPopCustName" maxLength="50" />
						</div>
						<div class="sbTit mr30 ml50">대표자명</div>
						<div class="width150px">
							<input class="inputStyle" id="bidCustListPopChairman" maxLength="25" />
						</div>
						<button class="btnStyle btnSearch" onclick="onSearchBidCustList(0)">검색</button>
					</div>
				</div>
				<table class="tblSkin1 mt30">
					<colgroup>
						<col />
					</colgroup>
					<thead>
						<tr>
							<th>업체명</th>
							<th>주소</th>
							<th>대표자명</th>
							<th class="end">선택</th>
						</tr>
					</thead>
					<tbody id="bidCustListPopTable">
					</tbody>
				</table>
				<div class="row mt30">
					<div class="col-xs-12">
						<div class="pagination1 text-center">
							<span id="bidCustListPageNumbers"></span>
						</div>
					</div>
				</div>
				<div class="modalFooter">
					<button class="modalBtnClose" title="닫기" onclick="onBidCustListClose()">닫기</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 협력사 사용자 팝업 -->
	<jsp:include page="/WEB-INF/jsp/bid/bidCustUserList.jsp" />
</div>
