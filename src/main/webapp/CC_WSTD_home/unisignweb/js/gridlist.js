var __gridlist=function(b){function y(a){this._viewlist=null;this._viewlistcnt=-1;this._selectedrow=null;this._tabidx=this._rowcnt=this._colcnt=-1;this._resizeFlag=!1;this._limittitleelementwidth=[];this._datarowwidth=this._datalistwidth=this._limitdatarowwidth=this._limitdataelementwidth=this._limittitlerowwidth=0;this._arrdataelementwidth=[];this._lastonmousemoveevent=document.onmousemove;this._lastonmouseupevent=document.onmouseup;this._listtype=a.listtype;this._tblid=a.tblid;this._tbltitleid=a.tbltitleid;this._titlelistid=a.titlelistid;this._titlerowid=a.titlerowid;this._titleelementid=a.titleelementid;this._titledividerid=a.titledividerid;this._titlelistcn=a.titlelistcn;this._titlerowcn=a.titlerowcn;this._titleelementcn=a.titleelementcn;this._titledividercn=a.titledividercn;this._tblbodyid=a.tblbodyid;this._datalistid=a.datalistid;this._datarowid=a.datarowid;this._dataelementid=a.dataelementid;this._datalistcn=a.datalistcn;this._datarowcn=a.datarowcn;this._dataelementcn=a.dataelementcn;this._dataselectcn=a.dataselectcn}y.prototype={setViewList:function(a){this._viewlist=a},getViewList:function(){return this._viewlist},setViewListCnt:function(a){this._viewlistcnt=a},getViewListCnt:function(){return this._viewlistcnt},setRowCnt:function(a){this._rowcnt=a},getRowCnt:function(){return this._rowcnt},setColCnt:function(a){this._colcnt=a},getColCnt:function(){return this._colcnt},setTabIdx:function(a){this._tabidx=a},getTabIdx:function(){return this._tabidx},setDataListWidth:function(a){this._datalistwidth=a},getDataListWidth:function(){return this._datalistwidth},setDataRowWidth:function(a){this._datarowwidth=a},getDataRowWidth:function(){return this._datarowwidth},setDataElementWidth:function(a,b){this._arrdataelementwidth[a]=b},getDataElementWidth:function(a){return this._arrdataelementwidth[a]},getLimitTitleRowWidth:function(){return this._limittitlerowwidth},getLimitTitleElementWidth:function(a){return this._limittitleelementwidth[a-1]},getLimitDataRowWidth:function(){return this._limitdatarowwidth},getLimitDataElementWidth:function(){return this._limitdataelementwidth},getResizeFlag:function(){return this._resizeFlag},getLastOnMouseMoveEvent:function(){return this._lastonmousemoveevent},getLastOnMouseUpEvent:function(){return this._lastonmouseupevent},getListTypeID:function(){return this._listtype},getTitleListID:function(){return this._titlelistid},getTitleRowID:function(){return this._titlerowid},getTitleElementID:function(){return this._titleelementid},getDividerID:function(){return this._titledividerid},getDataListID:function(){return this._datalistid},getDataRowID:function(){return this._datarowid},getDataElementID:function(){return this._dataelementid},getSelectedRow:function(){return this._selectedrow},focusOnRow:function(a){if(!a)return!1;var e=a.childNodes.length,c=-1;if(this._selectedrow){for(var c=this._selectedrow.getAttribute("tabindex"),l=0;l<e;l++)"certslist"==this.getListTypeID()?this._selectedrow.childNodes[l].className=this._dataelementcn+" grid-element"+(l+1):this._selectedrow.childNodes[l].className=this._dataelementcn;this._selectedrow.setAttribute("aria-selected","false",0);this._selectedrow.removeAttribute("tabindex")}for(l=0;l<e;l++)"certslist"==this.getListTypeID()?a.childNodes[l].className=this._dataselectcn+" grid-element"+(l+1):a.childNodes[l].className=this._dataselectcn;a.setAttribute("aria-selected","true",0);-1<c&&(a.setAttribute("tabindex",c,0),setTimeout(function(){a.focus()},10));this._selectedrow=a;if(a.className&&"us-layout-grid-body-row"==a.className&&null!=document.getElementById("us-div-cert-manage-detail")&&"none"!=document.getElementById("us-div-cert-manage-detail").style.display){if("undefined"==this.getSelectedIndex())return;e=this.getSelectedIndex();b.certsList&&b.certsList.list&&null!=b.certsList.list[e-1]&&null!=b.certsList.list[e-1].cert&&(c=b.certsList.list[e-1].path,b.usWebToolkit.x509Certificate.parser(b.certsList.list[e-1].cert,"Base64"),document.getElementById("us-layout-cert-manage-detail-box-subject").innerHTML="<b>"+b.certUtil().getCN(b.usWebToolkit.x509Certificate.getSubjectName())+"</b>",document.getElementById("us-layout-cert-manage-detail-box-expire-data").innerHTML=b.certUtil().getLocalDate(b.usWebToolkit.x509Certificate.getNotBefore())+" ~ "+b.certUtil().getLocalDate(b.usWebToolkit.x509Certificate.getNotAfter()),document.getElementById("us-layout-cert-manage-detail-box-savepath-data").innerHTML=c,document.getElementById("us-layout-cert-manage-detail-box-savepath-data").setAttribute("title",c))}return!0},getRowForFocusing:function(a,b){if(!a||!b)return null;var c=a||window.event,l=c.which||c.keyCode,n=parseInt(b.parentNode.childNodes.length);if(13==l)return c=b.id.split(this._datarowid),c=parseInt(c[1])-1,n=this._datarowid+(c+1),n=document.getElementById(n);if(38===l){if(c.stopPropagation(),c.cancelBubble=!0,c.returnValue=!1,c=b.id.split(this._datarowid),c=parseInt(c[1])-1,!(0>=c))return n=this._datarowid+c,n=document.getElementById(n)}else if(40===l&&(c.stopPropagation(),c.cancelBubble=!0,c.returnValue=!1,c=b.id.split(this._datarowid),c=parseInt(c[1])-1,!(c>=n-1||c>=this._viewlistcnt-1)))return n=this._datarowid+(c+2),n=document.getElementById(n);return null},getSelectedIndex:function(){if(!this._selectedrow)return-1;var a=this._selectedrow.childNodes.length;return a=this._selectedrow.childNodes[a-1].firstChild.nodeValue},drawListTitle:function(a,e,c){if(!a||0>=e)return!1;this._colcnt=e;this._resizeFlag=c;c=document.createElement("DIV");c.setAttribute("id",this._titlelistid,0);c.className=this._titlelistcn;document.getElementById(this._tbltitleid).appendChild(c);e=document.createElement("DIV");e.setAttribute("id",this._titlerowid,0);e.className=this._titlerowcn;c.appendChild(e);c=b.uiUtil().getNumSize(b.uiUtil().getStyle(c,"width","width"));for(var l=c/this._colcnt,n=b.uiUtil().getNumSize(b.uiUtil().getStyle(e,"height","height")),r=0,d=0;d<this._colcnt;d++){var h=document.createElement("DIV");h.setAttribute("id",this._titleelementid+(d+1),0);e.appendChild(h);"certslist"==this.getListTypeID()?(h.className="grid-element"+(d+1),r=b.uiUtil().getNumSize(b.uiUtil().getStyle(h,"width","width")),h.className=this._titleelementcn+" grid-element"+(d+1)):h.className=this._titleelementcn;h.appendChild(document.createTextNode(a[d].title));var q=n-0,f=l-0,k=0;0<r&&(k=r-0);"detailslist"==this._listtype&&(f=0===d?f-f/2+10:f+f/2-10);var p=0;this._resizeFlag&&(p=document.createElement("DIV"),p.setAttribute("id",this._titledividerid+(d+1),0),p.className=this._titledividercn,p.style.height=q+"px",p.style.cursor="e-resize",e.appendChild(p),p=b.uiUtil().getNumSize(b.uiUtil().getStyle(p,"width","width")),f-=p,150<r&&(r=150),this._limittitleelementwidth[d]=r);h.style.width=0<k?k-p+"px":f+"px";h.style.height=q+"px"}this._resizeFlag&&(this._limittitlerowwidth=c);return!0},drawListBody:function(a,e){this._viewlist=a;this._viewlistcnt=e;var c=document.createElement("DIV");c.setAttribute("id",this._datalistid,0);c.className=this._datalistcn;document.getElementById(this._tblbodyid).appendChild(c);this._rowcnt=this._viewlistcnt;for(var l=b.uiUtil().getNumSize(b.uiUtil().getStyle(c,"width","width")),n=l/this._colcnt,r=0,d=0;d<this._rowcnt;d++){var h=document.createElement("DIV");h.setAttribute("id",this._datarowid+(d+1),0);h.className=this._datarowcn;h.setAttribute("aria-selected","false",0);c.appendChild(h);if("chrome"==b.browserName||"safari"==b.browserName){var q=b.uiUtil().getNumSize(b.uiUtil().getStyle(h,"width","width"));l<q&&(l=q,n=l/this._colcnt)}for(var q=b.uiUtil().getNumSize(b.uiUtil().getStyle(h,"height","height")),f=0;f<this._colcnt;f++){var k=document.createElement("DIV");k.setAttribute("id",this._dataelementid+(d+1)+"-"+(f+1),0);h.appendChild(k);"certslist"==this.getListTypeID()?(k.className="grid-element"+(f+1),r=b.uiUtil().getNumSize(b.uiUtil().getStyle(k,"width","width")),k.className=this._dataelementcn+" grid-element"+(f+1)):k.className=this._dataelementcn;if("certlist"!=this._listtype)var p=b.uiUtil().getNumSize(b.uiUtil().getStyle(k,"paddingLeft","padding-left")),A=b.uiUtil().getNumSize(b.uiUtil().getStyle(k,"paddingRight","padding-right")),v=b.uiUtil().getNumSize(b.uiUtil().getStyle(k,"paddingTop","padding-top")),g=b.uiUtil().getNumSize(b.uiUtil().getStyle(k,"paddingBottom","padding-bottom"));else g=v=A=p=0;var v=q-(v+g),g=n-(p+A),m=0;0<r&&(m=r-(p+A));"detailslist"==this._listtype&&(g=0===f?g-g/2+10:g+g/2-10);this._resizeFlag?(this._arrdataelementwidth[f]?this._limitdataelementwidth=g:this._arrdataelementwidth[f]=0<m?m:g,k.style.width=this._arrdataelementwidth[f]+"px"):k.style.width=0<m?m+"px":g+"px";k.style.height=v+"px"}this._resizeFlag&&(0<this._datarowwidth?h.style.width=this._datarowwidth+"px":this._limitdatarowwidth=l);0===d&&h.setAttribute("tabindex",this._tabidx,0)}this._resizeFlag&&0<this._datalistwidth&&(c.style.width=this._datalistwidth+"px");b.uiUtil().loadingBox(!1,"us-div-list-load");return!0},listClear:function(){var a=document.getElementById(this._tblbodyid),b=document.getElementById(this._datalistid);this._viewlist=this._selectedrow=null;this._viewlistcnt=-1;if(a&&b)a.removeChild(b);else return!1;return!0}};return function(a){function e(){var b=a.textboxid,c=d.getSelectedRow();if(!c||!b)return!1;b=document.getElementById(b);if(!b)return!1;b.value=c.childNodes[1].firstChild.nodeValue;return!0}function c(d,c){var k=document.createElement("IMG"),p="";if(0===c)k.setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/cert_valid_small.png",0),p=a.textObj.IDS_CERT_GRID_VALID;else if(1===c)k.setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/cert_valid_1_month_small.png",0),p=a.textObj.IDS_CERT_GRID_MONTH_EXPIER;else if(2===c)k.setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/cert_invalid_small.png",0),p=a.textObj.IDS_CERT_GRID_INVALID;else return;k.setAttribute("align","middle",0);k.setAttribute("alt",p,0);d.insertBefore(k,d.firstChild)}function l(a){var d=document.createElement("IMG");d.setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/cert_list_check.png",0);d.setAttribute("align","middle",0);d.setAttribute("alt","",0);a.appendChild(d)}function n(){for(var a=d.getViewList(),f=d.getSelectedRow(),k=d.getColCnt(),p=d.getViewListCnt(),n=d.getDataRowID(),v=d.getDataElementID(),g=0;g<p;g++){var m=document.getElementById(n+(g+1)),u;for(u=0;u<k;u++){var s=document.getElementById(v+(g+1)+"-"+(u+1));s.appendChild(document.createTextNode(a[g][u]));"detailslist"!=h&&(0===u&&c(s,a[g][6]),4===u&&"certslist"==h&&l(s))}"detailslist"==h?(m.onclick=function(){d.focusOnRow(this);e()},m.onkeydown=function(a){a=d.getRowForFocusing(a?a:event,this);d.focusOnRow(a);e()}):(m.onclick=function(){d.focusOnRow(this)},m.onkeydown=function(a){a=d.getRowForFocusing(a?a:event,this);d.focusOnRow(a)},"certslist"==h&&(m.ondblclick=function(){d.focusOnRow(this);var a=this,c=d.getSelectedIndex(),k=b.loadUI("certview")({type:null,args:{type:"Base64",idx:c,cert:b.certsList.list[c-1].cert},onConfirm:function(){k.dispose();a.focus()},onCancel:function(){k.dispose();a.focus()}});k.show();b.uiUtil().loadingBox(!1,"us-div-list-load")}));m.style.cursor="pointer";s=document.createElement("DIV");s.setAttribute("id",v+(g+1)+"-"+(u+1),0);s.style.display="none";s.appendChild(document.createTextNode(a[g][u]));m.appendChild(s);0!==g||f||("detailslist"==h?(d.focusOnRow(m),e()):d.focusOnRow(m))}}function r(){for(var a=d.getColCnt(),c=d.getDividerID(),k=!1,p=0,l=0,h=null,g=null,e=null,n=null,s=null,r=null,B=null,C=null,z=0,y=0,F=0,G=0,D=0,E=0,w=0,x=0;x<a;x++)document.getElementById(c+(x+1)).onmousedown=function(a){p=(a?a:event).clientX;k=!0;e=d.getTitleElementID();n=d.getDataElementID();s=d.getTitleRowID();r=d.getDataRowID();B=d.getTitleListID();C=d.getDataListID();c=d.getDividerID();w=parseInt(this.id.replace(c,""));h=e+w;g=n+"1-"+w;z=b.uiUtil().getNumSize(b.uiUtil().getStyle(document.getElementById(h),"width","width"));F=b.uiUtil().getNumSize(b.uiUtil().getStyle(document.getElementById(s),"width","width"));D=b.uiUtil().getNumSize(b.uiUtil().getStyle(document.getElementById(B),"width","width"));y=b.uiUtil().getNumSize(b.uiUtil().getStyle(document.getElementById(g),"width","width"));G=b.uiUtil().getNumSize(b.uiUtil().getStyle(document.getElementById(r+"1"),"width","width"));E=b.uiUtil().getNumSize(b.uiUtil().getStyle(document.getElementById(C),"width","width"))};document.onmousemove=function(a){if(k){l=(a?a:event).clientX;var c=0,f=0,e=0,g=0,q=0,m=0,q=l-p,m=0;a=h.split("element")[h.split("element").length-1];g=d.getLimitTitleRowWidth();f=d.getLimitTitleElementWidth(a);a=d.getLimitDataRowWidth();var t=d.getLimitDataElementWidth();z<f&&(f=z);for(var c=document.getElementById(n+"1-"+w),e=document.getElementById(s).childNodes,x=t=0;x<e.length;x++){var H=b.uiUtil().getNumSize(e[x].style.width);0<H&&(t+=H)}D=E=t;e=b.uiUtil().getNumSize(b.uiUtil().getStyle(c,"paddingLeft","padding-left"));c=b.uiUtil().getNumSize(b.uiUtil().getStyle(c,"paddingRight","padding-right"));t=f-e-c;5!=w&&(t+=1);c=z+q;f>c&&(m=f-c,c=f);f=F+q+m;g>f&&(f=g);e=D;g>e&&(e=g);g=y+q;t>g&&(m=t-g,g=t);q=G+q+m;a>q&&(q=a);m=E;a>m&&(m=a);document.getElementById(s).style.width=f+"px";document.getElementById(B).style.width=e+"px";document.getElementById(h).style.width=c+"px";a=d.getRowCnt();for(f=0;f<a;f++)document.getElementById(r+(f+1)).style.width=q+"px",document.getElementById(n+(f+1)+"-"+w).style.width=g+"px";document.getElementById(C).style.width=m+"px";d.setDataElementWidth(w-1,g);d.setDataRowWidth(q);d.setDataListWidth(m)}};document.onmouseup=function(a){k=!1}}var d=new y({listtype:a.type,tblid:a.tblid,tbltitleid:a.tbltitleid,titlelistid:a.titlelistid,titlerowid:a.titlerowid,titleelementid:a.titleelementid,titledividerid:a.titledividerid,titlelistcn:a.titlelistcn,titlerowcn:a.titlerowcn,titleelementcn:a.titleelementcn,titledividercn:a.titledividercn,tblbodyid:a.tblbodyid,datalistid:a.datalistid,datarowid:a.datarowid,dataelementid:a.dataelementid,datalistcn:a.datalistcn,datarowcn:a.datarowcn,dataelementcn:a.dataelementcn,dataselectcn:a.dataselectcn}),h=d.getListTypeID();return{drawList:function(a,b,c,e,h,l){if(!a||0>=b||0>h)return!1;0<=h&&d.setTabIdx(h);d.drawListTitle(a,b,l);if(0>=e)d.drawListBody(null,-1);else if(0<e&&c)d.drawListBody(c,e),n();else return!1;l&&r();return!0},drawTitle:function(a,b,c){if(!a||0>=b||0>c)return!1;0<=c&&d.setTabIdx(c);d.drawListTitle(a,b);return!0},redrawList:function(a,b){d.listClear();if(0>=b)d.drawListBody(null,-1);else if(0<b&&a)d.drawListBody(a,b),n();else return!1;return!0},clearList:function(){d.listClear();return!0},restoreOnMouseEvent:function(){d.getResizeFlag()&&(document.onmousemove=d.getLastOnMouseMoveEvent(),document.onmouseup=d.getLastOnMouseUpEvent());return!0},selectedIndex:function(){return d.getSelectedIndex()}}}};