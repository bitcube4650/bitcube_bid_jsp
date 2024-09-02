<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/common.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	
	
    const loginInfo = JSON.parse(localStorage.getItem("loginInfo"));
	
	
    updateClickNum()
    $('#noticeType').empty()
    $('#noticeType').append('공지사항 상세')
	$('#userName').text(loginInfo.userName)
		
});


document.addEventListener("DOMContentLoaded", function() {
    const fileInput = document.getElementById('file-input');
    const uploadBox = document.querySelector('.upload-box'); 
    const uploadPreview = document.getElementById('uploadPreview'); 

    if (!fileInput || !uploadBox || !uploadPreview) {
        console.error("Required elements not found in the DOM.");
        return;
    }


    fileInput.addEventListener('change', function(event) {
        uploadPreview.innerHTML = '';

        const file = event.target.files[0];
        if (file) {
            uploadBox.style.display = 'none';

            const p = document.createElement('p');

            const fileNameSpan = document.createElement('span');
            fileNameSpan.textContent = file.name;
            p.appendChild(fileNameSpan);

            const removeButton = document.createElement('button');
            removeButton.className = 'file-remove';
            removeButton.textContent = '삭제';
            removeButton.onclick = function() {
                fileInput.value = ''; 
                uploadPreview.innerHTML = ''; 
                uploadBox.style.display = '';
                //$('#fileEditYn').val('Y')
            };
            p.appendChild(removeButton);

            uploadPreview.appendChild(p);
        }
    });
    
});

function noticeDetail(){
	
	   const params = {
	            bno : new URLSearchParams(window.location.search).get('bno'),
	        };

	        $.post(
	            '/api/v1/notice/noticeList',
	            params,
	            function(response) {
	            	console.log(response.data.content[0])
	            	const data = response.data.content[0]
	            	
					if((loginInfo.custType === 'inter' && loginInfo.userAuth === '1') || (data.buserId === loginInfo.userId)){
						$('#removeNotice').css('display','')
						$('#updateMove').css('display','')
					}	
	            	if(data.bco === 'CUST'){
		            	$('#interrelatedListCodes').val(data.interrelatedCodes)
		            	$('#affiliate').append(data.interrelatedNms)
	            	}

	            	$('#noticeTitleStr').append(data.btitle)
	            	$('input[name="bm2"][value="'+data.bco+'"]').prop('checked', true)
	            	$('#noticeUserName').append(data.buserName)
	            	$('#noticeDate').append(data.bdate)
	            	$('#noticeBcount').append(data.bcount)

            	    $('#bcontent').append(data.bcontent)

            	    if(data.bfile){
                	    $('#uploadFileNm').append('<a onclick="downloadFile()" class="textUnderline notiTitle">'+(data.bfile ? data.bfile : '' )+'</a>')
                	    $("#uploadFilePath").val(data.bfilePath);
                	    $('#editEfilePath').val(data.bfilePath)
                	    $('#editBfile').val(data.bfile)
            	    }

            	    


	                if (response.code == "OK") {
	                    const noticeData = response.data.content;
	                } else {
	                    console.error("Failed to retrieve data:", response.message);
	                }
	            },
	            "json"
	        );
	        
}

function updateClickNum(){
    $.post(
            "/api/v1/notice/updateClickNum",
            {bno : new URLSearchParams(window.location.search).get('bno')},
            function(response) {
            	if(response.code === 'OK'){
                	noticeDetail()
            	}

            },
            "json"
        );
}


function interrelatedList(){
    $.post(
            "/api/v1/login/interrelatedList",
            function(response) {
            	const data = response.data
                if (data.length > 0) {
                    const tableBody = document.getElementById('affiliateTableBody');
                    if (tableBody) {
                    	const interrelatedListCodes = $('#interrelatedListCodes').val().split(',');

                    	tableBody.innerHTML = '';

                    	data.forEach((affiliate, index) => {
                    	    const row = document.createElement('tr');

                    	    const checkboxCell = document.createElement('td');
                    	    const checkbox = document.createElement('input');
                    	    checkbox.type = 'checkbox';
                    	    checkbox.className = 'checkStyle';
                    	    checkbox.id = 'ckp' + index;
                    	    checkbox.name = 'interrelatedListCheck';
                    	    checkbox.value = affiliate.interrelatedCustCode;

                    	    if (interrelatedListCodes.includes(checkbox.value)) {
                    	        checkbox.checked = true; 
                    	    }

                    	    const label = document.createElement('label');
                    	    label.setAttribute('for', 'ckp' + index);
                    	    checkboxCell.appendChild(checkbox);
                    	    checkboxCell.appendChild(label);

                    	    const nameCell = document.createElement('td');
                    	    nameCell.className = 'text-left end';
                    	    const nameLabel = document.createElement('label');
                    	    nameLabel.setAttribute('for', 'ckp' + index);
                    	    nameLabel.className = 'fontweight-400';
                    	    nameLabel.textContent = affiliate.interrelatedNm;
                    	    nameCell.appendChild(nameLabel);

                    	    row.appendChild(checkboxCell);
                    	    row.appendChild(nameCell);

                    	    tableBody.appendChild(row);
                    	});

                    } else {
                        console.error("affiliateTableBody element not found.");
                    }
                }
            },
            "json"
        );
}

