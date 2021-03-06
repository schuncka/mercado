<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
 Dim objConn, objRS
 Dim NumPerPage

 NumPerPage = 18 'Valor padr�o

 AbreDBConn objConn, CFG_DB_DADOS 

 'Retrieve what page we're currently on
 Dim CurPage
 If Request("CurPage") = "" then
   CurPage = 1 'We're on the first page
 Else
   CurPage = Request("CurPage")
 End If

 '==========================================================
 ' Declara��o para vari�veis de consulta SQL
 '==========================================================
 Dim strCODATIV, strATIVIDADE, strATIVMINI, strACAO, strSQL, strSQLClause, iResult, strResult

 strCODATIV   = Replace(Request("var_codativ"),"'","''")
 strATIVIDADE = Replace(Request("var_atividade"),"'","''")
 strATIVMINI  = Replace(Request("var_ativmini"),"'","''")
 strACAO      = Replace(Request("var_acao"),"'","''")
 
strSQLClause = ""

If strCODATIV <> "" Then
  strSQLClause = strSQLClause & " AND CODATIV LIKE '" & strCODATIV & "%'"
End If

If strATIVIDADE <> "" Then
  strSQLClause = strSQLClause & " AND ATIVIDADE LIKE '" & strATIVIDADE & "%'"
End If

If strATIVMINI <> "" Then
  strSQLClause = strSQLClause & " AND ATIVMINI LIKE '" & strATIVMINI & "%'"
End If

strSQL = " SELECT CODATIV, ATIVIDADE, ATIVMINI, LOJA_SHOW, CODATIV_PAI" & _
         "   FROM tbl_ATIVIDADE" & _
         "  WHERE CODATIV = CODATIV " & strSQLClause & _
         "  ORDER BY CODATIV_PAI, CODATIV, ATIVIDADE"

'==========================================================
' Define o tamanho das p�ginas de visualiza��o
'==========================================================
set objRS = Server.CreateObject("ADODB.Recordset")

Set objRS = objConn.Execute(strSQL)

If not objRS.EOF Then
 iResult = 0

 If strACAO = ".xls" Or strACAO = ".doc" Then
	Response.AddHeader "Content-Type","application/x-msdownload"
	Response.AddHeader "Content-Disposition","attachment; filename=Relatorio_" & Session.SessionID & "_" & Replace(Time,":","") & strACAO
 End If
%>

<html>
<head>
<title>ProEvento</title>
<%
 If strACAO <> ".xls" And strACAO <> ".doc" Then
%>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<%
 End If
%>
</head>
<body topmargin="0" leftmargin="0" bgcolor="#FFFFFF" marginwidth="0" marginheight="0" >
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="#F2F2F2">
  	<td align="left" class="arial10"><strong>Ativ. Pai</strong></td> 
    <td align="left" class="arial10"><strong>C�digo</strong></td>
    <td align="left" class="arial10"><strong>Descricao</strong></td>
    <td align="left" class="arial10"><strong>Resumido</strong></td>
	
    <td align="left" class="arial10"><strong>Exibir Loja</strong></td>
  </tr>
<%
  Do While Not objRS.EOF
%>
	<tr>
	  <td><%=objRS("CODATIV_PAI")%></td>
	  <td><%=objRS("CODATIV")%></td>
	  <td><%=objRS("ATIVIDADE")%></td>
	  <td><%=objRS("ATIVMINI")%></td>
      <td><%=objRS("LOJA_SHOW")%></td>
	</tr>
<%
    iResult = iResult + 1
    objRS.MoveNext
  Loop
  
  strResult = Right("00000" & Cstr(iResult),5)
%>
  <tr> 
    <td colspan="4"><%=strResult & " ocorr�ncias."%> </td>
  </tr>
</table>
<%
 If strACAO = "printall" Then
%>
<script language="JavaScript">
 window.print();
</script>
<%
 End If
%>
</body>
</html>
<%
Else
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
</head>
  <% Mensagem "N�o existem dados para esta consulta.<br>Informe novos crit�rios para efetuar a pesquisa.", "" %>
  <!--  <div align="middle" class="arial10"> N�o existem dados para esta consulta. </div> -->
</body>
</html>
<%
End If
 FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>
