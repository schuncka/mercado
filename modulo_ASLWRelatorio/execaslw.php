<?php
/* - EXECASLE.PHP --------------------------------------------------------------------------
 Esta p�gina � chamda pelo m�dulo_ASLWRelat�rio, com sendo o PLAYER de qualquer relat�rio.
 
 - Este PLAYER (esta p�gina) � respons�vel por montar a Dialog com os par�metros do mesmo, 
   fazer as consist�ncias de entrada, e por fim encaminhar via POST ao EXECUTOR do 
   relat�rio os seguintes par�metros:
		var_cod    : c�digo do relat�rio
		var_asl    : SQL no padr�o ASL (com TAGs tipo <ASLW_APOSTROFE> e MODIFICADORES tipo [!]
		var_sql    : SQL limpo, ou seja livre de (com TAGs tipo e modificadores)
		var_tit    : titulo do relat�rio
		var_desc   : descri��o do relat�rio
		var_header : cabe�alho do relat�rio definido pelo usu�rio
		var_footer : rodap� do relat�rio definido pelo usu�rio
		var_inputs : usado apenas para o log
 
 - Funcionamento: atrav�s do c�digo do relat�rio que ela recebe (var_chavereg), Abre o ASL/SQL e 
   verifica se existem par�metros (:param:), caso existam ela monta o formul�rio preparando 
   os campos para preenchimento pelo usu�rio, coloca as fun��es de consist�ncia e ajustes 
   JScript. Caso o ASL n�o tenha par�metros, monta o formul�rio com os itens e efetua o 
   submit diretamente ao EXECUTOR do ASL em quest�o.

 - Atrav�s do modificador [>999 campo] chega o valor do campo a ser pr�prencido no 
   formul�rio arpa execu��o do submit e esta p�gina deve tratar isso tamb�m 
   
 * no futuro pr�ximo esta p�gina tamb�m ser� respons�vel pelo controle de direitos de execu��o
   que ser�o, em primeira inst�ncia: PUBLIC, GROUP:SU ou PRIVATE. 
   ** lembrando que o direto de edi��o tamb�m deve respeitar essa l�gica, al�m das permiss�es 
   de m�dulo � claro.
 --------------------------------------------------------------- 06/08/2010 - by Aless - */
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
  
$strSesPfx = strtolower(str_replace("modulo_","",basename(getcwd())));
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), 19);

$intRelCod  = request("var_chavereg"); 
$strRelASL  = "";
$strRelSQL  = "";
$strRelTit  = "";
$strRelDesc = "";
$strRelExec = "";
$strRelHead = "";
$strRelFoot = "";

$mixValorAux   = request("var_valor_aux");	//Possibilita preenchimento de um valor default pra um campo
$intFieldIndex = request("var_fieldindex");	//
$strOrder      = request("var_order");		//
$strRelEDir    = "";
$strRelUIns    = "";


