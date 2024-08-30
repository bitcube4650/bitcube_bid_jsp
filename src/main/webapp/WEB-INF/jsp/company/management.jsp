<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		const userAuth = loginInfo.userAuth
		if(userAuth === '2' || userAuth === '4'){
			$('#comPanyInsertBtn').css('display','')
		}


		$('#srcState').val('Y')
		onManageSearch(0);
		
        $('#srcCustName').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onManageSearch(0);
            }
        });
		
        $('#srcCustLogin').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onCustUserSearch();
            }
        });
        
        $('#srcCustUserNm').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onCustUserSearch();
            }
        });
        
		  
	});
	
	
	function itemSelect(itemCode,itemName){
		
		$("#custTypePop").modal('hide')
		$('#srcCustTypeCode').val(itemCode)
		$('#srcCustTypeName').val(itemName)
		$("#srcCustTypeCodeRemove").css("display", "")

	}

	function onManageSearch(page){
		const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
		
		const params = {
			custName: $('#srcCustName').val(),
			custType: $('#srcCustTypeCode').val(),	
			custTypeNm1 : 	$('#srcCustTypeName').val(),
			id : "PartnerApproval",
			"size"		: $("#pageSize").val(),
			"page"		: page,
			interrelatedCustCode : loginInfo.custCode,
			certYn : $("#srcState").val()
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
					            '<a href="/company/managementDetail?custCode=' + list[i].custCode + 
					            '" data-toggle="modal" class="textUnderline notiTitle"> ' + 
					            list[i].custName + 
					            '</a>' +
					        '</td>' +
					        '<td>' + list[i].custType1 + '</td>' +
					        '<td>' + list[i].regnum + '</td>' +
					        '<td>' + list[i].presName + '</td>' +
					        '<td>' + (list[i].certYn === 'Y' ? '정상' : '삭제' ) + '</td>' +
					        '<td>' + list[i].createDate + '</td>' +
							'<td class="text-center"><a class="btnStyle btnSecondary btnSm" onclick="onCustPop(\'' + list[i].custCode + '\')">조회</a></td>' +
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

	function onCustPop(custCode){
		$('#PartnerUser').modal('show')
		$('#custCodeForSrc').val(custCode)
		onCustUserSearch()
	}
	
	function itemSelectPop(){
		$("#custTypePop").modal('show')
	}
	
	
	function srcCustTypeCodeInit(){
		$('#srcCustTypeCode').val('')
		$('#srcCustTypeName').val('')
		$("#srcCustTypeCodeRemove").css("display", "none")
	}
	
	function itemSelectCallback(itemCode, itemName) {
		console.log(itemCode)
		console.log(itemName)
		$("#custTypePop").modal('hide')
		$('#srcCustTypeCode').val(itemCode)
		$('#srcCustTypeName').val(itemName)
		$("#srcCustTypeCodeRemove").css("display", "")

	}
	
	function onCustUserSearch(){

		const params = {
			custCode : $('#custCodeForSrc').val(),
			userName : $('#srcCustUserNm').val(),
			userId : $('#srcCustLogin').val(), 
			useYn : 'Y'
		}
			
		$.post("/api/v1/cust/userListForCust", params, 
				function(response) {
				console.log(response)
				if(response.code === 'OK') {
					const list = response.data.content;

					$("#custUerListTbody").empty();
					for(var i=0;i<list.length;i++) {
						$("#custUerListTbody").append(
						    "<tr>" +
						        '<td>' + list[i].userName + '</td>' +
						        '<td>' + list[i].userId + '</td>' +
						        '<td>' + (list[i].userBuseo || '') + '</td>' +
						        '<td>' + (list[i].userPosition || '')  + '</td>' +
						        '<td>' + list[i].userEmail + '</td>' +
						        '<td>' + onAddDashTel(list[i].userTel) + '</td>' +
						        '<td>' + onAddDashTel(list[i].userHp) + '</td>' +
						        '<td>' + (list[i].userType === '1' ? '업체관리자' : '사용자') + '</td>' +		
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
	
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
		    <div class="conRight">
		        <div class="conHeader">
		            <ul class="conHeaderCate">
		                <li>업체정보</li>
		                <li>업체관리</li>
		            </ul>
		        </div>
		
		        <div class="contents">
			        <div class="conTopBox">
				        <ul class="dList">
					        <li><div>아래는 시스템에서 관리되는 업체 목록 입니다. 업체명을 클릭하면 상세내용을 확인 하실 수 있습니다.</div></li>
					        <li><div>업체를 등록/수정하시면 이력이 남습니다. 주의해서 작성해 주십시오.</div></li>
					        
				        </ul>
			        </div>
		        		                
	                <div class="searchBox mt20">
		                <div class="flex align-items-center">
			                <div class="sbTit mr30">업체명</div>
			                <div class="flex align-items-center width150px">
			                	<input type="text" id="srcCustName" class="inputStyle" autocomplete="off">
			                </div>
			                <div class="sbTit mr30 ml50">상태</div>
								<div class="width120px">
									<select id="srcState" class="selectStyle" onchange="onManageSearch(0)">
										<option value="">전체</option>
										<option value="Y">정상</option>
										<option value="D">삭제</option>
									</select>
								</div>
			                <div class="sbTit mr30 ml50">업체유형</div>
			                <div class="flex align-items-center">
			                <input type="text" id="srcCustTypeName" class="inputStyle width250px readonly" disabled="disabled" placeholder="우측 검색 버튼을 클릭해 주세요">
			                <input type="text" id="srcCustTypeCode" class="inputStyle" hidden="">
			                <a onclick="itemSelectPop()" title="조회" class="btnStyle btnSecondary ml10">조회</a>
			                <button onclick="srcCustTypeCodeInit()" id="srcCustTypeCodeRemove" type="button" title="삭제" class="btnStyle btnOutline" style="display:none">삭제</button>
			                </div>
			                <a class="btnStyle btnSearch" onclick="onManageSearch(0)">검색</a>
		                </div>
	                </div>
					<input type="text" id="custCodeForSrc" class="inputStyle" hidden="">
		
		            <div class="flex align-items-center justify-space-between mt40">
		                <div class="width100">
		                    전체 : <span id="totalElements" class="textMainColor"><strong id="total"></strong></span>건
		                    <select id="pageSize" class="selectStyle maxWidth140px ml20" onchange="onManageSearch(0)">
		                        <option value="10">10개씩 보기</option>
		                        <option value="20">20개씩 보기</option>
		                        <option value="30">30개씩 보기</option>
		                        <option value="50">50개씩 보기</option>
		                    </select>
		                </div>
		                 <div>
		                    <a id="comPanyInsertBtn" href="/company/managementInsert" class="btnStyle btnPrimary" style="display:none;width:107px">업체 등록</a>
		                </div>
		            </div>
		
		            <table class="tblSkin1 mt10">
		                <colgroup>
		                    <col />
		                    <col />
		                    <col/>
		                    <col/>
		                </colgroup>
		                <thead>
		                    <tr>
		                        <th>업체명</th>
		                        <th>업체유형</th>
		                        <th style=" width: 172px;">사업자등록번호</th>
		                        <th style=" width: 172px;">대표이사</th>
		                        <th style=" width: 120px;">상태</th>
		                        <th style=" width: 220px;">등록일시</th>
		                        <th class="end" style=" width: 120px;">조회</th>
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
    	
    	<!-- 협력사 사용자 -->
		<div class="modal fade modalStyle" id="PartnerUser" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:1100px">
				<div class="modal-content">
					<div class="modal-body">
						<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<h2 class="modalTitle">협력사 사용자</h2>
						
						<div class="modalSearchBox mt20">
							<div class="flex align-items-center">
								<div class="sbTit mr30">사용자명</div>
								<div class="width150px">
									<input type="text" id="srcCustUserNm" class="inputStyle" autocomplete="off">
								</div> 
								<div class="sbTit mr30 ml50">로그인 ID</div>
								<div class="width150px">
									<input type="text" id="srcCustLogin" class="inputStyle" autocomplete="off">
								</div>
								<a onclick="onCustUserSearch()" class="btnStyle btnSearch">검색</a>
							</div>
						</div>
						<table class="tblSkin1 mt30">
							<colgroup>
								<col>
							</colgroup>
							<thead>
							<tr>
		                        <th>사용자명</th>
		                        <th>로그인ID</th>
		                        <th>부서</th>
		                        <th>직급</th>
		                        <th>이메일</th>
		                        <th>전화번호</th>
		                        <th>휴대폰</th>
		                        <th>권한</th>
		                    </tr>
							</thead>
							<tbody id="custUerListTbody">

							</tbody>
						</table>
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //협력사 사용자 -->
	
    	<!-- 업체유형 팝업 -->
		<jsp:include page="/WEB-INF/jsp/join/custTypePop.jsp" />
		
</body>
</html>
