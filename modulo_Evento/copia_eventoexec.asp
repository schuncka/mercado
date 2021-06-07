	<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_evento", Session("METRO_USER_ID_USER")), true %>
<%
'------------------------------------------------------------
Dim ObjConn, objRS, strSQL, objRSProd, objRSDetail
Dim strCOD_EVENTO,  strTITULO_EVENTO, strCOD_EVENTO_ORIGEM, strCOD_PROD
Dim flagCopystrMAPEACAMPO,flagCopyPROD,flagCopystrAREAGEO,flagCopyFORMAPAGAMENT,strCOD_FORMAPGTO
Dim flagCopyAREARESTRIEXPO,strCOD_PRODULT,flagCopystrFORMSETUP,flagCopyCOD_EVENTO,flagCopyAUXSERVICOS,strCOD_SERV,strPED_BASICO
Dim strVERBOSE,strLOCATION,strTABLES

strVERBOSE 				= ""
strTABLES 				= ""



strCOD_EVENTO 		 	= Replace(GetParam("var_cod_evento"),"'","''")
strCOD_EVENTO_ORIGEM 	= Replace(GetParam("var_cod_evento_orig"),"'","''")
strTITULO_EVENTO 	 	= Replace(GetParam("var_titulo"),"'","''")
strLOCATION 			= Replace(GetParam("DEFAULT_LOCATION"),"'","''")

flagCopyCOD_EVENTO		= Replace(GetParam("var_flagCpyEvento"),"'","''")
flagCopyPROD			= Replace(GetParam("var_flagCpyProd"),"'","''")
flagCopystrAREAGEO		= Replace(GetParam("var_flagCpyAreageo"),"'","''")
flagCopystrMAPEACAMPO	= Replace(GetParam("var_flagCpyMapeaCampo"),"'","''")
flagCopystrFORMSETUP	= Replace(GetParam("var_flagCpyFormSetup"),"'","''")
flagCopyFORMAPAGAMENT	= Replace(GetParam("var_flagCpyFormPgto"),"'","''")
flagCopyAREARESTRIEXPO	= Replace(GetParam("var_flagCpyAreaRestriExpo"),"'","''")
flagCopyAUXSERVICOS		= Replace(GetParam("var_flagCpyAuxServicos"),"'","''")


'..............................................................................................................
'em aux_servico temos auto incremento apenas no id_auto mas a chave é cod_serv ...
'...entao coloquei um contador antes de inserir para contar o max + 1 e assim poder inserir novo cod serviço
strPED_BASICO = ""
strCOD_SERV = "" 
'..............................................................................................................				 

AbreDBConn objConn, CFG_DB



'------------------------------------------------------------------------------------------------------------------
'- INI: Copia dados da tabela EVENTO ------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------

'busca o cod evento indicado para descubir se ja existe.  
'Se ele já existir , será ignorado e o sistem gerará um novo evento
if flagCopyCOD_EVENTO = "true" then

	strSQL = "SELECT COD_EVENTO FROM TBL_EVENTO WHERE COD_EVENTO = " & strCOD_EVENTO
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
		strSQL =  "SELECT MAX(COD_EVENTO) as PROX_EVENTO FROM TBL_EVENTO WHERE COD_EVENTO not like '999'" 'Cod Original: [WHERE COD_EVENTO <> 999] "
		Set objRS = objConn.Execute(strSQL)
		If not objRS.EOF Then
		  strCOD_EVENTO = GetValue(objRS,"PROX_EVENTO")
		End If
		FechaRecordSet objRS
		If strCOD_EVENTO = "" Then strCOD_EVENTO = 0 End If
		strCOD_EVENTO = strCOD_EVENTO + 1
	End If
	
	strSQL = "INSERT INTO TBL_EVENTO (COD_EVENTO, NOME, NOME_COMPLETO, CABECALHO, RODAPE, SITE, DT_MATERIAL, HR_MATERIAL "
