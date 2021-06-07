<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<% 
  Dim auxSTR

  auxSTR = GetParam("var_html")
  
  if (inStr(lcase(auxSTR),"<html>")<=0) then
	Response.write ("<html><head><title>ProEvento " & Session("NOME_EVENTO") & "</title>")
	Response.write ("<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'></head>")
	Response.write ("<body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'><center>")
	Response.write ("<table width='100%' height='100%' border='0' cellpadding='0' cellspacing='0'><tr><td align='center' valign='middle'>")
	Response.write (auxSTR)
	Response.write ("</td></tr></table></center></body></html>")
  else
	Response.write (auxSTR)
  end if
%>