<%
'1 Click DB ASP Library - Pop Up WYSIWYG HTML Editor 
'copyright 1997-2003 David Kawliche, AccessHelp.net

'1 Click DB ASP Library source code is protected by international
'laws and treaties.  Never use, distribute, or redistribute
'any software and/or source code in violation of its licensing.

'Use of this software and/or source code is strictly at your own risk.
'All warranties are specifically disclaimed except as required by law.

'For more information see : http://1ClickDB.com

'**Start Encode**

 Dim strtextboxname, strIndexForm

 strTextBoxName = Server.HTMLEncode(Request("var_TextBoxName"))
 strIndexForm   = Server.HTMLEncode(Request("var_IndexForm"))
%>
<HTML>
<HEAD>
<TITLE>Editor HTML</TITLE>
<link href="../_CSS/CSM.CSS" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JavaScript">
<!--
function writebacktext() { 
window.opener.document.forms[<%=strIndexForm%>].<%=strTextBoxName%>.value =  cleanup(document.forms.HTMLEdit.elements['editbox'].documentHTML);
self.close();
}
function BuscaTexto() { 
document.forms.HTMLEdit.elements['editbox'].documentHTML = window.opener.document.forms[<%=strIndexForm%>].<%=strTextBoxName%>.value;
self.focus();
}
// -->
</SCRIPT>
<SCRIPT language=JavaScript>
<!--
// DHTML Editing Component Constants for JavaScript
// Copyright 1998 Microsoft Corporation.  All rights reserved.
//

//
// Command IDs
//
DECMD_BOLD =                      5000
DECMD_COPY =                      5002
DECMD_CUT =                       5003
DECMD_DELETE =                    5004
DECMD_DELETECELLS =               5005
DECMD_DELETECOLS =                5006
DECMD_DELETEROWS =                5007
DECMD_FINDTEXT =                  5008
DECMD_FONT =                      5009
DECMD_GETBACKCOLOR =              5010
DECMD_GETBLOCKFMT =               5011
DECMD_GETBLOCKFMTNAMES =          5012
DECMD_GETFONTNAME =               5013
DECMD_GETFONTSIZE =               5014
DECMD_GETFORECOLOR =              5015
DECMD_HYPERLINK =                 5016
DECMD_IMAGE =                     5017
DECMD_INDENT =                    5018
DECMD_INSERTCELL =                5019
DECMD_INSERTCOL =                 5020
DECMD_INSERTROW =                 5021
DECMD_INSERTTABLE =               5022
DECMD_ITALIC =                    5023
DECMD_JUSTIFYCENTER =             5024
DECMD_JUSTIFYLEFT =               5025
DECMD_JUSTIFYRIGHT =              5026
DECMD_LOCK_ELEMENT =              5027
DECMD_MAKE_ABSOLUTE =             5028
DECMD_MERGECELLS =                5029
DECMD_ORDERLIST =                 5030
DECMD_OUTDENT =                   5031
DECMD_PASTE =                     5032
DECMD_REDO =                      5033
DECMD_REMOVEFORMAT =              5034
DECMD_SELECTALL =                 5035
DECMD_SEND_BACKWARD =             5036
DECMD_BRING_FORWARD =             5037
DECMD_SEND_BELOW_TEXT =           5038
DECMD_BRING_ABOVE_TEXT =          5039
DECMD_SEND_TO_BACK =              5040
DECMD_BRING_TO_FRONT =            5041
DECMD_SETBACKCOLOR =              5042
DECMD_SETBLOCKFMT =               5043
DECMD_SETFONTNAME =               5044
DECMD_SETFONTSIZE =               5045
DECMD_SETFORECOLOR =              5046
DECMD_SPLITCELL =                 5047
DECMD_UNDERLINE =                 5048
DECMD_UNDO =                      5049
DECMD_UNLINK =                    5050
DECMD_UNORDERLIST =               5051
DECMD_PROPERTIES =                5052

//
// Enums
//

// OLECMDEXECOPT  
OLECMDEXECOPT_DODEFAULT =         0 
OLECMDEXECOPT_PROMPTUSER =        1
OLECMDEXECOPT_DONTPROMPTUSER =    2

// DHTMLEDITCMDF
DECMDF_NOTSUPPORTED =             0 
DECMDF_DISABLED =                 1 
DECMDF_ENABLED =                  3
DECMDF_LATCHED =                  7
DECMDF_NINCHED =                  11

