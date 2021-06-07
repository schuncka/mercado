<?php




include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
$dt_inicio = request("dt_inicio");
$dt_final = request("dt_final");



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

// Função Mês Extenso
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



<!--
table.bordasimples {border-collapse: collapse;}
table.bordasimples tr td {border:1px solid #000000;}
-->

</style>
</head>
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<?php
			  		$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					// SQL Principal	
					try{
					$strSQL = "SELECT DISTINCT                                 
                                                 ped_nota_fiscal.razaonf 
												, upper(cad_empresa.erazao) as erazao
                              					, upper( ped_nota_fiscal.cgcmfnf) as cgcmfnf
                                                ,ped_nota_fiscal.codigonf
												,cad_empresa.ecnpj
								FROM     (cad_empresa
										 RIGHT JOIN ped_nota_fiscal
										 ON       cad_empresa.idmercado = ped_nota_fiscal.idmercado)
										 INNER JOIN ped_pedidos_parcelamento
										 ON       (ped_nota_fiscal.NRODUPLICATA = ped_pedidos_parcelamento.NRODUPLICATA)
										 AND      (ped_nota_fiscal.idmercado    = ped_pedidos_parcelamento.idmercado)
								WHERE    (((ped_pedidos_parcelamento.DATAPGTO) BETWEEN 
								to_date('$dt_inicio', 'DD/MM/YYYY')	AND to_date('$dt_final', 'DD/MM/YYYY')))
								GROUP BY DATE_PART('MONTH',DATApgto)        ,
										date_part('MONTH', ped_pedidos_parcelamento.datapgto),     
										 cad_empresa.ERODAPE             ,
										 cad_empresa.ERAZAO              ,
										 ped_nota_fiscal.RAZAONF       ,
										 ped_nota_fiscal.ENDERECONF    ,
										 ped_nota_fiscal.BAIRRONF      ,
										 ped_nota_fiscal.CIDADENF      ,
										 ped_nota_fiscal.ESTADONF      ,
										 ped_nota_fiscal.CEPNF         ,
										 ped_nota_fiscal.PAISPE        ,
										 ped_nota_fiscal.CGCMFNF       ,
										 cad_empresa.ECNPJ               ,
										 ped_nota_fiscal.CODIGONF      ,
										 ped_nota_fiscal.idmercado
								HAVING   (((SUM(ped_pedidos_parcelamento.VLRCOFINS))  >0)
										 AND      ((ped_nota_fiscal.idmercado)='$id_empresa'))
								OR       (((SUM(ped_pedidos_parcelamento.VLRPIS))     >0)
										 AND      ((ped_nota_fiscal.idmercado)='$id_empresa'))
								OR       (((SUM(ped_pedidos_parcelamento.VLRCSLL))    >0)
										 AND      ((ped_nota_fiscal.idmercado)='$id_empresa'))
								ORDER BY ped_nota_fiscal.RAZAONF;";
								$objResult = $objConn->query($strSQL); // execução da query	
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}			
			
			  	foreach($objResult as $objRS){
				$codigo_empresa = getValue($objRS,"codigonf");
			  ?>
<table width="100%" border="0" bgcolor="#FFFFFF">
  <tr>
    <td>
	<table width="100%"  class="bordasimples" >
        <tr>
          <td width="9%" align="50%" style="border-right:none"><img width="98" height="65" src="../img/logo_receita_federal.gif"><br>
          </td>
          <td width="42%" style="border-left:none" ><font size="2"> Ministerio da Fazenda<br>
            Secretaria da Receita Federal do Brasil</font> </td>
          <td width="49%" align="50%" ><div align="center"><font size="2">COMPROVANTE ANUAL DE RETENÇÃO DE CSLL, Cofins e PIS/Pasep (Lei nº 10833, art. 30)</font><br>
              <br>
              <font size="2"><b> Ano-Calendario <?php echo substr("$dt_final",-4); ?> </b></font> </div></td>
        </tr>
     </table>
	  <font size="2"><b> 1. FONTE PAGADORA </b></font>
      <table width="100%"  class="bordasimples" >
        <tr>
          <td width="75%" align="50%" style="border-right:none"> Nome Empresarial <br>
            <b><?php echo getValue($objRS,"razaonf") ?></b> </td>
          <td width="25%" align="50%"> CNPJ <br>
            <b> <?php echo getValue($objRS,"cgcmfnf") ?> </b> </td>
        </tr>
      </table>
      <font size="2"><b>2. PESSOA JURÍDICA BENEFICIARIA DOS RENDIMENTO</b></font>
      <table width="100%"  class="bordasimples" >
        <tr>
          <td width="75%" align="50%" style="border-right:none" > Nome Empresarial <br>
            <b><?php echo getValue($objRS,"erazao") ?> </b></td>
          <td width="25%" align="50%"> CNPJ <br>
            <b><?php echo getValue($objRS,"ecnpj") ?></b> </td>
        </tr>
      </table>
      <font size="2"><b> 3. RENDIMENTO E IMPORTO RETIDO NA FONTE</b></font>
      <table width="100%"  class="bordasimples" >
        <tr>
          <td width="25%" align="center" style="border-right:none"><b>Mês</b> </td>
          <td width="25%" align="center" style="border-right:none"><b>Cod. Ret. </b></td>
          <td width="25%" align="center" style="border-right:none"><b>Rendimento (R$) </b> </td>
          <td width="25%" align="center"><b>Imposto Retido (R$)</b> </td>
        </tr>
        <?php
			  	
					// SQL Secundário	
					try{
					$strSQLsecundario = "SELECT 
                              Sum(ped_nota_fiscal.valornf) AS somadevalornf
                              ,((Sum(ped_pedidos_parcelamento.vlrcofins)) + (Sum(ped_pedidos_parcelamento.vlrpis)) + (Sum(ped_pedidos_parcelamento.vlrcsll))) as imposto
							  , date_part('MONTH', ped_pedidos_parcelamento.datapgto) AS mesnum
                              ,CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '01' THEN
                                                    'JAN'
                                                 ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '02' THEN
                                                        'FEV'
                                                    ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '03' THEN
                                                            'MAR'
                                                        ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '04' THEN
                                                                'ABR'
                                                            ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '05' THEN
                                                                    'MAI'
                                                                ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '06' THEN
                                                                        'JUN'
                                                                    ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '07' THEN
                                                                            'JUL'
                                                                        ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '08' THEN
                                                                                'AGO'
                                                                            ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '09' THEN
                                                                                    'SET'
                                                                                ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '10' THEN
                                                                                        'OUT'
                                                                                    ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '11' THEN
                                                                                            'NOV'
                                                                                        ELSE CASE WHEN date_part('MONTH', ped_pedidos_parcelamento.datapgto) = '12' THEN
                                                                                                'DEZ'
                                                                                        END
                                                                                    END
                                                                                END
                                                                            END
                                                                        END
                                                                    END
                                                                END                               
                                                            END      
                                                        END         
                                                    END      
                                                 END             
                              				END AS mes
                              , ('5952') as cod_ret 
FROM     (cad_empresa
         RIGHT JOIN ped_nota_fiscal
         ON       cad_empresa.idmercado = ped_nota_fiscal.idmercado)
         INNER JOIN ped_pedidos_parcelamento
         ON       (ped_nota_fiscal.NRODUPLICATA = ped_pedidos_parcelamento.NRODUPLICATA)
         AND      (ped_nota_fiscal.idmercado    = ped_pedidos_parcelamento.idmercado)
WHERE    (
			((ped_pedidos_parcelamento.DATAPGTO) BETWEEN to_date('$dt_inicio', 'DD/MM/YYYY') AND to_date('$dt_final', 'DD/MM/YYYY'))
           AND   ped_nota_fiscal.codigonf  =  '$codigo_empresa'   
          )
GROUP BY DATE_PART('MONTH',DATApgto)        ,
		date_part('MONTH', ped_pedidos_parcelamento.datapgto),     
         cad_empresa.ERODAPE             ,
         cad_empresa.ERAZAO              ,
         ped_nota_fiscal.RAZAONF       ,
         ped_nota_fiscal.ENDERECONF    ,
         ped_nota_fiscal.BAIRRONF      ,
         ped_nota_fiscal.CIDADENF      ,
         ped_nota_fiscal.ESTADONF      ,
         ped_nota_fiscal.CEPNF         ,
         ped_nota_fiscal.PAISPE        ,
         ped_nota_fiscal.CGCMFNF       ,
         cad_empresa.ECNPJ             ,
         ped_nota_fiscal.CODIGONF      ,
         ped_nota_fiscal.idmercado
HAVING   (((SUM(ped_pedidos_parcelamento.VLRCOFINS))  >0)
         AND      ((ped_nota_fiscal.idmercado)='$id_empresa'))
OR       (((SUM(ped_pedidos_parcelamento.VLRPIS))     >0)
         AND      ((ped_nota_fiscal.idmercado)='$id_empresa'))
OR       (((SUM(ped_pedidos_parcelamento.VLRCSLL))    >0)
         AND      ((ped_nota_fiscal.idmercado)='$id_empresa'))
ORDER BY ped_nota_fiscal.RAZAONF;";
									
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}			
				$objResultsecundario = $objConn->query($strSQLsecundario); // execução da query
			  	foreach($objResultsecundario as $objRSsecundario){
				
	  ?>
        <tr>
          <td width="25%" align="center"><?php echo getValue($objRSsecundario,"mes") ?> </td>
          <td width="25%" align="center"><?php echo getValue($objRSsecundario,"cod_ret") ?> </td>
          <td width="25%" align="right"><?php echo number_format(getValue($objRSsecundario,"somadevalornf"), 2, ',', '.'); ?> </td>
          <td width="25%" align="right"><?php echo number_format(getValue($objRSsecundario,"imposto"), 2, ',', '.'); ?> </td>
        </tr>
        <?php } ?>
      </table>
      <font size="2"><b> 4.INFORMAÇÕES COMPLEMENTARES</b></font>
      <table width="100%"  class="bordasimples" >
        <tr>
          <td width="25%" align="50%"><br>
            <br>
            <br>
            <br>
            <br>
            <br></td>
        </tr>
      </table>
      <font size="2"><b> 5. RESPONSAVEL PELAS INFORMAÇÕES </b></font>
      <table width="100%"  class="bordasimples" >
        <tr>
          <td width="50%" align="50%"> Nome <br>
            <br>
            <br></td>
          <td width="15%" align="50%"> Data <br>
            <br>
            <br></td>
          <td width="35%" align="50%"> Assinatura <br>
            <br>
            <br></td>
        </tr>
      </table>
	  <br> <br> <br> <br>
	 <!-- Quebra de página-->
	  <div class="folha">
	  </div>
	  
</td>
</tr>
<?php } ;?>
</table>

</body>
</html>
<?php $objConn = NULL; ?>
