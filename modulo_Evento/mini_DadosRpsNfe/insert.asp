<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_DadosRpsNfe",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_fin_rps_evento" 		' - Nome da Tabela...
 Const DKN = "COD_RPS_EVENTO"		' - Campo chave...
 Const TIT = "Dados RPS/NFE"				' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 Dim  strCOD_EVENTO,strCOD_RPS_EVENTO


'strstrINSTRUCAOMINI = Replace(GetParam("var_chavemaster"),"'","''")
strCOD_RPS_EVENTO =  Replace(GetParam("var_chavereg"),"'","''")
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Evento/mini_DadosRpsNfe/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_Evento/mini_DadosRpsNfe/insert.asp?var_cod_evento=<%=strCOD_EVENTO%>"; 
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
                <li class="#"><a href="#DADOS2">DADOS</a></li>
                <li class="#"><a href="#EXTRA">EXTRA</a></li>
            </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                      <!--<div class="row ">
                            <div class="span10" style=""><p><b>Cod_Evento:&nbsp;&nbsp;&nbsp;<'%=strCOD_EVENTO%></b></p>                                         
                                 <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span>  
                            </div> 
                    </div>//-->
                     <div class="row">
                                <div class="span2"><p>*Inscrição Municipal:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text info-state" data-role="input-control"><input type="text" name="DBVAR_STR_INSCR_MUNICIPAL" id="DBVAR_STR_INSCR_MUNICIPALô"  value="" maxlength="45"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                      <div class="row">
                                <div class="span2"><p>Código Serviço/Alíquota:&nbsp;</p></div>
                                <div class="span8">
                                    <div class="input-control text size3" data-role="input-control">
                                        <p>
                                        	<input type="text" name="DBVAR_STR_COD_SERVICO" id="DBVAR_STR_COD_SERVICO" value="" class="" maxlength="45">
                                            <!--input type="text" name="DBVAR_STR_COD_SERVICO" id="DBVAR_STR_COD_SERVICO" value="" onKeyPress="return validateNumKey(event);" class="" maxlength="45"//-->
                                        </p>
                                    </div>
                                    <div class="input-control text size2" data-role="input-control">
                                        <p>
                                            <input type="text" name="DBVAR_STR_ALIQUOTA" id="DBVAR_STR_ALIQUOTA" value="" class="" maxlength="45">
                                        </p>
                                    </div><span class="tertiary-text-secondary"><br>Cod Serv.Ex: 00000 / Aliquota Ex: 5,00% preencher 0500</span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Instrução:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control textarea " data-role="input-control"><textarea type="text" name="DBVAR_STR_INSTRUCAO" id="DBVAR_STR_INSTRUCAO" value=""></textarea></p>
                                     <span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                     
                      <div class="row ">
                                <div class="span2"><p>*Isento:</p></div>
                                <div class="span8"><p>
                                    <input type="radio"   name="DBVAR_STR_ISENTO" id="DBVAR_STR_ISENTOô"  value="1">
                                    Sim&nbsp;
                                    <input  type="radio"  name="DBVAR_STR_ISENTO" id="DBVAR_STR_ISENTO2ô"  value="0">
                                    Não
                                    </p><span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                    </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
             <div class="frame" id="DADOS2" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                <div class="row">
                                <div class="span2"><p>CNPJ/Município:&nbsp;</p></div>
                                <div class="span8">
                                     <div class="input-control  text size3" data-role="input-control">
                                     	<p>
                                     		<input type="text" name="DBVAR_NUM_CNPJ" id="DBVAR_NUM_CNPJ" value="" maxlength="20" onKeyPress="return validateNumKey(event);" class="">
										</p>
                                     </div> 
                                     <div class="input-control  select  size2" data-role="input-control">
                                     	<p>
                                            <select name="DBVAR_STR_MUNICIPIO" id="DBVAR_STR_MUNICIPIO" class="">
                                                <option value='' >Selecione...</option>
                                                <option value='CURITIBA'>Curitiba</option>
                                                <option value='SAO PAULO'>São Paulo</option>
                                        	</select>									
										</p>
                                     </div>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                 <div class="row">
                                <div class="span2"><p>Número RPS Atual:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input type="text" name="DBVAR_NUM_NUM_RPS_ATUAL" id="DBVAR_NUM_NUM_RPS_ATUAL" value="" maxlength="9" onKeyPress="return validateNumKey(event);"></p>
                                     <span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Série RPS:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input type="text" name="DBVAR_STR_SERIE_RPS" id="DBVAR_STR_SERIE_RPS" value="" maxlength="45"></p>
                                     <span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                    </div> <!--FIM GRID//-->
                    </div><!--fim do frame extra//-->
                     <div class="frame" id="EXTRA" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                    <div class="grid" style="border:0px solid #F00">
                     <div class="row ">
                                <div class="span2"><p>*Dedução:</p></div>
                                <div class="span8"><p>
                                    <input type="radio"   name="DBVAR_NUM_DEDUCAO" id="DBVAR_NUM_DEDUCAOô"  value="1">
                                    Sim&nbsp;
                                    <input  type="radio"  name="DBVAR_NUM_DEDUCAO" id="DBVAR_NUM_DEDUCAO2ô"  value="0">
                                    Não
                                    </p><span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Layout Prefeitura:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input type="text" name="DBVAR_STR_LAYOUT_PREFEITURA" id="DBVAR_STR_LAYOUT_PREFEITURA" value="" maxlength="45"></p>
                                     <span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Layout Saída:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input type="text" name="DBVAR_STR_LAYOUT_SAIDA" id="DBVAR_STR_LAYOUT_SAIDA" value="" maxlength="45"></p>
                                     <span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>  
                    <div class="row">
                                <div class="span2"><p>Razão Social:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input type="text" name="DBVAR_STR_RAZAO_SOCIAL" id="DBVAR_STR_RAZAO_SOCIAL" value="" maxlength="100"></p>
                                     <span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>   
                 </div> <!--FIM GRID//-->
            </div><!--fim do frame extra//-->
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