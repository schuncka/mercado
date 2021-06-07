<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?php
	header("Cache-Control:no-cache, must-revalidate");
	header("Pragma:no-cache");
		
	// INCLUDES
	include_once("../_database/athdbconn.php");
	include_once("../_database/athtranslate.php");
	include_once("../_database/athkernelfunc.php");
	include_once("../_scripts/scripts.js");
	include_once("../_scripts/STscripts.js");
	
	// REQUESTS
	$strIDEVENTO  = request("var_idevento");   // ID EVENTO
	
	// Abre conexão com o banco de dados
	$objConn = abreDBConn(CFG_DB);
		
	// SESSÃO SQL
	// LOCALIZA O IDEMPRESA DO EVENTO SELECIONADO
	try{
		$strSQL    = "SELECT idempresa FROM cad_evento WHERE idevento = '".$strIDEVENTO."'";
		$objResult = $objConn->query($strSQL);
		$objRS	   = $objResult->fetch();
		$strIDEMPRESA = getValue($objRS,"idempresa");
	}catch(PDOException $e) {
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
		die();
	}
	
	// SQL LOCALIZA OS PRODUTOS VENDIDOS PARA O EVENTO SELECIONADO
	try{
		// SQL DE METAS CONVERTIDO DO GERTT - FINAL
		/*
		SELECT
			  cad_produtos_repre.idproduto
			, ped_produtos_lista_preco.descrproduto
			, SUM(cad_produtos_repre.qtde) AS total
		FROM
			  cad_produtos_repre
		INNER JOIN ped_produtos_lista_preco ON (
				   ped_produtos_lista_preco.idevento  = cad_produtos_repre.idevento AND
				   ped_produtos_lista_preco.idproduto = cad_produtos_repre.idproduto)
		WHERE
			  cad_produtos_repre.idevento = '000225' AND
			  ped_produtos_lista_preco.prod_venda
		GROUP BY cad_produtos_repre.idproduto, ped_produtos_lista_preco.descrproduto
		ORDER BY cad_produtos_repre.idproduto
		*/
		
		$strSQL = "
			SELECT
				  ped_pedidos_produtos.idproduto
				, ped_pedidos_produtos.descrpedido
				, SUM(ped_pedidos_produtos.quant_pedi) AS qtde
			FROM  ped_pedidos
			INNER JOIN ped_pedidos_produtos ON (
					   ped_pedidos_produtos.idmercado = ped_pedidos.idmercado AND
					   ped_pedidos_produtos.idpedido  = ped_pedidos.idpedido)
			INNER JOIN ped_produtos_lista_preco ON (
					   ped_produtos_lista_preco.idevento  = ped_pedidos.idevento AND
					   ped_produtos_lista_preco.idproduto = ped_pedidos_produtos.idproduto)
			WHERE
				  ped_pedidos_produtos.desc_pedi <> 1 		  	AND
				  ped_produtos_lista_preco.prod_venda 		  	AND
				  ped_pedidos.idevento  = '".$strIDEVENTO."'  	AND
				  ped_pedidos.idmercado = '".$strIDEMPRESA."' 	AND
				  ped_pedidos.confirmado 					  	AND
				  NOT ped_pedidos.excluida 						AND
				  ped_pedidos.modelpe = 'prin' 					AND
				  ped_pedidos.catalogo 							AND
				  ped_pedidos.idstatus = '003'
			GROUP BY
				  ped_pedidos_produtos.idproduto
				, ped_pedidos_produtos.descrpedido
			ORDER BY ped_pedidos_produtos.idproduto";
		die($strSQL);
		$objResult = $objConn->query($strSQL);
	}catch(PDOException $e) {
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
		die();
	}
	
	// Inicializa variavel para pintar linha
	$strColor = "#F5FAFA";
	
	// Função para cores de linhas
	function getLineColor(&$prColor){
		$prColor = ($prColor == CL_CORLINHA_1) ? "#F5FAFA" : CL_CORLINHA_1;
		echo($prColor);
	}
