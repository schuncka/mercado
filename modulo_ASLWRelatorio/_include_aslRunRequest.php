<?php
$outBuf = "";
$data_ini = strtotime(date("Y-m-d H:i:s")); // Calculando em segundos e retorna no formato 00:54
// Por defini��o esses s�o os par�metros que a p�gina anterior de prepara��o (execaslw.php) manda para os executores.
// Cada executor pode utilizar os par�metros que achar necess�rio, mas por defini��o queremos que todos fa�am os
// requests de todos os par�metros enviados, como no caso abaixo:
$intRelCod		= request("var_cod");	 	 // C�digo do relat�rioRodap� do relat�rio
$strRelASL		= request("var_asl"); 		 // ASL - Conulta com par�metros processados, mas TAGs e Modificadores 
$strRelSQL		= request("var_sql");        // SQL - Consulta no formato SQL (com par�metros processados e "limpa" de TAGs e Modificadores)
$strRelTit		= request("var_tit");        // Nome/T�tulo do relat�rio
$strRelDesc		= request("var_desc");		 // Descri��o do relat�rio	
$strRelHead		= request("var_header");	 // Cabe�alho do relat�rio
$strRelFoot		= request("var_footer");	 // Rodap� do relat�rio		
$strRelInpts	= request("var_inputs");	 // Usado apenas para o log
$strDBCampoRet	= request("var_dbcamporet"); // O nome do campo na consulta que deve ser retornado
$strDBCampoRet  = preg_replace("/[[:alnum:]_]+\./i","",$strDBCampoRet); //Para tirar o nome da tabela do campo que ser� retornado
$strCSVSep      = ";"; // Indica o separador para as colunas do arquivo CSV gerado - Pode ser passado por par�metro futuramente
?>