strSQL = strSQL & " 	, PAVILHAO, CIDADE, AGENCIA_TURISMO, AGENCIA_PUBLICIDADE, AGENCIA_BANCARIA, MONTADORA, DT_INICIO, DT_FIM, HORA_INICIO "
strSQL = strSQL & " 	, HORA_FIM, ESTADO_EVENTO, LOGOMARCA, FREE, LOJA_STATUS_PRECO, STATUS_PRECO, STATUS_CRED, EMAIL, EMAIL_SENDER "
strSQL = strSQL & " 	, SYS_INATIVO, ATIVO, CABECALHO_LOJA, RODAPE_LOJA, INSTRUCAO_INSC_EXISTENTE, ARM_TEXTO, ARM_TEXTO_INTL "
strSQL = strSQL & " 	, ACE_TEXTO, ACE_TEXTO_INTL, ACEPRESS_TEXTO, MOD1_TITLE, MOD1_TEXTO, MOD2_TITLE, MOD2_TEXTO "
strSQL = strSQL & " 	, MOD3_TITLE, MOD3_TEXTO, MOD4_TITLE, MOD4_TEXTO, MOD5_TITLE, MOD5_TEXTO, MOD6_TITLE, MOD6_TEXTO "
strSQL = strSQL & " 	, MOD7_TITLE, MOD7_TEXTO, FONE, LOJA_ATIVA, LOJAPJ_ATIVA, MODELO_LOJAPJ, IDUSER_LOJA, RECIBO_TEXTO, CNPJ "
strSQL = strSQL & " 	, COD_MOEDA_EVENTO, COD_MOEDA_COBRANCA, COD_MOEDA_REFERENCIA, LOJA_SHOW_DADOS, LOJA_SHOW_ENTIDADE "
strSQL = strSQL & " 	,  SUBPAPER_ATIVA, STATUS_PRECO_VISITANTE, ATESTADO_TEXTO, CONVITE_TEXTO, CONVITE_VIP_TEXTO, CONVITE_ELETRONICO_TEXTO "
strSQL = strSQL & " 	, CONVITE_ELETRONICO_TEXTO_INTL, APE_TEXTO, APE_TEXTO_INTL, LOJA_SHOW_FINANCEIRO, LOJA_SHOW_FATURAMENTO, ARM_ASSUNTO "
strSQL = strSQL & " 	, ARM_ASSUNTO_INTL, ACE_ASSUNTO, ACE_ASSUNTO_INTL, CABECALHO_RECIBO, CABECALHO_PAPER, RODAPE_PAPER "
strSQL = strSQL & " 	, MOD8_TITLE, MOD8_TEXTO, MOD9_TITLE, MOD9_TEXTO, MOD10_TITLE, MOD10_TEXTO, SMS_USER, SMS_PWD, SMS_TEXTO "
strSQL = strSQL & " 	, COD_GRUPO_EVENTO, PSC_ATIVA, CUPOM_FISCAL, VENDA_RAPIDA, RETIRADA_MATERIAL, LIMITE_IDADE, PSC_STATUS_CRED "
strSQL = strSQL & " 	, SMTP_SERVER, SMTP_USER, SMTP_PWD, INSCR_MUNICIPAL, ENTIDADE_OBRIGATORIO, ACE_ASSUNTO_US, ACE_TEXTO_US, ACE_ASSUNTO_SP "
strSQL = strSQL & " 	, ACE_TEXTO_SP, CERTIFICADO_TEXTO1, CERTIFICADO_TEXTO2, ACEPRESS_TEXTO_US, ACEPRESS_TEXTO_ES, EMAIL_PRESS, APE_ASSUNTO "
strSQL = strSQL & " 	, APE_ASSUNTO_INTL, ACEPRESS_TEXTO_INTL, EMAIL_AUDITORIA, EMAIL_AUDITORIA_INTL, ARIEL_TEXTO, ARIEL_TEXTO_INTL, ARIEL_TEXTO_NPG "
strSQL = strSQL & " 	, LOJA_PESQUISA_CNPJ, PRESS_STATUS_CRED, SMTP_PORT, IMG1, IMG2, PROGRAMACAO, ATESTADO_PDF, ATESTADO_PDF_ORIENTACAO, LOJA_TIPO_LOGIN "
strSQL = strSQL & " 	, DESCRICAO, LOGRADOURO, BAIRRO, PAIS, CRED_PRINT_CONTROLE, BARCODE_MODE, BARCODE_HEIGHT, TP_ACESSO_TOTEM, AVISO_LOJA_INATIVA, LOJA_PESQUISA_CPF, REGULAMENTO_LOJA "
strSQL = strSQL & " 	, REGULAMENTO_LOJA_INTL, EMAIL_REPLY_VISITANTE, EMAIL_REPLY_CONGRESSISTA, EMAIL_REPLY_CAEX, EMAIL_REPLY_PALESTRANTE, EMAIL_REPLY_PAPER, IMPRIMIR_VISITANTE "
strSQL = strSQL & " 	, IMPRIMIR_CONGRESSISTA, BYPASS_CORTESIA, EXTERNAL_API_URL, EXTERNAL_API_PARAM) "
strSQL = strSQL & " (SELECT " &strCOD_EVENTO&", if('"&strTITULO_EVENTO&"'='',NOME,'"&strTITULO_EVENTO&"') "
strSQL = strSQL & " , if('"&strTITULO_EVENTO&"'='',NOME_COMPLETO,'"&strTITULO_EVENTO&"') "
strSQL = strSQL & " , CABECALHO, RODAPE, SITE, DT_MATERIAL, HR_MATERIAL, PAVILHAO, CIDADE, AGENCIA_TURISMO, AGENCIA_PUBLICIDADE, AGENCIA_BANCARIA, MONTADORA "
strSQL = strSQL & " , DT_INICIO, DT_FIM, HORA_INICIO, HORA_FIM, ESTADO_EVENTO, LOGOMARCA, FREE, LOJA_STATUS_PRECO, STATUS_PRECO, STATUS_CRED, EMAIL, EMAIL_SENDER "
strSQL = strSQL & "	, SYS_INATIVO, ATIVO, CABECALHO_LOJA, RODAPE_LOJA, INSTRUCAO_INSC_EXISTENTE, ARM_TEXTO, ARM_TEXTO_INTL, ACE_TEXTO, ACE_TEXTO_INTL, ACEPRESS_TEXTO "
strSQL = strSQL & "	, MOD1_TITLE, MOD1_TEXTO, MOD2_TITLE, MOD2_TEXTO, MOD3_TITLE, MOD3_TEXTO, MOD4_TITLE, MOD4_TEXTO, MOD5_TITLE, MOD5_TEXTO, MOD6_TITLE, MOD6_TEXTO "
strSQL = strSQL & "	, MOD7_TITLE, MOD7_TEXTO, FONE, LOJA_ATIVA, LOJAPJ_ATIVA, MODELO_LOJAPJ, IDUSER_LOJA, RECIBO_TEXTO, CNPJ, COD_MOEDA_EVENTO, COD_MOEDA_COBRANCA, COD_MOEDA_REFERENCIA "
strSQL = strSQL & "	, LOJA_SHOW_DADOS, LOJA_SHOW_ENTIDADE, SUBPAPER_ATIVA, STATUS_PRECO_VISITANTE, ATESTADO_TEXTO, CONVITE_TEXTO, CONVITE_VIP_TEXTO, CONVITE_ELETRONICO_TEXTO, CONVITE_ELETRONICO_TEXTO_INTL "
strSQL = strSQL & "	, APE_TEXTO, APE_TEXTO_INTL, LOJA_SHOW_FINANCEIRO, LOJA_SHOW_FATURAMENTO, ARM_ASSUNTO, ARM_ASSUNTO_INTL, ACE_ASSUNTO, ACE_ASSUNTO_INTL, CABECALHO_RECIBO, CABECALHO_PAPER, RODAPE_PAPER "
strSQL = strSQL & "	, MOD8_TITLE, MOD8_TEXTO, MOD9_TITLE, MOD9_TEXTO, MOD10_TITLE, MOD10_TEXTO, SMS_USER, SMS_PWD, SMS_TEXTO, COD_GRUPO_EVENTO, PSC_ATIVA, CUPOM_FISCAL, VENDA_RAPIDA, RETIRADA_MATERIAL "
strSQL = strSQL & "	, LIMITE_IDADE, PSC_STATUS_CRED, SMTP_SERVER, SMTP_USER, SMTP_PWD, INSCR_MUNICIPAL, ENTIDADE_OBRIGATORIO, ACE_ASSUNTO_US, ACE_TEXTO_US, ACE_ASSUNTO_SP, ACE_TEXTO_SP, CERTIFICADO_TEXTO1 "
strSQL = strSQL & "	, CERTIFICADO_TEXTO2, ACEPRESS_TEXTO_US, ACEPRESS_TEXTO_ES, EMAIL_PRESS, APE_ASSUNTO, APE_ASSUNTO_INTL, ACEPRESS_TEXTO_INTL, EMAIL_AUDITORIA, EMAIL_AUDITORIA_INTL, ARIEL_TEXTO "
strSQL = strSQL & "	, ARIEL_TEXTO_INTL, ARIEL_TEXTO_NPG, LOJA_PESQUISA_CNPJ, PRESS_STATUS_CRED, SMTP_PORT, IMG1, IMG2, PROGRAMACAO, ATESTADO_PDF, ATESTADO_PDF_ORIENTACAO, LOJA_TIPO_LOGIN, DESCRICAO "
strSQL = strSQL & "	, LOGRADOURO, BAIRRO, PAIS, CRED_PRINT_CONTROLE, BARCODE_MODE, BARCODE_HEIGHT, TP_ACESSO_TOTEM, AVISO_LOJA_INATIVA, LOJA_PESQUISA_CPF, REGULAMENTO_LOJA, REGULAMENTO_LOJA_INTL "
strSQL = strSQL & "	, EMAIL_REPLY_VISITANTE, EMAIL_REPLY_CONGRESSISTA, EMAIL_REPLY_CAEX, EMAIL_REPLY_PALESTRANTE, EMAIL_REPLY_PAPER, IMPRIMIR_VISITANTE, IMPRIMIR_CONGRESSISTA, BYPASS_CORTESIA " 
strSQL = strSQL & "	, EXTERNAL_API_URL, EXTERNAL_API_PARAM "
strSQL = strSQL & " FROM tbl_evento WHERE COD_EVENTO = " & strCOD_EVENTO_ORIGEM & ")"
	'athdebug strSQL&"<hr>" , false
	strVERBOSE = strVERBOSE & strSQL&"<hr>"
	strTABLES  = strTABLES & "<li>TBL_EVENTO</li>"	
	objConn.Execute(strSQL)
