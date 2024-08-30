<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		onCustDetail();	
	});

	
	function onCustDetail(){
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
			
		if(loginInfo.userAuth === '2' || loginInfo.userAuth === '4'){
			$("#deleteBtn").css("display", "")
			$("#editMoveBtn").css("display", "")
		
		}
		
		const params = {
			custCode : new URLSearchParams(window.location.search).get('custCode'),
			interrelatedCustCode : loginInfo.custCode
		}
		
		$.post("/api/v1/cust/CustDetail", params, 
			function(response) {
			const data = response.data[0]
				if(response.code === 'OK') {
					//상세 값
					$("#interrelatedNm").append(data.interrelatedNm)
					$("#custTypeNm1").append(data.custTypeNm1)
					$("#custTypeNm2").append(data.custTypeNm2)
					$("#custName").append(data.custName)
					$("#presName").append(data.presName)
					$("#regnum").append(data.regnum)
					$("#presJuminNo").append(data.presJuminNo)
					$("#capital").append(Number(data.capital).toLocaleString())
					$("#foundYear").append(data.foundYear)
					$("#tel").append(data.tel)
					$("#fax").append(data.fax)
					$("#zipcode").append(data.zipcode)
					$("#addr").append(data.addr)
					$("#addrDetail").append(data.addrDetail)
					$("#regnum").append(data.regnum)
					$("#regnumFile").append(data.regnumFileName)
					$("#regnumPath").val(data.regnumPath)
					$("#bfile").append(data.bFileName)
					$("#bFilePath").val(data.bFilePath)
					$("#certYn").append(data.certYn === 'Y' ? '정상' : '삭제')
					$('input[name="otherCustBm2"][value="' + data.custLevel + '"]').prop('checked', true);
					$("#detailLevelVal").val(data.custLevel ? data.custLevel  : '')
					$("#otherCustCareContent").val(data.careContent ? data.careContent : '')
					$("#otherCustCareContentStr").append(data.careContent ? data.careContent : '')
					$("#otherCustValuation").val(data.careContent ? data.custValuation : '')
					$("#otherCustValuationtStr").append(data.careContent ? data.custValuation : '')
					$("#userName1").append(data.userName)
					$("#userEmail").append(data.userEmail)
					$("#userId").append(data.userId)
					$("#userHp").append(data.userHp)
					$("#userTel").append(data.userTel)
					$("#userPosition").append(data.userPosition)
					$("#userBuseo").append(data.userBuseo)
					
					//수정할 input들 값
		            $('#otherCustName').val(data.custName)
		            $('#otherCustPresName').val(data.presName)
		            $('#otherCustCapital').val(Number(data.capital).toLocaleString())
		            $('#otherCustFoundYear').val(data.foundYear)
		            $('#otherCustTel').val(data.tel)
		            $('#otherCustFax').val(data.fax)
		            $('#otherCustZipcode').val(data.zipcode)
		            $('#otherCustAddr').val(data.addr)
		            $('#otherCustAddrDetail').val(data.addrDetail)
		            $('#otherCustUserNm').val(data.userName)
		            $('#otherUserCustEmail').val(data.userEmail)
		            $('#otherCustUserHp').val(data.userHp)
		            $('#otherCustUserTel').val(data.userTel)
		            $('#otherCustUserPosition').val(data.userPosition ? data.userPosition :'')
		            $('#otherCustUserbuseo').val(data.userBuseo ? data.userBuseo : '')
					
					// 재 조회를 하지 않기 위해 rugnum,presJuminNo 분리해서 넣기
		            const regnum = divideString(data.regnum, [3,2,5])
		            const presJuminNo = divideString(data.presJuminNo, [6,7])
		            
		            $('#otherCustRegnum1').val(regnum[0])
		            $('#otherCustRegnum2').val(regnum[1])
		            $('#otherCustRegnum3').val(regnum[2])
		            
		            $('#otherCustPresJuminNo1').val(presJuminNo[0])
		            $('#otherCustPresJuminNo2').val(presJuminNo[1])
		            
	
			} else {
				Swal.fire('', response.msg, 'warning')
			}
		},
		"json"
		);
	}
	
	function divideString(str, lengths) {
        let result = [];
        let start = 0;
        for (let length of lengths) {
            result.push(str.substr(start, length));
            start += length;
        }
        return result;
    }

	function deletePop(){
		$('#delEtc').val('')
		$('#companyDel').modal('show')
		
	}
	
	function editMove(){
		$('#companyAccept').modal('show')
	}
	
	function del(){
		if(!$('#delEtc').val().trim()){
			Swal.fire('', '삭제 사유를 입력해 주세요.', 'warning')
			$('#delEtc').val('')
			return
		}
		
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		const params = {
			custCode : new URLSearchParams(window.location.search).get('custCode'),
			etc : $('#delEtc').val().trim(),
			userId : loginInfo.userId,
			updUserId : loginInfo.userId
		}

		$.post(
			'/api/v1/cust/del',
			params
			)
			.done(function(arg) {
				if (arg.code === "OK") {
					$('#companyDel').modal('hide')
					Swal.fire('', '정상적으로 업체 삭제 처리되었습니다.', 'info').then((result) => {
					    if (result.isConfirmed) {
					        window.location.href = '/company/management';
					    }
					});

				}
				else{
		            Swal.fire('', '업체 삭제 처리를 실패하였습니다.', 'warning');
		            return
				}
			})
			
	}	
	
	function onApproval(){
				
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		const params = {
			custCode : new URLSearchParams(window.location.search).get('custCode'),
			userId : loginInfo.userId,
			custName : $('#custName').text(),
			userHp : $('#userHp').text(),
			interrelatedNm : $('#interrelatedNm').text(),
			userName : $('#userName1').text(),
			userEmail : $('#userEmail').text()
		}

		$.post(
			'/api/v1/cust/approval',
			params
			)
			.done(function(arg) {
				if (arg.code === "OK") {
					$('#companyAccept').modal('hide')
					$("#certYn").empty()
					onCustDetail()
					Swal.fire('', '정상적으로 승인 처리되었습니다.', 'info').then((result) => {
					    if (result.isConfirmed) {
					        window.location.href = '/company/approval';
					    }
					});
				}
				else{
		            Swal.fire('', '승인 처리를 실패하였습니다.', 'warning');
		            return
				}
			})
			
			
	}
	
	function downloadFile(fileType){
		
		
		const filePath = fileType === 'regnum' ? $("#regnumPath").val() : $("#bFilePath").val()
		const fileName = fileType === 'regnum' ? $("#regnumFile").text() :$("#bfile").text()

		const params = {
				fileId : filePath,
				responseType: "blob"
		}
		$.post(
				'/api/v1/notice/downloadFile',
				params
				)
				.done(function(arg) {
					console.log(arg)
					if (arg.code === "OK") {
						const url = window.URL.createObjectURL(new Blob([arg.data]));
						const link = document.createElement("a");
						link.href = url;
						link.setAttribute("download", fileName);
						document.body.appendChild(link);
						link.click();
						document.body.removeChild(link);
					}
					else{
			            Swal.fire('', '파일 다운로드를 실패하였습니다.', 'warning');
			            return
					}
				})
	}
	
	function addComma(input){
        let value = $(input).val();

        value = value.replace(/[^0-9]/g, '');

        value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');

        $(input).val(value);
	}

	function fnAddrPopOpen(){
		initModal();
	}
	
	function addrPopCallback(data){
		$("#otherCustZipcode").val(data.zipcode);
		$("#otherCustAddr").val(data.addr);
		$("#otherCustAddrDetail").val('');
	}
	
	function moveDetail(){
		const levelVal = $("#detailLevelVal").val()

		if(levelVal){
			$('input[name="otherCustBm2"][value="' +levelVal + '"]').prop('checked', true);
		}else{
			 $('input[name="otherCustBm2"]').prop('checked', false);
		}

		$('#custName, #presName, #regnum, #presJuminNo, #capital, #foundYear, #tel, #fax, #addrStr, #regnumView, #bFileView, #otherCustCareContentStr, #otherCustValuationtStr, #userName1, #userEmail, #userHp, #userTel, #userPosition, #userBuseo').css('display', '');
		
		$('#otherCustName, #otherCustPresName, #regnumEdit, #otherCustPresJuminNo, #otherCustCapital, #otherCustFoundYearDiv, #otherCustTel, #otherCustFax, #addrEdit, #otherCustCareContent, #otherCustValuation, #otherCustUserNm, #otherUserCustEmail, #otherCustUserHp, #otherCustUserTel, #otherCustUserPosition, #otherCustUserbuseo').css('display', 'none');
		$('input[name="otherCustBm2"]').prop('disabled', true);
		
		$("#regnumView").css('display', '');
		$("#bFileView").css('display', '');
		
		$("#regnumFileVBoxiew").css('display', 'none');
		$("#bFileBoxView").css('display', 'none');
		 
		
		$("#moveManagementList").css('display', '');
		$("#deleteBtn").css('display', '');
		$("#editMoveBtn").css('display', '');
		$("#cancelEdit").css('display', 'none');
		$("#editBtn").css('display', 'none');
		
	}
	
	function editMove(){

		$('#custName, #presName, #regnum, #presJuminNo, #capital, #foundYear, #tel, #fax, #addrStr, #regnumView, #bFileView, #otherCustCareContentStr, #otherCustValuationtStr, #userName1, #userEmail, #userHp, #userTel, #userPosition, #userBuseo').css('display', 'none');
		
		$('#otherCustName, #otherCustPresName, #regnumEdit, #otherCustPresJuminNo, #otherCustCapital, #otherCustFoundYearDiv, #otherCustTel, #otherCustFax, #addrEdit, #otherCustCareContent, #otherCustValuation, #otherCustUserNm, #otherUserCustEmail, #otherCustUserHp, #otherCustUserTel, #otherCustUserPosition, #otherCustUserbuseo').css('display', '');
		$('input[name="otherCustBm2"]').prop('disabled', false);

		$("#regnumView").css('display', 'none');
		$("#bFileView").css('display', 'none');
		
		$("#regnumFileVBoxiew").css('display', '');
		$("#bFileBoxView").css('display', '');
		
		$("#moveManagementList").css('display', 'none');
		$("#deleteBtn").css('display', 'none');
		$("#editMoveBtn").css('display', 'none');
		$("#cancelEdit").css('display', '');
		$("#editBtn").css('display', '');
		
		if($("#regnumFile").text().trim()){
			$("#emptyFile1").css("display", "none");
			$("#preview1").css("display", "block");
			$("#fileName1").text($("#regnumFile").text());
		}
		if($("#bfile").text().trim()){
			$("#emptyFile2").css("display", "none");
			$("#preview2").css("display", "block");
			$("#fileName2").text($("#bfile").text());
		}
		

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
			$("#regnumDelYn").val('Y');
		}else{
			$("#file-input2").val('');
			$("#bFileDelYn").val('Y');
		}
	}
	
	function companyEditVali(){
		
			
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
		 
		if(!otherCustPresJuminNo1 || !otherCustPresJuminNo2){
			Swal.fire('', '법인번호를 입력해 주세요', 'warning')
			return
		}
		
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
		
		$('#companyEditPop').modal('show')
	}
	
	function companyEdit(){
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		
		 const formData = new FormData();

		 const params = {
			custCode : new URLSearchParams(window.location.search).get('custCode'),
		 	interrelatedNm : loginInfo.custName,
		 	interrelatedCustCode : loginInfo.custCode,
		 	custType : loginInfo.custType,
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
		 	custLevel :   $('input[name="otherCustBm2"]:checked').val() || '',
		 	careContent :  $('#otherCustCareContent').val(),
		 	custValuation :  $('#otherCustValuation').val(),
		 	userName :  $('#otherCustUserNm').val(),
		 	userEmail :  $('#otherUserCustEmail').val(),
		 	userId :  $("#userId").text(),
		 	userPwd :  $('#otherCustUserPwd').val(),
		 	userHp :  $('#otherCustUserHp').val(),
		 	userTel :  $('#otherCustUserTel').val(),
		 	userPosition :  $('#otherCustUserPosition').val(),
		 	userBuseo :  $('#otherCustUserbuseo').val(),
		 	updUserId : loginInfo.userId
		 }
		 		 		
	 	const fileInput = document.getElementById('file-input');
	    const fileInput2 = document.getElementById('file-input2');	 
		 
	    if(fileInput){
			formData.append('regnumFile', fileInput.files[0]);
	    }else if(!$("#regnumDelYn").val()){
			 params.regnumPath = $("#regnumPath").val()
			 params.regnumFile = $("#regnumFile").text()
	    }
	    
	    if(fileInput2){
			formData.append('bFile', fileInput2.files[0]);
	    } else if(!$("#bFileDelYn").val()){
			 params.bFilePath = $("#bFilePath").val()
			 params.bFile = $("#bfile").text()
	    }   
	    
		 formData.append('data',JSON.stringify(params))
	    
	    $.ajax({
	        url: '/api/v1/cust/save',
	        type: 'POST',
	        data: formData,
	        contentType: false,  
	        processData: false, 
	        success: function(response) {
	            if (response.code === "OK") {
	                Swal.fire('', '업체 수정이 완료되었습니다.', 'info').then((result) => {
	                    if (result.isConfirmed) {
	                        window.location.href = '/company/management';
	                    }
	                });
	            } else {
	                Swal.fire('', '업체 수정을 실패하였습니다.', 'warning');
	            }
	        },
	        error: function(xhr, status, error) {
	            Swal.fire('', '업체 수정을 실패하였습니다.', 'warning');
	            console.error('AJAX Error:', status, error);
	        }
	    });
				
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
		                <li>업체상세</li>
		            </ul>
		        </div>
		
		        <div class="contents">
		        	<div class="formWidth">
						<h3 class="h3Tit">회사 정보</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">가입희망 계열사</div>
								<div id="interrelatedNm" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">업체유형 1</div>
								<div id="custTypeNm1" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">업체유형 2</div>
								<div id="custTypeNm2" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">회사명</div>
								<div id="custName" class="width100"></div>
								<input type="text" id="otherCustName" class="inputStyle maxWidth-max-content" style="display: none">
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">대표자명</div>
								<div id="presName" class="width100"></div>
								<input type="text" id="otherCustPresName" class="inputStyle maxWidth-max-content" style="display: none">
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">사업자등록번호</div>
								<div id="regnum" class="width100"></div>
								<div id="regnumEdit" style="display: none">
									<input type="text"  id="otherCustRegnum1" class="inputStyle maxWidth-max-content" maxlength="3" >
									<span style="margin:0 10px">-</span>
									<input type="text" id="otherCustRegnum2" class="inputStyle maxWidth-max-content" maxlength="2">
									<span style="margin:0 10px">-</span>
									<input type="text" id="otherCustRegnum3" class="inputStyle maxWidth-max-content" maxlength="5">
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">법인번호</div>
								<div id="presJuminNo" class="width100"></div>
								<div id="otherCustPresJuminNo" style="display: none">
									<input type="text" id="otherCustPresJuminNo1" class="inputStyle maxWidth-max-content"  maxlength="6">
									<span style="margin:0 10px">-</span>
									<input type="text" id="otherCustPresJuminNo2" class="inputStyle maxWidth-max-content"  maxlength="7">								
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">자본금</div>
								<div id="capital" class="width100"></div>
								<div class="flex align-items-center width100">
									<input type="text" id="otherCustCapital" style="display: none" class="inputStyle maxWidth-max-content" placeholder="ex) 10,000,000" oninput="addComma(this)" >
									<div class="ml10">원</div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">설립년도</div>
								<div id="foundYear" class="width100"></div>
								<div id="otherCustFoundYearDiv" style="display: none">
									<div class="flex align-items-center width100">
										<input type="text" id="otherCustFoundYear" class="inputStyle maxWidth-max-content" placeholder="ex) 2021" maxlength="4">
										<div class="ml10">년</div>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">대표전화</div>
								<div id="tel" class="width100"></div>
								<input type="text" id="otherCustTel" class="inputStyle maxWidth-max-content" maxlength="13"  style="display: none">
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">팩스</div>
								<div id="fax" class="width100"></div>
								<input type="text" id="otherCustFax" class="inputStyle maxWidth-max-content" style="display: none">
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">회사주소</div>
								<div class="width100">
									<div id="addrStr">
			 							<p id="zipcode"></p>
										<p id="addr"></p>
										<p id="addrDetail"></p>
									</div>
									<div id="addrEdit" style="display: none">
										<div class="flex align-items-center width100">
											<input type="text" id="otherCustZipcode" class="inputStyle maxWidth-max-content readonly" placeholder="주소 조회 클릭" readonly>
											<a onclick="fnAddrPopOpen()"  class="btnStyle btnSecondary flex-shrink0 ml10" title="주소 조회">주소 조회</a>
										</div>
										<div class="mt5"><input type="text" id="otherCustAddr" class="inputStyle readonly"  readonly></div>
										<div class="mt5"><input type="text" id="otherCustAddrDetail" class="inputStyle" placeholder="상세 주소 입력"></div>
									</div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">사업자등록증</div>
								<div class="width100">
								
									<div id="regnumView">
										<a onclick="downloadFile('regnum')" id="regnumFile" class="textUnderline"></a>
										<input id="regnumPath" type="text" hidden="">
									</div>
									

									<div id="regnumFileVBoxiew" class="upload-boxWrap" style="display: none">
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
											<input id="regnumDelYn" type="text" hidden="">
										</p>
									</div>
								</div>								

								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">회사소개 및 기타자료</div>
								<div class="width100">
									<div id="bFileView">
										<a id="bfile" onclick="downloadFile('bfile')" class="textUnderline"></a>
										<input id="bFilePath" type="text" hidden="">
									</div>
									
									
									
									<div id="bFileBoxView" class="upload-boxWrap" style="display: none">
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
												<input id="bFileDelYn" type="text" hidden="">
											</p>
										</div>
									</div>									
									
									
								</div>
							</div>
							
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">상태</div>
								<div class="width100" id="certYn"></div>
							</div>
						</div>


						<h3 class="h3Tit mt50">계열사 관리항목</h3>
						
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">업체등급</div>
								<div class="width100">
									<input type="radio" name="otherCustBm2" value="A" id="otherCustBm2_1" class="radioStyle" disabled="disabled"><label for="otherCustBm2_1">A등급</label>
									<input type="radio" name="otherCustBm2" value="B" id="otherCustBm2_2" class="radioStyle" disabled="disabled"><label for="otherCustBm2_2">B등급</label>
									<input type="radio" name="otherCustBm2" value="C" id="otherCustBm2_3" class="radioStyle" disabled="disabled"><label for="otherCustBm2_3">C등급</label>
									<input type="radio" name="otherCustBm2" value="D" id="otherCustBm2_4" class="radioStyle" disabled="disabled"><label for="otherCustBm2_4">D등급</label>
									<input id="detailLevelVal" type="text" hidden="">
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">D업체평가</div>
								<div class="width100">
									<div id="otherCustCareContentStr"></div>
									<textarea id="otherCustCareContent" class="textareaStyle boxOverflowY" style="display: none"></textarea>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">관리단위</div>
								<div class="width100">
									<div id="otherCustValuationtStr"></div>
									<input type="text" id="otherCustValuation" class="inputStyle" style="display: none">
								</div>
							</div>
						</div>
						
						<h3 class="h3Tit mt50">관리자 정보</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">이름</div>
								<div id="userName1" class="width100"></div>
								<input type="text" id="otherCustUserNm" class="inputStyle maxWidth-max-content" style="display: none">
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">이메일</div>
								<div id="userEmail" class="width100"></div>
								<input type="text" id="otherUserCustEmail" class="inputStyle maxWidth-max-content" placeholder="ex) sample@iljin.co.kr" style="display: none">
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">아이디</div>
								<div id="userId" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">휴대폰</div>
								<div id="userHp" class="width100"></div>
								<input type="text" id="otherCustUserHp" class="inputStyle maxWidth-max-content" maxlength="13" style="display: none">
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">유선전화</div>
								<div id="userTel" class="width100"></div>
								<input type="text" id="otherCustUserTel" class="inputStyle maxWidth-max-content" maxlength="13" style="display: none">
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">직급</div>
								<div id="userPosition" class="width100"></div>
								<input type="text" id="otherCustUserPosition" class="inputStyle maxWidth-max-content" style="display: none">
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">부서</div>
								<div id="userBuseo" class="width100"></div>
								<input type="text" id="otherCustUserbuseo" class="inputStyle maxWidth-max-content" style="display: none">
							</div>
						</div>

						<div class="text-center mt50"> 
							<a id="moveManagementList" href="/company/management" class="btnStyle btnOutlineRed" title="취소">취소</a>
							<a id="cancelEdit" onclick="moveDetail()" class="btnStyle btnOutlineRed" title="취소" style="display: none">취소</a>
							<a id="deleteBtn" onclick="deletePop()" class="btnStyle btnRed" style="display:none" title="반려">삭제</a>						
							<a id="editMoveBtn" onclick="editMove()" class="btnStyle btnPrimary" style="display:none" title="승인">수정 이동</a>
							<a id="editBtn" onclick="companyEditVali()" class="btnStyle btnPrimary" style="display:none" title="승인">수정</a>  
						</div>
					</div>
		        </div>

		    </div>
    	</div>
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
		

		<!-- 삭제 -->
		<div class="modal fade modalStyle" id="companyDel" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:550px">
				<div class="modal-content">
					<div class="modal-body">
						<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<h2 class="modalTitle">업체 삭제</h2>
						<div class="modalTopBox">
							<ul>
								<li>
									<div>
										삭제사유를 작성되어야 삭제할 수 있습니다.<br>
										삭제 후 다시 정상으로 되돌릴 수 없습니다.<br>
										삭제 하시겠습니까?
									</div>
								</li>
							</ul>
						</div>
						<textarea id="delEtc" class="textareaStyle height150px mt20" placeholder="삭제 사유 필수 입력"></textarea>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
							<a onclick="del()" class="modalBtnCheck" title="반려">삭제</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //삭제 -->
	
		<!-- 수정 저장 -->

		<div class="modal fade modalStyle" id="companyEditPop" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:420px">
				<div class="modal-content">
					<div class="modal-body">
						<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<div class="alertText2">수정하신 정보로 저장됩니다.<br>저장 시 수정이력도 저장됩니다.<br><br>저장 하시겠습니까?</div>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
							<a  onclick="companyEdit()" class="modalBtnCheck" title="저장">저장</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
	
		<!-- //수정 저장-->
		
	<!-- 주소 팝업 -->
	<jsp:include page="/WEB-INF/jsp/join/addrPop.jsp" />
</body>
</html>
