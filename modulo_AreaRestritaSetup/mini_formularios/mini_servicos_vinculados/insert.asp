<!--#include file="../../../_database/athdbConnCS.asp"-->
<!--#include file="../../../_database/athUtilsCS.asp"-->
<!--#include file="../../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_servicos_vinculados",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_formularios" 								    ' - Nome da Tabela...
 Const DKN = "cod_formulario"									        ' - Campo chave...
 Const TIT = "Cadastro Caex"									' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro
 Const DLD = "../modulo_AreaRestritaSetup/mini_formularios/mini_servicos_vinculados/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção


 Dim arrICON, arrBG , i ,strIDINFO, strSQL
 Dim objConn, objRS, strCOD_EVENTO, strLANG, strID_AUTO, strID_DOCUMENTO
 Dim objFSO, strPath, objFolder, objItem   
 Dim strFormFolder

strCOD_EVENTO = Replace(GetParam("var_chavemaster"),"'","''")


AbreDBConn objConn, CFG_DB
 
 'strIDINFO = Replace(GetParam("var_chavereg"),"'","''")
%>

<html>
<head>
<title>Mercado</title>
<script src="../../../metro-calendar.js"></script>
<script src="../../../metro-datepicker.js"></script>
<!--#include file="../../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../../_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript">

/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_AreaRestritaSetup/mini_formularios/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      {  
  document.forminsert.DEFAULT_LOCATION.value="../modulo_AreaRestritaSetup/mini_formularios/insert.asp?var_chavemaster=<%=strCOD_EVENTO%>";
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
<script language="javascript" type="text/javascript">
//função para ativar o date picker dos campos data
$("#datepicker").datepicker( {
	date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer já  ele modifica automaticamente para data setada dentro da função//-->
	format: "dd/mm/yyyy", // set output format
	effect: "none", // none, slide, fade
	position: "bottom", // top or bottom,
	locale: ''en, // 'ru' or 'en', default is $.Metro.currentLocale
});
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
<form name="forminsert" id="forminsert" action="../../../_database/athinserttodb.asp" method="post">        
    <input type="hidden" name="DEFAULT_TABLE" value="tbl_formularios_servicos">
    <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
    <input type="hidden" name="FIELD_PREFIX"  value="dbvar_">
    <input type="hidden" name="DEFAULT_LOCATION" value="">
    <input type="hidden" name="dbvar_num_cod_formulario" value="<%=strID_DOCUMENTO%>">


        <div class="tab-control" data-effect="fade" data-role="tab-control">
            <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                <li class="active"><a href="#DADOS">GERAL</a></li>
            </ul>
        
	    	<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
                        
                    <div class="row">
                            <div class="span2"><p>SERVIÇO:</p></div>
                              <div class="span8">
                                <div class="input-control select ">
                                    <select id="dbvar_num_cod_serv" name="dbvar_num_cod_serv">
                                      <option value="" selected="selected">Selecione...</option>
                                       	<%
                                            strSQL =  " SELECT COD_SERV, TITULO FROM tbl_AUX_SERVICOS  WHERE COD_EVENTO = COD_EVENTO AND COD_SERV NOT IN (SELECT COD_SERV FROM tbl_formularios_servicos WHERE COD_FORMULARIO = COD_FORMULARIO ) ORDER BY TITULO"                                           
                                            MontaCombo "STR",strSQL, "cod_servico","titulo",""
                                        %>
                                   </select>
                                </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Qtde Fixa::</p></div>
                            <div class="span8">
                                <p class="input-control text" data-role="input-control">
                                <input id="dbvar_num_qtde_fixa" name="dbvar_num_qtde_fixa" type="text" placeholder="" value="" maxlength="250">
                            </p>
                                <span class="tertiary-text-secondary"></span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Ordem:</p></div>
                            <div class="span8">
                                <p class="input-control text" data-role="input-control">
                                <input id="dbvar_num_ordem" name="dbvar_num_ordem" type="text" placeholder="" value="" maxlength="250">
                            </p>
                                <span class="tertiary-text-secondary"></span>
                        </div>
                    </div>

                    </div> <!--FIM GRID//-->
                </div><!--fim do frame dados//-->
        
            </div><!--FIM - FRAMES//-->
        </div><!--FIM TABCONTROL //--> 

                <div style="padding-top:16px; padding-bottom: 50px;"><!--INI: BOTÕES/MENSAGENS//-->
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
</div> <!--FIM DIV CONTAINER//-->  
</body>
</html>
