var __crosscertlocalstorage = function( __SANDBOX ) {
	
	var messageNumber = 0;
	var sessionID = Math.random();
	
	ccoperation = new Array();
	ccoperation[0]			= "GetVersion";				// GetVersion
	ccoperation[1]			= "GetStorageHandler";		// getStorageHandler
	ccoperation[2]			= "GetCertificateList";		// GetCertificateList
	ccoperation[3]			= "SaveUserCert";			// SaveUserCert
	ccoperation[4]			= "SetP12OnMemory";			// SetP12OnMemory
	ccoperation[5]			= "DeleteUserCertByIndex";			// DeleteUserCertByIndex
	ccoperation[6]			= "IsAvaliable";			// IsAvaliable
	ccoperation[7]			= "GetP12ForBuToPc";			// GetP12ForBuToPc
	ccoperation[8]			= "GetP12ForBuToMo";			// GetP12ForBuToMo
	ccoperation[9]			= "DeleteUserCertByDN";			// DeleteUserCertByDN
	ccoperation[10]			= "SetP12HexOnMemory";			// SetP12HexOnMemory
		
	
					
	var iframeLoaded = false;
	 
	var errCode = "";
	var errMsg = "";
	
	var msgIndex = 0;
	var messageList = new Array();
	
	var iframesrc = __SANDBOX.ESVS.SHARESTORAGE;

	var cntAdd = 0;
	
	function trace(str){
		if(document.getElementById("tconsole") != null) document.getElementById("tconsole").value += ">> " + str + "\n";
	}
	
	function getCenterOption(){
		var dualScreenLeft, dualScreenTop, innerWidth, innerHeight, outerWidth, outerHeight;
		
		innerWidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
		innerHeight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
		outerWidth = window.outerWidth;
		outerHeight = window.outerHeight;
		
		dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
		dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
		
		/*if(__SANDBOX.browserName != "msie") {
			dualScreenLeft += outerWidth - innerWidth;
			dualScreenTop += outerHeight - innerHeight;
		}*/
		
		var center = {
			"x" : (innerWidth / 2) + dualScreenLeft,
			"y" : (innerHeight / 2) + dualScreenTop - 170
		};
		
		return center;
	}
	
	function insertQueue (json, msgNum, rvCallback) {
		var obj = JSON.parse(json);
				
 	    var struct = new Object();
		struct['messageNumber'] = msgNum;
		struct['operation'] = obj.operation;
		if ( obj.certIdentifier )
			struct['certIdentifier'] = obj.certIdentifier;
		else
			struct['certIdentifier'] = "";
			
		struct['callback'] = rvCallback;
		struct['valid'] = true;

		// 배열을 무작정 늘리지 않기 위해서 
		if (msgIndex >= 10)
			msgIndex = 0;
					
		messageList[msgIndex] = struct;    
		msgIndex = msgIndex + 1;		
		messageNumber = messageNumber + 1;	
	}
	
	function sendMessage(json, msgNum, rvCallback){
		// test
		//window.console.log("sendMessage : " + json);
		insertQueue(json, msgNum, rvCallback);
		try {
			var request = document.getElementById("hsmiframe").contentWindow;
			request.postMessage(json, iframesrc);
		}catch(e) {
			if(rvCallback != null) rvCallback(-1);
		}
	}
	
	function removeEvent(){
		cntAdd--;
		if (typeof window.addEventListener === 'function') {
		    // Check for addEventListener first, since IE9/10 have both,
		    // but you should use the standard over the deprecated IE-specific one
		    window.removeEventListener('message', receivedData, false);
		} else if (typeof window.attachEvent === 'function') {
		    window.detachEvent('onmessage', receivedData);
		} else {
			window.detachEvent('onmessage', receivedData);
		}
	}
	
	function addEvent()
	{
		if(cntAdd > 0){
			removeEvent();
		}
		if (typeof window.addEventListener === 'function') {
		    // Check for addEventListener first, since IE9/10 have both,
		    // but you should use the standard over the deprecated IE-specific one
		    window.addEventListener('message', receivedData, false);
		} else if (typeof window.attachEvent === 'function') {
		    window.attachEvent('onmessage', receivedData);
		} else {
			window.attachEvent('onmessage', receivedData);
		}
		cntAdd++
	}	
		
	
	var receivedData = function (event)
	{
		// test
		//window.console.log("receiveMessage : " + event.data);
//		if ( event.origin == iframesrc )
	//	{
			iframeLoaded = true;
			
			// nhkim 20151021
			if ( event.data == null || event.data.length <= 0)
				return;
			
			var i = 0;
			var certId = "";
			var callback = null;			
			var obj = JSON.parse(event.data);
							
			for (i = 0 ; i < messageList.length ; i++) {	
				if (messageList[i].messageNumber == obj.messageNumber)	{
					if ( messageList[i].valid == false )	{
						messageList[i].callback(-1);
						return;
					}			
					else	{
						if (obj.operation == ccoperation[2])
							certId = messageList[i].certIdentifier;
							
						callback = messageList[i].callback;
						messageList[i] = 0;
						break;
					}
				}
			}	
									
			if (obj.operation == ccoperation[0])
				ReceiveVersion( obj, callback );
			else if (obj.operation == ccoperation[1])
				ReceiveStorageHandler( obj, callback );
			else if (obj.operation == ccoperation[2])
				ReceiveCertificates( obj, callback );
			else if (obj.operation == ccoperation[3])
				ReceiveSaveCerts( obj, callback );
			else if (obj.operation == ccoperation[4])
				ReceiveSetP12OnMemory( obj, callback );		
			else if (obj.operation == ccoperation[5])
				ReceiveDeleteUserCertByIndex( obj, callback );	
			else if (obj.operation == ccoperation[6])
				ReceiveIsCCPFSHAvailable( obj, callback );	
			else if (obj.operation == ccoperation[7])
				ReceiveGetP12ForBuToPc( obj, callback );	
			else if (obj.operation == ccoperation[8])
				ReceiveGetP12ForBuToMo( obj, callback );		
			else if (obj.operation == ccoperation[9])
				ReceiveDeleteUserCertByDN( obj, callback );		
			else if (obj.operation == ccoperation[10])
				ReceiveSetP12HexOnMemory( obj, callback );		
				

			if(obj.operation != ccoperation[0] || obj.operation != ccoperation[1] || obj.operation != ccoperation[2]){
				//__SANDBOX.uiUtil().loadingBox(false, "us-div-list-load");
			}				
				
	//	} else {
	//		return;
	//	}
	}
			
	function GetVersion( rvCallback ){		
		// 인증서 이동시 디스크로 복사할때 이부부이 실행되면서 선택창에 떠 있는 인증서 리스트가 사라짐
		//certList.length = 0;	
		var jsonGetVersion = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[0]
		};
		
		sendMessage(JSON.stringify(jsonGetVersion), messageNumber, rvCallback);
	}
	
	function ReceiveVersion( obj, __callback )	 {
		currentVersion = obj.list[0].version;
		var cv = currentVersion.split('.');
		currentVersion = cv[0] +'.'+ cv[1] +'.'+ cv[2] + '.0';
		__callback ( currentVersion );
	}	
		
	function GetStorageHandler(encAlgo, hashAlgo, pki, rvCallback){					
		var jsonCreateSH = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[1],
			"enc_algo" : encAlgo,
			"hash_algo" : hashAlgo,
			"pki" : pki
		};
		
		sendMessage(JSON.stringify(jsonCreateSH), messageNumber, rvCallback);
	}


	function ReceiveStorageHandler( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, 0);
			return false;
		}
			
		__callback(obj.resultCode, obj.PFSH);
	}
	
	function SaveCerts(caname, usercert, checkExist, rvCallback){					
		var jsonSaveUserCerts = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[3],
			"caname" : caname,
			"usercert" : usercert,
			"checkExist": checkExist
		};
		
		sendMessage(JSON.stringify(jsonSaveUserCerts), messageNumber, rvCallback);
	}


	function ReceiveSaveCerts( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, 0);
			return false;
		}
			
		__callback(obj.resultCode, obj.resultMessage);
	}



	function GetCertificates( rvCallback ){					
		var jsonCertificate = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[2]
		};
		
		sendMessage(JSON.stringify(jsonCertificate), messageNumber, rvCallback);
	}


	function ReceiveCertificates( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, 0);
			return false;
		}
			
		__callback(obj.resultCode, obj.userCerts);
	}
	
	function _SetP12OnMemory( fileB64Bin, pw, rvCallback ){					
		var jsonCertificate = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[4],
			"fileB64Bin" : fileB64Bin,
			"pw" : pw
		};
		
		sendMessage(JSON.stringify(jsonCertificate), messageNumber, rvCallback);
	}


	function ReceiveSetP12OnMemory( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, errMsg);
		}
		else			
			__callback(obj.resultCode, obj.resultMessage, obj.userCertsInfo);
	}		

	function _DeleteUserCertByIndex( certIndex, rvCallback ){					
		var jsonCertificate = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[5],
			"index": certIndex
		};
		
		sendMessage(JSON.stringify(jsonCertificate), messageNumber, rvCallback);
	}


	function ReceiveDeleteUserCertByIndex( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, errMsg);
		}
		else			
			__callback(obj.resultCode, obj.resultMessage);
	}	
	
	function _IsCCPFSHAvailable( rvCallback ){					
		var jsonCertificate = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[6]
		};
		
		sendMessage(JSON.stringify(jsonCertificate), messageNumber, rvCallback);
	}


	function ReceiveIsCCPFSHAvailable( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, errMsg);
		}
		else			
			__callback(obj.resultCode, obj.resultMessage);
	}		
	
	function _GetP12ForBuToPc( index, pw, retType, rvCallback ){					
		var jsonCertificate = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[7],
			"index": index,
			"pw":pw,
			"retType": retType
		};
		
		sendMessage(JSON.stringify(jsonCertificate), messageNumber, rvCallback);
	}

	function ReceiveGetP12ForBuToPc( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, errMsg);
		}
		else			
			__callback(obj.resultCode, obj.resultMessage, obj.dn, obj.p12);
	}		
	
	function _GetP12ForBuToMo( index, encoding, rvCallback ){					
		var jsonCertificate = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[8],
			"index": index,
			"encoding": encoding
		};
		
		sendMessage(JSON.stringify(jsonCertificate), messageNumber, rvCallback);
	}

	function ReceiveGetP12ForBuToMo( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, errMsg);
		}
		else			
			__callback(obj.resultCode, obj.resultMessage, obj.p12key, obj.p12);
	}		
	
	function _DeleteUserCertByDN( ca, dn, pw, rvCallback ){					
		var jsonCertificate = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[9],
			"ca": ca,
			"dn": dn,
			"pw": pw
		};
		
		sendMessage(JSON.stringify(jsonCertificate), messageNumber, rvCallback);
	}

	function ReceiveDeleteUserCertByDN( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, errMsg);
		}
		else			
			__callback(obj.resultCode, obj.resultMessage);
	}	
	
	function _SetP12HexOnMemory( p12Hex, p12Hexkey, rvCallback )	{
		var jsonCertificate = {
			"messageNumber": messageNumber,
			"sessionID": "" + sessionID,
			"operation": ccoperation[10],
			"p12Hex" : p12Hex,
			"p12Hexkey" : p12Hexkey
		};
		
		sendMessage(JSON.stringify(jsonCertificate), messageNumber, rvCallback);
	}


	function ReceiveSetP12HexOnMemory( obj, __callback ){			
		if (obj.resultCode != 0) {
			errCode = obj.resultCode;
			errMsg = obj.resultMessage;
			__callback(errCode, errMsg);
		}
		else			
			__callback(obj.resultCode, obj.resultMessage, obj.userCertsInfo);
	}		
	
	
	
	function parseInt(s){
		var ver = s.replace(/\./g, "");
		return ver * 1;
	}
	
	var fnInstallCheck = function(rv){
		iframeLoaded = false;
		var isFirst = true;
		var fnResult = function(obj, r){
			if(isFirst){
				isFirst = false;
				if(obj && obj.parentNode) obj.parentNode.removeChild(obj);
				iframeLoaded = r;
				rv(r);
			}
		}
		
		var chkImg;
		if (navigator.userAgent.indexOf("MSIE 7.0") != -1) {
			chkImg = document.createElement("<img id='hsmImg' src='"+iframesrc + 'logo.png?cd=' + Math.random() + "' onload='' onerror='fnResult(this, false)' />");
			chkImg.onerror = function() {fnResult(chkImg, false);};
			chkImg.onload = function() {fnResult(chkImg, true);};
			chkImg.style.display = "none";
		} else {
			chkImg = document.createElement('img');
			chkImg.setAttribute('id', "hsmImg");
			chkImg.setAttribute('src', iframesrc + 'logo.png?cd=' + Math.random());
			chkImg.onerror = function() {fnResult(chkImg, false);};
			chkImg.onload = function() {fnResult(chkImg, true);};
			chkImg.style.display = "none";
		}
		document.body.appendChild(chkImg);
		
		if (navigator.userAgent.indexOf("MSIE 8") != -1) {
			var ie8 = function(){
				if(iframeLoaded == false) setTimeout(ie8, 100);
				else fnResult(null, true);
			}
			setTimeout(ie8, 100);
		}
		
	};
	
	fnInstallCheck(function(r){
		iframeLoaded = r;
		if(r){
			var hsmiframe = document.getElementById("hsmiframe");
			if(hsmiframe != null) hsmiframe.onload = function() {
				addEvent();
			};
		}
	});
	
	addEvent();
	
	
	var nimCall = function(fn, msg){
		if( msg != -1 ) __SANDBOX.uiUtil().loadingBox(true, "us-div-list-load", msg);
		fnInstallCheck(function(r){
			if(r){
				fn();
			}else{
				setTimeout(fn, 1500);
			}
		});
	};
	
	// nhkim 20151022
	function SetInvalidOperation ( type ) {
		// 이전에 실행되고 있던 operationid ccoperation[0], ccoperation[1], ccoperation[2] 에 대해서 invalid로 설정해서 더 이상 실행되지 않도록 한다.
		var i = 0;	
		switch (type) {
			case 0:
				for (i = 0 ; i < messageList.length ; i++) {
					if ( (messageList[i].operation == ccoperation[1]) ) {
						messageList[i].valid = false;
					}
				}							
				break;
		}
	}
	
	return {	
		Version : function( callback ) {
			function goRun() {
				if (currentVersion == null)
					GetVersion( callback );
				else
					callback (currentVersion);
			}
				
//			nimCall(goRun);	
		},
		
		GetLastErrorCode : function() {
			return errCode;
		},
		
		GetLastErrorMessage : function() {
			return errMsg;
		},
		
		IsAvailable : function(){
			return iframeLoaded;
		},
					
		GetIframeLoaded: function(){
			return iframeLoaded;
		},
		
		IsCCPFSHAvailable : function( rvCallback ){
			function goRun(){
				_IsCCPFSHAvailable( rvCallback );						
			}
			goRun();
		},		
					
		GetCCStorageHandler : function( encAlgo, hashAlgo, pki, rvCallback ) {
			function goRun(){
				// nhkim 20151022 - 이전에 구동되던 message들 취소
				//SetInvalidOperation(2);
				removeEvent();
				addEvent();
				GetStorageHandler( encAlgo, hashAlgo, pki, rvCallback );						
			}
			goRun();
			
//			nimCall(goRun);
		},
		
		SaveUserCert: function ( caname, usercert, checkExist, rvCallback ) {
			function goRun(){
				SaveCerts( caname, usercert, checkExist, rvCallback );						
			}
			goRun();
		},
			
		GetCertificateList: function( rvCallback ) {
			function goRun(){
				// nhkim 20151022 - 이전에 구동되던 message들 취소
				//SetInvalidOperation(2);
				GetCertificates( rvCallback );						
			}
			goRun();
		},
		
		SetP12OnMemory: function( fileB64Bin, pw, rvCallback ) {
			function goRun(){
				// nhkim 20151022 - 이전에 구동되던 message들 취소
				//SetInvalidOperation(2);
				_SetP12OnMemory( fileB64Bin, pw, rvCallback );						
			}
			goRun();
		},
		
		DeleteUserCertByIndex: function( certIndex, rvCallback ) {
			function goRun(){
				_DeleteUserCertByIndex( certIndex, rvCallback );						
			}
			goRun();
		},
			
		GetP12ForBuToPc: function( certIndex, pw, retType, rvCallback ) {
			function goRun(){
				_GetP12ForBuToPc( certIndex, pw, retType, rvCallback );						
			}
			goRun();
		},
		
		GetP12ForBuToMo: function( certIndex, encoding, rvCallback ) {
			function goRun(){
				_GetP12ForBuToMo( certIndex, encoding, rvCallback );						
			}
			goRun();
		},
		
		DeleteUserCertByDN:	function( ca, dn, pw, rvCallback ) {
			function goRun(){
				_DeleteUserCertByDN( ca, dn, pw, rvCallback );						
			}
			goRun();
		},
		
		SetP12HexOnMemory: function( p12Hex, p12Hexkey, rvCallback ) {
			function goRun(){
				_SetP12HexOnMemory( p12Hex, p12Hexkey, rvCallback );						
			}
			goRun();
		}
		
			
		//		
	}
};