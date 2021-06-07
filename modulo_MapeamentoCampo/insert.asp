<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_MapeamentoCampo",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_mapeamento_campo"	    				' - Nome da Tabela...
 Const DKN = "id_auto"          			' - Campo chave...
 Const TIT = "MapeamentoCampo"    						' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 
 Dim  strCODMAPEA, strNOMECAMPOCLI, strNOMECAMPOPRO, strNOMEDESCRI, strNOMEDESCRIUS, strNOMEDESCRIES  
 Dim  strVINCULOENTI, strCAMPOINSTRU, strCODEVENTO, strLOJASHOW, strCAMPOCOMBOLIST, strCAMPOREQ, strCAMPOCOR 
 Dim  strCAMPOTIPO, strTIPO, strTIPOPESS, strINCLUIRBUSCA
 
AbreDBConn objConn, CFG_DB
 strSQL = "SELECT COD_MAPEAMENTO_CAMPO FROM TBL_MAPEAMENTO_CAMPO WHERE COD_EVENTO = " & Session("cod_evento")
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
		strSQL =  "SELECT MAX(cod_mapeamento_campo) as PROX_cod_mapeamento FROM tbl_mapeamento_campo WHERE cod_mapeamento_campo not like '999'" 'Cod Original: [WHERE COD_EVENTO <> 999] "
		Set objRS = objConn.Execute(strSQL)
		If not objRS.EOF Then
		  strCODMAPEA = GetValue(objRS,"PROX_cod_mapeamento")
		End If
		FechaRecordSet objRS
		If strCODMAPEA = "" Then strCODMAPEA = 0 End If
		strCODMAPEA = strCODMAPEA + 1
	End If

FechaDBConn ObjConn
	

%>
<!DOCTYPE html>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script type="text/javascript" language="javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_MapeamentoCampo/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_MapeamentoCampo/insert.asp"; 
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

