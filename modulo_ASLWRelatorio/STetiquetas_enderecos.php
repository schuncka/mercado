
<?php
ini_set("max_execution_time", 300); //300s = 5min
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

// INI: INCLUDE requests ORDIÀRIOS -------------------------------------------------------------------------------------
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
	 $strRelDesc	   | Descrição do relatório	
	 $strRelHead	   | Cabeçalho do relatório
	 $strRelFoot	   | Rodapé do relatório		
	 $strRelInpts	   | Usado apenas para o log
	 $strDBCampoRet	   | O nome do campo na consulta que deve ser retornado
	 $strDBCampoRet    | **Usado no repasse entre ralatórios - sem o nome da tabela do campo que será retornado
	 -----------------------------------------------------------------------------  */
include_once("_include_aslRunRequest.php");



$dt_inicio 	= request('dt_inicio_date');
$dt_fim 	= request('dt_final_date');

$strSQL = request("var_sql");

// FIM: INCLUDE requests ORDIÀRIOS -------------------------------------------------------------------------------------


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
	 $strDIR           | Pega o diretório corrente (usado na exportação) 
	 $arrModificadores | Array contendo os modificadores ([! ], [$ ], ...) do ASL
	 $strSQL           | SQL PURO, ou seja, SEM os MODIFICADORES, TAGS, etc...
	 -----------------------------------------------------------------------------  */
include_once("_include_aslRunBase.php");
// FIM: INCLUDE funcionalideds BÁSICAS ---------------------------------------------------------------------------------


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

$objConn = abreDBConn(CFG_DB);

/* Este Executor não provê saida visual, ele apenas gera o arquivo html do relatório em questão */
 function echoOnFile($ptFile,$str) {
	/*
	 Os HTML gerados vão para uma pasta do cliente, portanto os caminhos para css, javascript, imagens
	 e chamada para outras págiansphp, devem ser ajustados. O código abaixo ajusta estes caminhos. 
	 **Acho que mais adiante poderemos melhorar essa lógica
	*/ 
	$str = str_replace("../_css/"		,"../../_"  . CFG_SYSTEM_NAME . "/_css/"							 , $str);
	$str = str_replace("../_scripts/"	,"../../_"  . CFG_SYSTEM_NAME . "/_scripts/"						 , $str);
	$str = str_replace("../img/"		,"../../_"  . CFG_SYSTEM_NAME . "/img/"							 	 , $str);
	$str = str_replace("'execaslw.php"	,"'../../_" . CFG_SYSTEM_NAME . "/modulo_ASLWRelatorio/execaslw.php" , $str);
	$str = str_replace("'aslExport.php"	,"'../../_" . CFG_SYSTEM_NAME . "/modulo_ASLWRelatorio/aslExport.php", $str);
	fputs($ptFile,"$str");	// Grava 
 }

 $dirCli  = getsession(CFG_SYSTEM_NAME . "_dir_cliente");
 $arqNome = $intRelCod . "_" . date("Ymd-His") . ".html";
 $local	  = realpath("../../" . $dirCli . "/asl_html/") . "/" . $arqNome;
 
 try { 
 	touch($local); /* Acesso ao arquivo, e se ele nao existir, ele é criado. */ 
	$fp=fopen($local,"w");	// Abre o arquivo pra escrita
 }
 catch(PDOException $e){
	mensagem("Erro de arquivo", "Problema na geração do arquivo HTML deste relatório", "Arquivo: " . $arqNome,  "javascript:window.close();","standarderro",1);
    die();
 }

