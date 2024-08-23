<%@ page language="java" import="java.io.*,java.util.*,crosscert.*" %>
<%@ page contentType = "text/html; charset=euc-kr" %>


<%  
	/*-------------------------����----------------------------*/ 
	request.setCharacterEncoding("euc-kr");
	response.setDateHeader("Expires",0); 
	response.setHeader("Prama","no-cache"); 

	if(request.getProtocol().equals("HTTP/1.1")) 
	{ 
		response.setHeader("Cache-Control","no-cache"); 
	} 
	/*------------------------- ��----------------------------*/ 
	
	String signeddata = request.getParameter("signedText");		// ����� ��
	String getR = request.getParameter("rvalue");		// ����� ������ R��
	String ssn = request.getParameter("ssn"); //DB���� �˻��� ����� ��ȣ

	// DB�� ����� �ֹ�/����ڹ�ȣ(SSN)�� �����´�..
	// �Ʒ��� ���� �� ���Ƿ� DB���� ������ �Դٴ� �����̴� ( SignDataP7GetR.html ���� ������ ) 


	int  nRet;
	boolean boolCertChk = true;
	String ErrMsg = "";
	String ErrCode = "";
	
	
	Base64 CBase64 = new Base64();  
	nRet = CBase64.Decode(signeddata.getBytes(), signeddata.getBytes().length);
	
	if(nRet==0) 
	{
		out.println("���� Base64 Decode ��� : ����<br>") ;

		Verifier CVerifier = new Verifier();
		nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen); 
		if(nRet==0) 
		{
			out.println("���ڼ��� ���� ��� : ����<br>") ;

			String sOrgData = new String(CVerifier.contentbuf);
			out.println("���� : " + sOrgData + "<br>");
			
			//������ ���� ���� ���	
			Certificate CCertificate = new Certificate();
			nRet=CCertificate.ExtractCertInfo(CVerifier.certbuf, CVerifier.certlen);
			if(nRet==0) 
			{			
				out.println("������ ���� ���� ���: ���� <br>");
				
				out.println("������ DN  : " + CCertificate.subject +"<br>");
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
						
				// ���λ�ȣ������(����)                            //
				policies +="1.2.410.200004.5.2.1.2"    + "|";          // �ѱ���������               ����                
				policies +="1.2.410.200004.5.1.1.5"    + "|";          // �ѱ���������               ����                
				policies +="1.2.410.200005.1.1.1"      + "|";          // ����������                 ����                
				policies +="1.2.410.200004.5.4.1.1"    + "|";          // �ѱ���������               ����                
				policies +="1.2.410.200012.1.1.1"      + "|";          // �ѱ������������           ���� 
				policies +="1.2.410.200004.5.5.1.1"      + "|";	       // �̴��� ����

				// ���λ�ȣ������(����)    				
				policies +="1.2.410.200004.5.2.1.1"    + "|";          // �ѱ���������               ����
				policies +="1.2.410.200004.5.1.1.7"    + "|";          // �ѱ���������               ����, ��ü, ���λ����
				policies +="1.2.410.200005.1.1.5"      + "|";          // ����������                 ����, ���Ǵ�ü, ���λ����
				policies +="1.2.410.200004.5.4.1.2"    + "|";          // �ѱ���������               ����, ��ü, ���λ����
				policies +="1.2.410.200012.1.1.3"      + "|";          // �ѱ������������           ����
				policies +="1.2.410.200004.5.5.1.2"      + "|";	       // �̴��� ����
				
				// ���� �뵵���ѿ� ��������å(OID)                 �뵵                    �����������
				policies += "1.2.410.200004.5.4.1.101|";        // ����ŷ���/�����       �ѱ���������
				policies += "1.2.410.200004.5.4.1.102|";        // ���ǰŷ���              �ѱ���������
				policies += "1.2.410.200004.5.4.1.103|";        // �ſ�ī���              �ѱ���������
				policies += "1.2.410.200004.5.4.1.104|";        // ���ڹο���              �ѱ���������
				policies += "1.2.410.200004.5.2.1.7.1|";        // ����ŷ���/�����       �ѱ���������
				policies += "1.2.410.200004.5.2.1.7.2|";        // ���ǰŷ���/�����       �ѱ���������
				policies += "1.2.410.200004.5.2.1.7.3|";        // �ſ�ī���              �ѱ���������
				policies += "1.2.410.200004.5.1.1.9|";          // ���ǰŷ���/�����       �ѱ�������
				policies += "1.2.410.200004.5.1.1.9.2|";        // �ſ�ī���              �ѱ�������
				policies += "1.2.410.200005.1.1.4|";            // ����ŷ���/�����       ����������
				policies += "1.2.410.200005.1.1.6.2|";          // �ſ�ī���              ����������
				policies += "1.2.410.200012.1.1.101|";          // ����ŷ���/�����       �ѱ������������
				policies += "1.2.410.200012.1.1.103|";          // ���ǰŷ���/�����       �ѱ������������
				policies += "1.2.410.200012.1.1.105|";           // �ſ�ī���              �ѱ������������


				// ������ ����
				nRet=CCertificate.ValidateCert(CVerifier.certbuf, CVerifier.certlen, policies, 1);

				if(nRet==0) 
				{
					out.println("������ ���� ��� : ����<br>") ;

					// �ĺ���ȣ ����	 �ֹ�/����ڹ�ȣ�� getR ���� ���� �ſ�Ȯ��
					nRet=CCertificate.VerifyVID(CVerifier.certbuf, CVerifier.certlen, getR.getBytes(), getR.length(), ssn);
					if(nRet==0) 
					{
						out.println("�ĺ���ȣ ���� ��� : ����<br>") ;
					}
					else
					{
						boolCertChk = false;
						out.println("�ĺ���ȣ ���� ��� : ����<br>") ;

						ErrMsg = "�ĺ���ȣ ���� ���� [ �������� : " + CCertificate.errmessage + " ]";
						ErrCode = "�����ڵ� [ " + CCertificate.errcode + " ]";  
						out.println("������ �ĺ���ȣ ���� ����");
					}
				}
				else
				{
					boolCertChk = false;
					ErrMsg = "������ ���� ���� [ �������� : " + CCertificate.errmessage + " ]";
					ErrCode = "�����ڵ� [ " + CCertificate.errcode + " ]";  
				}// �������� ����if�� ��
			
			}
			else
			{
				boolCertChk = false;
				ErrMsg = "������ ���� ���� [ �������� : " + CCertificate.errmessage + " ]";
				ErrCode = "�����ڵ� [ " + CCertificate.errcode + " ]";  
			}
		}//
		else
		{			
			boolCertChk = false;
			ErrMsg = "���ڼ��� ���� ��� ���� [ �������� : " + CVerifier.errmessage + " ]";
			ErrCode = "�����ڵ� [ " + CVerifier.errcode + " ]";  
		}
	}//
	else
	{
		boolCertChk = false;
		ErrMsg = "���� Base64 Decode ��� ���� [ �������� : " + CBase64.errmessage + " ]";
		ErrCode = "�����ڵ� [ " + CBase64.errcode + " ]";  
	} //���� Base64 Decode If�� ��...
	if (boolCertChk == false)
	{
%>
		<SCRIPT LANGUAGE="JavaScript">
		<!--
			alert("<%=ErrMsg%>\n\n<%=ErrCode%>");
			alert("���ڼ����� �ٽ� �Ͽ� �ֽʽÿ�");
		//-->
		</SCRIPT>
<%
	}
	else
	{
		out.print("������ �������� ����<br>");
		out.print("�ý��� �̿��ϱ�");
	}
%>
