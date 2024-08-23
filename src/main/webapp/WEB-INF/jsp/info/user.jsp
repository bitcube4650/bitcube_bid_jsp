<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		$('#srcUseYn').val('Y')
		onSearch(0);
		coInterList()
		
        $('#srcUserNm').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onSearch(0);
            }
        });
		
        $('#srcUserId').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onSearch(0);
            }
        });
		
		$("#userConfirmPassword").keydown(function(e){
			if(e.keyCode==13) {
				onUserPwdCheck();
			}
		});
		
	});
	
	
	function coInterList(){
		$.post(
				'/api/v1/statistics/coInterList',
				{}
			).done(function(arg){
				if(arg.code == "ERROR"){
					Swal.fire('', arg.msg, 'error');
				} else {
					const list = arg.data;
					
					const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
					const userAuth = loginInfo.userAuth
					
					if(list.length > 0){
						for(let i = 0; i < list.length; i++){
							$("#srcCoInter").append($("<option value='"+list[i].interrelatedCustCode+"'>"+list[i].interrelatedNm+"</option>"))
							$("#saveCoInter").append($("<option value='"+list[i].interrelatedCustCode+"'>"+list[i].interrelatedNm+"</option>"))
							
					        if (i % 5 === 0) {
					            if (i !== 0) {
					                $("#auth4").append('</td>');
					                $("#editAuth4").append('</td>');  
					            }
					            $("#auth4").append('<td>');
					            $("#editAuth4").append('<td>');
					        }
					        	
					        $("#auth4").append(
					            '<input type="checkbox" id="c' + i + '" name="auth4Check" class="checkStyle" value="' + list[i].interrelatedCustCode + '">' +
					            '<label for="c' + i + '" class="mr20">' + list[i].interrelatedNm + '</label>'
					        );
					        
					        $("#editAuth4").append(
					            '<input type="checkbox" id="ce' + i + '" name="editAuth4Check" class="checkStyle" value="' + list[i].interrelatedCustCode + '">' +
					            '<label for="ce' + i + '" class="mr20">' + list[i].interrelatedNm + '</label>'
					        );
					        
					
					        if (i === list.length - 1) {
					            $("#auth4").append('</td>');
					            $("#editAuth4").append('</td>');
					        }
						}
	
					}
					
				}
			});
	}
	
	function onSearch(page){
		const params = {
			interrelatedCustCode : 	$('#srcCoInter').val(),
			useYn : $('#srcUseYn').val(),
			userName : $('#srcUserNm').val(),
			userId : $('#srcUserId').val(),
			"size"		: $("#pageSize").val(),
			"page"		: page
		}
		
		$.post("/api/v1/couser/userList", params, 
			function(response) {
			if(response.code === 'OK') {
				var list = response.data.content;
				updatePagination(response.data);
				$("#total").html(response.data.totalElements)
				$("#userListBody").empty();
				for(var i=0;i<list.length;i++) {
					$("#userListBody").append(
						"<tr>" +
							'<td class="text-left"><a data-toggle="modal" class="textUnderline notiTitle" onClick="onUserEdit(\'' + list[i].userId + '\')">' + list[i].userName + '</a></td>' +
							'<td class="text-left"><a data-toggle="modal" class="textUnderline notiTitle"  onClick="onUserEdit(\'' + list[i].userId + '\')">' + list[i].userId + '</a></td>' +
							'<td>'+ (list[i].userPosition || '') +'</td>' +
							'<td>'+ (list[i].deptName || '')+'</td>' +
							'<td>'+ list[i].userTel +'</td>'+
							'<td>'+ list[i].userHp +'</td>'+
							'<td>'+ list[i].userAuth  +'</td>'+
							'<td>'+ list[i].useYn +'</td>'+
							'<td>'+ list[i].interrelatedNm +'</td>'+
						"</tr>"
					);
				}
			} else {
				Swal.fire('', response.msg, 'warning')
			}
		},
		"json"
		);
	}
	
	function onUserRegModal(){
		
		//값 초기화
		$('#saveLoginId').val('');
		$('#loginIdChk').val('')
		$('#userSavePwd').val('');
		$('#userSavePwdChk').val('');
		$('#saveName').val('');
		$('#saveCoInter').val('');
		$('#saveUseAuth').val('');
		$('#saveOpenAuth').val('');
		$('#saveBidAuth').val('');
		$('#savePhone').val('');
		$('#saveTel').val('');
		$('#saveMail').val('');
		$('#saveUserPosition').val('');
		$('#saveDept').val('');
		$('#saveUseYn').val('Y');
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		const userAuth = loginInfo.userAuth
		if(userAuth === '4'){
			$('input[name="auth4Check"]').prop('checked', false)
		}
		
	    $('#userReg').modal('show');

	    $('#saveLoginId').focus();
	    
	}
	
	function onLoginIdChk(){
		if(!$('#saveLoginId').val().trim()){
			Swal.fire('', '로그인 ID를 입력해 주세요.', 'warning')
			$('#saveLoginId').val('')
			return
		}
		

		const params = {
			userId : $('#saveLoginId').val().trim()
		}
			
		$.post("/api/v1/couser/idcheck", params, 
			function(response) {
			if(response.code === 'OK') {
				$('#loginIdChk').val('Y')
				Swal.fire('', '사용 가능한 로그인 ID 입니다.', 'info');
			} else {
				Swal.fire('', '사용 불가능한 로그인 ID입니다.', 'warning')
			}
		},
		"json"
		);
		
	}
	
	function onLoginIdChkInit(){
		$('#loginIdChk').val('')
	}

	function onUseAuthChk(auth){
		if(auth.value === '4'){
			 $("#auth4Block").css("display", "")	
		}else{
			 $("#auth4Block").css("display", "none")	
		}
	}
	
	function onEditUseAuthChk(auth){

		if(auth.value === '4'){
			 $("#editAuth4Block").css("display", "")	
		}else{
			 $("#editAuth4Block").css("display", "none")	
		}
	}
	
	function onUserReg(){
		
		if(!$('#saveLoginId').val().trim()){
			Swal.fire('', '로그인 ID를 입력해 주세요.', 'warning')
			$('#saveLoginId').val('')
			return
		}
		
		if(!$('#loginIdChk').val()){
			Swal.fire('', '로그인 ID를 중복 확인해 주세요.', 'warning')
			return
		}
	
		if(!$('#userSavePwd').val()){
			Swal.fire('', '비밀번호를 입력해 주세요.', 'warning')
			return
		}
		
        const pwdRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
        if (!pwdRegex.test($('#userSavePwd').val())) {
            Swal.fire('', '비밀번호는 최소 8자 이상, 숫자와 특수문자를 포함해야 합니다..', 'warning');
            return
        }
		
		if(!$('#userSavePwdChk').val()){
			Swal.fire('', '비밀번호 확인을 입력해 주세요.', 'warning')
			return
		}
		
		if ($('#userSavePwd').val() !== $('#userSavePwdChk').val()) {
		    Swal.fire('', '비밀번호가 일치하지 않습니다.', 'warning');
		    return;
		}
		
		if(!$('#saveName').val().trim()){
			Swal.fire('', '이름을 입력해 주세요.', 'warning')
			$('#saveName').val('')
			return
		}
		
		if(!$('#saveCoInter').val()){
			Swal.fire('', '소속 계열사를 선택해 주세요.', 'warning')
			$('#saveCoInter').val('')
			return
		}
		const userAuth = $('#saveUseAuth').val()
		if(!userAuth){
			Swal.fire('', '사용 권한을 선택해 주세요.', 'warning')
			return
		}
					
		if(userAuth === '4'){
			if ($("input[name='auth4Check']:checked").length === 0) {
				Swal.fire('', '계열사를 1개 이상 선택해 주세요.', 'warning')
				return
			}
		}
		
		if(!$('#savePhone').val().trim()){
			Swal.fire('', '휴대폰을 입력해 주세요.', 'warning')
			$('#savePhone').val('')
			return
		}
		
		const phoneNumberRegex = /^\d{3}-\d{3,4}-\d{4}$/;
        if (!phoneNumberRegex.test($('#savePhone').val())) {
            Swal.fire('', '휴대폰번호 형식에 맞게 입력해주세요.', 'warning');
            return
        }
		
		if(!$('#saveTel').val().trim()){
			Swal.fire('', '유선전화를 입력해 주세요.', 'warning')
			$('#saveTel').val('')
			return
		}		
		
        const telNumberRegex = /^\d{2,3}-\d{3,4}-\d{4}$/;
        if (!telNumberRegex.test($('#saveTel').val())) {
            Swal.fire('', '유선전화 형식에 맞게 입력해주세요.', 'warning');
            return 
        }
		
		if(!$('#saveMail').val().trim()){
			Swal.fire('', '이메일을 입력해 주세요.', 'warning')
			$('#saveMail').val('')
			return
		}
		
		const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test($('#saveMail').val())) {
            Swal.fire('', '입력한 이메일 형식이 올바르지 않습니다.', 'warning');
            return
        }

        const params = {
       		userId : $('#saveLoginId').val().trim(),
       		userPwd : $('#userSavePwd').val(),
       		userName : $('#saveName').val(),
       		interrelatedCustCode : $('#saveCoInter').val(),
       		userAuth : userAuth,
       		openauth : $('#saveOpenAuth').val(),
       		bidauth :  $('#saveBidAuth').val(),
       		userHp : $('#savePhone').val().trim() ,
       		userTel : $('#saveTel').val().trim(),
       		userEmail : $('#saveMail').val().trim(),
       		userPosition : $('#saveUserPosition').val().trim(),
       		deptName : $('#saveDept').val().trim(),
       		useYn : $('#saveUseYn').val(),   
       		insertYn : 'Y',
        }
		
		if(userAuth === '4'){
			const checkedValues = [];
			const checkboxes = document.querySelectorAll('input[name="auth4Check"]:checked');

			for (let i = 0; i < checkboxes.length; i++) {
			    checkedValues.push(checkboxes[i].value);
			}

			params.userInterrelatedList = checkedValues;
		}
		
		$.post(
			"/api/v1/couser/userSave",
			params
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				Swal.fire('', '사용자가 정상적으로 등록되었습니다.', 'info');
				onSearch(0);
				$('#userReg').modal('hide')
			}else{
	            Swal.fire('', '사용자 등록을 실패하였습니다.', 'warning');
	            return
			}
		})
		
	}
	
    function formatPhone(input) {
        let value = input.value.replace(/\D/g, ''); 
        if (value.length > 3 && value.length <= 7) {
            value = value.replace(/(\d{3})(\d+)/, '$1-$2');
        } else if (value.length > 7) {
            value = value.replace(/(\d{3})(\d{3,4})(\d+)/, '$1-$2-$3');
        }
        input.value = value;
    }
    
    function formatTel(input) {
        let value = input.value.replace(/\D/g, ''); 
        
        if (value.length > 6) {
            value = value.replace(/(\d{2,3})(\d{3,4})(\d{4})/, '$1-$2-$3');
        } else if (value.length > 3) {
            value = value.replace(/(\d{2,3})(\d{3,4})/, '$1-$2');
        }
        
        input.value = value;
    }
	
	function onUserEdit(loginId){
		const rowLoginId = loginId
		$("#rowLoginId").val(rowLoginId)
		$('#userCheckPwdPop').modal('show')
	}
				
	function loginInputVali(input){
		input.value = input.value.replace(/[^A-Za-z0-9]/g, '');
	}
	
	
	function onUserPwdCheck(){	

		$.post(
			"/api/v1/main/checkPwd",
			{ password : $("#userConfirmPassword").val() }
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				onUserDetail()
			}else {
				Swal.fire('', '비밀번호가 일치하지 않습니다.', 'warning');
			}
		})
		.always(function(arg){
			$("#userCheckPwdPop").modal('hide');
			$("#userConfirmPassword").val('');
			$("#userEdit").modal('show');
		})
		
	}
	
	
	function onUserDetail(){
		
		const params = {
			userId : $('#rowLoginId').val()
		}
				
		$.post("/api/v1/couser/userDetail", params, 
			function(response) {
			if(response.code === 'OK') {

				const data = response.data

				$('#editLoginId').empty()
				$('#editLoginId').append(data.userId)
				$('#editSaveLoginId').val(data.userId)
				$('#editSaveInterrelatedCustCode').val(data.interrelatedCustCode)
				$('#editName').val(data.userName)
				$('#editCointer').empty()
				$('#editCointer').append(data.interrelatedNm)
				$('#editUseAuth').val(data.userAuth)
				$('#editOpenAuth').val(data.openauth)
				$('#editBidAuth').val(data.bidauth)

				$('#editPhone').val(data.userHp)
				$('#editTel').val(data.userTel)	
				$('#editMail').val(data.userEmail)
				$('#editUserPosition').val(data.userPosition)
				$('#editDept').val(data.deptName)	
				$('#editUseYn').val(data.useYn)	
				
				const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))

				if(loginInfo.userId != data.userId){
					$("#pwdChkDisplay").css("display", "")
					$('#editPweUpdate').empty()
					$('#editPweUpdate').append("최종변경일 : " + data.pwdEditDateStr)
					
				}
				
				$('input[name="editAuth4Check"]').prop('checked', false)
				
				if(data.userAuth === '4'){
					$("#editAuth4Block").css("display", "")
					const userInterrelated = data.userInterrelated
					
					userInterrelated.forEach(function(item) {

					    let checkbox = document.querySelector('input[name="editAuth4Check"][value="' + item.interrelatedCustCode + '"]');
					    

					    if (checkbox) {
					        checkbox.checked = true;
					    }
					});		
					
				}else{
					$("#editAuth4Block").css("display", "none")
				}

			} else {
				Swal.fire('', '사용자 정보 조회를 실패하였습니다..', 'warning')
			}
		},
		"json"
		);
		
	}
	
	function onUserUpdate(){

		if(!$('#editName').val().trim()){
			Swal.fire('', '이름을 입력해 주세요.', 'warning')
			$('#editName').val('')
			return
		}
	
		const userAuth = $('#editUseAuth').val()
		if(!userAuth){
			Swal.fire('', '사용 권한을 선택해 주세요.', 'warning')
			return
		}
					
		if(userAuth === '4'){
			if ($("input[name='editAuth4Check']:checked").length === 0) {
				Swal.fire('', '계열사를 1개 이상 선택해 주세요.', 'warning')
				return
			}
		}
		
		if(!$('#editPhone').val().trim()){
			Swal.fire('', '휴대폰을 입력해 주세요.', 'warning')
			$('#savePhone').val('')
			return
		}
		
		const phoneNumberRegex = /^\d{3}-\d{3,4}-\d{4}$/;
        if (!phoneNumberRegex.test($('#editPhone').val())) {
            Swal.fire('', '휴대폰번호 형식에 맞게 입력해주세요.', 'warning');
            return
        }
		
		if(!$('#editTel').val().trim()){
			Swal.fire('', '유선전화를 입력해 주세요.', 'warning')
			$('#editTel').val('')
			return
		}		
		
        const telNumberRegex = /^\d{2,3}-\d{3,4}-\d{4}$/;
        if (!telNumberRegex.test($('#editTel').val())) {
            Swal.fire('', '유선전화 형식에 맞게 입력해주세요.', 'warning');
            return 
        }
		
		if(!$('#editMail').val().trim()){
			Swal.fire('', '이메일을 입력해 주세요.', 'warning')
			$('#saveMail').val('')
			return
		}
		
		const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test($('#editMail').val())) {
            Swal.fire('', '입력한 이메일 형식이 올바르지 않습니다.', 'warning');
            return
        }

        const params = {
       		userId : $('#editSaveLoginId').val(),
       		userName : $('#editName').val(),
       		interrelatedCustCode : $('#editSaveInterrelatedCustCode').val(),
       		userAuth : userAuth,
       		openauth : $('#editOpenAuth').val(),
       		bidauth :  $('#editBidAuth').val(),
       		userHp : $('#editPhone').val().trim() ,
       		userTel : $('#editTel').val().trim(),
       		userEmail : $('#editMail').val().trim(),
       		userPosition : $('#editUserPosition').val().trim(),
       		deptName : $('#editDept').val().trim(),
       		useYn : $('#editUseYn').val(),   
       		insertYn : 'N',
        }
		
		if(userAuth === '4'){
			const checkedValues = [];
			const checkboxes = document.querySelectorAll('input[name="editAuth4Check"]:checked');

			for (let i = 0; i < checkboxes.length; i++) {
			    checkedValues.push(checkboxes[i].value);
			}

			params.userInterrelatedList = checkedValues;
		}

		$.post(
			"/api/v1/couser/userSave",
			params
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				Swal.fire('', '사용자가 정상적으로 수정되었습니다.', 'info');
				onSearch(0);
				$('#userEdit').modal('hide')
			}else{
	            Swal.fire('', '사용자 수정을 실패하였습니다.', 'warning');
	            return
			}
		})
		
	}
	
	function onPwdEditModal(){
		
		$('#pwdEdit').modal('show')
	}
	
	function onPwdEditSave(){
		
		if(!$('#editPwd').val()){
			Swal.fire('', '비밀번호를 입력해 주세요.', 'warning')
			return
		}
		
        const pwdRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
        if (!pwdRegex.test($('#editPwd').val())) {
            Swal.fire('', '비밀번호는 최소 8자 이상, 숫자와 특수문자를 포함해야 합니다..', 'warning');
            return
        }
		
		if(!$('#editPwdChk').val()){
			Swal.fire('', '비밀번호 확인을 입력해 주세요.', 'warning')
			return
		}
		
		if ($('#editPwd').val() !== $('#editPwdChk').val()) {
		    Swal.fire('', '비밀번호가 일치하지 않습니다.', 'warning');
		    return;
		}
		
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))

		const params = {
			userPwd : $('#editPwd').val(),
			userId : $('#rowLoginId').val(),
			updateUser : loginInfo.userId
		}
		$.post(
				"/api/v1/couser/saveChgPwd",
				params
			)
			.done(function(arg) {
				if (arg.code === "OK") {
					Swal.fire('', '비밀번호가 정상적으로 변경되었습니다.', 'info');
					onUserDetail();
					$('#pwdEdit').modal('hide')
				}else{
		            Swal.fire('', '비밀번호 변경을 실패하였습니다.', 'warning');
		            return
				}
			})
		
	}
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
		    <div class="conRight">
		        <div class="conHeader">
		            <ul class="conHeaderCate">
		                <li>정보관리</li>
		                <li>사용자관리</li>
		            </ul>
		        </div>
		
		        <div class="contents">
			        <div class="conTopBox">
				        <ul class="dList">
					        <li><div>그룹사 사용자를 관리합니다.</div></li>
					        <li><div>사용자명과 아이디 클릭 시 상세정보를 확인할 수 있습니다. (보안을 위해 본인의 암호를 입력해야 확인 가능합니다.)</div></li>
				        </ul>
			        </div>
		        		                
	                <div class="searchBox mt20">
		                <div class="flex align-items-center">
			                <div class="sbTit width100px">그룹사</div>
			                <div class="flex align-items-center width250px">
				                <select id="srcCoInter" class="selectStyle" onchange="onSearch(0)">
				                <option value="">전체</option>
			                </select>
			                </div>
			                <div class="sbTit width100px ml50">사용여부</div>
			                <div class="flex align-items-center width250px">
			                <select id="srcUseYn" class="selectStyle" onchange="onSearch(0)">
				                <option value="">전체</option>
				                <option value="Y">사용</option>
				                <option value="N">미사용</option>
			                </select>
			                </div>
		                </div>
		                <div class="flex align-items-center height50px mt10">
			                <div class="sbTit width100px">사용자명</div>
			                <div class="flex align-items-center width250px">
			                	<input type="text" id="srcUserNm" placeholder="" class="inputStyle">
			                </div>
			                <div class="sbTit width100px ml50">아이디</div>
			                <div class="width250px"
				                ><input type="text" id="srcUserId" class="inputStyle">
			                </div>
			                <a class="btnStyle btnSearch" onclick="onSearch(0)">검색</a>
		                </div>
	                </div>

		
		            <div class="flex align-items-center justify-space-between mt40">
		                <div class="width100">
		                    전체 : <span id="totalElements" class="textMainColor"><strong id="total"></strong></span>건
		                    <select id="pageSize" class="selectStyle maxWidth140px ml20" onchange="onSearch(0)">
		                        <option value="10">10개씩 보기</option>
		                        <option value="20">20개씩 보기</option>
		                        <option value="30">30개씩 보기</option>
		                        <option value="50">50개씩 보기</option>
		                    </select>
		                </div>
		                <div class="flex-shrink0">
		                    <a class="btnStyle btnPrimary" onClick="onUserRegModal()" title="사용자 등록">사용자 등록</a>
		                </div>
		            </div>
		
		            <table class="tblSkin1 mt10">
		                <colgroup>
		                    <col style="width: 15%" />
		                    <col />
		                    <col style="width: 15%" />
		                    <col style="width: 15%" />
		                </colgroup>
		                <thead>
		                    <tr>
		                        <th>사용자명</th>
		                        <th>아이디</th>
		                        <th>직급</th>
		                        <th>부서</th>
		                        <th>전화번호</th>
		                        <th>휴대폰</th>
		                        <th>사용권한</th>
		                        <th>사용여부</th>
		                        <th class="end">소속사</th>
		                    </tr>
		                </thead>
		                <tbody id="userListBody">
		                    
		                </tbody>
		            </table>
		
		            <div class="row mt40">
		                <div class="col-xs-12">
		                    <jsp:include page="/WEB-INF/jsp/pagination.jsp" />
		                </div>
		            </div>
		           </div>
		        </div>

		    </div>
    	</div>
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    	

        <input type="text" id="rowLoginId" class="inputStyle" hidden="">
		<input type="text" id="editSaveLoginId" class="inputStyle"  hidden="">
		<input type="text" id="editSaveInterrelatedCustCode" class="inputStyle"  hidden="">
							
    <!-- 사용자 등록 -->
	<div class="modal fade modalStyle" id="userReg" tabindex="-1" role="dialog">
		<div class="modal-dialog" style="width:100%; max-width:650px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle">사용자 등록</h2>
					<div class="flex align-items-center">
						<div class="formTit flex-shrink0 width120px">로그인ID <span class="star" >*</span></div>
						<div class="flex align-items-center width100">
							<div class="width100">
							<input type="text" onchange="onLoginIdChkInit()" id="saveLoginId" class="inputStyle" placeholder="영문, 숫자 입력(8자 이내) 후 중복확인" maxlength="8" oninput="loginInputVali(this)"  autoComplete="off">
							<input type="text" id="loginIdChk" hidden="" >
							</div>
							<a onclick="onLoginIdChk()" class="btnStyle btnSecondary flex-shrink0 ml10" title="중복 확인">중복 확인</a>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">비밀번호</div>
						<div class="width100">
							<input type="password" id="userSavePwd" class="inputStyle" placeholder="대/소문자, 숫자, 특수문자 2 이상 조합(길이 8~16자리)" maxlength="16">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">비밀번호 확인</div>
						<div class="width100">
							<input type="password" id="userSavePwdChk" class="inputStyle" placeholder="비밀번호와 동일해야 합니다." maxlength="16">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">이름 <span class="star">*</span></div>
						<div class="width100">
							<input type="text"  id="saveName" class="inputStyle"  autoComplete="off">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">소속 계열사 <span class="star">*</span></div>
						<div class="width100">
							<select id="saveCoInter" class="selectStyle">
								<option value="">선택</option>
							</select>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">사용권한 <span class="star">*</span></div>
						<div class="width100">
							<select id="saveUseAuth" class="selectStyle" onchange="onUseAuthChk(this)">
								 <option value="">선택</option>
		                         <option value="1">시스템관리자</option>
		                         <option value="2">각사관리자</option>
		                         <option value="3">일반사용자</option>
		                         <option value="4">감사사용자</option>
							</select>
						</div>
					</div>
					
					<div id="auth4Block" class="flex align-items-center mt10" style="display:none">
						<div class="formTit flex-shrink0 width120px">계열사
							<!-- 툴팁 -->
							<i class="fas fa-question-circle toolTipSt ml5">
								<div class="toolTipText" style="width:420px">
									<ul class="dList">
										<li><div>사용권한을 감사사용자를 선택하면 아래 계열사는 한 개 이상 선택해야 합니다.</div></li>
										<li><div>선택된 계열사는 입찰 및 통계 조회 시 선택된 계열사에 한해 조회 됩니다.</div></li>
									</ul>
								</div>
							</i>
							<!-- //툴팁 -->
						</div>
						<div class="flex align-items-center flex-wrap-wrap width100">
							<table>
								<tbody>
									<tr id="auth4">
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="flex align-items-center mt20">
						<div class="formTit flex-shrink0 width120px">개찰권한 <span class="star">*</span></div>
						<div class="width100">
							<select id="saveOpenAuth" class="selectStyle">
								<option value="">아니오</option>
                            	<option value="1">개찰권한</option>
							</select>
						</div>
					</div>
					<div class="flex align-items-center mt20">
						<div class="formTit flex-shrink0 width120px">낙찰권한 <span class="star">*</span></div>
						<div class="width100">
							<select id="saveBidAuth" class="selectStyle">
								<option value="">아니오</option>
                            	<option value="1">낙찰권한</option>
							</select>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">휴대폰 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="savePhone" class="inputStyle" placeholder="숫자만" oninput="formatPhone(this)" autoComplete="off"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">유선전화 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="saveTel" class="inputStyle" placeholder="숫자만" autoComplete="off" oninput="formatTel(this)"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">이메일 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="saveMail" class="inputStyle" placeholder="james@iljin.co.kr" autoComplete="off"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">직급</div>
						<div class="width100"><input type="text" id="saveUserPosition" class="inputStyle" placeholder="" autoComplete="off"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">부서</div>
						<div class="width100"><input type="text" id="saveDept" class="inputStyle" placeholder="" autoComplete="off"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">사용여부 <span class="star">*</span></div>
						<div class="width100">
							<select id="saveUseYn" class="selectStyle">
								<option value="Y">사용</option>
	                            <option value="N">미사용</option>
							</select>
						</div>
					</div>

					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
						<a onclick="onUserReg()" class="modalBtnCheck" title="저장">저장</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- //사용자 등록 -->

     <!-- 사용자 수정 -->
	<div class="modal fade modalStyle" id="userEdit" tabindex="-1" role="dialog">
		<div class="modal-dialog" style="width:100%; max-width:650px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle">사용자 수정</h2>
					<div class="flex align-items-center">
						<div class="formTit flex-shrink0 width120px">로그인ID <span class="star" >*</span></div>
						<div class="flex align-items-center width100">
							<div class="width100" id="editLoginId">
							</div>
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">이름 <span class="star">*</span></div>
						<div class="width100">
							<input type="text" id="editName" class="inputStyle"  autoComplete="off">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">소속 계열사 <span class="star">*</span></div>
						<div id="editCointer" class="width100">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">사용권한 <span class="star">*</span></div>
						<div class="width100">
							<select id="editUseAuth" class="selectStyle" onchange="onEditUseAuthChk(this)">
								 <option value="">선택</option>
		                         <option value="1">시스템관리자</option>
		                         <option value="2">각사관리자</option>
		                         <option value="3">일반사용자</option>
		                         <option value="4">감사사용자</option>
							</select>
						</div>
					</div>
					
					<div id="editAuth4Block" class="flex align-items-center mt10" style="display:none">
						<div class="formTit flex-shrink0 width120px">계열사
							<!-- 툴팁 -->
							<i class="fas fa-question-circle toolTipSt ml5">
								<div class="toolTipText" style="width:420px">
									<ul class="dList">
										<li><div>사용권한을 감사사용자를 선택하면 아래 계열사는 한 개 이상 선택해야 합니다.</div></li>
										<li><div>선택된 계열사는 입찰 및 통계 조회 시 선택된 계열사에 한해 조회 됩니다.</div></li>
									</ul>
								</div>
							</i>
							<!-- //툴팁 -->
						</div>
						<div class="flex align-items-center flex-wrap-wrap width100">
							<table>
								<tbody>
									<tr id="editAuth4">
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="flex align-items-center mt20">
						<div class="formTit flex-shrink0 width120px">개찰권한 <span class="star">*</span></div>
						<div class="width100">
							<select id="editOpenAuth" class="selectStyle">
								<option value="">아니오</option>
                            	<option value="1">개찰권한</option>
							</select>
						</div>
					</div>
					<div class="flex align-items-center mt20">
						<div class="formTit flex-shrink0 width120px">낙찰권한 <span class="star">*</span></div>
						<div class="width100">
							<select id="editBidAuth" class="selectStyle">
								<option value="">아니오</option>
                            	<option value="1">낙찰권한</option>
							</select>
						</div>
					</div>
					<div id="pwdChkDisplay" class="flex align-items-center mt20" style="display:none">
						<div class="formTit flex-shrink0 width120px">비밀번호 <span class="star" >*</span></div>
						<div class="flex align-items-center width100">
							<div class="width100" id="editPweUpdate">
							</div>
							<a onclick="onPwdEditModal()" class='btnStyle btnSecondary flex-shrink0 ml10' title='비밀번호 변경'>비밀번호 변경</a>
							
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">휴대폰 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="editPhone" class="inputStyle" placeholder="숫자만" oninput="formatPhone(this)" autoComplete="off"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">유선전화 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="editTel" class="inputStyle" placeholder="숫자만" autoComplete="off" oninput="formatTel(this)"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">이메일 <span class="star">*</span></div>
						<div class="width100"><input type="text" id="editMail" class="inputStyle" placeholder="james@iljin.co.kr" autoComplete="off"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">직급</div>
						<div class="width100"><input type="text" id="editUserPosition" class="inputStyle" placeholder="" autoComplete="off"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">부서</div>
						<div class="width100"><input type="text" id="editDept" class="inputStyle" placeholder="" autoComplete="off"></div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">사용여부 <span class="star">*</span></div>
						<div class="width100">
							<select id="editUseYn" class="selectStyle">
								<option value="Y">사용</option>
	                            <option value="N">미사용</option>
							</select>
						</div>
					</div>

					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
						<a onclick="onUserUpdate()" class="modalBtnCheck" title="저장">저장</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	
		<!-- 비밀번호 확인 모달 -->
	<div class="modal fade modalStyle" id="userCheckPwdPop" tabindex="-1" role="dialog">
		<div class="modal-dialog" style="width:100%; max-width:510px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle">비밀번호 확인</h2>
					<div class="flex align-items-center">
						<div class="formTit flex-shrink0 width100px">비밀번호</div>
						<div class="width100">
							<input type="password" id="userConfirmPassword" class="inputStyle"/>
						</div>
					</div>
					<p class="text-center mt20"><i class="fa-light fa-circle-info"></i> 안전을 위해서 비밀번호를 입력해 주십시오</p>
					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
						<a onclick="onUserPwdCheck()" class="modalBtnCheck" title="확인">확인</a>
					</div>
				</div>
			</div>
		</div>
	</div>
		<!-- 비밀번호 확인 모달 -->
		
	<!-- 비밀번호 변경 -->
	<div class="modal fade modalStyle" id="pwdEdit" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:510px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle">비밀번호 변경</h2>
					<div class="flex align-items-center">
						<div class="formTit flex-shrink0 width120px">비밀번호</div>
						<div class="width100">
							<input type="password" id="editPwd" class="inputStyle" placeholder="대/소문자, 숫자, 특수문자 2 이상 조합(길이 8~16자리)">
						</div>
					</div>
					<div class="flex align-items-center mt10">
						<div class="formTit flex-shrink0 width120px">비밀번호 확인</div>
						<div class="width100">
							<input type="password" id="editPwdChk" class="inputStyle" placeholder="비밀번호와 동일해야 합니다.">
						</div>
					</div>

					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
						<a onclick="onPwdEditSave()" class="modalBtnCheck" data-toggle="modal" data-target="#pwMody3" title="저장">저장</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- //비밀번호 변경 -->
		
</body>
</html>