function onSelect(){
    $('#affiliate').empty();

    let selectedNames = [];
    $('input[name="interrelatedListCheck"]:checked').each(function() {
        const label = $(this).closest('tr').find('label.fontweight-400').text();
        selectedNames.push(label);
    });

    if (selectedNames.length > 0) {
        $('#affiliate').text(selectedNames.join(', '));
    } else {
    	
    }
    $('#AffiliateSelect').modal('hide')
}

function onAffiliateSelectOpen(){
	$('#affiliate').css("display", "")
	$('#AffiliateSelect').modal('show')
} 

function saveNotice(){
    
	if(!$('#btitle').val().trim()){
		Swal.fire('', '제목을 입력해 주세요', 'warning')
		$('#btitle').val('')
		return
	}
	 

    const bco = $('input[name="bm2"]:checked').val()
    let checkedValues = [];
    $('input[name="interrelatedListCheck"]:checked').each(function() {
        checkedValues.push($(this).val());
    });
    
	if(bco == 'CUST' && checkedValues.length === 0){
		Swal.fire('', '공지대상이 계열사일 경우 계열사를 1개 이상 선택해야 합니다.', 'warning')
		return
	}
	
	if(!$('#bcontent').val().trim()){
		Swal.fire('', '공지내용을 입력해 주세요 주세요.', 'warning')
		$('#bcontent').val('')
		return
	}
	
	let formData = new FormData()
	const fileInput = document.getElementById('file-input');
	const file = fileInput.files[0];
	
	const loginInfo = JSON.parse(localStorage.getItem("loginInfo"));

	const params = {
		btitle : $('#btitle').val(),
		bcontent : $('#bcontent').val(),
		bco : bco,
		buserid : loginInfo.userId,
		bfilePath : $('#editEfilePath').val(),
		bfile :  $('#editBfile').val(),		
		bno : new URLSearchParams(window.location.search).get('bno')
	}
    if(bco == 'CUST'){
    	params.interrelatedCustCodeArr = checkedValues
    }
    
    if(file){
    	formData.append('file', file);
    }
    
    formData.append('data', new Blob([JSON.stringify(params)], { type: 'application/json' }));
	
	    $.ajax({
        url: '/api/v1/notice/updateNotice',
        type: 'POST',
        data: formData,
        contentType: false, 
        processData: false,  
        success: function(response) {
			if (response.code === "OK") {
				Swal.fire('', '공지사항이 수정되었습니다.', 'info').then((result) => {
					window.location.href = '/notice/noticeList';
				});

			}
        },
        error: function(xhr, status, error) {
            Swal.fire('', '공지사항 수정을 실패하였습니다.', 'warning');
            return
            console.error('AJAX Error:', status, error);
        }
    });
	
	/*
	
    $.post(
    '/api/v1/notice/insertNotice', formData,
       function(response) {
			console.log(response)
       },
       "json"
    );
    
    */    
	
}
function bcoChange(){
	$('#affiliate').css("display", "none")
}

function onDelPop(){
	$('#notiDel').modal('show')
}
function deleteNotice(){

	const params = {
		bno : new URLSearchParams(window.location.search).get('bno')
	}

	$.post(
		'/api/v1/notice/deleteNotice',
		params
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				$('#notiDel').modal('hide')
				Swal.fire('', '공지사항이 삭제되었습니다.', 'info').then((result) => {
			        window.location.href = '/notice/noticeList';
				});

			}
			else{
	            Swal.fire('', '공지사항 삭제를 실패하였습니다.', 'warning');
	            return
			}
		})
}

