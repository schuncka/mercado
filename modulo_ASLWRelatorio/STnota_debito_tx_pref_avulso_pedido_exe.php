<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$dt_final = request("dt_final");




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
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					// SQL Principal	
					try{
					$strSQL = "select
		-- ped_pedidos.*                           ,
       ped_pedidos.razaope,
       ped_pedidos.enderecope,
       ped_pedidos.cidadepe,
	   ped_pedidos.estadope,
        ped_pedidos.cgcmfpe,
         ped_pedidos.inscrestpe,
       ped_pedidos.idpedido as id              ,
       cad_empresa.idmercado                   ,
       cad_empresa.erazao                      ,
       cad_empresa.efantasia                   ,
       cad_empresa.edeposito                   ,
       cad_empresa.erodape                     ,
       cad_empresa.eemail                      ,
       cad_empresa.eemail_op                   ,
       cad_empresa.deposito                    ,
       cad_empresa.etele                       ,
       cad_empresa.efax                        ,
       cad_empresa.ecnpj                       ,
       cad_empresa.eie                         ,
       ('data_digitada') as vcto,
       ('261.60') as valor_nota,
      cad_evento.nome_completo
from   cad_evento
       inner join (cad_empresa
              inner join ped_pedidos
       on     cad_empresa.idmercado = ped_pedidos.idmercado)
       on     (cad_evento.idmercado       = cad_empresa.idmercado)
       and    (cad_evento.idevento        = ped_pedidos.idevento)
where  
       cad_empresa.idmercado     ilike '".$id_empresa."';";
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
	<?php $logo = "../img/".CFG_SYSTEM_NAME."_logo_".$id_empresa.".gif";?>
		<img src="<?php echo $logo; ?>"><br><br>
		<font size="2"><?php echo preg_replace("/(\\r)?\\n/i", "<br/>", getValue($objRS,"erodape")); ?></font>
		<br><br>
	</td>
  </tr>
  <tr>
    <td colspan="2"><div align="center"> <font size="3"> <b>NOTA DE D�BITO <b></font></div></td>
  </tr>
  <tr>
    <td width="67%">&nbsp;</td>
    <td width="33%"><div align="left"> <font size="2">CNPJ..................: <?php echo getValue($objRS,"ecnpj") ?><br>
        Insc. Estadual.....: <?php echo getValue($objRS,"eie") ?> <br>
        Data da Emiss�o.: <?php echo date("d/m/Y");  ?></font><br>
      </div></td>
  </tr>
</table>

<table width="100%" border="1">
  <tr align="center">
    <td><font size="2">Nota de D�bito N�</font></td>
    <td><font size="2">Vencimento</font></td>
    <td><font size="2">Valor em R$</font></td>
  </tr>
  <tr align="center">
    <td><font size="3"><b><?php echo getValue($objRS,"id") ?></b></font></td>
    <td><font size="3"><b><?php echo $dt_final ?></b></font></td>
    <td><font size="3"><b><?php echo getValue($objRS,"valor_nota") ?></b></font></td>
  </tr>
</table>
<br>
<br>
<table width="100%" border="1">
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
<table width="100%" border="1">
  <tr>
    <td width="17%" height="65" valign="top" ><font size="2">Valor por Extenso. :</font></td>
	
<?php	
//recebe o valor
$valor = getValue($objRS,"valor_nota") ;
//recebe o valor escrito
$var_valor_extenso = valorporextenso($valor);
//imprime o valor em Maisculas
?>
	
    <td width="83%" align="justify"><font face="Lucida Console" size="2"><b> <?php echo "( ".convertem($var_valor_extenso, 1)." )"; ?>
<?php 
					$palavra = strlen($var_valor_extenso);
					
					while ($palavra < 195) {
						echo " ";
						$palavra++;
						if ($palavra < 191){
							echo "#";
							$palavra++;
						}	
					}
					  ?>
</b></font>
</td>
</tr>
</table>
<font size="2">Devem � <?php  echo getValue($objRS,"erazao") ?>, a import�ncia correspondente �s despesas abaixo: </font><br>
<br>
<table width="100%" border="1">
  <tr>
    <td><table width="100%" border="0">
        <tr>
          <td colspan="4" ><font size="2">Descri��o das Despesas</font></td>
        </tr>
        <tr>
          <td colspan="4"> <font size="2"><b>TAXAS MUNICIPAIS ref. a sua participa��o no evento <?php  echo getValue($objRS,"nome_completo") ?></b></font> </td>
        </tr>
        <tr>
          <td><font size="2"><b>( x ) TFE - Taxa de Fiscaliza&ccedil;&atilde;o e Estabelecimento:</b></font></td>
          <td><font size="2"><b>R$ 114,61</b></font></td>
          <td width="8%">&nbsp;</td>
          <td width="20%">&nbsp;</td>
        </tr>
        <tr>
          <td><font size="2"><b>( x ) TFA - Taxa de Fiscaliza&ccedil;&atilde;o de An&uacute;ncios:</b></font></td>
          <td><font size="2"><b> R$ 71,64</b></font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td><font size="2"><b>( x ) TFA - Taxa de Fiscaliza&ccedil;&atilde;o de Distrib. Folhetos:</b></font></td>
          <td><font size="2"><b> R$ 71,64</b></font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td><font size="2"><b>( x ) Despesas Administrativas:</b></font></td>
          <td><font size="2"><b> R$ 3,71</b></font></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td height="58" colspan="2" valign="top"><br>
            <hr>
           <font size="2"><b><br></b></font>          </td>
          <td rowspan="2">&nbsp;</td>
          <td rowspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td width="58%" height="58" valign="top"><font size="2"><b>VALOR TOTAL DESSA NOTA DE D�BITO: </b></font></td>
          <td width="14%" valign="top"><font size="2"><b>R$ 261,60</b></font></td>
        </tr>
      </table></td>
  </tr>
</table>
<br>
<br>
<br>
<font size="2">
Observa��es:<br>
(1) A presente Nota de D�bito n�o est� sujeita a reten��o de Imposto de Renda na Fonte.<br>
(2) Essa Nota de D�bito n�o vale como recibo.<br>
<br>
Forma de Pagamento:<br>
Dep�sito BANCO BRADESCO - Ag�ncia 3391-0 - Conta 46.680-8<br>
</font>
</td>
</tr>
</table>
 <!-- Quebra de p�gina-->
<div class="folha"> </div>
<?php } ?>

</body>
</html>
<?php $objConn = NULL; ?>
