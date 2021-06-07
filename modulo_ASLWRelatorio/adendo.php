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
$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc") || ($strAcao == ".pdf");

//Exporta��o para excel, word e adobe reader
if($boolIsExportation) {
	if($strAcao == ".pdf") {
		redirect("exportpdf.php"); //Redireciona para p�gina que faz a exporta��o para adode reader
	}
	else{
		//Coloca o cabe�alho de download do arquivo no formato especificado de exporta��o
		header("Content-type: application/force-download"); 
		header("Content-Disposition: attachment; filename=Modulo_" . getTText(getsession($strSesPfx . "_titulo"),C_NONE) . "_". time() . $strAcao);
	}	
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
		
		//BUSCA O PAVILH�O SELECIONADO NA COMBO ANTERIOR
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
								$objResulteventoAtual = $objConn->query($strSQLeventoAtual); // execu��o da query
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
						$objResultevento = $objConn->query($strSQLevento); // execu��o da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
					$objRSevento 	= $objResultevento->fetch();
				
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
				  <td rowspan="2" valign="middle" align="center"><b><?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."�"; ?> 
					<?php      if ($id_empresa == "MO"){echo "Feira Internacional de Cal�ados, Artigos Esportivos e Artefatos de Couro";} 
						  else if ($id_empresa == "SA"){echo "Feira Internacional de Produtos, Equipamentos, Servi�os e Tecnologia para Hospitais, Laborat�rios, Farm�cias, Cl�nicas e Consult�rios";}
						  else if ($id_empresa == "BE"){echo "Feira Internacional de Beleza, Cabelos e Est�tica";} ?>				   
						  
					<br>
					<?php echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?>
			        <?php echo getValue($objRSevento,"pavilhao");  ?> - S�O PAULO/SP </b></td>
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
			AUTORIZA��O PARA INCORPORA��O DA MONTAGEM PADR�O NO CONTRATO DE ORGANIZA��O, PLANEJAMENTO, PROMO��O E
			ADMINISTRA��O DE FEIRA COMERCIAL
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
				<td align="justify"> <div align="justify">S�O PAULO FEIRAS COMERCIAIS LTDA., inscrita no CNPJ n� 02.995.701/0001-33 com sede na Rua Padre Jo&atilde;o Manoel, 923 Conj. 61/62- 6&ordm; Andar - Cerqueira C&eacute;sar - Fone <?php echo getValue($objRSempresa, "etele"); ?> - Fax<?php echo getValue($objRSempresa, "efax"); ?> - CEP 01411-001 - S&atilde;o Paulo/SP - Brasil - vendas@saopaulopretaporter.com.br - www.saopaulopretaporter.com </div></td>
			</tr>
			<tr>
				<td align="left" valign="top"><strong>2.</strong></td>
				<td align="justify"><div align="justify">EXPOSITOR: <?php echo getValue($objRSexpositor, "razao") ?> , pessoa jur�dica inscrita no CNPJ n� <?php echo getValue($objRSexpositor, "cgcmf") ?>, com sede � <?php echo getValue($objRSexpositor, "endereco") ?>, 
				  <?php echo getValue($objRSexpositor, "bairro") ?>, na cidade de <?php echo getValue($objRSexpositor, "cidade")."/".getValue($objRSexpositor, "cgcmf") ?> - CEP.: <?php echo getValue($objRSexpositor, "cep") ?>.<br>
		  <br>
			  </div></td>
			</tr>
			<tr>
				<td align="left" valign="top">&nbsp;</td>
				<td align="justify"><div align="justify">Considerando que a S�O PAULO FEIRAS COMERCIAIS LTDA., � a promotora exclusiva e �nica repons�vel pela Organiza��o, Planejamento,
									Promo��o e Administra��o para realiza��o da Feira 
									<?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."�"; ?> 
									Feira Internacional de Moda, Confec��es e Acess�rios - 								
									<?php echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?>
									<?php echo getValue($objRSevento,"pavilhao");  ?> - localizado na cidade de S�O PAULO/SP 
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
				<td align="justify"><div align="justify">O presente ajuste tem como objeto a autoriza��o e confirma��o de utiliza��o da Montagem Padr�o no contrato de presta��o de servi�o de
				  Organiza��o, Planejamento, Promo��o e Administra��o da feira comercial - <?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."�"; ?> , previamente ou conjuntamente
				  assinado pelas partes.<br>
		  <br>
				</div></td>
			</tr>
			<tr>
				<td align="left" valign="top"><strong>III.</strong></td>
				<td align="justify"><div align="justify"><strong>DA MONTAGEM PADR�O </strong></div></td>
			</tr>
			<tr>
				<td align="left" valign="top"><strong>1.</strong></td>
				<td align="justify"><div align="justify">Por tratar-se de uma bonifica��o que a empresa S�O PAULO FEIRAS COMERCIAIS LTDA. est� ofertando, em caso de recusa do EXPOSITOR ao
				  programa de Montagem Padr�o oferecido, ser� concedido, automaticamente, um desconto comercial e incondicional de R$ 20,00 reais por metro
				quadrado ao EXPOSITOR. </div></td>
			</tr>
			<tr>
				<td align="left" valign="top"><strong>2.</strong></td>
				<td align="justify"><div align="justify">A Montagem Padr�o consiste em um estande padr�o, previamente estruturado e projetado pela empresa S�O PAULO FEIRAS COMERCIAIS LTDA., conforme modelo a ser enviado ao expositor, devendo este dar ci�ncia de seu recebimento. </div></td>
			</tr>
			<tr>
				<td align="left" valign="top"><strong>3.</strong></td>
				<td align="justify"><div align="justify">O EXPOSITOR, sob nenhuma hip�tese ou alega��o, poder� alterar a configura��o, a arquitetura e os elementos da Montagem Padr�o do estande,
				  entregue pela S�O PAULO FEIRAS COMERCIAIS LTDA., quer em sua disposi��o, altura, largura, profundidade ou cor. O EXPOSITOR n�o
				poder�, sob nenhuma hip�tese, ou sob qualquer alega��o, contratar outra montadora que n�o seja a montadora oficial da �rea em quest�o. </div></td>
			</tr>				
			<tr>
				<td align="left" valign="top"><strong>4.</strong></td>
				<td align="justify"><div align="justify">Todos os materiais e equipamentos utilizados na montagem, bem como aqueles que ir�o guarnecer os estandes, s�o de propriedade da empresa
				  MONTADORA, que para este fim os cedem para uso exclusivo do expositor durante a realiza��o do evento. Na desmontagem, caso sejam
				  constatados quaisquer danos e/ou falta de algum bem constante quando da entrega do estande, seu custo dever� ser ressarcido pelo EXPOSITOR
				ao pre�o de mercado. </div></td>
			</tr>		
			<tr>
				<td align="left" valign="top"><strong>5.</strong></td>
				<td align="justify"> <div align="justify">Os acr�scimos de m�veis e/ou materiais de montagem dever�o ser solicitados e pagos diretamente � montadora indicada.<br>
				  <br>		
				</div></td>
			</tr>		
			<tr>
				<td align="left" valign="top"><strong>IV.</strong></td>
				<td align="justify"> <div align="justify"><strong>DA AUTORIZA��O </strong></div></td>
			</tr>		
			<tr>
				<td align="left" valign="top"><strong>[ ]</strong></td>
				<td align="justify"><div align="justify">Autorizo e confirmo a utiliza��o da Montagem Padr�o oferecida pela empresa S�O PAULO FEIRAS COMERCIAIS LTDA.. </div></td>
			</tr>		
			<tr>
				<td align="left" valign="top"><strong>[ ]</strong></td>
				<td align="justify"><div align="justify">N�o autorizo e n�o confirmo a utiliza��o da Montagem Padr�o oferecida pela empresa S�O PAULO FEIRAS COMERCIAIS LTDA.. </div><br><br></td>
			</tr>		
			<tr>
				<td align="left" valign="top"><strong>V.</strong></td>
				<td align="justify"><div align="justify"><strong>DAS DISPOSI��ES FINAIS</strong>
				</div></td>
			</tr>		
			<tr>
				<td align="left" valign="top"><strong>1.</strong></td>
				<td align="justify"><div align="justify">O presente ajuste entra em vigor na data de sua assinatura		</div></td>
			</tr>		
			<tr>
				<td align="left" valign="top"><strong>2.</strong></td>
				<td align="justify"><div align="justify">O EXPOSITOR compromete-se a cumprir o Regulamento Geral da Feira <?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."�"; ?> , que � parte integrante e complementar
			  desta autoriza��o, do qual recebe uma c�pia e tem ci�ncia. </div></td>
			</tr>		
		
			<tr>
				<td align="left" valign="top"><strong>3.</strong></td>
				<td align="justify"><div align="justify">Segundo o Item III da presente autoriza��o, o Plano de Pagamento dever� estar plenamente quitado para participa��o e ingresso na feira. </div></td>
			</tr>		
			<tr>
				<td align="left" valign="top"><strong>4.</strong></td>
				<td align="justify"><div align="justify">Servi�os Adicionais necess�rios e/ou convenientes � participa��o do EXPOSITOR na Feira, tais como: energia el�trica adicional instalada em KVA,
				  limpeza, seguran�a e ponto d'�gua ter�o seus pre�os definidos em circular espec�fica, pag�veis pelo EXPOSITOR at� a data de <?php  echo getValue($objRSeventoAtual,"dtlimite");  ?>.
				  <br>
		  <br>		
				</div></td>
			</tr>		
		</table>	
		<br><br>
		
		<div align="justify" class="font_text">Esta autoriza��o dever� ser assinada com o Contrato de Presta��o de Servi�o de Organiza��o, Planejamento, Promo��o e Administra��o da feira comercial - <?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."�"; ?>  </div>
		
		<br>	
		 
		 
		 
		
		<table width="100%" border="0"  class="bordasimples" >
			<tr>
				<td align="left" class="font_text" style="border:none" width="1%" nowrap="nowrap">Nome/Cargo de quem autorizou o contrato:</td>
				<td align="left" class="font_text" style="border-left:none; border-right:none; border-top:none" >ARLOS GRA�A DE ARAUJO / S�CIO GERENTE</td>
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
				
				<td align="right" class="font_text" style="border:none">Data de Anivers�rio:</td>
				<td align="left"  class="font_text" style="border-left:none; border-right:none; border-top:none" width="15%">&nbsp;</td>
			</tr>
		</table>
		<br><br>
		
		<div align="center">_________________________________________________</div>
		<div align="center" class="font_text"><?php echo getValue($objRSexpositor, "razao") ?></div>
		
		
		
		
		
		
		
		
		<!-- para quebrar a p�ina -->
		<div style="page-break-after:always"></div>
		
<?php } //foreach dos contratos ?>
</body>
</html>
<?php $objConn = NULL; ?>
