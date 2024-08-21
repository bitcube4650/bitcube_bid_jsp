<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<jsp:include page="/WEB-INF/jsp/common.jsp" />
<body>
	<script type="text/javascript">
	$(document).ready(function() {
	    $('#faqType').val('1');
	    onSearch();
	    $('.faq_item_wrap').on('click', '.faq_item', function() {
	        $('.faq_item').removeClass('active');
	        $(this).addClass('active');
	    });

	    $('.faqList a').on('click', function(event) {
	        event.preventDefault();
	        const filter = $(this).data('filter');
	        const faqType = filter.replace('.faq', ''); // Extract the number from .faq1, .faq2, etc.

	        $('#faqType').val(faqType); // Update the hidden input with the selected faqType
	        $('.faqList a').removeClass('active'); // Remove active class from all links
	        $(this).addClass('active'); // Add active class to the clicked link

	        $('.faq_item_wrap .faq_item').hide(); // Hide all faq items
	        $('.faq_item_wrap .faq' + faqType).show(); // Show only the faq items with the selected type
	    });
	});
	
	
	function onSearch(){
		$.post("/api/v1/faq/faqList", {}, function(response) {
			if(response.code === 'OK') {
				console.log(response)
				renderFaqItems(response.data.content);
			} else {
				Swal.fire('', response.msg, 'warning')
			}
		},
		"json"
		);
	}

	function renderFaqItems(faqList) {
	    const faqItemWrap = $('.faq_item_wrap');
	    faqItemWrap.empty();
		const faqType = $('#faqType').val()
	    faqList.forEach((faq,idx) => {
	    	let faqItemHtml
		    	faqItemHtml = `
		            <div class="faq_item faq">
		                <div class="faqTitle">
		                    <div>
		                        <span class="faqQ">Q</span>
		                        <p class="faqTit">${faq.title}</p>
		                    </div>
		                    <i class="fal fa-chevron-down faqIcon"></i>
		                </div>
		                <div class="faqAn">
		                    <span class="faqA">A.</span>
		                    <div class="faqTxt">${faq.answer}</div>
		                </div>
		            </div>
		        `;
	    	

	        faqItemWrap.append(faqItemHtml);
	    });
	}
	
	
	
	function renderFaqItems(faqList) {
	    const faqItemWrap = $('.faq_item_wrap');
	    faqItemWrap.empty();
	    const faqType = $('#faqType').val();

	    faqList.forEach(function(faq, idx) {
	        let faqItemClass = 'faq_item faq faq' + faq.faqType; // faqType 값에 따라 클래스 추가
	        let displayStyle = (faqType == faq.faqType) ? 'block' : 'none'; // faqType이 일치하면 display: block

	        let faqItemHtml = 
	            '<div class="' + faqItemClass + '" style="display: ' + displayStyle + ';">' +
	                '<div class="faqTitle">' +
	                    '<div>' +
	                        '<span class="faqQ">Q</span>' +
	                        '<p class="faqTit">' + faq.title + '</p>' +
	                    '</div>' +
	                    '<i class="fal fa-chevron-down faqIcon"></i>' +
	                '</div>' +
	                '<div class="faqAn">' +
	                    '<span class="faqA">A.</span>' +
	                    '<div class="faqTxt">' + faq.answer + '</div>' +
	                '</div>' +
	            '</div>';

	        faqItemWrap.append(faqItemHtml);
	    });
	}



	
    document.addEventListener('DOMContentLoaded', function() {
        const links = document.querySelectorAll('a[data-filter]');
        links.forEach(link => {
            link.addEventListener('click', function(event) {
                event.preventDefault();
                
                links.forEach(link => link.classList.remove('active'));
                console.log($(this).data('filter'))
                if($(this).data('filter') === '.faq1'){
                	$('#faqType').val('1')
                }else if($(this).data('filter') === '.faq2'){
                	$('#faqType').val('2')
                }else{
                	$('#faqType').val('3')
                }
  
                faqType
                this.classList.add('active');
            });
        });
    });
	
	</script>
	<div id="wrap">
		<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
		<div class="contentWrap">
			<jsp:include page="/WEB-INF/jsp/layout/menu.jsp" />
		    <div class="conRight">
		        <div class="conHeader">
		            <ul class="conHeaderCate">
		                <li>공지</li>
		                <li>FAQ</li>
		            </ul>
		        </div>
		
		        <div class="contents">
		
					<div class="tabStyle tab3 faqList">
						<a data-filter=".faq1" class="active">가입관련</a>		
						<a data-filter=".faq2">입찰관련</a>
						<a data-filter=".faq3">인증서관련</a>
					</div>
					<div class="faq_item_wrap">

					</div>
       			 <input type="text" id="faqType" hidden="">
		        </div>
	
		        <%-- <script src="${pageContext.request.contextPath}/js/adminFaq.js"></script> --%>
		    </div>
    	</div>
    	<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
    		
    </div>
</body>
</html>
