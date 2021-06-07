<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/adovbs.inc"-->
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"--> 
<!--#include file="../_include/barcode39.asp"-->
<%

Sub GravaArquivo(prPATHNAME, prFILENAME, prCONTEUDO)
dim filesys, filetxt, getname, path

 Set filesys = CreateObject("Scripting.FileSystemObject")
 Set filetxt = filesys.CreateTextFile(prPATHNAME & prFILENAME, True) 
 
 filetxt.Write(prCONTEUDO) 
 filetxt.Close 

 Set filetxt = Nothing
 Set filesys = Nothing
End Sub

Dim strPATHNAME, strFILES
strPATHNAME = Server.MapPath(".") & "\upload\"
strFILES = ""

Dim strCOD_EVENTO, strCOD_EMPRESA
strCOD_EVENTO = Request("cod_evento")

Dim strCOD_PAPER, strCOD_PAPER_CADASTRO
strCOD_PAPER = Request("cod_paper")
strCOD_PAPER_CADASTRO = Request("cod_paper_cadastro")

If strCOD_EVENTO = "" Or strCOD_PAPER = "" Then Response.Redirect("default.asp")

strCOD_EMPRESA = Request("var_cod_empresa")

Dim strDESTINO, strEMAIL, strASSUNTO, strBODY, StrBodyCOMPLETO, strBodyOBS  
dim strCOD_INSC, strCOD_PAIS
dim objConn, strSQL, objRS, objRSDetail
Dim strNOMECLI, strENTIDADE, strNUMDOC1, strCODATIV1, strATIVIDADE, strENDER, strBAIRRO, strCIDADE, strESTADO, strCEP
Dim strFAT_RAZAO, strFAT_CNPJ, strFAT_IE, strFAT_ENDFULL, strFAT_CIDADE, strFAT_ESTADO, strFAT_CEP
Dim strFAT_CONTATO_NOME, strFAT_CONTATO_EMAIL, strFAT_CONTATO_DEPTO, strFAT_CONTATO_FONE
Dim strEMAIL1, strFONE1, strFONE2, strFONE3, strFONE4, strDT_CHEGADAFICHA, strVLR_TOTAL
Dim strEV_NOME, strEV_CABECALHO, strEV_RODAPE, strEV_CABECALHO_LOJA, strEV_RODAPE_LOJA, strEV_SITE, strEV_DT_MATERIAL, strEV_HR_MATERIAL
Dim strEV_PAVILHAO, strEV_CIDADE, strEV_AGENCIA_TURISMO, strEV_EMAIL, strEV_EMAIL_SENDER, strEV_FONE, strCOD_STATUS_PRECO, strSTATUS_PRECO
Dim strLINK_BOLETO, strFORMAPGTO, strPARCELAS
Dim strEV_COD_MOEDA_EVENTO, strEV_COD_MOEDA_COBRANCA, strEV_SIMBOLO_MOEDA, strEV_SIMBOLO_MOEDA_COBRANCA
Dim strEV_MOEDA_NOME, strEV_MOEDA_COBRANCA_NOME
Dim strMOEDA_COTACAO, strDATA_COTACAO
Dim strVALOR_INSCRICAO, strCODBARRA


AbreDBConn objConn, CFG_DB_DADOS

strCOD_PAIS = Request("lng")
If strCOD_PAIS = "" Then
  strCOD_PAIS = "BR"
End If

strSQL=	" SELECT E.NOME, E.NOME_COMPLETO, " &_
        " E.CABECALHO, " &_ 
		" E.RODAPE, " &_ 
		" E.CABECALHO_PAPER, " &_ 
		" E.RODAPE_LOJA, " &_ 
		" E.RODAPE_PAPER, " &_
        " E.CABECALHO_LOJA, " &_ 
		" E.RODAPE_LOJA, " &_ 
		" E.SITE, " &_ 
		" DT_MATERIAL, " &_ 
		" E.HR_MATERIAL, " &_ 
		" E.PAVILHAO, " &_ 
		" E.CIDADE, " &_ 		 
		" E.AGENCIA_TURISMO, " &_ 
		" E.EMAIL, " &_ 
		" E.EMAIL_SENDER, " &_
		" E.FONE, " &_
		" E.COD_MOEDA_EVENTO, " &_ 
		" E.COD_MOEDA_COBRANCA, " &_ 
		" M.MOEDA, " &_ 
		" M.SIMBOLO " &_ 
		" FROM tbl_EVENTO E LEFT OUTER JOIN tbl_MOEDA M ON (E.COD_MOEDA_EVENTO = M.COD_MOEDA)" &_ 
		" WHERE E.COD_EVENTO = " & strCOD_EVENTO
		