end if
'------------------------------------------------------------------------------------------------------------------
'- FIM: Copia dados da tabela EVENTO ------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------


'==================================================================================================================
'Area dos checks PRODUTO, AREAGEO, FORMA PGMENTO, MAPEAMENTO_CAMPOS
'==================================================================================================================


'------------------------------------------------------------------------------------------------------------------
'- INI: Copia dados da tabela PRODUTOS ----------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------
if flagCopyPROD = "true" then

	strSQL = "SELECT COD_PROD FROM TBL_PRODUTOS WHERE COD_EVENTO = " & strCOD_EVENTO_ORIGEM
	Set objRSProd = objConn.Execute(strSQL)
	Do While not objRSProd.EOF
		if flagCopyPROD = "true" then
			strSQL = "SELECT MAX(COD_PROD) AS LAST_PROD FROM TBL_PRODUTOS"
				Set objRSDetail = objConn.Execute(strSQL)
				strCOD_PROD = GetValue(objRSDetail,"LAST_PROD")
				FechaRecordSet objRSDetail
				If strCOD_PROD&"" = "" Then	strCOD_PROD = 0	End If
				strCOD_PROD = strCOD_PROD + 1
		End If
		strSQL = "INSERT INTO TBL_PRODUTOS (COD_PROD, COD_EVENTO, GRUPO, TITULO, DESCRICAO, OBS, CAPACIDADE, OCUPACAO, DT_OCORRENCIA, "
		strSQL = strSQL & "DT_TERMINO, COD_PALESTRANTE, SYS_DT_INATIVO, NUM_COMPETIDOR_START, LOCAL, CARGA_HORARIA, LOJA_SHOW, LOJA_EDIT_QTDE, PALESTRANTE,"
		strSQL = strSQL & "CERTIFICADO_TEXTO, DIPLOMA_TEXTO, COD_PROD_VALIDA, EXTRA_INFO_SHOW, EXTRA_INFO_MSG, EXTRA_INFO_REQUERIDO, VOUCHER_TEXTO, CERTIFICADO_PDF, "
		strSQL = strSQL & "CONCURSO, REF_NUMERICA, GRUPO_INTL, TITULO_INTL, DESCRICAO_INTL, IMG, TITULO_MINI, CERTIFICADO_PDF_ORIENTACAO, VOUCHER_TEXTO_US, VOUCHER_TEXTO_ES,"
		strSQL = strSQL & "BGCOLOR, DINAMICA, SINOPSE, GRUPO_SUB, DIPLOMA_PDF, CUPOM_FISCAL,COD_PROD_GRUPO,CERTIFICADO_NRO_PRODUTOS_MIN,CERTIFICADO_CARGA_HORARIA_MIN, " 
		strSQL = strSQL & "CERTIFICADO_COD_PROD_VALIDA,CERTIFICADO_TEXTO_INTL,CERTIFICADO_PDF_INTL,DIPLOMA_TEXTO_INTL,DIPLOMA_PDF_INTL,EXTRA_INFO_2_SHOW, "
		strSQL = strSQL & "EXTRA_INFO_2_MSG,EXTRA_INFO_2_REQUERIDO,EXTRA_INFO_2_TIPO,EXTRA_INFO_3_SHOW,EXTRA_INFO_3_MSG,EXTRA_INFO_3_REQUERIDO,EXTRA_INFO_3_TIPO,EXTRA_INFO_4_SHOW, "
		strSQL = strSQL & "EXTRA_INFO_4_MSG,EXTRA_INFO_4_REQUERIDO,EXTRA_INFO_4_TIPO,CERTIFICADO_VINCULO_COD_QUESTIONARIO,CERTIFICADO_DT_RETIRADA_MATERIAL,ACESSO_UNICO) "
		strSQL = strSQL & "SELECT "& strCOD_PROD &", "&strCOD_EVENTO&", GRUPO, TITULO, DESCRICAO, OBS, CAPACIDADE, OCUPACAO, DT_OCORRENCIA, DT_TERMINO, COD_PALESTRANTE, "
		strSQL = strSQL & "SYS_DT_INATIVO, NUM_COMPETIDOR_START, LOCAL, CARGA_HORARIA, LOJA_SHOW, LOJA_EDIT_QTDE, PALESTRANTE, CERTIFICADO_TEXTO, DIPLOMA_TEXTO, COD_PROD_VALIDA, "
		strSQL = strSQL & "EXTRA_INFO_SHOW, EXTRA_INFO_MSG, EXTRA_INFO_REQUERIDO, VOUCHER_TEXTO, CERTIFICADO_PDF, CONCURSO, REF_NUMERICA, GRUPO_INTL, TITULO_INTL, DESCRICAO_INTL, "
		strSQL = strSQL & "IMG, TITULO_MINI, CERTIFICADO_PDF_ORIENTACAO, VOUCHER_TEXTO_US, VOUCHER_TEXTO_ES, BGCOLOR, DINAMICA, SINOPSE, GRUPO_SUB, DIPLOMA_PDF, "
		strSQL = strSQL & "CUPOM_FISCAL ,COD_PROD_GRUPO,CERTIFICADO_NRO_PRODUTOS_MIN,CERTIFICADO_CARGA_HORARIA_MIN, " 
		strSQL = strSQL & "CERTIFICADO_COD_PROD_VALIDA,CERTIFICADO_TEXTO_INTL,CERTIFICADO_PDF_INTL,DIPLOMA_TEXTO_INTL,DIPLOMA_PDF_INTL,EXTRA_INFO_2_SHOW, "
		strSQL = strSQL & "EXTRA_INFO_2_MSG,EXTRA_INFO_2_REQUERIDO,EXTRA_INFO_2_TIPO,EXTRA_INFO_3_SHOW,EXTRA_INFO_3_MSG,EXTRA_INFO_3_REQUERIDO,EXTRA_INFO_3_TIPO,EXTRA_INFO_4_SHOW, "
		strSQL = strSQL & "EXTRA_INFO_4_MSG,EXTRA_INFO_4_REQUERIDO,EXTRA_INFO_4_TIPO,CERTIFICADO_VINCULO_COD_QUESTIONARIO,CERTIFICADO_DT_RETIRADA_MATERIAL,ACESSO_UNICO FROM TBL_PRODUTOS WHERE COD_PROD = " & GetValue(objRSProd,"COD_PROD")
		'athdebug strSQL&"<hr>" , false
		strVERBOSE = strVERBOSE & strSQL&"<hr>"
		objConn.Execute(strSQL)
		objRSProd.MoveNext
	Loop
	strTABLES  = strTABLES & "<li>TBL_PRODUTOS</li>"	


	
