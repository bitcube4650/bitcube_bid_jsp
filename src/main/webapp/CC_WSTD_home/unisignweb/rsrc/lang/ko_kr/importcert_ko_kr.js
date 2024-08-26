(function() {
	return {
		IDS_TITLE: 								"인증서 가져오기",
		IDS_CONTENT_NOTICE_UL: 					[
			"이 곳을 클릭하여 인증서 파일을 선택 하거나,",
			"인증서 파일을 끌어다 놓으면 브라우저에 인증서 저장 및 사용이 가능합니다.",
			"",
			"※ 지원 가능한 인증서 파일※",
			"⑴ *.pfx 파일 또는 *.p12 파일 (1개 파일)",
			"⑵ signCert.cer파일과 signPri.key 파일 (2개 파일)",
			"⑶ kmCert.cer파일과 kmPri.key 파일 추가 가능 (2개 파일)",
			"§ *.cer파일 또는 *.der파일 모두 가능"
		],
		IDS_CONTENT_DROP_UL:					[
			"여기에 놓아 주세요."
		],
		IDS_CERT_INFO:							{
			name: '이름',
			expire: '만료일',
			issuer: '발급자',
			password: '인증서 비밀번호'
		},
		IDS_ERROR:								{
			'INPUT_PASSWORD':		"인증서 비밀번호를 입력하세요.",
			'NO_MATCH_PASSWORD':		"인증서 비밀번호가 올바르지 않습니다.",
			'INVALID_FILE_COUNT':	"잘못된 파일 개수 입니다.",
			'NO_P12_FILE':			"단일 파일로는 *.pfx 또는 *.p12 파일만 지원합니다.",
			'UNSUPPORT_FILE':		"지원하지 않는 파일입니다.",
			
			'NO_SIGNCERT':			"signCert 파일이 선택되지 않았습니다.",
			'NO_SIGNPRIKEY':			"signPri.key 파일이 선택되지 않았습니다.",
			'NO_KMCERT':			"kmCert 파일이 선택되지 않았습니다.",
			'NO_KMPRIKEY':			"kmPri.key 파일이 선택되지 않았습니다."
		},
		IDS_PFX_DOWNLOAD: 						"PFX 파일 다운로드 하기",
		IDS_CERT_IMPORT:						"이 인증서 가져오기",
		IDS_RE_TRY:								"다시하기",
		
		IDS_CONFIRM: 							"확인",
		IDS_CLOSE: 								"닫기",
		IDS_CANCEL: 							"취소",
		IDS_MSGBOX_CAPSLOCK_ON: 							" 이 켜져있습니다."		
	}
})();
