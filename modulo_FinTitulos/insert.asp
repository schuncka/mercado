<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Cadastro",Session("ID_USER")), true %>
<%
 Const LTB = "FIN_CONTA_PAGAR_RECEBER"	    						' - Nome da Tabela...
 Const DKN = "COD_CONTA_PAGAR_RECEBER"			          			' - Campo chave...
 Const TIT = "FinContaPagarReceber" 

Dim objConn, objRS, strSQL
Dim strCODIGO, strTIPO
Dim strTIPO_CONTA, strTITLE 
Dim strLABEL_ENT, strLABEL_COR,strLABEL
Dim strCOD_CONTA, strLABEL_PARCELA,strVAR_CODIGO
Dim strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA, strCOD_NF
Dim strNUM_NF, strVLR_CONTA, strDOCUMENTO, strNUM_DOCUMENTO
Dim strVAR_COD_PLANOCONTA,strVAR_COD_CENTROCUSTO,strVAR_CODIGO_HINT


'-----------functions AthUtils Vboss---------------------
Function ShowLinkCalendario(prForm, prCampo, prHint)
	ShowLinkCalendario = "<a href='javascript:void(0)' " &_
						 "onClick=""if(self.gfPop)gfPop.fPopCalendar(document." & prForm & "." & prCampo & ");return false;"">" &_
						 "<img class='PopcalTrigger' src='../img/bullet_dataatual.gif' " &_
						 "border='0' style='cursor:hand; vertical-align:top; padding-top:2px;' vspace='0' hspace='0' alt='" & prHint & "' title='" & prHint & "'>" &_
						 "</a>"
End Function


function InputDate(prName, prClass, prValue, prReadOnly)
Dim strInput, strDate
	strDate = ""
	if prValue<>"" then	strDate = PrepData(prValue,true,false)

	strInput = "<input name='" & prName & "' id='" & prName & "'"
	if prClass<>"" then strInput = strInput & " class='" & prClass & "'" end if
	strInput = strInput & " value='" & strDate & "'" 	
	strInput = strInput & " type='text' maxlength='10' style='width:70px;'"
	strInput = strInput & " onKeyPress='Javascript:validateNumKey();'"	
	strInput = strInput & " onKeyUp='Javascript:FormataInputData(this.form.name, this.name);'"
	
	if prReadOnly then strInput = strInput &  " readonly"

	strInput = strInput & ">"
		
	InputDate = strInput
end function
'--------------------------------------------------------




AbreDBConn objConn, CFG_DB 

strCOD_CONTA = GetParam("var_chavereg")	
 strTIPO = ""
 strTIPO_CONTA = GetParam("var_tipo")

if   strTIPO_CONTA<>"" then
	if   strTIPO_CONTA		= "PG" then
		strLABEL 		= "Conta Pagar"
		strLABEL_ENT 	= "Pagar para"
		strLABEL_COR 	= "fg-red" 'vermelho
	else
		strLABEL = "RC"
		strLABEL 	 = "Conta Receber"
		strLABEL_ENT = "Receber de"
		strLABEL_COR = "fg-green" 'verde		
	end if 
	
	'strDIA = DatePart("D", Date)
	'strMES = DatePart("M", Date)
	'strANO = DatePart("YYYY", Date)
	
	%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script language="JavaScript" type="text/javascript">
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
<% 	if (CFG_WINDOW = "NORMAL") then 
		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_FINTITULOS/default.asp';") 
 	else
		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
 	end if
%> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_FINTITULOS/insert.asp"; 
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

function BuscaEntidade() {	
	AbreJanelaPAGE_NOVA('Busca_Entidade.asp?var_form=forminsert&var_input1=var_codigo&var_input2=var_nomeô','520','620');
}
function BuscaCentroCusto() {	
	AbreJanelaPAGE_NOVA('busca_centrocusto.asp?var_form=forminsert&var_input1=var_cod_centro_custo&var_input2=var_nome_centro_custoô','520','620');
}
function BuscaPlanoConta() {	
	AbreJanelaPAGE_NOVA('Busca_planoconta.asp?var_form=forminsert&var_input1=var_cod_plano_conta&var_input2=var_nome_plano_contaô','520','620');
}

function viewdoc(doc) {
  var conteudo = '';
  
  if(doc!='') {
    conteudo = eval('document.forminsert.DBVAR_STR_' + doc + '.value');
  }
  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}
function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '	../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

