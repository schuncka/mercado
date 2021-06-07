<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_clientes",Session("METRO_USER_ID_USER")), true %>
<%

 Const MDL = "DEFAULT"          											' - Default do Modulo...
 Const LTB = "tbl_clientes_sub"							    		' - Nome da Tabela...
 Const DKN = "cod_tbl_clientes_sub"										      	  		' - Campo chave...
 Const DLD = "../modulo_clientes/mini_Contatos/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Contatos"													' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCodCli
 

'Carraga a chave do registro, porém neste caso a relação masterdetail 
'ocorre com COD_EVENTO mesmo a chave do pai sendo ID_AUTO. 
'---------------carrega cachereg do pai local cred-----------------
'strCodEvento 	= Replace(GetParam("var_cod_evento"),"'","''")
strCodCli 		= Replace(GetParam("var_chavereg"),"'","''")

'------------------------------------------------------------------

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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      {  
  document.forminsert.DEFAULT_LOCATION.value="../modulo_clientes/mini_Contatos/insert.asp?var_chavereg=<%=strCodCli%>"; 
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
/* FIM: OK, APLICAR e CANCELAR, funções para action dos botões ------- */
</script>
</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
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
                    <!--<input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">-->
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
                                <input type="text" name="DBVAR_str_CONTATO" id="DBVAR_str_CONTATO" value="" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                <div class="row">
                    <div class="span2"><p>Cargo</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_CARGO" id="DBVAR_str_CARGO" value="" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                 <div class="row">
                    <div class="span2"><p>E-mail</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_MAILCOM" id="DBVAR_str_MAILCOM" value="" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                  <div class="row">
                    <div class="span2"><p>Fone</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_foneCom" id="DBVAR_str_foneCom" value="" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                <div class="row">
                    <div class="span2"><p>FAX</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_FAXCOM" id="DBVAR_str_FAXCOM" value="" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>


                  <div class="row">
                    <div class="span2"><p>Cel</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_Celular" id="DBVAR_str_Celular" value="" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                

                <div class="row">
                    <div class="span2"><p>OBS</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_OBS" id="DBVAR_str_OBS" value="" maxlength="50">
                            </p>
                            
                                <span class="tertiary-text-secondary"></span>
                        </div>
                </div>

                 <div class="row">
                    <div class="span2"><p>CPF</p></div>
                        <div class="span8">
                            <p class="input-control text" data-role="input-control">
                                <input type="text" name="DBVAR_str_CPF" id="DBVAR_str_CPF" value="" maxlength="50">
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

