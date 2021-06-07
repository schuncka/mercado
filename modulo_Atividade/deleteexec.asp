<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_Atividade",Session("METRO_USER_ID_USER")), true %>
<%
 
  
  Dim objConn
  Dim strSQL, strCODATIV
	
  strCODATIV = Replace(Request("var_chavereg"),"'","''")
  AbreDBConn objConn, CFG_DB 
	
  If strCODATIV <> "" Then
    strCODATIV = Replace(Request("var_chavereg"),",","','")
    strSQL = "DELETE FROM tbl_ATIVIDADE WHERE CODATIV IN ('" & strCODATIV & "')"
	objConn.Execute strSQL
  End If
	
  FechaDBConn objConn
  Response.Redirect("default.asp")
%>