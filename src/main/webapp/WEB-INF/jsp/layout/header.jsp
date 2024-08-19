<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

	});
	
	function setModPop(flag) {
		$('#modPop').val(flag);
	}
	
	function changeInfoLink(){
		setModPop('info');
		$('#checkPwdPop').modal('show');
	}
	
	function changePwdLink(){
		setModPop('pwd');
		$('#checkPwdPop').modal('show');
	}

	function fnLogout() {
		$.get(
			"/api/v1/logout",
			{},
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				removeCookie('loginInfo');
				localStorage.clear();
				location.href="/";
			}else{
				Swal.fire('', '로그아웃 처리에 실패하였습니다.', 'error');
			}
		})
	}
	
	function removeCookie(name){
		document.cookie = name + '=; Max-Age=0; path=/';
	}
	
	function fnMoveMain() {
		window.location.href = "/dashboard";
	}
</script>
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
				<a href="javascript:changeInfoLink()" id="changeInfoLink" title="개인정보 수정"><i class="fa-light fa-gear"></i>개인정보 수정</a>
				<a href="javascript:changePwdLink()" id="changePwdLink" title="비밀번호 변경"><i class="fa-light fa-lock-keyhole"></i>비밀번호 변경</a>
				<a href="javascript:void(0);" id="logoutLink" title="로그아웃"><i class="fa-light fa-arrow-right-from-bracket"></i>로그아웃</a>
			</div>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/jsp/layout/profileDropWrap.jsp" />
<input type="hidden" id="modPop" value="" />
