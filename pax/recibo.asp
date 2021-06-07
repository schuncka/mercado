<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/adovbs.inc"-->
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_include/barcode39.asp"-->
<!--#include file="../_include/extenso.inc"-->
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%>  - Recibo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_CSS/CSM.CSS" rel="stylesheet" type="text/css">
</head>
<body>
<%
dim strCOD_EVENTO, strCOD_INSCRICAO, strTIPO
dim objConn, strSQL, objRS
dim i,arrCOD_INSC, strCOD_INSC
Dim strNOMECLI, strENDER, strBAIRRO, strCIDADE, strESTADO, strCEP, strID_NUM_DOC1, strVLR_RECIBO, strDT_CHEGADAFICHA, strCPF
Dim strEV_NOME, strEV_CABECALHO, strEV_RODAPE, strEV_CABECALHO_LOJA, strEV_RODAPE_LOJA, strEV_SITE, strEV_DT_MATERIAL, strEV_HR_MATERIAL
Dim strEV_PAVILHAO, strEV_CIDADE, strEV_ESTADO, strEV_AGENCIA_TURISMO, strEV_EMAIL, strEV_EMAIL_SENDER, strEV_FONE
Dim strEV_RECIBO_TEXTO, strEV_TITLE, strEV_RECIBO_TEXTO_ORIGINAL, strDT_RECIBO, strDT_PGTO
Dim strLINK_BOLETO, objRSDetail, strCOD_FORMAPGTO, strCODBARRA, strVLR_PAGO
Dim strFAT_RAZAO, strFAT_CNPJ, strPRODUTOS, strPRODUTOS_VLR_EXTENSO

strCOD_EVENTO = Request.Form("var_cod_evento")
strCOD_INSCRICAO = Request.Form("var_cod_inscricao")

AbreDBConn objConn, CFG_DB_DADOS 

strSQL=	" SELECT NOME, " &_
        " CABECALHO, " &_ 
		" RODAPE, " &_ 
        " CABECALHO_LOJA, " &_ 
		" RODAPE_LOJA, " &_ 
		" SITE, " &_ 
		" DT_MATERIAL, " &_ 
		" HR_MATERIAL, " &_ 
		" PAVILHAO, " &_ 
		" CIDADE, " &_ 
		" ESTADO_EVENTO, " &_		 
		" AGENCIA_TURISMO, " &_ 
		" EMAIL, " &_ 
		" EMAIL_SENDER, " &_
		" FONE, " &_
		" RECIBO_TEXTO " &_ 
		" FROM tbl_EVENTO" &_ 
		" WHERE COD_EVENTO = " & strCOD_EVENTO
		
'FechaRecordSet objRS
'objConnCSM.open objRS, strSQL

set objRS = objConn.Execute(strSQL)

If not objRs.EOF then
  strEV_NOME = objRS("NOME")&""
  strEV_CABECALHO = objRS("CABECALHO")&""
  strEV_RODAPE = objRS("RODAPE")&""
  strEV_CABECALHO_LOJA = objRS("CABECALHO_LOJA")&""
  strEV_RODAPE_LOJA = objRS("RODAPE_LOJA")&""
  strEV_SITE = objRS("SITE")&""
  strEV_DT_MATERIAL = objRS("DT_MATERIAL")&""
  strEV_HR_MATERIAL = objRS("HR_MATERIAL")&""
  strEV_PAVILHAO = objRS("PAVILHAO")&""
  strEV_CIDADE = objRS("CIDADE")&""
  strEV_ESTADO = objRS("ESTADO_EVENTO")&""
  strEV_AGENCIA_TURISMO = objRS("AGENCIA_TURISMO")&""
  strEV_EMAIL = objRS("EMAIL")&""
  strEV_EMAIL_SENDER = objRS("EMAIL_SENDER")&""
  strEV_FONE = objRS("FONE")&""
  strEV_TITLE = "Recibo"
  strEV_RECIBO_TEXTO_ORIGINAL = objRS("RECIBO_TEXTO")&""
end if
		
'FechaRecordSet objRS
'objConnCSM.open objRS, strSQL


FechaRecordSet objRS

'********************************************
' O objetivo é fazer receber um array, fazer um loop até o fim do mesmo
' e para cada um deles imprimir uma ficha
'********************************************

