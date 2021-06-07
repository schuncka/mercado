<?php
	include_once("../_database/athdbconn.php");
	include_once("../_database/athtranslate.php");
	include_once("../_database/athkernelfunc.php");
	include_once("../_database/STathutils.php");
	include_once("../_scripts/scripts.js");
	include_once("../_scripts/STscripts.js");

$id_evento 			= getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa 		= getsession(CFG_SYSTEM_NAME."_id_mercado"); 
$datawide_lang 		= getsession("datawide_lang");


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
		.bordaBox .b2, .bordaBox .b3, .bordaBox .b4 {background:#CECECE; border-left:1px solid #999; border-right:1px solid #999;}
		.bordaBox .b1 {margin:0 5px; background:#999;}
		.bordaBox .b2 {margin:0 3px; border-width:0 2px;}
		.bordaBox .b3 {margin:0 2px;}
		.bordaBox .b4 {height:2px; margin:0 1px;}
		.bordaBox .conteudo {padding:5px;display:block; background:#CECECE; border-left:1px solid #999; border-right:1px solid #999;}
		
		
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
		<STYLE TYPE="text/css">
		.folha {
			page-break-after: always;
		}
		</STYLE>
		
		<style>
		.b1 {
		width:auto;
		height:auto;
		font-size:1px;
		background:#aaa;
		margin:0px;
		
		}
		.b2 {
		height:1px;
		font-size:1px;
		background:#fff;
		border-right:1px solid #aaa;
		border-left:1px solid #aaa;
		margin:0 3px;
		}
		.b3 {
		height:1px;
		font-size:1px;
		background:#fff;
		border-right:1px solid #aaa;
		border-left:1px solid #aaa;
		margin:0 2px;
		}
		.b4 {height:1px;
		font-size:1px;
		background:#fff;
		border-right:1px solid #aaa;
		border-left:1px solid #aaa;
		margin:0 1px;
		}
		.b5 {
		border-left:1px solid #aaa;
		border-right:1px solid #aaa;
		display:block;
		}
		
		.font_text {
			font-size:10px;
		}
		
	
		</style>
		</head>
		<body style="margin:30px 30px 30px 30px;" >

<?php

$strSQLcontratoRenovacao = "SELECT DISTINCT
								   ped_pedidos.razaope,
								   ped_pedidos.cod_pedidos,
								   ped_pedidos.idpedido,
								   ped_pedidos.new_localpe,
                                   ped_pedidos.idevento,
								   
								   CASE WHEN (ped_pedidos.new_localpe is null or ped_pedidos.new_localpe = '') 			THEN ped_pedidos.localpe ELSE ped_pedidos.new_localpe END AS localpe,  
        						   CASE WHEN (ped_pedidos.new_pavilhaope is null or ped_pedidos.new_pavilhaope = '') 	THEN ped_pedidos.pavilhaope ELSE ped_pedidos.new_pavilhaope END AS pavilhaope,
    	
								   ped_pedidos_renovacao_evento.idpedido
							FROM 	ped_pedidos  
									left join ped_pedidos_renovacao_evento 
									on (ped_pedidos.idmercado = ped_pedidos_renovacao_evento.idmercado 
									and ped_pedidos.idpedido = ped_pedidos_renovacao_evento.idpedido)
							WHERE 
										ped_pedidos.idevento = '000250' 
									and ped_pedidos.idstatus = '003'
									AND ped_pedidos.paispe = 'BRASIL'
									AND ped_pedidos.catalogo = TRUE
									AND ped_pedidos.tipope = 'ESM'
									AND SUBSTRING(ped_pedidos.idpedido FROM 7 FOR 3) = '-00'
								--	AND  ped_pedidos_renovacao_evento.idpedido IS NOT NULL
							ORDER BY 
									ped_pedidos.razaope limit 2";	
try{				
	$objResultcontratoRenovacao = $objConn->query($strSQLcontratoRenovacao);		
}catch(PDOException $e) {
	mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
	die();
}	

foreach($objResultcontratoRenovacao as $objRScontratoRenovacao){ 

		$var_cod_pedido     = getValue($objRScontratoRenovacao,"cod_pedidos"); 
		$op_contrato        = '1';
		$var_localizacao    = getValue($objRScontratoRenovacao,"localpe"); 
		$var_pavilhao       = getValue($objRScontratoRenovacao,"pavilhaope"); 
		
		
			
		
		
		//-------------------DADOS DO CONTRATO-----------------------------------------------------------------------
		
		//BUSCA O PAVILHÃO SELECIONADO NA COMBO ANTERIOR
				$strSQLpavilhao = "select descrpavilhao, idpavilhao from cad_pavilhao where idpavilhao = '".$var_pavilhao."' ;";	
					try{				
						$objResultpavilhao = $objConn->query($strSQLpavilhao);		
					}catch(PDOException $e) {
						mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
						die();
					}	
					$objRSpavilhao 	= $objResultpavilhao->fetch();
					$var_localizacao    = $var_localizacao." - ".getValue($objRSpavilhao,"descrpavilhao"); 
			
		//BUSCA OS DADOS DO PEDIDO
				 $strSQLpedido = "SELECT  
											a.nomemapa,
											a.cod_pedidos,
											a.codigope,
											a.idpedido,
											to_char(a.datape, 'dd/mm/yyyy') as datape,
											a.razaope,
											a.tipope,
											CASE WHEN (a.new_localpe is null or a.new_localpe = '') 			THEN a.localpe ELSE a.new_localpe END AS localpe,  
			        						CASE WHEN (a.new_pavilhaope is null or a.new_pavilhaope = '') 	THEN a.pavilhaope ELSE a.new_pavilhaope END AS pavilhaope
									FROM ped_pedidos a 
									WHERE a.cod_pedidos = ".$var_cod_pedido.";";	
				try{				
					$objResultpedido = $objConn->query($strSQLpedido);		
				}catch(PDOException $e) {
					mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
					die();
				}	
				$objRSpedido 	= $objResultpedido->fetch();		
				
		
		
		//BUSCA OS DADOS DO EXPOSITOR
				  $strSQLexpositor = "SELECT * FROM cad_cadastro a where  a.codigo = '".getValue($objRSpedido,"codigope")."' and idmercado ilike '".$id_empresa."' ;";	
					try{				
						$objResultexpositor = $objConn->query($strSQLexpositor);		
					}catch(PDOException $e) {
						mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
						die();
					}	
					$objRSexpositor 	= $objResultexpositor->fetch();
		
		//BUSCA OS DADOS DO EMPRESA
				 $strSQLempresa = "select * from cad_empresa where  idmercado = '".$id_empresa."'";	
				try{				
					$objResultempresa = $objConn->query($strSQLempresa);		
				}catch(PDOException $e) {
					mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
					die();
				}	
				$objRSempresa 	= $objResultempresa->fetch();
		
		//BUSCA OS DOADOS DO EVENTO ATUAL
			$strSQLeventoAtual = "SELECT  
												 cad_evento.dt_inicio,
												  cad_evento.descrevento,
												 to_char(cad_evento.dt_fim, 'dd/mm/yyyy') as dt_fim    ,
												 cad_evento.nome_completo                              ,
												 cad_evento.edicao                                     ,
												 cad_evento.pavilhao  								   ,
												 cad_evento.tipoevento								   ,
												 date_part('day', cad_evento.dt_inicio ) as dia_inicio ,
												 date_part('day', cad_evento.dt_fim )    as dia_fim    ,
												 date_part('year', cad_evento.dt_fim )   as ano_fim    ,
												 to_char((dt_inicio - interval '2 month'),'mm') 		as data_venc_mes,
												 to_char((dt_inicio - interval '2 month'),'yyyy') 		as data_venc_ano,
												 to_char((dt_inicio - interval '2 month'),'mm/yyyy') 	as data_venc
										FROM cad_evento
										WHERE  cad_evento.idevento = '".$id_evento."'";
							try{			
								$objResulteventoAtual = $objConn->query($strSQLeventoAtual); // execução da query
							}catch(PDOException $e){
									mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
									die();
							}
							$objRSeventoAtual 	= $objResulteventoAtual->fetch();
							
							
		
		//BUSCA OS DADOS EVENTO A SER RENOVADO
			$strSQLevento = "SELECT  
										 cad_evento.idevento,								
										 cad_evento.dt_inicio,
										 to_char(cad_evento.dt_fim, 'dd/mm/yyyy') as dt_fim    ,
										 cad_evento.nome_completo                              ,
										 cad_evento.edicao                                     ,
										 cad_evento.pavilhao  								   ,
										 cad_evento.tipoevento								   ,
										 date_part('day', cad_evento.dt_inicio ) as dia_inicio ,
										 date_part('day', cad_evento.dt_fim )    as dia_fim    ,
										  date_part('month', cad_evento.dt_fim )  as mes_fim    ,
										 date_part('year', cad_evento.dt_fim )   as ano_fim    ,
										 to_char((dt_inicio - interval '2 month'),'mm/yyyy') as data_venc
								FROM cad_evento
								WHERE  cad_evento.idevento = (	SELECT   idevento
																FROM cad_evento 
																WHERE idmercado = '".$id_empresa."' AND
																	cad_evento.descrevento Like '%' || SUBSTRING( '".getValue($objRSeventoAtual,"descrevento")."' ,1,8) || '%'
																AND cad_evento.descrevento Not Like 'EMPRESA%'
																AND DATE_PART('year', dt_inicio) = 
																			(
																				SELECT DATE_PART('year', dt_inicio) +1
																				FROM cad_evento 
																				WHERE idevento = '".$id_evento."'
																			)
															 );";
							
					try{			
						$objResultevento = $objConn->query($strSQLevento); // execução da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
					$objRSevento 	= $objResultevento->fetch();
				
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
										FROM 
										  public.cad_renovacao_valores 
										WHERE idevento = '".$id_evento."';";	
						try{				
							$objResultrenovacao = $objConn->query($strSQLrenovacao);		
						}catch(PDOException $e) {
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
							die();
						}	
						$objRSrenovacao 	= $objResultrenovacao->fetch();
		
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
					//	$objRSmarcas 	= $objResultmarcas->fetch();
						$marcasExpositor = '';
						foreach($objResultmarcas as $objRSmarcas){ 
						
										$marcasExpositor .= getValue($objRSmarcas,"descrmarca").", ";
						
						} // BUSCA LINHA POR LINHA
		
								
		?>



<!--      INICIO DO CONTRATO DE ADENDO PARA O EVENTO PRETA PORTER         -->
		
		<table width="100%"  border="0" class="bordasimples1">
		  <tr>
			<td><table width="100%" border="1" >
				<tr>
				  <td width="29%" align="center"><font size="+2"><b><img src="../img/logos/logo_pretaporter.jpg" width="160" height="30" > </b></font></td>
				  <td width="4%" align="center">&nbsp;</td>
				  <td rowspan="2" valign="middle" align="center"><b><?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."°"; ?> 
					<?php      if ($id_empresa == "MO"){echo "Feira Internacional de Calçados, Artigos Esportivos e Artefatos de Couro";} 
						  else if ($id_empresa == "SA"){echo "Feira Internacional de Produtos, Equipamentos, Serviços e Tecnologia para Hospitais, Laboratórios, Farmácias, Clínicas e Consultórios";}
						  else if ($id_empresa == "BE"){echo "Feira Internacional de Beleza, Cabelos e Estética";} ?>				   
						  
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
				<td align="justify"> <div align="justify">SÃO PAULO FEIRAS COMERCIAIS LTDA., inscrita no CNPJ nº 02.995.701/0001-33 com sede na Rua Padre Jo&atilde;o Manoel, 923 Conj. 61/62- 6&ordm; Andar - Cerqueira C&eacute;sar - Fone <?php echo getValue($objRSempresa, "etele"); ?> - Fax<?php echo getValue($objRSempresa, "efax"); ?> - CEP 01411-001 - S&atilde;o Paulo/SP - Brasil - vendas@saopaulopretaporter.com.br - www.saopaulopretaporter.com </div></td>
			</tr>
			<tr>
				<td align="left" valign="top"><strong>2.</strong></td>
				<td align="justify"><div align="justify">EXPOSITOR: <?php echo getValue($objRSexpositor, "razao") ?> , pessoa jurídica inscrita no CNPJ nº <?php echo getValue($objRSexpositor, "cgcmf") ?>, com sede à <?php echo getValue($objRSexpositor, "endereco") ?>, 
				  <?php echo getValue($objRSexpositor, "bairro") ?>, na cidade de <?php echo getValue($objRSexpositor, "cidade")."/".getValue($objRSexpositor, "cgcmf") ?> - CEP.: <?php echo getValue($objRSexpositor, "cep") ?>.<br>
		  <br>
			  </div></td>
			</tr>
			<tr>
				<td align="left" valign="top">&nbsp;</td>
				<td align="justify"><div align="justify">Considerando que a SÃO PAULO FEIRAS COMERCIAIS LTDA., é a promotora exclusiva e única reponsável pela Organização, Planejamento,
									Promoção e Administração para realização da Feira 
									<?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."°"; ?> 
									Feira Internacional de Moda, Confecções e Acessórios - 								
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
				  programa de Montagem Padrão oferecido, será concedido, automaticamente, um desconto comercial e incondicional de R$ 20,00 reais por metro
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
		</table>	
		<br><br>
		
		<div align="justify" class="font_text">Esta autorização deverá ser assinada com o Contrato de Prestação de Serviço de Organização, Planejamento, Promoção e Administração da feira comercial - <?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."°"; ?>  </div>
		
		<br>	
		 
		 
		 
		
		<table width="100%" border="0"  class="bordasimples" >
			<tr>
				<td align="left" class="font_text" style="border:none" width="1%" nowrap="nowrap">Nome/Cargo de quem autorizou o contrato:</td>
				<td align="left" class="font_text" style="border-left:none; border-right:none; border-top:none" >ARLOS GRAÇA DE ARAUJO / SÓCIO GERENTE</td>
				<td align="right" class="font_text" style="border:none">Data:</td>
				<td align="left" class="font_text"  style="border-left:none; border-right:none; border-top:none" width="15%">&nbsp;</td>
			</tr>
		</table>
			
		<table width="100%" border="0" class="bordasimples">
			<tr>
				<td align="left" class="font_text" style="border:none"  width="1%" nowrap="nowrap" >Cpf:</td>
				<td align="left" class="font_text" style="border-left:none; border-right:none; border-top:none" >90338383972</td>
				
				<td align="right" class="font_text" style="border:none">RG:</td>
				<td align="left"  class="font_text" style="border-left:none; border-right:none; border-top:none" >90338383972</td>
				
				<td align="right" class="font_text" style="border:none">Data de Aniversário:</td>
				<td align="left"  class="font_text" style="border-left:none; border-right:none; border-top:none" width="15%">&nbsp;</td>
			</tr>
		</table>
		<br><br>
		
		<div align="center">_________________________________________________</div>
		<div align="center" class="font_text"><?php echo getValue($objRSexpositor, "razao") ?></div>
		
		
		
		
		
		
		
		
		<!-- para quebrar a páina -->
		<div style="page-break-after:always"></div>
		
<?php } //foreach dos contratos ?>
</body>
</html>
<?php $objConn = NULL; ?>
