<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<%
  VerficaAcesso("ADMIN")
  
  Dim objConn
  Dim strSQL, objRS, strCOD_PROD, strCOD_PALESTRANTE, strFUNCAO, strIDAUTO
	
  strCOD_PROD = Replace(Request("var_cod_prod"),"'","''")
  strCOD_PALESTRANTE = Replace(Request("var_cod_palestrante"),"'","''")
  strIDAUTO = Replace(Request("var_idauto"),"'","''")
  strFUNCAO = Replace(Request("var_funcao"),"'","''")

  'Response.Write("[" & strCOD_PROD & "]<br>")
  'Response.Write("[" & strCOD_PALESTRANTE & "]<br>")
  'Response.Write("[" & strFUNCAO & "]<br>")
  'Response.End()

  AbreDBConn objConn, CFG_DB_DADOS


  If strIDAUTO <> "" Then
		'---------------
		'Já foi inserido
		'---------------
		strSQL = " UPDATE tbl_Produtos_Palestrante " &_
				 " SET FUNCAO = '" & strFUNCAO & "' " &_
				 " WHERE IDAUTO = " & strIDAUTO
		objConn.Execute(strSQL)
  Else
		'----------------
		'Não foi inserido
		'----------------
		strSQL = " INSERT INTO tbl_Produtos_Palestrante (COD_PROD, COD_PALESTRANTE, FUNCAO) " &_
				 " VALUES (" & strCOD_PROD & ", " & strCOD_PALESTRANTE & ", '" & strFUNCAO & "') " 
		objConn.Execute(strSQL)
  End If
	
  FechaDBConn objConn
  Response.Redirect("update.asp?var_chavereg=" & strCOD_PROD)
%>