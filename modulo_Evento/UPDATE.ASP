<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_Evento",Session("ID_USER")), true %>
<%
 Const LTB = "tbl_evento" ' - Nome da Tabela...
 Const DKN = "ID_AUTO"    ' - Campo chave...
 Const TIT = "EVENTO"     ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL,strSQL2,strSQL3,objRSDetail
 'Relativas a FILTRAGEM e Seleção	
 Dim  strCOD_EVENTO,strID_AUTO,strMERCADO, strIDTBL_MERCADO, strIDTBL_EVENTO
	
 AbreDBConn objConn, CFG_DB
	
 strID_AUTO = Replace(GetParam("var_chavereg"),"'","''")
 strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")
 '-----------------------------------------------------------------------------------------
 strSQL = " SELECT   COD_EVENTO "
 strSQL = strSQL & "  ,NOME						"	
 strSQL = strSQL & "  ,NOME_COMPLETO                "
 strSQL = strSQL & "  ,CABECALHO                    "
 strSQL = strSQL & "  ,RODAPE                       "
 strSQL = strSQL & "  ,SITE                         "
 strSQL = strSQL & "  ,DT_MATERIAL                  "
 strSQL = strSQL & "  ,HR_MATERIAL                  "
 strSQL = strSQL & "  ,PAVILHAO                     "
 strSQL = strSQL & "  ,CIDADE                       "
 strSQL = strSQL & "  ,AGENCIA_TURISMO              "
 strSQL = strSQL & "  ,AGENCIA_PUBLICIDADE          "
 strSQL = strSQL & "  ,AGENCIA_BANCARIA             "
 strSQL = strSQL & "  ,MONTADORA                    "
 strSQL = strSQL & "  ,DT_INICIO                    "
 strSQL = strSQL & "  ,DT_FIM                       "
 strSQL = strSQL & "  ,HORA_INICIO                  "
 strSQL = strSQL & "  ,HORA_FIM                     "
 strSQL = strSQL & "  ,ESTADO_EVENTO                "
 strSQL = strSQL & "  ,LOGOMARCA                    "
 strSQL = strSQL & "  ,FREE                         "
 strSQL = strSQL & "  ,LOJA_STATUS_PRECO            "
 strSQL = strSQL & "  ,STATUS_PRECO                 "
 strSQL = strSQL & "  ,STATUS_CRED                  "
 strSQL = strSQL & "  ,BLOQUEADO                    "
 strSQL = strSQL & "  ,EMAIL                        "
 strSQL = strSQL & "  ,EMAIL_SENDER                 "
 strSQL = strSQL & "  ,SYS_INATIVO                  "
 strSQL = strSQL & "  ,ATIVO                        "
 strSQL = strSQL & "  ,CABECALHO_LOJA               "
 strSQL = strSQL & "  ,RODAPE_LOJA                  "
 strSQL = strSQL & "  ,INSTRUCAO_INSC_EXISTENTE     "
 strSQL = strSQL & "  ,ARM_TEXTO                    "
 strSQL = strSQL & "  ,ARM_TEXTO_INTL               "
 strSQL = strSQL & "  ,ACE_TEXTO                    "
 strSQL = strSQL & "  ,ACE_TEXTO_INTL               "
 strSQL = strSQL & "  ,ACEPRESS_TEXTO               "
 strSQL = strSQL & "  ,MOD1_TITLE                   "
 strSQL = strSQL & "  ,MOD1_TEXTO                   "
 strSQL = strSQL & "  ,MOD2_TITLE                   "
 strSQL = strSQL & "  ,MOD2_TEXTO                   "
 strSQL = strSQL & "  ,MOD3_TITLE                   "
 strSQL = strSQL & "  ,MOD3_TEXTO                   "
 strSQL = strSQL & "  ,MOD4_TITLE                   "
 strSQL = strSQL & "  ,MOD4_TEXTO                   "
 strSQL = strSQL & "  ,MOD5_TITLE                   "
 strSQL = strSQL & "  ,MOD5_TEXTO                   "
 strSQL = strSQL & "  ,MOD6_TITLE                   "
 strSQL = strSQL & "  ,MOD6_TEXTO                   "
 strSQL = strSQL & "  ,MOD7_TITLE                   "
 strSQL = strSQL & "  ,MOD7_TEXTO                   "
 strSQL = strSQL & "  ,FONE                         "
 strSQL = strSQL & "  ,LOJA_ATIVA                   "
 strSQL = strSQL & "  ,LOJAPJ_ATIVA                 "
 strSQL = strSQL & "  ,MODELO_LOJAPJ                "
 strSQL = strSQL & "  ,IDUSER_LOJA                  "
 strSQL = strSQL & "  ,RECIBO_TEXTO                 "
 strSQL = strSQL & "  ,CNPJ                         "
 strSQL = strSQL & "  ,COD_MOEDA_EVENTO             "
 strSQL = strSQL & "  ,COD_MOEDA_COBRANCA           "
 strSQL = strSQL & "  ,COD_MOEDA_REFERENCIA         "
 strSQL = strSQL & "  ,LOJA_SHOW_DADOS              "
 strSQL = strSQL & "  ,LOJA_SHOW_ENTIDADE           "
 strSQL = strSQL & "  ,ID_AUTO                      "
 strSQL = strSQL & "  ,SUBPAPER_ATIVA               "
 strSQL = strSQL & "  ,STATUS_PRECO_VISITANTE       "
 strSQL = strSQL & "  ,ATESTADO_TEXTO               "
 strSQL = strSQL & "  ,CONVITE_TEXTO                "
 strSQL = strSQL & "  ,CONVITE_VIP_TEXTO            "
 strSQL = strSQL & "  ,CONVITE_ELETRONICO_TEXTO     "
 strSQL = strSQL & "  ,CONVITE_ELETRONICO_TEXTO_INTL"
 strSQL = strSQL & "  ,APE_TEXTO                    "
 strSQL = strSQL & "  ,APE_TEXTO_INTL               "
 strSQL = strSQL & "  ,LOJA_SHOW_FINANCEIRO         "
 strSQL = strSQL & "  ,LOJA_SHOW_FATURAMENTO        "
 strSQL = strSQL & "  ,ARM_ASSUNTO                  "
 strSQL = strSQL & "  ,ARM_ASSUNTO_INTL             "
 strSQL = strSQL & "  ,ACE_ASSUNTO                  "
 strSQL = strSQL & "  ,ACE_ASSUNTO_INTL             "
 strSQL = strSQL & "  ,ACE_BLOQUEADO_TEXTO          "
 strSQL = strSQL & "  ,ACE_APROVADO_TEXTO           "
 strSQL = strSQL & "  ,CABECALHO_RECIBO             "
 strSQL = strSQL & "  ,CABECALHO_PAPER              "
 strSQL = strSQL & "  ,RODAPE_PAPER                 "
 strSQL = strSQL & "  ,MOD8_TITLE                   "
 strSQL = strSQL & "  ,MOD8_TEXTO                   "
 strSQL = strSQL & "  ,MOD9_TITLE                   "
 strSQL = strSQL & "  ,MOD9_TEXTO                   "
 strSQL = strSQL & "  ,MOD10_TITLE                  "
 strSQL = strSQL & "  ,MOD10_TEXTO                  "
 strSQL = strSQL & "  ,SMS_USER                     "
 strSQL = strSQL & "  ,SMS_PWD                      "
 strSQL = strSQL & "  ,SMS_TEXTO                    "
 strSQL = strSQL & "  ,COD_GRUPO_EVENTO             "
 strSQL = strSQL & "  ,PSC_ATIVA                    "
 strSQL = strSQL & "  ,CUPOM_FISCAL                 "
 strSQL = strSQL & "  ,VENDA_RAPIDA                 "
 strSQL = strSQL & "  ,RETIRADA_MATERIAL            "
 strSQL = strSQL & "  ,LIMITE_IDADE                 "
 strSQL = strSQL & "  ,PSC_STATUS_CRED              "
 strSQL = strSQL & "  ,SMTP_SERVER                  "
 strSQL = strSQL & "  ,SMTP_USER                    "
 strSQL = strSQL & "  ,SMTP_PWD                     "
 strSQL = strSQL & "  ,INSCR_MUNICIPAL              "
 strSQL = strSQL & "  ,ENTIDADE_OBRIGATORIO         "
 strSQL = strSQL & "  ,ACE_ASSUNTO_US               "
 strSQL = strSQL & "  ,ACE_TEXTO_US                 "
 strSQL = strSQL & "  ,ACE_ASSUNTO_SP               "
 strSQL = strSQL & "  ,ACE_TEXTO_SP                 "
 strSQL = strSQL & "  ,CERTIFICADO_TEXTO1           "
 strSQL = strSQL & "  ,CERTIFICADO_TEXTO2           "
 strSQL = strSQL & "  ,ACEPRESS_TEXTO_US            "
 strSQL = strSQL & "  ,ACEPRESS_TEXTO_ES            "
 strSQL = strSQL & "  ,EMAIL_PRESS                  "
 strSQL = strSQL & "  ,APE_ASSUNTO                  "
 strSQL = strSQL & "  ,APE_ASSUNTO_INTL             "
 strSQL = strSQL & "  ,ACEPRESS_TEXTO_INTL          "
 strSQL = strSQL & "  ,EMAIL_AUDITORIA              "
 strSQL = strSQL & "  ,EMAIL_AUDITORIA_INTL         "
 strSQL = strSQL & "  ,ARIEL_TEXTO                  "
 strSQL = strSQL & "  ,ARIEL_TEXTO_INTL             "
 strSQL = strSQL & "  ,ARIEL_TEXTO_NPG              "
 strSQL = strSQL & "  ,LOJA_PESQUISA_CNPJ           "
 strSQL = strSQL & "  ,PRESS_STATUS_CRED            "
 strSQL = strSQL & "  ,SMTP_PORT                    "
 strSQL = strSQL & "  ,IMG1                         "
 strSQL = strSQL & "  ,IMG2                         "
 strSQL = strSQL & "  ,PROGRAMACAO                  "
 strSQL = strSQL & "  ,ATESTADO_PDF                 "
 strSQL = strSQL & "  ,ATESTADO_PDF_ORIENTACAO      "
 strSQL = strSQL & "  ,LOJA_TIPO_LOGIN              "
 strSQL = strSQL & "  ,DESCRICAO                    "
 strSQL = strSQL & "  ,LOGRADOURO                   "
 strSQL = strSQL & "  ,BAIRRO                       "
 strSQL = strSQL & "  ,cep_evento                   "
 strSQL = strSQL & "  ,PAIS                         "
 strSQL = strSQL & "  ,CRED_PRINT_CONTROLE          "
 strSQL = strSQL & "  ,BARCODE_MODE                 "
 strSQL = strSQL & "  ,BARCODE_HEIGHT               "
 strSQL = strSQL & "  ,TP_ACESSO_TOTEM              "
 strSQL = strSQL & "  ,AVISO_LOJA_INATIVA           "
 strSQL = strSQL & "  ,LOJA_PESQUISA_CPF            "
 strSQL = strSQL & "  ,REGULAMENTO_LOJA             "
 strSQL = strSQL & "  ,REGULAMENTO_LOJA_INTL        "
 strSQL = strSQL & "  ,EMAIL_REPLY_VISITANTE        "
 strSQL = strSQL & "  ,EMAIL_REPLY_CONGRESSISTA     "
 strSQL = strSQL & "  ,EMAIL_REPLY_CAEX             "
 strSQL = strSQL & "  ,EMAIL_REPLY_PALESTRANTE      "
 strSQL = strSQL & "  ,EMAIL_REPLY_PAPER            "
 strSQL = strSQL & "  ,IMPRIMIR_VISITANTE           "
 strSQL = strSQL & "  ,IMPRIMIR_CONGRESSISTA        "
 strSQL = strSQL & "  ,BYPASS_CORTESIA              "
 strSQL = strSQL & "  ,LOJA_FACEBOOK_PIXELID        "
 strSQL = strSQL & " , proshop_banner_carossel_pt   "
 strSQL = strSQL & " , proshop_banner_carossel_en   "
 strSQL = strSQL & " , proshop_banner_carossel_es   "
 strSQL = strSQL & " , proshop_descricao_pt         "
 strSQL = strSQL & " , proshop_descricao_en         "
 strSQL = strSQL & " , proshop_descricao_es         "
 strSQL = strSQL & " , proshop_google_maps          "
 strSQL = strSQL & " , proshop_email_evento         "
 strSQL = strSQL & " , proshop_email_contato1       "
 strSQL = strSQL & " , proshop_email_contato2       "
 strSQL = strSQL & " , proshop_campos_obrigatorios  "
 strSQL = strSQL & " , proshop_campos_exibir        "
 strSQL = strSQL & " , proshop_campos_obrigatorios_es "
 strSQL = strSQL & " , proshop_campos_obrigatorios_en "
 strSQL = strSQL & " , proshop_campos_exibir_es "
 strSQL = strSQL & " , proshop_campos_exibir_en "
 strSQL = strSQL & " , proshop_gtm_id               "
 strSQL = strSQL & " , proshop_cabecalho   "
 strSQL = strSQL & " , proshop_rodape      "
 strSQL = strSQL & "  FROM "& LTB 
 strSQL = strSQL & " WHERE ID_AUTO = " & strID_AUTO 
 'athDebug strSQL, true
 '------------------------------------------------------------------------------------------
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 

