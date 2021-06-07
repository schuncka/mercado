<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
include_once("../_scripts/scripts.js");
include_once("../_scripts/STscripts.js");

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


function habilita(){
var x;  
for(x=0; x<document.formconf.doc.length; x++)
	
	{
		if(document.formconf.doc[x].checked){
			valor = document.formconf.doc[x].value;
			break;
		}		
	}

	if(valor == "2"){
					x = document.getElementById("td1"); 
					x.style.visibility = "visible";
					x = document.getElementById("td2"); 
					x.style.visibility = "visible";
					x = document.getElementById("td3"); 
					x.style.visibility = "visible";					

			} else {
					x = document.getElementById("td1"); 
					x.style.visibility = "hidden";
					x = document.getElementById("td2"); 
					x.style.visibility = "hidden";
					x = document.getElementById("td3"); 
					x.style.visibility = "hidden";				
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
	
	datawide_lang = '<?PHP echo $datawide_lang; ?>';

	
	<!-- Carta Senha -->
	if(valor == "1"){
	document.forms['formconf'].action = "STcartaSenhaInternetExpositorLote.php";
	document.forms['formconf'].submit();
	}
	
	
	<!-- Nota Débito Pedidos -->	
	if(valor == "3"){
		if(document.getElementById("datarel").value == ""){
			alert("Você não informou a data de Vencimento");
			document.forms['formconf'].datarel.focus();
			document.forms['formconf'].datarel.select();
		}else{				
			document.forms['formconf'].action = "STnota_de_debito_pedido_exe.php";
			document.forms['formconf'].submit();
		}
	}
	
	

	<!-- Carta Localização -->
	if(valor == "2"){
	valor=0;
	
	for(x=0; x<document.formconf.dok.length; x++){
	
		if(document.formconf.dok[x].checked){
			valor = document.formconf.dok[x].value;
			break;
		}
		
	}		
		
		if(valor == "1"){
			document.forms['formconf'].action = "STLocalizaçãodoEstandePedLote_ptb.php";
			document.forms['formconf'].submit();
		}
		if(valor == "2"){
			document.forms['formconf'].action = "STLocalizaçãodoEstandePedLote_en.php";
			document.forms['formconf'].submit();
		}
		if(valor == "3"){
			document.forms['formconf'].action = "STLocalizaçãodoEstandePedLote_es.php";
			document.forms['formconf'].submit();
		}					
	
	}
	

}	




function abrirJanela(){ 

	//parent.window.resizeTo(485,550); 
	
	var w = document.body.offsetWidth;
	var h = document.body.offsetHeight;

	parent.window.resizeTo(w-140, h+55);

} 


</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body style="margin:10px;" bgcolor="#CFCFCF" background="../img/bgFrame_imgVWHITE_main.jpg" onLoad="autoSubmit();abrirJanela();">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
  <tr>
    <td align="center" valign="top">
		<div id="DialogGlass" class="bordaBox" style="width:450; height:none;">
        <div class="b1"></div>
        <div class="b2"></div>
        <div class="b3"></div>
        <div class="b4"></div>
        <div class="center">
          <div id="Conteudo" class="conteudo" style="width:432;  height:none;">
            <div id="GlassHeader" class="header" style="background-color:#C9DCF5;width:432px;">
			<span style='margin-left:4px;'><?php echo(getTText("reslt",C_UCWORDS));?></span></div>
            <table border="0" width="100%" bgcolor="#FFFFFF" style="border:1px #A6A6A6 solid;">
              <form name="formconf" action="" method="post">
                <tr>
                  <td style="padding:10px;"><b><?php echo(getTText("cadcampos",C_UCWORDS));?></b></td>
                </tr>
                <tr>
                  <td align="center" valign="top">
				  	<table width="400" border="0">
                      <tr>
                        <td width="14%"><?php echo(getTText("vencimento",C_UCWORDS));?>: </td>
                        <td width="86%"><input type="text" id="datarel" name="datarel" OnKeyPress="formatar(this, '##/##/####')" maxlength="10" size="10">
                        </td>
                      <tr>
                      <tr>
                        <td width="14%"><?php echo(getTText("textoadic",C_UCWORDS));?>: </td>
                        <td width="86%"><textarea name="textoadic" rows="4" cols="70%"></textarea>
                        </td>
                      <tr>
                      <tr>
                        <td width="14%"><?php echo(getTText("prazoresp",C_UCWORDS));?>: </td>
                        <td width="86%"><input type="text" name="prazoresp" size="70%" >
                          </textarea>
                        </td>
                      <tr>
                      <tr>
                        <td width="14%"><?php echo(getTText("assinante",C_UCWORDS));?>: </td>
                        <td width="86%"><textarea name="assinatura" id="assinatura" rows="4" cols="70%"></textarea>
                        </td>
                      </tr>
                      <tr>
                        <td height="5" colspan="3"></td>
                      </tr>
                      <tr>
                        <td height="1" colspan="3" bgcolor="#DBDBDB"></td>
                      </tr>
                      <tr>
                        <td align="left" colspan="3">
						  <input type="radio" id="S" name="doc" value="1" onClick="habilita();" style="border:none; background:none;" /><b><?php echo(getTText("cartapass",C_UCWORDS));?></b> 						  
						</td>
					  </tr>
					  <tr> 	  
                        <td align="left" colspan="3">						  
						  <input type="radio" id="S" name="doc" value="3" onClick="habilita();" style="border:none; background:none;" /><b> <?php echo(getTText("notadebito",C_UCWORDS));?> </b> 						  
						</td>
					  </tr>
					  <tr>
					</table>
					<table  width="400" border="0">
					  <tr> 	  
                        <td width="148" align="left">						  
						  <input type="radio" id="S" name="doc" value="2" style="border:none; background:none;" onClick="habilita();" /><b> <?php echo(getTText("cartalocal",C_UCWORDS));?> </b> 						  
   					    </td>
                        <td width="75" id="td1" align="left" style="visibility:hidden">						  
						  <input type="radio" id="N" name="dok" value="1" checked="checked" style="border:none; background:none;" /><b><?php echo(getTText("ptb",C_UCWORDS));?></b> 						  
   					    </td>
                        <td width="61" id="td2" align="left" style="visibility:hidden">						  
						  <input type="radio" id="N" name="dok" value="2" style="border:none; background:none;" /><b><?php echo(getTText("en",C_UCWORDS));?></b> 						  
   					    </td>
                        <td width="98" id="td3" align="left" style="visibility:hidden">						  
						  <input type="radio" id="N" name="dok" value="3" style="border:none; background:none;" /><b><?php echo(getTText("es",C_UCWORDS));?></b> 						  
   					    </td>																		
						
					  </tr>
					 </table>
					 <table  width="400" border="0"> 						  						  
					  <tr> 	  
                        <td align="right" colspan="3" style="padding:0px 0px 10px 10px;">						  
						<button onClick="encaminha();">Ok</button>
						<button onClick="parent.window.close();">Cancelar</button>
						</td>
					  </tr>	
                    </table></td>
                </tr>
                <input type="hidden" name="var_strparam">
              </form>
            </table>
          </div>
        </div>
        <div class="b4"></div>
        <div class="b3"></div>
        <div class="b2"></div>
        <div class="b1"></div>
      </div></td>
  </tr>
</table>
</body>
</html>