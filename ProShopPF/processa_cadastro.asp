<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->

<% 

  
  'Session.Timeout 	    = 900 ' 720 = 12h
  'Server.ScriptTimeout  = 3600 '1h
  'Response.Expires 	    = -1   'no expires
  'Response.Buffer       = True 'Para uso adequado da athMoveNext
  Response.CacheControl = "no-cache"
  Response.AddHeader "Pragma", "no-cache"
  'Response.AddHeader "Content-Type","text/html; charset=iso-8859-1" 
  'Response.AddHeader "Expires", "Mon, 26 Jul 1997 05:00:00 GMT"  'date in the past...
  'Response.AddHeader "Last-Modified", Now & " GMT" 'always modified
  Response.AddHeader "Cache-Control", "no-cache, must-revalidate" 'HTTP/1.1 
%>

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
Dim strCodProdEstoque, dblValorInscricao, dblQuantidade, dblTotalComprado
Dim strEXTRA_TXT1,strEXTRA_TXT2,strEXTRA_TXT3,strEXTRA_TXT4,strEXTRA_TXT5,strEXTRA_TXT6,strEXTRA_TXT7,strEXTRA_TXT8,strEXTRA_TXT9,strEXTRA_TXT10
Dim strItens, item, j, arrResp, strCodPergunta, strCodResposta, strCodigo,strCodPerg
Dim strIdNumDoc2, strSetor, strWebSite, str_DDI2, str_DDD2, str_FONE2, strIdInscrEst, strBloqueado
 
CFG_DB          = getParam("db")
strLng          = getParam("lng")
strCOD_EVENTO   = getParam("cod_evento")
strCategoria    = getParam("var_categoria")
strCodProd      = getParam("cod_prod")
dblValorProduto = getParam("vlr_prod")
intQuantidade   = getParam("combo_quantidade")
strCOD_EMPRESA  = getParam("var_cod_empresa")
dblValorInscricao = getParam("var_valor_inscricao") 

                                       
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
		'response.Write(auxStr)
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
 objLang.LoadLang strLOCALE,"../_lang/proshoppf/"
 ' FIM: LANG (ex. de uso: response.wrire(objLang.SearchIndex("area_restrita",0))
' ' -------------------------------------------------------------------------------
'
'



'response.write(strCodEvento)

'For Each item in request.form

' strItens = strItens &"|"& item & ":" & replace(Request.Form(item),"|",";") 
 
'next
'response.write(strItens)
'response.End()
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

strEXTRA_TXT1                   = Trim(uCase(getParam("var_extra_txt_1")))
strEXTRA_TXT2                   = Trim(uCase(getParam("var_extra_txt_2")))
strEXTRA_TXT3                   = Trim(uCase(getParam("var_extra_txt_3")))
strEXTRA_TXT4                   = Trim(uCase(getParam("var_extra_txt_4")))
strEXTRA_TXT5                   = Trim(uCase(getParam("var_extra_txt_5")))
strEXTRA_TXT6                   = Trim(uCase(getParam("var_extra_txt_6")))
strEXTRA_TXT7                   = Trim(uCase(getParam("var_extra_txt_7")))
strEXTRA_TXT8                   = Trim(uCase(getParam("var_extra_txt_8")))
strEXTRA_TXT9                   = Trim(uCase(getParam("var_extra_txt_9")))
strEXTRA_TXT10                  = Trim(uCase(getParam("var_extra_txt_10")))

strIdNumDoc2					= Trim(uCase(getParam("var_id_num_doc2")))
strSetor						= Trim(uCase(getParam("var_entidade_setor")))
strWebSite						= Trim(uCase(getParam("var_homepage")))
str_DDI2						= Trim(uCase(getParam("var_ddi2")))
str_DDD2						= Trim(uCase(getParam("var_ddd2")))
str_FONE2						= Trim(uCase(getParam("var_fone2")))

strIdInscrEst 					= Trim(uCase(getParam("var_id_inscr_est")))


strSQL = " SELECT E.LOJA_STATUS_PRECO, E.STATUS_PRECO , E.STATUS_CRED, E.IDUSER_LOJA, E.BLOQUEADO " & _
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
	if objRS("BLOQUEADO")&"" = "" THEN
		strBloqueado = "NULL"
	else 
		strBloqueado = objRS("BLOQUEADO")
	end if
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

