<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		onSearch(0);
		
        $('#srcTitle').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onSearch(0);
            }
        });
	});
	
	function onSearch(page){
		$.post("/api/v1/faq/faqList", {
			"title"		: $("#srcTitle").val(),
			"faqType"	: $("#srcFaqType").val(),
			"admin"		: 'Y',
			"size"		: $("#pageSize").val(),
			"page"		: page
		}, function(response) {
			if(response.code === 'OK') {
				var list = response.data.content;
				updatePagination(response.data);
				$("#total").html(response.data.totalElements)
				$("#faqListBody").empty();
				for(var i=0;i<list.length;i++) {
					$("#faqListBody").append(
						"<tr>" +
							'<td>'+ list[i].faqTypeDescription +'</td>' +
							'<td class="text-left"><a data-toggle="modal" class="textUnderline notiTitle" title="FAQ 자세히 보기" onClick="faqEdit(\'' + encodeURIComponent(JSON.stringify(list[i])) + '\')">' + list[i].title + '</a></td>' +
							'<td>'+ list[i].userName +'</td>' +
							'<td>'+ list[i].createDate +'</td>'+
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
		
	function onFaqRegModal(){
		$('#regTitle').val('')
		$('#regAnswer').val('')
		$('input[name="regFaqType"][value="1"]').prop('checked', true)
		$('#faqReg').modal('show')
	}
	
	function faqEdit(data){
		const rowData = JSON.parse(decodeURIComponent(data))
		$('#editTitle').val(rowData.title)
		$('#editAnswer').val(rowData.answer)
		+ $('input[name="editFaqType"][value="' + rowData.faqType + '"]').prop('checked', true)
		$('#rowData').val(JSON.stringify(rowData))
		$('#faqEdit').modal('show')
	}
	
	function onFaqSaveCheck(saveType){
		
		$('#saveType').val(saveType)
		if(saveType === 'insert'){
			
			if(!$('#regTitle').val().trim()){
				Swal.fire('', 'FAQ 제목을 입력해 주세요.', 'warning')
				$('#regTitle').val('')
				return
			}
			
			if(!$('#regAnswer').val().trim()){
				Swal.fire('', 'FAQ 내용을 입력해 주세요.', 'warning')
				$('#regAnswer').val('')
				return
			}
		}else{
			
			if(!$('#editTitle').val().trim()){
				Swal.fire('', 'FAQ 제목을 입력해 주세요.', 'warning')
				$('#editTitle').val('')
				return
			}
			
			if(!$('#editAnswer').val().trim()){
				Swal.fire('', 'FAQ 내용을 입력해 주세요.', 'warning')
				$('#editAnswer').val('')
				return
			}
			
		}

		$('#faqSaveConfirm').modal('show')
	}
	
	function onFaqSave(){

		const saveType = $('#saveType').val()	
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		const params ={
			title : saveType === 'insert' ? $('#regTitle').val().trim() : $('#editTitle').val().trim(),
			answer : saveType === 'insert' ? $('#regAnswer').val().trim(): $('#editAnswer').val().trim(),
			faqType : saveType === 'insert' ? $('input[name="regFaqType"]:checked').val() : $('input[name="editFaqType"]:checked').val(),
			updateInsert :  saveType,
			userId : loginInfo.userId
		}
		
		if(saveType === 'update'){
			const rowData = JSON.parse($('#rowData').val())
			params.faqId = rowData.faqId
		}	
		
		$.post(
			"/api/v1/faq/save",
			params
		)
		.done(function(arg) {
			if (arg.code === "OK") {
	            $('#faqSaveConfirm').modal('hide');
	            onSearch(0);
				Swal.fire('', 'FAQ가 저장되었습니다.', 'info');
	            if(saveType === 'insert'){
	                $('#faqReg').modal('hide');
	            } else {
	                $('#faqEdit').modal('hide');
	            }
			}else{
				Swal.fire('', 'FAQ 저장을 실패하였습니다.', 'warning');
			}
		})
		
						
	}
	function onFaqDelConfirm(){
		$('#faqDelConfirm').modal('show')
	}
	
	function onFaqDel(){
		const rowData = JSON.parse($('#rowData').val())
		
		const params = {
			faqId : rowData.faqId
		}
		
		console.log(params)
		
		$.post(
			"/api/v1/faq/delete",
			params
		)
		.done(function(arg) {
			console.log(arg)
			if (arg.code === "OK") {
	            $('#faqDelConfirm').modal('hide');
	            onSearch(0);
				Swal.fire('', 'FAQ가 삭제되었습니다.', 'info');
	            $('#faqEdit').modal('hide');
	            
			}else{
				Swal.fire('', 'FAQ 삭제를 실패하였습니다.', 'warning');
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
		                <li>공지</li>
		                <li>FAQ</li>
		            </ul>
		        </div>
		
		        <div class="contents">
		            <div class="searchBox">
		                <div class="flex align-items-center">
		                    <div class="sbTit mr30">제목</div>
		                    <div class="width200px">
		                        <input type="text" id="srcTitle" class="inputStyle" maxlength="300"/>
		                    </div>
		                    <div class="sbTit mr30 ml50">구분</div>
		                    <div class="width200px">
		                        <select id="srcFaqType" class="selectStyle">
		                            <option value="">전체</option>
		                            <option value="1">가입관련</option>
		                            <option value="2">입찰관련</option>
		                            <option value="3">인증서관련</option>
		                        </select>
		                    </div>
		                    <a id="searchBtn" class="btnStyle btnSearch" onclick="onSearch()">검색</a>
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
		                    <a id="addFaqBtn" class="btnStyle btnPrimary" onClick="onFaqRegModal()"  title="FAQ 등록">FAQ 등록</a>
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
		                        <th>구분</th>
		                        <th>제목</th>
		                        <th>등록자</th>
		                        <th class="end">등록일시</th>
		                    </tr>
		                </thead>
		                <tbody id="faqListBody">
		                    
		                </tbody>
		            </table>
		
		            <div class="row mt40">
		                <div class="col-xs-12">
		                    <jsp:include page="/WEB-INF/jsp/pagination.jsp" />
		                </div>
		            </div>
		        </div>
		
		        <!-- 팝업 창 코드가 필요하면 여기에 추가합니다. -->
		        <div id="faqPop" class="modal fade" tabindex="-1" role="dialog">
		            <div class="modal-dialog" role="document">
		                <div class="modal-content">
		                    <div class="modal-header">h
		                            <span aria-hidden="true">&times;</span>
		                        </button>
		                    </div>
		                    <div class="modal-body">
		                        <!-- 팝업 내용 -->
		                    </div>
		                    <div class="modal-footer">
		                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
		                        <button type="button" id="saveFaqBtn" class="btn btn-primary">Save changes</button>
		                    </div>
		                </div>
		            </div>
		        </div>
				
		        <%-- <script src="${pageContext.request.contextPath}/js/adminFaq.js"></script> --%>
		    </div>
    	</div>
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    	
    	<!-- faq confirm -->
		<div class="modal fade modalStyle" id="faqSaveConfirm" tabindex="-1" role="dialog" aria-hidden="true" style="z-index : 1050">
			<div class="modal-dialog" style="width:100%; max-width:420px">
				<div class="modal-content">
					<div class="modal-body">
						<a  class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<div class="alertText2">FAQ를 저장 하시겠습니까?</div>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
                            <a  class="modalBtnCheck" onClick="onFaqSave()" title="저장">저장</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //faq confirm -->
		
		    	<!-- faq confirm -->
		<div class="modal fade modalStyle" id="faqDelConfirm" tabindex="-1" role="dialog" aria-hidden="true" style="z-index : 1050">
			<div class="modal-dialog" style="width:100%; max-width:420px">
				<div class="modal-content">
					<div class="modal-body">
						<a  class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
                        <div class="alertText2">FAQ를 삭제합니다.<br>삭제 하시겠습니까?</div>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
							<a onclick="onFaqDel()" class="modalBtnCheck">삭제</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //faq confirm -->

        <!-- FAQ 등록 -->
        <div class="modal fade modalStyle" id="faqReg" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" style="width:100%; max-width:600px">
                <div class="modal-content">
                    <div class="modal-body">
                        <a  class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
                        <h2 class="modalTitle">FAQ 등록</h2>
                        <div class="flex align-items-center mt20">
                            <div class="formTit flex-shrink0 width150px">FAQ 제목 <span class="star">*</span></div>
                            <div class="width100">
                                <input type="text" id="regTitle" class="inputStyle" maxlength="2000">
                            </div>
                        </div>
                        <div class="flex align-items-center mt20">
                            <div class="formTit flex-shrink0 width150px">FAQ 구분 <span class="star">*</span></div>
                            <div class="flex align-items-center width100">
                                <input type="radio" name="regFaqType" value="1" id="bm2_1" class="radioStyle" checked="checked"><label for="bm2_1">가입관련</label>
                                <input type="radio" name="regFaqType" value="2" id="bm2_2" class="radioStyle"><label for="bm2_2">입찰관련</label>
                                <input type="radio" name="regFaqType" value="3" id="bm2_3" class="radioStyle"><label for="bm2_3">인증서관련</label>
                            </div>
                        </div>
                        <div class="flex mt20">
                            <div class="formTit flex-shrink0 width150px">FAQ 내용 <span class="star">*</span></div>
                            <div class="width100">
                                <textarea id="regAnswer" class="textareaStyle overflow-y-scroll height150px" placeholder=""></textarea>
                            </div>
                        </div>
                        <div class="modalFooter">
                            <a  class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
                            <a class="modalBtnCheck" onClick="onFaqSaveCheck('insert')" title="저장">저장</a>
                        </div>
                    </div>				
                </div>
            </div>
        </div>
        <!-- //FAQ 등록 -->
        <input type="text" id="saveType" class="inputStyle" hidden="">
         <input type="text" id="rowData" class="inputStyle" hidden="">
        
        <!-- FAQ 수정 -->
        <div class="modal fade modalStyle" id="faqEdit" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" style="width:100%; max-width:600px">
                <div class="modal-content">
                    <div class="modal-body">
                        <a  class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
                        <h2 class="modalTitle">FAQ 수정</h2>
                        <div class="flex align-items-center mt20">
                            <div class="formTit flex-shrink0 width150px">FAQ 제목 <span class="star">*</span></div>
                            <div class="width100">
                                <input type="text" id="editTitle" class="inputStyle" maxlength="2000">
                            </div>
                        </div>
                        <div class="flex align-items-center mt20">
                            <div class="formTit flex-shrink0 width150px">FAQ 구분 <span class="star">*</span></div>
                            <div class="flex align-items-center width100">
                                <input type="radio" name="editFaqType" value="1" id="ebm2_1" class="radioStyle" checked="checked"><label for="ebm2_1">가입관련</label>
                                <input type="radio" name="editFaqType" value="2" id="ebm2_2" class="radioStyle"><label for="ebm2_2">입찰관련</label>
                                <input type="radio" name="editFaqType" value="3" id="ebm2_3" class="radioStyle"><label for="ebm2_3">인증서관련</label>
                            </div>
                        </div>
                        <div class="flex mt20">
                            <div class="formTit flex-shrink0 width150px">FAQ 내용 <span class="star">*</span></div>
                            <div class="width100">
                                <textarea id="editAnswer" class="textareaStyle overflow-y-scroll height150px" placeholder=""></textarea>
                            </div>
                        </div>
                        <div class="modalFooter">
                            <a  class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
                            <a class="modalBtnDelete" onClick="onFaqDelConfirm()" title="삭제">삭제</a>
                            <a class="modalBtnCheck" onClick="onFaqSaveCheck('update')" title="저장">저장</a>
                        </div>
                    </div>				
                </div>
            </div>
        </div>
        <!-- //FAQ 수정 -->
    </div>
</body>
</html>