'--------------------------------------------
strCOD_INSC = strCOD_INSCRICAO
arrCOD_INSC = SPLIT(strCOD_INSC,",")


'---------------------------------------
for i=0 to ubound(arrCOD_INSC)

strSQL=	" SELECT SUM(tbl_Caixa_Sub_INSC.VLR) AS VLR_RECIBO, DATE_FORMAT(max(TBL_CAIXA.SYS_DATACA),'%d/%m/%Y') AS DT_PGTO " &_ 
	  " FROM tbl_Caixa_Sub_INSC INNER JOIN TBL_CAIXA ON TBL_CAIXA.IDCAIXA = tbl_Caixa_Sub_INSC.IDCAIXA" &_
	  " WHERE tbl_Caixa_Sub_INSC.COD_INSCRICAO = " & arrCOD_INSC(i)

set objRS = objConn.Execute(strSQL)		
strVLR_RECIBO = objRS("VLR_RECIBO")
strDT_PGTO = objRS("DT_PGTO")
FechaRecordSet objRS

If not IsNumeric(strVLR_RECIBO) Then
  strVLR_RECIBO = 0
End If
strVLR_RECIBO = FormatNumber(abs(strVLR_RECIBO))

strSQL=	" SELECT tbl_EMPRESAS.NOMECLI, " &_
        "        tbl_EMPRESAS.END_FULL, " &_ 
		"        tbl_EMPRESAS.END_BAIRRO, " &_ 
		"        tbl_EMPRESAS.END_CIDADE, " &_ 
		"        tbl_EMPRESAS.END_ESTADO, " &_ 
		"        tbl_EMPRESAS.END_CEP, " &_ 
		"        tbl_EMPRESAS.ID_NUM_DOC1, " &_ 
		"        tbl_INSCRICAO.COD_FORMAPGTO, " &_ 
		"        tbl_INSCRICAO.CODBARRA, " &_ 
		"        tbl_INSCRICAO.DT_CHEGADAFICHA, " & _
		"        tbl_INSCRICAO.FAT_RAZAO,  " &_ 
		"        tbl_INSCRICAO.FAT_CNPJ " &_ 
		" FROM tbl_INSCRICAO INNER JOIN tbl_EMPRESAS ON tbl_INSCRICAO.COD_EMPRESA = tbl_EMPRESAS.COD_EMPRESA " &_ 
		" WHERE tbl_Inscricao.COD_EVENTO = " & strCOD_EVENTO & _
		" AND tbl_INSCRICAO.COD_INSCRICAO = "& arrCOD_INSC(i)
set objRS = objConn.Execute(strSQL)		
strNOMECLI = objRS("NOMECLI")
strENDER = objRS("END_FULL")
strBAIRRO = objRS("END_BAIRRO")
strCIDADE = objRS("END_CIDADE")
strESTADO = objRS("END_ESTADO")
strCEP = objRS("END_CEP")
strCOD_FORMAPGTO = objRS("COD_FORMAPGTO")
strCODBARRA = objRS("CODBARRA")&""
strID_NUM_DOC1 = objRS("ID_NUM_DOC1")
strDT_CHEGADAFICHA = PrepData(objRS("DT_CHEGADAFICHA"),True,True)
strFAT_RAZAO = objRS("FAT_RAZAO")&""
strFAT_CNPJ = objRS("FAT_CNPJ") & ""

If strFAT_RAZAO = "" Or strFAT_CNPJ = "" Then
  strFAT_RAZAO = objRS("NOMECLI")&""
  strFAT_CNPJ  = objRS("ID_NUM_DOC1") & ""
End If

If strFAT_CNPJ <> "" Then
  If Len( Replace(Replace(strFAT_CNPJ,".",""),",","") ) > 11 Then
    strFAT_CNPJ = " CNPJ " & strFAT_CNPJ
  Else
    strFAT_CNPJ = " CPF " & strFAT_CNPJ
  End If 
End If


strCPF = objRS("ID_NUM_DOC1") & ""

If Len( Replace(Replace(strCPF,".",""),",","") ) > 11 Then
  strCPF = "CNPJ " & strCPF
Else
  strCPF = "CPF " & strCPF
End If

strDT_RECIBO = Request.Form("var_data")
If strDT_RECIBO = "" Or not IsDate(strDT_RECIBO) Then
  strDT_RECIBO = now()
End If


