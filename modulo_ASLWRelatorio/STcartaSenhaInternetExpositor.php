<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

$var_idevento  = getsession(CFG_SYSTEM_NAME . "_id_evento");


/***            VERIFICA��O DE ACESSO              ***/
/*****************************************************/
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app")); //Verifica��o de acesso do usu�rio corrente



/***           DEFINI��O DE PAR�METROS            ***/
/****************************************************/

$strAcao   	      = request("var_acao");           // Indicativo para qual formato que a grade deve ser exportada. Caso esteja vazio esse campo, a grade � exibida normalmente.
$strSQLParam      = request("var_sql_param");      // Par�metro com o SQL vindo do bookmark
$strPopulate      = request("var_populate");       // Flag de verifica��o se necessita popular o session ou n�o
$varCodigo		  = request("var_chavereg");


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
<STYLE TYPE="text/css">
.folha {
    page-break-after: always;
}
</STYLE>
</head>
<body style="margin:10px 0px 10px 0px;" >
<?php
				try{
					$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					$strSQL = " SELECT DISTINCT 
												cad_empresa.idmercado, 
												vw_monta_senha_expositor.usuario, 
												vw_monta_senha_expositor.senha, 
												vw_monta_senha_expositor.senha_gerador, 
												cad_cadastro.codigo, 
												cad_cadastro.razao, 
												cad_cadastro.fantasia, 
												cad_cadastro.endereco, 
												cad_cadastro.bairro, 
												cad_cadastro.cidade, 
												cad_cadastro.estado, 
												cad_cadastro.cep, 
												cad_cadastro.pais, 
												cad_cadastro.cgcmf, 
												cad_cadastro.telefone1, 
												cad_cadastro.telefone2, 
												cad_cadastro.telefone3, 
												cad_cadastro.telefone4, 
												cad_cadastro.website, 
												cad_cadastro.email, 
												cad_empresa.efantasia, 
												cad_empresa.idmercado, 
												cad_evento.rodape, 
												cad_evento.dt_inicio, 
												cad_evento.dt_fim
											FROM 
												((vw_monta_senha_expositor 
												INNER JOIN 
												cad_cadastro 
													ON (vw_monta_senha_expositor.idmercado = cad_cadastro.idmercado) 
													AND (vw_monta_senha_expositor.codigo = cad_cadastro.codigo)) 
												INNER JOIN 
												cad_empresa 
													ON cad_cadastro.idmercado = cad_empresa.idmercado) 
												INNER JOIN 
												cad_evento 
													ON vw_monta_senha_expositor.idevento = cad_evento.idevento       
											WHERE 
												cad_evento.idevento ILIKE '" . $var_idevento . "'
												--AND cad_cadastro.codigo ILIKE '".$varCodigo."'    
											ORDER BY 	
												cad_cadastro.razao;";
										
				$objResult = $objConn->query($strSQL);// execu��o da query
				}
				catch(PDOException $e){
					 mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
						die();
				}
			  	foreach($objResult as $objRS){
			  ?>

<table align="center" bgcolor="#FFFFFF" width="92%" border="0">
  <tr>
  	<td>
	  <br>
	  <!--AGUARDANDO LOGO-->
	  <br>
	  <br>	  	  
  	</td>
  </tr>
  <tr>
    <td><font size=2><b>Para:</b></font></td>
  </tr>
  <tr>
    <td><font size=2><b><?php echo getValue($objRS,"razao") ?> </b></font></td>
  </tr>
  <tr>
    <td><font size=2><?php echo getValue($objRS,"cidade") ?> / <?php echo getValue($objRS,"estado") ?></font><br>
      <br>
      <br></td>
  </tr>
  <tr>
    <td><font size=2>Senhores Expositores,</font></td>
  </tr>
  <tr align="justify">
    <td align="justify"><font size=2> Para agilizar e automatizar o tr�nsito de informa��es relativas � participa��o de sua empresa na <?php echo getValue($objRS,"nome_completo") ?> , estamos enviando sua senha de acesso aos servi�os que disponibilizamos via Internet: <strong><?php echo getValue($objRS,"site") ?></strong><BR>
      <BR>
      Acesse o nosso portal.<br>
      <br>
      Clique no item SERVI�OS AO EXPOSITOR, e voc� poder� encaminhar automaticamente a<br>
      solicita��o de servi�os como: </font> </td>
  </tr>
  <td><br>
      <table align="center" bgcolor="#FFFFFF" width="82%" border="1" bordercolor="#999999" style="border-collapse:collapse">
        <tr>
          <td width="50%"><b>- Dados de Cat�logo/Portal</b></td>
          <td width="50%"><b>- Informa��es sobre Telecomunica��es</b></td>
        </tr>
        <tr>
          <td><b>- Dados Confidenciais</b></td>
          <td><b>- Informa��o dos Eventos em seu Estande</b></td>
        </tr>
        <tr>
          <td><b>- Convidar Visitantes / Importadores</b></td>
          <td><b>- Consulta das Normas da DRT</b></td>
        </tr>
        <tr>
          <td><b>- Solicita��o de Credencial de Expositor</b></td>
          <td><b>- Consulta sobre Taxas Municipais</b></td>
        </tr>
        <tr>
          <td><b>- Autoriza��o de Montagem</b></td>
          <td><b>- Inscri��es para os Congressos</b></td>
        </tr>
        <tr>
          <td><b>- Autoriza��o de Prest. de Servi�o</b></td>
          <td><b>- Campanha 'Diga n�o ao Pared�o'</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Coletor de Dados</b></td>
          <td><b>- Resumo dos prazos das circulares</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de El�trica e Hidr�ulica</b></td>
          <td><b>- Envio de Not�cas para o Portal</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Extintor de Inc�ndio</b></td>
          <td><b>- Ficha de Retirada de Material</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Limpeza</b></td>
          <td><b>- Briefing do seu Estande para Or�amentos</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Seguran�a</b></td>
          <td><b>- Modelo de Contrato de M�o de Obra</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Seguro</b></td>
          <td><b>- Manual da Feira (HTML)</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Inser��o Publicit�ria</b></td>
          <td><b>- Manual da Feira (PDF)</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Recepcionista</b></td>
          <td><b>- Roteiro de Visita��o</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Loca��o de Equip. de Inform�tica</b></td>
          <td><b>- Hotel Holiday-Inn</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Loca��o de Equip. de Audiovisuais</b></td>
          <td><b>- Lista de Representantes</b></td>
        </tr>
        <tr>
          <td><b>- Pedido de Viagens e Hospedagem</b></td>
          <td><b>- Requerimento ECAD</b></td>
        </tr>
        <tr>
          <td><b>- Solicita��es de Convites / Selos</b></td>
          <td><b>- Pedido de Visto</b></td>
        </tr>
        <tr>
          <td><b>- Lista de Exportadores</b></td>
          <td><b>- V� de Metro / Hot�is</b></td>
        </tr>
        <tr>
          <td><b>- Conhe�a a nossa equipe</b></td>
          <td><b>- Cuidado com os seus pertences</b></td>
        </tr>
        <tr>
          <td><b>- Programa Exporter</b></td>
          <td>&nbsp;</td>
        </tr>
      </table></td>
  <tr>
    <td><br>
      <table align="center" bgcolor="#FFFFFF" width="40%" style="border:1px solid #000;">
        <tr>
          <td width="42%" align="left"><font size='2'>Nome do Usu�rio..............: </font></td>
          <td width="58%" align="left"><strong><font size="2"><?php echo getValue($objRS,"usuario") ?></font></strong></td>
        </tr>
        <tr>
          <td align="left"><font size='2'>Senha...............................:</font></td>
          <td align="left"><strong><font size="2"><?php 
			if (getValue($objRS,"senha_gerador") != "")
			  	echo getValue($objRS,"senha") ;
			else
				echo "******";
		  ?></font></strong></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td><font size='2'><b><br>
      Importante: Essa senha � de uso exclusivo do Expositor. As empresas montadoras
      ter�o senha pr�pria e individual.</b><BR>
      <BR>
      Em caso de d�vida, queira por gentileza nos contatar pelo fone (11) 3897.6157 ou 6156.<BR>
      <BR>
      Atenciosamente, <BR>
      <BR>
      <img width="108" height="50" src="../img/ass_ilton.gif"> <br>
      ILTON MIRANDA <BR>
      Depto Operacional <br>
      <br>
      </font> </td>
  </tr>
  <tr align="center">
    <td><hr>
      <font size="2"><?php echo preg_replace("/(\\r)?\\n/i", "<br/>", getValue($objRS,"rodape")); ?></font> </td>
  </tr>
</table>
<!-- Quebra de p�gina-->
<div class="folha"> </div>
<?php } ?>
</body>
</html>
<?php $objConn = NULL; ?>
