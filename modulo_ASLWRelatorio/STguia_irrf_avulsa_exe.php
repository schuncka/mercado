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


/***            VERIFICAÇÃO DE ACESSO              ***/
/*****************************************************/
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verificação de acesso do usuário corrente



/***           DEFINIÇÃO DE PARÂMETROS            ***/
/****************************************************/

$strAcao   	      = request("var_acao");           // Indicativo para qual formato que a grade deve ser exportada. Caso esteja vazio esse campo, a grade é exibida normalmente.
$strSQLParam      = request("var_sql_param");      // Parâmetro com o SQL vindo do bookmark
$strPopulate      = request("var_populate");       // Flag de verificação se necessita popular o session ou não

/***    AÇÃO DE PREPARAÇÃO DA GRADE - OPCIONAL    ***/
/****************************************************/
if($strPopulate == "yes") { initModuloParams(basename(getcwd())); } //Popula o session para fazer a abertura dos ítens do módulo


/***        AÇÃO DE EXPORTAÇÃO DA GRADE          ***/
/***************************************************/
//Define uma variável booleana afim de verificar se é um tipo de exportação ou não
$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc") || ($strAcao == ".pdf");

//Exportação para excel, word e adobe reader
if($boolIsExportation) {
	if($strAcao == ".pdf") {
		redirect("exportpdf.php"); //Redireciona para página que faz a exportação para adode reader
	}
	else{
		//Coloca o cabeçalho de download do arquivo no formato especificado de exportação
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
    <td width="43%" rowspan="4" style="border-left:none"> <font size="3"><b> MINISTÉRIO DA FAZENDA </b></font> <BR>
								<font size="2"><b> SECRETARIA DA RECEITA FEDERAL  </b></font><br>
								<font size="2">Documento de Arrecadação de Receitas Federais  </font><br>
								<font size="3"><b> DARF </b></font>    
	<td width="27%" ><b><font size="2">02 </font>PERÍODO DE APURAÇÃO </b></td>
    <td width="21%"><div align="center"><?php echo $competencia; ?></div></td>
  </tr>
  <tr>
    <td><b><font size="2">03 </font> NÚMERO DO CPF OU CNPJ</b></td>
    <td><div align="center"><?php echo $cnpj;         ?></div></td>
  </tr>
  <tr>
    <td><b><font size="2">04 </font> CÓDIGO DA RECEITA</b></td>
    <td><div align="center"><?php echo $codigo_tributol; ?></div></td>
  </tr>
  <tr>
    <td><b><font size="2">05 </font> NÚMERO DE REFERÊNCIA </b></td>
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
	<div align="center"> <font size="2"><b>ATENÇÃO</b></font> </div><BR>
	<div align="justify">
				É vedado o recolhimento de tributos e contribuições administrados pela
			Secretaria da Receita Federal cujo valor total seja inferior a R$ 10,00.
			Ocorrendo tal situação, adicione esse valor ao tributo/contribuição de
			mesmo código de períodos subsequentes, até que o total seja igual ou
			superior a R$ 10,00.</div>	<br><br><br>
			<br>
			<div align="justify"> <?php echo preg_replace("/(\\r)?\\n/i", "<br/>", $observacao); ?></div>			</td>
			
    <td><b><font size="2">10 </font> VALOR TOTAL</b></td>
    <td> <div align="right"><?php echo number_format(($valor_tributo + $valor_multa + $valor_juros), 2, ',', '.'); ?></div></td>
  </tr>
  <tr>
    <td height="23" colspan="2" style="border-bottom:none"><b>11 AUTENTICAÇÃO BANCÁRIA (Somente nas 1ª e 2ª vias)</b></td>
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
    <td width="44%" rowspan="4" style="border-left:none"> <font size="3"><b> MINISTÉRIO DA FAZENDA </b></font> <BR>
								<font size="2"><b> SECRETARIA DA RECEITA FEDERAL  </b></font><br>
								<font size="2">Documento de Arrecadação de Receitas Federais  </font><br>
								<font size="3"><b> DARF </b></font>    
	<td width="25%"><b>02 PERÍODO DE APURAÇÃO </b></td>
    <td width="25%"><div align="center"><?php echo $competencia; ?></div></td>
  </tr>
  <tr>
    <td><b>03 NÚMERO DO CPF OU CNPJ</b></td>
    <td><div align="center"><?php echo $cnpj;         ?></div></td>
  </tr>
  <tr>
    <td><b>04 CÓDIGO DA RECEITA</b></td>
    <td><div align="center"><?php echo $codigo_tributol; ?></div></td>
  </tr>
  <tr>
    <td><b>05 NÚMERO DE REFERÊNCIA </b></td>
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
	<div align="center"> <font size="2"><b>ATENÇÃO</b></font> </div><BR>
	<div align="justify">
				É vedado o recolhimento de tributos e contribuições administrados pela
			Secretaria da Receita Federal cujo valor total seja inferior a R$ 10,00.
			Ocorrendo tal situação, adicione esse valor ao tributo/contribuição de
			mesmo código de períodos subsequentes, até que o total seja igual ou
			superior a R$ 10,00.</div>	<br><br><br>
			<br>
			<div align="justify"> <?php echo preg_replace("/(\\r)?\\n/i", "<br/>", $observacao); ?> </div>			</td>
    <td><b>10 VALOR TOTAL</b></td>
    <td> <div align="right"><?php echo number_format(($valor_tributo + $valor_multa + $valor_juros), 2, ',', '.'); ?>	</div></td>
	
  </tr>
  <tr>
    <td height="23" colspan="2" style="border-bottom:none"><b>11 AUTENTICAÇÃO BANCÁRIA (Somente nas 1ª e 2ª vias)</b></td>
  </tr>
  <tr>
    <td height="70" colspan="2" style="border-top:none">&nbsp;</td>
  </tr>
</table>

</body>
</html>
<?php $objConn = NULL; ?>
