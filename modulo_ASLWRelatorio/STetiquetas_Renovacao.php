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
$id_evento = getsession(CFG_SYSTEM_NAME."_id_evento"); 
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



</style>
</head>
<body style="margin:10px 0px 10px 0px;" >
			  
<?php	  

$objConn = abreDBConn(CFG_DB); // Abertura de banco
$strSQL = " SELECT DISTINCT 
           
                PED_PEDIDOS.RAZAOPE         ,               
                PED_PEDIDOS.LOCALPE         ,
                
                CASE WHEN (PED_PEDIDOS.RAZAOPE = PED_PEDIDOS.FANTASIAPE)
                	THEN ''
                	ELSE PED_PEDIDOS.FANTASIAPE
                END AS nome_fantasia,
                
                CASE WHEN (CAD_PAVILHAO.DESCRPAVILHAO is null)
                	THEN ''
                	ELSE ' - '||CAD_PAVILHAO.DESCRPAVILHAO
                END AS nome_pavilhao,
                
                CASE WHEN (cad_representantes.nomerepre is null)
                	THEN ''
                	ELSE 'Repres.: '||SUBSTR (cad_representantes.nomerepre, 1, 38)
                END AS nome_representante                
					FROM            (PED_PEDIDOS
									LEFT JOIN CAD_REPRESENTANTES
									ON              (PED_PEDIDOS.IDREPREPE = CAD_REPRESENTANTES.IDREPRE)
									AND             (PED_PEDIDOS.idmercado = CAD_REPRESENTANTES.idmercado))
									LEFT JOIN CAD_PAVILHAO
									ON              PED_PEDIDOS.PAVILHAOPE                 = CAD_PAVILHAO.IDPAVILHAO
					WHERE           (((PED_PEDIDOS.IDEVENTO)                             ='".$id_evento."')
									AND             ((PED_PEDIDOS.EXCLUIDA)                = false)                
									AND             ( SUBSTRING(IDPEDIDO, '..$')   ilike '00')
									AND             ((PED_PEDIDOS.IDSTATUS)               <>'005'
													AND             (PED_PEDIDOS.IDSTATUS)<>'100'))
					ORDER BY        PED_PEDIDOS.RAZAOPE; ";
										
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


<?php  if ($var_lado == true) { $var_lado = false; ?>

<table width="45%" border="0" align="left">  
  <tr>
     <td width="45%"><?php echo getValue($objRS,"razaope"); ?></td>
  </tr>
  <tr>
    <td width="45%"><?php echo getValue($objRS,"nome_fantasia");  ?></td>
  </tr>
  <tr>
    <td width="45%"><b><?php echo getValue($objRS,"localpe").getValue($objRS,"nome_pavilhao"); ?></b></td>
  </tr>
	<tr>
    <td width="45%"><?php echo getValue($objRS,"nome_representante"); ?></td>
  </tr>
</table>

  <?php } else {  $var_lado = true; $var_cont++;?>
  
 

  
<table width="55%" border="0" >  
  <tr>
     <td width="16%">&nbsp;</td>
     <td width="84%"><?php echo getValue($objRS,"razaope"); ?></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%"><?php echo getValue($objRS,"nome_fantasia");  ?></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%"><b><?php echo getValue($objRS,"localpe").getValue($objRS,"nome_pavilhao"); ?></b></td>
  </tr>
	<tr>    <td width="16%">&nbsp;</td>
      <td width="84%"><?php echo getValue($objRS,"nome_representante"); ?></td>
  </tr>
</table>

<br>
<table width="100%" border="0">
  <tr>
    <td></td>
  </tr>
</table>
<br>

<?php } ?>

<?php } ?>  

</body>
</html>
<?php $objConn = NULL; ?>
