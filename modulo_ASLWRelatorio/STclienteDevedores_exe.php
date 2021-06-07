<?php

include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
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

// Função Mês Extenso
$mes = date('m');
switch ($mes){
case 1: $mes = "Janeiro"; break;
case 2: $mes = "Fevereiro"; break;
case 3: $mes = "Março"; break;
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

.folha {
    page-break-after: always;
}
</style>
</head>
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >

<?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco
					
					try{
					$strSQL = "Select * from sp_cria_tmp_Inadimplentes('$dt_final');";
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
				
				$objResult = $objConn->query($strSQL); // execução da query					
				
				
					// SQL Principal	
					try{
					$strSQL = "SELECT DISTINCT 
											razaope,
											enderecope,
											ceppe,
											estadope,
											contato,
											cidadepe,
											nome_completo,
											idpedido,
											codigope
										FROM 
											tmp_Inadimplentes
										ORDER BY
											tmp_Inadimplentes.razaope;";
				$objResult = $objConn->query($strSQL); // execução da query							
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  		
										
				
			  	foreach($objResult as $objRS){
				$codigo_pedido = getValue($objRS,"idpedido");
			  
			  ?>
<table class="folha" bgcolor="#FFFFFF"> <tr> <td>
			
<table width="100%" border="0">
	<tr>
	  <td>
	<font size="2"> São Paulo, <?php echo date('d').' de '.$mes.' '.date("Y"); ?> </font> <br><br><br><br></td>
	</tr>
	<tr>
	  <td> <font size=2>Para<BR></font> 
		<font size=2><b><?php echo getValue($objRS,"razaope") ?> - <?php echo getValue($objRS,"codigope") ?></b><br></font> 
		<font size=2><?php echo getValue($objRS,"enderecope") ?><br></font> 
		<font size=2><?php echo getValue($objRS,"ceppe")?> - <?php echo getValue($objRS,"cidadepe") ?> / <?php echo getValue($objRS,"estadope") ?><br>
      <?php echo getValue($objRS,"contato") ?></font> <br><br><br>
	  </td>
	</tr>
</table>


<table width="100%" border="0">
  <tr>
    <td width="4%"><font size=2><b> REF: </b> </font></td>
    <td width="96%"><font size=2><b> Débito pendente na <?php echo getValue($objRS,"nome_completo") ?> </b> </font></td>
  </tr>
  <tr>
    <td></td>
    <td><font size=2><b> CONTRATO n° <?php echo getValue($objRS,"idpedido") ?></b></font></td>
  </tr>
</table>
<br><br><br>
<table width="100%" border="0">
  <tr>
    <td><font size=2>Prezado Senhores, </font></td>
  </tr>
  <tr>
    <td><font size=2>Constatamos em nossos registros que as obrigações abaixo se encontram pendentes de pagamento</font></td>
  </tr>
</table>

<table  class="bordasimples" width="100%" border="0" >
      <tr>
        <td width="16%" align="center"><font size=2>Nº Duplicata</font></td>
        <td width="4%"  align="center"><font size=2>Parcela</font></td>
        <td width="13%"  align="center"><font size=2>Vencto</font></td>
        <td width="19%" align="right"><font size=2>Valor Bruto (R$)</font></td>
        <td width="10%" align="right"><font size=2>CSS (R$)</font></td>
        <td width="10%" align="right"><font size=2>IRRF (R$)</font></td>
        <td width="14%" align="right"><font size=2>Juros/dia (R$)</font></td>
        <td width="14%" align="center"><font size=2>Atraso (dias)</font></td>
      </tr>
	  
      <?php
					// SQL Principal	
					try{
					$strSQL = "SELECT
									codigope, 
									nroduplicata,
									parcelaped,
									to_char( vencimentoped , 'dd/mm/yyyy') as vencimentoped,
									valorpar,
									CURRENT_DATE - vencimentoped as atraso,
									
									CASE WHEN (valorpar >= 5000) THEN (valorpar * 0.0465) ELSE '0' END as css,
									CASE WHEN (valorpar >= 665) THEN (valorpar * 0.015) ELSE '0' END AS  irrf,    
									(valorpar * 0.0013) as juros_dia
									
								FROM
									tmp_Inadimplentes
									
								WHERE								 
									tmp_Inadimplentes.idpedido = '$codigo_pedido'
								ORDER BY
									nroduplicata;";
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  		
										
				$objResult = $objConn->query($strSQL); // execução da query
			  	foreach($objResult as $objRS){
			
			   ?>
      <tr>
        <td width="16%" align="center"><font size=2><?php echo getValue($objRS,"nroduplicata"); ?></font></td>
        <td width="4%" align="center"><font size=2><?php echo number_format(getValue($objRS,"parcelaped"),0) ; ?></font></td>
		<td width="13%" align="center"><font size=2><?php echo getValue($objRS,"vencimentoped"); ?></font></td>
        <td width="19%"align="right"><font size=2><?php echo number_format(getValue($objRS,"valorpar"),2, ',', '') ; ?></font></td>
		
		
		
		
		<td width="10%"align="right"><font size=2><?php echo number_format(getValue($objRS,"css"),2, ',', '') ; ?></font></td>
		<td width="10%"align="right"><font size=2><?php echo number_format(getValue($objRS,"irrf"),2, ',', '') ; ?></font></td>
		<td width="14%"align="right"><font size=2><?php echo number_format(getValue($objRS,"juros_dia"),2, ',', '') ; ?></font></td>
		
		
		
        <td width="14%"align="center"><font size=2><?php echo number_format(getValue($objRS,"atraso"),0) ; ?></font></td>
      </tr>
      <?php } ?>
    </table>
	<br><br>
<table width="100%"  border="0">
  <tr>
    <td a align="justify"> <div align="justify"><font size=2> Com a regularização do compromisso demonstrado acima poderemos resguardar direitos e responsabilidades, e desta
      forma manter atualizadas as informações cadastrais.<br>
      <br>
      Esta regularização poderá ser efetuada pelo pagamento do boleto bancário em seu poder, acrescidos os juros devidos,
      ou através de depósito bancário identificado, cujo código de identificação será fornecido através do fone - 11-3897.6100
      - Ramais 181,182 ou 184.<br>
      <br>
      Caso os mesmos tenham sido pagos, pedimos o envio do comprovante de pagamento através do FAX (11) 3897-6160,
      desta forma poderemos localizar o referido crédito junto ao banco cobrador.<br>
      <br>
      Colocamo-nos à disposição para maiores informações, e despedimo-nos.<br>
      <br>
      Atenciosamente,<br>
      <br>
      <br>
      <br>
      Ana santos<br>
      Gerencia Financeira<br>
      Hospitalar Feiras, Congressos e Empreendimentos Ltda.</font> <br>
      <br>
      <br>
    </div></td>
  </tr>
</table>
</table> </tr> </td>
 <!-- Quebra de página-->
 <div class="folha"></div>
  <?php } ?>

<?php
try{
					$strSQLproc = "SELECT * FROM sp_drop_temporarias('tmp_Inadimplentes')";
									$objConn->query($strSQLproc);
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
?>

</body>
</html>
<?php $objConn = NULL; ?>