function downloadFile(){
	let fileName = $(".notiTitle").text();
	const params = {
			fileId : $("#uploadFilePath").val()
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

function onEdit(){
    $('#noticeType').empty()
    $('#noticeType').append('공지사항 수정')
	interrelatedList()
	$('#removeNotice').css('display','none')
	$('#updateMove').css('display','none')
	$('#savebtn').css('display','')
    $('#noticeTitleStr').css('display','none')
    $('#btitle').val($('#noticeTitleStr').text())
    $('#btitle').css('display','')
    $('#noticeTitleStr').empty()
    $('#bm2_1').prop('disabled', false);
	$('#bm2_2').prop('disabled', false);
	$('#noticeDate').empty()
    $('#noticeDate').append('수정한 날짜로 저장됩니다.')
    $('#uploadFileNm').css('display','none')
    $('#noticeFileUpload').css('display','')
  	$('#bcontent').prop('disabled', false);
	
    const bfile = $('#uploadFileNm').text().trim()
    if (bfile) {
        const fileInput = document.getElementById('file-input');
        const uploadBox = document.querySelector('.upload-box');
        const uploadPreview = document.getElementById('uploadPreview');

        uploadPreview.innerHTML = '';  // 기존 내용을 초기화
        uploadBox.style.display = 'none';  // 업로드 박스를 숨김

        const p = document.createElement('p');

        const fileNameSpan = document.createElement('span');
        fileNameSpan.textContent = bfile;
        p.appendChild(fileNameSpan);

        const removeButton = document.createElement('button');
        removeButton.className = 'file-remove';
        removeButton.textContent = '삭제';
        removeButton.onclick = function() {
            fileInput.value = '';  // 파일 입력 초기화
            uploadPreview.innerHTML = '';  // 프리뷰 초기화
            uploadBox.style.display = '';  // 업로드 박스를 다시 표시
            $('#fileEditYn').val('Y');  // 파일이 수정되었음을 표시
            $('#uploadFileNm').text('');  // 파일명을 초기화
            $("#uploadFilePath").text('');
    		$('#editEfilePath').val('')
    		$('#editBfile').val('')
        };
        p.appendChild(removeButton);

        uploadPreview.appendChild(p);
    }

    $('#bcontent').prop('disabled', false);

	 
}
</script>

<body>
  <div class="conRight"></div>
  <div id="wrap">
    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
    <div class="contentWrap">
      <jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
      <div class="conRight">
        <div class="conHeader">
          <ul class="conHeaderCate">
            <li>공지</li>
            <li>공지사항</li>
            <li id="noticeType"></li>
          </ul>
        </div>

        <div class="contents">
          <h3 class="h3Tit">공지사항</h3>
          <div class="boxSt mt20">
            <div class="flex align-items-center">
              <div class="formTit flex-shrink0 width170px">제목</div>
              <div class="width100">
                <input type="text" id="btitle" class="inputStyle" maxlength="300" style="display:none">
                <div id="noticeTitleStr"></div>
              </div>
            </div>
            <div class="flex align-items-center mt20">
              <div class="formTit flex-shrink0 width170px">공지대상</div>
              <div class="flex width100">
                <input type="radio" name="bm2" value="ALL" id="bm2_1" class="radioStyle" onclick="bcoChange()" disabled="disabled">
                <label for="bm2_1">공통</label>
                <div>
                  <input type="radio" name="bm2" value="CUST" id="bm2_2" class="radioStyle" onclick="onAffiliateSelectOpen()" disabled="disabled">
                  <label for="bm2_2">계열사</label>
                  <p class="mt5" id="affiliate"></p>
                </div>
              </div>
            </div>
            <div class="flex align-items-center mt20">
              <div class="formTit flex-shrink0 width170px">작성자</div>
              <div class="width100" >
              	<p id="noticeUserName"></p>
              </div>
            </div>
            <div class="flex align-items-center mt20">
              <div class="formTit flex-shrink0 width170px">공지일시</div>
              <div class="width100" id="noticeDate"></div>
            </div>
            <div class="flex align-items-center mt20">
              <div class="formTit flex-shrink0 width170px">조회수</div>
              <div class="width100" id="noticeBcount"></div>
            </div>
            <div class="flex align-items-center mt20">
              <div class="formTit flex-shrink0 width170px">첨부파일</div>
              <div class="width100">
                <div id="noticeFileUpload" class="upload-boxWrap" style="display:none">
                  <div class="upload-box">
                    <input type="file" ref="uploadedFile" id="file-input">
                    <div class="uploadTxt">
                      <i class="fa-regular fa-upload"></i>
                      <div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제)<br>파일 최대 10MB (등록 파일 개수 최대 1개)</div>
                    </div>
                  </div>
                  <div id="uploadPreview" class="uploadPreview"></div>
                </div>
                <div id="uploadFileNm">
                </div>
                <input type="text" id="uploadFilePath" style="display:none;">
              </div>
            </div>
            <div class="flex mt20">
              <div class="formTit flex-shrink0 width170px">공지내용</div>
              <div class="width100">
                <textarea id="bcontent" class="textareaStyle notiBox overflow-y-auto" style="height:400px" disabled="disabled"></textarea>
              </div>
            </div>
          </div>

          <div class="text-center mt50"> 

            <a href="/notice/noticeList" class="btnStyle btnOutline" title="목록">목록</a>
            <a onclick="onEdit()" id="updateMove" class="btnStyle btnOutline" title="수정 이동" style="display:none">수정 이동</a>
			<a id="removeNotice" onclick="onDelPop()" class="btnStyle btnOutlineRed" title="삭제" style="display:none">삭제</a>
            <a id="savebtn" data-toggle="modal" data-target="#notiSave"class="btnStyle btnPrimary" title="저장" style="display:none">저장</a>
            
            <!--  <a href="group_sub02_1_2.html" class="btnStyle btnOutline" title="수정 이동">수정 이동</a>
            <a data-toggle="modal" data-target="#notiDel" class="btnStyle btnOutlineRed" title="삭제">삭제</a>-->
          </div>
        </div>
        <!-- //contents -->
      </div>
    </div>
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    	<input id="interrelatedListCodes" type="text" hidden="">
    	<input id="editEfilePath" type="text" hidden=""> 
    	<input id="editBfile" type="text" hidden=""> 
    	
      		<!-- 공지사항 저장 -->
		<div class="modal fade modalStyle" id="notiSave" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:420px">
				<div class="modal-content">
					<div class="modal-body">
						<a  class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<div class="alertText2">공지일시는 현재 처리되는 기준으로 저장됩니다.<br>저장 하시겠습니까?</div>
						<div class="modalFooter">
							<a  class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
							<a onClick="saveNotice()" data-dismiss="modal" class="modalBtnCheck" data-toggle="modal" title="저장">저장</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //공지사항 저장 -->
		<!-- 계열사 선택 -->
		<div class="modal fade modalStyle" id="AffiliateSelect" tabindex="-1" role="dialog" aria-hidden="true">
		  <div class="modal-dialog" style="width:100%; max-width:500px">
		    <div class="modal-content">
		      <div class="modal-body">
		        <a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
		        <h2 class="modalTitle">계열사 선택</h2>
		        <div class="modalTopBox">
		          <ul>
		            <li><div>공지 할 계열사를 선택해 주십시오.</div></li>
		          </ul>
		        </div>
		        <table class="tblSkin1 mt20">
		          <colgroup>
		            <col style="width:100px">
		            <col style="width:">
		          </colgroup>
		          <thead>
		            <tr>
		              <th>선택</th>
		              <th class="end">계열사</th>
		            </tr>
		          </thead>
		          <tbody id="affiliateTableBody">
		            <!-- Dynamic content will be inserted here by JavaScript -->
		          </tbody>
		        </table>
		        <div class="modalFooter">
		          <a class="modalBtnClose" data-dismiss="modal" title="닫기" style="cursor: pointer;">닫기</a>
		          <a onclick="onSelect()" class="modalBtnCheck" title="선택" style="cursor: pointer;">선택</a>
		        </div>
		      </div>				
		    </div>
		  </div>
		</div><!-- //계열사 선택 -->
		
		<!-- 공지사항 삭제 -->
		<div class="modal fade modalStyle" id="notiDel" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:420px">
				<div class="modal-content">
					<div class="modal-body">
						<a  class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<div class="alertText2">공지를 삭제합니다.<br>삭제 하시겠습니까?</div>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
							<a onclick="deleteNotice()" class="modalBtnCheck" data-toggle="modal" title="삭제">삭제</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //공지사항 삭제 -->
  </div>
  

</body>
</html>