<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<script>
    $(document).ready(function() {
        $('#enrollmentProcessLink').on('click', function(e) {
            e.preventDefault();
            $('#enrollmentProcessPop').show();
        });

        $('#biddingGuideLink').on('click', function(e) {
            e.preventDefault();
            $('#biddingGuidePop').show();
        });

        $('.closePop').on('click', function() {
            $(this).closest('.modal').hide();
        });
    });
</script>
<style>
    .modal { display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 80%; max-width: 500px; background: white; border: 1px solid #ccc; padding: 20px; z-index: 1000; }
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 999; }
    .modal-header { display: flex; justify-content: space-between; align-items: center; }
    .modal-body { margin-top: 20px; }
</style>
<body>
    <div class="footer">
        <div class="subFooter">
            <span>
                © BITCUBE ALL RIGHTS RESERVED. <br />
                전자입찰 문의: IT HelpDesk ( 02 - 720 - 4650 ) &nbsp; e-mail : bitcube@bitcube.co.kr
            </span>
            <div class="subFooterUtill">
                <a href="#" title="공동인증서">공동인증서</a>
                <a href="#" id="enrollmentProcessLink" title="업체등록절차">업체등록절차</a>
                <a href="#" id="biddingGuideLink" title="입찰업무안내">입찰업무안내</a>
            </div>
        </div>
    </div>

    <!-- 업체등록절차 팝업 -->
    <div id="enrollmentProcessPop" class="modal">
        <div class="modal-header">
            <h2>업체등록절차</h2>
            <button class="closePop">닫기</button>
        </div>
        <div class="modal-body">
            <!-- 업체등록절차 내용 -->
            <%-- <jsp:include page="/WEB-INF/jsp/common/EnrollmentProcessPop.jsp" /> --%>
        </div>
    </div>

    <!-- 입찰업무안내 팝업 -->
    <div id="biddingGuidePop" class="modal">
        <div class="modal-header">
            <h2>입찰업무안내</h2>
            <button class="closePop">닫기</button>
        </div>
        <div class="modal-body">
            <!-- 입찰업무안내 내용 -->
            <%-- <jsp:include page="/WEB-INF/jsp/common/BiddingGuidePop.jsp" /> --%>
        </div>
    </div>

    <div class="modal-overlay"></div>
</body>
</html>