end if
'------------------------------------------------------------------------------------------------------------------
'- INI: Copia dados da tabela PRODUTOS ----------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------


'------------------------------------------------------------------------------------------------------------------
'- INI: Copia dados da tabela AREA GEO ----------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------
if flagCopystrAREAGEO = "true" then
    'AREA GEO
	strSQL = "INSERT INTO tbl_areageo (Nome_AreaGeo, Cod_Evento)"
	strSQL = strSQL & "SELECT Nome_AreaGeo, " & strCOD_EVENTO & " FROM tbl_areageo where cod_Evento = " & strCOD_EVENTO_ORIGEM
	'athdebug strSQL&"<hr>" , false	
	strVERBOSE = strVERBOSE & strSQL&"<hr>"
	strTABLES  = strTABLES & "<li>tbl_areageo</li>"		
	objConn.Execute(strSQL)

	'AREA GEO CEP
	strSQL = "INSERT INTO tbl_areageo_cep (id_areageo, cep_ini, cep_fim, id_pais) "
	strSQL = strSQL & "SELECT a2.id_areageo, ac.cep_ini, ac.cep_fim, ac.id_pais "
	strSQL = strSQL & "  FROM tbl_areageo a "
	strSQL = strSQL & " INNER JOIN tbl_areageo_cep ac ON a.id_areageo = ac.id_areageo "
	strSQL = strSQL & "  LEFT JOIN tbl_areageo a2 ON a.nome_Areageo = a2.nome_areageo AND a2.cod_Evento = " & strCOD_EVENTO
	strSQL = strSQL & " WHERE a2.id_areageo IS NOT NULL "
	strSQL = strSQL & "   AND A.COD_EVENTO = " & strCOD_EVENTO_ORIGEM
	'athdebug strSQL&"<hr>" , false
	strVERBOSE = strVERBOSE & strSQL&"<hr>"
	strTABLES  = strTABLES & "<li>tbl_areageo_cep</li>"	
    objConn.Execute(strSQL)
