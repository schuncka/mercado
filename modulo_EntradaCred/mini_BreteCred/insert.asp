<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_BreteCred",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "TBL_LOCAL_CREDENCIAL_SITE" 		' - Nome da Tabela...
 Const DKN = "COD_LOCAL_CREDENCIAL_SITE" 		' - Campo chave...
 Const TIT = "LCredencialSite" 					' - Nome/Titulo sendo referencia como titulo do m�dulo no bot�o de filtro

 Dim  strCODLOCALCREDENCIAL 

 strCODLOCALCREDENCIAL = Replace(GetParam("var_chavemaster"),"'","''")
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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_EntradaCred/mini_BreteCred/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_EntradaCred/mini_BreteCred/insert.asp?var_chavemaster=<%=strCODLOCALCREDENCIAL%>"; 
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
		<input type="hidden" name="DEFAULT_TABLE"	 value="<%=LTB%>">
		<input type="hidden" name="DEFAULT_DB"		 value="<%=CFG_DB%>">
		<input type="hidden" name="FIELD_PREFIX" 	 value="DBVAR_">
		<input type="hidden" name="RECORD_KEY_NAME"	 value="<%=DKN%>">
		<input type="hidden" name="DEFAULT_LOCATION" value="">
		<input type="hidden" name="DBVAR_STR_COD_LOCAL_CREDENCIAL" value="<%=strCODLOCALCREDENCIAL%>">

    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                	<div class="row ">
                                <div class="span2" style=""><p>C�d. Evento:</p></div>
                                <div class="span8"><p class="input-control select text" data-role="input-control">
                                     <select name="DBVAR_STR_COD_EVENTO" id="DBVAR_STR_COD_EVENTO" >
                                         <option value="" selected="selected"></option>
                                         <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL AND COD_EVENTO LIKE '"& SESSION("METRO_EVENTO_COD_EVENTO") & "'", "COD_EVENTO", "NOME", SESSION("METRO_EVENTO_COD_EVENTO") %>
                                    	</select></p>                                         
                                     <!--span class="tertiary-text-secondary">(vari�veis de ambiente (session) podem ser utilizadas atrav�s de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row">
                                <div class="span2"><p>*Nome:</p></div>
                                <div class="span8">
                                     <p class="input-control text info-state" data-role="input-control"><input id="DBVAR_STR_NOME�" name="DBVAR_STR_NOME�" type="text" placeholder="" value="" maxlength="120"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Local:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text info-state" data-role="input-control"><input id="DBVAR_STR_LOCAL�" name="DBVAR_STR_LOCAL�" type="text" placeholder="" value="" maxlength="120"></p>
                                     <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div> 
                     <div class="row">
                                <div class="span2" style=""><p>Observa��o:</p></div>
                                <div class="span8">  
                                     <p class="input-control text" data-role="input-control"><input id="DBVAR_STR_OBS" name="DBVAR_STR_OBS" type="text"  placeholder="" value=""></p>
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
            <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e (*)</strong> campos obrigat�rios</small>
        </div> 
    </div><!--FIM: BOT�ES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>