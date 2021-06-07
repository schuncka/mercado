<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<!--#include file="_database/athUtils.asp"-->
<%
Dim objConn, objRS, objRSConf, strSQL
Dim strTableProd, strTableRecep, strCodEvento

AbreDBConn objConn, CFG_DB_DADOS

strCodEvento = GetParam("var_cod_evento")
strTableRecep = GetParam("var_tabela_prod")

If strTableRecep = "controle_in" Then strTableProd = "controle_in_hist" Else strTableProd = "controle_in"

strSQL = " SELECT COD_EVENTO FROM tbl_" & strTableRecep & " WHERE COD_EVENTO = " & strCodEvento
Set objRSConf = objConn.execute(strSQL)
 
If objRSConf.EOF Then

	strSQL = " SELECT COD_CONTROLE_IN, CODBARRA, DT_INSERT, LOCAL, COD_EVENTO FROM tbl_" & strTableProd & " WHERE COD_EVENTO = " & strCodEvento
	Set objRS = objConn.execute(strSQL)
	
	While Not objRS.EOF
		strSQL = "INSERT INTO tbl_" & strTableRecep & " (CODBARRA, DT_INSERT, LOCAL, COD_EVENTO) VALUES (" 
		strSQL = strSQL & " '" & objRS("CODBARRA") & "'"
		strSQL = strSQL & ",'" & objRS("DT_INSERT") & "'"
		strSQL = strSQL & ",'" & objRS("LOCAL") & "'"
		strSQL = strSQL & "," & objRS("COD_EVENTO")
		strSQL = strSQL & ")"
		objConn.execute(strSQL)
		
		objRS.MoveNext
	Wend
	
	strSQL = " DELETE FROM tbl_" & strTableProd & " WHERE COD_EVENTO = " & strCodEvento
	objConn.execute(strSQL)
	
	FechaRecordSet(objRS)
Else
	Response.Write("<center>")
	Response.Write("	<font face=""Arial"" style=""font-size:12px; font-weight:bold; color:red"">")
	Response.Write("		Não foi possível importar os dados por já haver referência na tabela solicitada<br><br>")
	Response.Write("		<a href=""javascript:history.back()"">Voltar</a>")
	Response.Write("	</font>")
	Response.Write("</center>")
	Response.End()
End If


FechaRecordSet(objRSConf)
FechaDBConn(objConn)

Response.Redirect("switchhistorico.asp")
%>