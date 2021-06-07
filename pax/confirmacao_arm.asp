<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/adovbs.inc"-->
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_include/barcode39.asp"-->
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%>  - ARM</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_CSS/CSM.CSS" rel="stylesheet" type="text/css">
</head>
<body>
<%
dim strCOD_INSC, strCOD_EVENTO
dim objConn, strSQL, objRS
dim i,arrCOD_INSC
Dim strCODBARRA
Dim strCOD_EMPRESA, strNOMECLI, strENTIDADE, strNUMDOC1, strCODATIV1, strATIVIDADE, strENDER, strBAIRRO, strCIDADE, strESTADO, strCEP
Dim strFAT_RAZAO, strFAT_CNPJ, strFAT_IE, strFAT_ENDFULL, strFAT_CIDADE, strFAT_ESTADO, strFAT_CEP
Dim strFAT_CONTATO_NOME, strFAT_CONTATO_EMAIL, strFAT_CONTATO_DEPTO, strFAT_CONTATO_FONE
Dim strEMAIL1, strFONE1, strFONE2, strFONE3, strFONE4, strDT_CHEGADAFICHA, strVLR_TOTAL, strVLR_PRODUTOS
Dim strEV_NOME, strEV_CABECALHO, strEV_RODAPE, strEV_CABECALHO_LOJA, strEV_RODAPE_LOJA, strEV_SITE, strEV_DT_MATERIAL, strEV_HR_MATERIAL
Dim strEV_PAVILHAO, strEV_CIDADE, strEV_ESTADO, strEV_AGENCIA_TURISMO, strEV_EMAIL, strEV_EMAIL_SENDER, strEV_FONE
Dim strEV_ARM_TEXTO, strEV_ARM_TEXTO_INTL, strEV_ARM_TEXTO_ORIGINAL, strBODY, strBodyDESCRICAO, strBodyDESCRICAO_HTML, StrBodyCOMPLETO, StrBodyOBS, strBodyPRECO, strVOUCHER_TEXTO, strAUX
Dim strCOD_PAIS, strDESTINO, strCOD_STATUS_PRECO, strSTATUS_PRECO, strSTATUS_PRECO_OBSERVACAO, strCOD_FORMAPGTO, strFORMAPGTO


'--------------------------------------------
'strCOD_EVENTO = Session("COD_EVENTO")
strCOD_EVENTO = request("var_cod_evento")
strCOD_INSC   = request("var_cod_inscricao")
arrCOD_INSC   = SPLIT(strCOD_INSC,",")


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
		" ARM_TEXTO, " &_ 
		" ARM_TEXTO_INTL " &_ 
		" FROM tbl_EVENTO" &_ 
		" WHERE  COD_EVENTO = " & strCOD_EVENTO
		
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
  strEV_ARM_TEXTO = objRS("ARM_TEXTO")&""
  strEV_ARM_TEXTO_INTL = objRS("ARM_TEXTO_INTL")&""
  strEV_ARM_TEXTO_ORIGINAL = strEV_ARM_TEXTO
  strEV_FONE = objRS("FONE")&""
end if

FechaRecordSet objRS



'************************************************************************************
' O objetivo é fazer receber um array (arrCOD_INSC), fazer um loop até o fim do mesmo
' e para cada um deles imprimir uma ficha
'************************************************************************************

