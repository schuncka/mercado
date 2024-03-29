<?php
ini_set("max_execution_time", 300); //300s = 5min
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

// INI: INCLUDE requests ORDIN�RIOS -------------------------------------------------------------------------------------
/*
 Por defini��o esses s�o os par�metros que a p�gina anterior de prepara��o (execaslw.php) manda para os executores.
 Cada executor pode utilizar os par�metros que achar necess�rio, mas por defini��o queremos que todos fa�am os
 requests de todos os par�metros enviados, como no caso abaixo:
 Vari�veis e Carga:
	 -----------------------------------------------------------------------------
	 vari�vel          | "alimenta��o"
	 -----------------------------------------------------------------------------
	 $data_ini         | DataHora in�cio do relat�rio
	 $intRelCod		   | C�digo do relat�rioRodap� do relat�rio
	 $strRelASL		   | ASL - Conulta com par�metros processados, mas TAGs e Modificadores 
	 $strRelSQL		   | SQL - Consulta no formato SQL (com par�metros processados e "limpa" de TAGs e Modificadores)
	 $strRelTit		   | Nome/T�tulo do relat�rio
	 $strRelDesc	   | Descri��o do relat�rio	
	 $strRelHead	   | Cabe�alho do relat�rio
	 $strRelFoot	   | Rodap� do relat�rio		
	 $strRelInpts	   | Usado apenas para o log
	 $strDBCampoRet	   | O nome do campo na consulta que deve ser retornado
	 $strDBCampoRet    | **Usado no repasse entre ralat�rios - sem o nome da tabela do campo que ser� retornado
	 -----------------------------------------------------------------------------  */
include_once("_include_aslRunRequest.php");

// FIM: INCLUDE requests ORDI�RIOS -------------------------------------------------------------------------------------


// INI: INCLUDE funcionalideds B�SICAS ---------------------------------------------------------------------------------
/* Fun��es
	 filtraAlias($prValue)
	 ShowDebugConsuta($prA,$prB)
	 ShowCR("CABECALHO/RODAPE",str)
  A��es:
  	 SEGURAN�A: Faz verifica��o se existe usu�rio logado no sistema
  Vari�veis e Carga:
	 -----------------------------------------------------------------------------
	 vari�vel          | "alimenta��o"
	 -----------------------------------------------------------------------------
	 $strDIR           | Pega o diret�rio corrente (usado na exporta��o) 
	 $arrModificadores | Array contendo os modificadores ([! ], [$ ], ...) do ASL
	 $strSQL           | SQL PURO, ou seja, SEM os MODIFICADORES, TAGS, etc...
	 -----------------------------------------------------------------------------  */
include_once("_include_aslRunBase.php");
// FIM: INCLUDE funcionalideds B�SICAS ---------------------------------------------------------------------------------

$objConn = abreDBConn(CFG_DB);

$dirCli  = getsession(CFG_SYSTEM_NAME . "_dir_cliente");
$arqNome = $intRelCod . "_" . date("Ymd-His") . ".html";
$local	  = realpath("../../" . $dirCli . "/asl_html/") . "/" . $arqNome;
 
 try { 
 	touch($local); /* Acesso ao arquivo, e se ele nao existir, ele � criado. */ 
	$fp=fopen($local,"w");	// Abre o arquivo pra escrita
 }

 catch(PDOException $e){
	mensagem("Erro de arquivo", "Problema na gera��o do arquivo HTML deste relat�rio", "Arquivo: " . $arqNome,  "javascript:window.close();","standarderro",1);
    die();
 }

BeginHtmlBuffer(); //Inicia a captura em buffer (ob_start())
echo("<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>\n");
echo("<html>\n");
echo("<head>\n");
//echo("<title>" . CFG_SYSTEM_TITLE . " - " . $strRelTit ."</title>");
//-- INI: INCLUDE JScript e CSS ***************************************** --
//-- Estilos....: "../_css/[SISTEMA].css" e "../_css/tablesort.css"
/*	 JavaScript..: "../_scripts/tablesort.js"
				  * Fun��es locais de exporta��o/impress�o e adicionais:					  	
					- swapDisplay, imprimir, exportarAdobe e exportDocument	!--*/
