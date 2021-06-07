<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CfgPanel", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 Const LTB = "tbl_mapeamento_campo"	    				' - Nome da Tabela...
 Const DKN = "cod_mapeamento_campo"          			' - Campo chave...
 Const TIT = "MapeamentoCampo"    						' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 
 Dim  strCODMAPEA, strNOMECAMPOCLI, strNOMECAMPOPRO, strNOMEDESCRI, strNOMEDESCRIUS, strNOMEDESCRIES  
 Dim  strVINCULOENTI, strCAMPOINSTRU, strCODEVENTO, strLOJASHOW, strCAMPOCOMBOLIST, strCAMPOREQ, strCAMPOCOR 
 Dim  strCAMPOTIPO, strTIPO, strTIPOPESS, strINCLUIRBUSCA
 

%>
<!DOCTYPE html>
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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_CfgPanel/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_CfgPanel/insert.asp"; 
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro" id="metrotablevista" >
<!-- Barra escura que contem o nome da dialog//-->
<nav class="navigation-bar light">
    <div class="navigation-bar-content">
    	<span class="element">&nbsp;<%=TIT%><sup>INSERT</sup></span>
    </div>
</nav>
<!-- FIM -------------------------------Barra//-->
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
            <li class=""><a href="#MAPEAMENTO">MAPEAMENTO</a></li>
            <li class=""><a href="#MAPEAMENTO2">MAPEAMENTO2</a></li>            
            <!-- li class=""><a href="#AJUDA">AJUDA</a></li //-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>*Nome Cliente</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_NOME_CAMPO_CLIENTEô" name="DBVAR_STR_NOME_CAMPO_CLIENTEô" type="text" placeholder="Ex: 'VIP' ou 'Verificar Cadastro'" value="" maxlength="100"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Nome Campo PRO:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_NOME_CAMPO_PROEVENTO" name="DBVAR_STR_NOME_CAMPO_PROEVENTO" type="text" placeholder="Ex: 'EXTRA_TXT_1'" value="" maxlength="100"></p>
                                     <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Nome Descritivo:</p></div>
                                <div class="span8">  
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_NOME_DESCRITIVOô" name="DBVAR_STR_NOME_DESCRITIVOô" type="text" placeholder="" value="" maxlength="120"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div> 
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Cod Evento:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input id="DBVAR_STR_COD_EVENTO" name="DBVAR_STR_COD_EVENTO" type="text" placeholder="ex." value="" maxlength="11" ></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div> 
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            
            <div class="frame" id="MAPEAMENTO" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                  <div class="row ">
                                <div class="span2"><p>Loja Show/Campo Req.:</p></div>
                                <div class="span8"><p class="input-control select" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    <select name="DBVAR_STR_LOJA_SHOW" id="DBVAR_STR_LOJA_SHOW" class="size2">
                                    <option value="sim" selected>Sim</option>
                                    <option value="">Não</option>
                                    </select>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <select name="DBVAR_STR_CAMPO_REQUERIDO" id="DBVAR_STR_CAMPO_REQUERIDO" class="size2">
                                    <option value="sim" selected>Sim</option>
                                    <option value="">Não</option>
                                    </select></p>
                                    <span class="tertiary-text-secondary">(exibir na loja /Requerimento do campo )</span> 
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Combo Lista</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_NOME_CAMPO_COMBOLISTô" name="DBVAR_STR_NOME_CAMPO_COMBOLISTô" type="text" placeholder="Ex: teste_cadastro.txt " value="" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Cor Destaque:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_NOME_CAMPO_COR_DESTAQUE" name="DBVAR_STR_NOME_CAMPO_COR_DESTAQUE" type="text" placeholder="Ex: '#F2F2F2' " value="" maxlength="45"></p>
                                     <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Campo Tipo/Tipo:</p></div>
                                <div class="span8">  
                                     <p class="input-control text " data-role="input-control"><input class="size2" id="DBVAR_STR_CAMPO_TIPOô" name="DBVAR_STR_CAMPO_TIPOô" type="text" placeholder="" value="" maxlength="45"> <!--dois inputs na mesma linha//-->
                                     &nbsp;&nbsp;&nbsp;&nbsp;<input class="size2" id="DBVAR_STR_TIPO" name="DBVAR_STR_TIPO" type="text" placeholder="ex. PJ ou PF" value="" maxlength="2" ></p>                                     
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>TipoPess:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text " data-role="input-control"><input class="size2" id="DBVAR_STR_TIPOPESS" name="DBVAR_STR_TIPOPESS" type="text" placeholder="ex. " value="" maxlength="1" ></p>                           
                                </div>
                     </div> 
            	</div><!--fim grid layout//-->
            </div><!--fim frame layout//-->
            <div class="frame" id="MAPEAMENTO2" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>Nome Descritovo US</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_NOME_DESCRITIVO_US" name="DBVAR_STR_NOME_DESCRITIVO_US" type="text" placeholder="Ex: " value="" maxlength="120"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
<div class="row">
                                <div class="span2"><p>Nome Descritovo ES</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_NOME_DESCRITIVO_ES" name="DBVAR_STR_NOME_DESCRITIVO_ES" type="text" placeholder="Ex: " value="" maxlength="120"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Vinculo Ent./ Campo Instrução:</p></div>
                                <div class="span8"><p>
                                    <p class="input-control select" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    <select name="DBVAR_STR_VINCULADO_ENTIDADE" id="DBVAR_STR_VINCULADO_ENTIDADE" class="size3">
                                    <option value="1" selected>Sim</option>
                                    <option value="0">Não</option>
                                    </select></p>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <p class="input-control textarea"><textarea class="input-control textarea size3" id="DBVAR_STR_CAMPO_INSTRUCAOô" name="DBVAR_STR_CAMPO_TIPOô" type="text" placeholder="EX: texto de instrução para criação do campo." value="" maxlength="45"></textarea></p>
                                    </p> <!--dois inputs na mesma linha//-->
                                </div> 
                     </div> 
                     
                    
            	</div><!--fim grid layout//-->
            </div><!--fim frame layout//-->
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
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigat&oacute;rios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