response.cookies("METRO_ProshopPF")("METRO_ProShopPF_strUsuerLoja") = strIDUSER_LOJA


if strIdInscrEst  <> "" then
	strIdInscrEst = "'" & strIdInscrEst & "'"
else
	strIdInscrEst = "NULL"
end if

if strIdNumDoc2  <> "" then
	strIdNumDoc2 = "'" & strIdNumDoc2 & "'"
else
	strIdNumDoc2 = "NULL"
end if

if strSetor  <> "" then
	strSetor = "'" & strSetor & "'"
else
	strSetor = "NULL"
end if

if strWebSite  <> "" then
	strWebSite = "'" & strWebSite & "'"
else
	strWebSite = "NULL"
end if





if strEXTRA_TXT1  <> "" then
	strEXTRA_TXT1 = "'" & strEXTRA_TXT1 & "'"
else
	strEXTRA_TXT1 = "NULL"
end if


if strEXTRA_TXT2  <> "" then
	strEXTRA_TXT2 = "'" & strEXTRA_TXT2 & "'"
else
	strEXTRA_TXT2 = "NULL"
end if


if strEXTRA_TXT3  <> "" then
	strEXTRA_TXT3 = "'" & strEXTRA_TXT3 & "'"
else
	strEXTRA_TXT3 = "NULL"
end if


if strEXTRA_TXT4  <> "" then
	strEXTRA_TXT4 = "'" & strEXTRA_TXT4 & "'"
else
	strEXTRA_TXT4 = "NULL"
end if


if strEXTRA_TXT5  <> "" then
	strEXTRA_TXT5 = "'" & strEXTRA_TXT5 & "'"
else
	strEXTRA_TXT5 = "NULL"
end if


if strEXTRA_TXT6  <> "" then
	strEXTRA_TXT6 = "'" & strEXTRA_TXT6 & "'"
else
	strEXTRA_TXT6 = "NULL"
end if


if strEXTRA_TXT7  <> "" then
	strEXTRA_TXT7 = "'" & strEXTRA_TXT7 & "'"
else
	strEXTRA_TXT7 = "NULL"
end if


if strEXTRA_TXT8  <> "" then
	strEXTRA_TXT8 = "'" & strEXTRA_TXT8 & "'"
else
	strEXTRA_TXT8 = "NULL"
end if


if strEXTRA_TXT9  <> "" then
	strEXTRA_TXT9 = "'" & strEXTRA_TXT9 & "'"
else
	strEXTRA_TXT9 = "NULL"
end if


if strEXTRA_TXT10 <> "" then
	strEXTRA_TXT10 = "'" & strEXTRA_TXT10 & "'"
else
	strEXTRA_TXT10 = "NULL"
