<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_evento",Session("METRO_USER_ID_USER")), true %>
<%

 Const LTB = "tbl_evento"	 ' - Nome da Tabela...
 Const DKN = "cod_evento"    ' - Campo chave...     
 Const TIT = "COPIA EVENTO"  ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 Dim objRS, objConn, strSQL
 Dim strCOD_EVENTO

 AbreDBConn objConn, CFG_DB


 strSQL =  "SELECT MAX(COD_EVENTO) as PROX_EVENTO FROM TBL_EVENTO "
 Set objRS = objConn.Execute(strSQL)
 If not objRS.EOF Then
   strCOD_EVENTO = objRS("PROX_EVENTO") + 1
 end if 
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
  		response.write ("document.formcopiar.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';") 
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
<body class="metro" id="metrotablevista" >
	<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
	<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
		<%=TIT%>&nbsp;<sup><span style="font-size:12px">INSERT</span></sup>
	</div>
	<!-- FIM:BARRA ----------------------------------------------- //-->

	<div class="container padding20">
            <form name="formcopiar" id="formcopiar" action="copia_eventoexec.asp" method="post">
            <input type="hidden" name="DEFAULT_LOCATION" value="copia_evento.asp">            
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
                                <div class="span2"><p>Evento Origem:</p></div>
                                <div class="span8">
                                    <p class="input-control select" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    <!-- <select name="COD_EVENTO_ORIGEM" id="COD_EVENTO_ORIGEM" class="textbox380" onChange="document.location='copia_evento.asp?cod_evento_origem='+this.value;">//-->
                                    <select name="var_cod_evento_orig" id="var_cod_evento_origô" onChange="">
                                     <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento ", "COD_EVENTO", "NOME", Session("COD_EVENTO") %>
                                    </select>
                                    <span class="tertiary-text-secondary"></span> 
                                </div>
                            </div>
                            <div class="row">
                                <div class="span2"><p>*Novo Código:</p></div>
                                <div class="span8">
                                    <p class="input-control text" data-role="input-control"><input type="text" name="var_cod_evento" id="var_cod_eventoô" maxlength="3" onKeyPress="return validateNumKey(event);" value="<%=strCOD_EVENTO%>"></p>
                                    <span class="tertiary-text-secondary">Digite "0"(zero) para gerar novo código automatico. </span>
                                </div>
                            </div>ss
                            
                            <div class="row">
                                <div class="span2"><p>*Novo Título:</p></div>
                                <div class="span8">
                                    <p class="input-control text" data-role="input-control"><input type="text" name="var_titulo" id="var_cod_tituloô"  value="" maxlength="50"></p>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                            </div>

							<!-- INI: Check boss ------------------------------------------------- //-->
                            <div class="row">
                                <div class="span2"><p>Copíar também:</p></div>
                                <div class="span8">
                                <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyEvento" id="var_flagCpyEvento" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Evento
                                        </label>
                                    </p>
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyProd" id="var_flagCpyProd" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Produtos
                                        </label>
                                    </p>
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyAreageo" id="var_flagCpyAreageo" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Áreas GEO
                                        </label>
                                    </p>
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyFormSetup" id="var_flagCpyFormSetup" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Form. Setup
                                        </label>
                                    </p>
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyMapeaCampo" id="var_flagCpyMapeaCampo" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Mapea Campos
                                        </label>
                                    </p>
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyFormPgto" id="var_flagCpyFormPgto" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Formas de PGTO
                                        </label>
                                    </p>
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyAreaRestriExpo" id="var_flagCpyAreaRestriExpo" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Area Restr. Expo
                                        </label>
                                    </p>
                                    <p class="input-control checkbox">
                                        <label>
                                            <input name="var_flagCpyAuxServicos" id="var_flagCpyAuxServicos" type="checkbox" value="true" checked/>
                                            <span class="check"></span>Aux. Serviços
                                        </label>
                                    </p>
                                     <br><span class="tertiary-text-secondary">Desmarque o que NÃO for necessário copiar.</span> 
                                </div>
	                        </div>
							<!-- FIM: Check boss ------------------------------------------------- //-->
                        </div>
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
</body>
</html>
<%
FechaRecordSet ObjRS
FechaDBConn ObjConn
%>