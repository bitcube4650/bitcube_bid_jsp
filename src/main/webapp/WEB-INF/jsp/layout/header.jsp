<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<!-- <script src="/resources/js/logoutPop.js"></script> LogoutPop 관련 스크립트
<script src="/resources/js/checkPwdPop.js"></script> CheckPwdPop 관련 스크립트 -->
<script>
    $(document).ready(function() {
        var loginInfoString = localStorage.getItem("loginInfo"); 
        var loginInfo = loginInfoString ? JSON.parse(loginInfoString) : null;
        
        if (loginInfo !== null) {
            $('#userName').text(loginInfo.userName);
            $('.headerRight').show();
        } else {
            $('.headerRight').hide();
        }

        $('.profileDrop').on('click', function(e) {
            e.preventDefault();
            $('.profileDropWrap').toggleClass('active');
        });

        $('#logoutLink').on('click', function(e) {
            e.preventDefault();
            $('#logoutPop').show();
        });

        $('#changeInfoLink').on('click', function(e) {
            e.preventDefault();
            setModPop('info');
            $('#checkPwdPop').show();
        });

        $('#changePwdLink').on('click', function(e) {
            e.preventDefault();
            setModPop('pwd');
            $('#checkPwdPop').show();
        });

        function setModPop(flag) {
            $('#modPop').val(flag);
        }
    });

    function fnMoveMain() {
        window.location.href = "/";
    }
</script>
<body>
    <div class="header">
        <div class="headerLeft">
            <a href="#" onclick="fnMoveMain()" class="headerLogo" title="메인 페이지로 이동">
                <img src="/resources/images/bitcube_logo.png" class="img-responsive" alt="로고" style="width: 150px;"/>
                <span>e-Bidding System</span>
            </a>
            <p>편하고 빠른 전자입찰시스템</p>
        </div>
        <div class="headerRight" style="display: none;">
            <div class="profileDropWrap">
                <a href="#" class="profileDrop"><i class="fa-solid fa-circle-user"> <span id="userName"></span></i>님<i class="fa-solid fa-sort-down"></i></a>
                <div class="profileDropMenu">
                    <a href="#" id="changeInfoLink" data-toggle="modal" title="개인정보 수정"><i class="fa-light fa-gear"></i>개인정보 수정</a>
                    <a href="#" id="changePwdLink" data-toggle="modal" title="비밀번호 변경"><i class="fa-light fa-lock-keyhole"></i>비밀번호 변경</a>
                    <a href="#" id="logoutLink" data-toggle="modal" title="로그아웃"><i class="fa-light fa-arrow-right-from-bracket"></i>로그아웃</a>
                </div>
            </div>
        </div>
    </div>

    <!-- 로그아웃 팝업 -->
    <%-- <div id="logoutPop" style="display: none;">
        <jsp:include page="/WEB-INF/jsp/common/LogoutPop.jsp" />
    </div> --%>

    <!-- 비밀번호 확인 팝업 -->
    <%-- <div id="checkPwdPop" style="display: none;">
        <jsp:include page="/WEB-INF/jsp/common/CheckPwdPop.jsp" />
        <input type="hidden" id="modPop" value="" />
    </div> --%>
</body>
</html>
