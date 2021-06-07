<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/md5.asp"--> 
<%
	Dim objConn, objRS, objRSCT, strSQL
	Dim strCOD_USUARIO, strNOME, strSENHA, strEMAIL, strTIPO, strCODIGO
	Dim strGRP_USER, strDIR_DEFAULT, strOBS, strFOTO, strDT_INATIVO, strRETORNO, strAPELIDO, strCLIENTEREF
	
	AbreDBConn objConn, CFG_DB
	
	strCOD_USUARIO = GetParam("var_chavereg")
	strNOME        = GetParam("var_nome")
	strSENHA       = Trim(GetParam("var_senha"))
	strEMAIL       = GetParam("var_email")
	strTIPO        = GetParam("var_tipo")
	strCODIGO      = GetParam("var_codigo")
	strGRP_USER    = GetParam("var_grp_user")
	strDIR_DEFAULT = GetParam("var_dir_default")
	strOBS         = GetParam("var_obs")
	strFOTO        = GetParam("var_foto")
	strDT_INATIVO  = GetParam("var_dt_inativo")
    strCLIENTEREF  = GetParam("var_cod_cli_chamado_filtro")	
	strRETORNO     = GetParam("var_retorno")
	strAPELIDO     = GetParam("var_apelido1")
	
	if IsDate(strDT_INATIVO) then 
		strDT_INATIVO = "'" & PrepDataBrToUni(strDT_INATIVO,false) & "'" 
	else 
		strDT_INATIVO = "Null"
	end if
	
	'Se usuário não informou nada usa "ID Usuario"
	If strAPELIDO = "" Then strAPELIDO = GetParam("var_apelido2")
	
	strSQL =          " UPDATE USUARIO "
	strSQL = strSQL & " SET NOME = '" & strNOME & "' "
	if strSENHA    <> "" then strSQL = strSQL & " ,SENHA = '"    & md5(strSENHA) & "' "
	If strTIPO     <> "" then strSQL = strSQL & " ,TIPO = '"     & strTIPO & "' "
	If strCODIGO   <> "" then strSQL = strSQL & " ,CODIGO = "    & strCODIGO
	If strGRP_USER <> "" then strSQL = strSQL & " ,GRP_USER = '" & strGRP_USER & "' "
	strSQL = strSQL & "  ,EMAIL = '" & strEMAIL & "' "
	strSQL = strSQL & "  ,DIR_DEFAULT = '" & strDIR_DEFAULT & "' "
	strSQL = strSQL & "  ,FOTO = '" & strFOTO & "' "
	strSQL = strSQL & "  ,OBS = '" & strOBS & "' "
	strSQL = strSQL & "  ,DT_INATIVO = " & strDT_INATIVO
	strSQL = strSQL & "  ,ENT_CLIENTE_REF = '" & strCLIENTEREF & "' "
	strSQL = strSQL & "  ,SYS_DT_ALT = '" & PrepDataBrToUni(Now(),true) & "' "
	strSQL = strSQL & "  ,SYS_USR_ALT = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
	strSQL = strSQL & "  ,APELIDO = '" & strAPELIDO & "' "
	strSQL = strSQL & " WHERE COD_USUARIO = " & strCOD_USUARIO
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
	    athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK USUARIO " & strCOD_USUARIO , strSQL

		Mensagem "modulo_USUARIO.Update_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
		athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT USUARIO " & strCOD_USUARIO, strSQL
	End If
	
	FechaDBConn(objConn)
	
	'Response.Redirect(strRETORNO)
	response.write "<script>"  & vbCrlf 
	if (GetParam("JSCRIPT_ACTION") <> "")   then response.write  GetParam("JSCRIPT_ACTION") & vbCrlf end if
	if (GetParam("DEFAULT_LOCATION") <> "") then response.write "location.href='" & GetParam("DEFAULT_LOCATION") & "'" & vbCrlf
	response.write "</script>"
%>