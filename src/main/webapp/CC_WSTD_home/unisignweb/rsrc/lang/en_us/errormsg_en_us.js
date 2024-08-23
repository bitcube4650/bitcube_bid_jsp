(function() {
    return {
        IDS_CERT_LOADING_MSG: ["loading certificate list ...", "signing ...", "revoking certificate ...", "deleting certificate ...", "renewing certificate ...", "copying certificate ...", 
    	                                  "importing certificate ...", "exporting certificate ...", "changing password ...", "checking password ...", "generating envelop data ...", 
    	                                  "verifying envelop data ...", "validating certificate ...", "verifying license ...", "getting media info ...", "issuing certificate ...", 
    	                                  "verifying sign data ...", "backuping certificate ...", "recovering backuped certificate ...", "generating hash data ...", "encrypting symmkey data ..."],
        IDS_ERROR_USER_CANCEL:            "User canceled",
        IDS_ERROR_NOT_SUPPORT_ALGORITHM:  "It's not supported",
        IDS_ERROR_FILE_NOT_FOUND:		  "Failed to load file",
        IDS_ERROR_DO_NOT_AVAILABLE:       "Failt to get Verify Info of Javascript File. \nIssue Certificate/ReIssue Certficate/Renew Certificate are not processed\nPlease call 1566-0566(customer center of CrossCert)",
        IDS_ERROR_NIM_NOT_INSTALL:		  "UniCRSLocalServer Program is not installed.\nMove to install page.",
        IDS_ERROR_NIM_NOT_INSTALL_CFM:		  "UniCRSLocalServer Program is not installed.\nDo you want to move to install page?", 
        IDS_ERROR_NIM_NOT_LASTEST_VERSION:		  "UniCRSLocalServer Program need to update\nMove to install page.",
        IDS_ERROR_BROWSER_NOT_SUPPORT:    "It's not supported on this browser.",
        IDS_MSGBOX_NIM_ERROR_UNLOAD:     "UniCRSLocalServer is unloaded.\nPlease refresh page or go to first page and retry.",
        
        IDS_VERIFYKEY_SIGN:				  "[cert for sign   ] ",
        IDS_VERIFYKEY_KM:				  "[cert for encrypt] ",
        
        IDS_VERIFYKEY_OK:				  "success",
        IDS_VERIFYKEY_FAIL:				  "fail",
        IDS_VERIFYKEY_NONE:				  "none",
        
        IDS_VERIFY_SIGN:				  "Failed to verify sign data.",
        IDS_VID_VERIFY_MESSAGE:			  "Verifing Identification. Please wait ...",
        // yjyoon 2016.06.01, 키보드 보안 모듈 설치를 확인하고 있습니다
        IDS_KS_INSTALL_CHECK:			  "Checking Keyboard Security program ...", 
        
        // nhkim 20151130
        IDS_NOALLOW_UPDATECERT: 		  "Renew certificate is not allowed. After registering renew certificate option and retry.",
        
        IDS_MSGBOX_VID_ERROR_VERIFICATION: 	"Failed to verify Identificateion. \nSSN or Business No is not same in Certificate's.",
        
        IDS_MSGBOX_VERIFY_LICENSE: 		  	"Failed to verify License. Please check License.",
        
        IDS_MSGBOX_LOCALSERVER_UNLOAD: 		"UniCRSLocalServer is unloaded \nCurrent process will stop. \nPlease refresh page or go to first page and retry.",
        IDS_ERROR_NOT_SUPPORT_DEVICE:  		"It's not supported media.",
        
        IDS_ERROR_NOT_MATTCHED_PWD:  		"Password is not correct.",
        IDS_NO_KMCERT:						"Cert for encrypting is not exist.",
        
        IDS_ERROR_FUC_NOT_SUPPORT:  		"It's not supported in current mode.",  
        
        IDS_CANT_ISSUECERT_BIOTOKEN:		"Certificate can't issue, renew and reIssue at Bio-Token.",
		IDS_ERROR_EMPTY_PARAMS:				"Invalid argument"

    }
})();