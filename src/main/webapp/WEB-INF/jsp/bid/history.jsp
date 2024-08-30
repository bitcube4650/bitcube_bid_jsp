<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="bitcube.framework.ebid.dto.UserDto"%>
<%@ page import="bitcube.framework.ebid.etc.util.Constances"%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>

<%
	// 로그인 세션정보
	UserDto user		= (UserDto) session.getAttribute(Constances.SESSION_NAME);
%>
	<script>
		$(document).ready(function() {
			// datepicker
			$("#startDate").datepicker();
			$("#endDate").datepicker();

			$('#startDate').datepicker('setDate', '-1Y'); // 1년 전
			$('#endDate').datepicker('setDate', 'today'); // 오늘

			onSearch(0);
			
			$("#srcBiNo").keydown(function(e) {
				if(e.key === "Enter" || e.keyCode === 13) {
					onSearch(0);
				}
			});
			
			$("#srcBiName").keydown(function(e) {
				if(e.key === "Enter" || e.keyCode === 13) {
					onSearch(0);
				}
			});
		});

		function onSearch(page) {
			$.post(
				"/api/v1/bidComplete/history",
				{
					size		: $("#pageSize").val(),
					page		: page,
					
					startDate	: $("#startDate").val(),
					endDate		: $("#endDate").val(),
					biNo		: $("#srcBiNo").val(),
					biName		: $("#srcBiName").val()
				}
			).done(function(response){
				$("#listCnt").text(0);
				$("#listTbl tbody").empty();
				
				if(response.code === 'OK') {
					var list = response.data.content;
					updatePagination(response.data);
					$("#listCnt").text(response.data.totalElements);
					$("#listTbl tbody").empty();
					
					var time = Ft.formatDate(new Date(), "yyyy_mm_dd");

					if(list.length > 0) {
						var str = "";
						for(var i=0;i<list.length;i++) {
								str += "<tr>";
								str += "	<td>"+ list[i].biNo +"</td>";
								str += "	<td class='text-left'>"+ list[i].biName +"</td>";
								str += "	<td class='text-right'>"+ Ft.numberWithCommas(list[i].bdAmt) +"</td>";
								str += "	<td class='text-right'>"+ Ft.numberWithCommas(list[i].succAmt) +"</td>";
								str += "	<td class='text-left'>"+ list[i].custName +"</td>";
								str += "	<td><a onclick='fnBidJoinCustListPop(\""+list[i].biNo+"\");' data-toggle='modal' data-target='#bidJoinCustListPop' class='textUnderline' title='투찰 정보 페이지가 열림'>"+ list[i].joinCustCnt +"</a></td>";
								str += "	<td>"+ list[i].estStartDate +"</td>";
								str += "	<td>"+ list[i].estCloseDate +"</td>";
								str += "	<td class='end'>"+ list[i].userName +"</td>";
								str +="</tr>";
						}
						$("#listTbl tbody").html(str);
					} else {
						$("#listTbl tbody").html("<tr><td class='end' colSpan=8>조회된 데이터가 없습니다.</td></tr>")
					}
				}
			});
		}

		function fnExcelDown() {
			var time = Ft.formatDate(new Date(), "yyyy_mm_dd");
			var params = {
				"biNo" : $("#srcBiNo").val(),
				"biName" : $("#srcBiName").val(),
				"startDate": $("#startDate").val(),
				"endDate": $("#endDate").val(),
				
				"userId" : "<%=user.getLoginId() %>",
				"interrelatedCustCode" : "<%=user.getCustCode() %>",
				"userAuth" : "<%=user.getUserAuth() %>",
				
				"fileName":"입찰_이력_" + time,
				"dataJson" : [
					{'header' : "입찰번호",			'column' : "biNo"},
					{'header' : "입찰명",				'column' : "biName"},
					{'header' : "예산금액",			'column' : "bdAmt"},
					{'header' : "낙찰금액",			'column' : "succAmt"},
					{'header' : "낙찰사",				'column' : "custName"},
					{'header' : "제출시작일",			'column' : "estStartDate"},
					{'header' : "제출마감일",			'column' : "estCloseDate"},
					{'header' : "입찰담당자",			'column' : "userName"},
					{'header' : "회사명(투찰정보)",		'column' : "custName2"},
					{'header' : "투찰가(투찰정보)",		'column' : "esmtAmt"},
					{'header' : "투찰시간(투찰정보)",	'column' : "submitDate"}
				]
			};

			$.ajax({
				url: "/api/v1/excel/selectFindComplateBidList/excel",
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

	<style>
.blueHighlight {
	color: #0109d0 !important;
}
</style>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			<div class="conRight">
				<div class="conHeader">
					<ul class="conHeaderCate">
						<li>전자입찰</li>
						<li>낙찰이력</li>
					</ul>
				</div>
				<div class="contents">
					<div class="conTopBox">
						<ul className="dList">
							<li>
								<div>조회기간 입찰완료일 기준으로 소속사의 낙찰된 입찰정보와 투찰 정보를 확인할 수 있습니다.</div>
							</li>
							<li>
								<div>참여업체수를 클릭하면 투찰 업체들의 투찰가 및 투찰 일시를 보실 수 있습니다.</div>
							</li>
						</ul>
					</div>
					<div class="searchBox mt20">
						<div class="flex align-items-center">
							<div class="sbTit mr30 width100px">입찰완료일</div>
							<div class="flex align-items-center" style="width: 320px;">
								<div class="react-datepicker-wrapper">
									<div class="react-datepicker__input-container">
										<input type="text" class="datepicker inputStyle"
											id="startDate">
									</div>
								</div>
								<span style="margin: 0px 10px;">~</span>
								<div class="react-datepicker-wrapper">
									<div class="react-datepicker__input-container">
										<input type="text" class="datepicker inputStyle" id="endDate">
									</div>
								</div>
							</div>
						</div>
						<div class="flex align-items-center height50px mt10">
							<div class="sbTit mr30 width100px">입찰번호</div>
							<div style="width: 320px;">
								<input type="text" class="inputStyle" id="srcBiNo"
									name="srcBiNo" value="">
							</div>
							<div class="sbTit mr30 ml50 width100px">입찰명</div>
							<div style="width: 320px;">
								<input type="text" class="inputStyle" id="srcBiName"
									name="srcBiName" value="">
							</div>
							<a class="btnStyle btnSearch" onclick="onSearch(0)">검색</a>
						</div>
					</div>
					<div class="flex align-items-center justify-space-between mt40">
						<div class="width100">
							전체 : <span class="textMainColor"><strong id="listCnt"></strong></span>건
							<select id="pageSize" class="selectStyle maxWidth140px ml20"
								onchange="onSearch(0)">
								<option value="10">10개씩 보기</option>
								<option value="20">20개씩 보기</option>
								<option value="30">30개씩 보기</option>
								<option value="50">50개씩 보기</option>
							</select>
						</div>
						<div class="flex-shrink0">
							<a onclick="fnExcelDown()" class="btnStyle btnPrimary" title="엑셀 다운로드">엑셀 다운로드 <i class="fa-light fa-arrow-down-to-line ml10"></i></a>
						</div>
					</div>
					<table class="tblSkin1 mt10" id="listTbl">
						<colgroup>
							<col style="" />
						</colgroup>
						<thead>
							<tr>
								<th>입찰번호</th>
								<th>입찰명</th>
								<th>예산금액</th>
								<th>낙찰금액</th>
								<th>낙찰사</th>
								<th>참여업체수</th>
								<th>제출시작일</th>
								<th>제출마감일</th>
								<th class="end">입찰담당자</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
					<div class="row mt40">
						<div class="col-xs-12">
							<jsp:include page="/WEB-INF/jsp/pagination.jsp" />
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/bid/bidJoinCustListPop.jsp" />
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
