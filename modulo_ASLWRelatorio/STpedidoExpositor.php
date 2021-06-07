<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

$var_cod_pedido	= request("var_cod_pedido");
$id_empresa 	= getsession(CFG_SYSTEM_NAME."_id_mercado");
$id_evento 		= getsession(CFG_SYSTEM_NAME."_id_evento"); 


$strAcao       = request("var_acao");       // Ação para exportação (excel, word...)
$strAcaoGrid   = request("var_acaogrid");   // Ação de retorno da grade (single, multiple)
$strSQLRelOrig = request("var_strparam");   // A consulta deve chegar com as TAGs do tipo (<ASLW_APOSTROFE>, etc...) 
$strDescricao  = request("var_descricao");  // A descrição do relatório (inativo)
$strNome       = request("var_nome");       // O nome do campo para retorno para o formulário
//$strCampoRet   = requests("var_camporet");   // O nome do campo no formulário para qual o relatório deve retornar o valor
$strDBCampoRet = request("var_dbcamporet"); // O nome do campo na cosulta que deve ser retornado
$strDBCampoLbl = request("var_dbcampolbl"); // O label do campo na cosulta que deve ser retornado
$strDialogGrp  = request("var_dialog_grp"); // O índice do formulário que deve ser retornado
$strRelatTitle = request("var_relat_title");// O nome do relatório, caso ele for um ASLW
$strHTMLBody   = ""; // Variável que receberá o HTML da página para ser exibido posteriormente. (Para não usar muitos echos)

$strDBCampoRet = preg_replace("/[[:alnum:]_]+\./i","",$strDBCampoRet); //Para tirar o nome da tabela do campo que será retornado

function filtraAlias($prValue){
	return(strtolower(preg_replace("/([[:alnum:]_\"\(\)\.\+\-\*\/\^' ]+ AS )|([[:alnum:]_\"]+\.)|/i","",$prValue)));
}

/********* Verificação de acesso e localização do módulo *********/
$strSesPfx = strtolower(str_replace("modulo_","",basename(getcwd())));
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), 19);

/********* Preparação SQL - Início *********/
$strSQLRel = removeTagSQL($strSQLRelOrig); //Remove as tags
$strSQLRel = replaceParametersSession($strSQLRel); //Coloca os valores de sistema (session)
//preg_match_all("/\[(?<operador>[[:punct:]]?) +(?<campo>[[:alnum:]_\"\(\)\.\+\-\*\/\^' ]+( AS [[:alnum:]_\"]+)*)\]/i",$strSQLRel,$arrParams); //Verifica se há funções ASLW e as coloca num array
preg_match_all("/\[([[:punct:]]?[0-9]*) +([[:alnum:]_\"\(\)\.\+\-\*\/\^' ]+( AS [[:alnum:]_\"]+)*)\]/i",$strSQLRel,$arrParams); //Verifica se há funções ASLW e as coloca num array
$strSQLRel = preg_replace("/\[[[:punct:]]([0-9])*|\]|\"/","",$strSQLRel); //retira as funções do SQL deixando somente o nome do campo com suas dependencias
/********* Preparação SQL - Fim *********/

$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc") || ($strAcao == ".pdf");
if($strAcao == '.pdf'){
	//seto a session do sql para executar na exportacao do pdf
	setsession($strSesPfx . "_sqlorig", $strSQLRel); 
	redirect("exportpdf_relatorio.php");
	die;
} else {
	VerificaModoExportacao($strAcao, getTText(getsession($strSesPfx . "_titulo"),C_NONE));
}
include_once("../_scripts/scripts.js");
	include_once("../_scripts/STscripts.js");

$objConn = abreDBConn(CFG_DB);





