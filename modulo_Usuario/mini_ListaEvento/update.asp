<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("mini_ListaEvento",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_usuario_evento" 		' - Nome da Tabela...
 Const DKN = "COD_USUARIO_EVENTO" 		' - Campo chave...
 Const TIT = "Lista Evento" 					' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro
 
 Dim objConn, objRS, strSQL
 Dim  strCOD_USUARIO ,strCOD_USUARIOLISTA

'strCOD_USUARIO  = Replace(GetParam("var_chavemaster"),"'","''")

strCOD_USUARIOLISTA = Replace(GetParam("var_chavereg"),"'","''")


'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB  
 
' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
	'strSQL =          " SELECT COD_USUARIO "
'	strSQL = strSQL & "  ,COD_EVENTO "
'	strSQL = strSQL & "  ,COD_LOCAL_CREDENCIAL_SITE "	
'	strSQL = strSQL & "    FROM " & LTB 
'	strSQL = strSQL & "  WHERE COD_USUARIO =  " & strCOD_USUARIOLISTA	
'	athDebug strSQL , false

    		  strSQL = " SELECT E.COD_EVENTO "
	'strSQL = strSQL & "  ,E.NOME "
	strSQL = strSQL & "  ,E.NOME_COMPLETO "	
	strSQL = strSQL & "  ,U.COD_USUARIO"
	strSQL = strSQL & "  ,UE.COD_LOCAL_CREDENCIAL_SITE"
	strSQL = strSQL & "  FROM "&LTB&" UE, tbl_Evento E,tbl_Usuario U " 
	strSQL = strSQL & "  WHERE U.COD_USUARIO =  " & strCOD_USUARIOLISTA
	strSQL = strSQL & "  AND E.COD_EVENTO = UE.COD_EVENTO "
	'strSQL = strSQL & "  AND UE.COD_EVENTO = " & Session("COD_EVENTO")
	strSQL = strSQL & "  AND UE.COD_USUARIO = " & strCOD_USUARIOLISTA
	'strSQL = strSQL & "  AND ( (E.COD_EVENTO LIKE '" & session("METRO_EVENTO_COD_EVENTO") & "') OR (E.COD_EVENTO IS NULL) OR (E.COD_EVENTO LIKE '') )"
 	strSQL = strSQL & "  ORDER BY UE.COD_LOCAL_CREDENCIAL_SITE"
	'athDebug strSQL , false
	   
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
 <%
 	 if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Usuario/mini_ListaEvento/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Usuario/mini_ListaEvento/update.asp?var_chavereg=<%=strCOD_USUARIOLISTA%>"; 
  if (validateRequestedFields("formupdate")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.formupdate.submit(); 
  }
}
function cancelar() { 
 <% 
 	if (CFG_WINDOW = "NORMAL") then 
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
		 <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_USUARIOLISTA%>">
        <input type="hidden" name="DEFAULT_LOCATION" value="">
        <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">

    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_USUARIOLISTA%>.GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                	<div class="row ">
                                <div class="span2" style=""><p>*Cód. Evento:</p></div>
                                <div class="span8"><p class="input-control select text" data-role="input-control">
                                     <select name="DBVAR_NUM_COD_EVENTOô" id="DBVAR_NUM_COD_EVENTOô" >
                                         <option value="" selected="selected"></option>
                                         <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", GetValue(objRS,"COD_EVENTO")%>
                                    	</select></p>                                         
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2" style=""><p>*Cód.Usuario:</p></div>
                                <div class="span8"><p class="input-control select text" data-role="input-control">
                                     <select name="DBVAR_NUM_COD_USUARIOô" id="DBVAR_NUM_COD_USUARIOô" >
                                         <option value="" selected="selected"></option>
                                         <% montaCombo "STR","SELECT distinct COD_USUARIO FROM tbl_usuario_EVENTO order BY 1","COD_USUARIO","COD_USUARIO", GetValue(objRS,"COD_USUARIO") %>
                                    	</select></p>                                         
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
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
	'athDebug strSQL, true '---para testes'
%>