end if


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
  
  
   If str_FONE2 <> "" Then
    If str_DDD2 <> "" Then str_FONE2 = Trim(str_DDD2 & " " & str_FONE2)
    If str_DDI2 <> "" Then str_FONE2 = Trim(str_DDI2 & " " & str_FONE2)
    str_FONE2 = "'" & Trim(str_FONE2) & "'"
  Else
    str_FONE2 = "NULL"
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
'response.write("<br>strEXTRA_TXT1  "& strEXTRA_TXT1)
'response.write("<br>strEXTRA_TXT2  "& strEXTRA_TXT2)
'response.write("<br>strEXTRA_TXT3  "& strEXTRA_TXT3)
'response.write("<br>strEXTRA_TXT4  "& strEXTRA_TXT4)
'response.write("<br>strEXTRA_TXT5  "& strEXTRA_TXT5)
'response.write("<br>strEXTRA_TXT6  "& strEXTRA_TXT6)
'response.write("<br>strEXTRA_TXT7  "& strEXTRA_TXT7)
'response.write("<br>strEXTRA_TXT8  "& strEXTRA_TXT8)
'response.write("<br>strEXTRA_TXT9  "& strEXTRA_TXT9)
'response.write("<br>strEXTRA_TXT10 "& strEXTRA_TXT10)
 
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
	if getValue(objRS,"cod_empresa") = "" AND prDado <> "" Then
		
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
		strSQL = strSQL & " , FONE1 "				
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
		strSQL = strSQL & "	, COD_STATUS_CRED "

		strSQL = strSQL &" ) VALUES( "					
		strSQL = strSQL & "	  " & str_FONE1				
		strSQL = strSQL & "	, " & str_FONE3				
		strSQL = strSQL & "	, " & str_FONE4
		strSQL = strSQL & " , " & str_FONE2
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
		'strSQL = strSQL & "	, " & strIdNumDoc2 
		'strSQL = strSQL & "	, " & strSetor
		'strSQL = strSQL & "	, " & strWebSite
		strSQL = strSQL & "		) "
		'strIdNumDoc2, strSetor, strWebSite
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
			strSQL = strSQL & "				, EXTRA_TXT_1  						  = " & strEXTRA_TXT1
			strSQL = strSQL & "				, EXTRA_TXT_2  						  = " & strEXTRA_TXT2
			strSQL = strSQL & "				, EXTRA_TXT_3  						  = " & strEXTRA_TXT3
			strSQL = strSQL & "				, EXTRA_TXT_4  						  = " & strEXTRA_TXT4
			strSQL = strSQL & "				, EXTRA_TXT_5  						  = " & strEXTRA_TXT5
			strSQL = strSQL & "				, EXTRA_TXT_6  						  = " & strEXTRA_TXT6
			strSQL = strSQL & "				, EXTRA_TXT_7  						  = " & strEXTRA_TXT7
			strSQL = strSQL & "				, EXTRA_TXT_8  						  = " & strEXTRA_TXT8
			strSQL = strSQL & "				, EXTRA_TXT_9  						  = " & strEXTRA_TXT9
			strSQL = strSQL & "				, EXTRA_TXT_10  					  = " & strEXTRA_TXT10
			strSQL = strSQL & "	            , ID_NUM_DOC2                         = " & strIdNumDoc2
			strSQL = strSQL & "	            , ENTIDADE_SETOR                      = " & strSetor
			strSQL = strSQL & "	            , HOMEPAGE                            = " & strWebSite
			strSQL = strSQL & "	            , ID_INSCR_EST                        = " & strIdInscrEst
			strSQL = strSQL & "	            , BLOQUEADO                        = " &strBloqueado
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
		strSQL =  strSQL & "                                    , FONE1                                 "
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
		strSQL =  strSQL & "									, EXTRA_TXT_1				            "
		strSQL =  strSQL & "									, EXTRA_TXT_2			            	"
		strSQL =  strSQL & "									, EXTRA_TXT_3			            	"
		strSQL =  strSQL & "									, EXTRA_TXT_4			            	"
		strSQL =  strSQL & "									, EXTRA_TXT_5			            	"
		strSQL =  strSQL & "									, EXTRA_TXT_6			            	"
		strSQL =  strSQL & "									, EXTRA_TXT_7			            	"
		strSQL =  strSQL & "									, EXTRA_TXT_8			            	"
		strSQL =  strSQL & "									, EXTRA_TXT_9			            	"
		strSQL =  strSQL & "									, EXTRA_TXT_10			            	"
		strSQL = strSQL  & "									, ID_NUM_DOC2                           "
		strSQL = strSQL  & "									, ENTIDADE_SETOR                        "
		strSQL = strSQL  & "									, HOMEPAGE                              "
		strSQL = strSQL &  "                      	            , ID_INSCR_EST                          "
		strSQL = strSQL &  "                      	            , BLOQUEADO								"

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
		strSQL =  strSQL & "                                    , " & str_FONE2										
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
		strSQL =  strSQL & "									, " & strEXTRA_TXT1
		strSQL =  strSQL & "									, " & strEXTRA_TXT2
		strSQL =  strSQL & "									, " & strEXTRA_TXT3
		strSQL =  strSQL & "									, " & strEXTRA_TXT4
		strSQL =  strSQL & "									, " & strEXTRA_TXT5
		strSQL =  strSQL & "									, " & strEXTRA_TXT6
		strSQL =  strSQL & "									, " & strEXTRA_TXT7
		strSQL =  strSQL & "									, " & strEXTRA_TXT8
		strSQL =  strSQL & "									, " & strEXTRA_TXT9
		strSQL =  strSQL & "									, " & strEXTRA_TXT10
		strSQL = strSQL &  "                                    , " & strIdNumDoc2 
		strSQL = strSQL &  "                                    , " & strSetor
		strSQL = strSQL &  "                                    , " & strWebSite
		strSQL = strSQL & "                                     , " & strIdInscrEst
		strSQL = strSQL & "                                     , " & strBloqueado
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
'response.write("<br>CRIA INSCRICAO PF")
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
'	response.Write("<br> inscricao:  "& strSQL &" <br>")
	objConn.Execute(strSQL)			 

	'strSQL = "INSERT INTO tbl_Inscricao_Produto ( COD_INSCRICAO      ,     COD_PROD      ,     QTDE             ,     VLR_PAGO            ,     SYS_USERCA          , SYS_DATACA) VALUES"
	'strSQL =strSQL & "                          ("& icodinscricao & ", " & strCodProd & ", " & intQuantidade & ", " & dblValorProduto  & ", '" & strIDUSER_LOJA & "',  NOW()    )"
	
	strSQL = "insert into tbl_Inscricao_Produto(    cod_inscricao     , cod_prod ,        qtde         ,          vlr_pago        ,     SYS_USERCA          , SYS_DATACA )"
	strSQL = strSQL & "		(select             "  & icodinscricao & " , cod_prod ,        qtde         ,          vlr_pago        , '" & strIDUSER_LOJA & "',  NOW()    from tbl_inscricao_produto_session where id_session = " & request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId")&")"
	
