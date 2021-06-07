<!--#include file="../_database/athdbConnCS.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtilsCS.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn
Dim strDT_AGORA, strMSG
Dim Cont, Desloc
Dim strRETORNO, strCODIGO, strTIPO, strCOD_CONTA, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA
Dim strVLR_CONTA, strTIPO_DOCUMENTO, strNUM_DOCUMENTO, strDT_EMISSAO, strDT_VCTO_Orig, strDT_VCTO
Dim strHISTORICO, strOBS, strFREQUENCIA, strPARCELAS, strCOD_GRUPO, strEDICAO_TOTAL
Dim strSYS_DT_CRIACAO, strTITLE
Dim strCOD_CONTA_PAGAR_RECEBER, strCOD_NF, strNUM_NF, strARQUIVO_ANEXO, strARQUIVO_ANEXO_ORIG
Dim strJSCRIPT_ACTION, strLOCATION

	strCOD_CONTA_PAGAR_RECEBER	= GetParam("var_chavereg")
	strCOD_CONTA				= GetParam("var_codigo")
	strCODIGO					= GetParam("var_codigo")
	strTIPO						= GetParam("var_tipo")
	strCOD_CENTRO_CUSTO			= GetParam("var_cod_centro_custo")
	strCOD_PLANO_CONTA			= GetParam("var_cod_plano_conta")
	strOBS						= GetParam("var_obs")
	strHISTORICO				= GetParam("var_historico")
	strVLR_CONTA				= GetParam("var_vlr_conta")
	strTIPO_DOCUMENTO			= GetParam("var_documento")
	strNUM_DOCUMENTO			= GetParam("var_num_documento")
	strDT_VCTO					= GetParam("var_dt_vcto")
	strDT_EMISSAO				= GetParam("var_dt_emissao")
	strARQUIVO_ANEXO			= GetParam("var_arquivo_anexo")
	strARQUIVO_ANEXO_ORIG		= GetParam("var_arquivo_anexo_orig")
	strEDICAO_TOTAL				= GetParam("var_edicao_total")
	strJSCRIPT_ACTION			= GetParam("JSCRIPT_ACTION")
	strLOCATION					= GetParam("DEFAULT_LOCATION")
	
	athDebug "strCOD_CONTA_PAGAR_RECEBER"&strCOD_CONTA_PAGAR_RECEBER&"<br>strCOD_CONTA"&strCOD_CONTA&"<br>cod:"&strCODIGO&"<br>strTIPO"&strTIPO&"<br>strCOD_CENTRO_CUSTO"&strCOD_CENTRO_CUSTO&"<br>strCOD_PLANO_CONTA"&strCOD_PLANO_CONTA&"<br>strOBS"&strOBS&"<br>strHISTORICO"&strHISTORICO&"<br>strVLR_CONTA"&strVLR_CONTA&"<br>strTIPO_DOCUMENTO"&strTIPO_DOCUMENTO&"<br>strNUM_DOCUMENTO"&strNUM_DOCUMENTO&"<br>strDT_VCTO"&strDT_VCTO&"<br>strDT_EMISSAO"&strDT_EMISSAO&"<br>strARQUIVO_ANEXO"&strARQUIVO_ANEXO&"<br>strARQUIVO_ANEXO_ORIG"&strARQUIVO_ANEXO_ORIG&"<br>edit:"&strEDICAO_TOTAL&"<br>strJSCRIPT_ACTION"&strJSCRIPT_ACTION&"<br>strLOCATION"&strLOCATION , false
	
	If Not IsNumeric(strVLR_CONTA) Then strVLR_CONTA = ""
	If Not IsDate(strDT_EMISSAO) Then strDT_EMISSAO = ""
	If Not IsDate(strDT_VCTO) Then strDT_VCTO = ""
	
	strMSG = ""
	If strEDICAO_TOTAL = "T" Then
		If (strCOD_CONTA_PAGAR_RECEBER 	= "") Then strMSG = strMSG & "Parâmetro inválido para lançamento<br>"
	End If
	
	If strMSG <> "" Then 
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	'-----------------------------
	'Inicialização
	'-----------------------------
	strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
	
	'-------------------------------------------------------------
	'Se for imagem faz a redução do arquivo enviado como anexo
	'-------------------------------------------------------------
	If (strARQUIVO_ANEXO <> "") And (strARQUIVO_ANEXO <> strARQUIVO_ANEXO_ORIG) Then
		If UCase(Right(strARQUIVO_ANEXO, 3)) = "JPG" Or UCase(Right(strARQUIVO_ANEXO, 4)) = "JPEG" Then
			'ReduzirImagem "../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/FIN_Titulos/", strARQUIVO_ANEXO, 1000
		End If
	End If
	
	If strEDICAO_TOTAL = "T" Then
		'-----------------------------
		'Formatações
		'-----------------------------
		strDT_VCTO_Orig = strDT_VCTO
		strDT_VCTO    = "'" & PrepDataBrToUni(strDT_VCTO, False) & "'"
		strDT_EMISSAO = "'" & PrepDataBrToUni(strDT_EMISSAO, False) & "'"
		
		If strVLR_CONTA <> 0 Then
			strVLR_CONTA = FormatNumber(strVLR_CONTA, 2) 
			strVLR_CONTA = Replace(strVLR_CONTA,".","")
			strVLR_CONTA = Replace(strVLR_CONTA,",",".")
		End If
		
		'-----------------------------
		'Atualiza dados da conta 
		'-----------------------------
		strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER "
		strSQL = strSQL & " SET TIPO = '" & strTIPO & "' "
		strSQL = strSQL & "   , CODIGO = '" & strCODIGO & "' "
		strSQL = strSQL & "   , COD_CONTA = '" & strCOD_CONTA & "' "
		strSQL = strSQL & "   , COD_PLANO_CONTA = '" & strCOD_PLANO_CONTA & "' "
		strSQL = strSQL & "   , COD_CENTRO_CUSTO = '" & strCOD_CENTRO_CUSTO & "' "
		strSQL = strSQL & "   , HISTORICO = '" & strHISTORICO & "'"
		strSQL = strSQL & "   , OBS = '" & strOBS & "' "
		strSQL = strSQL & "   , TIPO_DOCUMENTO = '" & strTIPO_DOCUMENTO & "' "
		strSQL = strSQL & "   , NUM_DOCUMENTO = '" & strNUM_DOCUMENTO & "' "
		strSQL = strSQL & "   , DT_EMISSAO = " & strDT_EMISSAO
		strSQL = strSQL & "   , DT_VCTO = " & strDT_VCTO
		strSQL = strSQL & "   , VLR_CONTA_ORIG = " & strVLR_CONTA
		strSQL = strSQL & "   , VLR_CONTA = " & strVLR_CONTA
		strSQL = strSQL & "   , ARQUIVO_ANEXO = '" & strARQUIVO_ANEXO & "' "
		strSQL = strSQL & "   , SYS_DT_ALTERACAO = " & strDT_AGORA
		strSQL = strSQL & "   , SYS_COD_USER_ALTERACAO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
		strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_PAGAR_RECEBER
		athDebug strSQL, false
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
	
		objConn.Execute(strSQL)	
	
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_TITULOS.Update_Exec A: " & Err.Number & " - "& Err.Description , strLOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
	Else
		'-----------------------------
		'Atualiza dados da conta 
		'-----------------------------
		strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER "
		strSQL = strSQL & " SET OBS = '" & strOBS & "' "
		strSQL = strSQL & "   , ARQUIVO_ANEXO = '" & strARQUIVO_ANEXO & "' "
		strSQL = strSQL & "   , SYS_DT_ALTERACAO = " & strDT_AGORA
		strSQL = strSQL & "   , SYS_COD_USER_ALTERACAO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
		strSQL = strSQL & " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_PAGAR_RECEBER
		
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)	
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_TITULOS.Update_Exec B: " & Err.Number & " - "& Err.Description , strLOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
	End If
	
	FechaDBConn ObjConn
	
response.write "<script>" & vbCrlf 
if strJSCRIPT_ACTION <> "" then
	response.write strJSCRIPT_ACTION & vbCrlf 
end if
if strLOCATION <> "" then 
	response.write "location.href='" & strLOCATION & "'" & vbCrlf
	response.write "</script>"
end if
'response.Redirect(strLOCATION & "?var_cahevereg="&strTIPO_ENT&"'")
%>