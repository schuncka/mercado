<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$dt_inicio = request("dt_inicio");
$dt_final = request("dt_final");


/***            VERIFICA��O DE ACESSO              ***/
/*****************************************************/
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verifica��o de acesso do usu�rio corrente



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

table.bordasimples {border-collapse: collapse;}
table.bordasimples tr td {border:1px solid #000000;}


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
    page-break-before: always;
}
</style>
</head>
<body style="margin:10px 0px 10px 0px;" >
<?php
$contador = 0;

			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = "SELECT DISTINCT
													   cad_empresa.efantasia
												FROM 
													(cad_evento 
													RIGHT JOIN 
													((ped_pedidos 
													LEFT JOIN 
													cad_empresa 
														ON ped_pedidos.idmercado = cad_empresa.idmercado) 
													LEFT JOIN 
													cad_pavilhao 
														ON ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao) 
														ON cad_evento.idevento = ped_pedidos.idevento) 
													INNER JOIN 
													ped_pedidos_cancelamentos 
														ON (ped_pedidos.idmercado = ped_pedidos_cancelamentos.idmercado) 
														AND (ped_pedidos.idpedido = ped_pedidos_cancelamentos.idpedido)
												WHERE 
													((ped_pedidos.idmercado ilike '".$id_empresa."') 
														AND (ped_pedidos_cancelamentos.dataproc 
														Between to_date( '$dt_inicio', 'DD/MM/YYYY') 
														AND to_date( '$dt_final', 'DD/MM/YYYY')));";
											
							$objResult = $objConn->query($strSQL); // execu��o da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  	foreach($objResult as $objRS){
				
			  ?>

<table  width="100%" border="0" bgcolor="#FFFFFF">
  <tr>
    <td width="70%" height="35" align="left" valign="top"><font size="4"><?php echo getValue($objRS,"efantasia") ?> </font></td>
    <td width="30%" valign="top"><font size="3"> Contratos Cancelados no Per�odo </font></td>
  </tr>
  <tr>
    <td colspan="2"><b> Posi��o at� <?PHP echo date("d/m/Y"); ?>   <?PHP echo date("H:i:s"); ?> </b></td>
  </tr>
</table>
<br>
<table width="100%" border="0" bgcolor="#FFFFFF" class="bordasimples" >
  <tr>
    <td width="5%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Contrato</td>
    <td width="6%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Data Canc</td>
    <td width="6%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Solicitante</td>
    <td width="6%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Autorizado</td>
    <td width="29%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Raz�o Social</td>
    <td width="11%" align="right" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Total do Contrato</td>
    <td width="11%" align="center" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Valor j� Faturado</td>
    <td width="11%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Saldo a Faturar</td>
    <td width="14%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">�rea Localiza��o</td>		
  </tr>
</table>
<?PHP }?>