echoOnFile($fp,"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>");
echoOnFile($fp,"<html>");
echoOnFile($fp,"<head>");
echoOnFile($fp,"<title>" . CFG_SYSTEM_TITLE . " - " . $strRelTit ."</title>");
echoOnFile($fp,"<link rel='stylesheet' href='../_css/" . CFG_SYSTEM_NAME .".css' type='text/css'>\n
				<link rel='stylesheet' type='text/css' href='../_css/tablesort.css'>\n
				<script type='text/javascript' src='../_scripts/tablesort.js'></script>\n");

echoOnFile($fp,"<style type='text/css'>

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
					
					
					.campos{
						border:0px solid #000000;
						height:10px;
					
						overflow: hidden;			
					} 

					

					
					</style>");

echoOnFile($fp,"<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>\n");
echoOnFile($fp,"</head>");
echoOnFile($fp,"<body style='margin-top:0px; margin-left:0px' >");



if($strSQL != "") {
	try{
		$objResult = $objConn->query($strSQL); // Rodando a consulta
		if($objResult->rowCount() == 0 || $objResult == ""){
			echoOnFile($fp,mensagem("alert_consulta_vazia_titulo","alert_consulta_vazia_desc", "", "","aviso",1));
			die();
		}
	}
	catch(PDOException $e){
		echoOnFile($fp,mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1));
		die();
	}
} else {
	echoOnFile($fp,mensagem("info_nova_pesquisa_titulo","info_nova_pesquisa_desc", "", "","info",1));
	die();
}
/* FIM: Execução do SQL ---------------------------------------------------------------------------------------------- */

$id_evento 			= getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa 		= getsession(CFG_SYSTEM_NAME."_id_mercado"); 
$datawide_lang 		= getsession("datawide_lang");



// Varredura da consulta com tratamento dos modificadores e echo das linhas do relatório
$strCOLOR = "#FFFFFF";
$intActuallyCount = 1;
$boolFooter = false;
$id_evento 			= getsession(CFG_SYSTEM_NAME."_id_evento"); 
$datawide_lang 		= getsession("datawide_lang");

$var_lado = true;
$var_cont = 0;

echoOnFile($fp,"<br><br><br>");
foreach($objResult as $objRS) {
	if ($var_cont == 10) { 
			echoOnFile($fp,"<div class='folha'></div><br><br><br>"); 
			$var_cont = 0;
		}
		
	if ($var_lado == true) { 
  		$var_lado = false; 
		echoOnFile($fp,"<table width='45%' border='0' align='left'>  
						  <tr>
							 <td width='45%' ><div class='campos' ><b>". getValue($objRS,'campo_razao') ."</b></div></td>
						  </tr>
						  <tr>
							<td width='45%' style='overflow:hidden'><div class='campos' ><b>". getValue($objRS,'campo_destinatario') ."</b></div> </td>
						  </tr>
						  <tr>
							<td width='45%' style='overflow:hidden'>". getValue($objRS,'campo_endereco') ." - ". getValue($objRS,'campo_bairro') ." </td>
						  </tr>
							<tr>
							<td width='45%' style='overflow:hidden'><B>". getValue($objRS,'campo_cep') ."</B>&nbsp;&nbsp;". getValue($objRS,'campo_cidade'));
		
		if (strtoupper(getValue($objRS,'campo_pais')) != 'BRASIL'){echoOnFile($fp,"&nbsp;&nbsp;&nbsp;-&nbsp;".strtoupper(getValue($objRS,'campo_pais')));  } else {echoOnFile($fp," / ".getValue($objRS,'campo_estado')); } 
		echoOnFile($fp,"	 </td>
							  </tr>
							</table>");
	} else {  
		$var_lado = true; 
		$var_cont++;
		echoOnFile($fp,"<table width='55%' border='0' >  
						  <tr>
							 <td width='15%'>&nbsp;</td>
							 <td width='85%'><div class='campos' ><b>". getValue($objRS,'campo_razao'). "</b></div></td>
						  </tr>
						  <tr>
							<td width='15%'>&nbsp;</td>
							<td width='85%' style='overflow:hidden'><div class='campos' ><b>". getValue($objRS,'campo_destinatario') ."</b></div></td>
						  </tr>
						  <tr>
							<td width='15%'>&nbsp;</td>
							<td width='85%' style='overflow:hidden'>". getValue($objRS,'campo_endereco') ." - ". getValue($objRS,'campo_bairro') ."</td>
						  </tr>
						  <tr>    
							<td width='15%'>&nbsp;</td>
							<td width='85%' style='overflow:hidden'><B>". getValue($objRS,'campo_cep') ."</B>&nbsp;&nbsp;". getValue($objRS,'campo_cidade'));
		
		if (strtoupper(getValue($objRS,'campo_pais')) != 'BRASIL'){echoOnFile($fp,"&nbsp;&nbsp;&nbsp;-&nbsp;".strtoupper(getValue($objRS,'campo_pais')));  } else {echoOnFile($fp," / ".getValue($objRS,'campo_estado')); } 
		echoOnFile($fp,"	 </td>
							  </tr>
							</table>");
		echoOnFile($fp,"<table width='100%' border='0'>
						  <tr>
							<!--MODELO 1 -  26,5px -->
							<!--MODELO 2 -  27,5px -->
							<td height='26,5px'>&nbsp;</td>
						  </tr>
						</table>");
	} // if
} // foreach
			

echoOnFile($fp,"</body>");
echoOnFile($fp,"</html>");

include_once("_include_aslRunHtmlLog.php");   // Grava Log de execução do Relatório (com o nome do HTML gerado)
include_once("_include_aslRunHtmlClear.php"); // Apaga arquivos html de relatórios antigos

$objResult->closeCursor();
$objConn = NULL;

mensagem("info_relgerado_titulo"
        ,"info_relgerado_desc"
		,"<img src='../img/icon_html_view_big.gif' onClick=\"window.open('../../".$dirCli."/asl_html/".$arqNome."','','width=640,height=480,top=30,left=30,scrollbars=1,resizable=yes,status=yes,directories=no,location=0,menubar=no,toolbar=no,titlebar=no');\" style='cursor:pointer; ' border='0' alt='view' title='view'>"
		 ."&nbsp;&nbsp;&nbsp;&nbsp;<a href='aslDownload.php?var_file=../../".$dirCli."/asl_html/".$arqNome."' target='_blank' alt='download HTML' title='download HTML'><img src='../img/icon_html_download_big.gif' border='0'></a>&nbsp;"
		 ."<a href='aslDownload.php?var_file=../../".$dirCli."/asl_html/".str_replace(".html",".csv",$arqNome)."' target='_blank' alt='download CSV' title='download CSV'><img src='../img/icon_csv_download_big.gif' border='0'></a>&nbsp;"
		 ."&nbsp;(". str_replace(".html","",$arqNome). ")"
		,"javascript:history.back();"
		,"info"
		,1);
?>