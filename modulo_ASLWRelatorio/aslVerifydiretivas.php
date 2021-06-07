<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");

// L� todos os campos que precisa repassar pra insupddelmastereditor.php, se passar na verifica��o
$strOperacao  = request("var_oper");       // Opera��o a ser realizada
$intCodDado   = request("var_chavereg");   // C�digo chave da p�gina
$strExec      = request("var_exec");       // Executor externo (fora do kernel)
$strPopulate  = request("var_populate");   // Flag para necessidade de popular o session ou n�o
$strAcao   	  = request("var_acao");       // Indicativo para qual formato que a grade deve ser exportada. Caso esteja vazio esse campo, a grade � exibida normalmente.

/* INI: Pega os dados do ASL ------------------------------------------------------ */
if($intCodDado != ""){
	$objConn = abreDBConn(CFG_DB);
	try{
		$strSQL = " SELECT  cod_relatorio, nome, descricao, parametro, cabecalho, rodape, executor, dtt_inativo, exec_direito, sys_usr_ins  FROM aslw_relatorio WHERE cod_relatorio = " . $intCodDado;
		$objRS  = $objConn->query($strSQL)->fetch();
	}
	catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
	}
	if(getValue($objRS, "dtt_inativo") == "") {
		$strRelEDir = (getValue($objRS,"exec_direito")=="")?"PUBLIC":strtoupper(getValue($objRS,"exec_direito")); //Vazio ser� tratado como PUBLIC
		$strRelUIns = getValue($objRS,"sys_usr_ins");
	} else {
		mensagem("Aviso", "Este relat�rio n�o pode ser executado.<br> Favor verificar o status ou entrar em contato com o suporte.", "", "javascript:history.back();","standardaviso",1);
		die();
	}
} else {
	mensagem("Aviso", "Favor selecionar um relat�rio v�lido.", "", "javascript:history.back();","standardaviso",1);
	die();
}
/* FIM: Pega os dados do ASL ------------------------------------------------------ */



/* INI: Verifica qual a diretiva de execu��o do relat�rio (Direito de Execu��o) --- */
$FlagEDirOk			= false;
$strUserLogado		= getsession(CFG_SYSTEM_NAME . "_id_usuario");
$strGrpUserLogado	= strtoupper(getsession(CFG_SYSTEM_NAME . "_grp_user"));
// Se o user logado � o criador ou o user logado � do grupo SU, ent�o sempre PODE RODAR
if ( ($strUserLogado==$strRelUIns) || ($strGrpUserLogado=="SU") )  { $FlagEDirOk = true; }
else {
  //se o relat�rio � PUBLIC, PODE RODAR
  if ($strRelEDir=="PUBLIC") { $FlagEDirOk = true; }
  else  {
	if ($strRelEDir=="PRIVATE") { $FlagEDirOk = false; }
	else {
		$arrEDir = explode(":",$strRelEDir);
		if ( ($arrEDir[0]=="GROUP") && ($arrEDir[0]==$strGrpUserLogado) ) { $FlagEDirOk = true; }
		else { $FlagEDirOk = false; }
	}
  }
}
if ($FlagEDirOk==false) {
  mensagem("Acesso Negado", "A diretiva de execu��o deste relat�rio n�o autoriza que seu usu�rio (" . $strUserLogado . " - " . $strGrpUserLogado . ") o altere.", "Diretiva: " . $strRelEDir, "javascript:history.back();","standarderro",1);
  die();
} else {
?>
<html>
<body>
	<form id='formrepasse' name='formrepasse' action='insupddelmastereditor.php' target='_self'>
		<input type='hidden' name='var_oper'	 id='var_oper'		value='<?php echo($strOperacao); ?>' />
		<input type='hidden' name='var_chavereg' id='var_chavereg'	value='<?php echo($intCodDado); ?>' />
		<input type='hidden' name='var_exec'	 id='var_exec'		value='<?php echo($strExec); ?>' />
		<input type='hidden' name='var_populate' id='var_populate'	value='<?php echo($strPopulate); ?>' />
		<input type='hidden' name='var_acao'	 id='var_acao'		value='<?php echo($strAcao); ?>' />
	</form>
	<script type="text/javascript" language="javascript">
		window.document.getElementById("formrepasse").submit();
	</script>
</body>
</html>

<?php
}
/* FIM: Verifica qual a diretiva de execu��o do relat�rio (Direito de Execu��o) --- */

$objConn = NULL;
?>