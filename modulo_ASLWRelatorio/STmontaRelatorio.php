<?php
 include_once("../_database/athdbconn.php");
 include_once("../_database/athtranslate.php");
 
 /*$intCodigo    = request("var_coditem");
 $strFieldName = request("var_fieldname");
 $strDialogGrp = request("var_dialog_grp");
 $strRelatTitle = request("var_relat_title");
 $strParam 		= request("var_strparam");
*/
 $intCodigo     = request("var_chavereg");
 $mixValorAux   = request("var_valor_aux");
 $arquivo		= request("var_arquivo");
 
 ?>
<html>
<head>
<title><?php echo(CFG_SYSTEM_TITLE . " - " . getTText("relatorio_aslw",C_UCWORDS)); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset rows="30,*,23" cols="*" framespacing="0" frameborder="no" border="0">
  <frame name="frm_resulaslw_header" src="STpopup_resultaslwheader.php?var_chavereg=<?php echo($intCodigo); ?>&var_valor_aux=<?php echo($mixValorAux); ?>" scrolling="no">
  <frame name="frm_resulaslw_detail" src="<?php echo $arquivo;?>">
  <frame frameborder="1" name="frm_resulaslw_footer" src="STpopup_resultaslwfooter.php" scrolling="no">
</frameset><noframes></noframes>
</html>