'FechaRecordSet objRS
'objConnCSM.open objRS, strSQL

set objRS = objConn.Execute(strSQL)

If not objRs.EOF then
  strEV_NOME = objRS("NOME_COMPLETO")&""
  strEV_CABECALHO = objRS("CABECALHO")&""
  strEV_RODAPE = objRS("RODAPE")&""
  strEV_CABECALHO_LOJA = objRS("CABECALHO_PAPER")&""
  If strEV_CABECALHO_LOJA = "" Then
	strEV_CABECALHO_LOJA = objRS("CABECALHO_LOJA")&""
  End If
  strEV_CABECALHO_LOJA = Replace(lcase(strEV_CABECALHO_LOJA),".jpg","_"&strCOD_PAIS&".jpg")
  strEV_CABECALHO_LOJA = Replace(lcase(strEV_CABECALHO_LOJA),".gif","_"&strCOD_PAIS&".gif")
  strEV_CABECALHO = Replace(lcase(strEV_CABECALHO),".jpg","_"&strCOD_PAIS&".jpg")
  strEV_CABECALHO = Replace(lcase(strEV_CABECALHO),".gif","_"&strCOD_PAIS&".gif")
  strEV_RODAPE = objRS("RODAPE_PAPER")&""
  If strEV_RODAPE = "" Then
    strEV_RODAPE = objRS("RODAPE_LOJA")&""
  End If
  strEV_RODAPE = Replace(lcase(strEV_RODAPE),".jpg","_"&strCOD_PAIS&".jpg")
  strEV_RODAPE = Replace(lcase(strEV_RODAPE),".gif","_"&strCOD_PAIS&".gif")
  strEV_SITE = objRS("SITE")&""
  strEV_DT_MATERIAL = objRS("DT_MATERIAL")&""
  strEV_HR_MATERIAL = objRS("HR_MATERIAL")&""
  strEV_PAVILHAO = objRS("PAVILHAO")&""
  strEV_CIDADE = objRS("CIDADE")&""
  strEV_AGENCIA_TURISMO = objRS("AGENCIA_TURISMO")&""
  strEV_EMAIL = objRS("EMAIL")&""
  strEV_EMAIL_SENDER = objRS("EMAIL_SENDER")&""
  strEV_FONE = objRS("FONE")&""
  strEV_COD_MOEDA_EVENTO = objRS("COD_MOEDA_EVENTO")&""
  strEV_COD_MOEDA_COBRANCA = objRS("COD_MOEDA_COBRANCA")&""
  strEV_SIMBOLO_MOEDA = objRS("SIMBOLO")&""
  strEV_MOEDA_NOME = objRS("MOEDA")&""
end if
FechaRecordSet objRS


Dim strPAPER_DESCRICAO, strPAPER_EMAIL_DESTINO, strPAPER_ARPEL, strPAPER_NRO_LIMITE_ENVIO

strSQL =          " SELECT TBL_PAPER.COD_PAPER, TBL_PAPER.EMAIL_DESTINO, TBL_PAPER.NRO_LIMITE_ENVIO"
Select Case strCOD_PAIS
	Case "BR"
		strSQL = strSQL & ", TBL_PAPER.DESCRICAO,  TBL_PAPER.ARPEL "
	Case Else
		strSQL = strSQL & ", TBL_PAPER.DESCRICAO_INTL AS DESCRICAO,  TBL_PAPER.ARPEL_INTL AS ARPEL "
