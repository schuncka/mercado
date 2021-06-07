<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/md5.asp"-->
<%
 Dim objConn, objRS, objRSAux, strSQL, objRSTs, strAuxSQL
 Dim strCODIGO, strID, strGRUPO, strOBS, strNOVO_ID, strNOVO_NOME, strNOVO_EMAIL, strCODIGO_ENTIDADE, strTIPO_ENTIDADE, strENT_CLIENTE_REF
 Dim strCODFIELDNAME, strENTTABLENAME, strFILDNAME, strCODENT, strNOVA_SENHA, strDIR_DEFAULT, strAPELIDO

 strCODIGO          = GetParam("var_cod_usuario")
 strID              = GetParam("var_id_usuario")
 strCODIGO_ENTIDADE = GetParam("var_codigo")
 strTIPO_ENTIDADE   = GetParam("var_tipo")
 strGRUPO           = GetParam("var_grupo")
 strOBS             = GetParam("var_obs")
 strDIR_DEFAULT     = GetParam("var_dir_default")
 strNOVO_ID	        = GetParam("var_novo_id")
 strNOVA_SENHA      = md5(GetParam("var_nova_senha"))
 strNOVO_NOME       = GetParam("var_novo_nome")
 strNOVO_EMAIL      = GetParam("var_novo_email")
 strAPELIDO         = GetParam("var_id_usuario")
 strENT_CLIENTE_REF = GetParam("var_ent_cliente_ref")
 
 if strTIPO_ENTIDADE="ENT_COLABORADOR" then strFILDNAME = "NOME" 
 if strTIPO_ENTIDADE="ENT_CLIENTE"     then strFILDNAME = "NOME_FANTASIA"
 if strTIPO_ENTIDADE="ENT_FORNECEDOR"  then strFILDNAME = "NOME_FANTASIA" 
 
 if strTIPO_ENTIDADE="ENT_COLABORADOR" then strCODFIELDNAME = "COD_COLABORADOR" 
 if strTIPO_ENTIDADE="ENT_CLIENTE"     then strCODFIELDNAME = "COD_CLIENTE"
 if strTIPO_ENTIDADE="ENT_FORNECEDOR"  then strCODFIELDNAME = "COD_FORNECEDOR" 
 
 AbreDBConn objConn, CFG_DB 
 
 'AQUI: NEW TRANSACTION
 set objRSTs  = objConn.Execute("start transaction")
 set objRSTs  = objConn.Execute("set autocommit = 0") 

 strAuxSQL = ""
 '-------------------------------------------------
 '1.Verifica se o ID_USUARIO já existe 
 '-------------------------------------------------
 strSQL = "SELECT COD_USUARIO, ID_USUARIO FROM USUARIO WHERE ID_USUARIO='" & strNOVO_ID & "'"
 set objRS = objConn.Execute(strSQL)
 if ( (not objRS.Eof) and (not objRS.BOF) ) then
  FechaRecordSet objRS
  Mensagem "O ID digitado já está sendo utilizado." & GetValue(objRS,"COD_USUARIO") & " - " & GetValue(objRS,"ID_USUARIO"), "", "", true
  response.end
 else
  FechaRecordSet objRS

  If strTIPO_ENTIDADE <> "ENT_COLABORADOR" Then
	strCODENT = strCODIGO_ENTIDADE
  Else
	'-------------------------------------------------------
	'2.Cria novo registro na entidade correspondente
	'-------------------------------------------------------
	'Não copia os dados da entidade porque na verdade o objetivo é copiar usr e por uma questão de integridade 
	'referencial:"cada usr tem que ter um tipo e código de entidade a qual esta relacionado", apenas criamos uma 
	'entidade pra ele, não copiamos os dados da entidade do usr original 
	strSQL = "INSERT INTO " & strTIPO_ENTIDADE & " (" & strFILDNAME & ", DT_CADASTRO) VALUES ('" & strNOVO_NOME & "', '" & PrepDataBrToUni(Now, True) & "')"
	strAuxSQL = strSQL

	objConn.Execute(strSQL)
	
	'-----------------------------------------------
	'3.Busca o código da entidade recém criado
	'-----------------------------------------------
	strSQL = "SELECT MAX(" & strCODFIELDNAME & ") AS ULT_COD FROM " & strTIPO_ENTIDADE    
    strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL

	set objRS = objConn.Execute(strSQL)                                            
	strCODENT = GetValue(objRS,"ULT_COD")                                          
	FechaRecordSet objRS
  End If
  
  '---------------------------------------------------------------------------
  '4.Cria novo usuário já ligando na entidade correspondente recém criada
  '---------------------------------------------------------------------------
  strSQL = " INSERT INTO USUARIO (ID_USUARIO, SENHA, APELIDO, NOME, EMAIL, GRP_USER, DIR_DEFAULT, TIPO, CODIGO, OBS, ENT_CLIENTE_REF) " &_ 
           " VALUES ('" & strNOVO_ID & "','" & strNOVA_SENHA & "','" & strAPELIDO & "','" & strNOVO_NOME & "','" & strNOVO_EMAIL & "', " &_
           "         '" & strGRUPO & "','" & strDIR_DEFAULT & "','" & strTIPO_ENTIDADE & "'," & strCODENT & ",'" & strOBS & "', '" & strENT_CLIENTE_REF & "')"
  strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL

  objConn.Execute(strSQL)
  
  '----------------------------------------------------------------------------------
  '5.Busca os horários do usuário origem inserindo cada um para o novo usuário
  '----------------------------------------------------------------------------------
  strSQL = "SELECT DIA_SEMANA, IN_1, OUT_1, IN_2, OUT_2, IN_3, OUT_3, IN_EXTRA, OUT_EXTRA, TOTAL, COD_EMPRESA, OBS FROM USUARIO_HORARIO WHERE ID_USUARIO = '" & strID & "'"
  set objRS = objConn.Execute(strSQL)
  while NOT objRS.EOF 
     strSQL = " INSERT INTO USUARIO_HORARIO ( ID_USUARIO, DIA_SEMANA, IN_1, OUT_1, IN_2, OUT_2, IN_3, OUT_3, IN_EXTRA, OUT_EXTRA, TOTAL, COD_EMPRESA, OBS)" &_
              " VALUES ('" & strNOVO_ID & "'" &_
			    ",'" & GetValue(objRS,"DIA_SEMANA") & "'" &_
			    ",'" & GetValue(objRS,"IN_1")       & "','" & GetValue(objRS,"OUT_1") & "'" &_
			    ",'" & GetValue(objRS,"IN_2")       & "','" & GetValue(objRS,"OUT_2") & "'" &_
			    ",'" & GetValue(objRS,"IN_3")       & "','" & GetValue(objRS,"OUT_3") & "'" &_
			    ",'" & GetValue(objRS,"IN_EXTRA")   & "','" & GetValue(objRS,"OUT_EXTRA") & "'" &_
			    ",'" & GetValue(objRS,"TOTAL")      & "','" & GetValue(objRS,"COD_EMPRESA") & "','" & GetValue(objRS,"OBS") & "') "
     strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL
     objConn.Execute(strSQL)				
     objRS.MoveNext
  wend
  FechaRecordSet objRS
  
  '---------------------------------------------------------------------------------
  '6.Busca os direitos do usuário origem inserindo cada um para o novo usuário
  '---------------------------------------------------------------------------------
  strSQL = " INSERT INTO SYS_APP_DIREITO_USUARIO (ID_USUARIO, COD_APP_DIREITO) " &_
		   " SELECT '" & strNOVO_ID & "', COD_APP_DIREITO FROM SYS_APP_DIREITO_USUARIO " &_
		   " WHERE ID_USUARIO = '" & strID & "'"
  strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL
  objConn.Execute(strSQL)
 end if
 
 set objRSTs = objConn.Execute("commit")
 athSaveLog "COPY", Session("METRO_USER_ID_USER")), strID & " para " & strNOVO_ID, strAuxSQL

 response.write "<script>"  & vbCrlf 
 if (GetParam("JSCRIPT_ACTION") <> "")   then response.write  GetParam("JSCRIPT_ACTION") & vbCrlf end if
 if (GetParam("DEFAULT_LOCATION") <> "") then response.write "location.href='" & GetParam("DEFAULT_LOCATION") & "'" & vbCrlf
 response.write "</script>"
%>