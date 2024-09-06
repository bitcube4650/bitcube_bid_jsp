<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		onCustDetail();
	    $('#custInfoPwd').keypress(function(event) {
	        if (event.which === 13) {
	            event.preventDefault();
	            custInfoPwdChk();
	        }
	    });
		
	});
	
	function onCustDetail(){
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
				
		const params = {
			custCode : loginInfo.custCode
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
					$("#regnum").append(Ft.onAddDashRegNum(data.regnum))
					$("#presJuminNo").append(Ft.onAddDashRPresJuminNum(data.presJuminNo))
					$("#capital").append(data.capital.toLocaleString())
					$("#foundYear").append(data.foundYear)
					$("#tel").append(Ft.onAddDashTel(data.tel))
					$("#fax").append(Ft.onAddDashTel(data.fax))
					$("#zipcode").append(data.zipcode)
					$("#addr").append(data.addr)
					$("#addrDetail").append(data.addrDetail)
					$("#regnumFile").append(data.regnumFileName)
					$("#regnumPath").val(data.regnumPath)
					$("#bfile").append(data.bFileName)
					$("#bFilePath").val(data.bFilePath)
					$("#certYn").append(data.certYn === 'Y' ? '정상' : '삭제')
					$("#userName1").append(data.userName)
					$("#userEmail").append(data.userEmail)
					$("#userId").append(data.userId)
					$("#userHp").append(Ft.onAddDashTel(data.userHp))
					$("#userTel").append(Ft.onAddDashTel(data.userTel))
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
					 let regnum =  ''
					 let presJuminNo = ''
					if(data.regnum){
						regnum = divideString(data.regnum, [3,2,5])
						$('#otherCustRegnum1').val(regnum[0])
			            $('#otherCustRegnum2').val(regnum[1])
			            $('#otherCustRegnum3').val(regnum[2])
					}
					if(data.presJuminNo){
						presJuminNo = divideString(data.presJuminNo, [6,7])
						$('#otherCustPresJuminNo1').val(presJuminNo[0])
		            	$('#otherCustPresJuminNo2').val(presJuminNo[1])
					}
					
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
		
	function downloadFile(fileType){
		
		
		const filePath = fileType === 'regnum' ? $("#regnumPath").val() : $("#bFilePath").val()
		const fileName = fileType === 'regnum' ? $("#regnumFile").text() :$("#bfile").text()

		let params = {
			fileId : filePath
		}
		
		$.ajax({
			url: '/api/v1/notice/downloadFile',
			data: params,
			type: 'POST',
			xhrFields: {
				responseType: "blob",
			},
			error: function(jqXHR, textStatus, errorThrown) {
				Swal.fire('', '파일 다운로드를 실패했습니다.', 'error');
			},
			success: function(data, status, xhr) {
				var blob = new Blob([data], { type: xhr.getResponseHeader('Content-Type') });

				// 링크 생성
				var link = document.createElement('a');
				link.href = window.URL.createObjectURL(blob);
				link.download = fileName;

				// 링크를 클릭하여 다운로드를 실행
				document.body.appendChild(link);
				link.click();

				// 링크 제거
				document.body.removeChild(link);
			}
		});
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

		$('#custName, #presName, #regnum, #presJuminNo, #capital, #foundYear, #tel, #fax, #addrStr, #regnumView, #bFileView').css('display', '');
		
		$('#otherCustName, #otherCustPresName, #regnumEdit, #otherCustPresJuminNo, #otherCustCapital, #otherCustFoundYearDiv, #otherCustTel, #otherCustFax, #addrEdit').css('display', 'none');
		
		$("#regnumView").css('display', '');
		$("#bFileView").css('display', '');
		
		$("#regnumFileVBoxiew").css('display', 'none');
		$("#bFileBoxView").css('display', 'none');
		 
		$("#viewBtn").css('display', '');
		$("#editBtn").css('display', 'none');

		
	}
	
	function editMove(){

		$('#custName, #presName, #regnum, #presJuminNo, #capital, #foundYearView, #tel, #fax, #addrStr, #regnumView, #bFileView').css('display', 'none');
		
		$('#otherCustName, #otherCustPresName, #regnumEdit, #otherCustPresJuminNo, #otherCustCapital, #otherCustFoundYearDiv, #otherCustTel, #otherCustFax, #addrEdit').css('display', '');

		$("#regnumView").css('display', 'none');
		$("#bFileView").css('display', 'none');
		
		$("#regnumFileVBoxiew").css('display', '');
		$("#bFileBoxView").css('display', '');
		
		$("#viewBtn").css('display', 'none');
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
				
		$('#companyEditPop').modal('show')
	}
	
	function companyEdit(){
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		
		 const formData = new FormData();

		 const params = {
			custCode :loginInfo.custCode,
		 	interrelatedNm : loginInfo.custName,
		 	userId : loginInfo.userId,
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
		 	custType : loginInfo.custType
		 }
		 		 		
	 	const fileInput = document.getElementById('file-input').files[0];
	    const fileInput2 = document.getElementById('file-input2').files[0];	 
		 
	    if(fileInput){
			formData.append('regnumFile', fileInput);
	    }else if(!$("#regnumDelYn").val()){
			 params.regnumPath = $("#regnumPath").val()
			 params.regnumFile = $("#regnumFile").text()
	    }
	    
	    if(fileInput2){
			formData.append('bFile', fileInput2);
	    } else if(!$("#bFileDelYn").val()){
			 params.bFilePath = $("#bFilePath").val()
			 params.bFile = $("#bfile").text()
	    }   
	    
	    formData.append('data', new Blob([JSON.stringify(params)], { type: 'application/json' }));
	    
	    $.ajax({
	        url: '/api/v1/cust/save',
	        type: 'POST',
	        data: formData,
	        contentType: false,  
	        processData: false, 
	        success: function(response) {
	            if (response.code === "OK") {
	            	$('#companyEditPop').modal('hide')
	                Swal.fire('', '자사정보가 수정되었습니다.', 'info').then((result)=>{
	                	location.reload();
	                });
	            } else {
	                Swal.fire('', '자사정보 수정을 실패하였습니다.', 'warning');
	            }
	        },
	        error: function(xhr, status, error) {
	            Swal.fire('', '자사정보 수정을 실패하였습니다.', 'warning');
	            console.error('AJAX Error:', status, error);
	        }
	    });
				
	}
	
	function custDelPop(){
		$('#pwdChk').modal('show')
		$('#custInfoPwd').val('')
		$('#delEtc').val('')
	}
	
	function custInfoPwdChk(){
			
		if(!$('#custInfoPwd').val().trim()){
			Swal.fire('', '비밀번호를 입력해 주세요', 'warning')
			$('#custInfoPwd').val('')
			return
		}
		
		
		const params = {
			password : $('#custInfoPwd').val()
		}

		$.post(
			'/api/v1/main/checkPwd',
			params
			)
			.done(function(arg) {
				console.log(arg)
				if (arg.code === "OK") {
					if(arg.data){
						$('#pwdChk').modal('hide')
						$('#delPop').modal('show')
					}else{
						Swal.fire('', '비밀번호가 일치하지 않습니다.', 'warning')
						return
					}
					
				}
				else{
		            Swal.fire('', '비밀번호 확인을 실패하였습니다.', 'warning');
		            return
				}
			})
			
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
	
	function custDel(){
		
		if(!$('#delEtc').val().trim()){
			Swal.fire('', '탈퇴사유를 입력해 주세요', 'warning')
			$('#delEtc').val('')
			return
		}
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		const userId = loginInfo.userId
		const params = {
			etc : $('#delEtc').val(),
			custCode : loginInfo.custCode,
			userId : userId,
			updUserId : userId,
			delUserId : $("#userId").val()
		}

		$.post(
			'/api/v1/cust/del',
			params
			)
			.done(function(arg) {
				console.log(arg)
				if (arg.code === "OK") {
					$('#delPop').modal('hide')
					fnLogout()
				}
				else{
		            Swal.fire('', '회원탈퇴를 실패하였습니다.', 'warning');
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
		                <li>업체정보</li>
		                <li>자사정보</li>
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
								<div id="capital"></div>
								<div class="flex align-items-center width100">
									<input type="text" id="otherCustCapital" style="display: none" class="inputStyle maxWidth-max-content" placeholder="ex) 10,000,000" oninput="addComma(this)" >
									<div class="ml10">원</div>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">설립년도</div>
								<div id="foundYearView" class="flex align-items-center width100">
									<div id="foundYear"></div>
									<div class="ml10">년</div>
								</div>
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

						<div id="viewBtn" class="text-center mt30">
							<button onclick="custDelPop()" class="btnStyle btnOutlineRed">회원탈퇴</button>
							<a onclick="editMove()"class="btnStyle btnPrimary" title="승인">수정</a>
						</div>
						
						<div id="editBtn" class="text-center mt30" style="display: none">
							<button onclick="moveDetail()" class="btnStyle btnOutlineRed">취소</button>
							<a onclick="companyEditVali()" class="btnStyle btnPrimary" title="승인">저장</a>
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

					</div>
		        </div>

		    </div>
    	</div>
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
			
		<!-- 수정 저장 -->

		<div class="modal fade modalStyle" id="companyEditPop" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:420px">
				<div class="modal-content">
					<div class="modal-body">
						<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
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


 	<!-- 개인정보 비밀번호 확인 -->
	<div class="modal fade modalStyle" id="pwdChk" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:510px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle">비밀번호 확인</h2>
					<div class="flex align-items-center">
						<div class="formTit flex-shrink0 width100px">비밀번호</div>
						<div class="width100">
							<input type="password" id="custInfoPwd" class="inputStyle">
						</div>
					</div>
					<p class="text-center mt20"><i class="fa-light fa-circle-info"></i> 안전을 위해서 비밀번호를 입력해 주십시오</p>

					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
						<a onclick="custInfoPwdChk()" class="modalBtnCheck"title="확인">확인</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- 개인정보 비밀번호 확인 -->		
	
		<!-- 회원탈퇴 -->
	<div class="modal fade modalStyle" id="delPop" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" style="width:100%; max-width:550px">
			<div class="modal-content">
				<div class="modal-body">
					<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
					<h2 class="modalTitle">회원 탈퇴</h2>
					<div class="modalTopBox">
						<ul>
							<li><div>탈퇴사유를 입력해 주십시오.<br>탈퇴처리 시 로그아웃 처리 되고 다시 로그인 할 수 없습니다.<br>탈퇴 하시겠습니까?</div></li>
						</ul>
					</div>
					<textarea id="delEtc"  class="textareaStyle height150px mt20" placeholder="탈퇴사유 필수 입력"></textarea>
					<div class="modalFooter">
						<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
						<a onclick="custDel()" class="modalBtnCheck" title="회원탈퇴">회원탈퇴</a>
					</div>
				</div>				
			</div>
		</div>
	</div>
	<!-- //회원탈퇴 -->
	
	<!-- 주소 팝업 -->
	<jsp:include page="/WEB-INF/jsp/join/addrPop.jsp" />
</body>
</html>
