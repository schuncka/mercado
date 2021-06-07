<%
'===============================================
' FUNÇÕES DE FORMULÁRIO
'===============================================

'Verifica se o formulário está dentro da data de vigência 
Function VerificaVigencia(prCOD_FORMULARIO, byRef prDtInativo)
	Dim objRSLocal
		
	strSQL = " SELECT dt_inativo FROM tbl_formularios WHERE cod_formulario = " & prCOD_FORMULARIO & " AND cod_evento = " & ValidateValueSQL(Session("AR_COD_EVENTO"),"NUM",false )
	Set objRSLocal = objConn.execute(strSQL)

	If Not objRSLocal.EOF Then
		prDtInativo = GetValue(objRSLocal,"dt_inativo")
	End If
	
	VerificaVigencia = (prDtInativo >= Date())
End Function

'Monta o cabeçalho do formulário (usando tags para substituir infos necessárias)
Function MontaFormHeader(prCOD_FORMULARIO, prNUM_FORMULARIO)
	Dim dtDtInativo, strTitulo, objRSLocal, strHEADER
	Dim arrScodi, arrSdesc
	
	MontaArrySiteInfo arrScodi, arrSdesc
	
	strSQL = " SELECT cabecalho_form FROM tbl_area_restrita_expositor WHERE cod_evento = " & ValidateValueSQL(Session("AR_COD_EVENTO"),"STR",false) & " AND lang = " & ValidateValueSQL(Session("AR_LANG"),"STR",false)
	Set objRSLocal = objConn.execute(strSQL)
	
	If Not objRSLocal.EOF Then
		strHEADER = GetValue(objRSLocal,"cabecalho_form")
	End If
	
	FechaRecordSet objRSLocal
	
	strSQL = " SELECT titulo, dt_inativo, IF (PREENCHIMENTO_OBRIGATORIO RLIKE concat('^'," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",',?') OR PREENCHIMENTO_OBRIGATORIO RLIKE concat(','," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",',') OR PREENCHIMENTO_OBRIGATORIO RLIKE concat('^'," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",'$') OR PREENCHIMENTO_OBRIGATORIO RLIKE concat(','," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",'$'), 1,0) AS PREENCHIMENTO_OBRIGATORIO FROM tbl_formularios WHERE cod_formulario = " & prCOD_FORMULARIO & " AND cod_evento = " & Session("AR_COD_EVENTO")
	Set objRSLocal = objConn.execute(strSQL)

	If Not objRSLocal.EOF Then
		dtDtInativo = GetValue(objRSLocal,"dt_inativo")
		strTitulo   = GetValue(objRSLocal,"titulo")
	End If
	
	If GetParam("msg")&"" <> "" Then
		Response.Write("<script language=""javascript"">alert('" & GetParam("msg") & "'); </script>")
	End If
	
	strHEADER = Replace(strHEADER,"<PRO_FORMULARIO_LOGOMARCA>",dtDtInativo)
	strHEADER = Replace(strHEADER,"<PRO_FORMULARIO_DEADLINE>",dtDtInativo)
	strHEADER = Replace(strHEADER,"<PRO_FORMULARIO_NUM>",prNUM_FORMULARIO)
	strHEADER = Replace(strHEADER,"<PRO_FORMULARIO_TITULO>",strTitulo)
	If CInt(GetValue(objRSLocal,"preenchimento_obrigatorio")) <> 0 Then
		strHEADER = Replace(strHEADER,"<PRO_FORMULARIO_OBRIGATORIO>","PREENCHIMENTO OBRIGATÓRIO")
	End If
	
	Response.Write(strHEADER)
End Function

'Monta o footer do formulário (usando tags para substituir infos necessárias) 
Function MontaFormFooter()
	Dim dtDtInativo, strTitulo, objRSLocal, strFOOTER
	Dim arrScodi, arrSdesc
	
	MontaArrySiteInfo arrScodi, arrSdesc
	
	strSQL = " SELECT rodape_form FROM tbl_area_restrita_expositor WHERE cod_evento = " & ValidateValueSQL(Session("AR_COD_EVENTO"),"STR",false) & " AND lang = " & ValidateValueSQL(Session("AR_LANG"),"STR",false)
	Set objRSLocal = objConn.execute(strSQL)
	
	If Not objRSLocal.EOF Then
		strFOOTER = GetValue(objRSLocal,"rodape_form")
	End If
	
	FechaRecordSet objRSLocal
	
	strSQL = " SELECT titulo, dt_inativo, IF (PREENCHIMENTO_OBRIGATORIO RLIKE concat('^'," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",',?') OR PREENCHIMENTO_OBRIGATORIO RLIKE concat(','," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",',') OR PREENCHIMENTO_OBRIGATORIO RLIKE concat('^'," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",'$') OR PREENCHIMENTO_OBRIGATORIO RLIKE concat(','," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",'$'), 1,0) AS PREENCHIMENTO_OBRIGATORIO FROM tbl_formularios WHERE cod_formulario = " & intCOD_FORMULARIO & " AND cod_evento = " & Session("AR_COD_EVENTO")
	Set objRSLocal = objConn.execute(strSQL)

	If Not objRSLocal.EOF Then
		dtDtInativo = GetValue(objRSLocal,"dt_inativo")
		strTitulo   = GetValue(objRSLocal,"titulo")
	End If
	
	strFOOTER = Replace(strFOOTER,"<PRO_FORMULARIO_LOGOMARCA>",arrSdesc(ArrayIndexOf(arrScodi,"LOGOMARCA")))
	strFOOTER = Replace(strFOOTER,"<PRO_FORMULARIO_DEADLINE>",dtDtInativo)
	strFOOTER = Replace(strFOOTER,"<PRO_FORMULARIO_NUM>",intCOD_FORMULARIO)
	strFOOTER = Replace(strFOOTER,"<PRO_FORMULARIO_TITULO>",strTitulo)
	If CInt(GetValue(objRSLocal,"preenchimento_obrigatorio")) <> 0 Then
		strFOOTER = Replace(strFOOTER,"<PRO_FORMULARIO_OBRIGATORIO>","PREENCHIMENTO OBRIGATÓRIO")
	End If
	
	Response.Write(strFOOTER)
End Function

