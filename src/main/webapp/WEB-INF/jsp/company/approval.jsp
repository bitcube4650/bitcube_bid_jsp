<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		onApprovalSearch(0);
		
        $('#srcCustName').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onApprovalSearch(0);
            }
        });
		
		
	});
	
	function itemSelectPop(){
		
		$("#custTypePop").modal('show')
	}
	
	function itemSelectCallback(itemCode, itemName) {
		console.log(itemCode)
		console.log(itemName)
		$("#custTypePop").modal('hide')
		$('#srcCustTypeCode').val(itemCode)
		$('#srcCustTypeName').val(itemName)
		$("#srcCustTypeCodeRemove").css("display", "")

	}

	function onApprovalSearch(page){
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		
		const params = {
			custName: $('#srcCustName').val(),
			custType : $('#srcCustTypeCode').val(),	
			custTypeNm1 : 	$('#srcCustTypeName').val(),
			id : "PartnerApproval",
			"size"		: $("#pageSize").val(),
			"page"		: page,
			interrelatedCustCode : loginInfo.custCode,
			certYn: 'N'
		}
		
		$.post("/api/v1/cust/approvalList", params, 
			function(response) {
			console.log(response)
			if(response.code === 'OK') {
				const list = response.data.content;
				updatePagination(response.data);
				$("#total").html(response.data.totalElements)
				$("#companyListBody").empty();
				for(var i=0;i<list.length;i++) {
					$("#companyListBody").append(
					    "<tr>" +
					        '<td class="text-left">' +
					            '<a href="/company/approvalDetail?custCode=' + list[i].custCode + 
					            '" data-toggle="modal" class="textUnderline notiTitle"> ' + 
					            list[i].custName + 
					            '</a>' +
					        '</td>' +
					        '<td>' + list[i].custType1 + '</td>' +
					        '<td>' + list[i].regnum + '</td>' +
					        '<td>' + list[i].presName + '</td>' +
					        '<td>' + list[i].userName + '</td>' +
					        '<td>' + list[i].createDate + '</td>' +
					    "</tr>"
					);

				}
			} else {
				Swal.fire('', response.msg, 'warning')
			}
		},
		"json"
		);
	}

	
	function onCustDetail(data){
		console.log(data)
	}
	
	function srcCustTypeCodeInit(){
		$('#srcCustTypeCode').val('')
		$('#srcCustTypeName').val('')
		$("#srcCustTypeCodeRemove").css("display", "none")
	}
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
		    <div class="conRight">
		        <div class="conHeader">
		            <ul class="conHeaderCate">
		                <li>업체정보</li>
		                <li>업체승인</li>
		            </ul>
		        </div>
		
		        <div class="contents">
			        <div class="conTopBox">
				        <ul class="dList">
					        <li><div>아래는 가입 신청한 업체 목록 입니다. 업체명을 클릭하여 상세내용을 확인 후 승인 처리 하십시오 (가입 승인은 최대 3일을 넘지 않도록 합니다).</div></li>
					        <li><div>가입 승인이 완료되면 업체 관리자에게 이메일로 통보 됩니다.</div></li>
					        
				        </ul>
			        </div>
		        		                
	                <div class="searchBox mt20">
		                <div class="flex align-items-center">
			                <div class="sbTit mr30">업체명</div>
			                <div class="flex align-items-center width250px">
			                	<input type="text" id="srcCustName" placeholder="" class="inputStyle width200px" autocomplete="off">
			                </div>
			                <div class="sbTit mr30">업체유형</div>
			                <div class="flex align-items-center">
			                <input type="text" id="srcCustTypeName" class="inputStyle width280px readonly" disabled="disabled" placeholder="우측 검색 버튼을 클릭해 주세요">
			                <input type="text" id="srcCustTypeCode" class="inputStyle" hidden="">
			                <a onclick="itemSelectPop()" title="조회" class="btnStyle btnSecondary ml10">조회</a>
			                <button onclick="srcCustTypeCodeInit()" id="srcCustTypeCodeRemove" type="button" title="삭제" class="btnStyle btnOutline" style="display:none">삭제</button>
			                </div>
			                <a class="btnStyle btnSearch" onclick="onApprovalSearch(0)">검색</a>
		                </div>
	                </div>

		
		            <div class="flex align-items-center justify-space-between mt40">
		                <div class="width100">
		                    전체 : <span id="totalElements" class="textMainColor"><strong id="total"></strong></span>건
		                    <select id="pageSize" class="selectStyle maxWidth140px ml20" onchange="onApprovalSearch(0)">
		                        <option value="10">10개씩 보기</option>
		                        <option value="20">20개씩 보기</option>
		                        <option value="30">30개씩 보기</option>
		                        <option value="50">50개씩 보기</option>
		                    </select>
		                </div>
		            </div>
		
		            <table class="tblSkin1 mt10">
		                <colgroup>
		                    <col style="width: 15%" />
		                    <col />
		                    <col style="width: 15%" />
		                    <col style="width: 15%" />
		                </colgroup>
		                <thead>
		                    <tr>
		                        <th>업체명</th>
		                        <th>업체유형</th>
		                        <th>사업자등록번호</th>
		                        <th>대표이사</th>
		                        <th>담당자명</th>
		                        <th class="end">요청일시</th>
		                    </tr>
		                </thead>
		                <tbody id="companyListBody">
		                    
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
    	</div>
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
			<!-- 업체유형 팝업 -->
		<jsp:include page="/WEB-INF/jsp/join/custTypePop.jsp" />

</body>
</html>