''	response.Write("<br> inscricao produto: " & strSQL & "<br>")
	objConn.Execute(strSQL)			 
	
	strSQL = "select cod_prod from tbl_inscricao_produto_session where id_session = " & request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId") 
	set objRS = objConn.Execute(strSQL)			 
	Do While NOT objRS.EOF 
		strCodProdEstoque = objRS("cod_prod")		
	''	strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO + " & Cint(intQuantidade) & " WHERE COD_PROD = " & strCodProdEstoque
'		response.Write("<br> produto ocupacao: " & strSQL & "<br>")
		objRS.MoveNext
		objConn.Execute(strSQL)
	Loop
	CriaInscricaoPF = icodinscricao
End Function 


' ========================================================================
' FIM Cria InscricaoPF no banco de dados
' ========================================================================

' ========================================================================
' Atualiza InscricaoPF no banco de dados
' ========================================================================
Function AtualizaInscricaoPF(prInscricao)
'response.write("<br>ATUALIZA INSCRICAO PF2")
Dim intQtde
Dim strCodProdUpd
	intQtde = 0
	
	strSQL = "SELECT count(*) AS qtde,cod_prod from tbl_inscricao_produto WHERE cod_inscricao = "& prInscricao & " AND cod_prod in(select cod_prod from tbl_inscricao_produto_session where id_session = " & request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId") & ") group by cod_prod"
	'response.Write("<br>qtde prod: " & strSQL)
	Set objRS = objConn.execute(strSQL)
	Do While not objRS.EOF 
		intQtde = cint(getValue(objRS,"qtde"))
		strCodProdUpd = getValue(objRS,"cod_prod")
		If intQtde > 0 Then
			strSQL = " DELETE FROM tbl_Inscricao_Produto " &_
				   "   WHERE COD_INSCRICAO =" & prInscricao & _
				   "   AND COD_PROD = " & strCodProdUpd 
'			response.Write("<br>del prod: " & strSQL)
			objConn.Execute(strSQL)
			strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO - " & intQtde & " WHERE COD_PROD = " & strCodProdUpd			
			objConn.Execute(strSQL)
		End If
		objRS.MoveNext	
	Loop

	
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
	
	strSQL = "insert into tbl_Inscricao_Produto(    cod_inscricao      , cod_prod ,        qtde         ,          vlr_pago        ,     SYS_USERCA          , SYS_DATACA )"
	strSQL = strSQL & "		(select             "  & icodinscricao & " , cod_prod ,        qtde         ,          vlr_pago        , '" & strIDUSER_LOJA & "',  NOW()    from tbl_inscricao_produto_session where id_session = " & request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId") & " )"
	
