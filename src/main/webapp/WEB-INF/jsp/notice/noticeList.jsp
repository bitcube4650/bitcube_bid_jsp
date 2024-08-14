<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/common.jsp" %>


<script type="text/javascript">

$(document).ready(function() { 
	
    const params = {
            title: "",
            content: "",
            userName: "",
            size: 10,
            page: 0
        };

        $.post(
            '/api/v1/notice/noticeList',
            params,
            function(response) {
                if (response.code == "OK") {
                    const noticeData = response.data.content;
                    console.log(noticeData)
                    let tbody = $(".tblSkin1 tbody"); // Select the tbody element

                    // Clear existing rows
                    tbody.empty();

                    // Loop through noticeData to create and append rows
                    noticeData.forEach(function(notice) {
                        // Create a row element and append it to tbody
                        tbody.append(
                            $("<tr>")
                            .append($("<td>").text(notice.rowNo))  // Row Number
                            .append($("<td>").addClass("text-left")  // Title with link
                                .append($("<a>")
                                    .addClass("textUnderline notiTitle")
                                    .attr("title", "공지사항 자세히 보기")
                                    .text(notice.btitle)
                                    .click(() => clickNoticeDetail(notice.bno))
                                )
                            )
                            .append($("<td>").html(notice.bfile ? '<i class="fa-regular fa-file-lines notiFile"></i>' : '')) // Optional File Icon
                            .append($("<td>").text(notice.buserName))  // User Name
                            .append($("<td>").text(notice.bdate))  // Date
                            .append($("<td>").addClass("end").text(notice.bcount))  // View Count
                        );
                    });

                    // If no data is returned, show a message
                    if (noticeData.length === 0) {
                        tbody.append(`
                            <tr>
                                <td class="end" colspan="6">조회된 데이터가 없습니다.</td>
                            </tr>
                        `);
                    }
                } else {
                    console.error("Failed to retrieve data:", response.message);
                }
            },
            "json"
        );
	
	
	
});

	function search(page) { // 파라미터로 들어온 페이지로 데이터 검색
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
		/*
		this.plusClickNum(data.bno); // 조회수 +1
		this.$store.commit('setNoticeDetailData', data); // 상세 페이지에 store로 넘기는 방법
	
		this.$router.push({name:"noticeDetail" , query: { 'bno': data.bno }}).catch(()=>{}); // 상세 페이지 이동
		*/
	}

	function plusClickNum(bno) { // 조회수 +1
		// this.$http.post('/api/v1/notice/updateClickNum', { 'bno': bno });
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
                        <input type="text"  class="inputStyle" placeholder="" maxlength="300">
                    </div>
                    <div class="sbTit mr30 ml50">내용</div>
                    <div class="width200px">
                        <input type="text" class="inputStyle" placeholder="" maxlength="300">
                    </div>
                    <div class="sbTit mr30 ml50">등록자</div>
                    <div class="width200px">
                        <input type="text" class="inputStyle" placeholder="" maxlength="50">
                    </div>
                    <a class="btnStyle btnSearch">검색</a>
                </div>
            </div>
            <!-- //searchBox -->

            <div class="flex align-items-center justify-space-between mt40">
                <div class="width100">
                    전체 : <span class="textMainColor"><strong>1</strong></span>건
                    <select name="" class="selectStyle maxWidth140px ml20">
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
                <tbody>
                    <tr >
                        <td ></td>
                        <td class="text-left"><a  class="textUnderline notiTitle" title="공지사항 자세히 보기"><span >[공통] </span></a></td>
                        <td><i class="fa-regular fa-file-lines notiFile"></i></td>
                        <td></td>
                        <td></td>
                        <td class="end"></td>
                    </tr>
                    <tr>
                        <td class="end" colspan="6">조회된 데이터가 없습니다.</td>
                    </tr>
                </tbody>
            </table>

            <!-- pagination -->
            <div class="row mt40">
                <div class="col-xs-12">
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
