<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");

$stridmercado 	= getsession(CFG_SYSTEM_NAME."_id_mercado");

$dateDtFat 		= request("var_dataemi");
$dateDtIni 		= request("var_dtinicio");
$dateDtFim 		= request("var_dtfim");


$strIdpedido	= request("var_idpedido");

include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");


	// ABERTURA DE CONEXÃO COM BANCO DE DADOS
	$objConn = abreDBConn(CFG_DB);
	
	
			try{
			//expositores ///--DoCmd.OpenQuery "qry_Faturamento DARF Inserir PED 10833 BLOQ"
			$strSQL = " SELECT DISTINCT  ped_pedidos.idpedido
										,tmp_ped_pedidos_parcelamento.vencimentoped
										,tmp_ped_pedidos_parcelamento.datafat
										,cad_cadastro.cnpjcob AS cgcmfnf
										,cad_cadastro.telefone1
										,cad_cadastro.razaocob AS razaonf
										,'".$dateDtFat."' AS DATANF1
										,ped_nota_fiscal.datanf
										,ped_nota_fiscal.observacao
										,cad_evento.descrevento
										,ped_nota_fiscal.descricao4
										,CASE WHEN cad_cadastro.ret_10833 THEN tmp_ped_pedidos_parcelamento.valorpar * 0.0465 ELSE 0 END AS vlr
										,'10833' AS expr1
										,CAST(tmp_ped_pedidos_parcelamento.vencimentoped AS DATE) + CAST((7 - (EXTRACT(DOW FROM tmp_ped_pedidos_parcelamento.vencimentoped)+1)) AS INTEGER) AS apur
										,CAST(tmp_ped_pedidos_parcelamento.vencimentoped AS DATE) + CAST((11 - (EXTRACT(DOW FROM tmp_ped_pedidos_parcelamento.vencimentoped)+1)) AS INTEGER) AS venc
						FROM cad_evento 
						INNER JOIN (((ped_pedidos 
									  INNER JOIN tmp_ped_pedidos_parcelamento ON (ped_pedidos.idpedido LIKE tmp_ped_pedidos_parcelamento.idpedido) 
																	 AND (ped_pedidos.idmercado ILIKE tmp_ped_pedidos_parcelamento.idmercado)) 
									  INNER JOIN cad_cadastro ON (ped_pedidos.idmercado ILIKE cad_cadastro.idmercado) 
												AND (ped_pedidos.codigope LIKE cad_cadastro.codigo)) 
									  LEFT JOIN ped_nota_fiscal ON (tmp_ped_pedidos_parcelamento.nronf LIKE ped_nota_fiscal.idnotafiscal) 
													AND (tmp_ped_pedidos_parcelamento.idmercado ILIKE ped_nota_fiscal.idmercado)) 
						ON cad_evento.idevento LIKE ped_pedidos.idevento";
			
			if($strIdpedido!=""){
				$strSQL .= " WHERE tmp_ped_pedidos_parcelamento.idpedido LIKE '".$strIdpedido."' 
						    AND (tmp_ped_pedidos_parcelamento.vencimentoped Between '".$dateDtIni."' AND '".$dateDtFim."')
						    AND tmp_ped_pedidos_parcelamento.datapgto IS NULL
						    AND tmp_ped_pedidos_parcelamento.datafat  IS NULL
						    AND ped_pedidos.idmercado LIKE '".$stridmercado."'
						    AND (CASE WHEN cad_cadastro.ret_10833 THEN tmp_ped_pedidos_parcelamento.valorpar * 0.0465 ELSE 0 END) > 0
						    ORDER BY cad_cadastro.razaocob";
			}else{
				$strSQL .= " WHERE (tmp_ped_pedidos_parcelamento.vencimentoped Between '".$dateDtIni."' AND '".$dateDtFim."')
							AND tmp_ped_pedidos_parcelamento.datafat  IS NULL
							AND (CASE WHEN cad_cadastro.ret_10833 THEN tmp_ped_pedidos_parcelamento.valorpar * 0.0465 ELSE 0 END) > 0
							AND tmp_ped_pedidos_parcelamento.datapgto IS NULL
							AND ped_nota_fiscal.idnotafiscal  IS NULL 
							AND ped_pedidos.idmercado ILIKE '".$stridmercado."'
							ORDER BY cad_cadastro.razaocob;";
			}
						
						
			//--DoCmd.OpenQuery "qry_Faturamento DARF Inserir PED 10833".			
			$strSQL2 = "SELECT DISTINCT  ped_pedidos.idpedido
										,tmp_ped_pedidos_parcelamento.vencimentoped
										,tmp_ped_pedidos_parcelamento.datafat
										,ped_nota_fiscal.idnotafiscal
										,ped_nota_fiscal.idnfe
										,cad_cadastro.cnpjcob AS cgcmfnf
										,cad_cadastro.telefone1
										,cad_cadastro.razaocob AS razaonf
										,'".$dateDtFat."' AS datanf1
										,ped_nota_fiscal.datanf
										,ped_nota_fiscal.observacao
										,cad_evento.descrevento
										,ped_nota_fiscal.descricao4
										,ped_nota_fiscal.valorcsll + ped_nota_fiscal.valorcofins + ped_nota_fiscal.valorpis AS vlr
										,'10833' AS expr1
										,ped_nota_fiscal.datanf as apur
										,sp_calc_vcto_css(CAST('".$dateDtFat."' AS DATE)) AS venc
						FROM cad_evento 
						INNER JOIN (((ped_pedidos 
									 INNER JOIN tmp_ped_pedidos_parcelamento ON (ped_pedidos.idpedido LIKE tmp_ped_pedidos_parcelamento.idpedido) 
																			 AND (ped_pedidos.idmercado LIKE tmp_ped_pedidos_parcelamento.idmercado)) 
									 INNER JOIN cad_cadastro ON (ped_pedidos.idmercado LIKE cad_cadastro.idmercado) 
															 AND (ped_pedidos.codigope LIKE cad_cadastro.codigo)) 
									 LEFT JOIN ped_nota_fiscal ON (tmp_ped_pedidos_parcelamento.nronf LIKE ped_nota_fiscal.idnotafiscal) 
															   AND (tmp_ped_pedidos_parcelamento.idmercado LIKE ped_nota_fiscal.idmercado)) 
						ON cad_evento.idevento = ped_pedidos.idevento";
						
			if($strIdpedido!=""){
				$strSQL2 .= " WHERE tmp_ped_pedidos_parcelamento.idpedido LIKE '".$strIdpedido."'
							  AND (tmp_ped_pedidos_parcelamento.vencimentoped BETWEEN '".$dateDtIni."' AND '".$dateDtFim."') 
							  AND (tmp_ped_pedidos_parcelamento.datafat BETWEEN '".$dateDtIni."' AND '".$dateDtFat."') 
							  AND (ped_nota_fiscal.valorcsll + ped_nota_fiscal.valorcofins + ped_nota_fiscal.valorpis) > 0 
							  AND tmp_ped_pedidos_parcelamento.datapgto IS NULL
							  AND ped_pedidos.idmercado ILIKE '".$stridmercado."'
							  ORDER BY cad_cadastro.razaocob;";
			}else{
				$strSQL2 .= " WHERE (tmp_ped_pedidos_parcelamento.vencimentoped BETWEEN '".$dateDtIni."' AND '".$dateDtFim."') 
							  AND (tmp_ped_pedidos_parcelamento.datafat BETWEEN '".$dateDtIni."' AND '".$dateDtFat."') 
							  AND (ped_nota_fiscal.valorcsll + ped_nota_fiscal.valorcofins + ped_nota_fiscal.valorpis) > 0 
							  AND tmp_ped_pedidos_parcelamento.datapgto IS NULL
							  AND ped_pedidos.idmercado ILIKE '".$stridmercado."'
							  ORDER BY cad_cadastro.razaocob;";
			}
			//--DoCmd.OpenQuery "qry_Faturamento DARF Inserir SER 10833"
			$strSQL3 = "SELECT DISTINCT  ped_servico.idservico
										,tmp_ped_servico_parcelamento.vencimentoped
										,tmp_ped_servico_parcelamento.datafat
										,ped_nota_fiscal.idnotafiscal
										,ped_nota_fiscal.idnfe
										,cad_montador.cgcmf AS cgcmfnf
										,cad_montador.telefone1
										,cad_montador.nomemont AS razaonf
										,'".$dateDtFat."' AS datanf1
										,ped_nota_fiscal.datanf
										,ped_nota_fiscal.observacao
										,cad_evento.descrevento
										,ped_nota_fiscal.descricao4
										,ped_nota_fiscal.valorcsll + ped_nota_fiscal.valorcofins + ped_nota_fiscal.valorpis AS vlr
										,'10833' AS expr1
										,ped_nota_fiscal.datanf as apur
										,sp_calc_vcto_css(CAST(tmp_ped_servico_parcelamento.vencimentoped AS DATE)) AS venc
						FROM (cad_evento 
						INNER JOIN (ped_servico 
									INNER JOIN (tmp_ped_servico_parcelamento 
												LEFT JOIN ped_nota_fiscal ON (tmp_ped_servico_parcelamento.idmercado ILIKE ped_nota_fiscal.idmercado) 
																			AND (tmp_ped_servico_parcelamento.nronf ILIKE ped_nota_fiscal.idnotafiscal)) 
									ON (ped_servico.idservico LIKE tmp_ped_servico_parcelamento.idservico) 
									AND (ped_servico.idmercado ILIKE tmp_ped_servico_parcelamento.idmercado)) 
						ON cad_evento.idevento LIKE ped_servico.ideventose) 
						INNER JOIN cad_montador ON ped_servico.idmontse LIKE cad_montador.idmont";
						
			if($strIdpedido!=""){
				$strSQL3 .= " WHERE tmp_ped_servico_parcelamento.idservico LIKE '".$strIdpedido."'
							AND (tmp_ped_servico_parcelamento.vencimentoped BETWEEN '".$dateDtIni."' AND '".$dateDtFim."') 
							AND (tmp_ped_servico_parcelamento.datafat BETWEEN '".$dateDtIni."' AND '".$dateDtFat."') 
							AND tmp_ped_servico_parcelamento.datapgto IS NULL 
							AND ped_servico.idmercado LIKE '".$stridmercado."'
							ORDER BY cad_montador.nomemont;";		
			}else{
				$strSQL3 .= " WHERE (tmp_ped_servico_parcelamento.vencimentoped BETWEEN '".$dateDtIni."' AND '".$dateDtFim."') 
							AND (tmp_ped_servico_parcelamento.datafat BETWEEN '".$dateDtIni."' AND '".$dateDtFat."') 
							AND tmp_ped_servico_parcelamento.datapgto IS NULL 
							AND ped_servico.idmercado LIKE '".$stridmercado."'
							ORDER BY cad_montador.nomemont;";
			}			
			
			$objResult 		= $objConn->query($strSQL);
			$objResult2 	= $objConn->query($strSQL2);
			$objResult3 	= $objConn->query($strSQL3);
		}catch(PDOException $e) {
			mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1,"");
			die();
		}	

