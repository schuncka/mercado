<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

$cod_chave 	= request("var_chavereg");
$strCodigo 	= request("var_codigo");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$id_evento 	= getsession(CFG_SYSTEM_NAME."_id_evento"); 




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



//SQL PARA BUSCAR OS DADOS DO EVENTO



// SQL PADRÃO DA LISTAGEM - BREVE DESCRIÇÃO
	try{
		// seleciona todos os contatos do fornecedor
		// com cod_cadastro enviado para este script
	 $strSQL = "SELECT
						     ped_servico.idservico
						   , cad_evento.nome_completo          
       					   , cad_evento.pavilhao               
                           , cad_evento.dt_inicio               
                           , cad_evento.dt_fim                          
						   , ped_servico.idmercado
						   , ped_servico.fatcli
						   , ped_servico.datase
						   , ped_servico.idmontse
						   , ped_servico.razaose
						   , ped_servico.fantasiase
						   , ped_servico.enderecose
						   , ped_servico.bairrose
						   , ped_servico.cidadese
						   , ped_servico.estadose
						   , ped_servico.cepse
						   , ped_servico.paisse
						   , ped_servico.cgcmfse
						   , ped_servico.inscrestse
						   , ped_servico.telefone1se
						   , ped_servico.telefone2se
						   , ped_servico.telefone3se
						   , ped_servico.telefone4se
						   , ped_servico.ideventose
						   , ped_pedidos.localpe
						   , ped_servico_produtos.itemserv
						   , ped_servico_produtos.idprodutoserv
						   , ped_servico_produtos.descrservico
						   , ped_servico_produtos.unidservico
						   , ped_servico_produtos.preco_serv
						   , ped_servico_produtos.quant_serv
						   , ped_servico_produtos.desc_serv
						   , ped_servico_produtos.sub_serv
						   , cad_evento.descrevento
						   , cad_evento.edicao
						   , cad_evento.dt_inicio AS PERIODO1
						   , cad_evento.dt_fim AS PERIODO2
						   , cad_evento.local
						   , ped_pedidos.razaope
						   , cad_pavilhao.descrpavilhao
						   , ped_servico.sindicatose
						   , ped_servico.sys_dtt_ins
						   , cad_montador.ret_ir  
                           , cad_montador.ret_iss
						   , cad_montador.ret_10833
					FROM ped_servico 
					INNER JOIN cad_evento ON ped_servico.ideventose = cad_evento.idevento
					LEFT JOIN (ped_servico_produtos 
					LEFT JOIN ped_pedidos ON ped_servico_produtos.idmercado = ped_pedidos.idmercado AND ped_servico_produtos.idpedido = ped_pedidos.idpedido
					LEFT JOIN cad_pavilhao ON ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao) ON ped_servico.idservico = ped_servico_produtos.idservico AND ped_servico.idmercado = ped_servico_produtos.idmercado
					LEFT JOIN cad_montador on (cad_montador.idmont = ped_servico.idmontse )
					WHERE ped_servico.cod_servico = ".$cod_chave." 
					AND ped_servico.idmercado ILIKE '".$id_empresa."' ";
		$objResult = $objConn->query($strSQL);
	}catch(PDOException $e) {
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
		die();
	}
	$objRS	 = $objResult->fetch();
	
	$calc_ir  = getvalue($objRS,"ret_ir");
	$calc_iss = getvalue($objRS,"ret_iss");
	$calc_10833 = getvalue($objRS,"ret_10833");
?>


<html>
<head>
<title>
<?php echo(CFG_SYSTEM_TITLE); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


		<?php /*?>if(!$boolIsExportation || $strAcao == "print"){
			echo(" <link rel=\"stylesheet\" href=\"../_css/" . CFG_SYSTEM_NAME . ".css\" type=\"text/css\">
			<link href='../_css/tablesort.css' rel='stylesheet' type='text/css'>
			      <script type='text/javascript' src='../_scripts/tablesort.js'></script>");
		}<?php */?>
	

<script language="JavaScript" type="text/javascript">
		function switchColor(prObj, prColor){
			prObj.style.backgroundColor = prColor;
		}
	</script>
<style type="text/css">

img{border:none;}
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


