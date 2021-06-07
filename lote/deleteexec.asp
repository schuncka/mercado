<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<%
  VerficaAcesso("ADMIN")
  
  Dim objConn
  Dim strSQL, strCOD_LOTE
	
  strCOD_LOTE = Replace(Request("codigo"),"'","''")
  AbreDBConn objConn, CFG_DB_DADOS 
	
  If strCOD_LOTE <> "" Then
    strSQL = "DELETE FROM tbl_Lote_Criterio WHERE COD_LOTE IN (" & strCOD_LOTE & ")"
	objConn.Execute strSQL

    strSQL = "DELETE FROM tbl_Lote WHERE COD_LOTE IN (" & strCOD_LOTE & ")"
	objConn.Execute strSQL
  End If
	
  FechaDBConn objConn
  Response.Redirect("data.asp")
%>