/* FIM: OK, APLICAR e CANCELAR, funções para action dos botões ------- */
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro" id="metrotablevista" >
<!-- Barra escura que contem o nome da dialog//-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">INSERT</span></sup>
</div>
<!-- FIM -------------------------------Barra//-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	<form name="forminsert" id="forminsert" action="../_database/athinserttodb.asp" method="post">
		<input type="hidden" name="DEFAULT_TABLE"	 value="<%=LTB%>">
		<input type="hidden" name="DEFAULT_DB"		 value="<%=CFG_DB%>">
		<input type="hidden" name="FIELD_PREFIX" 	 value="DBVAR_">
		<input type="hidden" name="RECORD_KEY_NAME"	 value="<%=DKN%>">
		<input type="hidden" name="DEFAULT_LOCATION" value="">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
            <li class=""><a href="#MAPEAMENTO">MAPEAMENTO</a></li>
            <li class=""><a href="#CAMPO">EXTRAS</a></li>            
            <!-- li class=""><a href="#AJUDA">AJUDA</a></li //-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">   
                  <div class="row ">
                        <div class="span2"><p>Cód. Evento/Cód. Mapeamento Campo::</p></div>
                        <div class="span8">
                            <div class="input-control text select size4 " data-role="input-control">
                                <p>                                
                                    <select name="DBVAR_STR_COD_EVENTO" id="DBVAR_STR_COD_EVENTO" >
                                        <option value="" selected="selected"></option>
                                        <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", SESSION("COD_EVENTO") %>
                                    </select>
                                </p>
                            </div>
                            <div class="input-control text readonly  size1" data-role="input-control">
                                <p>
                                    <input id="DBVAR_STR_COD_MAPEAMENTO_CAMPO" name="DBVAR_STR_COD_MAPEAMENTO_CAMPO" type="text" placeholder="" value="<%=strCODMAPEA%>" maxlength="10" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                </p>
                            </div>
                        </div>
						<span class="tertiary-text-secondary">(Cód. Evento / Cód. Mapeamento Campo [somente Leitura])</span> 

                     </div>
                     <div class="row">
                                <div class="span2"><p>Nome Cliente:</p></div>
                                <div class="span8">
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_NOME_CAMPO_CLIENTEô" name="DBVAR_STR_NOME_CAMPO_CLIENTEô" type="text" placeholder="Ex: 'VIP' ou 'Verificar Cadastro'" value="" maxlength="100"></p>
                                        </div>
                                    <span class="tertiary-text-secondary">(define o nome do campo no formulario do cliente)</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Nome Campo PRO:</p></div>
                                <div class="span8">
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_NOME_CAMPO_PROEVENTOô" name="DBVAR_STR_NOME_CAMPO_PROEVENTOô" type="text" placeholder="Ex: 'EXTRA_TXT_1'" value="" maxlength="100"></p>
                                        </div>
                                    <span class="tertiary-text-secondary">(define o nome do campo gravado no banco de dados)</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Nome Descritivo:</p></div>
                                <div class="span8">
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_NOME_DESCRITIVOô" name="DBVAR_STR_NOME_DESCRITIVOô" type="text" placeholder="Ex: 'VIP' ou 'Verificar Cadastro'" value="" maxlength="120"></p>
                                        </div>
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
                                <div class="input-control  select size2" data-role="input-control">
                                    <p>
                                        <select name="DBVAR_STR_LOJA_SHOW" id="DBVAR_STR_LOJA_SHOW" class="">
                                        <option value="1" selected>Sim</option>
                                        <option value="0">Não</option>
                                        </select> 
                                    <p>
                                </div>
                                <div class="input-control  select size2" data-role="input-control">
                                    <p>
                                        <select name="DBVAR_STR_CREDBUSCA_SHOW" id="DBVAR_STR_CREDBUSCA_SHOW" class="">
                                        <option value="1">Sim</option>
                                        <option value="0" selected>Não</option>
                                        </select> 
                                    <p>
                                </div>
                                <div class="input-control  select size2" data-role="input-control">
                                    <p>
                                        <select name="DBVAR_STR_CAMPO_REQUERIDO" id="DBVAR_STR_CAMPO_REQUERIDO" class="">
                                        <option value="1" selected>Sim</option>
                                        <option value="0">Não</option>
                                        </select>
                                    <p>
                                </div>
                            <span class="tertiary-text-secondary">(exibir na loja / exibir no credBusca / requerimento do campo )</span> 
                        </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Combo Lista:</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control">
                                     	<input id="DBVAR_STR_CAMPO_COMBOLIST" name="DBVAR_STR_CAMPO_COMBOLIST" type="text" placeholder="Ex: teste_cadastro.txt " value="" maxlength="50">
                                     	<button class="btn-file" onClick="javascript:UploadImage('forminsert','DBVAR_STR_CAMPO_COMBOLIST','//shop//'); return false;"></button>
                                     </p>
                                     <span class="tertiary-text-secondary">(arquivo 'TXT' que carrega opções do combo)</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Cor Destaque:</p></div>
                                <div class="span8">
                                    	<div class="input-control text " data-role="input-control">
                                            <p><input id="DBVAR_STR_CAMPO_COR_DESTAQUE" name="DBVAR_STR_CAMPO_COR_DESTAQUE" type="text" placeholder="Ex: '#F2F2F2' " value="" maxlength="45"></p>
                                        </div>
                                    <span class="tertiary-text-secondary">(cod HEXADECIMAL para definir cor usada nas regras de cadastro)</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Campo Tipo/Tipo:</p></div>
                                <div class="span8">  
                                     <div class="input-control text select size2" data-role="input-control">
                                        <!--<p>
                                            <input class="" id="DBVAR_STR_CAMPO_TIPOô" name="DBVAR_STR_CAMPO_TIPOô" type="text" placeholder="" value="" maxlength="45"> <!--dois inputs na mesma linha//-->
                                        <!--/p>//-->
                                        <p>
                                            <select name="DBVAR_STR_CAMPO_TIPO" id="DBVAR_STR_CAMPO_TIPO" class="">
                                            <option value="A" selected>[Ambos]</option>
                                            <option value="PF">PF(Pessoa Fisica)</option>
                                            <option value="PJ">PJ(Pessoa Jurídica)</option>
                                            </select>
                                        <p>
                                     </div> 
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div> 
                     
            	</div><!--fim grid layout//-->
            </div><!--fim frame layout//-->
            <div class="frame" id="CAMPO" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>Nome Descritivo US:</p></div>
                                <div class="span8">
                                    	<div class="input-control text " data-role="input-control">
                                            <p><input id="DBVAR_STR_NOME_DESCRITIVO_US" name="DBVAR_STR_NOME_DESCRITIVO_US" type="text" placeholder="Ex:NOME: será apresentado como NAME: " value="" maxlength="120"></p>
                                        </div>
                                    <span class="tertiary-text-secondary">Tradução do rótulo do campo na lingua inglesa</span>
                                </div>
                     </div> 
					<div class="row">
                                <div class="span2"><p>Nome Descritivo ES:</p></div>
                                <div class="span8">
                                    	<div class="input-control text " data-role="input-control">
                                            <p><input id="DBVAR_STR_NOME_DESCRITIVO_ES" name="DBVAR_STR_NOME_DESCRITIVO_ES" type="text" placeholder="Ex: NOME: será apresentado como NOMBRE: " value="" maxlength="120"></p>
                                        </div>
                                    <span class="tertiary-text-secondary">Tradução do rótulo do campo na lingua espanhola</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Vinculo Ent./ Campo Instrução:</p></div>
                                <div class="span8">
                                    <p class="input-control select" data-role="input-control"><!--para combo nao diminuir fonte//-->
                                    <select name="DBVAR_STR_VINCULADO_ENTIDADE" id="DBVAR_STR_VINCULADO_ENTIDADE" class="size2">
                                    <option value="1" selected>Sim</option>
                                    <option value="0">Não</option>
                                    </select>&nbsp;&nbsp;&nbsp;&nbsp;
                                   	<textarea class="input-control textarea size3" id="DBVAR_STR_CAMPO_INSTRUCAO" name="DBVAR_STR_CAMPO_INSTRUCAO" type="text" placeholder="EX: texto de instrução para criação do campo." value="" maxlength="45"></textarea></p>
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
