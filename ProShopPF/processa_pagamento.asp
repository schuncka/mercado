<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->
<%
 
  
Dim objConn, objRS, objLang, strSQL 'banco
Dim arrScodi,arrSdesc 'controle
Dim strLng, strLOCALE, icodinscricao
Dim strCOD_EVENTO, strCategoria
Dim strLinkDefault, i, str_NUM_DOC1
Dim strTitulo, strDescricao, strCodProd, dblDescontoPromo, dblVlrFixoPromo, strCodProdPromo, flagCodigoPromo, dblValorProduto,intQuantidade
Dim strCodigoPromo, dblDescontoProduto, dblVlrFixo, objRSPromo,strIDUSER_LOJA,strCodInscricao, strAction, str_SELECIONA_PAGAMENTO
Dim str_ID_NUMDOC1 , str_EMAIL,str_NOME, str_NOME_COMPLETO, str_NOME_CREDENCIAL, str_DATA_NASC, str_SEXO, str_IMG_FOTO, strCategoriaCred
Dim str_DDD1, str_DDI1, str_FONE1, str_DDI3, str_DDD3, str_FONE3, str_DDI4, str_DDD4, str_FONE4, str_EMAIL_CONFIRMA
Dim str_DEPARTAMENTO, str_CARGO, str_EMAIL_COMERCIAL, str_NECESSIDADE_ESPECIAL, str_CEP, str_ENDERECO,strCOD_EMPRESA
Dim str_END_NUM, str_END_COMPLEMENTO, str_BAIRRO, str_CIDADE, str_ESTADO, str_PAIS, str_CNPJ, str_RAZAO_SOCIAL, str_NOME_FANTASIA, str_CODATIV,str_ENDERECO_COMPLETO, str_NUMERACAO
Dim str_NUM_CARTAO, str_COD_SEGURANCA, stR_DIA_CARTAO, stR_ANO_CARTAO, stR_TITULAR_CARTAO, stR_DATA_NASC_TITULAR, stR_CPF_TITULAR, stR_CEL_DD_TITULAR
Dim str_NUM_PARCELAS, stR_CEL_TITULAR, str_TIPO_DOC, dblValorInscricao
Dim strTIPO_PESS , str_status_cred, strFormaPgto,strCOD_PAIS
Dim strCodProdEstoque, strTELEFONE, strDEPARTAMENTO, str_SOBRENOME,strTipoPgto,dblValorComprado,str_COMPLEMENTO,strLinkBoleto
	

CFG_DB                     = getParam("db")
strLng                     = getParam("lng")
strCOD_EVENTO              = getParam("cod_evento")
strCategoria               = getParam("var_categoria")
strCodProd                 = getParam("cod_prod")
dblValorProduto            = getParam("vlr_prod")
strCodInscricao            = getParam("var_cod_inscricao")
strCategoria               = getParam("var_categoria")
strCOD_EMPRESA             = getParam("var_cod_empresa")
strFormaPgto               = getParam("var_cod_formapgto")
strTipoPgto                = getParam("var_tp_pagamento")
dblValorComprado           = getParam("var_valor_comprado")
dblValorInscricao          = getParam("var_valor_comprado")
strLinkBoleto    = getParam("var_link_boleto")

