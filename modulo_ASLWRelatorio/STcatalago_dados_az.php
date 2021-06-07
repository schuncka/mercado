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
$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc");

//Exporta��o para excel, word e adobe reader
if($boolIsExportation) {
	//Coloca o cabe�alho de download do arquivo no formato especificado de exporta��o
	header("Content-type: application/force-download"); 
	header("Content-Disposition: attachment; filename=Modulo_" . getTText(getsession($strSesPfx . "_titulo"),C_NONE) . "_". time() . $strAcao);
	
	$strLimitOffSet = "";
} 

include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

$objConn = abreDBConn(CFG_DB); // Abertura de banco	

?>
<html>
<head>
<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<?php 
	if(!$boolIsExportation || $strAcao == "print"){
		echo("	<link rel=\"stylesheet\" href=\"../_css/" . CFG_SYSTEM_NAME . ".css\" type=\"text/css\">
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
</head>
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<font size="3"><b> FULL </b><br></font>
<?php  
	$cont = 0;
	
	try{
		$strSQL = "	SELECT
					  out_evento2 AS evento2
					, out_idpavilhao AS idpavilhao
					, out_codigo AS codigo
					, out_idmercado AS idmercado
					, out_nome AS nome
					, out_endereco AS endereco
					, out_bairro AS bairro
					, out_cep AS cep
					, out_cidade AS cidade
					, out_estado AS estado
					, out_pais AS pais
					, out_fone1 AS fone1
					, out_fone2 AS fone2
					, out_lista_prodp AS lista_prodp
					, out_lista_prodi AS lista_prodi
					, out_lista_prode AS lista_prode
					, out_idevento AS idevento
					, out_localizacao AS localizacao
					, out_website AS website
					, out_email AS email
					, out_idpedido AS idpedido
					FROM spr_catalogo_dados_a_z('".$id_evento."')
					WHERE out_evento2 = 'FULL'
					ORDER BY out_nome ";
		$objResult = $objConn->query($strSQL); // execu��o da query
	}catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
	}
	
	foreach($objResult as $objRS){
		if ($cont <> 3) {
			$cont = $cont + 1;
			?>
<table width="100%" border="0" bgcolor="#FFFFFF">
	<tr>
		<td> <br> <br>
		<font size="2"><b><?php echo getValue($objRS,"nome"); ?></b></font><br></td>
	</tr>
	<tr>
		<td><font size="2"><b></b></font><br><br></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"endereco"); ?> - <?php echo getValue($objRS,"bairro"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"cep"); ?> - <?php echo getValue($objRS,"cidade"); ?> - <?php echo getValue($objRS,"estado"); ?> - <?php echo getValue($objRS,"pais"); ?> </font><br></td>
	</tr>
	<tr>
		<td><font size="2">Telefone: <?php echo getValue($objRS,"fone1"); ?> - Telefax: <?php echo getValue($objRS,"fone2"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">E-mail: <?php echo getValue($objRS,"email"); ?> - Website: <?php echo getValue($objRS,"website"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Marcas: <b>
			<?php 
			try{
	            $strSQL = " SELECT out_marcas FROM sp_busca_marcas_expo('".getValue($objRS,"idmercado")."','".getValue($objRS,"codigo")."',TRUE) ";
				$objResultmarca = $objConn->query($strSQL);
            }catch(PDOException $e){
                mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
                die();
            }
            $objRSmarca = $objResultmarca->fetch();
			echo(getValue($objRSmarca,"out_marcas"));
			$objResultmarca->closeCursor();
            ?>
       	   </b></font><br>
        </td>
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
		<td><font size="2">Localizacao </font></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"localizacao");?></font><br><br><hr></td>		
	</tr>
</table>
<?php } 
else { 
	$cont = 1;
?>
<div class="folha">  </div>
<table  width="100%" border="0" bgcolor="#FFFFFF">
	<tr>
		<td> <br> <br>
		<font size="2"><b><?php echo getValue($objRS,"nome"); ?></b></font><br></td>
	</tr>
	<tr>
		<td><font size="2"><b></b></font><br><br></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"endereco"); ?> - <?php echo getValue($objRS,"bairro"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"cep"); ?> - <?php echo getValue($objRS,"cidade"); ?> - <?php echo getValue($objRS,"estado"); ?> - <?php echo getValue($objRS,"pais"); ?> </font><br></td>
	</tr>
	<tr>
		<td><font size="2">Telefone: <?php echo getValue($objRS,"fone1"); ?> - Telefax: <?php echo getValue($objRS,"fone2"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">E-mail: <?php echo getValue($objRS,"email"); ?> - Website: <?php echo getValue($objRS,"website"); ?></font><br></td>
	</tr>
	<tr>
		<td><font size="2">Marcas: <b>
			<?php 
			try{
	            $strSQL = " SELECT out_marcas FROM sp_busca_marcas_expo('".getValue($objRS,"idmercado")."','".getValue($objRS,"codigo")."',TRUE) ";
				$objResultmarca = $objConn->query($strSQL);
            }catch(PDOException $e){
                mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
                die();
            }
            $objRSmarca = $objResultmarca->fetch();
			echo(getValue($objRSmarca,"out_marcas"));
			$objResultmarca->closeCursor();
            ?>
			</b></font><br>
        </td>
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
		<td><font size="2">Localizacao </font></td>
	</tr>
	<tr>
		<td><font size="2"><?php echo getValue($objRS,"localizacao");?></font><br><br><hr></td>		
	</tr>
</table>
<?php 
	}
} 
?>
</table>
</body>
</html>
<?php $objConn = NULL; ?>
