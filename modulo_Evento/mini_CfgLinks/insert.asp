<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_CfgLinks",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "TBL_EVENTO_LINK" 								' - Nome da Tabela...
 Const DKN = "COD_EVENTO_LINK"									' - Campo chave...
 Const TIT = "CFG Link"	

 Dim  strCOD_EVENTO

strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")

%> 
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Evento/mini_CfgLinks/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      {  
  document.forminsert.DEFAULT_LOCATION.value="../modulo_Evento/mini_CfgLinks/insert.asp?var_cod_evento=<%=strCOD_EVENTO%>"; 
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
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">INSERT</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
                     <form name="forminsert" id="forminsert" action="../../_database/athinserttodb.asp" method="post">
                    <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
                    <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                    <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                    <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                    <input type="hidden" name="DEFAULT_LOCATION" value="">
                    <input type="hidden" name="DBVAR_NUM_COD_EVENTO" id="DBVAR_NUM_COD_EVENTO" value="<%=strCOD_EVENTO%>" >
 <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="row">
                                <div class="span2"><p>Titulo:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_TITULO" id="DBVAR_STR_TITULO" value="" maxlength="250"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>URL:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control textarea " data-role="input-control"><textarea type="text"  name="DBVAR_STR_URL" id="DBVAR_STR_URL" ></textarea></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Tipo:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text select" data-role="input-control"> 
                                     <select id="DBVAR_STR_TIPO" name="DBVAR_STR_TIPO" onChange="">                                 
                                     <option value="">Selecione:</option>                                 	
                                     <option value="SHOPPJ">Loja Pessoa Juridíca(SHOPPJ)</option>                                 
                                     <option value="SHOPPF">Loja Pessoa Física(SHOPPF)</option>                                 
                                     <option value="SHOPPJ3">Loja Pessoa Jurídica 3(SHOPPJ3)</option>                                 	
                                     <option value="PSCPJ">Loja de Pedido de Credencial de Pessoa Jurídica(PSCPJ)</option>                                 
                                     <option value="PSCPF">Loja de Pedido de Credencial de Pessoa Física(PSCPF)</option>                                 
                                     <option value="PSCPJ3">Loja de Pedido de Credencial de Pessoa Jurídica 3(PSCPJ3)</option>                                 
                                     <option value="SUBPAPER">Loja de Envio de Trabalhos Cientificos(SUBPAPER)</option>                                 				
                                     </select></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Idioma:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text select " data-role="input-control">
                                     <select id="DBVAR_STR_IDIOMA" name="DBVAR_STR_IDIOMA" onChange="">
                                     <option value="">Selecione:</option>
                                     <option value="BR">Portuguese(BR)</option>
                                     <option value="EN">Eglish(EN)</option>
                                     <option value="ES">Espanhol(ES)</option>
                                     </select></p>
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
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>                    