</script>
</head>
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">INSERT</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
        <form name="forminsert" id="forminsert" action="../modulo_FINTITULOS/Insertexec.asp" method="post">
        <input type="hidden"	name="var_tipo_conta" 			id="var_tipo_conta"  		value="<%=strTIPO_CONTA%>">
        <input type="hidden"	name="var_cod_nf" 				id="var_cod_nf"  			value="<%=strCOD_NF%>">
        <input type="hidden"	name="var_num_nf" 				id="var_num_nf"  			value="<%=strNUM_NF%>">
        <input type="hidden" 	name="var_tipo" 				id="var_tipo" 				value="TBL_EMPRESAS">
        <input type='hidden' 	name='var_codigo' 				id="var_codigoô"  			value="<%=strVAR_CODIGO%>">
        <input type="hidden" 	name="var_cod_plano_conta" 		id="var_cod_plano_contaô"  	value="<%=strVAR_CODIGO%>" >
        <input type="hidden" 	name="var_cod_centro_custo" 	id="var_cod_centro_custoô"  value="<%=strVAR_CODIGO%>" >
        <input type="hidden" 	name="DEFAULT_LOCATION" 		id="DEFAULT_LOCATION" 		value="../modulo_FINTITULOS/insert.asp?var_tipo=<%=strTIPO_CONTA%>">
        <input type="hidden"	name="JSCRIPT_ACTION" 			id="JSCRIPT_ACTION"  		value="">
          <div class="tab-control" data-effect="fade" data-role="tab-control">
                <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                    <li class="active"><a href="#DADOS">GERAL</a></li>
                    <li class=""><a href="#PERIODICIDADE">PERIODICIDADE</a></li>                    
                </ul>
                <div class="frames">
                    <div class="frame" id="DADOS" style="width:100%;">
                        <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                        <div class="grid" style="border:0px solid #F00">  
				<div class="row">
                    <div class="span2"><p>*Operação:<span class="<%=strLABEL_COR%>">&nbsp;<%=strLABEL%></span></p></div>
                </div> 
                <div class="row">
                    <div class="span2"><p>*Conta</p></div>
                    <div class="span8"><p class="input-control select" data-role="input-control">
                       <select name="var_cod_conta" id="var_cod_contaô">
                       <option value="">[Selecione]</option> 
                        <%
							strSQL = " SELECT COD_CONTA, NOME FROM FIN_CONTA "
							If strCOD_CONTA = "" Then strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
							strSQL = strSQL & " ORDER BY NOME "
							
							Set objRS = objConn.Execute(strSQL)
							
							Do While Not objRS.Eof
								Response.Write("<option value='" & GetValue(objRS, "COD_CONTA") & "'")
								If CStr(strCOD_CONTA) = CStr(GetValue(objRS, "COD_CONTA")) Then Response.Write(" selected")
								Response.Write(">" & GetValue(objRS, "NOME") & "</option>")
								
								objRS.MoveNext
							Loop
							
							FechaRecordSet objRS
                        %>
                         </select></p>
                    </div>
                </div>
                <div class="row">
                        <div class="span2"><p>*<%=strLABEL_ENT%>: </p></div>
                        <div class="span8">
                            <div  class="input-control text select " data-role="input-control">
                                <p>
                                     <input name='var_nome' id="var_nomeô" type='text' maxlength='10' value=""  readonly>
                                    <span class="btn-search" onClick="Javascript:BuscaEntidade();"></span>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div> 
                 </div>
                <div class="row">
                    <div class="span2"><p>*Plano de Conta:</p></div>
                    <div class="span8"><p class="input-control select text" data-role="input-control" >
                    
                    			<input name="var_nome_plano_conta" id="var_nome_plano_contaô" type="text" maxlength="10" value=""  readonly>
                               <span class="btn-search" onClick="Javascript:BuscaPlanoConta();"></span>
                            </p>
                            <span class="tertiary-text-secondary"></span>
                            </div>
                 </div>
                <div class="row">
                    <div class="span2"><p>*Centro de Custo:</p></div>
                    <div class="span8">
                        <p class="input-control select text" data-role="input-control">
                            <input name='var_nome_centro_custo' id="var_nome_centro_custoô" type='text' maxlength='10' value=""   readonly>
                            <span class="btn-search" onClick="Javascript:BuscaCentroCusto();"></span>
                        </p>
                            <span class="tertiary-text-secondary"></span>
                            </div>
                 </div>
                <div class="row">
                        <div class="span2"><p>*Número:</p></div>
                        <div class="span8">
                             <p class="input-control text " data-role="input-control">
                                <input name="var_num_documento" id="var_num_documentoô" type="text" value=""  maxlength="50">
                             </p>
                             <span class="tertiary-text-secondary"></span>
                        </div>
                 </div>
                <div class="row">
                        <div class="span2"><p>*Valor:</p></div>
                        <div class="span8">
                             <p class="input-control text " data-role="input-control">
                                <input name="var_vlr_conta" id="var_vlr_contaô" type="text" maxlength="15" onKeyPress="validateFloatKey();" value="">
                             </p>
                             <span class="tertiary-text-secondary"></span>
                        </div>
                 </div>
                 <div class="row">
                        <div class="span2"><p>*Tipo Documento:</p></div>
                        <div class="span8">
                             <p class="input-control select " data-role="input-control">
                                <select name="var_documento" id="var_documentoô">
                                	<option value="BOLETO"           <% If strDOCUMENTO = ""           		 Then Response.Write("selected") %>>[Selecione]</option>
                                    <option value="BOLETO"           <% If strDOCUMENTO = "BOLETO"           Then Response.Write("selected") %>>Boleto</option>
                                    <option value="CHEQUE"           <% If strDOCUMENTO = "CHEQUE"           Then Response.Write("selected") %>>Cheque</option>
                                    <option value="DOC"              <% If strDOCUMENTO = "DOC"              Then Response.Write("selected") %>>Doc</option>
                                    <option value="DUPLICATA"        <% If strDOCUMENTO = "DUPLICATA"        Then Response.Write("selected") %>>Duplicata</option>
                                    <option value="FATURA"           <% If strDOCUMENTO = "FATURA"           Then Response.Write("selected") %>>Fatura</option>
                                    <option value="NOTA_FISCAL"      <% If strDOCUMENTO = "NOTA_FISCAL"      Then Response.Write("selected") %>>Nota Fiscal</option>
                                    <option value="NOTA_PROMISSORIA" <% If strDOCUMENTO = "NOTA_PROMISSORIA" Then Response.Write("selected") %>>Nota Promissória</option>
                                    <option value="TED"              <% If strDOCUMENTO = "TED"              Then Response.Write("selected") %>>TED</option>
                                    <option value="OUTROS"           <% If strDOCUMENTO = "OUTROS"           Then Response.Write("selected") %>>Outros</option>
                                </select>
                             </p>
                             <span class="tertiary-text-secondary"></span>
                        </div>
                 </div>
                <div class="row">
                        <div class="span2"><p>*Data Vcto:</p></div>
                        <div class="span8">
                            <div class="input-control text " data-role="input-control">
                                <p class="input-control text " data-role="datepicker"  data-format="yyyy/mm/dd" data-position="top|bottom" data-effect="none|slide|fade">
                                    <input name="var_dt_vcto" id="var_dt_vctoô" type="text" placeholder="<%=Date%>" value="" maxlength="20" class=""  >
                                    <span class="btn-date"></span>
                                </p>
                            </div>
                             <span class="tertiary-text-secondary"><a href="" onClick="document.getElementById('var_dt_lcto').value=''; return false;// Limpa o campo">[LIMPAR DATA]</a></span>
                        </div>
                 </div>
                 <div class="row">
                        <div class="span2"><p>*Data Emissão:</p></div>
                        <div class="span8">
                            <div class="input-control text " data-role="input-control">
                                <p class="input-control text " data-role="datepicker"  data-format="yyyy/mm/dd" data-position="top|bottom" data-effect="none|slide|fade">
                                    <input name="var_dt_emissao" id="var_dt_emissaoô" type="text" placeholder="<%=Date%>" value="" maxlength="20" class=""  >
                                    <span class="btn-date"></span>
                                </p>
                            </div>
                             <span class="tertiary-text-secondary"><a href="" onClick="document.getElementById('var_dt_emissaoô').value=''; return false;// Limpa o campo">[LIMPAR DATA]</a></span>
                        </div>
                 </div>
                <div class="row">
                        <div class="span2"><p>Histórico:</p></div>
                        <div class="span8">
                             <p class="input-control text " data-role="input-control">
                                <input name="var_historico" id="var_historicoô" type="text" maxlength="250" >
                             </p>
                             <span class="tertiary-text-secondary"></span>
                        </div>
                 </div>
                <div class="row">
                        <div class="span2"><p>Observação:</p></div>
                        <div class="span8">
                             <p class="input-control textarea " data-role="input-control">
                                <textarea name="var_obs" id="var_obs" rows="7" ></textarea>
                             </p>
                             <span class="tertiary-text-secondary"></span>
                        </div>
                 </div>
                <div class="row">
                    <div class="span2"><p>Upload Imagens:</p></div>
                    <div class="span8">
                        <div class="input-control file">
                            <input type="text" name="var_arquivo_anexo" id="var_arquivo_anexo" />
                            <button class="btn-file" onClick="javascript:UploadImage('forminsert','var_arquivo_anexo','\\imgdin\\');"></button>
                            <span class="tertiary-text-secondary"></span>
                        </div>                     
                        	<span class="tertiary-text-secondary">Atalho para upload na pasta \IMGDIN </span>                             
                        </div>
                    </div>
            	</div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            <div class="frame" id="PERIODICIDADE" style="width:100%;">
            <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
                    <div class="row">
                        <div class="span2"><p>Periodicidade:</p></div>
                        <div class="span8">
                            <p class="input-control text select " data-role="input-control">
                            	O sistema deve gerar no total&nbsp;<input name="var_parcelas" id="var_parcelas" class="size2" value="" type="text" maxlength="3"  onFocus="this.value='';" onKeyPress="validateNumKey();"><%=strLABEL_PARCELA%>
                  <br>com freqüência&nbsp;<select name="var_frequencia" id="var_frequencia" size="1" class="size2">
                                            <option value="" selected> [selecione]</option>
                                            <option value="DIARIA">    Diária	  </option>
                                            <option value="SEMANAL">   Semanal	  </option>
                                            <option value="QUINZENAL"> Quinzenal  </option>
                                            <option value="MENSAL">    Mensal	  </option>
                                            <option value="BIMESTRAL"> Bimestral  </option>
                                            <option value="TRIMESTRAL">Trimestral </option>
                                            <option value="SEMESTRAL"> Semestral  </option>
                                            <option value="ANUAL">     Anual	  </option>
                                        </select>
                            </p>
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
end if
FechaDBConn objConn
%>