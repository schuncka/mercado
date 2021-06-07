<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$var_idevento  = getsession(CFG_SYSTEM_NAME . "_id_evento");
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
<body style="margin:10px 0px 10px 0px;" >	

  <?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					// SQL Principal	
					try{
					$strSQL = "select DISTINCT
									   cad_produto1_categoria.descrprod1     ,
									   cad_produto2_classificacao.descrprod2 ,
									   case
											  when (cad_cadastro.fantasia is null)
											  then cad_cadastro.razao
											  else cad_cadastro.fantasia
									   end as rz_fant                        
								from   cad_produto1_categoria
									   inner join ((ped_pedidos
											  inner join cad_cadastro
											  on     (ped_pedidos.idmercado = cad_cadastro.idmercado)
											  and    (ped_pedidos.codigope  = cad_cadastro.codigo))
											  inner join (cad_cadastro_industriais_produtos
													 inner join cad_produto2_classificacao
													 on     (cad_cadastro_industriais_produtos.idmercado = cad_produto2_classificacao.idmercado)
													 and    (cad_cadastro_industriais_produtos.idprod2   = cad_produto2_classificacao.idprod2))
											  on     (cad_cadastro.codigo                                = cad_cadastro_industriais_produtos.codigo)
											  and    (cad_cadastro.idmercado                             = cad_cadastro_industriais_produtos.idmercado))
									   on     (cad_produto1_categoria.idprod1                            = cad_produto2_classificacao.idprod1)
									   and    (cad_produto1_categoria.idmercado                          = cad_produto2_classificacao.idmercado)
								where  (((ped_pedidos.idstatus)                                         <>'005'
											  and    (ped_pedidos.idstatus)                             <>'100')
									   and    ((ped_pedidos.excluida)                                    =false)
									   and    ((cast(substring(ped_pedidos.idpedido from '..$') as       int)  = 0)
											  or     (cast(substring(ped_pedidos.idpedido from '..$') as int) >= 30))
									   and    ((ped_pedidos.idevento)                                          ='".$var_idevento."')
									   and    ((ped_pedidos.catalogo)                                          =true)
									   and    ((ped_pedidos.portal)                                            =true))
								Order by descrprod1, descrprod2, rz_fant;";
								//die($strSQL);
								$objResult = $objConn->query($strSQL); // execu��o da query	
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
					$var_cont = true;	
					
			  		foreach($objResult as $objRS)  {
					
					
					
					
					if ($var_cont == true) {
					
					$var_descrprod1 = getValue($objRS,"descrprod1") ;?>
					<div style="font-size:10px;"><?php echo($var_descrprod1);?></div>

					
					<?php $var_descrprod2 = getValue($objRS,"descrprod2");?>
					<div style="font-size:10px; padding-left:10px; font:bold"><?php echo($var_descrprod2);?></div><br>
					<?php $var_cont = false;?>					
					<?php }
									
					
					 if ($var_descrprod1 != getValue($objRS,"descrprod1")) {?>					 
					 <div style="font-size:10px;"><?php getValue($objRS,"descrprod1");?></div><br>
					 
					 <?php } 
					 
					 if ($var_descrprod2 != getValue($objRS,"descrprod2")){?>					 
					 <div style="font-size:10px; padding-left:10px; font:bold"><?php getValue($objRS,"descrprod2");?></div><br>
					 <?php }?>
					 
					 <div style="font-size:10px; padding-left:20px;"><?php echo(getValue($objRS,"rz_fant"));?></div><br>
					
                    <?php
						$var_descrprod1 = getValue($objRS,"descrprod1") ;
						$var_descrprod2 = getValue($objRS,"descrprod2") ;				
					 } ?>

					 
<?php $objConn = NULL; ?>