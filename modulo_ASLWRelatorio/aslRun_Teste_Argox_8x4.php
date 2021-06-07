<?php
header("Cache-Control:no-cache, must-revalidate");
header("Pragma:no-cache");

include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

// INI: INCLUDE requests ORDINÁRIOS -------------------------------------------------------------------------------------
/*
 Por definição esses são os parâmetros que a página anterior de preparação (execaslw.php) manda para os executores.
 Cada executor pode utilizar os parâmetros que achar necessário, mas por definição queremos que todos façam os
 requests de todos os parâmetros enviados, como no caso abaixo:
 Variáveis e Carga:
	 -----------------------------------------------------------------------------
	 variável          | "alimentação"
	 -----------------------------------------------------------------------------
	 $data_ini         | DataHora início do relatório
	 $intRelCod		   | Código do relatórioRodapé do relatório
	 $strRelASL		   | ASL - Conulta com parâmetros processados, mas TAGs e Modificadores 
	 $strRelSQL		   | SQL - Consulta no formato SQL (com parâmetros processados e "limpa" de TAGs e Modificadores)
	 $strRelTit		   | Nome/Título do relatório
	 $strRelDesc	   | Descriçãoo do relatório	
	 $strRelHead	   | Cabeçalho do relatório
	 $strRelFoot	   | Rodapé do relatório		
	 $strRelInpts	   | Usado apenas para o log
	 $strDBCampoRet	   | O nome do campo na consulta que deve ser retornado
	 $strDBCampoRet    | **Usado no repasse entre ralatórios - sem o nome da tabela do campo que será retornado
	 -----------------------------------------------------------------------------  */
include_once("../modulo_ASLWRelatorio/_include_aslRunRequest.php");
// FIM: INCLUDE requests ORDIÃ€RIOS -------------------------------------------------------------------------------------


// INI: INCLUDE funcionalideds BÁSICAS ---------------------------------------------------------------------------------
/* Funções
	 filtraAlias($prValue)
	 ShowDebugConsuta($prA,$prB)
	 ShowCR("CABECALHO/RODAPE",str)
  Ações:
  	 SEGURANÇA: Faz verificação se existe usuário logado no sistema
  Variáveis e Carga:
	 -----------------------------------------------------------------------------
	 variável          | "alimentação"
	 -----------------------------------------------------------------------------
	 $strDIR           | Pega o diretporio corrente (usado na exportação) 
	 $arrModificadores | Array contendo os modificadores ([! ], [$ ], ...) do ASL
	 $strSQL           | SQL PURO, ou seja, SEM os MODIFICADORES, TAGS, etc...
	 -----------------------------------------------------------------------------  */
include_once("../modulo_ASLWRelatorio/_include_aslRunBase.php");
// FIM: INCLUDE funcionalideds BÁSICAS ---------------------------------------------------------------------------------

function convertem($term, $tp) { 
	if ($tp == "1") $palavra = strtr(strtoupper($term),"àáâãäåæçèéêëìíîïðñòóôõö÷øùüúþÿ","ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÜÚÞß"); 
	elseif ($tp == "0") $palavra = strtr(strtolower($term),"ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÜÚÞß","àáâãäåæçèéêëìíîïðñòóôõö÷øùüúþÿ"); 
	return $palavra; 
}

$strDirCliente = getsession(CFG_SYSTEM_NAME . "_dir_cliente");