End Select
strSQL = strSQL & "   FROM TBL_PAPER"
strSQL = strSQL & "  WHERE TBL_PAPER.COD_EVENTO = " & strCOD_EVENTO
strSQL = strSQL & "    AND TBL_PAPER.COD_PAPER = " & strCOD_PAPER

Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
  strCOD_PAPER = objRS("COD_PAPER")
  strPAPER_DESCRICAO = objRS("DESCRICAO")&""
  strPAPER_EMAIL_DESTINO = objRS("EMAIL_DESTINO")&""
  strPAPER_ARPEL = objRS("ARPEL")&""
  strPAPER_NRO_LIMITE_ENVIO = objRS("NRO_LIMITE_ENVIO")
End If
FechaRecordSet objRS

If strPAPER_NRO_LIMITE_ENVIO&"" = "" Then
  strPAPER_NRO_LIMITE_ENVIO = 1
End If
%>
<html>
<head>
<title><%=strEV_NOME%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="subpaper.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<a name="top"></a>
<%
Response.Write(strEV_CABECALHO_LOJA)
%>
<table width="700" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td><img src="img/top_step.gif" border="0"></td>
</tr>
<tr>
<td background="img/bg_step.gif" align="center">
<%
Dim strSYS_DATAFINISH, strNRO_SUBMISSAO

strSQL = "SELECT COD_PAPER_CADASTRO, SYS_DATAFINISH FROM TBL_PAPER_CADASTRO WHERE COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
  strSYS_DATAFINISH = objRS("SYS_DATAFINISH")
End If
FechaRecordSet objRS


strSQL =          "SELECT COUNT(PC.COD_PAPER_CADASTRO) AS NRO_SUBMISSAO "
strSQL = strSQL & "  FROM tbl_PAPER_CADASTRO PC INNER JOIN tbl_PAPER P ON PC.COD_PAPER = P.COD_PAPER "
strSQL = strSQL & " WHERE PC.COD_EMPRESA = '" & strCOD_EMPRESA & "'"
strSQL = strSQL & "   AND PC.SYS_DATAFINISH IS NOT NULL "
strSQL = strSQL & "   AND P.COD_PAPER = " & strCOD_PAPER
strSQL = strSQL & "   AND P.COD_EVENTO = " & strCOD_EVENTO

'response.Write(strSQL)
'response.End()


Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
  strNRO_SUBMISSAO = clng(objRS("NRO_SUBMISSAO"))
