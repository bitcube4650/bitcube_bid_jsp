function UnisignWeb(a){a||alert("Failed to initialize module.");return new UnisignWebPlugIn({Mode:a.Mode,EncAlgo:a.EncAlgo,HashAlgo:a.HashAlgo,UniCRS:a.UniCRS,SecureKeyboardType:a.SecureKeyboardType,PKI:a.PKI,SRCPath:a.SRCPath,Language:a.Language,TargetObj:a.TargetObj,TabIndex:a.TabIndex,Embedded:a.Embedded,LimitNumOfTimesToTryToInputPW:a.LimitNumOfTimesToTryToInputPW,CMPIP:a.CMPIP,CMPPort:a.CMPPort,CMPURL:a.CMPURL,SHARESTORAGE:a.SHARESTORAGE,NimCheckURL:a.NimCheckURL,Media:a.Media,Organization:a.Organization,
Policy:a.Policy,ShowExpiredCerts:a.ShowExpiredCerts,LimitMinNewPWLen:a.LimitMinNewPWLen,LimitMaxNewPWLen:a.LimitMaxNewPWLen,LimitNewPWPattern:a.LimitNewPWPattern,ChangePWByNPKINewPattern:a.ChangePWByNPKINewPattern,CertRequestPageEnable:a.CertRequestPageEnable,SDInstallURL:a.SDInstallURL,IssueCertInBIOToken:a.IssueCertInBIOToken,License:a.License,chkEXESetup:!0,chkEXESetupCancel:!1,ShowGuide:a.ShowGuide,zIndex:a.zIndex})}
var UnisignWebPlugIn=function(a){a||alert("Failed to initialize Unisign Web Plugin.");var b;b=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");b.open("GET",a.SRCPath+"unisignweb/js/unisignweb.js?version=1.0.0.37",!1);b.send(null);eval(b.responseText);this.WebPlugIn=new (eval("UnisignWebEngine"))({Mode:a.Mode,EncAlgo:a.EncAlgo,HashAlgo:a.HashAlgo,UniCRS:a.UniCRS,SecureKeyboardType:a.SecureKeyboardType,PKI:a.PKI,SRCPath:a.SRCPath,Language:a.Language,TargetObj:a.TargetObj,
TabIndex:a.TabIndex,Embedded:a.Embedded,LimitNumOfTimesToTryToInputPW:a.LimitNumOfTimesToTryToInputPW,CMPIP:a.CMPIP,CMPPort:a.CMPPort,NimCheckURL:a.NimCheckURL,Media:a.Media,Organization:a.Organization,Policy:a.Policy,ShowExpiredCerts:a.ShowExpiredCerts,LimitMinNewPWLen:a.LimitMinNewPWLen,LimitMaxNewPWLen:a.LimitMaxNewPWLen,LimitNewPWPattern:a.LimitNewPWPattern,ChangePWByNPKINewPattern:a.ChangePWByNPKINewPattern,CertRequestPageEnable:a.CertRequestPageEnable,SDInstallURL:a.SDInstallURL,IssueCertInBIOToken:a.IssueCertInBIOToken,
License:a.License,chkEXESetup:a.chkEXESetup,ShowGuide:a.ShowGuide,zIndex:a.zIndex},{NAME:"unisignweb.js",DATA:b.responseText})};
UnisignWebPlugIn.prototype={IsValidity:function(){return this.WebPlugIn.IsValidity()},GetLastError:function(a){this.WebPlugIn.GetLastError(a)},SetEmbeddedUI:function(a){this.WebPlugIn.SetEmbeddedUI(a)},DigitalSignature:function(a,b,c){this.WebPlugIn.SignDataP1(a,b,c)},VerifyDigitalSignature:function(a,b,c,d){return this.WebPlugIn.VerifySignedDataP1(a,b,c,d)},SignData:function(a,b,c){var d=c;1==c.length&&(d=function(a){c(a.signedData)});this.WebPlugIn.SignDataP7(a,b,!0,null,d)},SignDataEx:function(a,
b,c){this.WebPlugIn.SignDataP7(a,b,!0,null,c)},VerifySignData:function(a,b){return this.WebPlugIn.VerifySignedDataP7(a,b)},SignDataForCertTransferring:function(a,b,c){this.WebPlugIn.SignDataP7Ext("DIGITAL_SIGNATURE_P7_EXT_DISABLE_SECTOKEN",null,a,null,b,c)},SelectMediaForCertTransferring:function(a,b){this.WebPlugIn.SelectMediaForCertImporting(a,b)},ExportCertForCertTransferring:function(a,b,c,d,e,f){return this.WebPlugIn.ExportCert(a,b,c,d,e,f)},ImportCertForCertTransferring:function(a,b,c,d,e,f,
g){return this.WebPlugIn.ImportCert(a,b,c,d,e,f,g)},IssueCert:function(a,b,c){this.WebPlugIn.IssueCert(a,b,c)},IssueKMCert:function(a){this.WebPlugIn.IssueKMCert(a)},RenewCert:function(a){this.WebPlugIn.RenewCertNSignedSubjectDn(-1,-1,null,!1,1,!0,a)},RevocateCert:function(a){this.WebPlugIn.RevocateCert(a)},SOECert:function(a){this.WebPlugIn.SOECert(a)},VerifyVID:function(a,b){var c=b;1==b.length&&(c=function(a){a.resultCode=0==a.resultCode?!0:!1;b(a.resultCode)});this.WebPlugIn.VerifyVID(a,c)},VerifyVIDEx:function(a,
b){this.WebPlugIn.VerifyVID(a,b)},ManageCert:function(){this.WebPlugIn.ManageCert()},ManageCertByType:function(a,b){this.WebPlugIn.ManageCertByType(a,b)},ImportCertFromMobileApp:function(a,b,c){return this.WebPlugIn.ImportCertFromMobileApp(a,b,c)},SetSelectedDevice:function(a){return this.WebPlugIn.SetSelectedDevice(a)},NimServiceLoaded:function(){return this.WebPlugIn.NimServiceLoaded()},SecureMail_Corporation:function(a,b,c,d){this.WebPlugIn.SecureMail(0,a,b,c,d)},SecureMail_Private:function(a,
b,c,d){this.WebPlugIn.SecureMail(1,a,b,c,d)},DecryptData:function(a,b){return this.WebPlugIn.DecryptData(a,b)},getFileDownload:function(a,b){this.WebPlugIn.getFileDownload(a,b)},SetUBIKeyEnvInfo:function(a,b,c,d){this.WebPlugIn.SetUBIKeyEnvInfo(a,b,c,d)},SignDataNGetIdentifierByEnvlp:function(a,b,c,d){this.WebPlugIn.SignDataP7(a,b,!0,c,d)},SignData_noConWithHash:function(a,b,c,d,e){this.WebPlugIn.SignData_noConWithHash(a,b,c,null,d,e)},SignDataNGetIdentifierByEnvlp_noConWithHash:function(a,b,c,d,
e,f){this.WebPlugIn.SignData_noConWithHash(a,b,c,d,e,f)},SignDataP7NVID_noConWithHash:function(a,b,c,d,e,f){this.WebPlugIn.SignDataP7NVID_noConWithHash(a,b,c,null,d,e,f)},VerifySignData_noConWithHash:function(a,b,c){return this.WebPlugIn.VerifySignData_noConWithHash(a,b,!1,c)},SignMultiData:function(a,b,c){var d=c;1==c.length&&(d=function(a){c(a.jsonSignedData)});this.WebPlugIn.SignMultiDataP7(a,null,b,!0,null,d)},SignMultiDataEx:function(a,b,c){this.WebPlugIn.SignMultiDataP7(a,null,b,!0,null,c)},
SignMultiDataExcludeContent:function(a,b,c){var d=c;1==c.length&&(d=function(a){c(a.jsonSignedData)});this.WebPlugIn.SignMultiDataP7(a,null,b,!1,null,d)},SignMultiDataExcludeContentEx:function(a,b,c){this.WebPlugIn.SignMultiDataP7(a,null,b,!1,null,c)},VerifyExcludedContentSignData:function(a,b,c){return this.WebPlugIn.VerifySignedDataP7ExcludedContent(a,b,c)},Base64Encoding:function(a){return this.WebPlugIn.Base64Encoding(a)},Base64Decoding:function(a){return this.WebPlugIn.Base64Decoding(a)},SignPersonInfoReq:function(a,
b,c,d){this.WebPlugIn.SignPersonInfoReqP7(a,b,c,!0,d)},MultiDigitalSignature:function(a,b,c){this.WebPlugIn.SignMultiDataP1(a,b,c)},SignDataExcludeContent:function(a,b,c){var d=c;1==c.length&&(d=function(a){c(a.signedData)});this.WebPlugIn.SignDataP7(a,b,!1,null,d)},SignDataExcludeContentEx:function(a,b,c){this.WebPlugIn.SignDataP7(a,b,!1,null,c)},SignDataNVerifyVID:function(a,b,c,d){this.WebPlugIn.SignDataP7AndVerifyVID(a,b,c,d)},SignMultiDataNVerifyVID:function(a,b,c,d){this.WebPlugIn.SignMultiDataP7NVerifyVID(a,
null,b,!0,c,d)},MakeHash:function(a,b,c){return this.WebPlugIn.MakeHash(a,b,"PlainText",c)},MakeFileHash:function(a,b,c){return this.WebPlugIn.MakeHash(a,b,"FilePath",c)},EncryptData:function(a,b,c,d,e){this.WebPlugIn.EncryptData(a,b,c,d,e)},EncryptDatabySymm:function(a,b){return this.WebPlugIn.EncryptDatabySymm(a,b)},EncryptDataWithSymmKey:function(a,b,c,d,e){return this.WebPlugIn.EncryptDataWithSymmKey(a,b,c,d,e)},DecryptDataWithSymmKey:function(a,b,c,d,e,f){return this.WebPlugIn.DecryptDataWithSymmKey(a,
b,c,d,e,f)},SetConfigInfo:function(a){this.WebPlugIn.SetConfigInfo(a)},SignFile:function(a,b,c){this.WebPlugIn.SignFileP7(a,b,0,null,!0,c)},SignFileExcludeContent:function(a,b,c){this.WebPlugIn.SignFileP7(a,b,0,null,!1,c)},SignMultiFile:function(a,b,c){this.WebPlugIn.SignMultiFileP7(a,b,0,null,!0,c)},SignMultiFileExcludeContent:function(a,b,c){this.WebPlugIn.SignMultiFileP7(a,b,0,null,!1,c)},VerifyKeyPair:function(a){this.WebPlugIn.VerifyKeyPair(a)},SignMultiDataNGetIdentifierByEnvlp:function(a,b,
c,d){this.WebPlugIn.SignMultiDataP7(a,null,b,!0,c,d)},SetMobileTokenEnvInfo:function(a,b,c,d,e,f){this.WebPlugIn.SetMobileTokenEnvInfo(a,b,c,d,e,f)},SignFileEx:function(a,b,c,d,e){this.WebPlugIn.SignFileP7(a,b,c,d,!0,e)},SignFileExcludeContentEx:function(a,b,c,d,e){this.WebPlugIn.SignFileP7(a,b,c,d,!1,e)},VerifyP7SignedFileWithFile:function(a,b,c,d){this.WebPlugIn.VerifyP7SignedFileWithFile(null,2,a,b,c,d)},VerifyP7SignedFileWithFileEx:function(a,b,c,d,e){this.WebPlugIn.VerifyP7SignedFileWithFile(null,
a,b,c,d,e)},VerifyP7SignedDataWithFile:function(a,b,c,d){this.WebPlugIn.VerifyP7SignedDataWithFile(null,a,b,c,d)},VerifyExcludeContentP7SignedDataWithFile:function(a,b,c,d,e){this.WebPlugIn.VerifyP7SignedDataWithFile(a,b,c,d,e)},RenewCertNSignedSubjectDn:function(a,b,c,d,e,f){this.WebPlugIn.RenewCertNSignedSubjectDn(a,b,c,!0,d,e,f)},SetOptions:function(a,b){this.WebPlugIn.SetOptions(a,b)},MakeTaxXMLDSIG:function(a,b,c,d){this.WebPlugIn.MakeTaxXMLDSIG(a,b,c,d)},MakeTaxXMLDSIGNonEnveloped:function(a,
b,c,d){this.WebPlugIn.MakeTaxXMLDSIGNonEnveloped(a,b,c,d)},DecryptWithUserSymmKey:function(a,b,c,d,e){this.WebPlugIn.DecryptWithUserSymmKey(a,b,c,d,e)},EncryptDataWithCert:function(a,b,c){this.WebPlugIn.EncryptDataWithCert(a,b,c)},SignData_noConWithHashEx:function(a,b,c,d,e,f){this.WebPlugIn.SignData_noConWithHashEx(a,b,c,d,e,f)},GetMacAddress:function(a,b){this.WebPlugIn.GetMacAddress(a,b)},SetMultiUsingOpt:function(a){this.WebPlugIn.SetMultiUsingOpt(a)},CheckConnectToCAServer:function(a,b,c){this.WebPlugIn.CheckConnectToCAServer(a,
b,c)},SetSystemTimeFromTimeServer:function(a,b,c){this.WebPlugIn.SetSystemTimeFromTimeServer(a,b,c)},GetUserDN:function(a){this.WebPlugIn.GetUserDN(a)},GetRValueFromKey:function(a,b,c){this.WebPlugIn.GetRValueFromKey(a,b,c)},VerifyCertVID:function(a,b,c,d){this.WebPlugIn.VerifyCertVID(a,b,c,d)},SignDataNonEnveloped:function(a,b,c,d){this.WebPlugIn.SignDataP7NonEnveloped(a,b,c,!0,d)},DigitalSignatureWithPwd:function(a,b,c,d){this.WebPlugIn.SignDataP1WithPwd(a,b,c,d)},getCertPEMType:function(a,b){this.WebPlugIn.getCertPEMType(a,
b)},reload:function(){this.WebPlugIn.reload()},GetCertPath:function(a){this.WebPlugIn.GetCertPath(a)}};