AbreDBConn objConn, CFG_DB_DADOS 
'---------------------------------------
for i=0 to ubound(arrCOD_INSC)

   strSQL=	" SELECT tbl_EMPRESAS.COD_EMPRESA, " &_
            " tbl_EMPRESAS.NOMECLI, " &_ 
			" tbl_EMPRESAS.ENTIDADE, " &_
            " tbl_EMPRESAS.END_FULL, " &_ 
            " tbl_EMPRESAS.END_BAIRRO, " &_ 
            " tbl_EMPRESAS.END_CIDADE, " &_ 
            " tbl_EMPRESAS.END_ESTADO, " &_ 
            " tbl_EMPRESAS.END_CEP, " &_ 
			" tbl_EMPRESAS.EMAIL1, " &_
			" tbl_EMPRESAS.FONE1, " &_
			" tbl_EMPRESAS.FONE2, " &_
			" tbl_EMPRESAS.FONE3, " &_
			" tbl_EMPRESAS.FONE4, " &_
			" tbl_EMPRESAS.ID_NUM_DOC1, " &_
			" tbl_EMPRESAS.CODATIV1, " &_
			" tbl_EMPRESAS_SUB.NOME_COMPLETO, " &_ 
			" tbl_EMPRESAS_SUB.EMAIL, " &_ 
			" tbl_EMPRESAS_SUB.ID_CPF, " &_ 
            " tbl_INSCRICAO.COD_INSCRICAO, " &_ 
			" tbl_INSCRICAO.CODBARRA, " &_
            " tbl_INSCRICAO.DT_CHEGADAFICHA, " &_ 
            " tbl_INSCRICAO.SYS_DATAAT, " &_ 
            " tbl_INSCRICAO.FAT_RAZAO, " &_ 
            " tbl_INSCRICAO.FAT_CNPJ, " &_ 
            " tbl_INSCRICAO.FAT_IE, " &_ 
            " tbl_INSCRICAO.FAT_ENDFULL, " &_ 
            " tbl_INSCRICAO.FAT_CIDADE, " &_ 
            " tbl_INSCRICAO.FAT_ESTADO, " &_ 
            " tbl_INSCRICAO.FAT_CEP, " &_ 
            " tbl_INSCRICAO.FAT_CONTATO_NOME, " &_ 
            " tbl_INSCRICAO.FAT_CONTATO_EMAIL, " &_ 
			" tbl_INSCRICAO.FAT_CONTATO_DEPTO, " &_ 
			" tbl_INSCRICAO.FAT_CONTATO_FONE, " &_ 
            " tbl_INSCRICAO.COD_STATUS_PRECO, " &_ 
            " tbl_INSCRICAO.SUFIXO_BOLETO, " &_ 
			" tbl_INSCRICAO.COD_PAIS, " &_
			" tbl_INSCRICAO.COD_FORMAPGTO, " &_ 
            " tbl_STATUS_PRECO.STATUS AS STATUS_PRECO," &_
			" tbl_STATUS_PRECO.OBSERVACAO AS STATUS_PRECO_OBSERVACAO" &_ 
			"   FROM ((tbl_INSCRICAO INNER JOIN tbl_EMPRESAS ON tbl_INSCRICAO.COD_EMPRESA = tbl_EMPRESAS.COD_EMPRESA) " &_ 
			"                       LEFT OUTER JOIN tbl_EMPRESAS_SUB ON tbl_INSCRICAO.CODBARRA = tbl_EMPRESAS_SUB.CODBARRA) " &_ 
			"                       LEFT OUTER JOIN tbl_STATUS_PRECO ON tbl_INSCRICAO.COD_STATUS_PRECO = tbl_STATUS_PRECO.COD_STATUS_PRECO " &_ 
            " WHERE tbl_Inscricao.COD_EVENTO = " & strCOD_EVENTO & _
            "   AND tbl_INSCRICAO.COD_INSCRICAO = "& arrCOD_INSC(i)

set objRS = objConn.Execute(strSQL)		
strNOMECLI = objRS("NOME_COMPLETO")&""
strENTIDADE = objRS("NOMECLI")&""
If strNOMECLI = "" Then
 strNOMECLI = objRS("NOMECLI")&""
 strENTIDADE = objRS("ENTIDADE")&"" 
End If
strCOD_EMPRESA = objRS("COD_EMPRESA")&""
strNUMDOC1 = objRS("ID_CPF")&""
If strNUMDOC1 = "" Then
  strNUMDOC1 = objRS("ID_NUM_DOC1")&""
