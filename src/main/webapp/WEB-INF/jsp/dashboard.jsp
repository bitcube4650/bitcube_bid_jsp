<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<script>
$(function(){
	selectNotice();
})
function fnChkPwChangeEncourage() {
	let params = {
		userId : loginInfo.userId,
		isGroup : true
	}
	
	$.post(
		"/api/v1/main/chkPwChangeEncourage",
		params,
		function(arg){
			if (arg.data.code == "OK") {
				if(arg.data.data){
					//setPwInit(true);
				}
			}
		},
		"json"
	);
};

function moveBiddingPage(keyword) {
	let params = {
		'keyword' : keyword
	}
	if (keyword === 'planning') {
		location.href="/api/v1/move?viewName=bid/progress";
	} else if (keyword === 'completed' || keyword === 'unsuccessful') {
		location.href="/api/v1/move?viewName=bid/complete&keyword="+keyword;
	} else {
		location.href="/api/v1/move?viewName=bid/status&keyword="+keyword;
	}
};

function onMoveNotice() {
	location.href="/api/v1/move?viewName=system/notice";
}

function selectNotice() {
	$.post(
		'/api/v1/notice/noticeList', 
		{ size: '7', page: '0' })
		.done(function(arg) {
			if (arg.code === "OK") {
				let data = arg.data.content;
				
				let text = "";
				for(let i = 0 ; i < data.length ; i++){
					text += '<a href="javascript:onNoticeDetail()" data-toggle="modal" data-target="#notiModal" title="해당 게시글 자세히 보기">';
					text += 	'<span class="notiTit">' + (data[i].bco === 'ALL' ? '[공통]' : '') + data[i].btitle + '</span>';
					text +=		'<span class="notiDate" style="width:170px;">' + data[i].bdate +'</span>';
					text += "</a>"
				}
				
				$("#notiList").html(text);
			}
		})
		.fail(function(request, status, error) {
			let param = JSON.parse(request.responseText);
			Swal.fire({
				title: '',			  // 타이틀
				text: param.error == undefined || param.error == null ? '문제가 발생하였습니다.' : param.error,  // 내용
				icon: 'error',						// success / error / warning / info / question
			}).then((result) => {
				if(request.status === 999){
					location.href="/";
				}
			});
		})
}

function selectBidCnt() {
	$.post(
		"/api/v1/main/selectBidCnt",
		{ size: 7, page: 0 },
		function(arg){
			if (arg.data.code == "OK") {
				console.log(arg.data.data);
				$("#planning").text();
				$("#noticing").text();
				$("#beforeOpening").text();
				$("#opening").text();
				$("#completed").text();
				$("#unsuccessful").text();
				
			}
		},
		"json"
	);
};

function selectPartnerCnt() {
	$.post(
		"/api/v1/main/selectPartnerCnt",
		{},
		function(arg){
			if (arg.data.code == "OK") {
				console.log(arg.data.data);
				$("#request").text();
				$("#approval").text();
				$("#deletion").text();
				
			}
		},
		"json"
	);
};

</script>
<body>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
			
			<div class="conRight">
				<div class="conHeader" style="padding: '23px 30px 20px 30px';">
					<ul class="conHeaderCate">
						<li>메인</li>
					</ul>
				</div>
				<div class="contents">
					<div class="mainConLayout" style="margin-top: '10px' ">
						<div class="mcl_left mainConBox" style=" height: '700px' ">
							<h2 class="h2Tit">전자입찰</h2>
							<div class="biddingList">
								<a onClick="moveBiddingPage('planning')" class="biddingStep1">
									<div class="biddingListLeft" style="height: '70px';"><i class="fa-light fa-flag"></i>입찰계획</div><!-- 공고전 상태 -->
									<div class="biddingListRight"><span id="planning">0</span>건<i class="fa-light fa-angle-right"></i></div>
								</a>
			
								<a onClick="moveBiddingPage('noticing')" class="biddingStep2">
									<div class="biddingListLeft" style="height: '70px'"><i class="fa-light fa-comments"></i>입찰진행(입찰공고)</div><!-- 공고는 되었지만 개찰은 안된 상태(재입찰 포함) -->
									<div class="biddingListRight"><span id="noticing">0</span>건<i class="fa-light fa-angle-right"></i></div>
								</a>
								<a onClick="moveBiddingPage('beforeOpening')" class="biddingStep3">
									<div class="biddingListLeft" style="height: '70px'"><i class="fa-light fa-files"></i>입찰진행(개찰대상)</div><!-- 공고는 되었는데 공고 기간이 지난 입찰(재입찰 포함) -->
									<div class="biddingListRight"><span id="beforeOpening">0</span>건<i class="fa-light fa-angle-right"></i></div>
								</a>
								<a onClick="moveBiddingPage('opening')" class="biddingStep4">
									<div class="biddingListLeft" style="height: '70px'"><i class="fa-light fa-file-check"></i>입찰진행(개찰)</div><!-- 개찰은 되었지만 업체 선정이 안된 상태 -->
									<div class="biddingListRight"><span id="opening">0</span>건<i class="fa-light fa-angle-right"></i></div>
								</a>
								<a onClick="moveBiddingPage('completed')" class="biddingStep5">
									<div class="biddingListLeft" style="height: '70px'"><i class="fa-light fa-puzzle-piece"></i>입찰완료 (12개월)</div><!-- 업체선정까지 완료된 상태(업체 선정된 시점이 12개월 이내) -->
									<div class="biddingListRight"><span id="completed">0</span>건<i class="fa-light fa-angle-right"></i></div>
								</a>
								<a onClick="moveBiddingPage('unsuccessful')" class="biddingStep5">
									<div class="biddingListLeft" ><i class="fa-light fa-puzzle-piece"></i>유찰 (12개월)</div><!-- 유찰된 시점이 12개월이내 -->
									<div class="biddingListRight"><span id="unsuccessful">0</span>건<i class="fa-light fa-angle-right"></i></div>
								</a>
							</div>
						</div>
						<div class="mcl_right">
							<div class="mainConBox">
								<h2 class="h2Tit">협력업체<a href="api/v1/move?viewName=company/partner/management" title="협력업체 페이지로 이동" class="mainConBoxMore">더보기<i class="fa-solid fa-circle-plus"></i></a></h2>
								<div class="cooperativ">
									<a href="/company/partner/approval" title="미승인 업체 페이지로 이동">
										<span class="cooperativ_tit">미승인 업체</span>
										<span class="cooperativ_num" id="request">0</span>
									</a>
									<a href="/company/partner/management" title="승인 업체 (인증서 제출) 페이지로 이동">
										<span class="cooperativ_tit">승인 업체</span>
										<span class="cooperativ_num" id="approval">0</span>
									</a>
									<a href="/company/partner/management?certYn=D" title="삭제 업체 페이지로 이동">
										<span class="cooperativ_tit">삭제 업체</span>
										<span class="cooperativ_num" id="deletion">0</span>
									</a>
								</div>
							</div>
							<div class="mainConBox" style="height: '381.41px'">
								<h2 class="h2Tit">공지사항<a onClick="onMoveNotice()" title="공지사항 페이지로 이동" class="mainConBoxMore">더보기<i class="fa-solid fa-circle-plus"></i></a></h2>
								<div class="notiList" id="notiList">
								</div>
							</div>
						</div>
					</div>
				</div>
				 <!-- <PwInitPop pwInit={pwInit} setPwInit={setPwInit} />  -->
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
	</div>
</body>
</html>