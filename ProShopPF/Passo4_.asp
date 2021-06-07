<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->
<!--#include file="../_database/athSendMail.asp"--> 
<!--#include file="../_include/barcode39.asp"-->
<%
 
  
 Dim objConn, objRS, objLang, strSQL 'banco
 Dim arrScodi,arrSdesc 'controle
 Dim strLng, strLOCALE,strBody,strHTMLProduto,strHTML,CFG_EMAIL_AUDITORIA_CLIENTE
 Dim strCOD_EVENTO, strCategoria, strVLR_TOTAL	
 Dim strLinkDefault, i, strCodInscricao,strCOD_EMPRESA,strCodFormaPgto, strCAMINHO_IMG
 Dim strTitulo, strDescricao, strCodProd, dblDescontoPromo, dblVlrFixoPromo, strCodProdPromo, flagCodigoPromo, dblValorProduto,strBodyAriel,strASSUNTO
 Dim strCodigoPromo, dblDescontoProduto, dblVlrFixo, objRSPromo
 Dim strEV_ARIEL_TEXTO, strEV_ARIEL_ASSUNTO , strEMAIL2
 Dim strEV_NOME,strEV_CABECALHO,strEV_RODAPE, strEV_CABECALHO_LOJA, strEV_RODAPE_LOJA, strEV_SITE, strEV_DT_MATERIAL, strEV_HR_MATERIAL, strEV_PAVILHAO
 Dim strEV_CIDADE, strEV_AGENCIA_TURISMO, strEV_EMAIL, strEV_EMAIL_SENDER, strEV_FONE, strEV_COD_MOEDA_EVENTO, strEV_COD_MOEDA_COBRANCA, strEV_SIMBOLO_MOEDA
 Dim strEV_MOEDA_NOME, strEV_IDUSER_LOJA, strEV_PixelFacebook ,strEV_SIMBOLO_MOEDA_COBRANCA, strEV_MOEDA_COBRANCA_NOME, strMOEDA_COTACAO
 Dim strNOMECLI,strENTIDADE,strNUMDOC1,strATIVIDADE,strDT_CHEGADAFICHA,strFAT_RAZAO,strFAT_CNPJ,strFAT_IE
 Dim strFAT_ENDFULL,strFAT_CIDADE,strFAT_ESTADO,strFAT_CEP,strFAT_CONTATO_NOME,strFAT_CONTATO_EMAIL,strFAT_CONTATO_DEPTO,strFAT_CONTATO_FONE
 Dim strCOD_STATUS_PRECO,strSTATUS_PRECO,strSTATUS_PRECO_OBSERVACAO,strVALOR_INSCRICAO,dtChegadaFicha
 Dim strCODATIV1,strENDER,strBAIRRO,strCIDADE,strESTADO,strCEP,strDESTINO,strEMAIL1,strFONE1,strFONE2,strFONE3,strFONE4,strCODBARRA,strSUFIXO_BOLETO
 Dim strDtInicio, strDtFim, strHrInicio, strHrFim, strLogradouroEv,  strBairroEv, strCidadeEv, strEstadoEv, strCEPEv,strPaisEv,strPavilhao,strDescrProd,strHTMLFinal,strHTMLCol2
 Dim strHTMLCol2Ini , strHTMLiFrame , strHTMLBotoes ,strHTMLCol2Fim,strCat, strLINK,strNOMEFAN, strSENHA
 Dim strLinkLimpo, strProshopTextoFinal,strLinkBoleto
 
	strLng			 = ucase(getParam("lng")) 'BR, [US ou EN], ES	
	CFG_DB           = getParam("db")
	strCOD_EVENTO    = getParam("cod_evento")
	strCategoria     = getParam("var_categoria")
	strCodInscricao	 = getParam("var_cod_inscricao")
	strCOD_EMPRESA   = getParam("var_cod_empresa")
	strCodFormaPgto  = getParam("var_cod_formapgto")
	'if strCodFormaPgto = "999" Then
	'strCodFormaPgto  = 4
	'end if
  	strLinkLimpo     = "https://" & Replace(lcase(Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("URL")),"proshoppf/passo4_.asp","")
	strLinkBoleto    = getParam("var_link_boleto")
'	response.write("<br>link:"&strLinkBoleto)
'response.write("strLng: "& strLng			&"<br>")
'response.write("CFG_DB: "& CFG_DB           &"<br>")
'response.write("strCOD_EVENTO: "& strCOD_EVENTO    &"<br>")
'response.write("strCategoria: "& strCategoria     &"<br>")
'response.write("strCodInscricao: "& strCodInscricao	&"<br>")
'response.write("strCOD_EMPRESA: "& strCOD_EMPRESA   &"<br>")
'response.write("strCodFormaPgto: "& strCodFormaPgto  &"<br>")
if strLNG = "SP" then
	strLng = "ES"
end if





Function CalculaSaldo(prCOD_INSCRICAO)
Dim objRSDetail, strVLR_COMPRADO, strVLR_PAGO
   
	 strVLR_COMPRADO = 0
	 strVLR_PAGO = 0
	  
     strSQL = " SELECT " & _
  	          "   SUM(tbl_Inscricao_Produto.VLR_PAGO * tbl_Inscricao_Produto.QTDE) As TOT_VLR_COMPRADO " & _
  	          " FROM tbl_Inscricao_Produto" & _
    	      " WHERE tbl_Inscricao_Produto.COD_INSCRICAO = " & prCOD_INSCRICAO
'     objRSDetail.Open strSQL, objConn
     set objRSDetail = objConn.Execute(strSQL)  
     If not objRSDetail.EOF Then
       If not IsNull(objRSDetail("TOT_VLR_COMPRADO")) Then
         strVLR_COMPRADO = objRSDetail("TOT_VLR_COMPRADO")
       End If
     End If
     ObjRSDetail.Close

     ' Pega tudo que ele já pagou
     strSQL = " SELECT " & _
              "   SUM(tbl_Caixa_Sub_INSC.VLR) As TOT_VLR_PAGO" & _
              " FROM tbl_Caixa_Sub_INSC" & _
              " WHERE tbl_Caixa_Sub_INSC.COD_INSCRICAO = " & prCOD_INSCRICAO
'     objRSDetail.Open strSQL, objConn
     set objRSDetail = objConn.Execute(strSQL)  
	 If not objRSDetail.EOF Then
       If not IsNull(objRSDetail("TOT_VLR_PAGO")) Then
         strVLR_PAGO =  objRSDetail("TOT_VLR_PAGO")
       End If
     End If
	 ObjRSDetail.Close
	 
  CalculaSaldo = strVLR_PAGO - strVLR_COMPRADO 
End Function







AbreDBConn objConn, CFG_DB 

' 
 if CFG_DB = "" Then  ' -------------------------------------------------------------------------------------------------------
	 CFG_DB = Request.Cookies("pVISTA")("DBNAME") 					'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
	 if ( (CFG_DB = Empty) OR (Cstr(CFG_DB) = "") ) then
		auxStr = lcase(Request.ServerVariables("PATH_INFO"))      	'retorna: /aspsystems/virtualboss/proevento/login.asp ou /proevento/login.asp
		response.Write(auxStr)
		auxStr = Mid(auxStr,1,inStr(auxStr,"/proshoppf/Passo4_.asp")-1) 	'retorna: /aspsystems/virtualboss/proevento ou /proevento
		auxStr = replace(auxStr,"/aspsystems/_pvista/","")        	'retorna: proevento ou /proevento
		auxStr = replace(auxStr,"/","")                           	'retorna: proevento
		CFG_DB = auxStr + "_dados"
		CFG_DB = replace(CFG_DB,"_METRO_dados","METRO_dados") 	'Caso especial, banco do ambiente /_pvista não tem o "_" no nome "
		Response.Cookies("sysMetro")("DBNAME") = CFG_DB			'cfg_db nao esta vazio grava no cookie
	 end if 