strSQL=	" SELECT TBL_PRODUTOS.COD_PROD, GRUPO, TITULO, DESCRICAO, OBS, PALESTRANTE, DT_OCORRENCIA, VLR_PAGO " &_ 
		" FROM TBL_PRODUTOS, TBL_INSCRICAO_PRODUTO " &_
		" WHERE TBL_PRODUTOS.COD_PROD=TBL_INSCRICAO_PRODUTO.COD_PROD " &_ 
		"   AND tbl_Produtos.COD_EVENTO = " & strCOD_EVENTO & _
		"   AND TBL_INSCRICAO_PRODUTO.COD_INSCRICAO= "&arrCOD_INSC(i)

set objRSDetail = objConn.Execute(strSQL)
strPRODUTOS = ""
If not objRSDetail.EOF Then

  Do While not objRSDetail.eof
      strVLR_PAGO = FormatNumber(objRSDetail("VLR_PAGO"),2) 
      strPRODUTOS = strPRODUTOS &    "(" & objRSDetail("COD_PROD") & ") " & objRSDetail("TITULO") & "<br>"
	  strPRODUTOS_VLR_EXTENSO = strPRODUTOS_VLR_EXTENSO & objRSDetail("TITULO") & " R$"&strVLR_PAGO&" ("&Extenso(strVLR_PAGO)&")"

    objRSDetail.movenext
	If not objRSDetail.EOF Then
	  strPRODUTOS_VLR_EXTENSO = strPRODUTOS_VLR_EXTENSO & ", "
	End If
  Loop
  
End If		
FechaRecordSet objRSDetail


strEV_RECIBO_TEXTO = strEV_RECIBO_TEXTO_ORIGINAL

strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_CABECALHO>", strEV_CABECALHO)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_NOMEEVENTO>", strEV_NOME)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_CIDADEEVENTO>", strEV_CIDADE)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_ESTADOEVENTO>", strEV_ESTADO)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_LOCALEVENTO>", strEV_PAVILHAO)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_DATA_EXTENSO>", DataExtenso(strDT_RECIBO) )
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_DATAATUAL>", DataExtenso(now()))

strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_DATAATUAL_US>", DataExtensoIntl(now(),1033)) 'Ingles (EUA)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_DATAATUAL_FR>", DataExtensoIntl(now(),1036)) 'Francês
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_DATAATUAL_IT>", DataExtensoIntl(now(),1040)) 'Italiano
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_DATAATUAL_ES>", DataExtensoIntl(now(),3082)) 'Espanhol

strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_INSCRICAO>", arrCOD_INSC(i))
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_COD_INSCRICAO>", arrCOD_INSC(i))
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_SITEEVENTO>", "<a href='http://" & strEV_SITE & "' target='_blank'>" & strEV_SITE & "</a>")
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_AGENCIATURISMO>", strEV_AGENCIA_TURISMO)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_EMAILEVENTO>", "<a href='mailto:" & strEV_EMAIL & "'>" & strEV_EMAIL & "</a>")
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_FONEEVENTO>", strEV_FONE)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_RODAPE>", strEV_RODAPE)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_PRODUTOS>", strPRODUTOS)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_PRODUTOS_VLR_EXTENSO>", strPRODUTOS_VLR_EXTENSO)

strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_VLR_RECIBO>", strVLR_RECIBO)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_FAT_RAZAO>", strFAT_RAZAO)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_FAT_CNPJ>", strFAT_CNPJ)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_NOMECLI>", strNOMECLI)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_DT_PGTO>", strDT_PGTO)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_CPF>", strCPF)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_CPF>", strID_NUM_DOC1)
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_VLR_RECIBO_EXTENSO>", Extenso(strVLR_RECIBO))

strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_AUTENTICACAO>", Replace(Replace(Replace(strDT_CHEGADAFICHA,"/",""),":","")," ","") & arrCOD_INSC(i) )

'Código de barras
strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_BARCODE>", ReturnBarCode39(strCODBARRA,30,1.5,"../img/") )

