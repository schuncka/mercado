<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CotacaoMoeda",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "TBL_MOEDA_COTACAO" ' - Nome da Tabela...
 Const DKN = "ID_AUTO"      ' - Campo chave...
 Const TIT = "COTAÇÃO MOEDA"     ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Relativas a FILTRAGEM e Seleção	
 Dim arrICON, arrBG , i ,strID_AUTO

 
 strID_AUTO = GetParam("var_chavereg")
 
 'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
 
 ' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
	'strSQL = "SELECT ID_AUTO "
'	strSQL = strSQL & "		  ,COD_MOEDA_ORIGEM "
'	strSQL = strSQL & "		  ,COD_MOEDA_DESTINO "
'	strSQL = strSQL & "		  ,COTACAO_DATA "
'	strSQL = strSQL & "		  ,COTACAO_TAXA "
'	strSQL = strSQL & "    FROM " & LTB 
'	strSQL = strSQL & "    WHERE ID_AUTO =  " & strID_AUTO
	
	strSQL = "SELECT MC.ID_AUTO, MO.MOEDA AS MOEDA_ORIGEM, MD.MOEDA AS MOEDA_DESTINO, MC.COTACAO_DATA, MC.COTACAO_TAXA " 
strSQL = strSQL & "		  FROM TBL_MOEDA_COTACAO MC, TBL_MOEDA MO, TBL_MOEDA MD " 
strSQL = strSQL & "		  WHERE ID_AUTO = " & strID_AUTO 
strSQL = strSQL & "		  AND MO.COD_MOEDA = MC.COD_MOEDA_ORIGEM " 
strSQL = strSQL & "		  AND MD.COD_MOEDA = MC.COD_MOEDA_DESTINO "
	

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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';") 
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
  document.formupdate.DEFAULT_LOCATION.value="../modulo_CotacaoMoeda/update.asp?var_chavereg=<%=strID_AUTO%>"; 
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
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
                <form name="formupdate" id="formupdate" action="updateexec.asp" method="post">
                <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
                <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strID_AUTO%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
                <input type="hidden" name="var_id_auto" value="<%=objRS("ID_AUTO")%>">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strID_AUTO%>.GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" >
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
                    <div class="row">
                        <div class="span2"><p>Data:</p></div>
                        <div class="span8">
                            <div class="grid">
                                <div class="row" style="margin:0px;">                        
                                    <div class="span3">
                                        <p class="input-control text size2 info-state" data-role="data-hole">
                                        	<input id="var_moeda_origem" name="var_moeda_origem" type="text" placeholder="" value="<%=objRS("COTACAO_DATA")%>" maxlength="11" readonly>
                                        </p>
                                    </div>
 								</div>
                                <span class="tertiary-text-secondary">Data para utilização da taxa convertida</span>
                            </div>                                                             
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Moeda Origem:</p></div>
                        <div class="span8">
                            <div class="grid">
                                <div class="row" style="margin:0px;">
                                	<div class="span3">
                                        <p class="input-control text size1">
                                          <input type="text" value="1,00" disabled>
                                        </p>                                
                                        <p class="input-control text size2 info-state" data-role="data-hole">
                                        	<input id="var_moeda_origem" name="var_moeda_origem" type="text" placeholder="" value="<%=getValue(objRS,"MOEDA_ORIGEM")%>" maxlength="11" readonly>
                                        </p>                                
                                    </div> 
                                </div>
                                <span class="tertiary-text-secondary">base (1,00) , moeda que será cotada</span>
                            </div>                         
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Taxa / Moeda Dest.:</p></div>
                        <div class="span8">
                            <div class="grid">
                                <div class="row" style="margin:0px;">
                                    <div class="span5">
                                        <p class="input-control text size1"><input type="text" value="=" disabled></p>                                
                                        <p class="input-control text size2 info-state" data-role="data-hole" >
                                            <input type="text" name="var_cotacao_taxa" id="var_cotacao_taxaô" maxlength="" placeholder="" value="<%=FormatNumber(objRS("COTACAO_TAXA"),6)%>" onChange="javascript: if ( parseFloat(this.value.replace(',','.')) <= 0.0 ) { this.value = ''; }"  onKeyPress="Javascript:return validateFloatKey(event);return false;">
                                        </p>                                
                                        <p class="input-control text size2 info-state" data-role="data-hole" >
                                        	<input id="var_moeda_destino" name="var_moeda_destino" type="text" placeholder="" value="<%=objRS("MOEDA_DESTINO")%>" maxlength="11" readonly>
                                        </p>                           
                                    </div>
                                </div>    
                                    <span class="tertiary-text-secondary">(cotacao_taxa) moeda na qual será feita cotação/(moeda_destino) Equivalente a 1,00 na moeda origem de acordo com Taxa</span>                                                     
                            </div>
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
            <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e (*)</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
