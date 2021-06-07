<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$var_idempresa = request('id_empresa');


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

// Fun��o M�s Extenso
$mes = date('m');
switch ($mes){
case 1: $mes = "Janeiro"; break;
case 2: $mes = "Fevereiro"; break;
case 3: $mes = "Mar�o"; break;
case 4: $mes = "Abril"; break;
case 5: $mes = "Maio"; break;
case 6: $mes = "Junho"; break;
case 7: $mes = "Julho"; break;
case 8: $mes = "Agosto"; break;
case 9: $mes = "Setembro"; break;
case 10: $mes = "Outubro"; break;
case 11: $mes = "Novembro"; break;
case 12: $mes = "Dezembro"; break;}



include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

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
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<table align="center" bgcolor="#FFFFFF" width="92%" border="0">
 
  <?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					// SQL Principal	
					$strSQL = " SELECT DISTINCT 
										idmont, nomemont, endereco, bairro, cidade, estado, cep, pais, cgcmf, telefone1
										, telefone2, telefone3, telefone4, email, 'mo' || cad_montador.idmont AS user

										, CASE WHEN '$var_idempresa' = 'CM' THEN
                							'COUROMODA'
                						  	ELSE CASE WHEN '$var_idempresa' = 'HP' THEN
                								'HOSPITALAR'
                						  		ELSE 'S�O PAULO'
                								END                
                						   END AS ide,
										   
										   CASE WHEN '$var_idempresa' = 'CM' THEN
                							'www.couromoda.com'
                						  	ELSE CASE WHEN '$var_idempresa' = 'HP' THEN
                								'www.hospitalar.com'
                						  		ELSE 'www.hairbrasil.com'
                								END                
                						   END AS site
										
										, SUBSTRING(CASE WHEN cad_montador.idmont IS NULL THEN
											'000000'
										  ELSE 
											(CAST((SUBSTRING(cad_montador.idmont from '......$')) AS DOUBLE PRECISION) * 3.5) 
										  END from '.......') AS pass
																				
									 , tipocred
									 , website
									FROM 
										cad_montador
										
									ORDER BY 
										cad_montador.nomemont;";
										
				$objResult = $objConn->query($strSQL); // execu��o da query
			  	foreach($objResult as $objRS){
			  ?>

  <tr>
    <td align="right"> <font size=2> S�o Paulo, <?php echo $mes; ?> de <?php echo date("Y"); ?></font></td>
  </tr>
  <tr>
    <td><font size=2><b>Para:</b></font></td>
  </tr>
  <tr>
    <td><font size=2><b><?php echo getValue($objRS,"nomemont") ?> </b></font></td>	
  </tr>
  <tr>
    <td><font size=2><?php echo getValue($objRS,"cidade") ?> / <?php echo getValue($objRS,"estado") ?><br>
    <br><br></font></td>	
  </tr>
  <tr>
  	<td><font size=2>Senhores,<br><br></font></td>  	 
  </tr>
  <tr align="justify">
  	<td align="justify">   	 
  	  <div align="justify"><font size=2>Para agilizar a comunica��o entre a feira <?php echo getValue($objRS,"ide") ?> e seus Prestadores de Servi�o estamos abrindo um novo canal de comunica��o. <BR>
        <BR>
		    Estas <u><b>informa��es agora passam a ser trocadas via Internet,</b></u> atrav�s do portal <u><b><?php echo getValue($objRS,"site") ?></b></u><BR>
		    <BR>
		    Clique no item SERVI�OS AO PRESTADOR, atrav�s da qual cada empresa poder� fazer a 
				solicita��o de diversos servi�os, tais como:<BR>
              <BR>
		    - Termo de Responsabilidade do Montador<BR>
		    - Solicita��o de Credenciais de MONTADOR para a feira<BR>
		    - Informa��o de Equipamentos a serem utilizados no estande<BR>
		    - Solicita��o de Servi�os de Limpeza para o estande<BR>
		    <BR>
		    Para utilizar estes servi�os, voc� precisa ter um NOME DE USU�RIO e uma SENHA, que informamos a seguir:<BR></font>
          <BR>
        <BR>
          <BR>

          </p>
  	  </div>
  	  <table align="center" bgcolor="#FFFFFF" width="40%" border="1">
	<tr>
	 <td><font size=2>
	 Nome do Usu�rio........: <b><?php echo getValue($objRS,"user") ?></b><BR>
	 Senha.........................: <b><?php echo getValue($objRS,"pass") ?></b>
	 </font></td>
	</tr>
	</table>

	<BR><BR><BR><BR>
	Para sua seguran�a, mantenha sua senha em sigilo at� seu primeiro acesso. Depois troque-a 
	o mais r�pido poss�vel por uma outra senha de sua prefer�ncia.<BR>
	<BR>
	
	Em caso de d�vida, queira por gentileza nos contatar pelo fone (11) 3897.6199.<BR>
	<BR>
	
	Atenciosamente,<BR><BR><BR>
	
	<img width="150" height="50" src="../img/ass_sousa.gif"><br>
	
	JORGE ALVES DE SOUZA<BR>
	Diretor Administrativo

	</td>  
  <tr>
  	<!-- Quebra de P�gina -->
	<td style="	page-break-after: always;">	</td>
  </tr> 	
  </tr>
  <?php } ?>
</table>
</body>
</html>
<?php $objConn = NULL; ?>
