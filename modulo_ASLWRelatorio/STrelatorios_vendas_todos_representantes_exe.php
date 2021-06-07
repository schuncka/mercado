<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");
$id_evento = getsession('datawide_'."id_evento");

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
	
<STYLE TYPE="text/css">
.folha {
    page-break-after: always;
}
</STYLE>
	
<style type="text/css">

table.bordasimples {border-collapse: collapse;}
table.bordasimples tr td {border:1px solid #000000;}

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
<body style="margin:10px 0px 10px 0px;"  >
<img style="display:none" id="img_collapse">
<?php
$soma = 0;
$contador = 30;
$nomerepre = '';
$datape = 0;
$var_quebra = false; 
$var_quebra2 = false; 

			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = "SELECT 
											ped_pedidos.idreprepe, 
											cad_representantes.nomerepre, 
											ped_pedidos.idpedido, 
											to_char(ped_pedidos.datape, 'DD/MM/YYYY') AS datape, 
											ped_pedidos.razaope, 
											ped_pedidos.idevento, 
											cad_evento.nome_completo, 
											cad_evento.edicao, 
											cad_evento.dt_inicio, 
											cad_evento.dt_fim,
											date_part('day', cad_evento.dt_inicio) as diainicio,
											date_part('day', cad_evento.dt_fim) as diafinal,
											date_part('month', cad_evento.dt_fim) as mes,
											date_part('year', cad_evento.dt_fim) as ano,       
											cad_evento.pavilhao, 
											cad_pavilhao.descrpavilhao, 
											ped_pedidos.localpe, 
											ped_pedidos_produtos.quant_pedi AS areat
										FROM 
											(cad_evento 
											INNER JOIN 
											((ped_pedidos 
											LEFT JOIN 
											cad_pavilhao 
												ON ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao) 
											INNER JOIN 
											cad_representantes 
												ON (ped_pedidos.idmercado = cad_representantes.idmercado) 
												AND (ped_pedidos.idreprepe = cad_representantes.idrepre)) 
												ON cad_evento.idevento = ped_pedidos.idevento) 
											INNER JOIN 
											ped_pedidos_produtos 
												ON (ped_pedidos.idpedido = ped_pedidos_produtos.idpedido) 
												AND (ped_pedidos.idmercado = ped_pedidos_produtos.idmercado)
										WHERE 
											((ped_pedidos.idevento = '$id_evento') 
											AND SUBSTRING(ped_pedidos_produtos.idproduto from '..') Like 'AR'     
											AND (ped_pedidos.idstatus Like '003') 
											AND (ped_pedidos_produtos.desc_pedi <> 1) 
											AND (ped_pedidos.excluida = FALSE)    
											AND (CAST(SUBSTRING(ped_pedidos.IDPEDIDO from '..$') AS INT) = 0) 
												OR (CAST(SUBSTRING(ped_pedidos.IDPEDIDO from '..$') AS INT) >= 30) 
											AND (ped_pedidos.catalogo = TRUE))
										ORDER BY
											cad_representantes.nomerepre,
											datape,
											ped_pedidos.idpedido;";
											
							$objResult = $objConn->query($strSQL); // execu��o da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  	foreach($objResult as $objRS){

				if($contador == 30){	
				
				if ($var_quebra == true){					
					echo "<div class='folha'> </div>";
				}
				    $var_quebra = false;				
			  ?>
			  
		  
<table width="100%" border="0" bgcolor="#FFFFFF">
  <tr>
    <td colspan="5" align="center"><font size="3"><b> <?php echo getValue($objRS,"nome_completo") ?> - <?php echo getValue($objRS,"edicao")?>� Edi��o - de <?php echo getValue($objRS,"diainicio")?> a <?php echo getValue($objRS,"diafinal")?> de <?php echo getMesExtensoFromMes(getValue($objRS,"mes"))?> de <?php echo getValue($objRS,"ano")?> - <?php echo getValue($objRS,"pavilhao")?> </b></font></td>
  </tr>
  <tr>
    <td colspan="5" align="center"><font size="3"><b> Renova��o (Exceto Reservas) </b></font></td>
  </tr>
</table> 

<table width="100%" border="0" class="bordasimples" style="border-right:none; border-left:none" bgcolor="#FFFFFF">  
  <tr>
    <td colspan="4" width="25%" style="border-right:none; border-left:none; border-bottom:none">Representante</td>
  </tr>
  <tr>
    <td colspan="1" width="25%" align="center" style="border-right:none; border-left:none; border-top:none; border-bottom:none">Data Venda</td>
  </tr>
  <tr>
    <td colspan="1" width="25%" align="right" style="border-right:none; border-left:none; border-top:none">N�Pedido</td>
    <td colspan="2" width="50%" align="center" style="border-right:none; border-left:none; border-top:none">Nome do Expositor/Cliente</td>
    <td colspan="1" width="25%" align="right" style="border-right:none; border-left:none; border-top:none">�rea Vendida</td>
  </tr>
</table>

<?PHP $contador = 0; } ?>

<?PHP
	if ($nomerepre != getValue($objRS,"nomerepre")){ ?>

<?PHP   if ($var_quebra2 == true){?>
		
	<hr>
	<table width="100%" border="0">
	  <tr>
		<td width="16%" align="right">&nbsp;  </td>
		<td width="70%"> Total de �rea vendida pelo Representante <?php echo getValue($objRS,"nomerepre")?> </td>
		<td width="14%" align="right"><font size="1"> <?php echo number_format($soma ,2, ',', '.');?> </font></td>	
	  </tr>
	</table>

<?PHP
		echo "<div class='folha'> </div>";
		}
		$var_quebra2 = true;	
?>


<?PHP $soma = 0; ?>

	<font size="1"><b> <?php echo getValue($objRS,"idreprepe")?> - <?php echo getValue($objRS,"nomerepre")?> </b></font><br>
	
<?PHP $nomerepre = getValue($objRS,"nomerepre"); } ?>






<?PHP
	if ($datape != getValue($objRS,"datape")){ ?>

	<font size="1"><b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo getValue($objRS,"datape")?> </b></font><br>
	
<?PHP $datape = getValue($objRS,"datape"); } ?>



						  
  <table width="100%" border="0">
	<tr>
		<td width="18%" align="right"> |_____</td>
		<td width="11%"><font size="1"> <?php echo getValue($objRS,"idpedido"); ?> </font></td>
		<td width="56%"><font size="1"> <?php echo getValue($objRS,"razaope"); ?> </font></td>
		<td width="15%" align="right"><font size="1"> <?php echo number_format(getValue($objRS,"areat"),2, ',', '.');?> </font></td>						
	</tr>
  </table>
 <!-- Quebra de p�gina-->
 <div class="folha"></div>
	      
  <?PHP $contador++; $soma = $soma + getValue($objRS,"areat"); ?>							  
<?PHP }?>	  

</body>
</html>
<?php $objConn = NULL; ?>
