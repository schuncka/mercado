<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<%' VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_SiteInfo",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "TBL_EMPRESAS" 	' - Nome da Tabela...
 Const DKN = "COD_EMPRESA"      ' - Campo chave...
 
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, objLang, strSQL
 'Relativas a FILTRAGEM e Seleção	
 Dim  i,  strIDINFO ,strCODIGO, strCOD_EMPRESA, strPAX_CADASTRO, strFLAG, strTIPO_PESS
 

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"./lang/"
 ' -------------------------------------------------------------------------------

 ' ---------------------------------------------------------------------------------------------------------
 ' INI: Variávis de ambiente - AREA_PAX_... 
 strPAX_CADASTRO = Request.Cookies("METRO_pax")("tp_cadastro") ' determina se grava ou envia e-mail solicitando (["EXIBIR" or "EDITAR" or "HOMOLOGAR"])
 ' ---------------------------------------------------------------------------------------------------------

 
 strCOD_EMPRESA = Replace(GetParam("var_chavereg"),"'","''")
 
 'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
 
 ' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
 		  strSQL = " SELECT "
 strSQL = strSQL & "   E.COD_EMPRESA "		  
 strSQL = strSQL & " , E.ID_NUM_DOC1 "
 strSQL = strSQL & " , E.TIPO_PESS " 
 strSQL = strSQL & " , E.NOMECLI "
 strSQL = strSQL & " , E.NOMEFAN "
 strSQL = strSQL & " , E.ENTIDADE "
 strSQL = strSQL & " , E.ENTIDADE_CNPJ "
 strSQL = strSQL & " , E.EMAIL1 "
 strSQL = strSQL & " , E.END_LOGR "
 strSQL = strSQL & " , E.END_NUM "
 strSQL = strSQL & " , E.END_COMPL "
 strSQL = strSQL & " , E.END_FULL "
 strSQL = strSQL & " , E.END_BAIRRO "
 strSQL = strSQL & " , E.END_CIDADE "
 strSQL = strSQL & " , E.END_ESTADO "
 strSQL = strSQL & " , E.END_PAIS "
 strSQL = strSQL & " , E.END_CEP "	
 strSQL = strSQL & " , E.FONE1 "
 strSQL = strSQL & " , E.FONE2 "
 strSQL = strSQL & " , E.FONE3 "
 strSQL = strSQL & " , E.FONE4 "
 strSQL = strSQL & " , E.IMG_FOTO "
 strSQL = strSQL & " , E.SYS_DATAAT "
 strSQL = strSQL & " , E.SYS_USERAT "
 strSQL = strSQL & " , P.COD_PALESTRANTE "
 strSQL = strSQL & " , P.FOTO "
 strSQL = strSQL & " , P.CURRICULO "
 strSQL = strSQL & " , P.AREA_ATUACAO "
 strSQL = strSQL & " , A.ATIVMINI "
 strSQL = strSQL & " FROM TBL_EMPRESAS E "
 strSQL = strSQL & " LEFT JOIN TBL_PALESTRANTE P ON E.COD_EMPRESA = P.COD_EMPRESA "
 strSQL = strSQL & " LEFT OUTER JOIN tbl_Atividade A ON (E.CODATIV1 =  A.CODATIV) " 
 strSQL = strSQL & "  WHERE E.COD_EMPRESA = " & strCOD_EMPRESA
 
 '-----------------------------------------------------------------------------------------------------------------
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
 
 'Teste para setar sulfixo da lang específica para user tipo PJ
 If getValue(objRS,"TIPO_PESS") = "N" Then
 	strTIPO_PESS = "_PJ"
 Else
  	strTIPO_PESS = ""
 End If	
 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<!-- funções para action dos botões OK, APLICAR,CANCELAR  e NOTIFICAÇÂO//-->
<script type="text/javascript" language="javascript">

/* nesta dialog precisamos bloquear o enter em todos os inputs com a função abaixo  */

