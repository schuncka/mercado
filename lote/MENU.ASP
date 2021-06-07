<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_scripts/scripts.js"-->
<!--#include file="../_database/athdbConn.asp"--> 
<%
 VerficaAcesso("ADMIN")
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" background="../img/BGLeftMenu.jpg" text="#000000" link="#000000" vlink="#000000" alink="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="data.asp" target="mainAthCSM">
<table width="200" border="0" cellspacing="0" cellpadding="5">
  <tr> 
	<td height="38" valign="middle" colspan="2">
      <div align="center"><span class="arial14Bold">LOTES</span><br>
      <img src="../img/separator.gif" width="195" height="2" border="0" vspace="4" hspace="0"></div>
	</td>
  </tr>
  <tr> 
    <td height="38" valign="middle" colspan="2"> <a href="javascript:AbreJanelaPAGE('insert.asp', '530', '400');" class="arial14Bold"><img src="../img/bt_add.gif" name="btAdd" width="21" height="19" hspace="3" vspace="0" border="0" align="absmiddle">Adicionar</a> 
      <div align="center"> <img src="../img/separator.gif" width="195" height="2" border="0" vspace="5" hspace="0"> 
      </div>
    </td>
  </tr>
  <tr> 
    <td valign="top" width="10"><font color="#FFFFFF">&nbsp;</font></td>
    <td valign="top" width="190"> <span class="arial14">Filtrar consulta por</span><br>
      <br>
      <span class="arial12"> C&oacute;digo</span><br>
        <input name="var_codigo" type="text" class="textfield" id="var_codigo" size="10" maxlength="15">
        <br>
        <br>
      <span class="arial12">Nome</span><br><input type="text" name="var_nome" size="15" maxlength="30" class="textfield">
      <br>
        <br>
    </td>
  </tr>
  <tr align="center" valign="middle"> 
    <td colspan="2" height="50"> <font color="#FFFFFF" class="arial10Bold"><img src="../img/separator.gif" width="195" height="2" border="0" vspace="5" hspace="0"></font> 
      <a href="javascript:form1.submit();"><img src="../img/bt_search.gif" width="129" height="22" border="0"></a></td>
  </tr>
</table>
</form>
</body>
</html>