End if	
FechaRecordSet objRS


	'==============================================================================
	
	Dim arrPAPER_CAMPO, arrPAPER_VALOR, strCAMPO_VALOR, strCAMPO_NOME, strCAMPO_LABEL_MEMO, strCAMPO_VALOR_ORIGINAL
	
	strSQL =          " SELECT COD_PAPER_SUB, CAMPO_TIPO, CAMPO_ORDEM, CAMPO_REQUERIDO, CAMPO_COMBOLIST, CAMPO_LABEL_MEMO"
	Select Case strCOD_PAIS
		Case "BR"
			strSQL = strSQL & ", CAMPO_NOME "
		Case "US"
			strSQL = strSQL & ", CAMPO_NOME_INTL AS CAMPO_NOME "
	End Select
	strSQL = strSQL & "   FROM TBL_PAPER_SUB"
	strSQL = strSQL & "  WHERE COD_PAPER = " & strCOD_PAPER
	strSQL = strSQL & "  ORDER BY CAMPO_ORDEM, COD_PAPER_SUB"
	Set objRS = objConn.Execute(strSQL)
	Do While not objRS.EOF
	  strCAMPO_VALOR = Request("var_campo_sub_"&objRS("COD_PAPER_SUB"))
	  strCAMPO_NOME = replace(replace(objRS("CAMPO_NOME")&"","\",""),"/","")

	  strCAMPO_LABEL_MEMO = objRS("CAMPO_LABEL_MEMO")&""
	  If strCAMPO_LABEL_MEMO = "" Then
	    strCAMPO_LABEL_MEMO = strCAMPO_NOME
	  End If

	  If objRS("CAMPO_TIPO") = "M" and strCAMPO_VALOR&"" <> "" Then
		GravaArquivo strPATHNAME, UCase(strCOD_PAPER_CADASTRO & "_" & strCAMPO_LABEL_MEMO & ".TXT"), strCAMPO_VALOR
		strFILES = strFILES & strPATHNAME & UCase(strCOD_PAPER_CADASTRO & "_" & strCAMPO_LABEL_MEMO & ".TXT") & "|"
	  End If
	  strCAMPO_VALOR = strToSQL(strCAMPO_VALOR)
	  
	  strSQL =          " SELECT TBL_PAPER_SUB_VALOR.COD_PAPER_SUB, TBL_PAPER_SUB_VALOR.CAMPO_VALOR, TBL_PAPER_SUB_VALOR.CAMPO_VALOR_ORIGINAL"
	  strSQL = strSQL & "   FROM TBL_PAPER_CADASTRO INNER JOIN TBL_PAPER_SUB_VALOR ON TBL_PAPER_CADASTRO.COD_PAPER_CADASTRO = TBL_PAPER_SUB_VALOR.COD_PAPER_CADASTRO  "
	  strSQL = strSQL & "  WHERE  TBL_PAPER_CADASTRO.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
	  strSQL = strSQL & "    AND TBL_PAPER_SUB_VALOR.COD_PAPER_SUB = " & objRS("COD_PAPER_SUB")
	  strSQL = strSQL & "    AND TBL_PAPER_CADASTRO.COD_EMPRESA = '" & strCOD_EMPRESA & "'"
	  Set objRSDetail = objConn.Execute(strSQL)
	  'Se o campo já tiver sido enviado faz uma atualização no campo (UPDATE), caso contrário faz insere o campo (INSERT)
	  If not objRSDetail.EOF Then
	    
		'Se o campo valor original ainda não foi preenchido então copia ela para o campo CAMPO_VALOR_ORIGINAL para fins de histórico/auditoria
	    If objRSDetail("CAMPO_VALOR_ORIGINAL")&"" = "" Then
			strSQL = "UPDATE TBL_PAPER_SUB_VALOR SET CAMPO_VALOR_ORIGINAL = CAMPO_VALOR WHERE COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO & " AND COD_PAPER_SUB = " & objRS("COD_PAPER_SUB")
			objConn.Execute(strSQL)
		End If
				
		strSQL = "UPDATE TBL_PAPER_SUB_VALOR SET CAMPO_VALOR = " & strCAMPO_VALOR & " WHERE COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO & " AND COD_PAPER_SUB = " & objRS("COD_PAPER_SUB")
		
	  Else
		strSQL = "INSERT INTO TBL_PAPER_SUB_VALOR (COD_PAPER_CADASTRO, COD_PAPER_SUB, CAMPO_VALOR) VALUES ("&strCOD_PAPER_CADASTRO&","&objRS("COD_PAPER_SUB")&","&strCAMPO_VALOR&")"
	  End If
	  FechaRecordSet objRSDetail
	' DEBUG
	 'Response.Write(strSQL &"<BR>") 
	  objConn.Execute(strSQL)
	  
	  objRS.MoveNext
	Loop
	FechaRecordSet objRS

'---------------------------------------
  	 
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
			" tbl_EMPRESAS.CODATIV1 " &_
            " FROM tbl_EMPRESAS" &_ 
            " WHERE tbl_EMPRESAS.COD_EMPRESA = '" & strCOD_EMPRESA  & "'"
		
    set objRS = objConn.Execute(strSQL)

    If not objRs.EOF then
	  strCOD_EMPRESA = objRS("COD_EMPRESA")
      strNOMECLI = objRS("NOMECLI")
	  strENTIDADE = objRS("ENTIDADE")&""
      strNUMDOC1 = objRS("ID_NUM_DOC1")
      strCODATIV1 = objRS("CODATIV1")
      strENDER   = objRS("END_FULL")
      strBAIRRO  = objRS("END_BAIRRO")
      strCIDADE  = objRS("END_CIDADE")
      strESTADO  = objRS("END_ESTADO")
      strCEP     = objRS("END_CEP")
	  strDESTINO = objRS("EMAIL1")
	  strEMAIL1  = objRS("EMAIL1")
	  strFONE1 = objRS("FONE1")
	  strFONE2 = objRS("FONE2")
	  strFONE3 = objRS("FONE3")
	  strFONE4 = objRS("FONE4")
    end if
    FechaRecordSet objRS
	

	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_NOMEEVENTO>", strEV_NOME)
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_CIDADEEVENTO>", strEV_CIDADE)
	Select Case(strCOD_PAIS) 
	  Case "US"
	    strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_DATAATUAL>", DataExtensoIntl(now(),1033)) 'Ingles (EUA)
	  Case "ES"
	    strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_DATAATUAL>", DataExtensoIntl(now(),3082)) 'Espanhol
	  Case Else
	  	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_DATAATUAL>", DataExtenso(now()) )
	End Select
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_DATAATUAL_US>", DataExtensoIntl(now(),1033)) 'Ingles (EUA)
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_DATAATUAL_FR>", DataExtensoIntl(now(),1036)) 'Francês
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_DATAATUAL_IT>", DataExtensoIntl(now(),1040)) 'Italiano
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_DATAATUAL_ES>", DataExtensoIntl(now(),3082)) 'Espanhol
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_DIAATUAL>", Right("0"&Day(date()),2) )
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_MESATUAL>", Right("0"&Month(date()),2) )
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_ANOATUAL>", Year(date()) )
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_COD_PAPER_CADASTRO>", strCOD_PAPER_CADASTRO)
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_PAPER_DESCRICAO>", strPAPER_DESCRICAO)
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_NOMECLIENTE>", strNOMECLI)
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_ENTIDADE>", strENTIDADE)
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_SITEEVENTO>", "<a href='http://" & strEV_SITE & "' target='_blank'>" & strEV_SITE & "</a>")
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_AGENCIATURISMO>", strEV_AGENCIA_TURISMO)
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_EMAILEVENTO>", "<a href='mailto:" & strEV_EMAIL & "'>" & strEV_EMAIL & "</a>")
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_FONEEVENTO>", strEV_FONE)
	
	strSQL =          " SELECT TBL_PAPER_SUB_VALOR.COD_PAPER_SUB, TBL_PAPER_SUB_VALOR.CAMPO_VALOR, TBL_PAPER_SUB_VALOR.CAMPO_VALOR_ORIGINAL "
	Select Case strCOD_PAIS
		Case "BR"
			strSQL = strSQL & ", TBL_PAPER_SUB.CAMPO_NOME "
		Case "US"
			strSQL = strSQL & ", TBL_PAPER_SUB.CAMPO_NOME_INTL AS CAMPO_NOME"
	End Select
	strSQL = strSQL & "   FROM TBL_PAPER_CADASTRO, TBL_PAPER_SUB, TBL_PAPER_SUB_VALOR "
	strSQL = strSQL & "  WHERE TBL_PAPER_CADASTRO.COD_PAPER_CADASTRO = TBL_PAPER_SUB_VALOR.COD_PAPER_CADASTRO  "
	strSQL = strSQL & "    AND TBL_PAPER_SUB.COD_PAPER_SUB = TBL_PAPER_SUB_VALOR.COD_PAPER_SUB  "
	strSQL = strSQL & "    AND TBL_PAPER_CADASTRO.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
	strSQL = strSQL & "    AND TBL_PAPER_CADASTRO.COD_EMPRESA = '" & strCOD_EMPRESA & "'"
	Set objRSDetail = objConn.Execute(strSQL)
	Do While not objRSDetail.EOF 
	    strCAMPO_VALOR = objRSDetail("CAMPO_VALOR")&""
		strCAMPO_VALOR = Replace(objRSDetail("CAMPO_VALOR")&"",vbNewLine,"<BR>")
		'Trecho para exibir o campo CAMPO_VALOR_ORIGINAL caso tenha sido alterado
		'strCAMPO_VALOR_ORIGINAL = objRSDetail("CAMPO_VALOR_ORIGINAL")&""
		'strCAMPO_VALOR_ORIGINAL = Replace(strCAMPO_VALOR_ORIGINAL,vbNewLine,"<BR>")
		'If strCAMPO_VALOR_ORIGINAL <> "" Then
		'  strCAMPO_VALOR = strCAMPO_VALOR & " ("&strCAMPO_VALOR_ORIGINAL&")"
		'End If

	  strPAPER_ARPEL = Replace(strPAPER_ARPEL&"", "<PRO_PAPER_"&objRSDetail("CAMPO_NOME")&""&">", strCAMPO_VALOR)
	  objRSDetail.MoveNext
	Loop
	FechaRecordSet objRSDetail
	
	Dim strCAMINHO_IMG
	strCAMINHO_IMG = "http://" & Replace(lcase(Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("URL")),"subpaper/passo4.asp","img/")
	'Código de barras
	strPAPER_ARPEL = Replace(strPAPER_ARPEL, "<PRO_BARCODE>", ReturnBarCode39(strCODBARRA,30,1.5,strCAMINHO_IMG) )
	
	
	
	strBody =           ""
	strBody = StrBody & "<STYLE>" & vbNewLine
	strBody = StrBody & ".textoarm {font-family:Verdana; font-color:000000; font-size:10pt}" & vbNewLine
	strBody = StrBody & ".textoarmpeq {font-family:Verdana; font-color:000000; font-size:8pt}" & vbNewLine
	strBody = StrBody & "</STYLE>" & vbNewLine
	strBody = StrBody & "<table width='98%' class='textoarm' align='center'>"
	strBody = StrBody & "  <tr><td align='justify' valign='top'>" & strPAPER_ARPEL & "</td></tr>"
	strBody = StrBody &	"</table>"
	
			
	Response.Write(strBody)
	
	strBody = Replace(strBody, "<PRO_CABECALHO>", strEV_CABECALHO_LOJA)
	strBody = Replace(strBody, "<PRO_RODAPE>", strEV_RODAPE_LOJA)
	
	
	strASSUNTO = strEV_NOME & " - " & strPAPER_DESCRICAO
	
	AthEnviaMail strDESTINO, strEV_EMAIL_SENDER, "", "", strASSUNTO, strBody, 1, 0, 0, ""
	
	
	'--------------------------------------------------------------------------------------------------------
	' EMAIL PARA SECRETARIA
	'---------------------------------------------------------------------------------------------------------
	strBody =           ""
	strBody = StrBody & "<table width='100%' border='0' class='texto'>"
	strBody = StrBody & "<tr><td colspan='2'>"
	strBody = StrBody & "Tema: <b>" & strPAPER_DESCRICAO & "</b><br>"
	strBody = StrBody & "Data Envio: " & PrepData(Now,True,True) & "<br><br>"
	strBody = StrBody & ":::::::::::::::::: Dados do participante ::::::::::::::::::::::" & "<br>"
	strBody = StrBody & "CPF: "& strNUMDOC1 & "<br>"
	strBody = StrBody & "Código: "& strCOD_EMPRESA & "<br>"
	strBody = StrBody & "Nome do Inscrito: " & strNOMECLI & "<br>"
	strBody = StrBody & "Entidade: " & strENTIDADE & "<br>"
	strBody = StrBody & "Endereço: " & strENDER & "<br>"
	strBody = StrBody & "Bairro: " & strBAIRRO & "<br>"
	strBody = StrBody & "Cidade: " & strCIDADE & "<br>"
	strBody = StrBody & "Estado: " & strESTADO & "<br>"
	strBody = StrBody & "CEP: " & strCEP & "<br> " 
	strBody = StrBody & "Fone 1: " & strFONE1 & "<br> " 
	strBody = StrBody & "Fone 2: " & strFONE2 & "<br>"
	strBody = StrBody & "Fone 3: " & strFONE3 & "<br>"
	strBody = StrBody & "Fone 4: " & strFONE4 & "<br>"
	strBody = StrBody & "E-mail: " & strEMAIL1 & "<br> "
	strBody = StrBody &	"</td>"
	strBody = StrBody &	"</tr>"
	
	strSQL =          " SELECT TBL_PAPER_SUB.CAMPO_NOME, TBL_PAPER_SUB_VALOR.CAMPO_VALOR, TBL_PAPER_SUB_VALOR.CAMPO_VALOR_ORIGINAL"
	strSQL = strSQL & "   FROM TBL_PAPER_SUB, TBL_PAPER_SUB_VALOR"
	strSQL = strSQL & "  WHERE TBL_PAPER_SUB.COD_PAPER_SUB = TBL_PAPER_SUB_VALOR.COD_PAPER_SUB"
	strSQL = strSQL & "    AND TBL_PAPER_SUB.COD_PAPER = " & strCOD_PAPER
	strSQL = strSQL & "    AND TBL_PAPER_SUB_VALOR.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
	strSQL = strSQL & "  ORDER BY TBL_PAPER_SUB.CAMPO_ORDEM, TBL_PAPER_SUB.COD_PAPER_SUB"
	
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
	  strBody = StrBody & "<tr><td colspan='2'>"
	  strBody = StrBody & ":::::::::::::::::: Dados informados ::::::::::::::::::::::" & "<br>"
	  strBody = StrBody & "</td></tr>"
	  Do While not objRS.EOF
		strBody = StrBody & "<tr>"
		strBody = StrBody & "<td width='10%' align='right' nowrap>"&objRS("CAMPO_NOME")&":</td>"
		strBody = StrBody & "<td width='90%'>"&Replace(objRS("CAMPO_VALOR")&"",vbNewLine,"<BR>")&"&nbsp;"
		'Trecho para exibir o campo CAMPO_VALOR_ORIGINAL caso tenha sido alterado
		'strCAMPO_VALOR_ORIGINAL = Replace(objRS("CAMPO_VALOR_ORIGINAL")&"",vbNewLine,"<BR>")
		'If strCAMPO_VALOR_ORIGINAL <> "" Then
		'  strBody = StrBody & " ("&strCAMPO_VALOR_ORIGINAL&")"
		'End If
		strBody = StrBody & "</td>"
		strBody = StrBody & "</tr>"  
		objRS.MoveNext
	  Loop
	End If
	FechaRecordSet objRS
	
	strBody = StrBody &	"</table>"
	
	'Response.Write(strBody)
	'Response.End()
	
	'--------------------------------------------------------------------------------------------------------
	' Chama a função para envio de email para a secretaria do congresso
	'--------------------------------------------------------------------------------------------------------
	
	'DEBUG
	'Response.Write(">> " & strFILES & "<BR>")
	
	strSQL = "UPDATE TBL_PAPER_CADASTRO SET SYS_DATAREENVIO = NOW() WHERE COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
	objConn.Execute(strSQL)
	
	strASSUNTO = "Submissão Papers - Reenvio - " & strEV_NOME 
	AthEnviaMail strPAPER_EMAIL_DESTINO, strEV_EMAIL_SENDER, "", CFG_EMAIL_AUDITORIA_PROEVENTO&";"&CFG_EMAIL_AUDITORIA_CLIENTE, strASSUNTO, strBODY, 1, 0, 0, strFILES



FechaDBConn objConn
%>

</td>
<tr>
<td background="img/ftr_step.gif" height="116">
  <br>
  <table width="600" align="center" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td width="300">&nbsp;</td>
      <td width="150" align="center"></td>
      <td width="150" align="center"></td>
    </tr>
  </table>
</td>
</tr>
</table>
<%
'--------------------------------------------- 
Response.Write(strEV_RODAPE_LOJA)
%>		
<script language="javascript">
<!--
//window.opener.document.location = window.opener.document.location.toString();
window.opener.location.reload(true);
//-->
</script>
</body>
</html>
