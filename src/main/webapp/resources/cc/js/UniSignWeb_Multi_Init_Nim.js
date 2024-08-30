﻿document.writeln("<iframe  src='https://127.0.0.1:15018/' name='hsmiframe' id='hsmiframe' style='visibility:hidden;position:absolute;height:0px;'></iframe>");

if(document.body){
	var winTarget = document.createElement('div');
	winTarget.id = 'ESignWindow';
	document.body.appendChild( winTarget, document.body.firstChild );
}else{
	document.writeln('<div id="ESignWindow"></div>');
}

var parent = null;
var policies = "";
policies +="1.2.410.200004.5.2.1.1"       + "|";
policies +="1.2.410.200004.5.2.1.2"       + "|";
policies +="1.2.410.200004.5.1.1.5"       + "|";
policies +="1.2.410.200005.1.1.1"         + "|";
policies +="1.2.410.200004.5.3.1.4"       + "|";
policies +="1.2.410.200004.5.4.1.1"       + "|";
policies +="1.2.410.200012.1.1.1"         + "|";
policies +="1.2.410.200004.5.4.1.101"     + "|";
policies +="1.2.410.200004.5.4.1.102"     + "|";
policies +="1.2.410.200004.5.4.1.103"     + "|";
policies +="1.2.410.200004.5.4.1.104"     + "|";
policies +="1.2.410.200004.5.2.1.7.1"     + "|";
policies +="1.2.410.200004.5.2.1.7.2"     + "|";
policies +="1.2.410.200004.5.2.1.7.3"     + "|";
policies +="1.2.410.200004.5.1.1.9"       + "|";
policies +="1.2.410.200004.5.1.1.9.2"     + "|";
policies +="1.2.410.200005.1.1.4"         + "|";
policies +="1.2.410.200005.1.1.6.2"       + "|";
policies +="1.2.410.200012.1.1.101"       + "|";
policies +="1.2.410.200012.1.1.103"       + "|";
policies +="1.2.410.200012.1.1.105"       + "|";
policies +="1.2.410.200004.5.1.1.7"       + "|";
policies +="1.2.410.200005.1.1.5"         + "|";
policies +="1.2.410.200004.5.3.1.1"       + "|";
policies +="1.2.410.200004.5.3.1.2"       + "|";
policies +="1.2.410.200004.5.4.1.2"       + "|";
policies +="1.2.410.200004.5.4.1.201"     + "|";
policies +="1.2.410.200012.1.1.3"         + "|";
policies +="1.2.410.200004.5.4.2.26"      + "|";
policies +="1.2.410.200005.1.1.2"         + "|";
policies +="1.2.410.200004.5.4.1.200"     + "|";
policies +="1.2.410.200004.5.4.2.31"      + "|";
policies +="1.2.410.100001.2.2.1"         + "|";
policies +="1.2.410.200004.5.2.1.4"       + "|";
policies +="1.2.410.200004.5.2.1.3"       + "|";
policies +="1.2.410.200004.5.2.1.5"       + "|";
policies +="1.2.410.200004.5.2.1.6"       + "|";
policies +="1.2.410.200004.5.2.1.5.140"   + "|";
policies +="1.2.410.200004.5.4.1.3"       + "|";
policies +="1.2.410.200004.5.4.1.4"       + "|";
policies +="1.2.410.200004.5.4.1.5"       + "|";
policies +="1.2.410.200004.5.5.1.1"       + "|";
policies +="1.2.410.200004.5.5.1.2"       + "|";

