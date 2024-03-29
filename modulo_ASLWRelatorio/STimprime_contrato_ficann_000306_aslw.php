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
//$var_opcao_contrato = request("var_opcao_contrato");
$var_localizacao    = request("var_localizacao");
$var_pavilhao       = request("var_pavilhao");

//if ($var_opcao_contrato == "") $var_opcao_contrato = "1";

$strApenasUm = "F";
if (($var_cod_pedido != "") || ($var_lote != "")) $strApenasUm = "T";
include_once("_include_aslRunRequest.php");
include_once("_include_aslRunBase.php");
// ABERTURA DE CONEX�O COM BANCO DE DADOS
$objConn = abreDBConn(CFG_DB);
	
/***            VERIFICA��O DE ACESSO              ***/
/*****************************************************/
/*
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verifica��o de acesso do usu�rio corrente
*/

/***           DEFINI��O DE PAR�METROS            ***/
/****************************************************/

$strAcao   	      = request("var_acao");           // Indicativo para qual formato que a grade deve ser exportada. Caso esteja vazio esse campo, a grade � exibida normalmente.
$strSQLParam      = request("var_sql_param");      // Par�metro com o SQL vindo do bookmark
$strPopulate      = request("var_populate");       // Flag de verifica��o se necessita popular o session ou n�o

/***    A��O DE PREPARA��O DA GRADE - OPCIONAL    ***/
/****************************************************/
if($strPopulate == "yes") { initModuloParams(basename(getcwd())); } //Popula o session para fazer a abertura dos �tens do m�dulo


/***        A��O DE EXPORTA��O DA GRADE          ***/
/***************************************************/
//Define uma vari�vel booleana afim de verificar se � um tipo de exporta��o ou n�o
$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc");

//Exporta��o para excel, word e adobe reader
if($boolIsExportation) {
	//Coloca o cabe�alho de download do arquivo no formato especificado de exporta��o
	header("Content-type: application/force-download"); 
	header("Content-Disposition: attachment; filename=Modulo_" . getTText(getsession($strSesPfx . "_titulo"),C_NONE) . "_". time() . $strAcao);
		
	$strLimitOffSet = "";
} 

function convertem($term, $tp) { 
    if ($tp == "1") $palavra = strtr(strtoupper($term),"������������������������������","������������������������������"); 
    elseif ($tp == "0") $palavra = strtr(strtolower($term),"������������������������������","������������������������������"); 
    return $palavra; 
} 

