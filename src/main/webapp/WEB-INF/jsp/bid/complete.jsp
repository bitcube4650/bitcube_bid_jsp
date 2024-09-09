<%@page import="java.util.Map"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<%
	Map<String, Object> params = (Map<String, Object>) request.getAttribute("params");
	
	String keyword = "";
	if (params != null && params.containsKey("keyword")) {
		keyword = (String) params.get("keyword");
	}
%>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script>
		$(document).ready(function() {
			if(<%= "completed".equals(keyword) %>){					// dashboard에서 입찰완료로 조회
				$("input[name=succBi]").prop("checked",true);
			} else if(<%= "unsuccessful".equals(keyword) %>){		// dashboard에서 유찰로 조회
				$("input[name=failBi]").prop("checked",true);
			} else {
				$("input[name=succBi]").prop("checked",true);
				$("input[name=failBi]").prop("checked",true);
			}
			
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
				"/api/v1/bidComplete/list",
				{
					size		: $("#pageSize").val(),
					page		: page,
					
					startDate	: $("#startDate").val(),
					endDate		: $("#endDate").val(),
					biNo		: $("#srcBiNo").val(),
					biName		: $("#srcBiName").val(),
					succBi		: $("#succBi").is(":checked") ? true : false,			// 입찰완료
					failBi		: $("#failBi").is(":checked") ? true : false,			// 유찰
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
								str += "	<td>"+ list[i].updateDate +"</td>";
								str += "	<td>"+ Ft.ftBiMode(list[i].biMode) +"</td>";
								str += "	<td style='" + (list[i].ingTag == "A7" ? "color:red;" : "" ) + "'>"+ Ft.ftIngTag(list[i].ingTag) +"</td>";
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

			
			const form = document.createElement('form');
			form.setAttribute('action', "/bidComplete/detail");
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
						<ul className="dList">
							<li>
								<div>입찰완료는 업체선정이 완료된 입찰이거나 유찰된 입찰 목록을 보여줍니다. (입찰번호 또는 입찰명을 클릭하시면 상세내용을 확인할 수 있습니다)</div>
							</li>
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
								<input type="checkbox" id="succBi" class="checkStyle" name="succBi"><label for="succBi" class="mr30">입찰완료</label>
								<input type="checkbox" id="failBi" class="checkStyle" name="failBi"><label for="failBi" class="mr30">유찰</label>
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
								<th>입찰완료일시</th>
								<th>입찰방식</th>
								<th>상태</th>
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
