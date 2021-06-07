<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

$id_evento 			= getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_mercado 		= getsession(CFG_SYSTEM_NAME."_id_mercado"); 
$dir_cliente		= getsession(CFG_SYSTEM_NAME."_dir_cliente"); 
$datawide_lang 		= getsession("datawide_lang");

$var_cod_pedido     = request("var_cod_pedido");
$var_lote			= request("var_lote");
$var_opcao_contrato = request("var_opcao_contrato");
$var_localizacao    = request("var_localizacao");
$var_pavilhao       = request("var_pavilhao");

if ($var_opcao_contrato == "") $var_opcao_contrato = "1";

$strApenasUm = "F";
if (($var_cod_pedido != "") || ($var_lote != "")) $strApenasUm = "T";

// ABERTURA DE CONEXÃO COM BANCO DE DADOS
$objConn = abreDBConn(CFG_DB);
	
/***            VERIFICAÇÃO DE ACESSO              ***/
/*****************************************************/
/*
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verificação de acesso do usuário corrente
*/

/***           DEFINIÇÃO DE PARÂMETROS            ***/
/****************************************************/

$strAcao   	      = request("var_acao");           // Indicativo para qual formato que a grade deve ser exportada. Caso esteja vazio esse campo, a grade é exibida normalmente.
$strSQLParam      = request("var_sql_param");      // Parâmetro com o SQL vindo do bookmark
$strPopulate      = request("var_populate");       // Flag de verificação se necessita popular o session ou não

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

function convertem($term, $tp) { 
    if ($tp == "1") $palavra = strtr(strtoupper($term),"àáâãäåæçèéêëìíîïðñòóôõö÷øùüúþÿ","ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÜÚÞß"); 
    elseif ($tp == "0") $palavra = strtr(strtolower($term),"ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÜÚÞß","àáâãäåæçèéêëìíîïðñòóôõö÷øùüúþÿ"); 
    return $palavra; 
} 

function nomeMes($mes) {
	switch ($mes){
	case 1:  $mes  = "JANEIRO"; break;
	case 2:  $mes  = "FEVEREIRO"; break;
	case 3:  $mes  = "MARÇO"; break;
	case 4:  $mes  = "ABRIL"; break;
	case 5:  $mes  = "MAIO"; break;
	case 6:  $mes  = "JUNHO"; break;
	case 7:  $mes  = "JULHO"; break;
	case 8:  $mes  = "AGOSTO"; break;
	case 9:  $mes  = "SETEMBRO"; break;
	case 10: $mes  = "OUTUBRO"; break;
	case 11: $mes  = "NOVEMBRO"; break;
	case 12: $mes  = "DEZEMBRO"; break;}
	return $mes;
}


//-------------------DADOS DO CONTRATO-----------------------------------------------------------------------

