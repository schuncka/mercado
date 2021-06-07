<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$id_evento = getsession(CFG_SYSTEM_NAME."_id_evento"); 

$objConn = abreDBConn(CFG_DB); // Abertura de banco	

/***            VERIFICAÇÃO DE ACESSO              ***/
/*****************************************************/
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verificação de acesso do usuário corrente



/***           DEFINIÇÃO DE PARÂMETROS            ***/
/****************************************************/

$intRelCod = request("var_cod");
$strTitulo = request("var_tit");

$strAcao     = request("var_acao");           // Indicativo para qual formato que a grade deve ser exportada. Caso esteja vazio esse campo, a grade é exibida normalmente.
$strSQLParam = request("var_sql_param");      // Parâmetro com o SQL vindo do bookmark
$strPopulate = request("var_populate");       // Flag de verificação se necessita popular o session ou não

/***    AÇÃO DE PREPARAÇÃO DA GRADE - OPCIONAL    ***/
/****************************************************/
if($strPopulate == "yes") { initModuloParams(basename(getcwd())); } //Popula o session para fazer a abertura dos ítens do módulo


/***        AÇÃO DE EXPORTAÇÃO DA GRADE          ***/
/***************************************************/
//Define uma variável booleana afim de verificar se é um tipo de exportação ou não
$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc") || ($strAcao == ".pdf");

//Exportação para excel, word e adobe reader
if($boolIsExportation) {
	if($strAcao == ".pdf") {
		redirect("exportpdf.php"); //Redireciona para página que faz a exportação para adode reader
	}
	else{
		//Coloca o cabeçalho de download do arquivo no formato especificado de exportação
		header("Content-type: application/force-download"); 
		header("Content-Disposition: attachment; filename=Modulo_" . getTText(getsession($strSesPfx . "_titulo"),C_NONE) . "_". time() . $strAcao);
	}
	
	$strLimitOffSet = "";
} 
?>
<html>
<head>
<title>DATAWIDE</title>
<link rel="stylesheet" href="../_css/datawide.css" type="text/css">
<script language="javascript"> 
function setParamToSQL(){
  var strMySQL, intCont;
  strMySQL = document.formconf.var_strparam.value;
  intCont = 0;
  while(document.formconf.elements[intCont].name != "") {
	strMySQL = strMySQL.replace("<ASLW_DOISPONTOS>" + document.formconf.elements[intCont].name + "<ASLW_DOISPONTOS>",document.formconf.elements[intCont].value);
	intCont++;
  }
}
 
function enableEnter(event){
	var tecla = window.event ? event.keyCode : event.which;
	if(tecla == 13){
		setParamToSQL();
		return false;
	}
}
 
function autoSubmit() {
	if(document.forms[0].elements.length == 4 && document.forms[0].elements[0].value != "") {
		setParamToSQL();
	}
}

function desabilita() {
	var x;
	
	for(x=0; x<document.formconf.doc.length; x++) {
		if(document.formconf.doc[x].checked){
			valor = document.formconf.doc[x].value;
			break;
		}		
	}
	
	if(valor == "4"){
		document.getElementById("lblnome").style.visibility = "visible"; 
		document.getElementById("nome").style.visibility = "visible"; 
		document.getElementById('nome').focus();
	} else {
		document.getElementById("lblnome").style.visibility = "hidden";
		document.getElementById("nome").style.visibility = "hidden";
		document.getElementById("nome").value = "";
	}
	if(valor == "5"){
		document.getElementById("lbldata").style.visibility = "visible"; 
		document.getElementById("data").style.visibility = "visible"; 
		document.getElementById('data').focus();
	} else {
		document.getElementById("lbldata").style.visibility = "hidden";
		document.getElementById("data").style.visibility = "hidden";
		document.getElementById("data").value = "";
	}
}		

