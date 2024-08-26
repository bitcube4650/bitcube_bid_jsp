<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		onSearch(0);
		
		
	});

	
	function onItemList(){
		const params = {
			itemGrp: $('#srcCustTypeCode').val(),
			itemName : 	$('#srcCustTypeName').val(),
			useYn : 'Y'	,
			"size"	: '5',
			"page"	: 0
		}
		
		$.post("/api/v1/login/itemList", params, 
			function(response) {
				if(response.code === 'OK') {
					const list = response.data.content;
					updatePagination(response.data);
					$("#total").html(response.data.totalElements)
					$("#itemListBody").empty();
					for(var i=0;i<list.length;i++) {
					$("#itemListBody").append(
						"<tr>" +
							'<td>'+ list[i].itemCode +'</td>'+
							'<td>'+ list[i].itemName +'</td>'+
							'<td> <a onclick="itemSelect(\''+ list[i].itemCode +'\', \''+ list[i].itemName +'\')" title="선택" class="btnStyle btnSecondary btnSm">선택</a></td>'+
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

	function onRejectModal(){
		$('#saveReject').val('')
		$('#companyTurnback').modal('show')
		
	}
	
	function onApprovalModal(){
		$('#companyAccept').modal('show')
		
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
		                <li>업체관리</li>
		            </ul>
		        </div>
		
		        <div class="contents">
		        	<div class="formWidth">
						<h3 class="h3Tit">회사 정보</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">가입희망 계열사</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">업체유형 1</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">업체유형 2</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">회사명</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">대표자명</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">사업자등록번호</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">법인번호</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">자본금</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">설립년도</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">대표전화</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">팩스</div>
								<div class="width100"></div>
							</div>
							<div class="flex mt20">
								<div class="formTit flex-shrink0 width170px">회사주소</div>
								<div class="width100">
	<!-- 								<p>12345</p>
									<p>서울시 마포구 도화동</p>
									<p>50-1 일진빌딩 304호</p> -->
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">사업자등록증</div>
								<div class="width100">
									<a class="textUnderline"></a>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">첨부파일</div>
								<div class="width100">
									<a class="textUnderline"></a>
								</div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">상태</div>
								<div class="width100"></div>
							</div>
						</div>

						<h3 class="h3Tit mt50">관리자 정보</h3>
						<div class="boxSt mt20">
							<div class="flex align-items-center">
								<div class="formTit flex-shrink0 width170px">이름</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">이메일</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">아이디</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">휴대폰</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">유선전화</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">직급</div>
								<div class="width100"></div>
							</div>
							<div class="flex align-items-center mt20">
								<div class="formTit flex-shrink0 width170px">부서</div>
								<div class="width100"></div>
							</div>
						</div>

						<div class="text-center mt50">
							<a class="btnStyle btnOutlineRed" title="취소">취소</a>
							<a onclick="onRejectModal()" class="btnStyle btnRed" title="반려">반려</a>
							<a onclick="onApprovalModal()" class="btnStyle btnPrimary" title="승인">승인</a>
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
						<textarea id="saveReject" class="textareaStyle height150px mt20" onkeydown="resize(this)" onkeyup="resize(this)" placeholder="반려사유 필수 입력"></textarea>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
							<a class="modalBtnCheck" data-toggle="modal" title="반려">반려</a>
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
							<a class="modalBtnCheck" data-toggle="modal" title="승인">승인</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //승인 -->
</body>
</html>
