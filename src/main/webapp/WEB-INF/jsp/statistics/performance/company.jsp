<%@ page contentType="text/html;charset=UTF-8" language="java"%>
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
								<li>
									<div>
										조회기간 입찰완료일 기준으로 각 계열사의 입찰 실적을 나타냅니다.
									</div>
								</li>
								<li>
									<div>
										통계 실적 Data는 사용권한이 시스템 관리자 일 경우 모든 계열사, 감사사용자일 경우 선택된 계열사를 대상으로 합니다.(감사사용자 계열사 선택은 시스템 관리자가 관리합니다.)
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
								<div class="sbTit width80px ml50">계열사</div>
								<div class="flex align-items-center width280px">
									<select class="selectStyle" id="srcCoInter">
										<option value="">전체</option>
									</select>
								</div>
								<a class="btnStyle btnSearch" onclick="onSearch()">검색</a>
							</div>
						</div>
						<div class="flex align-items-center justify-space-between mt40">
							<div class="width100">
								전체 : <span class="textMainColor"><strong id="listCnt"></strong></span>건
							</div>
							<div class="flex-shrink0">
								<a title="엑셀 다운로드" class="btnStyle btnPrimary" onclick="fnExcelDown()">엑셀 다운로드 <i class="fa-light fa-arrow-down-to-line ml10"></i></a>
							</div>
						</div>
						<table class="tblSkin1 mt10" id="listTbl">
							<colgroup>
								<col>
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 15%;">
								<col style="width: 15%;">
								<col style="width: 10%;">
							</colgroup>
							<thead>
								<tr>
									<th>회사명</th>
									<th>입찰건수</th>
									<th>예산금액(1)</th>
									<th>낙찰금액(2)</th>
									<th>차이(1)-(2)</th>
									<th class="end">비고</th>
								</tr>
							</thead>
							<tbody id="listTbody"></tbody>
							<tfoot id="listTfoot"></tfoot>
						</table>
						<div class="row mt40">
							<div class="col-xs-12">
								<!-- 페이지네이션을 위한 공간 -->
								<div id="pagination"></div>
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
		// datepicker 세팅
		$("#startDay").datepicker();
		$("#endDay").datepicker();
		
		$('#startDay').datepicker('setDate', '-1M');		// 1달전
		$('#endDay').datepicker('setDate', 'today');		// 오늘
		
		// 계열사 리스트 조회
		fnSetCoInter();
		
		// 입찰실적 리스트 조회
		onSearch();
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
		});
	}
	
	function onSearch(){
		$.post(
			'/api/v1/statistics/biInfoList',
			{	
				startDay	: $("#startDay").val(),
				endDay		: $("#endDay").val(),
				srcCoInter	: $("#srcCoInter").val()
			}
		).done(function(arg){
				$("#listCnt").text(0);
				$("#listTbl tbody").empty();
				$("#listTbl tfoot").empty();
				
				if(arg.code == "ERROR") {
					$("#listTbl tbody").append("<tr><td colspan='6'>조회된 데이터가 없습니다.</td></tr>");
					Swal.fire('', arg.msg, 'error');
				} else {
 				let list = arg.data;
 				$("#listCnt").text(list.length - 1 < 0 ? 0 : list.length - 1);
 				if(list.length <= 0) {
 					$("#listTbl tbody").append("<tr><td colspan='6'>조회된 데이터가 없습니다.</td></tr>");
 				} else {
	 				// 마지막 row는 합계이므로 마지막 row를 제외하고 tbody에 append 처리
 					let html = "";
	 				for(let i = 0; i < list.length - 1; i++){
	 					html += "<tr>";
	 					
	 					html += "	<td class='text-left textUnderline'><a onclick=\"fnSetDetail('"+list[i].interrelatedCustCode+"')\">"+list[i].interrelatedNm+"</a></td>";
	 					html += "	<td class='text-right'>"+list[i].cnt.toLocaleString()+"</td>";
	 					html += "	<td class='text-right'>"+list[i].bdAmt.toLocaleString()+"</td>";
	 					html += "	<td class='text-right'>"+list[i].succAmt.toLocaleString()+"</td>";
	 					if(parseInt(list[i].MAmt) > 0) {
	 						html += "<td class='text-right'>"+list[i].MAmt.toLocaleString()+"</td>";
	 					} else {
	 						html += "<td class='text-right textHighlight'>"+list[i].MAmt.toLocaleString()+"</td>";
	 					}
	 					html += "	<td className='end'>"+list[i].temp+"</td>";
	 					html += "</tr>";
	 				}
 					$("#listTbl tbody").html(html)
					
	 				// 마지막 row는 합계이므로 tfoot에 추가
 					let sumHtml = "";
 					sumHtml += "<tr>";
 					sumHtml += "	<th class='text-left'>"+list[list.length-1].interrelatedNm+"</th>";
 					sumHtml += "	<th class='text-right'>"+list[list.length-1].cnt.toLocaleString()+"</th>";
 					sumHtml += "	<th class='text-right'>"+list[list.length-1].bdAmt.toLocaleString()+"</th>";
 					sumHtml += "	<th class='text-right'>"+list[list.length-1].succAmt.toLocaleString()+"</th>";
 					sumHtml += "	<th class='text-right'>"+list[list.length-1].MAmt.toLocaleString()+"</th>";
 					sumHtml += "	<th class='end'>"+list[list.length-1].temp+"</th>";
 					sumHtml += "</tr>";
 					$("#listTbl tfoot").html(sumHtml)
 				}
				}
		})
	}
	
	function fnSetDetail(srcCoInter){
		const form = document.createElement('form');
		form.setAttribute('action', "/api/v1/move");
		form.setAttribute('method', 'post');
		
		// 이동할 화면
		const viewName = document.createElement('input');			// 자식 요소 input 태그 생성
		viewName.setAttribute('type', 'hidden');				// 태그 속성 설정
		viewName.setAttribute('name', 'viewName');
		viewName.setAttribute('value', "statistics/performance/detail");
		
		// 선택한 회사명
		const coInter = document.createElement('input');
		coInter.setAttribute('type', 'hidden');
		coInter.setAttribute('name', 'coInter');
		coInter.setAttribute('value', srcCoInter);
		
		// 조회조건(입찰완료일 - 시작일)
		const startDay = document.createElement('input');
		startDay.setAttribute('type', 'hidden');
		startDay.setAttribute('name', 'startDay');
		startDay.setAttribute('value', $("#startDay").val());

		// 조회조건(입찰완료일 - 종료일)
		const endDay = document.createElement('input');
		endDay.setAttribute('type', 'hidden'); 
		endDay.setAttribute('name', 'endDay');
		endDay.setAttribute('value',  $("#endDay").val());
		
		// input태그를 form태그의 자식요소로 만듦
		form.appendChild(viewName);
		form.appendChild(coInter);
		form.appendChild(startDay);
		form.appendChild(endDay);
		
		document.body.appendChild(form) // form태그를 body태그의 자식요소로 만듦
		form.submit();
	}
	
	// 엑셀 다운로드
	var fnExcelDown = async function(){
		let coInterArr = new Array();					// 조회할 계열사코드값을 담을 array
		let srcCoInter = $("#srcCoInter").val();		// 조회조건 중 '계열사' 선택 값
		
		if(srcCoInter != ""){
			coInterArr.push(srcCoInter)
		} else {
			await $.post(
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
			"fileName":"회사별_입찰실적_" + time,
			"dataJson" : [
				{'header' : "회사명",			'column' : "interrelatedNm"},
				{'header' : "입찰건수",		'column' : "cnt"},
				{'header' : "예산금액(1)",		'column' : "bdAmt"},
				{'header' : "낙찰금액(2)",		'column' : "succAmt"},
				{'header' : "차이(1)-(2)",	'column' : "MAmt"},
				{'header' : "비고",			'column' : "temp"}
			],
			"coInters" : coInterArr
		};
		
		await $.ajax({
			url: "/api/v1/statistics/selectBiInfoList/excel",
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
