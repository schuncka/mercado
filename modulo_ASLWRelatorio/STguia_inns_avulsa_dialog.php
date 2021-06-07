<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

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
					<div id="Conteudo" class="conteudo" style="width:582;  height:none;"><div id="GlassHeader" class="header" style="background-color:#C9DCF5;width:582px;"><span style='margin-left:4px;'>RELATÓRIOS - Definir Parâmetro Para Consulta</span></div> 
		<table border="0" width="100%" bgcolor="#FFFFFF" style="border:1px #A6A6A6 solid;">
		  <form name="formconf" action="STguia_inns_avulsa_exe.php" method="post">
			<tr>
			  <td style="padding:10px;"><b></b></td>
			</tr>
			<tr>
				<td align="center" valign="top">
					<table width="550" border="0" cellspacing="0" cellpadding="4">
						
						<tr>
							<td align="left" width="121">3 - Código de Pagto: </td>
							<td width="413"><input type="text" name="cod_pagt" value="" ></td>
						</tr>
						             
						<tr>
							<td align="left" width="121">4 - Competência:</td>
							<td><input type="text" name="competencia" value="" ></td>
						</tr>
						<tr>
							<td align="left" width="121">Razão Social:</td>
							<td><select name="razao" style="width: 300px;" 
			onChange="ajaxDetailData('select endereco from cad_FORNEC where cod_fornec ='+this.value, 'ajaxMontaEdit', 'endereco', '');
					  ajaxDetailData('select cgcmf    from cad_FORNEC where cod_fornec ='+this.value, 'ajaxMontaEdit', 'identificador', '') "  >
							
							
									<?php
										$objConn = abreDBConn(CFG_DB); // Abertura de banco		
										try{					
										$strSQL = " SELECT cad_FORNEC.NOMEMONT,
															cad_fornec.cod_fornec
													FROM cad_FORNEC
													ORDER BY cad_FORNEC.NOMEMONT;
												  ";
										$objResult = $objConn->query($strSQL); // execução da query
										}catch(PDOException $e){
												mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
												die();
										}
										foreach($objResult as $objRS){
									?>
												<option value="<?php  echo getValue($objRS,"cod_fornec");  ?>">  
												  <?php echo getValue($objRS,"nomemont"); ?>  </option>
									<?php } ?>	
							
							</select></td>
						</tr>
						
						<tr>
							<td align="left" width="121">Endereço:</td>
							<td><input type="text" name="endereco" value="" id="endereco" size="77"></td>
						</tr>
						<tr>
							<td align="left" width="121">5 - Indentificador</td>
							<td><input type="text" name="identificador" value="" id="identificador"></td>
						</tr>
							
						<tr>
							<td align="left" width="121">6 - Valor do INSS</td>
							<td><input type="text" name="valor_inns" value="" ></td>
						</tr>
						<tr>
							<td align="left" width="121">7 - 
						  <input type="text" name="campo7" value="" > </td>
							<td><input type="text" name="valor_campo7" value="" ></td>
						</tr>
						<tr>
							<td align="left" width="121">8 - 
						  <input type="text" name="campo8" value="" ></td>
							<td><input type="text" name="valor_campo8" value="" ></td>
						</tr>
						<tr>
							<td align="left" width="121">9 - Outras Entidades: </td>
							<td><input type="text" name="entidade" value="" ></td>
						</tr>
						<tr>
							<td align="left" width="121">10 - ATM/Multa e Juros </td>
							<td><input type="text" name="atm" value="" ></td>
						</tr>
						<tr>
							<td align="left" width="121">Observação</td>
							<td><textarea name="obs" cols="67" rows="4"></textarea></td>
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
			<input type="hidden" name="var_strparam" >
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
