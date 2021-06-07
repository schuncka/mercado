<!--#include file="../_database/athdbConnCS.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtilsCS.asp"-->
<%
Dim strSQL, objRS, objRSCT, ObjConn
Dim strMSG, strCODIGO, strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA
Dim strJSCRIPT_ACTION, strLOCATION

	strCODIGO 				= GetParam("var_cod_chavereg")
	strCOD_CENTRO_CUSTO		= GetParam("var_cod_centro_custo")
	strCOD_PLANO_CONTA	 	= GetParam("var_cod_plano_conta")
	strJSCRIPT_ACTION 		= GetParam("JSCRIPT_ACTION")
	strLOCATION 			= GetParam("DEFAULT_LOCATION")
	
	If Not IsNumeric(strCODIGO) 			Then strCODIGO 				= ""
	If Not IsNumeric(strCOD_CENTRO_CUSTO) 	Then strCOD_CENTRO_CUSTO 	= ""
	If Not IsNumeric(strCOD_PLANO_CONTA) 	Then strCOD_PLANO_CONTA 	= ""
	
	strMSG = ""
	If (strCODIGO 			= "") Then strMSG = strMSG & "Parâmetro inválido para lançamento<br>"
	If (strCOD_CENTRO_CUSTO = "") Then strMSG = strMSG & "Informar centro de custo<br>"
	If (strCOD_PLANO_CONTA 	= "") Then strMSG = strMSG & "Informar plano de conta<br>"
	
	If strMSG <> "" Then 
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	'-----------------------------
	'Altera dados do lançamento
	'-----------------------------
	strSQL =          " UPDATE FIN_LCTO_EM_CONTA "
	strSQL = strSQL & " SET COD_PLANO_CONTA 	= " & strCOD_PLANO_CONTA
	strSQL = strSQL & " , COD_CENTRO_CUSTO 		= " & strCOD_CENTRO_CUSTO
	strSQL = strSQL & " WHERE COD_LCTO_EM_CONTA = " & strCODIGO
	
	'AQUI: NEW TRANSACTION
'	set objRSCT  = objConn.Execute("start transaction")
'	set objRSCT  = objConn.Execute("set autocommit = 0")
	Set objRSCT = objConn.Execute(strSQL)
	objConn.Execute(strSQL)	
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FINLCTOCONTA.update_exec: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
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