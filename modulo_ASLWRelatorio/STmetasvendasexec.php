<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?php
	header("Cache-Control:no-cache, must-revalidate");
	header("Pragma:no-cache");

	// INCLUDES
	include_once("../_database/athdbconn.php");
	include_once("../_database/athtranslate.php");
	include_once("../_database/athkernelfunc.php");
	
	// PARÂMETROS PARA EXPORTAÇÃO
	$strSesPfx 	= strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
	$strAcao    = request("var_acao"); // Indicativo para qual formato que a grade deve ser exportada. Caso esteja vazio esse campo, a grade é exibida normalmente.
	// Define uma variável booleana afim de verificar se é um tipo de exportação ou não
	$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc") || ($strAcao == ".pdf");
	// EXPORT PARA EXCEL, PDF OU WORD
	if($boolIsExportation) {
		if($strAcao == ".pdf") {
			redirect("exportpdf.php"); //Redireciona para página que faz a exportação para adode reader
		}
		else{
			// Coloca o cabeçalho de download do arquivo no formato especificado de exportação
			header("Content-type: application/force-download"); 
			header("Content-Disposition: attachment; filename=Modulo_".getTText(getsession($strSesPfx."_titulo"),C_NONE)."_".time().$strAcao);
		}
		$strLimitOffSet = "";
	} else{
		include_once("../_scripts/scripts.js");
		include_once("../_scripts/STscripts.js");
	}
	
	// REQUESTS
	$strIDEVENTO = request("var_idevento");   // ID EVENTO
	$flagSALDO	 = request("var_flag_total")=="true"; // VEM "true" or "false" strings
	$flagTODOS   = request("var_com_mov")=="false";   // VEM "true" or "false" strings

	$dblTOTALMETA  = 0;
	$dblTOTALVENDA = 0;
	$arrREPR[]	   = "";	
	$matVENDAS[][] = null; 	
	$matMETAS[][]  = null;
	
	// Abre conexão com o banco de dados
	$objConn = abreDBConn(CFG_DB);
	
	// SESSÃO SQL
	// LOCALIZA TODOS OS REPRESENTANTES PARA O EVENTO ENCAMINHADO
	try{
		$strSQL  = "SELECT idrepre ";
		$strSQL .= "  FROM cad_representantes_evento ";
		$strSQL .= " WHERE idevento = '" . $strIDEVENTO . "' ";
		$strSQL .= "   AND idempresa = '" . getsession(CFG_SYSTEM_NAME."_id_mercado") ."' ";
		$strSQL .= " ORDER BY idrepre";

		$objResultRepre = $objConn->query($strSQL);
	}catch(PDOException $e) {
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
		die();
	}
	
	// Localiza Todos os Produtos Vendidos no EVENTO selecionado
	try{
		$strSQL = "
			SELECT cod_produtos_pedido
    			 , idproduto
			     , descrproduto
			     , disponivel AS meta 
			     , unidproduto
			 FROM ped_produtos_lista_preco 
			WHERE idevento  = '".$strIDEVENTO."'
			  AND idempresa = '".getsession(CFG_SYSTEM_NAME."_id_mercado")."'
			  AND prod_venda = true
			ORDER BY idproduto";
		//die($strSQL);
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
		return($prColor);
	}

	function myExplode(&$item1, $key="", $prefix="") { $item1 = explode(":",$item1); }