</style>
</head>
<body style="margin:30px 15px 30px 10px;"  >
<?php //athBeginFloatingBox("670","","<b>".getTText("historico_cliente",C_TOUPPER)."</b>",CL_CORBAR_GLASS_1); ?>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td align="center"><h4>PEDIDO PREST. SERVIÇO - <?php echo (getvalue($objRS,"nome_completo"))?> - <?php echo (getvalue($objRS,"pavilhao"))?> - <?php echo dDate("PTB",getvalue($objRS,"dt_inicio"),"0");?> a <?php echo dDate("PTB",getvalue($objRS,"dt_fim"),"0");?></h4></td>
		
																	
	</tr>	
	<tr>
		<td>
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<td width="65%"></td>
					<td align="right"><h5>Nº O.S.....:</h5></td>
					<td align="right"><h5><?php echo (getvalue($objRS,"idservico"))?></h5></td>
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
		<td height="20"></td>
	</tr>
	<tr>
		<td align="center">
			<table cellpadding="0" cellspacing="0" border="0" height="100%" width="100%" bgcolor="#FFFFFF" style="background-color:#FFFFFF; border:1px solid #CCCCCC;">
				<tr>
					<td align="center" valign="top" style="padding:10px 10px 10px 10px;">
						<table cellspacing="2" cellpadding="3" border="0" width="100%">
							<tr>
								<td width="13%" align="right"><strong><?php echo(getTText("cod_cadastro",C_NONE));?> :</strong></td>
								<td width="40%" align="left"><?php echo(getvalue($objRS,"idmontse"));?></td>
								<td width="13%" align="right"><strong><?php echo(getTText("telefone1",C_NONE));?> :</strong></td>
								<td width="22%" align="left" colspan="5"><?php echo(getvalue($objRS,"telefone1se"));?></td>
							</tr>
							<tr>
								<td align="right"><strong><?php echo(getTText("razao",C_NONE));?> :</strong></td>
								<td align="left"><?php echo(getvalue($objRS,"razaose"));?></td>
								<td align="right"><strong><?php echo(getTText("telefone1n",C_NONE));?> :</strong></td>
								<td align="left"><?php  echo(getvalue($objRS,"telefone2se"));?></td>
							</tr>
							<tr>
								<td align="right"><strong><?php echo(getTText("fantasia",C_NONE));?> :</strong></td>
								<td align="left"><?php  echo(getvalue($objRS,"fantasiase"));?></td>
								<td align="right"><strong><?php echo(getTText("telefone3",C_NONE));?> :</strong></td>
								<td align="left"><?php  echo(getvalue($objRS,"telefone3se"));?></td>
							</tr>
							<tr>
								<td align="right"><strong><?php echo(getTText("endereco",C_NONE));?> :</strong></td>
								<td align="left"><?php  echo(getvalue($objRS,"enderecose"));?></td>
								<td align="right"><strong><?php echo(getTText("telefone4",C_NONE));?> :</strong></td>
								<td align="left"><?php  echo(getvalue($objRS,"telefone4se"));?></td>
							</tr>
							<tr>
								<td align="right"><strong><?php echo(getTText("bairro",C_NONE));?> :</strong></td>
								<td align="left"><?php  echo(getvalue($objRS,"bairrose"));?></td>
								<td align="right"><strong><?php echo(getTText("cnpj",C_NONE));?> :</strong></td>
								<td align="left"><?php  echo(getvalue($objRS,"cgcmfse"));?></td>
							</tr>
							<tr>
								<td align="right"><strong><?php echo(getTText("cidade",C_NONE));?> :</strong></td>
								<td align="left"><?php echo(getvalue($objRS,"cidadese"));?></td>
								<td align="right"><strong><?php echo(getTText("inscr_estadual",C_NONE));?> :</strong></td>
								<td align="left"><?php echo(getvalue($objRS,"inscrestse"));?></td>
							</tr>
							<tr>
								<td align="right"><strong><?php echo(getTText("estado",C_NONE));?> :</strong></td>
								<td align="left"><?php echo(getvalue($objRS,"estadose"));?></td>
							
							</tr>
							<tr>
								<td align="right"><strong><?php echo(getTText("cep",C_NONE));?> :</strong></td>
								<td align="left"><?php echo(getvalue($objRS,"cepse"));?></td>
							</tr>
							<tr>
								<td align="right"><strong><?php echo(getTText("pais",C_NONE));?> :</strong></td>
								<td align="left"><?php echo(getvalue($objRS,"paisse"));?></td>
							</tr>
							
							
						</table>
					</td>
				</tr>
		  </table>
		</td>
	</tr>
	<tr>
		<td height="10"></td>
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
		<td height="10"></td>
	</tr>	
	<tr>
		<td align="center">
			<table cellpadding="0" cellspacing="0" border="0" height="100%" width="100%" bgcolor="#FFFFFF" style="background-color:#FFFFFF; border:1px solid #CCCCCC;">
				<tr>
					<td align="center" valign="top" style="padding:10px 10px 10px 10px;">
						<table cellspacing="2" cellpadding="3" border="0" width="100%">
							
							
							<tr>
								<td width="1%" align="center"><strong><?php echo(getTText("it",C_NONE));?></strong></td>
								<td width="30%" align="center"><strong><?php echo(getTText("expositor",C_NONE));?></strong></td>
								<td width="25%" align="center"><strong><?php echo(getTText("descr_prod",C_NONE));?></strong></td>
								<td width="5%" align="center"><strong><?php echo(getTText("unit",C_NONE));?></strong></td>
								<td width="5%" align="center"><strong><?php echo(getTText("qtd_preco",C_NONE));?></strong></td>
								<td width="5%" align="center"><strong><?php echo(getTText("preco_unit",C_NONE));?></strong></td>
								<td width="5%" align="center"><strong><?php echo(getTText("sub_total",C_NONE));?></strong></td>
								<td width="20%" align="center"><strong><?php echo(getTText("localizacao",C_NONE));?></strong></td>
							</tr>

