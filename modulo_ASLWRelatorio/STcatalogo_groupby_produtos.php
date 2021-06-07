<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$var_idevento  = getsession(CFG_SYSTEM_NAME . "_id_evento");
$dt_final  = request("dt_final");
$var_chavereg  = request("var_chavereg");



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
								$objResult = $objConn->query($strSQL); // execução da query	
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