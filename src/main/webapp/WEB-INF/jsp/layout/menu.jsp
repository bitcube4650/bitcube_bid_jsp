<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<% 
  	String path = ""; 
  	String userCustType = "inter";
  	int userAuth = 1;
%>
<script>
	var path = window.location.pathname;
	var loginInfo = JSON.parse(localStorage.getItem("loginInfo"));
	var userCustType = loginInfo.custType;
	var userAuth = loginInfo.userAuth;
	var targetId = "";
	var menuClickBoolean = false;
	
	var modalType = "";
	
	$(document).ready(function() {

		var path = window.location.pathname;
		var loginInfo = JSON.parse(localStorage.getItem("loginInfo"));
		var userCustType = loginInfo.custType;
		var userAuth = loginInfo.userAuth;
		var targetId = "";
		var menuClickBoolean = false;
		
		/* 
		function fetchData() {
			var url = userCustType === 'inter' ? "/api/v1/main/selectBidCnt" : "/api/v1/main/selectPartnerBidCnt";
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
		 */
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
		
		// 로그아웃
		$('#logoutConfirm').on('click', function(e) {
			Swal.fire({
				title: '',			  // 타이틀
				text: "로그아웃 하시겠습니까?",  // 내용
				icon: 'question',						// success / error / warning / info / question
				confirmButtonColor: '#3085d6',  // 기본옵션
				confirmButtonText: '확인',	  // 기본옵션
				showCancelButton: true,		 // conrifm 으로 하고싶을떄
				cancelButtonColor: '#d33',	  // conrifm 에 나오는 닫기버튼 옵션
				cancelButtonText: '취소',	   // conrifm 에 나오는 닫기버튼 옵션
			}).then((result) => {
				if(result.isConfirmed){
					fnLogout();
				}
			});
		});
// 		// 개인정보변경
// 		$('#changeStatusInfo').on('click', function(e) {
// 			console.log("Info");
// 			e.preventDefault();
// 			//modalType = 'info';
// // 			$('#checkPwdPop').show();
// 		});
		// 비밀번호변경
// 		$('#changeStatusPwd').on('click', function(e) {
// 			console.log("Pwd");
// 			e.preventDefault();
// 			//modalType = 'pwd';
// // 			$('#checkPwdPop').show();
// 		});
	});
	
	// 입찰 진행 건수 호출
	function fetchData() {
		var userCustType = 'inter';
		var loginInfo = null;
		//var url = (userCustType === 'inter') ? "/api/v1/main/selectBidCnt" : "/api/v1/main/selectPartnerBidCnt";
		$.post("/api/v1/main/selectBidCnt", 
			{}, 
			function(response) {
			console.log(response);
				if(response.code === 'OK') {
					$("#ingCount").text(response.data.ing);
					$("#completedCount").text(response.data.completed);
					$("#awardedCount").text(response.data.awarded);
				} else {
					$("#ingCount").text(0);
					$("#completedCount").text(0);
					$("#awardedCount").text(0);
				}
			}
		);
	}
	
	
</script>

<body>
	<div class="conLeftWrap">
	<a onclick="fetchData()" class="">테스트버튼<i class="fa-solid fa-sort-down"></i></a>
		<div class="profileDropWrap2">
			
			<a class="profileDrop2">테스트 님<i class="fa-solid fa-sort-down"></i></a>
			<div class="profileDropMenu2">
				<a id="changeStatusInfo" data-toggle="modal" data-target="#checkPwdPop" title="개인정보 수정"><i class="fa-light fa-gear"></i>개인정보 수정</a>
				<a id="changeStatusPwd" data-toggle="modal" data-target="#checkPwdPop" title="비밀번호 변경"><i class="fa-light fa-lock-keyhole"></i>비밀번호 변경</a>
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
			<li class="<%= path.equals("/dashboard") ? "active" : "" %>"><a href="/dashboard"><span><i class="fa-light fa-desktop"></i></span>메인</a></li>
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
						<li class="<%= path.equals("/notice/noticeList") ? "active" : "" %>"><a href="/notice/noticeList">공지사항</a></li>
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
						<%-- <li class="<%= path.equals("/company/partner/management/" + loginInfo.custCode) ? "active" : "" %>"><a href="/company/partner/management/<%= loginInfo.custCode %>">자사정보</a></li> --%>
						<li class=""><a href="">자사정보</a></li>
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
	
</body>
</html>
