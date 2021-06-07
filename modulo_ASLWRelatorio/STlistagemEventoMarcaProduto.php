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
$boolIsExportation = ($strAcao == ".xls") || ($strAcao == ".doc");

//Exportação para excel, word e adobe reader
if($boolIsExportation) {
	//Coloca o cabeçalho de download do arquivo no formato especificado de exportação
	header("Content-type: application/force-download"); 
	header("Content-Disposition: attachment; filename=Modulo_" . getTText(getsession($strSesPfx . "_titulo"),C_NONE) . "_". time() . $strAcao);
	
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
</head>
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<div align="center" style="font-size:14px; font-weight:bold;"> <?php echo($nome_evento." - " . $local ." - ". substr($dt_inicio,0,-5) ." a ". $dt_fim); ?></div>
<div align="center" style="font-size:9px; font-weight:bold;"> <?php echo(getTText("listagem_marcas_produtos",C_NONE)); ?></div>
<div align="left" style="font-size:9px; font-weight:bold; padding-bottom:20px;"> <?php echo(date("m/d/y"))." ".date("H:i:s"); ?></div><hr>

<?php  
					$objConn = abreDBConn(CFG_DB); // Abertura de banco	
					
					try{
					// SQL Principal	
					$strSQL = "
								SELECT     ped_pedidos.idmercado
										 , ped_pedidos.idpedido
										 , ped_pedidos.datape
										 , ped_pedidos.codigope
										 , ped_pedidos.prazopagto
										 , ped_pedidos.firstvenc
										 , ped_pedidos.razaope
										 , ped_pedidos.fantasiape
										 , ped_pedidos.enderecope
										 , ped_pedidos.bairrope
										 , ped_pedidos.cidadepe
										 , ped_pedidos.estadope
										 , ped_pedidos.ceppe
										 , ped_pedidos.paispe
										 , ped_pedidos.cgcmfpe
										 , ped_pedidos.inscrestpe
										 , ped_pedidos.telefone1pe
										 , ped_pedidos.telefone2pe
										 , ped_pedidos.telefone3pe
										 , ped_pedidos.telefone4pe
										 , ped_pedidos.idreprepe
										 , ped_pedidos.idmontpe
										 , ped_pedidos.areape
										 , ped_pedidos.tipope
										 , ped_pedidos.localpe
										 , cad_evento.descrevento
										 , cad_evento.edicao
										 , cad_evento.dt_inicio
										 , cad_evento.dt_fim
										 , cad_evento.local
										 , cad_areas.descrarea
										 , cad_pavilhao.descrpavilhao
										 , ped_pedidos.idreprepe
										 , ped_pedidos.idevento
										 , (SELECT cad_cadastro_sub.contato || ' - ' || cad_cadastro_sub.cargo FROM cad_cadastro_sub
                                            WHERE cad_cadastro_sub.resp_cp = 'S' AND cad_cadastro_sub.idmercado = ped_pedidos.idmercado 
                                            AND cad_cadastro_sub.codigo = ped_pedidos.codigope LIMIT 1) AS contato
										 , cad_cadastro.lista_prodp
										 , cad_cadastro.email
										 , cad_cadastro.website
								FROM cad_evento
								INNER JOIN (((ped_pedidos LEFT JOIN cad_areas ON ped_pedidos.tipope = cad_areas.idarea)
								LEFT JOIN cad_pavilhao ON ped_pedidos.pavilhaope = cad_pavilhao.idpavilhao)
								INNER JOIN cad_cadastro ON (ped_pedidos.idmercado = cad_cadastro.idmercado AND ped_pedidos.codigope = cad_cadastro.codigo))
								ON cad_evento.idevento = ped_pedidos.idevento
								WHERE ped_pedidos.idevento = '".$id_evento."'
								AND NOT ped_pedidos.excluida 
								AND ped_pedidos.idstatus NOT IN ('005','100') 
								AND (CAST(SUBSTR(ped_pedidos.idpedido,8,2)AS INTEGER) = 0 OR CAST(SUBSTR(ped_pedidos.idpedido,8,2)AS INTEGER) >= 30) 
								AND ped_pedidos.catalogo
								ORDER BY ped_pedidos.prazopagto,
										 ped_pedidos.firstvenc,
										 ped_pedidos.razaope ";
					
					$objResult = $objConn->query($strSQL); // execução da query
				}catch(PDOException $e){
					mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
					die();
				}
				$cont = 0;
		
			foreach($objResult as $objRS){		
				if ($cont < 3){
       		?>
            <table  width="100%" border="0" bgcolor="#FFFFFF">
                <tr>
                    <td> 
                    	<font size="2"><b><?php echo(getValue($objRS,"razaope")."(".getValue($objRS,"idreprepe").")"); ?></b></font><br>
                    </td>
                </tr>
                <?php if (getValue($objRS,"fantasiape") != ""){?>
	                <tr>                	
    	                <td><font size="2">Nome Fantasia: <?php echo(getValue($objRS,"fantasiape")); ?></font><br></td>                    
        	        </tr>
                <?php }?>
                <?php if (getValue($objRS,"contato") != ""){?>
	                <tr>
    	                <td><font size="2">Contato Principal: <?php echo(getValue($objRS,"contato")); ?></font><br></td>                    
        	        </tr>
                <?php }?>
                <tr>
                    <td><font size="2">Endereço: <?php echo(getValue($objRS,"enderecope"));?></font></td>
                </tr>                
                <tr>
                    <td ><font size="2"><?php echo(getValue($objRS,"cidadepe")."/". getValue($objRS,"estadope")); ?> </font></td>
                </tr>
                <tr>
                    <td><font size="2">Telefone: <?php echo(getValue($objRS,"telefone1pe")); ?> - Fax: <?php echo(getValue($objRS,"telefone2pe")); ?></font></td>
                </tr>
                <?php if (getValue($objRS,"emailpe") != ""){?>
	                <tr>
    	                <td><font size="2">E-mail: <?php echo(getValue($objRS,"emailpe")); ?></font></td>
        	        </tr>
                <?php }?>
                <?php if (getValue($objRS,"websitepe") != ""){?>
	                <tr>
    	            	<td>Website: <?php echo(getValue($objRS,"websitepe"));?></font></td>
        	        </tr>
                <?php }?>
                <tr>
                <td><font size="2">Marcas:</b></font>
                <?php
				try{
					$strSQLmarca = "SELECT cad_marcas.codigo
									 , cad_marcas.idmercado
									 , cad_marcas.descrmarca
									 , cad_marcas.catalogo
								   FROM cad_marcas
								   WHERE cad_marcas.codigo = '".getValue($objRS,"codigope")."'
								   AND cad_marcas.idmercado = '".$id_empresa."';";
								   
					$objResultMarcas = $objConn->query($strSQLmarca); // execução da query
					}
				catch(PDOException $e){
					mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
					die();
				}
                foreach($objResultMarcas as $objRSmarca){						   
	                ?>
                            <table>
                                <tr>
                                    <td style="padding-left:10px;"><?php if (getValue($objRSmarca,"catalogo")){echo("<img src='../img/imgstatus_fechado.gif' width='14' height='14' alt='Catálogo'>");}?></td>
                                    <td><?php echo(getValue($objRSmarca,"descrmarca"));?></td>
                                </tr>
                            </table>
                <?php } ?>
                </td>
            	</tr>	
                <tr>
                    <td><font size="2">Produtos: <?php echo getValue($objRS,"lista_prodp"); ?></font></td>
                </tr>	
                <tr>
                    <td><font size="2">Localização: <?php echo getValue($objRS,"localpe"); if (getValue($objRS,"descrpavilhao") <> null){echo ' - '. getValue($objRS,"descrpavilhao");}?> </font></td>
                </tr>
                
                <?php $cont++;?>
            </table><br><hr>
        <?php }
       			else				
        {?>
        	<div class="folha">&nbsp;</div>
            <table  width="100%" border="0" bgcolor="#FFFFFF" >
                <tr>
                    <td>
                    	<font size="2"><b><?php echo(getValue($objRS,"razaope")."(".getValue($objRS,"idreprepe").")"); ?></b></font><br>
                    </td>
                </tr>
                <?php if (getValue($objRS,"fantasiape") != ""){?>
	                <tr>                	
    	                <td><font size="2">Nome Fantasia: <?php echo(getValue($objRS,"fantasiape")); ?></font><br></td>                    
        	        </tr>
                <?php }?>
                <?php if (getValue($objRS,"contato") != ""){?>
	                <tr>
    	                <td><font size="2">Contato Principal: <?php echo(getValue($objRS,"contato")); ?></font><br></td>                    
        	        </tr>
                <?php }?>
                <tr>
                    <td><font size="2">Endereço: <?php echo(getValue($objRS,"enderecope"));?></font></td>
                </tr>                
                <tr>
                    <td ><font size="2"><?php echo(getValue($objRS,"cidadepe")."/". getValue($objRS,"estadope")); ?> </font></td>
                </tr>
                <tr>
                    <td><font size="2">Telefone: <?php echo(getValue($objRS,"telefone1pe")); ?> - Fax: <?php echo(getValue($objRS,"telefone2pe")); ?></font></td>
                </tr>
                <?php if (getValue($objRS,"emailpe") != ""){?>
	                <tr>
    	                <td><font size="2">E-mail: <?php echo(getValue($objRS,"emailpe")); ?></font></td>
        	        </tr>
                <?php }?>
                <?php if (getValue($objRS,"websitepe") != ""){?>
	                <tr>
    	            	<td>Website: <?php echo(getValue($objRS,"websitepe"));?></font></td>
        	        </tr>
                <?php }?>
                <tr>
                <td><font size="2">Marcas:</b></font>
                <?php
				try{
					$strSQLmarca = "SELECT cad_marcas.codigo
									 , cad_marcas.idmercado
									 , cad_marcas.descrmarca
									 , cad_marcas.catalogo
								   FROM cad_marcas
								   WHERE cad_marcas.codigo = '".getValue($objRS,"codigope")."'
								   AND cad_marcas.idmercado = '".$id_empresa."';";
								   
					$objResultMarcas = $objConn->query($strSQLmarca); // execução da query
				}
                catch(PDOException $e){
					mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
					die();
                }
                foreach($objResultMarcas as $objRSmarca){						   
	                ?>
                    <table>
                        <tr>
                            <td style="padding-left:10px;"><?php if (getValue($objRSmarca,"catalogo")){echo("<img src='../img/imgstatus_fechado.gif' width='14' height='14' alt='Catálogo'>");}?></td>
                            <td><?php echo(getValue($objRSmarca,"descrmarca"));?></td>
                        </tr>
                    </table>
                    <?php } ?>
	                </td>
            	</tr>	
                <tr>
                    <td><font size="2">Produtos: <?php echo getValue($objRS,"lista_prodp"); ?></font></td>
                </tr>	
                <tr>                    
                    <td><font size="2">Localização: <?php echo getValue($objRS,"localpe"); if (getValue($objRS,"descrpavilhao") <> null){echo ' - '. getValue($objRS,"descrpavilhao");}?> </font></td>
                </tr>
                </tr>                
			</table><br><hr>
         <?php $cont = 1;}?>
			<?php } ?>
</body>
</html>
<?php
$objConn = NULL; 
?>