end if
'------------------------------------------------------------------------------------------------------------------
'- FIM: Copia dados da tabela AREA GEO ----------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------


'------------------------------------------------------------------------------------------------------------------
'- INI: Copia dados da tabela MAPEMANETO CAMPO --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------
if flagCopystrMAPEACAMPO = "true" then

    strSQL = "INSERT INTO TBL_MAPEAMENTO_CAMPO"
    strSQL = strSQL & " (NOME_CAMPO_CLIENTE, NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, COD_evento "
    strSQL = strSQL & " , LOJA_SHOW, CAMPO_COMBOLIST, CAMPO_REQUERIDO,CAMPO_COR_DESTAQUE "
    strSQL = strSQL & " , CAMPO_TIPO, TIPO, NOME_DESCRITIVO_US "
    strSQL = strSQL & " , NOME_DESCRITIVO_ES, VINCULADO_ENTIDADE, CAMPO_INSTRUCAO, TIPOPESS, INCLUIR_BUSCA, ORDEM, CAMPO_TAMANHO, CAMPO_EXTENSAO) "
    strSQL = strSQL & " SELECT NOME_CAMPO_CLIENTE, NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO," & strCOD_EVENTO
    strSQL = strSQL & " ,LOJA_SHOW, CAMPO_COMBOLIST, CAMPO_REQUERIDO,CAMPO_COR_DESTAQUE "
    strSQL = strSQL & " ,CAMPO_TIPO, TIPO, NOME_DESCRITIVO_US "
    strSQL = strSQL & " ,NOME_DESCRITIVO_ES, VINCULADO_ENTIDADE, CAMPO_INSTRUCAO,TIPOPESS,INCLUIR_BUSCA,ORDEM,CAMPO_TAMANHO,CAMPO_EXTENSAO "
    strSQL = strSQL & " FROM TBL_MAPEAMENTO_CAMPO WHERE COD_evento = " & strCOD_EVENTO_ORIGEM
	'athdebug strSQL&"<hr>" , false
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_MAPEAMENTO_CAMPO</li>"	
    objConn.Execute(strSQL)

    strSQL = "INSERT INTO TBL_MAPEAMENTO_CAMPO_INSCRICAO"
    strSQL = strSQL & " (NOME_CAMPO_CLIENTE, NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, COD_evento "
    strSQL = strSQL & " , LOJA_SHOW, CAMPO_COMBOLIST, CAMPO_REQUERIDO,CAMPO_COR_DESTAQUE) "
    strSQL = strSQL & " SELECT NOME_CAMPO_CLIENTE, NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, " & strCOD_EVENTO
    strSQL = strSQL & " ,LOJA_SHOW, CAMPO_COMBOLIST, CAMPO_REQUERIDO,CAMPO_COR_DESTAQUE "
	strSQL = strSQL & " FROM TBL_MAPEAMENTO_CAMPO_INsCRICAO WHERE COD_evento = " & strCOD_EVENTO_ORIGEM
	'athdebug strSQL&"<hr>" , false
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_MAPEAMENTO_CAMPO_INSCRICAO</li>"	
	objConn.Execute(strSQL)
