<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_AreaGeo",Session("METRO_USER_ID_USER")), true %>
<%

	
	Dim objConn
	Dim strSQL, strCODIGOS, strCOD_INSCRICAO
	
	strCODIGOS = Request("var_chavereg")
	
	'Response.Write(strCODIGOS)
	'Response.End()
	AbreDBConn objConn, CFG_DB 
	
	'DEBUG: Response.write strCodigos
	
	If strCODIGOS <> "" Then
		
	strSQL = "DELETE FROM tbl_areageo_cep WHERE ID_Areageo IN(" & strCODIGOS & ")"
	'Response.Write(strSQL)
	'Response.End()
	objConn.Execute(strSQL) 
	
	strSQL = "DELETE FROM tbl_areageo WHERE ID_Areageo IN(" & strCODIGOS & ")"
	objConn.Execute(strSQL)  
		
		
	End If
	
	FechaDBConn objConn
	Response.Redirect("default.asp")
%>