// SQL PADRÃO DA LISTAGEM - BREVE DESCRIÇÃO
	try{
		

		// seleciona todos os contatos do fornecedor
		// com cod_cadastro enviado para este script
	 $strSQL = "select 
					cad_cadastro.ret_10833 as ret_css,
                    cad_cadastro.ret_iss,            
                    
                    cad_evento.nome_completo,          
					cad_evento.pavilhao,               
					cad_evento.dt_inicio,               
					cad_evento.dt_fim,    
					
					ped_pedidos.sys_dtt_ins,
					ped_pedidos.idpedido,  
					ped_pedidos.codigope,  
					ped_pedidos.razaope,
					ped_pedidos.fantasiape,
					ped_pedidos.enderecope,
					ped_pedidos.bairrope,
					ped_pedidos.cidadepe,
					ped_pedidos.estadope,
					ped_pedidos.ceppe,
					ped_pedidos.paispe,
					
					ped_pedidos.telefone1pe,    
					ped_pedidos.telefone2pe,    
					ped_pedidos.telefone3pe,    
					ped_pedidos.telefone4pe,
					
					ped_pedidos.cgcmfpe,
					ped_pedidos.inscrestpe,
					
					ped_pedidos.largurape,
					ped_pedidos.comprimentope,
					ped_pedidos.areape,
					ped_pedidos.tipope,
					--ped_pedidos.localpe,
					 ped_pedidos.localpe || CASE WHEN ped_pedidos.pavilhaope IS NULL THEN '' ELSE ' - ' || cad_pavilhao.descrpavilhao END as localiza,
					ped_pedidos.nomemapa,
					ped_pedidos.idreprepe,
					cad_montador.nomemont,
					cad_status.descrstatus					
				 from ped_pedidos LEFT JOIN cad_evento on (ped_pedidos.idevento = cad_evento.idevento) 
						LEFT JOIN cad_montador on (ped_pedidos.idmontpe = cad_montador.idmont )
						LEFT JOIN cad_status on (ped_pedidos.idstatus = cad_status.idstatus ) 
                        LEFT JOIN cad_cadastro on (ped_pedidos.codigope = cad_cadastro.codigo and ped_pedidos.idmercado ilike cad_cadastro.idmercado)
						LEFT JOIN cad_pavilhao ON (ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao)
				 where ped_pedidos.cod_pedidos = ".$var_cod_pedido.";";
		$objResult = $objConn->query($strSQL);
	}catch(PDOException $e) {
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
		die();
	}
	$objRS	 = $objResult->fetch();
	

	$calc_css  = getvalue($objRS,"ret_css");
	$calc_iss = getvalue($objRS,"ret_iss");
	
?>


<html>
<head>
<title>
<?php echo(CFG_SYSTEM_TITLE); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<?php 

		if(!$boolIsExportation || $strAcao == "print"){
			//echo(" <link rel=\"stylesheet\" href=\"../_css/" . CFG_SYSTEM_NAME . ".css\" type=\"text/css\">");
		}
	?>

<script language="JavaScript" type="text/javascript">
		function switchColor(prObj, prColor){
			prObj.style.backgroundColor = prColor;
		}
	</script>
<style type="text/css">



