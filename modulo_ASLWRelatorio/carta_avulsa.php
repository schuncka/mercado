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


$var_cod_pedido     = request("var_cod_pedido");
$op_contrato        = request("op_contrato");
$var_localizacao    = request("str_localizacao");
$var_pavilhao       = request("var_pavilhao");



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
									a.new_localpe,
									a.pavilhaope,
									a.localpe
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
		  $strSQLexpositor = "SELECT * FROM cad_cadastro a where  a.codigo = '".getValue($objRSpedido,"codigope")."' and idempresa ilike '".$id_empresa."' ;";	
			try{				
				$objResultexpositor = $objConn->query($strSQLexpositor);		
			}catch(PDOException $e) {
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
				die();
			}	
			$objRSexpositor 	= $objResultexpositor->fetch();

//BUSCA OS DADOS DO EMPRESA
		 $strSQLempresa = "select * from cad_empresa where  idempresa = '".$id_empresa."'";	
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
							     date_part('year', cad_evento.dt_fim )   as ano_fim    ,
								 to_char((dt_inicio - interval '2 month'),'mm/yyyy') as data_venc
						FROM cad_evento
						WHERE  cad_evento.idevento = (	SELECT   idevento
										 				FROM cad_evento 
										 				WHERE idempresa = '".$id_empresa."' AND
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
								  idempresa,
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
</style>
</head>
<body style="margin:30px 30px 30px 30px;" >
<table width="100%"  border="0" class="bordasimples1">
  <tr>
    <td><table width="100%" border="0" class="bordasimples1">
        <tr>
          <td width="29%" align="center"><font size="+2"><b><?php echo getValue($objRSevento,"tipoevento"); ?></b></font></td>
          <td width="4%" align="center">&nbsp;</td>
          <td colspan="2"><?php echo getValue($objRSevento,"nome_completo")." - ".getValue($objRSevento,"edicao")."�"; ?> 
		  	<?php      if ($id_empresa == "CM"){echo "Feira Internacional de Cal�ados, Artigos Esportivos e Artefatos de Couro";} 
				  else if ($id_empresa == "HP"){echo "Feira Internacional de Produtos, Equipamentos, Servi�os e Tecnologia para Hospitais, Laborat�rios, Farm�cias, Cl�nicas e Consult�rios";}
				  else if ($id_empresa == "SP"){echo "Feira Internacional de Beleza, Cabelos e Est�tica";} ?>
			<?php echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?>
	 	 	<?php echo getValue($objRSevento,"pavilhao");  ?> - S�O PAULO/SP		  </td>
        </tr>
        
        <tr>
          <td align="center" bgcolor="#000000"> <font color="#FFFFFF" size="2"><b><?php echo getValue($objRSevento,"dia_inicio")." a ".getValue($objRSevento,"dia_fim")." | ".nomeMes('5')." | " .getValue($objRSevento,"ano_fim")  ?></b></font></td>
          <td align="center">&nbsp;</td>
          <td width="10%" align="center" bgcolor="#000000"><font color="#FFFFFF" size="2"><b>OP��O <?php echo $op_contrato; ?></b></font></td>
          <td width="57%">Condi��es v�lidas para renova��o at� <?php echo getValue($objRSeventoAtual,"dt_fim"); ?>, com pagamento <?php if ($op_contrato == 1) { echo(" em at� 5 parcelas. "); } else { echo(" de 6 a 10 parcelas. "); }?></td>
        </tr>
      </table></td>
  </tr>
</table>
<div align="center">CONTRATO DE ORGANIZA��O, PLANEJAMENTO, PROMO��O E ADMINISTRA��O DE FEIRA COMERCIAL</div>
<div align="justify"><b>I. CONTRATANTES</b>
  <br>
  <b>1. PROMOTORA E ORGANIZADORA: </b> 
  <?php echo strtoupper(getValue($objRSempresa, "erazao")); ?>, inscrita no CNPJ n� <?php echo getValue($objRSempresa, "ecnpj"); ?> com sede na Rua Padre Jo&atilde;o Manoel, 923 - 6&ordm; Andar - Cerqueira C&eacute;sar - Fone (11) 3897-6199 - Fax(11) 3897-6191 - CEP 01411-001 - S&atilde;o Paulo/SP - Brasil, promotora e organizadora da <?php echo getValue($objRSevento, "nome_completo"); ?> um empreendimento da HOSPITALAR FEIRAS, CONGRESSOS E EMPREENDIMENTOS LTDA.<br>
<b>2. EXPOSITOR</b>
</div>
<table width="100%" border="1" class="bordasimples1">
  <tr>
    <td width="14%">C�digo</td>
    <td width="41%" align="left"><div align="left"> HP009761  <?php // echo getValue($objRSexpositor, "idempresa").getValue($objRSexpositor, "codigo");?></div></td>
    <td width="16%">Telefone</td>
    <td width="29%"><div align="left">(11) 3078-8026 <?php // echo getValue($objRSexpositor, "telefone1"); ?></div></td>
  </tr>
  <tr>
    <td>Raz�o Social</td>
    <td><div align="left"> MINDRAY DO BRASIL - COM E DISTR DE EQUIO M�DICOS LTDA. <?php // echo getValue($objRSexpositor, "razao"); ?></div></td>
    <td>Telefax</td>
    <td><div align="left">(11) 3078-8035<?php // echo getValue($objRSexpositor, "telefone2"); ?></div></td>
  </tr>
  <tr>
    <td>Nome Fantasia</td>
    <td><div align="left">MINDRAY BRASIL - EQUIPAMENTOS M�DICOS<?php // echo getValue($objRSexpositor, "fantasia"); ?></div></td>
    <td>Dire��o</td>
    <td><div align="left"><?php echo getValue($objRSexpositor, "telefone3"); ?></div></td>
  </tr>
  <tr>
    <td>Endere�o</td>
    <td><div align="left"> Rua Joaquin Floriano, 488 - Piso Intermedi�rio CJ 02<?php // echo getValue($objRSexpositor, "endereco"); ?></div></td>
    <td>CNPJ</td>
    <td><div align="left"> 09058456000187 <?php // echo getValue($objRSexpositor, "cgcmf"); ?></div></td>
  </tr>
  <tr>
    <td>Bairro</td>
    <td><div align="left">Itaim Bibi<?php // echo getValue($objRSexpositor, "bairro"); ?></div></td>
    <td>Inscr. Estadual</td>
    <td><div align="left"><?php // echo getValue($objRSexpositor, "inscrest"); ?></div></td>
  </tr>
  <tr>
    <td>Cidade</td>
    <td><div align="left"> S�o Paulo <?php // echo getValue($objRSexpositor, "cidade"); ?></div></td>
    <td>Inscr. Municipal</td>
    <td><div align="left"><?php echo getValue($objRSexpositor, "inscrmunicip"); ?></div></td>
  </tr>
  <tr>
    <td>C�digo Postal</td>
    <td><div align="left"> 04534-011<?php // echo getValue($objRSexpositor, "cep"); ?></div></td>
    <td>E-Mail</td>
    <td><div align="left">cristiina.yang@mindray.com <?php // echo getValue($objRSexpositor, "email"); ?></div></td>
  </tr>
  <tr>
    <td>Pa�s</td>
    <td><div align="left"> BRASIL <?php // echo getValue($objRSexpositor, "pais"); ?></div></td>
    <td>Website</td>
    <td><div align="left"> www.mindray.com<?php // echo getValue($objRSexpositor, "website"); ?></div></td>
  </tr>
  <tr>
    <td>Nome no MAPA</td>
    <td><div align="left">MYNDRAY <?php  //echo getValue($objRSpedido, "nomemapa"); ?></div></td>
    <td>CT</td>
    <td><div align="left">PC<?php // echo getValue($objRSexpositor, "idrepre"); ?></div></td>
  </tr>
  <tr>
    <td>Marcas</td>
    <td><div align="left"><?php  echo (substr($marcasExpositor, 0, -2)  ); ?></div></td>
    <td>Produto Principal</td>
    <td><div align="left"><?php // echo getValue($objRSexpositor, "idempresa"); ?></div></td>
  </tr>
</table>

<table width="100%" border="0" class="bordasimples1">
  <tr>
    <td width="2%" valign="top"><b>II.</b></td>
    <td width="98%" align="justify"><div align="justify"><b>OBJETO DO CONTRATO:</b> A <?php echo strtoupper(getValue($objRSempresa, "erazao")); ?>, � a promotora exclusiva e �nica respons�vel pela Organiza��o, Planejamento, Promo��o e Administra��o da Feira <?php echo getValue($objRSevento, "nome_completo"); ?> - <?php echo getValue($objRSevento, "edicao"); ?>� 	<?php      if ($id_empresa == "CM"){echo "Feira Internacional de Cal�ados, Artigos Esportivos e Artefatos de Couro";} 
				  else if ($id_empresa == "HP"){echo "Feira Internacional de Produtos, Equipamentos, Servi�os e Tecnologia para Hospitais, Laborat�rios, Farm�cias, Cl�nicas e Consult�rios";}
				  else if ($id_empresa == "SP"){echo "Feira Internacional de Beleza, Cabelos e Est�tica";} ?> - 	<?php echo getValue($objRSevento,"dia_inicio")." a ". TranslateDate(getValue($objRSevento,"dt_fim")); ?> - <?php echo getValue($objRSevento,"pavilhao"); ?>, localizada na cidade de S�o Paulo/SP, sendo de sua responsabilidade exclusiva prover todos os servi�os necess�rios e/ou convenientes � realiza��o desta Feira, nos termos do Regulamento Geral, que faz parte integrante e complementar deste contrato. </div></td>
  </tr>
  <tr>
    <td valign="top"><b>1.</b></td>
    <td align="justify"><div align="justify">O EXPOSITOR participar� da Feira <?php echo getValue($objRSevento, "nome_completo"); ?> ocupando um ou mais espa�os, sem nenhum tipo de montagem, a ele disponibilizados pela
    <?php echo strtoupper(getValue($objRSempresa, "erazao")); ?>, ao pre�o de: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   . . .<b>
	
	
	R$ <?php echo number_format( getValue($objRSrenovacao, "area".$op_contrato) , 2, ',', '.'); ?> por m�</b></div></td>
  </tr>
  <tr>
    <td valign="top" ><b>2.</b></td>
    <td align="justify"><div align="justify">O EXPOSITOR providenciar� �s suas expensas exclusivas a montagem do estande, tendo a inteira liberdade de cri�-lo de acordo com o visual,
    decora��o e disposi��o desejados, obedecendo �s normas estabelecidas pelo Regulamento Geral, exceto grupos, que t�m regras espec�ficas.</div></td>
  </tr>
  <tr>
    <td valign="top"><b>3.</b></td>
    <td align="justify"><div align="justify">Energia El�trica Instalada/Obrigat�ria: Ser� cobrado neste contrato o equivalente a 0,070 KVA de energia el�trica instalada por m� no espa�o
    disponibilizado, conforme item 6.2 do Regulamento Geral, ao pre�o de: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  .  . . . .<b>R$
	<?php echo number_format( getValue($objRSrenovacao, "energia" ), 2, ',', '.'); ?> por m�</b></div></td>
  </tr>
  <tr>
    <td valign="top"><b>4.</b></td>
    <td align="justify"><div align="justify">Energia El�trica da Climatiza��o: Corresponde ao funcionamento de todo o sistema de climatiza��o, no per�odo de realiza��o da <?php echo getValue($objRSevento, "nome_completo"); ?>
    e ser� cobrado por m� juntamente com as parcelas deste contrato . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   . . . . . .<b>R$ 
	
	<?php echo number_format( getValue($objRSrenovacao, "energia_cli") , 2, ',', '.'); ?> por m�</b></div></td>
  </tr>
  <tr>
    <td><b>III.</b></td>
    <td><b>PLANO DE PAGAMENTO</b></td>
  </tr>
</table>

<table width="80%" border="0"  class="bordasimples" align="left">
  <tr>
    <td width="2%">&nbsp;</td>
    <td width="11%" align="center">N�mero de <br> Parcelas</td>
    <td width="17%" align="center">Primeiro <br>  Vencimento</td>
    <td width="20%" align="center">Desconto Comercial <br> na emiss�o da Fatura</td>
    <td width="14%" align="center"><b>Pre�o L�quido(por m�)</b></td>
    <td width="36%" align="center">Desconto Pontualidade v�lido para pagto at� o vencto do boleto banc�rio</td>
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
							 CASE WHEN (cad_renovacao_desconto.idmercado ILIKE '".$id_empresa."' ) THEN
								'3,0%'
							 ELSE
								'4,0%'         
							 END AS  desc_pontualidade
					FROM     cad_renovacao_desconto
							 INNER JOIN cad_evento
							 ON       (cad_renovacao_desconto.IDEVENTO   = cad_evento.IDEVENTO) ";

	
	
	if ($op_contrato == 1) { 
		$strSQLparcela .="WHERE    (((cad_renovacao_desconto.PARCELA) <= 5) ";
	} else {
		$strSQLparcela .="WHERE    (((cad_renovacao_desconto.PARCELA) > 5) ";
	}
	
	
	$strSQLparcela .=" AND      ((cad_renovacao_desconto.IDEVENTO)= '".$id_evento."'))
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
    <td width="2%"><?php echo getValue($objRSparcela,""); ?></td>
    <td width="11%" align="center"><?php echo sprintf("%02s",getValue($objRSparcela,"parcela")); ?></td>
    <td width="17%" align="center"><?php echo getValue($objRSparcela,"datavencimento"); ?></td>
    <td width="20%" align="center"><?php echo number_format(getValue($objRSparcela,"desconto")*100, 2, ',', '.'); ?> %</td>
    <td width="14%" align="center">R$
	 
	
	<?php  echo number_format( getValue($objRSrenovacao, ("area".$op_contrato)) - ( getValue($objRSparcela,"desconto") * getValue($objRSrenovacao, ("area".$op_contrato)) ), 2, ',', '.'); ?></td>
    <td width="36%" align="center"><?php echo getValue($objRSparcela,"desc_pontualidade"); ?></td>
  </tr>
  <?php } ?>
