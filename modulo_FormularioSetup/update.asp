<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FormularioSetup",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_formulario_setup"	    				' - Nome da Tabela...
 Const DKN = "idauto"          			' - Campo chave...
 Const TIT = "FORM SETUP"    						' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL

 
 Dim  strIDAUTO ,strCAMPO, strREQUERIDO, strREQCODPAIS, strTABELA, strFORMULARIO,  strCODEVENTO, strETAPA, strVINCULOENT, strORDEM
  
  
 strIDAUTO = Replace(GetParam("var_chavereg"),"'","''")
 
  
'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
 
' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     idauto "
 strSQL = strSQL & "		  , CAMPO"
 strSQL = strSQL & "		  , REQUERIDO "
 strSQL = strSQL & "		  , REQUERIDO_COD_PAIS "
 strSQL = strSQL & "		  , TABELA " 
 strSQL = strSQL & "		  , FORMULARIO " 
 strSQL = strSQL & "		  , COD_EVENTO"
 strSQL = strSQL & "		  , ETAPA"
 strSQL = strSQL & "		  , VINCULADO_ENTIDADE"
 strSQL = strSQL & "		  , ORDEM"
 strSQL = strSQL & "    FROM " & LTB 
 strSQL = strSQL & "    WHERE idauto = " & strIDAUTO
 strSQL = strSQL & "    ORDER BY CAMPO"
 
 'athDebug strSQL ,true
 
 
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_FormularioSetup/default.asp';") 
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
  document.formupdate.DEFAULT_LOCATION.value="../modulo_FormularioSetup/update.asp?var_chavereg=<%=strIDAUTO%>"; 
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

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro" id="metrotablevista" >
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
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strIDAUTO%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">

 <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strIDAUTO%>.GERAL</a></li>
            <li class=""><a href="#SETUP">SETUP</a></li>
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
                                <div class="span2"><p>Tabela:</p></div>
                                <div class="span8">
                                	<p class="input-control select info-state" data-role="input-control"> 
                                        <select name="DBVAR_STR_TABELA" id="DBVAR_STR_TABELAô">
                                        	<option value="tbl_empresas" <%IF GetValue(objRS,"TABELA")="tbl_empresas" THEN response.Write("selected") end if%>>TBL_EMPRESAS</option>
                                        </select>
                                	</p>
                                </div> 
                     </div>
                	<div class="row">
                                <div class="span2"><p>Campo:</p></div>
                                <div class="span8">
                                <p class="input-control select info-state" data-role="input-control">
                                    <select name="DBVAR_STR_CAMPO" id="DBVAR_STR_CAMPOô" >
                                         <% montaCombo "STR" ,"SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '"& CFG_DB &"' AND TABLE_NAME = 'tbl_empresas'", "COLUMN_NAME", "COLUMN_NAME", GetValue(objRS,"CAMPO") %>
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
                                        <select name="DBVAR_STR_FORMULARIO" id="DBVAR_STR_FORMULARIOô" class="">
                                        <option><%=GetValue(objRS,"FORMULARIO")%></option>
                                        <!--<option value="LOJA">LOJA</option>//-->
                                        </select>
                                    <p>  
                                </div>
                                <div class="input-control select size2 info-state" data-role="input-control">
                                    <p>
                                        <select name="DBVAR_STR_ETAPA" id="DBVAR_STR_ETAPAô" class="">
                                            <option><%=GetValue(objRS,"ETAPA")%></option>
                                            <!--<option value="CADASTRO">CADASTRO</option>//-->
                                        </select>                                    
                                    <p>  
                                </div>  
                            </div>                                                                                                                                   <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
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
                                            <option value="1"<%if getVALUE(objRS,"REQUERIDO") ="1" then response.Write("selected") end if %> selected>Sim</option>
                                            <option value="0"<%if (getVALUE(objRS,"REQUERIDO")) <> "1" then response.Write("selected") end if %>>Não</option>
                                            </select>
										<p>
                                	</div>    
                                	<div class="input-control select size2" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    	<p>                                                                                                                    
                                            <select name="DBVAR_STR_VINCULADO_ENTIDADE" id="DBVAR_STR_VINCULADO_ENTIDADE" class="">
                                            <option value="1" <%if  getVALUE(objRS,"VINCULADO_ENTIDADE")  ="1" then response.Write("selected") end if %>  selected>Sim</option>
                                            <option value="0" <%if (getVALUE(objRS,"VINCULADO_ENTIDADE")) <>  "1" then response.Write("selected") end if %>>Não</option>
                                            </select>
                                    	</p>
                                	</div>                                        
                                    <span class="tertiary-text-secondary">(exibir na loja /Requerimento do campo )</span> 
                                </div>
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Requerido Cod. Pais:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_REQUERIDO_COD_PAIS" name="DBVAR_STR_REQUERIDO_COD_PAIS" type="text" placeholder="" value="<%=GetValue(objRS,"REQUERIDO_COD_PAIS")%>" maxlength="45"></p>
                                     <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Ordem:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_NUM_ORDEM" onKeyPress="return validateNumKey(event);" name="DBVAR_NUM_ORDEM" type="text" placeholder="número" value="<%=GetValue(objRS,"ORDEM")%>"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
            	</div><!--fim grid//-->
            </div><!--fim frame layout//-->
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 

    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
            <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e (*)</strong> campos obrigatórios</small>
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