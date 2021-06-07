<?php

/* *********CONFIGURAÇÃO DA PÁGINA PARA IMPRESSÃO DE ETIQUETAS **************/
/* ************ Margem Superior =  12,05 Milimitros *************************/
/* ************ Margem Inferior =  15,05 Milimitros *************************/
/* ************ Margem Esquerda =  15,05 Milimitros *************************/
/* ************ Margem Direita  =  19,05 Milimitros *************************/
/* **************************************************************************/

include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

$id_evento = getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");

$var_evento = request("evento");
$var_credencial = request("credencial");
$var_data = request("data");
$var_nome = request("nome");

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
		echo("<link rel=\"stylesheet\" href=\"../_css/" . CFG_SYSTEM_NAME . ".css\" type=\"text/css\">
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
<style type="text/css">
.folha {
    page-break-after: always;
}
</style>
</head>
<body style="margin-top:50px; margin-left:15px">
		  
<?php	
  
$objConn = abreDBConn(CFG_DB); // Abertura de banco
$strSQL = " select distinct 
			    SUBSTR (cad_montador.nomemont, 1, 50) as nomemont,                                
                cad_montador.endereco  , 
                               
                case when (cad_montador.bairro is null)
                then cad_montador.bairro
                else ' - '||cad_montador.bairro
                end as bairro,     
                           
                cad_montador.cidade,   
                 
                case when (cad_montador.estado is null)
                then cad_montador.estado
                else ' / '||cad_montador.estado
                end as estado,
                
                case when ( upper(cad_montador.pais) ilike 'BRASIL')
                then  cad_montador.cep 
                else cad_montador.pais ||' - '|| cad_montador.cep
                end as cep
                
from            cad_montador
                inner join ped_pedidos
                on              cad_montador.idmont = ped_pedidos.idmontpe
where        

		        cad_montador.idtipocred  = ".$var_credencial."
                and cad_montador.dt_inativo         is null
                and             ped_pedidos.idevento = '".$var_evento."'
                and             ped_pedidos.excluida  = false
                and             ped_pedidos.idstatus  <>'005'
                and (CAST(SUBSTRING(ped_pedidos.IDPEDIDO from '..$') AS INT) = 0)
                and             ped_pedidos.catalogo  = true
order by        nomemont";
										
					try{
					$objResult = $objConn->query($strSQL); // execução da query		
								
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
				$var_lado = true;
				$var_cont = 0;
			  	foreach($objResult as $objRS){
				//$codigo_pedido = getValue($objRS,"idpedido");		  
?>
<?php if ($var_cont == 10) {echo "<div class='folha'></div>"; $var_cont = 0;}?>
<?php  if ($var_lado == true) { $var_lado = false; ?>
<table width="50%" border="0" align="left">  
  <tr>
     <td width="45%"><b><?php echo $var_nome; ?></b></td>
  </tr>
  <tr>
    <td width="45%"><b><?php echo getValue($objRS,"nomemont");  ?></b></td>
  </tr>
  <tr>
    <td width="45%"><?php echo getValue($objRS,"endereco").getValue($objRS,"bairro"); ?></td>
  </tr>
	<tr>
	  <td width="45%"> <?php echo getValue($objRS,"cidade").getValue($objRS,"estado"); ?> </td>
  </tr>
	<tr>
    <td width="45%" height="20"><b><?php echo getValue($objRS,"cep"); ?></b></td>
  </tr>
</table>

  <?php } else {  $var_lado = true; $var_cont++;?>

<table width="60%" border="0" >  
  <tr>
     <td width="15%"></td>
     <td width="85%"><b><?php echo $var_nome; ?></b></td>
  </tr>
  <tr>
    <td width="15%"></td>
    <td width="85%"><b><?php echo getValue($objRS,"nomemont");  ?></b></td>
  </tr>
  <tr>
    <td width="15%"></td>
    <td width="85%"><?php echo getValue($objRS,"endereco").getValue($objRS,"bairro"); ?></td>
  </tr>
  <tr>
	<td width="15%"></td>
	<td width="85%"> <?php echo getValue($objRS,"cidade").getValue($objRS,"estado"); ?></td>
  </tr>
  <tr>
	<td width="15%" height="20">&nbsp;</td>
    <td width="85%" valign="top"><b><?php echo getValue($objRS,"cep"); ?></b></td>
  </tr>
</table>

<?php } ?>

<?php } ?>  

</body>
</html>
<?php $objConn = NULL; ?>
