<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_evento		= getsession(CFG_SYSTEM_NAME."_id_evento"); 
$id_empresa		= getsession(CFG_SYSTEM_NAME."_id_mercado"); 
$nome_evento	= getsession(CFG_SYSTEM_NAME."_nome_completo_evento");
$dt_inicio		= getsession(CFG_SYSTEM_NAME."_dt_inicio");
$dt_fim			= getsession(CFG_SYSTEM_NAME."_dt_fim"); 
$local			= getsession(CFG_SYSTEM_NAME."_local");


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
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<div align="center" style="font-size:14px; font-weight:bold;"> <?php echo($nome_evento." - " . $local ." - ". substr($dt_inicio,0,-5) ." a ". $dt_fim); ?></div>
<div align="center" style="font-size:9px; font-weight:bold;"> <?php echo(getTText("listagem_expo_repre",C_NONE)); ?></div>
<div align="left" style="font-size:9px; font-weight:bold; padding-bottom:20px;"> <?php echo(date("m/d/y"))." ".date("H:i:s"); ?></div><hr>

<table width="100%" border="0" bgcolor="#FFFFFF">
    <tr>
		<td colspan="5"><strong><?php echo(getTText("razao_social_repr",C_NONE)); ?></strong></td>    
    </tr>
    <tr>
    	<td width="10%" style="padding-left:15px;"><strong><?php echo(getTText("cod_repr",C_NONE)); ?></strong></td>
        <td width="40%"><strong><?php echo(getTText("representante_fantasia",C_NONE)); ?></strong></td>
        <td width="10%"><strong><?php echo(getTText("atuacao",C_NONE)); ?></strong></td>
        <td width="10%"><strong><?php echo(getTText("regiao",C_NONE)); ?></strong></td>
        <td width="30%">&nbsp;</td>        
    </tr>
    <tr>
    	<td width="10%" style="padding-left:15px;"></td>
        <td width="40%"><strong><?php echo(getTText("fones",C_NONE)); ?></strong></td>
        <td width="20%"><strong><?php echo(getTText("email",C_NONE)); ?></strong></td>        
        <td width="30%" colspan="2"><strong><?php echo(getTText("endereco",C_NONE)); ?></strong></td>        
    </tr>
</table>
<hr>

<?php  
					$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					
					/*try{ $strSQLnest = "SET enable_nestloop = OFF";					
						$objResultnest = $objConn->query($strSQLnest); // execução da query
					}
					catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}*/
					
					try{
					// SQL Principal	
					$strSQL = " SELECT DISTINCT ped_pedidos.idmercado
											  , ped_pedidos.codigope
											  , ped_pedidos.razaope
											  , ped_pedidos.idevento
								FROM ped_pedidos 
										INNER JOIN cad_representantes_industrial ON (ped_pedidos.idmercado = cad_representantes_industrial.idmercado) AND (ped_pedidos.codigope = cad_representantes_industrial.codigo)
								WHERE     ped_pedidos.idevento='".$id_evento."' 
									  AND NOT ped_pedidos.excluida 
									  AND ped_pedidos.idstatus NOT IN ('005', '100') 
									  AND (CAST(SUBSTR(ped_pedidos.idpedido,8,2)AS INTEGER)=0 OR CAST(SUBSTR(ped_pedidos.idpedido,8,2)AS INTEGER)>=30) 
									  AND ped_pedidos.catalogo
									  AND cad_representantes_industrial.dt_inativo IS NULL
								ORDER BY ped_pedidos.razaope;";
										
				$objResult = $objConn->query($strSQL); // execução da query
				}catch(PDOException $e){
							mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
							die();
					}
				$cont = 0;?>
		
			<?php foreach($objResult as $objRS){?>
            <table width="100%" border="0" bgcolor="#FFFFFF">
                <tr>
                    <td colspan="5" style="padding-top:5px; font-size:12px;"><strong><?php echo(getValue($objRS,"razaope")); ?></strong></td>    
                </tr>
                
                    <?php try{// SQL Secundario	
								$strSQLrepre = " SELECT cad_representantes_industrial.codigo
												 , cad_representantes_industrial.idmercado
												 , cad_representantes_industrial.idrepreexpo
												 , cad_representantes_industrial.repreexpo
												 , cad_representantes_industrial.nome_fantasia
												 , cad_representantes_industrial.area
												 , cad_representantes_industrial.idatua
												 , cad_atuacao_representante.areaatuacao
												 , cad_representantes_industrial.telefone as fone1
												 , cad_representantes_industrial.telefone2 as fone2
												 , cad_representantes_industrial.email
												 , cad_representantes_industrial.endereco
												 , cad_representantes_industrial.bairro
												 , cad_representantes_industrial.cep
												 , cad_representantes_industrial.cidade
												 , cad_representantes_industrial.estado
												 , cad_representantes_industrial.pais
											FROM cad_representantes_industrial 
													LEFT JOIN cad_atuacao_representante ON cad_representantes_industrial.idatua = cad_atuacao_representante.idatua
											WHERE cad_representantes_industrial.idmercado = '".$id_empresa."'
												  AND cad_representantes_industrial.codigo = '".getValue($objRS,"codigope")."'
												  AND cad_representantes_industrial.dt_inativo IS NULL";
													
							$objResultRepre = $objConn->query($strSQLrepre); // execução da query
							}catch(PDOException $e){
										mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
										die();
								}
						 foreach($objResultRepre as $objRSrepre){
						?>
                    <tr>
                        <td style="padding-left:15px;"><?php echo(getValue($objRSrepre,"idrepreexpo")); ?></td>
                        <td><?php echo(getValue($objRSrepre,"repreexpo"));?></td>
                        <td><?php echo(getValue($objRSrepre,"area"));?></td>
                        <td colspan="2"><?php echo(getValue($objRSrepre,"areaatuacao"));?></td>
					</tr>                    
                    <tr>
                        <td style="padding-left:15px;"></td>
                        <td><?php echo(getValue($objRS,"telefone") . (getValue($objRS,"telefone2")=="" ? "" : " / ".(getValue($objRS,"telefone2"))));?></td>
                        <td><?php echo(getValue($objRSrepre,"email"));?></td>
                        <td><?php echo(getValue($objRS,"endereco") . (getValue($objRS,"bairro")=="" ? "" : " / ".(getValue($objRS,"bairro"))) . (getValue($objRS,"cep")=="" ? "" : " / ".(getValue($objRS,"cep"))) . (getValue($objRS,"cidade")=="" ? "" : " / ".(getValue($objRS,"cidade"))) . (getValue($objRS,"estado")=="" ? "" : " / ".(getValue($objRS,"estado"))) . (getValue($objRS,"pais")=="" ? "" : " / ".(getValue($objRS,"pais"))));?></td>                        
                    </tr>
                    <tr><td colspan="5"><hr></td></tr>
                    <?php }?>
            </table><hr>
        <?php }?>
       			
</body>
</html>
<?php $objConn = NULL; ?>