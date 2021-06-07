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


$var_empresa = request("var_empresa");
$var_estado  = request("var_estado");
$id_evento = getsession(CFG_SYSTEM_NAME."_id_evento"); 



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
/*    page-break-after: always;*/
	page-break-before:always
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
<body style="margin-top:0px; margin-left:15px">			  
<?php	  

$objConn = abreDBConn(CFG_DB); // Abertura de banco

//EFETUA A BUSCA DAS ETIQUETAS

			
  $strSQL = "SELECT
					ped_pedidos.idpedido,
					ped_pedidos.razaope,
					ped_pedidos.enderecope,
					ped_pedidos.ceppe,
					ped_pedidos.cidadepe,
					ped_pedidos.estadope,
					ped_pedidos.paispe,
					cad_cadastro_sub.contato,
					CASE WHEN (cad_cadastro_exporter.e1 = TRUE) THEN 'JE' ELSE '' END || 
					CASE WHEN (cad_cadastro_exporter.e2 = TRUE) THEN 'QR' ELSE '' END ||
					CASE WHEN (cad_cadastro_exporter.e3 = TRUE) THEN '<strong>NE</strong>' ELSE '' END ||
					CASE WHEN (cad_cadastro_exporter.e4 = TRUE) THEN 'NQ' ELSE '' END ||
					CASE WHEN (cad_cadastro_exporter.e5 = TRUE) THEN 'NP' ELSE '' END ||
					CASE WHEN (cad_cadastro_exporter.e6 = TRUE) THEN '<strong>PD</strong>' ELSE '' END AS classificacao 
			FROM  ped_pedidos 
			INNER JOIN cad_cadastro ON (ped_pedidos.codigope = cad_cadastro.codigo AND ped_pedidos.idmercado ILIKE cad_cadastro.idmercado)
			LEFT JOIN cad_cadastro_exporter ON (cad_cadastro.tipoexpo = '1' AND cad_cadastro.codigo = cad_cadastro_exporter.codigo AND cad_cadastro.idmercado = cad_cadastro_exporter.idmercado AND cad_cadastro_exporter.dt_inativo IS NULL) 
			LEFT JOIN cad_cadastro_sub ON (cad_cadastro.codigo = cad_cadastro_sub.codigo AND cad_cadastro.idmercado = cad_cadastro_sub.idmercado AND cad_cadastro_sub.resp_re ilike 'S')
			WHERE ped_pedidos.idstatus <> '100'
			AND ped_pedidos.idstatus <> '005'
			AND ((CAST(SUBSTRING(ped_pedidos.IDPEDIDO from '..$') AS INT) = 0) OR (CAST(SUBSTRING(ped_pedidos.IDPEDIDO from '..$') AS INT) >= 30))
			AND ped_pedidos.idevento =  '".$id_evento."'
		    AND (ped_pedidos.excluida IS FALSE OR ped_pedidos.excluida IS NULL)
			ORDER BY razaope ASC ";
			
			try{
			$objResult = $objConn->query($strSQL); // execução da query		
						
			}catch(PDOException $e){
					mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
					die();
			}
		$var_lado = true;
		$var_cont = 0;
		$var_col = 2;
		foreach($objResult as $objRS){
				//$codigo_pedido = getValue($objRS,"idpedido");		  
?>			  
<?php if ($var_col == 2) {echo "<table border='0' width='100%'>"; $var_col = 0;}?>
       <?php  if ($var_lado == true) { $var_lado = false; ?>
        <tr>
        	<td style="text-align:left;">
                <table width="50%" border="0" align="left">  
                  <tr>
                     <td width="16%">&nbsp;</td>
                     <td width="84%"><div class="campos" ><b><?php echo getValue($objRS,"razaope"); ?></b></div></td>
                  </tr>
                  <tr>
                    <td width="16%">&nbsp;</td>
                    <td width="84%" style="overflow:hidden"><div class="campos" ><b><?php echo getValue($objRS,"contato"); ?></b></div></td>
                  </tr>
                  <tr>
                    <td width="16%">&nbsp;</td>
                    <td width="84%" style="overflow:hidden"><?php echo getValue($objRS,"enderecope"); ?></td>
                  </tr>
                  <tr>
                    <td width="16%">&nbsp;</td>
                    <td width="84%" style="overflow:hidden"><B><?php echo getValue($objRS,"ceppe"); ?></B>&nbsp;&nbsp;<?php echo getValue($objRS,"cidadepe");?><?php 
                    if (strtoupper(getValue($objRS,"paispe")) != "BRASIL")
                        echo "&nbsp;&nbsp;&nbsp;-&nbsp;".strtoupper(getValue($objRS,"paispe"));
                    else
                        echo " / ".getValue($objRS,"estadope");
                    echo("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;".getValue($objRS,"classificacao"));
                    ?></td>
                  </tr>
                </table>
		</td>
  <?php } else {  $var_lado = true; $var_cont++;?>
        <td style="text-align:left;">  
            <table width="50%" border="0" >  
              <tr>
                 <td width="16%">&nbsp;</td>
                 <td width="84%"><div class="campos" ><b><?php echo getValue($objRS,"razaope"); ?></b></div></td>
              </tr>
              <tr>
                <td width="16%">&nbsp;</td>
                <td width="84%" style="overflow:hidden"><div class="campos" ><b><?php echo getValue($objRS,"contato"); ?></b></div></td>
              </tr>
              <tr>
                <td width="16%">&nbsp;</td>
                <td width="84%" style="overflow:hidden"><?php echo getValue($objRS,"enderecope"); ?></td>
              </tr>
              <tr>
                <td width="16%">&nbsp;</td>
                <td width="84%" style="overflow:hidden"><B><?php echo getValue($objRS,"ceppe"); ?></B>&nbsp;&nbsp;<?php echo getValue($objRS,"cidadepe");?><?php 
                if (strtoupper(getValue($objRS,"paispe")) != "BRASIL")
                    echo "&nbsp;&nbsp;&nbsp;-&nbsp;".strtoupper(getValue($objRS,"paispe"));
                else
                    echo " / ".getValue($objRS,"estadope");
                echo("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;".getValue($objRS,"classificacao"));
                ?></td>
              </tr>          
            </table>
        </td>
    </tr>
	<tr><td height="27,5px" colspan="2">&nbsp;</td></tr>
	<?php if ($var_cont == 10) {
/*<!--table width="100%" border="0">
	<tr>
		<!--MODELO 1 -  26,5px -->
		<!--MODELO 2 -  27,5px 	
		<td height="27,5px">&nbsp;</td>
	</tr>
</table /-->*/
			if ($var_col == 0){echo "</table>"; $var_col = 2;}
			echo "<div class='folha'></div>"; $var_cont = 0;
	      }?>


<?php } ?>

<?php } ?>  

</body>
</html>
<?php $objConn = NULL; ?>