function nomeMes($mes) {
	switch ($mes){
	case 1:  $mes  = "JANEIRO"; break;
	case 2:  $mes  = "FEVEREIRO"; break;
	case 3:  $mes  = "MAR�O"; break;
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
//die($strSQL);
if($strSQL != "") {
	try{
		$objResult = $objConn->query($strSQL); // Rodando a consulta
		if($objResult->rowCount() == 0 || $objResult == ""){
			mensagem("alert_consulta_vazia_titulo","alert_consulta_vazia_desc", "", "","aviso",1);
			die();
		}
	}
	catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
	}
} else {
	mensagem("info_nova_pesquisa_titulo","info_nova_pesquisa_desc", "", "","info",1);
	die();
}
//die($strSQL);
/*if ($strApenasUm == "T") {
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
						WHERE ped_pedidos.idevento = '".$id_evento."' 
						AND ped_pedidos.idstatus = '003'
						AND ped_pedidos.paispe = 'BRASIL'
						AND ped_pedidos.catalogo = TRUE 
						AND NOT ped_pedidos.excluida
						AND SUBSTRING(ped_pedidos.idpedido FROM 7 FOR 3) = '-00'
						AND ped_pedidos_renovacao_evento.idpedido IS NOT NULL
						ORDER BY ped_pedidos.razaope ";
}*/
try{				
	$objResultcontrato = $objConn->query($strSQL);		
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

	foreach($objResultcontrato as $objRScontratoRenovacao){
		$var_opcao_contrato = getValue($objRScontratoRenovacao,"var_opcao"); 
		$var_cod_pedido = getValue($objRScontratoRenovacao,"cod_pedidos"); 
		
		if (($var_cod_pedido != "") && ($var_lote == "")) { //if ($strApenasUm == "T") {
			$strLocalizacao = $var_localizacao;
			$strPavilhao = $var_pavilhao;
		}
		else {
			$strLocalizacao = getValue($objRScontratoRenovacao,"localpe");
			$strPavilhao = getValue($objRScontratoRenovacao,"pavilhaope");
		}
		
		//BUSCA O PAVILH�O SELECIONADO NA COMBO ANTERIOR
		$strSQLpavilhao = "select descrpavilhao, idpavilhao from cad_pavilhao where idpavilhao ilike '".$strPavilhao."'";	
		try{
			$objResultpavilhao = $objConn->query($strSQLpavilhao);		
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}	
		$objRSpavilhao = $objResultpavilhao->fetch();
		$strLocalizacao = $strLocalizacao." - ".getValue($objRSpavilhao,"descrpavilhao"); 
		
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
										 to_char((cad_evento.dt_inicio - interval '2 month'),'mm') 			as data_venc_mes,
										 to_char((cad_evento.dt_inicio - interval '2 month'),'yyyy') 		as data_venc_ano,
										 to_char((cad_evento.dt_inicio - interval '2 month'),'mm/yyyy') 	as data_venc
								FROM cad_evento, cad_tipo_evento
								WHERE cad_evento.cod_tipo_evento = cad_tipo_evento.cod_tipo_evento
								AND cad_evento.idevento = '".$id_evento."'";
		try{			
			$objResulteventoAtual = $objConn->query($strSQLeventoAtual); // execu��o da query
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
								 cad_tipo_evento.descricao AS tipoevento			   , 
								 cad_evento.nome								 	   ,
								 to_char(cad_evento.dt_limite_contrato, 'dd/mm/yyyy') as dt_limite_contrato,
								 date_part('day', cad_evento.dt_inicio ) as dia_inicio ,
								 date_part('day', cad_evento.dt_fim )    as dia_fim    ,
								 date_part('month', cad_evento.dt_fim )  as mes_fim    ,
								 date_part('year', cad_evento.dt_fim )   as ano_fim    ,
								 cad_evento.dtlimite								   ,
								 CASE WHEN cad_evento.idmercado = 'BE' 
								 		THEN 'HAIR BRASIL' 
										ELSE CASE WHEN cad_evento.idmercado = 'SA' 
											 THEN 'HOSPITALAR'
											 ELSE 'FICANN'
										END END AS nomeevento						   ,
								CASE WHEN cad_evento.idmercado = 'BE' 
								 		THEN 'S�O PAULO FEIRAS COMERCIAIS LTDA' 
										ELSE CASE WHEN cad_evento.idmercado = 'SA' 
											 THEN 'HOSPITALAR FEIRAS, CONGRESSOS E EMPREENDIMENTOS LTDA'
											 ELSE 'COUROMODA FEIRAS COMERCIAIS LTDA E FRANCAL FEIRAS E EMPREENDIMENTOS LTDA'
										END END AS empreendimento						   		
						FROM cad_evento, cad_tipo_evento
						WHERE cad_evento.cod_tipo_evento = cad_tipo_evento.cod_tipo_evento
						AND cad_evento.idevento = '000306' ";
		
		try{			
			$objResultevento = $objConn->query($strSQLevento); // execu��o da query
		}catch(PDOException $e){
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
				die();
		}
		$objRSevento = $objResultevento->fetch();
		
		//BUSCA OS VALORES DE RENOVA��O DO EVENTO
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
							WHERE idevento = '". getValue($objRSevento,"idevento") ."';";	
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
			 <?php /*?> <td width="20%" align="center"><img src="../../<?php echo $dir_cliente; ?>/upload/LogoContrato_<?php echo $id_mercado; ?>.jpg" border="0"></td><?php */?>
              <td width="20%" align="center" style="vertical-align:text-bottom; font-size:24px; text-transform:capitalize; font-weight:bold; " nowrap><?php echo(getValue($objRSevento,"nome"));?></td>
			  <td width="1%" align="center">&nbsp;</td>
			  <td colspan="2" width="79%"><?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao"); ?> 
				<?php echo getValue($objRSevento,"nome_oficial");   ?> - 01 a 03 de setembro de 2014 -
				<?php // echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?>
				<?php echo getValue($objRSevento,"pavilhao");  ?> - FORTALEZA/CE</td>
			</tr>
			<tr>
			  <td width="20%" align="center" bgcolor="#000000"><font color="#FFFFFF" size="2"><b><?php echo getValue($objRSevento,"dia_inicio")." a ".getValue($objRSevento,"dia_fim")." | ".nomeMes(getValue($objRSevento,"mes_fim"))." | " .getValue($objRSevento,"ano_fim")  ?></b></font></td>
			  <td width="1%" align="center">&nbsp;</td>
			  <td width="10%" align="center" bgcolor="#000000" nowrap="nowrap"><font color="#FFFFFF" size="2"><b>OP��O <?php echo $var_opcao_contrato; ?></b></font></td>
			  <td width="69%">Condi��es v�lidas para renova��o at� <?php echo getValue($objRSevento,"dt_limite_contrato"); ?>, com pagamento <?php if ($var_opcao_contrato == "1") { echo(" em at� 5 parcelas. "); } else { echo(" de 6 a 10 parcelas. "); }?></td>
			</tr>
		  </table></td>
	  </tr>
	</table>
	<div align="center">CONTRATO DE ORGANIZA��O, PLANEJAMENTO, PROMO��O E ADMINISTRA��O DE FEIRA COMERCIAL</div>
	<div align="justify"><b>I. CONTRATANTES</b>
	  <br>
	  <b>1. PROMOTORA E ORGANIZADORA: </b>FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA., inscrita no CNPJ n&ordm; 16.943.233/0001-68
      <?php // echo getValue($objRSempresa, "ecnpj"); ?>
com sede na Rua VICENTE LINHARES, 500 CONJUNTOS 801, 802 E 803 - Bairro Aldeota Fone <?php echo getValue($objRSempresa, "etele"); ?> - Fax <?php echo getValue($objRSempresa, "efax"); ?> - CEP 60.135-270 -  FORTALEZA/CE - BRASIL - contato@ficann.com.br - www.ficann.com.br, promotora e organizadora da <?php echo getValue($objRSevento, "nome_completo"); ?> um empreendimento da <?php echo getValue($objRSevento, "empreendimento"); ?>.<br>
	<b>2. EXPOSITOR</b>
	</div>
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td width="14%">C�digo</td>
		<td width="41%" align="left"><div align="left"><strong><?php echo getValue($objRSexpositor, "idmercado").getValue($objRSexpositor, "codigo");?></strong></div></td>
		<td width="16%">Telefone</td>
		<td width="29%"><div align="left"><strong><?php echo getValue($objRSexpositor, "telefone1"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Raz�o Social</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "razao"); ?></strong></div></td>
		<td>Telefax</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "telefone2"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Nome Fantasia</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "fantasia"); ?></strong></div></td>
		<td>Dire��o</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "telefone3"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Endere�o</td>
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
		<td>C�digo Postal</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "cep"); ?></strong></div></td>
		<td>E-Mail</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "email"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Pa�s</td>
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
		<td><!--Marcas--></td>
		<td><div align="left"><strong><?php 
			//N�o exibe mais porque deslocava o resto pra baixo e gerava problema na impress�o porque assinatura 
			//ficava quebrada; acontecia quando expositor tinha muitas marcas, como CARBONGEL
			//Solu��o de "retic�ncias" n�o passou, ent�o Bruna pediu para remover todo campo - by Clv 05/05/2011
			/*
			if (strlen($marcasExpositor) > 135) 
				echo substr($marcasExpositor, 0, 135) . "..."; 
			else
				echo $marcasExpositor; 
			*/
			?></strong></div></td>
		<td>Produto Principal</td>
		<td><div align="left"><strong><?php echo $strProdPrinc; ?></strong></div></td>
	  </tr>
	</table>
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td width="2%" valign="top"><b>II.</b></td>
		<td width="98%" align="justify"><div align="justify"><b>OBJETO DO CONTRATO:</b> FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA, � a promotora exclusiva e �nica respons�vel pela Organiza��o, Planejamento, Promo��o e Administra��o da Feira <?php echo getValue($objRSevento, "nome_completo"); ?> <?php //echo getValue($objRSevento, "edicao"); ?>
		 -  <?php   echo getValue($objRSevento,"nome_oficial");   ?> 
		 -	<?php // echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?>01 a 03 de setembro de 2014 - <?php echo getValue($objRSevento,"pavilhao"); ?>, localizada na cidade de Fortaleza/CE, sendo de sua responsabilidade exclusiva prover todos os servi�os necess�rios e/ou convenientes � realiza��o desta Feira, nos termos do Regulamento Geral, que faz parte integrante e complementar deste contrato. </div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>1.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR participar� da Feira <?php echo getValue($objRSevento, "nome_completo"); ?> ocupando um ou mais espa�os, com tipo de montagem padr&atilde;o, a ele disponibilizados pela
		FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA., ao pre�o de: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .<b>R$ <?php echo number_format(getValue($objRSrenovacao, "area".$var_opcao_contrato), 2, ',', '.'); ?> por m�</b></div></td>
	  </tr>
	  <!-- tr>
		<td valign="top" ><b>2.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR providenciar� �s suas expensas exclusivas a montagem do estande, tendo a inteira liberdade de cri�-lo de acordo com o visual,
		decora��o e disposi��o desejados, obedecendo �s normas estabelecidas pelo Regulamento Geral, exceto grupos, que t�m regras espec�ficas.</div></td>
	  </tr //-->
	  <tr>
		<td valign="top"><b>3.</b></td>
		<td align="justify"><div align="justify">Energia El�trica Instalada/Obrigat�ria: Ser� cobrado neste contrato o equivalente a 0,070 KVA de energia el�trica instalada por m� no espa�o
		disponibilizado, conforme item 6.2.6 do Regulamento Geral, ao pre�o de: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .  . . . .<b>R$
		<?php echo number_format( getValue($objRSrenovacao, "energia" ), 2, ',', '.'); ?> por m�</b></div></td>
	  </tr>
	  <?php if ($id_evento <> '000228') { ?>
	 <?php /*?> <tr>
		<td valign="top"><b>4.</b></td>
		<td align="justify"><div align="justify">Energia El�trica da Climatiza��o: Corresponde ao funcionamento de todo o sistema de climatiza��o, no per�odo de realiza��o da <?php echo getValue($objRSevento, "nome_completo"); ?>
		e ser� cobrado por m� juntamente com as parcelas deste contrato . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   . . . . . .<b>R$ 
		
		<?php echo number_format( getValue($objRSrenovacao, "energia_cli") , 2, ',', '.'); ?> por m�</b></div></td>
	  </tr><?php */?>
	  <?php } ?> 
	  <tr>
		<td><b>III.</b></td>
		<td><b>PLANO DE PAGAMENTO</b></td>
	  </tr>
	</table>

	<table width="100%" border="0"><tr><td width="100%">

	<table width="70%" border="0" class="bordasimples" align="left">
	  <tr>
		<td width="2%">&nbsp;</td>
		<td width="11%" align="center">N�mero de <br>Parcelas</td>
		<td width="17%" align="center">Primeiro<br>Vencimento</td>
		<td width="20%" align="center">Desconto Comercial <br> na emiss�o da Fatura</td>
		<td width="14%" align="center"><b>Pre�o L�quido(por m�)</b></td>
		<td width="36%" align="center">Desconto Pontualidade v�lido para pagto at� o vencto do boleto banc�rio</td>
	  </tr>
	  <?php 
	  // BUSCA AS PARCELAS
	  
	   $strSQLparcela = "SELECT DISTINCT cad_evento.dt_fim
								,cad_evento.dt_inicio
								,cad_renovacao_desconto.parcela
								,cad_renovacao_desconto.desconto
								,cad_renovacao_desconto.pagamentomes
								,cad_renovacao_desconto.idevento
								,cad_renovacao_desconto.idmercado
								,to_char(cad_renovacao_desconto.datavencimento, 'dd/mm/yyyy') AS datavencimento
								,desconto_pontualidade
						   FROM cad_renovacao_desconto
								INNER JOIN cad_evento ON (cad_renovacao_desconto.IDEVENTO   = cad_evento.IDEVENTO) ";
		if ($var_opcao_contrato == "1") { 
			$strSQLparcela .="WHERE ((cad_renovacao_desconto.PARCELA <= 5) ";
		} else {
			$strSQLparcela .="WHERE ((cad_renovacao_desconto.PARCELA > 5) ";
		}
		$strSQLparcela .=" AND (cad_renovacao_desconto.IDEVENTO = '" . getValue($objRSevento,"idevento") . "'))
						   ORDER BY cad_renovacao_desconto.PARCELA, cad_renovacao_desconto.DESCONTO DESC;";	
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
		<td height="5" width="20%" align="center"><?php echo number_format(getValue($objRSparcela,"desconto")*100, 2, ',', '.'); ?> %</td>
		<td height="5" width="14%" align="center">R$<?php echo number_format( getValue($objRSrenovacao, ("area".$var_opcao_contrato)) - ( getValue($objRSparcela,"desconto") * getValue($objRSrenovacao, ("area".$var_opcao_contrato)) ), 2, ',', '.'); ?></td>
		<td height="5" width="36%" align="center"><?php echo getValue($objRSparcela,"desconto_pontualidade")."%"; ?></td>
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
				IMPORTANTE Pre�os e condi��es <br> de pagamento <br> v�lidos somente para <br> contratos renovados <br> at� <?php echo getValue($objRSevento,"dt_limite_contrato"); ?>
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

	</td></tr></table>
	
	<table width="100%" border="0">
	  <tr>
		<td><b>No caso de atraso de uma ou mais parcelas o EXPOSITOR perder� o desconto comercial concedido, sendo o mesmo incorporado nas
		  parcelas restantes ou emitido boleto complementar.</b></td>
	  </tr>
	</table>
	
	
	<b>IV. SERVI�OS CONTRATADOS</b>
	
	<table width="82%" border="0">
	  <tr>
		<td width="13%"  align="left"><b>Tipo Espa�o:</b></td>
		<td width="21%"  align="left"><b>MONTAGEM PADR&Atilde;O </b></td>
		<td width="12%"  align="left"><b>Localiza��o:</b></td>
		<td width="54%"  colspan="3" align="left"><b><?php echo getValue($objRSpedido, "localpe");  if (getValue($objRSpedido, "pavilhaope") <> "") {echo " - " . getValue($objRSpedido, "pavilhaope");}; ?></b></td>
	  </tr>
	</table>
	
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td align="right">C�d.Prod.</td>
		<td align="left">Descri��o do Produto</td>
		<td align="center">Unid.</td>
		<td align="right">Quantid.</td>
		<td align="right">Pre�o Unit. Bruto</td>
		<td align="right">Valor Total Bruto</td>
	  </tr>
	<?php
		//BUSCA OS DADOS DADOS DE RENOVA��O DO EVENTO
		
		//  $strSQLprodutos = "select * from ped_pedidos_renovacao_evento a where a.idpedido = '".getValue($objRSpedido ,"idpedido")."' AND idmercado ilike '".$id_mercado."' order by idproduto";	
			
			$strSQLprodutos  = "SELECT * ";
			$strSQLprodutos .= "  FROM ped_pedidos_renovacao_evento";
			$strSQLprodutos .= " INNER JOIN ped_pedidos ";
			$strSQLprodutos .= "		ON ped_pedidos.idpedido = ped_pedidos_renovacao_evento.idpedido";
			$strSQLprodutos .= "		AND upper(ped_pedidos.idmercado) = upper(ped_pedidos_renovacao_evento.idmercado)";
			$strSQLprodutos .= " WHERE ped_pedidos.cod_pedidos =  '".getValue($objRSpedido ,"cod_pedidos")."'"; /* -- 12826 */
			$strSQLprodutos .= "   AND ped_pedidos_renovacao_evento.idevento LIKE '000306'"; /* provis�rio este relat�rio renova especificamente o evento 000306 FICANN */
			$strSQLprodutos .= " ORDER BY ped_pedidos_renovacao_evento.idproduto;";
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
		// ATEN��O: seria "AR0001" pra ser usado como pdoduto principal, mas neste caso dos eventos 000305 e 000306 eles trocaram
		// e usaram o prdotudo AR0002, por agilidade mudamso o algoritmo a baixo para de AR0001 para AR0002
		// 21/09/2013 (Aless e Brunte)
		// ------------------------------------------------------------------------------------------------------		
		
		//SE O PRODUTO FOR AREA LIMPA (AR0001) DEVE-SE PGAR O VALOR DETERMINADO NA  TABELA cad_renovacao_valores
		//NESTA TABELA TEM O VALOR DA OP��O 1 DO CONTRATO E DA OP��O 2 DO CONTRADO
		if ((getValue($objRSprodutos,"idproduto")) == 'AR0002' && ($var_opcao_contrato == '1')){
						echo number_format(getValue($objRSrenovacao,"area1"), 2, ',', '.');
		} else if ((getValue($objRSprodutos,"idproduto") == 'AR0002') && ($var_opcao_contrato == '2')){
				echo number_format(getValue($objRSrenovacao,"area2"), 2, ',', '.');
		} else { 
				echo number_format(getValue($objRSprodutos,"preco_pedi"), 2, ',', '.');
		};
		?>
		<?php // echo number_format(getValue($objRSprodutos,"preco_pedi"), 2, ',', '.'); ?></td>
		<td align="right">
		<?php
		//SE O PRODUTO FOR AREA LIMPA (AR0001) DEVE-SE PGAR O VALOR DETERMINADO NA  TABELA cad_renovacao_valores
		//NESTA TABELA TEM O VALOR DA OP��O 1 DO CONTRATO E DA OP��O 2 DO CONTRADO
		if ((getValue($objRSprodutos,"idproduto")) == 'AR0002' && ($var_opcao_contrato == '1')){
			$valor_area_total = (getValue($objRSprodutos,"quant_pedi") * getValue($objRSrenovacao,"area1"));
			echo number_format($valor_area_total, 2, ',', '.');
		} else if ((getValue($objRSprodutos,"idproduto") == 'AR0002') && ($var_opcao_contrato == '2')){
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
	//TAMANHO M�XIMO DE PRODUTOS QUE CABE EM UMA FOLHA � 9
	// SE O TATAL TE PRODUTOS FOR MAIOR QUE 9 QUEBRAMOS A P�GINA PARA AS CL�USULAS FICAREM NA PR�XIMA P�GINA.
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
			<td width="66%" style="border-bottom:none; border-left:none; border-right:none"><b>DISPOSI��ES FINAIS</b></td>
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
			<td width="66%" style="border-bottom:none; border-left:none; border-right:none"><b>DISPOSI��ES FINAIS</b></td>
			<td width="32%"  align="right"style="border-bottom:none; border-left:none; border-right:none">Valor Total Bruto:&nbsp;&nbsp;&nbsp;&nbsp;<?php echo number_format($valor_total_bruto, 2, ',', '.'); ?></td>
		  </tr>
		</table>
		<?php
	}
	?>
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td valign="top" align="justify"><b>1.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR compromete-se a pagar o valor de R$ <?php echo number_format($valor_total_bruto, 2, ',', '.'); ?> ( <?php echo valorPorExtenso($valor_total_bruto); ?> ), sobre o qual incidir� o desconto comercial de ___% referente ao valor do espa�o com montagem padr�o, em ___ parcela(s) mensal(ais), com primeiro vencimento em ___/___/___ . Para pagamento at� a data do vencimento, se aplicar� desconto de pontualidade de ____%  no boleto banc�rio.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>2.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR autoriza expressamente a FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA a emitir os boletos de cobran�a banc�ria, origin�rios do presente contrato, com vencimento
		nas datas acima, bem como a emiss�o das notas fiscais de Organiza��o, Planejamento, Promo��o e Administra��o da Feira <?php echo getValue($objRSevento, "nome_completo"); ?>.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>3.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR compromete-se a cumprir o Regulamento Geral da Feira <?php echo getValue($objRSevento, "nome_completo"); ?>,  e respeitar a montagem padr&atilde;o disponibilizada, conforme anexo que &eacute; parte integrante e 
		complementar deste contrato, do qual recebe uma c&oacute;pia e tem ci&ecirc;ncia. </div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>4.</b></td>
		<td align="justify"><div align="justify">Segundo o Item III do presente contrato, o Plano de Pagamento dever� estar plenamente quitado para participa��o e ingresso na feira.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>5.</b></td>
		<td align="justify"><div align="justify">Servi�os Adicionais necess�rios e/ou convenientes � participa��o do EXPOSITOR na Feira, tais como: energia el�trica adicional instalada em KVA, limpeza, seguran�a e ponto d'�gua ter�o seus pre�os definidos em circular espec�fica, pag�veis pelo EXPOSITOR at� a data de <?php echo(dDate("PTB",getValue($objRSevento,"dtlimite"),"")); ?>.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>6.</b></td>
		<td align="justify"><div align="justify">Fica acordado entre as partes que a qualquer momento poder� ser aditado o contrato para modificar a cl�usula de pre�o e condi��es, de forma a
		manter o equil�brio econ�mico e financeiro deste contrato.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>7.</b></td>
		<td align="justify"><div align="justify">Os Contratantes elegem o Foro da Capital do Estado de Cear&aacute;, onde ser� realizada a Feira, para dirimirem quaisquer d�vidas provenientes da
		  execu��o e cumprimento deste contrato. <br>
		  Este contrato dever� ser assinado e enviado no prazo m�ximo de 3 dias ap�s a sua emiss�o e estar� sujeito a aprova��o do Departamento
		Financeiro da FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA. E, por estarem justas e contratadas, as partes assinam o presente contrato em duas vias de igual teor e forma. </div></td>
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
		<td align="center">FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA.</td>
	  </tr>
	</table>
		
            
         
         <div style="page-break-after:always">&nbsp;</div>
         
         
         
             <table width="100%" cellpadding="0" cellspacing="0" border="0">
	  <tr>
		<td><table width="100%" border="1" class="bordasimples1">
			<tr>
			 <?php /*?> <td width="20%" align="center"><img src="../../<?php echo $dir_cliente; ?>/upload/LogoContrato_<?php echo $id_mercado; ?>.jpg" border="0"></td><?php */?>
              <td width="20%" align="center" style="vertical-align:text-bottom; font-size:24px; text-transform:capitalize; font-weight:bold; " nowrap><?php echo(getValue($objRSevento,"nome"));?></td>
			  <td width="1%" align="center">&nbsp;</td>
			  <td colspan="2" width="79%"><?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao"); ?> 
				<?php echo getValue($objRSevento,"nome_oficial");   ?> - 01 a 03 de setembro de 2014 -
				<?php // echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?>
				<?php echo getValue($objRSevento,"pavilhao");  ?> - FORTALEZA/CE</td>
			</tr>
			<tr>
			  <td width="20%" align="center" bgcolor="#000000"><font color="#FFFFFF" size="2"><b><?php echo getValue($objRSevento,"dia_inicio")." a ".getValue($objRSevento,"dia_fim")." | ".nomeMes(getValue($objRSevento,"mes_fim"))." | " .getValue($objRSevento,"ano_fim")  ?></b></font></td>
			  <td width="1%" align="center">&nbsp;</td>
			  <td width="10%" align="center" bgcolor="#000000" nowrap="nowrap"><font color="#FFFFFF" size="2"><b>OP��O <?php echo $var_opcao_contrato; ?></b></font></td>
			  <td width="69%">Condi��es v�lidas para renova��o at� <?php echo getValue($objRSevento,"dt_limite_contrato"); ?>, com pagamento <?php if ($var_opcao_contrato == "1") { echo(" em at� 5 parcelas. "); } else { echo(" de 6 a 10 parcelas. "); }?></td>
			</tr>
		  </table></td>
	  </tr>
	</table>
	<div align="center">CONTRATO DE ORGANIZA��O, PLANEJAMENTO, PROMO��O E ADMINISTRA��O DE FEIRA COMERCIAL</div>
	<div align="justify"><b>I. CONTRATANTES</b>
	  <br>
	  <b>1. PROMOTORA E ORGANIZADORA: </b>FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA., inscrita no CNPJ n&ordm; 16.943.233/0001-68
      <?php // echo getValue($objRSempresa, "ecnpj"); ?>
com sede na Rua VICENTE LINHARES, 500 CONJUNTOS 801, 802 E 803 - Bairro Aldeota Fone <?php echo getValue($objRSempresa, "etele"); ?> - Fax<?php echo getValue($objRSempresa, "efax"); ?> - CEP 60.135-270 -  FORTALEZA/CE - BRASIL - contato@ficann.com.br - www.ficann.com.br, promotora e organizadora da <?php echo getValue($objRSevento, "nome_completo"); ?> um empreendimento da <?php echo getValue($objRSevento, "empreendimento"); ?>..<br>
	<b>2. EXPOSITOR</b>
	</div>
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td width="14%">C�digo</td>
		<td width="41%" align="left"><div align="left"><strong><?php echo getValue($objRSexpositor, "idmercado").getValue($objRSexpositor, "codigo");?></strong></div></td>
		<td width="16%">Telefone</td>
		<td width="29%"><div align="left"><strong><?php echo getValue($objRSexpositor, "telefone1"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Raz�o Social</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "razao"); ?></strong></div></td>
		<td>Telefax</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "telefone2"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Nome Fantasia</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "fantasia"); ?></strong></div></td>
		<td>Dire��o</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "telefone3"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Endere�o</td>
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
		<td>C�digo Postal</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "cep"); ?></strong></div></td>
		<td>E-Mail</td>
		<td><div align="left"><strong><?php echo getValue($objRSexpositor, "email"); ?></strong></div></td>
	  </tr>
	  <tr>
		<td>Pa�s</td>
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
		<td><!--Marcas--></td>
		<td><div align="left"><strong><?php 
			//N�o exibe mais porque deslocava o resto pra baixo e gerava problema na impress�o porque assinatura 
			//ficava quebrada; acontecia quando expositor tinha muitas marcas, como CARBONGEL
			//Solu��o de "retic�ncias" n�o passou, ent�o Bruna pediu para remover todo campo - by Clv 05/05/2011
			/*
			if (strlen($marcasExpositor) > 135) 
				echo substr($marcasExpositor, 0, 135) . "..."; 
			else
				echo $marcasExpositor; 
			*/
			?></strong></div></td>
		<td>Produto Principal</td>
		<td><div align="left"><strong><?php echo $strProdPrinc; ?></strong></div></td>
	  </tr>
	</table>
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td width="2%" valign="top"><b>II.</b></td>
		<td width="98%" align="justify"><div align="justify"><b>OBJETO DO CONTRATO:</b>  FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA, � a promotora exclusiva e �nica respons�vel pela Organiza��o, Planejamento, Promo��o e Administra��o da Feira <?php echo getValue($objRSevento, "nome_completo"); ?> <?php //echo getValue($objRSevento, "edicao"); ?>
		 -  <?php   echo getValue($objRSevento,"nome_oficial");   ?> 
		 -	<?php //echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?> 01 a 03 de setembro de 2014 - <?php echo getValue($objRSevento,"pavilhao"); ?>, localizada na cidade de Fortaleza/CE, sendo de sua responsabilidade exclusiva prover todos os servi�os necess�rios e/ou convenientes � realiza��o desta Feira, nos termos do Regulamento Geral, que faz parte integrante e complementar deste contrato. </div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>1.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR participar� da Feira <?php echo getValue($objRSevento, "nome_completo"); ?> ocupando um ou mais espa�os, com tipo de montagem padr�o ou n�o, a ele disponibilizados pela
		FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA., ao pre�o de: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .<b>R$ <?php echo number_format(getValue($objRSrenovacao, "area".$var_opcao_contrato), 2, ',', '.'); ?> por m�</b></div></td>
	  </tr>
	  <!-- tr>
		<td valign="top" ><b>2.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR providenciar� �s suas expensas exclusivas a montagem do estande, tendo a inteira liberdade de cri�-lo de acordo com o visual,
		decora��o e disposi��o desejados, obedecendo �s normas estabelecidas pelo Regulamento Geral, exceto grupos, que t�m regras espec�ficas.</div></td>
	  </tr //-->
	  <tr>
		<td valign="top"><b>2.</b></td>
		<td align="justify"><div align="justify">Energia El�trica Instalada/Obrigat�ria: Ser� cobrado neste contrato o equivalente a 0,070 KVA de energia el�trica instalada por m� no espa�o
		disponibilizado, conforme item 6.2.6 do Regulamento Geral, ao pre�o de: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .  . . . .<b>R$
		<?php echo number_format( getValue($objRSrenovacao, "energia" ), 2, ',', '.'); ?> por m�</b></div></td>
	  </tr>
	 
	  <tr>
		<td><b>III.</b></td>
		<td><b>PLANO DE PAGAMENTO</b></td>
	  </tr>
	</table>
	
	<table width="100%" border="0"><tr><td width="100%">
	
	<table width="70%" border="0" class="bordasimples" align="left">
	  <tr>
		<td width="2%">&nbsp;</td>
		<td width="11%" align="center">N�mero de <br>Parcelas</td>
		<td width="17%" align="center">Primeiro<br>Vencimento</td>
		<td width="20%" align="center">Desconto Comercial <br> na emiss�o da Fatura</td>
		<td width="14%" align="center"><b>Pre�o L�quido(por m�)</b></td>
		<td width="36%" align="center">Desconto Pontualidade v�lido para pagto at� o vencto do boleto banc�rio</td>
	  </tr>
	  <?php 
	  // BUSCA AS PARCELAS
	   $strSQLparcela = "SELECT   DISTINCT cad_evento.dt_fim
								 ,cad_evento.dt_inicio
								 ,cad_renovacao_desconto.parcela
								 ,cad_renovacao_desconto.desconto
								 ,cad_renovacao_desconto.pagamentomes
								 ,cad_renovacao_desconto.idevento
								 ,cad_renovacao_desconto.idmercado
								 ,desconto_pontualidade
								 ,to_char(cad_renovacao_desconto.datavencimento, 'dd/mm/yyyy') AS datavencimento
								 ,cad_evento.max_descfin as desc_pontualidade
						   FROM cad_renovacao_desconto
								INNER JOIN cad_evento ON (cad_renovacao_desconto.IDEVENTO   = cad_evento.IDEVENTO) ";
		if ($var_opcao_contrato == "1") { 
			$strSQLparcela .="WHERE ((cad_renovacao_desconto.PARCELA <= 5) ";
		} else {
			$strSQLparcela .="WHERE ((cad_renovacao_desconto.PARCELA > 5) ";
		}
		$strSQLparcela .=" AND (cad_renovacao_desconto.IDEVENTO = '" . getValue($objRSevento,"idevento") . "'))
						   ORDER BY cad_renovacao_desconto.PARCELA, cad_renovacao_desconto.DESCONTO DESC;";	
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
		<td height="5" width="20%" align="center"><?php echo number_format(getValue($objRSparcela,"desconto")*100, 2, ',', '.'); ?> %</td>
		<td height="5" width="14%" align="center">R$<?php echo number_format( getValue($objRSrenovacao, ("area".$var_opcao_contrato)) - ( getValue($objRSparcela,"desconto") * getValue($objRSrenovacao, ("area".$var_opcao_contrato)) ), 2, ',', '.'); ?></td>
		<td height="5" width="36%" align="center"><?php echo getValue($objRSparcela,"desconto_pontualidade")."%"; ?></td>
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
				IMPORTANTE Pre�os e condi��es <br> de pagamento <br> v�lidos somente para <br> contratos renovados <br> at� <?php echo getValue($objRSevento,"dt_limite_contrato"); ?>
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

	</td></tr></table>

	<table width="100%" border="0">
	  <tr>
		<td><b>No caso de atraso de uma ou mais parcelas o EXPOSITOR perder� o desconto comercial concedido, sendo o mesmo incorporado nas
		  parcelas restantes ou emitido boleto complementar.</b></td>
	  </tr>
	</table>
	
	
	<b>IV. SERVI�OS CONTRATADOS</b>
	
	<table width="82%" border="0">
	  <tr>
		<td width="13%"  align="left"><b>Tipo Espa�o:</b></td>
		<td width="21%"  align="left"><b>MONTAGEM PADR&Atilde;O </b></td>
		<td width="12%"  align="left"><b>Localiza��o:</b></td>
		<td width="54%"  colspan="3" align="left"><b><?php echo getValue($objRSpedido, "localpe");  if (getValue($objRSpedido, "pavilhaope") <> "") {echo " - " . getValue($objRSpedido, "pavilhaope");}; ?></b></td>
	  </tr>
	</table>
	
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td align="right">C�d.Prod.</td>
		<td align="left">Descri��o do Produto</td>
		<td align="center">Unid.</td>
		<td align="right">Quantid.</td>
		<td align="right">Pre�o Unit. Bruto</td>
		<td align="right">Valor Total Bruto</td>
	  </tr>
	<?php
		//BUSCA OS DADOS DADOS DE RENOVA��O DO EVENTO
		
		//  $strSQLprodutos = "select * from ped_pedidos_renovacao_evento a where a.idpedido = '".getValue($objRSpedido ,"idpedido")."' AND idmercado ilike '".$id_mercado."' order by idproduto";	
			
			$strSQLprodutos  = "SELECT * ";
			$strSQLprodutos .= "  FROM ped_pedidos_renovacao_evento";
			$strSQLprodutos .= " INNER JOIN ped_pedidos ";
			$strSQLprodutos .= "		ON ped_pedidos.idpedido = ped_pedidos_renovacao_evento.idpedido";
			$strSQLprodutos .= "		AND upper(ped_pedidos.idmercado) = upper(ped_pedidos_renovacao_evento.idmercado)";
			$strSQLprodutos .= " WHERE ped_pedidos.cod_pedidos =  '".getValue($objRSpedido ,"cod_pedidos")."'"; /* -- 12826 */
			$strSQLprodutos .= "   AND ped_pedidos_renovacao_evento.idevento LIKE '000306'"; /* provis�rio este relat�rio renova especificamente o evento 000306 FICANN */
			$strSQLprodutos .= " ORDER BY ped_pedidos_renovacao_evento.idproduto;";
		
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
		// ATEN��O: seria "AR0001" pra ser usado como pdoduto principal, mas neste caso dos eventos 000305 e 000306 eles trocaram
		// e usaram o prdotudo AR0002, por agilidade mudamso o algoritmo a baixo para de AR0001 para AR0002
		// 21/09/2013 (Aless e Brunte)
		// ------------------------------------------------------------------------------------------------------		
		
		//SE O PRODUTO FOR AREA LIMPA (AR0001) DEVE-SE PGAR O VALOR DETERMINADO NA  TABELA cad_renovacao_valores
		//NESTA TABELA TEM O VALOR DA OP��O 1 DO CONTRATO E DA OP��O 2 DO CONTRADO
		if ((getValue($objRSprodutos,"idproduto")) == 'AR0002' && ($var_opcao_contrato == '1')){
						echo number_format(getValue($objRSrenovacao,"area1"), 2, ',', '.');
		} else if ((getValue($objRSprodutos,"idproduto") == 'AR0002') && ($var_opcao_contrato == '2')){
				echo number_format(getValue($objRSrenovacao,"area2"), 2, ',', '.');
		} else { 
				echo number_format(getValue($objRSprodutos,"preco_pedi"), 2, ',', '.');
		};
		?>
		<?php // echo number_format(getValue($objRSprodutos,"preco_pedi"), 2, ',', '.'); ?></td>
		<td align="right">
		<?php
		//SE O PRODUTO FOR AREA LIMPA (AR0001) DEVE-SE PGAR O VALOR DETERMINADO NA  TABELA cad_renovacao_valores
		//NESTA TABELA TEM O VALOR DA OP��O 1 DO CONTRATO E DA OP��O 2 DO CONTRADO
		if ((getValue($objRSprodutos,"idproduto")) == 'AR0002' && ($var_opcao_contrato == '1')){
						$valor_area_total = (getValue($objRSprodutos,"quant_pedi") * getValue($objRSrenovacao,"area1"));
						echo number_format($valor_area_total, 2, ',', '.');
				} else if ((getValue($objRSprodutos,"idproduto") == 'AR0002') && ($var_opcao_contrato == '2')){
							
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
	//TAMANHO M�XIMO DE PRODUTOS QUE CABE EM UMA FOLHA � 9
	// SE O TATAL TE PRODUTOS FOR MAIOR QUE 9 QUEBRAMOS A P�GINA PARA AS CL�USULAS FICAREM NA PR�XIMA P�GINA.
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
			<td width="66%" style="border-bottom:none; border-left:none; border-right:none"><b>DISPOSI��ES FINAIS</b></td>
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
			<td width="66%" style="border-bottom:none; border-left:none; border-right:none"><b>DISPOSI��ES FINAIS</b></td>
			<td width="32%"  align="right"style="border-bottom:none; border-left:none; border-right:none">Valor Total Bruto:&nbsp;&nbsp;&nbsp;&nbsp;<?php echo number_format($valor_total_bruto, 2, ',', '.'); ?></td>
		  </tr>
		</table>
		<?php
	}
	?>
	<table width="100%" border="0" class="bordasimples1">
	  <tr>
		<td valign="top" align="justify"><b>1.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR compromete-se a pagar o valor de R$ <?php echo number_format($valor_total_bruto, 2, ',', '.'); ?> ( <?php echo valorPorExtenso($valor_total_bruto); ?> ), sobre o qual incidir� o desconto comercial de ___% referente ao valor do espa�o com montagem padr�o, em ___ parcela(s) mensal(ais), com primeiro vencimento em ___/___/___ . Para pagamento at� a data do vencimento, se aplicar� desconto de pontualidade de ____%  no boleto banc�rio.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>2.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR autoriza expressamente a FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA a emitir os boletos de cobran�a banc�ria, origin�rios do presente contrato, com vencimento
		nas datas acima, bem como a emiss�o das notas fiscais de Organiza��o, Planejamento, Promo��o e Administra��o da Feira <?php echo getValue($objRSevento, "nome_completo"); ?>.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>3.</b></td>
		<td align="justify"><div align="justify">O EXPOSITOR compromete-se a cumprir o Regulamento Geral da Feira <?php echo getValue($objRSevento, "nome_completo"); ?>,  e respeitar a montagem padr&atilde;o disponibilizada, conforme anexo que &eacute; parte integrante e 
		complementar deste contrato, do qual recebe uma c&oacute;pia e tem ci&ecirc;ncia. </div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>4.</b></td>
		<td align="justify"><div align="justify">Segundo o Item III do presente contrato, o Plano de Pagamento dever� estar plenamente quitado para participa��o e ingresso na feira.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>5.</b></td>
		<td align="justify"><div align="justify">Servi�os Adicionais necess�rios e/ou convenientes � participa��o do EXPOSITOR na Feira, tais como: energia el�trica adicional instalada em KVA, limpeza, seguran�a e ponto d'�gua ter�o seus pre�os definidos em circular espec�fica, pag�veis pelo EXPOSITOR at� a data de <?php echo(dDate("PTB",getValue($objRSevento,"dtlimite"),"")); ?>.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>6.</b></td>
		<td align="justify"><div align="justify">Fica acordado entre as partes que a qualquer momento poder� ser aditado o contrato para modificar a cl�usula de pre�o e condi��es, de forma a
		manter o equil�brio econ�mico e financeiro deste contrato.</div></td>
	  </tr>
	  <tr>
		<td valign="top"><b>7.</b></td>
		<td align="justify"><div align="justify">Os Contratantes elegem o Foro da Capital do Estado de Cear&aacute;, onde ser� realizada a Feira, para dirimirem quaisquer d�vidas provenientes da
		  execu��o e cumprimento deste contrato. <br>
		  Este contrato dever� ser assinado e enviado no prazo m�ximo de 3 dias ap�s a sua emiss�o e estar� sujeito a aprova��o do Departamento
		Financeiro da FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA. E, por estarem justas e contratadas, as partes assinam o presente contrato em duas vias de igual teor e forma. </div></td>
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
		<td align="center">FICANN FEIRAS COMERCIAIS DO NORTE E NORDESTE LTDA.</td>
	  </tr>
	</table>
		
     <div style="page-break-after:always">&nbsp;</div>       
	<?php
		
	   } //foreach dos contratos 
//}
 ?>
</body>
</html>
<?php 
$objConn = NULL; ?>
