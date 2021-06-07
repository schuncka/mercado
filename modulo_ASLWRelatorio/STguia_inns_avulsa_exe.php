<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");

$var_cod_pagt  		= request("cod_pagt");
$var_competencia  	= request("competencia");
$var_razao  		= request("razao");
$var_endereco  		= request("endereco");
$var_identificador  = request("identificador");
$var_valor_inss		= request("valor_inns");
$var_campo7  		= request("campo7");
$var_valor_campo7  	= request("valor_campo7");
$var_campo8  		= request("campo8");
$var_valor_campo8  	= request("valor_campo8");
$var_entidade  = request("entidade");
$var_atm  = request("atm");
$var_obs  = request("obs");
$var_total =  $var_valor_inss + $var_entidade + $var_valor_campo7 + $var_valor_campo8 + $var_atm;


//$dt_inicio = $_POST["dt_inicio"];
$dt_final  = request("dt_final");
$var_chavereg  = request("var_chavereg");



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
</style>
<STYLE TYPE="text/css">
.folha {
    page-break-after: always;
}
</STYLE>
</head>
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >

<table width="100%" border="0" class="bordasimples" bgcolor="#FFFFFF">
  <tr>
    <td width="9%" rowspan="3" style="border-right:none"><img src="../img/logo_previdecia_social.gif" width="98" height="68"></td>
    <td colspan="2" rowspan="3" style="border-left:none"align="center"> Minist�rio da Previd�ncia a Assist�ncia Social - MPAS <br>
								Instituto Nacional do Seguro Social - INSS <br><br>
									<b>Guia da Previd�ncia Social - GPS</b>
	</td>
    <td width="25%" height="55" valign="top">3 - C�digo de Pagamento</td>
    <td width="25%" valign="top"> <div align="center"><font size="2"> <b><?php echo $var_cod_pagt; ?></b></font> </div></td>
  </tr>
  <tr>
    <td>4 - Compet�ncia</td>
    <td><div align="center"><b><?php echo $var_competencia; ?></b></div></td>
  </tr>
  <tr>
    <td>5 - Identificador</td>
    <td><div align="center"><b><?php echo $var_identificador; ?></b></div></td>
  </tr>
  <tr>
    <td colspan="3" rowspan="3"><b>
	<?php 
	$objConn = abreDBConn(CFG_DB); // Abertura de banco		
	try{					
	$strSQL = " SELECT cad_fornec.nomemont,
					cad_fornec.telefone1,
					cad_fornec.cod_fornec,
       				cad_fornec.endereco,
					cad_fornec.cgcmf
				from cad_fornec
				where cad_fornec.cod_fornec =  '".$var_razao."' ;
			  ";
	$objResult = $objConn->query($strSQL); // execu��o da query
	}catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
	}
	foreach($objResult as $objRS){
	echo getValue($objRS,"nomemont");
	echo "<br>";
	echo $var_endereco;
	echo "<br>";
	echo "Telefone: ".getValue($objRS,"telefone1");
	}	
	?></b>
	</td>
    <td>6 - Valor do INSS</td>
    <td><div align="right"><b><?php echo number_format($var_valor_inss, 2, ',', '.');?></b></div></td>
  </tr>
  <tr>
    <td>7 - <b><?php echo $var_campo7; ?></b></td>
    <td><div align="right"><b><?php echo $var_valor_campo7; ?></b></div></td>
  </tr>
  <tr>
    <td>8 - <b><?php echo $var_campo8; ?></b></td>
    <td><div align="right"><b><?php echo number_format($var_valor_campo8, 2, ',', '.');?></b></div></td>
  </tr>
  <tr>
    <td height="61" colspan="2" valign="bottom">2 - Vencimento<br>
    (Uso exclusivo INSS)</td>
    <td width="25%">&nbsp;</td>
    <td valign="top">9 - Valor de Outras
    Entidades</td>
    <td><div align="right"><b><?php echo number_format($var_entidade, 2, ',', '.');?> </b></div></td>
  </tr>
  <tr>
    <td colspan="3" rowspan="2" valign="top"><?php echo preg_replace("/(\\r)?\\n/i", "<br/>", $var_obs);?></td>
    <td height="76" valign="top">10 - ATM/Multa e Juros</td>
    <td><div align="right"><b><?php echo number_format($var_atm, 2, ',', '.'); ?></b></div></td>
  </tr>
  <tr>
    <td>11 - Total</td>
    <td>  <div align="right"><b><?php echo number_format($var_total, 2, ',', '.'); ?></b></div></td>
  </tr>
  <tr>
    <td colspan="3" style="border-right:none">&nbsp;</td>
    <td style="border-left:none">12 - Autentica��o Mec�nica </td>
    <td>&nbsp;</td>
  </tr>
</table>



</body>
</html>
<?php $objConn = NULL; ?>