<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
		$('#srcUseYn').val('Y')
		onSearch(0);
		itemGrpList()
		
        $('#srcItemCode').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onSearch(0);
            }
        });
		
        $('#srcItemName').keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                onSearch(0);
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
							$("#srcItemGrp").append($("<option value='"+list[i].value+"'>"+list[i].name+"</option>"))
							
							$("#saveItemGrp").append($("<option value='"+list[i].value+"'>"+list[i].name+"</option>"))
							
						}
	
					}
					
				}
			});
	}
	
	function onSearch(page){
		const params = {
			itemGrp : 	$('#srcItemGrp').val(),
			useYn : $('#srcUseYn').val(),
			itemCode : $('#srcItemCode').val(),
			itemName : $('#srcItemName').val(),
			"size"		: $("#pageSize").val(),
			"page"		: page
		}
		
		$.post("/api/v1/item/itemList", params, 
			function(response) {
			console.log(response)
			if(response.code === 'OK') {
				var list = response.data.content;
				updatePagination(response.data);
				$("#total").html(response.data.totalElements)
				$("#itemListBody").empty();
				for(var i=0;i<list.length;i++) {
					$("#itemListBody").append(
						"<tr>" +
							'<td class="text-left"><a data-toggle="modal" class="textUnderline notiTitle" onClick="itemEditModal(\'' + encodeURIComponent(JSON.stringify(list[i]))  + '\')">' + list[i].itemCode + '</a></td>' +
							'<td class="text-left"><a data-toggle="modal" class="textUnderline notiTitle"  onClick="itemEditModal(\'' + encodeURIComponent(JSON.stringify(list[i]))  + '\')">' + list[i].itemName + '</a></td>' +
							'<td>'+ list[i].grpNm +'</td>'+
							'<td>'+ (list[i].useYn ==='Y' ? '사용' : '미사용' )+'</td>'+
							'<td>'+ (list[i].createUser || '') +'</td>'+
							'<td>'+ (list[i].createDate || '')+'</td>'+
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
	
	function itemRegModal(){
		
		$('#saveItemCode').attr('disabled', false);
   		$('#saveItemCode').val(''),
   		$('#saveItemGrp').val(''),
   		$('#saveItemName').val(''),
   		$('#saveUseYn').val('Y'),
   		
   		
		$('#itemSave').modal('show')
		$("#saveTypeStr").empty();
		$('#saveTypeStr').append('품목 등록')
	}
	
	function itemCodeNum(input){
		input.value = input.value.replace(/[^0-9]/g, '');
	}
	
	function onItemSave(){
		
		if(!$('#saveItemCode').val()){
			Swal.fire('', '품목코드를 입력해 주세요.', 'warning')
			return
		}
		 
		if(!$('#saveItemGrp').val()){
			Swal.fire('', '품목코드을 선택해 주세요.', 'warning')
			return
		}
		
		if(!$('#saveItemName').val().trim()){
			Swal.fire('', '품목 이름을 입력해 주세요.', 'warning')
			$('#saveItemName').val('')
			return
		}
		
		if(!$('#saveUseYn').val()){
			Swal.fire('', '품목코드을 선택해 주세요.', 'warning')
			return
		}

		
        const params = {
       		itemCode : $('#saveItemCode').val(),
       		itemGrpCd : $('#saveItemGrp').val(),
       		itemName : $('#saveItemName').val(),
       		useYn : $('#saveUseYn').val(),
        }
        
		const saveType = $("#saveTypeStr").html();
		let saveUrl = '';
		if(saveType.includes("등록")){
			const loginInfo = JSON.parse(localStorage.getItem("loginInfo"))
			params.createUser = loginInfo.userId
			saveUrl = 'save'
		}else{
			saveUrl = 'saveUpdate'
		}
		
		console.log(params)
		console.log(saveUrl)
		
		$.post(
			'/api/v1/item/'+saveUrl,
			params
		)
		.done(function(arg) {
			if (arg.code === "OK") {
				Swal.fire('', '품목이 정상적으로 저장되었습니다.', 'info');
				onSearch(0);
				$('#itemSave').modal('hide')
			}else if(arg.code === "DUP"){
	            Swal.fire('', '이미 등록된 품목 코드입니다.', 'warning');
			}
			else{
	            Swal.fire('', '품목 저장을 실패하였습니다.', 'warning');
	            return
			}
		})
		
	}
	
	function itemEditModal(data){
		const rowData = JSON.parse(decodeURIComponent(data))
		console.log(rowData)
   		$('#saveItemCode').val(rowData.itemCode)
   		$('#saveItemCode').attr('disabled', true);
   		$('#saveItemGrp').val(rowData.itemGrpCd)
   		$('#saveItemName').val(rowData.itemName)
   		$('#saveUseYn').val(rowData.useYn)
   		
   		
		$('#itemSave').modal('show')
		$("#saveTypeStr").empty();
		$('#saveTypeStr').append('품목 수정')
	}
	
	
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
		    <div class="conRight">
		        <div class="conHeader">
		            <ul class="conHeaderCate">
		                <li>정보관리</li>
		                <li>품목정보관리</li>
		            </ul>
		        </div>
		
		        <div class="contents">
			        <div class="conTopBox">
				        <ul class="dList">
					        <li><div>협력사 등록(업체유형)과 입찰 생성(입찰 품목) 시 필요한 항목입니다.</div></li>
					        <li><div>품목코드 및 품목명을 클릭하면 품목을 수정할 수 있습니다. (등록된 품목 코드는 수정할 수 없습니다)</div></li>
					        <li><div>품목 코드는 중복될 수 없습니다.</div></li>
					        
				        </ul>
			        </div>
		        		                
	                <div class="searchBox mt20">
		                <div class="flex align-items-center">
			                <div class="sbTit width100px">품목그룹</div>
			                <div class="flex align-items-center width250px">
				                <select id="srcItemGrp" class="selectStyle" onchange="onSearch(0)">
				                <option value="">전체</option>
			                </select>
			                </div>
			                <div class="sbTit width100px ml50">사용여부</div>
			                <div class="flex align-items-center width250px">
			                <select id="srcUseYn" class="selectStyle" onchange="onSearch(0)">
				                <option value="">전체</option>
				                <option value="Y">사용</option>
				                <option value="N">미사용</option>
			                </select>
			                </div>
		                </div>
		                <div class="flex align-items-center height50px mt10">
			                <div class="sbTit width100px">품목코드</div>
			                <div class="flex align-items-center width250px">
			                	<input type="text" id="srcItemCode" placeholder="" class="inputStyle">
			                </div>
			                <div class="sbTit width100px ml50">품목명</div>
			                <div class="width250px"
				                ><input type="text" id="srcItemName" class="inputStyle">
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
		                <div class="flex-shrink0">
		                    <a class="btnStyle btnPrimary" onClick="itemRegModal()" title="품목 등록">품목 등록</a>
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
		                        <th>품목코드</th>
		                        <th>품목명</th>
		                        <th>품목그룹</th>
		                        <th>사용여부</th>
		                        <th>등록자</th>
		                        <th class="end">등록일시</th>
		                    </tr>
		                </thead>
		                <tbody id="itemListBody">
		                    
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
		
		<!-- 품목 저장 -->
		<div class="modal fade modalStyle" id="itemSave" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog" style="width:100%; max-width:500px">
				<div class="modal-content">
					<div class="modal-body">
						<a class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
						<h2 class="modalTitle" id="saveTypeStr"></h2>
						<div class="flex align-items-center">
							<div class="formTit flex-shrink0 width120px">품목코드 <span class="star">*</span></div>
							<div class="width100"><input type="text" id="saveItemCode" class="inputStyle" placeholder="숫자만" maxlength="10" oninput="itemCodeNum(this)"></div>
						</div>
						<div class="flex align-items-center mt20">
							<div class="formTit flex-shrink0 width120px">품목그룹</div>
							<div class="width100">
								<select class="selectStyle" id="saveItemGrp">
									<option value="">선택</option>
								</select>
							</div> 
						</div>
						<div class="flex align-items-center mt20">
							<div class="formTit flex-shrink0 width120px">품목명 <span class="star">*</span></div>
							<div class="width100"><input type="text" id="saveItemName" class="inputStyle" placeholder=""></div>
						</div>
						<div class="flex align-items-center mt10">
							<div class="formTit flex-shrink0 width120px">사용여부 <span class="star">*</span></div>
							<div class="width100">
								<select id="saveUseYn"  class="selectStyle">
									<option value="Y">사용</option>
									<option value="N">미사용</option>
								</select>
							</div>
						</div>
	
						<div class="modalFooter">
							<a class="modalBtnClose" data-dismiss="modal" title="취소">취소</a>
							<a onclick="onItemSave()" class="modalBtnCheck" title="저장">저장</a>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<!-- //품목 저장 -->	
</body>
</html>