// DHTMLEDITAPPEARANCE
DEAPPEARANCE_FLAT =               0
DEAPPEARANCE_3D =                 1 

// OLE_TRISTATE
OLE_TRISTATE_UNCHECKED =          0
OLE_TRISTATE_CHECKED =            1
OLE_TRISTATE_GRAY =               2
//-->
</SCRIPT>
<SCRIPT language=JavaScript>
<!--
function cleanup(htmlstuff) {
  tmpvar = htmlstuff
  var startbody = tmpvar.indexOf("<BODY>");
  var endbody = tmpvar.lastIndexOf("</BODY>");
  if(startbody > 0 && startbody < endbody) {
    tmpvar = tmpvar.substring(startbody + 6, endbody);
    //why the edit control likes to put 35 spaces in here is a mystery
	for(intI = 0; intI < 35; intI++){
      if (tmpvar.substring(intI, intI+1) == ' ') {
	  } else {
	    break;
      }
    }
    tmpvar = tmpvar.substring(intI);
  }
  if (tmpvar == "<P>&nbsp;</P>") {
    //with no other content, the edit control inserts the above markup
    tmpvar = ""; 
  }
  return tmpvar
}
function hedBOLD(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_BOLD,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedITALIC(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_ITALIC,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedUNDERLINE(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_UNDERLINE,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedFONT(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_FONT,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedCUT(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_CUT,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedCOPY(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_COPY,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedPASTE(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_PASTE,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedUNDO(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_UNDO,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedREDO(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_REDO,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}	
function hedIMAGE(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_IMAGE,OLECMDEXECOPT_PROMPTUSER);
  htmleditbox.focus();
}
function hedHYPERLINK(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_HYPERLINK,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedVISIBLEBORDERS(htmleditbox) {
  htmleditbox.ShowDetails = !htmleditbox.ShowDetails;
  htmleditbox.ShowBorders = !htmleditbox.ShowBorders;
  htmleditbox.focus();
}
function hedINSERTROW(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_INSERTROW,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedINSERTTABLE(htmleditbox) {
  var tabletxt = "<TABLE BORDER=1><TR><TD></TD></TR></TABLE>"
  varselection = htmleditbox.DOM.selection;
  if (varselection.type == "Control") {
    var selrange = varselection.createRange();
    selrange.item(0).insertAdjacentHTML("afterEnd", tabletxt);
    varselection.clear();
  } else {
    var selrange = varselection.createRange();  	
	selrange.pasteHTML(tabletxt);
  }
  htmleditbox.focus();
}
function hedJUSTIFYLEFT(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_JUSTIFYLEFT,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedJUSTIFYCENTER(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_JUSTIFYCENTER,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedJUSTIFYRIGHT(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_JUSTIFYRIGHT	,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedUNORDERLIST(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_UNORDERLIST,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedORDERLIST(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_ORDERLIST,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedOUTDENT(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_OUTDENT,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedINDENT(htmleditbox) {
  htmleditbox.ExecCommand(DECMD_INDENT,OLECMDEXECOPT_DODEFAULT);
  htmleditbox.focus();
}
function hedDELETECELL(htmleditbox) {
  if (htmleditbox.QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
    htmleditbox.ExecCommand(DECMD_DELETECELLS,OLECMDEXECOPT_DODEFAULT);
  }
  htmleditbox.focus();
}
function hedDELETECOL(htmleditbox) {
  if (htmleditbox.QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
    htmleditbox.ExecCommand(DECMD_DELETECOLS,OLECMDEXECOPT_DODEFAULT);
  }
  htmleditbox.focus();
}
function hedDELETEROW(htmleditbox) {
  if (htmleditbox.QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
    htmleditbox.ExecCommand(DECMD_DELETEROWS,OLECMDEXECOPT_DODEFAULT);
  }
  htmleditbox.focus();
}
function hedINSERTCELL(htmleditbox) {
  if (htmleditbox.QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
    htmleditbox.ExecCommand(DECMD_INSERTCELL,OLECMDEXECOPT_DODEFAULT);
  }
  htmleditbox.focus();
}
function hedINSERTCOL(htmleditbox) {
  if (htmleditbox.QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
    htmleditbox.ExecCommand(DECMD_INSERTCOL,OLECMDEXECOPT_DODEFAULT);
  }
  htmleditbox.focus();
}
function hedINSERTROW(htmleditbox) {
  if (htmleditbox.QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
    htmleditbox.ExecCommand(DECMD_INSERTROW,OLECMDEXECOPT_DODEFAULT);
  }
  htmleditbox.focus();
}
function hedMERGECELL(htmleditbox) {
  if (htmleditbox.QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
    htmleditbox.ExecCommand(DECMD_MERGECELLS,OLECMDEXECOPT_DODEFAULT);
  }
  htmleditbox.focus();
}
function hedSPLITCELL(htmleditbox) {
  if (htmleditbox.QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
	htmleditbox.ExecCommand(DECMD_SPLITCELL,OLECMDEXECOPT_DODEFAULT);
  }
  htmleditbox.focus();
}
//-->
</SCRIPT>
<!-- <STYLE> -->
<!--A { font-size : 10pt; font-family : Tahoma, Arial, sans-serif; color : #330066; }-->
<!--A:hover { font-size : 10pt; font-family : Tahoma, Arial, sans-serif; color : #990000; }-->
<!--A.menu { font-size : 10pt; font-family : Tahoma, Arial, sans-serif; color : #330066; }-->
<!--A.menu:hover { font-size : 10pt; font-family : Tahoma, Arial, sans-serif; color : #330000; background : #FFD700; } -->
<!--A.menu:visited { font-size : 10pt; font-family : Tahoma, Arial, sans-serif;	color : #330066; }-->
<!--BODY { font-size : 10pt; font-family : Tahoma, Arial, sans-serif; scrollbar-base-color : #300066; scrollbar-face-color : #666690; scrollbar-shadow-color : Silver; scrollbar-highlight-color : Silver; scrollbar-3dlight-color : #ffffff; scrollbar-darkshadow-color : Silver; scrollbar-track-color : #CCCCCC; scrollbar-arrow-color : #ffffff; background : #FFFFFF; margin : 10px; }-->
<!--P {	font-size : 10pt; font-family : Tahoma, Arial, sans-serif; }-->
<!--INPUT { color : #300066;	background-color : silver; font-size : 8pt;	font-family : Tahoma, Arial, sans-serif; font-weight : bold; padding-bottom : 0; padding-left : 0; padding-right : 0; padding-top : 0; }-->
<!--</STYLE>-->
</HEAD>
<BODY onLoad="javascript:BuscaTexto();">
<FORM name=HTMLEdit>
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle">
  <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr> 
            <td width="4"><img src="IMG/inbox_left_top_corner.gif" width="4" height="4"></td>
            <td width="492" background="IMG/inbox_top_blue.gif"></td><td width="4"><img src="IMG/inbox_right_top_corner.gif" width="4" height="4"></td></tr>
  </table><table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
          <tr>
            <td width="4" height="1" background="IMG/inbox_left_blue.gif"></td>
      <td width="492"><table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Editor de HTML</td>
          </tr>
          <tr> 
                  <td height="16" align="center" bgcolor="eeeeee"></td>
          </tr>
          <tr> 
                  <td align="center"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td valign="middle" bgcolor="eeeeee"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td align="center" valign="middle"><a href="javascript:hedHYPERLINK(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/link.gif" alt="Inserir link" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr> 
                              <td><a href="javascript:hedINSERTTABLE(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/table.gif" alt="Inserir tabela" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr> 
                              <td><a href="javascript:hedVISIBLEBORDERS(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/border.gif" alt="Editar bordas" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr> 
                              <td><a href="javascript:hedINSERTROW(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/addrow.gif" alt="Adicionar linha" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr> 
                              <td><a href="javascript:hedINSERTCOL(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/addcol.gif" alt="Adicionar coluna" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr> 
                              <td><a href="javascript:hedINSERTCELL(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/addcel.gif" alt="Adicionar célula" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr> 
                              <td><a href="javascript:hedDELETEROW(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/delrow.gif" alt="Excluir linha" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr> 
                              <td><a href="javascript:hedDELETECOL(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/delcol.gif" alt="Excluir coluna" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr> 
                              <td><a href="javascript:hedDELETECELL(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/delcel.gif" alt="Excluir célula" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr> 
                              <td><a href="javascript:hedMERGECELL(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/mergerow.gif" alt="Mesclar célula" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                            <tr>
                              <td><a href="javascript:hedSPLITCELL(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/splitrow.gif" alt="Dividir célula" width="24" height="18" hspace="5" vspace="3" border="0"></a></td>
                            </tr>
                          </table>
                        </td>
                        <td width="1%" align="center" valign="top" bgcolor="eeeeee"> 
                          <table width="450" border="0" cellpadding="0" cellspacing="0" class="arial11">
                            <tr> 
                              <td width="450" colspan="2" align="center" bgcolor="#EEEEEE"> 
                                <a href="javascript:hedCUT(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/cut.gif" width="24" height="18" border="0" alt="Recortar"></a> 
                                <a href="javascript:hedCOPY(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/copy.gif" width="24" height="18" border="0" alt="Copiar"></a> 
                                <a href="javascript:hedPASTE(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/paste.gif" width="24" height="18" border="0" alt="Colar"></a> 
                                <a href="javascript:hedUNDO(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/undo.gif" width="24" height="18" border="0" alt="Desfazer"></a> 
                                <a href="javascript:hedREDO(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/redo.gif" width="24" height="18" border="0" alt="Refazer"></a><img src="IMG/div_MenuEdit.gif" width="2" height="18"> 
                                <a href="javascript:hedFONT(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/font.gif" width="30" height="24" border="0" alt="Editar fonte"></a> 
                                <a href="javascript:hedBOLD(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/bold.gif" width="24" height="18" border="0" alt="Negrito"></a> 
                                <a href="javascript:hedITALIC(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/italic.gif" width="24" height="18" border="0" alt="Itálico"></a> 
                                <a href="javascript:hedUNDERLINE(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/underline.gif" width="24" height="18" border="0" alt="Sublinhado"></a> 
                                <img src="IMG/div_MenuEdit.gif" width="2" height="18">
                                <a href="javascript:hedJUSTIFYLEFT(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/left.gif" width="24" height="18" border="0" alt="Alinhar à esquerda"></a> 
                                <a href="javascript:hedJUSTIFYCENTER(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/center.gif" width="24" height="18" border="0" alt="Centralizar"></a> 
                                <a href="javascript:hedJUSTIFYRIGHT(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/right.gif" width="24" height="18" border="0" alt="Alinhar à direita"></a> 
                                <a href="javascript:hedOUTDENT(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/outdent.gif" width="24" height="18" border="0" alt="Aumentar recuo"></a> 
                                <a href="javascript:hedINDENT(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/indent.gif" width="24" height="18" border="0" alt="Diminuir recuo"></a> 
                                <a href="javascript:hedORDERLIST(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/ol.gif" width="24" height="18" border="0" alt="Numeração"></a> 
                                <a href="javascript:hedUNORDERLIST(document.forms.HTMLEdit.DHTMLEdit1);"><img src="IMG/ul.gif" width="24" height="18" border="0" alt="Marcadores"></a><br>
								<OBJECT id=DHTMLEdit1 name=editbox classid=clsid:2D360201-FFF5-11D1-8D03-00A0C959BC0A width=450 height=250 VIEWASTEXT="YES" BORDER="0"></OBJECT><br><br></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table></td>
          </tr>
          <tr> 
            <td></td>
          </tr>
        </table></td>
            <td width="4" height="1" background="IMG/inbox_right_blue.gif"></td>
    </tr>
  </table>
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
          <td width="4"   height="4" background="IMG/inbox_left_bottom_corner.gif"></td>
            <td height="4" width="235" background="IMG/inbox_bottom_blue.gif"><img src="" alt="" border="0" width="1" height="32"></td>
          <td width="21"  height="26"><img src="IMG/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
            <td align="right" background="IMG/inbox_bottom_big3.gif"><A HREF="" onClick="javascript:writebacktext();"><img src="IMG/ok.gif" width="78" height="17" border="0"></a><A HREF="" onClick="javascript:self.close();"><img src="IMG/cancelar.gif" width="78" height="17" hspace="10" border="0"></a><img src="IMG/t.gif" width="3" height="3"><br></td>
          <td width="4" height="4"><img src="IMG/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
</tr></td></table>
</FORM>
</BODY>
</HTML>