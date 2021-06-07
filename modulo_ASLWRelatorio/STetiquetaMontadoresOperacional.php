<?php

/* *********CONFIGURA��O DA P�GINA PARA IMPRESS�O DE ETIQUETAS **************/
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


$var_empresa = request("var_empresa");
$var_estado  = request("var_estado");
$id_evento = getsession(CFG_SYSTEM_NAME."_id_evento"); 



/***            VERIFICA��O DE ACESSO              ***/
/*****************************************************/
//$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
//verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verifica��o de acesso do usu�rio corrente



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

			
  $strSQL = " SELECT DISTINCT '<strong>' ||cad_montador.nomemont || '</strong>' AS razao_social
                    , cad_montador.contato AS contato 
					, cad_montador.endereco AS endereco1
					, cad_montador.bairro || ' - ' || cad_montador.cidade || ' - ' || cad_montador.estado || ' - ' || cad_montador.pais AS endereco2
					, cad_montador.cep  AS cep
			 FROM cad_montador INNER JOIN ped_servico ON cad_montador.idmont = ped_servico.idmontse 
  			 WHERE ped_servico.ideventose = '".$id_evento."' 
			 ORDER BY 1
  
  
  
  			";
			
			try{
			$objResult = $objConn->query($strSQL); // execu��o da query		
						
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


<?php  if ($var_lado == true) { $var_lado = false; ?>

<table width="45%" border="0" align="left">  
  <tr>
     <td width="16%">&nbsp;</td>
     <td width="84%"><div class="campos" ><b><?php echo getValue($objRS,"razao_social"); ?></b></div></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%" style="overflow:hidden"><div class="campos" ><b><?php echo getValue($objRS,"contato"); ?></b></div></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%" style="overflow:hidden"><?php echo getValue($objRS,"endereco1"); ?></td>
  </tr>
  <tr>
	<td width="16%">&nbsp;</td>
	<td width="84%" style="overflow:hidden"><B><?php echo getValue($objRS,"cep"); ?></B>&nbsp;&nbsp;<?php echo getValue($objRS,"endereco2");?>
	</td>
  </tr>
</table>

  <?php } else {  $var_lado = true; $var_cont++;?>
  
 

  
<table width="55%" border="0" >  
  <tr>
     <td width="16%">&nbsp;</td>
     <td width="84%"><div class="campos" ><b><?php echo getValue($objRS,"razao_social"); ?></b></div></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%" style="overflow:hidden"><div class="campos" ><b><?php echo getValue($objRS,"contato"); ?></b></div></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%" style="overflow:hidden"><?php echo getValue($objRS,"endereco1"); ?></td>
  </tr>
  <tr>
	<td width="16%">&nbsp;</td>
	<td width="84%" style="overflow:hidden"><B><?php echo getValue($objRS,"cep"); ?></B>&nbsp;&nbsp;<?php echo getValue($objRS,"endereco2");?></td>
  </tr>
</table>


<table width="100%" border="0">
  <tr>
  	<!--MODELO 1 -  26,5px -->
	<!--MODELO 2 -  27,5px -->
    <td height="27,5px">&nbsp;</td>
  </tr>
</table>




<?php } ?>

<?php } ?>  

</body>
</html>
<?php $objConn = NULL; ?>

</body>
</html>
<?php $objConn = NULL; ?>
