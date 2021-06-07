<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->
<%
 
  
Dim objConn, objRS, objLang, strSQL 'banco
Dim arrScodi,arrSdesc 'controle
Dim strLng, strLOCALE, icodinscricao
Dim strCOD_EVENTO, strCategoria
Dim strLinkDefault, i
Dim strTitulo, strDescricao, strCodProd, dblDescontoPromo, dblVlrFixoPromo, strCodProdPromo, flagCodigoPromo, dblValorProduto,intQuantidade
Dim strCodigoPromo, dblDescontoProduto, dblVlrFixo, objRSPromo,strIDUSER_LOJA,strCodInscricao, strAction
 
Dim str_ID_NUMDOC1 , str_EMAIL, str_NOME_COMPLETO, str_NOME_CREDENCIAL, str_DATA_NASC, str_SEXO, str_IMG_FOTO, strCategoriaCred
Dim str_DDD1, str_DDI1, str_FONE1, str_DDI3, str_DDD3, str_FONE3, str_DDI4, str_DDD4, str_FONE4
Dim str_DEPARTAMENTO, str_CARGO, str_EMAIL_COMERCIAL, str_NECESSIDADE_ESPECIAL, str_CEP, str_ENDERECO,strCOD_EMPRESA
Dim str_END_NUM, str_END_COMPLEMENTO, str_BAIRRO, str_CIDADE, str_ESTADO, str_PAIS, str_CNPJ, str_RAZAO_SOCIAL, str_NOME_FANTASIA, str_CODATIV,str_ENDERECO_COMPLETO
Dim strTIPO_PESS , str_status_cred, strFormaPgto,strCOD_PAIS
 
CFG_DB          = getParam("db")
strLng          = getParam("lng")
strCOD_EVENTO   = getParam("cod_evento")
strCategoria    = getParam("var_categoria")
strCodProd      = getParam("cod_prod")
dblValorProduto = getParam("vlr_prod")
intQuantidade   = getParam("combo_quantidade")
strCOD_EMPRESA  = getParam("var_cod_empresa") 
'response.Write("<br>************************************<br>")
'response.write("<strong>PARAMETROS RECEBIDOS</strong><BR>")
'RESPONSE.WRITE("DB :"         & CFG_DB          &"<BR>")
'RESPONSE.WRITE("Lng: "        & strLng          &"<BR>")
'RESPONSE.WRITE("Evento: "     & strCOD_EVENTO   &"<BR>")
'RESPONSE.WRITE("Categoria: "  & strCategoria    &"<BR>")
'RESPONSE.WRITE("CodProd: "    & strCodProd      &"<BR>")
'RESPONSE.WRITE("VlrProd: "    & dblValorProduto &"<BR>")
'RESPONSE.WRITE("Quantidade: " & intQuantidade   &"<BR>")
'RESPONSE.WRITE("CodEmpresa: " & strCOD_EMPRESA  &"<BR>")
'response.Write("<br>************************************")

 if CFG_DB = "" Then  ' -------------------------------------------------------------------------------------------------------
	 CFG_DB = Request.Cookies("pVISTA")("DBNAME") 					'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
	 if ( (CFG_DB = Empty) OR (Cstr(CFG_DB) = "") ) then
		auxStr = lcase(Request.ServerVariables("PATH_INFO"))      	'retorna: /aspsystems/virtualboss/proevento/login.asp ou /proevento/login.asp
		response.Write(auxStr)
		auxStr = Mid(auxStr,1,inStr(auxStr,"/proshoppf/processa_cadastro.asp")-1) 	'retorna: /aspsystems/virtualboss/proevento ou /proevento
		auxStr = replace(auxStr,"/aspsystems/_pvista/","")        	'retorna: proevento ou /proevento
		auxStr = replace(auxStr,"/","")                           	'retorna: proevento
		CFG_DB = auxStr + "_dados"
		CFG_DB = replace(CFG_DB,"_METRO_dados","METRO_dados") 	'Caso especial, banco do ambiente /_pvista não tem o "_" no nome "
		Response.Cookies("sysMetro")("DBNAME") = CFG_DB			'cfg_db nao esta vazio grava no cookie
	 end if 
End If
AbreDBConn objConn, CFG_DB
'' ----------------------------------------------------------------------------------------------------------
' 
' 
'' --------------------------------------------------------------------------------
' ' INI: LANG - tratando o Lng que por padrão pVISTA é diferente de LOCALE da função
 Select Case ucase(strLng)
	Case "BR"		strLOCALE = "pt-br"
	Case "US","EN","INTL"	strLOCALE = "en-us" 'colocar idioma INTL
	Case "SP"		strLOCALE = "es"
	Case Else strLOCALE = "pt-br"
 End Select
 if strLng = "INTL" Then
 	strCOD_PAIS = "EN"
end if
' ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang strLOCALE,"./lang/"
 ' FIM: LANG (ex. de uso: response.wrire(objLang.SearchIndex("area_restrita",0))
' ' -------------------------------------------------------------------------------
'
'
' ' -------------------------------------------------------------------------------
 ' INI: Busca dados relativos as informações de ambiente do sistema (SITE_INFO)
'
 ' Cookies de ambiente PAX (não optamos por session, pq expira muito fácil/rápido e cokies são acessíveis fora da caixa de areia ------------------------------- '
 Response.Cookies("METRO_ProShopPF").Expires = DateAdd("h",2,now)
 Response.Cookies("METRO_ProShopPF")("locale")	  = strLOCALE
 'response.Write("<br><strong>COM GETPARAM: "&getParam("var_razao_social")&"</strong>")
 ' response.Write("<br><strong>COM REQUEST: "&request("var_razao_social")&"</strong>")
 ' response.end()
