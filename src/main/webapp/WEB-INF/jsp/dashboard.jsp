<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<%@ page import="java.util.List" %>

<%
    
    // JSON 응답 파싱
    String noticeListJson = null;
    List<Object> noticeList = null;

    String bidInfoJson = null;
    //BidInfo bidInfo = null;

    String partnerInfoJson = null;
    //PartnerInfo partnerInfo = null;

    boolean pwInit = false;
%>

<script>
	$(document).ready(function() {
		fnSelectNotice();	// 공지사항 리스트
	});
	function fnSelectNotice(){
		$.post(
			"/api/v1/selectNoticeList/list",
			{},
			function(arg){
				console.log(arg);
			},
			"json"
		);
	}
	
</script>
<head>
    <title>메인 페이지</title>
    <link rel="stylesheet" href="styles.css"> <!-- CSS 파일 포함 -->
</head>
<body>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
		    <div class="conRight">
		        <div class="conHeader" style="padding: 23px 30px 20px 30px;">
		            <ul class="conHeaderCate">
		                <li>메인</li>
		            </ul>
		        </div>
		        <div class="contents">
		            <div class="mainConLayout" style="margin-top: 10px;">
		                <div class="mcl_left mainConBox" style="height: 700px;">
		                    <h2 class="h2Tit">전자입찰</h2>
		                    <div class="biddingList">
		                        <a href="/bid/progress" class="biddingStep1">
		                            <div class="biddingListLeft" style="height: 70px;"><i class="fa-light fa-flag"></i>입찰계획</div>
		                            <div class="biddingListRight"><span>0</span>건<i class="fa-light fa-angle-right"></i></div>
		                        </a>
		                        <a href="/bid/progress" class="biddingStep2">
		                            <div class="biddingListLeft" style="height: 70px;"><i class="fa-light fa-comments"></i>입찰진행(입찰공고)</div>
		                            <div class="biddingListRight"><span>0</span>건<i class="fa-light fa-angle-right"></i></div>
		                        </a>
		                        <a href="/bid/progress" class="biddingStep3">
		                            <div class="biddingListLeft" style="height: 70px;"><i class="fa-light fa-files"></i>입찰진행(개찰대상)</div>
		                            <div class="biddingListRight"><span>0</span>건<i class="fa-light fa-angle-right"></i></div>
		                        </a>
		                        <a href="/bid/progress" class="biddingStep4">
		                            <div class="biddingListLeft" style="height: 70px;"><i class="fa-light fa-file-check"></i>입찰진행(개찰)</div>
		                            <div class="biddingListRight"><span>0</span>건<i class="fa-light fa-angle-right"></i></div>
		                        </a>
		                        <a href="/bid/progress" class="biddingStep5">
		                            <div class="biddingListLeft" style="height: 70px;"><i class="fa-light fa-puzzle-piece"></i>입찰완료(12개월)</div>
		                            <div class="biddingListRight"><span>0</span>건<i class="fa-light fa-angle-right"></i></div>
		                        </a>
		                        <a href="/bid/progress" class="biddingStep5">
		                            <div class="biddingListLeft" style="height: 70px;"><i class="fa-light fa-puzzle-piece"></i>유찰(12개월)</div>
		                            <div class="biddingListRight"><span>0</span>건<i class="fa-light fa-angle-right"></i></div>
		                        </a>
		                        <!-- 다른 입찰 단계 링크 추가 -->
		                    </div>
		                </div>
		                <div class="mcl_right">
		                    <div class="mainConBox">
		                        <h2 class="h2Tit">협력업체<a href="/company/partner/management" title="협력업체 페이지로 이동" class="mainConBoxMore">더보기<i class="fa-solid fa-circle-plus"></i></a></h2>
		                        <div class="cooperativ">
		                            <a href="/company/partner/approval" title="미승인 업체 페이지로 이동">
		                                <span class="cooperativ_tit">미승인 업체</span>
		                                <span class="cooperativ_num">0</span>
		                            </a>
		                            <a href="/company/partner/management" title="승인 업체 (인증서 제출) 페이지로 이동">
		                                <span class="cooperativ_tit">승인 업체</span>
		                                <span class="cooperativ_num">0</span>
		                            </a>
		                            <a href="/company/partner/management?certYn=D" title="삭제 업체 페이지로 이동">
		                                <span class="cooperativ_tit">삭제 업체</span>
		                                <span class="cooperativ_num">0</span>
		                            </a>
		                        </div>
		                    </div>
		                    <div class="mainConBox" style="height: 381.41px;">
		                        <h2 class="h2Tit">공지사항<a href="/notice" title="공지사항 페이지로 이동" class="mainConBoxMore">더보기<i class="fa-solid fa-circle-plus"></i></a></h2>
		                        <div class="notiList">
		                        	<div class="noticeItem">
	                                    <h3>예시</h3>
	                                    <p>작업중</p>
		                        	</div>
		                            <%-- <% for (Notice notice : noticeList) { %>
		                                <div class="noticeItem">
		                                    <h3><%= notice.getTitle() %></h3>
		                                    <p><%= notice.getContent() %></p>
		                                </div>
		                            <% } %> --%>
		                        </div>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <%-- <% if (pwInit) { %>
		            <div id="pwInitPop">비밀번호를 변경해 주세요!</div>
		        <% } %> --%>
		    </div>
    	</div>
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    </div>
</body>
</html>
