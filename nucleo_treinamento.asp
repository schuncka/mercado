<%@ LANGUAGE=VBScript %>
<% Option Explicit %>
<!--#include file="_database/ADOVBS.INC"-->
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"--> 
<!--#include file="_database/athUtils.asp"--> 
<!--#include file="_scripts/advancedmenu.js"-->
<% 
  Const GrupoMenu = "TODOS"
  Const CFG_BGMENU_TOP = "#FF0000" 
  Dim objConn, objRS, strSQL, auxCont, arrMenuVar, arrVlr, auxStrScodi, auxStrSdesc, teste

  AbreDBConn objConn, CFG_DB_DADOS 

  'Código equivalente a MontaArraysConteiners...
  strSQL = "SELECT COD_VAR, VALOR FROM SYS_MENU_VAR WHERE GRUPO = '"&GrupoMenu&"' ORDER BY ORDEM"
  Set objRS = objConn.execute(strSQL)
  auxStrScodi = ""
  auxStrSdesc = ""
  Do While NOT objRS.EOF
    auxStrScodi = auxStrScodi & "|" & objRS(0)
    auxStrSdesc = auxStrSdesc & "|" & objRS(1)
    objRS.MoveNext
  Loop
  FechaRecordSet(objRS)
  arrMenuVar = Split (auxStrScodi, "|")
  arrVlr = Split (auxStrSdesc, "|")


  function RecursiveSubMenus(prCodMenuPai, prStrNivel)
   Dim LocalstrSQL, LocalObjRS, LocalAuxCont
   LocalstrSQL ="SELECT COD_MENU, ROTULO, LINK FROM SYS_MENU WHERE GRUPO = '"&GrupoMenu&"' and COD_MENU_PAI = " & prCodMenuPai & " and DT_INATIVO is NULL ORDER by ORDEM"
   AbreRecordSet LocalObjRS, LocalstrSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1 
   'Set LocalObjRS = objConn.Execute(strSQL)

   LocalAuxCont = 1
   While not LocalObjRS.EOF
     RecursiveSubMenus GetValue(LocalObjRS,"COD_MENU"), prStrNivel & "," & LocalAuxCont
     Response.write ( "addmenuitem('" & prStrNivel & "," & LocalAuxCont )
     Response.write ( "','" & GetValue(LocalObjRS,"ROTULO") & "','" & GetValue(LocalObjRS,"LINK") )
     Response.write ( "','"&arrVlr(ArrayIndexOf(arrMenuVar,"OVER_TEXT"))&"','"&arrVlr(ArrayIndexOf(arrMenuVar,"OVER_BG")) )
     Response.write ( "','"&arrVlr(ArrayIndexOf(arrMenuVar,"OUT_TEXT"))&"','"&arrVlr(ArrayIndexOf(arrMenuVar,"OUT_BG")) )
     Response.write ( "','"&arrVlr(ArrayIndexOf(arrMenuVar,"DOWN_TEXT"))&"','"&arrVlr(ArrayIndexOf(arrMenuVar,"DOWN_BG")) )
	 Response.write ( "','"&arrVlr(ArrayIndexOf(arrMenuVar,"FONT_STYLE"))&"');" )
     LocalObjRS.MoveNext
     LocalAuxCont = LocalAuxCont + 1
   Wend
   FechaRecordSet(LocalObjRS)
  end function
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="_css/csm.css"> 
<script language='Javascript'>
<!--
function adjustWindow() {
  document.getElementById('fr_principal').height = document.body.clientHeight-99;
}
//-->
</script>
</head>
<body leftmargin="0" topmargin="0"
  onResize="adjustWindow();"
  onLoad="adjustWindow();">
