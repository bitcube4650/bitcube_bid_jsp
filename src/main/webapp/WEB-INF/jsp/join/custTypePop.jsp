<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
$(function(){
	fnItemGrpList();
});

function fnItemGrpList() {
	$.post(
		'/api/v1/login/itemGrpList', 
		{}
	)
	.done(function(arg) {
		if (arg.code === "OK") {
			let html = '<option value="">품목그룹 전체</option>';
			let data = arg.data;
			for(let i = 0 ; i < data.length ; i++){
				html += "<option value='"+data[i].value+"'>"+data[i].name+"</option>"
			}
			
			$("#itemGrp").html(html);
			onSearch(0);
		} else{
			Swal.fire('', '품목 불러오기에 실패하였습니다.', 'error');
		}
	})
}

function onSearch(page){
	
	$.post(
		'/api/v1/login/itemList', 
		{ 
			size: 5,
			itemGrp: $("#itemGrp").val(),
			useYn : 'Y',
			itemName : $("#itemName").val(),
			page : page
		}
	)
	.done(function(arg) {
		if (arg.code === "OK") {
			let html = "";
			let data = arg.data.content;
			updatePagination(arg.data);
			for(let i = 0 ; i < data.length ; i++){
				html += "<tr>";
				html += 	"<td>" + data[i].itemCode + "</td>";
				html += 	"<td class='text-left'>" + data[i].itemName + "</td>";
				html += 	"<td>";
				html += 		"<button onClick='itemSelectCallback(\""+data[i].itemCode+"\", \""+data[i].itemName+"\")' class='btnStyle btnSecondary btnSm' >선택</button>";
				html += 	"</td>";
				html += "</tr>";
			}
			
			if(data.length == 0){
				html += "<tr>";
				html += 	"<td colspan='3'>조회된 내용이 없습니다.</td>"
				html += "</tr>";
			}
			
			$("#itemList").html(html);
			
		} else{
			Swal.fire('', '품목 불러오기에 실패하였습니다.', 'error');
		}
	})
}

</script>
<div class="modal fade modalStyle" id="custTypePop" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:800px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">품목 선택</h2>
				<div class="modalTopBox">
					<ul>
					<li><div>검색 창에 품목명 또는 품목코드를 입력하시고 엔터 또는 [품목조회] 버튼을 클릭하시고 폼목을 선택해 주십시오.</div></li>
					<li><div>품목코드는 2017년부터 적용되는 한국표준산업분류 10차 개정 자료를 기준으로 합니다.</div></li>
					</ul>
				</div>
		
				<div class="modalSearchBox mt20">
					<div class="flex align-items-center">
						<div style="width:calc(100% - 120px)">
							<select id="itemGrp" id="itemGrp" class="selectStyle">
								<option value="">품목그룹전체</option>
							</select>
							<input type="text" id="itemName" name="itemName" class="inputStyle mt10" placeholder="품목명 또는 품목코드 입력 조회"/>
						</div>
						<a onClick="onSearch(0)" class="btnStyle btnSearch">검색</a>
					</div>
				</div>
		
				<table class="tblSkin1 mt30">
					<colgroup>
						<col style="" />
					</colgroup>
					<thead>
						<tr>
							<th>품목코드</th>
							<th>품목명</th>
							<th class="end" style="width:106px;">선택</th>
						</tr>
					</thead>
					<tbody id="itemList">
					</tbody>
				</table>
		
				<div class="row mt30">
					<div class="col-xs-12">
						<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
					</div>
				</div>
				
				<div class="modalFooter">
					<a href="javascript:void(0)" id="modalClose" class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
				</div>
			</div>
		</div>
	</div>
</div>