str_ID_NUMDOC1                  = Trim(uCase(getParam("var_id_numdoc1")))
str_EMAIL						= Trim(uCase(getParam("var_email")))
str_NOME_COMPLETO				= Trim(uCase(getParam("var_nome_completo")))
str_NOME_CREDENCIAL				= Trim(uCase(getParam("var_nome_credencial")))
str_DATA_NASC					= Trim(uCase(getParam("var_data_nasc")))
str_SEXO						= Trim(uCase(getParam("var_sexo")))
str_IMG_FOTO					= Trim(uCase(getParam("var_img_foto")))
str_DDD1						= Trim(uCase(getParam("var_ddd1")))
str_DDI1						= Trim(uCase(getParam("var_ddi1")))
str_FONE1						= Trim(uCase(getParam("var_fone1")))
str_DDI3						= Trim(uCase(getParam("var_ddi3")))
str_DDD3						= Trim(uCase(getParam("var_ddd3")))
str_FONE3						= Trim(uCase(getParam("var_fone3")))
str_DDI4						= Trim(uCase(getParam("var_ddi4")))
str_DDD4						= Trim(uCase(getParam("var_ddd4")))
str_FONE4						= Trim(uCase(getParam("var_fone4")))
str_DEPARTAMENTO				= Trim(uCase(getParam("var_departamento")))
str_CARGO						= Trim(uCase(getParam("var_cargo")))
str_EMAIL_COMERCIAL				= Trim(uCase(getParam("var_email_comercial")))
str_NECESSIDADE_ESPECIAL		= Trim(uCase(getParam("var_necessidade_especial")))
str_CEP							= Trim(uCase(getParam("var_cep")))
str_ENDERECO					= Trim(uCase(getParam("var_endereco")))
str_END_NUM						= Trim(uCase(getParam("var_end_num")))
str_END_COMPLEMENTO				= Trim(uCase(getParam("var_end_complemento")))
str_BAIRRO						= Trim(uCase(getParam("var_bairro")))
str_CIDADE						= Trim(uCase(getParam("var_cidade")))
str_ESTADO						= Trim(uCase(getParam("var_estado")))
str_PAIS						= Trim(uCase(getParam("var_pais")))
str_CNPJ						= Trim(uCase(getParam("var_cnpj")))
str_RAZAO_SOCIAL				= Trim(uCase(getParam("var_razao_social")))
str_NOME_FANTASIA				= Trim(uCase(getParam("var_nome_fantasia")))
str_CODATIV						= Trim(uCase(getParam("var_codativ")))
strTIPO_PESS                    = Trim(uCase(getParam("var_tipo_pess")))




strSQL = " SELECT E.LOJA_STATUS_PRECO, E.STATUS_PRECO , E.STATUS_CRED, E.IDUSER_LOJA " & _
           "   FROM tbl_EVENTO E" & _
           "  WHERE E.COD_EVENTO = " & strCOD_EVENTO
'response.write(strsql & "<br><br><br>")
  Set objRS = objConn.Execute(strSQL)
  If not objRS.EOF Then
	strCategoriaCred = objRS("STATUS_CRED") & ""
	if strCategoria = "0" OR not IsNumeric(strCategoria)Then
		strCategoria = objRS("STATUS_PRECO")
	end if
	strIDUSER_LOJA = objRS("IDUSER_LOJA") & ""

  End If
  FechaRecordSet objRS

  If strIDUSER_LOJA = "" Then
    strIDUSER_LOJA = "portal"
  End If

'  If strCOD_STATUS_CRED = "" Then
'    strCOD_STATUS_CRED = "0"
'  End If