str_NOME                   = Trim(uCase(getParam("var_nome")))
str_SOBRENOME              = Trim(uCase(getParam("var_sobrenome")))
str_EMAIL                  = Trim(uCase(getParam("var_email")))
str_EMAIL_CONFIRMA         = Trim(uCase(getParam("var_confirma")))
str_SELECIONA_PAGAMENTO    = Trim(uCase(getParam("var_tp_pagamento")))
str_NUM_CARTAO             = Trim(uCase(getParam("var_num_cartao")))
str_COD_SEGURANCA          = Trim(uCase(getParam("var_cod_cartao")))
stR_DIA_CARTAO             = Trim(uCase(getParam("var_dia_cartao")))
stR_ANO_CARTAO             = Trim(uCase(getParam("var_ano_cartao")))
stR_TITULAR_CARTAO         = Trim(uCase(getParam("var_nome_titular")))
stR_DATA_NASC_TITULAR      = Trim(uCase(getParam("var_data_nasc_titular")))
stR_CPF_TITULAR            = Trim(uCase(getParam("var_cpf_titular")))
stR_CEL_DD_TITULAR         = Trim(uCase(getParam("var_cel_ddd_titular")))
stR_CEL_TITULAR            = Trim(uCase(getParam("var_cel_titular")))
str_NUM_PARCELAS           = Trim(uCase(getParam("var_parcelas")))
str_RAZAO_SOCIAL           = Trim(uCase(getParam("var_razao_social")))
str_TIPO_DOC               = Trim(uCase(getParam("var_tipo_doc")))
str_NUM_DOC1               = Trim(uCase(getParam("var_num_doc1")))
str_PAIS                   = Trim(uCase(getParam("var_pais")))
str_CEP                    = Trim(uCase(getParam("var_cep")))
str_ENDERECO               = Trim(uCase(getParam("var_endereco")))
str_BAIRRO                 = Trim(uCase(getParam("var_end_bairro")))
str_NUMERACAO              = Trim(uCase(getParam("var_end_numero")))
str_ESTADO                 = Trim(uCase(getParam("var_end_estado")))
str_CIDADE                 = Trim(uCase(getParam("var_end_cidade")))
str_COMPLEMENTO            = Trim(uCase(getParam("var_end_complemento")))
strTELEFONE                = Trim(uCase(getParam("var_fone")))
strDEPARTAMENTO            = Trim(uCase(getParam("var_departamento")))

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
'response.end()
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
' ' -------------------------------------------------------------------------------
 ' INI: Busca dados relativos as informações de ambiente do sistema (SITE_INFO)
'
 ' Cookies de ambiente PAX (não optamos por session, pq expira muito fácil/rápido e cokies são acessíveis fora da caixa de areia ------------------------------- '
 Response.Cookies("METRO_ProShopPF").Expires = DateAdd("h",2,now)
 Response.Cookies("METRO_ProShopPF")("locale")	  = strLOCALE
 'response.Write("<br><strong>COM GETPARAM: "&getParam("var_razao_social")&"</strong>")
 ' response.Write("<br><strong>COM REQUEST: "&request("var_razao_social")&"</strong>")
 ' response.end()


If str_NOME <> "" Then
	str_NOME = "'" & str_NOME & " " & str_SOBRENOME & "'"
Else
	str_NOME = "NULL"
End If


If str_EMAIL <> "" Then
	str_EMAIL = "'" & str_EMAIL & "'"
Else
	str_EMAIL = "NULL"
End If


If str_NUM_CARTAO <> "" Then
	str_NUM_CARTAO = "'" & str_NUM_CARTAO & "'"
Else
	str_NUM_CARTAO = "NULL"
End If

If str_COD_SEGURANCA <> "" Then
    str_COD_SEGURANCA = "'" & str_COD_SEGURANCA & "'"
  Else
    str_COD_SEGURANCA = "NULL"
End If

If stR_DIA_CARTAO <> "" Then
    stR_DIA_CARTAO = "'" & stR_DIA_CARTAO & "'"
  Else
    stR_DIA_CARTAO = "NULL"
End If

If stR_ANO_CARTAO <> "" Then
    stR_ANO_CARTAO = "'" & stR_ANO_CARTAO & "'"
  Else
    stR_ANO_CARTAO = "NULL"
End If

If stR_TITULAR_CARTAO <> "" Then
    stR_TITULAR_CARTAO = "'" & stR_TITULAR_CARTAO & "'"
  Else
    stR_TITULAR_CARTAO = "NULL"
End If

If stR_DATA_NASC_TITULAR <> "" Then
   stR_DATA_NASC_TITULAR = "'" & PrepDataIve(stR_DATA_NASC_TITULAR,false,false) & "'"
  Else
    stR_DATA_NASC_TITULAR = "NULL"
End If

If stR_CPF_TITULAR <> "" Then
    stR_CPF_TITULAR = "'" & stR_CPF_TITULAR & "'"
  Else
    stR_CPF_TITULAR = "NULL"
End If

If stR_CEL_TITULAR <> "" Then
    If stR_CEL_DD_TITULAR <> "" Then stR_CEL_TITULAR = Trim(stR_CEL_DD_TITULAR & " " & stR_CEL_TITULAR)   
    stR_CEL_TITULAR = "'" & Trim(stR_CEL_TITULAR) & "'"
  Else
    stR_CEL_TITULAR = "NULL"
  End If

