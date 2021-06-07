<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

$objConn 			= abreDBConn(CFG_DB); // Abertura de banco
$id_evento 			= getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa 		= getsession(CFG_SYSTEM_NAME."_id_mercado");
$datawide_lang 		= getsession("datawide_lang");
$datarel            = request("datarel");


/***            VERIFICA��O DE ACESSO              ***/
/*****************************************************/
$strSesPfx 	   = strtolower(str_replace("modulo_","",basename(getcwd())));          //Carrega o prefixo das sessions
$strPopulate = ( request("var_populate") == "" ) ? "yes" : request("var_populate");
if($strPopulate == "yes") { initModuloParams(basename(getcwd())); } //Popula o session para fazer a abertura dos �tens do m�dulo
verficarAcesso(getsession(CFG_SYSTEM_NAME . "_cod_usuario"), getsession($strSesPfx . "_chave_app"),"UPD"); //Verifica��o de acesso do usu�rio corrente


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


include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");


function convertem($term, $tp) { 
    if ($tp == "1") $palavra = strtr(strtoupper($term),"������������������������������","������������������������������"); 
    elseif ($tp == "0") $palavra = strtr(strtolower($term),"������������������������������","������������������������������"); 
    return $palavra; 
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
		
		function abrirJanela(){ 
		
			//parent.window.resizeTo(700,600);
			
		var w = document.body.offsetWidth;
		var h = document.body.offsetHeight;
		
		parent.window.resizeTo(w+120, h+170);		 
			
		} 	
				
	</script>
<style type="text/css">

<!--
table.bordasimples {border-collapse: collapse;}
table.bordasimples tr td {border:1px solid #000000;}
-->

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
<body style="margin:10px 0px 10px 0px;" onLoad="abrirJanela();">
<?php

					// SQL Principal	
					try{
					$strSQL = "SELECT 
									ped_pedidos.razaope
								    , ped_pedidos.enderecope
								    , ped_pedidos.cidadepe
								    , ped_pedidos.estadope
									, ped_pedidos.cgcmfpe
									, ped_pedidos.inscrestpe
									, ped_pedidos.idpedido AS id
									, cad_empresa.idmercado
									, cad_empresa.erazao
									, cad_empresa.efantasia
									, cad_empresa.edeposito
									, cad_empresa.erodape
									, cad_empresa.eemail
									, cad_empresa.eemail_op
									, cad_empresa.deposito
									, cad_empresa.etele
									, cad_empresa.efax
									, cad_empresa.ecnpj
									, cad_empresa.eie
									--, [ENTRE COM A DATA DE VENCIMENTO] AS vcto
									, cad_evento.nome_completo
									, cad_empresa.deposito
								FROM 
									cad_evento 
									INNER JOIN 
									(cad_empresa 
									INNER JOIN 
									ped_pedidos 
										ON cad_empresa.idmercado ilike ped_pedidos.idmercado) 
										ON (cad_evento.idevento = ped_pedidos.idevento) 
										AND (cad_evento.idmercado ilike cad_empresa.idmercado)
								WHERE 
									((cad_evento.idevento = '".id_evento."' ) 
									AND  (cad_empresa.idmercado ilike '".$id_empresa."'));";
	
				$objResult = $objConn->query($strSQL); // execu��o da query	
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}		
			  	foreach($objResult as $objRS)  {?>
				

				
<table width="100%" border="0" bgcolor="#FFFFFF">
  <tr>
    <td>
<table width="100%" border="0">
  <tr>
    <td colspan="2">
	<?php //$logo = '../img/logos/cab_'.$datawide_lang.'_'.$id_evento.'.jpg';
          /*Mudan�a do cabe�alho/rodap� ficarem dentro da pasta do cliente. By Lumertz  - 09.07.2013*/
          $logo	= '../../'.getsession(CFG_SYSTEM_NAME."_dir_cliente").'/upload/imgdin/cab_'.$datawide_lang.'_'.$id_evento.'.jpg';   		
	?>
		<img width="600" height="80"  src="<?php echo $logo; ?>"><br><br><br><br>
		<font size="2"><?php echo preg_replace("/(\\r)?\\n/i", "<br/>", getValue($objRS,"erodape")); ?></font>
		<br><br>
	</td>
  </tr>
  <tr>
    <td colspan="2"><div align="center"> <font size="3"> <b>NOTA DE D�BITO <b></font></div></td>
  </tr>
  <tr>
    <td width="62%">&nbsp;</td>
    <td width="38%"><div align="left"> <font size="2">CNPJ..................: <?php echo getValue($objRS,"ecnpj") ?><br>
        Insc. Estadual.....: <?php echo getValue($objRS,"eie") ?> <br>
        Data da Emiss�o.: <?php echo date("d/m/Y");  ?></font><br>
      </div></td>
  </tr>
</table>

<?php
					// SQL Principal	
					try{
					$strSQLsom = "SELECT 
										Sum(ped_pedidos_produtos.sub_total) as soma
									FROM 
										ped_pedidos 
										INNER JOIN 
										ped_pedidos_produtos 
											ON (ped_pedidos.idmercado ilike ped_pedidos_produtos.idmercado) 
											AND (ped_pedidos.idpedido = ped_pedidos_produtos.idpedido)
									WHERE 
										((ped_pedidos.excluida = False)
										AND (ped_pedidos.idpedido = '".getValue($objRS,"id")."'));";
	
				$objResultsom = $objConn->query($strSQLsom); // execu��o da query	
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}		
			  	foreach($objResultsom as $objRSsom){
					$valorrec = getValue($objRSsom,"soma");
				}
				?>	


	<table width="100%" border="0" class="bordasimples">
	  <tr align="center">
		<td style="border-right:none"><font size="2">Nota de D�bito N�</font></td>
		<td style="border-right:none; border-left:none"><font size="2">Vencimento</font></td>
		<td style="border-left:none"><font size="2">Valor em R$</font></td>
	  </tr>
	  <tr align="center">
		<td style="border-right:none"><font size="3"><b><?php echo getValue($objRS,"id") ?></b></font></td>
		<td style="border-right:none; border-left:none"><font size="3"><b><?php echo $datarel; ?></b></font></td>
		<td style="border-left:none"><font size="3"><b><?php echo number_format(($valorrec), 2, ',', '.'); ?>
		
		</b></font></td>	
	  </tr>
	</table>
<br>
<br>
<table width="100%" border="1" style="border-collapse:collapse">
  <tr>
    <td><table width="100%" border="0">
        <tr>
          <td width="11%"><font size="2">Cliente:</font></td>
          <td width="89%"><font size="2"><b><?php echo getValue($objRS,"razaope") ?></b></font></td>
        </tr>
        <tr>
          <td><font size="2">Endere�o:</font></td>
          <td><font size="2"><b><?php echo getValue($objRS,"enderecope") ?></b></font></td>
        </tr>
        <tr>
          <td><font size="2">Cidade:</font></td>
          <td><font size="2"><b><?php echo getValue($objRS,"cidadepe") ?></b></font></td>
        </tr>
        <tr>
          <td><font size="2">Estado:</font></td>
          <td><font size="2"><b><?php echo getValue($objRS,"estadope") ?></b></font></td>
        </tr>
        <tr>
          <td><font size="2">CNPJ/CPF:</font></td>
          <td><font size="2"><b><?php echo getValue($objRS,"cgcmfpe") ?></b></font></td>
        </tr>
        <tr>
          <td><font size="2">I.E:</font></td>
          <td><font size="2"><b><?php echo getValue($objRS,"inscrestpe") ?></b></font></td>
        </tr>
      </table></td>
  </tr>
</table>
<br>
<table width="100%" border="0" class="bordasimples">
  <tr>
    <td width="21%" height="65" valign="top" style="border-right:none"><font size="2">Valor por Extenso. :</font></td>
	
<?php	
//recebe o valor
$valor = $valorrec ;
//recebe o valor escrito
$var_valor_extenso = valorporextenso($valor);
//imprime o valor em Maisculas
?>
	
    <td width="79%" align="justify" style="border-left:none"><font face="Lucida Console" size="2"><b> <?php echo "( ".convertem($var_valor_extenso, 1)." )"; ?>
<?php 
					$palavra = strlen($var_valor_extenso);
					
					while ($palavra < 184) {
						echo " ";
						$palavra++;
						if ($palavra < 184){
							echo "#";
							$palavra++;
						}	
					}
					  ?>
</b></font></td>
</tr>
</table>
<font size="2">Devem � <?php  echo getValue($objRS,"erazao") ?>, a import�ncia correspondente �s despesas abaixo: </font><br>
<br>
<table width="100%"  border="1" style="border-collapse:collapse">
  <tr>
    <td><table width="100%" border="0">
        <tr>
          <td colspan="5" ><font size="2">Descri��o das Despesas</font></td>
        </tr>
        <tr>
          <td colspan="5"> <font size="2"><b>SERVI�OS ADICIONAIS ref. a sua participa��o no evento <?php  echo getValue($objRS,"nome_completo") ?></b></font> </td>
        </tr>
        <tr>
          <td width="58%" colspan="5"><font size="2"><b>&nbsp;</b></font></td>
        </tr>
        <tr>
          <td width="10%"><font size="1"><b>QTDE</b></font></td>
          <td width="10%"><font size="1"><b>UNID</b></font></td>
		  <td width="40%"><font size="1"><b>DESCRI��O DOS PRODUTOS/SERVI�OS</b></font></td>
		  <td width="20%"><font size="1"><b>PRE�O UNIT</b></font></td>
		  <td width="20%"><font size="1"><b>SUB-TOTAL</b></font></td>		  		  
        </tr>
        <tr>
          <td colspan="5">
            <hr>		  </td>
        </tr>
<?php
					// SQL Principal	
					try{
					$strSQLsec = "SELECT 
									ped_pedidos.codigope
									, ped_pedidos_produtos.idpedido
									, ped_pedidos_produtos.idmercado
									, ped_pedidos_produtos.itempedi
									, ped_pedidos_produtos.idproduto
									, ped_pedidos_produtos.descrpedido	
									, CASE WHEN ped_pedidos_produtos.idproduto = 'SE0001' THEN
										'kva'
									  ELSE ped_pedidos_produtos.unidpedido
									  END AS unid	
									, ped_pedidos_produtos.preco_pedi
									, CASE WHEN ped_pedidos_produtos.idproduto = 'SE0001' THEN
										ped_pedidos_produtos.quant_pedi * 0.065
									  ELSE ped_pedidos_produtos.quant_pedi
									  END AS qtde
									, ped_pedidos_produtos.desc_pedi
									, ped_pedidos_produtos.preco_end
									, ped_pedidos_produtos.sub_total
									, ped_pedidos_produtos.servico
								FROM 
									ped_pedidos 
									INNER JOIN 
									ped_pedidos_produtos 
										ON (ped_pedidos.idmercado ilike ped_pedidos_produtos.idmercado) 
										AND (ped_pedidos.idpedido = ped_pedidos_produtos.idpedido)
								WHERE 
									((ped_pedidos.excluida = False)
									AND (ped_pedidos.idpedido = '".getValue($objRS,"id")."'))
								ORDER BY
									ped_pedidos_produtos.itempedi;";
	
				$objResultsec = $objConn->query($strSQLsec); // execu��o da query	
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}		
					$valorrec = 0;
			  	foreach($objResultsec as $objRSsec){
					$valorrec =  $valorrec + getValue($objRSsec,"sub_total");
					?>	

        <tr>
          <td width="10%"><font size="1"><?php echo getValue($objRSsec,"qtde") ?> </font></td>
          <td width="10%"><font size="1"><?php echo getValue($objRSsec,"unid") ?> </font></td>
		  <td width="40%"><font size="1"><?php echo getValue($objRSsec,"descrpedido") ?> </font></td>
		  <td width="20%"><font size="1"><?php echo number_format(getValue($objRSsec,"preco_pedi"), 2, ',', '.'); ?></font></td>
		  <td width="20%"><font size="1"><?php echo number_format(getValue($objRSsec,"sub_total"), 2, ',', '.'); ?></font></td>		  		  
        </tr>		
<?php } ?>      
        <tr>
          <td colspan="5">
            <hr>		  </td>
        </tr>
        <tr>
          <td width="58%" valign="top" colspan="4">&nbsp;</td>
          <td width="14%" valign="top" colspan="1"><font size="1"><b>R$ <?php echo number_format(($valorrec), 2, ',', '.'); ?> </b></font></td>
        </tr>
      </table></td>
  </tr>
</table>
<br>
<br>
<br>
<font size="2">
Observa��es:<br>
(2) Essa Nota de D�bito n�o vale como recibo.<br>
<br>
Forma de Pagamento:<br>
DEP�SITO EM NOSSA CONTA CORRENTE:<br>
BANCO BRADESCO - Ag�ncia 3391-0 - Conta 46.680-8<br>
</font>
</td>
</tr>
</table>
<?php }; ?>
</body>
</html>
<?php $objConn = NULL; ?>