End If
 ' ----------------------------------------------------------------------------------------------------------
 
 
' --------------------------------------------------------------------------------
 ' INI: LANG - tratando o Lng que por padrão pVISTA é diferente de LOCALE da função
 Select Case ucase(strLng)
	Case "BR"		strLOCALE = "pt-br"
	Case "US","EN","INTL"	strLOCALE = "en-us" 'colocar idioma INTL
	Case "SP","ES"		strLOCALE = "es"
	Case Else strLOCALE = "pt-br"
 End Select
 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang strLOCALE,"../_lang/proshoppf/"
 ' FIM: LANG (ex. de uso: response.wrire(objLang.SearchIndex("area_restrita",0))
 ' -------------------------------------------------------------------------------


 ' -------------------------------------------------------------------------------
 ' INI: Busca dados relativos as informações de ambiente do sistema (SITE_INFO)

 ' Cookies de ambiente PAX (não optamos por session, pq expira muito fácil/rápido e cokies são acessíveis fora da caixa de areia ------------------------------- '
 Response.Cookies("METRO_ProShopPF").Expires = DateAdd("h",2,now)
 Response.Cookies("METRO_ProShopPF")("locale")	  = strLOCALE



'BUSCA DADOS DO EVENTO
	strSQL =  " SELECT    e.COD_EVENTO "
	strSQL = strSQL & " , e.NOME "
	strSQL = strSQL & " , e.nome_completo "
	strSQL = strSQL & " , e.cabecalho_loja "
	strSQL = strSQL & " , e.rodape_loja "
	strSQL = strSQL & " , e.site "
	strSQL = strSQL & " , e.dt_inicio "
	strSQL = strSQL & " , e.dt_fim "
	strSQL = strSQL & " , e.hora_inicio "
	strSQL = strSQL & " , e.hora_fim "
	strSQL = strSQL & " , e.descricao "
	strSQL = strSQL & " , e.logradouro "
	strSQL = strSQL & " , e.bairro "
	strSQL = strSQL & " , e.pais "
	strSQL = strSQL & " , e.cidade "
	strSQL = strSQL & " , e.estado_evento "
	strSQL = strSQL & " , e.cep_evento "
	strSQL = strSQL & " , e.pavilhao "	
	strSQL = strSQL & " , e.cod_moeda_evento "
	strSQL = strSQL & " , e.cod_moeda_referencia "
	strSQL = strSQL & " , e.proshop_banner_carossel_pt "
	strSQL = strSQL & " , e.proshop_banner_carossel_en "
	strSQL = strSQL & " , e.proshop_banner_carossel_es "
	strSQL = strSQL & " , e.proshop_descricao_pt "
	strSQL = strSQL & " , e.proshop_descricao_en "
	strSQL = strSQL & " , e.proshop_descricao_es "
	strSQL = strSQL & " , e.proshop_google_maps  "
	strSQL = strSQL & " , e.email "
	strSQL = strSQL & " , e.email_sender "
	strSQL = strSQL & " , e.AGENCIA_TURISMO"
	strSQL = strSQL & " , e.proshop_email_evento "
	strSQL = strSQL & " , e.proshop_email_contato1 "
	strSQL = strSQL & " , e.proshop_email_contato2 "	
	strSQL = strSQL & " , e.cabecalho "	
	strSQL = strSQL & " , e.rodape "	
	strSQL = strSQL & " , m.simbolo "
	strSQL = strSQL & " , m.MOEDA"
	strSQL = strSQL & " , E.COD_MOEDA_COBRANCA"
	strSQL = strSQL & " , e.FONE"
	strSQL = strSQL & " , e.DT_MATERIAL"
	strSQL = strSQL & " , e.HR_MATERIAL"
	'strSQL = strSQL & " FROM tbl_evento "
	strSQL = strSQL & " , e.IDUSER_LOJA"
	strSQL = strSQL & " , e.LOJA_FACEBOOK_PIXELID"
	strSQL = strSQL & " FROM tbl_EVENTO e LEFT OUTER JOIN tbl_MOEDA M ON (E.COD_MOEDA_EVENTO = M.COD_MOEDA) "
	strSQL = strSQL & " WHERE cod_evento = " & strCOD_EVENTO
'response.Write(strSQL)
set objRS = objConn.Execute(strSQL)

If not objRs.EOF then
	strPavilhao         = getValue(objRS,"pavilhao")
	strDtInicio			= getValue(objRS,"dt_inicio")
	strDtFim			= getValue(objRS,"dt_fim")
	strHrInicio			= getValue(objRS,"hora_inicio")
	strHrFim			= getValue(objRS,"hora_fim")
	
	strLogradouroEv 	= getValue(objRS,"logradouro")
	strBairroEv 		= getValue(objRS,"bairro")
	strPaisEv 			= getValue(objRS,"pais")
	strCidadeEv 		= getValue(objRS,"cidade")
	strEstadoEv 		= getValue(objRS,"estado_evento")
	strCEPEv 			= getValue(objRS,"cep_evento")
	
  strEV_NOME = objRS("NOME_COMPLETO")&""
  strEV_CABECALHO = objRS("CABECALHO")&""
  strEV_RODAPE = objRS("RODAPE")&""
  strEV_CABECALHO_LOJA = objRS("CABECALHO_LOJA")&""
  strEV_CABECALHO_LOJA = Replace(lcase(strEV_CABECALHO_LOJA),".jpg","_"&strLng&".jpg")
  strEV_CABECALHO_LOJA = Replace(lcase(strEV_CABECALHO_LOJA),".gif","_"&strLng&".gif")
  strEV_RODAPE_LOJA = objRS("RODAPE_LOJA")&""
  strEV_RODAPE_LOJA = Replace(lcase(strEV_RODAPE_LOJA),".jpg","_"&strLng&".jpg")
  strEV_RODAPE_LOJA = Replace(lcase(strEV_RODAPE_LOJA),".gif","_"&strLng&".gif")
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
  strEV_IDUSER_LOJA = objRS("IDUSER_LOJA")&""
  strEV_PixelFacebook = objRS("LOJA_FACEBOOK_PIXELID")&""
end if

  strMOEDA_COTACAO = 1
  If strEV_COD_MOEDA_EVENTO <> "" And strEV_COD_MOEDA_COBRANCA <> "" And (strEV_COD_MOEDA_EVENTO <> strEV_COD_MOEDA_COBRANCA) Then
    strSQL =          "SELECT COTACAO_DATA, COTACAO_TAXA "
	strSQL = strSQL & "  FROM tbl_MOEDA_COTACAO "
	strSQL = strSQL & " WHERE COD_MOEDA_ORIGEM = " & strEV_COD_MOEDA_EVENTO
	strSQL = strSQL & "   AND COD_MOEDA_DESTINO = " & strEV_COD_MOEDA_COBRANCA
	strSQL = strSQL & " ORDER BY COTACAO_DATA DESC "
	strSQL = strSQL & " LIMIT 1"
	'Response.Write(strSQL)
	'Response.End
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
	  strMOEDA_COTACAO = objRS("COTACAO_TAXA")
	  strDATA_COTACAO = objRS("COTACAO_DATA")
	End If
	FechaRecordSet objRS
	
	strSQL = "SELECT SIMBOLO, MOEDA FROM tbl_MOEDA WHERE COD_MOEDA = " & strEV_COD_MOEDA_COBRANCA
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
	  strEV_SIMBOLO_MOEDA_COBRANCA = objRS("SIMBOLO")
	  strEV_MOEDA_COBRANCA_NOME = objRS("MOEDA")
	End If
	FechaRecordSet objRS
