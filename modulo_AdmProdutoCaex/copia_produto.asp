<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"-->
<!--#include file="../_database/athutils.asp"--> 
<%

Function proximoRegistro()
	Dim strSQL_Local, objRS_Local
	
	strSQL_Local = " SELECT MAX(COD_PROD) AS COD_PROD FROM tbl_PRODUTOS ORDER BY COD_PROD DESC"
	Set objRS_Local = objConn.execute(strSQL_Local)
	
	If objRS_Local("COD_PROD")&"" = "" or IsNull(objRS_Local("COD_PROD")) Then 
	  proximoRegistro = 1
	Else
	  proximoRegistro = Clng(objRS_Local("COD_PROD")) + 1
	End If
	
	FechaRecordSet(objRS_Local)
End Function

' ========================================================================
' Principal ==============================================================
' ========================================================================

Dim objConn, objRs, strSQL, strCOD_PROD, strTITULO, strLOCAL, strDT_OCORRENCIA

strTITULO = Request("titulo")

strLOCAL = Request("local")
If strLOCAL = "" Then
  strLOCAL = "LOCAL"
Else
  strLOCAL = strTOSQL(strLOCAL)
End If

strDT_OCORRENCIA = Request("dt_ocorrencia")
If not IsDate(strDT_OCORRENCIA) Then
  strDT_OCORRENCIA = "DT_OCORRENCIA"
Else
  strDT_OCORRENCIA = "'"& PrepDataIve(strDT_OCORRENCIA,False,True) & "'"
End If

	AbreDBConn objConn, CFG_DB_DADOS
	
    If strTITULO = "" and Request("acao") <> "copiaR" Then
%>
<form name="formgeral" action="copia_produto.asp" method="post">
Copiar produto: <input type="text" name="titulo" value="" /><br />
<br />
Data ocorrência: <input type="text" name="dt_ocorrencia" value="" /><br />
Local: <select name="local">
<option value="">Selecione...</option>
<%
strSQL = "SELECT LOCAL FROM TBL_PRODUTOS_LOCAL ORDER BY ORDEM, LOCAL"
MontaCombo strSQL,"LOCAL","LOCAL",""
%>
</select>
<br />
<input type="hidden" name="acao" value="copiar" /><br />
<input type="submit" name="butok" value="copiar" /><br />
</form>
<%
	
	Else
	
	strSQL = "insert into tbl_produtos (COD_PROD, COD_EVENTO, GRUPO, TITULO, DESCRICAO, OBS, CAPACIDADE, OCUPACAO, COD_PALESTRANTE, DT_OCORRENCIA, DT_TERMINO, SYS_DT_INATIVO, NUM_COMPETIDOR_START, PALESTRANTE, CARGA_HORARIA, LOCAL, LOJA_SHOW, LOJA_EDIT_QTDE, CERTIFICADO_TEXTO, DIPLOMA_TEXTO, COD_PROD_VALIDA, EXTRA_INFO_SHOW, EXTRA_INFO_MSG, EXTRA_INFO_REQUERIDO, VOUCHER_TEXTO, CERTIFICADO_PDF, CONCURSO, Firstname, ref_numerica, TITULO_INTL, DESCRICAO_INTL, GRUPO_INTL, IMG, TITULO_MINI, BGCOLOR, SINOPSE, VOUCHER_TEXTO_US, VOUCHER_TEXTO_ES, GRUPO_SUB)"
	strSQL = strSQL & " SELECT " & proximoRegistro() & ", COD_EVENTO, GRUPO, TITULO, DESCRICAO, OBS, CAPACIDADE, OCUPACAO, COD_PALESTRANTE, "&strDT_OCORRENCIA&", DT_TERMINO, SYS_DT_INATIVO, NUM_COMPETIDOR_START, PALESTRANTE, CARGA_HORARIA, "&strLOCAL&", LOJA_SHOW, LOJA_EDIT_QTDE, CERTIFICADO_TEXTO, DIPLOMA_TEXTO, COD_PROD_VALIDA, EXTRA_INFO_SHOW, EXTRA_INFO_MSG, EXTRA_INFO_REQUERIDO, VOUCHER_TEXTO, CERTIFICADO_PDF, CONCURSO, Firstname, ref_numerica, TITULO_INTL, DESCRICAO_INTL, GRUPO_INTL, IMG, TITULO_MINI, BGCOLOR, SINOPSE, VOUCHER_TEXTO_US, VOUCHER_TEXTO_ES, GRUPO_SUB"
	strSQL = strSQL & " FROM tbl_produtos where titulo='"&strTITULO&"'"
	Response.Write(strSQL)
	objConn.Execute(strSQL)
	
%>
  <br />
  Processo finalizado com sucesso.<br />
  <input type="button" onclick="document.location='copia_produto.asp';" value="nova cópia" />

<%
	End If
	
	FechaDBConn ObjConn
' ========================================================================
%>