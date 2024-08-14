<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/jsp/common.jsp" %>


<script type="text/javascript">
/*
	function search(page) {
		if (page >= 0) this.searchParams.page = page;
		this.retrieve();
	},
	function async retrieve() {
		try {
			this.$store.commit('loading');
			this.$store.commit('searchParams', this.searchParams);
			const response = await this.$http.post('/api/v1/faq/faqList', this.searchParams);
			this.listPage = response.data;
			this.$store.commit('finish');
		} catch(err) {
			console.log(err)
			this.$store.commit('finish');
		}
	},
	function goDetail(data){//상세정보 데이터 반영
	    this.detail = Object.assign({}, data);
	    this.detail.updateInsert = 'update';
	},
	function goInsert(){//등록전 초기화
	    this.detail = { title : '', faqType : '1', answer : '', updateInsert : 'insert'};
	},
	function save(){//저장
	    
	    var response = this.$http.post('/api/v1/faq/save', this.detail)
							    .then(response => {
	                                this.$swal({
	                                    type: 'success',
	                                    text: '저장되었습니다.'
	                                })
									$('#faqReg').modal('hide');
	                                $('#faqConfirm').modal('hide');
	                                this.retrieve();
								});
	                            
	},
	function deleteFaq(){//faq 삭제
	    var response = this.$http.post('/api/v1/faq/delete', this.detail)
							    .then(response => {
	                                this.$swal({
	                                    type: 'success',
	                                    text: '삭제되었습니다.'
	                                })
									$('#faqConfirm').modal('hide');
	                                $('#faqReg').modal('hide');
	                                this.retrieve();
								});
	    
	},
	function valueCheck(){//값 체크
	
		if(this.detail.title == '' || this.detail.title == null){
	        this.$swal({
	            type: 'warning',
	            text: '제목을 입력해주세요.'
	        })
			return true;
		}
	
		if(this.detail.answer == '' || this.detail.answer == null){
	        this.$swal({
	            type: 'warning',
	            text: '내용을 입력해주세요.'
	        })
			return true;
		}
	
	    return false;
	},
	function openConfirm(word){//삭제 및 저장시 확인창 띄우기
	
	    this.saveDelete = word;
	
	    if(word == 'delete'){//삭제하는 경우
	
	    }else{//수정 및 등록하는 경우
	
	        if(this.valueCheck()){//값체크
	            return false;
	        }
	    }
	
	    $('#faqReg').modal('hide');
	    $('#faqConfirm').modal('show');
	},
	cancelConfirm(){//삭제 및 저장을 취소할 경우 다시 상세창 띄우기
	    $('#faqReg').modal('show');
	},
	limitText() {//faq 답변 글자수 제한
	    if (this.detail.answer.length > 2000) {
	        // 최대 길이 초과 시 입력을 막음
	        this.detail.answer = this.detail.answer.slice(0, 2000);
	    }
	}
	*/
</script>