'  If strCSC <> "" Then
'    strCOD_STATUS_CRED = strCSC
'  End If


 


 If str_ID_NUMDOC1 <> "" Then
   str_ID_NUMDOC1 = "'" & str_ID_NUMDOC1 & "'"
 Else
   str_ID_NUMDOC1 = "NULL"
  End If

  If str_EMAIL <> "" Then
    str_EMAIL = "'" & str_EMAIL & "'"
  Else
    str_EMAIL = "NULL"
  End If


  If str_NOME_COMPLETO <> "" Then
    str_NOME_COMPLETO = "'" & str_NOME_COMPLETO & "'"
  Else
    str_NOME_COMPLETO = "NULL"
  End If


  If str_NOME_CREDENCIAL <> "" Then
    str_NOME_CREDENCIAL = "'" & str_NOME_CREDENCIAL & "'"
  Else
    str_NOME_CREDENCIAL = "NULL"
  End If


  If str_DATA_NASC <> "" Then
    str_DATA_NASC = "'" & PrepDataIve(str_DATA_NASC,false,false) & "'"
	
  Else
    str_DATA_NASC = "NULL"
  End If

  If str_SEXO <> "" Then
    str_SEXO = "'" & str_SEXO & "'" 
  Else
    str_SEXO = "NULL"
  End If

  If str_IMG_FOTO <> "" Then
    str_IMG_FOTO = "'" & str_IMG_FOTO & "'"
  Else
    str_IMG_FOTO = "NULL"
  End If

  If str_FONE1 <> "" Then
    If str_DDD1 <> "" Then str_FONE1 = Trim(str_DDD1 & " " & str_FONE1)
    If str_DDI1 <> "" Then str_FONE1 = Trim(str_DDI1 & " " & str_FONE1)
    str_FONE1 = "'" & Trim(str_FONE1) & "'"
  Else
    str_FONE1 = "NULL"
  End If

  If str_FONE3 <> "" Then
    If str_DDD3 <> "" Then str_FONE3 = Trim(str_DDD3 & " " & str_FONE3)
    If str_DDI3 <> "" Then str_FONE3 = Trim(str_DDI3 & " " & str_FONE3)
    str_FONE3 = "'" & Trim(str_FONE3) & "'"
  Else
    str_FONE3 = "NULL"
  End If

  If str_FONE4 <> "" Then
    If str_DDD4 <> "" Then str_FONE4 = Trim(str_DDD4 & " " & str_FONE4)
    If str_DDI4 <> "" Then str_FONE4 = Trim(str_DDI4 & " " & str_FONE4)
    str_FONE4 = "'" & Trim(str_FONE4) & "'"
  Else
    str_FONE4 = "NULL"
  End If

  If str_DEPARTAMENTO <> "" Then
    str_DEPARTAMENTO = "'" & str_DEPARTAMENTO & "'"
  Else
    str_DEPARTAMENTO = "NULL"
  End If
  
  If str_CARGO <> "" Then
    str_CARGO = "'" & str_CARGO & "'"
  Else
    str_CARGO = "NULL"
  End If

  If str_EMAIL_COMERCIAL <> "" Then
    str_EMAIL_COMERCIAL = "'" & str_EMAIL_COMERCIAL & "'"
  Else
    str_EMAIL_COMERCIAL = "NULL"
  End If

  If str_NECESSIDADE_ESPECIAL <> "" Then
    str_NECESSIDADE_ESPECIAL = "'" & str_NECESSIDADE_ESPECIAL & "'"
  Else
    str_NECESSIDADE_ESPECIAL = "NULL"
  End If

  If str_CEP <> "" Then
    str_CEP = "'" & str_CEP & "'"
  Else
    str_CEP = "NULL"
  End If

  If str_ENDERECO <> "" Then
    str_ENDERECO_COMPLETO = "'" & Trim(str_ENDERECO & " " & str_END_NUM & " " & str_END_COMPLEMENTO) & "'"
  Else
    str_ENDERECO_COMPLETO = "NULL"
  End If

  If str_ENDERECO <> "" Then
    str_ENDERECO = "'" & str_ENDERECO & "'"
  Else
    str_ENDERECO = "NULL"
  End If

  If str_END_NUM <> "" Then
    str_END_NUM = "'" & str_END_NUM & "'"
  Else
    str_END_NUM = "NULL"
  End If

  If str_END_COMPLEMENTO <> "" Then
    str_END_COMPLEMENTO = "'" & str_END_COMPLEMENTO & "'"
  Else
    str_END_COMPLEMENTO = "NULL"
  End If


  If str_BAIRRO <> "" Then
    str_BAIRRO = "'" & str_BAIRRO & "'"
  Else
    str_BAIRRO = "NULL"
  End If

  If str_CIDADE <> "" Then
    str_CIDADE = "'" & str_CIDADE & "'"
  Else
    str_CIDADE = "NULL"
  End If

  If str_ESTADO <> "" Then
    str_ESTADO = "'" & str_ESTADO & "'"
  Else
    str_ESTADO = "NULL"
  End If

  If str_PAIS <> "" Then
    str_PAIS = "'" & str_PAIS & "'"
  Else
    str_PAIS = "NULL"
  End If

  If str_CNPJ <> "" Then
    str_CNPJ = "'" & str_CNPJ & "'"
  Else
    str_CNPJ = "NULL"
  End If

  If str_RAZAO_SOCIAL <> "" Then
    str_RAZAO_SOCIAL = "'" & str_RAZAO_SOCIAL & "'"
  Else
    str_RAZAO_SOCIAL = "NULL"
  End If


  If str_NOME_FANTASIA <> "" Then
    str_NOME_FANTASIA = "'" & str_NOME_FANTASIA & "'"
  Else
    str_NOME_FANTASIA = "NULL"
  End If
 

  If str_CODATIV <> "" Then
    str_CODATIV = "'" & str_CODATIV & "'"
  Else
    str_CODATIV = "NULL"
  End If

	If strFormaPgto <> "" Then
		strFormaPgto = "'" & strFormaPgto & "'"
	Else
		strFormaPgto = "'999'"
	End If

'===========================================================
' INICIO DEBUG
'===========================================================
'response.write("<br>str_ID_NUMDOC1: "&str_ID_NUMDOC1)  
'response.write("<br>str_EMAIL: "&str_EMAIL)  
'response.write("<br>str_NOME_COMPLETO: "&str_NOME_COMPLETO)  
'response.write("<br>str_NOME_CREDENCIAL: "&str_NOME_CREDENCIAL)  
'response.write("<br>str_DATA_NASC: "&str_DATA_NASC)  
'response.write("<br>str_SEXO: "&str_SEXO)  
'response.write("<br>str_IMG_FOTO: "&str_IMG_FOTO)  
'response.write("<br>str_FONE1: "&str_FONE1)
'response.write("<br>str_FONE3: "&str_FONE3)
'response.write("<br>str_FONE4: "&str_FONE4)
'response.write("<br>str_DEPARTAMENTO: "&str_DEPARTAMENTO)
'response.write("<br>str_CARGO: "&str_CARGO)
'response.write("<br>str_EMAIL_COMERCIAL: "&str_EMAIL_COMERCIAL)
'response.write("<br>str_NECESSIDADE_ESPECIAL: "&str_NECESSIDADE_ESPECIAL) 
'response.write("<br>str_CEP: "&str_CEP)
'response.write("<br>str_ENDERECO_Completo: "&str_ENDERECO_COMPLETO)
'response.write("<br>str_ENDERECO: "&str_ENDERECO)  
'response.write("<br>str_END_NUM: "&str_END_NUM)  
'response.write("<br>str_END_COMPLEMENTO: "&str_END_COMPLEMENTO)  
'response.write("<br>str_BAIRRO: "&str_BAIRRO)  
'response.write("<br>str_CIDADE: "&str_CIDADE)  
'response.write("<br>str_ESTADO: "&str_ESTADO)
'response.write("<br>str_PAIS: "&str_PAIS)  
'response.write("<br>str_CNPJ: "&str_CNPJ)  
'response.write("<br>str_RAZAO_SOCIAL: "&str_RAZAO_SOCIAL)  
'response.write("<br>str_NOME_FANTASIA: "&str_NOME_FANTASIA)
'response.write("<br>str_CODATIV: "&str_CODATIV)  
'===========================================================
' FIM DEBUG
'===========================================================


