<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"-->
<%
 dim strLng

 Select Case lcase(Request.Cookies("METRO_pax")("locale"))
	Case "pt-br"	strLng = "BR"
	Case "en-us"	strLng = "US"
	Case "es"		strLng = "SP"
	Case Else strLng = "BR"
 End Select
%>
<html>
<head>
<title></title>
</head>
<body onLoad="document.formulario.submit()">
<form name="formulario" action="default.asp" method="post">
<input type="hidden" name="lng"		 id="lng"	  value="<%=strLng%>">
<input type="hidden" name="browser"  id="browser" value="<%=Request.Cookies("METRO_pax")("tp_browser")%>">
</form>
</body>
</html>