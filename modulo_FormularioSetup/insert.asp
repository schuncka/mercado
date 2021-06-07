<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FormularioSetup",Session("METRO_USER_ID_USER")), true %>
<%
  Const LTB = "tbl_formulario_setup"	    		' - Nome da Tabela...
  Const DKN = "id_auto"          				' - Campo chave...
  Const TIT = "FORM SETUP"    						' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresenta��o do modulo no bot�o de filtro

'Relativas a conex�o com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL,prDB
 
 Dim  strIDAUTO ,strCAMPO, strREQUERIDO, strREQCODPAIS, strTABELA, strFORMULARIO,  strCODEVENTO, strETAPA, strVINCULOENT, strORDEM

  
 strIDAUTO = Replace(GetParam("var_chavereg"),"'","''")
 
 'abertura do banco de dados e configura��es de conex�o
 AbreDBConn objConn, CFG_DB 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script type="text/javascript" language="javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ---------
Criando uma condi��o pois na ATHWINDOW temos duas op��es
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
bot�es est�o aptos a retornar para default location�s
corretos em cada op��o de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_FormularioSetup/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_FormularioSetup/insert.asp"; 
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
/* FIM: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ------- */
</script>
</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o t�tulo do m�dulo e a��o da dialog //-->
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
            <li class=""><a href="#SETUP">SETUP</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                	<div class="row ">
                                <div class="span2" style=""><p>C�d. Evento:</p></div>
                                <div class="span8">
                                    <p class="input-control select text" data-role="input-control">
                                        <select name="DBVAR_INT_COD_EVENTO" id="DBVAR_INT_COD_EVENTO" >
                                         <option value="" selected="selected"></option>
                                         <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", SESSION("COD_EVENTO") %>
                                        </select>
                                    </p>                                         
                                     <!--span class="tertiary-text-secondary">(vari�veis de ambiente (session) podem ser utilizadas atrav�s de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2" style=""><p>Tabela:</p></div>
                                <div class="span8">
                                	<p class="input-control select info-state" data-role="input-control"> 
                                        <select name="DBVAR_STR_TABELA" id="DBVAR_STR_TABELA�">
                                        	<option value="tbl_empresas">TBL_EMPRESAS</option>
                                        </select>
                                	</p>
                                </div> 
                     </div>
                	<div class="row">
                                <div class="span2"><p>Campo:</p></div>
                                <div class="span8">
                                    <p class="input-control select info-state" data-role="input-control">
                                        <select name="DBVAR_STR_CAMPO" id="DBVAR_STR_CAMPO�" >
                                             <% montaCombo "STR" ,"SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '"& CFG_DB &"' AND TABLE_NAME = 'tbl_empresas'", "COLUMN_NAME", "COLUMN_NAME", strTABELA %>
                                        </select>
                                    </p>
                                       <!--<span class="tertiary-text-secondary"></span>-->
                                </div>
                    </div>
                    <div class="row ">
                                <div class="span2" style=""><p>Formulario/Etapa:</p></div>
                                <div class="span8">
                                	<div class="input-control select size2 info-state" data-role="input-control">
                                        <p>
                                            <select name="DBVAR_STR_FORMULARIO" id="DBVAR_STR_FORMULARIO�" class="">
                                            <option value="LOJA">LOJA</option>
                                            </select>
                                        </p>
                                	</div>   
                                	<div class="input-control select size2 info-state" data-role="input-control">
                                        <p>
                                            <select name="DBVAR_STR_ETAPA" id="DBVAR_STR_ETAPA�" class="">
                                            <option value="CADASTRO">CADASTRO</option>
                                            </select>
                                        </p>
                                	</div>   
                                     <!--span class="tertiary-text-secondary">(vari�veis de ambiente (session) podem ser utilizadas atrav�s de  chaves - { }).</span//-->  
                                </div>
                    </div>
                    </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            
            <div class="frame" id="SETUP" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                 <div class="row ">
                                <div class="span2"><p>Requerido/Vinc. Entidade:</p></div>
                                <div class="span8">
                                	<div class="input-control select size2" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                        <p>
                                            <select name="DBVAR_STR_REQUERIDO" id="DBVAR_STR_REQUERIDO" class="">
                                            <option value="1" >Sim</option>
                                            <option value="0" selected>N�o</option>
                                            </select>
                                        </p>
                                    </div>
                                	<div class="input-control select size2" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                        <p>                                    
                                            <select name="DBVAR_STR_VINCULADO_ENTIDADE" id="DBVAR_STR_VINCULADO_ENTIDADE" class="">
                                            <option value="1"  selected>Sim</option>
                                            <option value="0" >N�o</option>
                                            </select>
                                        </p>
                                    </div>
                                    <span class="tertiary-text-secondary">(exibir na loja /Requerimento do campo )</span> 
                                </div>
                     </div>
                     <div class="row ">
                                <div class="span2" style=""><p>Requerido Cod. Pais:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_REQUERIDO_COD_PAIS" name="DBVAR_STR_REQUERIDO_COD_PAIS" type="text" placeholder="" value="" maxlength="100"></p>
                                     <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div>
                     <div class="row ">
                                <div class="span2" style=""><p>Ordem:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input id="DBVAR_NUM_ORDEM" name="DBVAR_NUM_ORDEM" type="text" placeholder="n�mero" value="" maxlength="10" onKeyPress="return validateNumKey(event);"></p>
                                     <!--span class="tertiary-text-secondary">(vari�veis de ambiente (session) podem ser utilizadas atrav�s de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                                           
            	</div><!--fim grid//-->
            </div><!--fim frame layout//-->
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    
    <div style="padding-top:16px;"><!--INI: BOT�ES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
            <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e (*)</strong> campos obrigat�rios</small>
        </div> 
    </div><!--FIM: BOT�ES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
<%
	  FechaDBConn objConn
  
 'athDebug strSQL, true '---para testes'
%>