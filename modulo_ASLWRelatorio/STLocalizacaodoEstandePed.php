<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

$objConn 			= abreDBConn(CFG_DB); // Abertura de banco	
$id_evento 			= getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa 		= getsession(CFG_SYSTEM_NAME."_id_mercado"); 
$datawide_lang 		= getsession("datawide_lang");



/***            VERIFICA��O DE ACESSO              ***/
/*****************************************************/
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
$strPopulate = ( request("var_populate") == "" ) ? "yes" : request("var_populate");
if($strPopulate == "yes") { initModuloParams(basename(getcwd())); } //Popula o session para fazer a abertura dos �tens do m�dulo
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app"),"VIE"); //Verifica��o de acesso do usu�rio corrente


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

// Fun��o M�s Extenso
$mes = date('m');
switch ($mes){
case 1: $mes = "Janeiro"; break;
case 2: $mes = "Fevereiro"; break;
case 3: $mes = "Mar�o"; break;
case 4: $mes = "Abril"; break;
case 5: $mes = "Maio"; break;
case 6: $mes = "Junho"; break;
case 7: $mes = "Julho"; break;
case 8: $mes = "Agosto"; break;
case 9: $mes = "Setembro"; break;
case 10: $mes = "Outubro"; break;
case 11: $mes = "Novembro"; break;
case 12: $mes = "Dezembro"; break;}