' ========================================================================
' Varifica Casdtro PJ no banco de dados
' ========================================================================
Function VerificaCadastroPJ(prCampo, prDado)
	Dim strSQL, icodbarra , icodempresa
	
	strSQL = "Select cod_empresa from tbl_Empresas where " & prCampo & " LIKE " & prDado 
    'response.write("<br>"&strSQL&"<br>")
	Set objRS = objConn.Execute(strSQL)
	if getValue(objRS,"cod_empresa") = "" Then
		
		strSQL = "SELECT rangelivre(start_gen_id,end_gen_id) as next_free from tbl_usuario where id_user = '" & strIDUSER_LOJA & "'"	
		'response.write("<br>"&strSQL&"<br>")
		Set objRS = objConn.Execute(strSQL)	
		If not objRS.EOF Then
		  icodempresa = int(objRS(0))		  
		End If
		'response.write("<br>"&icodempresa&"<br>")
		If icodempresa&"" <> "" Then
		  icodempresa = ATHFormataTamLeft(icodempresa,6,"0")
   		  icodbarra = icodempresa & "010"
		Else
		  Mensagem "Este usuário não esta autorizado a gerar uma novo cadastro." , "manutencao.asp"
		  Response.End()
		End If	  
	
		FechaRecordSet objRS
		
		strSQL = "INSERT INTO tbl_empresas ("		
		strSQL = strSQL & "   FONE2 "
		strSQL = strSQL & " , FONE3 "
		strSQL = strSQL & "	, FONE4	"				
		strSQL = strSQL & "	, EMAIL1 "									
		strSQL = strSQL & "	, END_CEP "
		strSQL = strSQL & "	, END_FULL "
		strSQL = strSQL & "	, END_LOGR "
		strSQL = strSQL & "	, END_NUM "
		strSQL = strSQL & "	, END_COMPL "
		strSQL = strSQL & "	, END_BAIRRO "
		strSQL = strSQL & "	, END_CIDADE "
		strSQL = strSQL & "	, END_ESTADO "
		strSQL = strSQL & "	, END_PAIS	 "			
		strSQL = strSQL & "	, ID_NUM_DOC1 "					
		strSQL = strSQL & "	, NOMECLI "
		strSQL = strSQL & "	, NOMEFAN "
		strSQL = strSQL & "	, CODATIV1 "
		strSQL = strSQL & "	, COD_EMPRESA "
		strSQL = strSQL & "	, CODBARRA "					
		strSQL = strSQL & "	, TIPO_PESS "
		strSQL = strSQL & "	, SYS_DATACA "
		strSQL = strSQL & "	, SYS_USERCA "
		strSQL = strSQL & "	, COD_STATUS_PRECO "
		strSQL = strSQL & "	, COD_STATUS_CRED) VALUES( "					
		strSQL = strSQL & "	  " & str_FONE1				
		strSQL = strSQL & "	, " & str_FONE3				
		strSQL = strSQL & "	, " & str_FONE4
		strSQL = strSQL & "	, " & str_EMAIL_COMERCIAL	
		strSQL = strSQL & "	, " & str_CEP
		strSQL = strSQL & "	, " & str_ENDERECO_COMPLETO							
		strSQL = strSQL & "	, " & str_ENDERECO					
		strSQL = strSQL & "	, " & str_END_NUM						
		strSQL = strSQL & "	, " & str_END_COMPLEMENTO				
		strSQL = strSQL & "	, " & str_BAIRRO						
		strSQL = strSQL & "	, " & str_CIDADE						
		strSQL = strSQL & "	, " & str_ESTADO						
		strSQL = strSQL & "	, " & str_PAIS						
		strSQL = strSQL & "	, " & str_CNPJ
		strSQL = strSQL & "	, " & str_RAZAO_SOCIAL				
		strSQL = strSQL & "	, " & str_NOME_FANTASIA				
		strSQL = strSQL & "	, " & str_CODATIV					
		strSQL = strSQL & "	, '" & icodempresa &"'"
		strSQL = strSQL & "	, '" & icodbarra &"'"
		strSQL = strSQL & "	, 'N'"
		strSQL = strSQL & "	, NOW()"
		strSQL = strSQL & "	, '" & strIDUSER_LOJA & "'"
		strSQL = strSQL & "	, " & strCategoria
		strSQL = strSQL & "	, " & strCategoriaCred
		strSQL = strSQL & "		) "
'response.write("<BR>"&strSQL)
'response.End()
		objConn.execute(strSQL)
	end if
End Function
' ========================================================================
' FIM Varifica Casdtro PJ no banco de dados
' ========================================================================