End If
strCODATIV1 = objRS("CODATIV1")&""
strENDER   = objRS("END_FULL")&""
strBAIRRO  = objRS("END_BAIRRO")&""
strCIDADE  = objRS("END_CIDADE")&""
strESTADO  = objRS("END_ESTADO")&""
strCEP     = objRS("END_CEP")&""
strDESTINO = objRS("EMAIL1")
strEMAIL1  = objRS("EMAIL1")&""
strFONE1 = objRS("FONE1")&""
strFONE2 = objRS("FONE2")&""
strFONE3 = objRS("FONE3")&""
strFONE4 = objRS("FONE4")&""
strCODBARRA = objRS("CODBARRA")&""
strDT_CHEGADAFICHA = objRS("DT_CHEGADAFICHA")&""
strFAT_RAZAO   = objRS("FAT_RAZAO")&""
strFAT_CNPJ    = objRS("FAT_CNPJ")&""
strFAT_IE      = objRS("FAT_IE")&""
strFAT_ENDFULL = objRS("FAT_ENDFULL")&""
strFAT_CIDADE  = objRS("FAT_CIDADE")&""
strFAT_ESTADO  = objRS("FAT_ESTADO")&""
strFAT_CEP     = objRS("FAT_CEP")&""
strFAT_CONTATO_NOME = objRS("FAT_CONTATO_NOME")&""
strFAT_CONTATO_EMAIL = objRS("FAT_CONTATO_EMAIL")&""
strFAT_CONTATO_DEPTO = objRS("FAT_CONTATO_DEPTO")&""
strFAT_CONTATO_FONE = objRS("FAT_CONTATO_FONE")&""
strCOD_STATUS_PRECO = objRS("COD_STATUS_PRECO")&""
strSTATUS_PRECO = objRS("STATUS_PRECO")&""
strSTATUS_PRECO_OBSERVACAO = objRS("STATUS_PRECO_OBSERVACAO")&""
strENDER = objRS("END_FULL")&""
strBAIRRO = objRS("END_BAIRRO")&""
strCIDADE = objRS("END_CIDADE")&""
strESTADO = objRS("END_ESTADO")&""
strCEP = objRS("END_CEP")&""
strDESTINO = objRS("EMAIL1")&";"&objRS("EMAIL")
strCOD_PAIS = objRS("COD_PAIS")&""
strCODBARRA = objRS("CODBARRA")&""
strCOD_FORMAPGTO = objRS("COD_FORMAPGTO")&""

FechaRecordSet objRS

If strCOD_FORMAPGTO&"" = "" Then
  strCOD_FORMAPGTO = 0
End If

strSQL =          " SELECT EF.COD_FORMAPGTO, EF.ID_LOJA, EF.CEDENTE, EF.RAZAO_SOCIAL, EF.CNPJ, EF.AGENCIA, EF.CONTA, EF.COD_CONTRATO, EF.PARCELAS, EF.INSTRUCOES, FP.URL_ENTRADA, FP.FORMAPGTO "
strSQL = strSQL & "   FROM tbl_EVENTO_FORMAPGTO EF, tbl_FORMAPGTO FP"
strSQL = strSQL & "  WHERE EF.COD_FORMAPGTO = FP.COD_FORMAPGTO"
strSQL = strSQL & "    AND EF.COD_EVENTO = " & strCOD_EVENTO
strSQL = strSQL & "    AND EF.COD_FORMAPGTO = " & strCOD_FORMAPGTO
Set objRS = objConn.Execute(strSQL)
  
If not objRS.EOF Then
   strFORMAPGTO = objRS("FORMAPGTO")
End If
FechaRecordSet objRS

strEV_ARM_TEXTO = strEV_ARM_TEXTO_ORIGINAL

'Teste se o COD_PAIS for alguma lingua diferente do BR - Brasil ou se não está em branco para utilizar o ARM_INTL
If strCOD_PAIS <> "" And strCOD_PAIS <> "BR" Then
  strEV_ARM_TEXTO = strEV_ARM_TEXTO_INTL
End If

strSQL=	" SELECT TBL_PRODUTOS.COD_PROD, GRUPO, TITULO, DESCRICAO,  DESCRICAO_HTML, OBS, PALESTRANTE, DT_OCORRENCIA, VOUCHER_TEXTO, (VLR_PAGO * QTDE) AS VLR_SUBTOTAL " &_ 
		" FROM TBL_PRODUTOS, TBL_INSCRICAO_PRODUTO " &_
		" WHERE TBL_PRODUTOS.COD_PROD=TBL_INSCRICAO_PRODUTO.COD_PROD " &_ 
		"   AND tbl_Produtos.COD_EVENTO = " & strCOD_EVENTO & _
		"   AND TBL_INSCRICAO_PRODUTO.COD_INSCRICAO= "&arrCOD_INSC(i)

