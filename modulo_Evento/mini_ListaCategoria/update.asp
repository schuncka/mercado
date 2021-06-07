<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("mini_ListaCategoria",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_STATUS_PRECO" 								' - Nome da Tabela...
 Const DKN = "COD_STATUS_PRECO"									' - Campo chave...
 Const TIT = "Lista Categoria"									' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro
  
'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCOD_EVENTO,strCOD_CATEGORIA

'Carraga a chave do registro, porém neste caso a relação masterdetail 
'ocorre com COD_EVENTO mesmo a chave do pai sendo ID_AUTO. 
'---------------carrega cachereg do pai local cred-----------------
strCOD_EVENTO 		= Replace(GetParam("var_cod_evento"),"'","''")
strCOD_CATEGORIA =  Replace(GetParam("var_chavereg"),"'","''")
'------------------------------------------------------------------

If strCOD_CATEGORIA <> "" Then
	
	AbreDBConn objConn, CFG_DB
	
	strSQL = " SELECT COD_STATUS_PRECO "
	strSQL = strSQL & "		   ,STATUS "
	strSQL = strSQL & "		   ,STATUS_INTL "
	strSQL = strSQL & "		   ,STATUS_MINI "
	strSQL = strSQL & "		   ,COD_EVENTO "
	strSQL = strSQL & "		   ,OBSERVACAO "
	strSQL = strSQL & "		   ,SENHA "
	strSQL = strSQL & "		   ,LOJA_SHOW "
	strSQL = strSQL & "		   ,ENTIDADE_OBRIGATORIO "
	strSQL = strSQL & "		   ,STATUS_CREDENCIAL "
	strSQL = strSQL & "		   ,COD_PAIS "
	strSQL = strSQL & "		   ,COD_STATUS_PRECO_REFERENCIA "
	strSQL = strSQL & "		   ,ORDEM "
	strSQL = strSQL & "		   ,CAEX_SHOW "
	strSQL = strSQL & "		   ,UPLOAD_COMPROVANTE "
	strSQL = strSQL & "		   FROM tbl_STATUS_PRECO AS EI " 
	strSQL = strSQL & "		   WHERE EI.COD_STATUS_PRECO = " & strCOD_CATEGORIA
	strSQL = strSQL & "		   ORDER BY EI.STATUS, EI.COD_STATUS_PRECO " 
	
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Evento/mini_ListaCategoria/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Evento/mini_ListaCategoria/update.asp?var_chavereg=<%=strCOD_CATEGORIA%>&var_cod_evento=<%=strCOD_EVENTO%>"; 
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
		 <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_CATEGORIA%>">
        <input type="hidden" name="DEFAULT_LOCATION" value="">
        <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
        <input type="hidden" name="DBVAR_NUM_COD_EVENTO" id="DBVAR_NUM_COD_EVENTO" value="<%=getValue(objRS,"COD_EVENTO")%>">

         <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_CATEGORIA%>.GERAL</a></li>
            <li class="#"><a href="#EXTRA">EXTRA</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    	<div class="row">
                                <div class="span2"><p>Categoria:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_STATUS" id="DBVAR_STR_STATUS" value="<%=getValue(objRS,"STATUS")%>" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Categoria Mini:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_STATUS_MINI" id="DBVAR_STR_STATUS_MINI" value="<%=getValue(objRS,"STATUS_MINI")%>" maxlength="45"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Categoria Intl:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_STATUS_INTL" id="DBVAR_STR_STATUS_INTL" value="<%=getValue(objRS,"STATUS_INTL")%>" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Observação:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_OBSERVACAO" id="DBVAR_STR_OBSERVACAO" value="<%=getValue(objRS,"OBSERVACAO")%>" maxlength="255"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Senha:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="password" name="DBVAR_STR_SENHA" id="DBVAR_STR_SENHA" value="<%=getValue(objRS,"SENHA")%>" maxlength="255"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     
                     <div class="row">
                                <div class="span2"><p>Loja Show/Entid.Obrigatória</p></div>
                                <div class="span8">
                                     <div class="input-control text select size2" data-role="input-control">
                                     	<p>
                                            <select name="DBVAR_STR_LOJA_SHOW" id="DBVAR_STR_LOJA_SHOW" class="">
                                                <option value="1" <%IF getValue(objRS,"LOJA_SHOW")= "1" THEN RESPONSE.Write("selected")%> >Sim</option>
                                                <option value="0" <%IF getValue(objRS,"LOJA_SHOW")= "0" THEN RESPONSE.Write("selected")%>>Não</option>
                                            </select>
										</p>
                                     </div>
                                     <div class="input-control text select size2" data-role="input-control">
                                     	<p>                                                                                                                 
                                            <select name="DBVAR_STR_ENTIDADE_OBRIGATORIO" id="DBVAR_STR_ENTIDADE_OBRIGATORIO" class="">
                                                <option value="1"  <%IF getValue(objRS,"ENTIDADE_OBRIGATORIO")= "1" THEN RESPONSE.Write("selected")%>>Sim</option>
                                                <option value="0" <%IF getValue(objRS,"ENTIDADE_OBRIGATORIO")= "0" THEN RESPONSE.Write("selected")%>>Não</option>
                                            </select>
                                     </p>
                                     </div>                                     
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                   
                      </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
             <div class="frame" id="EXTRA" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                  <div class="row">
                                <div class="span2"><p>Status Credencial&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_STATUS_CREDENCIAL" id="DBVAR_STR_STATUS_CREDENCIAL" value="<%=getValue(objRS,"STATUS_CREDENCIAL")%>" maxlength="255"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                        <div class="span2"><p>Código País:</p></div>
                        <div class="span8">
                            <p class="input-control select " data-role="input-control">
                                <select name="DBVAR_STR_COD_PAIS" id="DBVAR_STR_COD_PAIS"> 
                                <option value="US" <%IF getValue(objRS,"COD_PAIS")= "US" THEN RESPONSE.Write("selected")%>>US</option>
                                <option value="ES" <%IF getValue(objRS,"COD_PAIS")= "ES" THEN RESPONSE.Write("selected")%>>ES</option>
                                <option value="BR" <%IF getValue(objRS,"COD_PAIS")= "BR" THEN RESPONSE.Write("selected")%>>BR</option>
                                </select>
                            </p>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div> 
                    
                     <div class="row">
                                <div class="span2"><p>Cod Categoria Preço Referencial:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text"  name="DBVAR_NUM_COD_STATUS_PRECO_REFERENCIA" id="DBVAR_NUM_COD_STATUS_PRECO_REFERENCIA" value="<%=getValue(objRS,"COD_STATUS_PRECO_REFERENCIA")%>" maxlength="11" onKeyPress="return validateNumKey(event);"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Ordem:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input type="text"  name="DBVAR_NUM_ORDEM" id="DBVAR_NUM_ORDEM" value="<%=getValue(objRS,"ORDEM")%>" maxlength="11" onKeyPress="return validateNumKey(event);"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                        <div class="row">
                                <div class="span2"><p>CaexShow/Upload Comprovante</p></div>
                                <div class="span8">
                                     <div class="input-control text select size2" data-role="input-control">
                                     	<p>
                                         <select name="DBVAR_STR_CAEX_SHOW" id="DBVAR_STR_CAEX_SHOW" class="">
                                         <option value="1" <%IF getValue(objRS,"CAEX_SHOW")= "1" THEN RESPONSE.Write("selected")%>>Sim</option>
                                         <option value="0" <%IF getValue(objRS,"CAEX_SHOW")= "0" THEN RESPONSE.Write("selected")%>>Não</option>
                                         </select>
                                       </p>
                                     </div>
                                     <div class="input-control text select size2" data-role="input-control">
                                     	<p>
                                    		<select name="DBVAR_STR_UPLOAD_COMPROVANTE" id="DBVAR_STR_UPLOAD_COMPROVANTE" class="size2">
                                    		<option value="1" <%IF getValue(objRS,"UPLOAD_COMPROVANTE")= "1" THEN RESPONSE.Write("selected")%>>Sim</option>
                                    		<option value="0" <%IF getValue(objRS,"UPLOAD_COMPROVANTE")= "0" THEN RESPONSE.Write("selected")%>>Não</option>
                                    		</select>
                                     	</p>
                                     </div>
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
end if	
	'athDebug strSQL, true '---para testes'
%>                     
                                            
	 					  		 