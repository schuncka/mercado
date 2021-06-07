<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Usuario",Session("METRO_USER_ID_USER")), true %>
<%
Dim strSQL, objRS, ObjConn, objRSTs, strAuxSQL
Dim strID_USUARIO_O, strID_USUARIO_D
Dim strTIPO, arrValues(6), i
Dim strJSCRIPT_ACTION, strLOCATION

strID_USUARIO_O	= GetParam("var_id_usuario_o")
strID_USUARIO_D	= GetParam("var_id_usuario_d")
strTIPO = UCase(GetParam("var_tipo"))
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION = GetParam("DEFAULT_LOCATION")

AbreDBConn objConn, CFG_DB 

'AQUI: NEW TRANSACTION
set objRSTs  = objConn.Execute("start transaction")
set objRSTs  = objConn.Execute("set autocommit = 0")

strAuxSQL = ""
if strTIPO="ATALHOS" OR strTIPO="COPIAR_ATALHOS" then
	strSQL = "DELETE FROM SYS_PAINEL WHERE ID_USUARIO='" & strID_USUARIO_D & "'"
    strAuxSQL = strSQL
	objConn.Execute(strSQL)
	
	strSQL = " SELECT ROTULO, DESCRICAO, IMG, LINK, LINK_PARAM, TARGET, ORDEM FROM SYS_PAINEL " &_
			 " WHERE ID_USUARIO='"	& strID_USUARIO_O & "' AND DT_INATIVO IS NULL ORDER BY ORDEM "
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	
	if not objRS.eof then
		while not objRS.eof
			for i=0 to objRS.fields.count-1
				arrValues(i)="'',"			
				if objRS.fields(i).value<>"" then arrValues(i)="'"& Replace(objRS.fields(i).value,"'","""") &"',"
				if i=objRS.fields.count-1 then
					arrValues(i)= objRS.fields(i).value
					if arrValues(i)="" then arrValues(i)= "null"
				end if
			next
			
			strSQL = "INSERT INTO SYS_PAINEL (ROTULO,DESCRICAO,IMG,LINK,LINK_PARAM,TARGET,ORDEM,ID_USUARIO) VALUES ("
			for each i in arrValues
				strSQL = strSQL & i
			next
			strSQL = strSQL &	",'" & strID_USUARIO_D & "')"			
			strAuxSQL = strAuxSQL & vbnewline & strSQL
			
			objConn.Execute(strSQL)
			
			objRS.MoveNext
		wend
	end if
	
	FechaRecordSet objRS
else
	strSQL = "DELETE FROM SYS_APP_DIREITO_USUARIO WHERE ID_USUARIO='" & strID_USUARIO_D & "'"
    strAuxSQL = strAuxSQL & vbnewline & strSQL

	objConn.Execute(strSQL)
	
	strSQL = "SELECT COD_APP_DIREITO FROM SYS_APP_DIREITO_USUARIO WHERE ID_USUARIO='" & strID_USUARIO_O & "' ORDER BY COD_APP_DIREITO"
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.eof then
		while not objRS.eof
			strSQL = "INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO,ID_USUARIO) VALUES (" & GetValue(objRS,"COD_APP_DIREITO") & ",'" & strID_USUARIO_D & "')"
			strAuxSQL = strAuxSQL & vbnewline & strSQL
			objConn.Execute(strSQL)
			
			objRS.MoveNext
		wend
	end if
end if

set objRSTs = objConn.Execute("commit")
athSaveLog "CLONE",Session("METRO_USER_ID_USER")), strTIPO & " - " & strID_USUARIO_O & " para " & strID_USUARIO_D, strAuxSQL

FechaDBConn objConn

response.write "<script>"
if (strJSCRIPT_ACTION <> "") then response.write strJSCRIPT_ACTION & vbCrlf end if
if (strLOCATION <> "") then response.write "location.href='" & strLOCATION & "'" & vbCrlf
response.write "</script>"
%>

