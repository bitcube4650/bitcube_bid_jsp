<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		$(document).ready(function() {
			// datepicker
			$("#startDate").datepicker();
			$("#endDate").datepicker();
			
			$('#startDate').datepicker('setDate', '-1Y');			// 1년 전
			$('#endDate').datepicker('setDate', 'today');			// 오늘
			
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
				"/api/v1/bidComplete/partnerList",
				{
					size		: $("#pageSize").val(),
					page		: page,
					
					startDate	: $("#startDate").val(),
					endDate		: $("#endDate").val(),
					biNo		: $("#srcBiNo").val(),
					biName		: $("#srcBiName").val(),
					succYn_Y	: $("#succYn_Y").is(":checked") ? true : false,			// 완료상태 - 선정
					succYn_N	: $("#succYn_N").is(":checked") ? true : false,			// 완료상태 - 미선정
				}
			)
			.done(function(response){
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
								str += "	<td><a onClick=\"onClickBidDetail('"+ list[i].biNo +"')\" class='textUnderline'>"+ list[i].biNo +"</a></td>";
								str += "	<td class='text-left'><a onClick=\"onClickBidDetail('"+ list[i].biNo +"')\" class='textUnderline'>"+ list[i].biName +"</a></td>";
								str += "	<td><i class='fa-regular fa-timer'></i> "+ list[i].bidOpenDate +"</td>";
								str += "	<td>"+ Ft.ftBiMode(list[i].biMode) +"</td>";
								str += "	<td style='" + (list[i].succYn == "Y" ? "color:red;" : "" ) + "'>"+ fnSuccYn(list[i].succYn) +"</td>";
								str += "	<td>"+ Ft.ftInsMode(list[i].insMode) +"</td>";
								str += "	<td class='end'><i class='fa-light fa-paper-plane-top'></i> <a href=mailto:"+ list[i].userEmail +" class='textUnderline'' title=담당자 메일'>"+ list[i].userName +"</a></td>";
								str +="</tr>";
						}
						$("#listTbl tbody").html(str);
					} else {
						$("#listTbl tbody").html("<tr><td class='end' colSpan=8>조회된 데이터가 없습니다.</td></tr>")
					}
				}
			});
		}
		
		function onClickBidDetail(biNo) {
			localStorage.setItem("biNo", biNo);
			location.href = '/bid/partnerCompleteDetail';
		}
		
		function isPastDate(date){
			const currentDate = new Date();
			const targetDate = new Date(date);
			return targetDate < currentDate;
		}
		
		// 투찰여부 str
		function fnIngTag(data){
			let ingTag = data.ingTag;
			let esmtYn = data.esmtYn;

			if(ingTag == 'A3' && (esmtYn == '0' || esmtYn == '1')){
				return '미투찰(재입찰)'
			}else if(esmtYn == null || esmtYn == undefined || esmtYn == '' || esmtYn == '0' || esmtYn == '1'){
				return '미투찰'
			}else if(esmtYn == '2'){
				return '투찰'
			}
			return '';
		}
		
		function fnStyledData(data){
			return !(data.ingTag == 'A3' && data.rebidAtt == 'N') && data.esmtYn != '2' && isPastDate(data.estStartDate) && !isPastDate(data.estCloseDate);
		}
		
		// 낙찰여부 str
		function fnSuccYn(val) {
			if (val == 'Y') {
				return '선정(낙찰)'
			} else if (val == undefined || val == null || val == 'N') {
				return '비선정'
			}
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
						<li>입찰완료</li>
					</ul>
				</div>
				<div class="contents">
					<div class="conTopBox">
						<ul class="dList">
							<li><div>입찰완료는 결과가 선정 또는 비선정 된 입찰 목록을 보여줍니다. (입찰번호 또는
									입찰명을 클릭하시면 상세내용을 확인할 수 있습니다)</div></li>
						</ul>
					</div>
					<div class="searchBox mt20">
						<div class="flex align-items-center">
							<div class="sbTit mr30 width100px">입찰완료일</div>
							<div class="flex align-items-center" style="width: 320px;">
								<div class="react-datepicker-wrapper">
									<div class="react-datepicker__input-container">
										<input type="text" class="datepicker inputStyle" id="startDate">
									</div>
								</div>
								<span style="margin: 0px 10px;">~</span>
								<div class="react-datepicker-wrapper">
									<div class="react-datepicker__input-container">
										<input type="text" class="datepicker inputStyle" id="endDate">
									</div>
								</div>
							</div>
							<div class="sbTit mr30 ml50 width100px">완료상태</div>
							<div class="flex align-items-center">
								<input type="checkbox" id="succYn_Y" class="checkStyle" name="succYn_Y" checked><label for="succYn_Y" class="mr30">선정(낙찰)</label>
								<input type="checkbox" id="succYn_N" class="checkStyle" name="succYn_N" checked><label for="succYn_N" class="mr30">비선정(유찰포함)</label>
							</div>
						</div>
						<div class="flex align-items-center height50px mt10">
							<div class="sbTit mr30 width100px">입찰번호</div>
							<div style="width: 320px;">
								<input type="text" class="inputStyle" id="srcBiNo" name="srcBiNo" value="">
							</div>
							<div class="sbTit mr30 ml50 width100px">입찰명</div>
							<div style="width: 320px;">
								<input type="text" class="inputStyle" id="srcBiName" name="srcBiName" value="">
							</div>
							<a class="btnStyle btnSearch" onclick="onSearch(0)">검색</a>
						</div>
					</div>
					<div class="flex align-items-center justify-space-between mt40">
						<div class="width100">
							전체 : <span class="textMainColor"><strong id="listCnt"></strong></span>건
							<select id="pageSize" class="selectStyle maxWidth140px ml20" onchange="onSearch(0)">
								<option value="10">10개씩 보기</option>
								<option value="20">20개씩 보기</option>
								<option value="30">30개씩 보기</option>
								<option value="50">50개씩 보기</option>
							</select>
						</div>
					</div>
					<table class="tblSkin1 mt10" id="listTbl">
						<colgroup>
							<col style="width: 12%;">
							<col>
							<col style="width: 15%;">
							<col style="width: 10%;">
							<col style="width: 10%;">
							<col style="width: 10%;">
							<col style="width: 10%;">
						</colgroup>
						<thead>
							<tr>
								<th>입찰번호</th>
								<th>입찰명</th>
								<th>입찰공고일시</th>
								<th>입찰방식</th>
								<th>결과</th>
								<th>내역</th>
								<th class="end">담당자</th>
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
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
