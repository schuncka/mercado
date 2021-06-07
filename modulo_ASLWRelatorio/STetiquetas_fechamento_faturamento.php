<?php

/* *********CONFIGURAÇÃO DA PÁGINA PARA IMPRESSÃO DE ETIQUETAS **************/
/* ************ Margem Superior =  15,05 Milimitros *************************/
/* ************ Margem Inferior =  15,05 Milimitros *************************/
/* ************ Margem Esquerda =  15,05 Milimitros *************************/
/* ************ Margem Direita  =  19,05 Milimitros *************************/
/* **************************************************************************/

include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

$strIDMercado = request("var_idmercado");
$strIDEvento  = request("var_idevento");

/***            VERIFICAÇÃO DE ACESSO              ***/
/*****************************************************/
//$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
//verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verificação de acesso do usuário corrente



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
$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc");

//Exportação para excel, word e adobe reader
if($boolIsExportation) {
	//Coloca o cabeçalho de download do arquivo no formato especificado de exportação
	header("Content-type: application/force-download"); 
	header("Content-Disposition: attachment; filename=Modulo_" . getTText(getsession($strSesPfx . "_titulo"),C_NONE) . "_". time() . $strAcao);
	
	$strLimitOffSet = "";
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
.tdicon{
		text-align:center;
		font-size:11px;
		font:bold;
		width:25%;		
}
img{
	border:none;
}

.folha {
    page-break-after: always;
}

.campos{
	border:0px solid #000000;
	height:10px;
	width:333px;
	overflow: hidden;
/*	font-size: 15px;
	font-family:Arial, Helvetica, sans-serif;
	font-weight:bold;	*/
} 
</style>
</head>
<body style="margin-top:50px; margin-left:15px">
<?php	  
$objConn = abreDBConn(CFG_DB); // Abertura de banco

//EFETUA A BUSCA DAS ETIQUETAS
$strSQL = "	SELECT DISTINCT t3.codigo
				 , t3.razaocob1 AS razao
				 , t3.enderecocob1 || CASE WHEN (t3.bairrocob1 IS NULL) THEN NULL ELSE ' - ' || t3.bairrocob1 END AS endereco
				 , t3.cidadecob1 || '/' || t3.estadocob1 AS cidade
				 , t3.cepcob1 AS cep
				 , t3.nomecont1 AS nome_contato
			FROM ped_pedidos t1 
			INNER JOIN ped_pedidos_parcelamento t2 ON (t1.idpedido = t2.idpedido AND t1.idmercado = t2.idmercado) 
			INNER JOIN cad_cadastro t3 ON (t1.codigope = t3.codigo AND t1.idmercado = t3.idmercado)
			WHERE t1.idmercado ILIKE '".$strIDMercado."' 
			AND t1.idevento = '".$strIDEvento."' 
			AND t1.modelpe = 'taxa' 
			AND t1.idstatus NOT IN ('005','100') 
			AND (t1.excluida = FALSE OR t1.excluida IS NULL) 
			AND (t2.nronf IS NULL OR t2.nronf = '') 
			AND t2.datafat IS NULL 
			AND t3.razaocob1 IS NOT NULL
			ORDER BY t3.razaocob1 ";
try{
	$objResult = $objConn->query($strSQL); // execução da query		
				
	}catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
	}
$var_lado = true;
$var_cont = 0;

foreach($objResult as $objRS){
	//$codigo_pedido = getValue($objRS,"idpedido");		  
	?>			  

<?php if ($var_cont == 10) {echo "<div class='folha'></div>"; $var_cont = 0;}?>


<?php  if ($var_lado == true) { 
	$var_lado = false; 
	?>

<table width="45%" border="0" align="left">  
  <tr>
     <td width="45%" ><div class="campos" ><b><?php echo getValue($objRS,"razao"); ?></b></div></td>
  </tr>
  <tr>
    <td width="45%" style="overflow:hidden"><?php echo getValue($objRS,"endereco"); ?></td>
  </tr>
  <tr>
    <td width="45%" style="overflow:hidden"><?php echo getValue($objRS,"cidade"); ?></td>
  </tr>
	<tr>
    <td width="45%" style="overflow:hidden"><b><?php echo getValue($objRS,"cep"); ?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo getValue($objRS,"nome_contato"); ?> </b></td>
  </tr>
</table>
<?php } 
  else {  
	  	$var_lado = true; 
		$var_cont++;
?>
<table width="55%" border="0" >  
  <tr>
     <td width="16%">&nbsp;</td>
     <td width="84%"><div class="campos"><b><?php echo getValue($objRS,"razao"); ?></b></div></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%" style="overflow:hidden"><?php echo getValue($objRS,"endereco"); ?></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%" style="overflow:hidden"><?php echo getValue($objRS,"cidade"); ?></td>
  </tr>
	<tr>    <td width="16%">&nbsp;</td>
      <td width="84%" style="overflow:hidden"> <b><?php echo getValue($objRS,"cep"); ?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo getValue($objRS,"nome_contato"); ?></b></td>
  </tr>
</table>
<table width="100%" border="0">
  <tr>
    <td height="26,5px">&nbsp;</td>
  </tr>
</table>
<?php	 } ?>
<?php } ?>  
</body>
</html>
<?php $objConn = NULL; ?>
<script language="javascript">
window.print();
</script>