include_once("_include_aslRunScript.php"); 
//-- FIM: INCLUDE JScript e CSS ***************************************** -->
//Convers�o de mm para pixels
$numPIXEL_MM_Y = 3.78;
$numPIXEL_MM_X = 3.78;
/*configura��s etiqueta C6181 2 Colunas X 10 linhas = 20 etiquetas por folha. Altura etiqueta = 25,4mm - Largura etiqueta = 101,6 mm.*/
$numCOLUNA = 2;
$numLINHA  = 10;
$numMARGEM_SUPERIOR = round( 2    * $numPIXEL_MM_X,0); //Convertido para pixels
$numMARGEM_ESQUERDA = round(  4    * $numPIXEL_MM_X,0);
$numLARGURA_COLUNA  = round((101.6  * $numPIXEL_MM_X) ,0);
$numALTURA_COLUNA   = round(( 25.4  * $numPIXEL_MM_Y),0);				
$numESPACO_ENTRE_ETIQUETAS_Y = round((5 * $numPIXEL_MM_X),0);
$tamTABLE = round($numLARGURA_COLUNA * $numCOLUNA,0) + $numESPACO_ENTRE_ETIQUETAS_Y;

echo("<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>\n");
echo("</head>\n");
echo("<body leftmargin='".$numMARGEM_ESQUERDA."' topmargin='0' marginwidth='0' marginheight='0' bgcolor='#FFFFFF'>\n");
echo("<div id='mainPage'>");/*INI: Div mainPage - usado na Exporta��o...*/
//-- INI: T�tulo, Descri��o e controles de exporta��o e display/hidden descri��o 
/*-- Controle de expand/collapse da descri��o do relat�rio, formul�rios  de exprta��o,
	 icones de exporta��o e teste/echo do DEBUG --*/
//include_once("_include_aslRunControles.php"); 
//-- FIM: T�tulo, Descri��o e controles de exporta��o e display/hidden descri��o --
//echo $strSQL;
if($strSQL != "") {
	try{
		$objResult = $objConn->query($strSQL); // Rodando a consulta
		if($objResult->rowCount() == 0 || $objResult == ""){
			echo(mensagem("alert_consulta_vazia_titulo","alert_consulta_vazia_desc", "", "","aviso",1));
			die();
		}
	}
	catch(PDOException $e){
		echo(mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1));
		die();
	}
} else {
	echo(mensagem("info_nova_pesquisa_titulo","info_nova_pesquisa_desc", "", "","info",1));
	die();
}
/* FIM: Execu��o do SQL ---------------------------------------------------------------------------------------------- */

$intContLinha    = 1;
$intContPagina   = 1;
$intContEtiqueta = 1;
$boolFooter      = false;
$var_cont        = 0;

