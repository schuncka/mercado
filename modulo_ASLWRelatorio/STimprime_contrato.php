<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

include_once("_include_aslRunRequest.php");
include_once("_include_aslRunBase.php");

/***            VERIFICAÇÃO DE ACESSO              ***/
/*****************************************************/
$strSesPfx = strtolower(str_replace("modulo_","",basename(getcwd()))); //Carrega o prefixo das sessions
$strPopulate = ( request("var_populate") == "" ) ? "yes" : request("var_populate");
if($strPopulate == "yes") { initModuloParams(basename(getcwd())); } //Popula o session para fazer a abertura dos ítens do módulo
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app"),"VIE"); //Verificação de acesso do usuário corrente

/***           DEFINIÇÃO DE PARÂMETROS            ***/
/****************************************************/

$strAcao   	      = request("var_acao");           // Indicativo para qual formato que a grade deve ser exportada. Caso esteja vazio esse campo, a grade é exibida normalmente.
$strSQLParam      = request("var_sql_param");      // Parâmetro com o SQL vindo do bookmark
$strPopulate      = request("var_populate");       // Flag de verificação se necessita popular o session ou não

$objConn = abreDBConn(CFG_DB); // Abertura de banco	

/***    AÇÃO DE PREPARAÇÃO DA GRADE - OPCIONAL    ***/
/****************************************************/
if($strPopulate == "yes") { initModuloParams(basename(getcwd())); } //Popula o session para fazer a abertura dos ítens do módulo

/***        AÇÃO DE EXPORTAÇÃO DA GRADE          ***/
/***************************************************/
//Define uma variável booleana afim de verificar se é um tipo de exportação ou não
$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc");

//Exportação para excel, word e adobe reader
if($boolIsExportation) {
	//Coloca o cabeçalho de download do arquivo no formato especificado de exportação
	header("Content-type: application/force-download"); 
	header("Content-Disposition: attachment; filename=Modulo_" . getTText(getsession($strSesPfx . "_titulo"),C_NONE) . "_". time() . $strAcao);
	
	$strLimitOffSet = "";
} 

//Roda o SQL montado via relatório ASLW
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

$strOpcao = "";
$intCodModeloDoc = "";
$strModelo1 = "";
$strModelo2 = "";

