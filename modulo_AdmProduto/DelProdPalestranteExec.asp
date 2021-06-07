<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<%
  VerficaAcesso("ADMIN")
  
  Dim objConn
  Dim strSQL, strCOD_PROD, strCOD_PALESTRANTE, strIDAUTO
	
  strCOD_PROD = Replace(Request("var_cod_prod"),"'","''")
  strCOD_PALESTRANTE = Replace(Request("var_cod_palestrante"),"'","''")
  strIDAUTO = Replace(Request("var_idauto"),"'","''")
  
  AbreDBConn objConn, CFG_DB_DADOS 
	
'  If strCOD_PROD <> "" And strCOD_PALESTRANTE <> "" Then
'    strSQL = "DELETE FROM tbl_Produtos_Palestrante WHERE COD_PROD = " & strCOD_PROD & " AND COD_PALESTRANTE IN (" & strCOD_PALESTRANTE & ")"
'	objConn.Execute strSQL
'  End If
  If strIDAUTO <> "" Then
    strSQL = "DELETE FROM tbl_Produtos_Palestrante WHERE IDAUTO = " & strIDAUTO
	objConn.Execute strSQL
  End If

	
  FechaDBConn objConn
  Response.Redirect("update.asp?var_chavereg=" & strCOD_PROD)
%>