foreach($objResult as $objRS) {
    //Tabela Margem superior
	if (($intContLinha == 1)&&($intContEtiqueta == 1)){
		echo("<table width='".$tamTABLE."' border='0' cellspacing='0' cellpadding='0'>\n");
		echo("<tr>\n");
		echo("<td colspan='".$numCOLUNA."' height='".$numMARGEM_SUPERIOR."' valign='top'><img src='../img/transparent.gif' width='1' height='".$numMARGEM_SUPERIOR."' style='border:0px solid #000000'></td>\n");
		echo("</tr>\n");
		echo("</table>\n");
	}
	/*finalizar pagina
	if ($intContPagina = 1){
		echo("<table width='".$tamTABLE."' border='0' cellspacing='0' cellpadding='0'>");
      	echo("<tr>");
        echo("<td align='center'><font color='#999999'>P�gina ".$intContPagina." de TotalPages</font></td>");
      	echo("</tr>");
	  	echo("</table>");
	}		
	*/	
	
    //Quebra 1� p�gina
	/*
	if ($intContPagina == 1){	
		//echo("<br style='page-break-before:always;'>");
		$intContPagina++; 
		//echo("<table width='".$tamTABLE." border='0' cellspacing='0' cellpadding='0'>");
		//echo("<tr>");
		//echo("<td colspan='".$numCOLUNA."' height='".$numMARGEM_SUPERIOR."' valign='top'><img src='../img/transparent.gif' width='1' height='".$numMARGEM_SUPERIOR."'></td>");
		//echo("</tr>");
		//echo("</table>");	
	}  
	*/
	/*Campos da etiqueta*/			
	$razaoSOCIAL  = getValue($objRS,'campo_razao'       );
	$destinatario = getValue($objRS,'campo_destinatario');
	$endereco     = getValue($objRS,'campo_endereco'    );
	$bairro       = getValue($objRS,'campo_bairro'      );					
	$cep          = getValue($objRS,'campo_cep'         );
	$cidade       = getValue($objRS,'campo_cidade'      );
	if (strtoupper(getValue($objRS,'campo_pais')) != 'BRASIL'){
		$pais = strtoupper(getValue($objRS,'campo_pais'));  
		$estado = ""; 
	} else {
		$estado = getValue($objRS,'campo_estado'); 
		$pais="";
	} 	
		
	//Tabela com etiquetas - Equivale a p�gina	
	if ($intContEtiqueta == 1){	
		if ($intContLinha == 1){
			echo("<table id='table01' width='".$tamTABLE."' border='0' cellspacing='0' cellpadding='0' style='overflow:hidden;'>\n");
		}		
		echo("<tr>\n");		
	}	
	/*C�lula - equivale a etiqueta*/
	if ($intContEtiqueta == 1){	
    	echo("<td width='".$numLARGURA_COLUNA."' height='".$numALTURA_COLUNA."' style='border:0px solid #000000;margin-top:4px;' nowrap='nowrap'>\n");	
	}else{
   		echo("<td width='".$numLARGURA_COLUNA."' height='".$numALTURA_COLUNA."' style='border:0px solid #000000;margin-top:4px;margin-left:".$numESPACO_ENTRE_ETIQUETAS_Y."px;' nowrap='nowrap'>\n");	
	}	
	echo("<b>".$razaoSOCIAL."</b><br>\n");
	echo("<b>".$destinatario."</b><br>\n");
	echo($endereco." - ".$bairro."<br>\n");	
	if ($pais!=""){
		echo("<b>".$cep."</b>&nbsp;&nbsp;".$cidade."&nbsp;&nbsp;&nbsp;-&nbsp;".$pais."<br>\n");
	}else{
		echo("<b>".$cep."</b>&nbsp;&nbsp;".$cidade."&nbsp;/".$estado."<br>\n");		
	}
	echo("</td>\n");	
	
	/*Imprime 2 etiquetas por linha*/
	$intContEtiqueta++;
	/*Mudan�a de linha*/
	if($intContEtiqueta>$numCOLUNA){
		echo("</tr>\n");
		$intContEtiqueta = 1;
		$intContLinha++;			
	}
	/*Mudan�a de p�gina*/
	if ($intContLinha > $numLINHA  ){
		echo("</table>\n");		
		$intContLinha = 1;
		echo("<div style='page-break-before:always;'></div>\n");
		$intContPagina++; 
	}
		
} // foreach

$outBuf .= EndHtmlBuffer(); //Descarrega e finaliza o buffering
echo("</div>\n");/*FIM: Div mainPage - usado na Exporta��o... */
echo("</body>\n");
echo("</html>\n");

include_once("_include_aslRunHtmlSave.php");  // Grava o Arquivo HTML 			
include_once("_include_aslRunHtmlLog.php");   // Grava Log de execu��o do Relat�rio (com o nome do HTML gerado)
include_once("_include_aslRunHtmlClear.php"); // Apaga arquivos html de relat�rios antigos

$objResult->closeCursor();
$objConn = NULL;

?>