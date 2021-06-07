<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_AdmProduto",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "sys_site_info" ' - Nome da Tabela...
 Const DKN = "ID_AUTO"      ' - Campo chave...
 Const TIT = "Adm. Produto"     ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 Dim arrICON, arrBG , i ,strIDINFO , strSQL
 
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_AdmProduto/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_AdmProduto/updVigencia.asp"; 
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
/* FIM: OK, APLICAR e CANCELAR, funções para action dos botões ------- */
</script>
</head>
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-orange fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">Alt Dt Vig.</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	<form name="formupdate" id="formupdate" action="updVigenciaExec.asp" method="post">	
    <input type="hidden" id="DEFAULT_LOCATION"	 name="DEFAULT_LOCATION" value="">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
     <div class="row">
     	<div class="span2"><p>*Categorias</p></div>
     		<div class="span8"><p class="input-control select info-state" data-role="input-control">
               <select name="DBVAR_CATEGORIA" id="DBVAR_CATEGORIAô"> 
                    <option value="">Selecione...</option>
					<%
						strSQL = " SELECT distinct t1.COD_STATUS_PRECO, t1.STATUS FROM tbl_STATUS_PRECO t1 INNER JOIN tbl_prclista t2 on t1.cod_status_preco = t2.cod_status_preco WHERE STATUS <>'' and STATUS is not null AND COD_EVENTO = " & Session("COD_EVENTO")
'						MontaCombo strSQL, "COD_STATUS_PRECO", "STATUS", ""
						MontaCombo "STR",strSQL, "COD_STATUS_PRECO", "STATUS", ""
					%>
                 </select></p>
            </div>
            <span class="tertiary-text-secondary">As categorias listadas acima são referentes aos produtos disponiveis no evento logado.</span>
      </div>
      
      <div class="row">
        <div class="span2"><p>*Data Ini./Data Fim:</p></div><!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer. Ele modifica automaticamente para data setada dentro da função//-->
        <div class="span8">
            <div class="input-control text size3 info-state" data-role="input-control">
                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                    <input id="DBVAR_VELHA_DT_INICIOô" name="DBVAR_VELHA_DT_INICIO" type="text" placeholder="" value="" maxlength="11" class=""  >
                    <span class="btn-date"></span>
                </p>
            </div>
            <div class="input-control text size3" data-role="input-control">                                        
                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                    <input id="DBVAR_VELHA_DT_FIMô" name="DBVAR_VELHA_DT_FIM" type="text" placeholder="" value="" maxlength="11" class="">
                    <span class="btn-date"></span>
                </p>
            </div>    
            <br><span class="tertiary-text-secondary">As datas acima são referentes a atual vigência.</span>
        </div>
    </div>
    
    
    <div class="row">
        <div class="span2"><p>*Data Ini./Data Fim:</p></div><!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer. Ele modifica automaticamente para data setada dentro da função//-->
        <div class="span8">
            <div class="input-control text size3 info-state" data-role="input-control">
                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                    <input id="DBVAR_NOVA_DT_INICIOô" name="DBVAR_NOVA_DT_INICIO" type="text" placeholder="" value="" maxlength="11" class=""  >
                    <span class="btn-date"></span>
                </p>
            </div>
            <div class="input-control text size3" data-role="input-control">                                        
                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                    <input id="DBVAR_NOVA_DT_FIMô" name="DBVAR_NOVA_DT_FIM" type="text" placeholder="" value="" maxlength="11" class="">
                    <span class="btn-date"></span>
                </p>
            </div>    
            <br><span class="tertiary-text-secondary">As datas acima são referentes a nova vigência.</span>
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
