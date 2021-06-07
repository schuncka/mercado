<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

/***            VERIFICA��O DE ACESSO              ***/
/*****************************************************/
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verifica��o de acesso do usu�rio corrente



/***           DEFINI��O DE PAR�METROS            ***/
/****************************************************/

$strAcao   	      = request("var_acao");           // Indicativo para qual formato que a grade deve ser exportada. Caso esteja vazio esse campo, a grade � exibida normalmente.
$strSQLParam      = request("var_sql_param");      // Par�metro com o SQL vindo do bookmark
$strPopulate      = request("var_populate");       // Flag de verifica��o se necessita popular o session ou n�o

/***    A��O DE PREPARA��O DA GRADE - OPCIONAL    ***/
/****************************************************/
if($strPopulate == "yes") { initModuloParams(basename(getcwd())); } //Popula o session para fazer a abertura dos �tens do m�dulo


/***        A��O DE EXPORTA��O DA GRADE          ***/
/***************************************************/
//Define uma vari�vel booleana afim de verificar se � um tipo de exporta��o ou n�o
$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc") || ($strAcao == ".pdf");

//Exporta��o para excel, word e adobe reader
if($boolIsExportation) {
	if($strAcao == ".pdf") {
		redirect("exportpdf.php"); //Redireciona para p�gina que faz a exporta��o para adode reader
	}
	else{
		//Coloca o cabe�alho de download do arquivo no formato especificado de exporta��o
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
							<div style='display: inline; float: left; padding-left:4px;'><b>PAVILH�O</b></div>",CL_CORBAR_GLASS_2);
					?>
            <table bgcolor="#FFFFFF" width="100%" class="tablesort">
              <thead>
                <tr>
                  <th class="sortable-text"> Cod. Pavilh�o</th>
                  <th class="sortable-text">Id Pavilh�o</th>
                  <th class="sortable"> Descri��o</th>
                </tr>
              </thead>
              <tbody>
			  <?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					try{				
							$strSQL = " SELECT cod_pavilhao, idpavilhao, descrpavilhao FROM cad_pavilhao";
							$objResult = $objConn->query($strSQL); // execu��o da query
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
