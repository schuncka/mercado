<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<?php
//-------------------------------------------------------------------------
//Esta � a p�gina INDEX.PHP qe deve ser copiada para todos os m�dulos
//------------------------------------------ by Aless/Clv 04/09/2012 ------
include_once("../_database/athdbconn.php");
include_once("../_database/athkernelfunc.php");

$strAcao		= request("var_acao");
$strFieldName	= request("var_fieldname");
$strFormName	= request("var_formname");
$strURLRedirect	= request("var_redirect");
$strFieldDetail	= request("var_field_detail");
$intCodDado		= request("var_chavereg");
$strBaseName	= basename(getcwd());

$strSessionPfx = strtolower(str_replace("modulo_","",$strBaseName));

initModuloParams($strBaseName);

if($strAcao == "single"){
	setsession($strSessionPfx . "_acao"         , $strAcao);
	setsession($strSessionPfx . "_aux_fieldname", $strFieldName);
	setsession($strSessionPfx . "_aux_formname" , $strFormName);
}else{
	if(getsession($strSessionPfx . "_acao") != ''){
		setsession($strSessionPfx . "_acao", '');
	}
}

setsession($strSessionPfx . "_field_detail", $strFieldDetail);
setsession($strSessionPfx . "_value_detail", $intCodDado);
?>
<html>
 <head>
   <title><?php echo(CFG_SYSTEM_TITLE); ?></title>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  </head>
 <frameset  cols="250,*,0" frameborder="no" id="<?php echo(CFG_SYSTEM_NAME . "_principal"); ?>" name="<?php echo(CFG_SYSTEM_NAME . "_principal"); ?>" border="0" framespacing="0" rows="*"> 
  <frame name="<?php echo(CFG_SYSTEM_NAME . "_left"); ?>" id="<?php echo(CFG_SYSTEM_NAME . "_left"); ?>" src="../_fontes/menu.php?var_redirect=<?php echo $strURLRedirect; ?>&var_basename=<?php echo $strBaseName; ?>" scrolling="no" onResize="document.getElementById('<?php echo(CFG_SYSTEM_NAME . "_principal"); ?>').cols = this.width + ',*';">
  <frame name="<?php echo(CFG_SYSTEM_NAME . "_main"); ?>" id="<?php echo(CFG_SYSTEM_NAME . "_main"); ?>" src="">
 <frame src="UntitledFrame-2"></frameset> <noframes>
   <body text="#FFFFFF"></body>
 </noframes>
</html>