'	response.Write("<br><br> inscricao produto: " & strSQL & "<br>")
	objConn.Execute(strSQL)			 
	
	strSQL = "select cod_prod from tbl_inscricao_produto_session where id_session = " & request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId") 
	set objRS = objConn.Execute(strSQL)			 
	Do While NOT objRS.EOF 
		strCodProdEstoque = objRS("cod_prod")		
		'strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO + " & Cint(intQuantidade) & " WHERE COD_PROD = " & strCodProdEstoque
		'response.Write("<br> produto ocupacao: " & strSQL & "<br>")
		objRS.MoveNext
		objConn.Execute(strSQL)
	Loop
	
	'strSQL = "INSERT INTO tbl_Inscricao_Produto ( COD_INSCRICAO      ,     COD_PROD      ,     QTDE             ,     VLR_PAGO            ,     SYS_USERCA          , SYS_DATACA) VALUES"
	'strSQL =strSQL & "                          ("& icodinscricao & ", " & strCodProd & ", " & intQuantidade & ", " & dblValorProduto  & ", '" & strIDUSER_LOJA & "',  NOW()    )"
	'response.Write("<br> inscricao produto: " & strSQL & "<br>")
	'objConn.Execute(strSQL)			 
	
	'strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO + " & Cint(intQuantidade) & " WHERE COD_PROD = " & strCodProd
	'response.Write("<br> produto ocupacao: " & strSQL & "<br>")
	'objConn.Execute(strSQL)			 			 
	AtualizaInscricaoPF = prInscricao
End Function


' ========================================================================
' FIM Atualiza InscricaoPF no banco de dados
' ========================================================================


		
 %>
 <!DOCTYPE html>
 	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
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
	if ucase(str_PAIS) = "'BRASIL'" Then
		strSQL = "select cod_empresa from tbl_empresas " 
		strSQL = strSQL & "	WHERE id_num_doc1 = " & str_ID_NUMDOC1 &" AND sys_inativo IS NULL AND NOMECLI IS NOT NULL AND NOMECLI <> '' " 
		strSQL = strSQL & " AND DT_NASC = " & str_DATA_NASC  
	else 
		strSQL = "select cod_empresa from tbl_empresas "  
		strSQL = strSQL & "	WHERE email1 = " & str_EMAIL &" AND sys_inativo IS NULL AND NOMECLI IS NOT NULL AND NOMECLI <> '' " 
		strSQL = strSQL & " AND DT_NASC = " & str_DATA_NASC  
	end if
		'response.Write(strSQL)
		set objRS = objConn.Execute(strSQL)		
		strCOD_EMPRESA = getValue(objRS,"cod_empresa")
		
		if strCOD_EMPRESA <> "" Then
			AtualizaCadastroPF(strCOD_EMPRESA)
		else
			strCOD_EMPRESA = InsereCadastroPF 
		end if	
		








		'aqui questionario, porque já temos o cod empresa que gera o codigo de barra'
		dim strDT_ATUAL
		dim strCodbarra, strCOD_QUESTIONARIO, objRSQuestionario, strLAST_QUESTIONARIO
