<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<head>
	<meta charset="UTF-8">
	<title>비트큐브 전자입찰</title>
</head>
<%-- <script src="${pageContext.request.contextPath}/resources/jquery.min.js"></script> --%>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/3.3.2/bootstrap.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/bootstrap/3.3.2/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.3/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/common.css">
<link href="${pageContext.request.contextPath}/resources/fontawesome-pro-6.1.1-web/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="${pageContext.request.contextPath}/resources/datepicker-ko.js"></script>
<script src="${pageContext.request.contextPath}/resources/api/filters.js"></script>
<script src="${pageContext.request.contextPath}/resources/jquery.blockUI.js"></script>
<script src="${pageContext.request.contextPath}/resources/utils.js"></script>

<script>
$(document).ready(function() {
    // AJAX 요청이 시작되기 전에 BlockUI 실행
    $.ajaxSetup({
        beforeSend: function() {
        	$.blockUI();
        },
        complete: function() {
            // AJAX 요청이 완료되면 BlockUI 해제
            $.unblockUI();
        },
        error: function(request, status, error) {
        	let param = {}
        	try{
        		param = JSON.parse(request.responseText);
        	}catch(error){
        		console.log("json parse error");
        	}
			Swal.fire({
				title: '',			  // 타이틀
				text: param.error == undefined || param.error == null ? '문제가 발생하였습니다.' : param.error,  // 내용
				icon: 'error',						// success / error / warning / info / question
			}).then((result) => {
				if(request.status === 999){
					location.href="/";
				}
			});
		}
    });
})
</script>