<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.Map"%>
<%
	Map<String, Object> params = (Map<String, Object>) request.getAttribute("params");
	
	String keyword = "";
	if (params != null && params.containsKey("keyword")) {
		keyword = (String) params.get("keyword");
	}
%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		$(document).ready(function() {
			if(<%= "noticing".equals(keyword) %>){					// dashboard에서 입찰완료로 조회
				$("input[id=rebidYn]").prop("checked",true);
				$("input[id=dateOverYn]").prop("checked",false);
				$("input[id=openBidYn]").prop("checked",false);
			} else if(<%= "beforeOpening".equals(keyword) %>){		// dashboard에서 유찰로 조회
				$("input[id=rebidYn]").prop("checked",false);
				$("input[id=dateOverYn]").prop("checked",true);
				$("input[id=openBidYn]").prop("checked",false);
			} else if(<%= "opening".equals(keyword) %>){
				$("input[id=rebidYn]").prop("checked",false);
				$("input[id=dateOverYn]").prop("checked",false);
				$("input[id=openBidYn]").prop("checked",true);
			}
			
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
			var biNo		= $("#biNo").val();
			var biName		= $("#biName").val();
			var rebidYn		= $("#rebidYn").is(":checked") ? "Y" : "N";
			var dateOverYn	= $("#dateOverYn").is(":checked") ? "Y" : "N";
			var openBidYn	= $("#openBidYn").is(":checked") ? "Y" : "N";
			var size		= $("#pageSize").val();
			
			$.post(
				"/api/v1/bidstatus/statuslist",
				{
					bidNo		: biNo
				,	bidName		: biName
				,	rebidYn		: rebidYn
				,	dateOverYn	: dateOverYn
				,	openBidYn	: openBidYn
				,	size		: size
				,	page		: page
				},
				function(response){
					if(response.code === 'OK') {
						var list = response.data.content;
						updatePagination(response.data);
						$("#total").html(response.data.totalElements);
						$("#statusListBody").empty();
						
						var time = Ft.formatDate(new Date(), "yyyy_mm_dd");
						
						if(list.length > 0) {
							for(var i=0;i<list.length;i++) {
								var str = "";
									str += "<tr>";
									str += "<td><button onClick=\"onClickBidDetail('"+ list[i].biNo +"')\" class='textUnderline'>"+ list[i].biNo +"</button></td>";
									str += "<td><button onClick=\"onClickBidDetail('"+ list[i].biNo +"')\" class='textUnderline'>"+ list[i].biName +"</button></td>";
								var currentDate = new Date();
								var targetDate = new Date(list[i].estCloseDate);
								if(targetDate < currentDate) {
									str += "<td class='textHighlight'><i class='fa-regular fa-timer'></i>"+ list[i].estCloseDate +"</td>";
								} else {
									str += "<td><i class='fa-regular fa-timer'></i>"+ list[i].estCloseDate +"</td>";
								}
									str += "<td>"+ Ft.ftBiMode(list[i].biMode) +"</td>";
									
								if((targetDate < currentDate) && list[i].ingTag !== '개찰') {
									str += "<td class='textHighlight'>"+ list[i].ingTag +"</td>";
								} else {
									if(list[i].ingTag === '개찰') {
										str += "<td class='blueHighlight'>"+ list[i].ingTag +"</td>";
									} else {
										str += "<td>"+ list[i].ingTag +"</td>";
									}
								}
									str += "<td>"+ Ft.ftInsMode(list[i].insMode) +"</td>";
									str += "<td><i class='fa-light fa-paper-plane-top'></i><a href=mailto:"+ list[i].cuserEmail +" class='textUnderline'' title=담당자 메일'>"+ list[i].cuser +"</a></td>";
									str += "<td class='end'><i class='fa-light fa-paper-plane-top'></i><a href=mailto:"+ list[i].openerEmail +" class='textUnderline' title='공고자 메일'>"+ list[i].openerId +"</a></td>";
									str +="</tr>";
								$("#statusListBody").append(str);
							}
						} else {
							$("#statusListBody").append(
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
		
		function onClickBidDetail(biNo) {
			const form = document.createElement('form');
			form.setAttribute('action', "/bidstatus/moveBidStatusDetail");
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
	</script>
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
								<div>입찰진행은 입찰공고 되고 입찰 완료되기 전까지의 상태를 가진 입찰입니다. (입찰번호 또는 입찰명을 클릭하시면 상세내용을 확인할 수 있습니다.)</div>
							</li>
							<li>
								<div>칩찰이 마감되면 개찰자는 개찰 후 업체선정을 해 주십시오. (개찰대상은 상태가 빨간색으로, 개찰 후 업체선정대상은 상태가 파란색으로 표기됩니다.)</div>
							</li>
							<li class="textHighlight">
								<div>입찰마감 후 30일이 지나도록 업체 선정되지 않으면 자동으로 유찰처리 됩니다.</div>
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
						</div>
						<div class="flex align-items-center height50px mt10">
							<div class="sbTit mr30">진행상태</div>
							<div class="flex align-items-center width100">
								<input type="checkbox" id="rebidYn" class="checkStyle" checked/><label for="rebidYn" class="mr30">입찰공고(재입찰 포함)</label>
								<input type="checkbox" id="dateOverYn" class="checkStyle" checked/><label for="dateOverYn" class="mr30">입찰공고(개찰대상)</label>
								<input type="checkbox" id="openBidYn" class="checkStyle" checked/><label for="openBidYn" class="mr30">입찰공고(업체선정대상)</label>
							</div>
							<a class="btnStyle btnSearch" onClick="onSearch(0)">검색</a>
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
<!--						<div>-->
<!--							<button class="btnStyle btnPrimary">입찰계획등록</button> -->
<!--						</div>-->
					</div>
					<table class="tblSkin1 mt10">
						<colgroup>
							<col style="width:'12%'"/>
							<col />
							<col style="width:'15%'"/>
							<col style="width:'10%'"/>
							<col style="width:'10%'"/>
							<col style="width:'10%'"/>
							<col style="width:'10%'"/>
							<col style="width:'10%'"/>
						</colgroup>
						<thead>
							<tr>
								<th>입찰번호</th>
								<th>입찰명</th>
								<th>제출마감일시</th>
								<th>입찰방식</th>
								<th>상태</th>
								<th>내역</th>
								<th>담당자</th>
								<th class="end">개찰자</th>
							</tr>
						</thead>
						<tbody id="statusListBody">
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
