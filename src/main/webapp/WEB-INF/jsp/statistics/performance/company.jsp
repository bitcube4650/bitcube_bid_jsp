<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#startDay").datepicker();
			$("#endDay").datepicker();
			
			$('#startDay').datepicker('setDate', '-1M');
			$('#endDay').datepicker('setDate', 'today');
		});
		
		function fnSetDetail(coInter){
			var form = document.createElement('form'); // 폼 태그 생성
			form.setAttribute('action', "/statistics/performance/detail"); // 태그 속성 설정
			form.setAttribute('method', 'get');
			
			var input = document.createElement('input'); // 자식 요소 input 태그 생성
			input.setAttribute('type', 'hidden'); // 태그 속성 설정
			input.setAttribute('name', 'coInter');
			input.setAttribute('value', coInter);
			
			form.appendChild(input); // input태그를 form태그의 자식요소로 만듦
			document.body.appendChild(form) // form태그를 body태그의 자식요소로 만듦
			form.submit(); // 전송
		}
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			<div class="conRight">
				<div class="conHeader">
					<ul class="conHeaderCate">
						<li>통계</li>
						<li>회사별 입찰실적</li>
					</ul>
				</div>
				<div class="contents">
					<div class="conTopBox">
						<ul class="dList">
							<li><div>조회기간 입찰완료일 기준으로 각 계열사의 입찰 실적을 나타냅니다.</div></li>
							<li><div>통계 실적 Data는 사용권한이 시스템 관리자 일 경우 모든 계열사, 감사사용자일
									경우 선택된 계열사를 대상으로 합니다.(감사사용자 계열사 선택은 시스템 관리자가 관리합니다.)</div></li>
						</ul>
					</div>
					<div class="searchBox mt20">
						<div class="flex align-items-center">
							<div class="sbTit width100px">입찰완료일</div>
							<div class="flex align-items-center width300px">
								<input type="text" id="startDay" title="월 입력란" readonly="readonly" class="datepicker inputStyle" />
								<span style="margin: 0px 10px;">~</span>
								<input type="text" id="endDay" title="월 입력란" readonly="readonly" class="datepicker inputStyle" />
							</div>
							<div class="sbTit width80px ml50">계열사</div>
							<div class="flex align-items-center width280px">
								<select class="selectStyle"><option value="">전체</option>
									<option value="02">롯데에너지머티리얼즈</option>
									<option value="04">롯데에코월</option>
									<option value="06">롯데테크</option>
									<option value="10">일진LED</option>
									<option value="03">일진다이아몬드</option>
									<option value="08">일진디스플레이</option>
									<option value="13">일진디앤코</option>
									<option value="11">일진씨앤에스</option>
									<option value="01">일진전기</option>
									<option value="05">일진제강</option>
									<option value="12">일진파트너스</option>
									<option value="09">일진하이솔루스</option>
									<option value="07">전주방송</option>
									<option value="14">트랜스넷</option></select>
							</div>
							<a class="btnStyle btnSearch">검색</a>
						</div>
					</div>
					<div class="flex align-items-center justify-space-between mt40">
						<div class="width100">
							전체 : <span class="textMainColor"><strong>9</strong></span>건
						</div>
						<div class="flex-shrink0">
							<a title="엑셀 다운로드" class="btnStyle btnPrimary">엑셀 다운로드 <i
								class="fa-light fa-arrow-down-to-line ml10"></i></a>
						</div>
					</div>
					<table class="tblSkin1 mt10">
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
						<tbody>
							<tr>
								<td class="text-left"><a class="textUnderline" onclick="javascript:fnSetDetail('04')">롯데에너지머티리얼즈</a></td>
								<td class="text-right">132</td>
								<td class="text-right">13,714,111,360</td>
								<td class="text-right">12,917,709,863</td>
								<td class="text-right">796,401,497</td>
								<td class="end"></td>
							</tr>
							<tr>
								<td class="text-left"><a class="textUnderline">롯데에코월</a></td>
								<td class="text-right">7</td>
								<td class="text-right">599,518,042</td>
								<td class="text-right">521,738,400</td>
								<td class="text-right">77,779,642</td>
								<td class="end"></td>
							</tr>
							<tr>
								<td class="text-left"><a class="textUnderline">롯데테크</a></td>
								<td class="text-right">6</td>
								<td class="text-right">7,091,300,000</td>
								<td class="text-right">5,808,500,000</td>
								<td class="text-right">1,282,800,000</td>
								<td class="end"></td>
							</tr>
							<tr>
								<td class="text-left"><a class="textUnderline">일진다이아몬드</a></td>
								<td class="text-right">31</td>
								<td class="text-right">737,492,690</td>
								<td class="text-right">701,967,750</td>
								<td class="text-right">35,524,940</td>
								<td class="end"></td>
							</tr>
							<tr>
								<td class="text-left"><a class="textUnderline">일진디스플레이</a></td>
								<td class="text-right">1</td>
								<td class="text-right">1</td>
								<td class="text-right">43,200</td>
								<td class="text-right textHighlight">-43,199</td>
								<td class="end"></td>
							</tr>
							<tr>
								<td class="text-left"><a class="textUnderline">일진씨앤에스</a></td>
								<td class="text-right">29</td>
								<td class="text-right">633,874,002</td>
								<td class="text-right">618,919,919</td>
								<td class="text-right">14,954,083</td>
								<td class="end"></td>
							</tr>
							<tr>
								<td class="text-left"><a class="textUnderline">일진전기</a></td>
								<td class="text-right">9</td>
								<td class="text-right">11,990</td>
								<td class="text-right">14,260</td>
								<td class="text-right textHighlight">-2,270</td>
								<td class="end"></td>
							</tr>
							<tr>
								<td class="text-left"><a class="textUnderline">일진제강</a></td>
								<td class="text-right">11</td>
								<td class="text-right">11</td>
								<td class="text-right">825,804,937</td>
								<td class="text-right textHighlight">-825,804,926</td>
								<td class="end"></td>
							</tr>
							<tr>
								<td class="text-left"><a class="textUnderline">일진하이솔루스</a></td>
								<td class="text-right">11</td>
								<td class="text-right">1,135,800,001</td>
								<td class="text-right">920,419,000</td>
								<td class="text-right">215,381,001</td>
								<td class="end"></td>
							</tr>
							<tr style="display: none;">
								<td colspan="6">조회된 데이터가 없습니다.</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th class="text-left">계</th>
								<th class="text-right">237</th>
								<th class="text-right">23,912,108,097</th>
								<th class="text-right">22,315,117,329</th>
								<th class="text-right">1,596,990,768</th>
								<th class="end"></th>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>
