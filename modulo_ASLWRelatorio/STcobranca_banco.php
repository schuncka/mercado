<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");
//$id_evento = getsession('datawide_'."id_evento");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$dt_inicio = request("dt_inicio");
$dt_final = request("dt_final");


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

    thead { display: table-header-group; }
    tfoot { display: table-footer-group; }
</STYLE>

</head>
<body style="margin:10px 0px 10px 0px;">
<img style="display:none" id="img_collapse">

<?php

$var_bol_header = false;
$var_bol_footer = false;
$var_nome_completo = '';
$var_descrbanco = ''; 
$var_cont_duplicata = 0;
$var_valorliq_soma = 0;
$var_desc_fin = 0;
$var_total_cont_duplicata = 0;
$var_tota_valorliq_soma = 0;
$var_tota_desc_fin = 0;
$var_footer_um = 0;
$var_footer_dois = 0;
$var_footer_tres = 0;


			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = "select * from sp_cria_tmp_cobranca_banco('".$dt_inicio."','".$dt_final."','".$id_empresa."');";
							$objResult = $objConn->query($strSQL); // execução da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
					try{				
							$strSQL = "Select
											idevento, 
											descrbanco,
											erazao,
											to_char(vencimentoped, 'DD/MM/YYYY') AS vencimentoped1,
											idempresa, 
											razaope,
											to_char(dataemi, 'DD/MM/YYYY') AS dataemi1, 
											nroduplic,
											parcelaped,
											valorpar,
											irrf,
											desc_fin,
											datafat,
											to_char(datapgto, 'DD/MM/YYYY') AS datapgto1,
											excluida, 			
											idstatus, 			
											confirmado, 
											nome_completo,
											css,
											vlriss,
		  								    valorpar - irrf - css - vlriss AS soma										
									   from 
									   		sp_cria_tmp_cobranca_banco('".$dt_inicio."','".$dt_final."','".$id_empresa."'),
										    tmp_cobranca_banco
									   Order by
									   		nome_completo,
											descrbanco,
											razaope,
											nroduplic;";
											
							$objResult = $objConn->query($strSQL); // execução da query
							$linhas = $objResult->rowCount();
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  	foreach($objResult as $objRS){
					$var_cont_duplicata++;
				?>

<?PHP if ($var_descrbanco != getValue($objRS,"descrbanco")){ ?>

<?PHP if ($var_bol_footer == true){ ?>

<table border="0" width="100%" bgcolor="#FFFFFF" class="bordasimples">
  <tr>
	<?PHP $var_total_cont_duplicata = $var_total_cont_duplicata + $var_cont_duplicata; ?>
	<?PHP $var_tota_valorliq_soma = $var_tota_valorliq_soma + $var_valorliq_soma; ?>
	<?PHP $var_tota_desc_fin = $var_tota_desc_fin + $var_desc_fin; ?>
			
	<td width="14%" align="center" style="border-right:none;  border-left:none"> <?php echo $var_cont_duplicata ?> Duplicatas </td>
	<td width="7%" style="border-right:none; border-left:none">&nbsp;  </td>
	<td width="10%" style="border-right:none; border-left:none"><?php echo number_format(($var_valorliq_soma), 2, ',', '.'); ?> </td>
	<td width="69%" style="border-right:none; border-left:none"><?php echo number_format(($var_desc_fin), 2, ',', '.'); ?> </td>
  </tr>
</table>
<br>
<?PHP $var_cont_duplicata = 0; $var_valorliq_soma = 0; $var_desc_fin = 0; } ?>



<?PHP if ($var_nome_completo != getValue($objRS,"nome_completo")){ ?>

<?PHP if ($var_bol_header == true){ ?>
	<div class='folha'></div>
<?PHP } ?>

	<table  border="0" width="100%" >
	  <tr>
		<td width="72%"><font size="2"><b> <?php echo getValue($objRS,"erazao") ?> </b></font></td>
		<td width="28%"><font size="2"><b> Cobrança por Banco </b></font></td>
	  </tr>
	  <tr>
		<td width="72%" colspan="4">&nbsp;  </td>
	  </tr>
	</table>
	<table  border="0" width="100%" >
	  <tr>
		<td width="39%"><?PHP echo date("d/m/Y"); ?>   <?PHP echo date("H:i:s"); ?>		</td>
		<td width="61%" colspan="1"><b> Período de <?PHP echo $dt_inicio; ?> até <?PHP echo $dt_final; ?> </b></td>	     
	</table>


	<table border="0" width="100%" bgcolor="#FFFFFF" class="bordasimples">
	  <tr>
		<td width="14%" align="center" style="border-right:none; border-left:none">Duplicata/Parcela</td>
		<td width="6%" align="left" style="border-right:none; border-left:none">Vencto</td>
		<td width="11%" align="left" style="border-right:none; border-left:none">Valor Liq Imp</td>
		<td width="10%" align="left" style="border-right:none; border-left:none">Desc. Financ.</td>
		<td width="14%" align="left" style="border-right:none; border-left:none">Dt. Pagto</td>
		<td width="45%" align="center" style="border-right:none; border-left:none">Clientes - Razão Social / CNPJ</td>

	  </tr>
	</table>
	
<table border="0" width="100%" >
  <tr>
	<td width="50%" align="left" bgcolor="#000000"><font size="2" color="#FFFFFF"><b> <?php echo getValue($objRS,"nome_completo") ?> </b></font></td>
	<td width="50%" colspan="4">&nbsp;  </td>
  </tr>
</table> 

<?PHP $var_nome_completo = getValue($objRS,"nome_completo"); $var_bol_header = true; $var_bol_footer = true; }  ?>	




<table border="0" width="100%" >	  
   <tr>
	<td colspan="4"><font size="2"><b> <?php echo getValue($objRS,"descrbanco") ?> </b></font></td>	  
   </tr>
</table>

<?PHP $var_descrbanco = getValue($objRS,"descrbanco"); }  ?>	




<table border="0" width="100%" >
  <tr>
 	<?PHP $var_valorliq_soma = $var_valorliq_soma + getValue($objRS,"soma"); ?>
	<?PHP $var_desc_fin = $var_desc_fin + getValue($objRS,"desc_fin"); ?>
	 
  	<td width="11%" align="center"> <?php echo getValue($objRS,"nroduplic") ?> </td>
  	<td width="8%" align="center"> <?php echo getValue($objRS,"vencimentoped1") ?> </td>	
  	<td width="9%" align="center">  <?php echo number_format(getValue($objRS,"soma"), 2, ',', '.'); ?> </td>		
  	<td width="8%" align="center"> <?php echo number_format(getValue($objRS,"desc_fin"), 2, ',', '.'); ?> </td>
  	<td width="9%" align="center"> <?php echo getValue($objRS,"datapgto1"); ?> </td>
  	<td width="55%" align="left"> <?php echo getValue($objRS,"razaope"); ?> </td>
	
<?PHP $var_footer_um = $var_cont_duplicata;  ?>
<?PHP $var_footer_dois = $var_valorliq_soma;  ?>
<?PHP $var_footer_tres = $var_desc_fin;  ?>	
  </tr>
</table>


<?PHP } ?>

<table border="0" width="100%" bgcolor="#FFFFFF" class="bordasimples">
  <tr>
	<td width="14%" align="center" style="border-right:none;  border-left:none"> <?php echo $var_footer_um ?> Duplicatas </td>
	<td width="7%" style="border-right:none; border-left:none">&nbsp;  </td>
	<td width="10%" style="border-right:none; border-left:none"><?php echo number_format(($var_footer_dois), 2, ',', '.'); ?> </td>
	<td width="69%" style="border-right:none; border-left:none"><?php echo number_format(($var_footer_tres), 2, ',', '.'); ?> </td>
  </tr>
</table>
<br>
<table border="0" width="100%" bgcolor="#FFFFFF" class="bordasimples">
  <tr>
	<td width="14%" align="center" style="border-right:none;  border-left:none"> <?php echo $var_total_cont_duplicata + $var_cont_duplicata ?> Duplicatas </td>
	<td width="7%" style="border-right:none; border-left:none">&nbsp;  </td>
	<td width="10%" style="border-right:none; border-left:none"><?php echo number_format(($var_tota_valorliq_soma + $var_valorliq_soma), 2, ',', '.'); ?> </td>
	<td width="69%" style="border-right:none; border-left:none"><?php echo number_format(($var_tota_desc_fin + $var_desc_fin), 2, ',', '.'); ?> </td>
  </tr>
</table>
<br>



<?php 

try{
		$strSQLproc = "SELECT * FROM sp_drop_temporarias('tmp_cobranca_banco')";
						$objConn->query($strSQLproc);
		}catch(PDOException $e){
				mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
				die();
		}
?>

</body>
</html>
<?php $objConn = NULL; ?>