$(document).ready(function () {
   $('input').keypress(function (e) {
        var code = null;
        code = (e.keyCode ? e.keyCode : e.which);                
        return (code == 13) ? false : true;
   });
});
 
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() {
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='update.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %>  
	/*document.formupdate.DEFAULT_LOCATION.value="../_database/athWindowClose.asp"; */
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar() { 
  document.formupdate.DEFAULT_LOCATION.value="update.asp?var_chavereg=<%=strCOD_EMPRESA%>"; 
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

/* INI: Funções utilizadas pelo [athUploader -------------------------------------------------------- */
function SetFormField(formname, fieldname, valor) {
  var str = formname;
  if ( (formname != "") && (fieldname != "") && (valor != "") ) {
    eval("document.getElementById('" + formname + "')." + fieldname + ".value = '" + valor + "';");
	//document.getElementById("foto_webcam").src = '../webcam/imgphoto/'+valor;
	aplicar(); 
	//if (str.indexOf("formupdate") >= 0) { eval("document.getElementById('" + formname + "').submit();"); }
  }
}

function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '	../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}
</script>
<!-- FIM----------------------------------------- funções //-->

</head>
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=ucase(objLang.SearchIndex("dialog_dados_cadastrais",0))%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
                <form name="formupdate" id="formupdate" action="updateexec.asp" method="post">
                <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
                <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                <input type="hidden" name="var_cod_empresa" value="<%=strCOD_EMPRESA%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
                <input type="hidden" name="var_cod_palestrante" value="<%=getVALUE(objRS,"COD_PALESTRANTE")%>">
               
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_EMPRESA%>.<%=ucase(objLang.SearchIndex("dialog_geral",0))%></a></li>
            <li><a href="#ENDERECO"><%=ucase(objLang.SearchIndex("dialog_endereco",0))%></a></li>            
            <li><a href="#PALESTRANTE"><%=ucase(objLang.SearchIndex("dialog_palestrante",0))%></a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_id_num_doc1" & strTIPO_PESS,0)%>:</p></div>
                        <div class="span8"><p><strong><%=getVALUE(objRS,"ID_NUM_DOC1")%></strong></p></div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>E-mail:</p></div>
                        <div class="span8"><p><strong><%=getVALUE(objRS,"EMAIL1")%></strong></p></div>
                        <span class="tertiary-text-secondary"></span>
                    </div>                           
      
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_nomecli" & strTIPO_PESS,0)%>:</p></div>
                        <div class="span8">
                            <div class="input-control text " data-role="input-control"><p><input id="var_nomecliô" name="var_nomecli" type="text" placeholder="" value="<%=getVALUE(objRS,"NOMECLI")%>" maxlength="120"></p></div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div> 
                     
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_nomefan" & strTIPO_PESS,0)%>:</p></div>
                        <div class="span8">
                            <div class="input-control text " data-role="input-control"><p><input id="var_nomefanô" name="var_nomefan" type="text" placeholder="" value="<%=getVALUE(objRS,"NOMEFAN")%>" maxlength="25"></p></div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div>
                
                    <div class="row">
                         <div class="span2"><p><%=objLang.SearchIndex("dialog_ativmini",0)%>:</p></div>
                         <div class="span8"><p><strong><%=getVALUE(objRS,"ATIVMINI")%></strong></p></div>         
                    </div>
                
                <% If strTIPO_PESS = "" Then %>
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_entidade",0)%>:</p></div>
                        <div class="span8">
                            <div class="input-control text " data-role="input-control"><p><input id="var_entidade" name="var_entidade" type="text" placeholder="" value="<%=getVALUE(objRS,"ENTIDADE")%>" maxlength="150"></p></div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div>
                     
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_entidade_CNPJ",0)%>:</p></div>
                        <div class="span8">
                            <div class="input-control text " data-role="input-control"><p><input id="var_entidade_cnpj" name="var_entidade_cnpj" type="text" onBlur="checkCNPJ(this.value,'erro'); return false;" onKeyPress="return validateNumKey(event);return false;" placeholder="" value="<%=getVALUE(objRS,"ENTIDADE_CNPJ")%>" maxlength="14"></p></div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div> 
               <% End If %>    
    
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_fone4",0)%>:</p></div>
                        <div class="span8">
                            <div class="input-control text size2" data-role="input-control"><p><input id="var_fone4" name="var_fone4" type="text" placeholder="" value="<%=getVALUE(objRS,"FONE4")%>" maxlength="50"></p></div>
                            <div class="input-control text size2" data-role="input-control"><p><input id="var_fone1" name="var_fone1" type="text" placeholder="" value="<%=getVALUE(objRS,"FONE1")%>" maxlength="50"></p></div>
                            <span class="tertiary-text-secondary"></span>
                        </div>                      
                    </div>   
               
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_fone3",0)%> / <%=objLang.SearchIndex("dialog_fone2",0)%>:</p></div>
                        <div class="span8">
                            <div class="input-control text size2" data-role="input-control"><p><input id="var_fone3" name="var_fone3" type="text" placeholder="" value="<%=getVALUE(objRS,"FONE3")%>" maxlength="50"></p></div>
                            <div class="input-control text size2" data-role="input-control"><p><input id="var_fone2" name="var_fone2" type="text" placeholder="" value="<%=getVALUE(objRS,"FONE2")%>" maxlength="50"></p></div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div>   
				    
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_img_foto",0)%>:</p></div>
                        <div class="span8">
                            <div class="input-control file" data-role="input-control">
                                <p>
                                    <input type="text" readonly name="var_img_foto" id="var_img_foto" value="<%=getVALUE(objRS,"IMG_FOTO")%>" />
                                    <button class="btn-file" onClick="javascript:UploadImage('formupdate','var_img_foto','\\webcam\\imgphoto\\'); return false;"></button>
                                </p>
                            </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>&nbsp;</p></div>
                        <div class="span8"><p><img src="../webcam/imgphoto/<%=getValue(objRS,"IMG_FOTO")%>" class="rounded" width="120" height="120"></p></div>
                    </div>                 
                                     
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            
            <div class="frame" id="ENDERECO" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
           
                    <div class="row">
        	            <div class="span2"><p><%=objLang.SearchIndex("dialog_end_cep",0)%>:</p></div>
            	        <div class="span8">	            	        
                            <div class="input-control text size2 " data-role="input-control">
                            	<p>
                                	<input id="var_end_cep" name="var_end_cep" type="text" placeholder="" value="<%=getVALUE(objRS,"END_CEP")%>" maxlength="8">
		                        	<button class="btn-search" 
        		                    		onClick="document.getElementById('form_searchCEP').var_cep_search.value=document.getElementById('formupdate').var_end_cep.value; document.getElementById('form_searchCEP').submit(); return false;" >
                            		</button>
                            	</p>
                            </div>
  	            	    
                            <span class="tertiary-text-secondary"><iframe src="" style="display:none" id="ifr_searchcep" name="ifr_searchcep"></iframe> </span>
                    	</div>
                    </div>                       
                 
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_end_logr",0)%>:</p></div>
                        <div class="span8">
                            <div class="input-control text " data-role="input-control"><p><input id="var_end_logr" name="var_end_logr" type="text" placeholder="" value="<%=getVALUE(objRS,"END_LOGR")%>" maxlength="100"></p></div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div> 

                    <div class="row">
	                    <div class="span2"><p><%=objLang.SearchIndex("dialog_end_num",0)%> / <%=objLang.SearchIndex("dialog_end_compl",0)%>:</p></div>
    	                <div class="span8">
        		            <div class="input-control text size1" data-role="input-control"><p><input id="var_end_num" name="var_end_num" type="text" placeholder="" value="<%=getVALUE(objRS,"END_NUM")%>" maxlength="50"></p></div>
        		            <div class="input-control text size3" data-role="input-control"><p><input id="var_end_compl" name="var_end_compl" type="text" placeholder="" value="<%=getVALUE(objRS,"END_COMPL")%>" maxlength="100"></p></div>
                		    <span class="tertiary-text-secondary"></span>
                    	</div>
                    </div> 
                    
                    <div class="row">
	                    <div class="span2"><p><%=objLang.SearchIndex("dialog_end_bairro",0)%>:</p></div>
	                    <div class="span8">
		                    <div class="input-control text size3" data-role="input-control"><p><input id="var_end_bairro" name="var_end_bairro" type="text" placeholder="" value="<%=getVALUE(objRS,"END_BAIRRO")%>" maxlength="80"></p></div>
       			            <span class="tertiary-text-secondary"></span>
                    	</div>
                    </div> 
                 
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dialog_end_cidade",0)%>:</p></div>
                        <div class="span8">
                            <div class="input-control text size3" data-role="input-control"><p><input id="var_end_cidade" name="var_end_cidade" type="text" placeholder="" value="<%=getVALUE(objRS,"END_CIDADE")%>" maxlength="100"></p></div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div>   
                    
                    <div class="row">
	                    <div class="span2"><p><%=objLang.SearchIndex("dialog_end_estado",0)%> / <%=objLang.SearchIndex("dialog_end_pais",0)%>:</p></div>
    	                <div class="span8">
							<div class="input-control text size3" data-role="input-control"><p><input id="var_end_estado" name="var_end_estado" type="text" placeholder="" value="<%=getVALUE(objRS,"END_ESTADO")%>" maxlength="100"></p></div>
                            <div class="input-control text size2" data-role="input-control"><p><input id="var_end_pais" name="var_end_pais" type="text" placeholder="" value="<%=getVALUE(objRS,"END_PAIS")%>" maxlength="30"></p></div>
		                    <span class="tertiary-text-secondary"></span>
        	            </div>
                    </div>               
                                        
                </div> <!--FIM GRID//-->
            </div><!--fim do frame endereco//-->
           
            <div class="frame" id="PALESTRANTE" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
	                <div class="grid" style="border:0px solid #F00">  
                        <div class="row">
                            <div class="span2"><p><%=objLang.SearchIndex("dialog_curriculo",0)%>:</p></div>
                            <div class="span8">
                                <div class="input-control textarea " data-role="input-control"><p><textarea name="var_curriculo" id="var_curriculo"><%=getVALUE(objRS,"CURRICULO")%></textarea></p></div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div> 
                        
                        <div class="row">
                            <div class="span2"><p><%=objLang.SearchIndex("dialog_area_atuacao",0)%>:</p></div>
                            <div class="span8">
                                <div class="input-control text " data-role="input-control"><p><input id="var_area_atuacao" name="var_area_atuacao" type="text" placeholder="" value="<%=getVALUE(objRS,"AREA_ATUACAO")%>" maxlength="255"></p></div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>

        
                        <div class="row">
                            <div class="span2"><p><%=objLang.SearchIndex("dialog_foto",0)%>:</p></div>
                            <div class="span8">
                                <div class="input-control file" data-role="input-control">
                                	<p>
	                                    <input type="text" readonly name="var_foto" id="var_foto" value="<%=getVALUE(objRS,"FOTO")%>" />
    	                                <button class="btn-file" onClick="javascript:UploadImage('formupdate','var_foto','\\palestrante\\img\\'); return false;"></button>
                                    </p>
                                </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>                 
                        
                        <div class="row">
                            <div class="span2"><p>&nbsp;</p></div>
                            <div class="span8"><p><img src="../palestrante/img/<%=getValue(objRS,"FOTO")%>" class="rounded" width="120" height="120"></p></div>
                        </div>
                
                </div> <!--FIM GRID//-->
            </div><!--fim do frame palestrante//-->
                 

		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    
    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
        <%  If ( (ucase(strPAX_CADASTRO) <> "EXIBIR") ) Then %>
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="<%=ucase(objLang.SearchIndex("dialog_but_aplicar",0))%>" onClick="javascript:aplicar();return false;"> 
        <% Else %>
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                           
        <% End If %>                  
        </div>
        <!-- div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigat&oacute;rios</small>
        </div //--> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
    
    <!-- Este form somente é utilizado para chamar a pesquisa de dados do CEO digitado //-->

    <form id="form_searchCEP" name="form_searchCEP" action="cep_find.asp" target="ifr_searchcep">
    	<input type="hidden" name="var_cep_search" id="var_cep_search" value="">
    </form>
    
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
