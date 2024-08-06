<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>

    <% 
    	String path = ""; 
    	String userCustType = "inter";
   	%>
    <meta charset="UTF-8">
    <title>Menu</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/common.css">
    <script src="/resources/js/jquery.min.js"></script>
    <script src="/resources/js/sweetalert2.all.min.js"></script>
    <script>
    
        $(document).ready(function() {
            let path = window.location.pathname;
            let loginInfo = JSON.parse(localStorage.getItem("loginInfo"));
            let userCustType = loginInfo.custType;
            let userAuth = loginInfo.userAuth;
            let targetId = "";
            let menuClickBoolean = false;

            function fetchData() {
                let url = userCustType === 'inter' ? "/api/v1/main/selectBidCnt" : "/api/v1/main/selectPartnerBidCnt";
                $.post(url, loginInfo, function(response) {
                    if(response.code === 'OK') {
                        $("#ingCount").text(response.data.ing);
                        $("#completedCount").text(response.data.completed);
                        $("#awardedCount").text(response.data.awarded);
                    } else {
                        $("#ingCount").text(0);
                        $("#completedCount").text(0);
                        $("#awardedCount").text(0);
                    }
                });
            }

            fetchData();

            function toggleMenu(clickedId) {
                if (targetId === clickedId) {
                    menuClickBoolean = !menuClickBoolean;
                } else {
                    targetId = clickedId;
                    menuClickBoolean = true;
                }
                updateMenuState();
            }

            function updateMenuState() {
                $(".depth2Lnb").removeClass("depth2Lnb_active");
                if (menuClickBoolean) {
                    $("#" + targetId).siblings(".depth2Lnb").addClass("depth2Lnb_active");
                }
            }

            $(".profileDrop2").on("click", function() {
                $(".profileDropWrap2").toggleClass("active");
            });

            $(".menuLink").on("click", function(e) {
                e.preventDefault();
                toggleMenu($(this).attr("id"));
            });

            $("#logoutConfirm").on("click", function() {
                $("#logoutPop").show();
            });

            $(".closePop").on("click", function() {
                $(this).closest('.modal').hide();
            });

            $("#checkPwdConfirm").on("click", function() {
                $("#checkPwdPop").show();
            });

            $("#changeStatusInfo").on("click", function() {
                $("#modPop").val('info');
                $("#checkPwdPop").show();
            });

            $("#changeStatusPwd").on("click", function() {
                $("#modPop").val('pwd');
                $("#checkPwdPop").show();
            });
        });
    </script>
    <style>
        .modal { display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 80%; max-width: 500px; background: white; border: 1px solid #ccc; padding: 20px; z-index: 1000; }
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 999; }
        .modal-header { display: flex; justify-content: space-between; align-items: center; }
        .modal-body { margin-top: 20px; }
    </style>
