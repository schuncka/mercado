<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_AdmProduto",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"              ' - Default do Modulo...
 Const LTB = "tbl_produtos"	        ' - Nome da Tabela...
 Const DKN = "COD_PROD"             ' - Campo chave...
 Const TIT = "Produto"              ' - Carrega o titulo do modulo

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
  'Relativas a FILTRAGEM e Paginação	
 Dim strCOD_PROD,strCOD_PROD_ORIGEM, strDESCRICAO,strTITULO,strCOD_PROX
 
 
 AbreDBConn objConn, CFG_DB
	
strCOD_PROD 		 	= Replace(GetParam("var_chavereg"),"'","''")
strCOD_PROD_ORIGEM 	    = Replace(GetParam("var_cod_prod_new"),"'","''")
strCOD_PROX		 	    = Replace(GetParam("var_cod_prod_prox"),"'","''")
	
	
'Monta SQL ------------------------------------------------------------------------------------------------
 strSQL =  "SELECT MAX(COD_PROD) as PROX_COD_PROD FROM tbl_produtos "
 Set objRS = objConn.Execute(strSQL)
 If not objRS.EOF Then
   strCOD_PROX = objRS("PROX_COD_PROD") + 1
 end if 
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
 
 
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
  		response.write ("document.formcopiar.DEFAULT_LOCATION.value='../modulo_AdmProduto/default.asp';") 
	 else
  		response.write ("document.formcopiar.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formcopiar")) { 
		document.formcopiar.submit(); 
	} 
}
function aplicar() { 
  if (validateRequestedFields("formcopiar")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.formcopiar.submit(); 
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
<body class="metro" id="metrotablevista">
<div class="grid fluid">
	<!-- INI: barra no topo (filtro e adicionar) //-->
    <div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
    <%=TIT%>&nbsp;<sup><span style="font-size:12px">COPY</span></sup>
	</div>
    <div class="container padding20">
            <form name="formcopiar" id="formcopiar" action="duplicaexec.asp" method="post">
            <input type="hidden" name="DEFAULT_LOCATION" value="duplica.asp">            
			<!--INI: TABCONTROL //--> 
            <div class="tab-control" data-effect="fade" data-role="tab-control">
                <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                <li class="active"><a href="#DADOS">GERAL</a></li>	
                </ul>
                <!--INI - FRAMES //-->
                <div class="frames">
                    <div class="frame" id="DADOS" style="width:100%;">
                        <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                        <div class="grid" style="border:0px solid #F00">
                            <div class="row">
                                <div class="span2"><p>Produto Origem:</p></div>
                                <div class="span8">
                                    <p class="input-control select" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    <!-- <select name="COD_EVENTO_ORIGEM" id="COD_EVENTO_ORIGEM" class="textbox380" onChange="document.location='copia_evento.asp?cod_evento_origem='+this.value;">//-->
                                    <select name="var_chavereg" id="var_chavereg" onChange="">
                                    
                                     <% montaCombo "STR" ,"SELECT COD_PROD, CONCAT(CAST(COD_PROD AS CHAR), ' - ', CAST(TITULO AS CHAR)) AS TITULO FROM tbl_PRODUTOS ", "COD_PROD", "TITULO", strCOD_PROD%>
                                    </select>
                                    <span class="tertiary-text-secondary"></span> 
                                </div>
                            </div>
                            <div class="row">
                                <div class="span2"><p>*Novo Produto:</p></div>
                                <div class="span8">
                                    <p class="input-control text" data-role="input-control"><input type="text" name="var_cod_prod_new" id="var_cod_prod_new" maxlength="3" onKeyPress="return validateNumKey(event);" value="<%=strCOD_PROX%>"></p>
                                    <span class="tertiary-text-secondary">Digite "0"(zero) para gerar novo código autom&aacute;tico. </span>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="span2"><p>*Novo Título:</p></div>
                                <div class="span8">
                                    <p class="input-control text" data-role="input-control"><input type="text" name="var_titulo" id="var_tituloô"  value=""></p>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                            </div>

							<!-- INI: Check boss ------------------------------------------------- //-->
                             <div class="row">
                                <div class="span2">
                                  <p>Copiar também:</p></div>
                                <div class="span8">
                                <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyCod_Prod" id="var_flagCpyCod_Prod" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Produtos
                                        </label>
                                    </p>
                                <!--<p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpypreco_Prod" id="var_flagCpypreco_Prod" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Preços
                                        </label>
                                    </p>//-->
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyPalestr_Prod" id="var_flagCpyPalestr_Prod" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Prod. Palestr.
                                        </label>
                                    </p>
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCopyRestricao_Prod" id="var_flagCopyRestricao_Prod" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Prod. Restri.
                                        </label>
                                    </p>
                                    <!--<p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCopyCombo_Prod" id="var_flagCopyCombo_Prod" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Prod. Combo.
                                        </label>
                                    </p>//-->
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCopyPacote_Prod" id="var_flagCopyPacote_Prod" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Restr. Pacote.
                                        </label>
                                    </p>
                                   <!-- <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCopyJurado_Prod" id="var_flagCopyJurado_Prod" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Restr. Jurado.
                                        </label>
                                    </p>//-->
                                     <br><span class="tertiary-text-secondary">Desmarque o que NÃO for necessário copiar.</span> 
                                </div>
	                        </div>
	                      </div>
							<!-- FIM: Check boss ------------------------------------------------- //-->
                        </div>
                </div><!--FIM - FRAMES //-->

            </div><!--FIM TABCONTROL //--> 

            <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
                <div style="float:left">
                    <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
                    <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
                    <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false; ">    
                </div>
	            <div style="float:right">
    	        	<small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigatórios</small>
        	    </div>
            </div><!--FIM: BOTÕES/MENSAGENS //--> 
            
        </form>
	</div> <!--FIM ----DIV CONTAINER//-->  
</DIV>    
</body>
</html>
<%
FechaRecordSet ObjRS
FechaDBConn ObjConn
%>
   