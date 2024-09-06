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
			$("#rejectBtn").css("display", "")
			$("#approvaltBtn").css("display", "")
		}
		
		const params = {
			custCode : new URLSearchParams(window.location.search).get('custCode'),
			interrelatedCustCode : loginInfo.custCode
		}
		
		$.post("/api/v1/cust/CustDetail", params, 
			function(response) {
			const data = response.data[0]
				if(response.code === 'OK') {
					$("#interrelatedNm").append(data.interrelatedNm)
					$("#custTypeNm1").append(data.custTypeNm1)
					$("#custTypeNm2").append(data.custTypeNm2)
					$("#custName").append(data.custName)
					$("#presName").append(data.presName)
					$("#regnum").append(data.regnum ? Ft.onAddDashRegNum(data.regnum) : '')
					$("#presJuminNo").append(Ft.onAddDashRPresJuminNum(data.presJuminNo))
					$("#capital").append(Ft.fnRoundComma(data.capital))
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
					$("#certYn").append(data.certYn === 'N' ? '미승인' : '승인')
					$("#userName1").append(data.userName)
					$("#userEmail").append(data.userEmail)
					$("#userId").append(data.userId)
					$("#userHp").append(Ft.onAddDashTel(data.userHp))
					$("#userTel").append(Ft.onAddDashTel(data.userTel))
					$("#userPosition").append(data.userPosition)
					$("#userBuseo").append(data.userBuseo)
					
					
			} else {
				Swal.fire('', response.msg, 'warning')
			}
		},
		"json"
		);
	}

	function onRejectModal(){
		$('#saveReject').val('')
		$('#companyTurnback').modal('show')
		
	}
	
	function onApprovalModal(){
		$('#companyAccept').modal('show')
	}
	
	function saveReject(){
		if(!$('#saveReject').val().trim()){
			Swal.fire('', '반려 사유를 입력해 주세요.', 'warning')
			$('#saveReject').val('')
			return
		}
		
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		const params = {
			custCode : new URLSearchParams(window.location.search).get('custCode'),
			etc : $('#saveReject').val().trim(),
			userId : loginInfo.userId,
			custName : $('#custName').text()
		}

		$.post(
			'/api/v1/cust/back',
			params
			)
			.done(function(arg) {
				if (arg.code === "OK") {
					$('#companyTurnback').modal('hide')
					Swal.fire('', '정상적으로 반려 처리되었습니다.', 'info').then((result) => {
				        window.location.href = '/company/approval';
					});

				}
				else{
		            Swal.fire('', '반려 처리를 실패하였습니다.', 'warning');
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
				        window.location.href = '/company/approval';
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

</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
		    <div class="conRight">
		        <div class="conHeader">
		            <ul class="conHeaderCate">
		                <li>업체정보</li>
		                <li>업체승인</li>
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
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">대표자명</div>
								<div id="presName" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">사업자등록번호</div>
								<div id="regnum" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">법인번호</div>
								<div id="presJuminNo" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">자본금</div>
								<div id="capital" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">설립년도</div>
								<div id="foundYear" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">대표전화</div>
								<div id="tel" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">팩스</div>
								<div id="fax" class="width100"></div>
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">회사주소</div>
								<div class="width100">
		 							<p id="zipcode"></p>
									<p id="addr"></p>
									<p id="addrDetail"></p>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">사업자등록증</div>
								<div class="width100">
									<a onclick="downloadFile('regnum')" id="regnumFile" class="textUnderline"></a>
									<input id="regnumPath" type="text" hidden="">
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">회사소개 및 기타자료</div>
								<div class="width100">
									<a id="bfile" onclick="downloadFile('bfile')" class="textUnderline"></a>
									<input id="bFilePath" type="text" hidden="">
								</div>
							</div>
							
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">상태</div>
								<div class="width100" id="certYn"></div>
							</div>
						</div>

						<h3 class="h3Tit mt50">관리자 정보</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">이름</div>
								<div id="userName1" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">이메일</div>
								<div id="userEmail" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">아이디</div>
								<div id="userId" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">휴대폰</div>
								<div id="userHp" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">유선전화</div>
								<div id="userTel" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">직급</div>
								<div id="userPosition" class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">부서</div>
								<div id="userBuseo" class="width100"></div>
							</div>
						</div>

						<div class="text-center mt50"> 
							<a href="/company/approval" class="btnStyle btnOutlineRed" title="취소">취소</a>
							<a id="rejectBtn" onclick="onRejectModal()" class="btnStyle btnRed" style="display:none" title="반려">반려</a>						
							<a id="approvaltBtn" onclick="onApprovalModal()" class="btnStyle btnPrimary" style="display:none" title="승인">승인</a> 
						</div>
					</div>
		        </div>

		    </div>
    	</div>
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
		

		<!-- 반려 -->
		<div class="modal fade modalStyle" id="companyTurnback" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:550px">
				<div class="modal-content">
					<div class="modal-body">
						<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<h2 class="modalTitle">업체등록 반려</h2>
						<div class="modalTopBox">
							<ul>
								<li><div>업체 등록을 반려합니다.<br>아래 반려 사유를 입력해 주십시오.<br>반려 처리 시 반려사유 내용으로 업체에게 발송 됩니다.</div></li>
							</ul>
						</div>
						<textarea id="saveReject" class="textareaStyle height150px mt20" placeholder="반려사유 필수 입력"></textarea>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
							<a onclick="saveReject()" class="modalBtnCheck" title="반려">반려</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //반려 -->
	
		<!-- 승인 -->
		<div class="modal fade modalStyle" id="companyAccept" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:420px">
				<div class="modal-content">
					<div class="modal-body">
						<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<div class="alertText2">업체 등록을 승인하시겠습니까?</div>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
							<a onclick="onApproval()" class="modalBtnCheck"title="승인">승인</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //승인 -->
</body>
</html>
