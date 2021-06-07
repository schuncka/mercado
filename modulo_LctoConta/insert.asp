<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Cadastro",Session("ID_USER")), true %>
<%
 Const LTB = "FIN_LCTO_EM_CONTA" 			' - Nome da Tabela...
 Const DKN = "COD_LCTO_EM_CONTA"      			' - Campo chave...
 Const TIT = "Lançamento em Conta"		' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strVAR_CODIGO
Dim strTIPO_LCTO 
Dim strLABEL, strLABEL_ENT
Dim strLABEL_COR, strCOD_CONTA
Dim strDIA, strMES, strANO
Dim strINS_LCTO_NO_MES
Dim objConn, objRS, strSQL

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
strTIPO_LCTO = GetParam("var_tipo")

if strTIPO_LCTO<>"" then
	if strTIPO_LCTO="DESP" then
		strLABEL = "Despesa"
		strLABEL_ENT = "Pagar para"
		strLABEL_COR = "#FF0000" 'vermelho
	else
		strLABEL = "Receita"
		strLABEL_ENT = "Receber de"
		strLABEL_COR = "#00C000" 'verde		
	end if 
	
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
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.forminsert.DEFAULT_LOCATION.value = ""; submeterForm(); }
//function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  {alert('apertei no aplicar'); document.forminsert.JSCRIPT_ACTION.value = ""; submeterForm(); }
//****** Funções de ação dos botões - Fim ******

