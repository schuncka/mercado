<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("mini_CfgLinks",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "TBL_EVENTO_LINK" 								' - Nome da Tabela...
 Const DKN = "COD_EVENTO_LINK"									' - Campo chave...
 Const TIT = "CFG Link"		
 
 Dim objConn, objRS, strSQL
Dim  strCODLINK, strCOD_EVENTO

'Carraga os valores das varíáveis enviadaos pelo filtro 
'---------------carrega cachereg do pai local cred-----------------
strCODLINK 		= Replace(GetParam("var_chavereg"),"'","''")
strCOD_EVENTO	= Replace(GetParam("var_cod_evento"),"'","''")

'------------------------------------------------------------------

If strCODLINK <> "" Then
	
	AbreDBConn objConn, CFG_DB
	
	strSQL = " SELECT COD_EVENTO_LINK "
	 strSQL = strSQL & "		  , COD_EVENTO "
	 strSQL = strSQL & "		  , TITULO "
	 strSQL = strSQL & "		  , URL "
	 strSQL = strSQL & "		  , TIPO "
	 strSQL = strSQL & "		  , IDIOMA "
	strSQL = strSQL & "   FROM TBL_EVENTO_LINK " 
	strSQL = strSQL & "   WHERE COD_EVENTO_LINK = " & strCODLINK 
	strSQL = strSQL & "	  ORDER BY 1 " 

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
	
	
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Evento/mini_CfgLinks/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Evento/mini_CfgLinks/update.asp?var_chavereg=<%=strCODLINK%>&var_cod_evento=<%=strCOD_EVENTO%>"; 
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
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	 <form name="formupdate" id="formupdate" action="../../_database/athupdatetodb.asp" method="post">
		<input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
        <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
        <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
        <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
		 <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODLINK%>">
        <input type="hidden" name="DEFAULT_LOCATION" value="">
        <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
        <input type="hidden" name="DBVAR_NUM_COD_EVENTO" id="DBVAR_NUM_COD_EVENTO" value="<%=getValue(objRS,"COD_EVENTO")%>">
         <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCODLINK%>.GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                   
                    <div class="row">
                                <div class="span2"><p>Titulo:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input type="text" name="DBVAR_STR_TITULO" id="DBVAR_STR_TITULO" value="<%=getValue(objRS,"TITULO")%>" maxlength="250"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>URL:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control textarea" data-role="input-control"><textarea type="text"  name="DBVAR_STR_URL" id="DBVAR_STR_URL" ><%=getValue(objRS,"URL")%></textarea></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Tipo:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text select" data-role="input-control"> 
                                     <select id="DBVAR_STR_TIPO" name="DBVAR_STR_TIPO" onChange="">                                 
                                     <option value="" <%if getValue(objRS,"TIPO") = "" then response.write("selected")%>>Selecione:</option>                                 	
                                     <option value="SHOPPJ"<%if getValue(objRS,"TIPO") = "SHOPPJ" then response.write("selected")%>>Loja Pessoa Juridíca(SHOPPJ)</option>                                 
                                     <option value="SHOPPF" <%if getValue(objRS,"TIPO") = "SHOPPF" then response.write("selected")%>>Loja Pessoa Física(SHOPPF)</option>                                 
                                     <option value="SHOPPJ3" <%if getValue(objRS,"TIPO") = "SHOPPJ3" then response.write("selected")%>>Loja Pessoa Jurídica 3(SHOPPJ3)</option>                                 	
                                     <option value="PSCPJ" <%if getValue(objRS,"TIPO") = "PSCPJ" then response.write("selected")%>>Loja de Pedido de Credencial de Pessoa Jurídica(PSCPJ)</option>                                 
                                     <option value="PSCPF" <%if getValue(objRS,"TIPO") = "PSCPF" then response.write("selected")%>>Loja de Pedido de Credencial de Pessoa Física(PSCPF)</option>                                 
                                     <option value="PSCPJ3" <%if getValue(objRS,"TIPO") = "PSCPJ3" then response.write("selected")%>>Loja de Pedido de Credencial de Pessoa Jurídica 3(PSCPJ3)</option>                                 
                                     <option value="SUBPAPER" <%if getValue(objRS,"TIPO") = "SUBPAPER" then response.write("selected")%>>Loja de Envio de Trabalhos Cientificos(SUBPAPER)</option>                                 				
                                     </select></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Idioma:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text select " data-role="input-control">
                                     <select id="DBVAR_STR_IDIOMA" name="DBVAR_STR_IDIOMA" onChange="">
                                     <option value="" <%if getValue(objRS,"IDIOMA") = "" then response.write("selected")%>>Selecione:</option>
                                     <option value="BR"<%if getValue(objRS,"IDIOMA") = "BR" then response.write("selected")%>>Portuguese(BR)</option>
                                     <option value="EN"<%if getValue(objRS,"IDIOMA") = "EN" then response.write("selected")%>>Eglish(EN)</option>
                                     <option value="ES"<%if getValue(objRS,"IDIOMA") = "ES" then response.write("selected")%>>Espanhol(ES)</option>
                                     </select></p>
                                     <span class="tertiary-text-secondary"></span>
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
end if	
	'athDebug strSQL, true '---para testes'
%>                     
                                            
	 					  		 