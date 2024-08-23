<%@ page language="java" import="java.io.*,java.util.*,crosscert.*" %>
<%@ page contentType = "text/html; charset=euc-kr" %>


<%  
	/*-------------------------시작----------------------------*/ 
	request.setCharacterEncoding("euc-kr");
	response.setDateHeader("Expires",0); 
	response.setHeader("Prama","no-cache"); 

	if(request.getProtocol().equals("HTTP/1.1")) 
	{ 
		response.setHeader("Cache-Control","no-cache"); 
	} 
	/*------------------------- 끝----------------------------*/ 
	
	String signeddata = request.getParameter("signedText");		// 서명된 값
	String getR = request.getParameter("rvalue");		// 사용자 인증서 R값
	String ssn = request.getParameter("ssn"); //DB에서 검색한 사업자 번호

	// DB에 저장된 주민/사업자번호(SSN)를 가져온다..
	// 아래는 샘플 상 임의로 DB에서 가지고 왔다는 샘플이다 ( SignDataP7GetR.html 에서 가져옴 ) 


	int  nRet;
	boolean boolCertChk = true;
	String ErrMsg = "";
	String ErrCode = "";
	
	
	Base64 CBase64 = new Base64();  
	nRet = CBase64.Decode(signeddata.getBytes(), signeddata.getBytes().length);
	
	if(nRet==0) 
	{
		out.println("서명값 Base64 Decode 결과 : 성공<br>") ;

		Verifier CVerifier = new Verifier();
		nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen); 
		if(nRet==0) 
		{
			out.println("전자서명 검증 결과 : 성공<br>") ;

			String sOrgData = new String(CVerifier.contentbuf);
			out.println("원문 : " + sOrgData + "<br>");
			
			//인증서 정보 추출 결과	
			Certificate CCertificate = new Certificate();
			nRet=CCertificate.ExtractCertInfo(CVerifier.certbuf, CVerifier.certlen);
			if(nRet==0) 
			{			
				out.println("인증서 정보 추출 결과: 성공 <br>");
				
				out.println("인증서 DN  : " + CCertificate.subject +"<br>");
				out.println("==============================================<br>");
				out.println("subject  : " + CCertificate.subject +"<br>");
				out.println("from : " + CCertificate.from +"<br>");
				out.println("to : " + CCertificate.to +"<br>");
				out.println("signatureAlgId : " + CCertificate.signatureAlgId +"<br>");
				out.println("pubkey : " + CCertificate.pubkey +"<br>");
				out.println("signature : " + CCertificate.signature +"<br>");
				out.println("issuerAltName : " + CCertificate.issuerAltName +"<br>");
				out.println("subjectAltName : " + CCertificate.subjectAltName +"<br>");
				out.println("keyusage : " + CCertificate.keyusage +"<br>");
				out.println("policy : " + CCertificate.policy +"<br>");
				out.println("basicConstraint : " + CCertificate.basicConstraint +"<br>");
				out.println("policyConstraint : " + CCertificate.policyConstraint +"<br>");
				out.println("distributionPoint : " + CCertificate.distributionPoint +"<br>");
				out.println("authorityKeyId : " + CCertificate.authorityKeyId +"<br>");
				out.println("subjectKeyId : " + CCertificate.subjectKeyId +"<br>");
				out.println("==============================================<br>");

				String policies = "";
						
				// 개인상호연동용(범용)                            //
				policies +="1.2.410.200004.5.2.1.2"    + "|";          // 한국정보인증               개인                
				policies +="1.2.410.200004.5.1.1.5"    + "|";          // 한국증권전산               개인                
				policies +="1.2.410.200005.1.1.1"      + "|";          // 금융결제원                 개인                
				policies +="1.2.410.200004.5.4.1.1"    + "|";          // 한국전자인증               개인                
				policies +="1.2.410.200012.1.1.1"      + "|";          // 한국무역정보통신           개인 
				policies +="1.2.410.200004.5.5.1.1"      + "|";	       // 이니텍 개인

				// 법인상호연동용(범용)    				
				policies +="1.2.410.200004.5.2.1.1"    + "|";          // 한국정보인증               법인
				policies +="1.2.410.200004.5.1.1.7"    + "|";          // 한국증권전산               법인, 단체, 개인사업자
				policies +="1.2.410.200005.1.1.5"      + "|";          // 금융결제원                 법인, 임의단체, 개인사업자
				policies +="1.2.410.200004.5.4.1.2"    + "|";          // 한국전자인증               법인, 단체, 개인사업자
				policies +="1.2.410.200012.1.1.3"      + "|";          // 한국무역정보통신           법인
				policies +="1.2.410.200004.5.5.1.2"      + "|";	       // 이니텍 법인
				
				// 개인 용도제한용 인증서정책(OID)                 용도                    공인인증기관
				policies += "1.2.410.200004.5.4.1.101|";        // 은행거래용/보험용       한국전자인증
				policies += "1.2.410.200004.5.4.1.102|";        // 증권거래용              한국전자인증
				policies += "1.2.410.200004.5.4.1.103|";        // 신용카드용              한국전자인증
				policies += "1.2.410.200004.5.4.1.104|";        // 전자민원용              한국전자인증
				policies += "1.2.410.200004.5.2.1.7.1|";        // 은행거래용/보험용       한국정보인증
				policies += "1.2.410.200004.5.2.1.7.2|";        // 증권거래용/보험용       한국정보인증
				policies += "1.2.410.200004.5.2.1.7.3|";        // 신용카드용              한국정보인증
				policies += "1.2.410.200004.5.1.1.9|";          // 증권거래용/보험용       한국증전산
				policies += "1.2.410.200004.5.1.1.9.2|";        // 신용카드용              한국증전산
				policies += "1.2.410.200005.1.1.4|";            // 은행거래용/보험용       금융결제원
				policies += "1.2.410.200005.1.1.6.2|";          // 신용카드용              금융결제원
				policies += "1.2.410.200012.1.1.101|";          // 은행거래용/보험용       한국무역정보통신
				policies += "1.2.410.200012.1.1.103|";          // 증권거래용/보험용       한국무역정보통신
				policies += "1.2.410.200012.1.1.105|";           // 신용카드용              한국무역정보통신


				// 인증서 검증
				nRet=CCertificate.ValidateCert(CVerifier.certbuf, CVerifier.certlen, policies, 1);

				if(nRet==0) 
				{
					out.println("인증서 검증 결과 : 성공<br>") ;

					// 식별번호 검증	 주민/사업자번호와 getR 값을 통한 신원확인
					nRet=CCertificate.VerifyVID(CVerifier.certbuf, CVerifier.certlen, getR.getBytes(), getR.length(), ssn);
					if(nRet==0) 
					{
						out.println("식별번호 검증 결과 : 성공<br>") ;
					}
					else
					{
						boolCertChk = false;
						out.println("식별번호 검증 결과 : 실패<br>") ;

						ErrMsg = "식별번호 검증 실패 [ 에러내용 : " + CCertificate.errmessage + " ]";
						ErrCode = "에러코드 [ " + CCertificate.errcode + " ]";  
						out.println("인증서 식별번호 검증 실패");
					}
				}
				else
				{
					boolCertChk = false;
					ErrMsg = "인증서 검증 실패 [ 에러내용 : " + CCertificate.errmessage + " ]";
					ErrCode = "에러코드 [ " + CCertificate.errcode + " ]";  
				}// 인증서만 검증if문 끝
			
			}
			else
			{
				boolCertChk = false;
				ErrMsg = "인증서 추출 실패 [ 에러내용 : " + CCertificate.errmessage + " ]";
				ErrCode = "에러코드 [ " + CCertificate.errcode + " ]";  
			}
		}//
		else
		{			
			boolCertChk = false;
			ErrMsg = "전자서명 검증 결과 실패 [ 에러내용 : " + CVerifier.errmessage + " ]";
			ErrCode = "에러코드 [ " + CVerifier.errcode + " ]";  
		}
	}//
	else
	{
		boolCertChk = false;
		ErrMsg = "서명값 Base64 Decode 결과 실패 [ 에러내용 : " + CBase64.errmessage + " ]";
		ErrCode = "에러코드 [ " + CBase64.errcode + " ]";  
	} //서명값 Base64 Decode If문 끝...
	if (boolCertChk == false)
	{
%>
		<SCRIPT LANGUAGE="JavaScript">
		<!--
			alert("<%=ErrMsg%>\n\n<%=ErrCode%>");
			alert("전자서명을 다시 하여 주십시오");
		//-->
		</SCRIPT>
<%
	}
	else
	{
		out.print("인증서 최종검증 성공<br>");
		out.print("시스템 이용하기");
	}
%>
