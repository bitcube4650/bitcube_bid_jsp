<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@page import="crosscert.Hash"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/cc/css/certcommon.css?v=1" />
<script src="${pageContext.request.contextPath}/resources/cc/js/unisignwebclient.js?v=1"></script>
<script src="${pageContext.request.contextPath}/resources/cc/js/UniSignWeb_Multi_Init_Nim.js?v=1"></script>
<%
	Calendar cal = Calendar.getInstance();
	Date currentTime = cal.getTime();
	
	/* 서명시 서명원본을 구성하기 현재 시간을 구해옴.
	   구해진 현재시간에서 해쉬값을 추출함.
	*/
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd-hh:mm:ss");
	String timestr=formatter.format(currentTime);
	
	int nRet;
	String Origin_data = ""; 
	
	// 해당 부분 수정 필요 - 실제 https://127.0.0.1:15018/ 에서 통신해서 hash값을 가져오는거 같은데 통신이 안됌.... 확인 필요함
// 	Hash hash = new Hash();
// 	nRet = hash.GetHash(timestr.getBytes(), timestr.getBytes().length);
	
// 	if(nRet==0)		Origin_data = new String(hash.contentbuf);
// 	else			Origin_data = "abcdefghijklmnopqrstuvwxyz1234567890";
	Origin_data = "abcdefghijklmnopqrstuvwxyz1234567890";
%>
<div>
	<input id="businessNum" name="businessNum" type="hidden"/>
	<input id="src" name="src" type="hidden" value="<%=Origin_data%>"/>
	<input id="signed_data" name="signed_data" type="hidden"/>
	<input id="userDn" name="userDn" type="hidden"/>
</div>
<script type="text/javascript">
	// 숫자만 입력되게
	function onlyNumber(event) {
		var key = window.event ? event.keyCode : event.which;
		if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
		|| key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
		|| key  == 8  || key  == 46 || key  == 9) // del, back space, Tab
		) {
			return true;
		}else {
			return false;
		}
	}
	
	// 인증 버튼
	function SignDataRegi() {
		var src = $("#src").val();
		if (src == "") {
			alert("서명할 원문이 없습니다.");
			return;
		}
		// 테스트를 위해 해놓은 것 > 추후 변경필요함
		Swal.fire({
			title: '',
			text: "공인인증서 테스트 진행중입니다.",
			icon: 'question',
			confirmButtonColor: '#3085d6',
			confirmButtonText: '확인',
			showCancelButton: true,
			cancelButtonColor: '#d33',
			cancelButtonText: '취소',	
		}).then((result) => {
			// 공인인증서 창 띄우는 것
			unisign.SignDataNonEnveloped( src, null, "", function( resultObject ) {
				$("#signed_data").val(resultObject.signedData);
				if( !resultObject || resultObject.resultCode !=0 ) {
					alert( resultObject.resultMessage + "\n오류코드 : " + resultObject.resultCode );
					return;
				}
				
				GetRValueFromKeyRegi(resultObject.certAttrs.subjectName);
			});
		}).finally(() => {
			// 사업자번호 초기화
			$("#RegiBusinessNum").val("");
		});
	}
	
	// 공동인증서 인증 내부로직 
	function GetRValueFromKeyRegi(userDN) {
		unisign.GetRValueFromKey(userDN, "", function( resultObject ) {
			if( !resultObject || resultObject.resultCode != 0 ) {
				alert( resultObject.resultMessage + "\n오류코드 : " + resultObject.resultCode );
				return;
			}
			$("#userDn").val(resultObject.RValue);
			fnRegiAuthReg();
		})
	}
	
	// 최종 작동되는 것
	function fnRegiAuthReg() {
		Swal.fire('', '인증되었습니다.', 'info');
	}
</script>

<div class="modal fade modalStyle" id="unisignwebModal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog" style="width:100%; max-width:600px">
		<div class="modal-content">
			<div class="modal-body">
				<a href="javascript:void(0)" class="ModalClose" data-dismiss="modal" title="닫기"><i class="fa-solid fa-xmark"></i></a>
				<h2 class="modalTitle">공동인증서</h2>
				
				<div class="flex align-items-center">
					<div class="formTit flex-shrink0 width120px">사업자등록번호</div>
					<div class="width100">
						<input id="RegiBusinessNum" name="RegiBusinessNum" class="inputStyle" type="text" size="30" maxlength="15" onkeydown="return onlyNumber(event)" placeholder="(-없이)"/> 
					</div>
				</div>
				
				<div class="modalFooter">
					<a href="#" onclick="SignDataRegi()" class="modalBtnCheck" data-dismiss="modal" title="인증">인증</a>
					<a href="javascript:void(0)" class="modalBtnClose" data-dismiss="modal" title="닫기">닫기</a>
				</div>
			</div>
		</div>
	</div>
</div>