<%
  'if (VerifyLogin) then 
    response.write "<table width='100%' height='"&arrVlr(ArrayIndexOf(arrMenuVar,"HEIGHT"))+1&"' cellspacing='0' cellpadding='0' border='0' bgcolor='"&CFG_BGMENU_TOP&"'>"
    response.write " <tr><td id='holdmenu' style='position:relative' valign='middle'></td></tr>"
    response.write "</table>"
    response.write "<script>" ' Parâmetros: initmenu([max itens],[Height],[Width],[Delay],[Layout])
    response.write "initmenu("&arrVlr(ArrayIndexOf(arrMenuVar,"MAX_TOPITENS"))&","&arrVlr(ArrayIndexOf(arrMenuVar,"HEIGHT"))&","&arrVlr(ArrayIndexOf(arrMenuVar,"WIDTH"))&","&arrVlr(ArrayIndexOf(arrMenuVar,"DELAY"))&",'"&arrVlr(ArrayIndexOf(arrMenuVar,"TYPE"))&"');" 
    strSQL ="SELECT COD_MENU, ROTULO, LINK FROM SYS_MENU WHERE GRUPO = '"&GrupoMenu&"' and COD_MENU_PAI <= 0 and DT_INATIVO is NULL ORDER by ORDEM"
	AbreRecordSet ObjRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1 
    auxCont=1
    While not ObjRS.EOF
      Response.write ( "addmenuitem('"&auxCont&"','" & GetValue(ObjRS,"ROTULO") & "','" & GetValue(ObjRS,"LINK") )
      Response.write ( "','"&arrVlr(ArrayIndexOf(arrMenuVar,"OVER_TEXT"))&"','"&arrVlr(ArrayIndexOf(arrMenuVar,"OVER_BG")) )
	  Response.write ( "','"&arrVlr(ArrayIndexOf(arrMenuVar,"OUT_TEXT"))&"','"&arrVlr(ArrayIndexOf(arrMenuVar,"OUT_BG")) )
	  Response.write ( "','"&arrVlr(ArrayIndexOf(arrMenuVar,"DOWN_TEXT"))&"','"&arrVlr(ArrayIndexOf(arrMenuVar,"DOWN_BG")) ) 
	  Response.write ( "','"&arrVlr(ArrayIndexOf(arrMenuVar,"FONT_STYLE"))&"');" )
      RecursiveSubMenus GetValue(ObjRS,"COD_MENU"),auxCont
      ObjRS.MoveNext
      auxCont = auxCont + 1
    Wend
    response.write "createmenu();"
    response.write "add10xitems();"
    response.write "MENU_POS['block_top'][0]=document.getElementById('holdmenu').offsetTop;"
    response.write "new menu (MENU_ITEMS, MENU_POS, MENU_STYLES);"
    response.write "</script>"
    FechaRecordSet(ObjRS)
  'end if 
%>
<table width="100%" height="67" border="0" cellpadding="0" cellspacing="0" background="img/BGHeader.gif">
  <tr><td valign="top">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
	    <td width="1%"><img src="img/SistemLogo_treinamento.gif" width="173" height="54" hspace="5" vspace="5"></td>
		<td width="20%" valign="bottom"><div style="padding-bottom:5px"><small><font color="#F2F2F2">2007</font></small><!--span id="titulo_modulo"><em>&bull; Painel</em></span--></div></td>
		<td width="79%" valign="top" align="right" class="texto_corpo_peq">
		  <table border="0" cellpadding="2" cellspacing="0">
		    <tr>
			 <td align="right"><small>
		      <%
			   Response.write (Session("GRP_USER") & " (" & Session("ID_USER") & ")")
			   Response.write ("<br>" & Session("NOME_USER") )
			   teste=Ucase(InStr(CFG_DB_DADOS,"."))
			   If teste<>0 or teste<>NULL Then
               	 Response.write ("<br> " & Ucase(Mid(CFG_DB_DADOS,1,InStr(CFG_DB_DADOS,".")-1)) & " - " & Request.Cookies("sysMetro")("CODEVENTO") )
		       Else
			   	Response.Write("<br>"&Ucase(CFG_DB_DADOS) & " - " & Request.Cookies("sysMetro")("CODEVENTO") )
			   End If
			  %></small>
			 </td>
			 <td><a href="logout.asp"><img src="img/logout_quick.gif" border="0" alt="logout"></a> 
			 </td>
			</tr>
		  </table>
		</td>
	  </tr>
	</table></td></tr>
  <tr><td height="1"></td></tr>
</table> 
<iframe scrolling="auto" id="fr_principal" name="fr_principal" src="principal.asp" width="100%" height="400" frameborder="0"></iframe>
<table width="100%" height="10" border="0" cellpadding="0" cellspacing="0" bgcolor="#848484">
  <tr><td valign="bottom"><img src="img/Copyright.gif" align="right"></td></tr>
</table> 
</body></html>
<%
  FechaDBConn objConn
%>
