<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		$(document).ready(function() {
			fnInit();
			
			$("#onSearchBtn").on('click', function(e) {
				onSearch(0);
			})
			
			$("#biNo").keydown(function(e) {
				if(e.key === "Enter" || e.keyCode === 13) {
					onSearch(0);
				}
			});
			
			$("#biName").keydown(function(e) {
				if(e.key === "Enter" || e.keyCode === 13) {
					onSearch(0);
				}
			});
		});
		
		function fnInit() {
			onSearch(0);
		}
		
		function onSearch(page) {
			var biNo = $("#biNo").val();
			var biName = $("#biName").val();
			var size = $("#pageSize").val();
			
			$.post(
				"/api/v1/bid/progressList",
				{
					biNo : biNo						// 조회조건 : 입찰번호
				,	biName : biName					// 조회조건 : 입찰명
				,	size : size						// 10개씩 보기
				,	page : page						// 클릭한 페이지번호
				},
				function(response){
					if(response.code === 'OK') {
						var list = response.data.content;
						updatePagination(response.data);
						$("#total").html(response.data.totalElements);
						$("#progressListBody").empty();
						if(list.length > 0) {
							for(var i=0;i<list.length;i++) {
								$("#progressListBody").append(
									"<tr>" + 
										"<td><button onClick=\"onBidProgressDetail('"+ list[i].biNo +"')\" class='textUnderline'>"+ list[i].biNo +"</button></td>" +
										"<td><button onClick=\"onBidProgressDetail("+ list[i].biNo +")\" class='textUnderline'>"+ list[i].biName +"</button></td>" +
										"<td><i class='fa-regular fa-timer'></i>"+ list[i].estStartDate +"</td>" +
										"<td><i class='fa-regular fa-timer'></i>"+ list[i].estCloseDate +"</td>" +
										"<td>"+ list[i].biMode +"</td>"+
										"<td>"+ list[i].insMode +"</td>"+
										"<td><i class='fa-light fa-paper-plane-top'></i><a href=mailto:"+ list[i].cuserEmail +" class='textUnderline'' title=담당자 메일'>"+ list[i].cuser +"</a></td>" +
										"<td class='end'><i class='fa-light fa-paper-plane-top'></i><a href=mailto:"+ list[i].gongoEmail +" class='textUnderline' title='공고자 메일'>"+ list[i].gongoId +"</a></td>" +
									"</tr>"
								);
							}
						} else {
							$("#progressListBody").append(
								"<tr>" + 
									"<td class='end' colSpan=8>조회된 데이터가 없습니다.</td>" +
								"</tr>"
							)
						}
					} else {
						
					}
				},
				"json"
			);
		}
		
		function onBidProgressDetail(biNo) {
			
			const form = document.createElement('form');
		//	form.setAttribute('action', "/bidstatus/moveBidStatusDetail");
			form.setAttribute('action', "/bidStatus/moveBidProgressDetail");
			form.setAttribute('method', 'post');
			
			// 선택한 회사명
			const input = document.createElement('input');
			input.setAttribute('type', 'hidden');
			input.setAttribute('name', 'biNo');
			input.setAttribute('value', biNo);
			
			// input태그를 form태그의 자식요소로 만듦
			form.appendChild(input);
			
			document.body.appendChild(form) // form태그를 body태그의 자식요소로 만듦
			form.submit();
		}
		
		function onMoveSave() {
			location.href="/api/v1/move?viewName=bid/bidProgressSave&flag=save";
		}
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			<div class="conRight">
				<div class="conHeader">
					<ul class="conHeaderCate">
						<li>전자입찰</li>
						<li>입찰계획</li>
					</ul>
				</div>
				
				<div class="contents">
					<div class="conTopBox">
						<ul class="dList">
							<li>
								<div>입찰담당자가 생성한 입찰목록입니다. 입찰 공고자는 입찰계획 내용을 상세히 확인하시고 공고 하십시오.(입찰번호 또는 입찰명을 클릭하시면 상세내용을 확인할 수 있습니다)</div>
							</li>
							<li class="textHighlight">
								<div>입찰공고자는 제출마감일시 전에 입찰공고 하지 않으면 해당 입찰은 자동으로 삭제됩니다.</div>
							</li>
							<li>
								<div>담당자 또는 공고자를 클릭하면 해당인에게 메일을 보낼 수 있습니다.</div>
							</li>
						</ul>
					</div>
					
					<div class="searchBox mt20">
						<div class="flex align-items-center">
							<div class="sbTit mr30">입찰번호</div>
							<div class="width250px">
								<input type="text" class="inputStyle" name="biNo" id="biNo">
							</div>
							<div class="sbTit mr30 ml50">입찰명</div>
							<div class="width250px">
								<input type="text" class="inputStyle" name="biName" id="biName">
							</div>
							<button class="btnStyle btnSearch" id="onSearchBtn" >검색</button>
						</div>
					</div>
					
					<div class="flex align-items-center justify-space-between mt40">
						<div class="width100">
							전체 : <span class="textMainColor"><strong id="total"></strong></span>건
							<select id="pageSize" class="selectStyle maxWidth140px ml20" onchange="onSearch(0)">
								<option value="10">10개씩 보기</option>
								<option value="20">20개씩 보기</option>
								<option value="30">30개씩 보기</option>
								<option value="50">50개씩 보기</option>
							</select>
						</div>
						<div>
							<button onClick="onMoveSave()" class="btnStyle btnPrimary">입찰계획등록</button> 
						</div>
					</div>
					<table class="tblSkin1 mt10">
						<colgroup>
							<col style="width:'12%'"/>
							<col />
							<col style="width:'15%'"/>
							<col style="width:'15%'"/>
							<col style="width:'10%'"/>
							<col style="width:'10%'"/>
							<col style="width:'10%'"/>
							<col style="width:'10%'"/>
						</colgroup>
						<thead>
							<tr>
								<th>입찰번호</th>
								<th>입찰명</th>
								<th>제출시작일시</th>
								<th>제출마감일시</th>
								<th>입찰방식</th>
								<th>내역</th>
								<th>담당자</th>
								<th class="end">공고자</th>
							</tr>
						</thead>
						<tbody id="progressListBody">
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