?>
<html>
<head>
<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

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

.dados{
		font-size:11px;
		font-weight:bold;
		font-family:Arial;		
}

.dadoscampos{
		font-size:9px;
		font-weight:bold;
		font-family:Arial;
		vertical-align:text-top;
}
td{font-family:Arial, Helvetica, sans-serif;}

img{
	border:none;
}

hr {
      border-top: 1px dashed #000000;
      color: #fff;
      background-color: #fff;
      height: 4px;
}
.folha {page-break-after: always;
}
</STYLE>
</head>
<body style="margin:10px 0px 10px 0px;" background="../img/bgFrame_<?php echo(CFG_SYSTEM_THEME); ?>_main.jpg" >
<p>
<!-- ****** SQL BLOQ ********-->
<?php foreach($objResult as $objRS){ ?>
<center>
<br>
<table width="95%" class="bordasimples" border="1" bgcolor="#FFFFFF" cellpadding="1px">
  <tr>
    <td width="9%" rowspan="4" align="center" style="border-right:none"><img src="../img/logo_ministerio_da_fazenda.gif" width="99" height="89"> </td>
    <td width="43%" rowspan="4" style="border-left:none"> <font size="3"><b> MINISTÉRIO DA FAZENDA </b></font><BR>
								<font size="2"><b> SECRETARIA DA RECEITA FEDERAL  </b></font><br>
								<font size="2">Documento de Arrecadação de Receitas Federais  </font><br>
								<font size="3"><b> DARF </b></font>    
	<td width="27%" height="20"><b>02<font class="dadoscampos"> PERÍODO DE APURAÇÃO </font></b></td>
    <td width="21%" align="center" class="dados"><?php echo dDate("PTB",getValue($objRS,"apur"),""); ?></td>
  </tr>
  <tr>
    <td><b>03 <font class="dadoscampos" >NÚMERO DO CPF OU CNPJ</font></b></td>
    <td align="center" class="dados"><?php echo getValue($objRS,"cgcmfnf"); ?></td>
  </tr>
  <tr>
    <td><b>04 <font class="dadoscampos">CÓDIGO DA RECEITA</font></b></td>
    <td align="center" class="dados"><?php echo '5952' ?></td>
  </tr>
  <tr>
    <td><b>05 <font class="dadoscampos">NÚMERO DE REFERÊNCIA </font></b></td>
    <td align="center" class="dados">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" rowspan="3"><b>01 <font class="dadoscampos">NOME/TELEFONE</font></b><br>
    &nbsp; &nbsp; &nbsp; <b class="dados"><?php echo getValue($objRS,"razaonf"); ?> </b><br>
	&nbsp; &nbsp; &nbsp; <b class="dados"><?php echo getValue($objRS,"telefone1"); ?></b> </td>
    <td><b>06 <font class="dadoscampos">DATA DE VENCIMENTO</font></b></td>
    <td align="center" class="dados"><?php echo getValue($objRS,"venc"); ?></td>
  </tr>
  <tr>
    <td><b>07 <font class="dadoscampos">VALOR PRINCIPAL</font></b></td>
    <td align="right" class="dados"><?php echo number_format((double) getValue($objRS,"vlr"),2,',','.'); ?></td>
  </tr>
  <tr>
    <td><b>08 <font class="dadoscampos">VALOR DA MULTA</font></b></td>
    <td align="right" class="dados">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" style="font-size:12px;">&nbsp; &nbsp; &nbsp; Lei 10.8333 = CSLL(1%) + CONFINS(3%) + PIS/PASEP(0,65%)</td>
    <td><b>09 <font class="dadoscampos">VALOR DOS JUROS E/OU <br> 
		&nbsp; &nbsp; &nbsp; ENCARGOS DL - 1.025/69 </font></b></td>
    <td align="center" class="dados"></td>
  </tr>
  <tr>
    <td colspan="2" rowspan="3" align="center" style="padding:10">
	<font size="3"><b>ATENÇÃO</b></font> </div><BR>
	<div align="justify" style="font-size:12px;">
				É vedado o recolhimento de tributos e contribuições administrados pela
			Secretaria da Receita Federal cujo valor total seja inferior a R$ 10,00.
			Ocorrendo tal situação, adicione esse valor ao tributo/contribuição de
			mesmo código de períodos subsequentes, até que o total seja igual ou
			superior a R$ 10,00.<br><br><br>
			Nota Fiscal Eletrônica: <font class="dados"><?php echo getValue($objRS,"idnfe"); ?></font><br>
			RPS............................... : <font class="dados"><?php echo getValue($objRS,"idnotafiscal"); ?></font><br>
			Data da N. F ................ : <font class="dados"><?php echo getValue($objRS,"datanf"); ?></font><br>
			
			</div>	
	</td>
			
    <td><b>10 <font class="dadoscampos">VALOR TOTAL</font></b></td>
    <td align="right" class="dados"></td>
  </tr>
  <tr>
    <td height="23" colspan="2" style="border-bottom:none"><b>11 <font class="dadoscampos">AUTENTICAÇÃO BANCÁRIA (Somente nas 1ª e 2ª vias)</font></b></td>
  </tr>
  <tr>
    <td height="70" colspan="2" style="border-top:none"></td>
  </tr>
</table>
<br> <br> <br>  
<hr>
<br> <br> <br> 
			<!--SEGUNDA VIA DO DARF-->
<table width="95%" class="bordasimples" border="1" bgcolor="#FFFFFF" cellpadding="1px">
  <tr>
    <td width="9%" rowspan="4" align="center" style="border-right:none"><img src="../img/logo_ministerio_da_fazenda.gif" width="99" height="89"> </td>
    <td width="43%" rowspan="4" style="border-left:none"> <font size="3"><b> MINISTÉRIO DA FAZENDA </b></font><BR>
								<font size="2"><b> SECRETARIA DA RECEITA FEDERAL  </b></font><br>
								<font size="2">Documento de Arrecadação de Receitas Federais  </font><br>
								<font size="3"><b> DARF </b></font>    
	<td width="27%" height="20"><b>02<font class="dadoscampos"> PERÍODO DE APURAÇÃO </font></b></td>
    <td width="21%" align="center" class="dados"><?php echo dDate("PTB",getValue($objRS,"apur"),""); ?></td>
  </tr>
  <tr>
    <td><b>03 <font class="dadoscampos" >NÚMERO DO CPF OU CNPJ</font></b></td>
    <td align="center" class="dados"><?php echo getValue($objRS,"cgcmfnf"); ?></td>
  </tr>
  <tr>
    <td><b>04 <font class="dadoscampos">CÓDIGO DA RECEITA</font></b></td>
    <td align="center" class="dados"><?php echo '5952' ?></td>
  </tr>
  <tr>
    <td><b>05 <font class="dadoscampos">NÚMERO DE REFERÊNCIA </font></b></td>
    <td align="center" class="dados">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" rowspan="3"><b>01 <font class="dadoscampos">NOME/TELEFONE</font></b><br>
    &nbsp; &nbsp; &nbsp; <b class="dados"><?php echo getValue($objRS,"razaonf"); ?> </b><br>
	&nbsp; &nbsp; &nbsp; <b class="dados"><?php echo getValue($objRS,"telefone1"); ?></b> </td>
    <td><b>06 <font class="dadoscampos">DATA DE VENCIMENTO</font></b></td>
    <td align="center" class="dados"><?php echo getValue($objRS,"venc"); ?></td>
  </tr>
  <tr>
    <td><b>07 <font class="dadoscampos">VALOR PRINCIPAL</font></b></td>
    <td align="right" class="dados"><?php echo number_format((double) getValue($objRS,"vlr"),2,',','.'); ?></td>
  </tr>
  <tr>
    <td><b>08 <font class="dadoscampos">VALOR DA MULTA</font></b></td>
    <td align="right" class="dados">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" style="font-size:12px;">&nbsp; &nbsp; &nbsp; Lei 10.8333 = CSLL(1%) + CONFINS(3%) + PIS/PASEP(0,65%)</td>
    <td><b>09 <font class="dadoscampos">VALOR DOS JUROS E/OU <br> 
		&nbsp; &nbsp; &nbsp; ENCARGOS DL - 1.025/69 </font></b></td>
    <td align="center" class="dados"></td>
  </tr>
  <tr>
    <td colspan="2" rowspan="3" align="center" style="padding:10">
	<font size="3"><b>ATENÇÃO</b></font> </div><BR>
	<div align="justify" style="font-size:12px;">
				É vedado o recolhimento de tributos e contribuições administrados pela
			Secretaria da Receita Federal cujo valor total seja inferior a R$ 10,00.
			Ocorrendo tal situação, adicione esse valor ao tributo/contribuição de
			mesmo código de períodos subsequentes, até que o total seja igual ou
			superior a R$ 10,00.<br><br><br>
			Nota Fiscal Eletrônica: <font class="dados"><?php echo getValue($objRS,"idnfe"); ?></font><br>
			RPS............................... : <font class="dados"><?php echo getValue($objRS,"idnotafiscal"); ?></font><br>
			Data da N. F ................ : <font class="dados"><?php echo getValue($objRS,"datanf"); ?></font><br>
			
			</div>	
	</td>
			
    <td><b>10 <font class="dadoscampos">VALOR TOTAL</font></b></td>
    <td align="right" class="dados"></td>
  </tr>
  <tr>
    <td height="23" colspan="2" style="border-bottom:none"><b>11 <font class="dadoscampos">AUTENTICAÇÃO BANCÁRIA (Somente nas 1ª e 2ª vias)</font></b></td>
  </tr>
  <tr>
    <td height="70" colspan="2" style="border-top:none"></td>
  </tr>
</table>
<br class="folha">
<?php } ?>
</center>
</body>
</html>
<?php $objConn = NULL; ?>
<script language="javascript">
	window.print();
</script>