<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(document).ready(function() {
		$('#allChk').change(function() {
			$('input[name="subCheckbox"]').prop('checked', this.checked);
		});
	});
	
	function onSearch (page) {
		
	}
</script>
<div class="modal fade modalStyle" id="bidCustUserListPop" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog" style="width:100%; max-width:1200px">
		<div class="modal-content">
			<div class="modal-body">
				<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">협력사 사용자</h2>
				<div class="modalSearchBox mt20">
					<div class="flex align-items-center">
						<div class="sbTit mr30">사용자명</div>
						<div class="width150px">
							<input class="inputStyle" id="bidCustUserListPopUserName" />
						</div>
						<div class="sbTit mr30 ml50">로그인 ID</div>
						<div class="width150px">
							<input class="inputStyle" id="bidCustUserListPopUserId" />
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
							<th><input type="checkbox" id="allChk" /></th>
							<th>사용자명</th>
							<th>로그인ID</th>
							<th>부서</th>
							<th>직급</th>
							<th>이메일</th>
							<th>전화번호</th>
							<th>휴대폰</th>
							<th class="end">권한</th>
						</tr>
					</thead>
					<tbody id="bidCustUserListPopTable">
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
</div>
