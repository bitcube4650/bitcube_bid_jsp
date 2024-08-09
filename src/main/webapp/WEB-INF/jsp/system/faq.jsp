<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
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
		                        <input type="text" id="title" class="inputStyle" maxlength="300"/>
		                    </div>
		                    <div class="sbTit mr30 ml50">구분</div>
		                    <div class="width200px">
		                        <select id="faqType" class="selectStyle">
		                            <option value="">전체</option>
		                            <option value="1">가입관련</option>
		                            <option value="2">입찰관련</option>
		                            <option value="3">인증서관련</option>
		                        </select>
		                    </div>
		                    <a href="#" id="searchBtn" class="btnStyle btnSearch">검색</a>
		                </div>
		            </div>
		
		            <div class="flex align-items-center justify-space-between mt40">
		                <div class="width100">
		                    전체 : <span id="totalElements" class="textMainColor"><strong>0</strong></span>건
		                    <select id="pageSize" class="selectStyle maxWidth140px ml20">
		                        <option value="10">10개씩 보기</option>
		                        <option value="20">20개씩 보기</option>
		                        <option value="30">30개씩 보기</option>
		                        <option value="50">50개씩 보기</option>
		                    </select>
		                </div>
		                <div class="flex-shrink0">
		                    <a href="#" id="addFaqBtn" class="btnStyle btnPrimary" data-toggle="modal" data-target="#faqReg" title="FAQ 등록">FAQ 등록</a>
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
		                    <!-- FAQ 데이터가 로드됩니다. -->
		                </tbody>
		            </table>
		
		            <div class="row mt40">
		                <div class="col-xs-12">
		                    <!-- 페이지네이션을 위한 공간 -->
		                    <div id="pagination"></div>
		                </div>
		            </div>
		        </div>
		
		        <!-- 팝업 창 코드가 필요하면 여기에 추가합니다. -->
		        <div id="faqPop" class="modal fade" tabindex="-1" role="dialog">
		            <div class="modal-dialog" role="document">
		                <div class="modal-content">
		                    <div class="modal-header">
		                        <h5 class="modal-title">FAQ 팝업</h5>
		                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
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
    </div>
</body>
</html>
