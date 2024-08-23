(function(){function s(e){var k=e.jsustoolkitErrCode=e.jsustoolkitErrCode||{},a=e.asn1,m=e.pkcs7=e.pkcs7||{};m.messageFromPem=function(b){if(null==f||"undefined"==typeof f)throw{code:"113001",message:k["113001"]};b=e.pki.pemToDer(b);var f=a.fromDer(b);return m.messageFromAsn1(f)};m.messageToPem=function(b,f){if(null==b||"undefined"==typeof b)throw{code:"113002",message:k["113002"]};var c=a.toDer(b.toAsn1()),c=e.util.encode64(c.getBytes(),f||64);return"-----BEGIN PKCS7-----\r\n"+c+"\r\n-----END PKCS7-----"};m.messageFromBase64=function(b){if(null==b||"undefined"==typeof b)throw{code:"113003",message:k["113003"]};b=e.pki.base64ToDer(b);b=a.fromDer(b);return m.messageFromAsn1(b)};m.messageToBase64=function(b){if(null==b||"undefined"==typeof b)throw{code:"113004",message:k["113004"]};b=a.toDer(b.toAsn1());return e.util.encode64(b.getBytes())};m.messageFromAsn1=function(b){if(null==b||"undefined"==typeof b)throw{code:"113005",message:k["113005"]};var f={},c=[];if(!a.validate(b,m.asn1.contentInfoValidator,f,c))throw{code:"113006",message:k["113006"],errors:c};b=a.derToOid(f.contentType);switch(b){case e.pki.oids.envelopedData:b=m.createEnvelopedData();break;case e.pki.oids.encryptedData:b=m.createEncryptedData();break;case e.pki.oids.signedData:b=m.createSignedData();break;default:throw{code:"113007",message:k["113007"]+"("+b+")"};}b.fromAsn1(f.content.value[0]);return b};var p=function(b){var f={},c=[];if(!a.validate(b,m.asn1.recipientInfoValidator,f,c))throw{code:"113008",message:k["113008"],errors:c};return{version:f.version.charCodeAt(0),issuer:e.pki.RDNAttributesAsArray(f.issuer),serialNumber:e.util.createBuffer(f.serial).toHex(),encContent:{algorithm:a.derToOid(f.encAlgorithm),parameter:f.encParameter.value,content:f.encKey}}},r=function(b){return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[e.pki.distinguishedNameToAsn1({attributes:b.issuer}),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,e.util.hexToBytes(b.serialNumber))]),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.encContent.algorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")]),a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,b.encContent.content)])},s=function(b){for(var a=[],c=0;c<b.length;c++)a.push(r(b[c]));return a},q=function(b){return[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(e.pki.oids.data).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.algorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,b.parameter.getBytes())]),a.create(a.Class.CONTEXT_SPECIFIC,0,!1,b.content.getBytes())]},t=function(b,f,c){if(null==b||"undefined"==typeof b)throw{code:"113009",message:k["113009"]};if(null==f||"undefined"==typeof f)throw{code:"113010",message:k["113010"]};if(null==c||"undefined"==typeof c)throw{code:"113011",message:k["113011"]};var d={},g=[];if(!a.validate(f,c,d,g))throw{code:"113012",message:k["113012"],errors:g};if(a.derToOid(d.contentType)!==e.pki.oids.data)throw{code:"113013",message:k["113013"]};if(d.encContent){f="";if(d.encContent.constructor===Array)for(c=0;c<d.encContent.length;++c){if(d.encContent[c].type!==a.Type.OCTETSTRING)throw{code:"113014",message:k["113014"]};f+=d.encContent[c].value}else f=d.encContent;b.encContent={algorithm:a.derToOid(d.encAlgorithm),parameter:e.util.createBuffer(d.encParameter.value),content:e.util.createBuffer(f)}}if(d.content){f="";if(d.content.constructor===Array)for(c=0;c<d.content.length;++c){if(d.content[c].type!==a.Type.OCTETSTRING)throw{code:"113015",message:k["113015"]};f+=d.content[c].value}else f=d.content.constructor===Object?d.content.value[0].value:d.content;b.content=e.util.createBuffer(f)}if(d.signature){for(c=0;c<d.certificates.length;++c)b.certificates.push(e.pki.certificateFromAsn1(d.certificates[c]));b.crls=d.crls;b.signContent.push(d.signerInfos);b.digestAlgo.push(a.derToOid(d.digestAlgorithm));b.authenticatedAttributes.push(d.authenticatedAttributes);b.signature.push(d.signature)}b.version=d.version.charCodeAt(0);return b.rawCapture=d},u=function(a){if(null==a||"undefined"==typeof a)throw{code:"113016",message:k["113016"]};if(void 0===a.encContent.key)throw{code:"113017",message:k["113017"]};if(void 0===a.content){var f;switch(a.encContent.algorithm){case e.pki.oids["aes128-CBC"]:case e.pki.oids["aes192-CBC"]:case e.pki.oids["aes256-CBC"]:f=e.aes.createDecryptionCipher(a.encContent.key);break;case e.pki.oids["des-EDE3-CBC"]:f=e.des.createDecryptionCipher(a.encContent.key);break;case e.pki.oids["seed-CBC"]:f=e.seed.createDecryptionCipher(a.encContent.key);break;default:throw{code:"113018",message:k["113018"]+a.encContent.algorithm};}f.start(a.encContent.parameter);f.update(a.encContent.content);if(!f.finish())throw{code:"113019",message:k["113019"]};a.content=f.output}},v=function(a,f,c){if(null==a||"undefined"==typeof a)throw{code:"113020",message:k["113020"]};if(void 0===a.encContent.content){c=c||a.encContent.algorithm;f=f||a.encContent.key;var d,g,h;switch(c){case e.pki.oids["aes128-CBC"]:g=d=16;h=e.aes.createEncryptionCipher;break;case e.pki.oids["aes192-CBC"]:d=24;g=16;h=e.aes.createEncryptionCipher;break;case e.pki.oids["aes256-CBC"]:d=32;g=16;h=e.aes.createEncryptionCipher;break;case e.pki.oids["des-EDE3-CBC"]:d=24;g=8;h=e.des.createEncryptionCipher;break;case e.pki.oids["seed-CBC"]:g=d=16;h=e.seed.createEncryptionCipher;break;default:throw{code:"113021",message:k["113021"]+c};}if(void 0===f)f=e.util.createBuffer(e.random.getBytes(d));else if(f.length()!=d)throw{code:"113022",message:k["113022"]+"got "+f.length()+" bytes, expected "+d};a.encContent.algorithm=c;a.encContent.key=f;a.encContent.parameter=e.util.createBuffer(e.random.getBytes(g));f=h(f);f.start(a.encContent.parameter.copy());f.update(a.content);if(!f.finish())throw{code:"113023",message:k["113023"]};a.encContent.content=f.output}},w=function(b){if(null==b||"undefined"==typeof b)throw{code:"113024",message:k["113024"]};var f=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);f.value.push(a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)));f.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[e.pki.distinguishedNameToAsn1({attributes:b.issuer}),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,e.util.hexToBytes(b.serialNumber))]));f.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.digestAlgorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")]));b.authAttr&&f.value.push(a.create(a.Class.CONTEXT_SPECIFIC,0,!0,b.authAttr.value));f.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.digestEncAlgorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")]));f.value.push(a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,b.signature));return f};m.createSignedData=function(){var b=null;return b={type:e.pki.oids.signedData,version:1,certificates:[],crls:[],signature:[],signContent:[],authenticatedAttributes:[],digestAlgo:[],fromAsn1:function(a){if(null==a||"undefined"==typeof a)throw{code:"113026",message:k["113026"]};t(b,a,m.asn1.signedDataValidator)},toAsn1:function(){var f=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);f.value.push(a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.type).getBytes()));var c=a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[]),d=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);d.value.push(a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)));for(var g=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[]),h=0;h<b.signContent.length;h++)g.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.signContent[h].digestAlgorithm).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")]));d.value.push(g);b.content?d.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(e.pki.oids.data).getBytes()),a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,b.content.getBytes())])])):d.value.push(a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(e.pki.oids.data).getBytes())]));if(0!=b.certificates.length){g=a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[]);for(h=0;h<b.certificates.length;h++)g.value.push(e.pki.certificateToAsn1(b.certificates[h]));d.value.push(g)}if(0!=b.crls.length){g=a.create(a.Class.CONTEXT_SPECIFIC,1,!0,[]);for(h=0;h<b.crls.length;h++)g.value.push(b.crls[h].getBytes());d.value.push(g)}if(0<b.signContent.length){g=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[]);for(h=0;h<b.signContent.length;h++)g.value.push(w(b.signContent[h]));d.value.push(g)}else throw{code:"113027",message:k["113027"]};c.value.push(d);f.value.push(c);return f},signWithDecPriKey:function(a,c,d,g,h){if(null==c||"undefined"==typeof c)throw{code:"113028",message:k["113028"]};if(null==d||"undefined"==typeof d)throw{code:"113029",message:k["113029"]};if(null==a||"undefined"==typeof a)a="";b.content=e.util.createBuffer(a,"utf8");a={version:1,digestAlgorithm:e.pki.oids.sha256};var n=e.pki.oids[c.siginfo.algorithmOid].split("With");a.digestAlgorithm=e.pki.oids[n[0]];a.digestEncAlgorithm=e.pki.oids[n[1]];a.issuer=c.issuer.attributes;a.serialNumber=c.serialNumber;b.certificates.push(c);a.signTime=void 0!==typeof g&&null!=g?g:new Date;void 0!==typeof h&&null!=h&&b.crls.push(h);c=e.md.algorithms[e.pki.oids[a.digestAlgorithm]].create();c.update(b.content.bytes());a.signature=d.sign(c);b.signContent.push(a)},sign:function(a,c,d,g,h,n){if(null==g||"undefined"==typeof g)throw{code:"113030",message:k["113030"]};if(null==d||"undefined"==typeof d)throw{code:"113031",message:k["113031"]};d=e.pkcs8.decryptPrivateKeyInfo(d,g);d=e.pki.privateKeyFromAsn1(d);b.signWithDecPriKey(a,c,d,h,n)},signWithHashWithDecPriKey:function(a,c,d,g,h,n){if(null==d||"undefined"==typeof d)throw{code:"113028",message:k["113028"]};if(null==g||"undefined"==typeof g)throw{code:"113029",message:k["113029"]};if(null==a||"undefined"==typeof a)a="";var l={version:1,digestAlgorithm:e.pki.oids.sha256},m=e.pki.oids[d.siginfo.algorithmOid].split("With");l.digestAlgorithm=e.pki.oids[c];l.digestEncAlgorithm=e.pki.oids[m[1]];l.issuer=d.issuer.attributes;l.serialNumber=d.serialNumber;b.certificates.push(d);l.signTime=void 0!==typeof h&&null!=h?h:new Date;void 0!==typeof n&&null!=n&&b.crls.push(n);l.digest=a;l.signature=g.signWithHash(a);b.signContent.push(l)},signWithHashData:function(a,c,d,g,h,n,l){if(null==h||"undefined"==typeof h)throw{code:"113030",message:k["113030"]};if(null==g||"undefined"==typeof g)throw{code:"113031",message:k["113031"]};g=e.pkcs8.decryptPrivateKeyInfo(g,h);g=e.pki.privateKeyFromAsn1(g);b.signWithHashWithDecPriKey(a,c,d,g,n,l)},signWithHashDataNP1:function(a,c,d,g,h,n){if(null==g||"undefined"==typeof g)throw{code:"113028",message:k["113028"]};if(null==c||"undefined"==typeof c)c="";if(null==a||"undefined"==typeof a)a="";var l={version:1,digestAlgorithm:e.pki.oids.sha256},m=e.pki.oids[g.siginfo.algorithmOid].split("With");l.digestAlgorithm=e.pki.oids[d];l.digestEncAlgorithm=e.pki.oids[m[1]];l.issuer=g.issuer.attributes;l.serialNumber=g.serialNumber;b.certificates.push(g);l.signTime=void 0!==typeof h&&null!=h?h:new Date;void 0!==typeof n&&null!=n&&b.crls.push(n);l.digest=c;l.signature=a;b.signContent.push(l)},signWithP1:function(a,c,d,g,h){if(null==d||"undefined"==typeof d)throw{code:"113028",message:k["113028"]};if(null==c||"undefined"==typeof c)c="";b.content=e.util.createBuffer(c,"utf8");c={version:1,digestAlgorithm:e.pki.oids.sha256};var n=e.pki.oids[d.siginfo.algorithmOid].split("With");c.digestAlgorithm=e.pki.oids[n[0]];c.digestEncAlgorithm=e.pki.oids[n[1]];c.issuer=d.issuer.attributes;c.serialNumber=d.serialNumber;b.certificates.push(d);c.signTime=void 0!==typeof g&&null!=g?g:new Date;void 0!==typeof h&&null!=h&&b.crls.push(h);d=e.md.algorithms[e.pki.oids[c.digestAlgorithm]].create();d.update(b.content.bytes());c.digest=d.digest().bytes();c.signature=a;b.signContent.push(c)},verifyWithHash:function(f){if("undefined"!=typeof certs)if(cert.constructor===Array)for(var c in certs)b.certificates.push(certs[c]);else b.certificates.push(certs);if(null==f||"undefined"==typeof f)throw{code:"113043",message:k["113043"]};if(b.certificates.length!=b.signContent.length)throw{code:"113042",message:k["113042"]};for(c=0;c<b.certificates.length;c++){var d=b.certificates[c].publicKey,g;g=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[]);if("undefined"!=typeof b.authenticatedAttributes[0])for(var h in b.authenticatedAttributes[c]){e.pki.oids.messageDigest!=a.derToOid(b.authenticatedAttributes[c][h].value[0].value)&&e.pki.oids.signingTime==a.derToOid(b.authenticatedAttributes[c][h].value[0].value)&&(23==b.authenticatedAttributes[c][h].value[1].value[0].type?b.signTime=a.utcTimeToDate(b.authenticatedAttributes[c][h].value[1].value[0].value):24==b.authenticatedAttributes[c][h].value[1].value[0].type&&(b.signTime=a.generalizedTimeToDate(b.authenticatedAttributes[c][h].value[1].value[0].value)));g.value.push(b.authenticatedAttributes[c][h]);var n=e.md.algorithms[e.pki.oids[b.digestAlgo[c]]].create();n.update(a.toDer(g).bytes());b.verifyResult=!1;try{b.verifyResult=d.verify(n.digest().getBytes(),b.signature[c])}catch(l){b.verifyResult=!1}}else{g=f;try{b.verifyResult=d.verify(g,b.signature[c])}catch(m){b.verifyResult=!1}}}},addSign:function(a,b,d){},verify:function(f,c){if("undefined"!=typeof f)if(cert.constructor===Array)for(var d in f)b.certificates.push(f[d]);else b.certificates.push(f);"undefined"!=typeof c&&(b.content=e.util.createBuffer(c,"utf8"));if(b.certificates.length!=b.signContent.length)throw{code:"113042",message:k["113042"]};for(d=0;d<b.certificates.length;d++){var g=b.certificates[d].publicKey,h,n=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[]);if("undefined"!=typeof b.authenticatedAttributes[0]){for(var l in b.authenticatedAttributes[d])e.pki.oids.messageDigest==a.derToOid(b.authenticatedAttributes[d][l].value[0].value)?h=b.authenticatedAttributes[d][l].value[1].value[0].value:e.pki.oids.signingTime==a.derToOid(b.authenticatedAttributes[d][l].value[0].value)&&(23==b.authenticatedAttributes[d][l].value[1].value[0].type?b.signTime=a.utcTimeToDate(b.authenticatedAttributes[d][l].value[1].value[0].value):24==b.authenticatedAttributes[d][l].value[1].value[0].type&&(b.signTime=a.generalizedTimeToDate(b.authenticatedAttributes[d][l].value[1].value[0].value))),n.value.push(b.authenticatedAttributes[d][l]);var m=e.md.algorithms[e.pki.oids[b.digestAlgo]].create();m.update(b.content.bytes());m.digest().bytes()==h?b.verifyResult=!0:b.verifyResult=!1;n=a.toDer(n).bytes()}else n=b.content.bytes();m=e.md.algorithms[e.pki.oids[b.digestAlgo[d]]].create();m.update(n);b.verifyResult=!1;try{b.verifyResult=g.verify(m.digest().getBytes(),b.signature[d])}catch(p){b.verifyResult=!1}}}}};m.createEncryptedData=function(){var b=null;return b={type:e.pki.oids.encryptedData,version:0,encContent:{algorithm:e.pki.oids["seed-CBC"]},fromAsn1:function(a){if(null==a||"undefined"==typeof a)throw{code:"113032",message:k["113032"]};t(b,a,m.asn1.encryptedDataValidator)},toAsn1:function(){return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.type).getBytes()),a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,q(b.encContent))])])])},encrypt:function(a,c){if(null==a||"undefined"==typeof a)throw{code:"113033",message:k["113033"]};a=e.util.createBuffer(a);v(b,a,c)},decrypt:function(a){if(null==a||"undefined"==typeof a)throw{code:"113034",message:k["113034"]};a=e.util.createBuffer(a);b.encContent.key=a;u(b)}}};m.createEnvelopedData=function(){var b=null;return b={type:e.pki.oids.envelopedData,version:0,recipients:[],encContent:{algorithm:e.pki.oids["seed-CBC"]},fromAsn1:function(a){if(null==a||"undefined"==typeof a)throw{code:"113035",message:k["113035"]};var c=t(b,a,m.asn1.envelopedDataValidator);a=b;for(var c=c.recipientInfos.value,d=[],e=0;e<c.length;e++)d.push(p(c[e]));a.recipients=d},toAsn1:function(){return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.type).getBytes()),a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version)),a.create(a.Class.UNIVERSAL,a.Type.SET,!0,s(b.recipients)),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,q(b.encContent))])])])},findRecipient:function(a){if(null==a||"undefined"==typeof a)throw{code:"113036",message:k["113036"]};for(var c=a.issuer.attributes,d=0;d<b.recipients.length;++d){var e=b.recipients[d],h=e.issuer;if(e.serialNumber===a.serialNumber&&h.length===c.length){for(var m=!0,l=0;l<c.length;++l)if(h[l].type!==c[l].type||h[l].value!==c[l].value){m=!1;break}if(m)return e}}},decrypt:function(a,c){if(null==a||"undefined"==typeof a)throw{code:"113037",message:k["113037"]};if(null==c||"undefined"==typeof c)throw{code:"113038",message:k["113038"]};if(void 0===b.encContent.key&&void 0!==a&&void 0!==c)switch(a.encContent.algorithm){case e.pki.oids.RSAEncryption:var d=c.decrypt(a.encContent.content);b.encContent.key=e.util.createBuffer(d);break;default:throw{code:"113039",message:k["113039"]+"( OID : "+a.encContent.algorithm+")"};}u(b)},addRecipient:function(a){if(null==a||"undefined"==typeof a)throw{code:"113040",message:k["113040"]};b.recipients.push({version:0,issuer:a.issuer.attributes,serialNumber:a.serialNumber,encContent:{algorithm:e.pki.oids.RSAEncryption,key:a.publicKey}})},encrypt:function(a,c){v(b,a,c);for(var d=0;d<b.recipients.length;d++){var g=b.recipients[d];if(void 0===g.encContent.content)switch(g.encContent.algorithm){case e.pki.oids.RSAEncryption:g.encContent.content=g.encContent.key.encrypt(b.encContent.key.data);break;default:throw{code:"113041",message:k["113041"]};}}}}}}var q="./aes ./seed ./asn1 ./des ./pkcs7asn1 ./pki ./random ./util ./jsustoolkitErrCode".split(" "),r=null;"function"!==typeof define&&("object"===typeof module&&module.exports?r=function(e,k){k(require,module)}:(crosscert=window.crosscert=window.crosscert||{},s(crosscert)));(r||"function"===typeof define)&&(r||define)(["require","module"].concat(q),function(e,k){k.exports=function(a){var k=q.map(function(a){return e(a)}).concat(s);a=a||{};a.defined=a.defined||{};if(a.defined.pkcs7)return a.pkcs7;a.defined.pkcs7=!0;for(var p=0;p<k.length;++p)k[p](a);return a.pkcs7}})})();