If str_NUM_PARCELAS <> "" Then
    str_NUM_PARCELAS = "'" & str_NUM_PARCELAS & "'"
  Else
    str_NUM_PARCELAS = "NULL"
End If

If str_RAZAO_SOCIAL <> "" Then
    str_RAZAO_SOCIAL = "'" & str_RAZAO_SOCIAL & "'"
  Else
    str_RAZAO_SOCIAL = "NULL"
End If

If str_TIPO_DOC <> "" Then
    str_TIPO_DOC = "'" & str_TIPO_DOC & "'"
  Else
    str_TIPO_DOC = "NULL"
End If

If str_NUM_DOC1 <> "" Then
    str_NUM_DOC1 = "'" & str_NUM_DOC1 & "'"
  Else
    str_NUM_DOC1 = "NULL"
End If

If str_PAIS <> "" Then
    str_PAIS = "'" & str_PAIS & "'"
  Else
    str_PAIS = "NULL"
End If

 If str_CEP <> "" Then
    str_CEP = "'" & str_CEP & "'"
  Else
    str_CEP = "NULL"
End If

If str_ENDERECO <> "" Then
    str_ENDERECO = "'" & str_ENDERECO & "'"
  Else
    str_ENDERECO = "NULL"
End If

If str_BAIRRO <> "" Then
    str_BAIRRO = "'" & str_BAIRRO & "'"
  Else
    str_BAIRRO = "NULL"
End If

If str_NUMERACAO <> "" Then
    str_NUMERACAO = "'" & str_NUMERACAO & "'"
  Else
    str_NUMERACAO = "NULL"
End If

If str_ESTADO <> "" Then
    str_ESTADO = "'" & str_ESTADO & "'"
  Else
    str_ESTADO = "NULL"
End If

If str_CIDADE <> "" Then
    str_CIDADE = "'" & str_CIDADE & "'"
  Else
    str_CIDADE = "NULL"
End If

if str_COMPLEMENTO <> "" then
	str_COMPLEMENTO = "'" & str_COMPLEMENTO & "'"
else
	str_COMPLEMENTO = "NULL"
end if

if strTELEFONE <> "" then
	strTELEFONE = "'" & strTELEFONE & "'"
else 
	strTELEFONE = "NULL"
end if

if strDEPARTAMENTO <> "" then
	strDEPARTAMENTO = "'" & strDEPARTAMENTO & "'"
else
	strDEPARTAMENTO = "NULL"
end if


if strFormaPgto <> "" then
	strFormaPgto = "'" & strFormaPgto & "'"
else
	strFormaPgto = "NULL"
end if

'===========================================================
' INICIO DEBUG
'===========================================================
'response.write("<br>str_NOME: "&str_NOME)  
'response.write("<br>str_NOME_COMPLETO: "&str_NOME_COMPLETO)  
'response.write("<br>str_EMAIL: "&str_EMAIL)  
'response.write("<br>str_EMAIL_CONFIRMA: "&str_EMAIL_CONFIRMA)  
'response.write("<br>str_SELECIONA_PAGAMENTO: "&str_SELECIONA_PAGAMENTO)  
'response.write("<br>str_COD_SEGURANCA: "&str_COD_SEGURANCA)  
'response.write("<br>stR_DIA_CARTAO: "&stR_DIA_CARTAO)  
'response.write("<br>stR_ANO_CARTAO: "&stR_ANO_CARTAO)
'response.write("<br>stR_TITULAR_CARTAO: "&stR_TITULAR_CARTAO)
'response.write("<br>stR_DATA_NASC_TITULAR: "&stR_DATA_NASC_TITULAR)
'response.write("<br>stR_CPF_TITULAR: "&stR_CPF_TITULAR)
'response.write("<br>stR_CEL_DD_TITULAR: "&stR_CEL_DD_TITULAR)
'response.write("<br>stR_CEL_TITULAR: "&stR_CEL_TITULAR)
'response.write("<br>str_NUM_PARCELAS: "&str_NUM_PARCELAS) 
'response.write("<br>str_RAZAO_SOCIAL: "&str_RAZAO_SOCIAL)
'response.write("<br>str_TIPO_DOC: "&str_TIPO_DOC)
'response.write("<br>str_NUM_DOC1: "&str_NUM_DOC1)
'response.write("<br>str_PAIS: "&str_PAIS)
'response.write("<br>str_CEP: "&str_CEP)  
'response.write("<br>str_ENDERECO: "&str_ENDERECO)  
'response.write("<br>str_BAIRRO: "&str_BAIRRO)  
'response.write("<br>str_NUMERACAO: "&str_NUMERACAO)  
'response.write("<br>str_ESTADO: "&str_ESTADO)
'response.write("<br>str_PAIS: "&str_PAIS)  
'
'response.end