' ========================================================================
' Atualiza CadastroPF no banco de dados
' ========================================================================
Function AtualizaCadastroPF(prDado)
	Dim strSQL
	
				strSQL =      "		UPDATE tbl_empresas SET  "
			strSQL = strSQL & "				  ID_NUM_DOC1                         = " & str_ID_NUMDOC1
			strSQL = strSQL & "				, EMAIL1                              = " & str_EMAIL
			strSQL = strSQL & "				, NOMECLI                             = " & str_NOME_COMPLETO
			strSQL = strSQL & "				, NOMEFAN                             = " & str_NOME_CREDENCIAL
			strSQL = strSQL & "				, DT_NASC                             = " & str_DATA_NASC
			strSQL = strSQL & "				, SEXO                                = " & str_SEXO
			strSQL = strSQL & "				, IMG_FOTO                            = " & str_IMG_FOTO
			strSQL = strSQL & "				, FONE3                               = " & str_FONE3
			strSQL = strSQL & "				, FONE4                               = " & str_FONE4
			strSQL = strSQL & "				, FONE2                               = " & str_FONE1
			strSQL = strSQL & "				, ENTIDADE_CARGO                      = " & str_CARGO
			strSQL = strSQL & "				, ENTIDADE_DEPARTAMENTO               = " & str_DEPARTAMENTO
			strSQL = strSQL & "				, EMAIL2                              = " & str_EMAIL_COMERCIAL
			strSQL = strSQL & "				, PORTADOR_NECESSIDADE_ESPECIAL       = " & str_NECESSIDADE_ESPECIAL
			strSQL = strSQL & "				, END_LOGR                            = " & str_ENDERECO
			strSQL = strSQL & "				, END_NUM                             = " & str_END_NUM
			strSQL = strSQL & "				, END_COMPL                           = " & str_END_COMPLEMENTO
			strSQL = strSQL & "				, END_BAIRRO                          = " & str_BAIRRO
			strSQL = strSQL & "				, END_CIDADE                          = " & str_CIDADE
			strSQL = strSQL & "				, END_ESTADO                          = " & str_ESTADO
			strSQL = strSQL & "				, END_PAIS                            = " & str_PAIS
			strSQL = strSQL & "				, END_CEP                             = " & str_CEP
			strSQL = strSQL & "				, ENTIDADE_CNPJ                       = " & str_CNPJ
			strSQL = strSQL & "				, ENTIDADE                            = " & str_RAZAO_SOCIAL
			strSQL = strSQL & "				, ENTIDADE_FANTASIA                   = " & str_NOME_FANTASIA
			strSQL = strSQL & "				, CODATIV1                            = " & str_CODATIV
			strSQL = strSQL & "				, CODBARRA                            = concat(cod_empresa,'010')"
			strSQL = strSQL & "				, END_FULL                            = " & str_ENDERECO_Completo
			strSQL = strSQL & "				, TIPO_PESS                           = 'S'"
			strSQL = strSQL & "				, SYS_DATAAT                          = NOW()"
			strSQL = strSQL & "				, SYS_USERAT                          = '" & strIDUSER_LOJA &"'"
			strSQL = strSQL & "				, COD_STATUS_PRECO                    = " & strCategoria 
			strSQL = strSQL & "				, COD_STATUS_CRED                     = " & strCategoriaCred
			strSQL = strSQL & "		WHERE cod_empresa = '" & prDado & "'"			
'response.write "<BR>"&strSQL
			objConn.execute(strSQL)
End Function

' ========================================================================
' FIM Atualiza CadastroPF no banco de dados
' ========================================================================


