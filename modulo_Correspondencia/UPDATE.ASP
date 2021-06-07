<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_Cadastro",Session("ID_USER")), true %>
<%

 Const LTB = "TBL_EVENTO_CORRESP"	   	 ' - Nome da Tabela...
 Const DKN = "ID_AUTO"          ' - Campo chave...
 Const TIT = "Correspondencia"   		 ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

 
'Relativas a conexão com DB, RecordSet e SQL
Dim objConn, objRS, strSQL,strSQL2,strSQL3,objRSDetail
'Relativas a FILTRAGEM e Seleção	
Dim  strID_AUTO

AbreDBConn objConn, CFG_DB	
	
	strID_AUTO = Replace(Request("var_chavereg"),"'","''")

'-----------------------------------------------------------------------------------------
		strSQL = " SELECT     ID_AUTO "	
	strSQL = strSQL & "		  ,COD_EVENTO "
	strSQL = strSQL & "		  ,TITLE "
	strSQL = strSQL & "		  ,TEXTO "
	strSQL = strSQL & "		  ,RESUMO "
	strSQL = strSQL & "		  ,TIPO "
	strSQL = strSQL & "		  ,DT_INATIVO "
	strSQL = strSQL & "		  ,COD_EMPRESA "
	strSQL = strSQL & "  FROM "& LTB 	
	strSQL = strSQL & " WHERE ID_AUTO = " & strID_AUTO 	
		
		'athDebug strSQL, true	 	 
'------------------------------------------------------------------------------------------
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script src="metro-calendar.js"></script>
<script src="metro-datepicker.js"></script>
<!-- funções para action dos botões OK, APLICAR,CANCELAR  e NOTIFICAÇÂO//-->
<script type="text/javascript" language="javascript">
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() {
 <% 
 	if (CFG_WINDOW = "NORMAL") then 
		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Correspondencia/default.asp';") 
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
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Correspondencia/update.asp?var_chavereg=<%=strID_AUTO%>"; 
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

</script>
<script language="javascript" type="text/javascript">
//função para ativar o date picker dos campos data
$("#datepicker").datepicker({
date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer já  ele modifica automaticamente para data setada dentro da função//-->
format: "dd/mm/yyyy", // set output format
effect: "none", // none, slide, fade
position: "bottom", // top or bottom,
locale: ''en, // 'ru' or 'en', default is $.Metro.currentLocale
});
</script>
<!-- FIM----------------------------------------- funções //-->
</head>
<body class="metro" id="metrotablevista">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding5 ">
<!--div class TAB CONTROL --------------------------------------------------//-->
    <form name="formupdate" id="formupdate" action="../_database/athupdatetodb.asp" method="post">
    <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
    <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
    <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">	
    <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
    <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strID_AUTO%>">
    <input type="hidden" name="DEFAULT_LOCATION" value="">
    <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
		<div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
            <li class=""><a href="#RESUMO">RESUMO</a></li>                           
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                	<div class="row ">
                        <div class="span2" style=""><p>Cód. Evento:</p></div>
                        <div class="span8">
                            <p class="input-control select text" data-role="input-control">
                                <select name="DBVAR_INT_COD_EVENTO" id="DBVAR_INT_COD_EVENTO" >
                                 <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", getValue(objRS,"COD_EVENTO")%>
                                </select>
                            </p>                                         
                             <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                        </div> 
                     </div>                	
                    <div class="row">
                        <div class="span2"><p>*Titulo:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                    <input id="DBVAR_STR_TITLEô" name="DBVAR_STR_TITLEô" type="text" placeholder="" value="<%=getValue(objRS,"TITLE")%>" maxlength="250" >
                                </p>
                            </div>
                            <span class="tertiary-text-secondary">(end_logr)</span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>*Texto:</p></div>
                        <div class="span8"> 
                            <div class="input-control textarea " data-role="input-control">
                                <p>
                                    <textarea id="DBVAR_STR_TEXTOô" name="DBVAR_STR_TEXTOô" type="text" placeholder="" ><%=getValue(objRS,"TEXTO")%></textarea>
                                </p>
                                <span class="tertiary-text-secondary">(end_cidade)</span>
                            </div>                                                 
                        </div>
                    </div>    
                    <div class="row">
                        <div class="span2"><p>*Tipo:</p></div>
                        <div class="span8">
                            <div class="">
                                <p class="input-control select " data-role="input-control">
                                    <select  id="DBVAR_STR_TIPO" name="DBVAR_STR_TIPO" type="text">
                                        <option value=""   <%If getValue(objRS,"TIPO") = "" then response.Write("selected")%>>Todos</option>
                                        <option value="EXPOSITOR"  <%If getValue(objRS,"TIPO") = "EXPOSITOR" then response.Write("selected")%>>Expositor</option>
                                        <option value="MONTADOR"   <%If getValue(objRS,"TIPO") = "MONTADOR" then response.Write("selected")%>>Montador</option>
                                        <option value="PALESTRANTE" <%If getValue(objRS,"TIPO") = "PALESTRANTE" then response.Write("selected")%>>Palestrante</option>
                                    </select>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>                                                 
                        </div>
                    </div>         
                </div><!--fim grid geral//-->
            </div><!--fim frame dados//-->
            <div class="frame" id="RESUMO" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                   <div class="row">
                        <div class="span2"><p>Resumo:</p></div>
                        <div class="span8"> 
                            <div class="input-control textarea " data-role="input-control">
                                <p>
                                    <textarea id="DBVAR_STR_RESUMO" name="DBVAR_STR_RESUMO" type="text" placeholder="" ><%=getValue(objRS,"RESUMO")%></textarea>
                                </p>
                                <span class="tertiary-text-secondary">(end_cidade)</span>
                            </div>                                                 
                        </div>
                    </div>   
                    <div class="row">
                        <div class="span2"><p>Cod. Empresa:</p></div>
                        <div class="span8">
                            <div class="">
                                <p class="input-control text" data-role="input-control">
                                   <input id="DBVAR_STR_COD_EMPRESA" name="DBVAR_STR_COD_EMPRESA" type="text" placeholder="" value="<%=getValue(objRS,"COD_EMPRESA")%>" maxlength="6" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>                                                 
                        </div>
                    </div>      
                    <div class="row">
                        <div class="span2"><p>Ativos(DT_INATIVO):</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO"  type="radio" value="" <%If getValue(objRS,"DT_INATIVO") = "" then response.Write("checked")%>>
                                    Sim 
                                <input name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO2" type="radio" value="<%=Now()%>" <%If getValue(objRS,"DT_INATIVO") <> "" then response.Write("checked")%>>
                                    Não 
                            </p>
                            <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>
                </div><!--fim grid geral//-->
            </div><!--fim frame dados//-->
  
<!--INI aba entidade ------------------------------------------------------------------------------------------------>               

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