// -----------------------------------------------------------------------
// PASSO 1: varre o RecordSet para ler os dados que vieram na consulta
// -----------------------------------------------------------------------
foreach($objResult as $objRS){ 
	if ($strOpcao == "") {
		$strOpcao = getValue($objRS,"opcao");
	}
	
	if ($intCodModeloDoc == "") {
		$intCodModeloDoc = getValue($objRS,"cod_modelo_doc");
		
		// ------------------------------------------------------------------
		// PASSO 2: leitura do modelo passado junto dos dados da consulta
		// ------------------------------------------------------------------
		$strSQL = " SELECT conteudo FROM cad_modelo_documento WHERE cod_modelo_doc = ".$intCodModeloDoc;
		try{
			$objResultAux = $objConn->query($strSQL);
		}catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
		}
		$objRSAux = $objResultAux->fetch();
		$strModelo1 = getValue($objRSAux,"conteudo");
		$strModelo1 = html_entity_decode($strModelo1);
		$objResultAux->closeCursor();
		
		if ($strModelo1 == "") {
			mensagem("err_sql_titulo","err_sql_desc",getTText("modelo_vazio",C_NONE),"","erro",1);
			die();
		}
		
		// -------------------------------------------------------------------------
		// PASSO 3: leitura dos dados que NÃO MUDAM e substituicao das tags
		//          feito aqui dentro desse IF para só fazer uma vez
		// -------------------------------------------------------------------------
		
		// 3.1: Primeiras tags
		$strModelo1 = str_replace("TAG_NOME_SISTEMA",strtoupper(CFG_SYSTEM_NAME),$strModelo1);
		$strModelo1 = str_replace("TAG_DIR_CLIENTE" ,getsession(CFG_SYSTEM_NAME."_dir_cliente"),$strModelo1);
		
		$strModelo1 = str_replace("TAG_HOJE_DIA"		,date("d"),$strModelo1);
		$strModelo1 = str_replace("TAG_HOJE_MES_NUMERO"	,date("m"),$strModelo1);
		$strModelo1 = str_replace("TAG_HOJE_ANO"		,date("Y"),$strModelo1);
		
		$strModelo1 = str_replace("TAG_OPCAO_IMPRESSAO",$strOpcao,$strModelo1);
		if ($strOpcao == "1") 
			$strModelo1 = str_replace("TAG_OPCAO_PARCELAS","em at&eacute; 5 parcelas.",$strModelo1);
		else
			$strModelo1 = str_replace("TAG_OPCAO_PARCELAS","de 6 a 11 parcelas.",$strModelo1);
		
		// 3.2: Busca dados para as tags da empresa
		$strSQL = "	SELECT erazao AS razao_social
						 , efantasia AS nome_fantasia
						 , empreendimento
						 , ecnpj AS cnpj
						 , eie AS inscr_estadual
						 , im AS inscr_municipal
						 , etele AS fone
						 , efax AS fax
					FROM cad_empresa
					WHERE idmercado ILIKE '".getValue($objRS,"idmercado")."' ";
		try {
			$objResultAux = $objConn->query($strSQL);
		}catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
		}
		$objRSAux = $objResultAux->fetch();
		
		$strModelo1 = str_replace("TAG_EMPRESA_RAZAO_SOCIAL"	,strtoupper(getValue($objRSAux,"razao_social"))		,$strModelo1);
		$strModelo1 = str_replace("TAG_EMPRESA_NOME_FANTASIA"	,strtoupper(getValue($objRSAux,"nome_fantasia"))	,$strModelo1);
		$strModelo1 = str_replace("TAG_EMPRESA_EMPREENDIMENTO"	,strtoupper(getValue($objRSAux,"empreendimento"))	,$strModelo1);
		$strModelo1 = str_replace("TAG_EMPRESA_CNPJ"			,getValue($objRSAux,"cnpj")							,$strModelo1);
		$strModelo1 = str_replace("TAG_EMPRESA_INSCR_ESTADUAL"	,getValue($objRSAux,"inscr_estadual")				,$strModelo1);
		$strModelo1 = str_replace("TAG_EMPRESA_INSCR_MUNICIPAL"	,getValue($objRSAux,"inscr_municipal")				,$strModelo1);
		$strModelo1 = str_replace("TAG_EMPRESA_FONE"			,getValue($objRSAux,"fone")							,$strModelo1);
		$strModelo1 = str_replace("TAG_EMPRESA_FAX"				,getValue($objRSAux,"fax")							,$strModelo1);
		
		$objResultAux->closeCursor();
		
		// 3.3: Busca dados para as tags do evento
		$strSQL = "	SELECT TO_CHAR(cad_evento.dt_inicio, 'DD')                  AS dt_ini_dia
						 , TO_CHAR(cad_evento.dt_inicio, 'MM')                  AS dt_ini_mes
						 , TO_CHAR(cad_evento.dt_inicio, 'YYYY')                AS dt_ini_ano
						 , TO_CHAR(cad_evento.dt_inicio, 'DD/MM/YYYY')          AS dt_ini
						 , TO_CHAR(cad_evento.dt_fim, 'DD')                     AS dt_fim_dia
						 , TO_CHAR(cad_evento.dt_fim, 'MM')                     AS dt_fim_mes
						 , TO_CHAR(cad_evento.dt_fim, 'YYYY')                   AS dt_fim_ano
						 , TO_CHAR(cad_evento.dt_fim, 'DD/MM/YYYY')             AS dt_fim
						 , TO_CHAR(cad_evento.dtlimite, 'DD/MM/YYYY')           AS dt_limite_comercial
						 , TO_CHAR(cad_evento.dt_limite_contrato, 'DD/MM/YYYY') AS dt_limite_contrato
						 , cad_evento.nome
						 , cad_evento.nome_completo
						 , cad_evento.nome_oficial
						 , cad_evento.idevento
						 , cad_evento.pavilhao
						 , cad_evento.edicao
						 , cad_evento.site
						 , cad_evento.email
					FROM cad_evento
					WHERE cad_evento.idmercado ILIKE '".getValue($objRS,"idmercado")."'
					AND cad_evento.idevento = '".getValue($objRS,"idevento_renovar")."' ";
		try {
			$objResultAux = $objConn->query($strSQL);
		}catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
		}
		$objRSAux = $objResultAux->fetch();
		
		$strModelo1 = str_replace("TAG_EVENTO_DT_INI_EXTENSO",translateDate(getValue($objRSAux,"dt_ini")),$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_FIM_EXTENSO",translateDate(getValue($objRSAux,"dt_fim")),$strModelo1);
		
		$strModelo1 = str_replace("TAG_EVENTO_DT_INI_MES_EXTENSO",strtoupper(getMesExtensoFromMes(getValue($objRSAux,"dt_ini_mes"))),$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_FIM_MES_EXTENSO",strtoupper(getMesExtensoFromMes(getValue($objRSAux,"dt_fim_mes"))),$strModelo1);
		
		$strModelo1 = str_replace("TAG_EVENTO_IDEVENTO"				,getValue($objRSAux,"idevento")				,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_NOME_REDUZIDO"		,getValue($objRSAux,"nome")					,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_NOME_COMPLETO"		,getValue($objRSAux,"nome_completo")		,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_NOME_OFICIAL"			,getValue($objRSAux,"nome_oficial")			,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_INI_DIA"			,getValue($objRSAux,"dt_ini_dia")			,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_INI_MES"			,getValue($objRSAux,"dt_ini_mes")			,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_INI_ANO"			,getValue($objRSAux,"dt_ini_ano")			,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_INI"				,getValue($objRSAux,"dt_ini")				,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_FIM_DIA"			,getValue($objRSAux,"dt_fim_dia")			,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_FIM_MES"			,getValue($objRSAux,"dt_fim_mes")			,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_FIM_ANO"			,getValue($objRSAux,"dt_fim_ano")			,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_FIM"				,getValue($objRSAux,"dt_fim")				,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_PAVILHAO"				,getValue($objRSAux,"pavilhao")				,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_EDICAO"				,getValue($objRSAux,"edicao")				,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_LIMITE_COMERCIAL"	,getValue($objRSAux,"dt_limite_comercial")	,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_DT_LIMITE_CONTRATO"	,getValue($objRSAux,"dt_limite_contrato")	,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_WEBSITE"				,getValue($objRSAux,"site")					,$strModelo1);
		$strModelo1 = str_replace("TAG_EVENTO_EMAIL"				,getValue($objRSAux,"email")				,$strModelo1);
		
		$objResultAux->closeCursor();
		
		// 3.4: Busca dados para as tags da renovação
		$strSQL = "	SELECT area1, area2, energia, energia_cli
					FROM cad_renovacao_valores 
					WHERE idmercado ILIKE '".getValue($objRS,"idmercado")."'
					AND idevento = '".getValue($objRS,"idevento_renovar")."' ";
		try {
			$objResultAux = $objConn->query($strSQL);
		}catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
		}
		
		$objRSAux = $objResultAux->fetch();
		
		$dblVlrEnergiaEletr = getValue($objRSAux,"energia");
		$dblVlrEnergiaClim  = getValue($objRSAux,"energia_cli");
		$dblVlrArea1 = getValue($objRSAux,"area1");
		$dblVlrArea2 = getValue($objRSAux,"area2");
		if ($strOpcao == "1")
			$dblVlrArea = $dblVlrArea1;
		else
			$dblVlrArea = $dblVlrArea2;
		
		$strModelo1 = str_replace("TAG_RENOVACAO_VLR_AREA"         ,number_format((double) $dblVlrArea        ,2,',','.'),$strModelo1);
		$strModelo1 = str_replace("TAG_RENOVACAO_VLR_ENERGIA_ELETR",number_format((double) $dblVlrEnergiaEletr,2,',','.'),$strModelo1);
		$strModelo1 = str_replace("TAG_RENOVACAO_VLR_ENERGIA_CLIM" ,number_format((double) $dblVlrEnergiaClim ,2,',','.'),$strModelo1);
		
		$objResultAux->closeCursor();
		
		// 3.5: Busca dados para as tags do desconto da renovação
		$strSQL = "	SELECT DISTINCT cad_evento.dt_fim
						 , cad_evento.dt_inicio
						 , cad_renovacao_desconto.parcela
						 , cad_renovacao_desconto.desconto
						 , cad_renovacao_desconto.pagamentomes
						 , cad_renovacao_desconto.idevento
						 , cad_renovacao_desconto.idmercado
						 , cad_renovacao_desconto.desconto_pontualidade
						 , TO_CHAR(cad_renovacao_desconto.datavencimento, 'DD/MM/YYYY') AS datavencimento
					FROM cad_renovacao_desconto
					INNER JOIN cad_evento ON (cad_renovacao_desconto.idevento = cad_evento.idevento AND cad_renovacao_desconto.idmercado ILIKE cad_evento.idmercado) 
					WHERE cad_renovacao_desconto.idmercado ILIKE '".getValue($objRS,"idmercado")."'
					AND cad_renovacao_desconto.idevento = '".getValue($objRS,"idevento_renovar")."' ";
		if ($strOpcao == "1") 
			$strSQL .= " AND cad_renovacao_desconto.parcela <= 5 ";
		else
			$strSQL .= " AND cad_renovacao_desconto.parcela > 5 ";
		$strSQL .= "ORDER BY cad_renovacao_desconto.parcela
						   , cad_renovacao_desconto.desconto DESC ";
		try {
			$objResultAux = $objConn->query($strSQL);
		}catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
		}
		
		$strPlanoPgto = "";
		foreach($objResultAux as $objRSAux){ 
			$strPlanoPgto .= "<tr>";
			$strPlanoPgto .= "  <td height='5' width='2%'></td>";
			$strPlanoPgto .= "  <td height='5' width='11%' align='center'>".sprintf("%02s",getValue($objRSAux,"parcela"))."</td>";
			$strPlanoPgto .= "  <td height='5' width='17%' align='center'>".getValue($objRSAux,"datavencimento")."</td>";
			$strPlanoPgto .= "  <td height='5' width='20%' align='center'>".number_format((double) getValue($objRSAux,"desconto") * 100,2,',','.')."%</td>";
			$strPlanoPgto .= "  <td height='5' width='14%' align='center'>";
			if ($strOpcao == "1")
				$strPlanoPgto .= "R$".number_format((double) $dblVlrArea1,2,',','.');
			else
				$strPlanoPgto .= "R$".number_format((double) $dblVlrArea2,2,',','.');
			$strPlanoPgto .= "</td>";
			$strPlanoPgto .= "  <td height='5' width='36%' align='center'>".getValue($objRSAux,"desconto_pontualidade")."%</td>";
			$strPlanoPgto .= "</tr>";
		}
		$objResultAux->closeCursor();
		
		$strModelo1 = str_replace("TAG_GRADE_PLANO_PGTO", $strPlanoPgto, $strModelo1);
		
		// 3.6: Busca dados para as tags dos itens do pedido
		$strSQL = "	SELECT idproduto, descrpedido, unidpedido, quant_pedi, preco_pedi, sub_total
					FROM ped_pedidos_renovacao_evento
					INNER JOIN ped_pedidos ON (ped_pedidos.idpedido = ped_pedidos_renovacao_evento.idpedido AND ped_pedidos.idmercado ILIKE ped_pedidos_renovacao_evento.idmercado)
					WHERE ped_pedidos.cod_pedidos = ".getValue($objRS,"cod_pedidos")."
					ORDER BY ped_pedidos_renovacao_evento.idproduto ";
		try {
			$objResultAux = $objConn->query($strSQL);
		}catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
		}
		
		$strItens = "";
		$dblVlrTotalGeral = 0;
		$intCont = 0;
		foreach($objResultAux as $objRSAux){ 
			$dblVlrUnit = 0;
			$dblVlrTotal = 0;
			
			//SE O PRODUTO FOR AREA LIMPA (AR0001) DEVE-SE PGAR O VALOR DETERMINADO NA  TABELA cad_renovacao_valores
			//NESTA TABELA TEM O VALOR DA OPÇÃO 1 DO CONTRATO E DA OPÇÃO 2 DO CONTRADO
			if (getValue($objRSAux,"idproduto") == "AR0001") {
				if ($strOpcao == "1")
					$dblVlrUnit = $dblVlrArea1;
				else
					$dblVlrUnit = $dblVlrArea2;
			} 
			else {
				$dblVlrUnit = getValue($objRSAux,"preco_pedi");
			}
			
			//SE O PRODUTO FOR AREA LIMPA (AR0001) DEVE-SE PGAR O VALOR DETERMINADO NA  TABELA cad_renovacao_valores
			//NESTA TABELA TEM O VALOR DA OPÇÃO 1 DO CONTRATO E DA OPÇÃO 2 DO CONTRADO
			if (getValue($objRSAux,"idproduto") == "AR0001") {
				if ($strOpcao == "1")
					$dblVlrTotal = getValue($objRSAux,"quant_pedi") * $dblVlrArea1;
				else
					$dblVlrTotal = getValue($objRSAux,"quant_pedi") * $dblVlrArea2;
			}
			else {
				$dblVlrTotal = getValue($objRSAux,"sub_total");
			}
			
			$strItens .= "<tr>";
			$strItens .= "  <td align='right'>".getValue($objRSAux,"idproduto")."</td>";
			$strItens .= "  <td align='left'>".getValue($objRSAux,"descrpedido")."</td>";
			$strItens .= "  <td align='center'>".getValue($objRSAux,"unidpedido")."</td>";
			$strItens .= "  <td align='right'>".number_format((double) getValue($objRSAux,"quant_pedi"),2,',','.')."</td>";
			$strItens .= "  <td align='right'>".number_format((double) $dblVlrUnit,2,',','.')."</td>";
			$strItens .= "  <td align='right'>".number_format((double) $dblVlrTotal,2,',','.')."</td>";
			$strItens .= "</tr>";
			
			$dblVlrTotalGeral += $dblVlrTotal;
			$intCont++;
		}
		$objResultAux->closeCursor();
		
		$strModelo1 = str_replace("TAG_GRADE_ITENS", $strItens, $strModelo1);
		
		//TAMANHO MÁXIMO DE PRODUTOS QUE CABE EM UMA FOLHA É 9
		// SE O TATAL TE PRODUTOS FOR MAIOR QUE 9 QUEBRAMOS A PÁGINA PARA AS CLÁUSULAS FICAREM NA PRÓXIMA PÁGINA.
		$strRodape = "";
		if ($intCont > 5){
			$strRodape .= "<table width='100%' border='0' class='bordasimples'>";
			$strRodape .= "<tr>";
			$strRodape .= "  <td width='2%' style='border-bottom:none; border-left:none; border-right:none'></td>";
			$strRodape .= "  <td width='66%' style='border-bottom:none; border-left:none; border-right:none'></td>";
			$strRodape .= "  <td width='32%' align='right' style='border-bottom:none; border-left:none; border-right:none'>Valor Total Bruto:&nbsp;&nbsp;&nbsp;&nbsp;TAG_VLR_TOTAL</td>";
			$strRodape .= "</tr>";
			$strRodape .= "</table>";
			$strRodape .= "<div style='page-break-after:always'>&nbsp;</div>";
			$strRodape .= "<table width='100%' border='0' class='bordasimples'>";
			$strRodape .= "<tr>";
			$strRodape .= "  <td width='2%' style='border-bottom:none; border-left:none; border-right:none'><b>V.</b></td>";
			$strRodape .= "  <td width='66%' style='border-bottom:none; border-left:none; border-right:none'><b>DISPOSI&Ccedil;&Otilde;ES FINAIS</b></td>";
			$strRodape .= "  <td width='32%' align='right' style='border-bottom:none; border-left:none; border-right:none'></td>";
			$strRodape .= "</tr>";
			$strRodape .= "</table>";
		}
		else {
			$strRodape .= "<table width='100%' border='0' class='bordasimples'>";
			$strRodape .= "<tr>";
			$strRodape .= "  <td width='2%' style='border-bottom:none; border-left:none; border-right:none'><b>V.</b></td>";
			$strRodape .= "  <td width='66%' style='border-bottom:none; border-left:none; border-right:none'><b>DISPOSI&Ccedil;&Otilde;ES FINAIS</b></td>";
			$strRodape .= "  <td width='32%' align='right' style='border-bottom:none; border-left:none; border-right:none'>Valor Total Bruto:&nbsp;&nbsp;&nbsp;&nbsp;TAG_VLR_TOTAL</td>";
			$strRodape .= "</tr>";
			$strRodape .= "</table>";
		}
		
		$strModelo1 = str_replace("TAG_GRADE_RODAPE", $strRodape, $strModelo1);
		
		$strModelo1 = str_replace("TAG_VLR_TOTAL"  ,number_format((double) $dblVlrTotalGeral,2,',','.'),$strModelo1);
		$strModelo1 = str_replace("TAG_VLR_EXTENSO",valorPorExtenso($dblVlrTotalGeral),$strModelo1);
	}
	
	//Pega o modelo que está em "$strModelo1" porque já vai ter algumas tags 
	//substituidas e as tags de cliente e pedido ainda por ser substituidas
	$strModelo2 = $strModelo1;
	
	// -------------------------------------------------------------------------
	// PASSO 4: leitura dos dados que MUDAM e respectiva substituicao nas tags
	// -------------------------------------------------------------------------
	
	// 4.1: Busca dados para as tags do cliente
	$strSQL = "	SELECT cad_cadastro.idmercado
					 , cad_cadastro.codigo
					 , cad_cadastro.razao
					 , cad_cadastro.fantasia
					 , SUBSTRING(cad_cadastro.cgcmf,1,2) || '.' || SUBSTRING(cad_cadastro.cgcmf,3,3) || '.' || SUBSTRING(cad_cadastro.cgcmf,6,3) || '/' || SUBSTRING(cad_cadastro.cgcmf,9,4) || '-' || SUBSTRING(cad_cadastro.cgcmf,13,2) AS cnpj
					 , cad_cadastro.inscrest AS inscr_estadual, cad_cadastro.inscrmunicip AS inscr_municipal
					 , cad_cadastro.endereco, cad_cadastro.bairro, cad_cadastro.cidade, cad_cadastro.cep, cad_cadastro.estado, cad_cadastro.pais
					 , cad_cadastro.telefone1, cad_cadastro.telefone2, cad_cadastro.telefone3, cad_cadastro.telefone4
					 , cad_cadastro.email, cad_cadastro.website, cad_cadastro.idrepre
					 , cad_produto1_categoria.descrprod1 AS prod_principal
				FROM cad_cadastro 
				INNER JOIN ped_pedidos ON (cad_cadastro.codigo = ped_pedidos.codigope AND cad_cadastro.idmercado ILIKE ped_pedidos.idmercado)
				LEFT JOIN cad_produto1_categoria ON (cad_produto1_categoria.idmercado = cad_cadastro.idmercado AND cad_produto1_categoria.idprod1 ILIKE cad_cadastro.mainprod)
				WHERE ped_pedidos.idmercado ILIKE '".getValue($objRS,"idmercado")."'
				AND ped_pedidos.idpedido = '".getValue($objRS,"idpedido")."' ";
	try {
		$objResultAux = $objConn->query($strSQL);
	}catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
	}
	$objRSAux = $objResultAux->fetch();
	
	$strModelo2 = str_replace("TAG_CLIENTE_USUARIO",getValue($objRSAux,"idmercado").getValue($objRSAux,"codigo"),$strModelo2);
	
	$strModelo2 = str_replace("TAG_CLIENTE_RAZAO_SOCIAL"	,getValue($objRSAux,"razao")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_NOME_FANTASIA"	,getValue($objRSAux,"fantasia")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_CNPJ"			,getValue($objRSAux,"cnpj")				,$strModelo2); //Com máscara 47.568.195/0001-34
	$strModelo2 = str_replace("TAG_CLIENTE_INSCR_ESTADUAL"	,getValue($objRSAux,"inscr_estadual")	,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_INSCR_MUNICIPAL"	,getValue($objRSAux,"inscr_municipal")	,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_ENDERECO"		,getValue($objRSAux,"endereco")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_BAIRRO"			,getValue($objRSAux,"bairro")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_CIDADE"			,getValue($objRSAux,"cidade")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_CEP"				,getValue($objRSAux,"cep")				,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_ESTADO"			,getValue($objRSAux,"estado")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_PAIS"			,getValue($objRSAux,"pais")				,$strModelo2);
	//$strModelo2 = str_replace("TAG_CLIENTE_CONTATO"		,getValue($objRSAux,"contato")			,$strModelo2);
	//$strModelo2 = str_replace("TAG_CLIENTE_CARGO"			,getValue($objRSAux,"cargo")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_FONE1"			,getValue($objRSAux,"fone1")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_FONE2"			,getValue($objRSAux,"fone2")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_FONE3"			,getValue($objRSAux,"fone3")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_FONE4"			,getValue($objRSAux,"fone4")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_EMAIL"			,getValue($objRSAux,"email")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_WEBSITE"			,getValue($objRSAux,"website")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_IDREPRE"			,getValue($objRSAux,"idrepre")			,$strModelo2);
	$strModelo2 = str_replace("TAG_CLIENTE_PROD_PRINCIPAL"	,getValue($objRSAux,"prod_principal")	,$strModelo2);
	
	$objResultAux->closeCursor();
	
	// 4.2: Busca dados para as tags do pedido
	$strSQL = "	SELECT ped_pedidos.idpedido
					 , TO_CHAR(ped_pedidos.dataco,'DD/MM/YYYY') AS dt_contrato
					 , CASE WHEN cad_pavilhao.descrpavilhao IS NULL THEN ped_pedidos.localpe ELSE ped_pedidos.localpe || ' - ' || cad_pavilhao.descrpavilhao END AS localizacao
					 , TO_CHAR(ped_pedidos.firstvenc,'DD/MM/YYYY') AS dt_prim_vcto
					 , ped_pedidos.prazopagto
					 , ped_pedidos.nomemapa
				FROM ped_pedidos
				LEFT JOIN cad_pavilhao ON (ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao) 
				WHERE ped_pedidos.idmercado ILIKE '".getValue($objRS,"idmercado")."'
				AND ped_pedidos.idpedido = '".getValue($objRS,"idpedido")."' ";
	try {
		$objResultAux = $objConn->query($strSQL);
	}catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
	}
	$objRSAux = $objResultAux->fetch();
	
	$strModelo2 = str_replace("TAG_PEDIDO_NUMERO"		,getValue($objRSAux,"idpedido")		,$strModelo2);
	$strModelo2 = str_replace("TAG_PEDIDO_DT_CONTRATO"	,getValue($objRSAux,"dt_contrato")	,$strModelo2);
	$strModelo2 = str_replace("TAG_PEDIDO_DT_PRIM_VCTO"	,getValue($objRSAux,"dt_prim_vcto")	,$strModelo2);
	$strModelo2 = str_replace("TAG_PEDIDO_PRAZO_PGTO"	,getValue($objRSAux,"prazopagto")	,$strModelo2);
	$strModelo2 = str_replace("TAG_PEDIDO_LOCALIZACAO"	,getValue($objRSAux,"localizacao")	,$strModelo2);
	$strModelo2 = str_replace("TAG_PEDIDO_NOMEMAPA"		,getValue($objRSAux,"nomemapa")		,$strModelo2);
	
	$objResultAux->closeCursor();
	
	// -------------------------------------------------------------------
	// PASSO 5: exibicao do documento final montado no passo anterior
	// -------------------------------------------------------------------
	echo $strModelo2;
}

$objConn = NULL; 
?>