strCOD_QUESTIONARIO = request("var_cod_questionario")
if strCOD_QUESTIONARIO <>"" Then
							strDT_ATUAL = now()
							'strCOD_QUESTIONARIO = 4
									strCodbarra = strCOD_EMPRESA
									if len(strCodbarra) = 6 then
										strCodbarra = strCodbarra & "010"
									end if
									strSQL = "INSERT INTO tbl_QUESTIONARIO_CLIENTE (CODBARRA,COD_QUESTIONARIO,SYS_USERCA,SYS_DATACA) VALUES ('"&strCodbarra&"',"&strCOD_QUESTIONARIO&",'PROSHOP','"&PrepDataIve(strDT_ATUAL,true,true)&"')"
									
								'Response.Write(strSQL  &vbnewline)
								' response.end()
									objConn.Execute(strSQL)

									strSQL = "SELECT Max(COD_QUESTIONARIO_CLIENTE) AS LAST_QUESTIONARIO FROM tbl_QUESTIONARIO_CLIENTE WHERE CODBARRA = '" & strCodbarra & "' AND COD_QUESTIONARIO = " & strCOD_QUESTIONARIO & " AND SYS_DATACA = '"&PrepDataIve(strDT_ATUAL,true,true)&"' and SYS_USERCA = 'PROSHOP' ORDER BY 1 DESC"
									Set objRSQuestionario = objConn.Execute(strSQL)

									If not objRSQuestionario.EOF Then
										strLAST_QUESTIONARIO = objRSQuestionario("LAST_QUESTIONARIO")
									END IF
									


							'RESPONSE.WRITE(Request.Form&VBNEWLINE)
						For Each item in request.form

									if inStr(item,"quest_") > 0 then
									'RESPONSE.WRITE( item & ":" & Request.Form(item) &vbnewline)'& " **** " & replace(Request.Form(item),", , ","")&VBNEWLINE)
									'	strItens = strItens &"|"& item & ":" & replace(Request.Form(item),"|",";")
									'response.write("cod_pergunta:"& replace(item, "quest_", "") & Request.Form(item)&vbnewline)
									strItens = replace(Request.Form(item),", , ","") &","
									strItens = split(strItens,",")
								''	response.write(strItens&vbnewline)
								''	response.write(UBound(strItens)&vbnewline)

									For j = 0 To UBound(strItens) - 1
										'	 response.write("dado:"&trim(strItens(j))&vbnewline)
										strCodPergunta = replace(item, "quest_", "")
										strCodPerg =""
										strCodResposta =""
										strCodigo = ""
										if Request.Form(item) <>"" Then
											if inStr(strCodPergunta,"_")>0 Then
													'RESPONSE.WRITE(strCodPergunta)
													strCodPergunta = split(strCodPergunta,"_")
													'response.write("input text: " & strCodPergunta(0) & " / " & strCodPergunta(1)& " / "& Request.Form(item) &vbnewline)
													strCodPerg= strCodPergunta(0)
													strCodResposta = strCodPergunta(1)
													strCodigo = Request.Form(item) 
											end if
										End If
									
									
										if inStr(strItens(j),"_") > 0 then
											arrResp = split(strItens(j),"_")
										''	response.write(ubound(arrResp)&vbnewline)
										''	response.write("cod_pergunta: "& replace(item, "quest_", "") &" cod_resposta: " &arrResp(0) &" codigo :" &arrResp(1) &vbnewline)
											strCodPerg = replace(item, "quest_", "")
											strCodResposta = arrResp(0)
											strCodigo = arrResp(1)
										end if
										'strLAST_QUESTIONARIO = 4
										strSQL = ""
										if strCodigo <>"" Then
											strSQL =          " INSERT INTO tbl_QUESTIONARIO_RESPOSTA_CLIENTE "
											strSQL = strSQL & "  (COD_QUESTIONARIO_CLIENTE,COD_QUESTIONARIO_PERGUNTA,COD_QUESTIONARIO_RESPOSTA,    CODIGO     ,SYS_USERCA,SYS_DATACA)"
											strSQL = strSQL & " VALUES "
											strSQL = strSQL & "  ("&strLAST_QUESTIONARIO&","&strCodPerg&       ","&strCodResposta       &",'"&strCodigo&"','PROSHOP',NOW())"
											'Response.Write("SQL: " &strSQL&vbnewline)
											objConn.Execute(strSQL)
										End If

										
										
									Next

									'response.write(Request.Form(item) &","&vbnewline)


									'response.write(item & ":" & replace(Request.Form(item),"|",";")&vbnewline)
									end if
									
									next
								''	response.end
End if 'se tem ou nao questionario'

			











		If VerificaInscricao(strCOD_EMPRESA) <> "" Then
			strCodInscricao = AtualizaInscricaoPF(VerificaInscricao(strCOD_EMPRESA))
		Else
			strCodInscricao = CriaInscricaoPF(strCod_EMPRESA)

		End If
		
 if Err.Number <> 0 then 
	 Response.write ("Error Detail: "&Err.Description)   
	 response.End()
 end if

  if dblValorInscricao > 0 then
  	strAction = "passo3_.asp"
  else
  	strAction = "passo4_.asp"
	 end if
%>

    <form id="finaliza_compra" name="finaliza_compra" action="<%=strAction%>" method="post">
    	<input type="hidden" id="db" name="db" value="<%=CFG_DB%>">
        <input type="hidden" id="lng" name="lng" value="<%=strLng%>">
        <input type="hidden" id="cod_evento" name="cod_evento" value="<%=strCOD_EVENTO%>">
        <input type="hidden" id="var_categoria" name="var_categoria" value="<%=strCategoria%>">
		<input type="hidden" id="var_cod_inscricao" name="var_cod_inscricao" value="<%=strCodInscricao%>">    
        <input type="hidden" id="var_cod_empresa" name="var_cod_empresa" value="<%=strCOD_EMPRESA%>">    
        <input type="hidden" id="var_cod_formapgto" name="var_cod_formapgto" value="<%=replace(strFormaPgto,"'","")%>">    
        <input type="hidden" id="var_valor_comprado" name="var_valor_comprado" value="<%=dblValorInscricao%>">    
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