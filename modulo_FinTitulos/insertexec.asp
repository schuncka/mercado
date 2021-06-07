<!--#include file="../_database/athdbConnCS.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtilsCS.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn
Dim strDT_AGORA, strMSG
Dim Cont, Desloc
Dim strRETORNO, strCODIGO, strTIPO, strTIPO_CONTA, strCOD_CONTA, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA
Dim strNUM_DOCUMENTO, strVLR_DOCUMENTO, strTIPO_DOCUMENTO, strDT_EMISSAO, strDT_VCTO_Orig, strDT_VCTO
Dim strHISTORICO, strOBS, strFREQUENCIA, strPARCELAS, strCOD_GRUPO, strPAGAR_RECEBER, strINTERVALO
Dim strSYS_DT_CRIACAO, strTITLE
Dim strCOD_CONTA_PAGAR_RECEBER, strCOD_NF, strNUM_NF, strARQUIVO_ANEXO
Dim strJSCRIPT_ACTION, strLOCATION
	
	strTIPO_CONTA		= GetParam("var_tipo_conta")
	strCOD_CONTA		= GetParam("var_cod_conta")
	strCODIGO			= GetParam("var_codigo")
	strTIPO				= GetParam("var_tipo")
	strCOD_CENTRO_CUSTO	= GetParam("var_cod_centro_custo")
	strCOD_PLANO_CONTA	= GetParam("var_cod_plano_conta")
	strTIPO_DOCUMENTO	= GetParam("var_documento")
	strNUM_DOCUMENTO	= GetParam("var_num_documento")
	strVLR_DOCUMENTO	= GetParam("var_vlr_conta")
	strDT_EMISSAO		= GetParam("var_dt_emissao")
	strDT_VCTO			= GetParam("var_dt_vcto")
	strHISTORICO		= GetParam("var_historico")
	strOBS				= GetParam("var_obs")
	strFREQUENCIA		= GetParam("var_frequencia")
	strPARCELAS			= GetParam("var_parcelas")
	strCOD_NF			= GetParam("var_cod_nf")
	strNUM_NF			= GetParam("var_num_nf")
	strARQUIVO_ANEXO	= GetParam("var_arquivo_anexo")
	strJSCRIPT_ACTION	= GetParam("JSCRIPT_ACTION")
	strLOCATION			= GetParam("DEFAULT_LOCATION")
	
	If Not IsNumeric(strVLR_DOCUMENTO) Then strVLR_DOCUMENTO = ""
	If Not IsDate(strDT_EMISSAO) Then strDT_EMISSAO = ""
	If Not IsDate(strDT_VCTO) Then strDT_VCTO = ""
	If IsEmpty(strCOD_NF) Then strCOD_NF = "Null"
	If IsEmpty(strNUM_NF) Then strNUM_NF = ""
	
	strMSG = ""
	If (strTIPO_CONTA <> "PG") And (strTIPO_CONTA <> "RC") Then strMSG = strMSG & "Parâmetro inválido para tipo de conta<br>"
	If (strCOD_CONTA = "") Then 					strMSG = strMSG & "Parâmetro inválido para conta<br>"
	If (strCODIGO = "") Or (strTIPO = "") Then 		strMSG = strMSG & "Informar entidade<br>"
	If (strCOD_CENTRO_CUSTO = "") Then 				strMSG = strMSG & "Informar centro de custo<br>"
	If (strCOD_PLANO_CONTA = "") Then 				strMSG = strMSG & "Informar plano de conta<br>"
	If (strTIPO_DOCUMENTO = "") Then 				strMSG = strMSG & "Informar tipo do documento<br>"
	If (strNUM_DOCUMENTO = "") Then 				strMSG = strMSG & "Informar número do documento<br>"
	If (strVLR_DOCUMENTO = "") Or (strVLR_DOCUMENTO <= 0) Then strMSG = strMSG & "Informar valor do documento<br>"
	If (strDT_EMISSAO = "") Then 					strMSG = strMSG & "Informar data de emissão do documento<br>"
	If (strDT_VCTO = "") Then 						strMSG = strMSG & "Informar data de vencimento do documento<br>"
	If (strHISTORICO = "") Then 					strMSG = strMSG & "Informar histórico<br>"
	
	If strMSG <> "" Then 
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	'-----------------------------
	'Inicializações
	'-----------------------------
	strPAGAR_RECEBER = "True"
	strTITLE = "Conta a Pagar "
	if strTIPO_CONTA = "RC" then 
		strPAGAR_RECEBER = "False" 
		strTITLE = "Conta a Receber "
	end if 
	
	strDT_VCTO_Orig = strDT_VCTO
	strDT_VCTO    = "'" & PrepDataBrToUni(strDT_VCTO, False) & "'"
	strDT_EMISSAO = "'" & PrepDataBrToUni(strDT_EMISSAO, False) & "'"
	strDT_AGORA   = "'" & PrepDataBrToUni(Now, True) & "'"
	
	If strVLR_DOCUMENTO <> 0 Then
		strVLR_DOCUMENTO = FormatNumber(strVLR_DOCUMENTO, 2) 
		strVLR_DOCUMENTO = Replace(strVLR_DOCUMENTO,".","")
		strVLR_DOCUMENTO = Replace(strVLR_DOCUMENTO,",",".")
	End If
	
	'-------------------------------------------------------------
	'Se for imagem faz a redução do arquivo enviado como anexo
	'-------------------------------------------------------------
	If strARQUIVO_ANEXO <> "" Then
		If UCase(Right(strARQUIVO_ANEXO, 3)) = "JPG" Or UCase(Right(strARQUIVO_ANEXO, 4)) = "JPEG" Then
			'ReduzirImagem "../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/FIN_Titulos/", strARQUIVO_ANEXO, 1000
		End If
	End If
	
	'--------------------------------------------------------
	'Gera código de agrupamento se existirão contas irmãs
	'--------------------------------------------------------
	strCOD_GRUPO = ""
	If (strFREQUENCIA <> "") Then strCOD_GRUPO = GerarSenha(5, 1)
	
	'-----------------------------
	'Insere dados da conta 
	'-----------------------------
	auxStr = ""
	if (cInt(strPARCELAS) > 1) then
	  auxStr = " (parc 1/" & strPARCELAS & ")"
	end if
	strSQL =          " INSERT INTO FIN_CONTA_PAGAR_RECEBER ( PAGAR_RECEBER, COD_GRUPO, TIPO, CODIGO, COD_CONTA, COD_PLANO_CONTA, COD_CENTRO_CUSTO "
	strSQL = strSQL & "                                     , HISTORICO, OBS, TIPO_DOCUMENTO, NUM_DOCUMENTO, DT_EMISSAO, DT_VCTO, VLR_CONTA, VLR_CONTA_ORIG "
	strSQL = strSQL & "                                     , SITUACAO, MARCA_NFE, COD_NF, NUM_NF, ARQUIVO_ANEXO, SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) "
	strSQL = strSQL & " VALUES ( " & strPAGAR_RECEBER & ", '" & strCOD_GRUPO & "', '" & strTIPO & "', " & strCODIGO & ", " & strCOD_CONTA & ", " & strCOD_PLANO_CONTA & ", " & strCOD_CENTRO_CUSTO 
	strSQL = strSQL & "        , '" & strHISTORICO & "', '" & strOBS & "', '" & strTIPO_DOCUMENTO & "', '" & strNUM_DOCUMENTO & auxStr & "', " & strDT_EMISSAO & ", " & strDT_VCTO & ", " & strVLR_DOCUMENTO & ", " & strVLR_DOCUMENTO
	strSQL = strSQL & "        , 'ABERTA', 'SEM_NFE', " & strCOD_NF & ", '" & strNUM_NF & "', '" & strARQUIVO_ANEXO & "', " & strDT_AGORA & ", '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' ) "

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_TITULOS.InsertLcto_Exec A: " & Err.Number & " - "& Err.Description , strLOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	'--------------------------------------
	'Define parâmetros da periodicidade
	'--------------------------------------
	strINTERVALO = ""
	If strFREQUENCIA = "DIARIA"     Then strINTERVALO = "D"
	If strFREQUENCIA = "SEMANAL"    Then strINTERVALO = "WW"
	If strFREQUENCIA = "QUINZENAL"  Then strINTERVALO = "WW" 'WW x 2
	If strFREQUENCIA = "MENSAL"     Then strINTERVALO = "M"
	If strFREQUENCIA = "BIMESTRAL"  Then strINTERVALO = "M" 'M x 2
	If strFREQUENCIA = "TRIMESTRAL" Then strINTERVALO = "Q"
	If strFREQUENCIA = "SEMESTRAL"  Then strINTERVALO = "Q" 'Q x 2
	If strFREQUENCIA = "ANUAL"      Then strINTERVALO = "YYYY"
	
	Desloc = 1
	If strFREQUENCIA = "QUINZENAL"  Then Desloc = 2
	If strFREQUENCIA = "BIMESTRAL"  Then Desloc = 2
	If strFREQUENCIA = "SEMESTRAL"  Then Desloc = 2
	
	'-----------------------------
	'Insere demais contas 
	'-----------------------------
	For Cont = 1 To strPARCELAS-1
	    auxStr = " (parc " & Cont+1 & "/" & strPARCELAS & ")"
		strDT_VCTO = "'" & PrepDataBrToUni(DateAdd(strINTERVALO, Desloc * Cont, strDT_VCTO_Orig), False) & "'"
		
		strSQL =          " INSERT INTO FIN_CONTA_PAGAR_RECEBER ( PAGAR_RECEBER, COD_GRUPO, TIPO, CODIGO, COD_CONTA, COD_PLANO_CONTA, COD_CENTRO_CUSTO "
		strSQL = strSQL & "                                     , HISTORICO, OBS, TIPO_DOCUMENTO, NUM_DOCUMENTO, DT_EMISSAO, DT_VCTO, VLR_CONTA, VLR_CONTA_ORIG "
		strSQL = strSQL & "                                     , SITUACAO, MARCA_NFE, COD_NF, ARQUIVO_ANEXO, SYS_DT_CRIACAO, SYS_COD_USER_CRIACAO ) "
		strSQL = strSQL & " VALUES ( " & strPAGAR_RECEBER & ", '" & strCOD_GRUPO & "', '" & strTIPO & "', " & strCODIGO & ", " & strCOD_CONTA & ", " & strCOD_PLANO_CONTA & ", " & strCOD_CENTRO_CUSTO 
		strSQL = strSQL & "        , '" & strHISTORICO & "', '" & strOBS & "', '" & strTIPO_DOCUMENTO & "', '" & strNUM_DOCUMENTO & auxStr & "', " & strDT_EMISSAO & ", " & strDT_VCTO & ", " & strVLR_DOCUMENTO & ", " & strVLR_DOCUMENTO 
		strSQL = strSQL & "        , 'ABERTA', 'SEM_NFE', " & strCOD_NF & ", '" & strARQUIVO_ANEXO & "', " & strDT_AGORA & ", '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' ) "
		
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		'Não posso abrir a transação antes do laço por um BUG no MySQL que não gerencia 
		'bem uma trnsaction com várais operações dentro, então esout forçando a operação e um commit logo depois
		set objRSCT = objConn.Execute("commit")
	Next
	
	'athDebug strLOCATION , true
	FechaDBConn ObjConn
'	response.write "<script>" & vbCrlf 
'	if strJSCRIPT_ACTION <> "" then response.write strJSCRIPT_ACTION & vbCrlf end if
'	if strLOCATION <> "" then response.write "location.href='" & strLOCATION &"?var_tipo="&strTIPO_CONTA& "'" & vbCrlf end if
'	response.write "<'/script>"
	response.Redirect(strLOCATION & "?var_tipo="&strTIPO_CONTA)
%>