<?PHP
$total = 0;
$valor = 0;
$final = 0;

			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = "SELECT DISTINCT 
											   cad_evento.nome_completo,
											   ped_pedidos.idevento
										FROM 
											(cad_evento 
											RIGHT JOIN 
											((ped_pedidos 
											LEFT JOIN 
											cad_empresa 
												ON ped_pedidos.idmercado = cad_empresa.idmercado) 
											LEFT JOIN 
											cad_pavilhao 
												ON ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao) 
												ON cad_evento.idevento = ped_pedidos.idevento) 
											INNER JOIN 
											ped_pedidos_cancelamentos 
												ON (ped_pedidos.idmercado = ped_pedidos_cancelamentos.idmercado) 
												AND (ped_pedidos.idpedido = ped_pedidos_cancelamentos.idpedido)
										WHERE 
												((ped_pedidos.idmercado ilike '".$id_empresa."') 
													AND (ped_pedidos_cancelamentos.dataproc 
													Between to_date( '$dt_inicio', 'DD/MM/YYYY') 
													AND to_date( '$dt_final', 'DD/MM/YYYY')));";
											
							$objResult = $objConn->query($strSQL); // execu��o da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
					$total = 0;
			  	foreach($objResult as $objRS){
					$idevento = getValue($objRS,"idevento");
			  ?>

<table width="100%" border="0">
  <tr>
    <td width="100%" align="left" bgcolor="#000000"><font size="2" color="#FFFFFF"><b> <?php echo getValue($objRS,"nome_completo"); $contador = $contador + 2; ?> </b></font> </td>
  </tr>
</table>
<?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = "SELECT 
											   cad_empresa.efantasia, 
											   ped_pedidos.idevento, 
											   ped_pedidos.idmercado, 
											   cad_evento.nome_completo, 
											   ped_pedidos.codigope, 
											   ped_pedidos.datape, 
											   ped_pedidos_cancelamentos.dataproc, 
											   ped_pedidos.idpedido, 
											   ped_pedidos.razaope,
											   ped_pedidos_cancelamentos.vlratual, 
											   ped_pedidos_cancelamentos.vlrfatur, 
											   ped_pedidos_cancelamentos.diferenca, 
											   ped_pedidos.areape, 
											   ped_pedidos.localpe, 
											   cad_pavilhao.descrpavilhao, 
											   ped_pedidos_cancelamentos.logonsolic, 
											   ped_pedidos_cancelamentos.logon, 
											   to_char(ped_pedidos_cancelamentos.dataproc, 'DD/MM/YY') as dataproc
										FROM 
											(cad_evento 
											RIGHT JOIN 
											((ped_pedidos 
											LEFT JOIN 
											cad_empresa 
												ON ped_pedidos.idmercado = cad_empresa.idmercado) 
											LEFT JOIN 
											cad_pavilhao 
												ON ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao) 
												ON cad_evento.idevento = ped_pedidos.idevento) 
											INNER JOIN 
											ped_pedidos_cancelamentos 
												ON (ped_pedidos.idmercado = ped_pedidos_cancelamentos.idmercado) 
												AND (ped_pedidos.idpedido = ped_pedidos_cancelamentos.idpedido)
										WHERE 
												((ped_pedidos.idevento ILIKE '$idevento')
												AND (ped_pedidos.idmercado ILIKE '".$id_empresa."') 
												AND (ped_pedidos_cancelamentos.dataproc 
												Between to_date( '$dt_inicio', 'DD/MM/YYYY') 
												AND to_date( '$dt_final', 'DD/MM/YYYY')));";
											
							$objResult = $objConn->query($strSQL); // execu��o da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  	foreach($objResult as $objRS){
					$valor = getValue($objRS,"diferenca") 
					
			  ?>
			  
			  
		<?PHP
		if ($contador >= 38){ 
		$contador = 0;
		?>			
		
		<div class="folha"> </div>	
		
		<table width="100%" border="0" bgcolor="#FFFFFF" class="bordasimples" >
		  <tr>
			<td width="5%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Contrato</td>
			<td width="6%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Data Canc</td>
			<td width="6%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Solicitante</td>
			<td width="6%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Autorizado</td>
			<td width="29%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Raz�o Social</td>
			<td width="11%" align="right" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Total do Contrato</td>
			<td width="11%" align="center" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Valor j� Faturado</td>
			<td width="11%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Saldo a Faturar</td>
			<td width="14%" style="border-right:none; border-left:none; border-top:none; border-bottom:none">�rea Localiza��o</td>		
		  </tr>
		</table>			
		<hr>		
			
		<?PHP }	?>	
		 			  
			  
<table width="100%" border="0" bgcolor="#FFFFFF" class="bordasimples">
  <tr>
    <td width="6%" style="border-right:none; border-left:none; border-top:none; border-bottom:none" ><?php echo getValue($objRS,"idpedido"); ?>    <?PHP $contador++; ?></td>
    <td width="6%" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><?php echo getValue($objRS,"dataproc") ?></td>
    <td width="5%" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><?php echo getValue($objRS,"logonsolic") ?></td>
    <td width="5%" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><?php echo getValue($objRS,"logon") ?></td>
	<td width="34%" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><?php echo getValue($objRS,"razaope") ?></td>
	<td width="8%" align="right" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><?php echo number_format(getValue($objRS,"vlratual"), 2, ',', '.') ?></td>
	<td width="9%" align="right" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><?php echo number_format(getValue($objRS,"vlrfatur"), 2, ',', '.') ?></td>
	<td width="9%" align="right" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><?php echo number_format(getValue($objRS,"diferenca"), 2, ',', '.') ?></td>
	<td width="4%" align="right" style="border-right:none; border-left:none; border-top:none; border-bottom:none">&nbsp; </td>	
	<td width="14%" align="left" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><?php echo getValue($objRS,"areape") ?>m2 <?php echo getValue($objRS,"localpe") ?> </td>
  </tr>
</table >
  	 <?php $total = $total + $valor;?>	
<?php } ?>
<hr>
<table width="100%" border="0">
  <tr>
    <td width="73%"> <?php $final = $final + $total; $contador = $contador + 5 ?>	Redu��o no saldo a faturar do evento de: </td>
    <td width="9%" align="right"> <?php echo  number_format(($total), 2, ',', '.') ?> </td>
	<td width="18%">&nbsp;</td>
  </tr>
</table>
<br>
<br>
<?php } ?>
<hr>
<table width="100%" border="0">
  <tr>
    <td width="73%">
		Redu��o no saldo a faturar total:		</td>
    <td width="9%" align="right"><?php echo  number_format(($final), 2, ',', '.') ?></td>
	<td width="18%">&nbsp;  </td>
  </tr>
</table>
<hr>
</body>
</html>
<?php $objConn = NULL; ?>
