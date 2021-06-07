<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$dt_inicio = request("dt_inicio");
$dt_final = request("dt_final");
$var_representante = request("nome_cliente");




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


function convertem($term, $tp) { 
    if ($tp == "1") $palavra = strtr(strtoupper($term),"������������������������������","������������������������������"); 
    elseif ($tp == "0") $palavra = strtr(strtolower($term),"������������������������������","������������������������������"); 
    return $palavra; 
} 
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
</head>
<body style="margin:10px 0px 10px 0px;">

<?php


$objConn = abreDBConn(CFG_DB); // Abertura de banco	
		
		try{				
				$strSQL = "select * from sp_cria_tmp_comissao_rel('".$dt_inicio."','".$dt_final."','".$id_empresa."');";
				$objResult = $objConn->query($strSQL); // execu��o da query
		}catch(PDOException $e){
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
				die();
		}
		
		try{				
				$strSQL = " select DISTINCT
								tmp_comissao_rel.erazao,
								tmp_comissao_rel.nomerepre,
								tmp_comissao_rel.data1,
								tmp_comissao_rel.data2,
								tmp_comissao_rel.outros 
							from 
								tmp_comissao_rel
								INNER JOIN
								cad_evento
								on (tmp_comissao_rel.idevento = cad_evento.idevento)
							WHERE 
							   TMP_COMISSAO_REL.IDREPRE ILIKE '".$var_representante."';";
				$objResult = $objConn->query($strSQL); // execu��o da query
		}catch(PDOException $e){
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
				die();
		}
	foreach($objResult as $objRS){
?>

<table width="100%" border="0">
  <tr>
    <td><font size="3"><b><?php echo getValue($objRS,"erazao") ?></b></font></td>
  </tr>
</table>
<br>
<br>
<br>
<table width="100%" border="0">
  <tr>
    <td align="right"><font size="2">S�o Paulo, <?php echo TranslateDate(date("d/m/Y")); ?> </font> </td>
  </tr>
</table>
<br>

<table width="100%" border="0">
  <tr>
    <td><font size="2"><b> A <?php echo getValue($objRS,"nomerepre") ?></b></font></td>
  </tr>
  <tr>
    <td><font size="2">Prezado Senhor, </font></td>
  </tr>
</table>

<br>
<br>

<table width="100%" border="0">
  <tr>
    <td><font size="2">Segue listagem anexa correspondente aos pagamentos efetuados pelos clientes, de sua respectiva regi�o de
atendimento e sob sua responsabilidade, os quais efetuaram liquida��o <?php echo getValue($objRS,"data1") ?> at� <?php echo getValue($objRS,"data2") ?></font></td>
  </tr>

</table>

<br>

<table width="100%" border="0">
  <tr>
    <td><font size="2">E abaixo os valores referentes ao seu cr�dito sobre servi�os de comiss�es do respectivo per�odo de apura��o.</font></td>
  </tr>
</table>
<br>
<br>
<table width="100%" border="0">
  <tr>
    <td width="31%"><font size="2">Descri��o do Evento</font></td>
    <td width="28%" align="right"><font size="2">Valor p/ C�lculo</font></td>
    <td width="23%" align="center"><font size="2">% Comiss�o</font></td>
    <td width="18%" align="right"><font size="2">Valor Comiss�o</font></td>
  </tr>
  <tr>
    <td colspan="4"><hr></td>
  </tr>
<?php
try{				
				$strSQL2 = "SELECT 
								  tmp_comissao_rel.bruto * tmp_comissao_rel.camissrepre	as valor_comissao,
								  tmp_comissao_rel.adiantamento,
								  tmp_comissao_rel.bruto,
								  tmp_comissao_rel.camissrepre,
								  tmp_comissao_rel.css,
								  tmp_comissao_rel.data1,
								  tmp_comissao_rel.data2,		
								  tmp_comissao_rel.erazao,
								  tmp_comissao_rel.idevento,
								  tmp_comissao_rel.idrepre,
								  tmp_comissao_rel.irrf,
								  tmp_comissao_rel.iss,
								  tmp_comissao_rel.nomerepre,
								  tmp_comissao_rel.outros,
								  tmp_comissao_rel.tipo,
								  cad_evento.nome_completo || ' - ' || TMP_COMISSAO_REL.TIPO AS DESCRICAO
							FROM   TMP_COMISSAO_REL
								   INNER JOIN CAD_EVENTO
								   ON     TMP_COMISSAO_REL.IDEVENTO      = CAD_EVENTO.IDEVENTO
							WHERE  tmp_comissao_rel.camissrepre  > 0
								   AND    TMP_COMISSAO_REL.IDREPRE ILIKE '".$var_representante."';";
				$objResult2 = $objConn->query($strSQL2); // execu��o da query
		}catch(PDOException $e){
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
				die();
		}
	$var_int_direta = 0;
	$var_int_indireta = 0;
	$var_int_irrf = 0;
	
	foreach($objResult2 as $objRS2){
	
	
	if (getValue($objRS2,"tipo") == 'Direta'){
		$var_int_direta = $var_int_direta + getValue($objRS2,"valor_comissao");
	}
	if (getValue($objRS2,"tipo") == 'Indireta'){
		$var_int_indireta = $var_int_indireta + getValue($objRS2,"valor_comissao");
	}
	
?>
				  <tr>
					<td><font size="2"><?php echo getValue($objRS2,"descricao");?></font></td>
					<td align="right"><font size="2"><?php echo number_format(getValue($objRS2,"bruto"), 2, ',', '.'); ?></font></td>
				   <td align="center"><font size="2"><?php echo number_format(getValue($objRS2,"camissrepre") * 100, 2, ',', '.')."%" ; ?></font></td>
					<td align="right"><font size="2"><?php echo number_format(getValue($objRS2,"valor_comissao"), 2, ',', '.') ?></font></td>
				  </tr>
<?php } ?>			  
  
  
  <tr>
    <td colspan="4"><hr></td>
  </tr>
</table>

<br>
<table width="100%" border="0">
  <tr>
    <td width="31%"><font size="2">Comiss�es Diretas</font></td>
    <td width="9%"><div align="right"><font size="2"> <?php echo  number_format($var_int_direta, 2, ',', '.'); ?></font></div></td>
    <td width="60%">&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2">Comiss�es Indiretas</font></td>
    <td><div align="right"><font size="2"><?php echo number_format($var_int_indireta, 2, ',', '.'); ?></font></div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2">Outros Cr�ditos</font></td>
    <td><div align="right"><font size="2"><?php echo  number_format(getValue($objRS2,"outros"), 2, ',', '.'); ?> </font> </div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2"><hr></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2">Total Bruto</font></td>
    <td><div align="right">
		<font size="2"><?php echo number_format($var_int_td = (getValue($objRS2,"outros") +  $var_int_indireta +  $var_int_direta), 2, ',', '.'); ?>
		</font></div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2">IRRF 0%</font></td>
    <td><div align="right"><font size="2">
	<?php if (($var_int_td * getValue($objRS2,"irrf")) > 10) {echo number_format($var_int_irrf = $var_int_td * getValue($objRS2,"irrf"), 2, ',', '.');} else {echo number_format(0, 2, ',', '.'); $var_int_irrf = 0;}  ?></font></div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2">CSS 0%</font></td>
    <td><div align="right"><font size="2">
	<?php if ($var_int_td > 5000) {echo number_format($var_int_css = $var_int_td * getValue($objRS2,"css"), 2, ',', '.');} else {echo number_format(0, 2, ',', '.'); $var_int_css = 0;}  ?></font></div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2">ISS 0%</font></td>
    <td><div align="right"><font size="2"><?php echo  number_format($var_int_iss = $var_int_td * getValue($objRS2,"iss"), 2, ',', '.'); ?></font></div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2"><hr></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2">Total L�quido</font></td>
    <td><div align="right"><font size="2"><?php echo number_format($var_int_tl = ($var_int_td - $var_int_irrf - $var_int_css - $var_int_iss), 2, ',', '.'); ?></font></div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2">Adiantamento em C/C</font></td>
    <td><div align="right"><font size="2"><?php echo number_format(getValue($objRS2,"adiantamento"), 2, ',', '.'); ?> </font></div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2"><hr></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2"><b>Total Comiss�o Creditada</b></font></td>
    <td><div align="right"><font size="2"><?php echo number_format($var_int_tl =  ($var_int_tl - getValue($objRS2,"adiantamento")), 2, ',', '.');  ?></font></div></td>
    <td>&nbsp;</td>
  </tr>
</table>
<br>

<table width="100%" border="0">
  <tr>
   <td width="75%" align="justify"><font face="Lucida Console" size="2">
Valor total da comiss�o a ser creditada (por extenso): 
	
<?php	
//recebe o valor
$valor = $var_int_tl;
//recebe o valor escrito
$var_valor_extenso = valorporextenso($valor);
//imprime o valor em Maisculas
echo convertem($var_valor_extenso, 1); 

$palavra = strlen($var_valor_extenso);
while ($palavra < 187) {
	echo " ";
	$palavra++;
	if ($palavra < 183){
		echo "#";
		$palavra++;
	}	
}
					  ?>
</b></font></td>
</tr>
</table>


<br>
<br>
<br>

<table width="100%" border="0">
  <tr>
    <td align="justify"><div align="justify"><font size="2">Informamos que o valor total da comiss�o ser� creditado em conta corrente, ou mediante cheque nominal, at� o d�cimo dia �til do m�s subseq�ente ao m�s referente ao per�odo de apura��o. Lembramos que a nota fiscal dever� ser entregue at� dois dias antes da data do cr�dito e emitida conforme o valor total bruto correspondente.</font></div></td>
  </tr>
</table>
<br>
<br>
<br>
<font size="2">Sem mais.</font>
<br>
<br>
<br>

<table width="100%" border="0">
  <tr>
    <td><font size="2">Ladislau Jos� de Souza</font></td>
  </tr>
  <tr>
    <td><font size="2"><?php echo getValue($objRS,"erazao") ?></font></td>
  </tr>
</table>

<?php } ?>

</body>
</html>
<?php 
	try{				
				$strSQL = " SELECT * FROM sp_drop_temporarias('tmp_comissao_rel');";
				$objResult = $objConn->query($strSQL); // execu��o da query
		}catch(PDOException $e){
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
				die();
		}
?>

<?php $objConn = NULL; ?>
