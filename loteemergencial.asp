<%@ LANGUAGE=VBScript %>
<% Option Explicit %>
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"--> 
<!--#include file="_database/athUtils.asp"--> 
<%
Dim objConn, objRS, strSQL
Dim i, cont, strINICIO, strFIM, strNOME_CREDENCIAL, strCOD_ATIV
Dim strAviso   
cont = 0

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
   objConn.BeginTrans
   
   On Error Resume Next
   For i = strINICIO To strFIM
     strSQL = "INSERT INTO tbl_EMPRESAS (COD_EMPRESA, TIPO_PESS, SYS_USERCA, SYS_DATACA, NOMECLI, NOMEFAN, CODATIV1) " & _
              "              VALUES ('" & i & "','N','athenas',NOW(),'" & strNOME_CREDENCIAL & "','" & strNOME_CREDENCIAL & "','" & strCOD_ATIV & "')"
     objConn.Execute(strSQL)  
     'Response.Write(strSQL & "<br>")
	 cont = cont + 1
   Next
   If err.Number <> 0 Then
     objConn.RollBackTrans
	 strAviso = "Ocorreu um erro na gravação dos registros e a operação foi cancelada.<br><br>"
	 strAviso = strAviso & "Descrição do erro: " & err.Description
   Else
     objConn.CommitTrans
	 strAviso = "A gravação dos registros foi efetuada com sucesso.<br><br>"
	 strAviso = strAviso & "Total de registros inseridos: " & cont
   End If
   FechaDBConn ObjConn
%>
<font size="2" face="Verdana, Arial, Helvetica, sans-serif"><br>
<%=strAviso%></font><br>
<br>
<%
Else
%>
<table width="500" border="0" cellspacing="0" cellpadding="3">
  <form action="loteemergencial.asp" method="post">
    <tr> 
      <td colspan="2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Informe 
        os dados para a gera&ccedil;&atilde;o do intervalo de credenciais:</font></td>
    </tr>
    <tr> 
      <td width="126" align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">C&oacute;digo 
        Inicial:</font></td>
      <td width="362"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> 
        <input name="var_cod_inicio" type="text" id="var_cod_inicio" size="10" maxlength="6">
        </font></td>
    </tr>
    <tr> 
      <td align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">C&oacute;digo 
        Final:</font></td>
      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> 
        <input name="var_cod_fim" type="text" id="var_cod_fim" size="10" maxlength="6">
        </font></td>
    </tr>
    <tr> 
      <td align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Nome 
        Credencial:</font></td>
      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> 
        <input name="var_nome_credencial" type="text" id="var_nome_credencial" value="VISITANTE" size="50" maxlength="50">
        </font></td>
    </tr>
    <tr> 
      <td align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">C&oacute;digo 
        Atividade:</font></td>
      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> 
        <input name="var_cod_ativ" type="text" id="var_cod_fim3" value="000" size="10" maxlength="6">
        </font></td>
    </tr>
    <tr> 
      <td align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Pessoa 
        F&iacute;sica:</font></td>
      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> 
        <input name="var_tipo_pess" type="radio" value="S" checked>
        Sim&nbsp;&nbsp;&nbsp; 
        <input type="radio" name="var_tipo_pess" value="N">
        Não</font></td>
    </tr>
    <tr>
      <td align="right">&nbsp;</td>
      <td><input type="submit" name="Submit" value="executar"></td>
    </tr>
  </form>
</table>
<%
End If
%>