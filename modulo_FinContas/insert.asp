<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CfgPanel",Session("ID_USER")), true %>
<%
 
 Const LTB = "fin_conta"	 ' - Nome da Tabela...
 Const DKN = "cod_conta"    ' - Campo chave...
 Const TIT = "FinContaBanco"        ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_FinContas/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_FinContas/insert.asp"; 
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
	<form name="forminsert" id="forminsert" action="../_database/athinserttodb.asp" method="post">
		<input type="hidden" name="DEFAULT_TABLE"	 value="<%=LTB%>">
		<input type="hidden" name="DEFAULT_DB"		 value="<%=CFG_DB%>">
		<input type="hidden" name="FIELD_PREFIX" 	 value="DBVAR_">
		<input type="hidden" name="RECORD_KEY_NAME"	 value="<%=DKN%>">
		<input type="hidden" name="DEFAULT_LOCATION" value="">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
            <!--li class=""><a href="#BANCO">BANCO</a></li //-->
            <!-- li class=""><a href="#AJUDA">AJUDA</a></li //-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                        <div class="row ">
                                    <div class="span2"><p>*Banco:</p></div>
                                    <div class="span8">
                                            <div class="input-control  select size3" data-role="input-control">
                                                <p>
                                                    <select name="DBVAR_STR_COD_BANCOô" id="DBVAR_STR_COD_BANCOô" class="">
                                                        <option value=""></option>
                                                        <option value="1">Banco do Brasil</option>
                                                        <option value="2">Itaú</option>
                                                        <option value="3">Banrisul</option>
                                                        <option value="4">Unibanco</option>
                                                        <option value="5">Bradesco</option>
                                                        <option value="6">Caixa Economica Federal</option>
                                                        <option value="7">Santander</option>
                                                    </select>
                                                </p>
                                            </div>                                    	
                                    </div>
                         </div>                      
                     <div class="row ">
                            <div class="span2"><p>*Agência/ Conta:</p></div>
                            <div class="span8">
                                <div class="input-control select text size2" data-role="input-control">
                                	<p><input id="DBVAR_STR_AGENCIAô" name="DBVAR_STR_AGENCIAô" type="text" placeholder="ex.: 0,00" value="" maxlength="50" class=""></p>
                                </div>
                                <div class="input-control select text size3" data-role="input-control">
                                	<p><input id="DBVAR_STR_CONTAô" name="DBVAR_STR_CONTAô" type="text" placeholder="ex.: 0,00" value="" maxlength="50" class=""></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                            </div> 
                     </div>
                     <div class="row">
                                <div class="span2"><p>Nome:</p></div>
                                <div class="span8">
                                    	<div class="input-control text size3" data-role="input-control">
                                            <p><input id="DBVAR_STR_NOME" name="DBVAR_STR_NOME" type="text" value="" maxlength="50" placeholder="ex.: ITAU CDB Comp"></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                      </div>  
                      <div class="row ">
                                <div class="span2" style=""><p>Tipo:</p></div>
                                <div class="span8"> 
                                    	<div class="input-control  select size2" data-role="input-control">
                                            <p>
                                            	<select name="DBVAR_STR_TIPO" id="DBVAR_STR_TIPO" class="">
                                                    <option value="">[selecione]</option>
                                                    <option value="CONTA CORRENTE">Conta-Corrente</option>
                                                    <option value="CARTAO DE CREDITO">Cartão de Crédito</option>
                                                    <option value="DINHEIRO">Dinheiro</option>
                                                    <option value="INVESTIMENTOS">Investimentos</option>
                                                    <option value="POUPANCA">Poupança</option>
                                                    <option value="OUTROS">Outros</option>	
                                                </select>
                                            </p>
                                    	</div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Saldo Inicial:</p></div>
                                <div class="span8">
                                    	<div class="input-control text size3" data-role="input-control">
                                            <p><input id="DBVAR_STR_VLR_SALDO_INIô" name="DBVAR_STR_VLR_SALDO_INIô" type="text" placeholder="ex.: 0,00" value="" ></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     
                      <div class="row">
                                <div class="span2"><p>*Data Abertura:</p></div><!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer. Ele modifica automaticamente para data setada dentro da função//-->
                                <div class="span8">
                                    <div class="input-control text size3 " data-role="input-control">
                                        <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                            <input id="DBVAR_DATE_DT_CADASTROô" name="DBVAR_DATE_DT_CADASTROô" type="text" placeholder="" value="" maxlength="11" class=""  >
                                            <span class="btn-date"></span>
                                        </p>
                                    </div>                                    
                                </div>
                      </div>
                     <div class="row ">
                                <div class="span2" style=""><p>Descrição:&nbsp;</p></div>
                                <div class="span8">  
                                     <p class="input-control textarea " data-role="input-control"><textarea name="DBVAR_STR_DESCRICAO" maxlength="250" id="DBVAR_STR_DESCRICAO" cols="40" rows="6"></textarea></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2" style=""><p>Ordem:</p></div>
                                <div class="span8">
                                    <div class="input-control text " data-role="input-control">
                                            <p><input id="DBVAR_STR_ORDEM" name="DBVAR_STR_ORDEM" type="text" placeholder="ex.: 1" value="" ></p>
                                    </div>
                                    <span class="tertiary-text-secondary"></span>  
                                </div> 
                     </div>                       
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->          
            
            <!--
            <div class="frame" id="AJUDA">
                 <p>O modulo CFG_Panel esta habilitado a criar atalhos no "painel principal" do sistema PVista
                 e tem em seus campos de cadastro a descrição de como proceder na inserção ou alteração de um atalho.<br>
                 Com este módulo será possível configurar um atalho especificando o caminho do modulo até a cor .<br> Além do tamanho do atalho 
                 mas isto deve ser tratado com atenção pois ele tem padrões de cadastramento para funcionar perfeitamente.</p>
            </div >
            //-->      
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
