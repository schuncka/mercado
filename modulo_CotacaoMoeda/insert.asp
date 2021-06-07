<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CotacaoMoeda",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "TBL_MOEDA_COTACAO" ' - Nome da Tabela...
 Const DKN = "ID_AUTO"      ' - Campo chave...
 Const TIT = "COTAÇÃO MOEDA"     ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 Dim arrICON, arrBG , i ,strCOD_MOEDA 
 
 'strCOD_MOEDA = Replace(GetParam("var_chavereg"),"'","''")
 	
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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar() { 
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
<div class="container padding20" >
<!--div class TAB CONTROL --------------------------------------------------//-->
	<form name="forminsert" id="forminsert" action="insertexec.asp" method="post">
		<input type="hidden" name="DEFAULT_LOCATION" value="INSERT.asp">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" >
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
                    <div class="row">
                        <div class="span2"><p>Data:</p></div>
                        <div class="span8">
                            <div class="grid">
                                <div class="row" style="margin:0px;">                        
                                    <div class="span3">
                                        <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                            <input id="var_cotacao_dataô" name="var_cotacao_data" type="text" placeholder="" value="" maxlength="11" >                                        
                                        	<span class="btn-date"></span></p>
                                    </div>
 								</div>
                                <span class="tertiary-text-secondary">Data para utilização da taxa convertida</span>
                            </div>                                                             
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Moeda Origem:</p></div>
                        <div class="span8">
                            <div class="grid">
                                <div class="row" style="margin:0px;">
                                	<div class="span3">
                                        <p class="input-control text size1">
                                          <input type="text" value="1,00" disabled>
                                        </p>                                
                                        <span class="tertiary-text-secondary"></span>
                                        <p class="input-control select size2 info-state" data-role="data-hole" >
                                            <select name="var_moeda_origem" id="var_moeda_origemô" class="arial11">
                                            <option value="">Selecione</option>
                                            <%MontaCombo "STR"," SELECT COD_MOEDA, MOEDA AS LABEL FROM TBL_MOEDA ", "COD_MOEDA", "LABEL", ""%>
                                            </select>
                                        </p>                                
                                    </div> 
                                </div>
                                <span class="tertiary-text-secondary">base (1,00) , moeda que será cotada</span>
                            </div>                         
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Taxa / Moeda Dest.:</p></div>
                        <div class="span8">
                            <div class="grid">
                                <div class="row" style="margin:0px;">
                                    <div class="span5">
                                        <p class="input-control text size1"><input type="text" value="=" disabled></p>                                
                                        <p class="input-control text size2 info-state" data-role="data-hole" >
                                            <input type="text" name="var_cotacao_taxa" id="var_cotacao_taxaô" value="" maxlength="9" onChange="javascript: if ( parseFloat(this.value.replace(',','.')) <= 0.0 ) { this.value = ''; }"  onKeyPress="Javascript:return validateFloatKey(event);return false;">
                                        </p>                                
                                        <p class="input-control select size2 info-state" data-role="data-hole" >
                                            <select name="var_moeda_destino" id="var_moeda_destinoô" class="arial11">
                                            <option value="">Selecione</option>
                                            <%MontaCombo "STR"," SELECT COD_MOEDA, MOEDA AS LABEL FROM TBL_MOEDA ", "COD_MOEDA", "LABEL", ""%>
                                            </select>
                                        </p>                           
                                    </div>
                                </div>    
                                <span class="tertiary-text-secondary">(cotacao_taxa) moeda na qual será feita cotação/(moeda_destino) Equivalente a 1,00 na moeda origem de acordo com Taxa</span>                                                     
                            </div>
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
            <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e (*)</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