</table>




<table width="20%" height="122" border="0" >
  <tr>
    <td height="90%" align="center" class="bordaBox">
	<?php // athBeginFloatingBox("140","none",getTText("contatos_edicao",C_NONE),CL_CORBAR_GLASS_1); ?>
	
		<div class="b1"></div>
		<div class="b2"></div>
		<div class="b3"></div>
		<div class="b4"></div>
		<div class="b5">
		<br><br>
			<font color="#FF0000">IMPORTANTE <br>Pre�os e condi��es <br> de pagamento <br> v�lidos somente para <br> contratos renovados <br> at� <?php echo getValue($objRSeventoAtual ,"dt_fim"); ?></font>
		<br><br>
		</div>
		<div class="b4"></div>
		<div class="b3"></div>
		<div class="b2"></div>
		<div class="b1"></div>

	
	</td>
  	
	<?php // athEndFloatingBox();?>
  </tr>
</table>

<b>IV. SERVI�OS CONTRATADOS</b>
<table width="100%" border="0" class="bordasimples1" >
  <tr>
    <td><b>No caso de atraso de uma ou mais parcelas o EXPOSITOR perder� o desconto comercial concedido, sendo o mesmo incorporado nas
      parcelas restantes ou emitido boleto complementar.</b></td>
  </tr>
