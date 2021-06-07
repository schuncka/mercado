<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_evento 			= getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa 		= getsession(CFG_SYSTEM_NAME."_id_mercado"); 
$assinatura         = request("assinatura");
$datawide_lang 		= getsession("datawide_lang");


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

		function abrirJanela(){ 
		
		//parent.window.resizeTo(700,600); 

		var w = document.body.offsetWidth;
		var h = document.body.offsetHeight;
		
		parent.window.resizeTo(w+150, h+170);
		
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
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" onLoad="abrirJanela();" >
<table align="center" bgcolor="#FFFFFF" width="92%" border="0">
<?php  
$objConn = abreDBConn(CFG_DB); // Abertura de banco	
try{
// SQL Principal	
$strSQL = "SELECT 
				cad_cadastro.codigo 
				,DATE_PART('DAY', dt_inicio ) || '/'|| DATE_PART('MONTH', dt_inicio ) AS dt_inicio
				,DATE_PART('DAY', dt_fim ) || '/'|| DATE_PART('MONTH', dt_fim ) || '/' || DATE_PART('YEAR', dt_fim ) AS dt_fim
				, cad_cadastro.razao
				, cad_cadastro.fantasia
				, cad_cadastro.endereco
				, cad_cadastro.bairro
				, cad_cadastro.cidade
				, cad_cadastro.estado
				, cad_cadastro.cep
				, cad_cadastro.pais
				
				,DATE_PART('DAY', cad_evento.dt_inicio ) as dia_inicio
				,DATE_PART('DAY', cad_evento.dt_fim ) as dia_fim
				,DATE_PART('MONTH', cad_evento.dt_fim ) as mes_fim
				,DATE_PART('YEAR', cad_evento.dt_fim ) as ano_fim
				
				, cad_cadastro.cgcmf
				, cad_cadastro.telefone1
				, cad_cadastro.telefone2
				, cad_cadastro.telefone3
				, cad_cadastro.telefone4
				, cad_cadastro.website
				, cad_cadastro.email
				, cad_cadastro.lista_prodp
				, cad_cadastro.lista_prodi
				, cad_evento.nome_completo
				, cad_evento.pavilhao
				, cad_evento.edicao
				, LOWER(cad_tipo_evento.descricao) as tipoevento
				, ped_pedidos.largurape AS w
				, ped_pedidos.comprimentope AS comprimento
				, ped_pedidos.areape AS area    
				, ped_pedidos.localpe || CASE WHEN (cad_pavilhao.descrpavilhao) IS NULL 
											THEN NULL
											ELSE ' - ' || cad_pavilhao.descrpavilhao 
										 END AS localiz
				, cad_areas.descrarea
				, cad_empresa.efantasia
				, cad_evento.figura1
				, cad_empresa.erodape 
				, cad_evento.rodape
				, ped_pedidos.evento3
			FROM cad_evento 
			INNER JOIN ((((cad_cadastro 
			INNER JOIN ped_pedidos ON (cad_cadastro.idmercado = ped_pedidos.idmercado AND cad_cadastro.codigo = ped_pedidos.codigope)) 
			LEFT JOIN cad_pavilhao ON ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao)
			LEFT JOIN cad_areas ON ped_pedidos.tipope = cad_areas.idarea)
			INNER JOIN cad_empresa ON ped_pedidos.idmercado = cad_empresa.idmercado) 
			ON cad_evento.idevento = ped_pedidos.idevento
			INNER JOIN cad_tipo_evento ON (cad_tipo_evento.cod_tipo_evento = cad_evento.cod_tipo_evento)
			WHERE (ped_pedidos.excluida = FALSE) 
			AND (ped_pedidos.idstatus <> '005')
			AND (ped_pedidos.idstatus <> '100') 
			AND (ped_pedidos.idevento = '".$id_evento."')
			AND (ped_pedidos.idmercado ILIKE '".$id_empresa."')
			ORDER BY cad_cadastro.razao ";
	
	$objResult = $objConn->query($strSQL); // execução da query
}catch(PDOException $e){
	mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
	die();
}
foreach($objResult as $objRS){
?>
  <tr>
  	<td>
  </tr>
  <tr>	 
	<td  align="center"  >
		<?php //$logo = '../img/logos/cab_es_'.$id_evento.'.jpg';
              /*Mudança do cabeçalho/rodapé ficarem dentro da pasta do cliente. By Lumertz  - 09.07.2013*/
              $logo	= '../../'.getsession(CFG_SYSTEM_NAME."_dir_cliente").'/upload/imgdin/cab_es_'.$id_evento.'.jpg';   				
		?>
		<img width="600" height="80"  src="<?php echo $logo; ?>">  
   </tr>
  <tr align="center">
  
    <td colspan="2" align="center"> 
	
	<font size=4> <br><br> <?php echo getValue($objRS,"nome_completo"); ?> - <?php echo getValue($objRS,"pavilhao"); ?> <BR></font></td>
  </tr>
  <tr align="center">
    <td colspan="2" align="center"> <font size=3> <?php echo getValue($objRS,"dt_inicio"); ?>  a <?php echo getValue($objRS,"dt_fim"); ?>   </font></td>
  </tr>

  <tr>
    <td colspan="2" align="left"> <font size=2><br><br>São Paulo, <?php echo $mes; ?> de <?php echo date("Y"); ?></font><br><br><br><br></td>
  </tr>
  <tr>
    <td colspan="2"><br><font size=2>À</font></td>
  </tr>
  <tr>
    <td width="24%"><font size=2><b><?php echo getValue($objRS,"razao"); ?>     </b></font></td>	
    <td width="76%" align="left"> <font size=2><b><?php echo getValue($objRS,"codigo"); ?> </td>
  </tr>
  <tr>
    <td colspan="2"><font size=2><b><?php echo getValue($objRS,"endereco"); ?> - <?php echo getValue($objRS,"bairro"); ?></b><br></font></td>	
  </tr>
  	<tr><td colspan="2"><font size=2><b><?php echo getValue($objRS,"cep"); ?> - <?php echo getValue($objRS,"estado"); ?> - <?php echo getValue($objRS,"pais"); ?> <br><br></b></font></td>	
  <tr>
  	<td colspan="2"><font size=2>Ref.: <b>  UBICACIÓN DE SU STAND EN <?php echo getValue($objRS,"nome_completo"); ?></b><br><br></font></td>  	 
  </tr>
  <tr>
  	<td colspan="2"><font size=2>Sr. Presidente,</font></td>  	 
  </tr>
  <tr>
  	<td colspan="2"><font size=2>Nos gustaría informarle de que su stand en <?php echo getValue($objRS,"nome_completo"); ?>  se encuentra como se indica a continuación:</font><BR><BR>
  	  <table align="center" bgcolor="#FFFFFF" width="90%" border="1">
	<tr>
	 <td style="border:none;"><font size=2>
	 UBICACIÓN: <b><?php echo getValue($objRS,"localiz") ?></b><BR>
	 TIPO DE ESPACIO:</font><font size="2" color="#FF0000"> <b><?php echo getValue($objRS,"descrarea") ?></b>
	 </font><br></td>
	</tr>
	<br>
	<tr>
	 <td align="center" style="border:none;"><font size=2>
		 <b>STAND DE CINE</b><BR>
		 <b> <?php echo number_format(getValue($objRS,"w"),2, '.', '') ; ?>  metros de frente X 
		     <?php echo number_format(getValue($objRS,"comprimento"),2, '.', '') ; ?> metros de profundidad = 
			 <?php echo number_format(getValue($objRS,"area"),2, '.', '') ; ?> m²</b>
	 </font></td>
	</tr>
	</table>
	
	<BR><BR><BR><BR><font size="2">
	Para la mejor visualización, a raíz de planta adjunto del evento, con la demarcación de la zona de su negocio.<BR><br>
	Nos ponemos a su disposición para cualquier aclaración adicional.<BR><br>
	Recuerdos,</font><BR>
	<BR>
	<?PHP echo "<br> <font size='2'> <b>".$assinatura."</b></font><br>"; ?>
	<BR>
	<BR>
	<BR>
	<BR>
	<BR>
	<BR>
	<BR>
	<BR>
	<BR>
	<BR> 
	<hr>
	<tr align="center">
		<td colspan="2">
        <?php //$url = '../img/logos/rod_es_'.$id_evento.'.jpg';  
              /*Mudança do cabeçalho/rodapé ficarem dentro da pasta do cliente. By Lumertz  - 09.07.2013*/  
              $url	= '../../'.getsession(CFG_SYSTEM_NAME."_dir_cliente").'/upload/imgdin/rod_es_'.$id_evento.'.jpg';   				
		?>
		<img style="position:relative" width="580" height="30" src= "<?php echo $url ?>";><br>
	    </td>
		<td width="0%" style="	page-break-after: always;">	</td>
	</tr>
	<tr><td colspan="2"></td>
	

  <?php } ?>
</table>
</body>
</html>
<?php $objConn = NULL; ?>
