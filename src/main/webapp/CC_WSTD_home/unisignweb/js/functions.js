var crosscert=window.crosscert,messageNumber,sessionID,connUserID,relayURL,pktVersion,errormsg="\uc77c\uc2dc\uc801\uc778 \uc624\ub958\uac00 \ubc1c\uc0dd\ud588\uc2b5\ub2c8\ub2e4.\n\uc7a0\uc2dc \ud6c4 \ub2e4\uc2dc \uc2dc\ub3c4\ud574\uc8fc\uc138\uc694.",esdownmsg="[\uc774\uc9c0\uc2f8\uc778] \uc571 \ub2e4\uc6b4\ub85c\ub4dc \ub9c1\ud06c\ub97c \ubb38\uc790\ub85c \ubc1c\uc1a1\ud588\uc2b5\ub2c8\ub2e4.\n\ud734\ub300\ud3f0\uc5d0\uc11c \ud655\uc778\ud574 \uc8fc\uc138\uc694.",csdownmsg="[\ud074\ub77c\uc6b0\ub4dc\uc0ac\uc778] \uc571 \ub2e4\uc6b4\ub85c\ub4dc \ub9c1\ud06c\ub97c \ubb38\uc790\ub85c \ubc1c\uc1a1\ud588\uc2b5\ub2c8\ub2e4.\n\ud734\ub300\ud3f0\uc5d0\uc11c \ud655\uc778\ud574 \uc8fc\uc138\uc694.";
function reqMemberInfo(c,b){doXHRObject(memberURL,JSON.stringify({messageNumber:0,sessionID:"",operation:"REQUEST_MEMBER_INFO",phoneNum:c}),function(a){if(""!=a&&0<a.length)switch(a=JSON.parse(a),a.serviceCode){case "-1":case "0":"-1"==a.serviceCode?b(a.resultCode,a.resultMessage,a.serviceCode):b(a.resultCode,a.resultMessage,a.serviceCode+"|"+a.joinpageInfo);break;case "1":case "2":relayURL=a.serverInfo.url_string,pktVersion=a.serverInfo.pktVersion,b(a.resultCode,a.resultMessage,a.serviceCode)}else a=
createERRResponse(),b(a.resultCode,a.resultMessage,"")})}
function reqGetCert(c,b,a){var f={};f.siteName=siteName;f.siteURL=encodeURIComponent(window.location.protocol+"//"+window.location.host);f.purpose=b;messageNumber=2E3;doXHRObject(relayURL,JSON.stringify({messageNumber:messageNumber,sessionID:"",client:"PC-NX",operation:"CREATE_SESSION_PC",userID:c,version:"1.0",pktVersion:pktVersion,siteInfo:f}),function(d){if(""!=d&&0<d.length){var e=JSON.parse(d);if("0000"==e.resultCode){sessionID=e.sessionID;connUserID=c;d=e.certList.length;for(var f=[],g=1;g<
d+1;g++)messageNumber+=1,f.push(JSON.stringify({messageNumber:messageNumber,sessionID:sessionID,client:"PC-NX",certificateIndex:g,operation:"GET_CERTIFICATE",pktVersion:pktVersion}));doSynchronousLoop(f,[],function(b){a(e.resultCode,e.resultMessage,b)})}else"0021"==e.resultCode?reqGetCert(c,b,a):a(e.resultCode,e.resultMessage,"")}else e=createERRResponse(),a(e.resultCode,e.resultMessage,"")})}
function reqGetCertR(c,b){var a=crosscert.sha256.create();a.start();a.update(connUserID);var a=a.digest().getBytes(),f=a.substring(0,16),d=a.substring(16,32);messageNumber+=1;doXHRObject(relayURL,JSON.stringify({messageNumber:messageNumber,sessionID:sessionID,client:"PC-NX",certificateIndex:c,operation:"GET_CERTIFICATE_R",pktVersion:pktVersion}),function(a){if(""!=a&&0<a.length){if(a=JSON.parse(a),"0000"==a.resultCode){var c=a.certificateR,g=crosscert.cipher.algorithms.aes.startDecrypting(f,d);g.update(crosscert.util.createBuffer(crosscert.util.decode64(c)));
g.finish(g.tmonetpadding);c=g.output.toHex();c=crosscert.util.encode64(crosscert.util.hexToBytes(c));b(a.resultCode,a.resultMessage,c)}}else a=createERRResponse(),b(a.resultCode,a.resultMessage,"")})}
function reqGenSignNonVerifyPin(c,b,a,f){var d=crosscert.sha256.create();d.start();d.update(b);b=d.digest();d=crosscert.sha256.create();d.start();d.update(connUserID);var d=d.digest().getBytes(),e=d.substring(0,16),h=d.substring(16,32),d=crosscert.util.createBuffer(),g=crosscert.util.hexToBytes("0001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF003031300D060960864801650304020105000420");d.putBytes(g);
d.putBytes(b.getBytes());b=crosscert.cipher.algorithms.aes.startEncrypting(e,h);b.update(d.getBytes());b.finish(doHashPadding);b=b.output.getBytes();messageNumber+=1;c={messageNumber:messageNumber,sessionID:sessionID,client:"PC-NX",operation:"GENERATE_SIGNATURE",certificateIndex:c,tobeSignedData:crosscert.util.encode64(b),keyLength:2048,mechanism:0,pktVersion:pktVersion,checkCRL:a};doXHRObject(relayURL,JSON.stringify(c),function(a){if(""!=a&&0<a.length){a=JSON.parse(a);if("0000"==a.resultCode){var b=
a.signature,d=crosscert.cipher.algorithms.aes.startDecrypting(e,h);d.update(crosscert.util.createBuffer(crosscert.util.decode64(b)));d.finish(d.tmonetpadding);b=d.output.toHex();b=crosscert.util.encode64(crosscert.util.hexToBytes(b));f(a.resultCode,a.resultMessage,b)}else f(a.resultCode,a.resultMessage,"");closeSession()}else a=createERRResponse(),f(a.resultCode,a.resultMessage,"")})}
function reqGenSignMultiNonVerifyPin(c,b,a,f,d){b=parseInt(b);var e=crosscert.sha256.create();e.start();e.update(connUserID);var e=e.digest().getBytes(),h=e.substring(0,16),g=e.substring(16,32),e=[],k;for(k in a){var l=crosscert.util.createBuffer(crosscert.util.decode64(a[k])),m=crosscert.cipher.algorithms.aes.startEncrypting(h,g);m.update(l.getBytes());m.finish(doHashPadding);l=m.output.getBytes();e.push(crosscert.util.encode64(l))}messageNumber+=1;doXHRObject(relayURL,JSON.stringify({messageNumber:messageNumber,
sessionID:sessionID,client:"PC-NX",operation:"GENERATE_SIGNATURE_MULTI",certificateIndex:c,keyLength:2048,mechanism:2,pktVersion:pktVersion,count:b,tobeSignedDataList:e,checkCRL:f}),function(a){if(""!=a&&0<a.length){a=JSON.parse(a);if("0000"==a.resultCode){var b=a.signatureList,f=[],c;for(c in b){var e=crosscert.util.createBuffer(crosscert.util.decode64(b[c])),k=crosscert.cipher.algorithms.aes.startDecrypting(h,g);k.update(e);k.finish(k.tmonetpadding);e=k.output.getBytes();f.push(crosscert.util.encode64(e))}d(a.resultCode,
a.resultMessage,f)}else d(a.resultCode,a.resultMessage,"");closeSession()}else a=createERRResponse(),d(a.resultCode,a.resultMessage,"")})}
function reqRegDefaultCert(c,b,a,f){var d=crosscert.sha256.create();d.start();d.update(b);b=d.digest();d=crosscert.sha256.create();d.start();d.update(connUserID);var d=d.digest().getBytes(),e=d.substring(0,16),h=d.substring(16,32),d=crosscert.util.createBuffer(),g=crosscert.util.hexToBytes("0001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF003031300D060960864801650304020105000420");d.putBytes(g);
d.putBytes(b.getBytes());b=crosscert.cipher.algorithms.aes.startEncrypting(e,h);b.update(d.getBytes());b.finish(doHashPadding);b=b.output.getBytes();messageNumber+=1;c={messageNumber:messageNumber,sessionID:sessionID,client:"PC-NX",operation:"REGISTER_DEFAULT_CERT",certificateIndex:c,mechanism:0,tobeSignedData:crosscert.util.encode64(b),registrationNo:a};doXHRObject(relayURL,JSON.stringify(c),function(a){if(""!=a&&0<a.length){a=JSON.parse(a);if("0000"==a.resultCode){var b=a.signature,b=crosscert.util.createBuffer(crosscert.util.decode64(b)),
d=crosscert.cipher.algorithms.aes.startDecrypting(e,h);d.update(b);d.finish(d.tmonetpadding);b=crosscert.util.encode64(d.output.getBytes());f(a.resultCode,a.resultMessage,b)}else f(a.resultCode,a.resultMessage,"");closeSession()}else a=createERRResponse(),f(a.resultCode,a.resultMessage,"")})}
function reqVerifyVID(c,b,a){if(0==b.length)alert("\uc8fc\ubbfc\ub4f1\ub85d\ubc88\ud638/\uc0ac\uc5c5\uc790\ub4f1\ub85d\ubc88\ud638\ub97c \uc785\ub825\ud574\uc8fc\uc138\uc694.");else{var f,d,e=crosscert.md.algorithms.sha256.create();e.start();e.update(connUserID);var e=e.digest().getBytes(),h=e.substring(0,16),g=e.substring(16,32);messageNumber+=1;doXHRObject(relayURL,JSON.stringify({messageNumber:messageNumber,sessionID:sessionID,client:"PC-NX",certificateIndex:c,operation:"GET_CERTIFICATE",pktVersion:pktVersion}),
function(e){e=JSON.parse(e);"0000"==e.resultCode&&(f=e.certificate,messageNumber+=1,doXHRObject(relayURL,JSON.stringify({messageNumber:messageNumber,sessionID:sessionID,client:"PC-NX",certificateIndex:c,operation:"GET_CERTIFICATE_R",pktVersion:pktVersion}),function(e){e=JSON.parse(e);if("0000"==e.resultCode){e=e.certificateR;var c=crosscert.cipher.algorithms.aes.startDecrypting(h,g);c.update(crosscert.util.createBuffer(crosscert.util.decode64(e)));c.finish(c.tmonetpadding);d=c.output.toHex();e=crosscert.pki.certificateFromBase64(f);
c=crosscert.util.hexToBytes(d);try{crosscert.pkcs8.verifyVIDForHSM(c,b,e)?a("0000","OK",!0):a("0000","OK",!1)}catch(k){a("0014","FAIL",!1)}}}))})}}
function reqGetCertOID(c,b){messageNumber+=1;var a;doXHRObject(relayURL,JSON.stringify({messageNumber:messageNumber,sessionID:sessionID,client:"PC-NX",certificateIndex:c,operation:"GET_CERTIFICATE",pktVersion:pktVersion}),function(c){a=JSON.parse(c).certificate;c=window.crosscert||{};c.x509Certificate.parser(a,"Base64");b("0000","OK",c.x509Certificate.getCertificatePoliciesOid())})}
function reqGetCertExpirationDate(c,b){messageNumber+=1;var a;doXHRObject(relayURL,JSON.stringify({messageNumber:messageNumber,sessionID:sessionID,client:"PC-NX",certificateIndex:c,operation:"GET_CERTIFICATE",pktVersion:pktVersion}),function(c){a=JSON.parse(c).certificate;c=window.crosscert||{};c.x509Certificate.parser(a,"Base64");b("0000","OK",c.x509Certificate.getNotAfter())})}
function doSynchronousLoop(c,b,a){if(0<c.length){var f=function(a,c,h){doXHRObject(relayURL,a[c],function(g){g=JSON.parse(g);b.push(g.certificate);++c<a.length?f(a,c,h):h(b)})};f(c,0,a)}else a(b)}function doHashPadding(c,b,a){a||(b.putByte(128),c=b.length()==c?0:c-b.length(),b.fillWithByte(0,c));return!0}
function doXHRObject(c,b,a){var f={},d=JSON.parse(b);if(void 0==c)f.operation=d.operation,f.messageNumber=d.messageNumber,f.resultCode="0051",f.resultMessage="Initialization failed, please check server url.",a(JSON.stringify(f));else{var e=createCORSRequest("POST",c);if(!e)throw Error("CORS not supported");e.onload=function(){a(e.responseText)};e.onerror=function(){f.operation=d.operation;f.messageNumber=d.messageNumber;f.resultCode="0052";f.resultMessage="unexpected answer from Security Server :"+
e.status;document.getElementById("resData").value=JSON.stringify(f);a(JSON.stringify(f))};e.send(b)}}function createCORSRequest(c,b){var a=new XMLHttpRequest;"withCredentials"in a?(a.open(c,b,!0),a.setRequestHeader("Content-Type","application/json;charset=UTF-8")):"undefined"!=typeof XDomainRequest?(a=new XDomainRequest,a.open(c,b)):a=null;return a}function createERRResponse(){return JSON.parse(JSON.stringify({resultCode:"0053",resultMessage:"empty answer from Security Server"}))}
function closeSession(){messageNumber+=1;doXHRObject(relayURL,JSON.stringify({messageNumber:messageNumber,sessionID:sessionID,client:"PC-NX",operation:"CLOSE_SESSION",pktVersion:pktVersion}),function(c){"0000"==JSON.parse(c).resultCode&&(messageNumber=0)})}
function requestAppDown(c,b){var a;"easysign"==b?a="ES01":"cloudsign"==b&&(a="");var f={version:a,messageNumber:0,sessionID:"",operation:"SUBMIT_MEMBER_INFO",phoneNumber:c,joinCode:joinCode};console.log("msg : ",JSON.stringify(f));doXHRObject(smsURL,JSON.stringify(f),function(b){"0000"!=JSON.parse(b).resultCode?alert(errormsg):"ES01"==a?alert(esdownmsg):alert(csdownmsg)})};