</table>
<table width="82%" border="0">
  <tr>
    <td width="13%"  align="left"><b>Tipo Espa�o:</b></td>
    <td width="21%"  align="left"><b>SEM MONTAGEM</b></td>
    <td width="12%"  align="left"><b>Localiza��o:</b></td>
    <td width="54%"  colspan="3" align="left"><b><?php if ($var_localizacao == ''){echo getValue($objRSpedido, "localpe").getValue($objRSpedido, "pavilhaope");} else {echo $var_localizacao; } ?></b></td>
  	
  </tr>
</table>

<table width="100%" border="0" class="bordasimples1">
  <tr>
    <td align="right">C�d.Prod.</td>
    <td align="center">Descri��o do Produto</td>
    <td align="center">Unid.</td>
    <td align="right">Quantid.</td>
    <td align="right">Pre�o Unit. Bruto</td>
    <td align="right">Valor Total Bruto</td>
  </tr>
<?php
	//BUSCA OS DADOS DADOS DE RENOVA��O DO EVENTO
	
	//  $strSQLprodutos = "select * from ped_pedidos_renovacao_evento a where a.idpedido = '".getValue($objRSpedido ,"idpedido")."' AND idempresa ilike '".$id_empresa."' order by idproduto";	
		
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
	  foreach($objResultprodutos as $objRSprodutos){ 
	
?>
   <tr>
    <td align="right"><?php echo getValue($objRSprodutos,"idproduto"); ?></td>
    <td align="left"><?php echo getValue($objRSprodutos,"descrpedido"); ?></td>
    <td align="center"><?php echo getValue($objRSprodutos,"unidpedido"); ?></td>
    <td align="right"><?php echo number_format(getValue($objRSprodutos,"quant_pedi"), 2, ',', '.'); ?></td>
    <td align="right">
	<?php 
	
	//die(getValue($objRSprodutos,"idproduto"));

	if ((getValue($objRSprodutos,"idproduto")) == 'AR0001' && ($op_contrato == '1')){
					echo '677,00';
			} else if ((getValue($objRSprodutos,"idproduto") == 'AR0001') && ($op_contrato == '2')){
					echo '716,00';
			} else { 
					echo number_format(getValue($objRSprodutos,"preco_pedi"), 2, ',', '.');
			};
	?>
	
	<?php // echo number_format(getValue($objRSprodutos,"preco_pedi"), 2, ',', '.'); ?></td>
    <td align="right"><?php
	if ((getValue($objRSprodutos,"idproduto")) == 'AR0001' && ($op_contrato == '1')){
					
				$valor_area_total = (getValue($objRSprodutos,"quant_pedi") * 677);
					echo number_format($valor_area_total, 2, ',', '.');
			} else if ((getValue($objRSprodutos,"idproduto") == 'AR0001') && ($op_contrato == '2')){
						
				$valor_area_total = (getValue($objRSprodutos,"quant_pedi") * 716);
					echo number_format($valor_area_total, 2, ',', '.');
			} else { 
					 $valor_area_total = getValue($objRSprodutos,"sub_total");
					 echo number_format($valor_area_total, 2, ',', '.');
			};
	
	
	?>
	<?php // echo number_format(getValue($objRSprodutos,"sub_total"), 2, ',', '.'); ?></td>
  </tr>
<?php $valor_total_bruto = $valor_total_bruto + $valor_area_total; } ?>
</table>




