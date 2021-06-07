<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athSendMail.asp"--> 
<%'http://the_urano:83/_pvista/pax/lembrete.asp?var_identificador=95065750025%>
<%
Dim strIDENTIFICADOR, strACAO
Dim objConn, objRS
Dim strCOD_EMPRESA, strDOCUMENTO, strEMAIL, strINATIVO, strSENHA, strEV_EMAIL_SENDER	
Dim strMSG, strTpMsg, strBODY, strMsgSys, strToMsg, strSQL, strWhereSql, intTotal, strConst, strDESTINO, strASSUNTO


strIDENTIFICADOR   = Request("var_identificador")
If instr(strIDENTIFICADOR,"@") =0 then
	strIDENTIFICADOR   = replace(replace(replace(strIDENTIFICADOR,".",""),"-",""),"/","")
End If
'response.write("id:" & strIDENTIFICADOR)


AbreDBConn objConn, CFG_DB

' ------------------------------------------------------------------------
' Busca dados relativos as informações do site no banco (athcsm.mdb) 
' para montagem na tela principal
' ------------------------------------------------------------------------
strEV_EMAIL_SENDER = Request.Cookies("METRO_pax")("email_sender")


If strIDENTIFICADOR <> "" Then
		  If IsNumeric(strIDENTIFICADOR) Then
		     strWhereSql =  "  AND tbl_Empresas.id_num_doc1 = '" & strIDENTIFICADOR & "'"
		   Else
		     strWhereSql =  "  AND tbl_Empresas.email1 = '" & strIDENTIFICADOR & "'"
		   End If

    	strSQL = "SELECT tbl_Empresas.cod_empresa " & _		   
           " ,tbl_empresas.id_num_doc1 AS documento" & _
           " ,tbl_empresas.sys_inativo AS inativo " & _
		   " ,tbl_empresas.email1 AS email  " & _		   
		   " ,tbl_empresas.senha  " & _
		   " ,(SELECT count(cod_empresa) FROM tbl_empresas WHERE tbl_empresas.sys_inativo IS NULL " & strWhereSql & ") as qtde  " & _		   
           " FROM tbl_empresas " & _
           " WHERE tbl_empresas.sys_inativo IS NULL " & strWhereSql		  	     
		   
	'Response.Write(strSQL)
	'Response.end()
  		set objRS = objConn.Execute(strSQL)  
  
		If not objRS.EOF Then
			strCOD_EMPRESA      = getValue(objRS,"cod_empresa")
			strDOCUMENTO		= getValue(objRS,"documento")
			strEMAIL 			= getValue(objRS,"email")
			strINATIVO			= getValue(objRS,"inativo")
			strSENHA			= getValue(objRS,"senha")
			intTotal            = getValue(objRS,"qtde")
		End If

	
	If strCOD_EMPRESA <> "" Then		
		If strEMAIL = ""  Then
			strMSG = "E-mail n&atilde;o encontrado no cadastro. Entre em contato pelo telefone 88888-8888 e informe seu novo email."
			strTpMsg = "WARNING"
		Else
			If cint(intTotal) > 1 Then
				strMSG = "Foram encontrados mais de um cadastro com seu e-mail e/ou CPF,  contato pelo telefone 88888-8888."
				strTpMSg = "WARNING"
			Else
				If strSENHA = "" Then
					strSENHA = GerarSenhaAleatoria(6,0)
					strSQL = "UPDATE TBL_EMPRESAS SET SENHA = '"& strSENHA &"' WHERE COD_EMPRESA = '" & strCOD_EMPRESA & "'"
					objConn.Execute(strSQL)				
				End If
			
				'Esta constante é usada somente para exibição na tela, afim de nao mostrar a senha propriamente dita.
				strConst = "  <p> Caso tenha mudado o e-mail entre em contato atrav&eacute;s:<br />  <a href='mailto:" & strEV_EMAIL_SENDER & "'>" & strEV_EMAIL_SENDER & "</a></p> "
				
				strMSG =          " <p> "
				strMSG = strMSG & "	 <strong>Lembrete enviado com sucesso para o e-mail<br /><br />"& strEMAIL & "<br /><br /> que consta em seu cadastro.</strong> "
				strMSG = strMSG & " </p> "			

				strTpMsg = "INFO"
				strBODY = strMSG & " <p>Senha: <strong>" & strSENHA & "</strong></p>"
				strMSG = strMSG & strConst

				strDESTINO = strEMAIL
				'strEV_EMAIL_SENDER = strEMAIL
				strASSUNTO =  "CFG_ID_CLIENTE & - Lembrete de Acesso Area Restrita PAX "
				'AthEnviaMail strDESTINO, strEV_EMAIL_SENDER, "", "", strASSUNTO, strBody, 1, 0, 0, ""
			End If 'if do total maior que um registro		
	     	
		End If 'if do email vazio
		strMSgSys = "(Empresa: "& strCOD_EMPRESA & ")"
	Else
		strMSG = "Cadastro n&atilde;o encontrado. Entre em contato com a administra&ccedil;&atilde;o"
		strTpMsg = "WARNING"
	End If
	    
Else
	strMSG = "CPF e/ou E-MAIL n&atilde;o informado."
	strMsgSys = "Id Null"
	strTpMsg = "ERR"
End If 'end if do identificador
	
%>

<html>
    <head>
	    <title>Mercado</title>
	</head>
    <body>
        <form name="requestPass" id="requestPass" action="../_database/athMsgDlg.asp" method="post" target="_self">
            <input type="hidden" name="var_nome"       value="Lembrete Senha">
            <input type="hidden" name="var_tipo"       value="<%=strTpMsg%>">                                
            <input type="hidden" name="var_msg"        value="<%=server.HTMLEncode(strMSG)%>">
            <input type="hidden" name="var_titulo"     value="<%'="Inserção"%>">                                
            <input type="hidden" name="var_msgsys"     value="<%=strMsgSys%>">           
            <input type="hidden" name="var_parent"     value="window.close();">
        </form>
        <script language="javascript">
            document.getElementById("requestPass").submit();
        </script>	
</body>
</html>