''===========================================================
'' FIM DEBUG
''===========================================================
'strAction = "passo4_.asp"

strSQL = " UPDATE tbl_inscricao SET "
strSQL = strSQL & "         fat_razao         = " & str_RAZAO_SOCIAL  
strSQL = strSQL & "       , fat_cnpj          = " & str_NUM_DOC1 
'strSQL = strSQL & "       , fat_ie            = " & & "," 
'strSQL = strSQL & "       , fat_im            = " & & "," 
strSQL = strSQL & "       , fat_endfull       = '" & replace(str_ENDERECO,"'","") & ", " & replace(str_NUMERACAO,"'","") & " " & replace(str_COMPLEMENTO,"'","") & "'"
strSQL = strSQL & "       , fat_end_logr      = " & str_ENDERECO 
strSQL = strSQL & "       , fat_end_num       = " & str_NUMERACAO 
strSQL = strSQL & "       , fat_end_compl     = " & str_COMPLEMENTO
strSQL = strSQL & "       , fat_cep           = " & str_CEP 
strSQL = strSQL & "       , fat_cidade        = " & str_CIDADE 
strSQL = strSQL & "       , fat_bairro        = " & str_BAIRRO 
strSQL = strSQL & "       , fat_estado        = " & str_ESTADO 
strSQL = strSQL & "       , fat_contato_nome  = " & str_NOME 
strSQL = strSQL & "       , fat_contato_email = " & str_EMAIL 
strSQL = strSQL & "       , fat_contato_fone  = " & strTELEFONE 
strSQL = strSQL & "       , fat_contato_depto = " & strDEPARTAMENTO
strSQL = strSQL & "       , cod_formapgto     = " & strFormaPgto
strSQL = strSQL & " WHERE cod_inscricao = " & strCodInscricao 
'response.write(strSQL)
objConn.Execute(strSQL)
strAction = "passo4_.asp"
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
    <body>   
   <body bgcolor="#333333"><!--strong><br>CHEGOU AQUI É PQ FINALIZOU A INSCRICAO E APOS VAI PARA OS ENCAMINHAMENTOS FINAIS</strong//-->

    <form id="finaliza_compra" name="finaliza_compra" action="<%=strAction%>" method="post">
    	     <input type="hidden" id="db" name="db" value="<%=CFG_DB%>">
         <!--br><--><input type="hidden" id="lng" name="lng" value="<%=strLng%>">
         <!--br><--><input type="hidden" id="cod_evento" name="cod_evento" value="<%=strCOD_EVENTO%>">
         <!--br><--><input type="hidden" id="var_categoria" name="var_categoria" value="<%=strCategoria%>">
	     <!--br><--><input type="hidden" id="var_cod_inscricao" name="var_cod_inscricao" value="<%=strCodInscricao%>">    
         <!--br><--><input type="hidden" id="var_cod_empresa" name="var_cod_empresa" value="<%=strCOD_EMPRESA%>">    
         <!--br><--><input type="hidden" id="var_cod_formapgto" name="var_cod_formapgto" value="<%=replace(strFormaPgto,"'","")%>"> 
             <input type="hidden" id="var_valor_comprado" name="var_valor_comprado" value="<%=dblValorInscricao%>">   
			 <input type="hidden" id="var_link_boleto" name="var_link_boleto" value="<%=strLinkBoleto%>">
        
           
    </form>
    <!--span onClick="document.getElementById('finaliza_compra').submit()" style="cursor:pointer">[ CLIQUE AQUI ]</span-->
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
				}, 50000);		
		});
			
	</script>

	<div class="content"></div>
    
    
    </body>
 </html>