' ========================================================================
' Insere CadastroPF no banco de dados
' ========================================================================
Function InsereCadastroPF()
		
	Dim strSQL, icodbarra , icodempresa
	
	
		strSQL = "SELECT rangelivre(start_gen_id,end_gen_id) as next_free from tbl_usuario where id_user = '" & strIDUSER_LOJA & "'"	
		'response.write("<br>"&strSQL&"<br>")
		Set objRS = objConn.Execute(strSQL)	
		If not objRS.EOF Then
		  icodempresa = int(objRS(0))		  
		End If
		'response.write("<br>"&icodempresa&"<br>")
		If icodempresa&"" <> "" Then
		  icodempresa = ATHFormataTamLeft(icodempresa,6,"0")
   		  icodbarra = icodempresa & "010"
		Else
		  Mensagem "Este usuário não esta autorizado a gerar uma novo cadastro." , "manutencao.asp"
		  Response.End()
		End If	  	
		FechaRecordSet objRS
		
		strSQL = "INSERT INTO tbl_empresas	(															"
		strSQL =  strSQL & "									  ID_NUM_DOC1                           "
		strSQL =  strSQL & "									, EMAIL1                                "
		strSQL =  strSQL & "									, NOMECLI                               "
		strSQL =  strSQL & "									, NOMEFAN                               "
		strSQL =  strSQL & "									, DT_NASC                               "
		strSQL =  strSQL & "									, SEXO                                  "
		strSQL =  strSQL & "									, IMG_FOTO                              "
		strSQL =  strSQL & "									, FONE3                                 "
		strSQL =  strSQL & "									, FONE4                                 "
		strSQL =  strSQL & "									, FONE2                                 "
		strSQL =  strSQL & "									, ENTIDADE_CARGO                        "
		strSQL =  strSQL & "									, ENTIDADE_DEPARTAMENTO                 "
		strSQL =  strSQL & "									, EMAIL2                                "
		strSQL =  strSQL & "									, PORTADOR_NECESSIDADE_ESPECIAL         "
		strSQL =  strSQL & "									, END_LOGR                              "
		strSQL =  strSQL & "									, END_NUM                               "
		strSQL =  strSQL & "									, END_COMPL                             "
		strSQL =  strSQL & "									, END_BAIRRO                            "
		strSQL =  strSQL & "									, END_CIDADE                            "
		strSQL =  strSQL & "									, END_ESTADO                            "
		strSQL =  strSQL & "									, END_PAIS                              "
		strSQL =  strSQL & "									, END_CEP                               "
		strSQL =  strSQL & "									, ENTIDADE_CNPJ                         "
		strSQL =  strSQL & "									, ENTIDADE                              "
		strSQL =  strSQL & "									, ENTIDADE_FANTASIA                     "
		strSQL =  strSQL & "									, CODATIV1                              "
		strSQL =  strSQL & "									, COD_EMPRESA                           "
		strSQL =  strSQL & "									, CODBARRA                              "
		strSQL =  strSQL & "									, END_FULL                              "
		strSQL =  strSQL & "									, TIPO_PESS                             "
		strSQL =  strSQL & "									, SYS_DATACA                            "
		strSQL =  strSQL & "									, SYS_USERCA							"				
		strSQL =  strSQL & "									, COD_STATUS_PRECO                      "
		strSQL =  strSQL & "									, COD_STATUS_CRED			            "
		strSQL =  strSQL & "								 	)VALUES( "		
		strSQL =  strSQL & "									  " & str_ID_NUMDOC1
		strSQL =  strSQL & "									, " & str_EMAIL
		strSQL =  strSQL & "									, " & str_NOME_COMPLETO
		strSQL =  strSQL & "									, " & str_NOME_CREDENCIAL
		strSQL =  strSQL & "									, " & str_DATA_NASC
		strSQL =  strSQL & "									, " & str_SEXO
		strSQL =  strSQL & "									, " & str_IMG_FOTO
		strSQL =  strSQL & "									, " & str_FONE3
		strSQL =  strSQL & "									, " & str_FONE4											
		strSQL =  strSQL & "									, " & str_FONE1											
		strSQL =  strSQL & "									, " & str_CARGO
		strSQL =  strSQL & "									, " & str_DEPARTAMENTO
		strSQL =  strSQL & "									, " & str_EMAIL_COMERCIAL
		strSQL =  strSQL & "									, " & str_NECESSIDADE_ESPECIAL
		strSQL =  strSQL & "									, " & str_ENDERECO
		strSQL =  strSQL & "									, " & str_END_NUM
		strSQL =  strSQL & "									, " & str_END_COMPLEMENTO
		strSQL =  strSQL & "									, " & str_BAIRRO
		strSQL =  strSQL & "									, " & str_CIDADE
		strSQL =  strSQL & "									, " & str_ESTADO
		strSQL =  strSQL & "									, " & str_PAIS
		strSQL =  strSQL & "									, " & str_CEP
		strSQL =  strSQL & "									, " & str_CNPJ
		strSQL =  strSQL & "									, " & str_RAZAO_SOCIAL
		strSQL =  strSQL & "									, " & str_NOME_FANTASIA
		strSQL =  strSQL & "									, " & str_CODATIV
		strSQL =  strSQL & "									, " & icodempresa
		strSQL =  strSQL & "									, " & icodbarra
		strSQL =  strSQL & "									, " & str_ENDERECO_Completo
		strSQL =  strSQL & "									,     'S'"
		strSQL =  strSQL & "									,      now()"
		strSQL =  strSQL & "									, '" & strIDUSER_LOJA &"'"
		strSQL =  strSQL & "									, " & strCategoria
		strSQL =  strSQL & "									, " & strCategoriaCred
		strSQL =  strSQL & "									)"
		
		'response.Write("<BR>"&strSQL&"<br>")
		'retorna o codempresa do novo cadastro
		objConn.execute(strSQL)
		InsereCadastroPF = icodempresa
End Function
' ========================================================================
' FIM Insere CadastroPF no banco de dados
' ========================================================================

' ========================================================================
' Pesquisa se o CNPJ/CPF ja existe no cadastro do banco de dados
' ========================================================================
Function VerificaInscricao(prCOD_EMPRESA)
Dim strSQL, objRS, bolAchou
bolAchou = ""
  strSQL =          "SELECT MAX(COD_INSCRICAO) AS ULTIMA_INSCRICAO FROM tbl_INSCRICAO "
  strSQL = strSQL & " WHERE COD_EVENTO = " & strCOD_EVENTO
  strSQL = strSQL & "   AND SYS_INATIVO IS NULL "
  strSQL = strSQL & "   AND COD_EMPRESA = '" & prCOD_EMPRESA & "'"
  Set objRS = objConn.Execute(strSQL)
  If not objRS.EOF Then
  	icodinscricao = objRS("ULTIMA_INSCRICAO")
	If icodinscricao > 0 Then
  	  bolAchou = objRS("ULTIMA_INSCRICAO")
	End If
  End if	
  FechaRecordSet objRS
  
  VerificaInscricao = bolAchou
End Function


' ========================================================================
' Cria InscricaoPF no banco de dados
' ========================================================================

Function CriaInscricaoPF(prCOD_EMPRESA)

	Dim strSQL, objRS, objConnLocal, icodinscricao

	strSQL = "SELECT rangeinscricaolivre(start_insc_id,end_insc_id) as next_free from tbl_usuario where id_user = '" & strIDUSER_LOJA & "'"
	
	Set objRS = objConn.Execute(strSQL)

	If not objRS.EOF Then
	  icodinscricao = int(objRS(0))    
	End If
	
	If icodinscricao&"" <> "" Then
	  icodinscricao = ATHFormataTamLeft(icodinscricao,6,"0")
	Else
	  Mensagem "Este usuário não esta autorizado a gerar uma nova inscrição." , "default.asp"
	  Response.End()
    End If	  

	FechaRecordSet objRS
