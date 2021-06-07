<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_class/fpdf/html2fpdf.php");
 
header("Content-type: application/pdf");

$objConn = abreDBConn(CFG_DB); 

$objPDF  = new HTML2FPDF();

$objPDF->AliasNbPages();
$objPDF->AddPage();
$objPDF->SetFont("Arial","",11);



try{
	$strSesPfx  = strtolower(str_replace("modulo_","",basename(getcwd())));
	$strSQLGrid = getsession($strSesPfx . "_sqlorig");
	$objResult  = $objConn->query($strSQLGrid);
}
catch(PDOException $e){
	mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
	die();
}

/******** Cabe�alho do documento (HTML) - [In�cio] ********/
$objPDF->WriteHTML("
					<table width=\"100%\">
						<tr>
							<td align=\"right\" height=\"60\" valign=\"bottom\"></td>
						</tr>
					</table><br>
				  ");
$objPDF->Image("../img/system_logo.jpg",10,10);
$objPDF->WriteHTML("<table width=\"100%\"><tr bgcolor=\"#F0F0F0\">");
/******** Cabe�alho do documento (HTML) - [Fim]   ********/

$intContRegistros = 0;

if($objResult->rowCount() > 0){
	/******** Cabe�alho da grade - [In�cio] ********/
	$intI = 2;  				  //Contador auxiliar para exibi��o dos campos da consulta. Come�a em dois para retornar o numero certo da coluna.
	$objRS = $objResult->fetch(); //Faz o fetch do ResultSet retornando um array com o resultado da consulta
			
	foreach($objRS as $strCampo => $strDado){
		if($intI % 2 == 0){
			$objPDF->WriteHTML("<td nowrap>" . getTText($strCampo,C_UCWORDS) . "</td>");
		}
		$intI++;
	}
				
	/******** Cabe�alho da grade - [Fim]    ********/

	$objPDF->WriteHTML("</tr>");

	/******** Conte�do da grade - [In�cio] ********/
	$strBgColor = "#FFFFFF";
	
	do{
		$objPDF->WriteHTML("<tr bgcolor=\"" . $strBgColor . "\">");
		
		$intI = 0;
		foreach($objRS as $strDado){
			if($intI % 2 == 0){
				$objPDF->WriteHTML("<td height='22'>&nbsp;");
				(is_date($strDado)) ? $strDado = dDate(CFG_LANG,$strDado,true) : NULL;
				$objPDF->WriteHTML( $strDado . "</td>");
			}
			$intI++;
		}
		($strBgColor == "#F5FAFA") ? $strBgColor = "#FFFFFF"  :  $strBgColor = "#F5FAFA";
		$intContRegistros++;
		$objPDF->WriteHTML("</tr>");
	}while($objRS = $objResult->fetch());
}
		
/******** Conte�do da grade - [Fim]    ********/

/******** Rodap� do documento (HTML) - [In�cio] ********/
$objPDF->WriteHTML("
					<tr><td colspan=\"" . ($intI/2) . "\" height=\"3\" bgcolor=\"#FFFFFF\"></td></tr>
					<tr><td height=\"3\" bgcolor=\"#BFBFBF\" colspan=\"" . ($intI/2) . "\"></td></tr>
					<tr><td colspan=\"" . ($intI/2) . "\" height=\"3\" bgcolor=\"#FFFFFF\"></td></tr>
					<tr><td colspan=\"" . ($intI/2) . "\" bgcolor=\"#FFFFFF\">" . $intContRegistros . " " . getTText("reg_encontrados",C_TOLOWER) . "</td></tr>
				</table>
");
/******** Rodap� do documento (HTML) - [Fim]   ********/
		
$objPDF->Output();

$objResult->closeCursor();
$objConn = NULL;
$objPDF = NULL;
?>