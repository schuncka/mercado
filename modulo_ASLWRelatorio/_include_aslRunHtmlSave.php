<?php
/* INI: Grava o Arquivo HTML ------------------------------------------------------------------- */
	$dirCli	 = getsession(CFG_SYSTEM_NAME . "_dir_cliente");
	$arqNome = $intRelCod . "_" . date("Ymd-His") . ".html";
	$local	 = realpath("../../" . $dirCli . "/asl_html/") . "/" . $arqNome;
	
	/*
	 Os HTML gerados v�o para uma pasta do cliente, portanto os caminhos para css, javascript, imagens
	 e chamada para outras p�giansphp, devem ser ajustados. O c�digo abaixo ajusta estes caminhos. 
	 **Acho que mais adiante poderemos melhorar essa l�gica
	*/ 
	$outBuf = str_replace("../_css/"		,"../../_"  . CFG_SYSTEM_NAME . "/_css/"		, $outBuf);
	$outBuf = str_replace("../_scripts/"	,"../../_"  . CFG_SYSTEM_NAME . "/_scripts/"	, $outBuf);
	$outBuf = str_replace("../img/"			,"../../_"  . CFG_SYSTEM_NAME . "/img/"			, $outBuf);
	$outBuf = str_replace("'execaslw.php"	,"'../../_" . CFG_SYSTEM_NAME . "/modulo_ASLWRelatorio/execaslw.php", $outBuf);
	$outBuf = str_replace("'aslExport.php"	,"'../../_" . CFG_SYSTEM_NAME . "/modulo_ASLWRelatorio/aslExport.php", $outBuf);
	$flagOk = true;
	try {
		touch($local); 			// Acesso ao arquivo, e se ele nao existir, ele � criado.
		$fp=fopen($local,"w");	// Abre o arquivo pra escrita
		fputs($fp,"$outBuf");	// Grava 
		fclose($fp);			// Fecha o arquivo
	}
	catch(PDOException $e){
		// N�o importa se deu algum problema, apenas n�o grava o log, pois o relat�rio j� esta em tela
		$flagOk = false;
	}
/* FIM: Grava o Arquivo HTML ------------------------------------------------------------------- */
?>