<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html>
<%

	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	LocalDate today = LocalDate.now();						// 오늘
	LocalDate startDate = today.minusMonths(1);				// 1달전

	// 조회조건 default 값
	// 통계 > 입찰실적 상세내역 메뉴 이동 및 화면 새로고침시, default 값으로 조회
	String coInter = "";
	String startDay = startDate.format(formatter);
	String endDay = today.format(formatter);

	Map<String, Object> params = (Map<String, Object>) request.getAttribute("params");
	if (params != null) {
		// 통계 > 회사별 입찰실적 화면에서 선택한 회사정보(회사코드, 입찰완료시작일, 입찰완료종료일) 
		coInter = (String) params.get("coInter");
		startDay = (String) params.get("startDay");
		endDay = (String) params.get("endDay");
	}
%>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			<div class="conRightWrap">
				<div class="conRight">
					<div class="conHeader">
						<ul class="conHeaderCate">
							<li>통계</li>
							<li>입찰실적 상세내역</li>
						</ul>
					</div>
					<div class="contents">
						<div class="conTopBox">
							<ul class="dList">
								<li>
									<div>
										조회기간 입찰완료일 기준으로 각 계열사의 상세 입찰 실적을 나타냅니다.
									</div>
								</li>
							</ul>
						</div>
						<div class="searchBox mt20">
							<div class="flex align-items-center">
								<div class="sbTit width100px">입찰완료일</div>
								<div class="flex align-items-center width300px">
									<input type="text" id="startDay" class="datepicker inputStyle" readonly="readonly">
									<span style="margin: 0px 10px;">~</span>
									<input type="text" id="endDay" class="datepicker inputStyle" readonly="readonly">
								</div>
							</div>
							<div class="flex align-items-center height50px mt10">
								<div class="sbTit width100px">품목</div>
								<div class="flex align-items-center">
									<input type="text" placeholder="우측 검색 버튼을 클릭해 주세요" class="inputStyle width300px readonly" readonly="readonly">
									<input type="hidden" id="srcCustType"/>
									<a data-toggle="modal" data-target="#itemPop" title="조회" class="btnStyle btnSecondary ml10">조회</a>
									<button type="button" title="삭제" class="btnStyle btnOutline">삭제</button>
								</div>
								<div class="sbTit mr30 ml50">계열사</div>
								<div class="flex align-items-center width280px">
									<select class="selectStyle" id="srcCoInter">
										<option value="">전체</option>
									</select>
								</div>
								<a class="btnStyle btnSearch" onclick="onSearch(0)">검색</a>
							</div>
						</div>
						<div class="flex align-items-center justify-space-between mt40">
							<div class="width100">
								전체 : <span class="textMainColor"><strong id="listCnt"></strong></span>건
								<select class="selectStyle maxWidth140px ml20" id="pageSize" onchange="onSearch(0)">
									<option value="10">10개씩 보기</option>
									<option value="20">20개씩 보기</option>
									<option value="30">30개씩 보기</option>
									<option value="50">50개씩 보기</option>
								</select>
							</div>
							<div class="flex-shrink0">
								<a title="엑셀 다운로드" class="btnStyle btnPrimary" onclick="fnExcelDown()">엑셀 다운로드 <i class="fa-light fa-arrow-down-to-line ml10"></i></a>
							</div>
						</div>
						<div class="tblScroll">
							<table class="tblSkin1 mt10" id="listTbl">
								<colgroup>
									<col>
								</colgroup>
								<thead>
									<tr>
										<th>입찰번호</th>
										<th>입찰명</th>
										<th>입찰 품명</th>
										<th>예산금액</th>
										<th>낙찰금액</th>
										<th>계약금액</th>
										<th>참여업체수</th>
										<th>낙찰사</th>
										<th>제출시작일</th>
										<th>제출마감일</th>
										<th>투찰최고가(1)</th>
										<th>투찰최저가(2)</th>
										<th>편차(1)-(2)</th>
										<th class="end">재입찰횟수</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
						<div class="row mt40">
							<div class="col-xs-12">
								<!-- 페이지네이션을 위한 공간 -->
								<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
