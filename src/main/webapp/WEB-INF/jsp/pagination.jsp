<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="pagination1 text-center">
    <!-- 이전 페이지 그룹 이동 -->
    <a href="#" id="prevPageGroup" title="이전 페이지그룹 이동">
        <i class="fa-light fa-chevrons-left"></i>
    </a>
    
    <!-- 이전 페이지 이동 -->
    <a href="#" id="prevPage" title="이전 페이지로 이동">
        <i class="fa-light fa-chevron-left"></i>
    </a>
    
    <!-- 페이지 번호들 -->
    <span id="pageNumbers"></span>
    
    <!-- 다음 페이지 이동 -->
    <a href="#" id="nextPage" title="다음 페이지로 이동">
        <i class="fa-light fa-chevron-right"></i>
    </a>
    
    <!-- 다음 페이지 그룹 이동 -->
    <a href="#" id="nextPageGroup" title="끝페이지 다음 페이지로 이동">
        <i class="fa-light fa-chevrons-right"></i>
    </a>
</div>

<script>
	function initPagination(totalPages, currentPage, onPageChange) {
		updatePagination(totalPages, currentPage);
	}

	function updatePagination(totalPages, currentPage) {
		var paginationHtml = "";
		var itemsPerPageGroup = 5; // 페이지 그룹당 표시할 페이지 수
		var currentPageGroup = Math.floor(currentPage / itemsPerPageGroup);
		var startPage = currentPageGroup * itemsPerPageGroup + 1;
		var endPage = Math.min(startPage + itemsPerPageGroup - 1, totalPages);
		
		var beforePage	= (currentPage > 0 ? currentPage - 1 : 0);
		var afterPage	= (currentPage < totalPages - 1 ? currentPage + 1 : currentPage);
		
		// 이전 페이지 그룹
		paginationHtml += '<a onClick="onPage('+beforePage+')" data-page="' + beforePage + '" title="이전 페이지로 이동"><i class="fa-light fa-chevron-left"></i></a>';
		
		// 페이지 번호
		for (var i = startPage; i <= endPage; i++) {
			paginationHtml += '<a onClick="onPage('+(i - 1)+')" data-page="' + (i - 1) + '" title="' + i + '페이지로 이동" class="' + (i - 1 === currentPage ? 'number active' : 'number') + '">' + i + '</a>';
		}
		
		// 다음 페이지 그룹
		paginationHtml += '<a onClick="onPage('+afterPage+')" data-page="' + afterPage + '" title="다음 페이지로 이동"><i class="fa-light fa-chevron-right"></i></a>';
		
		$("#pageNumbers").html(paginationHtml);
	}
	
	function onPage(page){
		onSearch(page);
	}
</script>
