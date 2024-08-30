<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%
	Map<String, Object> params = (Map<String, Object>) request.getAttribute("params");
	String flag = CommonUtils.getString(params.get("flag"));
	String flagNm = "";
	if("save".equals(flag)) {
		flagNm = "등록";
	} else {
		flagNm = "수정";
	}
%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		$(document).ready(function() {
		});
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			<div class="conRight">
				<div class="conHeader">
					<ul class="conHeaderCate">
						<li>전자입찰</li>
						<li>입찰계획 <%=flagNm%> </li>
					</ul>
				</div>
				
				<div class="contents">
					<div class="formWidth">
						<jsp:include page="/WEB-INF/jsp/bid/bidSaveBasicInfo.jsp" />
						<jsp:include page="/WEB-INF/jsp/bid/bidSaveAddRegist.jsp" />
					</div>
						
					<div class="text-center mt50">
						<button title="목록" class="btnStyle btnOutline">목록 </button> 
						<button class="btnStyle btnPrimary">저장</button></div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
