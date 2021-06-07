<%@ LANGUAGE = VBScript.Encode %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"-->
<!--#include file="../_database/secure.asp"-->
<%
  VerficaAcesso("ADMIN")
  VerficaAcessoOculto(Session("ID_USER"))
  
  Response.Expires = 0
  

  	Dim auxmappath
  
	On Error Resume Next
  	Response.Buffer = true
  	Response.Clear
  
  	auxmappath = Trim("driver=Provider=MSDASQL;driver={MySQL ODBC 5.1 Driver};server="&CFG_PATH&";uid="&CFG_DB_DADOS_USER &";pwd="&CFG_DB_DADOS_PWD&";database="&CFG_DB_DADOS)
'	Response.Write(auxmappath)
'	REsponse.End()
  	Call Response.Redirect ("FreeConnect.asp?Action=CONNECT&UseTreemenu=True&CONNECT=" & auxmappath )
  	'Call Response.Redirect ("FreeConnect.asp?Action=Connect&CONNECT=" & auxmappath)

  	'Call Response.Redirect ("FreeConnect.asp")

  	Response.End
%>