if ($strApenasUm == "T") {
//,CASE WHEN (ped_pedidos.new_localpe IS NULL OR ped_pedidos.new_localpe = '') 		THEN ped_pedidos.localpe 	ELSE ped_pedidos.new_localpe 	END AS localpe
//,CASE WHEN (ped_pedidos.new_pavilhaope IS NULL OR ped_pedidos.new_pavilhaope = '') 	THEN ped_pedidos.pavilhaope ELSE ped_pedidos.new_pavilhaope END AS pavilhaope
	$strSQLcontrato = " SELECT DISTINCT
						    ped_pedidos.razaope
						   ,ped_pedidos.cod_pedidos
						   ,ped_pedidos.idpedido
						   ,ped_pedidos.new_localpe
						   ,CASE WHEN (ped_pedidos.localpe IS NULL OR ped_pedidos.localpe = '') 		THEN ped_pedidos.new_localpe 	ELSE ped_pedidos.localpe 	END AS localpe
						   ,CASE WHEN (ped_pedidos.pavilhaope IS NULL OR ped_pedidos.pavilhaope = '') 	THEN ped_pedidos.new_pavilhaope ELSE ped_pedidos.pavilhaope END AS pavilhaope
						FROM ped_pedidos  
						WHERE NOT ped_pedidos.excluida ";
	if ($var_cod_pedido != "") $strSQLcontrato .= " AND ped_pedidos.cod_pedidos = " . $var_cod_pedido;
	if ($var_lote != "") $strSQLcontrato .= " AND ped_pedidos.cod_pedidos IN (".$var_lote.") ";
	$strSQLcontrato .= " AND SUBSTRING(ped_pedidos.idpedido FROM 7 FOR 3) = '-00'
						 ORDER BY ped_pedidos.razaope ";
}
else {
	$strSQLcontrato = " SELECT DISTINCT
						    ped_pedidos.razaope
						   ,ped_pedidos.cod_pedidos
						   ,ped_pedidos.idpedido
						   ,ped_pedidos.new_localpe
						   ,ped_pedidos_renovacao_evento.idpedido
						   ,CASE WHEN (ped_pedidos.localpe IS NULL OR ped_pedidos.localpe = '') 		THEN ped_pedidos.new_localpe 	ELSE ped_pedidos.localpe 	END AS localpe
						   ,CASE WHEN (ped_pedidos.pavilhaope IS NULL OR ped_pedidos.pavilhaope = '') 	THEN ped_pedidos.new_pavilhaope ELSE ped_pedidos.pavilhaope END AS pavilhaope
						FROM ped_pedidos  
						LEFT JOIN ped_pedidos_renovacao_evento ON (ped_pedidos.idmercado = ped_pedidos_renovacao_evento.idmercado AND ped_pedidos.idpedido = ped_pedidos_renovacao_evento.idpedido)
						WHERE ped_pedidos.idevento = '000261' 
						AND ped_pedidos.idstatus = '003'
						AND ped_pedidos.paispe = 'BRASIL'
						AND ped_pedidos.catalogo = TRUE 
						AND NOT ped_pedidos.excluida
						AND SUBSTRING(ped_pedidos.idpedido FROM 7 FOR 3) = '-00'
						AND ped_pedidos_renovacao_evento.idpedido IS NOT NULL
						ORDER BY ped_pedidos.razaope ";
}
try{				
	$objResultcontrato = $objConn->query($strSQLcontrato);		
}catch(PDOException $e) {
	mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
	die();
}	
?>
<html>
<head>
<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<?php 
if(!$boolIsExportation || $strAcao == "print"){
	echo(" <link rel=\"stylesheet\" href=\"../_css/" . CFG_SYSTEM_NAME . ".css\" type=\"text/css\">
	<link href='../_css/tablesort.css' rel='stylesheet' type='text/css'>
	<script type='text/javascript' src='../_scripts/tablesort.js'></script>");
}
?>
<script language="JavaScript" type="text/javascript">
	function switchColor(prObj, prColor){
		prObj.style.backgroundColor = prColor;
	}
</script>
<style type="text/css">
<!--
table.bordasimples1 {border-collapse: collapse;}
table.bordasimples1 tr td {border:0px solid #000000;}
table.bordasimples {border-collapse: collapse;}
table.bordasimples tr td {border:1px solid #000000;}

.bordaBox {bbackground: ttransparent; width:30%;}
.bordaBox .b1, .bordaBox .b2, .bordaBox .b3, .bordaBox .b4, .bordaBox .b1b, .bordaBox .b2b, .bordaBox .b3b, .bordaBox .b4b {display:block; overflow:hidden; font-size:1px;}
.bordaBox .b1, .bordaBox .b2, .bordaBox .b3, .bordaBox .b1b, .bordaBox .b2b, .bordaBox .b3b {height:1px;}
.bordaBox .b2, .bordaBox .b3, .bordaBox .b4 {background:#FFFFFF; border-left:1px solid #000000; border-right:1px solid #000000;}
.bordaBox .b1 {margin:0 5px; background:#000000;}
.bordaBox .b2 {margin:0 3px; border-width:0 2px;}
.bordaBox .b3 {margin:0 2px;}
.bordaBox .b4 {height:2px; margin:0 1px;}
.bordaBox .conteudo {padding:5px;display:block; background:#CECECE; border-left:1px solid #999; border-right:1px solid #999;}
.bordaBox .conteudo2 {padding:5px;display:block; background:#FFFFFF; border-left:1px solid #999; border-right:1px solid #999;}

-->

.tdicon{
		text-align:center;
		font-size:11px;
		font:bold;
		width:25%;		
}
img{
	border:none;
}
</style>
<style>
.b1 {
	width:auto;
	height:auto;
	font-size:1px;
	background:#000000;
	margin:0px;
}
.b2 {
	height:1px;
	font-size:1px;
	background:#fff;
	border-right:1px solid #000000;
	border-left:1px solid #000000;
	margin:0 3px;
}
.b3 {
	height:1px;
	font-size:1px;
	background:#fff;
	border-right:1px solid #000000;
	border-left:1px solid #000000;
	margin:0 2px;
}
.b4 {
	height:1px;
	font-size:1px;
	background:#fff;
	border-right:1px solid #000000;
	border-left:1px solid #000000;
	margin:0 1px;
}
.b5 {
	border-left:1px solid #000000;
	border-right:1px solid #000000;
	display:block;
}
</style>
</head>
<body style="margin:30px 30px 30px 30px;">
<?php
if ($strApenasUm == "F") {
	$strLote = "";
	$iCont = 0;
	foreach($objResultcontrato as $objRScontratoRenovacao){ 
		$iCont++;
		$var_cod_pedido = getValue($objRScontratoRenovacao,"cod_pedidos"); 
		
		if ($strLote == "") 
			$strLote = $var_cod_pedido;
		else
			$strLote .= "," . $var_cod_pedido;
		
		if ($iCont == 100) {
			echo("<br><a href='STimprime_contrato_prevenda.php?var_lote=" . $strLote . "&var_opcao_contrato=" . $var_opcao_contrato . "' target='_blank'>imprimir lote</a>");
			$iCont = 0;
			$strLote = "";
		}
	}
	if ($strLote != "") {
		echo("<br><a href='STimprime_contrato_prevenda.php?var_lote=" . $strLote . "&var_opcao_contrato=" . $var_opcao_contrato . "' target='_blank'>imprimir lote</a>");
	}
}
else {
	foreach($objResultcontrato as $objRScontratoRenovacao){ 
		$var_cod_pedido = getValue($objRScontratoRenovacao,"cod_pedidos"); 
		
		if (($var_cod_pedido != "") && ($var_lote == "")) { //if ($strApenasUm == "T") {
			$strLocalizacao = $var_localizacao;
			$strPavilhao = $var_pavilhao;
		}
		else {
			$strLocalizacao = getValue($objRScontratoRenovacao,"localpe");
			$strPavilhao = getValue($objRScontratoRenovacao,"pavilhaope");
		}
		
		//BUSCA O PAVILHÃO SELECIONADO NA COMBO ANTERIOR
		$strSQLpavilhao = "select descrpavilhao, idpavilhao from cad_pavilhao where idpavilhao ilike '".$strPavilhao."'";	
		try{
			$objResultpavilhao = $objConn->query($strSQLpavilhao);		
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}	
		$objRSpavilhao = $objResultpavilhao->fetch();
		if (getValue($objRSpavilhao,"descrpavilhao") != "") {
			$strLocalizacao = $strLocalizacao." - ".getValue($objRSpavilhao,"descrpavilhao"); 
		}
		
		//BUSCA OS DADOS DO PEDIDO
		$strSQLpedido = "SELECT nomemapa,
								cod_pedidos,
								codigope,
								idpedido,
								TO_CHAR(datape, 'dd/mm/yyyy') AS datape,
								razaope,
								tipope,
								new_localpe,
								pavilhaope,
								localpe
						FROM ped_pedidos  
						WHERE cod_pedidos = ".$var_cod_pedido;	
		try{				
			$objResultpedido = $objConn->query($strSQLpedido);		
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}	
		$objRSpedido = $objResultpedido->fetch();		
		
		//BUSCA OS DADOS DO EXPOSITOR
		$strSQLexpositor = "SELECT cod_cadastro, idmercado, codigo, razao, fantasia, cgcmf, inscrest, inscrmunicip
								 , endereco, bairro, cidade, estado, cep, email, pais, website, telefone1, telefone2
								 , idrepre, mainprod
							FROM cad_cadastro WHERE codigo = '".getValue($objRSpedido,"codigope")."' 
							AND idmercado ILIKE '".$id_mercado."' ";	
		try{				
			$objResultexpositor = $objConn->query($strSQLexpositor);		
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}	
		$objRSexpositor = $objResultexpositor->fetch();
		
		//BUSCA PROD PRINCIPAL
		$strProdPrinc = "";
		if (getValue($objRSexpositor, "mainprod") != "") {
			$strSQLAux = " SELECT DISTINCT cad_produto1_categoria.idprod1 as cod, cad_produto1_categoria.descrprod1 AS descr 
						   FROM cad_produto1_categoria  
						   WHERE cad_produto1_categoria.idmercado = '".$id_mercado."' 
						   AND idprod1 ILIKE '" . getValue($objRSexpositor, "mainprod") . "'
						   ORDER BY cad_produto1_categoria.descrprod1 ";
			try{				
				$objResultAux = $objConn->query($strSQLAux);		
			}catch(PDOException $e) {
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
				die();
			}	
			$objRSAux = $objResultAux->fetch();
			$strProdPrinc = getValue($objRSAux,"descr");
			$objResultAux->closeCursor();
		}
		
		//BUSCA OS DADOS DO EMPRESA
		$strSQLempresa = "select * from cad_empresa where idmercado = '".$id_mercado."'";	
		try{				
			$objResultempresa = $objConn->query($strSQLempresa);		
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}	
		$objRSempresa = $objResultempresa->fetch();
		
		//BUSCA OS DOADOS DO EVENTO ATUAL
		$strSQLeventoAtual = "SELECT  
										 cad_evento.dt_inicio,
										 cad_evento.descrevento,
										 to_char(cad_evento.dt_fim, 'dd/mm/yyyy') as dt_fim    ,
										 cad_evento.nome_completo                              ,
										 cad_evento.edicao                                     ,
										 cad_evento.pavilhao  								   ,
										 cad_tipo_evento.descricao AS tipoevento			   ,
										 cad_evento.nome_oficial							   ,
										 date_part('day', cad_evento.dt_inicio ) as dia_inicio ,
										 date_part('day', cad_evento.dt_fim )    as dia_fim    ,
										 date_part('year', cad_evento.dt_fim )   as ano_fim    ,
										 to_char((cad_evento.dt_inicio - interval '2 month'),'mm') 		as data_venc_mes,
										 to_char((cad_evento.dt_inicio - interval '2 month'),'yyyy') 		as data_venc_ano,
										 to_char((cad_evento.dt_inicio - interval '2 month'),'mm/yyyy') 	as data_venc
								FROM cad_evento, cad_tipo_evento
								WHERE cad_evento.idevento = '000261'
								AND cad_evento.cod_tipo_evento = cad_tipo_evento.cod_tipo_evento ";
		try{			
			$objResulteventoAtual = $objConn->query($strSQLeventoAtual); // execução da query
		}catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
		}
		$objRSeventoAtual = $objResulteventoAtual->fetch();
		
		//BUSCA OS DADOS EVENTO A SER RENOVADO
		$strSQLevento = "SELECT 
								 cad_evento.idevento,								
								 cad_evento.dt_inicio,
								 to_char(cad_evento.dt_fim, 'dd/mm/yyyy') as dt_fim    ,
								 cad_evento.nome_completo                              ,
								 cad_evento.edicao                                     ,
								 cad_evento.nome_oficial							   ,
								 cad_evento.pavilhao  								   ,
								 cad_tipo_evento.descricao AS tipoevento		  	   ,
								 to_char(cad_evento.dt_limite_contrato, 'dd/mm/yyyy') as dt_limite_contrato,
								 date_part('day', cad_evento.dt_inicio ) as dia_inicio ,
								 date_part('day', cad_evento.dt_fim )    as dia_fim    ,
								 date_part('month', cad_evento.dt_fim )  as mes_fim    ,
								 date_part('year', cad_evento.dt_fim )   as ano_fim    ,
								 cad_evento.dtlimite								   ,
								 'EXPO ENFERMAGEM' AS nomeevento					   ,
								CASE WHEN cad_evento.idmercado = 'BE' 
								 		THEN 'SÃO PAULO FEIRAS COMERCIAIS LTDA' 
										ELSE CASE WHEN cad_evento.idmercado = 'SA' 
											 THEN 'HOSPITALAR FEIRAS, CONGRESSOS E EMPREENDIMENTOS LTDA'
											 ELSE 'COUROMODA FEIRAS COMERCIAIS LTDA'
										END END AS empreendimento						   		
						FROM cad_evento, cad_tipo_evento
						WHERE cad_evento.cod_tipo_evento = cad_tipo_evento.cod_tipo_evento
						AND cad_evento.idevento = (	SELECT cad_evento.idevento
													FROM cad_evento 
													WHERE cad_evento.idmercado = '".$id_mercado."' 
													AND cad_evento.descrevento ILIKE '%' || SUBSTRING( '".getValue($objRSeventoAtual,"descrevento")."' ,1,8) || '%'
													AND cad_evento.descrevento NOT ILIKE 'EMPRESA%'
													AND DATE_PART('year', dt_inicio) = (SELECT DATE_PART('year', dt_inicio) +1
																						FROM cad_evento 
																						WHERE idevento = '000261')
											 );";
		
		try{			
			$objResultevento = $objConn->query($strSQLevento); // execução da query
		}catch(PDOException $e){
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
				die();
		}
		$objRSevento = $objResultevento->fetch();
		
		//BUSCA OS VALORES DE RENOVAÇÃO DO EVENTO
		 $strSQLrenovacao = "SELECT 
							  idmercado,
							  idevento,
							  area1,
							  area2,
							  energia,
							  energia_cli,
							  logotipo,
							  pag_catalogo,
							  dt_limite,
							  sys_dtt_ins,
							  sys_usr_ins,
							  sys_dtt_upd,
							  sys_usr_upd,
							  cod_renovacao_valores
							FROM cad_renovacao_valores 
							WHERE idevento = '000282';";	
		try{				
			$objResultrenovacao = $objConn->query($strSQLrenovacao);		
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}	
		$objRSrenovacao = $objResultrenovacao->fetch();
	
		//BUSCA OS VALORES DAS MARCAS
		$strSQLmarcas = "SELECT
								  cad_marcas.cod_marcas
								, cad_marcas.codigo
								, cad_marcas.descrmarca
								, cad_marcas.catalogo
							FROM
								cad_marcas
							INNER JOIN cad_cadastro 
							ON cad_cadastro.codigo = cad_marcas.codigo
							AND cad_cadastro.cod_cadastro = '".getValue($objRSexpositor,"cod_cadastro")."'
							AND cad_cadastro.idmercado ILIKE cad_marcas.idmercado
							AND cad_marcas.dt_inativo IS NULL
							ORDER BY cad_marcas.cod_marcas, cad_marcas.descrmarca DESC ";	
		try{				
			$objResultmarcas = $objConn->query($strSQLmarcas);		
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}	
	
		//$objRSmarcas = $objResultmarcas->fetch();
		$marcasExpositor = "";
		foreach($objResultmarcas as $objRSmarcas){ 
			if ($marcasExpositor == "") 
				$marcasExpositor = getValue($objRSmarcas,"descrmarca");
			else
				$marcasExpositor .= "," . getValue($objRSmarcas,"descrmarca");
		}
	?>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
	  <tr>
		<td><table width="100%" border="1" class="bordasimples1">
			<tr>
			  <!-- <td width="20%" align="center"><img src="../../<?php //echo $dir_cliente; ?>/upload/LogoContrato_<?php //echo $id_mercado; ?>.jpg" border="0"></td> <img src="../../<?php echo $dir_cliente; ?>/upload/LogoContratoEE2012.jpg" border="0"> -->
              <td width="20%" align="center" style="vertical-align:text-bottom; font-size:36px; text-transform:capitalize; font-weight:bold;" nowrap><img src="../../<?php echo $dir_cliente; ?>/upload/LogoContratoEE2012.jpg" border="0"></td>
			  <td width="1%" align="center">&nbsp;</td>
			  <td colspan="2" width="79%"><?php echo getValue($objRSevento,"nome_completo"); ?> - <?php echo getValue($objRSevento,"nome_oficial"); ?> - 23 a 26 de Outubro de 2012 - <?php echo getValue($objRSevento,"pavilhao"); ?> - SÃO PAULO/SP</td>
			</tr>
			<tr>
			  <td width="20%" align="center" bgcolor="#000000"><font color="#FFFFFF" size="2"><b><?php echo getValue($objRSevento,"dia_inicio")." a ".getValue($objRSevento,"dia_fim")." | ".nomeMes(getValue($objRSevento,"mes_fim"))." | " .getValue($objRSevento,"ano_fim")  ?></b></font></td>
			  <td width="1%" align="center">&nbsp;</td>
			  <td width="10%" align="center" bgcolor="#000000" nowrap="nowrap"><font color="#FFFFFF" size="2"><b>OPÇÃO <?php //echo $var_opcao_contrato; ?></b></font></td>
			  <td width="69%">Condições válidas para renovação até <?php echo getValue($objRSevento,"dt_limite_contrato"); ?>, com pagamento <?php if ($var_opcao_contrato == "1") { echo(" em até 5 parcelas. "); } else { echo(" de 6 a 10 parcelas. "); }?></td>
			</tr>
		  </table></td>
	  </tr>
	</table>
	<div align="center">CONTRATO DE ORGANIZAÇÃO, PLANEJAMENTO, PROMOÇÃO E ADMINISTRAÇÃO DE FEIRA COMERCIAL</div>
	<div align="justify"><b>I. CONTRATANTES</b>
	  <br>
	  <b>1. PROMOTORA E ORGANIZADORA: </b> 
	  SÃO PAULO FEIRAS COMERCIAIS LTDA., inscrita no CNPJ nº 02.995.701/0001-33 <?php // echo getValue($objRSempresa, "ecnpj"); ?> com sede na Rua Padre Jo&atilde;o Manoel, 923 Conj. 61/62- 6&ordm; Andar - Cerqueira C&eacute;sar - Fone <?php echo getValue($objRSempresa, "etele"); ?> - Fax<?php echo getValue($objRSempresa, "efax"); ?> - CEP 01411-001 - S&atilde;o Paulo/SP - Brasil,  expoenfermagem@expoenfermagem.com.br www.expoenfermagem.com.br. Um empreendimento da <?php echo getValue($objRSevento, "empreendimento"); ?>.<br>
	<b>2. EXPOSITOR</b>
	</div>
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td width="14%">Código</td>
		<td width="41%" align="left"><div align="left"><strong><?php echo getValue($objRSexpositor, "idmercado").getValue($objRSexpositor, "codigo");?></strong></div></td>
		<td width="16%">Telefone</td>
		<td width="29%"><div align="left"><strong><?php echo getValue($objRSexpositor, "telefone1"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Razão Social</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "razao"); ?></strong></div></td>
		<td>Telefax</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "telefone2"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Nome Fantasia</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "fantasia"); ?></strong></div></td>
		<td>Direção</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "telefone3"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Endereço</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "endereco"); ?></strong></div></td>
		<td>CNPJ</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "cgcmf"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Bairro</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "bairro"); ?></strong></div></td>
		<td>Inscr. Estadual</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "inscrest"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Cidade</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "cidade"). "/" . getValue($objRSexpositor, "estado"); ?></strong></div></td>
		<td>Inscr. Municipal</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "inscrmunicip"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Código Postal</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "cep"); ?></strong></div></td>
		<td>E-Mail</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "email"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>País</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "pais"); ?></strong></div></td>
		<td>Website</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "website"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Nome no MAPA</td>
		<td><div align="left"><strong><?php echo getValue($objRSpedido, "nomemapa"); ?></strong></div></td>
		<td>CT</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "idrepre"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Produto Principal</td>
		<td><div align="left"><strong><?php echo $strProdPrinc; ?></strong></div></td>
		<td></td>
		<td><div align="left"><strong></strong></div></td>
	  </tr>
	</table>
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td width="2%" valign="top"><b>II.</b></td>
		<td width="98%" align="justify"><div align="justify"><b>OBJETO DO CONTRATO:</b> A SÃO PAULO FEIRAS COMERCIAIS LTDA, é a promotora exclusiva e única responsável pela Organização, Planejamento, Promoção e Administração da Feira <?php echo getValue($objRSevento, "nome_completo"); ?> -  <?php echo getValue($objRSevento,"nome_oficial"); ?>		 -	23 a 26 de Outubro de 2012 - <?php echo getValue($objRSevento,"pavilhao"); ?>, localizada na cidade de São Paulo/SP, sendo de sua responsabilidade exclusiva prover todos os serviços necessários e/ou convenientes à realização desta Feira, nos termos do Regulamento Geral, que faz parte integrante e complementar deste contrato. </div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>1.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR participará da Feira <?php echo getValue($objRSevento, "nome_completo"); ?> ocupando um ou mais espaços, sem nenhum tipo de montagem, a ele disponibilizados pela
		SÃO PAULO FEIRAS COMERCIAIS LTDA., ao preço de: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .<b>R$ <?php echo number_format(getValue($objRSrenovacao, "area".$var_opcao_contrato), 2, ',', '.'); ?> por m²</b></div></td>
	  </tr>
	  <tr>
		<td valign="top" ><b>2.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR providenciará às suas expensas exclusivas a montagem do estande, tendo a inteira liberdade de criá-lo de acordo com o visual,
		decoração e disposição desejados, obedecendo às normas estabelecidas pelo Regulamento Geral, exceto grupos, que têm regras específicas.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>3.</b></td>
		<td align="justify"><div align="justify">Energia Elétrica Instalada/Obrigatória: Será cobrado neste contrato o equivalente a 0,070 KVA de energia elétrica instalada por m² no espaço
		disponibilizado, conforme item 6.2 do Regulamento Geral, ao preço de: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .  . . . .<b>R$
		<?php echo number_format( getValue($objRSrenovacao, "energia" ), 2, ',', '.'); ?> por m²</b></div></td>
	  </tr>
	  <?php if ($id_evento <> '000228') { ?>
	  <tr>
		<td valign="top"><b>4.</b></td>
		<td align="justify"><div align="justify">Energia Elétrica da Climatização: Corresponde ao funcionamento de todo o sistema de climatização, no período de realização da <?php echo getValue($objRSevento, "nome_completo"); ?>
		e será cobrado por m² juntamente com as parcelas deste contrato . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   . . . . . .<b>R$ 
		
		<?php echo number_format( getValue($objRSrenovacao, "energia_cli") , 2, ',', '.'); ?> por m²</b></div></td>
	  </tr>
	  <?php } ?> 
	  <tr>
		<td><b>III.</b></td>
		<td><b>PLANO DE PAGAMENTO</b></td>
	  </tr>
	</table>
	<table width="80%" border="0" class="bordasimples" align="left">
	  <tr>
		<td width="2%">&nbsp;</td>
		<td width="11%" align="center">Número de <br>Parcelas</td>
		<td width="17%" align="center">Primeiro<br>Vencimento</td>
		<td width="20%" align="center">Desconto Comercial <br> na emissão da Fatura</td>
		<td width="14%" align="center"><b>Preço Líquido(por m²)</b></td>
		<td width="36%" align="center">Desconto Pontualidade válido para pagto até o vencto do boleto bancário</td>
	  </tr>
	  <?php 
	  // BUSCA AS PARCELAS
	  
	   $strSQLparcela = "SELECT   DISTINCT cad_evento.dt_fim    		,
								 cad_evento.dt_inicio                	,
								 cad_renovacao_desconto.parcela      	,
								 cad_renovacao_desconto.desconto      	,
								 cad_renovacao_desconto.pagamentomes  	,
								 cad_renovacao_desconto.idevento      	,
								 cad_renovacao_desconto.idmercado     	,
								 to_char(cad_renovacao_desconto.datavencimento, 'dd/mm/yyyy') AS datavencimento     ,        
								 cad_evento.max_descfin as desc_pontualidade
						FROM     cad_renovacao_desconto
								 INNER JOIN cad_evento
								 ON       (cad_renovacao_desconto.IDEVENTO   = cad_evento.IDEVENTO) ";
	
		
		
		if ($var_opcao_contrato == "1") { 
			$strSQLparcela .="WHERE ((cad_renovacao_desconto.PARCELA <= 5) ";
		} else {
			$strSQLparcela .="WHERE ((cad_renovacao_desconto.PARCELA > 5) ";
		}
		
		
		$strSQLparcela .=" AND (cad_renovacao_desconto.IDEVENTO = '000282'))
						   ORDER BY cad_renovacao_desconto.PARCELA,
									cad_renovacao_desconto.DESCONTO DESC;";	
		try{				
			$objResultparcela = $objConn->query($strSQLparcela);		
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}	
		foreach($objResultparcela as $objRSparcela){
	  ?>
	  <tr>
		<td height="5" width="2%"><?php echo getValue($objRSparcela,""); ?></td>
		<td height="5" width="11%" align="center"><?php echo sprintf("%02s",getValue($objRSparcela,"parcela")); ?></td>
		<td height="5" width="17%" align="center"><?php echo getValue($objRSparcela,"datavencimento"); ?></td>
		<td height="5" width="20%" align="center"><?php echo number_format(getValue($objRSparcela,"desconto") * 100, 2, ',', '.'); ?> %</td>
		<td height="5" width="14%" align="center">R$ <?php echo number_format( getValue($objRSrenovacao, ("area".$var_opcao_contrato)) - ( getValue($objRSparcela,"desconto") * getValue($objRSrenovacao, ("area".$var_opcao_contrato)) ), 2, ',', '.'); ?></td>
		<td height="5" width="36%" align="center"><?php echo getValue($objRSparcela,"desc_pontualidade")."%"; ?></td>
	  </tr>
	  <?php } ?>
	</table>
	<table width="20%" border="0" >
	  <tr>
		<td  align="center" valign="top">
		<table width="150" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="10" height="10"><img src="../img/ContrBordaSE.gif" width="10" height="10"></td>
			<td width="130" height="10"><img src="../img/ContrLinhaLS.gif" width="130" height="10"></td>
			<td width="10" height="10"><img src="../img/ContrBordaSD.gif" width="10" height="10"></td>
		</tr>
		<tr>
			<td height="100" width="10"><img src="../img/ContrLinhaLE.gif" width="10" height="100"></td>
			<td height="50" width="130" align="center" valign="middle">
				IMPORTANTE Preços e condições <br> de pagamento <br> válidos somente para <br> contratos renovados <br> até <?php echo getValue($objRSevento,"dt_limite_contrato"); ?>
			</td>
			<td height="100" width="10"><img src="../img/ContrLinhaLD.gif" width="10" height="100"></td>
		</tr>
		<tr>
			<td width="10" height="10"><img src="../img/ContrBordaIE.gif" width="10" height="10"></td>
			<td width="130" height="10"><img src="../img/ContrLinhaLI.gif" width="130" height="10"></td>
			<td width="10" height="10"><img src="../img/ContrBordaID.gif" width="10" height="10"></td>
		</tr>
		</table>
		</td>
	  </tr>
	</table>
	<table width="100%" border="0">
	  <tr>
		<td><b>No caso de atraso de uma ou mais parcelas o EXPOSITOR perderá o desconto comercial concedido, sendo o mesmo incorporado nas
		  parcelas restantes ou emitido boleto complementar.</b></td>
	  </tr>
	</table>
	
	
	<b>IV. SERVIÇOS CONTRATADOS</b>
	
	<table width="82%" border="0">
	  <tr>
		<td width="13%"  align="left"><b>Tipo Espaço:</b></td>
		<td width="21%"  align="left"><b>SEM MONTAGEM</b></td>
		<td width="12%"  align="left"><b>Localização:</b></td>
		<td width="54%"  colspan="3" align="left"><b><?php if ($strLocalizacao == ''){echo getValue($objRSpedido, "localpe").getValue($objRSpedido, "pavilhaope");} else {echo $strLocalizacao; } ?></b></td>
	  </tr>
	</table>
	
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td align="right">Cód.Prod.</td>
		<td align="center">Descrição do Produto</td>
		<td align="center">Unid.</td>
		<td align="right">Quantid.</td>
		<td align="right">Preço Unit. Bruto</td>
		<td align="right">Valor Total Bruto</td>
	  </tr>
	<?php
		//BUSCA OS DADOS DADOS DE RENOVAÇÃO DO EVENTO
		
		//  $strSQLprodutos = "select * from ped_pedidos_renovacao_evento a where a.idpedido = '".getValue($objRSpedido ,"idpedido")."' AND idmercado ilike '".$id_mercado."' order by idproduto";	
			
			$strSQLprodutos = "SELECT *
					FROM
						ped_pedidos_renovacao_evento
					INNER JOIN ped_pedidos 
					ON ped_pedidos.idpedido = ped_pedidos_renovacao_evento.idpedido
					AND upper(ped_pedidos.idmercado) = upper(ped_pedidos_renovacao_evento.idmercado)
					WHERE
						ped_pedidos.cod_pedidos =  '".getValue($objRSpedido ,"cod_pedidos")."' -- 12826 
			
					ORDER BY ped_pedidos_renovacao_evento.idproduto;";
			
				try{				
					$objResultprodutos = $objConn->query($strSQLprodutos);		
				}catch(PDOException $e) {
					mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
					die();
				}	
		  $valor_total_bruto = 0;
		  $cont_page_break   = 0; 
		  foreach($objResultprodutos as $objRSprodutos){ 
		  $cont_page_break++;
	?>
	   <tr>
		<td align="right"><?php echo getValue($objRSprodutos,"idproduto"); ?></td>
		<td align="left"><?php echo getValue($objRSprodutos,"descrpedido"); ?></td>
		<td align="center"><?php echo getValue($objRSprodutos,"unidpedido"); ?></td>
		<td align="right"><?php echo number_format(getValue($objRSprodutos,"quant_pedi"), 2, ',', '.'); ?></td>
		<td align="right">
		<?php 
		
		//SE O PRODUTO FOR AREA LIMPA (AR0001) DEVE-SE PGAR O VALOR DETERMINADO NA  TABELA cad_renovacao_valores
		//NESTA TABELA TEM O VALOR DA OPÇÃO 1 DO CONTRATO E DA OPÇÃO 2 DO CONTRADO
		
	
		if ((getValue($objRSprodutos,"idproduto")) == 'AR0001' && ($var_opcao_contrato == '1')){
						echo number_format(getValue($objRSrenovacao,"area1"), 2, ',', '.');
		} else if ((getValue($objRSprodutos,"idproduto") == 'AR0001') && ($var_opcao_contrato == '2')){
				echo number_format(getValue($objRSrenovacao,"area2"), 2, ',', '.');
		} else { 
				echo number_format(getValue($objRSprodutos,"preco_pedi"), 2, ',', '.');
		};
		?>
		
		<?php // echo number_format(getValue($objRSprodutos,"preco_pedi"), 2, ',', '.'); ?></td>
		<td align="right">
		<?php
		
		//SE O PRODUTO FOR AREA LIMPA (AR0001) DEVE-SE PGAR O VALOR DETERMINADO NA  TABELA cad_renovacao_valores
		//NESTA TABELA TEM O VALOR DA OPÇÃO 1 DO CONTRATO E DA OPÇÃO 2 DO CONTRADO
		
		if ((getValue($objRSprodutos,"idproduto")) == 'AR0001' && ($var_opcao_contrato == '1')){
						$valor_area_total = (getValue($objRSprodutos,"quant_pedi") * getValue($objRSrenovacao,"area1"));
						echo number_format($valor_area_total, 2, ',', '.');
				} else if ((getValue($objRSprodutos,"idproduto") == 'AR0001') && ($var_opcao_contrato == '2')){
							
						$valor_area_total = (getValue($objRSprodutos,"quant_pedi") * getValue($objRSrenovacao,"area2"));
						echo number_format($valor_area_total, 2, ',', '.');
				} else { 
						 $valor_area_total = getValue($objRSprodutos,"sub_total");
						 echo number_format($valor_area_total, 2, ',', '.');
				};
		
		
		?>
		<?php // echo number_format(getValue($objRSprodutos,"sub_total"), 2, ',', '.'); ?></td>
	  </tr>
	<?php
	
	$valor_total_bruto = $valor_total_bruto + $valor_area_total;
	 } ?>
	</table>
	<?php 
	//TAMANHO MÁXIMO DE PRODUTOS QUE CABE EM UMA FOLHA É 9
	// SE O TATAL TE PRODUTOS FOR MAIOR QUE 9 QUEBRAMOS A PÁGINA PARA AS CLÁUSULAS FICAREM NA PRÓXIMA PÁGINA.
	if ( $cont_page_break > 5){
		?>
		<table width="100%" border="0" class="bordasimples">
		  <tr>
			<td width="2%" style="border-bottom:none; border-left:none; border-right:none"></td>
			<td width="66%" style="border-bottom:none; border-left:none; border-right:none"></td>
			<td width="32%"  align="right"style="border-bottom:none; border-left:none; border-right:none">Valor Total Bruto:&nbsp;&nbsp;&nbsp;&nbsp;<?php echo number_format($valor_total_bruto, 2, ',', '.'); ?></td>
		  </tr>
		</table>
		<div style='page-break-after:always'>&nbsp;</div>
		<table width="100%" border="0" class="bordasimples">
		  <tr>
			<td width="2%" style="border-bottom:none; border-left:none; border-right:none"><b>V.</b></td>
			<td width="66%" style="border-bottom:none; border-left:none; border-right:none"><b>DISPOSIÇÕES FINAIS</b></td>
			<td width="32%"  align="right"style="border-bottom:none; border-left:none; border-right:none"></td>
		  </tr>
		</table>
		<?php
	}
	else {
		?>
		<table width="100%" border="0" class="bordasimples">
		  <tr>
			<td width="2%" style="border-bottom:none; border-left:none; border-right:none"><b>V.</b></td>
			<td width="66%" style="border-bottom:none; border-left:none; border-right:none"><b>DISPOSIÇÕES FINAIS</b></td>
			<td width="32%"  align="right"style="border-bottom:none; border-left:none; border-right:none">Valor Total Bruto:&nbsp;&nbsp;&nbsp;&nbsp;<?php echo number_format($valor_total_bruto, 2, ',', '.'); ?></td>
		  </tr>
		</table>
		<?php
	}
	?>
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td valign="top" align="justify"><b>1.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR compromete-se a pagar o valor de R$ <?php echo number_format($valor_total_bruto, 2, ',', '.'); ?> ( <?php echo valorPorExtenso($valor_total_bruto); ?> ), sobre o qual incidirá o desconto comercial de ___% referente ao valor do espaço sem montagem, em ___ parcela(s) mensal(ais), com primeiro vencimento em ___/___/___ . Para pagamento até a data do vencimento, se aplicará desconto de pontualidade de ____%  no boleto bancário.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>2.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR autoriza expressamente a SÃO PAULO FEIRAS COMERCIAIS LTDA a emitir os boletos de cobrança bancária, originários do presente contrato, com vencimento
		nas datas acima, bem como a emissão das notas fiscais de Organização, Planejamento, Promoção e Administração da Feira <?php echo getValue($objRSevento, "nome_completo"); ?>.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>3.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR compromete-se a cumprir o Regulamento Geral da Feira <?php echo getValue($objRSevento, "nome_completo"); ?>, que é parte integrante e complementar deste contrato,
		do qual recebe uma cópia e tem ciência.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>4.</b></td>
		<td align="justify"><div align="justify">Segundo o Item III do presente contrato, o Plano de Pagamento deverá estar plenamente quitado para participação e ingresso na feira.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>5.</b></td>
		<td align="justify"><div align="justify">Serviços Adicionais necessários e/ou convenientes à participação do EXPOSITOR na Feira, tais como: energia elétrica adicional instalada em KVA, limpeza, segurança e ponto d'água terão seus preços definidos em circular específica, pagáveis pelo EXPOSITOR até a data de 04/08/2012<?php //echo(dDate("PTB",getValue($objRSevento,"dtlimite"),"")); ?>.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>6.</b></td>
		<td align="justify"><div align="justify">Fica acordado entre as partes que a qualquer momento poderá ser aditado o contrato para modificar a cláusula de preço e condições, de forma a
		manter o equilíbrio econômico e financeiro deste contrato.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>7.</b></td>
		<td align="justify"><div align="justify">Os Contratantes elegem o Foro da Capital do Estado São Paulo, onde será realizada a Feira, para dirimirem quaisquer dúvidas provenientes da
		  execução e cumprimento deste contrato. <br>
		  Este contrato deverá ser assinado e enviado no prazo máximo de 3 dias após a sua emissão e estará sujeito a aprovação do Departamento
		Financeiro da SÃO PAULO FEIRAS COMERCIAIS LTDA. E, por estarem justas e contratadas, as partes assinam o presente contrato em duas vias de igual teor e forma. </div></td>
	  </tr>
	</table>
	<table class="bordasimples1" width="100%" border="0">
	  <tr><td align="center" colspan="3" height="5"></td></tr>
	  <tr>
		<td colspan="3">Nome/Cargo de quem autorizou o contrato:_____________________________________________________ Data: ____/____/_____</td>
	  </tr>
	  <tr><td align="center" colspan="3" height="5"></td></tr>
	  <tr>
		<td colspan="3">CPF:_______________________________ RG:________________________________</td>
	  </tr>
	  <tr><td align="center" colspan="3" height="5"></td></tr>
	  <tr>
		<td width="58%" valign="bottom" align="center">___________________________________________________</td>
		<td width="4%"></td>
		<td width="38%" valign="bottom" align="center">___________________________________________________</td>
	  </tr>
	  <tr>
		<td align="center"><?php echo strtoupper(getValue($objRSexpositor, "razao")); ?></td>
		<td></td>
		<td align="center">SÃO PAULO FEIRAS COMERCIAIS LTDA.</td>
	  </tr>
	</table>
		<?php //if (($strApenasUm == "F") || ($var_lote != "")) { ?>
			<div style="page-break-after:always">&nbsp;</div>
		<?php //} ?>
	<?php
	
	//***************************************************************************
	//ADENDO SOMENTE PARA PRET-A-PORTER
	//***************************************************************************
	
	
	if ( getValue($objRSevento,"tipoevento") == 'PRET-A-PORTER'){ 
	
	
	?> 
	
	<!-- para quebrar a páina -->
			<div style="page-break-after:always"></div>
	
			
	<!--      INICIO DO CONTRATO DE ADENDO PARA O EVENTO PRET-A-PORTER         -->
			<br>
			<table width="100%"  border="0" class="bordasimples1">
			  <tr>
				<td><table width="100%" border="1" >
					<tr>
						<td width="29%" align="center" nowrap="nowrap"><font size="+2"><b><?php echo getValue($objRSevento,"tipoevento"); ?></b></font></td>
					  <td width="4%" align="center">&nbsp;</td>
					  <td rowspan="2" valign="middle" align="center"><b><?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."° " .getValue($objRSevento,"nomeoficial"); ?> 
						
							  
						<br>
						<?php echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?>
						<?php echo getValue($objRSevento,"pavilhao");  ?> - SÃO PAULO/SP </b></td>
					</tr>
					
					<tr>
					  <td align="center" bgcolor="#000000"> 
					  
					  <font color="#FFFFFF" size="2"><b><?php echo getValue($objRSevento,"dia_inicio")." a ".getValue($objRSevento,"dia_fim")." | ".nomeMes(getValue($objRSevento,"mes_fim"))." | " .getValue($objRSevento,"ano_fim")  ?></b></font></td>
					  <td align="center">&nbsp;</td>
					</tr>
				  </table></td>
			  </tr>
			</table>
			
			
			
			<br>
			
			<div align="center" class="font_text">
				AUTORIZAÇÃO PARA INCORPORAÇÃO DA MONTAGEM PADRÃO NO CONTRATO DE ORGANIZAÇÃO, PLANEJAMENTO, PROMOÇÃO E
				ADMINISTRAÇÃO DE FEIRA COMERCIAL
			</div>
			<br>
			<br>
			
			
			<table border="0" width="100%" class="font_text"  > 
				<tr>
					<td align="left" valign="top"><strong>I. </strong></td>
					<td align="justify"><strong>PARTES </strong></td>
				</tr>
			
			
				<tr>
					<td align="left" valign="top"><strong>1. </strong></td>
					<td align="justify"> <div align="justify">SÃO PAULO FEIRAS COMERCIAIS LTDA., inscrita no CNPJ nº 02.995.701/0001-33 com sede na Rua Padre Jo&atilde;o Manoel, 923 Conj. 61/62- 6&ordm; Andar - Cerqueira C&eacute;sar - Fone <?php echo getValue($objRSempresa, "etele"); ?> - Fax<?php echo getValue($objRSempresa, "efax"); ?> - CEP 01411-001 - S&atilde;o Paulo/SP - Brasil - comercial@saopaulopretaporter.com.br - www.saopaulopretaporter.com </div></td>
				</tr>
				<tr>
					<td align="left" valign="top"><strong>2.</strong></td>
					<td align="justify"><div align="justify">EXPOSITOR: <?php echo getValue($objRSexpositor, "razao") ?> , pessoa jurídica inscrita no CNPJ nº <?php echo getValue($objRSexpositor, "cgcmf") ?>, com sede à <?php echo getValue($objRSexpositor, "endereco") ?>, 
					  <?php echo getValue($objRSexpositor, "bairro") ?>, na cidade de <?php echo getValue($objRSexpositor, "cidade")."/".getValue($objRSexpositor, "estado") ?> - CEP.: <?php echo getValue($objRSexpositor, "cep") ?>.<br>
			  <br>
				  </div></td>
				</tr>
				<tr>
					<td align="left" valign="top">&nbsp;</td>
					<td align="justify"><div align="justify">Considerando que a SÃO PAULO FEIRAS COMERCIAIS LTDA., é a promotora exclusiva e única reponsável pela Organização, Planejamento,
										Promoção e Administração para realização da Feira 
										<?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."°"; ?> -
										<?php echo getValue($objRSevento,"nome_oficial");  ?> -						
										<?php echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?>
										<?php echo getValue($objRSevento,"pavilhao");  ?> - localizado na cidade de SÃO PAULO/SP 
										<br>
										<br>
					</div></td>
				</tr>
				
				
				<tr>
					<td align="left" valign="top"><strong>II.</strong></td>
					<td align="justify"> <div align="justify"><strong>OBJETO </strong></div></td>
				</tr>
				<tr>
					<td align="left" valign="top"><strong>1.</strong></td>
					<td align="justify"><div align="justify">O presente ajuste tem como objeto a autorização e confirmação de utilização da Montagem Padrão no contrato de prestação de serviço de
					  Organização, Planejamento, Promoção e Administração da feira comercial - <?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."°"; ?> , previamente ou conjuntamente
					  assinado pelas partes.<br>
			  <br>
					</div></td>
				</tr>
				<tr>
					<td align="left" valign="top"><strong>III.</strong></td>
					<td align="justify"><div align="justify"><strong>DA MONTAGEM PADRÃO </strong></div></td>
				</tr>
				<tr>
					<td align="left" valign="top"><strong>1.</strong></td>
					<td align="justify"><div align="justify">Por tratar-se de uma bonificação que a empresa SÃO PAULO FEIRAS COMERCIAIS LTDA. está ofertando, em caso de recusa do EXPOSITOR ao
					  programa de Montagem Padrão oferecido, será concedido, automaticamente, um desconto comercial e incondicional de R$ 50,00 reais por metro
					quadrado ao EXPOSITOR. </div></td>
				</tr>
				<tr>
					<td align="left" valign="top"><strong>2.</strong></td>
					<td align="justify"><div align="justify">A Montagem Padrão consiste em um estande padrão, previamente estruturado e projetado pela empresa SÃO PAULO FEIRAS COMERCIAIS LTDA., conforme modelo a ser enviado ao expositor, devendo este dar ciência de seu recebimento. </div></td>
				</tr>
				<tr>
					<td align="left" valign="top"><strong>3.</strong></td>
					<td align="justify"><div align="justify">O EXPOSITOR, sob nenhuma hipótese ou alegação, poderá alterar a configuração, a arquitetura e os elementos da Montagem Padrão do estande,
					  entregue pela SÃO PAULO FEIRAS COMERCIAIS LTDA., quer em sua disposição, altura, largura, profundidade ou cor. O EXPOSITOR não
					poderá, sob nenhuma hipótese, ou sob qualquer alegação, contratar outra montadora que não seja a montadora oficial da área em questão. </div></td>
				</tr>				
				<tr>
					<td align="left" valign="top"><strong>4.</strong></td>
					<td align="justify"><div align="justify">Todos os materiais e equipamentos utilizados na montagem, bem como aqueles que irão guarnecer os estandes, são de propriedade da empresa
					  MONTADORA, que para este fim os cedem para uso exclusivo do expositor durante a realização do evento. Na desmontagem, caso sejam
					  constatados quaisquer danos e/ou falta de algum bem constante quando da entrega do estande, seu custo deverá ser ressarcido pelo EXPOSITOR
					ao preço de mercado. </div></td>
				</tr>		
				<tr>
					<td align="left" valign="top"><strong>5.</strong></td>
					<td align="justify"> <div align="justify">Os acréscimos de móveis e/ou materiais de montagem deverão ser solicitados e pagos diretamente à montadora indicada.<br>
					  <br>		
					</div></td>
				</tr>		
				<tr>
					<td align="left" valign="top"><strong>IV.</strong></td>
					<td align="justify"> <div align="justify"><strong>DA AUTORIZAÇÂO </strong></div></td>
				</tr>		
				<tr>
					<td align="left" valign="top"><strong>[ ]</strong></td>
					<td align="justify"><div align="justify">Autorizo e confirmo a utilização da Montagem Padrão oferecida pela empresa SÃO PAULO FEIRAS COMERCIAIS LTDA.. </div></td>
				</tr>		
				<tr>
					<td align="left" valign="top"><strong>[ ]</strong></td>
					<td align="justify"><div align="justify">Não autorizo e não confirmo a utilização da Montagem Padrão oferecida pela empresa SÃO PAULO FEIRAS COMERCIAIS LTDA.. </div><br><br></td>
				</tr>		
				<tr>
					<td align="left" valign="top"><strong>V.</strong></td>
					<td align="justify"><div align="justify"><strong>DAS DISPOSIÇÕES FINAIS</strong>
					</div></td>
				</tr>		
				<tr>
					<td align="left" valign="top"><strong>1.</strong></td>
					<td align="justify"><div align="justify">O presente ajuste entra em vigor na data de sua assinatura		</div></td>
				</tr>		
				<tr>
					<td align="left" valign="top"><strong>2.</strong></td>
					<td align="justify"><div align="justify">O EXPOSITOR compromete-se a cumprir o Regulamento Geral da Feira <?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."°"; ?> , que é parte integrante e complementar
				  desta autorização, do qual recebe uma cópia e tem ciência. </div></td>
				</tr>		
			
				<tr>
					<td align="left" valign="top"><strong>3.</strong></td>
					<td align="justify"><div align="justify">Segundo o Item III da presente autorização, o Plano de Pagamento deverá estar plenamente quitado para participação e ingresso na feira. </div></td>
				</tr>		
				<tr>
					<td align="left" valign="top"><strong>4.</strong></td>
					<td align="justify"><div align="justify">Serviços Adicionais necessários e/ou convenientes à participação do EXPOSITOR na Feira, tais como: energia elétrica adicional instalada em KVA,
					  limpeza, segurança e ponto d'água terão seus preços definidos em circular específica, pagáveis pelo EXPOSITOR até a data de <?php  echo getValue($objRSeventoAtual,"dtlimite");  ?>.
					  <br>
					  <br>		
					</div></td>
				</tr>
				<tr>
					<td colspan="2"></td>
				</tr>
			</table>
			<br><br>
			<div align="justify" class="font_text">Esta autorização deverá ser assinada com o Contrato de Prestação de Serviço de Organização, Planejamento, Promoção e Administração da feira comercial - <?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."°"; ?>  </div>
			<br><br>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td  height="30"></td>
				</tr>
				<tr>
					<td align="left" class="font_text" width="1%" nowrap="nowrap">Nome/Cargo de quem autorizou o contrato:</td>
					<td align="left" class="font_text">________________________________________________________________</td>
					<td align="right" nowrap="nowrap" class="font_text">Data:_____________</td>
				</tr>
			</table>
			<table width="100%" border="0" >
				<tr>
					<td align="left" class="font_text"  width="1%" nowrap="nowrap" >CPF:</td>
					<td align="left" class="font_text" >_____________________________________</td>
					
					<td align="right" class="font_text">RG:</td>
					<td align="left"  class="font_text">___________________________________</td>
					
					<td align="right" class="font_text">Data de Aniversário:_____________</td>
				</tr>
			</table>
			<br><br><br>
			<br><br><br>
			<br><br><br>
			<div align="center">_________________________________________________</div>
			<div align="center" class="font_text"><?php echo getValue($objRSexpositor, "razao") ?></div>
			<!-- FINAL DO ADENDO DO PRETA PORTER -->
			<?php if (($strApenasUm == "F") || ($var_lote != "")) { ?>
				<!-- para quebrar a páina -->
				<div style="page-break-after:always"></div>
			<?php } ?>
	<?php
		} // IF DO ADENDO DO PRET-A-PORTER
	   } //foreach dos contratos 
}
 ?>
</body>
</html>
<?php 
$objConn = NULL; ?>
