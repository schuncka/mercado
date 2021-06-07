<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_ListaCategoria",Session("METRO_USER_ID_USER")), true %>
<%

 Const LTB = "tbl_STATUS_PRECO" 								' - Nome da Tabela...
 Const DKN = "COD_RPS_EVENTO"									' - Campo chave...
 Const TIT = "LISTA CATEGORIA"									' - Nome/Titulo sendo referencia como titulo do m�dulo no bot�o de filtro
 

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
/* INI: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ---------
Criando uma condi��o pois na ATHWINDOW temos duas op��es
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
bot�es est�o aptos a retornar para default location�s
corretos em cada op��o de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Evento/mini_ListaCategoria/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      {  
  document.forminsert.DEFAULT_LOCATION.value="../modulo_Evento/mini_ListaCategoria/insert.asp?var_cod_evento=<%=strCOD_EVENTO%>"; 
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
            <li class="#"><a href="#EXTRA">EXTA</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="row">
                                <div class="span2"><p>Status:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_STATUS" id="DBVAR_STR_STATUS" value="" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Status Intl:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_STATUS_INTL" id="DBVAR_STR_STATUS_INTL" value="" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Observa��o:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_OBSERVACAO" id="DBVAR_STR_OBSERVACAO" value="" maxlength="255"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Senha:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="password" name="DBVAR_STR_SENHA" id="DBVAR_STR_SENHA" value="" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     
                     <div class="row">
                                <div class="span2"><p>Loja Show/Entid.Obrigat�ria:&nbsp;</p></div>
                                <div class="span8">
                                     <div class="input-control text select size2" data-role="input-control">
                                         <p>
                                             <select name="DBVAR_STR_LOJA_SHOW" id="DBVAR_STR_LOJA_SHOW" class="">
                                                 <option value="1">Sim</option>
                                                 <option value="0" selected>N�o</option>
                                             </select>
                                        </p>
                                    </div>
                                     <div class="input-control text select size2" data-role="input-control">
                                        <p>                                    
                                            <select name="DBVAR_STR_ENTIDADE_OBRIGATORIO" id="DBVAR_STR_ENTIDADE_OBRIGATORIO" class="">
                                                <option value="1">Sim</option>
                                                <option value="0" selected>N�o</option>
                                            </select>
                                         </p>
                                     </div>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>          
                      </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            <div class="frame" id="EXTRA" style="width:100%;">
            <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00"> 
                  	<div class="row">
                                <div class="span2"><p>Status Credencial:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_STATUS_CREDENCIAL" id="DBVAR_STR_STATUS_CREDENCIAL" value="" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                        <div class="span2"><p>C�digo Pa�s:&nbsp;</p></div>
                        <div class="span8">
                            <p class="input-control select " data-role="input-control">
                                <select name="DBVAR_STR_COD_PAIS" id="DBVAR_STR_COD_PAIS"> 
                                <option value="US">US</option>
                                <option value="ES">ES</option>
                                <option value="BR" selected>BR</option>
                                </select>
                            </p>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div> 
                    
                     <div class="row">
                                <div class="span2"><p>Cod Status Pre�o Referencial:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control">
                                     	<input type="text"  name="DBVAR_NUM_COD_STATUS_PRECO_REFERENCIA" id="DBVAR_NUM_COD_STATUS_PRECO_REFERENCIA" maxlength="11" onKeyPress="return validateNumKey(event);">
                                        </p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Ordem:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input type="text"  name="DBVAR_NUM_ORDEM" id="DBVAR_NUM_ORDEM" maxlength="11" onKeyPress="return validateNumKey(event);"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                        <div class="row">
                                <div class="span2"><p>Caex Show/Upload Comprovante:&nbsp;</p></div>
                                <div class="span8">
                                     <div class="input-control text select size2" data-role="input-control">
                                         <p>
                                             <select name="DBVAR_STR_CAEX_SHOW" id="DBVAR_STR_CAEX_SHOW" class="">
                                            <option value="1"  >Sim</option>
                                            <option value="0" selected>N�o</option>
                                            </select>
                                         </p>
                                     </div>
                                     <div class="input-control text select size2" data-role="input-control">                                     
                                         <p>                                                                                                                  
                                            <select name="DBVAR_STR_UPLOAD_COMPROVANTE" id="DBVAR_STR_UPLOAD_COMPROVANTE" class="">
                                            <option value="1"  >Sim</option>
                                            <option value="0" selected>N�o</option>
                                            </select>
                                         </p>
                                      </div>   
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>                                               
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    
    <div style="padding-top:16px;"><!--INI: BOT�ES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigat�rios</small>
        </div> 
    </div><!--FIM: BOT�ES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>                    
