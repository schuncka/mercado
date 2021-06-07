<?php
ini_set("max_execution_time", 180);
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

$strAcao       = request("var_acao");       // Ação para exportação (excel, word...)
$strAcaoGrid   = request("var_acaogrid");   // Ação de retorno da grade (single, multiple)
$strSQLRelOrig = request("var_strparam");   // A consulta deve chegar com as TAGs do tipo (<ASLW_APOSTROFE>, etc...) 
$strDescricao  = request("var_descricao");  // A descrição do relatório (inativo)
$strNome       = request("var_nome");       // O nome do campo para retorno para o formulário
$strCampoRet   = request("var_camporet");   // O nome do campo no formulário para qual o relatório deve retornar o valor
$strDBCampoRet = request("var_dbcamporet"); // O nome do campo na cosulta que deve ser retornado
$strDBCampoLbl = request("var_dbcampolbl"); // O label do campo na cosulta que deve ser retornado
$strDialogGrp  = request("var_dialog_grp"); // O índice do formulário que deve ser retornado
$strRelatTitle = request("var_relat_title");// O nome do relatório, caso ele for um ASLW
$strHTMLBody   = ""; // Variável que receberá o HTML da página para ser exibido posteriormente. (Para não usar muitos echos)

$strDBCampoRet = preg_replace("/[[:alnum:]_]+\./i","",$strDBCampoRet); //Para tirar o nome da tabela do campo que será retornado

function filtraAlias($prValue){
	return(strtolower(preg_replace("/([[:alnum:]_\"\(\)\.\+\-\*\/\^' ]+ AS )|([[:alnum:]_\"]+\.)|/i","",$prValue)));
}

/********* Verificação de acesso e localização do módulo *********/
$strSesPfx = strtolower(str_replace("modulo_","",basename(getcwd())));
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), 19);

/********* Preparação SQL - Início *********/
$strSQLRel = removeTagSQL($strSQLRelOrig); //Remove as tags
$strSQLRel = replaceParametersSession($strSQLRel); //Coloca os valores de sistema (session)
//preg_match_all("/\[(?<operador>[[:punct:]]?) +(?<campo>[[:alnum:]_\"\(\)\.\+\-\*\/\^' ]+( AS [[:alnum:]_\"]+)*)\]/i",$strSQLRel,$arrParams); //Verifica se há funções ASLW e as coloca num array
preg_match_all("/\[([[:punct:]]?[0-9]*) +([[:alnum:]_\"\(\)\.\+\-\*\/\^' ]+( AS [[:alnum:]_\"]+)*)\]/i",$strSQLRel,$arrParams); //Verifica se há funções ASLW e as coloca num array
$strSQLRel = preg_replace("/\[[[:punct:]]([0-9])*|\]|\"/","",$strSQLRel); //retira as funções do SQL deixando somente o nome do campo com suas dependencias
/********* Preparação SQL - Fim *********/

$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc") || ($strAcao == ".pdf");
if($strAcao == '.pdf'){
	//seto a session do sql para executar na exportacao do pdf
	setsession($strSesPfx . "_sqlorig", $strSQLRel); 
	redirect("exportpdf_relatorio.php");
	die;
} else {
	VerificaModoExportacao($strAcao, getTText(getsession($strSesPfx . "_titulo"),C_NONE));
}


$objConn = abreDBConn(CFG_DB);

if($strSQLRel != ""){
	try{
		$objResult = $objConn->query($strSQLRel);
      	  
		if($objResult->rowCount() == 0 || $objResult == ""){
			mensagem("alert_consulta_vazia_titulo","alert_consulta_vazia_desc", "", "","aviso",1);
			die();
		}
	}
	catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
	}
?>
<html>
<head>
	<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
<?php 
	if($strAcao == ""){

	echo("	<link rel=\"stylesheet\" href=\"../_css/" . CFG_SYSTEM_NAME . ".css\" type=\"text/css\">
			<script type=\"text/javascript\" src=\"../_scripts/tablesort.js\"></script>
			<link rel=\"stylesheet\" type=\"text/css\" href=\"../_css/tablesort.css\">
		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">");
	}
?>
</head>
<body style="margin:10px;" bgcolor="#FFFFFF">
<?php
	$strHTMLBody .= "