<script src="../_scripts/scriptsCS.js"></script>
<script src="metro-calendar.js"></script>
<script src="metro-datepicker.js"></script>

<!-- funções para action dos botões OK, APLICAR,CANCELAR  e NOTIFICAÇÂO//-->
<script type="text/javascript" language="javascript">

<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() {
	 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Evento/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %>  
	/*document.formupdate.DEFAULT_LOCATION.value="../_database/athWindowClose.asp"; */
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Evento/update.asp?var_chavereg=<%=strID_AUTO%>&var_cod_evento=<%=strCOD_EVENTO%>"; 
  if (validateRequestedFields("formupdate")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.formupdate.submit(); 
  }
}
function cancelar() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("window.history.back()")
	 else
  		response.write ("window.close();")
  	 end if
 %> 
}


function viewdoc(doc) {
  var conteudo = '';
  
  if(doc!='') {
    conteudo = eval('document.formupdate.DBVAR_STR_' + doc + '.value');
  }
  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}

function edithtml(doc) {
  var conteudo = '';
  
  if(doc!='') {
    conteudo = eval('document.formupdate.DBVAR_STR_' + doc + '.value');
  }
  window.open('edithtml.asp?var_html='+encodeURIComponent(conteudo)+'&var_campo=DBVAR_STR_'+doc,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}

function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '	../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

function SetParentField(campo,valor) {
	document.getElementById(campo).value = valor;
}

function atualizaMercado() {
	var_exibe = document.formupdate.RB_EXIBE_APP[0].checked;
	var_mercado = document.formupdate.RB_MERCADO.value;
	
	document.formmercado.var_exibe.value = var_exibe;
	document.formmercado.var_mercado.value = var_mercado;
	//alert(var_exibe);
	//alert(var_mercado);
	document.formmercado.submit();
}
</script>
<script language="javascript" type="text/javascript">
//função para ativar o date picker dos campos data
$("#datepicker").datepicker( {
	date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer já  ele modifica automaticamente para data setada dentro da função//-->
	format: "dd/mm/yyyy <%=Time%>", // set output format
	effect: "none", // none, slide, fade
	position: "bottom", // top or bottom,
	locale: ''en, // 'ru' or 'en', default is $.Metro.currentLocale
	
});
</script>
<!-- FIM----------------------------------------- funções //-->

</head>
<body class="metro" id="metrotablevista">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding50">
<!--div class TAB CONTROL --------------------------------------------------//-->
                 <form name="formupdate" id="formupdate" action="../_database/athupdatetodb.asp" method="post">
                <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
                <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strID_AUTO%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">

	<div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strID_AUTO%>.GERAL</a></li>
            <li class=""><a href="#CFGEMAIL">EMAIL</a></li>
            <li class=""><a href="#CFGMOEDA">MOEDA</a></li>
            <li class=""><a href="#STATUS">STATUS</a></li>
            <li class=""><a href="#HTMLTXT">HTML TXT</a></li>
            <li class=""><a href="#LOJA">LOJA</a></li>
            <li class=""><a href="#CORRESPONDENCIA">OFICIOS</a></li>
            <li class=""><a href="#PROSHOP">PROSHOP</a></li>
            <!-- li class=""><a href="#AJUDA">AJUDA</a></li //-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <!--//-->
                    <div class="tab-control" data-role="tab-control">
                        <ul class="tabs">
                            <li class="active"><a href="#GERAL1">CADASTRO</a></li>
                            <li><a href="#GERAL2">REGISTRO</a></li>
                            <li><a href="#GERAL3">LOCALIDADE</a></li>
                            <li><a href="#AGENCIA">AGENCIA</a></li>     
                            <li><a href="#SMS">SMS</a></li>
                            <!--<li><a href="#MINI">MINI</a></li>//-->   
                        </ul>
                        <div class="frames">
                            <div class="frame" id="GERAL1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2"><p>*Código/*Nome:</p></div>
                                        <div class="span8">
                                            <div class="input-control text size2 info-state" data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_COD_EVENTOô" name="DBVAR_STR_COD_EVENTOô" type="text" placeholder="" value="<%=getValue(objRS,"COD_EVENTO")%>" maxlength="11" class="size2" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                </p>
                                            </div>
                                            <div class="input-control text size4 info-state" data-role="input-control">                                        
                                                <p>                                               
                                                	<input id="DBVAR_STR_NOMEô" name="DBVAR_STR_NOMEô" type="text" placeholder="" value="<%=getValue(objRS,"NOME")%>" maxlength="50" class="size4">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>Nome Completo/Idade Limite:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text size5" data-role="input-control">
                                                <p>
                                                <input id="DBVAR_STR_NOME_COMPLETO" name="DBVAR_STR_NOME_COMPLETO" type="text" placeholder="" value="<%=getValue(objRS,"NOME_COMPLETO")%>" maxlength="100" >
                                                </p>
                                                </div>
                                            <div class="input-control text size1" data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_LIMITE_IDADE" name="DBVAR_STR_LIMITE_IDADE" type="text" placeholder="" value="<%=getValue(objRS,"LIMITE_IDADE")%>"  maxlength="11" class="" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                </p>
                                            </div>

                                            <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>*Data Ini./Data Fim:</p></div><!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer. Ele modifica automaticamente para data setada dentro da função//-->
                                        <div class="span8">
                                            <div class="input-control text size3 info-state" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                	<input id="DBVAR_DATE_DT_INICIO" name="DBVAR_DATE_DT_INICIOô" type="text" placeholder="" value="<%=PrepData(getValue(objRS,"DT_INICIO"),True,False)%> " maxlength="11" class=""  >
                                                	<span class="btn-date"></span>
                                            	</p>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">                                        
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                	<input id="DBVAR_DATE_DT_FIM" name="DBVAR_DATE_DT_FIM" type="text" placeholder="" value="<%=PrepData(getValue(objRS,"DT_FIM"),True,False)%>" maxlength="11" class="">
                                                	<span class="btn-date"></span>
                                                </p>
                                            </div>    
                                            <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2"><p>Hora Inicio/Hora Término:</p></div>
                                        <div class="span8">
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" >
                                                	<input id="DBVAR_DATETIME_HORA_INICIO" name="DBVAR_DATETIME_HORA_INICIO" type="text" placeholder="" value="<% If IsDate(getValue(objRS,"HORA_INICIO")) Then Response.Write(FormatDateTime(PrepData(getValue(objRS,"HORA_INICIO"),True,True), 4)) %>" maxlength="8" class="">
                                            	</p>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">                                        
                                                <p class="input-control text span3" >                                                
                                                	<input id="DBVAR_DATETIME_HORA_FIM" name="DBVAR_DATETIME_HORA_FIM" type="text" placeholder="" value="<% If IsDate(getValue(objRS,"HORA_FIM")) Then Response.Write(FormatDateTime(PrepData(getValue(objRS,"HORA_FIM"),True,True), 4)) %>" maxlength="8" class="">
                                                </p>
                                            </div>    
                                            <span class="tertiary-text-secondary"><br>HH:MM</span>
                                        </div>
                                    </div>
                                </div><!--fim grid//-->  
                            </div><!--fim de frame geral1//-->
                            <div class="frame" id="GERAL2">
                                <div class="grid" style="border:0px solid #F00">
                                      <div class="row">
                                            <div class="span2" style=""><p>Site/Telefone:</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text size3" data-role="input-control">
                                                    <p class="input-control text span3" >
                                                        <input id="DBVAR_STR_SITE" name="DBVAR_STR_SITE" type="text" placeholder="" value="<%=getValue(objRS,"SITE")%>" maxlength="50" class="size3">
                                                    </p>
                                                </div>
                                                <div class="input-control text size3" data-role="input-control">                                        
                                                    <p class="input-control text span3" >
                                                        <input id="DBVAR_STR_FONE" name="DBVAR_STR_FONE" type="text" placeholder="" value="<%=getValue(objRS,"FONE")%>" maxlength="50" class="size3">
                                                    </p>
                                                </div>    
                                                <span class="tertiary-text-secondary"></span>
                                            </div>
                                      </div> <!--FIM row//-->
                                     <div class="row">
                                        <div class="span2" style=""><p>CNPJ/Data Material:</p></div>
                                        <div class="span8 "> 
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3">
                                                   <input id="DBVAR_STR_CNPJ" name="DBVAR_STR_CNPJ" type="text" placeholder="" value="<%=getValue(objRS,"CNPJ")%>" maxlength="50" class="">
                                                </p>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">                                        
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade" >
                                                    <input id="DBVAR_STR_DT_MATERIAL" name="DBVAR_STR_DT_MATERIAL"  type="text" placeholder="" value="<%=PrepData(getValue(objRS,"DT_MATERIAL"),True,false)%>" maxlength="30" class="">
                                                <span class="btn-date"></span>                                                        
                                                </p>
                                            </div> 
                                            <span class="tertiary-text-secondary"></span>                       
                                        </div>
                                     </div> <!--FIM row//-->
                                    <div class="row">
                                        <div class="span2" style=""><p>Hora Material/Pavilhão:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" >
                                                    <input id="DBVAR_STR_HR_MATERIAL" name="DBVAR_STR_HR_MATERIAL" type="text" placeholder="" value="<%=getValue(objRS,"HR_MATERIAL")%>" maxlength="50" class="size3">
                                                </p>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">                                        
                                                <p class="input-control text span3" >                                                        
                                                    <input id="DBVAR_STR_PAVILHAO" name="DBVAR_STR_PAVILHAO" type="text" placeholder="" value="<%=getValue(objRS,"PAVILHAO")%>" maxlength="50" class="size3">
                                                </p>
                                            </div>    
                                            <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> <!--FIM row//-->   
                                       <div class="row">
                                            <div class="span2" style=""><p>Logomarca:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_LOGOMARCA" name="DBVAR_STR_LOGOMARCA" type="text" placeholder="" value="<%=getValue(objRS,"LOGOMARCA")%>" maxlength="50">
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div> <!--FIM row//-->                            
                                       <div class="row">
                                            <div class="span2" style=""><p>Cod. Grupo Evento:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_COD_GRUPO_EVENTO" name="DBVAR_STR_COD_GRUPO_EVENTO" type="text" placeholder="" value="<%=getValue(objRS,"COD_GRUPO_EVENTO")%>" maxlength="5">
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div> <!--FIM row//-->                            

                                </div><!--fim grid//--> 
                            </div><!--fim do frame GERAL2//-->
                             <div class="frame" id="GERAL3">
                                <div class="grid" style="border:0px solid #F00">
                                <div class="row">
                                            <div class="span2" style=""><p>Logradouro:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_LOGRADOURO" name="DBVAR_STR_LOGRADOURO" type="text" placeholder="" value="<%=getValue(objRS,"LOGRADOURO")%>" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div> <!--FIM row//-->
                                     
                                    <div class="row">
                                            <div class="span2" style=""><p>Bairro:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_BAIRRO" name="DBVAR_STR_BAIRRO" type="text" placeholder="" value="<%=getValue(objRS,"BAIRRO")%>" maxlength="250" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div><!--FIM row//-->
                                     
                                     <div class="row">
                                            <div class="span2" style=""><p>Cidade:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_CIDADE" name="DBVAR_STR_CIDADE" type="text" placeholder="" value="<%=getValue(objRS,"CIDADE")%>" maxlength="50">
                                                    </p>
                                                 </div>  
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div><!--FIM row//--> 
                                     
                                     <div class="row">
                                        <div class="span2" style=""><p>Estado/País:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control select size3" data-role="input-control">
                                                 <p>
                                                    <select id="DBVAR_STR_ESTADO_EVENTO" name="DBVAR_STR_ESTADO_EVENTO" class="">
                                                    <option value=""   <%IF getValue(objRS,"ESTADO_EVENTO") = "" THEN RESPONSE.Write("selected") %>>[selecione]</option>
                                                    <option value="AC" <%IF getValue(objRS,"ESTADO_EVENTO") = "AC" THEN RESPONSE.Write("selected") %>>Acre - AC</option>
                                                    <option value="AL" <%IF getValue(objRS,"ESTADO_EVENTO") = "AL" THEN RESPONSE.Write("selected") %>>Alagoas - AL</option>
                                                    <option value="AP" <%IF getValue(objRS,"ESTADO_EVENTO") = "AP" THEN RESPONSE.Write("selected") %>>Amapá - AP</option>
                                                    <option value="AM" <%IF getValue(objRS,"ESTADO_EVENTO") = "AM" THEN RESPONSE.Write("selected") %>>Amazonas - AM</option>
                                                    <option value="BA" <%IF getValue(objRS,"ESTADO_EVENTO") = "BA" THEN RESPONSE.Write("selected") %>>Bahia  - BA</option>
                                                    <option value="CE" <%IF getValue(objRS,"ESTADO_EVENTO") = "CE" THEN RESPONSE.Write("selected") %>>Ceará - CE</option>
                                                    <option value="DF" <%IF getValue(objRS,"ESTADO_EVENTO") = "DF" THEN RESPONSE.Write("selected") %>>Distrito Federal  - DF</option>
                                                    <option value="ES" <%IF getValue(objRS,"ESTADO_EVENTO") = "ES" THEN RESPONSE.Write("selected") %>>Espírito Santo - ES</option>
                                                    <option value="GO" <%IF getValue(objRS,"ESTADO_EVENTO") = "GO" THEN RESPONSE.Write("selected") %>>Goiás - GO</option>
                                                    <option value="MA" <%IF getValue(objRS,"ESTADO_EVENTO") = "MA" THEN RESPONSE.Write("selected") %>>Maranhão - MA</option>
                                                    <option value="MT" <%IF getValue(objRS,"ESTADO_EVENTO") = "MT" THEN RESPONSE.Write("selected") %>>Mato Grosso - MT</option>
                                                    <option value="MS" <%IF getValue(objRS,"ESTADO_EVENTO") = "MS" THEN RESPONSE.Write("selected") %>>Mato Grosso do Sul - MS</option>
                                                    <option value="MG" <%IF getValue(objRS,"ESTADO_EVENTO") = "MG" THEN RESPONSE.Write("selected") %>>Minas Gerais - MG</option>
                                                    <option value="PA" <%IF getValue(objRS,"ESTADO_EVENTO") = "PA" THEN RESPONSE.Write("selected") %>>Pará - PA</option>
                                                    <option value="PB" <%IF getValue(objRS,"ESTADO_EVENTO") = "PB" THEN RESPONSE.Write("selected") %>>Paraíba - PB</option>
                                                    <option value="PR" <%IF getValue(objRS,"ESTADO_EVENTO") = "PR" THEN RESPONSE.Write("selected") %>>Paraná - PR</option>
                                                    <option value="PE" <%IF getValue(objRS,"ESTADO_EVENTO") = "PE" THEN RESPONSE.Write("selected") %>>Pernambuco - PE</option>
                                                    <option value="PI" <%IF getValue(objRS,"ESTADO_EVENTO") = "PI" THEN RESPONSE.Write("selected") %>>Piauí - PI</option>
                                                    <option value="RJ" <%IF getValue(objRS,"ESTADO_EVENTO") = "RJ" THEN RESPONSE.Write("selected") %>>Rio de Janeiro - RJ</option>
                                                    <option value="RN" <%IF getValue(objRS,"ESTADO_EVENTO") = "RN" THEN RESPONSE.Write("selected") %>>Rio Grande do Norte - RN</option>
                                                    <option value="RS" <%IF getValue(objRS,"ESTADO_EVENTO") = "RS" THEN RESPONSE.Write("selected") %>>Rio Grande do Sul - RS</option>
                                                    <option value="RO" <%IF getValue(objRS,"ESTADO_EVENTO") = "RO" THEN RESPONSE.Write("selected") %>>Rondônia - RO</option>
                                                    <option value="RR" <%IF getValue(objRS,"ESTADO_EVENTO") = "RR" THEN RESPONSE.Write("selected") %>>Roraima - RR</option>
                                                    <option value="SC" <%IF getValue(objRS,"ESTADO_EVENTO") = "SC" THEN RESPONSE.Write("selected") %>>Santa Catarina - SC</option>
                                                    <option value="SP" <%IF getValue(objRS,"ESTADO_EVENTO") = "SP" THEN RESPONSE.Write("selected") %>>São Paulo - SP</option>
                                                    <option value="SE" <%IF getValue(objRS,"ESTADO_EVENTO") = "SE" THEN RESPONSE.Write("selected") %>>Sergipe - SE</option>
                                                    <option value="TO" <%IF getValue(objRS,"ESTADO_EVENTO") = "TO" THEN RESPONSE.Write("selected") %>>Tocantins - TO</option>
                                                    </select>
                                                </p>
                                             </div>
                                            <div class="input-control select size3" data-role="input-control">
                                                <p>
                                                    <select type="text" name="DBVAR_STR_PAIS" id="DBVAR_STR_PAIS"  class="">
                                                        <option value="">Selecione...</option>
                                                            <%MontaCombo "STR","SELECT ID_PAIS, CONCAT(ID_PAIS,'-',PAIS) AS PAIS FROM TBL_PAISES  ORDER BY PAIS", "ID_PAIS","PAIS",getValue(objRS,"PAIS")&""%>
                                                    </select>
                                                </p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>                             
                                             <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input type="text" name="DBVAR_STR_CEP_EVENTO" id="DBVAR_STR_CEP_EVENTO"  class="" value="<%=getValue(objRS,"cep_evento")%>" maxlength="8">                                                  
                                                </p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                     </div><!--FIM row//-->
                                    <div class="row">
                                        <div class="span2"><p>Montadora:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_MONTADORA" name="DBVAR_STR_MONTADORA" type="text" placeholder="" value="<%=getValue(objRS,"MONTADORA")%>" maxlength="100" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                </div><!--FIM GRID//-->
                            </div><!--fim do frame geral3//-->
                            <div class="frame" id="AGENCIA">
                                <div class="grid" style="border:0px solid #F00">
                                										<div class="row">
                                        <div class="span2"><p>Agencia Turismo:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_AGENCIA_TURISMO" name="DBVAR_STR_AGENCIA_TURISMO" type="text" placeholder="" value="<%=getValue(objRS,"AGENCIA_TURISMO")%>" maxlength="255" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>Agencia Publicidade:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_AGENCIA_PUBLICIDADE" name="DBVAR_STR_AGENCIA_PUBLICIDADE" type="text" placeholder="" value="<%=getValue(objRS,"AGENCIA_PUBLICIDADE")%>" maxlength="100" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>Agencia Bancaria:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_AGENCIA_BANCARIA" name="DBVAR_STR_AGENCIA_BANCARIA" type="text" placeholder="" value="<%=getValue(objRS,"AGENCIA_BANCARIA")%>" maxlength="255" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                </div><!--FIM GRID//-->
                            </div><!--fim do frame agencia//-->
                            <div class="frame" id="SMS">
                                <div class="grid" style="border:0px solid #F00">
									<div class="row">
                                        <div class="span2"><p>SMS User/SMS Pwd:</p></div>
                                        <div class="span8">
                                            <div class="input-control text size3" data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_SMS_USER" name="DBVAR_STR_SMS_USER" type="text" placeholder="" value="<%=getValue(objRS,"SMS_USER")%>" maxlength="45" class="" onKeyPress="">
                                                </p>
                                            </div>
                                            <div class="input-control text size2" data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_SMS_PWD" name="DBVAR_STR_SMS_PWD" type="password" placeholder="" value="<%=getValue(objRS,"SMS_PWD")%>" maxlength="45" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>SMS Texto:</p></div>
                                        <div class="span8">
                                            <div class="input-control  textarea" data-role="input-control">
                                                <p>
                                                	<textarea id="DBVAR_STR_SMS_TEXTO" name="DBVAR_STR_SMS_TEXTO" class="" onKeyPress=""><%=getValue(objRS,"SMS_TEXTO")%></textarea>
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div>                            
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame16//--> 
                            <!--<div class="frame" id="MINI">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Descrição:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea">
                                             	<textarea name="DBVAR_STR_DESCRICAO" id="DBVAR_STR_DESCRICAO"><'%=ReturnCaracterEspecial(objRS("DESCRICAO")&"")%></textarea>
                                             </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('DESCRICAO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
                                    <div class="row">
                                        <div class="span2" style=""><p>Programação:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea">
                                             	<textarea name="DBVAR_STR_PROGRAMACAO" id="DBVAR_STR_PROGRAMACAO"><'%=ReturnCaracterEspecial(objRS("PROGRAMACAO")&"")%></textarea>
                                             </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('PROGRAMACAO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
                                </div> <!--FIM GRID//-->
                            <!--/div><!--fim do RESUMO//--> 
                        </div><!--fim sub frames//-->
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid layout//-->
            </div><!--fim frame dados//-->
            <div class="frame" id="CFGEMAIL" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="tab-control" data-role="tab-control">
                    <ul class="tabs">
                        <li class="active"><a href="#_page_2_1_1">E-MAIL</a></li>
                        <li><a href="#_page_2_1_2">EMAIL EXTRA</a></li>
                        <li><a href="#_page_2_2_1">SMTP</a></li>
                    </ul>
                        <div class="frames">
                            <div class="frame" id="_page_2_1_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Oficial Evento:</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL" name="DBVAR_STR_EMAIL" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL")%>" maxlength="250" >
                                                    </p>
                                                </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div>
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Remetente:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_SENDER" name="DBVAR_STR_EMAIL_SENDER" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL_SENDER")%>" maxlength="180">
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div> 
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Imprensa: </p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_PRESS" name="DBVAR_STR_EMAIL_PRESS" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL_PRESS")%>" maxlength="180" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div>
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Auditoria:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_AUDITORIA" name="DBVAR_STR_EMAIL_AUDITORIA" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL_AUDITORIA")%>" maxlength="180">
                                                    </p>
                                                </div>       
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div>
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Auditoria Intl:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_AUDITORIA_INTL" name="DBVAR_STR_EMAIL_AUDITORIA_INTL" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL_AUDITORIA_INTL")%>" maxlength="180" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div>
                                    
                                </div><!--fim grid layout//-->  
                            </div><!--fim FRAME _page_2_1_1//-->
                            <div class="frame" id="_page_2_1_2">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail CAEX (Reply):</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_REPLY_CAEX" name="DBVAR_STR_EMAIL_REPLY_CAEX" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL_REPLY_CAEX")%>" maxlength="100" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Congressista (Reply):</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_REPLY_CONGRESSISTA" name="DBVAR_STR_EMAIL_REPLY_CONGRESSISTA" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL_REPLY_CONGRESSISTA")%>" maxlength="100">
                                                    </p>
                                                </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div> <!--FIM row//-->
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Palestrante (Reply):</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text" data-role="input-control">
                                                    <p>	
                                                        <input id="DBVAR_STR_EMAIL_REPLY_PALESTRANTE" name="DBVAR_STR_EMAIL_REPLY_PALESTRANTE" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL_REPLY_PALESTRANTE")%>" maxlength="100" >
                                                    </p>
                                                </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Trabalho (Reply):</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_REPLY_PAPER" name="DBVAR_STR_EMAIL_REPLY_PAPER" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL_REPLY_PAPER")%>" maxlength="100">
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Visitante (Reply):</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_REPLY_VISITANTE" name="DBVAR_STR_EMAIL_REPLY_VISITANTE" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL_REPLY_VISITANTE")%>" maxlength="100" >
                                                    </p>                                                 
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div><!--FIM row//-->
                                    
                                </div><!--fim grid EMAIL EXTRA//-->  
                            </div><!--fim FRAME _page_2_1_2//-->
                            <div class="frame" id="_page_2_2_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>SMTP Server:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>                                            
                                                    <input type="text" name="DBVAR_STR_SMTP_SERVER" id="DBVAR_STR_SMTP_SERVER" value="<%=getValue(objRS,"SMTP_SERVER")%>" maxlength="120">
                                                </p>                                            
                                            </div>
                                             <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                        <div class="span2" style=""><p>SMTP Usuário:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_SMTP_USER" name="DBVAR_STR_SMTP_USER" type="text" placeholder="" value="<%=getValue(objRS,"SMTP_USER")%>" maxlength="120">
                                                </p>	
                                            </div>
                                             <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div> <!--FIM row//-->
                                    
                                    <div class="row">
                                        <div class="span2" style=""><p>SMTP Senha:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                                    <p>                                            
                                                        <input id="DBVAR_STR_SMTP_PWD" name="DBVAR_STR_SMTP_PWD" type="password" data-transform="input-control" placeholder="" value="<%=getValue(objRS,"SMTP_PWD")%>" maxlength="45" >
                                                    </p>                                            
                                            </div>
                                           <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                        <div class="span2" style=""><p>SMTP Porta:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_SMTP_PORT" name="DBVAR_STR_SMTP_PORT" type="text" placeholder="" value="<%=getValue(objRS,"SMTP_PORT")%>" maxlength="45" >
                                                </p>
                                            </div>
                                           <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div><!--FIM row//-->
                                    
                                </div><!--FIM GRID//-->
                            </div><!--fim do frame _page_2_2_1//-->
                            
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid layout//-->
            </div><!--fim frame CFGEMAIL//--> 
             
            <div class="frame" id="CFGMOEDA" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
						<h6><span class="tertiary-text-secondary">Categoria Status Credencial (Padrão)</span></h6>
                    <div class="row">
                        <div class="span2" ><p>*Status Credencial/*Status Credencial PSC:</p></div>
                        <div class="span8"> 
                             <div class="input-control select size3 info-state" data-role="input-control">
                             	<p>
                                    <select type="text" name="DBVAR_NUM_STATUS_CREDô" id="DBVAR_NUM_STATUS_CRED" class="">
                                        <option value="">Selecione...</option>
                                            <%'MontaCombo "STR","SELECT COD_STATUS_CRED, STATUS FROM TBL_STATUS_CRED ORDER BY ORDEM","COD_STATUS_CRED","STATUS",getValue(objRS,"STATUS_CRED")&""%>
			                                 <% montaCombo "STR" ,"SELECT COD_STATUS_CRED, CONCAT(CAST(COD_STATUS_CRED AS CHAR), ' - ', CAST(STATUS AS CHAR)) AS STATUS FROM TBL_STATUS_CRED ORDER BY COD_STATUS_CRED", "COD_STATUS_CRED", "STATUS", getValue(objRS,"STATUS_CRED")&""%>

                                    </select>
                                </p>
                             </div>
                             <div class="input-control select size3 info-state" data-role="input-control">
                             	<p>                                    
                                    <select type="text" name="DBVAR_STR_PSC_STATUS_CRED" id="DBVAR_STR_PSC_STATUS_CREDô" class="">
                                        <option value="">Selecione...</option>
                                            <%'MontaCombo "STR","SELECT COD_STATUS_CRED, STATUS FROM TBL_STATUS_CRED ORDER BY STATUS","COD_STATUS_CRED","STATUS",getValue(objRS,"STATUS_CRED")&""%>
                                    		<% montaCombo "STR" ,"SELECT COD_STATUS_CRED, CONCAT(CAST(COD_STATUS_CRED AS CHAR), ' - ', CAST(STATUS AS CHAR)) AS STATUS FROM TBL_STATUS_CRED ORDER BY COD_STATUS_CRED", "COD_STATUS_CRED", "STATUS", getValue(objRS,"PSC_STATUS_CRED")&""%>
                                    </select>
                                </p>                                
                             </div>
                             <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div> 
                    <div class="row">
                        <div class="span2"><p>Press Status Cred:</p></div>
                        <div class="span8">
                            <div class="input-control text " data-role="input-control">
                                <p>
                                    <input id="DBVAR_STR_PRESS_STATUS_CRED" name="DBVAR_STR_PRESS_STATUS_CRED" type="text" placeholder="" value="<%=getValue(objRS,"PRESS_STATUS_CRED")%>" maxlength="9" class=""  onKeyPress="Javascript:return validateNumKey(event);return false;">
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>
                        </div>
                    </div> 
                        	<h6><span class="tertiary-text-secondary">Categoria Preço (Padrão)</span></h6>                    
                     <div class="row">
                        <div class="span2" style=""><p>Categoria Preço / Categoria Preço Visitant.:</p></div>
                        <div class="span8"> 
                             <div class="input-control select size3" data-role="input-control">
                             	<p>
                                    <select type="text" name="DBVAR_STR_STATUS_PRECO" id="DBVAR_STR_STATUS_PRECO" class="">
                                        <option value="">Selecione...</option>
                                            <%MontaCombo "STR","SELECT COD_STATUS_PRECO, STATUS FROM TBL_STATUS_PRECO WHERE COD_EVENTO = " & strCOD_EVENTO &"  ORDER BY STATUS","COD_STATUS_PRECO","STATUS",getValue(objRS,"STATUS_PRECO")%>
                                    </select>
                                </p>
                             </div>                                
                             
                             <div class="input-control select text size3" data-role="input-control">
                             	<p>
                                    <!-- input id="DBVAR_NUM_STATUS_PRECO_VISITANTE" name="DBVAR_NUM_STATUS_PRECO_VISITANTE" type="text" placeholder="" value="<%'=getValue(objRS,"STATUS_PRECO_VISITANTE")%>" maxlength="11" class=""  onKeyPress="Javascript:return validateNumKey(event);return false;" //-->
                                    <select type="text" name="DBVAR_NUM_STATUS_PRECO_VISITANTE" id="DBVAR_NUM_STATUS_PRECO_VISITANTE" class="">
                                        <option value="">Selecione...</option>
                                            <%MontaCombo "STR","SELECT COD_STATUS_PRECO, STATUS FROM TBL_STATUS_PRECO WHERE COD_EVENTO = " & strCOD_EVENTO &"  ORDER BY STATUS","COD_STATUS_PRECO","STATUS",getValue(objRS,"STATUS_PRECO_VISITANTE")%>
                                    </select>
                                </p>
                             </div>
                             <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div>
                     <div class="row">
                        <div class="span2" style=""><p>Moeda Evento:</p></div>
                        <div class="span8"> 
                             <div class="input-control select " data-role="input-control">
                             	<p>
                                    <select type="text" name="DBVAR_NUM_COD_MOEDA_EVENTO" id="DBVAR_NUM_COD_MOEDA_EVENTO">
                                        <option value="">Selecione...</option>
                                            <%MontaCombo "STR","SELECT COD_MOEDA, MOEDA FROM TBL_MOEDA ORDER BY MOEDA","COD_MOEDA","MOEDA",getValue(objRS,"COD_MOEDA_EVENTO")&""%>
                                    </select>
                             	</p>                             
                             </div>
                             <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div> 
                     <div class="row">
                        <div class="span2" style=""><p>Moeda Cobrança:</p></div>
                         <div class="span8"> 
                             <div class="input-control select " data-role="input-control">
                             	<p>
                                    <select type="text" name="DBVAR_NUM_COD_MOEDA_COBRANCA" id="DBVAR_NUM_COD_MOEDA_COBRANCA">
                                    <option value="">Selecione...</option>
                                        <%MontaCombo "STR","SELECT COD_MOEDA, MOEDA FROM TBL_MOEDA ORDER BY MOEDA","COD_MOEDA","MOEDA",getValue(objRS,"COD_MOEDA_COBRANCA")&""%>
                                    </select>
                             	</p>
                             </div>                                
                             <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div> 
                     <div class="row">
                        <div class="span2" style=""><p>Moeda Referência:</p></div>
                        <div class="span8"> 
                            <div class="input-control select " data-role="input-control">
                            	<p>    
                                <select type="text" name="DBVAR_NUM_COD_MOEDA_REFERENCIA" id="DBVAR_NUM_COD_MOEDA_REFERENCIA">
                                    <option value="">Selecione...</option>
                                        <%MontaCombo "STR","SELECT COD_MOEDA, MOEDA FROM TBL_MOEDA ORDER BY MOEDA","COD_MOEDA","MOEDA",getValue(objRS,"COD_MOEDA_REFERENCIA")&""%>
                                </select>
                                </p>
                            </div>
                            <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div> 
                </div><!--fim grid//-->
            </div><!--fim frame CFGMOEDA//-->
            <div class="frame" id="STATUS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                         <div class="tab-control" data-role="tab-control">
                            <ul class="tabs">
                                <li class="active"><a href="#_page_2_1_3">Ativar Evento</a></li>
                                <li><a href="#_page_2_2_4">Imp. Controle</a></li>
                            </ul>
                            <div class="frames">
                                <div class="frame" id="_page_2_1_3">
                                    <div class="grid" style="border:0px solid #F00">
                                        <div class="row">
                                            <div class="span2" style=""><p>Evento Gratuito:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_FREE" id="DBVAR_BOOL_FREE"  type="radio" value="1" <% If getValue(objRS,"FREE")= "1" Then Response.Write("checked") End If %> >
                                                        Sim 
                                                    <input name="DBVAR_BOOL_FREE" id="DBVAR_BOOL_FREE2"  type="radio" value="0" <% If not getValue(objRS,"FREE") =  "1" Then Response.Write("checked") End If %> >
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="span2" style=""><p>Evento Ativo:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_DATE_SYS_INATIVO" id="DBVAR_DATE_SYS_INATIVO"  type="radio" value="" <% If getValue(objRS,"SYS_INATIVO") = "" Then Response.Write("checked") End If %>>
                                                        Sim 
                                                    <input name="DBVAR_DATE_SYS_INATIVO" id="DBVAR_DATE_SYS_INATIVO2" type="radio" value="<%=Now()%>" <% If getValue(objRS,"SYS_INATIVO") <> "" Then Response.Write("checked") End If %> >
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="span2" style=""><p>Cupom Fiscal:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_CUPOM_FISCAL" id="DBVAR_BOOL_CUPOM_FISCAL" type="radio" value="1" <% If getValue(objRS,"CUPOM_FISCAL")= "1" Then Response.Write("checked") End If %>>
                                                        Sim 
                                                    <input name="DBVAR_BOOL_CUPOM_FISCAL" id="DBVAR_BOOL_CUPOM_FISCAL2" type="radio" value="0" <% If getValue(objRS,"CUPOM_FISCAL")= "0" Then Response.Write("checked") End If %>>
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="span2" style=""><p>Venda Rápida:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_VENDA_RAPIDA" id="DBVAR_BOOL_VENDA_RAPIDA" type="radio" value="1" <% If getValue(objRS,"VENDA_RAPIDA")= "1" Then Response.Write("checked") End If %>>
                                                        Sim 
                                                    <input name="DBVAR_BOOL_VENDA_RAPIDA" id="DBVAR_BOOL_VENDA_RAPIDA2" type="radio" value="0"  <% If not getValue(objRS,"VENDA_RAPIDA") = "1" Then Response.Write("checked") End If %>>
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </DIV>
                                    </div><!--FIM DO SUB GRID//-->
                                </div><!--fim SUB FRAME//-->  
                                <div class="frame" id="_page_2_2_4">
                                    <div class="grid" style="border:0px solid #F00">
                                        <div class="row">
                                            <div class="span2" style=""><p>Retirada Material:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_RETIRADA_MATERIAL" id="DBVAR_BOOL_RETIRADA_MATERIAL"  type="radio" value="1" <% If getValue(objRS,"RETIRADA_MATERIAL")= "1" Then Response.Write("checked") End If %>>
                                                        Sim 
                                                    <input name="DBVAR_BOOL_RETIRADA_MATERIAL" id="DBVAR_BOOL_RETIRADA_MATERIAL2" type="radio" value="0" <% If not getValue(objRS,"RETIRADA_MATERIAL") = "1" Then Response.Write("checked") End If %>>
                                                        Não 
                                                </p>
                                            <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 
                                        <div class="row">
                                            <div class="span2" style=""><p>Controle Credencial:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_CRED_PRINT_CONTROLE" id="DBVAR_BOOL_CRED_PRINT_CONTROLE"  type="radio" value="1" <% If getValue(objRS,"CRED_PRINT_CONTROLE")= "1" Then Response.Write("checked") End If %>>
                                                        Sim 
                                                    <input name="DBVAR_BOOL_CRED_PRINT_CONTROLE" id="DBVAR_BOOL_CRED_PRINT_CONTROLE2" type="radio" value="0"  <% If not getValue(objRS,"CRED_PRINT_CONTROLE") = "1" Then Response.Write("checked") End If %>>
                                                        Não 
                                                </p>
                                            <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 
                                        <div class="row">
                                            <div class="span2" style=""><p>Imprimir Credencial Visitante:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_IMPRIMIR_VISITANTE" id="DBVAR_BOOL_IMPRIMIR_VISITANTE"  type="radio" value="1" <% If cstr(getValue(objRS,"IMPRIMIR_VISITANTE")&"")="1" Then Response.Write("checked") End If %>>
                                                        Sim 
                                                    <input name="DBVAR_BOOL_IMPRIMIR_VISITANTE" id="DBVAR_BOOL_IMPRIMIR_VISITANTE2"  type="radio" value="0" <% If cstr(getValue(objRS,"IMPRIMIR_VISITANTE")&"") <> "1" Then Response.Write("checked") End If %>>
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 
									  <div class="row">
                                            <div class="span2" style=""><p>Imprimir Credencial Congressista:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_IMPRIMIR_CONGRESSISTA" id="DBVAR_BOOL_IMPRIMIR_CONGRESSISTA"  type="radio" value="1" <% If cstr(getValue(objRS,"IMPRIMIR_CONGRESSISTA")&"")="1" Then Response.Write("checked") End If %>>
                                                        Sim 
                                                    <input name="DBVAR_BOOL_IMPRIMIR_CONGRESSISTA" id="DBVAR_BOOL_IMPRIMIR_CONGRESSISTA2"  type="radio" value="0" <% If cstr(getValue(objRS,"IMPRIMIR_CONGRESSISTA")&"")<>"1" Then Response.Write("checked") End If %>>
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 
                                        <div class="row">
                                            <div class="span2" style=""><p>ByPass Cortesia:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_BYPASS_CORTESIA" id="DBVAR_BOOL_BYPASS_CORTESIA"  type="radio" value="1" <% If cstr(getValue(objRS,"BYPASS_CORTESIA")&"")="1" Then Response.Write("checked") End If %>>
                                                        Sim 
                                                    <input name="DBVAR_BOOL_BYPASS_CORTESIA" id="DBVAR_BOOL_BYPASS_CORTESIA2"  type="radio" value="0" <% If cstr(getValue(objRS,"BYPASS_CORTESIA")&"")<>"1" Then Response.Write("checked") End If %>>
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 

                                        <div class="row">
                                            <div class="span2" style=""><p>Padrão Código Barras/Altura Código de Barras:</p></div>
                                            <div class="span8"> 
                                                <div class="input-control select size2" data-role="input-control">
                                                        <p>
                                                            <select name="DBVAR_STR_BARCODE_MODE" id="DBVAR_STR_BARCODE_MODE" class="">
                                                            <option value="code39" <% If getValue(objRS,"BARCODE_MODE")&""="code39" or getValue(objRS,"BARCODE_MODE")&"" = "" Then Response.Write("selected") End If %>>Code39</option>
                                                            <option value="code128b" <% If getValue(objRS,"BARCODE_MODE")&""="code128b" Then Response.Write("selected") End If %>>Code128b</option>
                                                            <option value="UPC-A" <% If getValue(objRS,"BARCODE_MODE")&""="UPC-A" Then Response.Write("selected") End If %>>UPC-A</option>
                                                            <option value="EAN-13" <% If getValue(objRS,"BARCODE_MODE")&""="EAN-13" Then Response.Write("selected") End If %>>EAN-13</option>
                                                            <option value="Postal" <% If getValue(objRS,"BARCODE_MODE")&""="Postal" Then Response.Write("selected") End If %>>Postal</option>
                                                            <option value="Planet" <% If getValue(objRS,"BARCODE_MODE")&""="Planet" Then Response.Write("selected") End If %>>Planet</option>
                                                            <option value="qrcode" <% If getValue(objRS,"BARCODE_MODE")&""="qrcode" Then Response.Write("selected") End If %>>QRCode</option>
                                                            </select>
                                                        </p>
                                                    </div>
                                                    <div class="input-control text size2" data-role="input-control">                                                    
                                                        <p>
                                                            <input type="text" name="DBVAR_NUM_BARCODE_HEIGHT" id="DBVAR_NUM_BARCODE_HEIGHT" value="<%If getValue(objRS,"BARCODE_HEIGHT") = "" Then Response.Write("30") Else Response.Write(getValue(objRS,"BARCODE_HEIGHT")) End If%>" class="">
                                                        </p>
                                                    </div>
                                                    <span class="tertiary-text-secondary">(pixels)</span>                             
                                        	</div>
                                        </div>
                                        <div class="row">
                                            <div class="span2" style=""><p>Inscrição Municipal:</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text" data-role="input-control">
                                                    <p>
                                                    	<input type="text" name="DBVAR_STR_INSCR_MUNICIPAL" id="DBVAR_STR_INSCR_MUNICIPAL" value="<%=getValue(objRS,"INSCR_MUNICIPAL")%>" >
                                                	</p>
                                                </div>
                                               <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div>
                                    </div> <!--FIM GRID//-->
                                </div><!--fim do frame14//-->
                            </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid STATUS//-->
            </div><!--fim frame STATUS//-->
            <div class="frame" id="HTMLTXT" style="width:100%;"><!--esta guia contem tab dentro de tab//-->
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="tab-control" data-role="tab-control">
                                <ul class="tabs">
                                    <li class="active"><a href="#RECIBO">DADOS RECIBO</a></li>
                                    <!--li><a href="#ARIEL">ARIEL</a></li//-->
                                    <li><a href="#ARM">ARM</a></li>
                                    <li><a href="#ACE">ACE</a></li>
                                    <li><a href="#CONVITE">CONVITE</a></li>
                                    <li><a href="#APE">APE</a></li>
                                    <li><a href="#ATESTADOS">ATESTADO</a></li>
                                    <li><a href="#TEXTO">CERT. TXT</a></li>
                                    <li><a href="#UPLOAD">UPLOAD</a></li>
                                    <li><a href="#PAPER">PAPER</a></li>
                                </ul>
                        <div class="frames">
                            <div class="frame" id="RECIBO">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                                <div class="span2" style=""><p>Recibo A4:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_RECIBO_TEXTO" id="DBVAR_STR_RECIBO_TEXTO"><%=ReturnCaracterEspecial(getValue(objRS,"RECIBO_TEXTO")&"")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('RECIBO_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Cabeçalho:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_CABECALHO" id="DBVAR_STR_CABECALHO"><%=ReturnCaracterEspecial(objRS("CABECALHO")&"")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CABECALHO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Rodapé:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_RODAPE" id="DBVAR_STR_RODAPE"><%=ReturnCaracterEspecial(objRS("RODAPE")&"") %></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('RODAPE');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                      <div class="row">
                                                <div class="span2" style=""><p>Instrucao Insc. Existente:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_INSTRUCAO_INSC_EXISTENTE" id="DBVAR_STR_INSTRUCAO_INSC_EXISTENTE"><%=getValue(objRS,"INSTRUCAO_INSC_EXISTENTE")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('INSTRUCAO_INSC_EXISTENTE');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Cabeçalho Recibo:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_CABECALHO_RECIBO" id="DBVAR_STR_CABECALHO_RECIBO"><%=ReturnCaracterEspecial(objRS("CABECALHO_RECIBO")&"")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CABECALHO_RECIBO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                </div><!--fim grid layout//-->  
                            </div><!--fim frame recibo//-->
                            <!--div class="frame" id="ARIEL">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                                <div class="span2" style=""><p>Ariel Texto:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_ARIEL_TEXTO" id="DBVAR_STR_ARIEL_TEXTO"><%=ReturnCaracterEspecial(getValue(objRS,"ARIEL_TEXTO")&"")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARIEL_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    <div class="row">
                                                <div class="span2" style=""><p>Ariel Texto Intl:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_ARIEL_TEXTO_INTL" id="DBVAR_STR_ARIEL_TEXTO_INTL"><%=ReturnCaracterEspecial(getValue(objRS,"ARIEL_TEXTO_INTL")&"")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARIEL_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    <div class="row">
                                                <div class="span2" style=""><p>Ariel Texto NPG:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_ARIEL_TEXTO_NPG" id="DBVAR_STR_ARIEL_TEXTO_NPG"><%=ReturnCaracterEspecial(getValue(objRS,"ARIEL_TEXTO_NPG")&"")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARIEL_TEXTO_NPG');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    
                                </div><!--fim grid layout//-->  
                            <!--/div//--><!--fim frame ariel//-->
                            <div class="frame" id="ARM">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ARM:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ARM_TEXTO" id="DBVAR_STR_ARM_TEXTO"><%=ReturnCaracterEspecial(objRS("ARM_TEXTO")&"")%></textarea>
                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ARM Intl:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ARM_TEXTO_INTL" id="DBVAR_STR_ARM_TEXTO_INTL"> <%=ReturnCaracterEspecial(objRS("ARM_TEXTO_INTL")&"") %></textarea>
                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ARM Assunto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ARM_ASSUNTO" id="DBVAR_STR_ARM_ASSUNTO" value="<%=ReturnCaracterEspecial(objRS("ARM_ASSUNTO")&"") %>" maxlength="250">
                                                <!--<textarea name="DBVAR_STR_ARM_ASSUNTO" id="DBVAR_STR_ARM_ASSUNTO" ><'%=ReturnCaracterEspecial(objRS("ARM_ASSUNTO")&"") %></textarea>-->
                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_ASSUNTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ARM Assunto Intl:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ARM_ASSUNTO_INTL" id="DBVAR_STR_ARM_ASSUNTO_INTL" value="<%=ReturnCaracterEspecial(objRS("ARM_ASSUNTO_INTL")&"") %>" maxlength="250">
<!--                                                <textarea name="DBVAR_STR_ARM_ASSUNTO_INTL" id="DBVAR_STR_ARM_ASSUNTO_INTL"><'%=ReturnCaracterEspecial(objRS("ARM_ASSUNTO_INTL")&"") %></textarea>
-->                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_ASSUNTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                 </div><!--fim grid//--> 
                            </div><!--fim frame arm//-->
                            <div class="frame" id="ACE">
                                <div class="grid" style="border:0px solid #F00" >
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ACE:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_TEXTO" id="DBVAR_STR_ACE_TEXTO"><%=ReturnCaracterEspecial(objRS("ACE_TEXTO")&"") %></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                             <span class="tertiary-text-secondary"><a href="javascript:edithtml('ACE_TEXTO');" class=""><i class="icon-pencil"></i>&nbsp;editar HTML&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ACE APROVADO:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_APROVADO_TEXTO" id="DBVAR_STR_ACE_APROVADO_TEXTO"><%=ReturnCaracterEspecial(objRS("ACE_APROVADO_TEXTO")&"") %></textarea>
                                             </p>
                                             <!--span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                             <span class="tertiary-text-secondary"><a href="javascript:edithtml('ACE_TEXTO');" class=""><i class="icon-pencil"></i>&nbsp;editar HTML&nbsp;</a></span//-->                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ACE BLOQUEADO:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_BLOQUEADO_TEXTO" id="DBVAR_STR_ACE_BLOQUEADO_TEXTO"><%=ReturnCaracterEspecial(objRS("ACE_BLOQUEADO_TEXTO")&"") %></textarea>
                                             </p>
                                             <!--span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                             <span class="tertiary-text-secondary"><a href="javascript:edithtml('ACE_TEXTO');" class=""><i class="icon-pencil"></i>&nbsp;editar HTML&nbsp;</a></span//-->                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ACE Intl:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_TEXTO_INTL" id="DBVAR_STR_ACE_TEXTO_INTL"><%=ReturnCaracterEspecial(objRS("ACE_TEXTO_INTL")&"") %></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                                             <span class="tertiary-text-secondary"><a href="javascript:edithtml('ACE_TEXTO_INTL');" class=""><i class="icon-pencil"></i>&nbsp;editar HTML&nbsp;</a></span>                                                          
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Assunto:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ACE_ASSUNTO" id="DBVAR_STR_ACE_ASSUNTO" value="<%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO")&"") %>" maxlength="250">
<!--                                             <textarea name="DBVAR_STR_ACE_ASSUNTO" id="DBVAR_STR_ACE_ASSUNTO"><'%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO")&"") %></textarea>
-->                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_ASSUNTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Assunto INTL:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ACE_ASSUNTO_INTL" id="DBVAR_STR_ACE_ASSUNTO_INTL" value="<%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO_INTL")&"") %>" maxlength="250">
<!--                                             <textarea name="DBVAR_STR_ACE_ASSUNTO_INTL" id="DBVAR_STR_ACE_ASSUNTO_INTL"><'%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO")&"") %></textarea>
-->                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_ASSUNTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Texto US:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_TEXTO_US" id="DBVAR_STR_ACE_TEXTO_US"><%=ReturnCaracterEspecial(objRS("ACE_TEXTO_US")&"") %></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO_US');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Assunto US:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ACE_ASSUNTO_US" id="DBVAR_STR_ACE_ASSUNTO_US" value="<%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO_US")&"") %>" maxlength="250">
<!--                                             <textarea name="DBVAR_STR_ACE_ASSUNTO_INTL" id="DBVAR_STR_ACE_ASSUNTO_INTL"><'%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO")&"") %></textarea>
-->                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_ASSUNTO_US');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Texto SP:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_TEXTO_SP" id="DBVAR_STR_ACE_TEXTO_SP"><%=ReturnCaracterEspecial(objRS("ACE_TEXTO_SP")&"") %></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO_SP');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Assunto SP:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ACE_ASSUNTO_SP" id="DBVAR_STR_ACE_ASSUNTO_SP" value="<%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO_SP")&"") %>" maxlength="250">
<!--                                             <textarea name="DBVAR_STR_ACE_ASSUNTO_INTL" id="DBVAR_STR_ACE_ASSUNTO_INTL"><'%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO")&"") %></textarea>
-->                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_ASSUNTO_SP');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Imprensa:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACEPRESS_TEXTO" id="DBVAR_STR_ACEPRESS_TEXTO"><%=ReturnCaracterEspecial(objRS("ACEPRESS_TEXTO")&"")%></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACEPRESS_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Imprensa US:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACEPRESS_TEXTO_US" id="DBVAR_STR_ACEPRESS_TEXTO_US"><%=ReturnCaracterEspecial(objRS("ACEPRESS_TEXTO_US")&"")%></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACEPRESS_TEXTO_US');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Imprensa ES:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACEPRESS_TEXTO_ES" id="DBVAR_STR_ACEPRESS_TEXTO_ES"><%=ReturnCaracterEspecial(objRS("ACEPRESS_TEXTO_ES")&"")%></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACEPRESS_TEXTO_ES');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
									<div class="row">
                                        <div class="span2" style=""><p>ACE Imprensa Intl:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACEPRESS_TEXTO_INTL" id="DBVAR_STR_ACEPRESS_TEXTO_INTL"><%=ReturnCaracterEspecial(objRS("ACEPRESS_TEXTO_INTL")&"")%></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACEPRESS_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                </div><!--fim grid //--> 
                            </div><!--FIM DO FRAME ACE//-->
                            <div class="frame" id="CONVITE">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto Convite: </p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_CONVITE_TEXTO" id="DBVAR_STR_CONVITE_TEXTO"><%=ReturnCaracterEspecial(objRS("CONVITE_TEXTO")&"")%></textarea>
                                                </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CONVITE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto Convite VIP:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_CONVITE_VIP_TEXTO" id="DBVAR_STR_CONVITE_VIP_TEXTO"><%=ReturnCaracterEspecial(objRS("CONVITE_VIP_TEXTO")&"")%></textarea>
                                                </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CONVITE_VIP_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto Convite Eletrônico:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_CONVITE_ELETRONICO_TEXTO" id="DBVAR_STR_CONVITE_ELETRONICO_TEXTO"><%=ReturnCaracterEspecial(objRS("CONVITE_ELETRONICO_TEXTO")&"")%></textarea>
                                                </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CONVITE_ELETRONICO_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto Convite Eletrônico Intl:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_CONVITE_ELETRONICO_TEXTO_INTL" id="DBVAR_STR_CONVITE_ELETRONICO_TEXTO_INTL"><%=ReturnCaracterEspecial(objRS("CONVITE_ELETRONICO_TEXTO_INTL")&"")%></textarea>
                                                </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CONVITE_ELETRONICO_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                </div><!--fim grid//--> 
                            </div><!--fim FRAME CONVITE//-->
                            <div class="frame" id="APE">
                               <div class="grid" style="border:0px solid #F00">
                                     <div class="row">
                                                <div class="span2" style=""><p>Texto APE:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                        <textarea name="DBVAR_STR_APE_TEXTO" id="DBVAR_STR_APE_TEXTO"  ><%=ReturnCaracterEspecial(objRS("APE_TEXTO")&"")%></textarea>
                                                            </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('APE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Texto APE Intl:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                        <textarea name="DBVAR_STR_APE_TEXTO_INTL" id="DBVAR_STR_APE_TEXTO_INTL"  ><%=ReturnCaracterEspecial(objRS("APE_TEXTO_INTL")&"")%></textarea>
                                                            </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('APE_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Assunto APE :</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control text " data-role="input-control">
                                                     <input id="DBVAR_STR_APE_ASSUNTO" name="DBVAR_STR_APE_ASSUNTO" type="text" placeholder="" value="<%=getValue(objRS,"APE_ASSUNTO")%>" maxlength="150" class="" onKeyPress="">
                                                            </p>
                                                     <span class="tertiary-text-secondary"></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Assunto APE Intl:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control text " data-role="input-control">
                                                     <input id="DBVAR_STR_APE_ASSUNTO_INTL" name="DBVAR_STR_APE_ASSUNTO_INTL" type="text" placeholder="" value="<%=getValue(objRS,"APE_ASSUNTO_INTL")%>" maxlength="150" class="" onKeyPress="">
                                                            </p>
                                                     <span class="tertiary-text-secondary"></span>                             
                                                </div>
                                     </div>
                                 </div><!--fim grid layout//--> 
                            </div><!--fim FRAME ape//-->
                            
                            <div class="frame" id="ATESTADOS">
                               <div class="grid" style="border:0px solid #F00">
                                     <div class="row">
                                                <div class="span2" style=""><p>Texto Atestado: </p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                        <textarea name="DBVAR_STR_ATESTADO_TEXTO" id="DBVAR_STR_ATESTADO_TEXTO"  ><%=ReturnCaracterEspecial(objRS("ATESTADO_TEXTO")&"")%></textarea>
                                                            </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ATESTADO_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Atestado PDF Orientação:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control select " data-role="input-control">
                                                <select name="DBVAR_STR_ATESTADO_PDF_ORIENTACAO" id="DBVAR_STR_ATESTADO_PDF_ORIENTACAO" class="arial11">
                                                    <option value="RETRATO"	 <% IF getValue(objRS,"ATESTADO_PDF_ORIENTACAO")= "RETRATO"  THEN response.write("selected")%>>RETRATO</option>
                                                    <option value="PAISAGEM" <% IF getValue(objRS,"ATESTADO_PDF_ORIENTACAO")= "PAISAGEM" THEN response.write("selected")%>>PAISAGEM</option>
                                                </select>
                                            </p>
                                            <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Atestado PDF: </p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_ATESTADO_PDF" id="DBVAR_STR_ATESTADO_PDF"><%=ReturnCaracterEspecial(objRS("ATESTADO_PDF")&"")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ATESTADO_PDF');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                 </div><!--fim grid layout//--> 
                            </div><!--fim FRAME atestado//-->
                            <div class="frame" id="TEXTO">
                               <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                                <div class="span2" style=""><p>Certificado Texto1:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_CERTIFICADO_TEXTO1" id="DBVAR_STR_CERTIFICADO_TEXTO1"><%=ReturnCaracterEspecial(objRS("CERTIFICADO_TEXTO1")&"")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CERTIFICADO_TEXTO1');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Certificado Texto2:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_CERTIFICADO_TEXTO2" id="DBVAR_STR_CERTIFICADO_TEXTO2"><%=ReturnCaracterEspecial(objRS("CERTIFICADO_TEXTO2")&"")%></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CERTIFICADO_TEXTO2');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    
                                 </div><!--fim grid layout//--> 
                            </div><!--fim FRAME texto//-->
                            <div class="frame" id="UPLOAD">
                                <div class="grid" style="border:0px solid #F00">
                              <!--<div class="row">
                                        <div class="span2"><p>IMG2:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_IMG2" name="DBVAR_STR_IMG2" type="text" placeholder="" value="<'%=getValue(objRS,"IMG2")%>" maxlength="45" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> //-->

                                    <div class="row">
                                        <div class="span2"><p>Upload Imagens:</p></div>
                                        <div class="span8">
                                            <div class="input-control file">
                                                <input type="text" name="var_arquivo" id="var_arquivo" />
                                                <button class="btn-file" onClick="javascript:UploadImage('formupdate','var_arquivo','\\imgdin\\');"></button>
                                                <span class="tertiary-text-secondary"></span>
                                            </div>                     
                                            <span class="tertiary-text-secondary">Atalho para upload na pasta \IMGDIN </span>                             
                                        </div>
                                    </div>
                                </div><!--fim grid layout//--> 
                            </div><!--fim FRAME upload//-->
                            <div class="frame" id="PAPER">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Cabeçalho Paper:</p></div>
                                        <div class="span8"> 
                                        <p class="input-control textarea " data-role="input-control">
                                        	<textarea name="DBVAR_STR_CABECALHO_PAPER" id="DBVAR_STR_CABECALHO_PAPER"><%=ReturnCaracterEspecial(objRS("CABECALHO_PAPER")&"")%></textarea>
                                        </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CABECALHO_PAPER');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Rodapé Paper:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                            	<textarea name="DBVAR_STR_RODAPE_PAPER" id="DBVAR_STR_RODAPE_PAPER"><%=ReturnCaracterEspecial(objRS("RODAPE_PAPER")&"")%></textarea>
                                            </p>
                                            <span class="tertiary-text-secondary"><a href="javascript:viewdoc('RODAPE_PAPER');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>    
                                        </div>                       
                                    </div>
                                </div> <!--fim grid layout//-->
                            </div><!--fim FRAME paper//-->               
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid //-->
            </div><!--fim frame HTMLTXT//-->
            
            <div class="frame" id="LOJA" style="width:100%;"><!--esta guia contem tab dentro de tab//-->
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="tab-control" data-role="tab-control">
                        <ul class="tabs">
                            <li class="active"><a href="#_page_12_1_1">GERAL</a></li>
                            <li><a href="#_page_13_2_1">EXIB.DADOS</a></li>
                            <li><a href="#_page_14_2_1">ATIV.DADOS</a></li>
                            <li><a href="#_page_15_2_1">REGRAS</a></li>
                            
                        </ul>
            
                        <div class="frames">
                            <div class="frame" id="_page_12_1_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Usuário Loja:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control select " data-role="input-control">
                                                <select name="DBVAR_STR_IDUSER_LOJA" id="DBVAR_STR_IDUSER_LOJA" class="">
                                                    <option value="">Selecione...</option>
                                                        <% MontaCombo "STR","SELECT ID_USER FROM TBL_USUARIO ORDER BY ID_USER","ID_USER","ID_USER",getValue(objRS,"IDUSER_LOJA")&"" %>
                                                </select>	
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2"><p>Background Loja(IMG1):</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_IMG1" name="DBVAR_STR_IMG1" type="text" placeholder="" value="<%=getValue(objRS,"IMG1")%>" maxlength="255" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">Endereço da imagem (ex.: [http://pvista.proevento.com.br/qe/imgdin/bgshop_135.jpg] ou [../imgdin/bgshop_135.jpg]</span>
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2" style=""><p>Cabeçalho Loja:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                            	<textarea name="DBVAR_STR_CABECALHO_LOJA" id="DBVAR_STR_CABECALHO_LOJA"><%=ReturnCaracterEspecial(objRS("CABECALHO_LOJA")&"")%></textarea>
                                            </p>
                                            <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CABECALHO_LOJA');" class=""><i class="icon-search"></i> visualizar</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Rodapé Loja:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                            	<textarea name="DBVAR_STR_RODAPE_LOJA" id="DBVAR_STR_RODAPE_LOJA"><%=ReturnCaracterEspecial(objRS("RODAPE_LOJA")&"")%></textarea>
                                            </p>
                                            <span class="tertiary-text-secondary"><a href="javascript:viewdoc('RODAPE_LOJA');" class=""><i class="icon-search"></i> visualizar</a></span>                             
                                        </div>
                                    </div>  
                                    <div class="row">
                                    <div class="span2" style=""><p>Categoria Aberta:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_STATUS_PRECO" id="DBVAR_BOOL_LOJA_STATUS_PRECO" type="radio" value="1" <% If getValue(objRS,"LOJA_STATUS_PRECO")="1" Then Response.Write("checked") End If %>>
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_STATUS_PRECO" id="DBVAR_BOOL_LOJA_STATUS_PRECO2"  type="radio" value="0" <% If not getValue(objRS,"LOJA_STATUS_PRECO")="1" Then Response.Write("checked") End If %> >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Pixel Facebook ID:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                            	<input type="text" placeholder="" value="<%=getValue(objRS,"LOJA_FACEBOOK_PIXELID")%>" maxlength="255" class="" onKeyPress="" name="DBVAR_STR_LOJA_FACEBOOK_PIXELID" id="DBVAR_STR_LOJA_FACEBOOK_PIXELID">
                                            </p>
                                            <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div> 

                                </div><!--fim grid layout//-->  
                            </div><!--fim do frame12//-->

                      <tr>
                            <div class="frame" id="_page_13_2_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir dados pessoais:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_SHOW_DADOS" id="DBVAR_BOOL_LOJA_SHOW_DADOS" type="radio" value="1" <% If objRS("LOJA_SHOW_DADOS")= "1" Then Response.Write("checked") End If %>>
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_SHOW_DADOS" id="DBVAR_BOOL_LOJA_SHOW_DADOS2" type="radio" value="0" <% If not objRS("LOJA_SHOW_DADOS")="1" Then Response.Write("checked") End If %> >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir entidade na loja:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_SHOW_ENTIDADE" id="DBVAR_BOOL_LOJA_SHOW_ENTIDADE"  type="radio" value="1" <% If objRS("LOJA_SHOW_ENTIDADE")= "1" Then Response.Write("checked") End If %>>
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_SHOW_ENTIDADE" id="DBVAR_BOOL_LOJA_SHOW_ENTIDADE2" type="radio" value="0" <% If not objRS("LOJA_SHOW_ENTIDADE")="1" Then Response.Write("checked") End If %> >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir Entidade Obrigatório:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_ENTIDADE_OBRIGATORIO" id="DBVAR_BOOL_ENTIDADE_OBRIGATORIO"  type="radio" value="1" <% If objRS("ENTIDADE_OBRIGATORIO")= "1" Then Response.Write("checked") End If %>>
                                                    Sim 
                                                <input name="DBVAR_BOOL_ENTIDADE_OBRIGATORIO" id="DBVAR_BOOL_ENTIDADE_OBRIGATORIO2"  type="radio" value="0" <% If not objRS("ENTIDADE_OBRIGATORIO")="1" Then Response.Write("checked") End If %>>
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir Financeiro na Loja:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_SHOW_FINANCEIRO" id="DBVAR_BOOL_LOJA_SHOW_FINANCEIRO" type="radio" value="1" <% If objRS("LOJA_SHOW_FINANCEIRO")= "1" Then Response.Write("checked") End If %>>
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_SHOW_FINANCEIRO" id="DBVAR_BOOL_LOJA_SHOW_FINANCEIRO2" type="radio" value="0" <% If NOT objRS("LOJA_SHOW_FINANCEIRO")= "1" Then Response.Write("checked") End If %>>
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir Faturamento na Loja:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_SHOW_FATURAMENTO" id="DBVAR_BOOL_LOJA_SHOW_FATURAMENTO"  type="radio" value="1" <% If objRS("LOJA_SHOW_FATURAMENTO")= "1" Then Response.Write("checked") End If %>>
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_SHOW_FATURAMENTO" id="DBVAR_BOOL_LOJA_SHOW_FATURAMENTO2" type="radio" value="0" <% If NOT objRS("LOJA_SHOW_FATURAMENTO")= "1" Then Response.Write("checked") End If %>>
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Pesquisa CNPJ (WebService):</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_PESQUISA_CNPJ" id="DBVAR_BOOL_LOJA_PESQUISA_CNPJ"  type="radio" value="1" <% If objRS("LOJA_PESQUISA_CNPJ")= "1" Then Response.Write("checked") End If %>>
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_PESQUISA_CNPJ" id="DBVAR_BOOL_LOJA_PESQUISA_CNPJ2"  type="radio" value="0" <% If NOT objRS("LOJA_PESQUISA_CNPJ")= "1" Then Response.Write("checked") End If %> >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                </div><!--fim grid layout//-->  
                            </div><!--fim do frame13//-->
                            <div class="frame" id="_page_14_2_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Loja Tipo Login:</p></div>
                                        <div class="span8"> 
                                        <p class="input-control select " data-role="input-control">
                                            <select name="DBVAR_STR_LOJA_TIPO_LOGIN" id="DBVAR_STR_LOJA_TIPO_LOGIN" class="size3">
                                                <!-- option value="CPF">CPF </option //-->
                                                <option value="ID_NUM_DOC1" <%IF getValue(objRS,"LOJA_TIPO_LOGIN") = "ID_NUM_DOC1" THEN RESPONSE.Write("selected") %>>CPF(id_num_doc1)</option>
                                                <option value="EMAIL1" <%IF getValue(objRS,"LOJA_TIPO_LOGIN") = "EMAIL1" THEN RESPONSE.Write("selected") %>>E-MAIL </option>
                                            </select>
                                        </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Padrão Bloqueado:</p></div>
                                        <div class="span8"> 
                                        <p class="input-control select " data-role="input-control">
                                            <select name="DBVAR_STR_BLOQUEADO" id="DBVAR_STR_BLOQUEADO" class="size3">                                                
                                                <option value="0" <%IF getValue(objRS,"BLOQUEADO") = "0" THEN RESPONSE.Write("selected") %>>APROVADO</option>
                                                <option value="" <%IF (getValue(objRS,"BLOQUEADO")) = "" THEN RESPONSE.Write("selected") %>>EM ANÁLISE</option>
												<option value="1" <%IF getValue(objRS,"BLOQUEADO") = "1" THEN RESPONSE.Write("selected") %>>BLOQUEADO</option>
                                            </select>
                                        </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Loja Ativa/Loja PAPER ativa:</p></div>
                                        <div class="span8"> 
                                            <!--div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy <'%=Time%>" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_DATETIME_LOJA_ATIVA" name="DBVAR_DATETIME_LOJA_ATIVA" type="text" placeholder="DD/MM/AAAA HH:MM" value="<'%=PrepData(getValue(objRS,"LOJA_ATIVA"),True,True)%> " maxlength="16">
                                                <span class="btn-date"></span>
                                              </p>  
                                            </div>	-->
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="input-control">
                                                <input id="DBVAR_DATETIME_LOJA_ATIVA" name="DBVAR_DATETIME_LOJA_ATIVA" type="text" placeholder="DD/MM/AAAA HH:MM" value="<%=getValue(objRS,"LOJA_ATIVA")%> " maxlength="20">
                                              </p>  
                                            </div>	
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_DATETIME_SUBPAPER_ATIVA" name="DBVAR_DATETIME_SUBPAPER_ATIVA" type="text" placeholder="" value="<%=PrepData(getValue(objRS,"SUBPAPER_ATIVA"),True,False)%> " maxlength="11">
                                                <span class="btn-date"></span>
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">O campo Loja ativa usa [Data/Hora] no padrão  DD/MM/AAAA HH:MM:SS.</span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Modelo Loja PJ:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                            	<p>
                                                <input type="text" name="DBVAR_STR_MODELO_LOJAPJ" id="DBVAR_STR_MODELO_LOJAPJ" value="<%=getValue(objRS,"MODELO_LOJAPJ")%>" maxlength="1">
                                            	<p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                   
                                    <div class="row">
                                        <div class="span2" style=""><p>PSC Ativa/Loja Ativa PJ:</p></div>
                                        <div class="span8">
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                    <input id="DBVAR_DATETIME_PSC_ATIVA" name="DBVAR_DATETIME_PSC_ATIVA" type="text" placeholder="" value="<%=PrepData(getValue(objRS,"PSC_ATIVA"),True,False)%> " maxlength="11">
                                                    <span class="btn-date"></span>
                                        		</p>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                    <input id="DBVAR_DATETIME_LOJAPJ_ATIVA" name="DBVAR_DATETIME_LOJAPJ_ATIVA" type="text" placeholder="" value="<%=PrepData(getValue(objRS,"LOJAPJ_ATIVA"),True,False)%> " maxlength="11">
                                                    <span class="btn-date"></span>
                                        		</p>
                                        	</div>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame14//-->
                            <div class="frame" id="_page_15_2_1">
                                <div class="grid" style="border:0px solid #F00">
									<div class="row">
                                        <div class="span2" style=""><p>Regulamento Loja:</p></div>
                                        <div class="span8"> 
                                        <p class="input-control textarea " data-role="input-control">
                                        	<textarea name="DBVAR_STR_REGULAMENTO_LOJA" id="DBVAR_STR_REGULAMENTO_LOJA" ><%=ReturnCaracterEspecial(objRS("REGULAMENTO_LOJA")&"")%></textarea>
                                        </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('REGULAMENTO_LOJA');" class=""><i class="icon-search"></i> visualizar</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Regulamento Loja Intl:</p></div>
                                        <div class="span8"> 
                                        <p class="input-control textarea " data-role="input-control">&nbsp;</p>
                                            <span class="tertiary-text-secondary"><a href="javascript:viewdoc('REGULAMENTO_LOJA_INTL');" class=""><i class="icon-search"></i> <span class="input-control textarea ">
                                            <textarea name="DBVAR_STR_REGULAMENTO_LOJA_INTL" id="DBVAR_STR_REGULAMENTO_LOJA_INTL" ><%=ReturnCaracterEspecial(objRS("REGULAMENTO_LOJA_INTL")&"")%></textarea>
                                            </span>visualizar</a></span>    
                                        </div>                       
                                    </div>   
                                    <div class="row">
                                        <div class="span2" style=""><p>TP Acesso Totem:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                <input type="text" name="DBVAR_STR_TP_ACESSO_TOTEM" id="DBVAR_STR_TP_ACESSO_TOTEM" value="<%=getValue(objRS,"TP_ACESSO_TOTEM")%>" > 
                                             	</p>
                                             </div>
                                            <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Aviso Loja Inativa:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_AVISO_LOJA_INATIVA" id="DBVAR_STR_AVISO_LOJA_INATIVA" rows="5" cols="50" class="arial11"><%=ReturnCaracterEspecial(objRS("AVISO_LOJA_INATIVA")&"") %></textarea></p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('AVISO_LOJA_INATIVA');" class=""><i class="icon-search"></i> visualizar</a></span>   
                                        </div>
                                    </div>                                   
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame15//-->
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid layout//-->
            </div><!--fim frame layout//-->
            
            <div class="frame" id="CORRESPONDENCIA" style="width:100%;"><!--esta guia contem tab dentro de tab//-->
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="tab-control" data-role="tab-control">
                        <ul class="tabs">
                            <li class="active"><a href="#MOD1">M1</a></li>
                            <li><a href="#MOD2">M2</a></li>
                            <li><a href="#MOD3">M3</a></li>
                            <li><a href="#MOD4">M4</a></li>
                            <li><a href="#MOD5">M5</a></li>
                            <li><a href="#MOD6">M6</a></li>
                            <li><a href="#MOD7">M7</a></li>
                            <li><a href="#MOD8">M8</a></li>
                            <li><a href="#MOD9">M9</a></li>
                            <li><a href="#MOD10">M10</a></li>                                                                                    
                        </ul>
                        <div class="frames">
                            <div class="frame" id="MOD1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 1- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                <input type="text" name="DBVAR_STR_MOD1_TITLE" id="DBVAR_STR_MOD1_TITLE" value="<%=getValue(objRS,"MOD1_TITLE")%>" > 
                                             	</p>
                                             </div>
                                            <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 1- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD1_TEXTO" id="DBVAR_STR_MOD1_TEXTO" rows="5" cols="50" class="arial11"><%=ReturnCaracterEspecial(objRS("MOD1_TEXTO")&"") %></textarea></p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD1_TEXTO');" class=""><i class="icon-search"></i> visualizar</a></span>   
                                        </div>
                                    </div>   
                                </div><!--fim grid layout//-->  
                            </div><!--fim FRAME MOD1//-->
                            <div class="frame" id="MOD2">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 2- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 <input type="text" name="DBVAR_STR_MOD2_TITLE" id="DBVAR_STR_MOD2_TITLE" value="<%=getValue(objRS,"mod2_title")%>" > 
                                             	</p>
                                             </div>
                                        <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 2- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD2_TEXTO" id="DBVAR_STR_MOD2_TEXTO" ><%=ReturnCaracterEspecial(objRS("mod2_texto")&"")%></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD2_TEXTO');" class=""><i class="icon-search"></i> visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid layout//--> 
                            </div><!--fim FRAME MOD2//-->
                            <div class="frame" id="MOD3">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 3- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 <input type="text" name="DBVAR_STR_MOD3_TITLE" id="DBVAR_STR_MOD3_TITLE" value="<%=getValue(objRS,"mod3_title")%>" >
                                             	</p>
                                             </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 3- Texto:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD3_TEXTO" id="DBVAR_STR_MOD3_TEXTO"><%=ReturnCaracterEspecial(objRS("mod3_texto")&"")%></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD3_TEXTO');" class=""><i class="icon-search"></i> visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid //--> 
                            </div><!--FIM FRAME MOD3//-->
                            <div class="frame" id="MOD4">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 4- Título:</p></div>
                                        <div class="span8">
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 <input type="text" name="DBVAR_STR_MOD4_TITLE" id="DBVAR_STR_MOD4_TITLE" value="<%=getValue(objRS,"mod4_title")%>" > 
                                             	</p>
                                             </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 4- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD4_TEXTO" id="DBVAR_STR_MOD4_TEXTO" ><%=ReturnCaracterEspecial(objRS("mod4_texto")&"")%></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD4_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid //--> 
                            </div><!--fim frame mod4//-->
                            <div class="frame" id="MOD5">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 5- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 <input type="text" name="DBVAR_STR_MOD5_TITLE" id="DBVAR_STR_MOD5_TITLE" value="<%=getValue(objRS,"mod5_title")%>" > 
                                             	</p>
                                             </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 5- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD5_TEXTO" id="DBVAR_STR_MOD5_TEXTO" ><%=ReturnCaracterEspecial(objRS("mod5_texto")&"")%></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD5_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid //--> 
                            </div><!--fim frame mod5//-->
                            <div class="frame" id="MOD6">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 6- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 	<input type="text" name="DBVAR_STR_MOD6_TITLE" id="DBVAR_STR_MOD6_TITLE" value="<%=getValue(objRS,"mod6_title")%>" >
                                             	</p>
                                             </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 6- Texto:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea">
                                             	<textarea name="DBVAR_STR_MOD6_TEXTO" id="DBVAR_STR_MOD6_TEXTO"><%=ReturnCaracterEspecial(objRS("mod6_texto")&"")%></textarea>
                                             </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD6_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid//--> 
                            </div><!--fim frame mod6//-->
                            <div class="frame" id="MOD7">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 7- Título:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                            	<p>
													<input type="text" name="DBVAR_STR_MOD7_TITLE" id="DBVAR_STR_MOD7_TITLE" value="<%=getValue(objRS,"mod7_title")%>"> 
                                            	</p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 7- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD7_TEXTO" id="DBVAR_STR_MOD7_TEXTO"><%=ReturnCaracterEspecial(objRS("mod7_texto")&"")%></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD7_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame mod7 //-->

                            <div class="frame" id="MOD8">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 8- Título:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                            	<p>
													<input type="text" name="DBVAR_STR_MOD8_TITLE" id="DBVAR_STR_MOD8_TITLE" value="<%=getValue(objRS,"mod8_title")%>"> 
                                            	</p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 8- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD8_TEXTO" id="DBVAR_STR_MOD8_TEXTO"><%=ReturnCaracterEspecial(objRS("mod8_texto")&"")%></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD8_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame mod8 //-->
                            <div class="frame" id="MOD9">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 9- Título:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                            	<p>
													<input type="text" name="DBVAR_STR_MOD9_TITLE" id="DBVAR_STR_MOD9_TITLE" value="<%=getValue(objRS,"mod9_title")%>"> 
                                            	</p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 9- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD9_TEXTO" id="DBVAR_STR_MOD9_TEXTO"><%=ReturnCaracterEspecial(objRS("mod9_texto")&"")%></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD9_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame mod9 //-->
                            <div class="frame" id="MOD10">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 10- Título:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                            	<p>
													<input type="text" name="DBVAR_STR_MOD10_TITLE" id="DBVAR_STR_MOD10_TITLE" value="<%=getValue(objRS,"mod10_title")%>"> 
                                            	</p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 10- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD10_TEXTO" id="DBVAR_STR_MOD10_TEXTO"><%=ReturnCaracterEspecial(objRS("mod10_texto")&"")%></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD10_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame mod10 //-->
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid //-->
            </div><!--fim frame correspondencia//-->
                                       	
        
        
        <div class="frame" id="PROSHOP" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <!--//-->
                    <div class="tab-control" data-role="tab-control">
                        <ul class="tabs">
                            <li class="active"><a href="#PASSO1">PASSO 1</a></li>
                            <!--li><a href="#GERAL2">REGISTRO</a></li>
                            <li><a href="#GERAL3">LOCALIDADE</a></li>
                            <li><a href="#AGENCIA">AGENCIA</a></li>     
                            <li><a href="#SMS">SMS</a></li>
                            <<li><a href="#MINI">MINI</a></li>//-->   
                        </ul>
                        
                        <div class="frames">
                            <div class="frame" id="PASSO1">
                                <div class="grid" style="border:0px solid #F00">
                                        
                                        <div class="row">
                                            <div class="span2"><p>Imagem cabeçalho:</p></div>
                                                <div class="span8">
                                                     <p class="input-control textarea">
                                                        <textarea name="DBVAR_STR_proshop_cabecalho" id="DBVAR_STR_proshop_cabecalho"><%=ReturnCaracterEspecial(objRS("proshop_cabecalho")&"")%></textarea>
                                                      </p>
                                                 </div>                                            
                                                  <span class="tertiary-text-secondary"></span>
                                        </div>
                                     
                                        
                                        <div class="row">
                                            <div class="span2"><p>Banner Carossel PT:</p></div>
                                                <div class="span8">
                                                     <p class="input-control textarea">
                                                        <textarea name="DBVAR_STR_proshop_banner_carossel_pt" id="DBVAR_STR_proshop_banner_carossel_pt"><%=ReturnCaracterEspecial(objRS("proshop_banner_carossel_pt")&"")%></textarea>
                                                      </p>
                                                 </div>                                            
                                                  <span class="tertiary-text-secondary"></span>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="span2"><p>Banner Carossel EN:</p></div>
                                                <div class="span8">
                                                    <p class="input-control textarea">                                                                                                	
                                                       <textarea name="DBVAR_STR_proshop_banner_carossel_en" id="DBVAR_STR_proshop_banner_carossel_en"><%=ReturnCaracterEspecial(objRS("proshop_banner_carossel_en")&"")%></textarea>
                                                    </p>
                                                </div>                                            
                                            <span class="tertiary-text-secondary"></span>
                                        </div>
                                      
                                        
                                        <div class="row">
                                            <div class="span2"><p>Banner Carossel ES:</p></div>
                                                <div class="span8">
                                                    <p class="input-control textarea">                                                                                              	
                                                       <textarea name="DBVAR_STR_proshop_banner_carossel_es" id="DBVAR_STR_proshop_banner_carossel_es"><%=ReturnCaracterEspecial(objRS("proshop_banner_carossel_es")&"")%></textarea>
                                                    </p>
                                                </div>                                            
                                             <span class="tertiary-text-secondary"></span>                                        
                                        </div> 
                                    
                                                                         
                                        <div class="row">
                                            <div class="span2"><p>Descrição PT:</p></div>
                                            <div class="span8">
                                                <p class="input-control textarea">                                                                                              	
                                                   <textarea name="DBVAR_STR_proshop_descricao_pt" id="DBVAR_STR_proshop_descricao_pt"><%=ReturnCaracterEspecial(objRS("proshop_descricao_pt")&"")%></textarea>
                                                 </p>
                                             </div>                                            
                                            <span class="tertiary-text-secondary"></span>                                        
                                        </div>
                                        
                                        <div class="row">
                                            <div class="span2"><p>Descrição Intl:</p></div>
                                            <div class="span8">
                                                <p class="input-control textarea">                                                                                              	
                                                   <textarea name="DBVAR_STR_proshop_descricao_en" id="DBVAR_STR_proshop_descricao_en"><%=ReturnCaracterEspecial(objRS("proshop_descricao_en")&"")%></textarea>
                                                </p>
                                            </div>                                            
                                            <span class="tertiary-text-secondary"></span>                                        
                                        </div> 
                                        
                                        <div class="row">
                                            <div class="span2"><p>Descrição ES:</p></div>
                                            <div class="span8">                                            
                                                 <p class="input-control textarea">                                               	
                                                    <textarea name="DBVAR_STR_proshop_descricao_es" id="DBVAR_STR_proshop_descricao_es"><%=ReturnCaracterEspecial(objRS("proshop_descricao_es")&"")%></textarea>
                                                 </p>                                                                                      
                                                <span class="tertiary-text-secondary"></span>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="span2"><p>Google MAPS:</p></div>
                                            <div class="span8">
                                                <p class="input-control textarea">
                                                   <textarea name="DBVAR_STR_proshop_google_maps" id="DBVAR_STR_proshop_google_maps"><%=ReturnCaracterEspecial(objRS("proshop_google_maps")&"")%></textarea>
                                                </p>
                                             </div>                                            
                                            <span class="tertiary-text-secondary"></span>
                                        </div> 
                                        
                                        <div class="row">
                                            <div class="span2"><p>Google Tag Manager ID:</p></div>
                                            <div class="span8">
                                                <div class="input-control text info-state" data-role="input-control">
                                                    <p>                                                	
                                                       <input type="text" value="<%=ucase(getValue(objRS,"proshop_gtm_id"))%>" name="DBVAR_STR_proshop_gtm_id" id="DBVAR_STR_proshop_gtm_id" style="text-transform: uppercase;">
                                                    </p>
                                                </div>                                            
                                            <span class="tertiary-text-secondary">GTM-XXXXXXX</span>
                                            </div>
                                        </div>
                                        
                                         
                                        <div class="row">
                                            <div class="span2"><p>Campos Obrigatorios Default:</p></div>
                                            <div class="span8">                                               
                                                    <p class="input-control textarea">
                                                       <textarea name="DBVAR_STR_proshop_campos_obrigatorios" id="DBVAR_STR_proshop_campos_obrigatorios"><%=objRS("proshop_campos_obrigatorios")&""%></textarea>
                                                    </p>                                                                                           
                                            <span class="tertiary-text-secondary">var_cpf|var_email|var_email_comercial|var_nome_completo|var_nome_credencial|
											                                      var_data_nasc|var_sexom|var_necessidade_espt|var_necessidade_espf|var_ddi3|
											                                      var_ddd3|var_fone3|var_ddi4|var_ddd4|var_fone4|var_cargo|var_departamento|
																				  var_endereco|var_end_num|var_bairro|var_cidade|var_estado|var_pais|var_cep|
																				  var_cnpj|var_razao_social|var_nome_fantasia|var_codativ|var_sexof|</span>
                                            </div>
                                        </div>

                                          <div class="row">
                                            <div class="span2"><p>Campos Obrigatorios Inglês:</p></div>
                                            <div class="span8">                                               
                                                    <p class="input-control textarea">
                                                       <textarea name="DBVAR_STR_proshop_campos_obrigatorios_en" id="DBVAR_STR_proshop_campos_obrigatorios_en"><%=objRS("proshop_campos_obrigatorios_en")&""%></textarea>
                                                    </p>                                                                                           
                                            <span class="tertiary-text-secondary"></span>
                                            </div>
                                        </div>

                                          <div class="row">
                                            <div class="span2"><p>Campos Obrigatorios Espanhol:</p></div>
                                            <div class="span8">                                               
                                                    <p class="input-control textarea">
                                                       <textarea name="DBVAR_STR_proshop_campos_obrigatorios_es" id="DBVAR_STR_proshop_campos_obrigatorios_es"><%=objRS("proshop_campos_obrigatorios_es")&""%></textarea>
                                                    </p>                                                                                           
                                            <span class="tertiary-text-secondary"></span>
                                            </div>
                                        </div>
                                        
                                        <!--div class="row">
                                            <div class="span2"><p>Campos Exibir:</p></div>
                                            <div class="span8">
                                                <div class="input-control textarea">
                                                    <p>
                                                       <textarea name="DBVAR_STR_proshop_campos_exibir" id="DBVAR_STR_proshop_campos_exibir"><%=objRS("proshop_campos_exibir")&""%></textarea>
                                                    </p>
                                                </div>                                            
                                            <span class="tertiary-text-secondary">var_email|var_cpf|var_nome_completo.....</span>
                                            </div>
                                        </div//-->
                                        
                                        
                                        
                                        <div class="row">
                                            <div class="span2"><p>E-mail Evento:</p></div>
                                            <div class="span8">
                                                <div class="input-control text info-state" data-role="input-control">
                                                    <p>                                                	
                                                       <input type="text" value="<%=getValue(objRS,"proshop_email_evento")%>" name="DBVAR_STR_proshop_email_evento" id="DBVAR_STR_proshop_email_evento">
                                                    </p>
                                                </div>                                            
                                            <span class="tertiary-text-secondary"></span>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="span2"><p>E-mail Contato1:</p></div>
                                            <div class="span8">
                                                <div class="input-control text " data-role="input-control">
                                                    <p>                                                	
                                                       <input type="text" value="<%=getValue(objRS,"proshop_email_contato1")%>" name="DBVAR_STR_proshop_email_contato1" id="DBVAR_STR_proshop_email_contato1">
                                                    </p>
                                                </div>                                            
                                                <span class="tertiary-text-secondary"></span>
                                            </div>
                                         </div>
                              
                                        <div class="row">
                                            <div class="span2"><p>E-mail Contato2:</p></div>
                                            <div class="span8">
                                                <div class="input-control text" data-role="input-control">
                                                    <p>                                                	
                                                       <input type="text" value="<%=getValue(objRS,"proshop_email_contato2")%>" name="DBVAR_STR_proshop_email_contato2" id="DBVAR_STR_proshop_email_contato2">
                                                    </p>
                                                </div>                                            
                                                <span class="tertiary-text-secondary"></span>
                                            </div>
                                           </div>
                                         </div>
                                       </div>
                                       
                                       

                                       
                                       
                                       
                                       
                                                                       
                                   </div><!--fim grid//-->  
                                </div><!--fim de frame passo11//-->
                            
                                </div> <!--FIM GRID//-->
                            </div><!--fim do RESUMO//--> 
                        </div><!--fim sub frames//-->
                    </div><!--fim do sub tabcontrol//-->
                    
                 <div style="padding-top:16px; padding-bottom: 50px;"><!--INI: BOTÕES/MENSAGENS//-->
                    <div style="float:left">
                        <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
                        <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
                        <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
                    </div>
                    <div style="float:right">
                        <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e (*)</strong> campos obrigatórios</small>
                    </div> 
                    
        	    </div><!--FIM: BOTÕES/MENSAGENS //--> 
            
        
                <!-- este formulario //-->    
                
                <form name="formmercado" action="atualizamercado.asp" method="post">
                    <input type="hidden" name="var_chavereg" value="<%=strID_AUTO%>">
                    <input type="hidden" name="cod_evento" value="<%=getValue(objRS,"COD_EVENTO")%>">
                    <input type="hidden" name="base" value="<%=CFG_DB%>">
                    <input type="hidden" name="var_evento" value="<%=strIDTBL_EVENTO%>">
                    <input type="hidden" name="var_exibe" value="">
                    <input type="hidden" name="var_mercado" value="">
                    <input type="hidden" name="var_cod_evento" value="<%=strCOD_EVENTO%>">
                </form>
                
                <div class="span12"></div>

               </div><!--fim grid layout//-->
            </div><!--fim frame dados//-->
         </div><!--FIM - FRAMES//-->
	  </div><!--FIM TABCONTROL //--> 
	</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>


<%
	FechaRecordSet ObjRS
	FechaDBConn ObjConn
	'athDebug strSQL, true '---para testes'
%>