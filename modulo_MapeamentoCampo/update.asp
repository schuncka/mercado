<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_MapeamentoCampo",Session("METRO_USER_ID_USER")), true %>
<%
  Const LTB = "tbl_mapeamento_campo"	    				' - Nome da Tabela...
 Const DKN = "id_auto"          			' - Campo chave...
 Const TIT = "MapeamentoCampo"    						' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais

 
 Dim  strCODMAPEA, strNOMECAMPOCLI, strNOMECAMPOPRO, strNOMEDESCRI, strNOMEDESCRIUS, strNOMEDESCRIES  
 Dim  strVINCULOENTI, strCAMPOINSTRU, strCODEVENTO, strLOJASHOW, strCREDBUSCASHOW, strCAMPOCOMBOLIST, strCAMPOREQ, strCAMPOCOR 
 Dim  strCAMPOTIPO, strTIPO, strTIPOPESS, strINCLUIRBUSCA
  
  
 strCODMAPEA = Replace(GetParam("var_chavereg"),"'","''")

  
'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
 
' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
strSQL = " SELECT            ID_AUTO"
	strSQL = strSQL & "		  , COD_MAPEAMENTO_CAMPO"
	strSQL = strSQL & "		  , NOME_CAMPO_CLIENTE"
	strSQL = strSQL & "		  , NOME_CAMPO_PROEVENTO"
	strSQL = strSQL & "		  , NOME_DESCRITIVO"
	strSQL = strSQL & "		  , LOJA_SHOW"
	strSQL = strSQL & "		  , CAMPO_COMBOLIST"
	strSQL = strSQL & "		  , CAMPO_REQUERIDO"
	strSQL = strSQL & "		  , CAMPO_COR_DESTAQUE"
	strSQL = strSQL & "		  , CAMPO_TIPO"
	strSQL = strSQL & "		  , TIPO"
	strSQL = strSQL & "		  , NOME_DESCRITIVO_US"
	strSQL = strSQL & "		  , NOME_DESCRITIVO_ES"
	strSQL = strSQL & "		  , VINCULADO_ENTIDADE"
	strSQL = strSQL & "		  , CAMPO_INSTRUCAO"
	strSQL = strSQL & "		  , TIPOPESS"
	strSQL = strSQL & "		  , INCLUIR_BUSCA"
	strSQL = strSQL & "		  , COD_EVENTO"	
	strSQL = strSQL & "    FROM " & LTB 
	strSQL = strSQL & "    WHERE ID_AUTO = " & strCODMAPEA  
	strSQL = strSQL & "    ORDER BY COD_MAPEAMENTO_CAMPO"

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
'athDebug strSQL, true
 
%>
<!DOCTYPE html>
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_MapeamentoCampo/default.asp';") 
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
  document.formupdate.DEFAULT_LOCATION.value="../modulo_MapeamentoCampo/update.asp?var_chavereg=<%=strCODMAPEA%>"; 
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

