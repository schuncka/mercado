<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Cadastro",Session("ID_USER")), true %>
<%
 Const LTB = "FIN_CONTA" 					' - Nome da Tabela...
 Const DKN = "COD_CONTA"      				' - Campo chave...
 Const TIT = "TRANSFERÊNCIA"		' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

Dim strCOD_CONTA
Dim strDIA, strMES, strANO
Dim strINS_LCTO_NO_MES

Dim objConn, objRS, strSQL

AbreDBConn objConn, CFG_DB 

strCOD_CONTA = GetParam("var_chavereg") 

strDIA = DatePart("D", Date)
strMES = DatePart("M", Date)
strANO = DatePart("YYYY", Date)

strINS_LCTO_NO_MES = "F"
If VerificaDireito("|INS_NO_MES|", BuscaDireitosFromDB("modulo_FIN_LCTOCONTA", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then
	strINS_LCTO_NO_MES = "T"
End If

%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.forminsert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() {window.close(); }
function aplicar()  { document.forminsert.JSCRIPT_ACTION.value = ""; submeterForm(); }
//****** Funções de ação dos botões - Fim ******

function submeterForm() {
	var var_msg = '';
	var var_vlr_lcto;
	var arrData, var_dt_lcto;
	var MesLcto, AnoHoje, AnoLcto;

    var prDiaHoje = '<%=strDIA%>';
	var prMesHoje = '<%=strMES%>';
	var prAnoHoje = '<%=strANO%>';
	var prInsLctoNoMes = '<%=strINS_LCTO_NO_MES%>';
	
	if (document.forminsert.var_cod_conta_orig.value == '') var_msg += '\nParâmetro inválido para conta de origem';
	if (document.forminsert.var_cod_conta_dest.value == '') var_msg += '\nParâmetro inválido para conta de destino';
	if ((document.forminsert.var_cod_conta_orig.value != '') && (document.forminsert.var_cod_conta_dest.value != '') && (document.forminsert.var_cod_conta_orig.value == document.forminsert.var_cod_conta_dest.value)) var_msg += '\nContas devem ser diferentes';
	if (document.forminsert.var_num_lcto.value == '') var_msg += '\nInformar número do lançamento';
	if (document.forminsert.var_historico.value == '') var_msg += '\nInformar histórico';
	if (document.forminsert.var_dt_lcto.value == '') var_msg += '\nInformar data do lançamento';
	if (document.forminsert.var_dt_lcto.value != '') {
		arrData = document.forminsert.var_dt_lcto.value;
		arrData = arrData.split("/");
		
		DiaLcto = arrData[0];
		MesLcto = arrData[1];
		AnoLcto = arrData[2];
		
		DiaLcto = Number(DiaLcto);
		AnoLcto = Number(AnoLcto);
		MesLcto = Number(MesLcto);
		
		prDiaHoje = Number(prDiaHoje);
		prMesHoje = Number(prMesHoje);
		prAnoHoje = Number(prAnoHoje);
		
		if ((AnoLcto > prAnoHoje) || ((MesLcto > prMesHoje) && (AnoLcto == prAnoHoje)) || ((DiaLcto > prDiaHoje) && (MesLcto == prMesHoje) && (AnoLcto == prAnoHoje))) 
			var_msg += '\nNão é permitido lançamento com data futura (' + document.forminsert.var_dt_lcto.value + ')';
		//Se tiver direito INS_NO_MES é porque só pode inserir no mês corrente
		if (prInsLctoNoMes == 'T') 
			if (((MesLcto != prMesHoje) && (AnoLcto == prAnoHoje)) || (AnoLcto != prAnoHoje)) 
				var_msg += '\nNão é permitido lançamento fora do mês corrente (' + document.forminsert.var_dt_lcto.value + ')';
	}
	if (document.forminsert.var_vlr_lcto.value != '') {
		var_vlr_lcto = eval("document.forminsert.var_vlr_lcto.value");
		var_vlr_lcto = var_vlr_lcto.toString();
		var_vlr_lcto = var_vlr_lcto.replace(',', '.');
		
		if (var_vlr_lcto <= 0) var_msg += '\nInformar valor válido para lançamento';
	}
	else {
		var_msg += '\nInformar valor válido para lançamento';
	}
	
	if (var_msg == '') {
		document.forminsert.submit();
	}
	else {
		alert('Verificar mensagem(ns) abaixo:\n' + var_msg);
		return false;
	}
}
</script>
</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">INSERT</span></sup>
</div>
<!-- FIM:BARRA ------------------------------------------------------------ //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
    <form name="forminsert" action="../mini_lctotransf/Insertexec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION" value=''>
	<input type="hidden" name="DEFAULT_LOCATION" id="DEFAULT_LOCATION" value='../mini_lctotransf/Insert.asp'>
          <div class="tab-control" data-effect="fade" data-role="tab-control">
                <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                    <li class="active"><a href="#DADOS">GERAL</a></li>
                </ul>
                <div class="frames">
                    <div class="frame" id="DADOS" style="width:100%;">
                        <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                        <div class="grid" style="border:0px solid #F00">  
                            <div class="row">
                                    <div class="span2"><p>*Banco:</p></div>
                                    <div class="span8">
                                        <p class="input-control select text " data-role="input-control">
                                            <select name="var_cod_conta_orig" id="var_cod_conta_origô" >
                                            <option value="" selected>[Selecione]<option>
											<%
                                            strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
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
                                            </select>
                                        </p>
                                         <span class="tertiary-text-secondary"></span>
                                    </div>
                             </div>
                             <div class="row">
                                    <div class="span2"><p>*Destino:&nbsp;</p></div>
                                    <div class="span8">
                                        <p class="input-control select text " data-role="input-control">
                                            <select name="var_cod_conta_dest" id="var_cod_conta_destô" >
                                                <option value="" selected>[conta destino]</option>			
												<%
                                                strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
                                                strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
                                                strSQL = strSQL & " ORDER BY NOME "
                                                
                                                Set objRS = objConn.Execute(strSQL)
                                                
                                                Do While Not objRS.Eof
                                                    Response.Write("<option value='" & GetValue(objRS, "COD_CONTA") & "'")
                                                    If strCOD_CONTA = GetValue(objRS, "COD_CONTA") Then Response.Write(" selected")
                                                    Response.Write(">" & GetValue(objRS, "NOME") & "</option>")
                                                    
                                                    objRS.MoveNext
                                                Loop
                                                
                                                FechaRecordSet objRS
                                                %>
                                            </select>
                                        </p>
                                         <span class="tertiary-text-secondary"></span>
                                    </div>
                             </div>
                            <div class="row">
                                <div class="span2"><p>*Número:&nbsp;</p></div>
                                <div class="span8">
                                    <p class="input-control text " data-role="input-control">
                                    	<input name="var_num_lcto" id="var_num_lctoô" type="text" maxlength="50" >
                                    </p>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                             </div>
                            <div class="row">
                                    <div class="span2"><p>*Valor:</p></div>
                                    <div class="span8">
                                         <p class="input-control text " data-role="input-control">
                                            <input name="var_vlr_lcto" id="var_vlr_lctoô" type="text" maxlength="15" onKeyPress="validateFloatKey();">
                                         </p>
                                         <span class="tertiary-text-secondary"></span>
                                    </div>
                             </div>
                            <div class="row">
                                    <div class="span2"><p>*Data:</p></div>
                                    <div class="span8">
                                        <div class="input-control text  info-state" data-role="input-control">
                                            <p class="input-control text  info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="var_dt_lctoô" name="var_dt_lcto" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                                <span class="btn-date"></span>
                                            </p>
                                        </div>
                                         <span class="tertiary-text-secondary"><a href="" onClick="document.getElementById('var_dt_lcto').value=''; return false;// Limpa o campo">[LIMPAR DATA]</a></span>
                                    </div>
                             </div>
                            <div class="row">
                                    <div class="span2"><p>*Histórico:</p></div>
                                    <div class="span8">
                                         <p class="input-control text " data-role="input-control">
                                            <input name="var_historico" id="var_historicoô" type="text" maxlength="50" >
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
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigat&oacute;rios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
<%
FechaDBConn objConn
%>