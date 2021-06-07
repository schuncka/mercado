<?php
ini_set("max_execution_time", 300); //300s = 5min
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

// INI: INCLUDE requests ORDI�RIOS -------------------------------------------------------------------------------------
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

BeginHtmlBuffer(); //Inicia a captura em buffer (ob_start())
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title><?php echo(CFG_SYSTEM_TITLE . " - " . $strRelTit); ?></title>
	<!-- INI: INCLUDE JScript e CSS ***************************************** -->
	<!-- Estilos....: "../_css/[SISTEMA].css" e "../_css/tablesort.css"
		 JavaScrit..: "../_scripts/tablesort.js"
					  * Fun��es locais de exporta��o/impress�o e adicionais:					  	
						- swapDisplay, imprimir, exportarAdobe e exportDocument	!-->
	<?php include_once("_include_aslRunScript.php"); ?>
	<!-- FIM: INCLUDE JScript e CSS ***************************************** -->
	
	<!-- Exemplo de CSS espec�fica para formatos diferentes de etiquetas, etc... 
	<style>
		table.pagina { border:0px #FFFFFF solid; width:810px; background-color:#FFF; }
		div.box 	 { border:1px #FFFFFF solid; margin-bottom:8px; float:left; margin-left:8px; width:240px; height:87px; }
		div.linha    { width:240px; height:18px; overflow:hidden; }
		div.conteudo { width:240px; height:87px; padding:0px 0px 0px 0px; text-align:left; vertical-align:middle; background:#FFF;}
	</style>
	-->
	<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
</head>
<body style='margin:10px;' bgcolor='#FFFFFF'>
<!-- INI: T�tulo, Descri��o e controles de exporta��o e display/hidden descri��o -->
<!-- Controle de expand/collapse da descri��o do relat�rio, formul�rios  de exprta��o,
	 icones de exporta��o e teste/echo do DEBUG -->
<?php include_once("_include_aslRunControles.php"); ?>
<!-- FIM: T�tulo, Descri��o e controles de exporta��o e display/hidden descri��o -->

<div id='mainPage'><!-- INI: Div mainPage - usado na Exporta��o... -->
<?php
	echo(ShowCR("CABECALHO",$strRelHead)); // CABE�ALHO do relat�rio


	/* INI: Execu��o do SQL ---------------------------------------------------------------------------------------------- */
	if($strSQL != "") {
		try{
			$objResult = $objConn->query($strSQL); // Rodando a consulta
			if($objResult->rowCount() == 0 || $objResult == ""){
				mensagem("alert_consulta_vazia_titulo","alert_consulta_vazia_desc", "", "","aviso",1);
				die();
			}
		}
		catch(PDOException $e){
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
			die();
		}
	} else {
		mensagem("info_nova_pesquisa_titulo","info_nova_pesquisa_desc", "", "","info",1);
		die();
	}
	/* FIM: Execu��o do SQL ---------------------------------------------------------------------------------------------- */



	/* INI: GRADE/TABLE do relat�rio em si ------------------------------------------------------------------------------- */
	// Criando a tabela para os dados (uso da classe TableSort)
	echo("<table align='center' cellpadding='0' cellspacing='1'  style='width:100%' class='tablesort'>");
	$intI = 0;
	$intJ = 1;
	$objRS = $objResult->fetch();


	// Monta o cabe�alho(thead) da TableSort
	echo("<thead><tr>");
	echo("<th class='sortable'>Campo</th>");
	echo("<th class='sortable'>Dado</th>");
	echo("</tr></thead>");


	// Varredura da consulta com tratamento dos modificadores e echo das linhas do relat�rio
	$strCOLOR = "#FFFFFF";
	$intActuallyCount = 1;
	$boolFooter = false;
	echo("<tbody>");
	do{
	 	$outBuf .= FlushHtmlBuffer(); //Descarrega o Buffer

		$strCOLOR = ($strCOLOR == "#FFFFFF") ? "#F5FAFA" : "#FFFFFF";
		$intI = 0; $intIdxAction = 0; $intRowCount = $objResult->rowCount();
		foreach($objRS as $strCampo => $strDado) {
			if($intI % 2 == 0){
				$intIdxAux = $intI/2;
				$boolFormatDouble = false;
				$strOperator = "";
				
				if(isset($arrModificadores[2][$intIdxAction]) && filtraAlias($arrModificadores[2][$intIdxAction]) == $strCampo){
					$strOperator = $arrModificadores[1][$intIdxAction];
					if($strOperator == "+")       { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] += $strDado; $boolFooter = true; $boolFormatDouble = true;
					} elseif($strOperator == "-") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] -= $strDado; $boolFooter = true; $boolFormatDouble = true;
					} elseif($strOperator == "$") { $boolFooter = false; $boolFormatDouble = true;
					} elseif($strOperator == "*") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] *= $strDado; $boolFooter = true; $boolFormatDouble = true;
					} elseif($strOperator == "/") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] /= $strDado; $boolFooter = true; $boolFormatDouble = true;
					} elseif($strOperator == "#") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = 1 : $arrValues[$intIdxAux]++; $boolFooter = true;
					} elseif($strOperator == "@") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : ($intActuallyCount != $intRowCount) ? $arrValues[$intIdxAux] += $strDado : $arrValues[$intIdxAux] /= $intRowCount ; $boolFooter = true; $boolFormatDouble = true;
					} elseif($strOperator == "!") { (!isset($arrValues[$intIdxAux]) || $arrValues[$intIdxAux] != $strDado) ? $arrValues[$intIdxAux] = $strDado : $strDado = "";
					} elseif(preg_match("/\>([0-9])+/i",$strOperator) !== false) { $strDado = "<a onClick=\"window.open('execaslw.php?var_chavereg=" . str_replace(">","",$strOperator) . "&var_valor_aux=" . $strDado . "','','width=700,height=600,scrollbars=yes,resizable=yes,menubar=no');\" style=\"cursor:pointer;\">" . $strDado . "</a>";
					}
					$intIdxAction++;
				} else {
					$arrValues[$intIdxAux] = false;
				}
				if(is_date($strDado)) { $strDado = dDate(CFG_LANG,$strDado,false); }
				echo("<tr>");
				echo("<td>". $strCampo . "</td>");
				echo("<td>");
				echo( ($boolFormatDouble == false)?$strDado:number_format((double) $strDado, 2, ",", ".") );
				echo("</td>");
				echo("</tr>\n");
			}
			$intI++;
		}
		$intActuallyCount++;
		echo("<tr><td style='height:5px; width:50px; background-color:#DEDFDE;'></td><td style='background-color:#DEDFDE;'></td></tr>\n");
	} while($objRS = $objResult->fetch());
	echo("</tbody>");

	// Monta o rodap�(thead) da TableSort
	echo("<tfoot></td></tr>");
	if($boolFooter){
		echo("<tr>");
		$strCOLOR = ($strCOLOR == "#FFFFFF") ? "#F5FAFA" : "#FFFFFF";
		foreach($arrValues as $mixValue){ echo("<td style='padding-left:15px;' bgcolor='".$strCOLOR."'>" . (($mixValue !== false && is_numeric($mixValue)) ? "<b>" . number_format((double) $mixValue,2,",",".") . "</b>" : "") . "</td>"); }
		echo("</tr>");
	}
	echo("</tfoot>");
	echo("</table>"); //Fechando a tabela para os dados (uso da classe TableSort)
	/* FIM: GRADE/TABLE do relat�rio em si ------------------------------------------------------------------------------- */

	echo(ShowCR("RODAPE",$strRelFoot)); // RODAP� do relat�rio

	$outBuf .= EndHtmlBuffer(); //Descarrega e finaliza o buffering
?>
</div><!-- FIM: Div mainPage - usado na Exporta��o... -->
</body>
</html>
<?php
    include_once("_include_aslRunHtmlSave.php");  // Grava o Arquivo HTML 
    include_once("_include_aslRunHtmlLog.php");   // Grava Log de execu��o do Relat�rio (com o nome do HTML gerado)
    include_once("_include_aslRunHtmlClear.php"); // Apaga arquivos html de relat�rios antigos

	$objResult->closeCursor();
	$objConn = NULL;
?>