end if
'------------------------------------------------------------------------------------------------------------------
'- FIM: Copia dados da tabela MAPEMANETO CAMPO --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------



'------------------------------------------------------------------------------------------------------------------
'- INI: Copia dados da tabela FORMULARIO SETUP --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------
IF flagCopystrFORMSETUP = "true" then

	strSQL = "INSERT INTO tbl_formulario_setup"
	strSQL = strSQL & " (CAMPO,REQUERIDO,REQUERIDO_COD_PAIS,TABELA,FORMULARIO,cod_evento,ETAPA,VINCULADO_ENTIDADE,ORDEM, OCULTAR)"
	strSQL = strSQL & "  select CAMPO,REQUERIDO,REQUERIDO_COD_PAIS,TABELA,FORMULARIO,"&strCOD_EVENTO&",ETAPA,VINCULADO_ENTIDADE,ORDEM, OCULTAR "
	strSQL = strSQL & "	 FROM tbl_formulario_setup WHERE COD_EVENTO =" & strCOD_EVENTO_ORIGEM
	'athdebug strSQL&"<hr>" , false
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>tbl_formulario_setup</li>"	
	objConn.Execute(strSQL)
end if
'------------------------------------------------------------------------------------------------------------------
'- FIM: Copia dados da tabela FORMULARIO SETUP --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------	



'------------------------------------------------------------------------------------------------------------------
'- INI: Copia dados da tabela FORMA DE PGTO --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------	
IF flagCopyFORMAPAGAMENT = "true" then