//Recebe os parâmetros. Deixei apenas o parãmetro no ASLW para evitar que o SQL deste relatório seja alterado indevidamente.
$strRelSQL = str_replace('\'','',$strRelSQL);
list($strSocio, $intSegmento, $intAtividade, $intCodPJ, $strDepartamento) = explode(',',$strRelSQL);
//echo('Sócio '.$strSocio.' Segmento '.(string)$intSegmento.' Atividade '.(string)$intAtividade.' CodPj '.(string)$intCodPJ.' Departamento '.$strDepartamento);
?>
<html>
<head>
<STYLE TYPE="text/css">
hr    { color: #000000; height:1px; border-style: dotted; }
			
<?php 
	//ETIQUETA 8x4 
	echo("<STYLE TYPE='text/css'>");
	echo(" hr { color: #000000; height:1px; border-style: dotted; }");
	echo(" div.box    { margin-bottom:10px; width:230px; border:1px #FFFFFF solid; }");
	echo(" div.linha1 { width:225px; height:25px; overflow:hidden; border:0px solid #0000FF; font-family:'Arial Narrow'; font-size:20px; font-weight:bold; }");
	echo(" div.linha2 { width:225px; height:8px;  overflow:hidden; border:0px solid #FF0000}");
	echo(" div.linha3 { width:225px; height:20px; overflow:hidden; border:0px solid #00FF00; font-family:'Arial Narrow'; font-size:15px; font-weight:bold; }");
	echo(" div.linha4 { width:225px; height:40px; overflow:hidden; border:0px solid #FFFF33; font-size:10px; }");
	echo(" div.linha5 { width:225px; height:25px; overflow:hidden; border:0px solid #FF00FF; font-family:'Arial Narrow'; font-size:15px; font-weight:bold; }");
	echo("</style>");
?>

</style>
</head>
<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<?php // antes estava 90px e eu coloquei 30px?>
<body marginheight="0" marginwidth="0" leftmargin="10px" rightmargin="0" topmargin="10px">

<?php
$objConn = abreDBConn(CFG_DB); // Abertura de banco

$strSQL = "	SELECT pj.razao_social  AS razao_social
                   ,COALESCE(pf.nome,'') AS nome_pf
                   ,COALESCE(pj.endcobr_logradouro,'') AS logradouro 
                   ,COALESCE(pj.endcobr_numero,'') AS numero
                   ,COALESCE(pj.endcobr_complemento,'') AS complemento 
                   ,pj.endcobr_bairro AS bairro            
                   ,COALESCE(pf_pj.departamento,'') AS departamento
                   ,pj.endcobr_cep AS cep
                   ,pj.endcobr_cidade AS cidade
                   ,pj.endcobr_estado AS estado
                   ,pj.endcobr_pais AS pais
              FROM relac_pj_pf pf_pj
              LEFT OUTER JOIN cad_pj pj ON (pf_pj.cod_pj = pj.cod_pj)
              LEFT OUTER JOIN cad_pf pf ON (pf_pj.cod_pf = pf.cod_pf)
              WHERE pf.dtt_inativo is null ";	
if($strSocio != "") $strSQL .= " AND pj.socio = '".$strSocio."'";
if(($intSegmento != "")&&($intSegmento > 0)) $strSQL .= " AND pj.cod_segmento = ".$intSegmento;
if(($intAtividade != "")&&($intAtividade > 0)) $strSQL .= " AND pj.cod_atividade = ".$intAtividade;
if(($intCodPJ != "")&&($intCodPJ > 0)) $strSQL .= " AND pj.cod_pj = ".$intCodPJ;
if($strDepartamento != "") $strSQL .= " AND pf_pj.departamento = '".$strDepartamento."'";
										
try{
//die($strSQL);
$objResult = $objConn->query($strSQL); // execução da query										
}catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
}
$total_impressao = $objResult->rowCount();
$cont_impressao = 0;
foreach($objResult as $objRS){
	$cont_impressao++;
?>			
<center>  
<table align="center" border="0" <?php if($total_impressao <> $cont_impressao){	echo "style='page-break-after:always'"; }?>>
<tr>
	<td>
	<div align="center" class='box'>	
		<div class="linha1" align="center">	<?php echo strtoupper(getValue($objRS,"razao_social")); ?></div>
		<div class="linha2" align="center"> <?php echo strtoupper("A/C ".getValue($objRS,"nome_pf")."Depto ".getValue($objRS,"departamento")); ?> </div>
		<div class="linha3" align="center">	<?php echo strtoupper(getValue($objRS,"logradouro").", ".getValue($objRS,"numero")); ?></div>		
        <div class="linha2" align="center"> <?php echo strtoupper(getValue($objRS,"complemento")); ?> </div>		
        <div class="linha2" align="center"> <?php echo strtoupper(getValue($objRS,"bairro")); ?> </div>				
        <div class="linha2" align="center"> <?php echo strtoupper(getValue($objRS,"cep")); ?> </div>						
        <div class="linha2" align="center"> <?php echo strtoupper(getValue($objRS,"cidade").", ".getValue($objRS,"estado").", ".getValue($objRS,"pais")); ?> </div>								
		<div class="linha5" align="center">	<?php //echo($strFantasia); ?></div>
		<div class="linha2" align="center"> <hr> </div>		
		<div class="linha4" align="center">	<?php //echo barCode39(getValue($objRS,"codbarra"),true,30); ?></div>	
	</div>	
	</td>
</tr>
</table>
</center>
<?php 
 
} 

?>
<script type="text/javascript">
	alert("Para Imprimir Pressione CTRL+P e Selecione a Impressora");
</script>
</body>
</html>
<?php $objConn = NULL; ?>
