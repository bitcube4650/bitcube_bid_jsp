<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
/*
	function async retrieve() {
		try {
			this.$store.commit('loading');
    		this.$store.commit('searchParams', this.searchParams);
			const response = await this.$http.post('/api/v1/faq/faqList', this.searchParams);
			this.listPage = response.data;
			this.$store.commit('finish');
		} catch(err) {
			console.log(err)
			this.$store.commit('finish');
		}
	}
	*/
</script>
<body>
	<!-- 본문 -->
	<div class="conRight">
		<!-- conHeader -->
		<div class="conHeader">
			<ul class="conHeaderCate">
				<li>공지</li>
				<li>FAQ</li>
			</ul>
		</div>
		<!-- //conHeader -->
		<!-- contents -->
		<div class="contents">

			<!-- 가입관련은 faq1, 입찰관련 faq2, 인증서관련 faq3으로 필터됌 -->
			<div class="tabStyle tab3 faqList">
				<a id="faq1" data-filter=".faq1" class="active">가입관련</a>		
				<a id="faq2" data-filter=".faq2">입찰관련</a>
				<a id="faq3" data-filter=".faq3">인증서관련</a>
			</div>
			<div class="faq_item_wrap">
				<div>
					<div class="faqTitle"><div><span class="faqQ">Q</span><p class="faqTit">{{ title}}</p></div><i class="fal fa-chevron-down faqIcon"></i></div>
					<div class="faqAn">
						<span class="faqA">A.</span>
						<div class="faqTxt">
							<pre v-html="val.answer" style="background-color: white;"></pre>
						</div>
					</div>
				</div>
			</div>

		</div>
		<!-- //contents -->
	</div>
	<!-- //본문 -->
</body>
</html>