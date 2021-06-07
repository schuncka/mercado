<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athutils.asp"-->
<%
Dim objConn
Dim strSQL, strCOD_PAPER_CADASTRO
Dim strMENSAGEM

strMENSAGEM = ""

strCOD_PAPER_CADASTRO = Replace(Request("var_cod_paper_cadastro"),"'","''")
AbreDBConn objConn, CFG_DB_DADOS 

If strCOD_PAPER_CADASTRO <> "" Then

  On Error Resume Next

  strSQL = "UPDATE tbl_PAPER_CADASTRO SET SYS_DATAFINISH = NULL, SYS_INATIVO = NOW(), SYS_DATAAT = NOW(), SYS_USERAT = '"&Session("PAX_COD_EMPRESA")&"' WHERE (COD_PAPER_STATUS IS NULL OR COD_PAPER_STATUS = 0) AND COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO 
  'Response.Write(strSQL)
  'Response.End()  
  objConn.Execute strSQL
  
  If err.Number <> 0 Then
	strMENSAGEM = "- O trabalho com código [" & strCOD_PAPER_CADASTRO & "] não pode ser removido.<br>"
	strMENSAGEM = strMENSAGEM & err.Description
  End If

  strSQL = "INSERT INTO TBL_EMPRESAS_HIST (COD_EMPRESA, HISTORICO, SYS_DATACA, SYS_USERCA) VALUES ('"&Session("PAX_COD_EMPRESA")&"','AREA PAX - EXCLUSÃO TRABALHO: "&strCOD_PAPER_CADASTRO&"',NOW(),'"&Session("PAX_COD_EMPRESA")&"')"
  objConn.Execute(strSQL)

End If

FechaDBConn objConn

Response.Redirect("main.asp?guia=" & Request.Form("guia")&"&lng="&request("lng"))  
%>