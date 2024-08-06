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
		"/api/v1/bidComplete/list",
		{
			biNo : ''						//조회조건 : 입찰번호
		,	biName : ''						//조회조건 : 입찰명
		,	succBi : true					//조회조건 : 완료상태 - 입찰완료
		,	failBi : true					//조회조건 : 완료상태 - 유찰
		,	size : 10						//10개씩 보기
		,	page : 0						//클릭한 페이지번호
		,   startDate : '2023-08-07'                  //조회조건 : 입찰완료 - 시작일
		,   endDate : '2024-08-06'                 //조회조건 : 입찰완료 - 종료일
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