function submeterForm() {
	alert('entrei no submetform');
	var var_msg = '';
	var var_vlr_lcto;
	var arrData, var_dt_lcto;
	var MesLcto, AnoHoje, AnoLcto;

    var prDiaHoje = '<%=strDIA%>';
	var prMesHoje = '<%=strMES%>';
	var prAnoHoje = '<%=strANO%>';
	var prInsLctoNoMes = '<%=strINS_LCTO_NO_MES%>';
	
	if (document.forminsert.var_cod_conta.value == '') 		var_msg += '\nParâmetro inválido para conta';
	if (document.forminsert.var_operacao.value == '') 			var_msg += '\nParâmetro inválido para operação';
	if ((document.forminsert.var_codigo.value == '') || (document.forminsert.var_tipo.value == '')) var_msg += '\nInformar entidade';
	if (document.forminsert.var_cod_centro_custo.value == '') 	var_msg += '\nInformar centro de custo';
	if (document.forminsert.var_cod_plano_conta.value == '') 	var_msg += '\nInformar plano de conta';
	if (document.forminsert.var_dt_lcto.value == '') 			var_msg += '\nInformar data do lançamento';
	if (document.forminsert.var_num_lcto.value == '') 			var_msg += '\nInformar número do lançamento';
	//if (document.forminsert.var_historico.value == '') 		var_msg += '\nInformar histórico';
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

function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=forminsert&var_input=var_codigo&var_input_tipo=var_tipo&var_tipo=' + 
					document.forminsert.var_tipo.value,'640','390');
}
function cancelar() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("window.history.back()")
	 else
  		response.write ("window.close();")
  	 end if
 %> 
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
	<form name="forminsert" id="forminsert" action="insertexec.asp" method="post">
		<input type="hidden" name="DEFAULT_TABLE"	 value="<%=LTB%>">
		<input type="hidden" name="DEFAULT_DB"		 value="<%=CFG_DB%>">
		<input type="hidden" name="FIELD_PREFIX" 	 value="DBVAR_">
		<input type="hidden" name="RECORD_KEY_NAME"	 value="<%=DKN%>">
		<input type="hidden" name="DEFAULT_LOCATION" value="">
		<form name="forminsert" action="../modulo_FIN_LCTOCONTA/Insert_Exec.asp" method="post">
		<input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
		<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_FIN_LCTOCONTA/insert.asp?var_tipo=<%=strTIPO_LCTO%>'>
		<input name="var_operacao" id="var_operacao" type="hidden" value="<%=UCase(strLABEL)%>">
          <div class="tab-control" data-effect="fade" data-role="tab-control">
                <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                    <li class="active"><a href="#DADOS">GERAL</a></li>
                </ul>
                <div class="frames">
                    <div class="frame" id="DADOS" style="width:100%;">
                        <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                        <div class="grid" style="border:0px solid #F00">  
                <div class="row">
                    <div class="span2"><p>*Conta</p></div>
                    <div class="span8"><p class="input-control select" data-role="input-control">
                       <select name="var_cod_conta" id="var_cod_conta"> 
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
                        <div class="span2"><p>*<%=strLABEL_ENT%>:</p></div>
                        <div class="span8">
                             <p class="input-control text " data-role="input-control">
                                <input name='var_codigo' type='text' maxlength='10' value="<%=strVAR_CODIGO%>" onKeyPress="validateNumKey();" >
                             </p>
                             <span class="tertiary-text-secondary"></span>
                        </div>
                 </div>
                <div class="row">
                    <div class="span2"><p>*Operação:<%=strLABEL%>:</p></div>
                    <div class="span8"><p class="input-control select" data-role="input-control">
                            <select name="var_tipo" size="1" >
                            <%' MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", "" %>
                            </select>
                            </p>
                            <span class="tertiary-text-secondary"><a href="Javascript://;" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a></span> 
                    </div>
                </div> 
                <div class="row">
                    <div class="span2"><p>*Plano de Conta:</p></div>
                    <div class="span8"><p class="input-control select" data-role="input-control">
                       			<%
                                    strSQL = "SELECT DISTINCT T1.COD_PLANO_CONTA, T1.NOME " 	&_
                                            " FROM FIN_PLANO_CONTA T1, FIN_LCTO_EM_CONTA T2 " 	&_
                                            " WHERE T1.COD_PLANO_CONTA = T2.COD_PLANO_CONTA " 	&_
                                            " AND T1.DT_INATIVO IS NULL "						&_
                                            " AND T2.DT_LCTO > DATE_SUB(CURDATE(), INTERVAL 60 DAY) " &_
                                            " ORDER BY T1.NOME "
                                %>
                                <select name="var_cod_plano_conta" >
                                    <% montaCombo "STR" ,strSQL ,"COD_PLANO_CONTA","NOME",""%>
                                </select>
                                </p>
                                <span class="tertiary-text-secondary"><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=forminsert&var_retorno1=var_cod_plano_conta', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a></span>
                    </div>
                </div>
                <div class="row">
                    <div class="span2"><p>*Centro de Custo:</p></div>
                    <div class="span8">
                        <p class="input-control select" data-role="input-control">
                        <%
                            strSQL = "SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME "		&_
                                " FROM FIN_CENTRO_CUSTO T1, FIN_LCTO_EM_CONTA T2 "			&_
                                " WHERE T1.COD_CENTRO_CUSTO = T2.COD_CENTRO_CUSTO "			&_
                                " AND T1.DT_INATIVO IS NULL "								&_
                                " AND T2.DT_LCTO > DATE_SUB(CURDATE(), INTERVAL 60 DAY) " 	&_
                                " ORDER BY T1.NOME "
                        %>
                        <select name="var_cod_centro_custo" >
                            <%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME","")%>
                        </select>
                        </p>
                                <span class="tertiary-text-secondary"><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=forminsert&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a></span>
                    </div>
                </div>
                <div class="row">
                        <div class="span2"><p>*Número:</p></div>
                        <div class="span8">
                             <p class="input-control text " data-role="input-control">
                                <input name="var_num_lcto" type="text"  maxlength="50">
                             </p>
                             <span class="tertiary-text-secondary"></span>
                        </div>
                 </div>
                <div class="row">
                        <div class="span2"><p>*Valor:</p></div>
                        <div class="span8">
                             <p class="input-control text " data-role="input-control">
                                <input name="var_vlr_lcto" type="text" maxlength="15" onKeyPress="validateFloatKey();">
                             </p>
                             <span class="tertiary-text-secondary"></span>
                        </div>
                 </div>
                <div class="row">
                        <div class="span2"><p>*Data:</p></div>
                        <div class="span8">
                            <div class="input-control text  info-state" data-role="input-control">
                                <p class="input-control text  info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                    <input id="var_dt_lcto" name="var_dt_lcto" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
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
                                <input name="var_historico" id="var_historico" type="text" maxlength="50" >
                             </p>
                             <span class="tertiary-text-secondary"></span>
                        </div>
                 </div>
                <div class="row">
                        <div class="span2"><p>*Observação:</p></div>
                        <div class="span8">
                             <p class="input-control textarea " data-role="input-control">
                                <textarea name="var_obs" rows="7" ></textarea>
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
end if
FechaDBConn objConn
%>