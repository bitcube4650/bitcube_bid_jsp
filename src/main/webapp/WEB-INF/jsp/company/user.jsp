<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/common.jsp" %>


<script type="text/javascript">

$(document).ready(function() { 
	$('#srcUseYn').val('Y')
	onSearch(0)
    $('#srcUserNm').keypress(function(event) {
        if (event.which === 13) {
            event.preventDefault();
            onSearch(0);
        }
    });
	
    $('#srcLogin').keypress(function(event) {
        if (event.which === 13) {
            event.preventDefault();
            onSearch();
        }
    });
    
    $('#srcUseYn').keypress(function(event) {
        if (event.which === 13) {
            event.preventDefault();
            onSearch();
        }
    });
		
});

	function onSearch(page) { // 파라미터로 들어온 페이지로 데이터 검색
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
	    const params = {
			custCode : loginInfo.custCode,
    		userName: $('#srcUserNm').val(),
    		userId: $('#srcLogin').val(),
    		useYn: $('#srcUseYn').val(),
			size : $("#pageSize").val(),
			page : page
	        };

	        $.post(
	            '/api/v1/cust/userListForCust',
	            params,
	            function(response) {
	                if (response.code == "OK") {
						const list = response.data.content;
						updatePagination(response.data);
						$("#total").html(response.data.totalElements)
						$("#noticeListBody").empty();
						for(var i=0;i<list.length;i++) {
							$("#noticeListBody").append(
								"<tr>" +
								'<td> <a onclick="userEditPop(\''+ encodeURIComponent(JSON.stringify(list[i])) +'\')" title="선택" class="textUnderline notiTitle">'+list[i].userName+'</a></td>'+
								'<td> <a onclick="userEditPop(\''+ encodeURIComponent(JSON.stringify(list[i])) +'\')" title="선택" class="textUnderline notiTitle">'+list[i].userId+'</a></td>'+
								'<td>'+ (list[i].userBuseo || '') +'</td>'+
								'<td>'+ (list[i].userPosition || '')+'</td>'+
								'<td>'+ onAddDashTel(list[i].userTel)  +'</td>'+
								'<td>'+ onAddDashTel(list[i].userHp)  +'</td>'+
								'<td>'+ (list[i].useYn ==='Y' ? '정상' : '삭제') +'</td>'+
								'<td>'+ (list[i].userType === '1' ? '업체관리자' : '일반사용자') +'</td>'+
								"</tr>"
							);
						}
	                } else {
	                    console.error("Failed to retrieve data:", response.message);
	                }
	            },
	            "json"
	        );
	}

	function userRegPop(){
		

		$('#custUserRegFooter').css('display','')
		$('#custUserEditFooter').css('display','none')
		$('#saveName').empty()
		$('#loginIdEditStr').css('display','none')
		$('#custUserId').css('display','')
		$('#loginChk').css('display','')
		$('#idStar').css('display','')
		$('#pwdStar').css('display','')
		$('#pwdchkStar').css('display','')
		$('#saveName').append('사용자 등록')
		$('#custUserNm').val('')
		$('#custUserEmail').val('')
		$('#custUserId').val('')
		$('#custUserPwd').val('')
		$('#custUserPwdChk').val('')
		$('#custUserHp').val('')
		$('#custUserTel').val('')
		$('#custUserPosition').val('')
		$('#custUserBuseo').val('')


		$('#userSave').modal('show')
	}
	
	function userIdCheck(){
		if(!$('#custUserId').val().trim()){
			Swal.fire('', '아이디를 입력해 주세요.', 'warning')
			$('#custUserId').val('')
			return
		}

		const params = {
			userId : $('#custUserId').val().trim()
		}
			
		$.post("/api/v1/couser/idcheck", params, 
			function(response) {
			if(response.code === 'OK') {
				$('#custUserIdChk').val('Y')
				Swal.fire('', '사용 가능한 로그인 ID 입니다.', 'info');
			} else {
				Swal.fire('', '사용 불가능한 로그인 ID입니다.', 'warning')
			}
		},
		"json"
		);
	}
	
	function onLoginIdChkInit(){
		$('#custUserIdChk').val('')
	}
	
	function loginInputVali(input){
		input.value = input.value.replace(/[^A-Za-z0-9]/g, '');
	}
	
	
	function custUserSaveVali(){
		if(!$('#custUserNm').val().trim()){
			Swal.fire('', '이름을 입력해 주세요.', 'warning')
			$('#custUserNm').val('')
			return
		}
		
		if(!$('#custUserEmail').val().trim()){
			Swal.fire('', '이메일을 입력해 주세요.', 'warning')
			$('#custUserEmail').val('')
			return
		}
		
		const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-_]+\.[a-zA-Z]{2,}$/;
		if(!emailRegex.test($('#custUserEmail').val())){
			Swal.fire('', '이메일을 형식에 맞게 입력해 주세요', 'warning')
		   return;
		}
		
		if($('#saveName').text() === '사용자 등록'){
			if(!$('#custUserId').val().trim()){
				Swal.fire('', '아이디를 입력해 주세요.', 'warning')
				$('#custUserId').val('')
				return
			}
			
			if(!$('#custUserIdChk').val()){
				Swal.fire('', '아이디를 중복 확인해 주세요.', 'warning')
				return
			}
			
			if(!$('#custUserPwd').val()){
				Swal.fire('', '비밀번호를 입력해 주세요.', 'warning')
				return
			}
			
	        const pwdRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
	        if (!pwdRegex.test($('#custUserPwd').val())) {
	            Swal.fire('', '비밀번호는 최소 8자 이상, 숫자와 특수문자를 포함해야 합니다..', 'warning');
	            return
	        }
			
			if(!$('#custUserPwdChk').val()){
				Swal.fire('', '비밀번호 확인을 입력해 주세요.', 'warning')
				return
			}
			
			if ($('#custUserPwd').val() !== $('#custUserPwdChk').val()) {
			    Swal.fire('', '비밀번호가 일치하지 않습니다.', 'warning');
			    return;
			}
		}else{
			if($('#custUserPwd').val().trim()){
		       const pwdRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
		        if (!pwdRegex.test($('#custUserPwd').val())) {
		            Swal.fire('', '비밀번호는 최소 8자 이상, 숫자와 특수문자를 포함해야 합니다..', 'warning');
		            return
		        }
				
				if(!$('#custUserPwdChk').val()){
					Swal.fire('', '비밀번호 확인을 입력해 주세요.', 'warning')
					return
				}
				
				if ($('#custUserPwd').val() !== $('#custUserPwdChk').val()) {
				    Swal.fire('', '비밀번호가 일치하지 않습니다.', 'warning');
				    return;
				}
			}
		}

		if(!$('#custUserHp').val().trim()){
			Swal.fire('', '휴대폰 번호를 입력해 주세요', 'warning')
			$('#custUserHp').val('')
			return
		}
				
		if(!$('#custUserTel').val().trim()){
			Swal.fire('', '유선전화를 입력해 주세요', 'warning')
			$('#custUserTel').val('')
			return
		}
		
		$('#userSaveConfirm').modal('show')
		
	}
	
	function custUserSave(){
		
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		const params = {
			userName : $('#custUserNm').val(),
			userEmail : $('#custUserEmail').val(),
			userId : $('#custUserId').val(),
			userPwd : $('#custUserPwd').val(),
			userHp : $('#custUserHp').val(),
			userTel : $('#custUserTel').val(),
			userPosition : $('#custUserPosition').val(),
			userBuseo : $('#custUserBuseo').val(),
			custCode : loginInfo.custCode,
			updUserId : loginInfo.userId,
			saveType : $('#saveName').text() === '사용자 등록' ? 'REQ' : 'EDIT'
		}

		$.post(
			'/api/v1/cust/custUserSave',
			params
			)
			.done(function(arg) {
				if (arg.code === "OK") {
					onSearch(0)
					$('#userSave').modal('hide')
					$('#userSaveConfirm').modal('hide')
					Swal.fire('', '사용자 정보가 저장되었습니다.', 'info')
				}
				else{
		            Swal.fire('', '사용자 정보 저장을 실패하였습니다.', 'warning');
		            return
				}
			})
		
	}
	function userEditPop(data){
		const rowData = JSON.parse(decodeURIComponent(data))
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		$('#custUserRegFooter').css('display','none')
		$('#custUserEditFooter').css('display','')
		if(rowData.userId === loginInfo.userId){
			$('#custUserDelBtn').css('display','none')
		}else{
			$('#custUserDelBtn').css('display','')
		}
		$('#saveName').empty()
		$('#saveName').append('사용자 수정')
		$('#custUserNm').val(rowData.userName)
		$('#custUserEmail').val(rowData.userEmail)
		$('#loginIdEditStr').empty()
		$('#loginIdEditStr').append(rowData.userId)
		$('#custUserHp').val(onAddDashTel(rowData.userHp))
		$('#custUserTel').val(onAddDashTel(rowData.userTel))
		$('#custUserPosition').val(rowData.userPosition)
		$('#custUserBuseo').val(rowData.userBuseo)
		$('#userSave').modal('show')
		$('#custUserId').val(rowData.userId)
		$('#loginIdEditStr').css('display','')
		$('#custUserPwd').val('')
		$('#custUserPwdChk').val('')
		$('#custUserId').css('display','none')
		$('#loginChk').css('display','none')
		$('#idStar').css('display','none')
		$('#pwdStar').css('display','none')
		$('#pwdchkStar').css('display','none')
		
	}
	
	function custUserDelPop(){
		$('#userDelConfirm').modal('show')
		
	}
	
	function custUserDel(){
		
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		const params = {
			delUserId : $('#custUserId').val(),
			custCode : loginInfo.custCode,
			updUserId : loginInfo.userId,
			useYn : 'N',
		}

		$.post(
			'/api/v1/cust/custUserDel',
			params
			)
			.done(function(arg) {
				if (arg.code === "OK") {
					onSearch(0)
					$('#userSave').modal('hide')
					$('#userDelConfirm').modal('hide')
					Swal.fire('', '사용자가 삭제되었습니다.', 'info')
				}
				else{
		            Swal.fire('', '사용자 삭제를 실패하였습니다.', 'warning');
		            return
				}
			})
		
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
                <li>업체정보</li>
                <li>사용자관리</li>
            </ul>
        </div>
        <!-- //conHeader -->
        <!-- contents -->
        <div class="contents">
			<div class="conTopBox">
				<ul class="dList">
					<li>
						<div>전자입찰 시스템을 사용할 수 있는 사용자 목록입니다.</div>
					</li>
					<li>
						<div>사용자명을 클릭하면 정보 확인 후 수정하실 수 있습니다.</div>
					</li>
				</ul>
			</div>
            <!-- searchBox -->
            <div class="searchBox mt20">
                <div class="flex align-items-center">
                    <div class="sbTit mr30">사용자명</div>
                    <div class="flex align-items-center width200px">
                        <input id="srcUserNm" type="text"  class="inputStyle" autocomplete="off" maxlength="300">
                    </div>
                    <div class="sbTit mr30 ml50">로그인 ID</div>
                    <div class="flex align-items-center width200px">
                        <input id="srcLogin" type="text" class="inputStyle" autocomplete="off" maxlength="300">
                    </div>
                    <div class="sbTit mr30 ml50">상태</div>
                    <div class="flex align-items-center width200px">
                        <select id="srcUseYn" class="selectStyle maxWidth140px ml20" onchange="onSearch(0)">
	                        <option value="">전체</option>
	                        <option value="Y">정상</option>
	                        <option value="N">삭제</option>
                        </select>
                    </div>
                    <a onclick="onSearch(0)" class="btnStyle btnSearch">검색</a>
                </div>
            </div>
            <!-- //searchBox -->

            <div class="flex align-items-center justify-space-between mt40">
                <div class="width100">
                    전체 : <span class="textMainColor"><strong id="total"></strong></span>건
                    <select id="pageSize" class="selectStyle maxWidth140px ml20" onchange="onSearch(0)">
                        <option value="10">10개씩 보기</option>
                        <option value="20">20개씩 보기</option>
                        <option value="30">30개씩 보기</option>
                        <option value="50">50개씩 보기</option>
                    </select>
                </div>
                <div>
                    <a onclick="userRegPop()" class="btnStyle btnPrimary" title="사용자 등록" style="width:121px">사용자 등록</a>
                </div>
            </div>
            <table class="tblSkin1 mt10">
                <colgroup>
                    <col>
                    <col>
                    <col>
                    <col>
                    <col>
                    <col>
                </colgroup>
                <thead>
                    <tr>
                        <th>사용자명</th>
                        <th>로그인 ID</th>
                        <th>부서</th>
                        <th>직급</th>
                        <th>전화번호</th>
                        <th>휴대폰</th>
                        <th>상태</th>
                        <th class="end">사용권한</th>
                    </tr>
                </thead>
                <tbody id="noticeListBody">
                </tbody>
            </table>

            <!-- pagination -->
            <div class="row mt40">
                <div class="col-xs-12">
                	<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
                </div>
            </div>
            <!-- //pagination -->

        </div>
        <!-- //contents -->


			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
		
	<!-- 사용자 저장 -->
	<div class="modal fade modalStyle" id="userSave" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:600px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 id="saveName" class="modalTitle"></h2>
					<div class="flex align-items-center">
						<div class="formTit flex-shrink0 width120px">이름 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="custUserNm" class="inputStyle" placeholder=""></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">이메일 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="custUserEmail" class="inputStyle" placeholder="ex) sample@iljin.co.kr"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">아이디 <span id="idStar" class="star">*</span></div>
						<div class="flex align-items-center width100">
							<div class="width100">
								<input type="text" onchange="onLoginIdChkInit()" oninput="loginInputVali(this)" id="custUserId" class="inputStyle" placeholder="영문, 숫자 입력(8자 이내) 후 중복확인" maxlength="8">
								<input type="text" id="custUserIdChk" hidden="">
								<div id="loginIdEditStr"></div>
							</div>
							<a id="loginChk" onclick="userIdCheck()" class="btnStyle btnSecondary flex-shrink0 ml10" title="중복 확인">중복 확인</a>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">비밀번호<span id="pwdStar" class="star">*</span></div>
						<div class="width100">
							<input type="password" id="custUserPwd"class="inputStyle" placeholder="대/소문자, 숫자, 특수문자 2 이상 조합(길이 8~16자리)">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">비밀번호 확인<span id="pwdchkStar" class="star">*</span></div>
						<div class="width100">
							<input type="password" id="custUserPwdChk" class="inputStyle" placeholder="비밀번호와 동일해야 합니다.">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">휴대폰 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="custUserHp" class="inputStyle" placeholder=""></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">유선전화 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="custUserTel" class="inputStyle" placeholder=""></div>
					</div>					
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">직급</div>
						<div class="width100"><input type="text" id="custUserPosition" class="inputStyle" placeholder=""></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">부서</div>
						<div class="width100"><input type="text" id="custUserBuseo" class="inputStyle" placeholder=""></div>
					</div>

					<div id="custUserRegFooter" class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
						<a onclick="custUserSaveVali()" class="modalBtnCheck" title="저장">저장</a>
					</div>
					<div id="custUserEditFooter" class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
						<a id="custUserDelBtn" onclick="custUserDelPop()" class="btnStyle btnOutlineRed" title="삭제">삭제</a>
						<a onclick="custUserSaveVali()" class="modalBtnCheck" title="저장">저장</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- //사용자 저장 -->
	
		<!-- 사용자수정 저장 -->
	<div class="modal fade modalStyle" id="userSaveConfirm" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:420px">
			<div class="modal-content">
				<div class="modal-body">
					<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<div class="alertText2">입력하신 회원정보로 저장됩니다.<br>저장 하시겠습니까?</div>
					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
						<a onclick="custUserSave()" class="modalBtnCheck"  title="저장">저장</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- //사용자수정 저장 -->
	
	<!-- 사용자 삭제 -->
	<div class="modal fade modalStyle" id="userDelConfirm" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:420px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<div class="alertText2">삭제된 사용자는 로그인 하실 수 없습니다.<br>사용자를 삭제 하시겠습니까?</div>
					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
						<a onclick="custUserDel()" class="modalBtnCheck"  title="저장">삭제</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- //사용자 삭제 -->
		
	</div>
</body>
</html>