?>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="_css/default.css" rel="stylesheet" type="text/css">
		<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
		<link href="../_css/<?php echo(CFG_SYSTEM_NAME); ?>.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="../_scripts/tablesort.js"></script>
		<style>
			.menu_css { border:0px solid #dddddd; background:#FFFFFF; padding:0px 0px 0px 0px; margin-bottom:5px }
			body{ margin: 10px; background-color:#FFFFFF; } 
			ul{ margin-top: 0px; margin-bottom: 0px; }
			li{ margin-left: 0px; }
		</style>
	</head>
<body bgcolor="#FFFFFF">
	<?php
	// Testa se existe alguma resposta inserida
	// caso contrário, exibe mensagem de vazio
	if($objResult->rowCount() == 0) {
		mensagem("alert_consulta_vazia_titulo","alert_consulta_vazia_desc",getTText("nenhuma_resp_pub",C_NONE),"","aviso",1,"","");
	} else{
	?>
	<table align="center" cellpadding="0" cellspacing="1" style="width:100%;" class="tablesort">
		<thead>
			<tr>
				<th class="sortable" nowrap><?php echo(getTText("idprod",C_TOUPPER));?></th>
				<th class="sortable" nowrap><?php echo(getTText("descricao_prod",C_TOUPPER));?></th>
				<th nowrap><?php echo(getTText("valores",C_TOUPPER));?></th>
				<?php foreach($objResultRepre as $objRSRep){?>
					<th width="1%" class="sortable" nowrap><?php echo(getTText(getValue($objRSRep,"idrepre"),C_TOUPPER));?></th>
				<?php $auxCount++; }?>
				<th nowrap><?php echo(getTText("totais",C_TOUPPER));?></th>
			</tr>
		</thead>
		<tbody>
		<?php foreach($objResult as $objRS){?>
			<tr bgcolor="<?php echo(getLineColor($strColor));?>">
				<td align="center" style="vertical-align:top;"><?php echo(getValue($objRS,"idproduto"));?></td>
				<td align="left"   style="vertical-align:top;"><?php echo(getValue($objRS,"descrproduto"));?></td>
				<td align="right" style="vertical-align:top;">
					<div style="border:none;text-align:right;background-color:transparent;font-size:10px;font-family:'Trebuchet MS',Verdana,Arial,Tahoma;"><?php echo(getTText("meta",C_TOUPPER));?>:</div>
					<div style="border:none;text-align:right;background-color:transparent;font-size:10px;font-family:'Trebuchet MS',Verdana,Arial,Tahoma;"><?php echo(getTText("venda",C_TOUPPER));?>:</div>
				</td>
				<?php 
					try{
						// Seleciona todos os representantes já
						// CADASTRADOS PARA este PRODUTO - META
						$strSQL = "	
							SELECT DISTINCT
								  cad_produtos_repre.idrepre
								, cad_produtos_repre.cod_produtos_repre
								, cad_produtos_repre.qtde
							FROM
								  cad_produtos_repre
							INNER JOIN ped_produtos_lista_preco  ON (ped_produtos_lista_preco.idproduto = cad_produtos_repre.idproduto 
																AND  cad_produtos_repre.idevento = '".$strIDEVENTO."'
																AND  ped_produtos_lista_preco.cod_produtos_pedido = ".getValue($objRS,"cod_produtos_pedido")." 
																AND  ped_produtos_lista_preco.idmercado = '".getsession(CFG_SYSTEM_NAME."_id_mercado")."')
							ORDER BY cad_produtos_repre.idrepre ";
						//die($strSQL);
						$objResultMetas = $objConn->query($strSQL);
					}catch(PDOException $e) {
						mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
						die();
					}
				?>
				<?php 
				foreach($objResultMetas as $objRSMetas){
					if(getValue($objRSMetas,"qtde") != "0"){
					try{
						// Seleciona todos os representantes já
						// CADASTRADOS PARA este PRODUTO - META
						$strSQL = "	
							SELECT sum(ped_pedidos_produtos.quant_pedi) AS quantidade
							FROM ped_pedidos	
								 INNER JOIN ped_pedidos_produtos ON ped_pedidos.idpedido = ped_pedidos_produtos.idpedido 
																AND ped_pedidos.idmercado = ped_pedidos_produtos.idmercado
							WHERE ped_pedidos.idevento = '".$strIDEVENTO."'
         
								 AND ped_pedidos.idreprepe = '".getValue($objRSMetas,"idrepre")."'
								 AND ped_pedidos_produtos.idproduto = '".getValue($objRS,"idproduto")."'
								 AND ped_pedidos.confirmado
								 AND ped_pedidos.modelpe = 'prin'
								 AND ped_pedidos.idstatus = '003'";
						die($strSQL);
						$objResultVendas = $objConn->query($strSQL);
						$objRSVendas = $objResultVendas->fetch();
					}catch(PDOException $e) {
						mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
						die();
					}
					}
				?>
					  <td style="text-align:right;vertical-align:top;">
					  		<?php echo(number_format(getValue($objRSMetas,"qtde"),2,',','.'));?><br/>
							<?php echo((getValue($objRSMetas,"qtde") != "0") ? number_format(getValue($objRSVendas,"quantidade"),2,',','.') : "");?>
					  </td>
				<?php 
					  $dblTOTALMETA = $dblTOTALMETA + getValue($objRSMetas,"qtde"); 
					  $auxCount2++; 
					  }
				?>
				<?php for($auxTDs = $auxCount2; $auxTDs < $auxCount; $auxTDs++){?>
				<td></td>
				<?php }?>
				<td style="text-align:right;vertical-align:top;font-weight:bold;"><?php echo(($dblTOTALMETA != "0") ? number_format($dblTOTALMETA,2,',','.') : "");?></td>
			</tr>
		<?php $auxCount2 = 0; $dblTOTALMETA = 0; }?>
		</tbody>
	</table>
	<?php } ?>
</body>
<script type="text/javascript">
  // Quando esta página for chamda de dentro de um iframe denominado pelo nome [system_name]_detailiframe_[num]
  resizeIframeParent('<?php echo(CFG_SYSTEM_NAME); ?>_detailiframe_<?php echo(request("var_chavereg")); ?>',20);
  // ----------------------------------------------------------------------------------------------------------
</script>
</html>
<?php
	$objConn = NULL;
	$objResult->closeCursor();
?>