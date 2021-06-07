<%@ LANGUAGE=VBScript %>
<% Option Explicit %>
<!--#include file="_database/adovbs.inc"-->
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<%
Dim objConn, objRS, strSQL
  
  On Error Resume Next
    
  AbreDBConn objConn, CFG_DB_DADOS 
	
 ' ------------------------------------------------------------------------
 ' Monta consulta para buscar registros de ocupações não processados
 ' ------------------------------------------------------------------------
'  strSQLCons = "SELECT COD_PROD, DT_INSERT, QTDE FROM TBL_SHOPLIST WHERE SYS_UPDATE = 0"
  strSQL =          " SELECT COD_PROD, SUM(QTDE) AS TOT_QTDE"
  strSQL = strSQL & " FROM TBL_SHOPLIST"
  strSQL = strSQL & " WHERE SYS_UPDATE = 0"
  strSQL = strSQL & " GROUP BY COD_PROD"
  strSQL = strSQL & " ORDER BY COD_PROD"

  
  Set objRS = Server.CreateObject("ADODB.Recordset")
  objRS.Open strSQL, objConn
  
  do while not objRS.Eof
    strSQL = "UPDATE TBL_PRODUTOS SET OCUPACAO = OCUPACAO + " & objRS("TOT_QTDE") & " WHERE COD_PROD = " & objRS("COD_PROD") & " AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")
    objConn.execute strSQL, adLockPessimistic, adExecuteNoRecords
'	Response.Write(strSQL & "<BR>")
	strSQL = "UPDATE TBL_SHOPLIST SET SYS_UPDATE = 1  WHERE COD_PROD = " & objRS("COD_PROD") & " AND SYS_UPDATE = 0"
    objConn.execute strSQL, adLockPessimistic, adExecuteNoRecords
'	Response.Write(strSQL & "<BR>")
    objRS.MoveNext
  Loop
  
  If err.Number <> 0 Then
    Response.Write("Erro:" & err.Description & "<br>")
  End If
  FechaRecordSet ObjRS
  FechaDBConn ObjConn
%>