Function MontaFormSolicitacoes(prCOD_FORMULARIO) 
	Dim objHIS
	Dim contLocal, strBGCOLOR, intQTDE_TOTAL

	strSQL = 		  " SELECT p.cod_ped, p.descricao_pedido, p.valor_total, p.data_pedido, SUM(pi.qtde) AS qtde_ped "
	strSQL = strSQL & "   FROM tbl_aux_pedido_geral AS p "
	strSQL = strSQL & "   INNER JOIN tbl_aux_pedido_geral_servico AS pi ON (pi.cod_ped = p.cod_ped) "
	strSQL = strSQL & "  WHERE p.cod_empresa = " & ValidateValueSQL(Session("EMP_COD_EMPRESA"),"STR",false)
	strSQL = strSQL & "    AND p.cod_evento = " & Session("AR_COD_EVENTO")
	strSQL = strSQL & "    AND p.cod_formulario = " & prCOD_FORMULARIO
	strSQL = strSQL & "    AND p.sys_inativo IS NULL "
	strSQL = strSQL & " GROUP BY p.cod_ped, p.descricao_pedido, p.valor_total, p.data_pedido "
	strSQL = strSQL & " HAVING SUM(pi.qtde) IS NOT NULL "

	Set objHIS = objConn.Execute(strSQL)

	If not objHIS.EOF Then
		Response.Write("<table width=""100%"" border=""0"">")
		Response.Write("	<tr>")
		Response.Write("		<img src=""../img/BulletMais.gif"" title=""Expand"" id=""form_collapse_1"" onClick=""displayAreaAR('form_grupo_1'); changeSrc(this.id,'../img/BulletMais.gif', '../img/BulletMenos.gif')"" alt=""Fechar"" style=""cursor:pointer;"">&nbsp;&nbsp; <font size=""2""> Histórico de pedidos: </font>")
		Response.Write("	</tr>")		
		Response.Write("	<tr>")
		Response.Write("		<td colspan=""5"" class=""form_bypass"" style=""width:910px; height:1px""><img src=""../img/line_group.gif"" style=""width:910px; height:1px""></td>")
		Response.Write("	</tr>")		
		Response.Write("	<tr id=""form_grupo_1"" style=""display:none"">")			
		Response.Write("		<td colspan=""5"">")
		Response.Write("			<table width=""100%"">")
		Response.Write("				<tr bgcolor=""#CCCCCC"">")
		Response.Write("					<td>Cód. Pedido</td>")
		Response.Write("					<td>Descrição</td>")
		Response.Write("					<td>Data do Pedido</td>")
		Response.Write("					<td>Valor do Pedido</td>")
		Response.Write("					<td>Qtde</td>")
		Response.Write("				</tr>")

		contLocal 	  = 0
		While not objHIS.EOF 
			If (contLocal mod 2) = 0 Then
				strBGCOLOR="#E0ECF0"
			Else
				strBGCOLOR="#FFFFFF"
			End If	

			Response.Write("				<tr bgcolor=""" & strBGCOLOR & """>")
			Response.Write("					<td>" & GetValue(objHIS,"cod_ped") & "</td>")
			Response.Write("					<td>" & GetValue(objHIS,"descricao_pedido") & "</td>")
			Response.Write("					<td>" & GetValue(objHIS,"data_pedido") & "</td>")
			Response.Write("					<td>" & FormatNumber(GetValue(objHIS,"valor_total")&"",2) & "</td>")
			Response.Write("					<td>" & GetValue(objHIS,"qtde_ped") & "</td>")
			Response.Write("				</tr>")
			
			contLocal = contLocal+1
			objHIS.Movenext()
		Wend
		
		Response.Write("			</table>")
		Response.Write("		</td>")
		Response.Write("	</tr>")
		Response.Write("</table>")

	End If
End Function


Function RegisterFormExpositor(prCodForm, prDescricao)
  	strSQL = " INSERT INTO tbl_formulario_expositor (COD_FORMULARIO, COD_EMPRESA, DT_ENVIO, DESCRICAO, COD_EVENTO) VALUES ( "
	strSQL = strSQL & prCodForm & "," & ValidateValueSQL(Session("EMP_COD_EMPRESA"),"STR",false) & ", current_timestamp, "&ValidateValueSQL(prDescricao,"STR",false)&", "&ValidateValueSQL(Session("AR_COD_EVENTO"),"STR",false)&") "
	objConn.Execute(strSQL)
End Function


'===============================================
' FUNÇÕES DE GERENCIAMENTO DE CADASTRO
'===============================================

'Insere uma entrada na tbl_empresas como montadora conforme parâmetros passados.
Function InsereMontadora(prPrefix)
	Dim objConnLocal, strSQLLocal, objRSLocal
	Dim strCodEmpresa, strNomeCli, strNomeFan, strEmail, strCargo, strEmpresa, strIdNumDoc1
	Dim dateDtEnvio, strFone1, strFone2, strFone3, strFone4, strCPF, dateSysDataCa, strIdNumDoc2
	Dim dateSysUserCa, strTipo, strEndereco, strCidade, strCEP, strEstado, intStatusPreco, strBairro
	Dim intStatusCred, strExtraTXT1, strEntidade, strSenha, strBODY, strASSUNTO
	
	' Recupera as informações da insercao via GetParam
	strIdNumDoc1   = ValidateValueSQL(GetParam(prPrefix & "id_num_doc1"),"STR",false)
	
	'Abertura do banco
	AbreDBConn objConnLocal, CFG_DB_DADOS
	
	If strIdNumDoc1 <> "NULL" Then
		strCodEmpresa  = ValidateValueSQL(GeraCodEmpresa("bbsi"),"STR",true)
		strNomeCli     = ValidateValueSQL(GetParam(prPrefix & "nomecli"),"STR",true)
		strNomeFan     = ValidateValueSQL(GetParam(prPrefix & "nomefan"),"STR",false)
		strIdNumDoc2   = ValidateValueSQL(GetParam(prPrefix & "id_num_doc2"),"STR",false)
		strEmail       = ValidateValueSQL(GetParam(prPrefix & "email1"),"STR",false)
		strFone4       = ValidateValueSQL(GetParam(prPrefix & "fone4"),"STR",false)
		strFone1       = ValidateValueSQL(GetParam(prPrefix & "fone1"),"STR",false)
		strFone3       = ValidateValueSQL(GetParam(prPrefix & "fone3"),"STR",false)
		strFone2       = ValidateValueSQL(GetParam(prPrefix & "fone2"),"STR",false)
		dateSysDataCa  = ValidateValueSQL(Now(),"AUTODATETIME",true)
		dateSysUserCa  = ValidateValueSQL(GetParam(prPrefix & "sys_userca"),"STR",true)
		strEndereco    = ValidateValueSQL(GetParam(prPrefix & "end_full"),"STR",false)
		strBairro      = ValidateValueSQL(GetParam(prPrefix & "end_bairro"),"STR",false)
		strCidade      = ValidateValueSQL(GetParam(prPrefix & "end_cidade"),"STR",false)
		strEstado      = ValidateValueSQL(GetParam(prPrefix & "end_estado"),"STR",false)
		strCEP         = ValidateValueSQL(GetParam(prPrefix & "end_cep"),"STR",false)
		strExtraTXT1   = ValidateValueSQL(GetParam(prPrefix & "extra_txt_1"),"STR",false)
		strEntidade    = ValidateValueSQL(GetParam(prPrefix & "entidade"),"STR",false)
		strSenha       = ValidateValueSQL(Left(Replace(strIdNumDoc1,"'",""),6),"STR",false)
		
		intStatusPreco = ValidateValueSQL(Session("EMP_CATEGORIA"),"NUM",true)
	
		'Pesquisa o codigo do status_cred de MONTADORA
		Set objRSLocal = objConnLocal.execute(" SELECT cod_status_cred FROM tbl_status_cred WHERE status = 'MONTADOR'")
		
		' Testa se o tipo de credencial está cadastrado, se não tiver ele não permite que a inserção prossiga
		If Not objRSLocal.EOF Then
			intStatusCred = ValidateValueSQL(GetValue(objRSLocal,"cod_status_cred"),"NUM",true)
		Else
			Response.Write("O tipo de credencial não está cadastrado")
			Response.End()
		End If
		
		FechaRecordset objRSLocal
		
		'Comando de inserção já com os dados tratados
		strSQLLocal = " INSERT INTO tbl_empresas (cod_empresa, nomecli, nomefan, id_num_doc1, id_num_doc2"
		strSQLLocal = strSQLLocal & "           , email1, fone4, fone1, fone3, fone2 "
		strSQLLocal = strSQLLocal & "	        , sys_dataca, sys_userca, end_full, end_bairro, end_cidade, end_estado"
		strSQLLocal = strSQLLocal & "           , end_cep, cod_status_preco, cod_status_cred, extra_txt_1, entidade, senha, tipo_pess "
		strSQLLocal = strSQLLocal & "            ) VALUES ( "
		strSQLLocal = strSQLLocal & "            " & strCodEmpresa & ", " & strNomeCli & ", " & strNomeFan & ", " & strIdNumDoc1 & ", " & strIdNumDoc2
		strSQLLocal = strSQLLocal & "          , " & strEmail & ", " & strFone4 & ", " & strFone1 & ", " & strFone3 & ", " & strFone2
		strSQLLocal = strSQLLocal & "          , " & dateSysDataCa & ", " & dateSysUserCa & ", " & strEndereco & ", " & strBairro & ", " & strCidade & ", " & strEstado 
		strSQLLocal = strSQLLocal & "          , " & strCEP & ", " & intStatusPreco & ", " & intStatusCred & ", " & strExtraTXT1 & ", " & strEntidade & ", " & strSenha & ",'N')"
		objConnLocal.execute(strSQLLocal)
		
		strBODY = "<table border='0' align='center'>"&_
				  "<tr><td>Dados para acesso da area restrita - " & Session("AR_NOME_EVENTO") & "</td></tr>"&_
				  "<tr><td>Login: " & Replace(strIdNumDoc1,"'","") & "</td></tr>" &_
				  "<tr><td>Senha: " & Replace(strSenha,"'","") & "</td></tr>" &_
				  "<tr><td>Link de acesso <a href='http://pvista.proevento.com.br/" & CFG_IDCLIENTE & "/arearestrita/?cod_evento=" & Session("AR_COD_EVENTO") & "'>Área Restrita - " & Session("AR_NOME_EVENTO") & "</a></td></tr>"&_
				  "</table>"
			  
		strASSUNTO = "Senha de acesso a area do expositor - " & Session("AR_NOME_EVENTO") 
		AthEnviaMail Replace(strEmail,"'",""), Session("AR_EMAIL_SENDER"), "", CFG_EMAIL_AUDITORIA_PROEVENTO & ";" & CFG_EMAIL_AUDITORIA_CLIENTE, strASSUNTO, strBODY, 1, 0, 0, ""
	Else
		strCodEmpresa = "NULL"
	End If
	
	strSQLLocal = "UPDATE tbl_inscricao_expositor SET cod_empresa_montadora = " & strCodEmpresa & " WHERE cod_empresa = " & Session("EMP_COD_EMPRESA")
	objConnLocal.execute(strSQLLocal)
	
	InsereMontadora = Replace(Replace(strCodEmpresa,"NULL",""),"'","")
	
	'Fechamento da conexão do banco e recordset
	FechaDBConn objConnLocal
End Function

'Altera uma entrada na tbl_empresas como montadora conforme parâmetros passados.
Function AlteraMontadora(prPrefix)
	Dim objConnLocal, strSQLLocal, objRSLocal
	Dim strCodEmpresa, strNomeCli, strNomeFan, strEmail, strCargo, strEmpresa, strIdNumDoc1
	Dim dateDtEnvio, strFone1, strFone2, strFone3, strFone4, strCPF, dateSysDataAt, strIdNumDoc2
	Dim strSysUserAt, strTipo, strEndereco, strCidade, strCEP, strEstado, intStatusPreco, strBairro
	Dim intStatusCred, strExtraTXT1, strEntidade
	Dim strBODY, strASSUNTO, strSenha
	
	strIdNumDoc1   = ValidateValueSQL(GetParam(prPrefix & "id_num_doc1"),"STR",true)
	
	If strIdNumDoc1 <> "NULL" Then
		' Recupera as informações da insercao via GetParam
		strCodEmpresa  = ValidateValueSQL(GetParam(prPrefix & "cod_empresa"),"STR",true)
		strNomeCli     = ValidateValueSQL(GetParam(prPrefix & "nomecli"),"STR",true)
		strNomeFan     = ValidateValueSQL(GetParam(prPrefix & "nomefan"),"STR",false)
		strIdNumDoc2   = ValidateValueSQL(GetParam(prPrefix & "id_num_doc2"),"STR",false)
		strEmail       = ValidateValueSQL(GetParam(prPrefix & "email1"),"STR",false)
		strFone4       = ValidateValueSQL(GetParam(prPrefix & "fone4"),"STR",false)
		strFone1       = ValidateValueSQL(GetParam(prPrefix & "fone1"),"STR",false)
		strFone3       = ValidateValueSQL(GetParam(prPrefix & "fone3"),"STR",false)
		strFone2       = ValidateValueSQL(GetParam(prPrefix & "fone2"),"STR",false)
		dateSysDataAt  = ValidateValueSQL(Now(),"AUTODATETIME",true)
		strSysUserAt   = ValidateValueSQL(GetParam(prPrefix & "sys_userca"),"STR",true)
		strEndereco    = ValidateValueSQL(GetParam(prPrefix & "end_full"),"STR",false)
		strBairro      = ValidateValueSQL(GetParam(prPrefix & "end_bairro"),"STR",false)
		strCidade      = ValidateValueSQL(GetParam(prPrefix & "end_cidade"),"STR",false)
		strEstado      = ValidateValueSQL(GetParam(prPrefix & "end_estado"),"STR",false)
		strCEP         = ValidateValueSQL(GetParam(prPrefix & "end_cep"),"STR",false)
		strExtraTXT1   = ValidateValueSQL(GetParam(prPrefix & "extra_txt_1"),"STR",false)
		strEntidade    = ValidateValueSQL(GetParam(prPrefix & "entidade"),"STR",false)
		strSenha       = ValidateValueSQL(Left(Replace(strIdNumDoc1,"'",""),6),"STR",false)
		
		intStatusPreco = ValidateValueSQL(Session("EMP_CATEGORIA"),"NUM",true)
		
		'Abertura do banco
		AbreDBConn objConnLocal, CFG_DB_DADOS
		
		'Pesquisa o codigo do status_cred de MONTADORA
		Set objRSLocal = objConnLocal.execute(" SELECT cod_status_cred FROM tbl_status_cred WHERE status = 'MONTADOR' ")
		
		' Testa se o tipo de credencial está cadastrado, se não tiver ele não permite que a inserção prossiga
		If Not objRSLocal.EOF Then
			intStatusCred = ValidateValueSQL(GetValue(objRSLocal,"cod_status_cred"),"NUM",true)
		Else
			Response.Write("O tipo de credencial correspondente não está cadastrado")
			Response.End()
		End If
		
		'Comando de inserção já com os dados tratados
		strSQLLocal = " UPDATE tbl_empresas SET "
		strSQLLocal = strSQLLocal & "   nomecli = " & strNomeCli & ", nomefan = " & strNomeFan & ", id_num_doc1 = " & strIdNumDoc1 & ", id_num_doc2 = " & strIdNumDoc2
		strSQLLocal = strSQLLocal & " , email1 = " & strEmail & ", fone4 = " & strFone4 & ", fone1 = " & strFone1 & ", fone3 = " & strFone3 & ", fone2 = " & strFone2
		strSQLLocal = strSQLLocal & " , sys_dataat = " & dateSysDataAt & ", sys_userca = " & strSysUserAt & ", end_full = " & strEndereco & ", end_bairro = " & strBairro & ", end_cidade = " & strCidade
		strSQLLocal = strSQLLocal & " , end_estado = " & strEstado & " , end_cep = " & strCEP & ", cod_status_preco = " & intStatusPreco & ", cod_status_cred = " & intStatusCred 
		strSQLLocal = strSQLLocal & " , extra_txt_1 = " & strExtraTXT1 & " , entidade = " & strEntidade & " , senha = " & strSenha
		strSQLLocal = strSQLLocal & " WHERE cod_empresa = " & strCodEmpresa 
		objConnLocal.execute(strSQLLocal)
		
		Set objRSLocal = objConnLocal.execute("SELECT senha FROM tbl_empresas WHERE cod_empresa = " & strCodEmpresa)
		
		strBODY = "<table border='0' align='center'>"&_
				  "<tr><td>Dados para acesso da area restrita - " & Session("AR_NOME_EVENTO") & "</td></tr>"&_
				  "<tr><td>Login: " & Replace(strIdNumDoc1,"'","") & "</td></tr>" &_
				  "<tr><td>Senha: " & Replace(strSenha,"'","")  & "</td></tr>" &_
				  "<tr><td>Link de acesso <a href='http://pvista.proevento.com.br/" & CFG_IDCLIENTE & "/arearestrita/?cod_evento=" & Session("AR_COD_EVENTO") & "'>Área Restrita - " & Session("AR_NOME_EVENTO") & "</a></td></tr>"&_
				  "</table>"
			  
		strASSUNTO = "Senha de acesso a area do expositor - " & Session("AR_NOME_EVENTO") 
		AthEnviaMail Replace(strEmail,"'",""), Session("AR_EMAIL_SENDER"), "", CFG_EMAIL_AUDITORIA_PROEVENTO & ";" & CFG_EMAIL_AUDITORIA_CLIENTE, strASSUNTO, strBODY, 1, 0, 0, ""
		
		FechaRecordset objRSLocal
	Else
		strCodEmpresa = "NULL"
	End If
	
	strSQLLocal = "UPDATE tbl_inscricao_expositor SET cod_empresa_montadora = " & strCodEmpresa & " WHERE cod_empresa = " & Session("EMP_COD_EMPRESA")
	objConnLocal.execute(strSQLLocal)
	
	AlteraMontadora = GetParam(prPrefix & "cod_empresa")
	
	'Fechamento da conexão do banco e recordset
	FechaDBConn objConnLocal
End Function

'Gera o cod_empresa conforme o usuário passado por parâmetro.
Function GeraCodEmpresa(prUser)
	Dim strSQLLocal, objRSLocal, objConnLocal
	Dim strCodBarra
	
	AbreDBConn objConnLocal, CFG_DB_DADOS
	
	'Pesquisa o ultimo cod_empresa inserido para aquele usuário
	strSQLLocal = " SELECT last_gen_id FROM tbl_usuario WHERE id_user = '" & Replace(prUser,"'","''") & "' AND dt_inativo IS NULL "
	Set objRSLocal = objConnLocal.execute(strSQLLocal)
	
	If Not objRSLocal.EOF Then
		' Acrescenta 1 no último codigo para continuar a sequência
		strCodBarra = GetValue(objRSLocal,"last_gen_id") + 1
		strCodBarra = Right("000000" & strCodBarra,6)
		
		' Salva o codigo gerado no campo last_gen_id como o ultimo usado
		strSQLLocal = " UPDATE tbl_usuario SET last_gen_id = '" & strCodBarra & "' WHERE id_user = '" & Replace(prUser,"'","''") & "' AND dt_inativo IS NULL "
		objConnLocal.execute(strSQLLocal)
	Else
		strCodBarra = Null
	End If
	
	FechaRecordset objRSLocal
	FechaDBConn objConnLocal
	
	GeraCodEmpresa = strCodBarra
End Function

'Insere um convidado conforme parâmetros passados.
Function InsereConvidado(prPrefix, prSufix)
	Dim objConnLocal, strSQLLocal
	Dim strCodEmpresa, strNome, strEmail, strCargo, strEmpresa
	Dim dateDtEnvio, strFone, strCPF, dateSysDataCa, strTipo
	Dim strEndereco, strCidade, strCEP, strEstado, strCodBarra, strCodEvento
	
	' Recupera as informações da insercao via GetParam
	strCodEmpresa = ValidateValueSQL(GetParam(prPrefix & "cod_empresa" & prSufix),"STR",true)
	strCodEvento  = ValidateValueSQL(GetParam(prPrefix & "cod_evento" & prSufix),"STR",true)
	strNome       = ValidateValueSQL(GetParam(prPrefix & "nome" & prSufix),"STR",true)
	strEmail      = ValidateValueSQL(GetParam(prPrefix & "email" & prSufix),"STR",false)
	strCargo      = ValidateValueSQL(GetParam(prPrefix & "cargo" & prSufix),"STR",false)
	strEmpresa    = ValidateValueSQL(GetParam(prPrefix & "empresa" & prSufix),"STR",false)
	dateDtEnvio   = ValidateValueSQL(GetParam(prPrefix & "dt_envio" & prSufix),"DATETIME",false)
	strFone       = ValidateValueSQL(GetParam(prPrefix & "fone" & prSufix),"STR",false)
	strCPF        = ValidateValueSQL(GetParam(prPrefix & "cpf" & prSufix),"STR",false)
	dateSysDataCa = ValidateValueSQL(Now(),"AUTODATETIME",true)
	strTipo       = ValidateValueSQL(GetParam(prPrefix & "tipo" & prSufix),"STR",true)
	strEstado     = ValidateValueSQL(GetParam(prPrefix & "estado" & prSufix),"STR",false)
	strCEP        = ValidateValueSQL(GetParam(prPrefix & "cep" & prSufix),"STR",false)
	strCidade     = ValidateValueSQL(GetParam(prPrefix & "cidade" & prSufix),"STR",false)
	strEndereco   = ValidateValueSQL(GetParam(prPrefix & "endereco" & prSufix),"STR",false)
	strCodBarra   = ValidateValueSQL(GetParam(prPrefix & "codbarra" & prSufix),"STR",false)
	
	'Abertura do banco
	AbreDBConn objConnLocal, CFG_DB_DADOS
	
	'Comando de inserção já com os dados tratados
	strSQLLocal = " INSERT INTO tbl_expositor_convite (cod_empresa, cod_evento, nome, email, cargo, empresa, dt_envio, fone, cpf, sys_dataca, tipo, estado, cep, cidade, endereco, codbarra) "
	strSQLLocal = strSQLLocal & " VALUES (" & strCodEmpresa & ", " & strCodEvento & ", " & strNome & ", " & strEmail & ", " & strCargo & ", " & strEmpresa
	strSQLLocal = strSQLLocal & ", " & dateDtEnvio & ", " & strFone & ", " & strCPF & ", " & dateSysDataCa & ", " & strTipo
	strSQLLocal = strSQLLocal & ", " & strEstado & ", " & strCEP & ", " & strCidade & ", " & strEndereco & ", " & strCodBarra & ")"
	objConnLocal.execute(strSQLLocal)
	
	'Fechamento da conexão do banco
	FechaDBConn objConnLocal
End Function

'Insere um convidado conforme parâmetros passados.
Function AtualizaConvidado(prPrefix)
	Dim objConnLocal, strSQLLocal
	Dim intIDAuto, strCodEmpresa, strNome, strEmail, strCargo, strEmpresa
	Dim dateDtEnvio, strFone, strCPF, dateSysDataCa, strTipo
	Dim strEndereco, strCidade, strCEP, strEstado, strCodBarra
	
	' Recupera as informações da insercao via GetParam
	intIDAuto     = ValidateValueSQL(GetParam(prPrefix & "id_auto"),"NUM",true)
	strCodEmpresa = ValidateValueSQL(GetParam(prPrefix & "cod_empresa"),"STR",true)
	strCodEmpresa = ValidateValueSQL(GetParam(prPrefix & "cod_event"),"STR",true)
	strNome       = ValidateValueSQL(GetParam(prPrefix & "nome"),"STR",true)
	strEmail      = ValidateValueSQL(GetParam(prPrefix & "email"),"STR",true)
	strCargo      = ValidateValueSQL(GetParam(prPrefix & "cargo"),"STR",true)
	strEmpresa    = ValidateValueSQL(GetParam(prPrefix & "empresa"),"STR",true)
	dateDtEnvio   = ValidateValueSQL(GetParam(prPrefix & "dt_envio"),"DATETIME",false)
	strFone       = ValidateValueSQL(GetParam(prPrefix & "fone"),"STR",false)
	strCPF        = ValidateValueSQL(GetParam(prPrefix & "cpf"),"STR",false)
	dateSysDataCa = ValidateValueSQL(GetParam(prPrefix & "sys_dataca"),"AUTODATETIME",true)
	strTipo       = ValidateValueSQL(GetParam(prPrefix & "tipo"),"STR",true)
	strEstado     = ValidateValueSQL(GetParam(prPrefix & "estado"),"STR",false)
	strCEP        = ValidateValueSQL(GetParam(prPrefix & "cep"),"STR",false)
	strCidade     = ValidateValueSQL(GetParam(prPrefix & "cidade"),"STR",false)
	strEndereco   = ValidateValueSQL(GetParam(prPrefix & "endereco"),"STR",false)
	strCodBarra   = ValidateValueSQL(GetParam(prPrefix & "codbarra"),"STR",false)
	
	'Abertura do banco
	AbreDBConn objConnLocal, CFG_DB_DADOS
	
	'Comando de atualização já com os dados tratados
	strSQLLocal = " UPDATE tbl_convite_expositor SET "
	strSQLLocal = strSQLLocal & "   cod_empresa = " & strCodEmpresa & ", nome = " & strNome & ", email = " & strEmail & ", cargo = " & strCargo & ", empresa = " & strEmpresa
	strSQLLocal = strSQLLocal & " , dt_envio = " & dateDtEnvio & ", fone = " & strFone & ", cpf = " & strCPF & ", sys_dataca = " & dateSysDataCa & ", tipo = " & strTipo
	strSQLLocal = strSQLLocal & " , estado = " & strEstado & ", cep = " & strCEP & ", cidade = " & strCidade & ", endereco = " & strEndereco & ", codbarra = " & strCodBarra
	strSQLLocal = strSQLLocal & " WHERE id_auto = " & intIDAuto
	objConnLocal.execute(strSQLLocal)
	
	'Fechamento da conexão do banco
	FechaDBConn objConnLocal
End Function

Function GeraProxCodBarra(prCodEmpresa)
	If prCodEmpresa <> "" And prCodEmpresa <> "NULL" Then
		Dim strCOD_EMPRESA, strCOD_BARRA, objRSLocal
		
		strCOD_EMPRESA = ValidateValueSQL(prCodEmpresa,"STR",false)
		
		strSQL = " SELECT MAX(codbarra) AS ult_codbarra FROM tbl_empresas_sub WHERE cod_empresa = " & strCOD_EMPRESA
		Set objRSLocal = objConn.execute(strSQL)
		
		If Not objRSLocal.EOF Then
			If GetValue(objRSLocal,"ult_codbarra") = "" Then strCOD_BARRA = prCodEmpresa & "011" Else strCOD_BARRA = GetValue(objRSLocal,"ult_codbarra")
		End If
		
		GeraProxCodBarra = Right("000000000" & (CLng(strCOD_BARRA) + 1),9)
	End If
End Function


'===============================================
' CONSTANTES DE SERVIÇOS
'===============================================
Dim CAT_BASICA, CAT_MONTAGEM_B, CAT_MONTAGEM_C, CAT_MONTAGEM_ESPACO, CAT_PERMUTA
Dim PROD_PREFEITURA, PROD_ELETRICA, PROD_ELETRICA_MONTAGEM, PROD_LIMPEZA, PROD_LIMPEZA_MONTAGEM
Dim PROD_CREDENCIAL_EXP, PROD_CREDENCIAL_SERV, PROD_RECEPCIONISTA_PT, PROD_RECEPCIONISTA_EN, PROD_RECEPCIONISTA_EN_PT
Dim PROD_HIDRAULICA_INT, PROD_HIDRAULICA_EXT, PROD_ELETRICA_ADICIONAL, PROD_SEGURANCA_ESTANDE, PROD_EXTINTORES, PROD_EXTINTORES_EXT
Dim PROD_PAISAGISMO_A, PROD_PAISAGISMO_B, PROD_PLACA_IDENTIFICACAO, PROD_COR_CARPETE_COLUNA, PROD_CREDENCIAL_VIP
Dim PROD_CREDENCIAL_ELETRONICO, PROD_CREDENCIAL_MON, PROD_CREDENCIAL_SEG, PROD_CREDENCIAL_SEG_EXT, PROD_ELETRICA_AD, PROD_ELETRICA_AD_EXT
Dim PROD_SEGURANCA_ESTANDE_1, PROD_SEGURANCA_ESTANDE_2
Dim PROD_SEGURANCA_ESTANDE_3, PROD_SEGURANCA_ESTANDE_4
Dim PROD_PAISAGISMO_C, PROD_PAISAGISMO_D, PROD_CONVITE_PT, PROD_CONVITE_ES
Dim PROD_CATALOGO_COLIGADA, PROD_LIMPEZA_INT, PROD_LIMPEZA_EXT
Dim PROD_SEGURANCA_ESTANDE_1_EXT, PROD_SEGURANCA_ESTANDE_2_EXT, PROD_SEGURANCA_ESTANDE_3_EXT, PROD_SEGURANCA_ESTANDE_4_EXT
Dim PROD_MOBILIARIO

' Constantes com as categorias usadas na AR
CAT_PERMUTA         = 66
CAT_BASICA 		    = 68
CAT_MONTAGEM_B 	    = 65 'Basica Plus
CAT_MONTAGEM_C 	    = 69 'Pact Completo
CAT_MONTAGEM_ESPACO = 67

'PROD_PREFEITURA 		  = 100
'PROD_ELETRICA 		      = 101
'PROD_LIMPEZA_MONTAGEM    = 104
'PROD_ELETRICA_MONTAGEM   = 102
'PROD_CONVITE_PT          = 119
'PROD_CONVITE_ES          = 120
'PROD_CREDENCIAL_VIP      = 123
'PROD_RECEPCIONISTA_EN_PT = 124
'PROD_CATALOGO_COLIGADA   = 130
PROD_CREDENCIAL_EXP      	 = 166
PROD_CREDENCIAL_SERV     	 = 167
PROD_CREDENCIAL_SEG      	 = 168
PROD_RECEPCIONISTA_PT    	 = 169
PROD_HIDRAULICA_INT        	 = 170
PROD_ELETRICA_AD         	 = 171
PROD_ELETRICA_AD_EXT     	 = 172
PROD_LIMPEZA 			 	 = 173
PROD_LIMPEZA_EXT         	 = 174
PROD_LIMPEZA_INT         	 = 175
PROD_SEGURANCA_ESTANDE_1 	 = 176 ' Período INTERNO das 21:00 de 04/04/2011 até as 13:00 de 05/04/2011 
PROD_SEGURANCA_ESTANDE_2 	 = 177 ' Período INTERNO das 21:00 de 05/04/2011 até as 13:00 de 06/04/2011
PROD_SEGURANCA_ESTANDE_3 	 = 178 ' Período INTERNO das 21:00 de 06/04/2011 até as 13:00 de 07/04/2011 
PROD_SEGURANCA_ESTANDE_4 	 = 179 ' Período INTERNO das 21:00 de 07/04/2011 até as 13:00 de 08/04/2011
PROD_SEGURANCA_ESTANDE_1_EXT = 180 ' Período EXTERNO das 21:00 de 04/04/2011 até as 13:00 de 05/04/2011 
PROD_SEGURANCA_ESTANDE_2_EXT = 181 ' Período EXTERNO das 21:00 de 05/04/2011 até as 13:00 de 06/04/2011
PROD_SEGURANCA_ESTANDE_3_EXT = 182 ' Período EXTERNO das 21:00 de 06/04/2011 até as 13:00 de 07/04/2011
PROD_SEGURANCA_ESTANDE_4_EXT = 183 ' Período EXTERNO das 21:00 de 07/04/2011 até as 13:00 de 08/04/2011
PROD_EXTINTORES 		 	 = 184
PROD_EXTINTORES_EXT      	 = 185
PROD_CREDENCIAL_SEG_EXT  	 = 187
PROD_PAISAGISMO_A		 	 = 188	
PROD_PAISAGISMO_B		 	 = 189
PROD_PAISAGISMO_C		 	 = 190
PROD_PAISAGISMO_D		 	 = 191
PROD_COR_CARPETE_COLUNA  	 = 193
PROD_CREDENCIAL_ELETRONICO 	 = 192
PROD_CREDENCIAL_MON      	 = 194
PROD_PLACA_IDENTIFICACAO     = 195
PROD_HIDRAULICA_EXT        	 = 199
PROD_CREDENCIAL_VIP          = 202
PROD_MOBILIARIO              = 212

'Pega o valor correspondente ao periodo
Function GetPeriodValue(prArrPeriod, prArrValues)
Dim i
	i = 0
	Do While i <= UBound(prArrPeriod)
		If CDate(prArrPeriod(i)) >= Date() Then
			GetPeriodValue = prArrValues(i)
			Exit Do
		Else
			GetPeriodValue = prArrValues(UBound(prArrValues))
		End If 
		
		i = i + 1
	Loop
End Function


Function GetCurValorServ(prCodServ)
	GetCurValorServ = GetValorServDate(prCodServ, Date)
End Function

Function GetValorServDate(prCodServ, prDate)
	Dim objRSLocal, objConnLocal
	
	AbreDBConn objConnLocal, CFG_DB_DADOS
	
	strSQL = " 		   SELECT vlr "
	strSQL = strSQL & "  FROM tbl_aux_servicos AS s " 
	strSQL = strSQL & " 	 INNER JOIN tbl_aux_servicos_periodo AS sp ON (s.cod_serv = sp.cod_serv) "
	strSQL = strSQL & " WHERE s.cod_serv = " & prCodServ
	strSQL = strSQL & "   AND (" & ValidateValueSQL(prDate,"DATE",false) & " BETWEEN dt_ini AND dt_fim OR (dt_ini IS NULL AND dt_fim IS NULL)) "
	'strSQL = strSQL & "   AND (" & ValidateValueSQL(strMETRAGEM,"NUM",false) & " BETWEEN qtde_ini AND qtde_fim OR (qtde_ini IS NULL AND qtde_fim IS NULL)) "
	strSQL = strSQL & "   AND cod_evento = " & ValidateValueSQL(Session("AR_COD_EVENTO"),"NUM",false)
	strSQL = strSQL & "   AND lang = " & ValidateValueSQL(Session("AR_LANG"),"STR",false)
	strSQL = strSQL & "   AND (sp.cod_status_preco RLIKE concat('^'," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",',?') "
	strSQL = strSQL & " 	   OR sp.cod_status_preco RLIKE concat(','," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",',') "
	strSQL = strSQL & " 	   OR sp.cod_status_preco RLIKE concat(','," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",'$') OR sp.cod_status_preco IS NULL) "
	strSQL = strSQL & "   AND (sp.cod_status_cred RLIKE concat('^'," & ValidateValueSQL(Session("EMP_COD_STATUS_CRED"),"STR",false) & ",',?') "
	strSQL = strSQL & " 	   OR sp.cod_status_cred RLIKE concat(','," & ValidateValueSQL(Session("EMP_COD_STATUS_CRED"),"STR",false) & ",',') "
	strSQL = strSQL & " 	   OR sp.cod_status_cred RLIKE concat(','," & ValidateValueSQL(Session("EMP_COD_STATUS_CRED"),"STR",false) & ",'$') OR sp.cod_status_cred IS NULL) "
	Set objRSLocal = objConnLocal.execute(strSQL)
	
	If Not objRSLocal.EOF Then
		GetValorServDate = GetValue(objRSLocal,"vlr")
	End If
	
	FechaDBConn objConnLocal
End Function

Function GetListValorServ(prCodServ, prFlagTextBox, prFlagReadOnly)
	Dim objRSLocal, objConnLocal, strPeriodo, strFlagReadOnly
	Dim strAux, i
	ReDim arrPeriodo(0), arrValues(0)
	
	AbreDBConn objConnLocal, CFG_DB_DADOS
	
	strSQL = " 		   SELECT vlr, DATE_FORMAT(dt_fim,'%d/%m/%Y') AS dt_fim "
	strSQL = strSQL & "  FROM tbl_aux_servicos AS s " 
	strSQL = strSQL & " 	 INNER JOIN tbl_aux_servicos_periodo AS sp ON (s.cod_serv = sp.cod_serv) "
	strSQL = strSQL & " WHERE s.cod_serv = " & prCodServ
	strSQL = strSQL & "   AND cod_evento = " & ValidateValueSQL(Session("AR_COD_EVENTO"),"NUM",false)
	strSQL = strSQL & "   AND lang = " & ValidateValueSQL(Session("AR_LANG"),"STR",false)
	strSQL = strSQL & "   AND (sp.cod_status_preco RLIKE concat('^'," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",',?') "
	strSQL = strSQL & " 	   OR sp.cod_status_preco RLIKE concat(','," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",',') "
	strSQL = strSQL & " 	   OR sp.cod_status_preco RLIKE concat(','," & ValidateValueSQL(Session("EMP_CATEGORIA"),"STR",false) & ",'$') OR sp.cod_status_preco IS NULL) "
	strSQL = strSQL & "   AND (sp.cod_status_cred RLIKE concat('^'," & ValidateValueSQL(Session("EMP_COD_STATUS_CRED"),"STR",false) & ",',?') "
	strSQL = strSQL & " 	   OR sp.cod_status_cred RLIKE concat(','," & ValidateValueSQL(Session("EMP_COD_STATUS_CRED"),"STR",false) & ",',') "
	strSQL = strSQL & " 	   OR sp.cod_status_cred RLIKE concat(','," & ValidateValueSQL(Session("EMP_COD_STATUS_CRED"),"STR",false) & ",'$') OR sp.cod_status_cred IS NULL) "	
	strSQL = strSQL & " ORDER BY dt_ini "
	'Response.Write(strSQL)
	Set objRSLocal = objConnLocal.execute(strSQL)
	
	If Not objRSLocal.EOF Then
		i = 0
		
		'Preenche arrays com as datas e valores ordenados
		While Not objRSLocal.EOF
			arrPeriodo(i) = GetValue(objRSLocal,"dt_fim")
			arrValues(i) = GetValue(objRSLocal,"vlr")
			objRSLocal.MoveNext
			
			If Not objRSLocal.EOF Then
				i = i + 1
				ReDim Preserve arrPeriodo(i) 
				ReDim Preserve arrValues(i)
			End If
		WEnd
		
		'Verifica qual é o periodo atual para colocar o textbox certo
		i = 0
		Do While i <= UBound(arrPeriodo)
			If CDate(arrPeriodo(i)) >= Date() Then
				strPeriodo = Left(Replace(arrPeriodo(i),"/",""),4)
				Exit Do
			End If 
			
			i = i + 1
		Loop
		
		If prFlagReadOnly Then
			strFlagReadOnly = " readonly='true' "
		End If
		
		Response.Write("				<script type=""text/javascript"" language=""javascript"">"&vbCrLf)
		Response.Write("					var strPeriodo = '" & strPeriodo & "';"&vbCrLf)
		Response.Write("					function soma(qtd) { "&vbCrLf)
		Response.Write("						switch (strPeriodo) {"&vbCrLf)
													For i = 0 To UBound(arrPeriodo) 
														strAux = Left(Replace(arrPeriodo(i),"/",""),4)
		Response.Write("							case '" & strAux & "':  "&vbCrLf)
		Response.Write("								vV='" & arrValues(i) & "';"&vbCrLf)
		Response.Write("								break;"&vbCrLf)
													Next
		Response.Write("						}"&vbCrLf)
		Response.Write("						document.forms[0].var_sol_qtde.value = qtd;"&vbCrLf)
		Response.Write("						total=parseFloat(qtd)*parseFloat(vV);"&vbCrLf)
		Response.Write("						document.forms[0].var_total.value=Formata(total); "&vbCrLf)
		Response.Write("					}"&vbCrLf)
		
		

		Response.Write("					function Formata(amount) {"&vbCrLf)
		Response.Write("						var i = parseFloat(amount);"&vbCrLf)
		Response.Write("						if(isNaN(i)) { i = 0.00; }"&vbCrLf)
		Response.Write("						var minus = '';"&vbCrLf)
		Response.Write("						if(i < 0) { minus = '-'; }"&vbCrLf)
		Response.Write("						i = Math.abs(i);"&vbCrLf)
		Response.Write("						i = parseInt((i + .0005) * 100);"&vbCrLf)
		Response.Write("						i = i / 100;"&vbCrLf)
		Response.Write("						s = new String(i);"&vbCrLf)
		Response.Write("						if(s.indexOf('.') < 0) { s += '.00'; }"&vbCrLf)
		Response.Write("						if(s.indexOf('.') == (s.length - 2)) { s += '0'; }"&vbCrLf)
		Response.Write("						s = s.replace(""."","","");"&vbCrLf)
		Response.Write("						s = minus + s;"&vbCrLf)
		Response.Write("						return s;"&vbCrLf)
		Response.Write("					}"&vbCrLf)		
		
		
		Response.Write("					function somenteNumero(e){"&vbCrLf)
		Response.Write("						var tecla=(window.event)?event.keyCode:e.which;"&vbCrLf)
		Response.Write("						if((tecla > 47 && tecla < 58)) return true;"&vbCrLf)
		Response.Write("						else{"&vbCrLf)
		Response.Write("						if (tecla != 8) return false;"&vbCrLf)
		Response.Write("						else return true;"&vbCrLf)
		Response.Write("						}"&vbCrLf)
		Response.Write("					}"&vbCrLf)				
		
		
		Response.Write("				</script>"&vbCrLf)
		
		Response.Write("				<table width=""100%"" border=""1"" align=""center"">"&vbCrLf)
		
		If UBound(arrPeriodo) > 0 Then
		Response.Write("					<tr>"&vbCrLf)
		Response.Write("						<td align=""center"">&nbsp;</td>"&vbCrLf)
		
												For i = 0 To UBound(arrPeriodo) 
													strAux = Left(arrPeriodo(i),5)
		Response.Write("						<td align=""center"">Solicita&ccedil;&otilde;es at&eacute; " & strAux & " </td>"&vbCrLf)
												Next 
												
		Response.Write("					</tr>"&vbCrLf)
		End If
		
		If prFlagTextBox Then
		
		Response.Write("					<tr>"&vbCrLf)
		Response.Write("						<td align=""center"">Quantidade</td>"&vbCrLf)
		
												For i = 0 To UBound(arrPeriodo) 
													strAux = Left(Replace(arrPeriodo(i),"/",""),4)
		Response.Write("						<td align=""center"">"&vbCrLf)
													If strPeriodo = strAux Then
		Response.Write("							<input type=""text"" name=""var_sol_qtde"" onkeypress=""return somenteNumero(event)"" id=""var_sol_qtde"" onBlur=""soma(this.value)"" " & strFlagReadOnly & " class=""textbox100""/>"&vbCrLf)
													End If
		Response.Write("						</td>"&vbCrLf)
												Next 
												
		Response.Write("					</tr>"&vbCrLf)
		
		End If
		
		Response.Write("					<tr>"&vbCrLf)
		Response.Write("						<td align=""center"">Valor</td>"&vbCrLf)
												For i = 0 To UBound(arrValues)
		Response.Write("						<td align=""center"">R$ " & FormatNumber(arrValues(i),2) & "</td>"&vbCrLf)
												Next
		Response.Write("					</tr>"&vbCrLf)
		If prFlagTextBox Then
		Response.Write("					<tr>"&vbCrLf)
		Response.Write("						<td colspan=""" & i+1 & """ align=""right"">Total:&nbsp;<input type=""text"" name=""var_total"" class=""textbox100"" readonly=""true""/></td>"&vbCrLf)
		Response.Write("					</tr>"&vbCrLf)
		End If
		Response.Write("				</table>"&vbCrLf)
	End If
	
	FechaDBConn objConnLocal
End Function

'Insere um pedido conforme os parâmetros passados.
Function InserePedido()

End Function

'Insere um pedido ou um conjunto para geração de uma cobrança.
Function InsereTitulo()

End Function

'Dispara um lote de e-mail com determinado tamanho e tipo.
Function DisparaLoteEmail(prLoteSize, prTipoLote, prFlagReenvio)
	Dim objRSLocal, objConnLocal, strSQLLocal, strBodyLocal
	Dim strBody, strAssunto, strEmails, strCodConvidado, i
	
	
	AbreDBConn objConnLocal, CFG_DB_DADOS
	
	Set objRSLocal = objConnLocal.execute(" SELECT convite_" & prTipoLote & "_texto AS texto, email_auditoria_caex FROM tbl_area_restrita_expositor WHERE cod_evento = " & ValidateValueSQL(Session("AR_COD_EVENTO"),"STR",false) & " AND lang = " & ValidateValueSQL(Session("AR_LANG"),"STR",false))
	
	If Not objRSLocal.EOF Then
		strBody    = GetValue(objRSLocal,"texto")
		strAssunto = "" & Session("EMP_NOME") & " convida você para " & Session("AR_NOME_EVENTO")
		
		strSQLLocal = " 			 SELECT id_auto, nome, email "
		strSQLLocal = strSQLLocal & "  FROM tbl_expositor_convite "
		strSQLLocal = strSQLLocal & " WHERE cod_empresa = " & ValidateValueSQL(Session("EMP_COD_EMPRESA"),"STR",false)
		strSQLLocal = strSQLLocal & "   AND email IS NOT NULL AND email <> '' "

		strSQLLocal = strSQLLocal & "   AND DT_INATIVO IS NULL "
		
		strSQLLocal = strSQLLocal & "   AND tipo = " & ValidateValueSQL(prTipoLote,"STR",false)
		strSQLLocal = strSQLLocal & "   AND cod_evento = " & ValidateValueSQL(Session("AR_COD_EVENTO"),"STR",false)
		If prFlagReenvio = false Then
			strSQLLocal = strSQLLocal & " AND dt_envio IS NULL "
		End If 
		Set objRSLocal = objConnLocal.execute(strSQLLocal)
		
		i = 0
		strEmails = ""
		strCodConvidado = ""
		While Not objRSLocal.EOF 
			i = i + 1
			strBodyLocal = Replace(strBody, "{PRO_LOCALIZACAO_ESTANDE}", strEXP_LOCALIZACAO&"")
			strBodyLocal = Replace(strBodyLocal, "{PRO_EXPOSITOR}", Session("EMP_NOME")&"")
			strBodyLocal = Replace(strBodyLocal, "{PRO_NOMECLIENTE}", GetValue(objRSLocal,"nome")&"")
			
			strEmails = strEmails & GetValue(objRSLocal,"email")&";"
			strCodConvidado = strCodConvidado & GetValue(objRSLocal,"id_auto")&","
			
			'If i mod prLoteSize = 0 Then
			AthEnviaMail GetValue(objRSLocal,"email"), Session("AR_EMAIL_SENDER"), "", CFG_EMAIL_AUDITORIA_PROEVENTO&";"&GetValue(objRSLocal,"email_auditoria_caex"), strAssunto, strBodyLocal, 1, 0, 0, ""
			'End If
			
			objRSLocal.MoveNext
		Wend
		
		If strCodConvidado <> "" Then
			objConnLocal.execute(" UPDATE tbl_expositor_convite SET dt_envio = current_timestamp WHERE id_auto IN (" & Mid(strCodConvidado,1,Len(strCodConvidado)-1) & ") ")
		End If
	End If
	
	DisparaLoteEmail = i
End Function
%>