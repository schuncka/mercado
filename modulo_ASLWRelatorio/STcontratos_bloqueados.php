<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");

/***            VERIFICAÇÃO DE ACESSO              ***/
/*****************************************************/
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verificação de acesso do usuário corrente



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

			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = "SELECT DISTINCT 
													cad_empresa.erazao 
												FROM 
													cad_empresa 
													INNER JOIN 
													ped_pedidos 
														ON cad_empresa.idmercado = ped_pedidos.idmercado
													INNER JOIN 
													cad_evento 
														ON ped_pedidos.idevento = cad_evento.idevento
												WHERE 
													cad_empresa.idmercado ilike '".$id_empresa."'
													AND ped_pedidos.bloqueado = TRUE 
													AND ped_pedidos.excluida = FALSE;";
											
							$objResult = $objConn->query($strSQL); // execução da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  	foreach($objResult as $objRS){
				
			  ?>

<table  width="100%" border="0" bgcolor="#FFFFFF">
  <tr>
    <td width="70%" height="35" align="left" valign="top"><font size="4"><b> <?php echo getValue($objRS,"erazao") ?> </b></font></td>
    <td width="30%" valign="top"><font size="3"><b> Contratos Bloqueados </b></font></td>
  </tr>
  <tr>
    <td colspan="2">Posição em <?PHP echo date("d/m/Y"); ?>   <?PHP echo date("H:i:s"); ?></td>
  </tr>
</table>
<?PHP }?>

<?php
$total = 0;

			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = "SELECT DISTINCT 
											cad_empresa.erazao, 
											cad_evento.nome_completo, 
											ped_pedidos.idevento
										FROM 
											cad_empresa 
											INNER JOIN 
											ped_pedidos 
												ON cad_empresa.idmercado = ped_pedidos.idmercado
											INNER JOIN 
											cad_evento 
												ON ped_pedidos.idevento = cad_evento.idevento
										WHERE 
											cad_empresa.idmercado ilike '".$id_empresa."'
											AND ped_pedidos.bloqueado = TRUE 
											AND ped_pedidos.excluida = FALSE
										ORDER BY
                                        	ped_pedidos.idevento;";
											
							$objResult = $objConn->query($strSQL); // execução da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  	foreach($objResult as $objRS){
				
					$idevento = getValue($objRS,"idevento");
					$cont = 0;
			  ?>

<table width="100%" border="0" bgcolor="#FFFFFF" class="bordasimples" >
  <tr>
    <td width="10%" style="border-right:none; border-left:none">Código</td>
    <td width="10%" style="border-right:none; border-left:none">Pedido</td>
    <td width="75%" style="border-right:none; border-left:none">Razão Social</td>
    <td width="5%" style="border-right:none; border-left:none">Repres.</td>
  </tr>
</table>
<table width="40%" border="0">
  <tr>
    <td width="40%" align="left" bgcolor="#000000"><font size="4" color="#FFFFFF"><b> <?php echo getValue($objRS,"nome_completo") ?> </b></font> </td>
  </tr>
</table>
<br>
<?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = "SELECT 
											cad_empresa.erazao, 
											cad_evento.nome_completo, 
											cad_empresa.idmercado, 
											ped_pedidos.codigope, 
											ped_pedidos.idpedido, 
											ped_pedidos.idmercado, 
											ped_pedidos.razaope, 
											ped_pedidos.bloqueado, 
											ped_pedidos.idreprepe,
											ped_pedidos.idevento
										FROM 
											(cad_empresa 
											INNER JOIN 
											ped_pedidos 
												ON cad_empresa.idmercado = ped_pedidos.idmercado) 
											INNER JOIN 
											cad_evento 
												ON ped_pedidos.idevento = cad_evento.idevento
										WHERE 
											((cad_empresa.idmercado ILIKE '".$id_empresa."') 
											AND (ped_pedidos.bloqueado = True) 
											AND (ped_pedidos.excluida = False)
											AND (ped_pedidos.idevento = '$idevento'))
										ORDER BY 
											ped_pedidos.razaope;";
											
							$objResult = $objConn->query($strSQL); // execução da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  	foreach($objResult as $objRS){
					$cont = $cont + 1;
			  ?>
<table width="100%" border="0" bgcolor="#FFFFFF" class="bordasimples">
  <tr>
    <td width="10%" style="border-right:none; border-left:none; border-top:none; border-bottom:none" ><b><?php echo getValue($objRS,"codigope") ?></b></td>
    <td width="10%" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><b> <?php echo getValue($objRS,"idpedido") ?></b></td>
    <td width="75%" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><b> <?php echo getValue($objRS,"razaope") ?></b></td>
    <td width="5%" style="border-right:none; border-left:none; border-top:none; border-bottom:none"><b> <?php echo getValue($objRS,"idreprepe") ?></b></td>
  </tr>
</table >
<?php } ?>
<hr>
<tr>
  <td><?PHP echo $cont; ?> Contratos Bloqueados
    <?php $total = $total + $cont; ?>
  </td>
</tr>
<br>
<br>
<?php } ?>
<hr>
<tr>
  <td><b><?PHP echo $total; ?> Contratos Bloqueados</b> </td>
</tr>
</body>
</html>
<?php $objConn = NULL; ?>
