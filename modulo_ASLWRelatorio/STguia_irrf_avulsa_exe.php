<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");


$competencia = request("competencia");
$vencimento = request("vencimento");
$nome_cliente = request("nome_cliente");
$cnpj = request("cnpj");
$telefone = request("telefone");
$codigo_tributol = request("codigo_tributo");
$valor_tributo = request("valor_tributo");
$valor_multa = request("valor_multa");
$valor_juros = request("valor_juros");
$observacao = request("observacao");


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

<!--
table.bordasimples {border-collapse: collapse;}
table.bordasimples tr td {border:1px solid #000000;}
-->

.tdicon{
		text-align:center;
		font-size:11px;
		font:bold;
		width:25%;		
}
img{
	border:none;
}

hr {
      border-top: 1px dashed #000000;
      color: #fff;
      background-color: #fff;
      height: 4px;
    }

</style>


<STYLE TYPE="text/css">
.folha {
    page-break-after: always;
}
</STYLE>

</head>
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<p>


<table width="100%" class="bordasimples" border="0" bgcolor="#FFFFFF">
  <tr>
    <td width="9%" rowspan="4" align="center" style="border-right:none"> <img src="../img/logo_ministerio_da_fazenda.gif" width="89" height="79"> </td>
    <td width="43%" rowspan="4" style="border-left:none"> <font size="3"><b> MINIST�RIO DA FAZENDA </b></font> <BR>
								<font size="2"><b> SECRETARIA DA RECEITA FEDERAL  </b></font><br>
								<font size="2">Documento de Arrecada��o de Receitas Federais  </font><br>
								<font size="3"><b> DARF </b></font>    
	<td width="27%" ><b><font size="2">02 </font>PER�ODO DE APURA��O </b></td>
    <td width="21%"><div align="center"><?php echo $competencia; ?></div></td>
  </tr>
  <tr>
    <td><b><font size="2">03 </font> N�MERO DO CPF OU CNPJ</b></td>
    <td><div align="center"><?php echo $cnpj;         ?></div></td>
  </tr>
  <tr>
    <td><b><font size="2">04 </font> C�DIGO DA RECEITA</b></td>
    <td><div align="center"><?php echo $codigo_tributol; ?></div></td>
  </tr>
  <tr>
    <td><b><font size="2">05 </font> N�MERO DE REFER�NCIA </b></td>
    <td><div align="center"></div></td>
  </tr>
  <tr>
    <td colspan="2" rowspan="3"><b><font size="2">01 </font> NOME/TELEFONE</b><br>
        						  &nbsp; &nbsp; &nbsp; <b><?php echo $nome_cliente; ?> </b><br>
	&nbsp; &nbsp; &nbsp; <b><?php echo $telefone; ?></b> </td>
    <td><b><font size="2">06 </font> DATA DE VENCIMENTO</b></td>
    <td> <div align="center"><?php echo $vencimento;   ?></div></td>
  </tr>
  <tr>
    <td><b><font size="2">07 </font> VALOR RPINCIPAL</b></td>
    <td><div align="right"><?php echo $valor_tributo; ?></div></td>
  </tr>
  <tr>
    <td><b> <font size="2">08 </font> VALOR DA MULTA</b></td>
    <td><div align="right"><?php echo $valor_multa; ?></div></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp; &nbsp; &nbsp; IRRF - Imposto de Renda Retido na Fonte</td>
    <td><b><font size="2">09 </font> VALOR DOS JUROS E/OU <br> 
		&nbsp; &nbsp; &nbsp; ENCARGOS DL - 1.025/69 </b></td>
    <td><div align="right"><?php echo $valor_juros; ?></div></td>
  </tr>
  <tr>
    <td colspan="2" rowspan="3">
	<div align="center"> <font size="2"><b>ATEN��O</b></font> </div><BR>
	<div align="justify">
				� vedado o recolhimento de tributos e contribui��es administrados pela
			Secretaria da Receita Federal cujo valor total seja inferior a R$ 10,00.
			Ocorrendo tal situa��o, adicione esse valor ao tributo/contribui��o de
			mesmo c�digo de per�odos subsequentes, at� que o total seja igual ou
			superior a R$ 10,00.</div>	<br><br><br>
			<br>
			<div align="justify"> <?php echo preg_replace("/(\\r)?\\n/i", "<br/>", $observacao); ?></div>			</td>
			
    <td><b><font size="2">10 </font> VALOR TOTAL</b></td>
    <td> <div align="right"><?php echo number_format(($valor_tributo + $valor_multa + $valor_juros), 2, ',', '.'); ?></div></td>
  </tr>
  <tr>
    <td height="23" colspan="2" style="border-bottom:none"><b>11 AUTENTICA��O BANC�RIA (Somente nas 1� e 2� vias)</b></td>
  </tr>
  <tr>
    <td height="70" colspan="2" style="border-top:none">&nbsp;</td>
  </tr>
</table>

<br> <br> <br> <br> <br> <br> <br>

<hr>

<br> <br> <br> <br> <br> <br> <br>

<table width="100%" class="bordasimples" border="0" bgcolor="#FFFFFF">
  <tr>
    <td width="6%" rowspan="4" align="center" style="border-right:none"> <img src="../img/logo_ministerio_da_fazenda.gif" width="89" height="79"> </td>
    <td width="44%" rowspan="4" style="border-left:none"> <font size="3"><b> MINIST�RIO DA FAZENDA </b></font> <BR>
								<font size="2"><b> SECRETARIA DA RECEITA FEDERAL  </b></font><br>
								<font size="2">Documento de Arrecada��o de Receitas Federais  </font><br>
								<font size="3"><b> DARF </b></font>    
	<td width="25%"><b>02 PER�ODO DE APURA��O </b></td>
    <td width="25%"><div align="center"><?php echo $competencia; ?></div></td>
  </tr>
  <tr>
    <td><b>03 N�MERO DO CPF OU CNPJ</b></td>
    <td><div align="center"><?php echo $cnpj;         ?></div></td>
  </tr>
  <tr>
    <td><b>04 C�DIGO DA RECEITA</b></td>
    <td><div align="center"><?php echo $codigo_tributol; ?></div></td>
  </tr>
  <tr>
    <td><b>05 N�MERO DE REFER�NCIA </b></td>
    <td><div align="center"></div></td>
  </tr>
  <tr>
    <td colspan="2" rowspan="3"><b>01 NOME/TELEFONE</b><br>
        						  &nbsp; &nbsp; &nbsp; <b><?php echo $nome_cliente; ?> </b><br>
	&nbsp; &nbsp; &nbsp; <b><?php echo $telefone; ?></b> </td>
    <td><b>06 DATA DE VENCIMENTO</b></td>
    <td> <div align="center"><?php echo $vencimento;   ?></div></td>
  </tr>
  <tr>
    <td><b>07 VALOR RPINCIPAL</b></td>
    <td><div align="right"><?php echo $valor_tributo; ?></div></td>
  </tr>
  <tr>
    <td><b> 08 VALOR DA MULTA</b></td>
    <td><div align="right"><?php echo $valor_multa; ?></div></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp; &nbsp; &nbsp; IRRF - Imposto de Renda Retido na Fonte</td>
    <td><b>09 VALOR DOS JUROS E/OU <br> 
		&nbsp; &nbsp; &nbsp; ENCARGOS DL - 1.025/69 </b></td>
    <td><div align="right"><?php echo $valor_juros; ?></div></td>
  </tr>
  <tr>
    <td colspan="2" rowspan="3">
	<div align="center"> <font size="2"><b>ATEN��O</b></font> </div><BR>
	<div align="justify">
				� vedado o recolhimento de tributos e contribui��es administrados pela
			Secretaria da Receita Federal cujo valor total seja inferior a R$ 10,00.
			Ocorrendo tal situa��o, adicione esse valor ao tributo/contribui��o de
			mesmo c�digo de per�odos subsequentes, at� que o total seja igual ou
			superior a R$ 10,00.</div>	<br><br><br>
			<br>
			<div align="justify"> <?php echo preg_replace("/(\\r)?\\n/i", "<br/>", $observacao); ?> </div>			</td>
    <td><b>10 VALOR TOTAL</b></td>
    <td> <div align="right"><?php echo number_format(($valor_tributo + $valor_multa + $valor_juros), 2, ',', '.'); ?>	</div></td>
	
  </tr>
  <tr>
    <td height="23" colspan="2" style="border-bottom:none"><b>11 AUTENTICA��O BANC�RIA (Somente nas 1� e 2� vias)</b></td>
  </tr>
  <tr>
    <td height="70" colspan="2" style="border-top:none">&nbsp;</td>
  </tr>
</table>

</body>
</html>
<?php $objConn = NULL; ?>
