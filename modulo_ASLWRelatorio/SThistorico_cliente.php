<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_evento = getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado"); 



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



</style>
</head>
<body style="margin:10px 0px 10px 0px;">
<div align="center"><font size="3"><b>HIST�RICO DO CLIENTE</b></font> </div>

<table width="100%" border="1">
  <tr>
    <td>
	
		<table width="100%" border="0">
  <tr>
    <td width="15%">C�digo</td>
    <td width="41%">&nbsp;</td>
    <td width="16%">Telefone</td>
    <td width="28%">&nbsp;</td>
  </tr>
  <tr>
    <td>Raz�o Social</td>
    <td>&nbsp;</td>
    <td>Telefax</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Nome Fantasia</td>
    <td>&nbsp;</td>
    <td>Dire��o</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Endere�o</td>
    <td>&nbsp;</td>
    <td>Compras</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Bairro</td>
    <td>&nbsp;</td>
    <td>Data Funda��o</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Cidade</td>
    <td>&nbsp;</td>
    <td>Funcion�rios</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Estado</td>
    <td>&nbsp;</td>
    <td>Produ��o</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>C�digo Postal</td>
    <td>&nbsp;</td>
    <td>CGCMF</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Pa�s</td>
    <td>&nbsp;</td>
    <td>Inscr. Estadual</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Home Page</td>
    <td>&nbsp;</td>
    <td colspan="2" rowspan="3"><table width="100%" border="1">
  <tr>
    <td width="25%"><form name="form1" method="post" action="">
      <input style="border:none" name="radiobutton" type="radio" value="radiobutton">
      Pagante
    </form>
    </td>
    <td width="25%"><form name="form2" method="post" action="">
      <input style="border:none" name="radiobutton" type="radio" value="radiobutton">
      Permuta
    </form></td>
    <td width="25%"><form name="form3" method="post" action="">
      <input style="border:none" name="radiobutton" type="radio" value="radiobutton">
      Cortesia
    </form></td>
    <td width="25%"><form style="border:none" name="form4" method="post" action="">
      <input style="border:none" name="radiobutton" type="radio" value="radiobutton">
      Inativo
    </form></td>
  </tr>
</table>
</td>
    </tr>
  <tr>
    <td>E-Mail</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>RC</td>
    <td>&nbsp;</td>
    </tr>
</table>	
	</td>
  </tr>
</table>


<br>
<br>

<table width="90%" border="0" align="center">
  <tr>
    <td width="10%">C�d. Barra</td>
    <td width="32%">Nome do Contato</td>
    <td width="29%">Cargo do Contato</td>
    <td width="3%">St</td>
    <td width="3%">DI</td>
    <td width="3%">MV</td>
    <td width="3%">CP</td>
    <td width="3%">IC</td>
    <td width="3%">EX</td>
    <td width="3%">RJ</td>
    <td width="8%" align="center">Nasc.</td>
  </tr>
</table>
<table width="90%" border="1" align="center">
  <tr>
    <td width="10%">C�d. Barra</td>
    <td width="32%">Nome do Contato</td>
    <td width="29%">Cargo do Contato</td>
    <td width="3%">St</td>
    <td width="3%">DI</td>
    <td width="3%">MV</td>
    <td width="3%">CP</td>
    <td width="3%">IC</td>
    <td width="3%">EX</td>
    <td width="3%">RJ</td>
    <td width="8%" align="center">Nasc.</td>
  </tr>
</table>
<br>

<table width="90%" border="1" align="center">
  <tr>
    <td width="22%">Evento</td>
    <td width="5%">Edi��o</td>
    <td width="17%" align="center">Per�odo</td>
    <td width="5%">Largura</td>
    <td width="7%">Comprim.</td>
    <td width="5%">�rea</td>
    <td width="16%" align="center">�rea Tipo</td>
    <td width="23%" align="center">Local</td>
  </tr>
</table>
<table width="90%" border="1" align="center">
  <tr>
    <td width="22%">COUROMODA 2006</td>
    <td width="5%">33</td>
    <td width="8%">16/01/2006</td>
    <td width="9%">19/01/2006</td>
    <td width="6%">5,0</td>
    <td width="6%">12,0</td>
    <td width="6%" align="center">60</td>
    <td width="15%">�REA LIMPA</td>
    <td width="23%">BOULEVARD NORT</td>
  </tr>
</table>

<br>

<table width="100%" border="0">
  <tr>
    <td colspan="2">Lista de Produtos para o Cat�logo Oficial</td>
  </tr>
  <tr>
    <td width="11%">Portugu�s...:</td>
    <td width="89%">
					<table width="100%" border="1">
					  <tr>
						<td>Bolsas e Pastas, masculinas e femininas e cintos.</td>
					  </tr>
					</table>
</td>
  </tr>
  <tr>
    <td>Ingles......:</td>
    <td>
					<table width="100%" border="1">
					  <tr>
						<td>Bolsas e Pastas, masculinas e femininas e cintos.</td>
					  </tr>
					</table>
	</td>
  </tr>
  <tr>
    <td>Espanhol</td>
    <td>
					<table width="100%" border="1">
					  <tr>
						<td>Bolsas e Pastas, masculinas e femininas e cintos.</td>
					  </tr>
					</table>	
	</td>
  </tr>
</table>

<?php
$text = '<p>Test paragraph.</p><!-- Comment --> <a href="#fragment">Other text</a>';
echo strip_tags($text);
echo "<br>";

// Allow <p> and <a>
echo strip_tags($text, '<p><a>');
?> 


<br>
<br>
<div align="right"> Impresso em <?php echo date("d/m/Y H:i:s"); ?></div>




</body>
</html>
<?php $objConn = NULL; ?>