set objRS = objConn.Execute(strSQL)
StrBody = ""
StrBodyCOMPLETO = ""
strBodyOBS = ""
strBodyDESCRICAO = ""
strBodyDESCRICAO_HTML = ""
strVOUCHER_TEXTO = ""
strVLR_PRODUTOS = 0

If not objRS.EOF Then
  strBodyPRECO = "<table width='100%' cellpadding='3' cellspacing='0' border='1'>"
  do while not objRS.eof
      strBody = StrBody & objRS("TITULO")
      strBodyCOMPLETO = strBodyCOMPLETO & objRS("TITULO") & ": " & objRS("DESCRICAO")
      strBodyOBS = strBodyOBS & objRS("OBS")
	  strBodyDESCRICAO = strBodyDESCRICAO & objRS("DESCRICAO") & ""
	  strBodyDESCRICAO_HTML = strBodyDESCRICAO_HTML & objRS("DESCRICAO_HTML") & ""	  
	  strAUX = objRS("VOUCHER_TEXTO")&""
	  strVOUCHER_TEXTO = strVOUCHER_TEXTO & strAUX
	  
	  strBodyPRECO = strBodyPRECO & "<tr><td width='90%'>"&objRS("TITULO")&"</td><td nowrap width='10%' align='right'>"&FormatNumber(objRS("VLR_SUBTOTAL"),2)&"</td></tr>"
	  strVLR_PRODUTOS = strVLR_PRODUTOS + objRS("VLR_SUBTOTAL")
	  
    objRS.MoveNext
	If not objRS.EOF Then
	  strBody = StrBody & "<BR>"
	  strBodyCOMPLETO = strBodyCOMPLETO & "<BR>"
      strBodyOBS = strBodyOBS & "<BR>"
	  strBodyDESCRICAO = strBodyDESCRICAO & "<BR>"
	  strBodyDESCRICAO_HTML = strBodyDESCRICAO_HTML & "<BR>"
	  If strAUX <> "" Then
	    strVOUCHER_TEXTO = strVOUCHER_TEXTO & "<br style='page-break-before:always;'>"
	  End If
	End If
  loop
  strBodyPRECO = strBodyPRECO & "</table>"
End If
FechaRecordSet objRS

strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_PRODUTOS_VOUCHER>", strVOUCHER_TEXTO)

strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_CABECALHO>", strEV_CABECALHO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_NOMEEVENTO>", strEV_NOME)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_CIDADEEVENTO>", strEV_CIDADE)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_ESTADOEVENTO>", strEV_ESTADO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_LOCALEVENTO>", strEV_PAVILHAO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DATAATUAL>", DataExtenso(now()))
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DATAATUAL_US>", DataExtensoIntl(now(),1033)) 'Ingles (EUA)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DATAATUAL_FR>", DataExtensoIntl(now(),1036)) 'Francês
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DATAATUAL_IT>", DataExtensoIntl(now(),1040)) 'Italiano
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DATAATUAL_ES>", DataExtensoIntl(now(),3082)) 'Espanhol
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DIAATUAL>", Right("0"&Day(date()),2) )
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_MESATUAL>", Right("0"&Month(date()),2) )
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_ANOATUAL>", Year(date()) )
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_COD_EMPRESA>", strCOD_EMPRESA)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_NOMECLIENTE>", strNOMECLI)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_NOMECLI>", strNOMECLI)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_ID_NUM_DOC1>", strNUMDOC1)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_CPF>", strNUMDOC1)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_INSCRICAO>", arrCOD_INSC(i))
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_SITEEVENTO>", "<a href='http://" & strEV_SITE & "' target='_blank'>" & strEV_SITE & "</a>")
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_AGENCIATURISMO>", strEV_AGENCIA_TURISMO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_EMAILEVENTO>", "<a href='mailto:" & strEV_EMAIL & "'>" & strEV_EMAIL & "</a>")
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FONEEVENTO>", strEV_FONE)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_RODAPE>", strEV_RODAPE)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_PRODUTOS>", strBody)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_PRODUTOS_DESCRICAO>", strBodyDESCRICAO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_PRODUTOS_DESCRICAO_HTML>", strBodyDESCRICAO_HTML)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_PRODUTOS_COMPLETO>", strBodyCOMPLETO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_PRODUTOS_OBS>", strBodyOBS)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_PRODUTOS_PRECO>", strBodyPRECO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_PRODUTOS_TOTAL>", FormatNumber(strVLR_PRODUTOS,2))

