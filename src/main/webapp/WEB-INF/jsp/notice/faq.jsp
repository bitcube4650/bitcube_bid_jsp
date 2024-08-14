<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		//initPagination(0,0,0);
		onSearch(0);
	});
	
	function onSearch(page){
		$.post("/api/v1/faq/faqList", {
			"title"		: $("#title").val(),
			"faqType"	: $("#faqType").val(),
			"admin"		: 'Y',
			"size"		: $("#pageSize").val(),
			"page"		: page
		}, function(response) {
			if(response.code === 'OK') {
				var list = response.data.content;
				updatePagination(response.data);
				$("#total").html(response.data.totalElements)
				$("#faqListBody").empty();
				for(var i=0;i<list.length;i++) {
					$("#faqListBody").append(
						"<tr>" +
							'<td>'+ list[i].faqTypeDescription +'</td>' +
							'<td className="text-left"><a data-toggle="modal" className="textUnderline notiTitle" title="FAQ 자세히 보기">'+ list[i].title+'</a></td>' +
							'<td>'+ list[i].userName +'</td>' +
							'<td>'+ list[i].createDate +'</td>'+
						"</tr>"
					);
				}
			} else {
				
			}
		},
		"json"
		);
	}
	
	function fnFaqExcelDown() {
		var time = Ft.formatDate(new Date(), "yyyy_mm_dd");
		var params = {
			"title": $("#title").val(),
			"faqType": $("#faqType").val(),
			"fileName":"FAQ_"+time,
			"dataJson" : [
				{
					'header' : "ID",
					'column' : "faqId"
				},
				{
					'header' : "구분",
					'column' : "faqTypeDescription"
				},
				{
					'header' : "제목",
					'column' : "title"
				},
				{
					'header' : "내용",
					'column' : "answer"
				},
				{
					'header' : "등록자",
					'column' : "userName"
				},
				{
					'header' : "등록일",
					'column' : "createDate"
				}
			]
		};
	
		$.ajax({
			url: "/api/v1/etc/selectFaqList/excel",
			type: "POST",
			data: JSON.stringify(params),
			contentType: "application/json; charset=utf-8",
			// 응답을 Blob으로 처리하기 위해 xhrFields 사용
			xhrFields: {
				responseType: 'blob'
			},
			success: function(response) {
				if (response) {
					const url = window.URL.createObjectURL(new Blob([response]));
					const link = document.createElement("a");
					link.href = url;
					link.setAttribute("download", params.fileName + ".xlsx");
					document.body.appendChild(link);
					link.click();
					window.URL.revokeObjectURL(url);
				} else {
					Swal.fire('', '엑셀 다운로드 중 오류가 발생했습니다.', 'error');
				}
			},
			error: function(xhr, status, error) {
				console.error("Error:", error);
				Swal.fire('', '엑셀 다운로드 중 오류가 발생했습니다.', 'error');
			}
		});
	}

	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
		    <div class="conRight">
		        <div class="conHeader">
		            <ul class="conHeaderCate">
		                <li>공지</li>
		                <li>FAQ</li>
		            </ul>
		        </div>
		
		        <div class="contents">
		            <div class="searchBox">
		                <div class="flex align-items-center">
		                    <div class="sbTit mr30">제목</div>
		                    <div class="width200px">
		                        <input type="text" id="title" class="inputStyle" maxlength="300"/>
		                    </div>
		                    <div class="sbTit mr30 ml50">구분</div>
		                    <div class="width200px">
		                        <select id="faqType" class="selectStyle">
		                            <option value="">전체</option>
		                            <option value="1">가입관련</option>
		                            <option value="2">입찰관련</option>
		                            <option value="3">인증서관련</option>
		                        </select>
		                    </div>
		                    <a href="#" id="searchBtn" class="btnStyle btnSearch" onclick="onSearch()">검색</a>
		                </div>
		            </div>
		
		            <div class="flex align-items-center justify-space-between mt40">
		                <div class="width100">
		                    전체 : <span id="totalElements" class="textMainColor"><strong id="total"></strong></span>건
		                    <select id="pageSize" class="selectStyle maxWidth140px ml20" onchange="onSearch(0)">
		                        <option value="10">10개씩 보기</option>
		                        <option value="20">20개씩 보기</option>
		                        <option value="30">30개씩 보기</option>
		                        <option value="50">50개씩 보기</option>
		                    </select>
		                </div>
		                <div class="flex-shrink0">
		                    <a href="#" id="fnFaqExcelDown" class="btnStyle btnPrimary" onclick="fnFaqExcelDown()" title="엑셀 다운">엑셀 다운</a>
		                    <a href="#" id="addFaqBtn" class="btnStyle btnPrimary" data-toggle="modal" data-target="#faqReg" title="FAQ 등록">FAQ 등록</a>
		                </div>
		            </div>
		
		            <table class="tblSkin1 mt10">
		                <colgroup>
		                    <col style="width: 15%" />
		                    <col />
		                    <col style="width: 15%" />
		                    <col style="width: 15%" />
		                </colgroup>
		                <thead>
		                    <tr>
		                        <th>구분</th>
		                        <th>제목</th>
		                        <th>등록자</th>
		                        <th class="end">등록일시</th>
		                    </tr>
		                </thead>
		                <tbody id="faqListBody">
		                    
		                </tbody>
		            </table>
		
		            <div class="row mt40">
		                <div class="col-xs-12">
		                    <jsp:include page="/WEB-INF/jsp/pagination.jsp" />
		                </div>
		            </div>
		        </div>
		
		        <!-- 팝업 창 코드가 필요하면 여기에 추가합니다. -->
		        <div id="faqPop" class="modal fade" tabindex="-1" role="dialog">
		            <div class="modal-dialog" role="document">
		                <div class="modal-content">
		                    <div class="modal-header">h
		                            <span aria-hidden="true">&times;</span>
		                        </button>
		                    </div>
		                    <div class="modal-body">
		                        <!-- 팝업 내용 -->
		                    </div>
		                    <div class="modal-footer">
		                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
		                        <button type="button" id="saveFaqBtn" class="btn btn-primary">Save changes</button>
		                    </div>
		                </div>
		            </div>
		        </div>
				
		        <%-- <script src="${pageContext.request.contextPath}/js/adminFaq.js"></script> --%>
		    </div>
    	</div>
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    </div>
</body>
</html>