function encaminhar(){
	var x, valor, var_sql, data;
	var combo_evento, valor_evento, combo_credencial, valor_credencial;
	
	for(x=0; x<document.formconf.doc.length; x++){
		if(document.formconf.doc[x].checked){
			valor = document.formconf.doc[x].value;
			break;
		}	
	}
	
	// PEGAR O VALOR DO COMBO DO EVENTO SELECIONADA	
	combo_evento = document.getElementById("evento").selectedIndex;
	valor_evento = formconf.evento.options[combo_evento].value;
	
	// PEGAR O VALOR DO COMBO DA CREDENCIAL SELECIONADA	
	combo_credencial = document.getElementById("credencial").selectedIndex;
	valor_credencial = formconf.credencial.options[combo_credencial].value;
	
	document.getElementById("var_cod").value = "<?php echo $intRelCod; ?>";
	if(valor == "1"){
		var_sql = "SELECT DISTINCT cad_montador.nomemont AS razao_social, cad_montador.endereco, cad_montador.bairro, cad_montador.cidade, cad_montador.estado, cad_montador.cep, cad_montador.pais, cad_montador.telefone1, cad_montador.telefone4 FROM ((cad_montador INNER JOIN (SELECT DISTINCT SUBSTRING(CODCLI,'......$') AS CODIGO, SUBSTRING(CODCLI, '..') AS idmercado, cn_montsite.idevento, cn_montsite.tipoprest, cn_montsite.idmont, cn_montsite.nomemont FROM cn_montsite ORDER BY cn_montsite.tipoprest, cn_montsite.nomemont) AS tabela ON cad_montador.idmont = tabela.idmont) INNER JOIN cad_evento ON tabela.idevento = cad_evento.idevento) INNER JOIN cad_empresa ON cad_evento.idmercado = cad_empresa.idmercado WHERE (tabela.idevento = '" + valor_evento + "') AND (cad_montador.idtipocred = '" + valor_credencial + "') AND (cad_montador.dt_inativo IS NULL) ORDER BY cad_montador.nomemont ";
		document.getElementById("var_sql").value = var_sql;
		document.getElementById("var_tit").value = "<?php echo $strTitulo; ?> - Listagem dos Prestadores do Evento";
		document.forms['formconf'].action ="../modulo_ASLWRelatorio/aslRun_DefaultArquivo.php";
		document.forms['formconf'].submit();
	}
	if(valor == "2"){
		document.forms['formconf'].action = "STmontadora_clientes.php";
		document.forms['formconf'].submit();
	}
	if(valor == "3"){
		document.forms['formconf'].action = "STetiquetas_Pastas_Montador.php";
		document.forms['formconf'].submit();
	}	
	if(valor == "4"){
		document.forms['formconf'].action = "STetiquetas_Montadoras_exe.php";
		document.forms['formconf'].submit();
	}
	if(valor == "5"){
		data = document.getElementById("data").value;
		var_sql = "SELECT DISTINCT cad_montador.nomemont AS razao_social, cad_montador.endereco,cad_montador.bairro,cad_montador.cidade, cad_montador.estado, cad_montador.cep, cad_montador.pais, cad_montador.cgcmf AS cnpj,cad_montador.inscrest AS inscri_estadual, cad_montador.inscrmunicp as inscri_municipal, cad_montador.telefone1 AS telefone, cad_montador.email, cad_montador.website, cad_montador.contato, cad_montador.datacad AS data_cadastro, cad_montador.dataatu AS data_atualizacao, cad_montador.tipocred AS tipo_credencial, cad_montador.tipopes AS tipo_pessoa, cad_montador.comissmont AS comissao, cad_montador.sindicato AS sindicato, cad_montador.cecam, cad_montador.validacao, cad_montador.dt_inativo AS inativo FROM cad_montador WHERE (cad_montador.dataatu >= to_date('"+data+"', 'DD/MM/YYYY')) AND (cad_montador.idtipocred = "+valor_credencial+") AND (cad_montador.dt_inativo IS NULL) ORDER BY cad_montador.nomemont ";
		document.getElementById("var_sql").value = var_sql;
		document.getElementById("var_tit").value = "<?php echo $strTitulo; ?> - Listagem dos Prestadores em Geral";
		document.forms['formconf'].action ="../modulo_ASLWRelatorio/aslRun_DefaultArquivo.php";
		document.forms['formconf'].submit();	
	}
	if(valor == "6"){
		alert ("Aguardando novo Modelo para Desenvolvimento!");
	}
	if(valor == "7"){
			var_sql = "SELECT cad_montador.nomemont AS nome_montadora FROM ((cad_montador LEFT JOIN ( SELECT DISTINCT cad_montador.idmont FROM  (cad_montador LEFT JOIN (ped_servico LEFT JOIN cad_evento ON ped_servico.ideventose = cad_evento.idevento) ON cad_montador.idmont = ped_servico.idmontse) LEFT JOIN ped_servico_produtos ON (ped_servico.idmercado = ped_servico_produtos.idmercado) AND (ped_servico.idservico = ped_servico_produtos.idservico) WHERE ( (ped_servico.ideventose = '"+valor_evento+"' ) AND (ped_servico.pago = FALSE) AND (ped_servico.excluida = FALSE) ) GROUP BY cad_montador.idmont ORDER BY cad_montador.idmont ) AS LiberadasSAI1 ON cad_montador.idmont = LiberadasSAI1.idmont) LEFT JOIN ( SELECT DISTINCT cad_montador.idmont FROM  ( cad_montador LEFT JOIN ped_pedidos ON cad_montador.idmont = ped_pedidos.idmontpe) LEFT JOIN cad_evento ON ped_pedidos.idevento = cad_evento.idevento WHERE ((cad_evento.idevento = '"+valor_evento+"') AND ((SUBSTRING(ped_pedidos.IDPEDIDO FROM  '..$')) = '00') AND ((ped_pedidos.circular01) IS NULL)) OR (((cad_evento.idevento) <> '000139' ) AND ((SUBSTRING(ped_pedidos.IDPEDIDO FROM  '..$')) = '00') AND (ped_pedidos.circular03 IS NULL)) OR ((cad_evento.idevento = '"+valor_evento+"') AND ((SUBSTRING(ped_pedidos.IDPEDIDO FROM  '..$')) = '00') AND (ped_pedidos.circular04 IS NULL)) GROUP BY cad_montador.idmont ORDER BY cad_montador.idmont ) AS LiberadasSAI2 ON cad_montador.idmont = LiberadasSAI2.idmont) INNER JOIN ( SELECT DISTINCT cad_montador.idmont, cad_evento.idevento FROM  cad_evento INNER JOIN (cad_montador INNER JOIN ped_pedidos ON cad_montador.idmont = ped_pedidos.idmontpe) ON cad_evento.idevento = ped_pedidos.idevento WHERE ( (cad_evento.idevento = '"+valor_evento+"') AND ((SUBSTRING(ped_pedidos.IDPEDIDO FROM  '..$') = '00') ) ) GROUP BY cad_montador.idmont, cad_evento.idevento ORDER BY cad_montador.idmont ) AS LiberadasEV ON cad_montador.idmont = LiberadasEV.idmont WHERE ((cad_montador.dt_inativo IS NULL) AND (cad_montador.tipocred ILIKE 'MONTADOR') AND ((LiberadasSAI1.idmont) IS NULL) AND (LiberadasSAI2.idmont IS NULL)) ORDER BY cad_montador.nomemont ";
		document.getElementById("var_sql").value = var_sql;
		document.getElementById("var_tit").value = "<?php echo $strTitulo; ?> - Montadoras Liberadas";
		document.forms['formconf'].action ="../modulo_ASLWRelatorio/aslRun_DefaultArquivo.php";
		document.forms['formconf'].submit();	
	}
}	