'as duas linhas abaixo sao apenas referencia!!!
'strSQL = " INSERT INTO tbl_inscricao (   COD_INSCRICAO     , COD_EMPRESA, CODBARRA, NOMECOMPLETO, DT_ChegadaFicha,     SYS_USERCA         , SYS_DATACA, FAT_RAZAO, FAT_CNPJ     , FAT_ENDFULL                                  , FAT_END_LOGR, FAT_END_NUM, FAT_END_COMPL, FAT_BAIRRO , FAT_CEP, FAT_CIDADE , FAT_ESTADO , COD_STATUS_PRECO, FAT_CONTATO_NOME, FAT_CONTATO_EMAIL, FAT_CONTATO_DEPTO, FAT_CONTATO_FONE, COD_EVENTO, COD_PAIS)"
'strSQL = strSQL & "           SELECT " & iconsinscricao & ", COD_EMPRESA, CODBARRA, NOMECLI     , NOW()          , " & strIDUSER_LOJA & " , NOW()     , ENTIDADE , ENTIDADE_CNPJ, CONCAT(END_LOGR,' ', END_NUM,' ', END_COMPL) , END_LOGR    , END_NUM    , END_COMPL    , END_BAIRRO , END_CEP, END_CIDADE , END_ESTADO , END_PAIS ,      " & strCOD_EVENTO & ", COD_EMPRESA, CODBARRA, NULL        , NOW()          , nomecli     , 0        , " &  & ", NOW()     , NOMECLI , NOMEFAN , DT_NASC , SEXO , IMG_FOTO , FONE3 , FONE4 , FONE1 , ENTIDADE_CARGO , ENTIDADE_DEPARTAMENTO , EMAIL2 , PORTADOR_NECESSIDADE_ESPECIAL ,  , ,  ,  , ENTIDADE_FANTASIA , CODATIV1 , COD_EMPRESA , CODBARRA , END_FULL , TIPO_PESS , SYS_DATACA , SYS_USERCA	, COD_STATUS_PRECO , COD_STATUS_CRED FROM TBL_EMPRESAS where cod_empresa = '112952'

		
	strSQL = "INSERT INTO tbl_inscricao(   COD_INSCRICAO    , COD_EMPRESA, CODBARRA, NOMECOMPLETO, DT_ChegadaFicha, SYS_USERCA               , SYS_DATACA, COD_STATUS_PRECO, COD_EVENTO         , COD_PAIS   , COMPROVANTE_CATEGORIA,     COD_FORMAPGTO ) "
	strSQL = strSQL & "  (SELECT        "& icodinscricao & ", COD_EMPRESA, CODBARRA, NOMECLI     , NOW()          , '" & strIDUSER_LOJA & "' , NOW()     , COD_STATUS_PRECO, "& strCOD_EVENTO &",'"&strLng&"', NULL                 , " & strFormaPgto &  " FROM TBL_EMPRESAS  WHERE cod_empresa = '"&prCOD_EMPRESA&"')"
	'response.Write("<br> inscricao:  "& strSQL &" <br>")
	objConn.Execute(strSQL)			 

	strSQL = "INSERT INTO tbl_Inscricao_Produto ( COD_INSCRICAO      ,     COD_PROD      ,     QTDE             ,     VLR_PAGO            ,     SYS_USERCA          , SYS_DATACA) VALUES"
	strSQL =strSQL & "                          ("& icodinscricao & ", " & strCodProd & ", " & intQuantidade & ", " & dblValorProduto  & ", '" & strIDUSER_LOJA & "',  NOW()    )"
	'response.Write("<br> inscricao produto: " & strSQL & "<br>")
	objConn.Execute(strSQL)			 
	
	strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO + " & Cint(intQuantidade) & " WHERE COD_PROD = " & strCodProd
	'response.Write("<br> produto ocupacao: " & strSQL & "<br>")
	objConn.Execute(strSQL)			 
	CriaInscricaoPF = icodinscricao
End Function 


' ========================================================================
' FIM Cria InscricaoPF no banco de dados
' ========================================================================

' ========================================================================
' Atualiza InscricaoPF no banco de dados
' ========================================================================
Function AtualizaInscricaoPF(prInscricao)
Dim intQtde
	intQtde = 0
	
	strSQL = "SELECT count(*) AS qtde from tbl_inscricao_produto WHERE cod_inscricao = "& prInscricao & " AND cod_prod = " & strCodProd
	'response.Write("<br>qtde prod: " & strSQL)
	Set objRS = objConn.execute(strSQL)
	intQtde = cint(getValue(objRS,"qtde"))
	If intQtde > 0 Then
		strSQL = " DELETE FROM tbl_Inscricao_Produto " &_
			   "   WHERE COD_INSCRICAO =" & prInscricao & _
			   "   AND COD_PROD = " & strCodProd 
	    'response.Write("<br>del prod: " & strSQL)
		objConn.Execute(strSQL)
		strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO - " & intQtde & " WHERE COD_PROD = " & strCodProd
		'response.Write("<br>upd_del prod: " & strSQL)
		objConn.Execute(strSQL)
	End If
	

	
	strSQL = "    UPDATE tbl_inscricao SET "	
	strSQL = strSQL & "  NOMECOMPLETO  = " & str_NOME_COMPLETO 
	strSQL = strSQL & ", DT_ChegadaFicha  = NOW() "
	strSQL = strSQL & ", SYS_USERAT = '" & strIDUSER_LOJA & "'"
	strSQL = strSQL & ", SYS_DATAAT = NOW() "
	strSQL = strSQL & ", COD_STATUS_PRECO  = " & strCategoria
	strSQL = strSQL & ", COD_EVENTO = " & strCOD_EVENTO 
	strSQL = strSQL & ", COD_PAIS   = '" & strCOD_PAIS & "'"
	strSQL = strSQL & ", COD_FORMAPGTO = " & strFormaPgto 
