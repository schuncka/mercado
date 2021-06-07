<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_SiteInfo",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "FIN_CONTA_PAGAR_RECEBER"	    						' - Nome da Tabela...
 Const DKN = "COD_CONTA_PAGAR_RECEBER"			          			' - Campo chave...
 Const TIT = "FinContaPagarReceber" 
 
 'Relativas a conexão com DB, RecordSet e SQL
Dim objConn, objRS, objRSAux, strSQL
 'Relativas a FILTRAGEM e Seleção	
 Dim  i,  strIDINFO ,strCODIGO

Dim strLABEL_ENT, strLABEL_COR
Dim strLABEL_PARCELA
Dim strCOD_CONTA_PAGAR_RECEBER, strMSG, strEDICAO_TOTAL
dim strVAR_CODIGO,strENTIDADE
Dim strREAD_ONLY,strDISABLE_BTN

 
AbreDBConn objConn, CFG_DB 

strCOD_CONTA_PAGAR_RECEBER = GetParam("var_chavereg")

 	AbreDBConn objConn, CFG_DB 
	
 if strCOD_CONTA_PAGAR_RECEBER <> "" then

	'Este select em comparação com VB tem uma linha a menos em virtude da tbl_contrato nao existir no pVISTA "LEFT OUTER JOIN CONTRATO AS T5 ON (T1.COD_CONTRATO=T5.COD_CONTRATO) " 	&_
	strSQL =	"SELECT "											&_
				"	T1.COD_CONTA_PAGAR_RECEBER "					&_
				",	T1.TIPO "										&_
				",	T1.CODIGO "										&_
				",	T1.DT_EMISSAO "									&_
				",	T1.HISTORICO "									&_
				",	T1.TIPO_DOCUMENTO "								&_
				",	T1.NUM_DOCUMENTO "								&_
				",	T1.PAGAR_RECEBER "								&_
				",	T1.DT_VCTO "									&_
				",	T1.VLR_CONTA "									&_
				",	T2.NOME AS CONTA "								&_
				",	T1.COD_CONTA "									&_
				",	T3.NOME "										&_
				",	T1.SITUACAO "									&_
				",	T1.OBS "										&_
				",	T3.NOME AS PLANO_CONTA "						&_
				",	T3.COD_PLANO_CONTA "							&_
				",	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO "	&_
				",	T4.NOME AS CENTRO_CUSTO "						&_
				",	T4.COD_CENTRO_CUSTO "							&_
				",	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO "	&_
				",	T1.COD_NF "										&_
				",	T1.NUM_NF "										&_
				",	T1.ARQUIVO_ANEXO "								&_
				",	T1.MARCA_NFE "									&_
				",	T1.COD_CONTRATO "								&_
				",	T1.MARCA_NFE "									&_
				"FROM FIN_CONTA_PAGAR_RECEBER AS T1 " 				&_
				"LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) " 	&_
				"LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) " 	&_
				"LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " 	&_
				"WHERE T1.COD_CONTA_PAGAR_RECEBER=" & strCOD_CONTA_PAGAR_RECEBER
				'athDebug strSQL , true
				'",	T5.CODIFICACAO "	
				'"LEFT OUTER JOIN CONTRATO AS T5 ON (T1.COD_CONTRATO=T5.COD_CONTRATO) " 	&_
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
		if GetValue(objRS,"PAGAR_RECEBER") <> "0" then
			strLABEL_PARCELA = "Conta a Pagar"
			strLABEL_ENT     = "Pagar para:"		
			strLABEL_COR     = "fg-red" 'vermelho
		else
			strLABEL_PARCELA = "Conta a Receber"
			strLABEL_ENT     = "Receber de:"
			strLABEL_COR     = "fg-green" 'verde		
		end if
	
		
		strMSG = ""
		If GetValue(objRS, "SITUACAO") = "CANCELADA" Then 
			strMSG = strMSG & "Conta está cancelada<br>"
		end if	
		'If GetValue(objRS, "SITUACAO") <> "ABERTA" Then strMSG = strMSG & "Conta em situação diferente de aberta<br>"
		'If GetValue(objRS, "COD_NF") <> "" Then strMSG = strMSG & "Conta possui uma Nota Fiscal associada<br>"
		'If GetValue(objRS, "MARCA_NFE") = "COM_NFE" Then strMSG = strMSG & "Conta possui taxas calculadas e está marcada como tendo NFe<br>"
		
		strEDICAO_TOTAL = "F"
		'athDebug "strEDICAO_TOTAL_ini"&strEDICAO_TOTAL, false
		'athDebug  "<br> se for  ABERTA "& GetValue(objRS, "SITUACAO") & "<br>e igual SEM_NFE" & GetValue(objRS, "MARCA_NFE") & " <br>ou se marca nfe = vazio" & GetValue(objRS,"MARCA_NFE") , false
		If GetValue(objRS, "SITUACAO") = "ABERTA" And (GetValue(objRS, "MARCA_NFE") = "SEM_NFE" Or GetValue(objRS, "MARCA_NFE") = "") Then
			strEDICAO_TOTAL = "T"
		End If
		'athDebug "strEDICAO_TOTAL_fim"&strEDICAO_TOTAL, false
		
		If strMSG <> "" Then
			Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
			Response.End()
		End If
		
		If strEDICAO_TOTAL = "T" Then 
			strREAD_ONLY 	= "readonly"
			strDISABLE_BTN  =	"-off"
		end if
	
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script language="JavaScript" type="text/javascript">
function ok() { 
<% 	if (CFG_WINDOW = "NORMAL") then 
		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_FINTITULOS/default.asp';") 
 	else
		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
 	end if
%> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_FINTITULOS/Update.asp?var_chavereg=<%=strCOD_CONTA_PAGAR_RECEBER%>"; 
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
function BuscaCentroCusto() {	
	AbreJanelaPAGE_NOVA('busca_centrocusto.asp?var_form=formupdate&var_input1=var_cod_centro_custo&var_input2=var_nome_centro_custoô','520','620');
}
function BuscaPlanoConta() {	
	AbreJanelaPAGE_NOVA('Busca_planoconta.asp?var_form=formupdate&var_input1=var_cod_plano_conta&var_input2=var_nome_plano_contaô','520','620');
}


</script>
<!-- FIM----------------------------------------- funções //-->

</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
         <form name="formupdate" id="formupdate" action="updateexec.asp" method="post">
        <input type="hidden" name="JSCRIPT_ACTION" 				id="JSCRIPT_ACTION"   			value="" >
        <input type="hidden" name="DEFAULT_LOCATION" 			id="DEFAULT_LOCATION" 			value="Update.asp?var_chavereg=<%=strCOD_CONTA_PAGAR_RECEBER%>">
        <input type="hidden" name="var_chavereg" 				id="var_chavereg" 				value="<%=strCOD_CONTA_PAGAR_RECEBER%>">
        <input type="hidden" name="var_arquivo_anexo_orig" 		id="var_arquivo_anexo_orig" 	value="<%=GetValue(objRS, "ARQUIVO_ANEXO")%>">
        <input type="hidden" name="var_edicao_total" 			id="var_edicao_total" 			value="<%=strEDICAO_TOTAL%>">
        <input type="hidden" name="var_codigo" 					id="var_codigo" 				value="<%=getValue(objRS,"COD_CONTA")%>">
        <input type="hidden" name="var_cod_plano_conta" 		id="var_cod_plano_contaô"  		value="<%=getValue(objRS,"COD_PLANO_CONTA")%>" >
        <input type="hidden" name="var_cod_centro_custo" 		id="var_cod_centro_custoô"  	value="<%=getValue(objRS,"COD_CENTRO_CUSTO")%>" >
        <input type="hidden" name="var_tipo" 					id="var_tipo" 					value="<%=getValue(objRS,"TIPO")%>">

        <div class="tab-control" data-effect="fade" data-role="tab-control">
            <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_CONTA_PAGAR_RECEBER%>.GERAL</a></li>
            </ul>
            <div class="frames">
                <div class="frame" id="DADOS" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                    <div class="grid" style="border:0px solid #F00">  
                        <div class="row">
                            <div class="span2"><p>Operação:&nbsp;<span class="<%=strLABEL_COR%>"><%=strLABEL_PARCELA%></span></p></div>
                        </div> 
                        <div class="row">
                            <div class="span2"><p>*<%=strLABEL_ENT%></p></div>
                            <div class="span8">
                                <div  class="input-control text select " data-role="input-control">
                                <p>
                                    <input name='var_nome' id="var_nomeô" type='text' maxlength='10' value="<%=getValue(objRS,"CONTA")%>"  <%=strREAD_ONLY%>>
                                    <!--<span class="btn-search" onClick="Javascript:BuscaEntidade();"></span>//-->
                                </p>
                                <span class="tertiary-text-secondary"></span>
                                </div>
                            </div> 
                        </div>
                        <div class="row">
                            <div class="span2"><p>Plano deConta: </p></div>
                            <div class="span8">
                                <div  class="input-control text select " data-role="input-control">
                                    <p>
                                    <%
                                    strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME " 							&_
                                    " FROM FIN_PLANO_CONTA T1 "																&_
                                    " INNER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_PLANO_CONTA = T2.COD_PLANO_CONTA) " 	&_
                                    " WHERE T1.DT_INATIVO IS NULL " &_
                                    " AND ((T2.DT_EMISSAO > DATE_SUB(CURDATE(), INTERVAL 60 DAY) OR (T1.COD_PLANO_CONTA = '" & GetValue(objRS, "COD_PLANO_CONTA") & "'))) " 		&_
                                    " ORDER BY 2 "
                                    'athDebug strSQL , false
                                    Set objRSAux = objConn.Execute(stRSQL)
                                    %>                                
                                    	<input name='var_nome_plano_conta' id="var_nome_plano_conta" type='text' maxlength='10' value="<%=getValue(objRSAux,"NOME")%>"  <%=strREAD_ONLY%>>
                                    <% FechaRecordSet objRSAux %>                                     
                                    	<span class="btn-search<%=strDISABLE_BTN%>" onClick="Javascript:BuscaPlanoConta();"></span>
                                    </p>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                            </div> 
                        </div>
                        <div class="row">
                            <div class="span2"><p>Centro de Custo:</p></div>
                            <div class="span8">
                                <p class="input-control select text" data-role="input-control">
                                <%
									strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME "												&_
									" FROM FIN_CENTRO_CUSTO T1 "																	&_
									" LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_CENTRO_CUSTO=T2.COD_CENTRO_CUSTO) "	&_
									" WHERE T1.DT_INATIVO IS NULL " &_
									" AND ((T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_CENTRO_CUSTO = " & GetValue(objRS, "COD_CENTRO_CUSTO") & ")) " 		&_
									" ORDER BY 2 "
									'athDebug strSQL , false
									Set objRSAux = objConn.Execute(stRSQL)
                                %>
                                	<input name='var_nome_centro_custo' id="var_nome_centro_custo" type='text' maxlength='10' value="<%=GetValue(objRSAux, "NOME")%>"  <%=strREAD_ONLY%>>
                                <% FechaRecordSet objRSAux %>  
                                	<span class="btn-search<%=strDISABLE_BTN%>" onClick="Javascript:BuscaCentroCusto();"></span>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>                            
                        <div class="row">
                            <div class="span2"><p>Número:</p></div>
                            <div class="span8">
                                <p class="input-control text " data-role="input-control">
                                <input name="var_num_documento" id="var_num_documento" type="text" value="<%=getValue(objRS,"NUM_DOCUMENTO")%>"  maxlength="50" <%=strREAD_ONLY%>>
                            </p>
                            <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="span2"><p>Valor:</p></div>
                            <div class="span8">
                                 <p class="input-control text " data-role="input-control">
                                    <input name="var_vlr_conta" id="var_vlr_conta" type="text" maxlength="15" onKeyPress="validateFloatKey();" value="<%=getValue(objRS,"VLR_CONTA")%>" <%=strREAD_ONLY%>>
                                 </p>
                                 <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="span2"><p>Tipo Documento:</p></div>
                            <div class="span8">
                                 <p class="input-control text" data-role="input-control">
                                    <input name="var_documento" id="var_documento" value="<%=getValue(objRS,"TIPO_DOCUMENTO")%>" <%=strREAD_ONLY%>>
                                 </p>
                                 <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>
                        <div class="row">
                                <div class="span2"><p>Data Vcto:</p></div>
                                <div class="span8">
                                    <div class="input-control text " data-role="input-control">
                                        <p class="input-control text " data-role="datepicker"  data-format="yyyy/mm/dd" data-position="top|bottom" data-effect="none|slide|fade">
                                            <input name="var_dt_vcto" id="var_dt_vcto" type="text" placeholder="<%=Date%>" value="<%=getValue(objRS,"DT_VCTO")%>" maxlength="20" class=""  <%=strREAD_ONLY%>>
                                            <span class="btn-date<%=strDISABLE_BTN%>"></span>
                                        </p>
                                    </div>
                                     <span class="tertiary-text-secondary"><a href="" onClick="document.getElementById('var_dt_lcto').value=''; return false;// Limpa o campo">[LIMPAR DATA]</a></span>
                                </div>
                         </div>
                        <div class="row">
                            <div class="span2"><p>Data Emissão:</p></div>
                            <div class="span8">
                                <div class="input-control text " data-role="input-control">
                                    <p class="input-control text " data-role="datepicker"  data-format="yyyy/mm/dd" data-position="top|bottom" data-effect="none|slide|fade">
                                        <input name="var_dt_emissao" id="var_dt_emissao" type="text" placeholder="<%=Date%>" value="<%=getValue(objRS,"DT_EMISSAO")%>" maxlength="20" class=""  <%=strREAD_ONLY%>>
                                        <span class="btn-date<%=strDISABLE_BTN%>"></span>
                                    </p>
                                </div>
                                 <span class="tertiary-text-secondary"><a href="" onClick="document.getElementById('var_dt_emissaoô').value=''; return false;// Limpa o campo">[LIMPAR DATA]</a></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="span2"><p>*Histórico:</p></div>
                            <div class="span8">
                                 <p class="input-control text " data-role="input-control">
                                    <input name="var_historico" id="var_historicoô" type="text" maxlength="50" value="<%=getValue(objRS,"HISTORICO")%>" <%=strREAD_ONLY%>>
                                 </p>
                                 <span class="tertiary-text-secondary"></span>
                            </div>
                         </div>
                         <div class="row">
                            <div class="span2"><p>Observação:</p></div>
                            <div class="span8">
                                 <p class="input-control textarea " data-role="input-control">
                                    <textarea name="var_obs" id="var_obs"><%=getValue(objRS,"OBS")%></textarea>
                                 </p>
                                 <span class="tertiary-text-secondary"></span>
                            </div>
                         </div>
                        <div class="row">
                            <div class="span2"><p>Upload Imagens:</p></div>
                            <div class="span8">
                                <div class="input-control file">
                                    <p>
                                        <input type="text" name="var_arquivo_anexo" id="var_arquivo_anexo" />
                                        <button class="btn-file" onClick="javascript:UploadImage('forminsert','var_arquivo_anexo','\\imgdin\\');"></button>
                                    </p>
                                </div>                     
                            	<span class="tertiary-text-secondary">Atalho para upload na pasta \IMGDIN </span>                             
                            </div>
                        </div>              
                    </div> <!--FIM GRID//-->
                </div><!--fim do frame dados//-->
            </div><!--FIM - FRAMES//-->
        </div><!--FIM TABCONTROL//--> 

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
	end if
end if
FechaDBConn objConn
%>