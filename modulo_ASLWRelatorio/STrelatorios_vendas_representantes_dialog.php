<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");
$id_evento = getsession('datawide_'."id_evento");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");

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


function encaminha(){
var x, valor;

	for(x=0; x<document.formconf.doc.length; x++){
	
		if(document.formconf.doc[x].checked){
			valor = document.formconf.doc[x].value;
			break;
		}
		
	}	
	
	<!-- Todos Representantes -->
	if(valor == "1"){
	document.forms['formconf'].action = "STrelatorios_vendas_todos_representantes_exe.php";
	document.forms['formconf'].submit();
	}

	<!-- Por Representantes -->
	if(valor == "2"){
		document.forms['formconf'].action = "STrelatorios_vendas_por_representantes_exe.php";
		document.forms['formconf'].submit();
	}	
	

}
function habilita(){
var x;  

	for(x=0; x<document.formconf.doc.length; x++){
		if(document.formconf.doc[x].checked){
			valor = document.formconf.doc[x].value;
			break;
		}		
	}
	
	if(valor == "1"){
	x = document.getElementById("chk1");    
	x.disabled = true;
	}
		
	if(valor == "2"){
	x = document.getElementById("chk1");    
	x.disabled = false;
	}

}
	

</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body style="margin:10px;" bgcolor="#CFCFCF" background="../img/bgFrame_imgVWHITE_main.jpg" onLoad="autoSubmit();">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
  <tr>
    <td align="center" valign="top"><div id="DialogGlass" class="bordaBox" style="width:600; height:none;">
      <div class="b1"></div>
      <div class="b2"></div>
      <div class="b3"></div>
      <div class="b4"></div>
      <div class="center">
        <div id="Conteudo" class="conteudo" style="width:582;  height:none;">
          <div id="GlassHeader" class="header" style="background-color:#C9DCF5;width:582px;"><span style='margin-left:4px;'>Relatório Representantes Vendas</span></div>
          <table border="0" width="100%" bgcolor="#FFFFFF" style="border:1px #A6A6A6 solid;">
            <form name="formconf" action="" method="post">
              <tr>
                <td align="center" valign="top"><table width="550" border="0" cellspacing="0" cellpadding="4">
                    
					<tr>
                      <td align="center"><fieldset>
                        <input type="radio" id="T" name="doc" value="1" style="border:none; background:none;" onClick="habilita();"/>
                        Todos Representantes
                        <input type="radio" id="E" name="doc" value="2" style="border:none; background:none;" onClick="habilita();"/>
                        Escolher Representante
                        </fieldset></td>
                    </tr>
                    
					<tr>
                      <td> <?php									
										$objConn = abreDBConn(CFG_DB); // Abertura de banco						
										$strSQL = " SELECT 
														cad_representantes.nomerepre, 
														cad_representantes.idrepre
													FROM 
														cad_representantes
													WHERE 
														(cad_representantes.idmercado ILIKE '".$id_empresa."')
													ORDER BY 
														cad_representantes.nomerepre;";

									?>
                        Escolha o Representante............:
                        <select name="combo" id="chk1" disabled="true" style="width: 300px;">
						<?php echo(montaCombo($objConn,$strSQL,"idrepre","nomerepre",$id_evento)); ?>
                        </select>
                      </td>
                    </tr>
                    <td align="right" colspan="3" style="padding:10px 0px 10px 10px;"><button onClick="encaminha();">Imprimir</button>
                        <button onClick="parent.window.close();">Cancelar</button></td>
                    </tr>
                  </table></td>
              </tr>
            </form>
          </table>
        </div>
      </div></td>
  </tr>
</table>
</body>
</html>