'strSQL = "SELECT COD_FORMAPGTO FROM tbl_evento_formapgto WHERE COD_EVENTO = " & strCOD_EVENTO_ORIGEM
'	Set objRS = objConn.Execute(strSQL)
'	If not objRS.EOF Then
'		strSQL =  "SELECT MAX(COD_FORMAPGTO) as PROX_FORMAPGTO FROM tbl_evento_formapgto WHERE COD_FORMAPGTO <> 999" 'Cod Original: [WHERE COD_EVENTO <> 999] "
'		Set objRS = objConn.Execute(strSQL)
'		If not objRS.EOF Then
'		  strCOD_FORMAPGTO = GetValue(objRS,"PROX_FORMAPGTO")
'		End If
'		FechaRecordSet objRS
'		If strCOD_FORMAPGTO = "" Then strCOD_FORMAPGTO = 0 End If
'		strCOD_FORMAPGTO = strCOD_FORMAPGTO + 1
'	End If
'	'athdebug strCOD_EVENTO_ORIGEM&"<hr>" , TRUE

	strSQL = "INSERT INTO tbl_evento_formapgto(COD_EVENTO,COD_FORMAPGTO,COD_PAIS,ID_LOJA,AGENCIA,CONTA,CEDENTE,CARTEIRA,GERENTE "
	strSQL = strSQL & ", CNPJ,RAZAO_SOCIAL,PARCELAS,INSTRUCOES,VALOR_MIN,VALOR_MAX,COD_CONTRATO,EXIBIR_LOJA,DT_LIMITE_VCTO "
	strSQL = strSQL & ", DV_AGENCIA,DV_CONTA,ASSINATURA,COD_MOEDA_COBRANCA,ARIEL,ARIEL_ASSUNTO,VALOR_TAXA,PARCELA_VLR_MINIMO "
	strSQL = strSQL & ", CAPTURA,CABECALHO,ARIEL_INTL,ARIEL_INTL_ASSUNTO,NUM_DIAS_VCTO,TIPO,RODAPE,ENDERECO,CONTROLE_FINALIZAR_COMPRA )"
	strSQL = strSQL & "  SELECT "&strCOD_EVENTO&",COD_FORMAPGTO,COD_PAIS,ID_LOJA,AGENCIA,CONTA,CEDENTE,CARTEIRA,GERENTE,CNPJ,RAZAO_SOCIAL,PARCELAS "
	strSQL = strSQL & ", INSTRUCOES,VALOR_MIN,VALOR_MAX,COD_CONTRATO,EXIBIR_LOJA,DT_LIMITE_VCTO "
	strSQL = strSQL & ", DV_AGENCIA,DV_CONTA,ASSINATURA,COD_MOEDA_COBRANCA,ARIEL,ARIEL_ASSUNTO,VALOR_TAXA, "
	strSQL = strSQL & " PARCELA_VLR_MINIMO,CAPTURA,CABECALHO,ARIEL_INTL,ARIEL_INTL_ASSUNTO,NUM_DIAS_VCTO,TIPO,RODAPE,ENDERECO,CONTROLE_FINALIZAR_COMPRA "
	strSQL = strSQL & "FROM tbl_evento_formapgto WHERE COD_EVENTO = " & strCOD_EVENTO_ORIGEM
	'athdebug strSQL&"<hr>" , false
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>tbl_evento_formapgto</li>"	
	objConn.Execute(strSQL)
end if
'------------------------------------------------------------------------------------------------------------------
'- FIM: Copia dados da tabela FORMA DE PGTO --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------	



'------------------------------------------------------------------------------------------------------------------
'- INI: Copia dados da tabela AREA RESTRITA EXPOSITOR --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------	
IF flagCopyAREARESTRIEXPO = "true" then
	strSQL =  "INSERT INTO tbl_area_restrita_expositor (COD_EVENTO,LANG,DT_INI,DT_FIM,EMAIL_AUDITORIA_CAEX,CONVITE_ELETRONICO_TEXTO,CONVITE_VIP_TEXTO, "
    strSQL = strSQL & "CABECALHO_FORM,RODAPE_FORM,SYS_INATIVO,DT_LIMITE_PGTO,APRESENTACAO,APRESENTACAO_INTL,ENVIA_EMAIL_MONTADORA) "
	strSQL = strSQL & " SELECT "&strCOD_EVENTO&",LANG,DT_INI,DT_FIM,EMAIL_AUDITORIA_CAEX,CONVITE_ELETRONICO_TEXTO,CONVITE_VIP_TEXTO, "
    strSQL = strSQL & "CABECALHO_FORM,RODAPE_FORM,SYS_INATIVO,DT_LIMITE_PGTO,APRESENTACAO,APRESENTACAO_INTL,ENVIA_EMAIL_MONTADORA "
	strSQL = strSQL & "FROM tbl_area_restrita_expositor WHERE COD_EVENTO = " & strCOD_EVENTO_ORIGEM
	'athdebug strSQL&"<hr>" , false
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>tbl_area_restrita_expositor</li>"	
	objConn.Execute(strSQL)
end if
'------------------------------------------------------------------------------------------------------------------
'- FIM: Copia dados da tabela FORMA DE PGTO --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------	




'------------------------------------------------------------------------------------------------------------------
'- INI: Copia dados da tabela  --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------	
IF flagCopyAUXSERVICOS = "true" then
	'
