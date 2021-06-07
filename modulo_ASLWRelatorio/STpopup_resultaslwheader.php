<?php 
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");

$intCodigo     = request("var_chavereg");
$mixValorAux   = request("var_valor_aux");
 
if($intCodigo != ""){
	$objConn = abreDBConn(CFG_DB);
	try{
		$strSQL = " SELECT parametro, descricao, executor, dtt_inativo, nome FROM aslw_relatorio WHERE cod_relatorio = " . $intCodigo;
		$objRS  = $objConn->query($strSQL)->fetch();
	}
	catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
	} 
	$strRelatTitle = getValue($objRS,"nome");
	
	$strPesquisa = "no";
	if(preg_match_all("/\:[[:alnum:] _]+\:/",getValue($objRS,"parametro"),$arrParams)){
		$strPesquisa = "ok";
		$strSQLRel = getValue($objRS,"parametro");
	}else{
		$strSQLRel = replaceParametersSession(insertTagSQL(getValue($objRS,"parametro")));//Insere as tags ASLW para passagem de parâmetro e faz a substituição dos valores de sistema
	}
}
	
?>
<html>
	<head>
		<title></title>
		<link rel="stylesheet" href="../_css/<?php echo(CFG_SYSTEM_NAME) ?>.css" type="text/css">
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	</head>
	<body bgcolor="#F7F7F7" leftmargin="0" topmargin="0">
		
		<table width="100%" height="100%" cellpadding="0" cellspacing="2" border="0">
			<tr><td><div style="padding-left:10px;padding-top:3px;"><b><?php echo($strRelatTitle)?></b></div></td></tr>
		</table>
	</body>
</html>