'  Else
'    Response.Write("("&strEV_COD_MOEDA_EVENTO & ") - " & strEV_COD_MOEDA_COBRANCA & "<BR>")
'	Response.End()
  End If
  
  If strEV_SIMBOLO_MOEDA = "" Then strEV_SIMBOLO_MOEDA = "$" End If
  If strEV_SIMBOLO_MOEDA_COBRANCA = "" Then strEV_SIMBOLO_MOEDA_COBRANCA = "$" End IF
  
  If IsNull(strMOEDA_COTACAO) Then strMOEDA_COTACAO = 1 End If

	'Pega os textos do ariel conforme a forma de pagamento
	strSQL = "SELECT ARIEL, ARIEL_ASSUNTO, COD_MOEDA_COBRANCA, PROSHOP_TEXTO_FINAL FROM tbl_EVENTO_FORMAPGTO WHERE COD_EVENTO = " & strCOD_EVENTO & " AND COD_FORMAPGTO = " & strCodFormaPgto & " AND (COD_PAIS IS NULL OR COD_PAIS = '" & strLNG & "')"
'	response.write("<br><br> ariel "&strSQL)
	set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
	  strEV_ARIEL_TEXTO = objRS("ARIEL")&""
	  strProshopTextoFinal = objRS("PROSHOP_TEXTO_FINAL")&""
	  'strProshopTextoFinal=objRS("ARIEL")&""
	  strEV_ARIEL_ASSUNTO = objRS("ARIEL_ASSUNTO")&""
	  strEV_COD_MOEDA_COBRANCA = objRS("COD_MOEDA_COBRANCA")&""
	End If
'	response.write(strProshopTextoFinal)
strASSUNTO = strEV_ARIEL_ASSUNTO&""
If strASSUNTO = "" Then
  strASSUNTO = strEV_ARIEL_ASSUNTO
End If
	

strSQL=	" SELECT tbl_EMPRESAS.COD_EMPRESA, " 
strSQL = strSQL & " tbl_EMPRESAS.NOMECLI, "  
strSQL = strSQL & " tbl_EMPRESAS.ENTIDADE, "
strSQL = strSQL & " tbl_EMPRESAS.NOMEFAN, " 
strSQL = strSQL & " tbl_EMPRESAS.END_FULL, "  
strSQL = strSQL & " tbl_EMPRESAS.END_BAIRRO, "  
strSQL = strSQL & " tbl_EMPRESAS.END_CIDADE, "  
strSQL = strSQL & " tbl_EMPRESAS.END_ESTADO, "  
strSQL = strSQL & " tbl_EMPRESAS.END_CEP, "  
strSQL = strSQL & " tbl_EMPRESAS.EMAIL1, "
strSQL = strSQL & " tbl_EMPRESAS.EMAIL2, " 
strSQL = strSQL & " tbl_EMPRESAS.FONE1, " 
strSQL = strSQL & " tbl_EMPRESAS.FONE2, " 
strSQL = strSQL & " tbl_EMPRESAS.FONE3, " 
strSQL = strSQL & " tbl_EMPRESAS.FONE4, " 
strSQL = strSQL & " tbl_EMPRESAS.ID_NUM_DOC1, " 
strSQL = strSQL & " tbl_EMPRESAS.SENHA, " 
strSQL = strSQL & " tbl_EMPRESAS.CODATIV1, " 
strSQL = strSQL & " tbl_EMPRESAS_SUB.NOME_COMPLETO, "  
strSQL = strSQL & " tbl_EMPRESAS_SUB.EMAIL, "  
strSQL = strSQL & " tbl_EMPRESAS_SUB.ID_CPF, "  			
strSQL = strSQL & " tbl_INSCRICAO.COD_INSCRICAO, "  
strSQL = strSQL & " tbl_INSCRICAO.CODBARRA, " 
strSQL = strSQL & " tbl_INSCRICAO.DT_CHEGADAFICHA, "  
strSQL = strSQL & " tbl_INSCRICAO.SYS_DATAAT, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_RAZAO, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_CNPJ, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_IE, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_ENDFULL, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_CIDADE, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_ESTADO, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_CEP, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_CONTATO_NOME, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_CONTATO_EMAIL, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_CONTATO_DEPTO, "  
strSQL = strSQL & " tbl_INSCRICAO.FAT_CONTATO_FONE, "  
strSQL = strSQL & " tbl_INSCRICAO.COD_STATUS_PRECO, "  
strSQL = strSQL & " tbl_INSCRICAO.SUFIXO_BOLETO, "  
strSQL = strSQL & " tbl_STATUS_PRECO.STATUS AS STATUS_PRECO," 
strSQL = strSQL & " tbl_STATUS_PRECO.OBSERVACAO AS STATUS_PRECO_OBSERVACAO"  
strSQL = strSQL & " FROM tbl_INSCRICAO INNER JOIN tbl_EMPRESAS ON tbl_INSCRICAO.COD_EMPRESA = tbl_EMPRESAS.COD_EMPRESA " 
strSQL = strSQL & "                    LEFT JOIN tbl_EMPRESAS_SUB ON tbl_INSCRICAO.CODBARRA = tbl_EMPRESAS_SUB.CODBARRA "  
strSQL = strSQL & "                    LEFT JOIN tbl_STATUS_PRECO ON tbl_STATUS_PRECO.COD_STATUS_PRECO = tbl_INSCRICAO.COD_STATUS_PRECO"  
strSQL = strSQL & " WHERE tbl_INSCRICAO.COD_INSCRICAO = "& strCodInscricao
		
    set objRS = objConn.Execute(strSQL)

    If not objRs.EOF then
	  strCOD_EMPRESA = objRS("COD_EMPRESA")&""
	  strNOMECLI = objRS("NOME_COMPLETO")&""
	  strNOMEFAN = objRS("NOME_COMPLETO")&""
	  If strNOMECLI = "" Then
	    strNOMECLI = objRS("NOMECLI")&""
	  End If
	  strENTIDADE = objRS("ENTIDADE")&""
	  strNUMDOC1 = objRS("ID_CPF")&""
	  If strNUMDOC1 = "" Then
	    strNUMDOC1 = objRS("ID_NUM_DOC1")&""
	  End If
      strSENHA = objRS("SENHA")&""
      strCODATIV1 = objRS("CODATIV1")&""
      strENDER   = objRS("END_FULL")&""
      strBAIRRO  = objRS("END_BAIRRO")&""
      strCIDADE  = objRS("END_CIDADE")&""
      strESTADO  = objRS("END_ESTADO")&""
      strCEP     = objRS("END_CEP")&""
	  strDESTINO = objRS("EMAIL1")&""
	  strEMAIL1  = objRS("EMAIL1")&""
	  strEMAIL2  = objRS("EMAIL2")&""
	  strFONE1 = objRS("FONE1")&""
	  strFONE2 = objRS("FONE2")&""
	  strFONE3 = objRS("FONE3")&""
	  strFONE4 = objRS("FONE4")&""
	  strCODBARRA = objRS("CODBARRA")&""
	  strDT_CHEGADAFICHA = objRS("DT_CHEGADAFICHA")
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
	  
	  strSUFIXO_BOLETO = ATHFormataTamLeft(objRS("SUFIXO_BOLETO"),2,"0") 
	  strVALOR_INSCRICAO = FormatNumber(Abs(CalculaSaldo(strCodInscricao))) 
	End If
	strEV_ARIEL_TEXTO = replace(strEV_ARIEL_TEXTO, "<PRO_LINK_BOLETO>",strLinkBoleto)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_NOMEEVENTO>", strEV_NOME)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_CIDADEEVENTO>", strEV_CIDADE)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_DATAATUAL>", DataExtenso(now()) )
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_DATAATUAL_US>", DataExtensoIntl(now(),1033)) 'Ingles (EUA)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_DATAATUAL_FR>", DataExtensoIntl(now(),1036)) 'Francês
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_DATAATUAL_IT>", DataExtensoIntl(now(),1040)) 'Italiano
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_DATAATUAL_ES>", DataExtensoIntl(now(),3082)) 'Espanhol
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_DIAATUAL>", Right("0"&Day(date()),2) )
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_MESATUAL>", Right("0"&Month(date()),2) )
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_ANOATUAL>", Year(date()) )
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_COD_EMPRESA>", strCOD_EMPRESA)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_ID_NUM_DOC1>", strNUMDOC1)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_CPF>", strNUMDOC1)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_NOMECLIENTE>", strNOMECLI)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_NOMECLI>", strNOMECLI)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_NOMEFAN>", strNOMEFAN)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_ENTIDADE>", strENTIDADE)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_EMAIL>", strEMAIL1)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_SENHA>", strSENHA)	
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_INSCRICAO>", strCodInscricao)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_SITEEVENTO>", "<a href='http://" & strEV_SITE & "' target='_blank'>" & strEV_SITE & "</a>")
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_AGENCIATURISMO>", strEV_AGENCIA_TURISMO)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_EMAILEVENTO>", "<a href='mailto:" & strEV_EMAIL & "'>" & strEV_EMAIL & "</a>")
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_FONEEVENTO>", strEV_FONE)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_RODAPE>", strEV_RODAPE)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_VALOR_INSCRICAO>", strVALOR_INSCRICAO)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_STATUS_PRECO>", strSTATUS_PRECO)
	strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_STATUS_PRECO_OBSERVACAO>", strSTATUS_PRECO_OBSERVACAO)

