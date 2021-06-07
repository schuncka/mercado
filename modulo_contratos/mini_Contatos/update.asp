<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_clientes",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          											' - Default do Modulo...
 Const LTB = "tbl_clientes_sub"							    		' - Nome da Tabela...
 Const DKN = "cod_tbl_clientes_sub"										      	  		' - Campo chave...
 Const DLD = "../modulo_clientes/mini_Contatos/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Contatos"														' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 
'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCodCli

strCodCli = Replace(GetParam("var_chavereg"),"'","''")

If strCodCli <> "" Then
	
	AbreDBConn objConn, CFG_DB
	
 strSQL = "SELECT  contato"
 strSQL = strSQL & "    , celular "
 strSQL = strSQL & "	, cargo"
 strSQL = strSQL & "	, mailcom "
 strSQL = strSQL & "	, foneCom "
 strSQL = strSQL & "	, FAXCOM "
 strSQL = strSQL & "	, Celular "
 strSQL = strSQL & "	, OBS "
 strSQL = strSQL & "	, CPF "
 strSQL = strSQL & " FROM tbl_clientes_sub "
 strSQL = strSQL & "    WHERE cod_TBL_CLIENTES_SUB = " & strCodCli 
 
 
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_clientes/mini_Contatos/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      {  
  document.formupdate.DEFAULT_LOCATION.value="../modulo_clientes/mini_Contatos/update.asp?var_chavereg=<%=strCodCli%>"; 
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
                    <input type="hidden" name="DEFAULT_LOCATION" value="">
					<input type="hidden" name="DBVAR_str_CodigoDoCliente" value="<%=strCodCli%>">
   
<div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
            <!--li class="#"><a href="#EXTRA">EXTRA</a></li//-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">                    
                  
                  <div class="row">
                    <div class="span2"><p>Contato</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_CONTATO" id="DBVAR_str_CONTATO" value="<%=getValue(objRS,"CONTATO")%>" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                <div class="row">
                    <div class="span2"><p>Cargo</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_CARGO" id="DBVAR_str_CARGO" value="<%=getValue(objRS,"CARGO")%>" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                 <div class="row">
                    <div class="span2"><p>E-mail</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_MAILCOM" id="DBVAR_str_MAILCOM" value="<%=getValue(objRS,"MAILCOM")%>" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                  <div class="row">
                    <div class="span2"><p>Fone</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_foneCom" id="DBVAR_str_foneCom" value="<%=getValue(objRS,"foneCom")%>" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                <div class="row">
                    <div class="span2"><p>FAX</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_FAXCOM" id="DBVAR_str_FAXCOM" value="<%=getValue(objRS,"FAXCOM")%>" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>


                  <div class="row">
                    <div class="span2"><p>Cel</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_Celular" id="DBVAR_str_Celular" value="<%=getValue(objRS,"Celular")%>" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                

                <div class="row">
                    <div class="span2"><p>OBS</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_OBS" id="DBVAR_str_OBS" value="<%=getValue(objRS,"OBS")%>" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                 <div class="row">
                    <div class="span2"><p>CPF</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_CPF" id="DBVAR_str_CPF" value="<%=getValue(objRS,"CPF")%>" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>



                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->           
	</div><!--FIM TABCONTROL //--> 
    
    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e/ou (*)</strong> campos obrigatórios</small>
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
