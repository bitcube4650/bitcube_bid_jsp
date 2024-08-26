(function(){function r(f){var g=f.jsustoolkitErrCode=f.jsustoolkitErrCode||{},c=f.pkcs8=f.pkcs8||{},a=f.asn1,t=f.pkcs5=f.pkcs5||{},k=f.pki=f.pki||{},m=k.oids,p={name:"EncryptedPrivateKeyInfo",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"EncryptedPrivateKeyInfo.encryptionAlgorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"AlgorithmIdentifier.algorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.OID,constructed:!1,capture:"encryptionOid"},{name:"AlgorithmIdentifier.parameters",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,captureAsn1:"encryptionParams"}]},{name:"EncryptedPrivateKeyInfo.encryptedData",tagClass:a.Class.UNIVERSAL,type:a.Type.OCTETSTRING,constructed:!1,capture:"encryptedData"}]};c.privateKeyValidator={name:"PrivateKeyInfo",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"PrivateKeyInfo.version",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyVersion"},{name:"PrivateKeyInfo.privateKeyAlgorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"AlgorithmIdentifier.algorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.OID,constructed:!1,capture:"privateKeyOid"}]},{name:"PrivateKeyInfo",tagClass:a.Class.UNIVERSAL,type:a.Type.OCTETSTRING,constructed:!1,capture:"privateKey"},{name:"Random",tagClass:a.Class.CONTEXT_SPECIFIC,type:0,constructed:!0,optional:!0,value:[{name:"Attributes",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"AttrOID",tagClass:a.Class.UNIVERSAL,type:a.Type.OID,constructed:!1,capture:"attributesOid"},{name:"AttributesValue",tagClass:a.Class.UNIVERSAL,type:a.Type.SET,constructed:!0,value:[{name:"rand",tagClass:a.Class.UNIVERSAL,type:a.Type.BITSTRING,constructed:!1,capture:"attributesRandom"}]}]}]}]};c.getPrivateKeyAttributesRandom=function(d){if(null==d||"undefined"==typeof d)throw{code:"111019",message:g["111019"]};var e={},b=[];if(!a.validate(d,f.pkcs8.privateKeyValidator,e,b))throw{code:"111020",message:g["111020"],errors:b};return"undefined"!=typeof e.attributesOid&&a.derToOid(e.attributesOid)==m.identifyData_random?(d=f.util.createBuffer(e.attributesRandom),++d.read,d.getBytes()):""};c.rsaPrivateKeyInfo=function(d,e){if(null==d||"undefined"==typeof d)throw{code:"111021",message:g["111021"]};var b=a.oidToDer(m.RSAEncryption).getBytes(),c=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);c.value.push(a.create(a.Class.UNIVERSAL,a.Type.OID,!1,b));c.value.push(a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,""));b=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(0)),c,a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,a.toDer(d).getBytes())]);null!=e&&(c=a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(m.identifyData_random).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[a.create(a.Class.UNIVERSAL,a.Type.BITSTRING,!1,String.fromCharCode(0)+e)])])]),b.value.push(c));return b};c.encryptPrivateKeyInfo=function(d,e,b){if(null==d||"undefined"==typeof d)throw{code:"111022",message:g["111022"]};if(null==e||"undefined"==typeof e)throw{code:"111023",message:g["111023"]};b=b||{};b.saltSize=b.saltSize||8;b.count=b.count||2048;b.algorithm=b.algorithm||"seed";b.salt=b.salt||f.random.getBytes(b.saltSize);var c=b.salt,h=b.count,q=f.util.createBuffer();q.putInt16(h);var n;if(0===b.algorithm.indexOf("aes")||0===b.algorithm.indexOf("seed")){var k;if("aes128"===b.algorithm)n=16,k=m["aes128-CBC"];else if("aes192"===b.algorithm)n=24,k=m["aes192-CBC"];else if("aes256"===b.algorithm)n=32,k=m["aes256-CBC"];else if("seed"===b.algorithm)n=16,k=m["seed-CBC"];else throw{code:"111024",message:g["111024"]+"("+b.algorithm+")"};n=f.pkcs5.pbkdf2(e,c,h,n);e=f.random.getBytes(16);b=f.cipher.algorithms[b.algorithm].createEncryptionCipher(n);b.start(e);b.update(a.toDer(d));b.finish();d=b.output.getBytes();c=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(m.pkcs5PBES2).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(m.pkcs5PBKDF2).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,c),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,q.getBytes())])]),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(k).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,e)])])])}else if("3des"===b.algorithm)n=24,k=new f.util.ByteBuffer(c),n=f.pkcs12.generateKey(e,k,1,h,n),e=f.pkcs12.generateKey(e,k,2,h,8),b=f.des.createEncryptionCipher(n),b.start(e),b.update(a.toDer(d)),b.finish(),d=b.output.getBytes(),c=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(m["pbeWithSHAAnd3-KeyTripleDES-CBC"]).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,c),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,q.getBytes())])]);else throw{code:"111025",message:g["111025"]+"("+b.algorithm+")"};return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[c,a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,d)])};c.decryptPrivateKeyInfo=function(d,c){if(null==d||"undefined"==typeof d)throw{code:"111026",message:g["111026"]};if(null==c||"undefined"==typeof c)throw{code:"111027",message:g["111027"]};var b=null,l={},h=[];if(!a.validate(d,p,l,h))throw{code:"111028",message:g["111028"],errors:h};h=a.derToOid(l.encryptionOid);h=t.pbe.getCipher(h,l.encryptionParams,c);l=f.util.createBuffer(l.encryptedData);h.update(l);h.finish()&&(b=a.fromDer(h.output));return b};c.encryptedPrivateKeyToPem=function(d,c){if(null==d||"undefined"==typeof d)throw{code:"111029",message:g["111029"]};var b=a.toDer(d),b=f.util.encode64(b.getBytes(),c||64);return"-----BEGIN ENCRYPTED PRIVATE KEY-----\r\n"+b+"\r\n-----END ENCRYPTED PRIVATE KEY-----"};c.encryptedPrivateKeyToBase64=function(d){if(null==d||"undefined"==typeof d)throw{code:"111030",message:g["111030"]};d=a.toDer(d);return f.util.encode64(d.getBytes())};c.encryptedPrivateKeyFromPem=function(d){if(null==d||"undefined"==typeof d)throw{code:"111031",message:g["111031"]};d=k.pemToDer(d);return a.fromDer(d)};c.encryptedPrivateKeyFromBase64=function(d){if(null==d||"undefined"==typeof d)throw{code:"111032",message:g["111032"]};d=k.base64ToDer(d);return a.fromDer(d)};c.encryptRsaPrivateKey=function(a,e,b,f,h){h=h||"bin";a=c.rsaPrivateKeyInfo(k.privateKeyToAsn1(a),e);a=c.encryptPrivateKeyInfo(a,b,f);if("bin"==h)return a;if("base64"==h)return c.encryptedPrivateKeyToBase64(a);if("pem"==h)return c.encryptedPrivateKeyToPem(a);throw{code:"111040",message:g["111040"]+"(type:"+h+")"};};c.decryptRsaPrivateKeyFromPem=function(a,e){var b=c.decryptRsaPrivateKeyInfoFromPem(a,e);null!==b&&(b=k.privateKeyFromAsn1(b));return b};c.decryptRsaPrivateKeyInfoFromPem=function(a,e){var b=c.encryptedPrivateKeyFromPem(a);return c.decryptPrivateKeyInfo(b,e)};c.decryptRsaPrivateKeyFromBase64=function(a,e){var b=c.decryptRsaPrivateKeyInfoFromBase64(a,e);null!==b&&(b=k.privateKeyFromAsn1(b));return b};c.decryptRsaPrivateKeyInfoFromBase64=function(a,e){var b=c.encryptedPrivateKeyFromBase64(a);return c.decryptPrivateKeyInfo(b,e)};c.checkUserCertPassword=function(a,e){if(null==e||"undefined"==typeof e)throw{code:"111034",message:g["111034"]};if(null==a||"undefined"==typeof a)throw{code:"111035",message:g["111035"]};try{return a=c.decryptPrivateKeyInfo(a,e),null!==a?(k.privateKeyFromAsn1(a),!0):!1}catch(b){return!1}};c.changePassword=function(a,e,b,f){if(null==a||"undefined"==typeof a)throw{code:"111036",message:g["111036"]};if(null==e||"undefined"==typeof e)throw{code:"111037",message:g["111037"]};if(null==b||"undefined"==typeof b)throw{code:"111038",message:g["111038"]};f=f||"bin";a=c.decryptPrivateKeyInfo(a,e);a=c.encryptPrivateKeyInfo(a,b,{algorithm:"seed"});if("bin"==f)return a;if("Base64"==f)return c.encryptedPrivateKeyToBase64(a);if("PEM"==f)return c.encryptedPrivateKeyToPem(a);throw{code:"111039",message:g["111039"]+"("+f+")"};};c.verifyVIDForHSM=function(c,e,b){if(null==c||"undefined"==typeof c)throw{code:"111045",message:g["111045"]};if(null==e||"undefined"==typeof e)throw{code:"111043",message:g["111043"]};if(null==b||"undefined"==typeof b)throw{code:"111044",message:g["111044"]};b=f.asn1.fromDer(b.getExtension("subjectAltName").value);if(m.identifyData==a.derToOid(b.value[0].value[0].value)){var l=m[a.derToOid(b.value[0].value[1].value[0].value[1].value[0].value[1].value[0].value[0].value)];b=b.value[0].value[1].value[0].value[1].value[0].value[1].value[1].value[0].value;c=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.PRINTABLESTRING,!1,e),a.create(a.Class.UNIVERSAL,a.Type.BITSTRING,!1,String.fromCharCode(0)+c)]);e=f.md.algorithms[l].create();e.start();e.update(a.toDer(c).getBytes());c=e.digest();e.start();e.update(c.bytes());c=e.digest();return b==c.bytes()?!0:!1}return!1};c.verifyVID=function(d,e,b,l){if(null==d||"undefined"==typeof d)throw{code:"111041",message:g["111041"]};if(null==e||"undefined"==typeof e)throw{code:"111042",message:g["111042"]};if(null==b||"undefined"==typeof b)throw{code:"111043",message:g["111043"]};if(null==l||"undefined"==typeof l)throw{code:"111044",message:g["111044"]};for(var h=f.asn1.fromDer(l.getExtension("subjectAltName").value),k=0;k<h.value.length;k++)if(0==h.value[k].type&&m.identifyData==a.derToOid(h.value[k].value[0].value)){l=m[a.derToOid(h.value[k].value[1].value[0].value[1].value[0].value[1].value[0].value[0].value)];h=h.value[k].value[1].value[0].value[1].value[0].value[1].value[1].value[0].value;d=c.decryptPrivateKeyInfo(d,e);d=c.getPrivateKeyAttributesRandom(d);b=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.PRINTABLESTRING,!1,b),a.create(a.Class.UNIVERSAL,a.Type.BITSTRING,!1,String.fromCharCode(0)+d)]);l=f.md.algorithms[l].create();l.start();l.update(a.toDer(b).getBytes());b=l.digest();l.start();l.update(b.bytes());b=l.digest();if(h==b.bytes())return!0;break}return!1}}var s="./aes ./seed ./asn1 ./jsbn ./md ./oids ./random ./rsa ./util ./jsustoolkitErrCode".split(" "),p=null;"function"!==typeof define&&("object"===typeof module&&module.exports?p=function(f,g){g(require,module)}:(crosscert=window.crosscert=window.crosscert||{},r(crosscert)));(p||"function"===typeof define)&&(p||define)(["require","module"].concat(s),function(f,g){g.exports=function(c){var a=s.map(function(a){return f(a)}).concat(r);c=c||{};c.defined=c.defined||{};if(c.defined.pkcs8)return c.pkcs8;c.defined.pkcs8=!0;for(var g=0;g<a.length;++g)a[g](c);return c.pkcs8}})})();