</head>
<body>
    <div class="conLeftWrap">
        <div class="profileDropWrap2">
            <a class="profileDrop2">테스트 님<i class="fa-solid fa-sort-down"></i></a>
            <div class="profileDropMenu2">
                <a id="changeStatusInfo" data-toggle="modal" title="개인정보 수정"><i class="fa-light fa-gear"></i>개인정보 수정</a>
                <a id="changeStatusPwd" data-toggle="modal" title="비밀번호 변경"><i class="fa-light fa-lock-keyhole"></i>비밀번호 변경</a>
                <a id="logoutConfirm" data-toggle="modal" data-target="#logout" title="로그아웃"><i class="fa-light fa-arrow-right-from-bracket"></i>로그아웃</a>
            </div>
        </div>
        <div class="myState" id="myStateInter" style="display: none;">
            <div>진행중<a class="myStateNum" title="전자입찰 페이지로 이동"><span id="ingCount">0</span>건</a></div>
            <div>낙찰 (12개월)<a class="myStateNum" title="전자입찰 페이지로 이동"><span id="completedCount">0</span>건</a></div>
        </div>
        <div class="myState" id="myStateCust" style="display: none;">
            <div>진행중<a class="myStateNum" title="전자입찰 페이지로 이동"><span id="ingCount">0</span>건</a></div>
            <div>낙찰 (12개월)<a class="myStateNum" title="전자입찰 페이지로 이동"><span id="awardedCount">0</span>건</a></div>
        </div>
        <ul class="conLeft">
            <li class="<%= path.equals("/main") ? "active" : "" %>"><a href="/main"><span><i class="fa-light fa-desktop"></i></span>메인</a></li>
            <li class="<%= path.startsWith("/bid") ? "active" : "" %>">
                <a id="ebid" class="menuLink"><span><i class="fa-light fa-file-contract"></i></span>전자입찰</a>
                <div class="depth2Lnb">
                    <ul>
                        <li style="display: <%= userCustType.equals("inter") ? "block" : "none" %>;" class="<%= path.equals("/bid/progress") ? "active" : "" %>"><a href="/bid/progress">입찰계획</a></li>
                        <li style="display: <%= userCustType.equals("inter") ? "block" : "none" %>;" class="<%= path.equals("/bid/status") ? "active" : "" %>"><a href='/bid/status'>입찰진행</a></li>
                        <li style="display: <%= userCustType.equals("cust") ? "block" : "none" %>;" class="<%= path.equals("/bid/partnerStatus") ? "active" : "" %>"><a href='/bid/partnerStatus'>입찰진행-협력사</a></li>
                        <li style="display: <%= userCustType.equals("inter") ? "block" : "none" %>;" class="<%= path.equals("/bid/complete") ? "active" : "" %>"><a href='/bid/complete'>입찰완료</a></li>
                        <li style="display: <%= userCustType.equals("cust") ? "block" : "none" %>;" class="<%= path.equals("/bid/partnerComplete") ? "active" : "" %>"><a href='/bid/partnerComplete'>입찰완료-협력사</a></li>
                        <li style="display: <%= userCustType.equals("inter") ? "block" : "none" %>;" class="<%= path.equals("/bid/history") ? "active" : "" %>"><a href='/bid/history'>낙찰이력</a></li>
                    </ul>
                </div>
            </li>
            <li class="<%= path.startsWith("/notice") ? "active" : "" %>">
                <a id="notice" class="menuLink"><span><i class="fa-light fa-bullhorn"></i></span>공지</a>
                <div class="depth2Lnb">
                    <ul>
                        <li class="<%= path.equals("/notice") ? "active" : "" %>"><a href="/notice">공지사항</a></li>
                        <li style="display: <%= userCustType.equals("inter") ? "block" : "none" %>;" class="<%= path.equals("/notice/faq/admin") ? "active" : "" %>"><a href='/notice/faq/admin'>FAQ</a></li>
                        <li style="display: <%= userCustType.equals("cust") ? "block" : "none" %>;" class="<%= path.equals("/notice/faq/user") ? "active" : "" %>"><a href='/notice/faq/user'>FAQ-협력사</a></li>
                        <li style="display: <%= userCustType.equals("inter") ? "block" : "none" %>;"><a href="../../installFile/전자입찰_매뉴얼_본사.pdf" download="전자입찰_메뉴얼.pdf">메뉴얼</a></li>
                        <li style="display: <%= userCustType.equals("cust") ? "block" : "none" %>;"><a href="../../installFile/전자입찰_매뉴얼_업체.pdf" download="전자입찰_메뉴얼.pdf">메뉴얼</a></li>
                    </ul>
                </div>
            </li>
            <li style="display: <%= (userCustType.equals("inter") && (userAuth == 1 || userAuth == 2 || userAuth == 4)) || (userCustType.equals("cust") && userAuth == 1) ? "block" : "none" %>;" 
                class="<%= (path.equals("/company/partner/approval") || path.indexOf("/company/partner/management") > -1) ? "active" : "" %>">
                <a id="company" class="menuLink"><span><i class="fa-light fa-buildings"></i></span>업체정보</a>
                <div class="depth2Lnb">
                    <ul style="display: <%= (userCustType.equals("inter") && (userAuth == 1 || userAuth == 2 || userAuth == 4)) ? "block" : "none" %>;">
                        <li class="<%= path.equals("/company/partner/approval") ? "active" : "" %>"><a href="/company/partner/approval">업체승인</a></li>
                        <li class="<%= path.equals("/company/partner/management") ? "active" : "" %>"><a href="/company/partner/management">업체관리</a></li>
                    </ul>
                    <ul style="display: <%= userCustType.equals("cust") && userAuth == 1 ? "block" : "none" %>;">
                        <li class="<%= path.equals("/company/partner/management/" + loginInfo.custCode) ? "active" : "" %>"><a href="/company/partner/management/<%= loginInfo.custCode %>">자사정보</a></li>
                        <li class="<%= path.equals("/company/partner/user") ? "active" : "" %>"><a href="/company/partner/user">사용자관리</a></li>
                    </ul>
                </div>
            </li>
            <li style="display: <%= (userCustType.equals("inter") && (userAuth == 1 || userAuth == 4)) ? "block" : "none" %>;" 
                class="<%= (path.equals("/statistics/performance/company") || path.equals("/statistics/performance/detail") || path.equals("/statistics/status") || path.equals("/statistics/detail")) ? "active" : "" %>">
                <a id="statistics" class="menuLink"><span><i class="fa-light fa-chart-pie-simple"></i></span>통계</a>
                <div class="depth2Lnb">
                    <ul>
                        <li class="<%= path.equals("/statistics/performance/company") ? "active" : "" %>"><a href="/statistics/performance/company">회사별 입찰실적</a></li>
                        <li class="<%= path.equals("/statistics/performance/detail") ? "active" : "" %>"><a href="/statistics/performance/detail">입찰실적 상세내역</a></li>
                        <li class="<%= path.equals("/statistics/status") ? "active" : "" %>"><a href="/statistics/status">입찰현황</a></li>
                        <li class="<%= path.equals("/statistics/detail") ? "active" : "" %>"><a href="/statistics/detail">입찰 상세내역</a></li>
                    </ul>
                </div>
            </li>
            <li style="display: <%= userCustType.equals("inter") && userAuth == 1 ? "block" : "none" %>;" class="<%= path.equals("/info/group/user") || path.equals("/info/group/item") ? "active" : "" %>">
                <a id="info" class="menuLink"><span><i class="fa-light fa-memo-circle-info"></i></span>정보관리</a>
                <div class="depth2Lnb">
                    <ul>
                        <li class="<%= path.equals("/info/group/user") ? "active" : "" %>"><a href="/info/group/user">사용자관리</a></li>
                        <li class="<%= path.equals("/info/group/item") ? "active" : "" %>"><a href="/info/group/item">품목관리</a></li>
                    </ul>
                </div>
            </li>
        </ul>
    </div>
    <div id="logoutPop" class="modal">
        <div class="modal-header">
            <h2>로그아웃</h2>
            <button class="closePop">X</button>
        </div>
        <div class="modal-body">
            <p>정말 로그아웃 하시겠습니까?</p>
            <button>예</button>
            <button class="closePop">아니오</button>
        </div>
    </div>
    <div id="checkPwdPop" class="modal">
        <div class="modal-header">
            <h2>비밀번호 확인</h2>
            <button class="closePop">X</button>
        </div>
        <div class="modal-body">
            <input type="password" placeholder="비밀번호 입력">
            <button id="checkPwdConfirm">확인</button>
        </div>
    </div>
    <input type="hidden" id="modPop" value="">
</body>
</html>
