<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");
$codCli 		    = getsession(CFG_SYSTEM_NAME."_id_entidade");
$id_evento			= getsession(CFG_SYSTEM_NAME."_id_evento");
$id_empresa			= getsession(CFG_SYSTEM_NAME."_id_mercado");		
$var_tipo           = request("var_tipo");


?>
<html>
<head>
<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


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

.folha {
    page-break-before: always;
}
</style>
</head>
<body style="margin:10px 0px 10px 0px;">
<img style="display:none" id="img_collapse">
<div align="center">
	<b>	LISTA DE CREDENCIAIS JÁ CADASTRADAS NO EVENTO <?php echo getsession(CFG_SYSTEM_NAME."_nome_completo_evento"); ?></b> </div>
</div>
<BR><BR>

<table align="center" border="0" width="80%" bgcolor="#FFFFFF" class="bordasimples">


 <tr>			
 				<td width="20%"  align="center"><b> CPF </b></td>
				<td width="50%"  align="center"><b> NOME </b></td>
				<td width="30%"  align="center"><b> CARGO </b> </td>
</tr>

<?php 
$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
					$strSQL = "select * 
								from relac_montador_prestador a
									inner join cad_prestador_pf b 
									on (a.cpf = b.cpf)
								where 
									a.idevento = '".$id_evento."'
									and a.idmont = '".$codCli."'
									and tipo  = '".$var_tipo."'									
								ORDER BY nomecred;";


					$objResult = $objConn->query($strSQL); // execução da query	
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}	
					$cont_mont=0;
					foreach($objResult as $objRS){
					$cont_mont++;
?>
		
			  <tr>
			  	<td width="20%" > <?php echo  getValue($objRS,"cpf");  ?> </td>
				<td width="50%" > <?php echo  getValue($objRS,"nomecred");  ?> </td>
				<td width="30%" > <?php echo  getValue($objRS,"cargo");  ?> </td>
			  </tr>
			
<?php		} ?>

</table>
<br>

<table width="90%">
	<tr>
	  <td class="texto" align="right">Quantidade de Credenciais: <?php echo $cont_mont; ?></font>
	</td>
</tr>
</table>



<script type="text/javascript">

function fechar()
{
  print();
  setTimeout("window.close()",50)
}

fechar();


	window.close();
</script>

</body>
</html>
<?php $objConn = NULL; ?>