strCAMINHO_IMG = "https://" & Replace(lcase(Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("URL")),"ProShopPF/passo4_.asp","img/")
'Código de barras
strEV_ARIEL_TEXTO = Replace(strEV_ARIEL_TEXTO, "<PRO_BARCODE>", ReturnBarCode39Cli(strCODBARRA,30,1.5,strCAMINHO_IMG,replace(CFG_DB,"_dados","")) )
strLINK = "https://" & Replace(lcase(Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("URL")),"passo4_.asp","default.asp")
if strCategoria <>0 Then
	strCat = "&categoria="&strCategoria
end if


'==========================TEXTO PARA EXIBIR O TEXTO FINAL COM SUBISTITUIÇÃO DE TAGS=================
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_NOMEEVENTO>", strEV_NOME)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_CIDADEEVENTO>", strEV_CIDADE)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_DATAATUAL>", DataExtenso(now()) )
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_DATAATUAL_US>", DataExtensoIntl(now(),1033)) 'Ingles (EUA)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_DATAATUAL_FR>", DataExtensoIntl(now(),1036)) 'Francês
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_DATAATUAL_IT>", DataExtensoIntl(now(),1040)) 'Italiano
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_DATAATUAL_ES>", DataExtensoIntl(now(),3082)) 'Espanhol
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_DIAATUAL>", Right("0"&Day(date()),2) )
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_MESATUAL>", Right("0"&Month(date()),2) )
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_ANOATUAL>", Year(date()) )
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_COD_EMPRESA>", strCOD_EMPRESA)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_ID_NUM_DOC1>", strNUMDOC1)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_SENHA>", strSENHA)	
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_CPF>", strNUMDOC1)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_NOMECLIENTE>", strNOMECLI)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_NOMECLI>", strNOMECLI)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_NOMEFAN>", strNOMEFAN)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_ENTIDADE>", strENTIDADE)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_EMAIL>", strEMAIL1)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_INSCRICAO>", strCodInscricao)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_SITEEVENTO>", "<a href='http://" & strEV_SITE & "' target='_blank'>" & strEV_SITE & "</a>")
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_AGENCIATURISMO>", strEV_AGENCIA_TURISMO)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_EMAILEVENTO>", "<a href='mailto:" & strEV_EMAIL & "'>" & strEV_EMAIL & "</a>")
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_FONEEVENTO>", strEV_FONE)
	'strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_RODAPE>", strEV_RODAPE)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_VALOR_INSCRICAO>", strVALOR_INSCRICAO)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_STATUS_PRECO>", strSTATUS_PRECO)
	strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_STATUS_PRECO_OBSERVACAO>", strSTATUS_PRECO_OBSERVACAO)
	strProshopTextoFinal = replace(strProshopTextoFinal, "<PRO_LINK_BOLETO>",strLinkBoleto)

strCAMINHO_IMG = "https://" & Replace(lcase(Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("URL")),"ProShopPF/passo4_.asp","img/")
'Código de barras
strProshopTextoFinal = Replace(strProshopTextoFinal, "<PRO_BARCODE>", ReturnBarCode39Cli(strCODBARRA,30,1.5,strCAMINHO_IMG,replace(CFG_DB,"_dados","")) )
'===================================================================================================================================



strHTML = strHTML & "<!DOCTYPE html>"&vbnewline
strHTML = strHTML & "<head>"&vbnewline
strHTML = strHTML & "	<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"&vbnewline
strHTML = strHTML & "    <!--meta charset='utf-8'//-->"&vbnewline
strHTML = strHTML & "    <meta name='viewport'    content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>"&vbnewline
strHTML = strHTML & "    <meta name='product'     content='PRO MetroUI  Framework'>"&vbnewline
strHTML = strHTML & "    <meta name='description' content='Simple responsive css framework'>"&vbnewline
strHTML = strHTML & "    <meta name='author' 	 content='Sergey P. - adapted by Aless'>"&vbnewline

strHTML = strHTML & "    <link href='"&strLinkLimpo&"_metroUI/css/metro-bootstrap.css' rel='stylesheet'>"&vbnewline
strHTML = strHTML & "    <link href='"&strLinkLimpo&"_metroUI/css/metro-bootstrap-responsive.css' rel='stylesheet'>"&vbnewline
strHTML = strHTML & "    <link href='"&strLinkLimpo&"_metroUI/css/iconFont.css' rel='stylesheet'>"&vbnewline
strHTML = strHTML & "    <link href='"&strLinkLimpo&"_metroUI/css/docs.css' rel='stylesheet'>"&vbnewline
strHTML = strHTML & "    <link href='"&strLinkLimpo&"_metroUI/js/prettify/prettify.css' rel='stylesheet'>"&vbnewline
strHTML = strHTML & "    <!-- Load JavaScript Libraries -->"&vbnewline
strHTML = strHTML & "    <script src='"&strLinkLimpo&"_metroUI/js/jquery/jquery.min.js'></script>"&vbnewline
strHTML = strHTML & "    <script src='"&strLinkLimpo&"_metroUI/js/jquery/jquery.widget.min.js'></script>"&vbnewline
strHTML = strHTML & "    <script src='"&strLinkLimpo&"_metroUI/js/jquery/jquery.mousewheel.js'></script>"&vbnewline
strHTML = strHTML & "    <script src='"&strLinkLimpo&"_metroUI/js/prettify/prettify.js'></script>"&vbnewline

strHTML = strHTML & "    <!-- PRO  MetroUI  JavaScript plugins -->"&vbnewline
strHTML = strHTML & "    <script src='"&strLinkLimpo&"_metroUI/js/load-metro.js'></script>"&vbnewline

strHTML = strHTML & "    <!-- Local JavaScript -->"&vbnewline
strHTML = strHTML & "    <script src='"&strLinkLimpo&"_metroUI/js/docs.js'></script>"&vbnewline
strHTML = strHTML & "    <script src='"&strLinkLimpo&"_metroUI/js/github.info.js'></script>"&vbnewline

strHTML = strHTML & "    <!-- Tablet Sort -->"&vbnewline
strHTML = strHTML & "	<script src='"&strLinkLimpo&"_metroUI/js/tablesort_metro.js'></script>"&vbnewline

