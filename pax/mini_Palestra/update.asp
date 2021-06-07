<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|UPD|", BuscaDireitosFromDB("mini_Palestra",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_PRODUTOS_PALESTRANTE" ' - Nome da Tabela...
 Const DKN = "IDAUTO"			      	' - Campo chave...
 Const TIT = "Palestra"     			' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
  
'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage

 Dim strIDINFO

 strIDINFO = GetParam("var_chavereg")

 AbreDBConn objConn, CFG_DB

		  strSQL = " SELECT     IDAUTO "
 strSQL = strSQL & "		  , CONFIRMADO "		  
 strSQL = strSQL & "		  , COD_PALESTRANTE "
 strSQL = strSQL & "		  , FUNCAO "
 strSQL = strSQL & "		  , TEMA "
 strSQL = strSQL & "  FROM " & LTB 
 strSQL = strSQL & " WHERE IDAUTO = " & strIDINFO

 'athDebug strSQL, false
 	
 'set objRS = objConn.execute(strSQL)
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
%>
<html>
<head>
<title>Mercado</title>
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../pax/mini_Palestra/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Evento/mini_Palestra/update.asp?var_chavereg=<%=strIDINFO%>"; 
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
		<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strIDINFO%>">
        <input type="hidden" name="DEFAULT_LOCATION" value="">
        <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
        <input type="hidden" name="DBVAR_NUM_COD_EVENTO" id="DBVAR_NUM_COD_EVENTO" value="<%=getValue(objRS,"COD_EVENTO")%>">

        <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strIDINFO%>.GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>Função:&nbsp;</p></div>
                                <div class="span8">
                                     <p><%=getValue(objRS,"FUNCAO")%></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Tema:&nbsp;</p></div>
                                <div class="span8">
                                     <p><%=getValue(objRS,"TEMA")%></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Confirmar presença</p></div>
                                <div class="span8">
                                     <div class="input-control text select size2" data-role="input-control">
                                     	<p>
                                            <select name="DBVAR_STR_LOJA_SHOW" id="DBVAR_STR_LOJA_SHOW" class="">
                                                <option value="" <%IF getValue(objRS,"LOJA_SHOW") = "" THEN RESPONSE.Write("selected")%>></option>
                                                <option value="1" <%IF getValue(objRS,"LOJA_SHOW")= "1" THEN RESPONSE.Write("selected")%>>Sim</option>
                                                <option value="0" <%IF getValue(objRS,"LOJA_SHOW")= "0" THEN RESPONSE.Write("selected")%>>Não</option>
                                            </select>
										</p>
                                     </div>
                                     <span class="tertiary-text-secondary"><br>Obs.: depois de confirmada ou negada a presençao não poderá masi ser editada</span>
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
%>