include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

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
table.bordasimples {border-collapse: collapse;}
table.bordasimples tr td {border:1px solid #000000;}
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
</head>
<body style="margin:10px 0px 10px 0px;" >

  	<?php  
  
	try{
	// SQL Principal	
	$strSQL = "SELECT
				  ped_pedidos.evento3
				  , cad_cadastro.codigo
				  
				  ,date_part('day', dt_inicio ) || '/'|| date_part('month', dt_inicio ) as dt_inicio
				  ,date_part('day', dt_fim ) || '/'|| date_part('month', dt_fim ) || '/' || date_part('year', dt_fim ) as dt_fim  
				
				  , ped_pedidos.idpedido
				  , cad_cadastro.razao
				  , cad_cadastro.fantasia
				  , cad_cadastro.endereco
				  , cad_cadastro.bairro
				  , cad_cadastro.cidade
				  , cad_cadastro.estado
				  , cad_cadastro.cep
				  , cad_cadastro.pais
				
				  ,date_part('day', cad_evento.dt_inicio ) as dia_inicio
				  ,date_part('day', cad_evento.dt_fim ) as dia_fim
				  ,date_part('month', cad_evento.dt_fim ) as mes_fim
				  ,date_part('year', cad_evento.dt_fim ) as ano_fim
				  
				  , cad_cadastro.cgcmf
				  , cad_cadastro.telefone1
				  , cad_cadastro.telefone2
				  , cad_cadastro.telefone3
				  , cad_cadastro.telefone4
				  , cad_cadastro.website
				  , cad_cadastro.email
				  , cad_cadastro.lista_prodp
				  , cad_cadastro.lista_prodi
				  , cad_evento.nome_completo
				  , cad_evento.edicao
				  , ped_pedidos.largurape AS w
				  , cad_evento.pavilhao --local
				  , ped_pedidos.comprimentope AS comprimento
				  , ped_pedidos.areape AS area
				  
				  , ped_pedidos.localpe || CASE WHEN (cad_pavilhao.descrpavilhao) IS NULL THEN
															NULL
													ELSE ' - ' || cad_pavilhao.descrpavilhao 
													END AS localiz  

				  , cad_areas.descrarea
				  , cad_empresa.efantasia
				  , cad_evento.figura1
				  , cad_empresa.erodape
				  , cad_evento.rodape
				  , ped_pedidos.evento2
				FROM 
					cad_evento 
				INNER JOIN
				  ((((cad_cadastro
				INNER JOIN
				  ped_pedidos 
				ON (cad_cadastro.idmercado = ped_pedidos.idmercado) 
				  AND (cad_cadastro.codigo = ped_pedidos.codigope)) 
				LEFT JOIN
				  cad_pavilhao 
				ON ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao) 
				LEFT JOIN
				  cad_areas 
					ON ped_pedidos.tipope = cad_areas.idarea)
				INNER JOIN
				  cad_empresa 
				ON ped_pedidos.idmercado = cad_empresa.idmercado) 
				ON cad_evento.idevento = ped_pedidos.idevento
				WHERE ped_pedidos.idevento = '".$id_evento."'
				  AND  ped_pedidos.excluida = false 
				  AND  (ped_pedidos.idstatus <> '005' 
					AND  ped_pedidos.idstatus <> '100')  
				ORDER by cad_cadastro.razao";

			$objResult = $objConn->query($strSQL); // execu��o da query
			}catch(PDOException $e){
					mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
					die();
			}
			foreach($objResult as $objRS){
			?>

<table align="center" bgcolor="#FFFFFF" width="100%" border="0">
  	<tr>
		<td  align="center"  >
			<?php  
			  //$url = '../img/logos/cab_'.$datawide_lang.'_'.$id_evento.'.jpg';  
			  /*Mudan�a do cabe�alho/rodap� ficarem dentro da pasta do cliente. By Lumertz  - 09.07.2013*/ 
              $url = '../../'.getsession(CFG_SYSTEM_NAME."_dir_cliente").'/upload/imgdin/rod_'.$datawide_lang.'_'.$id_evento.'.jpg';   
			?>
			<img width="600" height="80" src= "<?php echo $url ?>";>   
		</td>	
  	</tr>
  	<tr>  
    	<td colspan="2" align="center"> 
			<font size=4> <br> <?php echo getValue($objRS,"nome_completo"); ?> - <?php echo getValue($objRS,"pavilhao"); ?> <BR></font>
		</td>
  	</tr>
  	<tr>
    	<td colspan="2" align="center"> <font size=3> <?php echo getValue($objRS,"dt_inicio"); ?> a <?php echo getValue($objRS,"dt_fim"); ?> </font></td>
  	</tr>
  	<tr>
    	<td colspan="2" align="left"> <font size=2><br><br>S�o Paulo, <?php echo $mes; ?> de <?php echo date("Y"); ?></font><br><br><br><br></td>
  	</tr>
  	<tr>
    	<td colspan="2"><br><font size=2>�</font></td>
  	</tr>
  	<tr>
    	<td width="24%"><font size=2><b><?php echo getValue($objRS,"razao"); ?>     </b></font></td>	
    	<td width="76%" align="left"> <font size=2><b><?php echo getValue($objRS,"codigo"); ?> </td>
  	</tr>
  	<tr>
    	<td colspan="2"><font size=2><b><?php echo getValue($objRS,"endereco"); ?> - <?php echo getValue($objRS,"bairro"); ?></b><br></font></td>
  	</tr>
  	<tr>
		<td colspan="2"><font size=2><b><?php echo getValue($objRS,"cep"); ?> - <?php echo getValue($objRS,"estado"); ?> - <?php echo getValue($objRS,"pais"); ?> <br><br></b></font></td>
	</tr>
  	<tr>
  		<td colspan="2"><font size=2>Ref.: <b>  LOCALIZA��O DO SEU ESTANDE NA <?php echo getValue($objRS,"nome_completo"); ?></b><br><br></font></td>
  	</tr>
  	<tr>
  		<td colspan="2"><font size=2>Senhor Expositor,</font></td>  	 
  	</tr>
  	<tr>
  		<td colspan="2">
			<font size=2>Gostariamos de inform�-lo que seu estande na <?php echo getValue($objRS,"nome_completo"); ?>  est� localizado conforme dados abaixo:</font><BR><BR>
  	  		<table align="center" bgcolor="#FFFFFF" width="90%" border="1">
				<tr>
	 				<td style="border:none;">
						<font size=2>LOCALIZA��O: <b><?php echo getValue($objRS,"localiz") ?></b><BR>TIPO DE �REA:</font><font size="2" color="#FF0000"> <b><?php echo getValue($objRS,"descrarea") ?></b></font><br>
					</td>
				</tr>
				<tr>
	 				<td align="center" style="border:none;">
						<font size=2><b>METRAGEM DO ESTANDE</b><BR><b> <?php echo number_format(getValue($objRS,"w"),2, '.', '') ; ?>  metros de frente X 
		     			<?php echo number_format(getValue($objRS,"comprimento"),2, '.', '') ; ?> metros de fundo = 
			 			<?php echo number_format(getValue($objRS,"area"),2, '.', '') ; ?> m�</b>
	 					</font>
	 				</td>
				</tr>
			</table>
	
			<BR><BR><BR><BR><font size="2">
			Para melhor visualiza��o, segue anexa planta baixa do evento, com a demarca��o do espa�o de sua empresa.<br><br>
			Colocamo-nos ao seu inteiro dispor para qualquer esclarecimento adicional.<br><br>
			Atenciosamente,</font>
			<BR>
			<BR>
			<BR>
			<BR>
			<BR>
			<BR>
			<BR>	
			<BR>
			<BR>
			<BR>
			<BR>
			<BR>	
			<BR>
			<BR>
			<BR>
			<BR>
			<BR>
			<BR>
			<BR>	
			<BR>
			<BR>
			<BR>
			<BR>	
			<BR>
			<BR>
			<BR>	
			<BR>
			<BR>
			<BR>
	<hr>
		</td>
	</tr>
	<tr align="center">
		<td colspan="2" >
			<?php  $url = '../img/logos/rod_'.$datawide_lang.'_'.$id_evento.'.jpg';  ?>
			<img style="position:relative" width="580" height="30" src= "<?php echo $url ?>";>				
		</td>
	</tr>
	<tr><td colspan="2" height="30"></td></tr>
	<tr><td><br style="page-break-after:always;" ></td></tr>

  <?php } ?>
</table>
</body>
</html>
<?php $objConn = NULL; ?>