<script>
	$(function(){
		// datepicker
		$("#startDay").datepicker();
		$("#endDay").datepicker();
		
		$('#startDay').datepicker('setDate', "<%=startDay%>");
		$('#endDay').datepicker('setDate', "<%=endDay%>");
		
		// 계열사 리스트 조회
		fnSetCoInter();
	});
	
	// 계열사 리스트 조회
	function fnSetCoInter(){
		$.post(
			'/api/v1/statistics/coInterList',
			{}
		).done(function(arg){
			if(arg.code == "ERROR"){
				Swal.fire('', arg.msg, 'error');
			} else {
				const list = arg.data;
				if(list.length > 0){
					for(let i = 0; i < list.length; i++){
						$("#srcCoInter").append($("<option value='"+list[i].interrelatedCustCode+"'>"+list[i].interrelatedNm+"</option>"))
					}
				}
			}
			$("#srcCoInter").val("<%=coInter%>");

			// 조회
			onSearch(0);
		});
	}
	
	function onSearch(page){
		$.post(
			'/api/v1/statistics/biInfoDetailList',
			{
				page		: page,
				startDay	: $("#startDay").val(),
				endDay		: $("#endDay").val(),
				srcCoInter	: $("#srcCoInter").val(),
				size		: $("#pageSize").val()
			}
		).done(function(arg){
			$("#listCnt").text(0);
			$("#listTbl tbody").empty();
			
			if(arg.code == "ERROR") {
				$("#listTbl tbody").append("<tr><td colspan='14'>조회된 데이터가 없습니다.</td></tr>");
				Swal.fire('', arg.msg, 'error');
			} else {
				let result = arg.data;
				
				// 페이징 처리
				updatePagination(result);
				
				$("#listCnt").text(result.totalElements);
				if(result.totalElements == 0) {
					$("#listTbl tbody").append("<tr><td colspan='14'>조회된 데이터가 없습니다.</td></tr>");
				} else {
					let text = "";
	 				for(let i = 0; i < result.content.length - 1; i++){
	 					text += "<tr>";
	 					text += "	<td class='text-left'>"+result.content[i].biNo+"</td>";
	 					text += "	<td class='text-left'>"+result.content[i].biName+"</td>";
	 					text += "	<td class='text-left'>"+result.content[i].itemName+"</td>";
	 					text += "	<td class='text-right'>"+result.content[i].bdAmt.toLocaleString()+"</td>";
	 					text += "	<td class='text-right'>"+result.content[i].succAmt.toLocaleString()+"</td>";
							text += "	<td class='text-right'>"+result.content[i].realAmt.toLocaleString()+"</td>";
	 					text += "	<td class='text-right'>"+result.content[i].custCnt.toLocaleString()+"</td>";
	 					text += "	<td>"+result.content[i].custName+"</td>";
	 					text += "	<td>"+result.content[i].estStartDate+"</td>";
	 					text += "	<td>"+result.content[i].estCloseDate+"</td>";
	 					text += "	<td class='text-right'>"+result.content[i].esmtAmtMax.toLocaleString()+"</td>";
							text += "	<td class='text-right'>"+result.content[i].esmtAmtMin.toLocaleString()+"</td>";
	 					text += "	<td class='text-right'>"+result.content[i].esmtAmtDev.toLocaleString()+"</td>";
	 					text += "	<td class='text-right end'>"+result.content[i].reBidCnt.toLocaleString()+"</td>";
	 					text += "</tr>";
	 				}
					$("#listTbl tbody").html(text)
				}
			}
		});
	}
	
	// 엑셀 다운로드
	function fnExcelDown(){
		let coInterArr = new Array();					// 조회할 계열사코드값을 담을 array
		let srcCoInter = $("#srcCoInter").val();		// 조회조건 중 '계열사' 선택 값
		
		if(srcCoInter != ""){
			coInterArr.push(srcCoInter)
		} else {
			$.post(
				'/api/v1/statistics/coInterList',
				{}
			).done(function(arg){
				if(arg.code == "OK"){
					let list = arg.data;
					if(list.length > 0){
						for(let i = 0; i < list.length; i++){
							coInterArr.push(list[i].interrelatedCustCode)
						}
					}
				}
			});
		}
		
		var time = Ft.formatDate(new Date(), "yyyy_mm_dd");
		var params = {
			"startDay": $("#startDay").val(),
			"endDay": $("#endDay").val(),
			"fileName":"입찰실적_상세내역_" + time,
			"dataJson" : [
				{'header' : "입찰번호",		'column' : "biNo"},
				{'header' : "입찰명",			'column' : "biName"},
				{'header' : "입찰 품명",		'column' : "itemName"},
				{'header' : "예산금액",		'column' : "bdAmt"},
				{'header' : "낙찰금액",		'column' : "succAmt"},
				{'header' : "계약금액",		'column' : "realAmt"},
				{'header' : "참여업체수",		'column' : "custCnt"},
				{'header' : "낙찰사",			'column' : "custName"},
				{'header' : "제출시작일",		'column' : "estStartDate"},
				{'header' : "제출마감일",		'column' : "estCloseDate"},
				{'header' : "투찰최고가(1)",	'column' : "esmtAmtMax"},
				{'header' : "투찰최저가(2)",	'column' : "esmtAmtMin"},
				{'header' : "편차(1)-(2)",	'column' : "esmtAmtDev"},
				{'header' : "재입찰횟수",		'column' : "reBidCnt"}
			],
			"coInters" : coInterArr,
			"itemCode" : $("#srcCustType").val(),
			"excel" : "Y"
		};
		
		$.ajax({
			url: "/api/v1/statistics/biInfoDetailList/excel",
			type: "POST",
			data: JSON.stringify(params),
			contentType: "application/json; charset=utf-8",
			// 응답을 Blob으로 처리하기 위해 xhrFields 사용
			xhrFields: {
				responseType: 'blob'
			},
			success: function(response) {
				if (response) {
					const url = window.URL.createObjectURL(new Blob([response]));
					const link = document.createElement("a");
					link.href = url;
					link.setAttribute("download", params.fileName + ".xlsx");
					document.body.appendChild(link);
					link.click();
					window.URL.revokeObjectURL(url);
				} else {
					Swal.fire('', '엑셀 다운로드 중 오류가 발생했습니다.', 'error');
				}
			},
			error: function(xhr, status, error) {
				console.error("Error:", error);
				Swal.fire('', '엑셀 다운로드 중 오류가 발생했습니다.', 'error');
			}
		});
	}
</script>
</html>
