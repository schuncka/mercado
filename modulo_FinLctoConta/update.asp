<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Cadastro",Session("ID_USER")), true %>
<%

Const LTB = "FIN_LCTO_EM_CONTA"		' - Nome da Tabela...
Const DKN = "COD_LCTO_EM_CONTA"      	' - Campo chave...
Const TIT = "Lançamento em Conta"		' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro


Dim strCODIGO,strENTIDADE
Dim objConn, objRS, objRSAux, objRSa, strSQL
Dim strVAR_CODIGO
Dim strTIPO_LCTO 
Dim strLABEL, strLABEL_ENT
Dim strLABEL_COR, strCOD_CONTA
Dim strDIA, strMES, strANO
Dim strINS_LCTO_NO_MES
Dim strVAR_COD_PLANOCONTA,strVAR_COD_CENTROCUSTO,strVAR_CODIGO_HINT

AbreDBConn objConn, CFG_DB 

strCODIGO 	 = GetParam("var_chavereg")
strTIPO_LCTO = GetParam("var_tipo")

'athDebug "[debug]:teste1"&strCODIGO&"<br>", false
 
if strCODIGO <> "" then

'athDebug "[debug]:teste2"&strCODIGO&"<br>", false
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	" SELECT LCTO.COD_LCTO_EM_CONTA "&_	
				"		,PLAN.NOME "&_	
				"		,LCTO.OPERACAO "&_	
				"		,LCTO.CODIGO "&_	
				"		,LCTO.TIPO "&_	
				"		,LCTO.COD_CONTA " &_
				"		,PLAN.COD_REDUZIDO "&_
				"		,CTA.NOME AS CONTA "&_
				"		,LCTO.COD_PLANO_CONTA " &_
				"		,PLAN.NOME AS PLANO_CONTA "	&_	
				"		,LCTO.COD_CENTRO_CUSTO " &_
				"		,CUST.NOME AS CENTRO_CUSTO "&_	
				"		,LCTO.HISTORICO "&_
				"		,LCTO.OBS "	&_					
				"		,LCTO.NUM_LCTO "&_	
				"		,LCTO.VLR_LCTO "&_		
				"		,LCTO.DT_LCTO "	&_	
				" FROM FIN_LCTO_EM_CONTA LCTO "	&_	
				" LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA = LCTO.COD_PLANO_CONTA) "	&_	
				" LEFT OUTER JOIN FIN_CENTRO_CUSTO CUST ON (CUST.COD_CENTRO_CUSTO = LCTO.COD_CENTRO_CUSTO) "	&_	
				" LEFT OUTER JOIN FIN_CONTA CTA ON (LCTO.COD_CONTA=CTA.COD_CONTA) "	&_	
				" WHERE LCTO.COD_LCTO_EM_CONTA=" & strCODIGO	
		''athDebug strSQL ,false
				
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
		strSQL=""					 
		if GetValue(objRS, "TIPO")="ENT_CLIENTE"     and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_CLIENTE     WHERE COD_CLIENTE     = " & GetValue(objRS,"CODIGO")
		if GetValue(objRS, "TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR  WHERE COD_FORNECEDOR  = " & GetValue(objRS,"CODIGO")
		if GetValue(objRS, "TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME                  FROM ENT_COLABORADOR WHERE COD_COLABORADOR = " & GetValue(objRS,"CODIGO")
	
		strENTIDADE=""
		if strSQL<>"" then 
			Set objRSa = objConn.Execute(strSQL)
			if not objRSa.Eof then strENTIDADE = GetValue(objRSa, "NOME")
			FechaRecordSet objRSa
		end if 
		'athDebug "[debug]:teste3"&strCODIGO&"<br>", false
		if strTIPO_LCTO = "" then
			strTIPO_LCTO = getValue(objRS,"TIPO")
		end if
		
		'athDebug "tipo:"&strTIPO_LCTO&"<br>", false
				
		
			strDIA = DatePart("D", Date)
			strMES = DatePart("M", Date)
			strANO = DatePart("YYYY", Date)		
			'athDebug "[debug]:teste4"&strCODIGO&"<br>", false
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script language="JavaScript" type="text/javascript">
function ok() { 
<% 	if (CFG_WINDOW = "NORMAL") then 
		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_FINLCTOCONTA/default.asp';") 
 	else
		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
 	end if
%> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_FINLCTOCONTA/update.asp"; 
  if (validateRequestedFields("formupdate")) { 
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
function BuscaCentroCusto() {	
	AbreJanelaPAGE_NOVA('busca_centrocusto.asp?var_form=formupdate&var_input1=var_cod_centro_custo&var_input2=var_nome_centro_custoô','520','620');
}
function BuscaPlanoConta() {	
	AbreJanelaPAGE_NOVA('Busca_planoconta.asp?var_form=formupdate&var_input1=var_cod_plano_conta&var_input2=var_nome_plano_contaô','520','620');
}


</script>
</head>
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ------------------------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
<form name="formupdate" id="formupdate" action="updateexec.asp" method="post">
    <input type="hidden" name="JSCRIPT_ACTION"   value=''>
    <input type="hidden" name="DEFAULT_LOCATION" value="Update.asp?var_chavereg=<%=strCODIGO%>">
    <input type="hidden" name="var_cod_chavereg" value="<%=strCODIGO%>">
    <input type="hidden" name="var_cod_plano_conta" id="var_cod_plano_contaô"  value="<%=getValue(objRS,"COD_PLANO_CONTA")%>" >
    <input type="hidden" name="var_cod_centro_custo" id="var_cod_centro_custoô"  value="<%=getValue(objRS,"COD_CENTRO_CUSTO")%>" >
          <div class="tab-control" data-effect="fade" data-role="tab-control">
                <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                    <li class="active"><a href="#DADOS"><%=strCODIGO%>.GERAL</a></li>
                </ul>
                <div class="frames">
                    <div class="frame" id="DADOS" style="width:100%;">
                        <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                        <div class="grid" style="border:0px solid #F00">  
				<div class="row">
                    <div class="span2"><p>*Código:<%=strCODIGO%></span></p></div>
                </div> 
				<div class="row">
                    <div class="span2"><p>*Operação:<%=GetValue(objRS,"OPERACAO")%></span></p></div>
                </div>
<div class="row">
                    <div class="span2"><p>*Entidade:<%=strENTIDADE%></p></div>
                </div>                 
                <div class="row">
                    <div class="span2"><p>*Conta:<%=getValue(objRS,"COD_CONTA")%>-<%=getValue(objRS,"NOME")%></p></div>
                </div>
                <div class="row">
                        <div class="span2"><p>Plano deConta: </p></div>
                        <div class="span8">
                            <div  class="input-control text select " data-role="input-control">
                                <p>
									<%
                                    strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME " 	&_
                                         " FROM FIN_PLANO_CONTA T1, FIN_LCTO_EM_CONTA T2 "	&_
                                         " WHERE T1.DT_INATIVO IS NULL " 					&_
										 " AND T2.COD_LCTO_EM_CONTA=" & strCODIGO		&_
                                         " AND T1.COD_PLANO_CONTA = T2.COD_PLANO_CONTA " 	&_
                                         " AND ((T2.DT_LCTO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_PLANO_CONTA = " & GetValue(objRS, "COD_PLANO_CONTA") & ")) " &_
                                         " ORDER BY T1.NOME "
										 'athDebug strSQL , false
                                    Set objRSAux = objConn.Execute(stRSQL)
                                    %>                                
                                    <input name='var_nome_plano_conta' id="var_nome_plano_contaô" type='text' maxlength='10' value="<%=getValue(objRSAux,"NOME")%>"  readonly>
                                    <% FechaRecordSet objRSAux %>                                     
                                    <span class="btn-search" onClick="Javascript:BuscaPlanoConta();"></span>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div> 
                 </div>
                <div class="row">
                    <div class="span2"><p>*Centro de Custo:</p></div>
                    <div class="span8">
                        <p class="input-control select text" data-role="input-control">
									<%
                        strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME "	&_
									 " FROM FIN_CENTRO_CUSTO T1, FIN_LCTO_EM_CONTA T2 "	&_
									 " WHERE T1.DT_INATIVO IS NULL " 					&_ 
									 " AND T2.COD_LCTO_EM_CONTA=" & strCODIGO		&_
									 " AND T1.COD_CENTRO_CUSTO = T2.COD_CENTRO_CUSTO "	&_
									 " AND ((T2.DT_LCTO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_CENTRO_CUSTO = " & GetValue(objRS, "COD_CENTRO_CUSTO") & ")) " &_
									 " ORDER BY T1.NOME "
									 'athDebug strSQL , false
									 Set objRSAux = objConn.Execute(stRSQL)
									%>
                            <input name='var_nome_centro_custo' id="var_nome_centro_custoô" type='text' maxlength='10' value="<%=GetValue(objRSAux, "NOME")%>"  readonly>
                           <% FechaRecordSet objRSAux %>  
                            <span class="btn-search" onClick="Javascript:BuscaCentroCusto();"></span>
                        </p>
                        <span class="tertiary-text-secondary"></span>
                    </div>
                </div>
                <div class="row">
                    <div class="span2"><p>*Histórico: <%=getValue(objRS,"HISTORICO")%></p></div>
                </div>
                <div class="row">
                    <div class="span2"><p>*Número: <%=getValue(objRS,"NUM_LCTO")%></p></div>
                </div>
                <div class="row">
                    <div class="span2"><p>*Valor: <%=getValue(objRS,"VLR_LCTO")%></p></div>
                </div>
                <div class="row">
                    <div class="span2"><p>*Data:  <%=getValue(objRS,"DT_LCTO")%></p></div>
                </div>
                <div class="row">
                    <div class="span2"><p>*Observação:</p></div>
                    <div class="span8">
                         <p class="input-control textarea " data-role="input-control">
                            <%=getValue(objRS,"OBS")%>
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
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
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
	end if
	FechaRecordSet objRS		
end if	
FechaDBConn objConn


%>