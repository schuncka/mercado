<%@ LANGUAGE=VBScript %>
<% Option Explicit %>
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"--> 
<!--#include file="_database/athUtils.asp"--> 
<%
Dim objConn, objRS, strSQL
Dim i , strINICIO, strFIM, strNOME_CREDENCIAL, strCOD_ATIV
   
strINICIO = Request("var_cod_inicio")
strFIM = Request("var_cod_fim")
strNOME_CREDENCIAL = UCase(Request("var_nome_credencial")&"")
strCOD_ATIV = Request("var_cod_ativ")

If strNOME_CREDENCIAL = "" Then
  strNOME_CREDENCIAL = "VISITANTE"
End If

If strCOD_ATIV = "" Then
  strCOD_ATIV = "000"
End If
   
If IsNumeric(strINICIO) And strINICIO <> "" And IsNumeric(strFIM) And strFIM <> "" Then

   AbreDBConn objConn, CFG_DB_DADOS 
   
   For i = strINICIO To strFIM
     strSQL = "INSERT INTO tbl_EMPRESAS (COD_EMPRESA, TIPO_PESS, SYS_USERCA, SYS_DATACA) " & _
              "              VALUES ('" & i & "','S','athenas', NOW() )"
     objConn.Execute(strSQL)  
   Next

   FechaDBConn ObjConn
   
End If
%>