<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_Cargo",Session("METRO_USER_ID_USER")), true %>
<%
  
  Dim objConn
  Dim strSQL, strCOD_CARGOS
	
  strCOD_CARGOS = Replace(Request("var_chavereg"),"'","''")

  AbreDBConn objConn, CFG_DB_DADOS 
	
  If strCOD_CARGOS <> "" Then
    strSQL = "DELETE FROM tbl_CARGOS WHERE COD_CARGOS IN (" & strCOD_CARGOS & ")"
    'Response.write strsql
	objConn.Execute strSQL
  End If
	
  FechaDBConn objConn
  Response.Redirect("default.asp")
%>