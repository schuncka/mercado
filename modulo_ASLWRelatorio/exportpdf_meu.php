<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_class/fpdf/html2fpdf.php");


$var_idempresa = $_SESSION['id_empresa'];
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
			case 12: $mes = "Dezembro"; break;
}

$corpo .= "<html>
			<head>
			</head>
			<body> ";

$corpo .= "<table align='center' bgcolor='#FFFFFF' width='92%' border='5'>";
	$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					$strSQL = " SELECT DISTINCT 
										idmont, nomemont, endereco, bairro, cidade, estado, cep, pais, cgcmf, telefone1
										, telefone2, telefone3, telefone4, email, 'mo' || cad_montador.idmont AS user

										, CASE WHEN '$var_idempresa' = 'CM' THEN
                							'COUROMODA'
                						  	ELSE CASE WHEN '$var_idempresa' = 'HP' THEN
                								'HOSPITALAR'
                						  		ELSE 'SÃO PAULO'
                								END                
                						   END AS ide,
										   
										   CASE WHEN '$var_idempresa' = 'CM' THEN
                							'www.couromoda.com'
                						  	ELSE CASE WHEN '$var_idempresa' = 'HP' THEN
                								'www.hospitalar.com'
                						  		ELSE 'www.hairbrasil.com'
                								END                
                						   END AS site
										
										, CASE WHEN cad_montador.idmont IS NULL THEN
											'000000'
										  ELSE 
											(CAST((SUBSTRING(cad_montador.idmont from '......$')) AS DOUBLE PRECISION) * 3.5) 
										  END AS pass
											
									 , tipocred
									 , website
									FROM 
										cad_montador
									WHERE
										(cad_montador.idmont = '905248')
									ORDER BY 
										cad_montador.nomemont";
										
				$objResult = $objConn->query($strSQL); // execução da query
							  	foreach($objResult as $objRS){
				  $corpo ="<tr><td align='right'> <font size=2> São Paulo, ".$mes." de ".date("Y")."</td></tr>";
	}

$corpo .="</table>";
$corpo .="</body> </html>";



header("Content-type: application/pdf");
$objConn = abreDBConn(CFG_DB); 
$objPDF  = new HTML2FPDF();
$objPDF->AliasNbPages();
$objPDF->AddPage();
$objPDF->SetFont("Arial","",11);


//inicio




$objPDF->WriteHTML($corpo);


// Termina a leitura


/******** Rodapé do documento (HTML) - [Fim]   ********/
		
$objPDF->Output();

$objResult->closeCursor();
$objConn = NULL;
$objPDF = NULL;
?>