'	strSQL = "SELECT COD_SERV FROM tbl_aux_servicos WHERE COD_EVENTO = " & strCOD_EVENTO_ORIGEM
'	Set objRS = objConn.Execute(strSQL)
'	If not objRS.EOF Then
'		strSQL =  "SELECT MAX(COD_SERV) as PROX_SERV FROM tbl_aux_servicos WHERE COD_SERV <> 999" 'Cod Original: [WHERE COD_EVENTO <> 999] "
'		Set objRS = objConn.Execute(strSQL)
'		If not objRS.EOF Then
'		  strCOD_SERV = GetValue(objRS,"PROX_SERV")
'		End If
'		FechaRecordSet objRS
'		if strPED_BASICO = "" then strPED_BASICO = 0 end if 
'		If strCOD_SERV = "" Then strCOD_SERV = 0 End If
'		strCOD_SERV = strCOD_SERV + 1
'	End If
'	'athdebug strCOD_EVENTO_ORIGEM&"<hr>" , TRUE
	
	strSQL =  "INSERT INTO tbl_aux_servicos (COD_SERV,COD_EVENTO,GRUPO,TITULO,DESCRICAO,OBS,QTDE,SYS_DT_INATIVO "
	strSQL = strSQL & ",LOJA_SHOW,LOJA_EDIT_QTDE,TRIBUTADO,TITULO_INTL,PRC_LISTA "
	strSQL = strSQL & ",PRC_LISTA_INTL,EMITE_CREDENCIAL,BASICO,COD_STATUS_PRECO,REF_UNIDADE "
	strSQL = strSQL & ",EXTRA_INFO_SHOW,EXTRA_INFO_MSG,EXTRA_INFO_REQUERIDO,IMG,EXTRA_INFO_MSG_INTL "
	strSQL = strSQL & ",CONTATO_COD_STATUS_CRED,EXTRA_INFO_LIMITE,FATOR_REF_NUMERICA,EXTRA_INFO_TIPO "
	strSQL = strSQL & ",EXTRA_INFO_VALOR, QTDE_LIMITE_MAX) "
	strSQL = strSQL & "	SELECT COD_SERV,"&strCOD_EVENTO&",GRUPO,TITULO,DESCRICAO,OBS,QTDE,SYS_DT_INATIVO "
	strSQL = strSQL & ",LOJA_SHOW,LOJA_EDIT_QTDE,TRIBUTADO,TITULO_INTL,PRC_LISTA "
	strSQL = strSQL & ",PRC_LISTA_INTL,EMITE_CREDENCIAL,BASICO,COD_STATUS_PRECO,REF_UNIDADE "
	strSQL = strSQL & ",EXTRA_INFO_SHOW,EXTRA_INFO_MSG,EXTRA_INFO_REQUERIDO,IMG,EXTRA_INFO_MSG_INTL "
	strSQL = strSQL & ",CONTATO_COD_STATUS_CRED,EXTRA_INFO_LIMITE,FATOR_REF_NUMERICA,EXTRA_INFO_TIPO, QTDE_LIMITE_MAX "
	strSQL = strSQL & ",EXTRA_INFO_VALOR FROM tbl_aux_servicos WHERE COD_EVENTO = " & strCOD_EVENTO_ORIGEM
	'athdebug strSQL&"<hr>" , false
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>tbl_aux_servicos</li>"	
	objConn.Execute(strSQL)
end if
'------------------------------------------------------------------------------------------------------------------
'- FIM: Copia dados da tabela FORMA DE PGTO --------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------	

'==========================FIM AREA CHECKS====================================================================
%>

<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
        <div class="padding20">
            <h1><i class="icon-copy fg-black on-right on-left"></i>Event Copy</h1>
            <h2>Copia de Evento <%=strCOD_EVENTO_ORIGEM%></h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:400px; overflow:scroll; overflow-x:hidden;">
                	<p>O sistema processou a cópia do Evento <strong><%=strCOD_EVENTO_ORIGEM%></strong>, gerando o evento <strong><%=strCOD_EVENTO%></strong>. As tabelas envolvidas nesta cópia foram:</p>
                    <ul><%=ucase(strTABLES)%></ul>
                	<p>Abaixo segue, como informação técnica, o LOG de execução de script SQL relativos as tabelas copiadas:</p>
					<hr />
					<%=ucase(strVERBOSE)%>
                </div>
                <hr>
                <div><form id="" action="<%=strLOCATION&"?var_chavereg="&strCOD_EVENTO%>"> 
                <input class="primary" type="submit" name="btRun" value="OK" />
                </form></div>
                <br>
        </div>
</div>
</body>
</html>


<%
'athdebug "<hr> [FIM]" , true
'response.Redirect(strLOCATION)

'FechaRecordSet ObjRS
FechaDBConn ObjConn
%>