strHTML = strHTML & "    <title>pVISTA ProShopUI</title>"&vbnewline
strHTML = strHTML & "    <style>"&vbnewline
strHTML = strHTML & "        .indent {"&vbnewline
strHTML = strHTML & "            height: 40px;"&vbnewline
strHTML = strHTML & "        }"&vbnewline
strHTML = strHTML & "        .super-menu {"&vbnewline
strHTML = strHTML & "            position: fixed;"&vbnewline
strHTML = strHTML & "            top: 45px;"&vbnewline
strHTML = strHTML & "            left: 0;"&vbnewline
strHTML = strHTML & "            right: 0;"&vbnewline
strHTML = strHTML & "            z-index: 100;"&vbnewline
strHTML = strHTML & "        }"&vbnewline
strHTML = strHTML & "        .page {"&vbnewline
strHTML = strHTML & "            /*padding-top: 130px !important;*/"&vbnewline
strHTML = strHTML & "        }"&vbnewline
strHTML = strHTML & "        .super-menu li {"&vbnewline
strHTML = strHTML & "        }"&vbnewline
strHTML = strHTML & "        .super-menu a {"&vbnewline
strHTML = strHTML & "            text-decoration: underline;"&vbnewline
strHTML = strHTML & "        }"&vbnewline
strHTML = strHTML & "		@media print {"&vbnewline
strHTML = strHTML & "		    -webkit-print-color-adjust: exact;"&vbnewline
strHTML = strHTML & "		}"&vbnewline
strHTML = strHTML & "    </style>"&vbnewline
strHTML = strHTML & "<script language='JavaScript' type='text/javascript' src='"&strLinkLimpo&"proshoppf/_scripts/SiteScripts.js'></script>"&vbnewline
If request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId") <> "" Then 
strHTML = strHTML & "        <!-- Google Tag Manager -->"
strHTML = strHTML & "        <script>"
strHTML = strHTML & "        (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','"&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId")&"');"
strHTML = strHTML & "        </script>"
strHTML = strHTML & "        <!-- End Google Tag Manager -->"
End If 
strHTML = strHTML & "</head>"&vbnewline
strHTML = strHTML & "<body class='metro' style='background-color:#F8F8F8; -webkit-print-color-adjust: exact;'>"&vbnewline
If request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId") <> "" Then
strHTML = strHTML & "<!-- Google Tag Manager (noscript) -->"
strHTML = strHTML & "<noscript><iframe src='https://www.googletagmanager.com/ns.html?id="&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId")&"' height='0' width='0' style='display:none;visibility:hidden'></iframe></noscript>"
strHTML = strHTML & "<!-- End Google Tag Manager (noscript) -->"
End If
strHTML = strHTML & " <!-- INI: HeaderBAR --------------------------------------------------------------------- //-->"&vbnewline
strHTML = strHTML & "<div class='page-footer padding5' style='background-color:#282828;'></div>"&vbnewline
strHTML = strHTML & " <!-- FIM: HeaderBAR --------------------------------------------------------------------- //-->"&vbnewline

strHTML = strHTML & " <!-- INI: PAGE CONTAINER ------------------------------------------------------------- //-->"&vbnewline
strHTML = strHTML & " <div class='page container'> <!-- container-phone | container-tablet | container-large //-->"&vbnewline


strHTML = strHTML & "    <!-- INI: page-header -------------------------------------------------------------- //-->"&vbnewline
strHTML = strHTML & "    <div class='page-header'>"&vbnewline

strHTML = strHTML & "		<!-- INI: LOGO Promotora //-->	"&vbnewline
         If request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_strCabecalhoLoja") <>"" Then 
strHTML = strHTML & "            <div class='grid' style='margin-bottom:35px'>"&vbnewline
strHTML = strHTML & "                 <div class='row'>"&vbnewline
strHTML = strHTML & "                     <div class='span114' style='background-color:#F8F8F8;'><!-- level 1 column //-->"&vbnewline
strHTML = strHTML & "                         <div sclass='row'>"&vbnewline
strHTML = strHTML & "                             <img class='' src='"&strLinkLimpo&"imgdin/"&request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_strCabecalhoLoja")&"' style='margin-bottom:15px;margin-top:15px;background-color:#F8F8F8;'>"&vbnewline
strHTML = strHTML & "                         </div>"&vbnewline
strHTML = strHTML & "                     </div>"&vbnewline
strHTML = strHTML & "                 </div>"&vbnewline
strHTML = strHTML & "            </div>"&vbnewline
         End If 
strHTML = strHTML & "        <!-- FIM: LOGO Promotora //-->"&vbnewline
        

strHTML = strHTML & "		<!-- INI: MENU  //-->"&vbnewline	
strHTML = strHTML & "        <div class='navigation-bar dark'>"&vbnewline
strHTML = strHTML & "                <div class='navbar-content' id='eventBar'>"&vbnewline

strHTML = strHTML & "                    <a href='"&strLINK&"?cod_evento="&strCOD_EVENTO&"&lng="&strLng&strCat&"' class='element'><strong>"&request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_strNomeEvento")&"</strong></a>"&vbnewline
strHTML = strHTML & "                    <div class='no-tablet-portrait place-right'>"&vbnewline
strHTML = strHTML & "                        <!--div class='element input-element' >"&vbnewline
strHTML = strHTML & "                            <form>"&vbnewline
strHTML = strHTML & "                                <div class='input-control text'>"&vbnewline
strHTML = strHTML & "                                    <input type='text' style='background-color:#555555; border:0px; color:#ffffff'>"&vbnewline
strHTML = strHTML & "                                    <button class='btn-search fg-white' ></button>"&vbnewline
strHTML = strHTML & "                                </div>"&vbnewline
strHTML = strHTML & "                            </form>"&vbnewline
strHTML = strHTML & "                    	</div//-->"&vbnewline

strHTML = strHTML & "                        <span class='element-divider place-right'></span>"&vbnewline
strHTML = strHTML & "                    </div>"&vbnewline
strHTML = strHTML & "                </div>"
strHTML = strHTML & "        </div>"&vbnewline
strHTML = strHTML & "		<!-- FIM: MENU  //-->	"&vbnewline

strHTML = strHTML & "	</div> "&vbnewline
strHTML = strHTML & "    <!-- FIM: page-header -------------------------------------------------------------- //--> "&vbnewline


'response.Write(strEV_ARIEL_TEXTO)





'<BR>
'                           Ol&aacute; <b>Rodrigo Brunet.</b><br>
'                            Esta &eacute; sua confirma&ccedil;&atilde;o do pedido para o evento FÓRUM COUROMODA 2019
'							<BR>
'							Lembrete: A CREDENCIAL DA FEIRA da acesso ao Fórum, caso tenha recebido a credencial pelo correio 
'							não é necessário fazer troca, sua vaga ficará reservada até 30 minutos antes do início da palestra, 
'							após este horário as vagas disponíveis serão liberadas para outros interessados. 
'                            <BR><BR>'

'                            <address>
'                                <strong>S&atilde;o Paulo Feiras</strong><br />
'                                Rua Jo&atilde;o Aboutt 319/503<br>
'                                Porto Alegre/RS, Brasil<br>
'                              <abbr title="Phone">P:</abbr> (123) 456-7890
'                           </address>
                    
'                            <address>
'                                <strong>D&uacute;vidas</strong><br>
'                                <a href="mailto:#">atendimento@couromoda.com</a>
'                            </address>


strHTML = strHTML & "    <div class='page-region-content'>"&vbnewline
    
strHTML = strHTML & "        <div class='grid'>"&vbnewline
strHTML = strHTML & "             <div class='row'>"&vbnewline
							
