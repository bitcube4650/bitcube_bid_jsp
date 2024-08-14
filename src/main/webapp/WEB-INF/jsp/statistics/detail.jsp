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
							<li>입찰상세내역</li>
						</ul>
					</div>
					<div class="contents">
						<div class="conTopBox">
							<ul class="dList">
								<li>
									<div>조회기간 입찰완료일 기준으로 각 계열사의 낙찰된 입찰정보와 투찰 정보를 확인할수 있습니다.</div>
								</li>
								<li>
									<div>참여업체수를 클릭하면 투찰 업체들의 투찰가 및 투찰 일시를 보실 수 있습니다.</div>
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
								<a title="엑셀 다운로드" class="btnStyle btnPrimary">엑셀 다운로드 <i class="fa-light fa-arrow-down-to-line ml10"></i></a>
							</div>
						</div>
						<table class="tblSkin1 mt10" id="listTbl">
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
							<tbody></tbody>
						</table>
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
<%-- 		<jsp:include page="/WEB-INF/jsp/ebid/bidJoinCustListPop.jsp" /> --%>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>

<script>
	$(function(){
		// datepicker
		$("#startDay").datepicker();
		$("#endDay").datepicker();
		
		$('#startDay').datepicker('setDate', '-1M');		// 1달 전
		$('#endDay').datepicker('setDate', 'today');		// 오늘
		
		// 계열사 리스트 조회
		fnSetCoInter();
	});
	
	function fnSetCoInter(){
		$.post(
			'/api/v1/statistics/coInterList',
			{}
		).done(function(arg){
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
			
			// 입찰실적 리스트 조회
			onSearch(0);
		});
	}

	function onSearch(page){
		$.post(
			'/api/v1/statistics/bidDetailList',
			{
				page		: page,
				size		: $("#pageSize").val(),
				
				startDay	: $("#startDay").val(),
				endDay		: $("#endDay").val(),
				srcCoInter	: $("#srcCoInter").val()
			}
		).done(
			function(arg){
 				$("#listCnt").text(0);
 				$("#listTbl tbody").empty();
 				
 				if(arg.code == "ERROR") {
 					$("#listTbl tbody").append("<tr><td colspan='9'>조회된 데이터가 없습니다.</td></tr>");
 					Swal.fire('', arg.msg, 'error');
 				} else {
 					let result = arg.data
					// 페이징 처리
 					updatePagination(result);
 					
	 				$("#listCnt").text(result.totalElements);
	 				if(result.totalElements == 0) {
	 					$("#listTbl tbody").append("<tr><td colspan='9'>조회된 데이터가 없습니다.</td></tr>");
	 				} else {
		 				let text = "";
		 				for(let i = 0; i < result.content.length; i++){
		 					text += "<tr>";
		 					text += "	<td class='text-left'>"+result.content[i].biNo+"</td>";
		 					text += "	<td class='text-left'>"+result.content[i].biName+"</td>";
		 					text += "	<td class='text-right'>"+parseInt(result.content[i].bdAmt).toLocaleString()+"</td>";
		 					text += "	<td class='text-right'>"+parseInt(result.content[i].succAmt).toLocaleString()+"</td>";
		 					text += "	<td>"+result.content[i].custName+"</td>";
		 					text += "	<td class='textUnderline'><a data-toggle='modal' onclick=\"fnBiddingInfoPop('"+result.content[i].biNo+"')\">"+result.content[i].joinCustCnt+"</a></td>";
		 					text += "	<td>"+result.content[i].estStartDate+"</td>";
		 					text += "	<td>"+result.content[i].estCloseDate+"</td>";
		 					text += "	<td class='end'>"+result.content[i].userName+"</td>";
		 					text += "</tr>";
		 				}
	 					$("#listTbl tbody").html(text)
	 				}
 				}
			}
		);
	}
	
	// 참여업체수 팝업
	function fnBiddingInfoPop(biNo){
		console.log(biNo)
	}
</script>
</html>
