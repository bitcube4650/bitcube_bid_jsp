<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<title>Insert title here</title>
<script>

function fnTest(){
	location.href="/api/v1/move?viewName=system/temp&p=1";
	
}

function fnTest2(){
	$.post(
		"/api/v1/test2",
		{
			'test':'test11'
		},
		function(arg){
			console.log(arg);
		},
		"json"
	);
}

</script>
</head>
<body>
<a href="javascript:fnTest()">generalController 페이지 이동 방법</a>
<a href="javascript:fnTest2()">ajax 데이터 가져오는 법</a>
</body>
</html>