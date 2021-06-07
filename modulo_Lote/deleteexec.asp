<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_Lote",Session("METRO_USER_ID_USER")), true %>
<%
  
  Dim objConn
  Dim strSQL, strCOD_LOTE
	
  strCOD_LOTE = Replace(Request("codigo"),"'","''")
  AbreDBConn objConn, CFG_DB 
	
  If strCOD_LOTE <> "" Then
    strSQL = "DELETE FROM tbl_Lote_Criterio WHERE COD_LOTE IN (" & strCOD_LOTE & ")"
	objConn.Execute strSQL

    strSQL = "DELETE FROM tbl_Lote WHERE COD_LOTE IN (" & strCOD_LOTE & ")"
	objConn.Execute strSQL
  End If
	
  FechaDBConn objConn
  Response.Redirect("default.asp")
%>