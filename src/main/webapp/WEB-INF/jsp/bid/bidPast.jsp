<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	function bidPastInit() {
		onSearchBidPast(0);
	}
	
	function onSearchBidPast(page) {
		$.post(
				"/api/v1/bid/pastBidList",
				{
					biNo : $("#bisPastBiNo").val(),
					biName : $("#bisPastBiName").val(),
					size : 5,
					page : page
				}
				).done(function(response){
					$("#bidPastBody").empty();
					let html = ''
					if(response.code === 'OK') {
						const list = response.data.content;
						bidPastUpdatePagination(response.data);
						if(list.length > 0){
							for(var i=0;i<list.length;i++) {
								html += "<tr>";
								html += "<td>"+ list[i].biNo +"</td>";
								html += "<td>"+ list[i].biName +"</td>";
								html += "<td>"+ list[i].estCloseDate +"</td>";
								html += "<td>"+ list[i].biMode +"</td>";
								html += "<td>"+ list[i].ingTag +"</td>";
								html += "<td>"+ list[i].insMode +"</td>";
								html += "<td class='end'>";
								html += "<button class='btnStyle btnSecondary btnSm' title='선택' onclick='onBidPastSelect(\"" + list[i].biNo + "\")'>선택</button>";
								html += "</td>";
								html += "</tr>";
							}
							$("#bidPastBody").append(html);
						} else {
							html += '<tr>';
							html += '	<td colspan="7">조회된 결과가 없습니다.</td>';
							html += '</tr>';
							$("#bidPastBody").append(html);
						}
					} else {
						html += '<tr>';
						html += '	<td colspan="7">조회된 결과가 없습니다.</td>';
						html += '</tr>';
						$("#bidPastBody").append(html);
						Swal.fire('', response.msg, 'warning')
					}
				});
	}
	
	function onBidPastSelect(biNo) {
		onselectBidPastCallback(biNo);
		onCloseBidPastPop();
	}
	
	function onCloseBidPastPop() {
		$("#bidPast").modal("hide");
	}
	
	function bidPastUpdatePagination(data) {
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
		paginationHtml += '<a onClick="bidPastCustOnPage(' + firstPage + ')" title="첫 페이지로 이동"><i class="fa-light fa-chevrons-left"></i></a>';
	
		// 이전 페이지로 이동
		paginationHtml += '<a onClick="bidPastCustOnPage(' + beforePage + ')" title="이전 페이지로 이동"><i class="fa-light fa-chevron-left"></i></a>';
	
		// 페이지 번호 링크 생성
		for (var i of pageList) {
			paginationHtml += '<a onClick="bidPastCustOnPage(' + (i - 1) + ')" title="' + i + '페이지로 이동" class="' + (data.number + 1 === i ? 'number active' : 'number') + '">' + i + '</a>';
		}
	
		// 다음 페이지로 이동
		paginationHtml += '<a onClick="bidPastCustOnPage(' + afterPage + ')" title="다음 페이지로 이동"><i class="fa-light fa-chevron-right"></i></a>';
	
		// 마지막 페이지로 이동
		paginationHtml += '<a onClick="bidPastCustOnPage(' + lastPage + ')" title="마지막 페이지로 이동"><i class="fa-light fa-chevrons-right"></i></a>';
	
		$("#bidPastPage").html(paginationHtml);
	}

	
	function bidPastCustOnPage(page){
		onSearchBidPast(page);
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
						<button class="btnStyle btnSearch" onclick="onSearchBidPast(0)">검색</button>
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
						<div class="pagination1 text-center">
							<span id="bidPastPage"></span>
						</div>
					</div>
				</div>
				
				<div class="modalFooter">
					<button class="modalBtnClose" title="닫기" data-dismiss="modal" onClick="onCloseBidPastPop()" >닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>
