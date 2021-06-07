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
$dt_inicio  = request("dt_inicio");
$dt_final  = request("dt_final"); 


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
					$strSQL = "
								SELECT DISTINCT Demonstrativo_IRRF.RAZAONF AS RAZAO   ,
               						 			CAD_CADASTRO.ENDERECOCOB1            AS ENDERECO,
												CAD_CADASTRO.BAIRROCOB1              AS BAIRRO  ,
												CAD_CADASTRO.CIDADECOB1              AS CIDADE  ,
												CAD_CADASTRO.ESTADOCOB1              AS ESTADO  ,
												CAD_CADASTRO.CEPCOB1                 AS CEP     ,
												CAD_CADASTRO.PAISCOB1                AS PAIS
								FROM            (
												  SELECT   SUM(PED_NOTA_FISCAL.VALORNF) AS SomaDeVALORNF,
														   DATE_PART('month', DATANF )         AS mesnum,
														   sp_converte_mes(DATE_PART('MONTH', DATANF)) as mes,
														   SUM(PED_NOTA_FISCAL.VALORIR) AS IR           ,
														   CAD_EMPRESA.ERODAPE                            ,
														   CAD_EMPRESA.ERAZAO                             ,
														   PED_NOTA_FISCAL.CGCMFNF                      ,
														   CAD_EMPRESA.ECNPJ                              ,
														   PED_NOTA_FISCAL.CODIGONF                     ,
														   PED_NOTA_FISCAL.RAZAONF                      ,
														   DATE_PART('Year', DATANF ) AS ANO           ,
														   PED_NOTA_FISCAL.ENDERECONF                   ,
														   PED_NOTA_FISCAL.BAIRRONF                     ,
														   PED_NOTA_FISCAL.CIDADENF                     ,
														   PED_NOTA_FISCAL.ESTADONF                     ,
														   PED_NOTA_FISCAL.CEPNF                        ,
														   PED_NOTA_FISCAL.PAISPE
												  FROM     CAD_EMPRESA
														   RIGHT JOIN PED_NOTA_FISCAL
														   ON       CAD_EMPRESA.idmercado = PED_NOTA_FISCAL.idmercado
												  WHERE    (((PED_NOTA_FISCAL.VALORIR)  >0)
														   AND      ((PED_NOTA_FISCAL.DATANF) BETWEEN to_date('".$dt_inicio."', 'dd/mm/yyyy') AND to_date('".$dt_final."', 'dd/mm/yyyy' ))
														   AND      ((PED_NOTA_FISCAL.CANCELADA)= false))
												  GROUP BY 
														   DATE_PART('month', DATANF)        ,
														   sp_converte_mes(DATE_PART('MONTH', DATANF)) ,
														   CAD_EMPRESA.ERODAPE           ,
														   CAD_EMPRESA.ERAZAO            ,
														   PED_NOTA_FISCAL.CGCMFNF     ,
														   CAD_EMPRESA.ECNPJ             ,
														   PED_NOTA_FISCAL.CODIGONF    ,
														   PED_NOTA_FISCAL.RAZAONF     ,
														   DATE_PART('Year', DATANF )	,
														   PED_NOTA_FISCAL.ENDERECONF  ,
														   PED_NOTA_FISCAL.BAIRRONF    ,
														   PED_NOTA_FISCAL.CIDADENF    ,
														   PED_NOTA_FISCAL.ESTADONF    ,
														   PED_NOTA_FISCAL.CEPNF       ,
														   PED_NOTA_FISCAL.PAISPE      ,
														   PED_NOTA_FISCAL.idmercado
												  HAVING   (((PED_NOTA_FISCAL.idmercado) ilike '".$id_empresa."'))) as Demonstrativo_IRRF
												INNER JOIN CAD_CADASTRO
												ON              Demonstrativo_IRRF.CODIGONF = CAD_CADASTRO.CODIGO
								WHERE           (((CAD_CADASTRO.idmercado)  ilike '".$id_empresa."'))
								ORDER BY        Demonstrativo_IRRF.RAZAONF; ";
					
					
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
     <td width="45%"><b><?php echo getValue($objRS,"razao"); ?></b></td>
  </tr>
  <tr>
    <td width="45%"><?php echo getValue($objRS,"endereco")." - "; echo getValue($objRS,"bairro"); ?></td>
  </tr>
  <tr>
    <td width="45%"><?php echo getValue($objRS,"cidade")." - "; echo getValue($objRS,"estado"); ?></td>
  </tr>
	<tr>
    <td width="45%"><b><?php echo getValue($objRS,"cep"); ?></b></td>
  </tr>
</table>

  <?php } else {  $var_lado = true; $var_cont++;?>
  
   
<table width="55%" border="0" >  
  <tr>
     <td width="16%">&nbsp;</td>
     <td width="84%"><b><?php echo getValue($objRS,"razao"); ?></b></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%"><?php echo getValue($objRS,"endereco")." - "; echo getValue($objRS,"bairro"); ?></td>
  </tr>
  <tr>
    <td width="16%">&nbsp;</td>
    <td width="84%"><?php echo getValue($objRS,"cidade")." - "; echo getValue($objRS,"estado"); ?></td>
  </tr>
	<tr>    <td width="16%">&nbsp;</td>
      <td width="84%"><b><?php echo getValue($objRS,"cep"); ?></b></td>
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