strHTML = strHTML & "						 <!-- INI: 1 COLUNA //-->"&vbnewline
strHTML = strHTML & "                         <div class='span10' style='text-align:left;'>"&vbnewline
strHTML = strHTML &                             strProshopTextoFinal&vbnewline
'strHTML = strHTML & "                            <legend>"&objLang.SearchIndex("resumo_pedido",0)&"</legend>"&vbnewline
'strHTML = strHTML & "                            <div style='display:block; background-color:#EEE; padding:10px;'>"&vbnewline
'strHTML = strHTML & "                                <!-- INI: Bloco produtos //-->"&vbnewline
'strHTML = strHTML & "                                <div class='grid'>"&vbnewline
'strHTML = strHTML & "                                     <div class='row'>"&vbnewline
'strHTML = strHTML & "                                        <div class='tile no-border' style='width:100%; height:auto; margin:0 auto;  text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:5px; border:0px solid #4390DF;'>"&vbnewline
'strHTML = strHTML & "                                            <font size='+1'>"&vbnewline
'strHTML = strHTML & "                                                <!-- <b>Nº 03022018154531</b> //-->"&vbnewline
'strHTML = strHTML & "                                                <font size='+1'>"&vbnewline
'strHTML = strHTML & "					                                <span style='color:#0099CC; font-weight:bold;'>"&strDT_CHEGADAFICHA&"</span>"&vbnewline
'strHTML = strHTML & "					                            </font>"&vbnewline
'strHTML = strHTML & "                                                <br>"&objLang.SearchIndex("inscricoes",0)&" ["&strCodInscricao&"]"&vbnewline
'                                                if strVALOR_INSCRICAO > 0 Then 
'strHTML = strHTML & "                                                    <br><br>"&vbnewline
'strHTML = strHTML & "                                                    "& objLang.SearchIndex("forma_pagamento",0)&vbnewline
'strHTML = strHTML & "                                                    <br>"& strFormaPagamento&vbnewline
'                                                end if
'strHTML = strHTML & "                                            </font>"&vbnewline
'strHTML = strHTML & "                                        </div>"&vbnewline
'strHTML = strHTML & "                                     </div>"&vbnewline
                        
'						strSQL=	" SELECT TBL_PRODUTOS.COD_PROD, GRUPO, TITULO,titulo_intl, DESCRICAO,descricao_intl, OBS, PALESTRANTE, DT_OCORRENCIA, VOUCHER_TEXTO, (VLR_PAGO * QTDE) AS VLR_SUBTOTAL " &_ 
'								" , (SELECT nomecompleto FROM tbl_inscricao where cod_inscricao = tbl_inscricao_produto.cod_inscricao) AS nome_inscricao" &_
'								" FROM TBL_PRODUTOS, TBL_INSCRICAO_PRODUTO " &_
'								" WHERE TBL_PRODUTOS.COD_PROD=TBL_INSCRICAO_PRODUTO.COD_PROD " &_ 
'								"   AND TBL_INSCRICAO_PRODUTO.COD_INSCRICAO = "& strCodInscricao &_
'								"   AND TBL_PRODUTOS.COD_EVENTO = "& strCOD_EVENTO
'						set objRS = objConn.Execute(strSQL)
'						if NOT objRS.eof Then
'						      do while not objRS.EOF
'									if strLng <> "BR" Then 
'										strTitulo = getValue(objRS,"titulo_intl")
'										strDescricao = getValue(objRS,"descricao_intl")
'										'strCategoriaTxt = getValue(objRS,"status_intl")
'									else 
'										strTitulo    = getValue(objRS,"titulo")
'										strDescricao = getValue(objRS,"descricao")
'										'strCategoriaTxt = getValue(objRS,"status")
'									End If 
						
'strHTMLProduto = strHTMLProduto & "                                     <div class='row'>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                        <div class='tile' style='width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:5px; margin-top:5px; border:0px solid #4390DF;'>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                            <font size='+1'>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                                " & strDescricao&vbnewline
'                                                 if getValue(objRS,"vlr_subtotal") > 0 Then
'strHTMLProduto = strHTMLProduto & "                                                <br><span style='color:#0099CC;'>"&getValue(objRS,"vlr_subtotal")&"</span>"&vbnewline
'                                                 else 
'strHTMLProduto = strHTMLProduto & "                                                <br><span style='color:#0099CC;'>"&objLang.SearchIndex("gratuito",0)&"</span>"&vbnewline
'                                                 end if
'strHTMLProduto = strHTMLProduto & "                                            </font><BR>"&vbnewline
                                            
'strHTMLProduto = strHTMLProduto & "                                            <div class='accordion margin10' data-role='accordion' data-closeany='false'>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                                <div class='accordion-frame'>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                                    <a class=' heading bg-active-grayLight fg-darkCyan' href='#'>"&getValue(objRS,"nome_inscricao")&"</a>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                                </div>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                            </div>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                        </div>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                     </div>"&vbnewline
'                     			objRS.MoveNext       
'							 loop
'						end if 
                    '                 <!--div class="row">
                    '                    <div class="tile" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:5px; margin-top:5px; border:0px solid #4390DF;">
                    '                        <font size="+1">
                    '                            Workshop Especial com Tomas Lander
                    '                            <br><span style="color:#0099CC;">1x R$ 96,00</span>
                    '                        </font>
                    '    
                    '                       <div class="accordion margin10" data-role="accordion" data-closeany="false">
                    '                            <div class="accordion-frame">
                    '                                <a class=" heading bg-active-grayLight fg-darkCyan" href="#">Rodrigo Brunet</a>
                    '                            </div>
                    '                        </div>                    
                    '                    </div>
                    '                 </div//-->

'strHTMLProduto = strHTMLProduto & "                                     <div class='row'>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                        <div class='tile' style='width:100%; height:auto; margin:0 auto;  background-color:#CCC; color:#666; text-align:right; padding-top:7px; padding-right:10px; padding-bottom:5px; margin-top:5px; border:0px solid #4390DF;'>"&vbnewline
'                                             if strVALOR_INSCRICAO > 0 Then
'strHTMLProduto = strHTMLProduto & "                                                <font size='+1'>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                                   " & objLang.SearchIndex("total",0)&vbnewline
'strHTMLProduto = strHTMLProduto & "                                                    <br><span style='color:#0099CC; font-weight:bold;'>"&dblValorTotal&"</span>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                                </font>"&vbnewline
'                                             else 
'strHTMLProduto = strHTMLProduto & "                                                <font size='+1'>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                                    <span style='color:#0099CC; font-weight:bold;'>"&objLang.SearchIndex("evento_gratuito",0)&"</span>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                                </font>"&vbnewline
'                                             end if 
'strHTMLProduto = strHTMLProduto & "                                        </div>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                     </div>"&vbnewline
'strHTMLProduto = strHTMLProduto & "                                </div>"&vbnewline           
'strHTMLProduto = strHTMLProduto & "                                <!-- FIM: Bloco produtos //-->"&vbnewline

'strHTMLProduto = strHTMLProduto & "                            </div>"&vbnewline


                           
strHTML = strHTML & "                         </div>"&vbnewline
strHTML = strHTML & "						 <!-- FIM: 1 COLUNA //-->"&vbnewline


strHTMLCol2Ini = strHTMLCol2Ini & "						 <!-- INI: 2 COLUNA //-->"&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "                         <div class='span4'>"&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "                                <div class='row'>"&vbnewline
                                    
                                    
                                    
                                    
                                    
strHTMLCol2Ini = strHTMLCol2Ini & "                                    <div class='tile ' style='width:100%; height:auto; margin:0 auto; margin-bottom:10px; "&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "                                                              background-color:#CCC; color:#666; text-align:right; "&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "                                                              padding-top:7px; padding-right:10px; padding-bottom:25px; border:1px solid #FFF;'>"&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "                                        <font size='+2'><span style='color:#009966;'>"&objLang.SearchIndex("evento",0)&"</span></font>"&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "                                        <br><br>"&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "										<b>"&strEV_NOME&"</b>"&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "                                        <br>"&vbnewline
										 if year(strDtInicio) <> year(strDtFim) Then 
