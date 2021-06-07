<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/secure.asp"-->
<% Response.Expires = 0 %>
<%
  VerficaAcesso("ADMIN")
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset cols="205,*" frameborder="NO" border="0" framespacing="0" rows="*"> 
  <frame name="leftAthCSM" src="menu.asp" scrolling="NO" noresize>
  <frame name="mainAthCSM" src="data.asp">
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000">
</body>
</noframes> 
</body>
</html>
