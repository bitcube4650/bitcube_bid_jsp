<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/common.jsp" %>


<script type="text/javascript">

$(document).ready(function() { 
	onSearch(0)
    $('#srcNoticeTitle').keypress(function(event) {
        if (event.which === 13) {
            event.preventDefault();
            onSearch(0);
        }
    });
	
    $('#srcNoticeContent').keypress(function(event) {
        if (event.which === 13) {
            event.preventDefault();
            onSearch();
        }
    });
    
    $('#srcNoticeUserName').keypress(function(event) {
        if (event.which === 13) {
            event.preventDefault();
            onSearch();
        }
    });
		
});

	function onSearch(page) { // 파라미터로 들어온 페이지로 데이터 검색
	    const params = {
	            title: $('#srcNoticeTitle').val(),
	            content: $('#srcNoticeContent').val(),
	            userName: $('#srcNoticeUserName').val(),
				size : $("#pageSize").val(),
				page : page
	        };

	        $.post(
	            '/api/v1/notice/noticeList',
	            params,
	            function(response) {
	                if (response.code == "OK") {
						const list = response.data.content;
						updatePagination(response.data);
						$("#total").html(response.data.totalElements)
						$("#noticeListBody").empty();
						for(var i=0;i<list.length;i++) {
							$("#noticeListBody").append(
								"<tr>" +
								'<td>'+ list[i].rowNo +'</td>'+
								'<td> <a onclick="clickNoticeDetail(\''+ list[i].bno +'\')" title="선택" class="textUnderline notiTitle">'+list[i].btitle+'</a></td>'+
									'<td>'+ (list[i].bfile ? '<i class="fa-regular fa-file-lines notiFile"></i>' : '') +'</td>'+
									'<td>'+ list[i].buserName +'</td>'+
									'<td>'+ list[i].bdate +'</td>'+
									'<td>'+ list[i].bcount +'</td>'+
								"</tr>"
							);
						}
	                } else {
	                    console.error("Failed to retrieve data:", response.message);
	                }
	            },
	            "json"
	        );
		/*
		if (page >= 0) this.searchParams.page = page;
		this.retrieve();
		*/
	}

	// Define the async function separately
	function retrieve() { // 공지사항 조회
		try {
			/*
			this.$store.commit('loading');
			this.$store.commit('searchParams', this.searchParams);
			const response = await this.$http.post('/api/v1/notice/noticeList', this.searchParams);
			this.listPage = response.data;
			this.$store.commit('finish');
			*/
		} catch(err) {
			console.log(err)
		//	this.$store.commit('finish');
		}
	}

	function clickNoticeDetail(data) { // 공지사항 상세 이동
		
		window.location.href = '/notice/noticeDetail?bno='+data
		/*
		this.plusClickNum(data.bno); // 조회수 +1
		this.$store.commit('setNoticeDetailData', data); // 상세 페이지에 store로 넘기는 방법
	
		this.$router.push({name:"noticeDetail" , query: { 'bno': data.bno }}).catch(()=>{}); // 상세 페이지 이동
		*/
	}

</script>

<body>
  <div class="conRight">
    </div>   
    
    	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			
			<div class="conRight">


      <div class="conHeader">
            <ul class="conHeaderCate">
                <li>공지</li>
                <li>공지사항</li>
            </ul>
        </div>
        <!-- //conHeader -->
        <!-- contents -->
        <div class="contents">

            <!-- searchBox -->
            <div class="searchBox">
                <div class="flex align-items-center">
                    <div class="sbTit mr30">제목</div>
                    <div class="width200px">
                        <input id="srcNoticeTitle" type="text"  class="inputStyle" placeholder="" maxlength="300">
                    </div>
                    <div class="sbTit mr30 ml50">내용</div>
                    <div class="width200px">
                        <input id="srcNoticeContent" type="text" class="inputStyle" placeholder="" maxlength="300">
                    </div>
                    <div class="sbTit mr30 ml50">등록자</div>
                    <div class="width200px">
                        <input id="srcNoticeUserName" type="text" class="inputStyle" placeholder="" maxlength="50">
                    </div>
                    <a onclick="onSearch(0)" class="btnStyle btnSearch">검색</a>
                </div>
            </div>
            <!-- //searchBox -->

            <div class="flex align-items-center justify-space-between mt40">
                <div class="width100">
                    전체 : <span class="textMainColor"><strong id="total"></strong></span>건
                    <select id="pageSize" class="selectStyle maxWidth140px ml20" onchange="onSearch(0)">
                        <option value="10">10개씩 보기</option>
                        <option value="20">20개씩 보기</option>
                        <option value="30">30개씩 보기</option>
                        <option value="50">50개씩 보기</option>
                    </select>
                </div>
                <div>
                    <a href="/notice/noticeSave" class="btnStyle btnPrimary" title="공지등록">공지등록</a>
                </div>
            </div>
            <table class="tblSkin1 mt10">
                <colgroup>
                    <col style="width:7%">
                    <col style="">
                    <col style="width:10%">
                    <col style="width:10%">
                    <col style="width:10%">
                    <col style="width:10%">
                </colgroup>
                <thead>
                    <tr>
                        <th>순번</th>
                        <th>제목</th>
                        <th>첨부파일</th>
                        <th>등록자</th>
                        <th>등록일시</th>
                        <th class="end">조회수</th>
                    </tr>
                </thead>
                <tbody id="noticeListBody">
                </tbody>
            </table>

            <!-- pagination -->
            <div class="row mt40">
                <div class="col-xs-12">
                	<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
                </div>
            </div>
            <!-- //pagination -->

        </div>
        <!-- //contents -->


			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