strHTMLCol2Ini = strHTMLCol2Ini & "	                                        "& (objLang.SearchIndex("de",0)) & " " & DAY(strDtInicio) & " ("& objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtInicio)))),0)&")  "& (objLang.SearchIndex("de",0)) & " " & objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtInicio)))),0)&" | "&year(strDtInicio)&" "& (objLang.SearchIndex("a_craseado",0)) & " " &DAY(strDtFim)&" ("&objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtFim)))),0)&") de "& objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtFim)))),0)&" | "&year(strDtFim)&"<br>"&vbnewline
                                  		else if (month(strDtInicio) <> month(strDtFim)) AND year(strDtInicio) = year(strDtFim) Then 
strHTMLCol2Ini = strHTMLCol2Ini & "											"& (objLang.SearchIndex("de",0)) & " " & DAY(strDtInicio) &" ("& objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtInicio)))),0)&")  "& (objLang.SearchIndex("de",0)) & " " &objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtInicio)))),0)&" "& (objLang.SearchIndex("a_craseado",0)) & " " &DAY(strDtFim)&" ("&objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtFim)))),0)&") "& (objLang.SearchIndex("de",0)) & " " & objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtFim)))),0)&" | "&year(strDtFim)&"<br>"&vbnewline
                                         		else 
strHTMLCol2Ini = strHTMLCol2Ini & "											"& (objLang.SearchIndex("de",0)) & " " & DAY(strDtInicio) &" ("& objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtInicio)))),0)&")  "& (objLang.SearchIndex("a_craseado",0)) & " " & DAY(strDtFim) &" ("&objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtFim)))),0)&") " & (objLang.SearchIndex("de",0)) & " " &objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtFim)))),0)&" | "&year(strDtFim)&"<br>"&vbnewline
										 		end if 
										    end if										
                                        if strHrInicio <> "" Then
strHTMLCol2Ini = strHTMLCol2Ini & "											"&strHrInicio&" - "&strHrFim&" ("&objLang.SearchIndex("horario_de_brasilia",0)&")"&vbnewline
                                        end if                                         
strHTMLCol2Ini = strHTMLCol2Ini & "                                    </div>"&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "								</div>"&vbnewline

strHTMLCol2Ini = strHTMLCol2Ini & "                         	<div class='row'>"&vbnewline

strHTMLCol2Ini = strHTMLCol2Ini & "                                <div class='grid'>"&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "                                    <div class='row'>"&vbnewline
strHTMLCol2Ini = strHTMLCol2Ini & "                                            <div class='' style='text-align:left;'>"&vbnewline
												   If request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_strGoogleMapsEvento") <> "" Then 
strHTMLiFrame = strHTMLiFrame & "                                      <iframe src='"&request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_strGoogleMapsEvento")&"' width='100%' height='400' frameborder='0' style='border:0' allowfullscreen></iframe>"&vbnewline
                                                   End If 
strHTMLCol2Fim = strHTMLCol2Fim & "                                                <h3><b>"&strPavilhao&"</b></h3>"&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                                                <p class='tertiary-text-secondary'>"&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                                                    "&strLogradouroEv&"<br>"&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                                                    "&strBairroEv&","&strCidadeEv&" - "&strEstadoEv&", "&strCEPEv&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                                                    <br><br>"&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                                                    <small></small>"&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                                                </p>"&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                                            </div>"&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                                    </div>"&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                                </div>"&vbnewline
strHTMLCol2Fim = strHTMLCol2Fim & "                         </div>"&vbnewline
                         
strHTMLBotoes = strHTMLBotoes & "                         <!-- INI: Botão(es) ... //-->"&vbnewline
strHTMLBotoes = strHTMLBotoes & "                            <div class='row'  style='margin-top:15px;'>"&vbnewline														
strHTMLBotoes = strHTMLBotoes & "                                    <a href='"&strLINK&"?cod_evento="&strCOD_EVENTO&"&lng="&strLng&strCat&"' style='text-decoration:none;'>"&vbnewline
strHTMLBotoes = strHTMLBotoes & "                                    <div style='width:100%; height:40px; cursor:pointer; background-color:#0CF; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;'>"&vbnewline
strHTMLBotoes = strHTMLBotoes & "                                        <font size='+1'><b>"&objLang.SearchIndex("novo_pedido",0)&"</b></font>"&vbnewline
strHTMLBotoes = strHTMLBotoes & "                                    </div>"&vbnewline
strHTMLBotoes = strHTMLBotoes & "                                    </a>"&vbnewline
strHTMLBotoes = strHTMLBotoes & "                            </div>"&vbnewline
strHTMLBotoes = strHTMLBotoes & "                         <!-- FIM: Botão(es) ... //-->"&vbnewline

strHTMLFinal = strHTMLFinal & "						 <!-- FIM: 2 COLUNA //-->"&vbnewline

strHTMLFinal = strHTMLFinal & "             </div>"&vbnewline
strHTMLFinal = strHTMLFinal & "        </div>"&vbnewline
    
strHTMLFinal = strHTMLFinal & "    </div>  <!-- page-region-content //--> "&vbnewline
    
    


strHTMLFinal = strHTMLFinal & " </div> "&vbnewline
%>
 <!-- FIM: PAGE CONTAINER ------------------------------------------------------------- //-->


 <!-- INI: Footer --------------------------------------------------------------------- //-->
 <!-- div class="page-footer padding5" style="background-color:#CCC; color:#FFF"></div //-->
 <%
strHTMLFinal = strHTMLFinal & " </div> <!-- esse div é importante para o efeito de rodapé que transpaça a área de container //-->" 
%>
 <!--#include file="_include/IncludeFooter.asp" -->
 <!-- FIM: Footer --------------------------------------------------------------------- //-->
<%
strFooter = strFooter & "<form name='to_passo1' id='to_passo1' action='to_passo11_.asp' method='post'>"
strFooter = strFooter & "   <input type='hidden' name='cod_evento' value='"&strCOD_EVENTO&"'>"
strFooter = strFooter & "   <input type='hidden' name='lng' value='"&strLng&"'>"
strFooter = strFooter & "   <input type='hidden' name='categoria' value='"&strCategoria&"'>"
strFooter = strFooter & "   <input type='hidden' name='db' value='"&CFG_DB&"'>"
strFooter = strFooter & " </form>"


%>
<!-- AQUI DEVE POSSIVELMENTE DEVERÁ SER COLOCADO O CODIGO DO GOOGLE>
<script language="javascript">
rechear com os codigos que forem enviados
</script//-->


<%
strFooter = strFooter & "</body>"
strFooter = strFooter & "</html>"


'ARIEL EM TELA EXIBE IFRAME MAPA
response.write(strHTML & strHTMLProduto & strHTMLCol2Ini & strHTMLiFrame & strHTMLBotoes  & strHTMLCol2Fim & strHTMLFinal & strFooter)
'strBodyAriel = strHTML & strHTMLProduto & strHTMLCol2Ini & strHTMLBotoes & strHTMLCol2Fim & strHTMLFinal & strFooter

'ATHEnviaMail(pmTO                   , pmFROM            , pmCC, pmBCC, pmSUBJECT , pmBODY      , pmREPLY, pmBODYFORMAT, pmMAILFORMAT, pmATTACH)
AthEnviaMail strDESTINO&";"&strEMAIL2, strEV_EMAIL_SENDER, ""  , ""   , strASSUNTO, strEV_ARIEL_TEXTO, 1      , 0           , 0           , ""



