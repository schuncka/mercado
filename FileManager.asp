<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<!--#include file="_database/secure.asp"-->
<%
Server.ScriptTimeout = 2400

Response.Buffer = True

  VerficaAcesso("ADMIN")
  VerficaAcessoOculto(Session("ID_USER"))
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<table width="100%" border="0" cellspacing="10" cellpadding="0">
  <tr>
    <td align="left" valign="top"><!--#include file="FileManager_engine.asp"--></td>
  </tr>
</table>
</body>
</html>
<%
Response.Flush()
%>