'	strSQL = strSQL & ", COMPROVANTE_CATEGORIA =  
	strSQL = strSQL & " WHERE cod_inscricao = " & prInscricao 

	'response.Write("<br> updInscricao : " & strSQL & "<br>")
	objConn.Execute(strSQL)

	strSQL = "INSERT INTO tbl_Inscricao_Produto ( COD_INSCRICAO      ,     COD_PROD      ,     QTDE             ,     VLR_PAGO            ,     SYS_USERCA          , SYS_DATACA) VALUES"
	strSQL =strSQL & "                          ("& icodinscricao & ", " & strCodProd & ", " & intQuantidade & ", " & dblValorProduto  & ", '" & strIDUSER_LOJA & "',  NOW()    )"
	'response.Write("<br> inscricao produto: " & strSQL & "<br>")
	objConn.Execute(strSQL)			 
	
	strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO + " & Cint(intQuantidade) & " WHERE COD_PROD = " & strCodProd
	'response.Write("<br> produto ocupacao: " & strSQL & "<br>")
	objConn.Execute(strSQL)			 
	AtualizaInscricaoPF = prInscricao
End Function


' ========================================================================
' FIM Atualiza InscricaoPF no banco de dados
' ========================================================================


		
 %>
 <!DOCTYPE html>
 	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta name="viewport"    content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="product"     content="PRO MetroUI  Framework">
    <meta name="description" content="Simple responsive css framework">
    <meta name="author" 	 content="Sergey P. - adapted by Aless">

    <link href="./_metroUI/css/metro-bootstrap.css" rel="stylesheet">
    <link href="./_metroUI/css/metro-bootstrap-responsive.css" rel="stylesheet">
    <link href="./_metroUI/css/iconFont.css" rel="stylesheet">
    <link href="./_metroUI/css/docs.css" rel="stylesheet">
    <link href="./_metroUI/js/prettify/prettify.css" rel="stylesheet">
    <!-- Load JavaScript Libraries -->
    <script src="./_metroUI/js/jquery/jquery.min.js"></script>
    <script src="./_metroUI/js/jquery/jquery.widget.min.js"></script>
    <script src="./_metroUI/js/jquery/jquery.mousewheel.js"></script>
    <script src="./_metroUI/js/prettify/prettify.js"></script>

    <!-- PRO  MetroUI  JavaScript plugins -->
    <script src="./_metroUI/js/load-metro.js"></script>
    <!-- Local JavaScript -->
    <script src="./_metroUI/js/docs.js"></script>
    <script src="./_metroUI/js/github.info.js"></script>
    <!-- Tablet Sort -->
	<script src="./_metroUI/js/tablesort_metro.js"></script>
    
    </head>
    <body bgcolor="#333333"><!--strong><br>CHEGOU AQUI É PQ FINALIZOU A INSCRICAO E APOS VAI PARA OS ENCAMINHAMENTOS FINAIS</strong//-->




<% VerificaCadastroPJ "id_num_doc1",str_CNPJ 
		if strCOD_EMPRESA <> "" Then
			AtualizaCadastroPF(strCOD_EMPRESA)
		else
			strCOD_EMPRESA = InsereCadastroPF 
		end if	
		
		If VerificaInscricao(strCOD_EMPRESA) <> "" Then
			strCodInscricao = AtualizaInscricaoPF(VerificaInscricao(strCOD_EMPRESA))
		Else
			strCodInscricao = CriaInscricaoPF(strCod_EMPRESA)

		End If
		
 if Err.Number <> 0 then 
	 Response.write ("Error Detail: "&Err.Description)   
	 response.End()
 end if
  strAction = "passo4_.asp"
%>


    <form id="finaliza_compra" name="finaliza_compra" action="<%=strAction%>" method="post">
    	<input type="hidden" id="db" name="db" value="<%=CFG_DB%>">
        <input type="hidden" id="lng" name="lng" value="<%=strLng%>">
        <input type="hidden" id="cod_evento" name="cod_evento" value="<%=strCOD_EVENTO%>">
        <input type="hidden" id="var_categoria" name="var_categoria" value="<%=strCategoria%>">
		<input type="hidden" id="var_cod_inscricao" name="var_cod_inscricao" value="<%=strCodInscricao%>">    
        <input type="hidden" id="var_cod_empresa" name="var_cod_empresa" value="<%=strCOD_EMPRESA%>">    
        <input type="hidden" id="var_cod_formapgto" name="var_cod_formapgto" value="<%=replace(strFormaPgto,"'","")%>">    
    </form>
    <script language="javascript">
		$( window ).load(function() {
			    setTimeout(function(){
					$.Notify({style: {background: '#1ba1e2', color: 'white'}, caption: '<%=objLang.SearchIndex("info",0)%>...', content: "<%=objLang.SearchIndex("processando",0)%>..."});
					document.getElementById("finaliza_compra").submit();
				}, 500);
				setTimeout(function(){
					$.Notify({style: {background: 'red', color: 'white'}, content: "<%=objLang.SearchIndex("processando",0)%>"});
				}, 2000);
				setTimeout(function(){
					$.Notify({style: {background: 'green', color: 'white'}, content: "<%=objLang.SearchIndex("processando",0)%>"});					
				}, 3000);		
		});
			
	</script>
    
    
    </body>
 </html>