?>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<?php 
			if(!$boolIsExportation || $strAcao == "print") {
				echo("
				  	  <link href=\"_css/default.css\" rel=\"stylesheet\" type=\"text/css\">
					  <link rel=\"stylesheet\" href=\"../_css/" . CFG_SYSTEM_NAME . ".css\" type=\"text/css\">
					  <link href=\"../_css/tablesort.css\" rel=\"stylesheet\" type=\"text/css\">
					  <script type=\"text/javascript\" src=\"../_scripts/tablesort.js\"></script>
					");
			}
		?>
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
	<table align='center' cellpadding='0' cellspacing='1' style='width:100%;' class='tablesort'>
		<thead>
			<tr>
				<th width='1%' class='sortable' nowrap><?php echo(getTText("idprod",C_TOUPPER));?></th>
				<th width='1%' class='sortable' nowrap><?php echo(getTText("descricao_prod",C_TOUPPER));?></th>
				<th width='1%'><?php echo(getTText("valores",C_TOUPPER));?></th>
				<?php 
				  $i=0;
				  foreach($objResultRepre as $objRSRep){  
				?>
					<th width='1%' nowrap><?php echo(getTText(getValue($objRSRep,"idrepre"),C_TOUPPER));?></th>
				<?php 
				   $arrREPR[$i] = getValue($objRSRep,"idrepre");
				   $i++;
				  }
				?>
				<th width='1%'><?php echo(getTText("totais",C_TOUPPER));?></th>
			</tr>
		</thead>
		<tbody>
		<?php 
		  $flag  = true;
		  $strTR = ""; 
		  foreach($objResult as $objRS) { 
			$strTR  = "<tr bgcolor='" . getLineColor($strColor) . "'>";
			$strTR .= "<td align='center' style='vertical-align:top;'>" . getValue($objRS,"idproduto") . "</td>";
			$strTR .= "<td align='left'   style='vertical-align:top;' nowrap='nowrap'>" . getValue($objRS,"descrproduto") . " (" . getValue($objRS,"unidproduto") . ")</td>";
			$strTR .= "<td align='right'  style='vertical-align:top;'>";
			$strTR .= "<div style='border:none;text-align:right;background-color:transparent;font-size:11px;font-family:Trebuchet MS,Verdana,Arial,Tahoma;'>" . getTText("meta",C_TOUPPER) . ":</div>";
			$strTR .= "<div style='border:none;text-align:right;background-color:transparent;font-size:11px;font-family:Trebuchet MS,Verdana,Arial,Tahoma;'>" . getTText("venda",C_TOUPPER). ":</div>";
			$strTR .= ($flagSALDO) ? "<div style='border:none;text-align:right;background-color:transparent;font-size:11px;font-family:Trebuchet MS,Verdana,Arial,Tahoma;'>" . getTText("saldo",C_TOUPPER). ":</div>" : "";
			$strTR .= "</td>";

			//INI: Busca METAS dos representantes -----------------------------------------------
			try{
				$strSQL = "SELECT out_metas FROM spr_metas_produtos('" . getsession(CFG_SYSTEM_NAME."_id_mercado") . "','" . $strIDEVENTO . "','" . getValue($objRS,"idproduto") . "','" . getsession(CFG_SYSTEM_NAME.'idrepre') . "')";
				$objResultMetas = $objConn->query($strSQL);
				$objRSMetas		= $objResultMetas->fetch();
			}catch(PDOException $e) {
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
				die();
			}
			$strAUX   = getValue($objRSMetas,"out_metas");
			$matMETAS = explode("|",$strAUX); //"AM:12|AS:33|..."
			array_walk($matMETAS, "myExplode"); //Array ( [0] => Array ( [0] => AM [1] => 12 ) [1] => Array ....
			//print_r ($matMETAS); echo("<br><br>");
			//FIM: Busca METAS dos representantes -----------------------------------------------

			//INI: Busca VENDAS dos representantes -----------------------------------------------
			try{
				$strSQL = "SELECT out_vendas FROM spr_vendas_produtos('" . getsession(CFG_SYSTEM_NAME."_id_mercado") . "','" . $strIDEVENTO . "','" . getValue($objRS,"idproduto") . "','" . getsession(CFG_SYSTEM_NAME.'idrepre') . "')";
				$objResultVendas	= $objConn->query($strSQL);
				$objRSVendas		= $objResultVendas->fetch();
			}catch(PDOException $e) {
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
				die();
			}
			$strAUX = getValue($objRSVendas,"out_vendas");
			$matVENDAS = explode("|",$strAUX); //"AM:12|AS:33|..."
			array_walk($matVENDAS, "myExplode"); //Array ( [0] => Array ( [0] => AM [1] => 12 ) [1] => Array ....
			//print_r ($matVENDAS); die();
			//FIM: Busca VENDAS dos representantes -----------------------------------------------

			for($idxRepr=0; $idxRepr < count($arrREPR); $idxRepr++) {
			    $auxSALDO = 0;
				$strTR .= "<td style='text-align:right;vertical-align:top;'>";
				for($i=0; $i<count($matMETAS); $i++) {
				    $aux = array_search( $arrREPR[$idxRepr],$matMETAS[$i]);
					    if ($aux===0) { 
					    	if ($matMETAS[$i][1] > 0) { 
								$strTR .= FloatToMoeda($matMETAS[$i][1]); 
						    	$dblTOTALMETA  = $dblTOTALMETA  + $matMETAS[$i][1]; 
								break;
							}
						  }
					  }
				$strTR .= "<br>";
				for($j=0; $j<count($matVENDAS); $j++) {
				    $aux = array_search( $arrREPR[$idxRepr],$matVENDAS[$j]);
					    if ($aux===0) { 
					    	if ($matVENDAS[$j][1] > 0) { 
								$strTR .= FloatToMoeda($matVENDAS[$j][1]); 
						    	$dblTOTALVENDA = $dblTOTALVENDA + $matVENDAS[$j][1]; 
								break;
							}
						}
					  }
				if ($j<count($matVENDAS) && $i<count($matMETAS))  { $auxSALDO = $matVENDAS[$j][1] - $matMETAS[$i][1]; }
				$strTR .= ($auxSALDO !=0) && ($flagSALDO) ? "<br>" . FloatToMoeda($auxSALDO) : "";
				$strTR .= "</td>";
			}

			$auxSALDO = $dblTOTALVENDA - $dblTOTALMETA;
			$strTR .= "<td style='text-align:right;vertical-align:top;font-weight:bold;' nowrap='nowrap'>";
			$strTR .= ($dblTOTALMETA > 0) ? FloatToMoeda($dblTOTALMETA) : "";
			$strTR .= ($dblTOTALVENDA > 0) ? "<br>". FloatToMoeda($dblTOTALVENDA) : "";
			$strTR .= ( ($auxSALDO !=0) && ($dblTOTALVENDA > 0) && ($flagSALDO) ) ? "<br>" . FloatToMoeda($auxSALDO) : "";
			$strTR .= "</td>";
			$strTR .= "</tr>";

			if ($flagTODOS) { 
				echo($strTR); 
			}
			else { 
				if ( ($dblTOTALMETA != 0) || ($dblTOTALVENDA != 0)  ) { echo($strTR); } 
			}
						
		    $dblTOTALMETA  = 0; 
		    $dblTOTALVENDA = 0; 
			$strTR = "";
		 }
		?>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="<?php echo(4 + count($arrREPR));?>" height="20" bgcolor="#E9E9E9"></td>
			</tr>
		</tfoot>
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