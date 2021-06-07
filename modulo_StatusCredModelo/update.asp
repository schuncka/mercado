<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_StatusCresModelo",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_status_cred_modelo"	    				' - Nome da Tabela...
 Const DKN = "cod_status_cred_modelo"          				' - Campo chave...
 Const TIT = "Status Cred Modelo"    						' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Relativas a FILTRAGEM e Seleção	
 Dim  i
 Dim  strCOD_STATUS_CRED_MODELO,strCOD_EVENTO,strCOD_STATUS_CRED,strMODELO_NOME,strMODELO_LAYOUT

 
 strCOD_STATUS_CRED_MODELO = Replace(GetParam("var_chavereg"),"'","''")
 

 'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
 
 ' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		 
 strSQL = " select COD_STATUS_CRED_MODELO "
 strSQL = strSQL & "		  ,COD_EVENTO "
 strSQL = strSQL & "		  ,COD_STATUS_CRED "
 strSQL = strSQL & "		  ,MODELO_NOME "
 strSQL = strSQL & "		  ,MODELO_LAYOUT "
 strSQL = strSQL & "    FROM " & LTB 
 strSQL = strSQL & "    WHERE COD_STATUS_CRED_MODELO = " & strCOD_STATUS_CRED_MODELO
 strSQL = strSQL & "    ORDER BY COD_STATUS_CRED_MODELO"
 '-----------------------------------------------------------------------------------------------------------------
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<!-- funções para action dos botões OK, APLICAR,CANCELAR  e NOTIFICAÇÂO//-->
<script type="text/javascript" language="javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() {
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_StatusCredModelo/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %>  
	/*document.formupdate.DEFAULT_LOCATION.value="../_database/athWindowClose.asp"; */
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_StatusCredModelo/update.asp?var_chavereg=<%=strCOD_STATUS_CRED_MODELO%>"; 
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
</script>
<!-- FIM----------------------------------------- funções //-->

</head>
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
                <form name="formupdate" id="formupdate" action="../_database/athupdatetodb.asp" method="post">
                <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
                <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_STATUS_CRED_MODELO%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
                
                
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_STATUS_CRED_MODELO%>.GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="row ">
                                    <div class="span2"><p>Cód. Evento:</p></div>
                                    <div class="span8"><p class="input-control select" data-role="input-control"> 
                                         <select name="DBVAR_NUM_COD_EVENTO" id="DBVAR_NUM_COD_EVENTO" >
                                             <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) as NOME FROM tbl_EVENTO", "COD_EVENTO", "NOME", GetValue(objRS,"COD_EVENTO") %>
                                            </select></p>
                                         <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                    </div> 
                    </div>
                    <div class="row ">
                                    <div class="span2"><p>Cód. Status Cred:</p></div>
                                    <div class="span8"><p class="input-control select" data-role="input-control"> 
                                         <select name="DBVAR_NUM_COD_STATUS_CRED" id="DBVAR_NUM_COD_STATUS_CRED" >
                                             <% montaCombo "STR" ,"SELECT COD_STATUS_CRED, CONCAT(CAST(COD_STATUS_CRED AS CHAR), ' - ', CAST(STATUS AS CHAR)) AS STATUS FROM tbl_status_cred ORDER BY COD_STATUS_CRED", "COD_STATUS_CRED", "STATUS", GetValue(objRS,"COD_STATUS_CRED") %>
                                            </select></p>
                                         <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                    </div> 
                    </div>
                     <div class="row ">
                                <div class="span2"><p>Modelo Nome:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_MODELO_NOME" name="DBVAR_STR_MODELO_NOME" type="text" placeholder="" value="<%=GetValue(objRS,"MODELO_NOME")%>" maxlength="80"></p>
                                     <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div>
                      <div class="row ">
                                <div class="span2"><p>Modelo Layout:</p></div>
                                <div class="span8"> 
                                     <p class="input-control textarea " ><textarea id="DBVAR_STR_MODELO_LAYOUT" name="DBVAR_STR_MODELO_LAYOUT" type="text" ><%=GetValue(objRS,"MODELO_LAYOUT")%></textarea></p>
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
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> Campos Obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>