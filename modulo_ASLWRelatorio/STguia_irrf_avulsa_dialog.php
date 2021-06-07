<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

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
?>
 
 <html>
<head>
<title>DATAWIDE</title>
<link rel="stylesheet" href="../_css/datawide.css" type="text/css">
<script language="javascript"> 
function setParamToSQL(){
  var strMySQL, intCont;
  strMySQL = document.formconf.var_strparam.value;
  intCont = 0;
  while(document.formconf.elements[intCont].name != "") {
		strMySQL = strMySQL.replace("<ASLW_DOISPONTOS>" + document.formconf.elements[intCont].name + "<ASLW_DOISPONTOS>",document.formconf.elements[intCont].value);
		intCont++;
  }
	<!--parent.window.frames[0].document.frmRelatorio.var_strparam.value = strMySQL;-->
	<!--	parent.window.frames[0].document.frmRelatorio.action = 'STcarta_IRRF_Exec.php';-->
	<!--	parent.window.frames[0].document.frmRelatorio.submit();-->
}
 
function enableEnter(event){
	var tecla = window.event ? event.keyCode : event.which;
	if(tecla == 13){
		setParamToSQL();
		return false;
	}
}
 
function autoSubmit() {
	if(document.forms[0].elements.length == 4 && document.forms[0].elements[0].value != "") {
		setParamToSQL();
	}
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body style="margin:10px;" bgcolor="#CFCFCF" background="../img/bgFrame_imgVWHITE_main.jpg" onLoad="autoSubmit();">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
 <tr>
   <td align="center" valign="top">
	 <div id="DialogGlass" class="bordaBox" style="width:600; height:none;">
				<div class="b1"></div><div class="b2"></div><div class="b3"></div><div class="b4"></div>
				<div class="center">
					<div id="Conteudo" class="conteudo" style="width:582;  height:none;"><div id="GlassHeader" class="header" style="background-color:#C9DCF5;width:582px;"><span style='margin-left:4px;'>RELAT�RIOS - Definir Par�metro Para Consulta</span></div> 
		<table border="0" width="100%" bgcolor="#FFFFFF" style="border:1px #A6A6A6 solid;">
		  <form name="formconf" action="STguia_irrf_avulsa_exe.php" method="post">
			<tr>
			  <td style="padding:10px;"><b></b></td>
			</tr>
			<tr>
				<td align="center" valign="top">
					<table width="550" border="0" cellspacing="0" cellpadding="4">
						
						<tr>
							<td align="right" width="100">Compet�ncia</td>
							<td><input type="text" name="competencia" value="" ></td>
						</tr>
						             
						<tr>
							<td align="right" width="100">Vencimento</td>
							<td><input type="text" name="vencimento" value="" ></td>
						</tr>
						<tr>
							<td align="right" width="100">Nome do Cliente</td>
							<td><select name="nome_cliente" style="width: 300px;">
							
							
							
							
							
									<?php
									
									
							
									
										$objConn = abreDBConn(CFG_DB); // Abertura de banco		
										try{					
										$strSQL = " select cad_fornec.nomemont, cad_fornec.idmont
													from cad_fornec
													order by cad_fornec.nomemont;
												  ";
										$objResult = $objConn->query($strSQL); // execu��o da query
										}catch(PDOException $e){
												mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
												die();
										}
										
										foreach($objResult as $objRS){
									?>
												
												<option value="<?php  echo getValue($objRS,"nomemont");  ?>">  
												  <?php echo getValue($objRS,"nomemont"); ?>  </option>
									<?php } ?>			
							
							</select></td>
				
						</tr>
						<tr>
							<td align="right" width="100">CNPJ</td>
							<td><input type="text" name="cnpj" value="" ></td>
						</tr>
						<tr>
							<td align="right" width="100">Telefone</td>
							<td><input type="text" name="telefone" value="" ></td>
						</tr>
						<tr>
							<td align="right" width="100">C�digo do Tributo</td>
							<td><input type="text" name="codigo_tributo" value="" ></td>
						</tr>
						<tr>
							<td align="right" width="100">Valor do Tributo</td>
							<td><input type="text" name="valor_tributo" value="" ></td>
						</tr>
						<tr>
							<td align="right" width="100">Valor da Multa</td>
							<td><input type="text" name="valor_multa" value="0,00" ></td>
						</tr>
						<tr>
							<td align="right" width="100">Valor da Juros</td>
							<td><input type="text" name="valor_juros" value="0,00" ></td>
						</tr>
						<tr>
							<td align="right" width="100">Observa��o</td>
							<td><textarea name="observacao" cols="67" rows="4"></textarea></td>
						</tr>
						
						             						<tr><td height="5" colspan="3"></td></tr>
						<tr><td height="1" colspan="3" bgcolor="#DBDBDB"></td></tr>
						<tr>
							<td align="right" colspan="3" style="padding:10px 0px 10px 10px;">
								<button type="submit">Ok</button>
								<button onClick="parent.window.close();">Cancelar</button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<input type="hidden" name="var_strparam">
		  </form>
		</table>
		 </div>
			    </div>
			   <div class="b4"></div><div class="b3"></div><div class="b2"></div><div class="b1"></div>
		     </div>	   </td>
 </tr>
</table>
</body>
</html>
