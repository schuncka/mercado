<?php 
	// INCLUDES
	include_once("../_database/athdbconn.php");
	include_once("../_database/athtranslate.php");
	
	// GETTING THE CURRENT DIR
	$strDIR = strtoupper(str_replace("modulo_","",basename(getcwd())));
 ?>
<html>
<head>
<title><?php echo(CFG_SYSTEM_TITLE);?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/<?php echo(CFG_SYSTEM_NAME); ?>.css" rel="stylesheet" type="text/css">
<script>
<!--
	function imprimir(){
		parent.window.frames[1].focus();
		parent.window.frames[1].print();
	}
	
	function exportarAdobe(){
		parent.window.frames[0].document.frmRelatorio.var_acao.value = '.pdf';
		parent.window.frames[0].document.frmRelatorio.submit();
	}
	
	function exportDocument(prType){
	   /* Esta função faz o export do CONTEÚDO 
		* que está no FRAME da direita, para um
 		* tipo de documento informado como param. 
		* O conteúdo é coletado via javascript
		* e o formulário atual de export é atuali-
		* zado e aberto em pop-up, onde o conteú-
		* do é carregado.
		*/
		var objBODY;
		var objFORM;
		var objCONT;
		var objACAO;
		var objLINK;
		var strACAO;
				
		// PASSAGEM DE PARÂMETROS, INICIALIZACAO
		objACAO = document.getElementById("var_acao");
		objCONT = document.getElementById("var_content");
		objLINK = document.getElementById("var_link");
		objFORM = document.getElementById("formexport");
		strACAO = prType;
		
		// TRATAMENTO CONTRA PARAMS NULL
		if(parent.window.frames[1] == null){
			alert('Documento corrente NÃO está dentro da Estrutura de Frames Correta!');
		} else{ 
			objBODY = parent.window.frames[1].document.getElementsByTagName("body");
		}		
		
		// @DEBUG:
		// alert(objBODY[0].innerHTML);
		
		// ATUALIZAÇÃO DE VALUES, ETC
		objCONT.value = objBODY[0].innerHTML;
		objACAO.value = strACAO;
		objLINK.value = "<?php echo($strDIR);?>";
		objFORM.submit();
	}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="formexport" id="formexport" action="../modulo_Principal/STexport.php" target="_blank" method="post">
	<input type="hidden" name="var_content" id="var_content" value="" />
	<input type="hidden" name="var_acao"    id="var_acao"    value="" />
	<input type="hidden" name="var_link"    id="var_link"    value="" />
</form>
<form name="formAcao" action="" target="frm_resulaslw_detail">
	<input type="hidden" name="var_acao" value="">
</form>
<table width="100%" height="22" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="99%" valign="middle" background="../img/bgFooterLeft.jpg">
	  <table width="100%" height="22" cellpadding="0" cellspacing="0" border="0">
	    <tr>
			<td align="left" valign="middle" class="texto_corpo_peq">
				<?php 
					echo(getsession(CFG_SYSTEM_NAME . "_id_usuario") . ":&nbsp;" . getsession(CFG_SYSTEM_NAME . "_grp_user"));
					if(getsession(CFG_SYSTEM_NAME . "_su_passwd")){
						echo("*");
					}
				?>
				<span class="copyright"><!--(<?php echo("SID:" . session_id()); ?>)--></span>
			</td>
			<td align="right" valign="middle"><a href="http://www.athenas.com.br" target="_blank" class="copyright">Copyright Athenas Software &amp; Systems&nbsp;</a></td>
		</tr>
	  </table>
	</td>
    <td background="../img/bgFooterRight.jpg"> 
	  <table width="120" height="22" cellpadding="0" cellspacing="0" border="0">
	    <tr>
			<td style="padding-left:8px;"><!-- Tabela preparada para os ícones de impressão, exportação, e-mail, etc...-->
				<table border="0" cellpadding="0" cellspacing="0" width="74">
					<tr>
						<td align="center" width="18"><img src="../img/iconfooter_print.gif" border="0" onClick="imprimir();"             style="cursor:pointer;"  title="<?php echo(getTText("imprimir",C_UCWORDS));?>"></td>
						<td align="center" width="18"><img src="../img/iconfooter_word.gif"  border="0" onClick="exportDocument('.doc');" style="cursor:pointer;"  title="<?php echo(getTText("exportar_word",C_UCWORDS));?>"></td>
						<td align="center" width="18"><img src="../img/iconfooter_excel.gif" border="0" onClick="exportDocument('.xls');" style="cursor:pointer;"  title="<?php echo(getTText("exportar_excel",C_UCWORDS));?>"></td>
						<td align="center" width="18"><!-- img src="../img/iconfooter_adobe.gif" border="0"   onClick="exportarAdobe();"  style="cursor:pointer;"  title="<?php echo(getTText("exportar_adobe_reader",C_UCWORDS));?>"--></td>
					</tr>
				</table>
			</td>
		</tr>
	  </table>
	</td>
  </tr>
</table>
</body>
</html>