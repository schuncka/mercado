<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_evento = getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado"); 



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
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<font size="3"><b> EXPORTADOR </b><br></font>
<?php  
					$cont = 0;
  
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					
				
					try{
					$strSQLproc = "SELECT * FROM sp_cria_tmp_catalogo_exporter('$id_evento');";
									$objConn->query($strSQLproc);
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
					
				
					try{
					// SQL Principal	
					$strSQL = "
select   tmp_catalogo_exporter.codigo       ,
         tmp_catalogo_exporter.idmercado    ,
         tmp_catalogo_exporter.razao        ,
         tmp_catalogo_exporter.fantasia     ,
         tmp_catalogo_exporter.endereco     ,
         tmp_catalogo_exporter.bairro       ,
         tmp_catalogo_exporter.cidade       ,
         tmp_catalogo_exporter.estado       ,
         tmp_catalogo_exporter.cep          ,
         tmp_catalogo_exporter.pais         ,
         tmp_catalogo_exporter.cgcmf        ,
         tmp_catalogo_exporter.inscrest     ,
         tmp_catalogo_exporter.telefone1    ,
         tmp_catalogo_exporter.telefone2    ,
         tmp_catalogo_exporter.telefone3    ,
         tmp_catalogo_exporter.telefone4    ,
         tmp_catalogo_exporter.email        ,
         tmp_catalogo_exporter.respexp      ,
         tmp_catalogo_exporter.observacao   ,
         tmp_catalogo_exporter.lista_prodp  ,
         tmp_catalogo_exporter.lista_prodi  ,
         tmp_catalogo_exporter.lista_prode  ,
         tmp_catalogo_exporter.marcas       ,
         tmp_catalogo_exporter.paises       ,
         tmp_catalogo_exporter.idtelefone1  ,
         tmp_catalogo_exporter.idtelefone2  ,
         tmp_catalogo_exporter.idtelefone3  ,
         tmp_catalogo_exporter.idtelefone4  ,
         tmp_catalogo_exporter.distribuidor ,
         tmp_catalogo_exporter.representante,
         tmp_catalogo_exporter.isexport     ,
         tmp_catalogo_exporter.excluido     ,
         tmp_catalogo_exporter.dt           ,
         tmp_catalogo_exporter.localpe      ,
         tmp_catalogo_exporter.website      ,
         tmp_catalogo_exporter.descrpavilhao,
        
         tmp_catalogo_exporter.tipoexp
from    
		tmp_catalogo_exporter
order by tmp_catalogo_exporter.tipoexp;";
										
				$objResult = $objConn->query($strSQL); // execu��o da query
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  	foreach($objResult as $objRS){
			  
			  
			  if ($cont <> 3) {
			  $cont = $cont + 1;
			  ?>


<table  width="100%" border="0" bgcolor="#FFFFFF">
	<tr>
		<td> <br> <br>
		<font size="2"><b><?php echo getValue($objRS,"razao"); ?></b></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Commercial name: <b><?php echo getValue($objRS,"fantasia"); ?></b></font><br><br></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"endereco"); ?> - <?php echo getValue($objRS,"bairro"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"cep"); ?> - <?php echo getValue($objRS,"cidade"); ?> - <?php echo getValue($objRS,"estado"); ?> - <?php echo getValue($objRS,"pais"); ?> </font><br></td>
	</tr>
	<tr>
		<td><font size="2">Phone: <?php echo getValue($objRS,"telefone1"); ?> - Fax: <?php echo getValue($objRS,"telefone2"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">E-mail: <?php echo getValue($objRS,"email"); ?> - Website: <?php echo getValue($objRS,"website"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Brands: <b><?php echo getValue($objRS,"marcas"); ?></b></font><br></td>
	</tr>
	
	<tr>
		<td><font size="2">Produtos: <?php echo getValue($objRS,"lista_prodp"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Products: <?php echo getValue($objRS,"lista_prodi"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Productos: <?php echo getValue($objRS,"lista_prode"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Stand at </font></td>
	</tr>
	<tr>
		<td>
		<font size="2">
		<?php 
		
		echo getValue($objRS,"localpe");
		
		if (getValue($objRS,"descrpavilhao") <> null){
			 echo ' - '. getValue($objRS,"descrpavilhao");
			 }
		?>
		</font>
		
		<br>
		<br>
		<hr>
		</td>
		
	</tr>
	
</table>


<?php } else { 
$cont = 1;
?>
<div class="folha">  </div>
<table  width="100%" border="0" bgcolor="#FFFFFF">
	<tr><br><br>
		<td><font size="2"><b><?php echo getValue($objRS,"razao"); ?></b></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Commercial name: <b><?php echo getValue($objRS,"fantasia"); ?></b></font><br><br></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"endereco"); ?> - <?php echo getValue($objRS,"bairro"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"cep"); ?> - <?php echo getValue($objRS,"cidade"); ?> - <?php echo getValue($objRS,"estado"); ?> - <?php echo getValue($objRS,"pais"); ?> </font><br></td>
	</tr>
	<tr>
		<td><font size="2">Phone: <?php echo getValue($objRS,"telefone1"); ?> - Fax: <?php echo getValue($objRS,"telefone2"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">E-mail: <?php echo getValue($objRS,"email"); ?> - Website: <?php echo getValue($objRS,"website"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Brands: <b><?php echo getValue($objRS,"marcas"); ?></b></font><br></td>
	</tr>
	
	<tr>
		<td><font size="2">Produtos: <?php echo getValue($objRS,"lista_prodp"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Products: <?php echo getValue($objRS,"lista_prodi"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Productos: <?php echo getValue($objRS,"lista_prode"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Stand at </font></td>
	</tr>
	<tr>
		<td>
		<font size="2">
		<?php 
		echo getValue($objRS,"localpe");
		
		if (getValue($objRS,"descrpavilhao") <> null){
			 echo ' - '. getValue($objRS,"descrpavilhao");
			 }
		?>
		</font>
		
		<br>
		<br>
		<hr>
		
		</td>
		
	</tr>
	
</table>

<?php }; } ?>
</table>

<?php

try{
					$strSQLproc = "SELECT * FROM sp_drop_temporarias('tmp_catalogo_exporter')";
									$objConn->query($strSQLproc);
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}

?>

</body>
</html>
<?php $objConn = NULL; ?>
