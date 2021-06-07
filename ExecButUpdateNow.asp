<%@ LANGUAGE=VBScript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="_database/ADOVBS.INC"-->
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<!--#include file="_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim strACAO, Total
 
strACAO = Request("var_acao")
Total = 0
  
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
  objRS.Open strSQL, objConn, adLockPessimistic
  
  do while not objRS.Eof
    strSQL = "UPDATE TBL_PRODUTOS SET OCUPACAO = OCUPACAO + " & objRS("TOT_QTDE") & " WHERE COD_PROD = " & objRS("COD_PROD") & "   AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO") & _
    objConn.execute strSQL, adLockPessimistic
'	Response.Write(strSQL & "<BR>")
	strSQL = "UPDATE TBL_SHOPLIST SET SYS_UPDATE = 1  WHERE COD_PROD = " & objRS("COD_PROD") & " AND SYS_UPDATE = 0"
    objConn.execute strSQL, adLockPessimistic
'	Response.Write(strSQL & "<BR>")
    Total = Total + 1
    objRS.MoveNext
  Loop
  FechaRecordSet ObjRS
  FechaDBConn ObjConn
%>

<html>
<head>
<link href="_CSS/CSM.CSS" rel="stylesheet" type="text/css">
<script language="JavaScript">
function tricky_win_close() {
    window.opener = top;
    window.close();
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF" onLoad="tricky_win_close()">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td align="center" valign="middle"><BR> <table width="270" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="270"><img src="img/header_info.gif" width="270" height="19"></td>
        </tr>
        <tr> 
          <td align="center" valign="middle">
		    <table width="90%" border="0" cellspacing="0" cellpadding="2">
                <tr> 
                  <td class="">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="">Total de Produtos atualizados: <%=Total%> </td>
                </tr>
                <tr> 
                  <td align="center" class="">&nbsp;</td>
                </tr>
                <tr>
                  <td align="center" class="">&nbsp;</td>
                </tr>
            </table></td>
        </tr>
        <tr> 
          <td width="270" valign="top"><img src="img/footer_info.gif" width="270" height="15"></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