/* INI: Pega os dados do ASL ------------------------------------------------------ */
if($intRelCod != ""){
	$objConn = abreDBConn(CFG_DB);
	try{
		$strSQL = " SELECT  cod_relatorio, nome, descricao, parametro, cabecalho, rodape, executor, dtt_inativo, exec_direito, sys_usr_ins  FROM aslw_relatorio WHERE cod_relatorio = " . $intRelCod;
		$objRS  = $objConn->query($strSQL)->fetch();
	}
	catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
	}
	if(getValue($objRS, "dtt_inativo") == "") {
		//redirect(getValue($objRS,"executor") . "?var_chavereg=" . $intCodigo . "&var_valor_aux=" . $mixValorAux);
		$intRelCod  = getValue($objRS,"cod_relatorio");
		$strRelASL  = getValue($objRS,"parametro"); // Ser� feita ainda a substitui��o dos valores dos par�metros( :param:)
		$strRelSQL  = getValue($objRS,"parametro"); // Depois da substitui��o dos valores dos par�metros( :param:),  ser�o retiras das TAGS e os modificares.
		$strRelExec = getValue($objRS,"executor");
		$strRelTit  = getValue($objRS,"nome");
		$strRelDesc = getValue($objRS,"descricao");
		$strRelHead = getValue($objRS,"cabecalho");
		$strRelFoot = getValue($objRS,"rodape");
		$strRelEDir = (getValue($objRS,"exec_direito")=="")?"PUBLIC":getValue($objRS,"exec_direito"); //Vazio ser� tratado como PUBLIC
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
$FlagEDirOk		  = false;
$strUserLogado	  = getsession(CFG_SYSTEM_NAME . "_id_usuario");
$strGrpUserLogado = getsession(CFG_SYSTEM_NAME . "_grp_user");
// Se o user logado � o criador ou o user logado � do grupo SU, ent�o sempre PODE RODAR
if ( ($strUserLogado==$strRelUIns) || ($strGrpUserLogado=="SU") )  { $FlagEDirOk = true; }
else {
  if ($strRelEDir=="PUBLIC") { $FlagEDirOk = true; } //se o relat�rio � PUBLIC, PODE RODAR
  else  {
	if ($strRelEDir=="PRIVATE") { $FlagEDirOk = false; } //se PRIVADO e neste ponto j� sabemso qeu n�o � SU nem o criador, ent�o n�o pode rodar
	else {
		$arrEDir = explode(":",$strRelEDir); 		
		if ($arrEDir[0]=="GROUP") { //se GRUOP
			//preg_match_all("/(,+)|(;+)|( +)/",$arrEDir[1],$arrGrupos); //Monta array com os grupos
			$arrGrupos = explode(";",$arrEDir[1]); 		
			if (in_array($strGrpUserLogado,$arrGrupos)) { $FlagEDirOk = true; }	else { $FlagEDirOk = false; }
		} else { 
			if ($arrEDir[0]=="USER") {
				//preg_match_all("/(,+)|(;+)|( +)/",$arrEDir[1],$arrUsers); //Monta array com os usu�rios
				$arrUsers = explode(";",$arrEDir[1]); 		
				if (in_array($strUserLogado,$arrUsers)) { $FlagEDirOk = true; } else { $FlagEDirOk = false; }
			} else { 
				$FlagEDirOk = false; 
			}
		}	
	}
  }
}
if ($FlagEDirOk==false) {
  mensagem("Acesso Negado", "A diretiva de execu��o deste relat�rio n�o autoriza que seu usu�rio [" . $strUserLogado . " - " . $strGrpUserLogado . "] o execute.", "Diretiva [" . $strRelEDir. "]", "javascript:window.close();","standarderro",1);
  die();
}
/* FIM: Verifica qual a diretiva de execu��o do relat�rio (Direito de Execu��o) --- */



/* INI: Processamento dos par�metros e montagem do formu�rio apartir do ASL ------- */
/* Neste caso, o Kernel esta gravando os ASL sem as TAGS, mas para comunica��o entre as p�ginas se 
   faz necess�ria a inser��o das mesmas. Obs.: mesmo que o sistema passe, em algum momento, a armazenar 
   no banco os ASLs com TAGS, n�o existe problema em chamarmos a insertTagSQL	mesmo que por garantia. 
   - Neste ponto tamb�m s�o substitu�dos os valores de sess�o dentro do ASL. */	 
//preg_match_all("/\:[[:alnum:] _]+\:/",$strRelASL,$arrParams);  //Monta o array de par�metros (:param:) 
//preg_match_all("/\:[[:alpha:] _]+\:/",$strRelASL,$arrParams);    //Monta o array de par�metros (:param:) 
preg_match_all("/\:[[:alpha:] (_)(0-9)(,)(\()(\))(\{)(\})]+\:/",$strRelASL,$arrParams);    //Monta o array de par�metros (:param:) 
$strRelASL = replaceParametersSession(insertTagSQL($strRelASL)); //Insere as tags ASLW para passagem de par�metro e faz a substitui��o dos valores de sistema
$strRelSQL = replaceParametersSession(preg_replace("/\[[[:punct:]]([0-9])*|\]|\"/","",$strRelSQL)); //retira os MODIFICADORES do SQL e n�o coloca TAGS

//DEBUG: print_r($arrParams); //:nome_COMBO(254,COD_CLI,NOME,12):
//DEBUG: print_r($strRelSQL); //:nome_COMBO(254,COD_CLI,NOME,12): 
//die();

// Substitu�dos os valores de sess�o dentro das vari�veis que descrevem o relat�rio: t�tulo, descri��o, cabe�alho e rodap�. */	 
$strRelTit  = replaceParametersSession($strRelTit);
$strRelDesc = replaceParametersSession($strRelDesc);
$strRelHead = replaceParametersSession($strRelHead);
$strRelFoot = replaceParametersSession($strRelFoot);

include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");
?>
<html>
<head>
<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
<link rel="stylesheet" href="../_css/<?php echo(CFG_SYSTEM_NAME) ?>.css" type="text/css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<style>
.centropreload { width:120px; height:120px;  position:absolute; top:50%; left:50%; margin-top:-60px; margin-left:-60px; }
</style>
<script language="javascript">
	function setParamToSQL() {
	  var strMySQL, intCont, strValor, strNome;

	  document.getElementById("mainTable").style.display="none";
	  document.getElementById("divPreload").style.display="block";

	  strMyASL = document.formRelASLW.var_asl.value;
	  strMySQL = document.formRelASLW.var_sql.value;
	  intCont = 0;
	  while(document.formRelASLW.elements[intCont].name != "") {
			strValor = document.formRelASLW.elements[intCont].value;
			/* Substitui todas as ocorr�ncias de um par�metro que aparece mais de uma vez no sql original. */
			while(strMyASL.indexOf("<ASLW_DOISPONTOS>" + document.formRelASLW.elements[intCont].name + "<ASLW_DOISPONTOS>")>0) {
				strMyASL = strMyASL.replace("<ASLW_DOISPONTOS>" + document.formRelASLW.elements[intCont].name + "<ASLW_DOISPONTOS>",strValor);
			}

			while(strMySQL.indexOf(":" + document.formRelASLW.elements[intCont].name + ":")>0) {
				strNome = document.formRelASLW.elements[intCont].name.toLowerCase();
				if (strNome.indexOf("_double")>0){
					while(strValor.indexOf(".")>0) {
						strValor = strValor.replace(".","");
					}	
					strValor = strValor.replace(",",".");
				}
				strMySQL = strMySQL.replace(":" + document.formRelASLW.elements[intCont].name + ":",strValor);	
				document.formRelASLW.var_inputs.value = document.formRelASLW.var_inputs.value + document.formRelASLW.elements[intCont].name + ":" + strValor + "; "
			}
			intCont++;
	  }
	  document.formRelASLW.var_asl.value = strMyASL; // O ASL � repassado para o EXECUTOR com as TAGS, conforme ele espera.
	  document.formRelASLW.var_sql.value = strMySQL; // O SQL � repassado para o EXECUTOR SEM as TAGS, conforme ele espera.
	  document.formRelASLW.action = '<?php echo($strRelExec); ?>';
	  document.formRelASLW.submit();
	}

	function enableEnter(event) {
		var tecla = window.event ? event.keyCode : event.which;
		if(tecla == 13) { setParamToSQL(); return false; }
	}

	//-->
	</script>
</head>
<body id="HtmlBodyContent" bgcolor="#CFCFCF" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg">
<span id="divPreload" style="display:none;" class="centropreload"><img src="../img/aslw_aguarde.gif"></span>
<div id="mainTable" align="center" style="width:100%; height:100%; display:block; text-align:center; vertical-align:top;"> 
	<?php athBeginFloatingBox("600","none","<b>" . strtoupper($intRelCod . " - " . $strRelTit) . "</b>",CL_CORBAR_GLASS_1); ?> 
		<table border="0" width="100%" bgcolor="#FFFFFF" style="border:1px #A6A6A6 solid;">
		    <tr><td style="text-align:left;"><?php echo($strRelDesc); ?></td></tr>
		</table><br>
		<table border="0" width="100%" bgcolor="#FFFFFF" style="border:1px #A6A6A6 solid;">
		  <form name="formRelASLW" action="" method="post" target="_self">
			<tr><td style="text-align:left; padding:10px;"><b><?php echo(getTText("campos_consulta",C_NONE)); ?></b></td></tr>
			<tr>
				<td align="center" valign="top">
					<table width="550" border="0" cellspacing="0" cellpadding="4">
						<?php 
                        

						$strCampos = "";
						if (count($arrParams[0])>0) {
							foreach($arrParams[0] as $strIndex) {
								$strIndex = preg_replace("/:|<ASLW_DOISPONTOS>/i","",$strIndex);
								if (strpos($strCampos, "[". $strIndex . "]") === false) {
									$strCampos .= "[" . $strIndex . "]";
									$strNome = getTText($strIndex,C_TOUPPER);
									
									$iPos = strpos(strtoupper($strIndex), "_DATE");
									if ($iPos !== false) {
										echo("<tr><td style='text-align:right'; width='100'>" . $strNome . "</td>
												  <td><input type='text' style='height:18px;' name='" . $strIndex . "' value='" . $mixValorAux . "' onkeypress='return FormataInputDataNew(this,event);' maxlength='10'></td></tr>");
									}
									else {
										$iPos = strpos(strtoupper($strIndex), "_NUMBER");
										if ($iPos !== false) {
											echo("<tr><td style='text-align:right'; width='100'>" . $strNome . "</td>
													  <td><input type='text' style='height:18px;' name='" . $strIndex . "' value='" . $mixValorAux . "' onKeyPress='return validateNumKey(event);'></td></tr>");
										}
										else {
											$iPos = strpos(strtoupper($strIndex), "_DOUBLE");
											if ($iPos !== false) {
												echo("<tr><td style='text-align:right'; width='100'>" . $strNome . "</td>
														  <td><input type='text' style='height:18px;' name='" . $strIndex . "' value='" . $mixValorAux . "' onkeypress='return validateFloatKeyNew(this, event);' dir='rtl'></td></tr>");
											}
											else {
												//:nome_COMBO(254): 
												$iPos = strpos(strtoupper($strIndex), "_COMBO");
												if ($iPos !== false) {
													$strComboParans = replaceParametersSession(getTextBetweenTags($strIndex,"(",")", $PosIni, $PosFim)); 
													$arrComboParans = explode(" ",$strComboParans); // preparado para mais par�metros no futuro...		
													$strNome 		= substr ($strIndex,0,$PosIni); 

													echo("<tr><td style='text-align:right'; width='100'>" . getTText($strNome,C_TOUPPER) . "</td><td>");
													//$arrComboParans[0]; //cod_sqlaux
													if($arrComboParans[0] != ""){
														$objConn = abreDBConn(CFG_DB);
														try{
															$strSQL = "SELECT cod_sqlaux, sql, combo_valor, combo_campo, combo_search FROM aslw_sqlauxiliar WHERE cod_sqlaux = " . $arrComboParans[0];
															$objRS  = $objConn->query($strSQL)->fetch();
														}
														catch(PDOException $e){
															mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
															die();
														}
														$strSQLAUX  = replaceParametersSession(getValue($objRS,"sql")); 
														$strCValor  = replaceParametersSession(getValue($objRS,"combo_valor")); 
														$strCCampo  = replaceParametersSession(getValue($objRS,"combo_campo")); 
														$strCSearch = replaceParametersSession(getValue($objRS,"combo_search")); 
														
														//echo("<BR><BR>DEBUG: ".$strSQLAUX ."<br> [".$strCValor."] [".$strCCampo."] [".$strCSearch."]");

														echo("<select name='" . $strIndex . "' id='" . $strIndex . "' size='1' style='width:300px; onKeyPress='return enableEnter(event);'>");
														echo("<option value=''></option>");
														echo(montaCombo($objConn, $strSQLAUX, $strCValor, $strCCampo, $strCSearch)); 
														echo("</select>");
													}
													echo("</td></tr>");
												}
												else { //_ALFA
													echo("<tr><td style='text-align:right'; width='100'>" . $strNome . "</td>
															  <td><input type='text' style='height:18px;' name='" . $strIndex . "' value='" . $mixValorAux . "' onKeyPress='return enableEnter(event);'></td></tr>");
												}
											}	
										}
									}
								}
							}
						} else {
						?>
							<tr><td collspan='2' style='text-align:left; padding-left:20px;'><?php echo(getTText("aviso_sem_param",C_NONE));?></td></tr>
						<?php
						}	
						?>
						<tr><td height="10" colspan="2"></td></tr>
						<tr><td height="1" colspan="2" bgcolor="#DBDBDB"></td></tr>
						<tr>
							<td align="right" colspan="2" style="padding:10px 0px 10px 10px;">
								<button onClick="setParamToSQL(); return false;"><?php echo(getTText("ok",C_UCWORDS)); ?></button>
								<button onClick="window.close();"><?php echo(getTText("cancelar",C_UCWORDS)); ?></button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<input type="hidden" name="var_cod"		id="var_cod"  	value="<?php echo($intRelCod); ?>">
			<input type="hidden" name="var_asl"		id="var_asl"  	value="<?php echo($strRelASL); ?>">
			<input type="hidden" name="var_sql"		id="var_sql"  	value="<?php echo($strRelSQL); ?>">
			<input type="hidden" name="var_tit"		id="var_tit"  	value="<?php echo($strRelTit); ?>">
			<input type="hidden" name="var_desc"	id="var_desc" 	value="<?php echo($strRelDesc); ?>">
			<input type="hidden" name="var_header"	id="var_header"	value="<?php echo($strRelHead); ?>">
			<input type="hidden" name="var_footer"	id="var_footer"	value="<?php echo($strRelFoot); ?>">
			<input type="hidden" name="var_inputs"	id="var_inputs" value="">
		  </form>
		</table>
	<?php athEndFloatingBox(); ?>
	<br />
	
	
	
	<?php 
	// INI: Exibi��o da grade com os HTMLs gerados do relat�rio ------------------------------------------ //
	if ($FlagEDirOk==true) {
		// inicializa variavel para pintar linha
		$strColor = "#F5FAFA";
		// fun��o para cores de linhas
		function getLineColor(&$prColor){
			$prColor = ($prColor == CL_CORLINHA_1) ? "#F5FAFA" : CL_CORLINHA_1;
			echo($prColor);
		} 
	
		try{
			$strSQL  = "SELECT nome, cod_relatorio_log, cod_relatorio, inputs, arquivo, sys_usr_ins, sys_dtt_ins, custo_seg";
			$strSQL .= "  FROM aslw_relatorio_log";
			$strSQL .= " WHERE cod_relatorio = " . $intRelCod ." ORDER BY sys_dtt_ins DESC LIMIT 50";
			
			$objResult = $objConn->query($strSQL);
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}
		
		athBeginFloatingBox("600","270","<b>�ltimas execu��es</b>",CL_CORBAR_GLASS_1); 
		echo("<table border='0' width='100%' bgcolor='#FFFFFF' style='border:0px #A6A6A6 solid;'><tr><td>");
		echo("<div style='text-align:left;'>".getTText("aviso_ult_execs",C_NONE)."</div>");
		?>
		<br /><div style="width:580; height:180px; max-height:180px; overflow:auto; position:absolute; top:auto; left:0px; border-bottom:1px solid #CCCCCC; background-color:#FFFFFF;">
		<table align="center" cellpadding="0" cellspacing="1" class="tablesort" style="width:100%; margin:0px;">
			<thead>
				<tr>
					<th width="1%"></th><!-- VIEW -->
					<th width="1%"></th><!-- DOWNLOAD HTML -->
					<th width="1%"></th><!-- DOWNLOAD CSV -->
					<th width="1%"></th><!-- DOWNLOAD XML -->
					<th width="8%" class="sortable"><?php echo(getTText("data",C_TOUPPER));?></th>
					<th width="67%" class="sortable"><?php echo(getTText("titulo",C_TOUPPER));?></th>
					<th width="9%" class="sortable"><?php echo(getTText("inputs",C_TOUPPER));?></th>
					<th width="9%" class="sortable"><?php echo(getTText("usr_ins",C_TOUPPER));?></th>								
					<th width="2%" class="sortable"><?php echo(getTText("seg.",C_TOUPPER));?></th>								
				</tr>
			</thead>
			<tbody>
			<?php 
			foreach($objResult as $objRS){ 
			    $lfname  = trim(getValue($objRS,"arquivo"));
				$arqPath = "../../".getsession(CFG_SYSTEM_NAME."_dir_cliente")."/asl_html/".$lfname;
				?>
				<tr bgcolor="<?php echo(getLineColor($strColor));?>">
					<td align="center" style="vertical-align:top; padding-top:2px;">
						<img src="../img/icon_html_view.gif" alt="view: <?php echo(getValue($objRS,"arquivo"));?>" 
							 title="view: <?php echo(getValue($objRS,"arquivo"));?>" border="0" style="cursor:pointer;"
							 onClick="AbreJanelaPAGE('<?php echo ($arqPath);?>','640','480');">
					</td>
					<td align="center" style="vertical-align:top; padding-top:2px;">
						<a href='aslDownload.php?var_file=<?php echo ($arqPath);?>' target='_blank' alt='download: <?php echo($lfname);?>' title='download: <?php echo($lfname);?>'><img src='../img/icon_html_download.gif' border='0'></a>
					</td>
					<td align="center" style="vertical-align:top; padding-top:2px;">
						<?php 
						$lfname  = str_replace(".html",".csv",$lfname);
						$arqPath = str_replace(".html",".csv",$arqPath);
						?>
						<a href='aslDownload.php?var_file=<?php echo $arqPath; ?>' target='_blank' alt='download: <?php echo($lfname);?>' title='download: <?php echo($lfname);?>'><img src='../img/icon_csv_download.gif' border='0'></a>
					</td>                    
					<td align="center" style="vertical-align:top; padding-top:2px;">
						<?php 
						$lfname  = str_replace(".csv",".xml",$lfname);
						$arqPath = str_replace(".csv",".xml",$arqPath);
						?>
						<a href='aslDownload.php?var_file=<?php echo $arqPath; ?>' target='_blank' alt='download: <?php echo($lfname);?>' title='download: <?php echo($lfname);?>'><img src='../img/icon_xml_download.gif' border='0'></a>
					</td>                    
					<td style="text-align:left;"><?php echo dDate(CFG_LANG,getValue($objRS,"sys_dtt_ins"),true); ?></td>
					<td style="text-align:left;"><?php echo(getValue($objRS,"nome"));?></td>
					<td style="text-align:left;"><?php echo(getValue($objRS,"inputs"));?></td>
					<td style="text-align:left;"><?php echo(getValue($objRS,"sys_usr_ins"));?></td>								
					<td style="text-align:right;"><?php echo(getValue($objRS,"custo_seg"));?></td>
				</tr>
			<?php } ?>
			</tbody>
		</table>
		</div>
	<?php 
		echo("</td></tr></table>");
		athEndFloatingBox();
	}
	// FIM: Exibi��o da grade com os HTMLs gerados do relat�rio ------------------------------------------ //
	?>
</div>
</body>
</html>
<?php
/* FIM: Processamento dos par�metros e montagem do formu�rio apartir do ASL ------- */
$objConn = NULL;
?>