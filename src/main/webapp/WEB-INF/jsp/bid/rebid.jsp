<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.math.RoundingMode"%>
<%@ page import="bitcube.framework.ebid.etc.util.Constances" %>
<%@ page import="bitcube.framework.ebid.dto.UserDto" %>
<%@ page import="bitcube.framework.ebid.etc.util.CommonUtils" %>
<%
	UserDto							userDto = (UserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String							userId = userDto.getLoginId();
	String							reCustCodeStr = CommonUtils.getString(request.getAttribute("reCustCode"));
	Map<String, Object>				data = (Map<String, Object>) request.getAttribute("biInfo");
	ArrayList<Map<String, Object>>	custList = new ArrayList<Map<String, Object>>();
									custList = (ArrayList) data.get("custList");
	ObjectMapper					objectMapper = new ObjectMapper();
	String							jsonCustList = objectMapper.writeValueAsString(custList);
	String							jsonData = objectMapper.writeValueAsString(data);
%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		$(document).ready(function() {
			fnInit();
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
						<li>재입찰</li>
					</ul>
				</div>
				
				<div class="contents">
					
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