If strCOD_FORMAPGTO <> "" Then
  strSQL =          " SELECT EF.COD_FORMAPGTO, EF.ID_LOJA, EF.CEDENTE, EF.RAZAO_SOCIAL, EF.CNPJ, EF.AGENCIA, EF.CONTA, EF.COD_CONTRATO, EF.PARCELAS, EF.INSTRUCOES, FP.URL_ENTRADA, FP.FORMAPGTO "
  strSQL = strSQL & "   FROM tbl_EVENTO_FORMAPGTO EF, tbl_FORMAPGTO FP"
  strSQL = strSQL & "  WHERE EF.COD_FORMAPGTO = FP.COD_FORMAPGTO"
  strSQL = strSQL & "    AND EF.COD_EVENTO = " & strCOD_EVENTO
  strSQL = strSQL & "    AND EF.COD_FORMAPGTO = " & strCOD_FORMAPGTO
  
  Set objRSDetail = objConn.Execute(strSQL)
  
  If not objRSDetail.EOF Then
  '   strFORMAPGTO = objRSDetail("FORMAPGTO")
     Select Case Cstr(strCOD_FORMAPGTO)
       Case "1"
	   ' Boleto Banco Brasil - OnLine
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletobb.asp?id="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>Reimpressão do boleto bancário.</a><br>"
  	   Case "2"
	   ' Boleto Bradesco - Athenas
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletobradesco2.asp?id="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>Reimpressão do boleto bancário.</a><br>"
	   Case "3"
	   ' Boleto Bradesco - Scopus
         strLINK_BOLETO = "<a href='"&Trim(objRSDetail("URL_ENTRADA")&"")&"?merchantid="&Trim(objRSDetail("ID_LOJA")&"")&"&orderid="&arrCOD_INSC(i)&"'  target='_blank'>"&Trim(objRSDetail("URL_ENTRADA")&"")&"?merchantid="&Trim(objRSDetail("ID_LOJA")&"")&"&orderid="&arrCOD_INSC(i)&"</a><br>"
	   Case "5"
	   ' Boleto Sicredi - OnLine
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletosicredi.asp?orderid="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>REIMPRESSÃO DO BOLETO</a><br>"
	   Case "51"
	   ' Boleto Banco Brasil - Locaweb
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletobblw.asp?orderid="&strCOD_INSC&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>REIMPRESSÃO DO BOLETO</a><br>"
	   Case "6"
	   ' Boleto Santander - Nexxera
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletosantander2.asp?id="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>Reimpressão do boleto bancário.</a><br>"
	   Case "7"
	   ' Boleto Itau - Athenas
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletoitau2.asp?id="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>Reimpressão do boleto bancário.</a><br>"
	   Case "8"
	   ' Boleto Real - Athenas
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletoreal2.asp?id="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>Reimpressão do boleto bancário.</a><br>"
	   Case "41"
	   ' Boleto Banrisul
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletobanrisul2.asp?id="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>Reimpressão do boleto bancário.</a>"
	   Case "104"
	   ' Boleto Caixa - Athenas
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletocaixa2.asp?id="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>Reimpressão do boleto bancário.</a><br>"
  	   Case "399"
	   ' Boleto HSBC - Athenas
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boletohsbc2.asp?id="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>Reimpressão do boleto bancário.</a>"
	   Case "748"
	   ' Boleto Sicredi - Athenas
         strLINK_BOLETO = "<a href='http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/boleto_sicredi2.asp?id="&arrCOD_INSC(i)&"&cod_evento="&strCOD_EVENTO&"&adm=1' target='_blank'>Reimpressão do boleto bancário.</a>"
       Case Else
     End Select
  End If
  
  strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_FORMAPGTO>", objRSDetail("FORMAPGTO")&"")
  strEV_RECIBO_TEXTO = Replace(strEV_RECIBO_TEXTO, "<PRO_LINKBOLETO>", strLINK_BOLETO)
  
  FechaRecordSet objRSDetail
  
End If
%>
<table cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td height="760" valign="top"> 
      <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr> 
          <td><%=strEV_RECIBO_TEXTO%></td>
        </tr>
      </table>
	</td>
  </tr>
</table>
<%
  If  i < ubound(arrCOD_INSC) Then
  'Imprime a quebra de pagina se não for o ultimo da lista
%>
<!--este comando faz a quebra de página forçada, o problema é que quando foi utilizado ele imprimiu uma página em branco //-->
<div style="page-break-before:always;"></div>
<%
  End If
Next

FechaDBConn objConn
'---------------------------------------------%>

<script language="JavaScript">
<!--
window.print();
//-->
</script>
</body>
</html>