'--------------------------------------------------------------------------------------------------------
' EMAIL PARA SECRETARIA
'---------------------------------------------------------------------------------------------------------
strBody =           ""
strBody = StrBody & "<table width='100%' class='texto'>"
strBody = StrBody & "<tr><td valign='top'>"
strBody = StrBody & "DADOS DE CONFIRMAÇÃO DA INSCRIÇÃO NÚMERO: <b>" &strCodInscricao& "</b>.</div>" & "<br>"
strBody = StrBody & "Data da Inscrição: " &strDT_CHEGADAFICHA & "<br><br>"
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
strBody = StrBody & "Fone 1: " & strFONE4 & "<br>"
strBody = StrBody & "Fone 2: " & strFONE1 & "<br> " 
strBody = StrBody & "Fax: " & strFONE2 & "<br>"
strBody = StrBody & "Celular: " & strFONE3 & "<br>"
strBody = StrBody & "E-mail: " & strEMAIL1 & "<br> "
strBody = StrBody & "E-mail Comercial: " & strEMAIL2 & "<br> "
strBody = StrBody & "Atividade: (" & strCODATIV1 & ") " & strATIVIDADE & "<br> "
strBody = StrBody & "<br> "
strBody = StrBody & "::::::::::::::::::: Dados da Nota Fiscal ::::::::::::::::::::::<br>"
strBody = StrBody & "CPF/CNPJ: "& strFAT_CNPJ & "<br>"

strBody = StrBody & "I.E.: " & strFAT_IE & "<br>"
strBody = StrBody & "Nome do Inscrito: " & strFAT_RAZAO & "<br>"
strBody = StrBody & "Endereço: " & strFAT_ENDFULL & "<br>"
strBody = StrBody & "Cidade: " & strFAT_CIDADE & "<br>"
strBody = StrBody & "Estado: " & strFAT_ESTADO & "<br>"
strBody = StrBody & "CEP: " & strFAT_CEP & "<br> " 
strBody = StrBody & "<br> "
strBody = StrBody & "::::::::::::::::::: Dados para Contato ::::::::::::::::::::::<br>"
strBody = StrBody & "Responsável: "& strFAT_CONTATO_NOME & "<br>"
strBody = StrBody & "E-mail: " & strFAT_CONTATO_EMAIL & "<br>"
strBody = StrBody & "Departamento: " & strFAT_CONTATO_DEPTO & "<br>"
strBody = StrBody & "Telefone: " & strFAT_CONTATO_FONE & "<br>"
strBody = StrBody & "<br> "
strBody = StrBody & "Solicito minha inscrição para: " & "<br>"

strSQL=	" SELECT PROD.TITULO, INSC.COMPLEMENTO, INSC.VLR_PAGO " &_ 
        " FROM TBL_PRODUTOS PROD, TBL_INSCRICAO_PRODUTO INSC" &_
        " WHERE PROD.COD_PROD=INSC.COD_PROD " &_ 
        "   AND INSC.COD_INSCRICAO= "& strCodInscricao
set objRS = objConn.Execute(strSQL)
strVLR_TOTAL = 0
Do While not objRS.EOF
  strBody = StrBody & "  - " & objRS("TITULO")
  
  If objRS("COMPLEMENTO")&"" <> "" Then
    strBody = strBody & " (" & objRS("COMPLEMENTO") & ") "
  End If
  strBody = StrBody & " ($" & FormatNumber(objRS("VLR_PAGO")) & ")<br>"
  
  strVLR_TOTAL = strVLR_TOTAL + objRS("VLR_PAGO")
  objRS.MoveNext
Loop
FechaRecordSet objRS

'strSQL = " UPDATE tbl_INSCRICAO SET COD_FORMAPGTO = " & strCOD_FORMAPGTO & ", PARCELAS = " & strPARCELAS & " WHERE COD_INSCRICAO = " & arrCOD_INSC(i)
'objConn.Execute(strSQL)

'strBody = StrBody & "<br> "
'strBody = StrBody & ":::::::::::::::::: Formas de pagamento ::::::::::::::::::::::::" & "<br>"
'strBody = StrBody & "Forma de Pagamento: (" & strCodFormaPgto & ") " & strFORMAPGTO & " - " & strPARCELAS & " parcela(s)<br>"
'strBody = StrBody & "Status Preço: (" & strCOD_STATUS_PRECO & ") " & strSTATUS_PRECO & "<br>"
'strBody = StrBody & "Valor Total Pago: " & FormatNumber(strVLR_TOTAL) & "<br>"
'strBody = StrBody & ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::" & "<br>"

'Dim strCARTAO
'strCARTAO = ""
'Dados de cartão de crédito digitáveis
'If cstr(strCodFormaPgto) = "9001" Or cstr(strCodFormaPgto) = "9002" Or cstr(strCodFormaPgto) = "9003" Then
'  strCARTAO = strCARTAO & ":::::::::::::::::: Dados Cartão ::::::::::::::::::::::::" & "<br>"
'  strCARTAO = strCARTAO & "Numero Cartão = " & Request("cartao") & "<BR>"
'  strCARTAO = strCARTAO & "Nome Impresso Cartão = " & Request("nome") & "<BR>"
'  strCARTAO = strCARTAO & "Data de Validade = " & Request("validade_mes") & "/" & Request("validade_ano") & "<BR>"
'  strCARTAO = strCARTAO & "Código Segurança = " & Request("codigo") & "<BR>"
'  strCARTAO = strCARTAO & "Bandeira = " & Request("bandeira") & "<BR>"
'  strCARTAO = strCARTAO & ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::" & "<br>"
'  strBody = StrBody & "<BR>" & strCARTAO 
  
'  strSQL = "INSERT INTO tbl_Inscricao_Hist (COD_INSCRICAO, SYS_USERCA, SYS_DATACA, HISTORICO, COD_INSCRICAO_HIST_CATEG) VALUES ("&strCOD_INSC&",'"&strEV_IDUSER_LOJA&"',NOW(),'"&strCARTAO&"',1)"
'  objConn.Execute(strSQL)
'End If


'strSQL = "SELECT SPP.CODIGO, SPP.COD_PROD, SPP.DESCONTO, SPP.VLR_FIXO FROM tbl_Senha_Promo SP, tbl_Senha_Promo_Prod SPP WHERE SP.CODIGO = SPP.CODIGO AND SP.COD_INSCRICAO = " & arrCOD_INSC(i)
strSQL =          " SELECT SP.CODIGO, SPP.COD_PROD, SPP.DESCONTO, SPP.VLR_FIXO "
strSQL = strSQL & "   FROM tbl_Senha_Promo SP LEFT OUTER JOIN tbl_Senha_Promo_Prod SPP ON (SP.CODIGO = SPP.CODIGO)"
strSQL = strSQL & "  WHERE SP.COD_INSCRICAO = " & strCodInscricao
Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
  strBody = StrBody & "<br> "
  strBody = StrBody & ":::::::::::::::::: Promoção ::::::::::::::::::::::::" & "<br>"
  strBody = StrBody & "Senha Promo&ccedil;&atilde;o: " & objRS("CODIGO") & "<br>"
  Do While not objRS.EOF
    If objRS("COD_PROD")&"" <> "" Then
		strBody = StrBody & "Produto: " & objRS("COD_PROD") 
		strCodProd = strCodProd & objRS("COD_PROD") & " | "
		If objRS("VLR_FIXO")<>"" And not isNull(objRS("VLR_FIXO")) Then
		  strBody = StrBody & " - Valor Fixo: " & FormatNumber(objRS("VLR_FIXO")) & "<br>"
		Else
		  strBody = StrBody & " - Desconto: " & objRS("DESCONTO") & "% <br>"
		End If
	
		
		
	
	End If
	objRS.MoveNext
  Loop
  strBody = StrBody & ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::" & "<br>"
End If
FechaRecordSet objRS


strBody = StrBody &	"</td>"
strBody = StrBody &	"</tr>"
strBody = StrBody &	"</table>"

'Response.Write(strBody)
'Response.End()

'--------------------------------------------------------------------------------------------------------
' Chama a função para envio de email para a secretaria do congresso
'--------------------------------------------------------------------------------------------------------

strASSUNTO = "Ficha de Inscrição (" & strCodInscricao & ") - " & strEV_NOME
AthEnviaMail strEV_EMAIL, strEV_EMAIL_SENDER, "", CFG_EMAIL_AUDITORIA_PROEVENTO&";"&CFG_EMAIL_AUDITORIA_CLIENTE, strASSUNTO, strBODY, 1, 0, 0, ""


%>
