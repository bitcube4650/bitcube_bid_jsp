<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
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
							<li>입찰현황</li>
						</ul>
					</div>
					<div class="contents">
						<div class="conTopBox">
							<ul class="dList">
								<li><div>조회결과의 등록업체 수는 조회기간과 관계없이 각사 별 등록업체 수를 나타냅니다.</div></li>
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
								<div class="sbTit width80px ml50">계열사</div>
								<div class="flex align-items-center width280px">
									<select class="selectStyle" id="srcCoInter">
										<option value="">전체</option>
									</select>
								</div>
								<a class="btnStyle btnSearch" onclick="fnSearch()">검색</a>
							</div>
						</div>
						<div class="flex align-items-center justify-space-between mt40">
							<div class="width100"></div>
							<div class="flex flex-shrink0">
								<p class="align-self-end mr20"></p>
								<a title="엑셀 다운로드" class="btnStyle btnPrimary" onclick="fnExcelDown()">엑셀 다운로드 <i
									class="fa-light fa-arrow-down-to-line ml10"></i></a>
							</div>
						</div>
						<table class="tblSkin1 mt10" id="listTbl">
							<colgroup>
								<col>
								<col style="width: 7%;">
								<col style="width: 10%;">
								<col style="width: 7%;">
								<col style="width: 10%;">
								<col style="width: 7%;">
								<col style="width: 7%;">
								<col style="width: 10%;">
							</colgroup>
							<thead>
								<tr>
									<th rowspan="2">회사명</th>
									<th colspan="2">입찰계획</th>
									<th colspan="2">입찰진행</th>
									<th colspan="3">입찰완료(유찰제외)</th>
									<th rowspan="2">등록 업체수</th>
									<th rowspan="2" class="end">기타</th>
								</tr>
								<tr>
									<th>건수</th>
									<th>예산금액</th>
									<th>건수</th>
									<th>예산금액</th>
									<th>건수</th>
									<th>낙찰금액</th>
									<th>업체수/건수</th>
								</tr>
							</thead>
							<tbody></tbody>
							<tfoot></tfoot>
						</table>
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
		
		$('#startDay').datepicker('setDate', '-1M');			// 1달 전
		$('#endDay').datepicker('setDate', 'today');			// 오늘
		
		// 계열사 리스트 조회
		fnSetCoInter();
	});
	
	function fnSetCoInter(){
		$.post(
			'/api/v1/statistics/coInterList',
			{}
		).done(
			function(arg){
 				if(arg.code == "ERROR"){
 					Swal.fire('', arg.msg, 'error');
 				} else {
	 				let list = arg.data;
 					if(list.length > 0){
 						for(let i = 0; i < list.length; i++){
 							$("#srcCoInter").append($("<option value='"+list[i].interrelatedCustCode+"'>"+list[i].interrelatedNm+"</option>"))
 						}
 					}
 				}
 				// 입찰현황 리스트 조회
 				fnSearch();
			}
		);
	}
	
	function fnSearch(){
		$.post(
			'/api/v1/statistics/bidPresentList',
			{	
				startDay	: $("#startDay").val(),
				endDay		: $("#endDay").val(),
				srcCoInter	: $("#srcCoInter").val()
			}
		).done(
			function(arg){
 				$("#listTbl tbody").empty();
 				$("#listTbl tfoot").empty();
 				
 				if(arg.code == "ERROR") {
 					$("#listTbl tbody").append("<tr><td colspan='10'>조회된 데이터가 없습니다.</td></tr>");
 					Swal.fire('', arg.msg, 'error');
 				} else {
					let list = arg.data;
					if(list.length <= 0) {
						$("#listTbl tbody").append("<tr><td colspan='10'>조회된 데이터가 없습니다.</td></tr>");
					} else {
						let text = "";
						// 마지막 row는 합계이므로 마지막 row를 제외하고 tbody에 append 처리
						for(let i = 0; i < list.length - 1; i++){
							text += "<tr>";
							text += "	<td class='text-left'>"+list[i].interrelatedNm+"</td>";
							text += "	<td class='text-right'>"+list[i].planCnt.toLocaleString()+"</td>";
							text += "	<td class='text-right'>"+list[i].planAmt.toLocaleString()+"</td>";
							text += "	<td class='text-right'>"+list[i].ingCnt.toLocaleString()+"</td>";
							text += "	<td class='text-right'>"+list[i].ingAmt.toLocaleString()+"</td>";
							text += "	<td class='text-right'>"+list[i].succCnt.toLocaleString()+"</td>";
							text += "	<td class='text-right'>"+list[i].succAmt.toLocaleString()+"</td>";
							text += "	<td class='text-right'>"+list[i].custCnt.toLocaleString()+"</td>";
							text += "	<td class='text-right'>"+list[i].regCustCnt.toLocaleString()+"</td>";
							text += "	<td className='end'></td>";
							text += "</tr>";
						}
						$("#listTbl tbody").html(text)
						
						// 마지막 row는 합계이므로 tfoot에 추가
						let sumHtml = "";
						sumHtml += "<tr>";
						sumHtml += "	<th class='text-left'>"+list[list.length-1].interrelatedNm+"</th>";
						sumHtml += "	<th class='text-right'>"+list[list.length-1].planCnt.toLocaleString()+"</th>";
						sumHtml += "	<th class='text-right'>"+list[list.length-1].planAmt.toLocaleString()+"</th>";
						sumHtml += "	<th class='text-right'>"+list[list.length-1].ingCnt.toLocaleString()+"</th>";
						sumHtml += "	<th class='text-right'>"+list[list.length-1].ingAmt.toLocaleString()+"</th>";
						sumHtml += "	<th class='text-right'>"+list[list.length-1].succCnt.toLocaleString()+"</th>";
						sumHtml += "	<th class='text-right'>"+list[list.length-1].succAmt.toLocaleString()+"</th>";
						sumHtml += "	<th class='text-right'>"+list[list.length-1].custCnt.toLocaleString()+"</th>";
						sumHtml += "	<th class='text-right'>"+list[list.length-1].regCustCnt.toLocaleString()+"</th>";
						sumHtml += "	<th class='end'></th>";
						sumHtml += "</tr>";
						$("#listTbl tfoot").html(sumHtml)
					}
				}
			}
		)
	}

	var loginInfo = JSON.parse(localStorage.getItem("loginInfo"));
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
			"fileName":"입찰현황_" + time,
			"dataJson" : [
				{'header' : "회사명",						'column' : "interrelatedNm"},
				{'header' : "건수(입찰계획)",				'column' : "planCnt"},
				{'header' : "예산금액(입찰계획)",			'column' : "planAmt"},
				{'header' : "건수(입찰진행)",				'column' : "ingCnt"},
				{'header' : "예산금액(입찰진행)",			'column' : "ingAmt"},
				{'header' : "건수(입찰완료(유찰제외))",		'column' : "succCnt"},
				{'header' : "예산금액(입찰완료(유찰제외))",	'column' : "succAmt"},
				{'header' : "업체수/건수(입찰완료(유찰제외))",	'column' : "custCnt"},
				{'header' : "등록 업체수",					'column' : "regCustCnt"},
				{'header' : "기타",						'column' : "temp"}
			],
			"coInters" : coInterArr,
			"userId" : loginInfo.loginId,
			"userAuth" : loginInfo.userAuth
		};
		
		$.ajax({
			url: "/api/v1/statistics/bidPresentList/excel",
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
