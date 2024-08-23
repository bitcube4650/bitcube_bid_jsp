(function(){function u(h){"undefined"===typeof BigInteger&&(BigInteger=h.jsbn.BigInteger);var a=h.asn1,p=h.jsustoolkitErrCode=h.jsustoolkitErrCode||{},f=h.pki=h.pki||{},k=f.oids,w=h.pkcs8=h.pkcs8||{},y=h.x509Certificate=h.x509Certificate||{},r={};r.cn=k.commonName;r.commonName="cn";r.c=k.countryName;r.countryName="c";r.l=k.localityName;r.localityName="l";r.s=k.stateOrProvinceName;r.stateOrProvinceName="s";r.o=k.organizationName;r.organizationName="o";r.ou=k.organizationalUnitName;r.organizationalUnitName="ou";r.e=k.emailAddress;r.emailAddress="e";r.street=k.street;r.street="street";r.serialNumber=k.serialName;r.serialName="serialNumber";r.dnQualifier=k.dnQualifier;r.dnQualifier="dnQualifier";r.dc=k.domailComponent;r.domailComponent="dc";var u={name:"SubjectPublicKeyInfo",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,captureAsn1:"subjectPublicKeyInfo",value:[{name:"SubjectPublicKeyInfo.AlgorithmIdentifier",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"AlgorithmIdentifier.algorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.OID,constructed:!1,capture:"publicKeyOid"}]},{name:"SubjectPublicKeyInfo.subjectPublicKey",tagClass:a.Class.UNIVERSAL,type:a.Type.BITSTRING,constructed:!1,capture:"rsaPublicKey"}]},x={name:"RSAPublicKey",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"RSAPublicKey.modulus",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"publicKeyModulus"},{name:"RSAPublicKey.exponent",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"publicKeyExponent"}]},F={name:"Certificate",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"Certificate.TBSCertificate",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,captureAsn1:"tbsCertificate",value:[{name:"Certificate.TBSCertificate.version",tagClass:a.Class.CONTEXT_SPECIFIC,type:0,constructed:!0,optional:!0,value:[{name:"Certificate.TBSCertificate.version.integer",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"certVersion"}]},{name:"Certificate.TBSCertificate.serialNumber",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"certSerialNumber"},{name:"Certificate.TBSCertificate.signature",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"Certificate.TBSCertificate.signature.algorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.OID,constructed:!1,capture:"certinfoSignatureOid"},{name:"Certificate.TBSCertificate.signature.parameters",tagClass:a.Class.UNIVERSAL,optional:!0,captureAsn1:"certinfoSignatureParams"}]},{name:"Certificate.TBSCertificate.issuer",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,captureAsn1:"certIssuer"},{name:"Certificate.TBSCertificate.validity",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"Certificate.TBSCertificate.validity.notBefore (utc)",tagClass:a.Class.UNIVERSAL,type:a.Type.UTCTIME,constructed:!1,optional:!0,capture:"certValidity1UTCTime"},{name:"Certificate.TBSCertificate.validity.notBefore (generalized)",tagClass:a.Class.UNIVERSAL,type:a.Type.GENERALIZEDTIME,constructed:!1,optional:!0,capture:"certValidity2GeneralizedTime"},{name:"Certificate.TBSCertificate.validity.notAfter (utc)",tagClass:a.Class.UNIVERSAL,type:a.Type.UTCTIME,constructed:!1,optional:!0,capture:"certValidity3UTCTime"},{name:"Certificate.TBSCertificate.validity.notAfter (generalized)",tagClass:a.Class.UNIVERSAL,type:a.Type.GENERALIZEDTIME,constructed:!1,optional:!0,capture:"certValidity4GeneralizedTime"}]},{name:"Certificate.TBSCertificate.subject",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,captureAsn1:"certSubject"},u,{name:"Certificate.TBSCertificate.issuerUniqueID",tagClass:a.Class.CONTEXT_SPECIFIC,type:1,constructed:!0,optional:!0,value:[{name:"Certificate.TBSCertificate.issuerUniqueID.id",tagClass:a.Class.UNIVERSAL,type:a.Type.BITSTRING,constructed:!1,capture:"certIssuerUniqueId"}]},{name:"Certificate.TBSCertificate.subjectUniqueID",tagClass:a.Class.CONTEXT_SPECIFIC,type:2,constructed:!0,optional:!0,value:[{name:"Certificate.TBSCertificate.subjectUniqueID.id",tagClass:a.Class.UNIVERSAL,type:a.Type.BITSTRING,constructed:!1,capture:"certSubjectUniqueId"}]},{name:"Certificate.TBSCertificate.extensions",tagClass:a.Class.CONTEXT_SPECIFIC,type:3,constructed:!0,captureAsn1:"certExtensions",optional:!0}]},{name:"Certificate.signatureAlgorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"Certificate.signatureAlgorithm.algorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.OID,constructed:!1,capture:"certSignatureOid"},{name:"Certificate.TBSCertificate.signature.parameters",tagClass:a.Class.UNIVERSAL,optional:!0,captureAsn1:"certSignatureParams"}]},{name:"Certificate.signatureValue",tagClass:a.Class.UNIVERSAL,type:a.Type.BITSTRING,constructed:!1,capture:"certSignature"}]},G={name:"RSAPrivateKey",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"RSAPrivateKey.version",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyVersion"},{name:"RSAPrivateKey.modulus",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyModulus"},{name:"RSAPrivateKey.publicExponent",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyPublicExponent"},{name:"RSAPrivateKey.privateExponent",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyPrivateExponent"},{name:"RSAPrivateKey.prime1",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyPrime1"},{name:"RSAPrivateKey.prime2",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyPrime2"},{name:"RSAPrivateKey.exponent1",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyExponent1"},{name:"RSAPrivateKey.exponent2",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyExponent2"},{name:"RSAPrivateKey.coefficient",tagClass:a.Class.UNIVERSAL,type:a.Type.INTEGER,constructed:!1,capture:"privateKeyCoefficient"}]},H={name:"rsapss",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"rsapss.hashAlgorithm",tagClass:a.Class.CONTEXT_SPECIFIC,type:0,constructed:!0,value:[{name:"rsapss.hashAlgorithm.AlgorithmIdentifier",tagClass:a.Class.UNIVERSAL,type:a.Class.SEQUENCE,constructed:!0,optional:!0,value:[{name:"rsapss.hashAlgorithm.AlgorithmIdentifier.algorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.OID,constructed:!1,capture:"hashOid"}]}]},{name:"rsapss.maskGenAlgorithm",tagClass:a.Class.CONTEXT_SPECIFIC,type:1,constructed:!0,value:[{name:"rsapss.maskGenAlgorithm.AlgorithmIdentifier",tagClass:a.Class.UNIVERSAL,type:a.Class.SEQUENCE,constructed:!0,optional:!0,value:[{name:"rsapss.maskGenAlgorithm.AlgorithmIdentifier.algorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.OID,constructed:!1,capture:"maskGenOid"},{name:"rsapss.maskGenAlgorithm.AlgorithmIdentifier.params",tagClass:a.Class.UNIVERSAL,type:a.Type.SEQUENCE,constructed:!0,value:[{name:"rsapss.maskGenAlgorithm.AlgorithmIdentifier.params.algorithm",tagClass:a.Class.UNIVERSAL,type:a.Type.OID,constructed:!1,capture:"maskGenHashOid"}]}]}]},{name:"rsapss.saltLength",tagClass:a.Class.CONTEXT_SPECIFIC,type:2,optional:!0,value:[{name:"rsapss.saltLength.saltLength",tagClass:a.Class.UNIVERSAL,type:a.Class.INTEGER,constructed:!1,capture:"saltLength"}]},{name:"rsapss.trailerField",tagClass:a.Class.CONTEXT_SPECIFIC,type:3,optional:!0,value:[{name:"rsapss.trailer.trailer",tagClass:a.Class.UNIVERSAL,type:a.Class.INTEGER,constructed:!1,capture:"trailer"}]}]};f.RDNAttributesAsArray=function(b,c){if(null==b||"undefined"==typeof b)throw{code:"112001",message:p["112001"]};for(var d=[],e,q,g,f=0;f<b.value.length;++f){e=b.value[f];for(var h=0;h<e.value.length;++h)g={},q=e.value[h],g.type=a.derToOid(q.value[0].value),g.value=q.value[1].value,g.valueTagClass=q.value[1].type,g.type in k&&(g.name=k[g.type],g.name in r&&(g.shortName=r[g.name])),c&&(c.update(g.type),c.update(g.value)),d.push(g)}return d};var C=function(a,c){c.constructor==String&&(c={shortName:c});for(var d=null,e,q=0;null===d&&q<a.attributes.length;++q)e=a.attributes[q],c.type&&c.type===e.type?d=e:c.name&&c.name===e.name?d=e:c.shortName&&c.shortName===e.shortName&&(d=e);return d},I=/-----BEGIN [^-]+-----([A-Za-z0-9+/=\s]+)-----END [^-]+-----/;f.pemToDer=function(a){if(null==a||"undefined"==typeof a)throw{code:"112002",message:p["112002"]};var c=null;if(a=I.exec(a))c=h.util.createBuffer(h.util.decode64(a[1]));else throw"Invalid PEM format";return c};f.base64ToDer=function(a){if(null==a||"undefined"==typeof a)throw{code:"112003",message:p["112003"]};var c=null;return c=h.util.createBuffer(h.util.decode64(a))};var z=function(b,c){var d=null,d=f.pemToDer(b),d=a.fromDer(d);return d=c(d)},A=function(b,c){var d=null,d=f.base64ToDer(b),d=a.fromDer(d);return d=c(d)},s=function(a){a=h.util.bytesToHex(h.util.hexToBytes(a.toString(16)));"8"<=a[0]&&(a="00"+a);return h.util.hexToBytes(a)},D=function(b,c,d){var e={};if(b!==k["RSASSA-PSS"])return e;d&&(e={hash:{algorithmOid:k.sha1},mgf:{algorithmOid:k.mgf1,hash:{algorithmOid:k.sha1}},saltLength:20});b={};d=[];if(!a.validate(c,H,b,d))throw{code:"112004",message:p["112004"]+"("+d+")"};void 0!==b.hashOid&&(e.hash=e.hash||{},e.hash.algorithmOid=a.derToOid(b.hashOid));void 0!==b.maskGenOid&&(e.mgf=e.mgf||{},e.mgf.algorithmOid=a.derToOid(b.maskGenOid),e.mgf.hash=e.mgf.hash||{},e.mgf.hash.algorithmOid=a.derToOid(b.maskGenHashOid));void 0!==b.saltLength&&(e.saltLength=b.saltLength.charCodeAt(0));return e};f.certificateFromPem=function(a,c){if(null==a||"undefined"==typeof a)throw{code:"112005",message:p["112005"]};return z(a,function(a){return f.certificateFromAsn1(a,c)})};f.certificateFromBase64=function(a,c){if(null==a||"undefined"==typeof a)throw{code:"112006",message:p["112006"]};return A(a,function(a){return f.certificateFromAsn1(a,c)})};f.certificateToPem=function(b,c){if(null==b||"undefined"==typeof b)throw{code:"112007",message:p["112007"]};var d=a.toDer(f.certificateToAsn1(b)),d=h.util.encode64(d.getBytes(),c||64);return"-----BEGIN CERTIFICATE-----\r\n"+d+"\r\n-----END CERTIFICATE-----"};f.certificateToBase64=function(b){if(null==b||"undefined"==typeof b)throw{code:"112008",message:p["112008"]};b=a.toDer(f.certificateToAsn1(b));return h.util.encode64(b.getBytes())};f.publicKeyFromPem=function(a){if(null==a||"undefined"==typeof a)throw{code:"112009",message:p["112009"]};return z(a,f.publicKeyFromAsn1)};f.publicKeyToPem=function(b,c){if(null==b||"undefined"==typeof b)throw{code:"112010",message:p["112010"]};var d=a.toDer(f.publicKeyToAsn1(b)),d=h.util.encode64(d.getBytes(),c||64);return"-----BEGIN PUBLIC KEY-----\r\n"+d+"\r\n-----END PUBLIC KEY-----"};f.privateKeyFromPem=function(a){if(null==a||"undefined"==typeof a)throw{code:"112011",message:p["112011"]};return z(a,f.privateKeyFromAsn1)};f.privateKeyToPem=function(b,c){if(null==b||"undefined"==typeof b)throw{code:"112012",message:p["112012"]};var d=a.toDer(f.privateKeyToAsn1(b)),d=h.util.encode64(d.getBytes(),c||64);return"-----BEGIN RSA PRIVATE KEY-----\r\n"+d+"\r\n-----END RSA PRIVATE KEY-----"};f.publicKeyFromBase64=function(a){if(null==a||"undefined"==typeof a)throw{code:"112013",message:p["112013"]};return A(a,f.publicKeyFromAsn1)};f.publicKeyToBase64=function(b){if(null==b||"undefined"==typeof b)throw{code:"112014",message:p["112014"]};b=a.toDer(f.publicKeyToAsn1(b));return h.util.encode64(b.getBytes())};f.privateKeyFromBase64=function(a){if(null==a||"undefined"==typeof a)throw{code:"112015",message:p["112013"]};return A(a,f.privateKeyFromAsn1)};f.privateKeyToBase64=function(b){if(null==b||"undefined"==typeof b)throw{code:"112016",message:p["112016"]};b=a.toDer(f.privateKeyToAsn1(b));return h.util.encode64(b.getBytes())};f.createCertificate=function(){var b={version:2,serialNumber:"00",signatureOid:null,signature:null,siginfo:{}};b.siginfo.algorithmOid=null;b.validity={};b.validity.notBefore=new Date;b.validity.notAfter=new Date;b.issuer={};b.issuer.getField=function(a){return C(b.issuer,a)};b.issuer.addField=function(a){c([a]);b.issuer.attributes.push(a)};b.issuer.attributes=[];b.issuer.hash=null;b.subject={};b.subject.getField=function(a){return C(b.subject,a)};b.subject.addField=function(a){c([a]);b.subject.attributes.push(a)};b.subject.attributes=[];b.subject.hash=null;b.extensions=[];b.publicKey=null;b.md=null;var c=function(a){for(var b,c=0;c<a.length;++c){b=a[c];"undefined"===typeof b.name&&(b.type&&b.type in f.oids?b.name=f.oids[b.type]:b.shortName&&b.shortName in r&&(b.name=f.oids[r[b.shortName]]));if("undefined"===typeof b.type)if(b.name&&b.name in f.oids)b.type=f.oids[b.name];else throw{code:"112017",message:p["112017"]+"("+b+")"};"undefined"===typeof b.shortName&&b.name&&b.name in r&&(b.shortName=r[b.name]);if("undefined"===typeof b.value)throw{code:"112018",message:p["112018"]+"("+b+")"};}};b.setSubject=function(a,e){if(null==a||"undefined"==typeof a)throw{code:"112019",message:p["112019"]};c(a);b.subject.attributes=a;delete b.subject.uniqueId;e&&(b.subject.uniqueId=e);b.subject.hash=null};b.setIssuer=function(a,e){if(null==a||"undefined"==typeof a)throw{code:"112020",message:p["112020"]};c(a);b.issuer.attributes=a;delete b.issuer.uniqueId;e&&(b.issuer.uniqueId=e);b.issuer.hash=null};b.setExtensions=function(d){if(null==d||"undefined"==typeof d)throw{code:"112021",message:p["112021"]};for(var e,c=0;c<d.length;++c){e=d[c];"undefined"===typeof e.name&&e.id&&e.id in f.oids&&(e.name=f.oids[e.id]);if("undefined"===typeof e.id)if(e.name&&e.name in f.oids)e.id=f.oids[e.name];else throw{code:"112022",message:p["112022"]+"("+e.name+")"};if("undefined"===typeof e.value){if("keyUsage"===e.name){var g=0,n=0,m=0;e.digitalSignature&&(n|=128,g=7);e.nonRepudiation&&(n|=64,g=6);e.keyEncipherment&&(n|=32,g=5);e.dataEncipherment&&(n|=16,g=4);e.keyAgreement&&(n|=8,g=3);e.keyCertSign&&(n|=4,g=2);e.cRLSign&&(n|=2,g=1);e.encipherOnly&&(n|=1,g=0);e.decipherOnly&&(m|=128,g=7);g=String.fromCharCode(g);0!==m?g+=String.fromCharCode(n)+String.fromCharCode(m):0!==n&&(g+=String.fromCharCode(n));e.value=a.create(a.Class.UNIVERSAL,a.Type.BITSTRING,!1,g)}else if("basicConstraints"===e.name)e.value=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]),e.cA&&e.value.value.push(a.create(a.Class.UNIVERSAL,a.Type.BOOLEAN,!1,String.fromCharCode(255))),e.pathLenConstraint&&(g=e.pathLenConstraint,n=h.util.createBuffer(),n.putInt(g,g.toString(2).length),e.value.value.push(a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,n.getBytes())));else if("subjectAltName"===e.name||"issuerAltName"===e.name)for(e.value=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]),m=0;m<e.altNames.length;++m)n=e.altNames[m],g=n.value,8===n.type&&(g=a.oidToDer(g)),e.value.value.push(a.create(a.Class.CONTEXT_SPECIFIC,n.type,!1,g));if("undefined"===typeof e.value)throw{code:"112023",message:p["112023"]};}}b.extensions=d};b.getExtension=function(a){if(null==a||"undefined"==typeof a)throw{code:"112024",message:p["112024"]};a.constructor==String&&(a={name:a});for(var e=null,c,g=0;null===e&&g<b.extensions.length;++g)c=b.extensions[g],a.id&&c.id===a.id?e=c:a.name&&c.name===a.name&&(e=c);return e};b.sign=function(d){if(null==d||"undefined"==typeof d)throw{code:"112025",message:p["112025"]};b.signatureOid=k.sha1WithRSAEncryption;b.siginfo.algorithmOid=k.sha1WithRSAEncryption;b.md=h.md.sha1.create();b.tbsCertificate=f.getTBSCertificate(b);var e=a.toDer(b.tbsCertificate);b.md.update(e.getBytes());b.signature=d.sign(b.md)};b.verify=function(d){if(null==d||"undefined"==typeof d)throw{code:"112026",message:p["112026"]};var e=!1,c=d.md;if(null===c){if(b.signatureOid in k)switch(k[b.signatureOid]){case "sha1WithRSAEncryption":c=h.md.sha1.create();break;case "kcdsaWithSHA1":b.md=h.md.sha1.create();break;case "md5WithRSAEncryption":c=h.md.md5.create();break;case "sha256WithRSAEncryption":c=h.md.sha256.create();break;case "RSASSA-PSS":c=h.md.sha256.create()}if(null===c)throw{code:"112027",message:p["112027"]+"("+b.signatureOid+")"};var g=d.tbsCertificate||f.getTBSCertificate(d),g=a.toDer(g);c.update(g.getBytes())}if(null!==c){e=void 0;switch(d.signatureOid){case k.sha1WithRSAEncryption:e=void 0;break;case k["RSASSA-PSS"]:e=k[d.signatureParameters.mgf.hash.algorithmOid];if(void 0===e||void 0===h.md[e])throw{code:"112028",message:p["112028"]+"(oid:"+d.signatureParameters.mgf.hash.algorithmOid+")"};g=k[d.signatureParameters.mgf.algorithmOid];if(void 0===g||void 0===h.mgf[g])throw{code:"112029",message:p["112029"]+"(oid:"+d.signatureParameters.mgf.algorithmOid+")"};g=h.mgf[g].create(h.md[e].create());e=k[d.signatureParameters.hash.algorithmOid];if(void 0===e||void 0===h.md[e])throw{code:"112030",message:p["112030"]+"(oid:"+d.signatureParameters.hash.algorithmOid+")"};e=h.pss.create(h.md[e].create(),g,d.signatureParameters.saltLength)}e=b.publicKey.verify(c.digest().getBytes(),d.signature,e)}return e};b.isIssuer=function(a){if(null==a||"undefined"==typeof a)throw{code:"112031",message:p["112031"]};var e=!1,c=b.issuer;a=a.subject;if(c.hash&&a.hash)e=c.hash===a.hash;else if(c.attributes.length===a.attributes.length)for(var e=!0,g,f,h=0;e&&h<c.attributes.length;++h)if(g=c.attributes[h],f=a.attributes[h],g.type!==f.type||g.value!==f.value)e=!1;return e};return b};f.certificateFromAsn1=function(b,c){if(null==b||"undefined"==typeof b)throw{code:"112032",message:p["112032"]};var d={},e=[];if(!a.validate(b,F,d,e))throw{code:"112033",message:p["112033"]+e};var e=a.derToOid(d.publicKeyOid),q=f.createCertificate();q.version=d.certVersion?d.certVersion.charCodeAt(0):0;var g=h.util.createBuffer(d.certSerialNumber);q.serialNumber=g.toHex();q.signatureOid=h.asn1.derToOid(d.certSignatureOid);q.signatureParameters=D(q.signatureOid,d.certSignatureParams,!0);q.siginfo.algorithmOid=h.asn1.derToOid(d.certinfoSignatureOid);q.siginfo.parameters=D(q.siginfo.algorithmOid,d.certinfoSignatureParams,!1);g=h.util.createBuffer(d.certSignature);++g.read;q.signature=g.getBytes();g=[];void 0!==d.certValidity1UTCTime&&g.push(a.utcTimeToDate(d.certValidity1UTCTime));void 0!==d.certValidity2GeneralizedTime&&g.push(a.generalizedTimeToDate(d.certValidity2GeneralizedTime));void 0!==d.certValidity3UTCTime&&g.push(a.utcTimeToDate(d.certValidity3UTCTime));void 0!==d.certValidity4GeneralizedTime&&g.push(a.generalizedTimeToDate(d.certValidity4GeneralizedTime));if(2<g.length)throw{code:"112035",message:p["112035"]};if(2>g.length)throw{code:"112036",message:p["112036"]};q.validity.notBefore=g[0];q.validity.notAfter=g[1];q.publicKeyOid=h.asn1.derToOid(d.publicKeyOid);q.tbsCertificate=d.tbsCertificate;if(c){q.md=null;if(q.signatureOid in k)switch(e=k[q.signatureOid],e){case "sha1WithRSAEncryption":q.md=h.md.sha1.create();break;case "kcdsaWithSHA1":q.md=h.md.sha1.create();break;case "md5WithRSAEncryption":q.md=h.md.md5.create();break;case "sha256WithRSAEncryption":q.md=h.md.sha256.create();break;case "RSASSA-PSS":q.md=h.md.sha256.create()}if(null===q.md)throw{code:"112037",message:p["112037"]+"(signatureOid:"+q.signatureOid+")"};g=a.toDer(q.tbsCertificate);q.md.update(g.getBytes())}g=h.md.sha1.create();q.issuer.attributes=f.RDNAttributesAsArray(d.certIssuer,g);d.certIssuerUniqueId&&(q.issuer.uniqueId=d.certIssuerUniqueId);q.issuer.hash=g.digest().toHex();g=h.md.sha1.create();q.subject.attributes=f.RDNAttributesAsArray(d.certSubject,g);d.certSubjectUniqueId&&(q.subject.uniqueId=d.certSubjectUniqueId);q.subject.hash=g.digest().toHex();if(d.certExtensions){for(var g=d.certExtensions,n=[],m,l,B,r=0;r<g.value.length;++r){B=g.value[r];for(var s=0;s<B.value.length;++s){l=B.value[s];m={};m.id=a.derToOid(l.value[0].value);m.critical=!1;l.value[1].type===a.Type.BOOLEAN?(m.critical=0!==l.value[1].value.charCodeAt(0),m.value=l.value[2].value):m.value=l.value[1].value;if(m.id in k)if(m.name=k[m.id],"keyUsage"===m.name){l=a.fromDer(m.value);var t=0,v=0;1<l.value.length&&(t=l.value.charCodeAt(1),v=2<l.value.length?l.value.charCodeAt(2):0);m.digitalSignature=128==(t&128);m.nonRepudiation=64==(t&64);m.keyEncipherment=32==(t&32);m.dataEncipherment=16==(t&16);m.keyAgreement=8==(t&8);m.keyCertSign=4==(t&4);m.cRLSign=2==(t&2);m.encipherOnly=1==(t&1);m.decipherOnly=128==(v&128)}else if("basicConstraints"===m.name)l=a.fromDer(m.value),m.cA=0<l.value.length?0!==l.value[0].value.charCodeAt(0):!1,1<l.value.length&&(l=h.util.createBuffer(l.value[1].value),m.pathLenConstraint=l.getInt(l.length()<<3));else if("subjectAltName"===m.name||"issuerAltName"===m.name)for(m.altNames=[],l=a.fromDer(m.value),v=0;v<l.value.length;++v){var t=l.value[v],u={type:t.type,value:t.value};m.altNames.push(u);switch(t.type){case 8:u.oid=a.derToOid(t.value)}}n.push(m)}}q.extensions=n}else q.extensions=[];e==f.oids.RSAEncryption?(q.publicKey=f.publicKeyFromAsn1(d.subjectPublicKeyInfo),q.rsaPublicKey=f.rsaPublicKeyToAsn1(q.publicKey)):q.publicKey=d.subjectPublicKeyInfo.value[1];return q};_dnToAsn1=function(b){var c=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]),d;b=b.attributes;for(var e=0;e<b.length;++e){d=b[e];var f=d.value,g=a.Type.PRINTABLESTRING;"valueTagClass"in d&&(g=d.valueTagClass);d=a.create(a.Class.UNIVERSAL,a.Type.SET,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(d.type).getBytes()),a.create(a.Class.UNIVERSAL,g,!1,f)])]);c.value.push(d)}return c};_extensionsToAsn1=function(b){var c=a.create(a.Class.CONTEXT_SPECIFIC,3,!0,[]),d=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);c.value.push(d);for(var e,f,g=0;g<b.length;++g){e=b[g];f=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[]);d.value.push(f);f.value.push(a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(e.id).getBytes()));e.critical&&f.value.push(a.create(a.Class.UNIVERSAL,a.Type.BOOLEAN,!1,String.fromCharCode(255)));var h=e.value;e.value.constructor!=String&&(h=a.toDer(h).getBytes());f.value.push(a.create(a.Class.UNIVERSAL,a.Type.OCTETSTRING,!1,h))}return c};var E=function(b,c){switch(b){case k["RSASSA-PSS"]:var d=[];void 0!==c.hash.algorithmOid&&d.push(a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.hash.algorithmOid).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")])]));void 0!==c.mgf.algorithmOid&&d.push(a.create(a.Class.CONTEXT_SPECIFIC,1,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.mgf.algorithmOid).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(c.mgf.hash.algorithmOid).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")])])]));void 0!==c.saltLength&&d.push(a.create(a.Class.CONTEXT_SPECIFIC,2,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(c.saltLength))]));return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,d);default:return a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")}};f.getTBSCertificate=function(b){var c=a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.CONTEXT_SPECIFIC,0,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(b.version))]),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,h.util.hexToBytes(b.serialNumber)),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.siginfo.algorithmOid).getBytes()),E(b.siginfo.algorithmOid,b.siginfo.parameters)]),_dnToAsn1(b.issuer),a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.UTCTIME,!1,a.dateToUtcTime(b.validity.notBefore)),a.create(a.Class.UNIVERSAL,a.Type.UTCTIME,!1,a.dateToUtcTime(b.validity.notAfter))]),_dnToAsn1(b.subject),f.publicKeyToAsn1(b.publicKey)]);b.issuer.uniqueId&&c.value.push(a.create(a.Class.CONTEXT_SPECIFIC,1,!0,[a.create(a.Class.UNIVERSAL,a.Type.BITSTRING,!1,String.fromCharCode(0)+b.issuer.uniqueId)]));b.subject.uniqueId&&c.value.push(a.create(a.Class.CONTEXT_SPECIFIC,2,!0,[a.create(a.Class.UNIVERSAL,a.Type.BITSTRING,!1,String.fromCharCode(0)+b.subject.uniqueId)]));0<b.extensions.length&&c.value.push(_extensionsToAsn1(b.extensions));return c};f.distinguishedNameToAsn1=function(a){if(null==a||"undefined"==typeof a)throw{code:"112038",message:p["112038"]};return _dnToAsn1(a)};f.certificateToAsn1=function(b){if(null==b||"undefined"==typeof b)throw{code:"112039",message:p["112039"]};var c=b.tbsCertificate||f.getTBSCertificate(b);return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[c,a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(b.signatureOid).getBytes()),E(b.signatureOid,b.signatureParameters)]),a.create(a.Class.UNIVERSAL,a.Type.BITSTRING,!1,String.fromCharCode(0)+b.signature)])};f.createCaStore=function(b){var c={certs:{},getIssuer:function(b){if(null==b||"undefined"==typeof b)throw{code:"112040",message:p["112040"]};var d=null;new y.certUtil;if(b.issuer.hash in c.certs){d=c.certs[b.issuer.hash];b=h.asn1.fromDer(b.getExtension("authorityKeyIdentifier").value);var g=h.asn1.fromDer(d.getExtension("subjectKeyIdentifier").value).value;if(b.value[0].value!=g)return null;if(b.value[1]){var g=h.util.bytesToHex(a.toDer(b.value[1].value[0].value[0]).getBytes()),n=h.util.bytesToHex(a.toDer(f.distinguishedNameToAsn1(d.issuer)).getBytes());if(g!=n)return null}if(b.value[2]&&h.util.bytesToHex(b.value[2].value)!=d.serialNumber)return null}return d},addCertificate:function(a){if(null==a||"undefined"==typeof a)throw{code:"112041",message:p["112041"]};a.constructor==String&&(a=h.pki.certificateFromPem(a));if(a.subject.hash in c.certs){var b=c.certs[a.subject.hash];b.constructor!=Array&&(b=[b]);b.push(a)}else c.certs[a.subject.hash]=a}};if(b)for(var d=0;d<b.length;++d)c.addCertificate(b[d]);return c};f.certificateError={bad_certificate:"crosscert.pki.BadCertificate",unsupported_certificate:"crosscert.pki.UnsupportedCertificate",certificate_revoked:"crosscert.pki.CertificateRevoked",certificate_expired:"crosscert.pki.CertificateExpired",certificate_unknown:"crosscert.pki.CertificateUnknown",unknown_ca:"crosscert.pki.UnknownCertificateAuthority"};_verifyValidity=function(a,c){new y.certUtil;return a<c.validity.notBefore||a>c.validity.notAfter?!1:!0};f.verifyCertificateChain=function(a,c,d){var e=new Date,p=!1,g=new y.certUtil;if(_verifyValidity(e,c)){var n=[],m=a.getIssuer(c);if(null===m)error={message:"no parent issuer, so certificate not trusted.",error:f.certificateError.unknown_ca},d(!1,n.length,error.message);else{for(n.push(c);m.issuer.hash!=m.subject.hash;){var l=m;if(_verifyValidity(e,l)){m=a.getIssuer(l);if(null===m){error={message:"no parent issuer, so certificate not trusted.",error:f.certificateError.unknown_ca};break}n.push(l)}else error={message:"Certificate is not valid yet or has expired.",error:f.certificateError.certificate_expired,notBefore:c.validity.notBefore,notAfter:c.validity.notAfter,now:e},d(!1,n.length,error.message)}_verifyValidity(e,m)?n.push(m):(error={message:"Certificate is not valid yet or has expired.",error:f.certificateError.certificate_expired,notBefore:c.validity.notBefore,notAfter:c.validity.notAfter,now:e},d(!1,n.length,error.message));a=[];for(c=n.length-1;0<=c;c--){e=n[c];m=e.getExtension("basicConstraints");if(c!=n.length-1&&0!=c&&(l=e.getExtension("nameConstraints"),null!=l)){var k=g.getDN(n[c-1].subject);if(null!=l.permittedSubtrees){var r=!0,s="";for(c=0;c<l.permittedSubtrees.length;c++)s=l.permittedSubtrees.value[c],0>k.indexOf(s)&&(r=!1);1!=r&&(error={message:"Certificate nameConstraints verify : fail!(permittedSubtrees)",error:f.certificateError.bad_certificate},d(!1,n.length,error.message))}if(null!=l.excludedSubtrees){r=!1;for(c=0;c<l.excludedSubtrees.length;c++)s=l.excludedSubtrees.value[c],-1<k.indexOf(s)&&(r=!0);1==r&&(error={message:"Certificate nameConstraints verify : fail!(excludedSubtrees)",error:f.certificateError.bad_certificate},d(!1,n.length,error.message))}}l=e.getExtension("keyUsage");null!=l&&(k="",l.digitalSignature&&(k+="digitalSignature,"),l.nonRepudiation&&(k+="nonRepudiation,"),l.keyEncipherment&&(k+="keyEncipherment,"),l.dataEncipherment&&(k+="dataEncipherment,"),l.keyAgreement&&(k+="keyAgreement,"),null!=m&&l.keyCertSign&&(k+="keyCertSign,"),null!=m&&l.cRLSign&&(k+="cRLSign,"),l.encipherOnly&&(k+="encipherOnly,"),l.decipherOnly&&(k+="decipherOnly,"),k=k.substring(0,k.length-1),""==k&&d(!1,n.length,"\ud655\uc7a5\ud0a4 \uc0ac\uc6a9 \ubaa9\uc801  \uac80\uc99d : false"));c!=n.length-1&&(m=e.getExtension("certificatePolicies"),l={valid_policy:"any-policy",qualifier_set:"empty",criticality_indicator:!1,expected_policy_set:"any-policy",node:[]},null!=m&&null!=l?(k=h.asn1.fromDer(m.value),k.value[1]?(l.valid_policy=h.asn1.derToOid(k.value[1].value[0].value),l.qualifier_set=k.v,alue[1].value[1].value):(l.valid_policy=h.asn1.derToOid(k.value[0].value[0].value),l.qualifier_set=k.value[0].value[1].value),l.criticality_indicator=m.critical,"2.5.29.32.0"==l.valid_policy?(l.expected_policy_set=l.valid_policy,a.push(l)):"2.5.29.32.0"==a[a.length-1].expected_policy_set?(l.expected_policy_set=l.valid_policy,a[a.length-1].node.push(l)):(l.expected_policy_set=l.valid_policy,a.push(l))):a=null,null==a&&d(!1,n.length,"\uc720\ud6a8\ud55c \uc815\ucc45 \ud2b8\ub9ac\uac00 null\uc784. \uac80\uc99d \uc2e4\ud328"));if(c==n.length-1)try{p=e.verify(e)}catch(t){error={message:"Certificate signature is invalid.",error:f.certificateError.bad_certificate},d(!1,n.length,error.message)}else try{p=n[c+1].verify(e)}catch(u){error={message:"Certificate signature is invalid.",error:f.certificateError.bad_certificate},d(!1,n.length,error.message)}}d(p,n.length,n)}}else error={message:"Certificate is not valid yet or has expired.",error:f.certificateError.certificate_expired,notBefore:c.validity.notBefore,notAfter:c.validity.notAfter,now:e},d(!1,0,error.message)};f.publicKeyFromAsn1=function(b){var c={},d=[];if(!a.validate(b,u,c,d))throw{code:"112042",message:p["112042"],errors:d};return a.derToOid(c.publicKeyOid)==f.oids.RSAEncryption?(b=h.util.createBuffer(c.rsaPublicKey),b.getByte(),f.rsaPublicKeyFromAsn1(a.fromDer(b))):a.create(a.Class.UNIVERSAL,a.Type.BITSTRING,!1,String.fromCharCode(0)+c.subjectPublicKeyInfo.value[1].value)};f.publicKeyToAsn1=function(b){if(null==b||"undefined"==typeof b)throw{code:"112045",message:p["112045"]};return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.OID,!1,a.oidToDer(f.oids.RSAEncryption).getBytes()),a.create(a.Class.UNIVERSAL,a.Type.NULL,!1,"")]),a.create(a.Class.UNIVERSAL,a.Type.BITSTRING,!1,[a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.n)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.e))])])])};f.rsaPublicKeyFromAsn1=function(b){var c={},d=[];if(!a.validate(b,x,c,d))throw{code:"112044",message:p["112044"],errors:d};b=h.util.createBuffer(c.publicKeyModulus).toHex();c=h.util.createBuffer(c.publicKeyExponent).toHex();return f.setRsaPublicKey(new BigInteger(b,16),new BigInteger(c,16))};f.rsaPublicKeyToAsn1=function(b){if(null==b||"undefined"==typeof b)throw{code:"112046",message:p["112046"]};return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.n)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.e))])};f.privateKeyFromAsn1=function(b){if(null==b||"undefined"==typeof b)throw{code:"112047",message:p["112047"]};var c={},d=[];a.validate(b,w.privateKeyValidator,c,d)&&(b=a.fromDer(h.util.createBuffer(c.privateKey)));c={};d=[];if(!a.validate(b,G,c,d))throw{code:"112048",message:p["112048"],errors:d};var e,k,g,n,m;b=h.util.createBuffer(c.privateKeyModulus).toHex();d=h.util.createBuffer(c.privateKeyPublicExponent).toHex();e=h.util.createBuffer(c.privateKeyPrivateExponent).toHex();k=h.util.createBuffer(c.privateKeyPrime1).toHex();g=h.util.createBuffer(c.privateKeyPrime2).toHex();n=h.util.createBuffer(c.privateKeyExponent1).toHex();m=h.util.createBuffer(c.privateKeyExponent2).toHex();c=h.util.createBuffer(c.privateKeyCoefficient).toHex();return f.setRsaPrivateKey(new BigInteger(b,16),new BigInteger(d,16),new BigInteger(e,16),new BigInteger(k,16),new BigInteger(g,16),new BigInteger(n,16),new BigInteger(m,16),new BigInteger(c,16))};f.privateKeyToAsn1=function(b){if(null==b||"undefined"==typeof b)throw{code:"112049",message:p["112049"]};return a.create(a.Class.UNIVERSAL,a.Type.SEQUENCE,!0,[a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,String.fromCharCode(0)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.n)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.e)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.d)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.p)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.q)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.dP)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.dQ)),a.create(a.Class.UNIVERSAL,a.Type.INTEGER,!1,s(b.qInv))])};f.setRsaPublicKey=f.rsa.setPublicKey;f.setRsaPrivateKey=f.rsa.setPrivateKey}var x="./aes ./asn1 ./jsbn ./md ./oids ./random ./rsa ./util ./jsustoolkitErrCode".split(" "),w=null;"function"!==typeof define&&("object"===typeof module&&module.exports?w=function(h,a){a(require,module)}:(crosscert=window.crosscert=window.crosscert||{},u(crosscert)));(w||"function"===typeof define)&&(w||define)(["require","module"].concat(x),function(h,a){a.exports=function(a){var f=x.map(function(a){return h(a)}).concat(u);a=a||{};a.defined=a.defined||{};if(a.defined.pki)return a.pki;a.defined.pki=!0;for(var k=0;k<f.length;++k)f[k](a);return a.pki}})})();