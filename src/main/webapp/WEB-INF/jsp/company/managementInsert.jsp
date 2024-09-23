<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		$('#interrelatedNm').append(loginInfo.custName)  
		
        $('#srcOtherCustName').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onSearch(0);
            }
        });
	});

		
	function onSearch(page){
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
			
		
		const params = {
			custCode : loginInfo.custCode,
			custType : $('#srcOtherCustTypeCode').val(),
			custName : $('#srcOtherCustName').val().trim(),
			page : page,
			size : '10'
		}
		
		$.post("/api/v1/cust/otherCustList", params, 
			function(response) {
			if(response.code === 'OK') {
				const list = response.data.content;
				updatePagination(response.data);
				$("#total").html(response.data.totalElements)
				$("#otherCustListBody").empty();
				for(var i=0;i<list.length;i++) {
					$("#otherCustListBody").append(
					    "<tr>" +
				        	'<td>' + list[i].custName + '</td>' +
					        '<td>' + list[i].custType1 + '</td>' +
					        '<td>' + list[i].regnum + '</td>' +
					        '<td>' + list[i].presName + '</td>' +
					        '<td>' + list[i].interrelatedNm +
							'<td class="text-center"><a class="btnStyle btnSecondary btnSm" onclick="selectOtherCust(\'' + list[i].custCode + '\')">조회</a></td>' +
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
	
	function onCustDetail(custCode){

		const params = {
			custCode : custCode,
		}
		
		$.post("/api/v1/cust/otherCustDetail", params, 
			function(response) {
			const data = response.data[0]
				if(response.code === 'OK') {
					$('#otherCompany').modal('hide')
					$('#type1Str, #type2Str,#otherCustIdStr').empty()
				 	$("#custType1").val(data.custType1),
				 	$("#custType2").val(data.custType2),
					$('#type1Str').append(data.custTypeNm1)
					$('#type2Str').append(data.custTypeNm2 || '')
					$('#otherCustName').val(data.custName)
		            $('#otherCustPresName').val(data.presName)
		            $('#otherCustCapital').val(Number(data.capital).toLocaleString())
		            $('#otherCustFoundYear').val(data.foundYear)
		            $('#otherCustTel').val(data.tel)
		            $('#otherCustFax').val(data.fax)
		            $('#otherCustZipcode').val(data.zipcode)
		            $('#otherCustAddr').val(data.addr)
		            $('#otherCustAddrDetail').val(data.addrDetail)
					$('#manageItem,#type1Str,#type2Str,#otherCustIdStr').css('display','')
					$('#type1Input,#type2Input,#custUserInput,#otherCustUserPwdInPut').css('display','none')
					

		            $('#otherCustRegnum1').val(data.regnum1 || '')
		            $('#otherCustRegnum2').val(data.regnum2 || '')
		            $('#otherCustRegnum3').val(data.regnum3 || '')
		            
		            $('#otherCustPresJuminNo1').val(data.presJuminNo1 || '')
		            $('#otherCustPresJuminNo2').val(data.presJuminNo2 || '')
		            
		            $('#otherCustUserNm').val(data.userName)
		            $('#otherUserCustEmail').val(data.userEmail)
		            $('#otherCustUserHp').val(data.userHp)
		            $('#otherCustUserTel').val(data.userTel)
		            $('#otherCustIdStr').append(data.userId)
		            $('#otherCustUserPosition').val(data.userPosition)
		            $('#otherCustUserbuseo').val(data.userBuseo)

					if(data.regnumFile){
						$("#emptyFile1").css("display", "none");
						$("#preview1").css("display", "block");
						$("#fileName1").text(data.regnumFile);
						$("#regnumFilePath").val(data.regnumPath)
					}else{
						$("#emptyFile1").css("display", "");
						$("#preview1").css("display", "none");
						$("#fileName1").text();
						$("#regnumFilePath").val('')
					}
					if(data.BFile){
						$("#emptyFile2").css("display", "none");
						$("#preview2").css("display", "block");
						$("#fileName2").text(data.BFile)
						$("#bFilePath").val(data.BFilePath)
					}else{
						$("#emptyFile2").css("display", "");
						$("#preview2").css("display", "none");
						$("#fileName2").text('')
						$("#bFilePath").val('')
					}
					
					
					$('#otherCustSaveYn').val('Y')
					
			} else {
				Swal.fire('', response.msg, 'warning')
			}
		},
		"json"
		);
	}
	
	function selectOtherCust(custCode){
		onCustDetail(custCode)
	}

	function otherCompanyPop(){
		$("#otherCustRemoveBtn").css('display','none')
		$("#srcOtherCustTypeNm").val('')
		$("#srcOtherCustTypeCode").val('')
		$("#srcOtherCustName").val('')		
		onSearch(0)
		$('#otherCompany').modal('show')
	}
	
	function openCustTypePop(type) {
		$("#itemType").val(type);
		$("#custTypePop").modal('show');
	}
	
	
	function itemSelectCallback(itemCode,itemName){
		console.log(itemCode)
		$("#custTypePop").modal('hide');
		let type = $("#itemType").val();
		if("type1" === type) {
			
			$("#custType1").val(itemCode);
			$("#custTypeNm1").val(itemName);
			
		} else if("type2" === type) {
			
			$("#custType2").val(itemCode);
			$("#custTypeNm2").val(itemName);
			
		}else if("type3" === type) {
			$("#srcOtherCustTypeCode").val(itemCode);
			$("#srcOtherCustTypeNm").val(itemName);
			$('#otherCustRemoveBtn').css('display','')
		}
	}
	
	function otherCustItemRemove(){
		$("#srcOtherCustTypeCode").val('');
		$("#srcOtherCustTypeNm").val('');
		$('#otherCustRemoveBtn').css('display','none')
	}

	function onLoginIdChk(){
		if(!$('#otherCustUserId').val().trim()){
			Swal.fire('', '로그인 ID를 입력해 주세요.', 'warning')
			$('#otherCustUserId').val('')
			return
		}

		const params = {
			userId : $('#otherCustUserId').val().trim()
		}
			
		$.post("/api/v1/couser/idcheck", params, 
			function(response) {
			if(response.code === 'OK') {
				$('#otherCustUSerLoginIdChk').val('Y')
				Swal.fire('', '사용 가능한 로그인 ID 입니다.', 'info');
			} else {
				Swal.fire('', '사용 불가능한 로그인 ID입니다.', 'warning')
			}
		},
		"json"
		);
	}
	
	function onLoginIdChkInit(){
		$('#otherCustUSerLoginIdChk').val('')
	}
	function loginInputVali(input){
		input.value = input.value.replace(/[^A-Za-z0-9]/g, '');
	}
	
	function companyVali(){
		
		
		if(!$('#otherCustSaveYn').val()){
			if(!$('#custType1').val()){
				Swal.fire('', '업체유형1을 선택해 주세요', 'warning')
				$('#btitle').val('')
				return
			}
		}

		if(!$('#otherCustName').val().trim()){
			Swal.fire('', '회사명 입력해 주세요', 'warning')
			$('#otherCustName').val('')
			return
		}
		
		if(!$('#otherCustPresName').val().trim()){
			Swal.fire('', '대표자명을 입력해 주세요', 'warning')
			$('#otherCustPresName').val('')
			return
		}
		const regnum1 = $('#otherCustRegnum1').val().trim();
		const regnum2 = $('#otherCustRegnum2').val().trim();
		const regnum3 = $('#otherCustRegnum3').val().trim();

		if (!regnum1 || !regnum2 || !regnum3) {
			Swal.fire('', '사업자 등록 번호를 입력해 주세요.', 'warning')
			return
		}
		
		const otherCustPresJuminNo1 = $('#otherCustPresJuminNo1').val().trim() 
		const otherCustPresJuminNo2 = $('#otherCustPresJuminNo2').val().trim() 
		 
		/*
		if(!otherCustPresJuminNo1 || !otherCustPresJuminNo2){
			Swal.fire('', '법인번호를 입력해 주세요', 'warning')
			return
		}
		*/
		
		if(!$('#otherCustCapital').val().trim()){
			Swal.fire('', '자본금을 입력해 주세요', 'warning')
			$('#otherCustCapital').val('')
			return
		}
		
		if(!$('#otherCustFoundYear').val().trim()){
			Swal.fire('', '설립년도를 입력해 주세요', 'warning')
			$('#otherCustFoundYear').val('')
			return
		}
		
		if(!$('#otherCustTel').val().trim()){
			Swal.fire('', '대표전화를 입력해 주세요', 'warning')
			$('#otherCustTel').val('')
			return
		}
		
		if(!$('#otherCustZipcode').val() || !$('#otherCustAddr').val() ||  !$('#otherCustAddrDetail').val().trim()){
			Swal.fire('', '주소를 입력해 주세요', 'warning')
			return
		}
		
		
		if(!$('#otherCustUserNm').val().trim()){
			Swal.fire('', '이름을 입력해 주세요', 'warning')
			$('#otherCustUserNm').val('')
			return
		}
		
		if(!$('#otherUserCustEmail').val().trim()){
			Swal.fire('', '이메일을 입력해 주세요', 'warning')
			$('#otherUserCustEmail').val('')
			return
		}
		
		const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-_]+\.[a-zA-Z]{2,}$/;
		if(!emailRegex.test($('#otherUserCustEmail').val())){
			Swal.fire('', '이메일을 형식에 맞게 입력해 주세요', 'warning')
		   return;
		}
		if(!$('#otherCustSaveYn').val()){
			if(!$('#otherCustUserId').val().trim()){
				Swal.fire('', '로그인 ID를 입력해 주세요.', 'warning')
				$('#otherCustUserId').val('')
				return
			}
			
			if(!$('#otherCustUSerLoginIdChk').val()){
				Swal.fire('', '로그인 ID를 중복 확인해 주세요.', 'warning')
				return
			}
			
			if(!$('#otherCustUserPwd').val()){
				Swal.fire('', '비밀번호를 입력해 주세요.', 'warning')
				return
			}
			
	        const pwdRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
	        if (!pwdRegex.test($('#otherCustUserPwd').val())) {
	            Swal.fire('', '비밀번호는 최소 8자 이상, 숫자와 특수문자를 포함해야 합니다..', 'warning');
	            return
	        }
			
			if(!$('#otherCustUserPwdChk').val()){
				Swal.fire('', '비밀번호 확인을 입력해 주세요.', 'warning')
				return
			}
			
			if ($('#otherCustUserPwd').val() !== $('#otherCustUserPwdChk').val()) {
			    Swal.fire('', '비밀번호가 일치하지 않습니다.', 'warning');
			    return;
			}
		}
		
		
		if(!$('#otherCustUserHp').val().trim()){
			Swal.fire('', '휴대폰 번호를 입력해 주세요', 'warning')
			$('#otherCustUserHp').val('')
			return
		}
		
		/*
		const phoneNumberRegex = /^\d{3}-\d{3,4}-\d{4}$/;
		if(!phoneNumberRegex.test($('#otherCustUserHp').val())){
			Swal.fire('', '휴대폰번호 형식에 맞게 입력해주세요.', 'warning')
		   	return;
		}
		*/
		
		if(!$('#otherCustUserTel').val().trim()){
			Swal.fire('', '유선전화를 입력해 주세요', 'warning')
			$('#otherCustUserTel').val('')
			return
		}
		
		/*
		const telNumberRegex = /^\d{2,3}-\d{3,4}-\d{4}$/;
		if(!telNumberRegex.test($('#otherCustUserTel').val())){
			Swal.fire('', '유선전화를 형식에 맞게 입력해주세요.', 'warning')
		   return;
		}
		*/
		
		$('#joinBtn3').modal('show')
	}
	
	
	
	function fnAddrPopOpen(){
		initModal();
	}
	
	function addrPopCallback(data){
		$("#otherCustZipcode").val(data.zipcode);
		$("#otherCustAddr").val(data.addr);
		$("#otherCustAddrDetail").val('');
	}
	
	function companyReq(){
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		
		 const formData = new FormData();

		 const params = {
		 	custType1 :  $("#custType1").val(),
		 	custTypeNm1 : $("#custTypeNm1").val(),
		 	custType2 :  $("#custType2").val(),
		 	custTypeNm2 : $("#custTypeNm2").val(),
		 	interrelatedNm : loginInfo.custName,
		 	interrelatedCustCode : loginInfo.custCode,
		 	custName : $("#otherCustName").val(),
		 	presName : $("#otherCustPresName").val(),
		 	regnum1 : $('#otherCustRegnum1').val(),
		 	regnum2 : $('#otherCustRegnum2').val(),
		 	regnum3 : $('#otherCustRegnum3').val(),
		 	presJuminNo1 : $('#otherCustPresJuminNo1').val(),
		 	presJuminNo2 : $('#otherCustPresJuminNo2').val(),
		 	capital : $('#otherCustCapital').val(),
		 	foundYear : $('#otherCustFoundYear').val(),
		 	tel : $('#otherCustTel').val(),
		 	fax : $('#otherCustFax').val(),
		 	zipcode : $('#otherCustZipcode').val(),
		 	addr : $('#otherCustAddr').val(),
		 	addrDetail : $('#otherCustAddrDetail').val(),
		 	userName :  $('#otherCustUserNm').val(),
		 	userEmail :  $('#otherUserCustEmail').val(),
		 	userId :  $('#otherCustUserId').val(),
		 	userPwd :  $('#otherCustUserPwd').val(),
		 	userHp :  $('#otherCustUserHp').val(),
		 	userTel :  $('#otherCustUserTel').val(),
		 	userPosition :  $('#otherCustUserPosition').val(),
		 	userBuseo :  $('#otherCustUserbuseo').val(),
		 	otherCustSaveYn : $('#otherCustSaveYn').val() ? 'Y' : 'N',
		 }
		 
		 if($('#otherCustSaveYn').val()){
			 
			 if( $('input[name="otherCustBm2"]:checked').val()){
				 params.custLevel = $('input[name="otherCustBm2"]:checked').val()
			 }
			   
			 if($('#otherCustCareContent').val().trim()){
				 params.custValuation = $('#otherCustCareContent').val().trim()
			 }
			 
			 if($('#otherCustValuation').val().trim()){
				 params.careContent = $('#otherCustValuation').val().trim() 
			 }
			 
			 if($('#regnumFilePath').val()){
				params.regnumPath = $('#regnumFilePath').val()
				params.regnumFile = $('#fileName1').text()
			 }
			 
			 if($('#bFilePath').val()){
				params.bFilePath = $('#bFilePath').val()
				params.bFile = $('#fileName2').text()	 
			 }
	
			 
		 }

		 formData.append('data', new Blob([JSON.stringify(params)], { type: 'application/json' }));
		 
	 	const fileInput = document.getElementById('file-input');
	    const fileInput2 = document.getElementById('file-input2');
	    if(fileInput){
			formData.append('regnumFile', fileInput.files[0]);
	    }
	    if(fileInput2){
			formData.append('bFile', fileInput2.files[0]);
	    }    
	    
	    $.ajax({
	        url: '/api/v1/cust/save',
	        type: 'POST',
	        data: formData,
	        contentType: false,  
	        processData: false, 
	        success: function(response) {
	            if (response.code === "OK") {
	                Swal.fire('', '업체 회원가입 신청이 완료되었습니다.', 'info').then((result) => {
	                    if (result.isConfirmed) {
	                        window.location.href = '/company/management';
	                    }
	                });
	            } else {
	                Swal.fire('', '업체 회원가입 신청을 실패하였습니다.', 'warning');
	            }
	        },
	        error: function(xhr, status, error) {
	            Swal.fire('', '업체 회원가입 신청을 실패하였습니다.', 'warning');
	            console.error('AJAX Error:', status, error);
	        }
	    });
				
	}
	
	function addComma(input){
        let value = $(input).val();

        value = value.replace(/[^0-9]/g, '');

        value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');

        $(input).val(value);
	}
	function fnFileInputChange(id){
		let file = event.target.files[0];
		
		$("#emptyFile" + id).css("display", "none");
		$("#preview" + id).css("display", "block");
		
		$("#fileName" + id).text(file.name);
		
	}
	
	function fnEmptyFile(id){
		$("#emptyFile" + id).css("display", "flex");
		$("#preview" + id).css("display", "none");
		
		if(id === 1){
			$("#file-input").val('');
			$("#regnumFilePath").val('');
			$("#fileName1").empty();
		}else{
			$("#file-input2").val('');
			$("#bFilePath").val('');
			$("#fileName2").empty();
		}
	}
	
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
		    <div class="conRight">
		        <div class="conHeader">
		            <ul class="conHeaderCate">
		                <li>업체정보</li>
		                <li>업체등록</li>
		            </ul>
		        </div>
				<input id="itemType" type="text" hidden="">
				<input id="otherCustSaveYn" type="text" hidden="">
		        <div class="contents">
		        	<div class="formWidth">
		        		<div class="conTopBox">
							<ul class="dList">
								<li><div>등록이 완료되면 업체 관리자에게 이메일로 등록 되었음을 알려드립니다.</div></li>
								<li><div>회원가입 <span class="star">*</span> 부분은 필수 입력 정보 입니다.</div></li>
							</ul>
							</div>
						<h3 class="h3Tit mt50">회사 정보</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
									<div class="flex formTit flex-shrink0 width170px">승인 계열사</div>
									<div class="flex width100">
										<div style="margin-top:15px" id="interrelatedNm"></div>
										<a onclick="otherCompanyPop()" class="btnStyle btnSecondary ml50" title="타계열사 업체">타계열사 업체</a>
										<!-- 툴팁 -->
										<i class="fas fa-question-circle toolTipSt toolTipMd ml5" style="margin-top:15px">
											<div class="toolTipText" style="width:320px">
												<ul class="dList">
													<li><div>등록하실 업체가 다른 계열사에 이미 등록되어 있다면 [타계열사 업체]를 조회하여 등록하십시오.</div></li>
												</ul>
											</div>
										</i>
										<!-- //툴팁 -->
									</div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">업체유형1<span class="star">*</span></div>
									<div id="type1Str" class="width100" style="display: none">
									</div>
									<div id="type1Input" class="flex align-items-center width100">
										<input type="text" id="custTypeNm1" class="inputStyle readonly" placeholder="우측 검색 버튼을 클릭해 주세요" >
										<input type="text" id="custType1" hidden="">
										<a onclick="openCustTypePop('type1')"  class="btnStyle btnSecondary ml10" title="조회">조회</a>
									</div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">업체유형2</div>
									<div id="type2Str" class="width100" style="display: none">
									</div>
									<div id="type2Input"  class="flex align-items-center width100">
										<input type="text" id="custTypeNm2" class="inputStyle readonly" placeholder="우측 검색 버튼을 클릭해 주세요" >
										<input type="text" id="custType2" hidden="">
										<a onclick="openCustTypePop('type2')" class="btnStyle btnSecondary ml10" title="조회">조회</a>
									</div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">회사명 <span class="star">*</span></div>
									<div class="width100"><input type="text" id="otherCustName" class="inputStyle maxWidth-max-content"></div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">대표자명 <span class="star">*</span></div>
									<div class="width100"><input type="text" id="otherCustPresName" class="inputStyle maxWidth-max-content"></div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">사업자등록번호 <span class="star">*</span></div>
									<div class="flex align-items-center width100">
										<input type="text"  id="otherCustRegnum1" class="inputStyle maxWidth-max-content" maxlength="3" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
										<span style="margin:0 10px">-</span>
										<input type="text" id="otherCustRegnum2" class="inputStyle maxWidth-max-content" maxlength="2" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
										<span style="margin:0 10px">-</span>
										<input type="text" id="otherCustRegnum3" class="inputStyle maxWidth-max-content" maxlength="5" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
									</div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">법인번호</div>
									<div class="flex align-items-center width100">
										<input type="text" id="otherCustPresJuminNo1" class="inputStyle maxWidth-max-content"  maxlength="6" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
										<span style="margin:0 10px">-</span>
										<input type="text" id="otherCustPresJuminNo2" class="inputStyle maxWidth-max-content"  maxlength="7" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
									</div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">자본금 <span class="star">*</span></div>
									<div class="flex align-items-center width100">
										<input type="text" id="otherCustCapital" class="inputStyle maxWidth-max-content" placeholder="ex) 10,000,000" oninput="addComma(this)" >
										<div class="ml10">원</div>
									</div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">설립년도 <span class="star">*</span></div>
									<div class="flex align-items-center width100">
										<input type="text" id="otherCustFoundYear" class="inputStyle maxWidth-max-content" placeholder="ex) 2021" maxlength="4" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
										<div class="ml10">년</div>
									</div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">대표전화 <span class="star">*</span></div>
									<div class="width100">
										<input type="text" id="otherCustTel" class="inputStyle maxWidth-max-content" maxlength="13" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
									</div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">팩스</div>
									<div class="width100">
										<input type="text" id="otherCustFax" class="inputStyle maxWidth-max-content" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
									</div>
								</div>
								<div class="flex mt10">
									<div class="formTit flex-shrink0 width170px">회사주소 <span class="star">*</span></div>
									<div class="width100">
										<div class="flex align-items-center width100">
											<input type="text" id="otherCustZipcode" class="inputStyle maxWidth-max-content readonly" placeholder="주소 조회 클릭" readonly>
											<a onclick="fnAddrPopOpen()"  class="btnStyle btnSecondary flex-shrink0 ml10" title="주소 조회">주소 조회</a>
										</div>
										<div class="mt5"><input type="text" id="otherCustAddr" class="inputStyle readonly"  readonly></div>
										<div class="mt5"><input type="text" id="otherCustAddrDetail" class="inputStyle" placeholder="상세 주소 입력"></div>
									</div>
								</div>
								<div class="flex mt10">
									<div class="formTit flex-shrink0 width170px">사업자등록증</div>
									<div class="width100">
										<!-- 다중파일 업로드 -->
										<div class="upload-boxWrap">
											<div class="upload-box" id="emptyFile1">
												<input type="file" id="file-input"  onchange="fnFileInputChange(1)">
												<div class="uploadTxt">
													<i class="fa-regular fa-upload"></i>
													<div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제)<br>파일 최대 10MB (등록 파일 개수 최대 1개)</div>
												</div>
											</div>
											<div class="uploadPreview" id="preview1" style="display:none;">
												<p style="line-height:80px;"><span id="fileName1">
													</span><button id="removeBtn" class="file-remove" onClick="fnEmptyFile(1)">삭제</button>
												</p>
											</div>
										</div>
										<input id="regnumFilePath" type="text" hidden="">
										<!-- //다중파일 업로드 -->
									</div>
								</div>
								<div class="flex mt10">
									<div class="formTit flex-shrink0 width170px">회사소개 및 기타자료
										<!-- 툴팁 -->
										<i class="fas fa-question-circle toolTipSt ml5">
											<div class="toolTipText" style="width:420px">
												<ul class="dList">
													<li><div>첨부파일은 간단한 업체 소개 자료 등의 파일을 첨부해 주십시오.</div></li>
													<li><div>1개  이상의 파일을 첨부하실 경우 Zip으로 압축하여 첨부해 주십시오</div></li>
													<li><div>파일은 10M 이상을 초과할 수 없습니다.</div></li>
												</ul>
											</div>
										</i>
										<!-- //툴팁 -->
									</div>
									<div class="width100">
										<!-- 다중파일 업로드 -->
										<div class="upload-boxWrap">
											<div class="upload-box"  id="emptyFile2">
												<input type="file" id="file-input2" onchange="fnFileInputChange(2)">
												<div class="uploadTxt">
													<i class="fa-regular fa-upload"></i>
													<div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제)<br>파일 최대 10MB (등록 파일 개수 최대 1개)</div>
												</div>
											</div>
											<div class="uploadPreview" id="preview2" style="display:none;">
												<p style="line-height:80px;"><span id="fileName2"></span>
													<button id="removeBtn" class="file-remove" onClick="fnEmptyFile(2)">삭제</button>
												</p>
											</div>
											<input id="bFilePath" type="text" hidden="">
										</div>
										<!-- //다중파일 업로드 -->
									</div>
								</div>
							</div>
							
						<div id="manageItem" style="display: none">	
							<h3  class="h3Tit mt50">계열사 관리항목</h3>
								<div class="boxSt mt20">
									<div class="flex align-items-center">
										<div class="formTit flex-shrink0 width170px">업체등급</div>
										<div class="width100">
											<input type="radio" name="otherCustBm2" value="A" id="otherCustBm2_1" class="radioStyle"><label for="otherCustBm2_1">A등급</label>
											<input type="radio" name="otherCustBm2" value="B" id="otherCustBm2_2" class="radioStyle"><label for="otherCustBm2_2">B등급</label>
											<input type="radio" name="otherCustBm2" value="C" id="otherCustBm2_3" class="radioStyle"><label for="otherCustBm2_3">C등급</label>
											<input type="radio" name="otherCustBm2" value="D" id="otherCustBm2_4" class="radioStyle"><label for="otherCustBm2_4">D등급</label>
										</div>
									</div>
									<div class="flex align-items-center mt20">
										<div class="formTit flex-shrink0 width170px">D업체평가</div>
										<div class="width100">
											<textarea id="otherCustCareContent" class="textareaStyle boxOverflowY" ></textarea>
										</div>
									</div>
									<div class="flex align-items-center mt20">
										<div class="formTit flex-shrink0 width170px">관리단위</div>
										<div class="width100"><input type="text" id="otherCustValuation" class="inputStyle" ></div>
									</div>
								</div>
							</div>

							<h3 class="h3Tit mt50">관리자 정보</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="formTit flex-shrink0 width170px">이름 <span class="star">*</span></div>
									<div class="width100">
										<input type="text" id="otherCustUserNm" class="inputStyle maxWidth-max-content" >
									</div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">이메일 <span class="star">*</span></div>
									<div class="width100">
										<input type="text" id="otherUserCustEmail" class="inputStyle maxWidth-max-content" placeholder="ex) sample@iljin.co.kr">
									</div>
								</div>

									<div class="flex align-items-center mt10">
										<div class="formTit flex-shrink0 width170px">아이디 <span class="star">*</span></div>
										<div id="custUserInput" class="flex align-items-center width100">
											<input type="text"  maxlength="8" onchange="onLoginIdChkInit()" id="otherCustUserId" class="inputStyle maxWidth-max-content" placeholder="영문, 숫자 입력(8자 이내) 후 중복확인" oninput="loginInputVali(this)" >
											<a onclick="onLoginIdChk()" class="btnStyle btnSecondary flex-shrink0 ml10" title="중복 확인">중복 확인</a>
											<input type="text" id="otherCustUSerLoginIdChk"  hidden="">
										</div>
										<div id="otherCustIdStr" class="flex align-items-center width100" style="display: none">
										</div>
									</div>
									<div id="otherCustUserPwdInPut">
										<div class="flex align-items-center mt10">
											<div class="formTit flex-shrink0 width170px">비밀번호 <span class="star">*</span></div>
											<div class="width100">
												<input type="password" id="otherCustUserPwd" class="inputStyle maxWidth-max-content" placeholder="대/소문자, 숫자, 특수문자 2 이상 조합(길이 8~16자리)">
											</div>
										</div>
										<div class="flex align-items-center mt10">
											<div class="formTit flex-shrink0 width170px">비밀번호 확인 <span class="star">*</span></div>
											<div class="width100">
												<input type="password" id="otherCustUserPwdChk" class="inputStyle maxWidth-max-content" placeholder="비밀번호와 동일해야 합니다.">
											</div>
										</div>
									</div>
								<div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">휴대폰 <span class="star">*</span></div>
									<div class="width100">
										<input type="text" id="otherCustUserHp" class="inputStyle maxWidth-max-content" maxlength="13" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
									</div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">유선전화 <span class="star">*</span></div>
									<div class="width100">
										<input type="text" id="otherCustUserTel" class="inputStyle maxWidth-max-content" maxlength="13" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
									</div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">직급</div>
									<div class="width100">
										<input type="text" id="otherCustUserPosition" class="inputStyle maxWidth-max-content" >
									</div>
								</div>
								<div class="flex align-items-center mt10">
									<div class="formTit flex-shrink0 width170px">부서</div>
									<div class="width100">
										<input type="text" id="otherCustUserbuseo" class="inputStyle maxWidth-max-content" >
									</div>
								</div>
							</div>

							<div class="text-center mt50">
								<a href="/company/management" class="btnStyle btnOutline" title="취소">취소</a>
								<a onclick="companyVali()" class="btnStyle btnPrimary" title="회원가입 신청">회원가입 신청</a>
							</div>
					</div>
		        </div>

		    </div>
		    </div>
    	</div>
    	
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
		
		
	<!-- 타계열사 업체조회 -->
	<div class="modal fade modalStyle" id="otherCompany" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:900px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle">타계열사 업체조회</h2>
					<div class="modalTopBox">
						<ul>
							<li><div>계열사에 등록되어 있는 업체리스트를 조회합니다</div></li>
						</ul>
					</div>
					
					<div class="modalSearchBox mt20">
						<div class="flex align-items-center">
							<div class="sbTit mr30">업체유형</div>
								<div class="width150px">
									<input type="text" id="srcOtherCustTypeNm" class="inputStyle readonly" readonly="readonly">
									<input type="text" id="srcOtherCustTypeCode" class="inputStyle" hidden="">
								</div>
							<a onclick="openCustTypePop('type3')" class="btnStyle btnSecondary ml10">조회</a>
							<button onclick="otherCustItemRemove()" id="otherCustRemoveBtn" type="button" title="삭제" class="btnStyle btnOutline" style="display: none">삭제</button>
							<div class="sbTit mr30 ml50">업체명</div>
							<div class="width150px">
								<input type="text" id="srcOtherCustName" class="inputStyle">
							</div>
							<a onclick="onSearch(0)" class="btnStyle btnSearch" >검색</a>
						</div>
					</div>
					<table class="tblSkin1 mt30">
						<colgroup>
							<col style="">
						</colgroup>
						<thead>
							<tr>
								<th>업체명</th>
								<th>업체유형</th>
								<th>사업자번호</th>
								<th>대표이사</th>
								<th>등록 계열사</th>
								<th class="end">선택</th>
							</tr>
						</thead>
						<tbody id="otherCustListBody">


						</tbody>
					</table>
					<!-- pagination -->
					<div class="row mt30">
						<div class="col-xs-12">
							<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
						</div>
					</div>
					<!-- //pagination -->
					<div class="modalFooter" style="margin-bottom: 20px;">
						<a class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- //타계열사 업체조회 -->
	
		<!-- 회원가입 신청 -->
	<div class="modal fade modalStyle" id="joinBtn3" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:420px">
			<div class="modal-content">
				<div class="modal-body">
					<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<div class="alertText2">입력하신 정보로 회원가입이 완료됩니다.<br><br>회원가입 하시겠습니까?</div>
					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
						<a onclick="companyReq()" class="modalBtnCheck" title="신청">신청</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- //회원가입 신청 -->
	
		<!-- 업체유형 팝업 -->
	<jsp:include page="/WEB-INF/jsp/join/custTypePop.jsp" />
	
	<!-- 주소 팝업 -->
	<jsp:include page="/WEB-INF/jsp/join/addrPop.jsp" />
</body>
</html>