<table width="100%" border="0" class="bordasimples">
  <tr>
    <td width="2%" style="border-bottom:none; border-left:none; border-right:none"><b>V.</b></td>
    <td width="66%" style="border-bottom:none; border-left:none; border-right:none"><b>DISPOSI��ES FINAIS</b></td>
	<td width="32%"  align="right"style="border-bottom:none; border-left:none; border-right:none">Valor Total Bruto:....<?php echo number_format($valor_total_bruto, 2, ',', '.'); ?></td>
  </tr>
</table>

<table width="100%" border="0" class="bordasimples1">
  <tr>
    <td valign="top" align="justify"><b>1.</b></td>
    <td align="justify"><div align="justify">O EXPOSITOR compromete-se a pagar o valor de R$ <?php echo number_format($valor_total_bruto, 2, ',', '.'); ?> ( <?php echo valorPorExtenso($valor_total_bruto); ?> ), sobre o qual incidir� o desconto comercial de ___% referente ao valor do espa�o sem montagem, em ___ parcela(s) mensal(ais), com primeiro vencimento em ___/___/___ . Para pagamento na data do vencimento, se aplicar� o desconto de pontualidade de ___% no boleto banc�rio.</div></td>
  </tr>
  <tr>
    <td valign="top"><b>2.</b></td>
    <td align="justify"><div align="justify">O EXPOSITOR autoriza expressamente a <?php echo strtoupper(getValue($objRSempresa, "erazao")); ?> a emitir os boletos de cobran�a banc�ria, origin�rios do presente contrato, com vencimento
    nas datas acima, bem como a emiss�o das notas fiscais de Organiza��o, Planejamento, Promo��o e Administra��o da Feira <?php echo getValue($objRSevento, "nome_completo"); ?>.</div></td>
  </tr>
  <tr>
    <td valign="top"><b>3.</b></td>
    <td align="justify"><div align="justify">O EXPOSITOR compromete-se a cumprir o Regulamento Geral da Feira <?php echo getValue($objRSevento, "nome_completo"); ?>, que � parte integrante e complementar deste contrato,
    do qual recebe uma c�pia e tem ci�ncia.</div></td>
  </tr>
  <tr>
    <td valign="top"><b>4.</b></td>
    <td align="justify"><div align="justify">Segundo o Item III do presente contrato, o Plano de Pagamento dever� estar plenamente quitado para participa��o e ingresso na feira.</div></td>
  </tr>
  <tr>
    <td valign="top"><b>5.</b></td>
    <td align="justify"><div align="justify">Servi�os Adicionais necess�rios e/ou convenientes � participa��o do EXPOSITOR na Feira, tais como: energia el�trica adicional instalada em KVA, limpeza, seguran�a e ponto d'�gua ter�o seus pre�os definidos em circular espec�fica, pag�veis pelo EXPOSITOR at� a data de 28/<?php  echo getValue($objRSeventoAtual,"data_venc_mes")."/".(getValue($objRSeventoAtual,"data_venc_ano")+1) ;  ?>.</div></td>
  </tr>
  <tr>
    <td valign="top"><b>6.</b></td>
    <td align="justify"><div align="justify">Fica acordado entre as partes que a qualquer momento poder� ser aditado o contrato para modificar a cl�usula de pre�o e condi��es, de forma a
    manter o equil�brio econ�mico e financeiro deste contrato.</div></td>
  </tr>
  <tr>
    <td valign="top"><b>7.</b></td>
    <td align="justify"><div align="justify">Os Contratantes elegem o Foro da Capital do Estado S�o Paulo, onde ser� realizada a Feira, para dirimirem quaisquer d�vidas provenientes da
      execu��o e cumprimento deste contrato. <br>
      Este contrato dever� ser assinado e enviado no prazo m�ximo de 3 dias ap�s a sua emiss�o e estar� sujeito a aprova��o do Departamento
    Financeiro da <?php echo strtoupper(getValue($objRSempresa, "erazao")); ?>. E, por estarem justas e contratadas, as partes assinam o presente contrato em duas vias de igual teor e forma. </div></td>
  </tr>
</table>

Nome/Cargo de quem autorizou o contrato:_____________________________________________________ Data: ____/____/_____ <br>
CPF:_______________________________ RG:________________________________ <br>

<table class="bordasimples1" width="100%" border="0">
  <tr>
    <td width="44%" valign="bottom" align="center">___________________________________________________</td>
    <td width="7%">&nbsp;</td>
    <td width="49%" valign="bottom" align="center">___________________________________________________</td>
  </tr>
  <tr>
    <td align="center">MINDRAY DO BRASIL - COM E DISTR DE EQUIO M�DICOS LTDA.<?php // echo strtoupper(getValue($objRSexpositor, "razao")); ?></td>
    <td>&nbsp;</td>
    <td align="center"><?php echo strtoupper(getValue($objRSempresa, "erazao")); ?></td>
  </tr>
</table>

</body>
</html>
<?php $objConn = NULL; ?>