// MODE 4 = NIM, nim + webstorage = 6
var unisign = UnisignWeb({
    Mode: 4,
    
    PKI: 'NPKI',
    SRCPath: '/CC_WSTD_home/',
    Language: 'ko-kr',
    TargetObj: document.getElementById('ESignWindow'),
    TabIndex: 1000,
    LimitNumOfTimesToTryToInputPW: 3,
    
    // npk, touchen: 라온, ahnlab - 현재는 touchen만 지원됨. 안랩 - e2e_type="11" , 라온 - data-enc="on"
    // TOUCHEN - NPAPI 스타일이라서 CHROME은 해당 되지 않음
    //SecureKeyboardType: 'ahnlab',
 
    /* // TODO : 저장매체 추가시 수정해야될 부분 */
    //Media: {'defaultdevice':'harddisk', 'list':'removable|sectoken|savetoken|mobilephone|harddisk'},/* plugin mode(Mode:1) media list */
    //Media: {'defaultdevice':'webstorage', 'list':'webstorage|touchsign|smartsign|websectoken|websofttoken'},/* plugin-free mode(Mode:2) media list */
   // NPKI
    Media: {'defaultdevice':'harddisk', 'list':'mobiletoken|sectoken|savetoken|removable|harddisk|mobilephone|securedisk'},	/* all media(Mode:3) list */
   // GPKI
//    Media: {'defaultdevice':'harddisk', 'list':'sectoken|savetoken|removable|harddisk'},/* all media(Mode:3) list */
    
    
	//Policy: '1.2.410.200004.5.2.1.1|1.2.410.200004.5.1.1.7|1.2.410.200005.1.1.5|1.2.410.200004.5.4.1.2|1.2.410.200012.1.1.3',
    //Policy: '1.2.410.200004.5.4.1.2',  Policy: '1.2.410.200004.5.4.1.1',
    
    //ShowExpiredCerts: false,
    CMPIP:  'testca.crosscert.com', // '211.180.234.221', // 'testca.crosscert.com',  //CMP IP // '211.118.38.179',
    //CMPIP: '211.180.234.216',  //CMP IP
    CMPPort: 4502,  //CMP Port			// real 사설 - 3502   // 그외 - 4502
    
    LimitMinNewPWLen: 8,
    LimitMaxNewPWLen: 64,
    LimitNewPWPattern: 2,  //0 : 제한 없음, 1 : 영문,숫자 혼합, 2 : 영문,숫자,특수문자 혼합
	ChangePWByNPKINewPattern: true,
	
	SDInstallURL: 'http://testca.crosscert.com/test/download.html',
	
	// 지문보안토큰에 인증서 밝급 여부 설정
	IssueCertInBIOToken: false,
/*
1.2.410.200004.5.2.1.2	// 한국정보인증               개인                
1.2.410.200004.5.1.1.5	// 한국증권전산               개인                
1.2.410.200005.1.1.1	// 금융결제원                 개인                
1.2.410.200004.5.4.1.1	// 한국전자인증               개인                
1.2.410.200012.1.1.1	// 한국무역정보통신           개인 
1.2.410.200004.5.5.1.1	// 이니텍 개인

// 법인상호연동용(범용)    				
1.2.410.200004.5.2.1.1	// 한국정보인증               법인
1.2.410.200004.5.1.1.7	// 한국증권전산               법인, 단체, 개인사업자
1.2.410.200005.1.1.5	// 금융결제원                 법인, 임의단체, 개인사업자
1.2.410.200004.5.4.1.2	// 한국전자인증               법인, 단체, 개인사업자
1.2.410.200012.1.1.3	// 한국무역정보통신           법인
1.2.410.200004.5.5.1.2  // 이니텍 법인

// 개인 용도제한용 인증서정책(OID)                 용도                    공인인증기관
1.2.410.200004.5.4.1.101	// 은행거래용/보험용       한국전자인증
1.2.410.200004.5.4.1.102	// 증권거래용              한국전자인증
1.2.410.200004.5.4.1.103	// 신용카드용              한국전자인증
1.2.410.200004.5.4.1.104	// 전자민원용              한국전자인증
1.2.410.200004.5.2.1.7.1	// 은행거래용/보험용       한국정보인증
1.2.410.200004.5.2.1.7.2	// 증권거래용/보험용       한국정보인증
1.2.410.200004.5.2.1.7.3	// 신용카드용              한국정보인증
1.2.410.200004.5.1.1.9		// 증권거래용/보험용       한국증전산
1.2.410.200004.5.1.1.9.2	// 신용카드용              한국증전산
1.2.410.200005.1.1.4		// 은행거래용/보험용       금융결제원
1.2.410.200005.1.1.6.2		// 신용카드용              금융결제원
1.2.410.200012.1.1.101		// 은행거래용/보험용       한국무역정보통신
1.2.410.200012.1.1.103		// 증권거래용/보험용       한국무역정보통신
1.2.410.200012.1.1.105		// 신용카드용              한국무역정보통신
*/

//    Policy: '1.2.410.200004.5.2.1.2|1.2.410.200004.5.1.1.5|1.2.410.200005.1.1.1|1.2.410.200004.5.4.1.1|1.2.410.200012.1.1.1|1.2.410.200004.5.2.1.1|1.2.410.200004.5.1.1.7|1.2.410.200005.1.1.5|1.2.410.200004.5.4.1.2|1.2.410.200012.1.1.3',
	Policy: policies,

	// 파일 명. root 디렉토리
	//License: "License.js"	
});

unisign.SetOptions("popup", "center,overlay=true");
unisign.SetMobileTokenEnvInfo("303010001", "0003", "www.crosscert.com", "service.smartcert.kr", "443", "http://download.smartcert.kr");
unisign.SetUBIKeyEnvInfo("1,3,0,7", "CROSSCERT|http://www.ubikey.co.kr/infovine/download.html", "CROSSCERT|NULL", "http://www.ubikey.co.kr/infovine/download.html");			
	
