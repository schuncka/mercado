<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"--> 
<!--#include file="_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<html>
<head>
<title>PAINEL pVISTA</title>
<!--#include file="metacssjs_root.inc"--> 
<script src="./_scripts/scriptsCS.js"></script>
</head>
<body class="metro">
<%
Dim objConn, ObjRS
Dim strSQL, strvalor
Dim strDT_REFERENCIA, strACAO, strNRO_REGISTROS

AbreDBConn objConn, CFG_DB 

strACAO = Request.Form("var_acao")
strDT_REFERENCIA = Request.Form("var_dt_referencia")
If strDT_REFERENCIA="" or not isDate(strDT_REFERENCIA) Then
	strDT_REFERENCIA = DateAdd("D",-5,Date())
End If

strNRO_REGISTROS = 0
strSQL = strSQL & " SELECT COUNT(DISTINCT I.COD_INSCRICAO) AS TOTAL_INSCRICAO"
strSQL = strSQL & "   FROM TBL_INSCRICAO I INNER JOIN TBL_INSCRICAO_PRODUTO IP ON I.COD_INSCRICAO = IP.COD_INSCRICAO "
strSQL = strSQL & "                        INNER JOIN TBL_PRODUTOS P  ON IP.COD_PROD = P.COD_PROD "
strSQL = strSQL & "  WHERE I.COD_EVENTO = " & Session("COD_EVENTO") 
strSQL = strSQL & "    AND FN_CALCULA_SALDO(I.COD_INSCRICAO) < 0 "
strSQL = strSQL & "    AND FN_CALCULA_TOTAL_PAGAMENTO(I.COD_INSCRICAO) = 0 "
strSQL = strSQL & "    AND (DATE(IP.SYS_DATACA) <= '"&PrepDataIve(strDT_REFERENCIA,False,False)&"' OR IP.SYS_DATACA IS NULL) "
'Response.Write(StrSQL)
Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
	strNRO_REGISTROS = clng(objRS("TOTAL_INSCRICAO"))
End If
FechaRecordSet objRS

Select Case strACAO 
Case "DELETAR" 
	'Insere no historico das respectivas inscrições os produtos que serao excluidos
	strSQL =          "INSERT INTO TBL_INSCRICAO_HIST (COD_INSCRICAO,SYS_DATACA,SYS_USERCA,HISTORICO,COD_INSCRICAO_HIST_CATEG) "
	strSQL = strSQL & " SELECT I.COD_INSCRICAO, NOW(), '"& Session("ID_USER") &"', CONCAT('AJUSTE INSCRICAO PENDENTE - PRODUTO DELETADO = ',P.TITULO,' (', IP.COD_PROD, ') QTDE = ',IP.QTDE, ' VLR = ',IP.VLR_PAGO) AS HISTORICO, 1"
	strSQL = strSQL & "   FROM TBL_INSCRICAO I INNER JOIN TBL_INSCRICAO_PRODUTO IP ON I.COD_INSCRICAO = IP.COD_INSCRICAO "
	strSQL = strSQL & "                        INNER JOIN TBL_PRODUTOS P  ON IP.COD_PROD = P.COD_PROD "
	strSQL = strSQL & "  WHERE I.COD_EVENTO = " & Session("COD_EVENTO") 
	strSQL = strSQL & "    AND FN_CALCULA_SALDO(I.COD_INSCRICAO) < 0 "
	strSQL = strSQL & "    AND FN_CALCULA_TOTAL_PAGAMENTO(I.COD_INSCRICAO) = 0 "
	strSQL = strSQL & "    AND (DATE(IP.SYS_DATACA) <= '"&PrepDataIve(strDT_REFERENCIA,False,False)&"' OR IP.SYS_DATACA IS NULL) "
	'Response.Write(strSQL&"<BR>")
	objConn.Execute(strSQL)
	 
	'Deleta os produtos das inscrições que a data de compra seja inferior a data de referencia e ainda nao tenham sido pagos
	strSQL =          " DELETE IP.* " 
	strSQL = strSQL & "   FROM TBL_INSCRICAO I INNER JOIN TBL_INSCRICAO_PRODUTO IP ON I.COD_INSCRICAO = IP.COD_INSCRICAO "
	strSQL = strSQL & "  WHERE I.COD_EVENTO = " & Session("COD_EVENTO") 
	strSQL = strSQL & "    AND FN_CALCULA_SALDO(I.COD_INSCRICAO) < 0 "
	strSQL = strSQL & "    AND FN_CALCULA_TOTAL_PAGAMENTO(I.COD_INSCRICAO) = 0 "
	strSQL = strSQL & "    AND (DATE(IP.SYS_DATACA) <= '"&PrepDataIve(strDT_REFERENCIA,False,False)&"' OR IP.SYS_DATACA IS NULL)"
	'Response.Write(strSQL&"<BR>")
	objConn.Execute(strSQL)
%>
<div align="center">Processo finalizado.</div>
<%
Case "CONFIRMAR"
	If strNRO_REGISTROS > 0 Then
%>

    <div align="center">
    Existem <%=right("00000"&strNRO_REGISTROS,6)%> inscri&ccedil;&otilde;es com pagamento em aberto at&eacute; <%=PrepData(strDT_REFERENCIA,True,False)%>.<br>
    <br>
    <form name="formdeletar" action="ajusteInscricaoPendente.asp" method="post">
    <input type="hidden" name="var_dt_referencia" value="<%=PrepData(strDT_REFERENCIA,True,False)%>" maxlength="10" readonly>
    <input type="hidden" name="var_acao" value="DELETAR">
    <br>
    <input type="submit" name="btEnviar" value="Confirmar Dele&ccedil;&atilde;o Produtos Pendentes">
    </form>
    </div>
<%
	Else
%>
    <div align="center">Nenhuma inscri&ccedil;&atilde;o pendente localizada.<br>
    <input type="button" name="btVoltar" value="Voltar" onClick="document.location='ajusteInscricaoPendente.asp';">
    </div>

<%
	End If
Case Else	 
%>
    <div align="center">
      <form name="formdeletar" action="ajusteInscricaoPendente.asp" method="post">
    Data de Refer&ecirc;ncia:
    <input type="text" name="var_dt_referencia" value="<%=PrepData(strDT_REFERENCIA,True,False)%>" maxlength="10">
    <input type="hidden" name="var_acao" value="CONFIRMAR">
    <br>
    <input type="submit" name="btEnviar" value="Pesquisar Inscri&ccedil;&otilde;es Pendentes no Sistema">
    </form>
</div>
<%
End Select

FechaDBConn ObjConn
%>
</body>
</html>