<body>
	<!-- 본문 -->
    <div class="conRight">
        <!-- conHeader -->
        <div class="conHeader">
            <ul class="conHeaderCate">
                <li>공지</li>
                <li>FAQ</li>
            </ul>
        </div>
        <!-- //conHeader -->
        <!-- contents -->
        <div class="contents">

            <!-- searchBox -->
            <div class="searchBox">
                <div class="flex align-items-center">
                    <div class="sbTit mr30">제목</div>
                    <div class="width200px">
                        <input type="text" class="inputStyle" placeholder="" maxlength="300">
                    </div>
                    <div class="sbTit mr30 ml50">구분</div>
                    <div class="width200px">
                        <select class="selectStyle">
                            <option value="">전체</option>
                            <option value="1">가입관련</option>
                            <option value="2">입찰관련</option>
                            <option value="3">인증서관련</option>
                        </select>
                    </div>
                    <a class="btnStyle btnSearch">검색</a>
                </div>
            </div>
            <!-- //searchBox -->

            <div class="flex align-items-center justify-space-between mt40">
                <div class="width100">
                    전체 : <span class="textMainColor"><strong> 0</strong></span>건
                    <select class="selectStyle maxWidth140px ml20">
                        <option value="10">10개씩 보기</option>
                        <option value="20">20개씩 보기</option>
                        <option value="30">30개씩 보기</option>
                        <option value="50">50개씩 보기</option>
                    </select>
                </div>
                <div class="flex-shrink0">
                    <a data-toggle="modal" data-target="#faqReg" class="btnStyle btnPrimary" title="FAQ 등록">FAQ 등록</a>
                </div>
            </div>
            <table class="tblSkin1 mt10">
                <colgroup>
                    <col style="width:15%">
                    <col style="">
                    <col style="width:15%">
                    <col style="width:15%">
                </colgroup>
                <thead>
                    <tr>
                        <th>구분</th>
                        <th>제목</th>
                        <th>등록자</th>
                        <th class="end">등록일시</th>
                    </tr>
                </thead>
                <tbody>
                    <tr >
                        <td>1</td>
                        <td class="text-left"><a data-toggle="modal" data-target="#faqReg" class="textUnderline notiTitle" title="FAQ 자세히 보기">2</a></td>
                        <td>3</td>
                        <td class="end">4</td>
                    </tr>
                </tbody>
            </table>

            <!-- pagination -->
            <div class="row mt40">
                <div class="col-xs-12">

                </div>
            </div>
            <!-- //pagination -->

        </div>
        <!-- //contents -->

        <!-- faq confirm -->
		<div class="modal fade modalStyle" id="faqConfirm" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:420px">
				<div class="modal-content">
					<div class="modal-body">
						<a  class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<div class="alertText2">FAQ를 저장 하시겠습니까?</div>
                        <div class="alertText2">FAQ를 삭제합니다.<br>삭제 하시겠습니까?</div>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
                            <a  class="modalBtnCheck" data-toggle="modal" title="저장">저장</a>
							<a class="modalBtnCheck" data-toggle="modal" title="삭제">삭제</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //faq confirm -->

        <!-- FAQ 상세 -->
        <div class="modal fade modalStyle" id="faqReg" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" style="width:100%; max-width:600px">
                <div class="modal-content">
                    <div class="modal-body">
                        <a  class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
                        <h2 class="modalTitle">FAQ 상세</h2>
                        <div class="flex align-items-center mt20">
                            <div class="formTit flex-shrink0 width150px">FAQ 제목 <span class="star">*</span></div>
                            <div class="width100">
                                <input type="text"  class="inputStyle" placeholder="" value="발신번호를 선택할 수 없습니다." maxlength="2000">
                            </div>
                        </div>
                        <div class="flex align-items-center mt20">
                            <div class="formTit flex-shrink0 width150px">FAQ 구분 <span class="star">*</span></div>
                            <div class="flex align-items-center width100">
                                <input type="radio" name="bm2" value="1" id="bm2_1" class="radioStyle"><label for="bm2_1">가입관련</label>
                                <input type="radio" name="bm2" value="2" id="bm2_2" class="radioStyle"><label for="bm2_2">입찰관련</label>
                                <input type="radio" name="bm2" value="3" id="bm2_3" class="radioStyle"><label for="bm2_3">인증서관련</label>
                            </div>
                        </div>
                        <div class="flex mt20">
                            <div class="formTit flex-shrink0 width150px">FAQ 내용 <span class="star">*</span></div>
                            <div class="width100">
                                <textarea @input="limitText" class="textareaStyle overflow-y-scroll height150px" placeholder=""></textarea>
                            </div>
                        </div>
                        <div class="modalFooter">
                            <a  class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
                            <a class="deleteBtn" data-toggle="modal" title="저장">삭제</a>
                            <a class="modalBtnCheck" data-toggle="modal" title="저장">저장</a>
                        </div>
                    </div>				
                </div>
            </div>
        </div>
        <!-- //FAQ 상세 -->
    </div>
</body>
</html>