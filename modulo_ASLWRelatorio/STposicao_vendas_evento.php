<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_evento = getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado"); 

$objConn = abreDBConn(CFG_DB); // Abertura de banco

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



</style>
</head>
<body style="margin:10px 0px 10px 0px;">

<?php	  


try{
$strSQL = "SET enable_nestloop = off;";
$objResult = $objConn->query($strSQL);
}catch(PDOException $e) {
	mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
	die();
}


//---------------DADOS DO EVENTO-------------------------


$strSQL = "select 	to_char(dt_inicio, 'dd/mm/yyyy') as dt_inicio, 
						to_char(dt_fim, 'dd/mm/yyyy') as dt_fim, 
						nome_completo,
						edicao 
				from cad_evento where idevento = '".$id_evento."';";
										
					try{
					$objResult = $objConn->query($strSQL); // execução da query	
								
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
		
			 
			$objRS 	= $objResult->fetch();	
			
			$var_dt_inicio		=  getValue($objRS,"dt_inicio");
			$var_dt_final		=  getValue($objRS,"dt_fim");
			$var_edicao			=  getValue($objRS,"edicao");
			$var_nome_completo	=  getValue($objRS,"nome_completo");
			

//---------------DADOS DA CONSULTA-------------------------


 $strSQL = "SELECT cad_evento.idevento,
               cad_evento.idmercado,
               cad_evento.nome_completo,
               cad_evento.edicao,
               cad_evento.dt_inicio,
               cad_evento.dt_fim,
               cad_evento.areatot as local,        
               vw_posicao_vendas01.nro01 ,
               vw_posicao_vendas02.nro02,
               vw_posicao_vendas03.nro03,
               vw_posicao_vendas04.nro04,
               vw_posicao_vendas05.nro05,
               vw_posicao_vendas06.nro06,
               vw_posicao_vendas07.nro07,
               vw_posicao_vendas08.nro08,
               vw_posicao_vendas09.nro09,
               vw_posicao_vendas10.nro10,
               vw_posicao_vendas11.nro11,
               vw_posicao_vendas12.nro12,
               vw_posicao_vendas13.nro13,
               vw_posicao_vendas14.nro14,
               current_date AS datahora
        FROM   CAD_EVENTO
                LEFT JOIN vw_posicao_vendas01 ON cad_evento.idevento = vw_posicao_vendas01.ideventope
                LEFT JOIN vw_posicao_vendas02 ON cad_evento.idevento = vw_posicao_vendas02.ideventope
                LEFT JOIN vw_posicao_vendas03 ON cad_evento.idevento = vw_posicao_vendas03.ideventope
                LEFT JOIN vw_posicao_vendas04 ON cad_evento.idevento = vw_posicao_vendas04.ideventope
                LEFT JOIN vw_posicao_vendas05 ON cad_evento.idevento = vw_posicao_vendas05.ideventope
                LEFT JOIN vw_posicao_vendas06 ON cad_evento.idevento = vw_posicao_vendas06.ideventope
                LEFT JOIN vw_posicao_vendas07 ON cad_evento.idevento = vw_posicao_vendas07.ideventope
                LEFT JOIN vw_posicao_vendas08 ON cad_evento.idevento = vw_posicao_vendas08.ideventope
                LEFT JOIN vw_posicao_vendas09 ON cad_evento.idevento = vw_posicao_vendas09.ideventope
                LEFT JOIN vw_posicao_vendas10 ON cad_evento.idevento = vw_posicao_vendas10.ideventope
                LEFT JOIN vw_posicao_vendas11 ON cad_evento.idevento = vw_posicao_vendas11.ideventope
                LEFT JOIN vw_posicao_vendas12 ON cad_evento.idevento = vw_posicao_vendas12.ideventope
                LEFT JOIN vw_posicao_vendas13 ON cad_evento.idevento = vw_posicao_vendas13.ideventope
                LEFT JOIN vw_posicao_vendas14 ON cad_evento.idevento = vw_posicao_vendas14.ideventope
        WHERE  CAD_EVENTO.IDEVENTO = '".$id_evento."'";
										
					try{
					$objResult = $objConn->query($strSQL); // execução da query	
								
					}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
						  	$objRS 	= $objResult->fetch();   // RETORNA OS VALORES DE UMA LINHA
?>			  





<div align="center"><font size="5"><b><i>RESUMO DE VENDAS</i></b></font> </div>

<table width="100%" border="1" bgcolor="#000000">
  <tr>
    <td align="center"><font size="2" color="#FFFFFF"><b><?php echo ($var_nome_completo); ?> - <?php echo ($var_edicao); ?> Edição - <?php echo ($var_dt_inicio); ?> a <?php echo ($var_dt_final); ?></b></font></td>
  </tr>
</table>
Área Total............. <?php echo getValue($objRS,"local"); ?> m²<br>
<hr>
<div align="center"><font size="2"><b>POSIÇÃO DE CONTRATOS NACIONAIS</b></font> </div>

<table width="80%" border="0" align="center">
  <tr>
    <td width="82%"><font size="2">TOTAL DE EMPRESAS.......................................................................</font></td>
    <td width="18%">
	
      <div align="right"><?php echo getValue($objRS,"nro01"); ?>      </div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE &Aacute;REA SEM MONTAGEM.....................................................</font></td>
    <td>
	<div align="right"><?php echo number_format((getValue($objRS,"nro02") - getValue($objRS,"nro03")), 2, ',', '.'); ?>        </div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE &Aacute;REA COM MONTAGEM.....................................................</font></td>
    <td><div align="right"><?php echo number_format(getValue($objRS,"nro03"), 2, ',', '.'); ?></div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE ACERTOS.........................................................................</font></td>
    <td><div align="right"><?php echo number_format(getValue($objRS,"nro04"), 2, ',', '.'); ?></div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE M&sup2;...................................................................................</font></td>
    <td>
	<div align="right"><?php echo number_format((getValue($objRS,"nro04")+getValue($objRS,"nro02")), 2, ',', '.'); ?>        </div></td>
  </tr>
  <tr>
    <td><font size="2"><b>TOTAL DE M&sup2; FATURADOS (Exceto Acertos)..............................</b></font></td>
    <td><div align="right"><?php echo number_format(getValue($objRS,"nro02"), 2, ',', '.'); ?></div></td>
  </tr>
</table>

<hr>
<div align="center"><font size="2"><b>POSIÇÃO DE CONTRATOS INTERNACIONAIS</b></font> </div>

<table width="80%" border="0" align="center">
  <tr>
    <td width="82%"><font size="2">TOTAL DE EMPRESAS.......................................................................</font></td>
    <td width="18%"><div align="right"><?php echo getValue($objRS,"nro05"); ?></div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE &Aacute;REA SEM MONTAGEM.....................................................</font></td>
    <td><div align="right"><?php echo number_format((getValue($objRS,"nro06")-getValue($objRS,"nro07")), 2, ',', '.'); ?></div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE &Aacute;REA COM MONTAGEM.....................................................</font></td>
    <td><div align="right"><?php echo number_format(getValue($objRS,"nro07"), 2, ',', '.'); ?></div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE ACERTOS.........................................................................</font></td>
    <td><div align="right"><?php echo number_format(getValue($objRS,"nro08"), 2, ',', '.'); ?></div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE M&sup2;...................................................................................</font></td>
    <td><div align="right"><?php echo number_format((getValue($objRS,"nro06")+getValue($objRS,"nro08")), 2, ',', '.'); ?></div></td>
  </tr>
  <tr>
    <td><font size="2"><b>TOTAL DE M&sup2; FATURADOS (Exceto Acertos)..............................</b></font></td>
    <td><div align="right"><?php echo number_format(getValue($objRS,"nro06"), 2, ',', '.'); ?></div></td>
  </tr>
</table>

<hr>


<table width="80%" border="1" align="center">
  <tr>
    <td width="82%" style="border-right:none; border-bottom:none"><font size="2">TOTAL DE EMPRESAS.......................................................................</font></td>
    <td width="18%" style="border-left:none; border-bottom:none"><div align="right"><?php echo (getValue($objRS,"nro01")+getValue($objRS,"nro05")); ?></div></td>
  </tr>
  <tr>
    <td style="border-right:none ; border-top:none"><font size="2">TOTAL DE &Aacute;REA LIMPA.....................................................................</font></td>
    <td style="border-left:none; border-bottom:none" bgcolor="#000000" align="right"><font size="2"; color="#FFFFFF"><b><?php echo number_format((getValue($objRS,"nro02")+getValue($objRS,"nro06")), 2, ',', '.'); ?></b></font></td>
  </tr>
</table>

<hr>
<div align="center"><font size="2"><b>POSIÇÃO DE PERMUTAS</b></font> </div>
<table width="80%" border="0" align="center">
  <tr>
    <td width="82%"><font size="2">TOTAL DE EMPRESAS.......................................................................</font></td>
    <td width="18%"><div align="right"><?php echo getValue($objRS,"nro09"); ?></div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE M&sup2;...................................................................................</font></td>
    <td><div align="right"><?php echo number_format(getValue($objRS,"nro10"), 2, ',', '.'); ?></div></td>
  </tr>
</table>
<hr>
<div align="center"><font size="2"><b>POSIÇÃO DE CORTESIAS</b></font> </div>
<table width="80%" border="0" align="center">
  <tr>
    <td width="82%"><font size="2">TOTAL DE EMPRESAS.......................................................................</font></td>
    <td width="18%"><div align="right"><?php echo getValue($objRS,"nro11"); ?></div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE M&sup2;...................................................................................</font></td>
    <td><div align="right"><?php echo number_format(getValue($objRS,"nro12"), 2, ',', '.'); ?></div></td>
  </tr>
</table>

<hr>
<div align="center"><font size="2"><b>POSIÇÃO DE RESERVAS / RENOVAÇÃO</b></font> </div>
<table width="80%" border="0" align="center">
  <tr>
    <td width="82%"><font size="2">TOTAL DE EMPRESAS.......................................................................</font></td>
    <td width="18%"><div align="right"><?php echo getValue($objRS,"nro13"); ?></div></td>
  </tr>
  <tr>
    <td><font size="2">TOTAL DE M&sup2;...................................................................................</font></td>
    <td><div align="right"><?php echo number_format(getValue($objRS,"nro14"), 2, ',', '.'); ?></div></td>
  </tr>
</table>

<hr>
<div align="center"><font size="2"><b>POSIÇÃO DE GERAL</b></font> </div>

<table width="80%" border="1" align="center">
  <tr>
    <td width="82%" style="border-right:none; border-bottom:none"><font size="2"><b>TOTAL DE EMPRESAS (Exeto Reservas).......................................</b></font></td>
    <td width="18%" style="border-left:none; border-bottom:none">
	
	  <div align="right"><?php echo ((getValue($objRS,"nro01")+getValue($objRS,"nro05")+getValue($objRS,"nro09")+getValue($objRS,"nro11"))); ?>      </div></td>
  </tr>
  <tr>
    <td style="border-right:none; border-bottom:none; border-top:none"><font size="2"><b>TOTAL DE M² (Fatur+Perm+Cort)...............................................</b></font></td>
    <td style="border-left:none; border-top:none; border-bottom:none">
	
	  <div align="right"><?php echo number_format((getValue($objRS,"nro02")+getValue($objRS,"nro06")+getValue($objRS,"nro10")+getValue($objRS,"nro12")), 2, ',', '.'); ?>      </div></td>
  </tr>
  <tr>
    <td width="82%" style="border-right:none; border-bottom:none; border-top:none"><font size="2"><b>TOTAL DE M² (Fatur+Perm+Cort+Acertos).................................</b></font></td>
    <td width="18%" style="border-left:none; border-top:none; border-bottom:none">

  	  <div align="right"><?php echo number_format((getValue($objRS,"nro02")+getValue($objRS,"nro04")+getValue($objRS,"nro06")+getValue($objRS,"nro08")+getValue($objRS,"nro10")+getValue($objRS,"nro12")), 2, ',', '.'); ?>      </div></td>  
  </tr>
  <tr>
    <td style="border-right:none; border-bottom:none; border-top:none"><font size="2"><b>TOTAL DE M² (Fatur+Perm+Cort+Acertos+Reservas)................</b></font></td>
    <td style="border-left:none; border-top:none; border-bottom:none">
	<div align="right"><?php echo number_format((getValue($objRS,"nro02")+getValue($objRS,"nro04")+getValue($objRS,"nro06")+getValue($objRS,"nro08")+getValue($objRS,"nro10")+getValue($objRS,"nro12")+getValue($objRS,"nro14")), 2, ',', '.'); ?>            </div></td>
  </tr>
   <tr>
    <td style="border-right:none; border-top:none"><font size="2"><b>ÁREA DISPONÍVEL PARA VENDA (M²).........................................</b></font></td>
    <td style="border-left:none; border-top:none";>
	
	 <div align="right">
	 
	 <?php echo number_format((getValue($objRS,"local")-(getValue($objRS,"nro02")+getValue($objRS,"nro04")+getValue($objRS,"nro06")+getValue($objRS,"nro08")+getValue($objRS,"nro10")+getValue($objRS,"nro12")+getValue($objRS,"nro14"))), 2, ',', '.'); ?>        </div></td>
  </tr>
</table>

<br>
<br>
<div align="center"> Impresso em <?php echo date("d/m/Y H:i:s"); ?></div>




</body>
</html>


<?php 

try{
$strSQL = "SET enable_nestloop = on;";
$objResult = $objConn->query($strSQL);
}catch(PDOException $e) {
	mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
	die();
}



$objConn = NULL; ?>