<?php
try{
		 $strSQL = "SELECT 
						   ped_pedidos.localpe, 
						   cad_pavilhao.descrpavilhao,
						   ped_pedidos.razaope ,
						   ped_servico_produtos.itemserv      ,
						   ped_servico_produtos.idprodutoserv ,
						   ped_servico_produtos.descrservico  ,
						   ped_servico_produtos.unidservico   ,
						   ped_servico_produtos.preco_serv    ,
						   ped_servico_produtos.quant_serv    ,
						   ped_servico_produtos.desc_serv     ,
						   ped_servico_produtos.sub_serv      						
					FROM   ped_servico
						   INNER JOIN cad_evento
						   ON     ped_servico.ideventose = cad_evento.idevento
						   INNER JOIN (ped_servico_produtos
								  LEFT JOIN ped_pedidos
								  ON     ped_servico_produtos.idmercado = ped_pedidos.idmercado
								  AND    ped_servico_produtos.idpedido  = ped_pedidos.idpedido
								  LEFT JOIN cad_pavilhao
								  ON     ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao)
						   ON     ped_servico.idservico         = ped_servico_produtos.idservico
						   AND    ped_servico.idmercado         = ped_servico_produtos.idmercado
					WHERE  ped_servico.cod_servico = ".$cod_chave."
					AND    ped_servico.idmercado ILIKE '".$id_empresa."' ";
					
		$objResult = $objConn->query($strSQL);
	}catch(PDOException $e) {
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
		die();
	}
	$totalOS = 0;
	foreach($objResult as $objRS){
	
	 $totalOS = $totalOS + (getvalue($objRS,"sub_serv")); 
?>				
						
							<tr>
								<td align="center"><?php  echo(getvalue($objRS,"itemserv"));?></td>
								<td align="center"><?php  echo(getvalue($objRS,"razaope"));?></td>
								<td align="center"><?php echo(getvalue($objRS,"descrservico"));?></td>
								<td align="center"><?php  echo(getvalue($objRS,"unidservico"));?></td>
								<td align="center"><?php  echo(getvalue($objRS,"quant_serv"));?></td>
								
								<td align="center"><?php echo number_format(getvalue($objRS,"preco_serv"), 2, '.', ''); ?></td>
								<td align="center"><?php echo number_format(getvalue($objRS,"sub_serv"), 2, '.', ''); ?></td>
								<td align="center"><?php  echo(getvalue($objRS,"localpe"). " - " .getvalue($objRS,"descrpavilhao")  );?></td>
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
			<br><br><br><br>
			<hr>			
				<?php echo(getTText("total_os",C_NONE));?> : <?php echo number_format($totalOS, 2, ',', '.'); ?>
			<hr>
			<table>
				<tr>
					<td></td>					
					<td><?php echo(getTText("retencao_ir",C_NONE));?></td>
					<td align="right">
						<?php 
						if (($totalOS > 666.67) && ($calc_ir == '1')) { $retencao_ir = $totalOS * 0.015; }
						echo number_format($retencao_ir, 2, ',', '.'); 
						?>
					</td>
				</tr>			
				<tr>
					<td></td>
					<td><?php echo(getTText("retencao_css",C_NONE));?></td>
					<td align="right">
						<?php 
						if (($totalOS > 10) && ($calc_10833 == "1")) { $retencao_css = $totalOS * 0.0465; }
						echo number_format($retencao_css, 2, ',', '.'); 
						?>
					</td>
				</tr>		
				<tr>
					<td></td>					
					<td><?php echo(getTText("retencao_iss",C_NONE));?></td>					
					<td align="right">
						<?php 
						//if(($calc_ir == '1') and ($totalOS > 666.67)){
							if ($calc_iss == '1') { $retencao_iss = $totalOS * 0.02; }
						//}
						echo number_format($retencao_iss, 2, ',', '.'); 
						?>
					</td>
				</tr>						
				<tr>
					<td colspan="3"><hr></td>					
				</tr>				
				<tr>
					<td></td>					
					<td><?php echo(getTText("total_liquido",C_NONE));?>	</td>
					<td align="right"><?php echo number_format(($totalOS  - ($retencao_ir + $retencao_css + $retencao_iss)), 2, ',', '.'); ?></td>
				</tr>		
			</table>
		</td>
	</tr>
</table>
<?php // athEndFloatingBox();?>
</body>
</html>
<?php $objConn = NULL; ?>
