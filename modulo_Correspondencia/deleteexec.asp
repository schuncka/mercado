<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_Correspondencia",Session("METRO_USER_ID_USER")), true %>
<%
  
  Dim objConn
  Dim strSQL, strID_AUTO
	
  strID_AUTO = Replace(Request("var_chavereg"),"'","''")

  AbreDBConn objConn, CFG_DB 
	
  If strID_AUTO <> "" Then
    strSQL = "DELETE FROM tbl_EVENTO_CORRESP WHERE ID_AUTO IN (" & strID_AUTO & ")"
    'Response.write strsql
	objConn.Execute strSQL
  End If
	
  FechaDBConn objConn
  Response.Redirect("default.asp")
  
%>