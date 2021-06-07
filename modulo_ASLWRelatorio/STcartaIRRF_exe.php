<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$dt_inicio = request("dt_inicio");
$dt_final = request("dt_final");



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

// Fun��o M�s Extenso
$mes = date('m');
switch ($mes){
case 1: $mes = "Janeiro"; break;
case 2: $mes = "Fevereiro"; break;
case 3: $mes = "Mar�o"; break;
case 4: $mes = "Abril"; break;
case 5: $mes = "Maio"; break;
case 6: $mes = "Junho"; break;
case 7: $mes = "Julho"; break;
case 8: $mes = "Agosto"; break;
case 9: $mes = "Setembro"; break;
case 10: $mes = "Outubro"; break;
case 11: $mes = "Novembro"; break;
case 12: $mes = "Dezembro"; break;}



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
</head>
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<table align="center" bgcolor="#FFFFFF" width="98%" border="0">
 
  <?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					// SQL Principal	
					try{
					$strSQL = " SELECT DISTINCT 
									erazao
									, erodape
									, razaonf
									, codigonf
									, endereconf
									, bairronf
									, cidadenf
									, estadonf
									, cepnf
									, paispe
								FROM 
									(SELECT * FROM sp_demonstrativo_irrf_new('$id_empresa', '$dt_inicio', '$dt_final')) as SEL
									, tmp_irrf_carta;";
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  		
										
				$objResult = $objConn->query($strSQL); // execu��o da query
			  	foreach($objResult as $objRS){
			  ?>

  <tr>
    <td align="Left" colspan="2"><font size=2><br><br><br><br> S�o Paulo, <?php echo $mes; ?> de <?php echo date("Y"); ?><br><br><br><br><br></font></td>
  </tr>
  <tr>
    <td align="Left" colspan="2"><font size=2>Para<BR></font>	
    		         <font size=2><b><?php echo getValue($objRS,"razaonf") ?> - <?php echo getValue($objRS,"codigonf") ?></b><br></font>
					 <font size=2><?php echo getValue($objRS,"endereconf") ?><br></font>
					 <font size=2><?php echo getValue($objRS,"cepnf")?> - <?php echo getValue($objRS,"cidadenf") ?> / 
					 <?php echo getValue($objRS,"estadonf") ?><br><br><br></font></td>	
  </tr>

	  <tr>
	  <td width="45%"></td>
	  <td align="justify" bgcolor="#FFFFFF" width="55%" >
		<div align="justify"><font size=2><b><br>
		  REF: INFORME DE RENDIMENTOS DO IMPOSTO
		  DE RENDA E CONTRIBUI��ES SOCIAIS RETIDAS
		  NA FONTE
		  </b><br>
	    <br>
	    <br>
	    <br>
		  </font>
	        </div></td>	
	</tr>	
 

  <tr>
  	<td align="justify" colspan="2">   	 
  	  <div align="justify"><font size=2>
	  	Prezado Cliente,<br><br>
		Como at� a presente data n�o recebemos os informes de rendimentos do Imposto de Renda na Fonte e Contribui��es
		Sociais retidas por sua empresa, referentes ao pagamento das parcelas do Contrato de Participa��o de sua empresa
		em nossa feira, relativas ao ano-calend�rio 2008, pedimos conferir os dados constantes nos informes anexos, extra�dos
		de nossos registros.<br><br>

		Para que possamos anexar estes informes aos documentos que comp�em a nossa DIPJ 2009, pedimos colocar o seu
		carimbo (CNPJ) e enviar via correio para o nosso escrit�rio.<br><br>
		
		Caso haja alguma diverg�ncia de informa��o nos referidos documentos, favor reemiti-los com as devidas corre��es, e
		enviar-nos com a m�xima urg�ncia.<br><br>
		
		Vale ressaltar que o prazo para remessa desses informes � de 30 dias do recebimento desta. Caso n�o sejam enviados
		consideraremos os informes anexos como sendo o correto.<br><br>
		
		Contamos com sua colabora��o, subscrevemo-nos.<br><br>
		
		Atenciosamente,<br><br><br><br>
		
		Jorge Alves de Souza<br>
		Diretor Administrativo e Financeiro<br>
		Couromoda Feiras Comerciais Ltda.<br>
 	  </div>
		</font></td>  
  <tr>
  	<!-- Quebra de P�gina -->
	<td style="	page-break-after: always;">	</td>
  </tr> 	
  </tr>
  <?php } ?>
</table>
</body>
</html>
<?php $objConn = NULL; ?>
