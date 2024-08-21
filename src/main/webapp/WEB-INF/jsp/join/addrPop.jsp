<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function initModal() {
	$("#addrPop").modal('show');
	
	let elementLayer = document.getElementById("daumAddrLayer");
	elementLayer.style.display = 'block';
    elementLayer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - 500) / 2 - 5) + 'px';
	
	new daum.Postcode({
		oncomplete: function(data) {
			let addr = '';
			let extraAddr = '';

			if (data.userSelectedType === 'R') {
				addr = data.roadAddress;
			} else {
				addr = data.jibunAddress;
			}

			if (data.userSelectedType === 'R') {
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraAddr += data.bname;
				}
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				if (extraAddr !== '') {
					extraAddr = ` (${extraAddr})`;
				}
			}

			callbackAddr(data.zonecode, addr, extraAddr);
			closeAddr();
		},
		width: '100%',
		height: '100%',
		maxSuggestItems : 5
	}).embed(elementLayer);
	
}

function callbackAddr(zipcode, addr, addrDetail) {
	let data = { zipcode, addr, addrDetail };
	addrPopCallback(data);
}

function closeAddr(){
	$("#addrPop").modal('hide');
}
</script>
<div class="modal fade" id="addrPop" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:100%; max-width:800px">
		<div id="daumAddrLayer" style="display:none; position:fixed; overflow:hidden; z-index: 1; width:750px; height:500px; border:5px solid;">
			<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer" style="cursor:pointer; position:absolute; right:-3px; top:-3px; z-index: 1;" onClick="closeAddr()" alt="닫기 버튼" />
		</div>
	</div>
</div> 