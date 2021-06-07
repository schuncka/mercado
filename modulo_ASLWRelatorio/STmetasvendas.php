<?php
	// INCLUDES
	include_once("../_database/athdbconn.php");
	include_once("../_database/athtranslate.php");
	include_once("../_scripts/scripts.js");
	include_once("../_scripts/STscripts.js");
	include_once("../_database/athkernelfunc.php");
	
	// Abre objeto para manipulação com o banco
	$objConn = abreDBConn(CFG_DB);
	
	// inicializa variavel para pintar linha
	$strColor = CL_CORLINHA_1;
	
	// função para cores de linhas
	function getLineColor(&$prColor){
		$prColor = ($prColor == CL_CORLINHA_1) ? CL_CORLINHA_2 : CL_CORLINHA_1;
		echo($prColor);
	}
	
?>
<html>
	<head>
		<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link rel="stylesheet" href="../_css/<?php echo(CFG_SYSTEM_NAME);?>.css" type="text/css">
		<link href="../_css/tablesort.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="../_scripts/tablesort.js"></script>
		<style type="text/css">
			.tr_filtro_field { padding-left:5px; }
			.tr_filtro_label { padding-left:5px; padding-top:5px; }
			.td_search_left  { 
				padding:8px;
				border-top:1px solid #C9C9C9;
				border-left:1px solid #C9C9C9;
				border-bottom:1px solid #C9C9C9; 
			}
			.td_search_right  { 
				padding:5px;
				border-top:1px solid #C9C9C9;
				border-right:1px solid #C9C9C9;
				border-left: 1px dashed #C9C9C9;
				border-bottom:1px solid #C9C9C9;
			}
			.table_master{
				background-color:#FFFFFF;
				border-top:   1px solid #E9E9E9;
				border-right: 1px solid #E9E9E9;
				border-bottom:1px solid #E9E9E9;
				border-left:  1px solid #E9E9E9;
				padding-bottom: 5px;
			}
			.td_no_resp{ 
				font-size:11px; 
				font-weight:bold; 
				color:#C9C9C9; 
				text-align:center; 
				border:1px solid #E9E9E9;
				padding:5px 5px 0px 5px;
			}
			.td_resp{ border:1px solid #E9E9E9; padding:5px 0px 2px 10px; }
			.td_resp_cabec{ font-size:11px; font-weight:bold; color:#CCC;}
			.td_resp_conte{ padding:6px 0px 2px 20px; }
			.td_text_resp { border:2px dashed #E9E9E9; padding:4px 9px 4px 9px; }
		</style>
		<script type="text/javascript">
			var strLocation = null;
			function ok() {
				submeterForm();
			}

			function cancelar(){
				window.parent.close();
			}

			function submeterForm() {
				document.forminsert.submit();
			}
		</script>
	</head>
<body bgcolor="#FFFFFF" style="margin:10px 0px 10px 0px;">
<!-- body background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" style="margin:10px;"  -->

<!-- USO -->
<center>
<?php athBeginFloatingBox("520","",getTText("metas_vendas",C_UCWORDS),CL_CORBAR_GLASS_1); ?>
<table cellpadding="0" cellspacing="0" border="0" height="100%" width="500" bgcolor="#FFFFFF" class="table_master">
	<tr><td align="left" valign="top" style="padding:15px 0px 0px 15px;"><strong><?php echo(getTText("selecione_evento",C_NONE));?>:</strong></td></tr>
	<tr>
		<td align="left" valign="top" style="padding:10px 30px 10px 30px;">
			<table cellspacing="2" cellpadding="3" border="0" width="100%">
			<form name="forminsert" action="STmetasvendasexec.php" method="post">
				<!-- DADOS AGENDA -->
				<tr bgcolor="#FFFFFF">
					<td width="23%" align="right">&nbsp;</td>
					<td width="77%" align="left" class="destaque_gde">
						<strong><?php echo(getTText("dados_evento",C_TOUPPER));?></strong>
					</td>
				</tr>
				<tr><td colspan="2" height="2" background="../img/line_dialog.jpg"></td></tr>
				
				<tr bgcolor="<?php echo(getLineColor($strColor));?>">
					<td width="23%" align="right"><strong>*<?php echo(getTText("evento",C_UCWORDS));?>:</strong></td>
					<td width="77%" align="left">
						<select name="var_idevento" style="width:220px;">
						<?php echo(montaCombo($objConn,"SELECT idevento, idevento||' - '||nome_completo AS nome_evento FROM cad_evento WHERE idempresa = '".getsession(CFG_SYSTEM_NAME."_id_mercado")."' ORDER BY dt_inicio DESC, nome_completo","idevento","nome_evento",getsession(CFG_SYSTEM_NAME."_id_evento")));?>
						</select>
					</td>
				</tr>
				<tr bgcolor="<?php echo(getLineColor($strColor));?>">
					<td width="23%" align="right"><strong><?php echo(getTText("question_exibir_totais",C_NONE));?></strong></td>
					<td width="77%" align="left"><input type="radio" value="true" name="var_flag_total" class="inputclean" checked="checked"/>&nbsp;<?php echo(getTText("sim",C_NONE));?>&nbsp;&nbsp;&nbsp;<input type="radio" value="false" name="var_flag_total" class="inputclean" />&nbsp;<?php echo(getTText("nao",C_NONE));?></td>
				</tr>
				<tr bgcolor="<?php echo(getLineColor($strColor));?>">
					<td width="23%" align="right"><strong><?php echo(getTText("question_exibir_prods",C_NONE));?></strong></td>
					<td width="77%" align="left"><input type="radio" value="true" name="var_com_mov" class="inputclean" checked="checked"/>&nbsp;<?php echo(getTText("com_movimentacao",C_NONE));?>&nbsp;&nbsp;&nbsp;<input type="radio" value="false" name="var_com_mov" class="inputclean" />&nbsp;<?php echo(getTText("todos",C_NONE));?></td>
				</tr>
				<!-- DADOS NOVA RESPOSTA -->
				<tr>
					<td colspan="2" style="border-bottom:1px solid #CCC;padding-top:15px;">
						<span class="comment_peq"><?php echo(getTText("campos_obrig",C_NONE));?></span>
					</td>
				</tr>
			</form>	
			</table>			
		</td>
	</tr>
	<!-- LINHA DOS BUTTONS E AVISO -->
	<tr>
		<td colspan="3">
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<td width="20%">
						<table cellspacing="0" cellpadding="0" border="0" width="100%">
							<tr><td align="right" width="23%" style="padding-right:8px;"></td></tr>
						</table>
					</td>
					<!-- goNext() -->
					<td width="35%" align="right">
						<button onClick="ok();return false;"><?php echo(getTText("ok",C_UCWORDS));?></button>
					</td>
					<td width="20%" align="left" >
						<button onClick="cancelar();"><?php echo(getTText("cancelar",C_UCWORDS));?></button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>	
	<!-- LINHA ACIMA DOS BOTÕES -->
</table>
<?php athEndFloatingBox();?>
</center>
</body>
</html>