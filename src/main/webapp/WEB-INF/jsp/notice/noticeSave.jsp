<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/common.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	
    const loginInfo = JSON.parse(localStorage.getItem("loginInfo"));
	console.log(loginInfo)
	console.log(loginInfo.userName)
	$('#userName').text(loginInfo.userName)
		
    $.post(
        "/api/v1/login/interrelatedList",
        function(response) {
            if (response.length > 0) {
                const tableBody = document.getElementById('affiliateTableBody');
                
                if (tableBody) {
                    tableBody.innerHTML = '';  // Clear existing content

                    response.forEach((affiliate, index) => {
                        const row = document.createElement('tr');

                        // Create checkbox cell
                        const checkboxCell = document.createElement('td');
                        const checkbox = document.createElement('input');
                        checkbox.type = 'checkbox';
                        checkbox.className = 'checkStyle';
                        checkbox.id = 'ck' + index;
                        checkbox.name = 'interrelatedListCheck' 
                        checkbox.value = affiliate.interrelatedCustCode;
                        const label = document.createElement('label');
                        label.setAttribute('for', 'ck' + index);
                        checkboxCell.appendChild(checkbox);
                        checkboxCell.appendChild(label);

                        // Create name cell
                        const nameCell = document.createElement('td');
                        nameCell.className = 'text-left end';
                        const nameLabel = document.createElement('label');
                        nameLabel.setAttribute('for', 'ck' + index);
                        nameLabel.className = 'fontweight-400';
                        nameLabel.textContent = affiliate.interrelatedNm;
                        nameCell.appendChild(nameLabel);

                        // Append cells to row
                        row.appendChild(checkboxCell);
                        row.appendChild(nameCell);

                        // Append row to table body
                        tableBody.appendChild(row);
                    });
                } else {
                    console.error("affiliateTableBody element not found.");
                }
            }
        },
        "json"
    );
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
            };
            p.appendChild(removeButton);

            uploadPreview.appendChild(p);
        }
    });
    
});

function onSelect(){
    let checkedValues = [];
    $('input[name="interrelatedListCheck"]:checked').each(function() {
        checkedValues.push($(this).val());
    });
    console.log(checkedValues)
}

function saveNotice(){
	let formData = new FormData()
	const fileInput = document.getElementById('file-input');
	const file = fileInput.files[0];
	
	const loginInfo = JSON.parse(localStorage.getItem("loginInfo"));
    let checkedValues = [];
    $('input[name="interrelatedListCheck"]:checked').each(function() {
        checkedValues.push($(this).val());
    });
    
    const bco = $('input[name="bm2"]:checked').val()
	const params = {
		btitle : $('#btitle').val(),
		bcontent : $('#bcontent').val(),
		bco : bco,
		buserid : loginInfo.userId,
	}
    if(bco == 'CUST'){
    	params.interrelatedCustCodeArr = checkedValues
    }
    
    if(file){
    	formData.append('file', file);
    }

	formData.append('data', JSON.stringify(params));
	
	    $.ajax({
        url: '/api/v1/notice/insertNotice',
        type: 'POST',
        data: formData,
        contentType: false, 
        processData: false,  
        success: function(response) {
            console.log('Response:', response);
        },
        error: function(xhr, status, error) {
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
            <li>공지사항 등록/수정</li>
          </ul>
        </div>

        <div class="contents">
          <h3 class="h3Tit">공지사항</h3>
          <div class="boxSt mt20">
            <div class="flex align-items-center">
              <div class="formTit flex-shrink0 width170px">제목</div>
              <div class="width100">
                <input type="text" id="btitle" class="inputStyle" maxlength="300">
              </div>
            </div>
            <div class="flex align-items-center mt20">
              <div class="formTit flex-shrink0 width170px">공지대상</div>
              <div class="flex width100">
                <input type="radio" name="bm2" value="ALL" id="bm2_1" class="radioStyle" checked="">
                <label for="bm2_1">공통</label>
                <div data-toggle="modal" data-target="#AffiliateSelect">
                  <input type="radio" name="bm2" value="CUST" id="bm2_2" class="radioStyle">
                  <label for="bm2_2">계열사</label>
                  <p class="mt5" id="affiliate"></p>
                </div>
              </div>
            </div>
            <div class="flex align-items-center mt20">
              <div class="formTit flex-shrink0 width170px">작성자</div>
              <div class="width100" >
              	<p id="userName"></p>
              </div>
            </div>
            <div class="flex align-items-center mt20">
              <div class="formTit flex-shrink0 width170px">공지일시</div>
              <div class="width100">등록 또는 수정한 날짜로 저장됩니다.</div>
            </div>
            <div class="flex align-items-center mt20">
              <div class="formTit flex-shrink0 width170px">첨부파일</div>
              <div class="width100">
                <div class="upload-boxWrap">
                  <div class="upload-box">
                    <input type="file" ref="uploadedFile" id="file-input">
                    <div class="uploadTxt">
                      <i class="fa-regular fa-upload"></i>
                      <div>클릭 혹은 파일을 이곳에 드롭하세요.(암호화 해제)<br>파일 최대 10MB (등록 파일 개수 최대 1개)</div>
                    </div>
                  </div>
                  <div id="uploadPreview" class="uploadPreview"></div>
                </div>
              </div>
            </div>
            <div class="flex mt20">
              <div class="formTit flex-shrink0 width170px">공지내용</div>
              <div class="width100">
                <textarea id="bcontent" class="textareaStyle notiBox overflow-y-auto" style="height:400px"></textarea>
              </div>
            </div>
          </div>

          <div class="text-center mt50">
            <a href="/notice/noticeList" class="btnStyle btnOutline" title="목록">목록</a>
            <a  data-toggle="modal" data-target="#notiSave"class="btnStyle btnPrimary" title="저장">저장</a>
            
            <!--  <a href="group_sub02_1_2.html" class="btnStyle btnOutline" title="수정 이동">수정 이동</a>
            <a data-toggle="modal" data-target="#notiDel" class="btnStyle btnOutlineRed" title="삭제">삭제</a>-->
          </div>
        </div>
        <!-- //contents -->
      </div>
    </div>
    <jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    
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
		
  </div>
  

</body>
</html>