</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body style="margin:10px 0px 0px 0px;" bgcolor="#FFFFFF" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" onLoad="autoSubmit();">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
 <tr>
   <td align="center" valign="top">
	 <div id="DialogGlass" class="bordaBox" style="width:600; height:none;">
				<div class="b1"></div><div class="b2"></div><div class="b3"></div><div class="b4"></div>
				<div class="center">
					<div id="Conteudo" class="conteudo" style="width:582;  height:none;"><div id="GlassHeader" class="header" style="background-color:#C9DCF5;width:582px;"><span style='margin-left:4px;'>RELATÓRIOS - Definir Parâmetro Para Consulta</span></div> 
		<table border="0" width="100%" bgcolor="#FFFFFF" style="border:1px #A6A6A6 solid;">
		  <form name="formconf" method="post" action="">
			<input type="hidden" name="var_cod" value="">
			<input type="hidden" name="var_tit" value="">
			<tr>
			  <td style="padding:10px;"><b></b></td>
			</tr>
			<tr>
				<td align="center" valign="top">
					<table width="550" border="0" cellspacing="0" cellpadding="4">
						<tr>
							<td align="right" width="100">Escolha o Evento</td>
							<td><select name="evento" id="evento" style="width: 300px;">
									<?php
										$strSQL = " SELECT nome_completo, idevento, idmercado
													FROM cad_evento
													WHERE idmercado ILIKE '".$id_empresa."'
													ORDER BY substring(nome_completo from '....$'), edicao desc ";
										echo(montaCombo($objConn, $strSQL, "idevento","nome_completo",$id_evento, ""));
									?>
							</select></td>
						</tr>
						<tr>
							<td align="right" width="100">Tipo Credencial</td>
							<td><select name="credencial" style="width: 300px;">
							
									<?php
										try{					
											$strSQL = " SELECT idcred, tipo_cred
														FROM cad_tipo_cred
														ORDER BY tipo_cred ";
											$objResult = $objConn->query($strSQL); // execução da query
										}catch(PDOException $e){
												mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
												die();
										}
										
										foreach($objResult as $objRS){
											?><option value="<?php  echo getValue($objRS,"idcred");  ?>">
											  <?php echo getValue($objRS,"tipo_cred"); ?></option>
									<?php } ?>			
							</select></td>
						</tr>
						<tr>
							<td align="right" width="100"></td>
							<td></td>
						</tr>
						<tr>
							<td align="right" width="100">Prestadores do Evento</td>
							<td>
						      <input type="radio" name="doc"  style="background:none; border:none"  value="1" disabled="disabled">Listagem dos Prestadores do Evento <br>
						      <input type="radio" name="doc" style="background:none; border:none" value="2" disabled="disabled">Montadora e seus Clientes <br>
						      <input type="radio" name="doc" style="background:none; border:none" value="3" onClick="desabilita();">Etiquetas para as Pastas 
						    </td>
						</tr>
						<tr>
							<td align="right" width="100">Prestadores em Geral</td>
						  <td>
							 <input type="radio" name="doc" value="4" style="background:none; border:none" onClick="desabilita();" >
								Etiquetas de Endereçamento
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <label style="visibility:hidden" id="lblnome"> Aos Cuidados de: </label> 
							 <input type="text" id="nome" style="visibility:hidden" name="nome">
								  <br>
							      <input type="radio" name="doc" style="background:none; border:none" value="5" onClick="desabilita();">
							      Listagem dos Prestadores em Geral&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								 <label style="visibility:hidden" id="lbldata">Atualizado Após: </label> 
								 <input type="text" name="data" id="data" style="visibility:hidden; width:70px;">
								 <br>
							    <input type="radio" name="doc" style="background:none; border:none" value="6" disabled="disabled">
								Ficha de Recadastramento 
						     </td>
						</tr>
						<tr>
							<td align="right" width="100">Montadoras do Evento</td>
						  <td>
						      <input type="radio" name="doc" style="background:none; border:none" value="7" onClick="desabilita();">
						      Montadoras Liberadas<br>
						     </td>
						</tr>
							
						<tr>
							<td align="right" colspan="3" style="padding:10px 0px 10px 10px;">
							    <!-- CAMPO PARA RECEBER A VARIAVÉL -->
								<textarea id="var_strparam" name="var_strparam" value="" style="visibility:hidden"></textarea>
								<textarea id="var_sql" name="var_sql" value="" style="visibility:hidden"></textarea>
								<button onClick="encaminhar();" type="submit">Ok</button>
								<button onClick="window.close();">Cancelar</button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		  </form>
		</table>
		 </div>
	    </div>
	   <div class="b4"></div><div class="b3"></div><div class="b2"></div><div class="b1"></div>
	   </div>
	</td>
 </tr>
</table>
</body>
</html>
