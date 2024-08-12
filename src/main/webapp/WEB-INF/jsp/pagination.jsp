<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="pagination1 text-center">
    <span id="pageNumbers"></span>
</div>

<script>
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
	
		$("#pageNumbers").html(paginationHtml);
	}

	
	function onPage(page){
		onSearch(page);
	}
</script>