<table align=\"center\" cellpadding=\"0\" cellspacing=\"1\"  style=\"width:100%\" class=\"tablesort\">
	 <thead>
		<tr>";
	$intI = 0;
	$intJ = 1;
	$objRS = $objResult->fetch();
	
	foreach($objRS as $strCampo => $strDado){
		if($intI % 2 == 0){
		    $intJ++;
			$strHTMLBody .= "			
				<th class=\"sortable\">". $strCampo . "</th>";
		}
		$intI++;
	}
	$strHTMLBody .= "\n	</tr></thead>\n<tbody>";
	
	$strCOLOR = "#FFFFFF";
	$intActuallyCount = 1;
	$boolFooter = false;
	do{
		echo($strHTMLBody);
		$strHTMLBody = "";
		
		$strCOLOR = ($strCOLOR == "#FFFFFF") ? "#F5FAFA" : "#FFFFFF";
		$strHTMLBody .= "\n			<tr bgcolor=\"" . $strCOLOR . "\" ";
		$strHTMLBody .= ">";
		$intI = 0; $intIdxAction = 0; $intRowCount = $objResult->rowCount();
		foreach($objRS as $strCampo => $strDado) {
			if($intI % 2 == 0){
				// Código das funções ASLW - Início
				$intIdxAux = $intI/2;
				if(isset($arrParams[2][$intIdxAction]) && filtraAlias($arrParams[2][$intIdxAction]) == $strCampo){
					
					//switch($arrParams["operador"][$intIdxAction]){
					$strOperator = $arrParams[1][$intIdxAction];
					
					if($strOperator == "+")       { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] += $strDado; $boolFooter = true;
					} elseif($strOperator == "-") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] -= $strDado; $boolFooter = true;
					} elseif($strOperator == "*") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] *= $strDado; $boolFooter = true;
					} elseif($strOperator == "/") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] /= $strDado; $boolFooter = true;
					} elseif($strOperator == "#") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = 1 : $arrValues[$intIdxAux]++; $boolFooter = true;
					} elseif($strOperator == "@") { (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : ($intActuallyCount != $intRowCount) ? $arrValues[$intIdxAux] += $strDado : $arrValues[$intIdxAux] /= $intRowCount ; $boolFooter = true;
					} elseif($strOperator == "!") { (!isset($arrValues[$intIdxAux]) || $arrValues[$intIdxAux] != $strDado) ? $arrValues[$intIdxAux] = $strDado : $strDado = "";
					} elseif(preg_match("/\>([0-9])+/i",$strOperator) !== false) { $strDado = "<a onClick=\"window.open('execaslw.php?var_chavereg=" . str_replace(">","",$strOperator) . "&var_valor_aux=" . $strDado . "','','width=700,height=600,scrollbars=yes,resizable=yes,menubar=no');\" style=\"cursor:pointer;\">" . $strDado . "</a>";
					}
					/*
					switch($arrParams[1][$intIdxAction]){
						case "+": (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] += $strDado;
						$boolFooter = true;
						break;
						case "-": (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] -= $strDado;
						$boolFooter = true;
						break;
						case "*": (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] *= $strDado;
						$boolFooter = true;
						break;
						case "/": (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : $arrValues[$intIdxAux] /= $strDado;
						$boolFooter = true;
						break;
						case "#": (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = 1 : $arrValues[$intIdxAux]++;
						$boolFooter = true;
						break;
						case "@": (!isset($arrValues[$intIdxAux])) ? $arrValues[$intIdxAux] = $strDado : ($intActuallyCount != $intRowCount) ? $arrValues[$intIdxAux] += $strDado : $arrValues[$intIdxAux] /= $intRowCount ;
						$boolFooter = true;
						break;
						case "!": (!isset($arrValues[$intIdxAux]) || $arrValues[$intIdxAux] != $strDado) ? $arrValues[$intIdxAux] = $strDado : $strDado = "";
						break;
					}
					*/
					$intIdxAction++;
				} else {
					$arrValues[$intIdxAux] = false;
				}
				
				if(is_date($strDado)) { $strDado = dDate(CFG_LANG,$strDado,false); }
				$strHTMLBody .= "\n				<td style=\"padding-left:10px;\" bgcolor=\"".$strCOLOR."\" class=\"texto_corpo_mdo\">" . $strDado . "</td>";
			}
			$intI++;
		}
		$strHTMLBody .= "\n			</tr>";
		$intActuallyCount++;
	} while($objRS = $objResult->fetch());
	$strHTMLBody .= "
		</tbody>";
	if($boolFooter){
		$strHTMLBody .= "\n				<tfoot><tr><td colspan=\"" . ($intI/2) . "\"><hr size=\"2\" color=\"#BFBFBF\"></td></tr>
				<tr><td height=\"5\" colspan=\"" . ($intI/2) . "\"></td></tr>
				<tr>";
		$strCOLOR = ($strCOLOR == "#FFFFFF") ? "#F5FAFA" : "#FFFFFF";
		foreach($arrValues as $mixValue){ $strHTMLBody .= "\n\t\t\t<td style=\"padding-left:15px;\" bgcolor=\"".$strCOLOR."\">" . (($mixValue !== false && is_numeric($mixValue)) ? "<b>" . $mixValue . "</b>" : "") . "</td>"; }
		$strHTMLBody .="</tfoot>";
	}

	$strHTMLBody .= "
</table>";

echo($strHTMLBody);
?>
</body>
</html>
<?php
$objResult->closeCursor();
$objConn = NULL;
}
else{
	mensagem("info_nova_pesquisa_titulo","info_nova_pesquisa_desc", "", "","info",1);
	die();
}
?>