body       { font-family:Tahoma; font-size:10px; color:#111111; background-repeat:repeat-x; background-attachment:fixed;  }
form       { margin:0px; padding:0px; }
/* select     { font-family:Tahoma; margin:1px; font-size:10px; border:1px #999999 solid; height:17px; background-image:url(../img/input_bg.gif); color:#333333; width:180px; }
   input      { font-family:Tahoma; margin:1px; font-size:10px; color:#111111; border:1px #999999 solid; padding-left:4px; background-image:url(../img/input_bg.gif); height:13px; } */
select     { font-family:Tahoma; margin:1px; font-size:10px; border:1px #999999 solid; height:17px; color:#333333; width:180px; }
input      { font-family:Tahoma; margin:1px; font-size:10px; color:#111111; border:1px #999999 solid; padding-left:4px; height:16px; } 
textarea   { font-family:Tahoma; margin:1px 1px 3px 1px; font-size:10px; color:#111111; border:1px #999999 solid; padding-left:4px; }
button     { font-family:Arial; font-size:11px; color:#000000; background-image:url(../img/But_XPTeal_clean.gif); background-color:transparent; width:86px; height:22px; border:0px; margin:0px 6px 0px 6px; }
div	       { font-family:Tahoma; font-size:10px; color:#111111; }
td	       { font-family:Tahoma; font-size:10px; color:#111111; }
td a	   { text-decoration:none; color:#111111; }
td a:hover { text-decoration:none; color:#999999; }

</style>
</head>
<body style="padding:15px 15px 15px 15px;"  >

<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td align="center"><h4>PEDIDO <?php echo (getvalue($objRS,"nome_completo"))?> - <?php echo (getvalue($objRS,"pavilhao"))?> - <?php echo dDate("PTB",getvalue($objRS,"dt_inicio"),"0");?> a <?php echo dDate("PTB",getvalue($objRS,"dt_fim"),"0");?></h4></td>
	</tr>	
	<tr>
		<td>
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<td width="65%"></td>
					<td align="right"><h5>Nº PEDIDO.....:</h5></td>
					<td align="right"><h5><?php echo $idpedido = getvalue($objRS,"idpedido")?></h5></td>
				</tr>
				<tr>
					<td width="65%">Impresso em <?php echo date("d/m/Y H:i:s"); ?></td>
					<td align="right"><h5>Data da O.S....:</h5></td>
					<td align="right"><h5><?php echo dDate("PTB",getvalue($objRS,"sys_dtt_ins"),"0");?></h5></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<!--td height="20"></td //-->
	</tr>
	<tr>
		<td align="center">
			<table cellpadding="0" cellspacing="0" border="0" height="100%" width="100%" bgcolor="#FFFFFF" style="background-color:#FFFFFF; border:1px solid #CCCCCC;">
				<tr>
				  <td align="center" valign="top" style="padding:10px 10px 10px 10px;"><table cellspacing="2" cellpadding="3" border="0" width="100%">
                    <tr>
                      <td width="13%" align="right"><strong><?php echo(getTText("cod_cadastro",C_NONE));?> :</strong></td>
                      <td width="40%" align="left"><?php echo(getvalue($objRS,"codigope"));?></td>
                      <td width="13%" align="right"><strong><?php echo(getTText("telefone1",C_NONE));?> :</strong></td>
                      <td width="22%" align="left" colspan="5"><?php echo(getvalue($objRS,"telefone1pe"));?></td>
                    </tr>
                    <tr>
                      <td align="right"><strong><?php echo(getTText("razao",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"razaope"));?></td>
                      <td align="right"><strong><?php echo(getTText("telefone1n",C_NONE));?> :</strong></td>
                      <td align="left"><?php  echo(getvalue($objRS,"telefone2pe"));?></td>
                    </tr>
                    <tr>
                      <td align="right"><strong><?php echo(getTText("fantasia",C_NONE));?> :</strong></td>
                      <td align="left"><?php  echo(getvalue($objRS,"fantasiape"));?></td>
                      <td align="right"><strong><?php echo(getTText("telefone3",C_NONE));?> :</strong></td>
                      <td align="left"><?php  echo(getvalue($objRS,"telefone3pe"));?></td>
                    </tr>
                    <tr>
                      <td align="right"><strong><?php echo(getTText("endereco",C_NONE));?> :</strong></td>
                      <td align="left"><?php  echo(getvalue($objRS,"enderecope"));?></td>
                      <td align="right"><strong><?php echo(getTText("telefone4",C_NONE));?> :</strong></td>
                      <td align="left"><?php  echo(getvalue($objRS,"telefone4pe"));?></td>
                    </tr>
                    <tr>
                      <td align="right"><strong><?php echo(getTText("bairro",C_NONE));?> :</strong></td>
                      <td align="left"><?php  echo(getvalue($objRS,"bairrope"));?></td>
                      <td align="right"><strong><?php echo(getTText("cnpj",C_NONE));?> :</strong></td>
                      <td align="left"><?php  echo(getvalue($objRS,"cgcmfpe"));?></td>
                    </tr>
                    <tr>
                      <td align="right"><strong><?php echo(getTText("cidade",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"cidadepe"));?></td>
                      <td align="right"><strong><?php echo(getTText("inscr_estadual",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"inscrestpe"));?></td>
                    </tr>
                    <tr>
                      <td align="right"><strong><?php echo(getTText("estado",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"estadope"));?></td>
					  <td align="right"><strong><?php echo(getTText("largura",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"largurape"));?></td>
					  
                    </tr>
                    <tr>
                      <td align="right"><strong><?php echo(getTText("cep",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"ceppe"));?></td>
					  <td align="right"><strong><?php echo(getTText("comprimento",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"comprimentope"));?></td>
                    </tr>
                    <tr>
                      <td align="right"><strong><?php echo(getTText("pais",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"paispe"));?></td>
					  <td align="right"><strong><?php echo(getTText("area",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"areape"));?></td>
					 
                    </tr>
					<tr>
                      <td align="right"><strong><?php echo(getTText("representante",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"idreprepe"));?></td>
					  <td align="right"><strong><?php echo(getTText("tipope",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"idreprepe"));?></td>
					
					  
                    </tr>
					<tr>
                      <td align="right"><strong><?php echo(getTText("montador",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"nomemont"));?></td>
					  <td align="right"><strong><?php echo(getTText("localizacao",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"localiza"));?></td>
                    </tr>
					<tr>
                      <td align="right"><strong><?php echo(getTText("status",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"descrstatus"));?></td>
					  <td align="right"><strong><?php echo(getTText("nome_mapa",C_NONE));?> :</strong></td>
                      <td align="left"><?php echo(getvalue($objRS,"nomemapa"));?></td>
                    </tr>
                  </table>
                </td>
				  
				  
				</tr>
		  </table>
		</td>
	</tr>
	<tr>
		<!--td height="10"></td //-->
	</tr>
	<tr>
		<td align="center">
			<table cellpadding="0" cellspacing="0" border="0" height="100%" width="100%" bgcolor="#FFFFFF" style="background-color:#FFFFFF; border:1px solid #CCCCCC;">
				<tr>
					<td align="left"><strong><?php echo(getTText("faturar_para",C_NONE));?> :</strong> </td>
					<td align="left"></td>
				</tr>
		  </table>
		</td>
	</tr>
	<tr>
		<!--td height="10"></td //-->
	</tr>	
	<tr>
		<td align="center">
			<table cellpadding="0" cellspacing="0" border="0" height="100%" width="100%" bgcolor="#FFFFFF" style="background-color:#FFFFFF; border:1px solid #CCCCCC;">
				<tr>
					<td align="center" valign="top" style="padding:10px 10px 10px 10px;">
						<table cellspacing="2" cellpadding="3" border="0" width="100%">
							
							
							<tr>
								<td width="3%" align="center"><strong><?php echo(getTText("it",C_NONE));?></strong></td>
								<td width="9%" align="left"><strong><?php echo(getTText("cod_produto",C_NONE));?></strong></td>
								<td width="27%" align="left"><strong><?php echo(getTText("desc_produto",C_NONE));?></strong></td>
								<td width="8%" align="center"><strong><?php echo(getTText("unidade",C_NONE));?></strong></td>
								<td width="10%" align="right"><strong><?php echo(getTText("preco_unidade",C_NONE));?></strong></td>
								<td width="7%" align="right"><strong><?php echo(getTText("quantidade",C_NONE));?></strong></td>
								<td width="6%" align="right"><strong><?php echo(getTText("desconto",C_NONE));?></strong></td>
								<td width="11%" align="right"><strong><?php echo(getTText("preco_final",C_NONE));?></strong></td>
								<td width="19%" align="right"><strong><?php echo(getTText("sub_total",C_NONE));?></strong></td>
							</tr>
							

<?php


try{
		 $strSQL = " SELECT
						  ped_pedidos_produtos.itempedi
						, ped_pedidos_produtos.idproduto
						, ped_pedidos_produtos.descrpedido
						, ped_pedidos_produtos.unidpedido
						, ped_pedidos_produtos.preco_pedi
						, ped_pedidos_produtos.quant_pedi	
						, ped_pedidos_produtos.desc_pedi				
						, ped_pedidos_produtos.preco_end
						, ped_pedidos_produtos.sub_total						
					FROM
						ped_pedidos_produtos
					INNER JOIN 
						ped_pedidos 
					ON ped_pedidos.cod_pedidos = ".$var_cod_pedido."
						AND ped_pedidos.idpedido = ped_pedidos_produtos.idpedido
						AND ped_pedidos.idmercado ILIKE ped_pedidos_produtos.idmercado
					ORDER BY 
							ped_pedidos_produtos.idproduto;";
					
					
					
					
		$objResult = $objConn->query($strSQL);
	}catch(PDOException $e) {
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
		die();
	}
	$totalOS = 0;
	foreach($objResult as $objRS){
	
	 $totalOS = $totalOS + (getvalue($objRS,"sub_total")); 
?>				

 
						
							<tr>
								<td align="center"><?php echo(getvalue($objRS,"itempedi"));?></td>
								<td align="left"><?php echo(getvalue($objRS,"idproduto"));?></td>
								<td align="left"><?php echo(getvalue($objRS,"descrpedido"));?></td>
								<td align="center"><?php echo(getvalue($objRS,"unidpedido"));?></td>								
								<td align="right"><?php echo number_format((double) getvalue($objRS,"preco_pedi"), 2, '.', ''); ?></td>
								<td align="right"><?php echo getvalue($objRS,"quant_pedi"); ?></td>
								<td align="right"><?php echo getvalue($objRS,"desc_pedi"); ?>%</td>
								<td align="right"><?php echo number_format((double) getvalue($objRS,"preco_end"), 2, '.', ''); ?></td>
								<td align="right"><?php echo number_format((double) getvalue($objRS,"sub_total"), 2, '.', ''); ?></td>
								
							</tr>
							
							
						
						<?php }?>
						</table>
					</td>
				</tr>
		  </table>
		</td>
	</tr>
	
	<?php
	
	$retencao_ir  = 0;
	$retencao_css = 0;
	$retencao_iss = 0;
	
	
	?>
	
	
	<tr>
		<td align="right">
			<br>
			<hr>			
				<?php echo(getTText("total_os",C_NONE));?> : <?php echo number_format((double) $totalOS, 2, ',', '.'); ?>
			<hr>
			<table>
				<tr>
					<td></td>					
					<td><?php echo(getTText("retencao_ir",C_NONE));?></td>
					<td align="right">
						<?php 
						if ($totalOS > 666.67){$retencao_ir = $totalOS * 0.015;}
						echo number_format((double) $retencao_ir, 2, ',', '.'); 
						?>
					</td>
				</tr>			
				<tr>
					<td></td>
					<td>
						<?php echo(getTText("retencao_css",C_NONE));?>
					</td>
					<td align="right">
						<?php 
							if ($totalOS > 10 and $calc_css != ''){$retencao_css = $totalOS * 0.0465;}
							echo number_format((double) $retencao_css, 2, ',', '.'); 
						//	SeImed([CSS]=0;0;SeImed(([TOTGER])>5000;([TOTGER])*0,0465;0)))
						
						?>
					</td>
				</tr>		
				<tr>
					<td></td>					
					<td><?php echo(getTText("retencao_iss",C_NONE));?></td>					
					<td align="right">
						<?php 
							if (($calc_iss != '') and ($totalOS > 666.67)){
								if ($calc_iss != ''){$retencao_iss = $totalOS * 0.02;}
							}
							echo number_format((double) $retencao_iss, 2, ',', '.'); 
						//	SeImed([ISS]=0;0;([TOTGER])*0,02))
						
						?>
					</td>
				</tr>						
				<tr>
					<td colspan="3"><hr></td>					
				</tr>				
				<tr>
					<td><td>					
					<td><?php echo(getTText("total_liquido",C_NONE));?>	</td>
					<td align="right">
					<?php echo number_format((double) ($totalOS  - ($retencao_ir + $retencao_css + $retencao_iss)), 2, ',', '.');?>
					</td>
				</tr>		
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<?php
				// busca o codigo do Pedido
				try{
					$strSQL = "SELECT cad_empresa.deposito
								FROM cad_evento INNER JOIN (cad_empresa 
									INNER JOIN 
									ped_pedidos 
										ON cad_empresa.idmercado = ped_pedidos.idmercado) 
										ON (cad_evento.idevento = ped_pedidos.idevento) 
										AND (cad_evento.idmercado = cad_empresa.idmercado)
								WHERE 
									((ped_pedidos.idpedido = '".$idpedido."') 
									AND  (cad_empresa.idmercado     ilike '".$id_empresa."'));";
	
				$objResult = $objConn->query($strSQL); // execução da query	
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}		
					$objRSbanco	 = $objResult->fetch();
			//		echo "<b>CONTA CORRENTE</b><br>";
			//		echo getvalue($objRSbanco,"deposito");
		  ?>
		</td>
	</tr>
</table>

</body>
</html>
<?php $objConn = NULL; ?>
