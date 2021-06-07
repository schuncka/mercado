<!--#include file="../_database/athdbConnCS.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/athSendMail.asp"--> 
<%
 Dim strSQL, objRS, ObjConn
 
 Dim strCOD_EMPRESA,strID_NUM_DOC1,strNOMECLI,strNOMEFAN,strENTIDADE,strENTIDADE_CNPJ,strEMAIL1,strEND_LOGR,strEND_NUM,strEND_COMPL
 Dim strEND_BAIRRO,strEND_CIDADE,strEND_ESTADO,strEND_PAIS,strEND_CEP,strFONE1,strFONE2,strFONE3,strFONE4,strIMG_FOTO
 Dim strPAL_COD_PALESTRANTE,strPAL_FOTO,strPAL_CURRICULO,strPAL_ATUACAO
 Dim strJSCRIPT_ACTION, strLOCATION

 Dim strPAX_CADASTRO, strPAX_CADASTRO_EMAIL, strPAX_EMAIL_SENDER, strPAX_EMAIL_AUDITORIA_PROEVENTO, strPAX_EMAIL_AUDITORIA_CLIENTE
 Dim strMsgHist,strASSUNTO,strBody 
 
 strCOD_EMPRESA 		= GetParam("var_COD_EMPRESA")
 strNOMECLI				= GetParam("var_NOMECLI")
 strNOMEFAN				= GetParam("var_NOMEFAN")
 strENTIDADE			= GetParam("var_ENTIDADE")
 strENTIDADE_CNPJ		= GetParam("var_ENTIDADE_CNPJ")
 strEMAIL1				= GetParam("var_EMAIL1")
 strEND_LOGR			= GetParam("var_END_LOGR")
 strEND_NUM				= GetParam("var_END_NUM")
 strEND_COMPL			= GetParam("var_END_COMPL")
 strEND_BAIRRO			= GetParam("var_END_BAIRRO")
 strEND_CIDADE			= GetParam("var_END_CIDADE")
 strEND_ESTADO			= GetParam("var_END_ESTADO")
 strEND_PAIS			= GetParam("var_END_PAIS")
 strEND_CEP				= GetParam("var_END_CEP")
 strFONE1				= GetParam("var_FONE1")
 strFONE2				= GetParam("var_FONE2")
 strFONE3				= GetParam("var_FONE3")
 strFONE4				= GetParam("var_FONE4")
 strIMG_FOTO			= GetParam("var_IMG_FOTO")

 strPAL_COD_PALESTRANTE	= GetParam("var_COD_PALESTRANTE")
 strPAL_FOTO			= GetParam("var_FOTO")
 strPAL_CURRICULO		= GetParam("var_CURRICULO")
 strPAL_ATUACAO			= GetParam("var_AREA_ATUACAO")
 
 strJSCRIPT_ACTION		= GetParam("JSCRIPT_ACTION")
 strLOCATION			= GetParam("DEFAULT_LOCATION")
 'athDebug "" , false

	
 AbreDBConn objConn, CFG_DB 

 ' ---------------------------------------------------------------------------------------------------------
 ' INI: Variávis de ambiente - PAX_... 
 strPAX_CADASTRO					= Request.Cookies("METRO_pax")("tp_cadastro") '(["EXIBIR" or "EDITAR" or "HOMOLOGAR"])
 strPAX_CADASTRO_EMAIL  			= Request.Cookies("METRO_pax")("cadastro_email")
 strPAX_EMAIL_SENDER 				= Request.Cookies("METRO_pax")("email_sender")
 strPAX_EMAIL_AUDITORIA_PROEVENTO	= Request.Cookies("METRO_pax")("email_auditoria_proevento")
 strPAX_EMAIL_AUDITORIA_CLIENTE		= Request.Cookies("METRO_pax")("email_auditoria_cliente")
 ' ---------------------------------------------------------------------------------------------------------


 If ( (ucase(strPAX_CADASTRO) = "EDITAR") or (strPAX_CADASTRO = "") ) Then
	if (strCOD_EMPRESA <> "") then	
		strSQL = " UPDATE TBL_EMPRESAS SET "
		strSQL = strSQL & "  NOMECLI = " & strToSQL(strNOMECLI)
		strSQL = strSQL & ", NOMEFAN = " & strToSQL(strNOMEFAN)
		strSQL = strSQL & ", ENTIDADE = " & strToSQL(strENTIDADE)
		strSQL = strSQL & ", ENTIDADE_CNPJ = " & strToSQL(strENTIDADE_CNPJ)
		'strSQL = strSQL & ", EMAIL1 = " & strToSQL(strEMAIL1) ' Não permite alterar EMAIL (porque ele pode locar com ele, assim como com o ID_NUM_DOC1
		strSQL = strSQL & ", END_LOGR = " & strToSQL(strEND_LOGR)
		strSQL = strSQL & ", END_NUM = " & strToSQL(strEND_NUM)
		strSQL = strSQL & ", END_COMPL = " & strToSQL(strEND_COMPL)
		strSQL = strSQL & ", END_FULL = " & strToSQL(ucase(Trim(strEND_LOGR & " " & strEND_NUM & " " & strEND_COMPL)))
		strSQL = strSQL & ", END_BAIRRO = " & strToSQL(strEND_BAIRRO)
		strSQL = strSQL & ", END_CIDADE = " & strToSQL(strEND_CIDADE)
		strSQL = strSQL & ", END_ESTADO = " & strToSQL(strEND_ESTADO)
		strSQL = strSQL & ", END_PAIS = " & strToSQL(strEND_PAIS)
		strSQL = strSQL & ", END_CEP = " & strToSQL(strEND_CEP)
		strSQL = strSQL & ", FONE1 = " & strToSQL(strFONE1)
		strSQL = strSQL & ", FONE2 = " & strToSQL(strFONE2)
		strSQL = strSQL & ", FONE3 = " & strToSQL(strFONE3)
		strSQL = strSQL & ", FONE4 = " & strToSQL(strFONE4)
		strSQL = strSQL & ", IMG_FOTO = " & strToSQL(strIMG_FOTO)
		strSQL = strSQL & ", SYS_DATAAT = NOW()"
		strSQL = strSQL & ", SYS_USERAT = '" & strCOD_EMPRESA & "'"
		strSQL = strSQL & " WHERE COD_EMPRESA = '" & strCOD_EMPRESA & "'"
		'athDebug strSQL, true
		objConn.Execute(strSQL)
	end if

	if (strPAL_COD_PALESTRANTE <> "") then	
		strSQL = " UPDATE tbl_PALESTRANTE SET "
		strSQL = strSQL & "  FOTO = " & strToSQL(strPAL_FOTO)
		strSQL = strSQL & ", CURRICULO = " & strToSQL(strPAL_CURRICULO)
		strSQL = strSQL & ", AREA_ATUACAO = " & strToSQL(strPAL_ATUACAO)
		strSQL = strSQL & " WHERE COD_PALESTRANTE = " & strToSQL(strPAL_COD_PALESTRANTE)
		'athDebug strSQL, true
		objConn.Execute(strSQL)
	end if
	
	strMsgHist = "ATUALIZACAO DADOS CADASTRO"
 else
	If ( ucase(strPAX_CADASTRO) = "HOMOLOGAR" ) Then

		strBody =           " "
		strBody = StrBody & "<table width='100%' class='texto'>"
		strBody = StrBody & "<tr><td valign='top'>"
		strBody = StrBody & "pVISTA PAX - PEDIDO HOMOLOGACAO/ATUALIZACAO CADASTRO" & "<br>"
		strBody = StrBody & "Data do Pedido: " & PrepData(now(),True,True) & "<br><br>"
		strBody = StrBody & ":::::::::::::::::: Dados de Cadastro ::::::::::::::::::::" & "<br>"
		strBody = StrBody & "Código: "& strCOD_EMPRESA & "<br>"
		strBody = StrBody & "CPF: " & strID_NUM_DOC1 & "<br>"
		strBody = StrBody & "Nome Completo: " & strNOMECLI & "<br>"
		strBody = StrBody & "Nome Fantasia: " & strNOMEFAN & "<br>"
		strBody = StrBody & "Entidade: " & strENTIDADE & "<br>"
		strBody = StrBody & "Entidade CNPJ: " & strENTIDADE_CNPJ & "<br>"
		strBody = StrBody & "Endereço: " & strEND_LOGR & "<br>"
		strBody = StrBody & "Número: " & strEND_NUM & "<br>"
		strBody = StrBody & "Complemento: " & strEND_COMPL & "<br>"
		strBody = StrBody & "Bairro: " & strEND_BAIRRO & "<br>"
		strBody = StrBody & "Cidade: " & strEND_CIDADE & "<br>"
		strBody = StrBody & "Estado: " & strEND_ESTADO & "<br>"
		strBody = StrBody & "CEP: " & strEND_CEP & "<br> " 
		strBody = StrBody & "Fone Preferencial: " & strFONE4 & "<br> " 
		strBody = StrBody & "Fone Residencial: " & strFONE1 & "<br>"
		strBody = StrBody & "Celular: " & strFONE3 & "<br>"
		strBody = StrBody & "Fax: " & strFONE2 & "<br>"
		strBody = StrBody & "E-mail: " & strEMAIL1 & "<br> "
		strBody = StrBody & "<br> "
		strBody = StrBody &	"</td>"
		strBody = StrBody &	"</tr>"
		strBody = StrBody &	"</table>"
		'athDebug strBody true
		
		strASSUNTO = "pVISTA PAX - PEDIDO HOMOLOGACAO/ATUALIZACAO CADASTRO - " & " (" & strCOD_EMPRESA & ")"
		AthEnviaMail strPAX_CADASTRO_EMAIL, strPAX_EMAIL_SENDER, "", strPAX_EMAIL_AUDITORIA_PROEVENTO & ";" & strPAX_EMAIL_AUDITORIA_CLIENTE, strASSUNTO, strBODY, strPAX_EMAIL_SENDER, 0, 0, ""
	
		strMsgHist = "HOMOLOGACAO DADOS CADASTRO"
	end if
 end if

 	
 ' Grava histórico ATUALIZAÇÃO ou HOMOLOGAÇÂO - solicitação (enviada por email)
 If ( ucase(strPAX_CADASTRO) <> "EXIBIR" ) Then
 	strSQL = "INSERT INTO TBL_EMPRESAS_HIST (COD_EMPRESA, HISTORICO, SYS_DATACA, SYS_USERCA) VALUES ('" & strCOD_EMPRESA 
 	strSQL = strSQL & "', '" & strMsgHist & "' , NOW() ,'" & strCOD_EMPRESA &"')"
 	objConn.Execute(strSQL)
 end if


 FechaDBConn ObjConn
	
 response.write "<script>" & vbCrlf 
 if (strJSCRIPT_ACTION <> "") then
	response.write strJSCRIPT_ACTION & vbCrlf 
 end if
 if (strLOCATION <> "") then 
	response.write "location.href='" & strLOCATION & "'" & vbCrlf
	response.write "</script>"
 end if
%>