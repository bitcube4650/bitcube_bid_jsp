<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		$(document).ready(function() {
			onSearch();
		});
		
		function onSearch(){
			// localStorage에서 입찰번호 가져오기
			var biNo = localStorage.getItem('biNo');
			
			$.post(
				'/api/v1/bidComplete/partnerDetail',
				{
					biNo : biNo
				}
			).done(
				function(arg){
					if(arg.code == "fail"){
						Swal.fire('', arg.msg, 'error');
					} else {
						let result = arg.data;
						console.log(result)
						// 입찰에 부치는 사람
						$("#biNo").text(result.biNo);								// 입찰번호
						$("#biName").text(result.biName);							// 입찰명
						$("#itemName").text(result.itemName + ' 품목류');				// 품목
						
						// 입찰방식 및 낙찰자 결정방법
						$("#biMode").text(Ft.ftBiMode(result.biMode));				// 입찰방식
						$("#succDeciMeth").text(result.succDeciMeth);				// 낙찰자 결정방법
						
						// 입찰 참가정보
						$("#bidJoinSpec").text(result.bidJoinSpec);					// 입찰참가자격
						$("#spotDate").text(result.spotDate);						// 현장설명일시
						$("#spotArea").text(result.spotArea);						// 현장설명장소
						$("#specialCond").html(result.specialCond);					// 특수조건
						$("#supplyCond").text(result.supplyCond);					// 납품조건
						$("#amtBasis").text(result.amtBasis);						// 금액기준
						$("#payCond").text(result.payCond);							// 결제조건
						
						// 참고사항
						$("#damdangName").text(result.damdangName);					// 입찰담당자
						$("#deptName").text(result.deptName);						// 입찰담당부서
						$("#whyA3").text(result.whyA3);								// 재입찰사유
						
						// 전자입찰 제출 내역
						$("#estStartDate").text(result.estStartDate);				// 제출시작일시
						$("#estCloseDate").text(result.estCloseDate);				// 제출마감일시

						let insMode = "";											// 세부내역
						if(result.insMode == '1'){
							for(let i = 0; i < result.specFile.length; i++){
								insMode += "<a class='textUnderline'>"+result.specFile[i].fileNm+"</a>"
							}
						} else if(result.insMode == '2'){
								insMode += "<table class='tblSkin1'>";
								insMode += "	<colgroup>";
								insMode += "		<col style>";
								insMode += "	</colgroup>";
								insMode += "	<thead>";
								insMode += "		<tr>";
								insMode += "			<th>품목명</th>";
								insMode += "			<th>규격</th>";
								insMode += "			<th>단위</th>";
								insMode += "			<th class='end'>수량</th>";
								insMode += "		</tr>";
								insMode += "	</thead>";
								insMode += "	<tbody>";
								for(let i = 0; i < result.specInput.length; i++){
									insMode += "	<tr>";
									insMode += "		<td>"+result.specInput[i].name+"</td>";
									insMode += "		<td>"+result.specInput[i].ssize+"</td>";
									insMode += "		<td>"+result.specInput[i].unitcode+"</td>";
									insMode += "		<td>"+parseInt(result.specInput[i].orderQty).toLocaleString()+"</td>";
									insMode += "	</tr>";
								}
								insMode += "	</tbody>";
								insMode += "</table>";
						}
						$("#insModeDiv").html(insMode);
						
						let attachFile = "";											// 첨부파일
						for(let i = 0; i < result.fileList.length; i++){
							attachFile += "<a class='textUnderline'>"+result.fileList[i].fileNm+"</a>";
						}
						$("#attachFileDiv").html(attachFile);
					}
				}
			)
		}
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			<div class="conRight">
				<div class="conHeader">
					<ul class="conHeaderCate">
						<li>전자입찰</li>
						<li>입찰완료 상세</li>
					</ul>
				</div>
				<div class="contents">
					<div class="formWidth">
						<div>
							<h3 class="h3Tit">입찰에 부치는 사람</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="formTit flex-shrink0 width170px">입찰번호</div>
									<div class="width100" id="biNo"></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">입찰명</div>
									<div class="width100" id="biName"></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">품목</div>
									<div class="width100" id="itemName"></div>
								</div>
							</div>
							<h3 class="h3Tit mt50">입찰방식 및 낙찰자 결정방법</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="formTit flex-shrink0 width170px">입찰방식</div>
									<div class="width100" id="biMode"></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">낙찰자 결정방법</div>
									<div class="width100" id="succDeciMeth"></div>
								</div>
							</div>
							<h3 class="h3Tit mt50">입찰 참가정보</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="formTit flex-shrink0 width170px">입찰참가자격</div>
									<div class="width100" id="bidJoinSpec"></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">현장설명일시</div>
									<div class="width100" id="spotDate"></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">현장설명장소</div>
									<div class="width100" id="spotArea">비즈밸리</div>
								</div>
								<div class="flex mt20">
									<div class="formTit flex-shrink0 width170px">특수조건</div>
									<div class="width100">
										<div class="overflow-y-scroll boxStSm width100" style="height: 100px;">
											<pre style="background-color: white;" id="specialCond"></pre>
										</div>
									</div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">납품조건</div>
									<div class="width100" id="supplyCond"></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">금액기준</div>
									<div class="width100" id="amtBasis"></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">결제조건</div>
									<div class="width100" id="payCond"></div>
								</div>
							</div>
							<h3 class="h3Tit mt50">참고사항</h3>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="flex align-items-center width100">
										<div class="formTit flex-shrink0 width170px">입찰담당자</div>
										<div class="width100" id="damdangName"></div>
									</div>
									<div class="flex align-items-center width100 ml80">
										<div class="formTit flex-shrink0 width170px">입찰담당부서</div>
										<div class="width100" id="deptName"></div>
									</div>
								</div>
								<!--  data.ingTag == 'A3' && data.whyA3 일때만 보이기 -->
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">재입찰사유</div>
									<div class="width100" id="whyA3"></div>
								</div>
							</div>
							<h3 class="h3Tit mt50">전자입찰 제출 내역</h3>
							<div class="conTopBox mt20">
								<ul class="dList">
									<li><div>세부내역파일을 다운받아 내역 작성 후 제출기한 내 등록해 주시기 바랍니다.</div></li>
									<li><div>첨부파일은 세부내역 작성에 참고 될 자료들입니다.</div></li>
								</ul>
							</div>
							<div class="boxSt mt20">
								<div class="flex align-items-center">
									<div class="flex align-items-center width100">
										<div class="formTit flex-shrink0 width170px">제출시작일시</div>
										<div class="width100" id="estStartDate"></div>
									</div>
									<div class="flex align-items-center width100 ml80">
										<div class="formTit flex-shrink0 width170px">제출마감일시</div>
										<div class="width100" id="estCloseDate"></div>
									</div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">세부내역</div>
									<div class="width100" id="insModeDiv"></div>
								</div>
								<div class="flex align-items-center mt20">
									<div class="formTit flex-shrink0 width170px">첨부파일</div>
									<div class="width100" id="attachFileDiv"></div>
								</div>
							</div>
						</div>
						<h3 class="h3Tit mt50">유찰</h3>
						<div class="conTopBox mt20">
							<ul class="dList">
								<li class="textHighlight"><div>아쉽게도 이번 입찰에는 선정되지
										못했습니다. 아래 유찰사유 내용을 확인하십시오.</div></li>
							</ul>
						</div>
						<div class="boxSt mt20">
							<div class="flex align-items-center width100">
								<div class="formTit flex-shrink0 width170px">유찰사유</div>
								<div class="width100">입찰마감 30일이 지난입찰 자동 유찰처리</div>
							</div>
						</div>
						<div class="text-center mt50">
							<a title="목록" class="btnStyle btnOutline">목록</a>
							<!---->
						</div>
					</div>
				</div>
				<div id="biddingCheck" tabindex="-1" role="dialog"
					aria-hidden="true" class="modal fade modalStyle">
					<div class="modal-dialog" style="width: 100%; max-width: 420px;">
						<div class="modal-content">
							<div class="modal-body">
								<a data-dismiss="modal" title="닫기" class="ModalClose"><i
									class="fa-solid fa-xmark"></i></a>
								<div class="alertText2">
									본 입찰의 업체선정 됨을 확인합니다.<br>낙찰된 건에 대해 승인하시겠습니까?
								</div>
								<div class="modalFooter">
									<a data-dismiss="modal" title="취소" class="modalBtnClose">취소</a><a
										data-toggle="modal" title="승인" class="modalBtnCheck">승인</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
