<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<script>

	$(function(){
		$("#loginId").keydown(function(e){
			if(e.keyCode==13) {
				onLogin();
			}
		});
		$("#loginPw").keydown(function(e){
			if(e.keyCode==13) {
				onLogin();
			}
		});
	});
	
	function onLogin() {
		var id = $("#loginId").val().trim();
		var pw = $("#loginPw").val().trim();
		var chkID = $("#chkID").val();
		var params = {
				loginId : id
			,	loginPw : pw
		}
		
		if(id === "") {
			Swal.fire('', '아이디를 입력해 주십시오', 'error');
			return;
		}
		
		if (pw === "") {
			Swal.fire('', '비밀번호를 입력해 주십시오', 'error');
			return;
		}
		
		$.post(
			"/api/v1/login", params, 
			function(arg){
				if(arg.data.statusCodeValue === 200){
					var loginData = arg.data.body;
					setCookie('loginInfo', JSON.stringify(loginData));
					localStorage.setItem("loginInfo", JSON.stringify(loginData));
					if (chkID) {
						setCookie('rememberUserId', id);
					} else {
						removeCookie('rememberUserId');
					}
					location.href="/api/v1/move?viewName=dashboard";
				}else if(arg.data.statusCodeValue === 403){
					Swal.fire('', '입력하신 아이디와 비밀번호는 일치하나, 아직 본사의 승인이 이루어지지 않았습니다. 본사의 승인 후 본 전자입찰/계약 시스템을 이용하실 수 있습니다. 본사승인 후 다시 로그인 해 주세요.', 'error');
				}else{
					Swal.fire('', '아이디 또는 비밀번호를 확인해 주십시오.', 'error');
				}
			},
			"json"
		);
	};
	
	function onSignUp() {
		location.href="/api/v1/move?viewName=sign/signUp";
	};
	
	function setCookie(name, value) {
		document.cookie = name + "=" + escape( value ) + "; path=/;";
	}
	
</script>
<body>
	<div>
		<div class="loginBg">
			<div class="inner">
				<div class="loginWrap">
					<div class="loginLeft">
						<h1><img src="./resources/images/bitcube_logo_black.png" class="img-responsive" alt="일진그룹 로고" /></h1>
						<input type="text" id="loginId" autoComplete="name" name="username" placeholder="아이디" autoFocus class="loginInputStyle"/>
						<input type="password" id="loginPw" autoComplete="new-password" name="password" class="loginInputStyle mt10" placeholder="비밀번호"/>
						<div class="loginFindWrap">
							<input type="checkbox" id="chkID" class="loginCheckStyle"/>
							<label for="chkID">아이디 저장</label>
							<ul class="loginFind">
								<li>
									<a data-toggle="modal" data-target="#idSearchPop" title="아이디 찾기">아이디 찾기</a>
								</li>
								<li>
									<a data-toggle="modal" data-target="#pwSearchPop" title="비밀번호 찾기">비밀번호 찾기</a>
								</li>
							</ul>
						</div>
						<div class="loginBtnWrap">
							<a onClick="onLogin()" class="btnLoginPrimary" title="로그인">로그인</a>
							<a onClick="onSignUp()" class="btnLoginOutline mt10" title="회원가입">회원가입</a>
						</div>
					</div>
					<div class="loginRight">
						<h2><span>투명</span>합니다.</h2>
						<h2><span>함께</span>합니다.</h2>
						<h2><span>미래</span>를 엽니다.</h2>
						<h3>" CLEAR, UNITED, OPENING THE FUTURE "</h3>
						<div class="loginRight">
							<h3 style="font-size: 30px; color: #F3B352; font-weight: 550;">IT HelpDesk</h3>
							<h3 style="margin-top: 5px; font-size: 30px; font-Weight: 550;">Tel : 080-707-9100</h3>
						</div>
					</div>
				</div>
		
				<div class="loginFooter">
					<div class="inner">
						<div class="loginFootCenter">
							<a href="/#" title="공동인증서">공동인증서</a>
							<a href="/#" data-toggle="modal" data-target="#regProcess" title="업체등록절차">업체등록절차</a>
							<a href="/#" data-toggle="modal" data-target="#biddingInfo" title="입찰업무안내">입찰업무안내</a>
						</div>
						<div class="loginFootRight">
							<div class="loginSelectStyle">
								<button class="selLabel">BITCUBE FAMILY</button>
								<ul class="optionList">
									<li class="optionItem"><a href="http://www.bitcube.co.kr" target="_blank">비트큐브</a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="footAddr">
						전자입찰 문의: IT HelpDesk ( 02 - 720 - 4650 ) &nbsp e-mail : bitcube@bitcube.co.kr<br />
						서울특별시 강동구 강동U1빌딩 1613호<br />
						© BITCUBE ALL RIGHTS RESERVED.
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="/WEB-INF/jsp/sign/idSearchPop.jsp" />
	<jsp:include page="/WEB-INF/jsp/sign/pwSearchPop.jsp" />
	<jsp:include page="/WEB-INF/jsp/sign/regProcessPop.jsp" />
	<jsp:include page="/WEB-INF/jsp/sign/biddingInfoPop.jsp" />
</body>
</html>