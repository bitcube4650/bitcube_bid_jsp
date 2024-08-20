<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>

var fnNoticeDetail = async function(bno){
	
	await $.post("/api/v1/notice/updateClickNum", {'bno': bno}); //클릭 시 조회수 +1
	
	await $.post(
		'/api/v1/notice/noticeList', 
		{ 'bno': bno }
	)
	.done(function(arg) {
		if (arg.code === "OK") {
			let data = arg.data.content[0];
			
			$("#notiPop_Title").text(data.btitle);
			$("#notiPop_WriteName").text(data.buserName);
			$("#notiPop_RegDt").text(data.bdate);
			$("#notiPop_Count").text(data.bcount);
			$("#notiPop_Content").text(data.bcontent);
			$("#notiPop_File").text(data.bfile);
			$("#notiPop_FilePath").val(data.bfilePath);
			
			
			$("#notiModal").modal('show');
		}
	})
}

var fnNotiFileDown = async function() {
	let fileName = $("#notiPop_File").text();
	let filePath = $("#notiPop_FilePath").val();
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
</script>

<div class="modal fade modalStyle" id="notiModal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog" style="width:100%; max-width:600px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">공지사항</h2>
				<div class="flex align-items-center">
					<div class="formTit flex-shrink0 width100px">제목</div>
					<div class="width100 line140"><span id="notiPop_Title"></span></div>
				</div>
				<div class="flex align-items-center mt20">
					<div class="formTit flex-shrink0 width100px">작성자</div>
					<div class="width100"><span id="notiPop_WriteName"></span></div>
				</div>
				<div class="flex align-items-center mt20">
					<div class="formTit flex-shrink0 width100px">공지일시</div>
					<div class="width100"><span id="notiPop_RegDt"></span></div>
				</div>
				<div class="flex align-items-center mt20">
					<div class="formTit flex-shrink0 width100px">조회수</div>
					<div class="width100"><span id="notiPop_Count"></span></div>
				</div>
				<div class="modalBoxSt overflow-y-scroll height250px mt30">
					<p id="notiPop_Content"></p>
				</div>
				<div class="flex align-items-center mt20">
					<div class="formTit flex-shrink0 width100px">첨부파일</div>
					<div class="width100">
						<a href="javascript:fnNotiFileDown()" class="textUnderline">
							<span id="notiPop_File"></span>
							<input type="text" id="notiPop_FilePath" class="inputStyle" style="display:none;" />
						</a>
					</div>
				</div>

				<div class="modalFooter">
					<a href="javascript:void(0)" class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
				</div>
			</div>				
		</div>
	</div>
</div>
