<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

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

	
	
?>
<html>
<head>
<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<?php 

		if(!$boolIsExportation || $strAcao == "print"){
			echo(" <link rel=\"stylesheet\" href=\"../_css/" . CFG_SYSTEM_NAME . ".css\" type=\"text/css\">
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
</head>
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" onLoad="swapwidth(0,'<?php echo CFG_SYSTEM_THEME;?>','<?php echo CFG_SYSTEM_NAME;?>');" >
<img style="display:none" id="img_collapse">

<table cellpadding="0" cellspacing="0" border="0" width="100%" >
  <tr>
    <td align="center"  valign="top">
					<?php   athBeginFloatingBox("100%","","<div style='display: inline; float: right; padding-right:4px;'></div>
							<div style='display: inline; float: left; padding-left:4px;'><b>PAVILHÃO</b></div>",CL_CORBAR_GLASS_2);
					?>
            <table bgcolor="#FFFFFF" width="100%" class="tablesort">
              <thead>
                <tr>
                  <th class="sortable-text"> Cod. Pavilhão</th>
                  <th class="sortable-text">Id Pavilhão</th>
                  <th class="sortable"> Descrição</th>
                </tr>
              </thead>
              <tbody>
			  <?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = " SELECT cod_pavilhao, idpavilhao, descrpavilhao FROM cad_pavilhao";
							$objResult = $objConn->query($strSQL); // execução da query
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
			  	foreach($objResult as $objRS){
			  ?>
                <tr>
                  <td><?php echo getValue($objRS,"cod_pavilhao") ?></td>
                  <td><?php echo getValue($objRS,"idpavilhao") ?></td>
                  <td><?php echo getValue($objRS,"descrpavilhao") ?></td>
                </tr>
				<?php } ?>
              </tbody>
            </table>
            <?php athEndFloatingBox(); ?>
          </td>
  </tr>
</table>
</body>
</html>
<?php $objConn = NULL; ?>
