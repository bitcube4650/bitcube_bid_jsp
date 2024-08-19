<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="footer">
	<div class="subFooter">
		<span>
			© BITCUBE ALL RIGHTS RESERVED. <br />
			전자입찰 문의: IT HelpDesk ( 02 - 720 - 4650 ) &nbsp; e-mail : bitcube@bitcube.co.kr
		</span>
		<div class="subFooterUtill">
			<a href="/#" title="공동인증서">공동인증서</a>
			<a href="/#" data-toggle="modal" data-target="#regProcess" title="업체등록절차">업체등록절차</a>
			<a href="/#" data-toggle="modal" data-target="#biddingInfo" title="입찰업무안내">입찰업무안내</a>
			<!-- <a href="#" id="enrollmentProcessLink" title="업체등록절차">업체등록절차</a>
			<a href="#" id="biddingGuideLink" title="입찰업무안내">입찰업무안내</a> -->
		</div>
	</div>
</div>

<!-- 업체등록절차 팝업 -->
<jsp:include page="/WEB-INF/jsp/sign/regProcessPop.jsp" />

<!-- 입찰업무안내 팝업 -->
<jsp:include page="/WEB-INF/jsp/sign/biddingInfoPop.jsp" />