function UploadImage(formname,fieldname, dir_upload) 
{
  var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
  window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

function SetFormField(formname, fieldname, valor) 
{
  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
  {
	eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
	//document.location.reload();
  }
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
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODMAPEA%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
<div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCODMAPEA%>.GERAL</a></li>
            <li class=""><a href="#MAPEAMENTO">MAPEAMENTO</a></li>
            <li class=""><a href="#MAPEAMENTO2">EXTRAS</a></li>            
            <!-- li class=""><a href="#AJUDA">AJUDA</a></li //-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                  <div class="row ">
                        <div class="span2"><p>Cód. Evento/Cód. Mapeamento Campo::</p></div>
                        <div class="span8">
                            <div class="input-control text select size3 " data-role="input-control">
                                <p>                                
                                    <select name="DBVAR_STR_COD_EVENTO" id="DBVAR_STR_COD_EVENTO" >
                                        <option value=""></option>
                                        <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", GetValue(objRS,"COD_EVENTO")%>
                                    </select>
                                </p>
                            </div>
                            <div class="input-control text readonly size2" data-role="input-control">
                                <p>
                                    <input id="DBVAR_STR_COD_MAPEAMENTO_CAMPO" name="DBVAR_STR_COD_MAPEAMENTO_CAMPO" type="text" placeholder="" value="<%=GetValue(objRS,"COD_MAPEAMENTO_CAMPO")%>" maxlength="10" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                </p>
                            </div>
                        </div>
						<span class="tertiary-text-secondary">(Cód. Evento / Cód. Mapeamento Campor [somente Leitura])</span> 

                     </div>
                     <div class="row">
                                <div class="span2"><p>Nome Cliente:</p></div>
                                <div class="span8">
                                     <p class="input-control text info-state" data-role="input-control">
                                     	<input id="DBVAR_STR_NOME_CAMPO_CLIENTEô" name="DBVAR_STR_NOME_CAMPO_CLIENTEô" type="text" placeholder="Ex: 'VIP' ou 'Verificar Cadastro'" value="<%=GetValue(objRS,"NOME_CAMPO_CLIENTE")%>" maxlength="100"></p>
                                     <span class="tertiary-text-secondary">(define o nome do campo no formulario do cliente)</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Nome Campo PRO:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text info-state" data-role="input-control">
                                     	<input id="DBVAR_STR_NOME_CAMPO_PROEVENTOô" name="DBVAR_STR_NOME_CAMPO_PROEVENTOô" type="text" placeholder="Ex: 'EXTRA_TXT_1'" value="<%=GetValue(objRS,"NOME_CAMPO_PROEVENTO")%>" maxlength="100"></p>
                                     <span class="tertiary-text-secondary">(define o nome do campo gravado no banco de dados)</span>                             
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Nome Descritivo:</p></div>
                                <div class="span8">  
                                     <p class="input-control text info-state" data-role="input-control">
                                     	<input id="DBVAR_STR_NOME_DESCRITIVOô" name="DBVAR_STR_NOME_DESCRITIVOô" type="text" placeholder="" value="<%=GetValue(objRS,"NOME_DESCRITIVO")%>" maxlength="120"></p>
                                     <span class="tertiary-text-secondary">(descreve conteudo do campo)</span>
                                </div> 
                     </div> 
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            
            <div class="frame" id="MAPEAMENTO" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                  <div class="row ">
                                <div class="span2">
                                  <p>Loja Show / CredBusca Show / Campo Req.:</p></div>
                                <div class="span8">
                                	<div class="input-control select size2" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    	<p>
                                            <select name="DBVAR_STR_LOJA_SHOW" id="DBVAR_STR_LOJA_SHOW" class="">
                                                <option value="1"<%if getVALUE(objRS,"LOJA_SHOW") ="1" then response.Write("selected") end if %> selected>Sim</option>
                                                <option value="0"<%if (getVALUE(objRS,"LOJA_SHOW")) ="" or (getVALUE(objRS,"LOJA_SHOW")) <> "1" then response.Write("selected") end if %>>Não</option>
                                            </select>
                                        </p>
                                	</div>
                                	<div class="input-control select size2" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    	<p>
                                            <select name="DBVAR_STR_CREDBUSCA_SHOW" id="DBVAR_STR_CREDBUSCA_SHOW" class="">
                                                <option value="1"<%if getVALUE(objRS,"CREDBUSCA_SHOW") ="1" then response.Write("selected") end if %> selected>Sim</option>
                                                <option value="0"<%if (getVALUE(objRS,"CREDBUSCA_SHOW")) ="" or (getVALUE(objRS,"CREDBUSCA_SHOW")) <> "1" then response.Write("selected") end if %>>Não</option>
                                            </select>
                                        </p>
                                	</div>
                                	<div class="input-control select size2" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    	<p>
                                            <select name="DBVAR_STR_CAMPO_REQUERIDO" id="DBVAR_STR_CAMPO_REQUERIDO" class="">
                                                <option value="1"<%if  getVALUE(objRS,"CAMPO_REQUERIDO")  ="1" then response.Write("selected") end if %>  selected>Sim</option>
                                                <option value="0"<%if (getVALUE(objRS,"CAMPO_REQUERIDO"))= ""  or (getVALUE(objRS,"CAMPO_REQUERIDO")) <> "1" then response.Write("selected") end if %>>Não</option>
                                            </select>
                                        </p>
                                	</div>
                                    <span class="tertiary-text-secondary">(exibir na loja / exibir no credbusca / requerimento do campo )</span> 
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Combo Lista:</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control">
                                     	<input id="DBVAR_STR_CAMPO_COMBOLIST" name="DBVAR_STR_CAMPO_COMBOLIST" type="text" placeholder="Ex: teste_cadastro.txt " value="<%=GetValue(objRS,"CAMPO_COMBOLIST")%>" maxlength="50">
                                     	<button class="btn-file" onClick="javascript:UploadImage('formupdate','DBVAR_STR_CAMPO_COMBOLIST','//shop//'); return false;"></button>
                                     </p>
                                     <span class="tertiary-text-secondary">(arquivo 'TXT' que carrega opções do combo)</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Cor Destaque:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_CAMPO_COR_DESTAQUE" name="DBVAR_STR_CAMPO_COR_DESTAQUE" type="text" placeholder="Ex: '#F2F2F2' " value="<%=GetValue(objRS,"CAMPO_COR_DESTAQUE")%>" maxlength="45"></p>
                                     <span class="tertiary-text-secondary">(cod HEXADECIMAL para definir cor usada nas regras de cadastro)</span>                             
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Campo Tipo/Tipo:</p></div>
                                <div class="span8"> 
                                	<div class="input-control text select size2" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    	<!--<p>
                                     		<input class="" id="DBVAR_STR_CAMPO_TIPO" name="DBVAR_STR_CAMPO_TIPO" type="text" placeholder="" value="<'%=GetValue(objRS,"CAMPO_TIPO")%>" maxlength="45"> <!--dois inputs na mesma linha//-->
                                        <!--/p>//-->
                                        <p>
                                            <select name="DBVAR_STR_CAMPO_TIPO" id="DBVAR_STR_CAMPO_TIPO" class="">
                                                <option value=""  <%if getVALUE(objRS,"CAMPO_TIPO") = ""  then response.Write("selected") end if %>>[Ambos]</option>
                                                <option value="PF"<%if getVALUE(objRS,"CAMPO_TIPO") ="PF" then response.Write("selected") end if %> >PF(Pessoa Fisica)</option>
                                                <option value="PJ"<%if getVALUE(objRS,"CAMPO_TIPO") ="PJ" then response.Write("selected") end if %>>PJ(Pessoa Jurídica)</option>                                                
                                            </select>
                                        </p>
                                	</div>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div> 
            	</div><!--fim grid layout//-->
            </div><!--fim frame layout//-->
            <div class="frame" id="MAPEAMENTO2" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>Nome Descritivo US:</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control">
                                     	<input id="DBVAR_STR_NOME_DESCRITIVO_US" name="DBVAR_STR_NOME_DESCRITIVO_US" type="text" placeholder="Ex: " value="<%=GetValue(objRS,"NOME_DESCRITIVO_US")%>" maxlength="120"></p>
                                     <span class="tertiary-text-secondary">Tradução do rótulo do campo na lingua inglesa</span>
                                </div>
                     </div> 
					<div class="row">
                                <div class="span2"><p>Nome Descritivo ES:</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control">
                                     	<input id="DBVAR_STR_NOME_DESCRITIVO_ES" name="DBVAR_STR_NOME_DESCRITIVO_ES" type="text" placeholder="Ex: " value="<%=GetValue(objRS,"NOME_DESCRITIVO_ES")%>" maxlength="120"></p>
                                     <span class="tertiary-text-secondary">Tradução do rótulo do campo na lingua espanhola</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Vinculo Ent./ Campo Instrução:</p></div>
                                <div class="span8">
                                	<div class="input-control select size2" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    	<p>
                                            <select name="DBVAR_STR_VINCULADO_ENTIDADE" id="DBVAR_STR_VINCULADO_ENTIDADE" class="">
                                            <option value="1" <%if getVALUE(objRS,"VINCULADO_ENTIDADE") = "1" then response.Write("selected") end if %>>Sim</option>
                                            <option value="0" <%if getVALUE(objRS,"VINCULADO_ENTIDADE") <> "1" then response.Write("selected") end if %>>Não</option>
                                            </select>                                        	
                                        </p>
                                	</div>
                                	<div class="input-control textarea size2" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    	<p>
                                    		<textarea class="input-control textarea " id="DBVAR_STR_CAMPO_INSTRUCAO" name="DBVAR_STR_CAMPO_INSTRUCAO" type="text" placeholder="EX: texto de instrução para criação do campo." value="<%=GetValue(objRS,"CAMPO_INSTRUCAO")%>" maxlength="45"></textarea>                                                                                   	
                                        </p>
                                	</div>
                                
                                    <p class="input-control select" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                  
                                     <!--dois inputs na mesma linha//-->
                                </div> 
                     </div> 
            	</div><!--fim grid layout//-->
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
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigat&oacute;rios</small>
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