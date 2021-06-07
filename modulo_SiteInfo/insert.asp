<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_SiteInfo",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "sys_site_info" ' - Nome da Tabela...
 Const DKN = "ID_AUTO"      ' - Campo chave...
 Const TIT = "Site Info"     ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 Dim arrICON, arrBG , i ,strIDINFO 
 
 strIDINFO = Replace(GetParam("var_chavereg"),"'","''")
 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script type="text/javascript" language="javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_SiteINFO/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_SiteInfo/insert.asp"; 
  if (validateRequestedFields("forminsert")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.forminsert.submit(); 
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
/* FIM: OK, APLICAR e CANCELAR, funções para action dos botões ------- */
</script>
</head>
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">INSERT</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	<form name="forminsert" id="forminsert" action="../_database/athinserttodb.asp" method="post">
		<input type="hidden" name="DEFAULT_TABLE"	 value="<%=LTB%>">
		<input type="hidden" name="DEFAULT_DB"		 value="<%=CFG_DB%>">
		<input type="hidden" name="FIELD_PREFIX" 	 value="DBVAR_">
		<input type="hidden" name="RECORD_KEY_NAME"	 value="<%=DKN%>">
		<input type="hidden" name="DEFAULT_LOCATION" value="">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
     <div class="row">
     <div class="span2"><p>Cód.Info</p></div>
     <div class="span8"><p class="input-control select info-state" data-role="input-control">
               <select name="DBVAR_STR_COD_INFOô" id="DBVAR_STR_COD_INFOô"> 
                    <option value="" selected>[selecione]</option>
                    <option value="CLIENTE ">CLIENTE</option>
                    <option value="CNPJ">CNPJ</option>
                    <option value="CONTATO">CONTATO</option>
                    <option value="CONTRATO">CONTRATO</option>
                    <option value="CPF">CPF</option>
                    <option value="DATABASE">DATABASE</option>
                    <option value="DOMINIO">DOMINIO</option>   
                    <option value="DT_PUBLICACAO">DT_PUBLICACAO</option> 
                    <option value="GERENTE">GERENTE</option>
                    <option value="HOSTING">HOSTING</option>
                    <option value="INSC_EXPRESSA_PGTO_ONLINE">INSC_EXPRESSA_PGTO_ONLINE</option>
                    <option value="TOTEM">TOTEM</option>  
                    <option value="TOTEM_CABECALHO">TOTEM_CABECALHO</option>
                    <option value="TOTEM_CONGRESSO">TOTEM_CONGRESSO</option>
                    <option value="TOTEM_VISITANTE">TOTEM_VISITANTE</option>                    
                    <option value="CFG_IDEMPRESA">CFG_IDEMPRESA</OPTION>   	
                    <option value="CFG_IDCLIENTE ">CFG_IDCLIENTE</OPTION>    	
                    <option value="CFG_SIZE_LABEL_NOME ">CFG_SIZE_LABEL_NOME</OPTION> 
                    <option value="CFG_MAXLEN_LABEL_NOME">CFG_MAXLEN_LABEL_NOME</OPTION> 
                    <option value="CFG_SIZE_LABEL_EMPRESA">CFG_SIZE_LABEL_EMPRESA</OPTION> 
                    <option value="CFG_MAXLEN_LABEL_EMPRESA">CFG_MAXLEN_LABEL_EMPRESA</OPTION> 
                    <option value="PAX_CADASTRO">PAX_CADASTRO</option>
                    <option value="PAX_CADASTRO_EMAIL">PAX_CADASTRO_EMAIL</option>
                    <option value="PAX_VALIDA_SENHA">PAX_VALIDA_SENHA</option>
                    <option value="PAX_EMAIL_SENDER">PAX_EMAIL_SENDER</option>
                    <option value="PAX_EMAIL_AUDITORIA_PROEVENTO">PAX_EMAIL_AUDITORIA_PROEVENTO</option>
                    <option value="PAX_EMAIL_AUDITORIA_CLIENTE">PAX_EMAIL_AUDITORIA_CLIENTE</option>
                    <option value="TOTEM_IMPRIMIR_VISITANTE">TOTEM_IMPRIMIR_VISITANTE</OPTION> 
                    <option value="TOTEM_IMPRIMIR_CONGRESSISTA">TOTEM_IMPRIMIR_CONGRESSISTA</OPTION> 
                    <option value="TOTEM_TEMPO_LIMITE_REIMPRESSAO">TOTEM_TEMPO_LIMITE_REIMPRESSAO</OPTION>
                    <option value="TOTEM_TEMPO_LIMITE_REIMPRESSAO_DIARIO">TOTEM_TEMPO_LIMITE_REIMPRESSAO_DIARIO</OPTION>
                    <option value="BRINDE_IMPRIMIR_VOUCHER">BRINDE_IMPRIMIR_VOUCHER</OPTION>
                    <option value="BRINDE_CONFIRMA_RETIRADA">BRINDE_CONFIRMA_RETIRADA</OPTION>
                    <option value="BRINDE_TIPO_PESQUISA">BRINDE_TIPO_PESQUISA</OPTION>                   
                    <option value="BRINDE_LIMITE_RETIRADA ">BRINDE_LIMITE_RETIRADA</OPTION>                                                            
                    <option value="SRF_PESQUISA_CNPJ ">SRF_PESQUISA_CNPJ</OPTION>
                    <option value="SRF_USER">SRF_USER</OPTION>
                    <option value="SRF_PASSWORD">SRF_PASSWORD</OPTION>
                 </select></p>
            </div>
        </div>
        <div class="row">
                <div class="span2"><p>Descrição:</p></div>
                <div class="span8">
                     <p class="input-control text " data-role="input-control"><input id="DBVAR_DESCRICAO" name="DBVAR_DESCRICAO" type="text" placeholder="" value="" maxlength="250"></p>
                     <span class="tertiary-text-secondary"></span>
                </div>
         </div> 
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    
    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigat&oacute;rios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
