<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		onSearch(0);
		
        $('#srcCustName').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onSearch(0);
            }
        });
		
        $('#srcItemName').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onItemList();
            }
        });
		
	});
	
	function itemGrpList(){
		$.post(
				'/api/v1/item/itemGrpList',null
			).done(function(arg){
				if(arg.code == "ERROR"){
					Swal.fire('', arg.msg, 'error');
				} else {
					const list = arg.data;
					
					
					if(list.length > 0){
						for(let i = 0; i < list.length; i++){
							$("#srcItemList").append($("<option value='"+list[i].value+"'>"+list[i].name+"</option>"))
														
						}
	
					}
					
				}
			});
	}
	
	function onItemList(){
		const params = {
			itemGrp: $('#srcCustTypeCode').val(),
			itemName : 	$('#srcCustTypeName').val(),
			useYn : 'Y'	,
			"size"	: '5',
			"page"	: 0
		}
		
		$.post("/api/v1/login/itemList", params, 
			function(response) {
				if(response.code === 'OK') {
					const list = response.data.content;
					updatePagination(response.data);
					$("#total").html(response.data.totalElements)
					$("#itemListBody").empty();
					for(var i=0;i<list.length;i++) {
					$("#itemListBody").append(
						"<tr>" +
							'<td>'+ list[i].itemCode +'</td>'+
							'<td>'+ list[i].itemName +'</td>'+
							'<td> <a onclick="itemSelect(\''+ list[i].itemCode +'\', \''+ list[i].itemName +'\')" title="선택" class="btnStyle btnSecondary btnSm">선택</a></td>'+
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

	
	function itemSelect(itemCode,itemName){
		
		$('#srcCustTypeName').val(itemName)
		$('#srcCustTypeCode').val(itemCode)
		$('#selectItem').modal('hide')

	}
	function itemSelectPop(){
		
		$('#srcItemList').val('')
		$('#srcItemName').val('')
		   
		$('#selectItem').modal('show')
		itemGrpList()
		onItemList()
	}
	function onSearch(page){
		const params = {
			custName: $('#srcCustName').val(),
			custTypeCode1 : $('#srcCustTypeCode').val(),	
			custTypeNm1 : 	$('#srcCustTypeName').val(),
			id : "PartnerApproval",
			"size"		: $("#pageSize").val(),
			"page"		: page
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
					        '<td class="text-left">' +
					            '<a href="/company/approvalDetail?custCode=' + list[i].custCode + 
					            '" data-toggle="modal" class="textUnderline notiTitle"> ' + 
					            list[i].custType1 + 
					            '</a>' +
					        '</td>' +
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
		$("#srcCustTypeCodeRemove").css("display", "")
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
			                	<input type="text" id="srcCustName" placeholder="" class="inputStyle width200px" >
			                </div>
			                <div class="sbTit mr30">업체유형</div>
			                <div class="flex align-items-center">
			                <input type="text" id="srcCustTypeName" class="inputStyle width280px readonly" disabled="disabled" placeholder="우측 검색 버튼을 클릭해 주세요">
			                <input type="text" id="srcCustTypeCode" class="inputStyle" hidden="">
			                <a onclick="itemSelectPop()" title="조회" class="btnStyle btnSecondary ml10">조회</a>
			                <button onclick="srcCustTypeCodeInit()" id="srcCustTypeCodeRemove" type="button" title="삭제" class="btnStyle btnOutline" style="display:none">삭제</button>
			                </div>
			                <a class="btnStyle btnSearch" onclick="onSearch(0)">검색</a>
		                </div>
	                </div>

		
		            <div class="flex align-items-center justify-space-between mt40">
		                <div class="width100">
		                    전체 : <span id="totalElements" class="textMainColor"><strong id="total"></strong></span>건
		                    <select id="pageSize" class="selectStyle maxWidth140px ml20" onchange="onSearch(0)">
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
		

		<!-- 품목 선택 -->
		<div class="modal fade modalStyle" id="selectItem" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:650px">
				<div class="modal-content">
					<div class="modal-body">
						<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<h2 class="modalTitle">품목 선택</h2>
						<div class="modalTopBox">
							<ul>
								<li><div>검색 창에 품목명 또는 품목코드를 입력하시고 엔터 또는 [품목조회]버튼을 클릭하시고 품목을 선택해 주십시오.</div></li>
								<li><div>품목코드는 2017년부터 적용되는 한국표준산업분류 10차 개정 자료를 기준으로 합니다.</div></li>
							</ul>
						</div>
						
						<div class="modalSearchBox mt20">
							<div class="flex">
								<div class="width100">
									<select id="srcItemList" class="selectStyle" onchange="onItemList()">
										<option value="">품목그룹 전체</option>
									</select>
									<input type="text" id="srcItemName" class="inputStyle mt10" placeholder="품목명 또는 품목코드 입력 조회">
								</div>
								<div class="flex-shrink0 align-self-end ml20">
									<a onclick="itemGrpList(search)" class="btnStyle btnOutlineRed width100px" >검색</a>
								</div>							
							</div>
						</div>
						<table class="tblSkin1 mt30">
							<colgroup>
								<col style="width:15%">
								<col style="width:*%">
								<col style="width:15%">
							</colgroup>
							<thead>
								<tr>
									<th>품목코드</th>
									<th>품목명</th>
									<th class="end">선택</th>
								</tr>
							</thead>
							<tbody id="itemListBody">
							</tbody>
						</table>
						<!-- pagination -->
						 <div class="row mt40">
			                <div class="col-xs-12">
			                    <jsp:include page="/WEB-INF/jsp/pagination.jsp" />
			                </div>
			            </div>
						<!-- //pagination -->
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //품목 선택 -->
</body>
</html>
