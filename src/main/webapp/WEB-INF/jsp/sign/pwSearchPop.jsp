<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	function validate() {
		let regnum1 = $("#pw_regnum1").val().trim();
		let regnum2 = $("#pw_regnum2").val().trim();
		let regnum3 = $("#pw_regnum3").val().trim();
		let userName = $("#pw_userName").val().trim();
		let userId = $("#pw_userId").val().trim();
		let userEmail = $("#pw_userEmail").val().trim();
		if (!regnum1 || !regnum2 || !regnum3 || !userName || !userId || !userEmail) {
			Swal.fire('', '비밀번호를 찾기 위해서는 필수 정보[<span class="star">*</span>]를 입력해야 합니다.', 'error');
		} else {
			Swal.fire({
				title: '',			  // 타이틀
				html: "입력하신 사용자에게 문자와 이메일로 e-bidding 시스템에 접속하실 비밀번호를 전송합니다. 비밀번호는 초기화 되어 새로 생성됩니다. 비밀번호를 전송하시겠습니까?",  // 내용
				icon: 'question',						// success / error / warning / info / question
				confirmButtonColor: '#3085d6',  // 기본옵션
				confirmButtonText: '전송',	  // 기본옵션
				showCancelButton: true,		 // conrifm 으로 하고싶을떄
				cancelButtonColor: '#d33',	  // conrifm 에 나오는 닫기버튼 옵션
				cancelButtonText: '취소',	   // conrifm 에 나오는 닫기버튼 옵션
			}).then((result) => {
				if(result.isConfirmed){
					onSearch();
				}
			});
		}
	};
	
	function onSearch() {
		var params = {
			regnum1		: $("#pw_regnum1").val()
		,	regnum2		: $("#pw_regnum2").val()
		,	regnum3		: $("#pw_regnum3").val()
		,	userName	: $("#pw_userName").val()
		,	userId		: $("#pw_userId").val()
		,	userEmail	: $("#pw_userEmail").val()
		};
		
		$.post(
			"/api/v1/login/pwSearch", params, 
			function(arg){
				if (arg.status === 200) {
					if(arg.code == "OK") {
						Swal.fire('', '전송되었습니다.', 'success');
						$("#pw_modalClose").click();
						$("#pw_regnum1").val('');
						$("#pw_regnum2").val('');
						$("#pw_regnum3").val('');
						$("#pw_userName").val('');
						$("#pw_userId").val('');
						$("#pw_userEmail").val('');
					} else {
						Swal.fire('', '입력한 정보가 등록된 정보와 상이합니다. 다시 입력해 주십시오.', 'warning');
					}
				} else {
					Swal.fire('', '아이디 찾기 중 오류가 발생하였습니다.', 'error');
				}
			},
			"json"
		);
	};
	
</script>
<div class="modal fade modalStyle" id="pwSearchPop" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:510px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">비밀번호 찾기</h2>
				<div class="modalTopBox">
					<ul>
						<li><div>아래 사업자등록번호, 찾고자 하는 로그인 사용자명, 로그인 아이디 그리고 등록된 이메일을 정확히 입력하셔야 이메일 및 문자로 비밀번호를 발송합니다.</div></li>
						<li><div>비밀번호는 초기화되어 발송 하므로 로그인 후 암호를 변경하시고 사용하십시오.</div></li>
						<li><div>[비밀번호 찾기]는 전자입찰 협력사 사용자만 해당 됩니다. 계열사 사용자는 시스템 관리자에게 문의해 주십시오.</div></li>
					</ul>
				</div>
				<div class="flex align-items-center mt30">
					<div class="formTit flex-shrink0 width150px">사업자등록번호 <span class="star">*</span></div>
					<div class="flex align-items-center width100">
						<input type="text" name="pw_regnum1" id="pw_regnum1" class="inputStyle" placeholder="">
						<span style="margin:0 10px">-</span>
						<input type="text" name="pw_regnum2" id="pw_regnum2" class="inputStyle" placeholder="">
						<span style="margin:0 10px">-</span>
						<input type="text" name="pw_regnum3" id="pw_regnum3" class="inputStyle" placeholder="">
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width150px">로그인 사용자명 <span class="star">*</span></div>
					<div class="flex align-items-center width100">
						<input type="text" name="pw_userName" id="pw_userName" class="inputStyle" placeholder="">
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width150px">로그인 아이디 <span class="star">*</span></div>
					<div class="flex align-items-center width100">
						<input type="text" name="pw_userId" id="pw_userId" class="inputStyle" placeholder="">
					</div>
				</div>
				<div class="flex align-items-center mt10">
					<div class="formTit flex-shrink0 width150px">등록된 이메일 <span class="star">*</span></div>
					<div class="flex align-items-center width100">
						<input type="text" name="pw_userEmail" id="pw_userEmail" class="inputStyle" placeholder="ex) sample@iljin.co.kr">
					</div>
				</div>
				<div class="modalFooter">
					<a href="javascript:void(0)" id="pw_modalClose" class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
					<a href="javascript:validate()" class="modalBtnCheck" title="비밀번호 이메일 발송">비밀번호 이메일 발송</a>
				</div>
			</div>
		</div>
	</div>
</div>