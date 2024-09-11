<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	// init
	function fnInitBidCustListPop() {
		onSearch(0);
	}
	
	function onSearch(page) {
		var custName	= $("#bidCustListPopCustName").val();
		var chairman	= $("#bidCustListPopChairman").val();
		
		$.post(
			"/api/v1/bid/custList",
			{
				custName	: custName
			,	chairman	: chairman
			,	size		: 5
			,	page		: page
			},
			function(response){
				if(response.code === 'OK') {
					var list = response.data.content;
					updatePagination(response.data);
					$("#bidCustListPopTable").empty();
					
					if(list.length > 0) {
						for(var i=0;i<list.length;i++) {
							var str = "";
							str += "<tr>";
							str += "<td>"+ list[i].custName +"</td>";
							str += "<td>"+ list[i].combinedAddr +"</td>";
							str += "<td>"+ list[i].presName +"</td>";
							str += "<td class='end'>";
							str += "<button class='btnStyle btnSecondary btnSm' title='선택' onclick='onBidCustSelect(\"" + list[i].custCode + "\",\"" + list[i].custName + "\")'>선택</button>";
							str += "</td>";
							str += "</tr>";
							
							$("#bidCustListPopTable").append(str);
						}
					} else {
						$("#bidCustListPopTable").append(
							"<tr>" + 
								"<td class='end' colSpan=4>조회된 데이터가 없습니다.</td>" +
							"</tr>"
						)
					}
				} else {
					
				}
			},
			"json"
		);
	}
	
	function onBidCustSelect(srcCustCode, srcCustName) {
	//	const hasCustCode = custContent.some(item => item.custCode == srcCustCode);

		//if (!hasCustCode) {
			onBidCustUserListModal();
		//} else {
		//	Swal.fire('이미 등록된 업체입니다.', '', 'error');
		//}
	}
	
	// 닫기
	function onBidCustListModalHide() {
		$("#bidCustListPop").modal("hide");
	}
</script>
<div class="modal fade modalStyle" id="bidCustListPop" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog" style="width:100%; max-width:1200px">
		<div class="modal-content">
			<div class="modal-body">
				<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">업체조회</h2>
				<div class="modalTopBox">
					<ul>
						<li>
							<div>계열사에 등록되어 있는 업체리스트를 조회합니다</div>
						</li>
					</ul>
				</div>
				<div class="modalSearchBox mt20">
					<div class="flex align-items-center">
						<div class="sbTit mr30">업체명</div>
						<div class="width150px">
							<input class="inputStyle" id="bidCustListPopCustName" maxLength="50" />
						</div>
						<div class="sbTit mr30 ml50">대표자명</div>
						<div class="width150px">
							<input class="inputStyle" id="bidCustListPopChairman" maxLength="25" />
						</div>
						<button class="btnStyle btnSearch" onclick="onSearch(0)">검색</button>
					</div>
				</div>
				<table class="tblSkin1 mt30">
					<colgroup>
						<col />
					</colgroup>
					<thead>
						<tr>
							<th>업체명</th>
							<th>주소</th>
							<th>대표자명</th>
							<th class="end">선택</th>
						</tr>
					</thead>
					<tbody id="bidCustListPopTable">
					</tbody>
				</table>
				<div class="row mt30">
					<div class="col-xs-12">
						<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
					</div>
				</div>
				<div class="modalFooter">
					<button class="modalBtnClose" title="닫기" onClick="onBidCustListModalHide()">닫기</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 협력사 사용자 팝업 -->
	<jsp:include page="/WEB-INF/jsp/bid/bidCustUserList.jsp" />
</div>
