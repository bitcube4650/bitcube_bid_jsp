<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		$(document).ready(function() {
			onSearch(0);
			
			$("#srcBidNo").keydown(function(e) {
				if(e.key === "Enter" || e.keyCode === 13) {
					onSearch(0);
				}
			});
			
			$("#srcBidName").keydown(function(e) {
				if(e.key === "Enter" || e.keyCode === 13) {
					onSearch(0);
				}
			});
		});
		
		function onSearch(page) {
			$.post(
				"/api/v1/bidPtStatus/statuslist",
				{
					size		: $("#pageSize").val(),
					page		: page,
					
					bidNo		: $("#srcBidNo").val(),
					bidName		: $("#srcBidName").val(),
					bidModeA	: $("#bidModeA").is(":checked") ? true : false,			// 입찰방식 - 지명
					bidModeB	: $("#bidModeB").is(":checked") ? true : false,			// 입찰방식 - 일반
					esmtYnY		: $("#esmtYnY").is(":checked") ? true : false,			// 투찰상태 - 투찰
					esmtYnN		: $("#esmtYnN").is(":checked") ? true : false			// 투찰상태 - 미투찰
				}
			)
			.done(function(response){
				$("#listCnt").text(0);
				$("#statusTbl tbody").empty();
				
				if(response.code === 'OK') {
					var list = response.data.content;
					updatePagination(response.data);
					$("#listCnt").text(response.data.totalElements);
					$("#statusTbl tbody").empty();
					
					var time = Ft.formatDate(new Date(), "yyyy_mm_dd");

					if(list.length > 0) {
						var str = "";
						for(var i=0;i<list.length;i++) {
								str += "<tr>";
								str += "	<td><a onClick=\"onClickBidDetail('"+ list[i].biNo +"')\" class='textUnderline "+ ( fnStyledData(list[i]) ? 'blueHighlight': '' )  +"'>"+ list[i].biNo +"</a></td>";
								str += "	<td class='text-left'><a onClick=\"onClickBidDetail('"+ list[i].biNo +"')\" class='textUnderline "+ ( fnStyledData(list[i]) ? 'blueHighlight' : '' )  +"'>"+ list[i].biName +"</a></td>";
								str += "	<td><i class='fa-regular fa-timer'></i> "+ list[i].estStartDate +"</td>";
								str += "	<td><i class='fa-regular fa-timer'></i> "+ list[i].estCloseDate +"</td>";
								str += "	<td>"+ Ft.ftBiMode(list[i].biMode) +"</td>";
								str += "	<td>"+ Ft.ftInsMode(list[i].insMode) +"</td>";
								str += "	<td>";
								str += "		<span class='"+(list[i].esmtYn == "2" ? 'blueHighlight' : '')+"' style='"+ ( fnStyledData(list[i]) ? 'color:red;': '' ) +"'>";
								str += 				fnIngTag(list[i]);
								str += "		</span>"
								str += "	</td>";
								str += "<td class='end'><i class='fa-light fa-paper-plane-top'></i> <a href=mailto:"+ list[i].damdangEmail +" class='textUnderline'' title=담당자 메일'>"+ list[i].damdangName +"</a></td>";
								str +="</tr>";
						}
						$("#statusTbl tbody").html(str);
					} else {
						$("#statusTbl tbody").html("<tr><td class='end' colSpan=8>조회된 데이터가 없습니다.</td></tr>")
					}
				}
			});
		}
		
		function onClickBidDetail(biNo) {
			alert(biNo);
		}
		
		function isPastDate(date){
			const currentDate = new Date();
			const targetDate = new Date(date);
			return targetDate < currentDate;
		}
		
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
						<li>입찰진행</li>
					</ul>
				</div>
				
				<div class="contents">
					<div class="conTopBox">
						<ul class="dList">
							<li>
								<div>입찰진행은 입찰공고 되고 입찰 완료되기 전까지의 상태를 가진 입찰입니다.(입찰번호 또는 입찰명을 클릭하시면 상세내용을 확인할 수 있습니다)</div>
							</li>
							<li>
								<div>견적 제출이 가능한 입찰은 입찰번호, 입찰명 그리고 제출시작일시가 파란색으로 표기됩니다.(견적 가능은 미투찰 상태에서 제출시작시간이 지난 입찰입니다.)</div></li>
						</ul>
					</div>
					<div class="searchBox mt20">
						<div class="flex align-items-center">
							<div class="sbTit mr30">입찰번호</div>
							<div class="width250px">
								<input type="text" class="inputStyle" name="srcBidNo" id="srcBidNo">
							</div>
							<div class="sbTit mr30 ml50">입찰명</div>
							<div class="width250px">
								<input type="text" class="inputStyle" name="srcBidName" id="srcBidName">
							</div>
						</div>
						<div class="flex align-items-center height50px mt10">
							<div class="sbTit mr30">입찰방식</div>
							<div class="flex align-items-center" style="min-width: 250px;">
								<input type="checkbox" id="bidModeA" class="checkStyle" checked /><label for="bidModeA">지명</label>
								<input type="checkbox" id="bidModeB" class="checkStyle" checked /><label for="bidModeB" class="ml50">일반</label>
							</div>
							<div class="sbTit mr30 ml50">투찰상태</div>
							<div class="flex align-items-center width100">
								<input type="checkbox" id="esmtYnN" class="checkStyle" checked /><label for="esmtYnN">미투찰(재입찰 포함)</label>
								<input type="checkbox" id="esmtYnY" class="checkStyle" checked /><label for="esmtYnY" class="ml50">투찰</label>
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
					<table class="tblSkin1 mt10" id="statusTbl">
						<colgroup>
							<col width="12%"/>
							<col />
							<col width="14%"/>
							<col width="14%"/>
							<col width="8%"/>
							<col width="7%"/>
							<col width="8%"/>
							<col width="8%"/>
						</colgroup>
						<thead>
							<tr>
								<th>입찰번호</th>
								<th>입찰명</th>
								<th>제출시작일시</th>
								<th>제출마감일시</th>
								<th>입찰방식</th>
								<th>투찰상태</th>
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