If strFAT_RAZAO <> "" Then
  strBody = "<b><u>Dados de Faturamento</u>:</b><br>"
  strBody = StrBody & "<b>Razão Social / Nome:</b> " & strFAT_RAZAO & "<br>"
  strBody = StrBody & "<b>CNPJ / CPF:</b> "& strFAT_CNPJ & "<br>"
  strBody = StrBody & "<b>Endereço:</b> " & strFAT_ENDFULL & "<br>"
  strBody = StrBody & "<b>Cidade:</b> " & strFAT_CIDADE & "&nbsp;&nbsp;&nbsp;&nbsp;"
  strBody = StrBody & "<b>Estado:</b> " & strFAT_ESTADO & "<br>"
  strBody = StrBody & "<b>CEP:</b> " & strFAT_CEP & "<br> " 
  strBody = StrBody & "<b>E-mail:</b> " & strFAT_CONTATO_EMAIL & "<br> " 
  
  strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DADOS_FATURAMENTO>", strBody)
End If

strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FAT_RAZAO>", strFAT_RAZAO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FAT_CNPJ>", strFAT_CNPJ)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FAT_ENDFULL>", strFAT_ENDFULL)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FAT_CIDADE>", strFAT_CIDADE)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FAT_ESTADO>", strFAT_ESTADO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FAT_CEP>", strFAT_CEP)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FAT_CONTATO_NOME>", strFAT_CONTATO_NOME)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FAT_CONTATO_EMAIL>", strFAT_CONTATO_EMAIL)

strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FORMAPGTO>", strFORMAPGTO)

'Código de barras
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_BARCODE>", ReturnBarCode39(arrCOD_INSC(i),30,1.5,"../img/") )

 strBody = ""
 Dim objRSImg, strALTURA, strLARGURA
 strSQL = " SELECT ARQUIVO, ALTURA, LARGURA FROM tbl_EVENTO_IMG WHERE AREA = 'ARM' AND COD_EVENTO = " & strCOD_EVENTO
 Set objRSImg = objConn.Execute(strSQL)
 If not objRSImg.EOF Then
   strBody = StrBody & "<br><table border=0>"
   strBody = StrBody & "  <tr><td align='justify' valign='top'>"
   Do While not objRSImg.EOF
     strLARGURA = objRSImg("LARGURA") & ""
     strALTURA = objRSImg("ALTURA") & ""
     If strLARGURA <> "0" And strLARGURA <> "" And not IsNull(strLARGURA) Then
       strLARGURA = " width='" & strLARGURA &"'"
     End If
     If strALTURA <> "0" And strALTURA <> "" And not IsNull(strALTURA) Then
       strALTURA = " height='" & strALTURA &"'"
     End If
     strBody = StrBody &	"<div align=""center""><img src=""../imgdin/" & objRSImg("ARQUIVO") & """ " & strALTURA & strLARGURA & " border=""0""></div><br>"
     objRSImg.MoveNext
   Loop
   strBody = StrBody & "  </td></tr>"
   strBody = StrBody & "</table><br>"
 End If
 FechaRecordSet objRSImg

strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_IMAGEM>", strBody)
%>
<table cellpadding="0" cellspacing="0" border="0">
<tr>
    <td height="700" valign="top"><%= strEV_ARM_TEXTO %> <br>
    </td>
  </tr>
  <tr> 
    <td  height="60"><br> 
	  <table width="400" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr> 
          <td><%=strNOMECLI%></td>
        </tr>
        <tr> 
          <td><%=strENDER%></td>
        </tr>
        <tr> 
          <td><%=strCIDADE%> - <%=strESTADO%></td>
        </tr>
        <tr> 
          <td><%=strCEP%></td>
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
NEXT

FechaDBConn objConn
'---------------------------------------------%>

<script language="JavaScript">
<!--
window.print();
//-->
</script>
</body>
</html>
