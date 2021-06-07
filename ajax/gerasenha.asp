<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="../_database/athUtils.asp"-->
<%
Response.AddHeader "Expires", "Mon, 26 Jul 1997 05:00:00 GMT"
Response.AddHeader "Last-Modified", Now & " GMT"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
Response.AddHeader "Pragma", "no-cache"

Dim strTAM, strTIPO


strTAM  = Request("var_tam")
strTIPO = Request("var_tipo")

If strTAM = "" Then
  strTAM = 6
End If

If strTIPO = "" Then
  strTIPO = 1
End If


Response.Write( GerarSenhaAleatoria(strTAM,strTIPO) )
%>