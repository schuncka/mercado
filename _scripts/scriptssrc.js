/* 
 JavaScript Sources for KernelCS METRO - Biblioteca de funções (equivalente a antiga scrips.js) ---------- 
 --------------------------------------------------------------------------------------------------------- 
 Todas as funções JavaScript para sistemas de KerenlCS, para inclusão em padrão "script src", exemplo:
 <script src='scriptssrc.js'></script>
 Quando for inserir uma nova função aqui, observe as  categorias em que elas estão conforme os comentários 
 abaixo. Funções específicas de cada projeto e usadas em seus respectivos módulos devem estar na 
 STscripts.js ou com seus nomes e caracerpisticas próprias
 ------------------------------------------------------------------- revised for pVISTA by Aless 22/08/14 - 
 INI - ÍNDICE de funções ---------------------------------------------------------------------------------

 WRAPPERS
	AbreJanelaPAGE(prpage, prwidth, prheight) 
    AbreJanelaPAGE_NOVA(prpage, prwidth, prheight) 
    AbreJanelaIMG(primage, prwidth, prheight) 
	getObj(prIDElement)
	MM_swapImgRestore()
	MM_swapImage() 
	MM_findObj(n, d)
	AutoTab(current,to)
 LAYOUT
 	swapwidth(prDimMax,prTheme,prSystemName)
	resizeIframeParent(prIdFrame,prIntMargemHeight)
	reSizeiFrame(prFrameBody, prFrameID, prFlagX, prFlagY)
    ATHSetFocus (formulario, campo) // origem pvista
    displayAreaAR(prIDArea) //origem pvista
 VALIDAÇÃO
 	validateNumKey (prEvt)  // somenteNumero(e) é WRAPPER desta
	validateFloatKeyNew(objTextBox, e, negativo) 
	validateFloatKey()
	checkCNPJ(prCNPJ, prAviso)
	checkCPF(prCPF, prAviso)
	validaCep(prObject)
	validateRequestedFields(formID) 
    mailValidate(email,aviso) // origem pvista
    emailVerify(campo,aviso)  // origem pvista
    autentica()               // origom pvista
    verifica_formulario(CAMP) // origom pvista
    verifica_form_fone(VAR)   // origom pvista
 MASCARA/FORMATAÇÃO
 	FormataInputData(prObject,prBoolDiffYear) 
	FormataInputDataNew(prObject,prEvt)
	FormataInputHoraMinuto(prObject,prEvt)
    PrepExecASLW(prPagina, prFormCampo) //origom pvista
 DATA/HORA
	var dateDif = ... DateDiff: function(strDate1,strDate2)...  ...
	convertUTCDate(prUTCDate)
    calcular_idade(data) // origem pvista 
 MATEMATICAS/CONVERSÔES 
 	FloatToMoeda(prValue)
	MoedaToFloat(prValue)
	RoundNumber(prValor, prNumCasas)
 AJAX 
 	createAjax() 
	ajaxMontaCombo(prID, prDados) 
	ajaxMontaComboNotNull(prID, prDados)
    ajaxMontaEdit(prID, prDados) 
	ajaxDetailData(prSQL, prFuncao, prID, prFuncExtra)
	ajaxPreencheCamposTabela(prIDCombo, prIDMemo, prDados) 
	ajaxBuscaCamposTabela(prIDCombo, prIDMemo) 
	ajaxBuscaCEP(prIDCep,prIDLog,prIDBai,prIDCid,prIDUF,prIDNum,prIDREPLACE)
 EMULAÇÃO
	blurCombo(obj) 
	mouseDownCombo(obj)
	mouseUpCombo(obj)
    changeCombo(obj)
	EditaCampos(prChaveName,prChavereg,prTable,prField,prValue,prLocation,prCodResize)
 STRING
 	returnChar(prString)
    Trim(str)
 FIM - ÍNDICE de funções --------------------------------------------------------------------------------- 
*/
 
var winpopup		= null;
var winpopup_pvista = null;

/* -------------------------------------------------------------------------------------------------------------- */
/* INI - Funções WRAPPERS --------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */
/* Wrapper para window.open (by Aless) */
function AbreJanelaPAGE(prpage, prwidth, prheight){ 
	var auxstr;
	auxstr  = 'width=' + prwidth;
	auxstr  = auxstr + ',height=' + prheight;
	auxstr  = auxstr + ',top=30,left=30,scrollbars=1,resizable=yes,status=yes';

	if (winpopup_pvista != null) { winpopup_pvista.close(); }
	winpopup_pvista = window.open(prpage, 'winpopup_pvista', auxstr);
}


function AbreJanelaPAGE_NOVA(prpage, prwidth, prheight) 
{ 
  var auxstr;

  auxstr  = 'width=' + prwidth;
  auxstr  = auxstr + ',height=' + prheight;
  auxstr  = auxstr + ',top=30,left=30,scrollbars=yes,resizable=yes';

  if (winpopup_pvista != null) 
  {
    winpopup_pvista.close();
  }
  winpopup_pvista = window.open(prpage, 'METRO_PAGE_DETAIL', auxstr);
}

function AbreJanelaIMG(imgname, prwidth, prheight) 
{ 
  var strcode = 'viewimg.asp?img=' + imgname;
  var auxstr;

  auxstr  = 'width=' + prwidth;
  auxstr  = auxstr + ',height=' + prheight;
  auxstr  = auxstr + ',top=10,left=10,scrollbars=1,resizable=yes';

  if (winpopup != null) 
  {
    winpopup.close();
  }
  winpopup = window.open(strcode,'METRO_IMG_DETAIL', auxstr);
}


/* Wrapper para document.getElementById (by Aless/Leandro) */
function getObj(prIDElement){
	/* Exemplo de uso: getObj("iddoelemento"); */
	if(prIDElement == null || prIDElement == ""){ return null; } 
	else { return document.getElementById(prIDElement);	}
}


function MM_swapImgRestore() { var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc; } //v3.0

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; 
  document.MM_sr=new Array; 
  for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null) { document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src;  x.src=a[i+2]; }
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  
  if(!d) d=document; 
  if((p=n.indexOf("?"))>0&&parent.frames.length) { d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p); }
  if(!(x=d[n])&&d.all) x=d.all[n]; 
  for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function AutoTab(current,to){
	if (current.getAttribute && current.value.length==current.getAttribute("maxlength")) {
		to.focus() 
	}
}

/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - Funções WRAPPERS --------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */



/* -------------------------------------------------------------------------------------------------------------- */
/* INI - Funções LAYOUT ----------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */
function swapwidth(prDimMax,prTheme,prSystemName){
 var strMin     = 10;
 var strAtual   = ""; 
 var strColumns = self.parent.document.getElementById(prSystemName + "_principal");
 
 strAtual = strColumns.cols.substr(0,strColumns.cols.lastIndexOf(","));

 if(strAtual <= strMin){
	strColumns.cols = prDimMax + ",*";
	document.getElementById("img_collapse").src = "../img/collapse_open.gif";
    //window.parent.document.frames["proeventostudio_main"].document.body.background  = "../img/bgFrame_" + prTheme + "_main.jpg";
 }
 else{
	strColumns.cols =  strMin + ",*";
	document.getElementById("img_collapse").src = "../img/collapse_closed.gif";
	//window.parent.document.frames["proeventostudio_main"].document.body.background  = "../img/bgFrame_" + prTheme + "_collapsed.jpg";
 }
}

/* Atualiza o tamanho de um iframe (by Aless/Leandro 05/01/2010) */
/* Última alteração (by Aless/Clv 31/08/2012) */
function resizeIframeParent(prIdFrame,prIntMargemHeight) {
	/*
	 - usando livremente
	  você tem uma página com um iframe de nome ifrBanana e coloca dentro dele a página dialog.php
	  no final da página dialog.php deve coloca ro seguinte código, isso fara com que o ifrmae fique 
	  do tamanho necessário para conter o conteúdo da dialog.php
		...
		< / body >
		< script type="text/javascript">
	      resizeIframeParent('ifrBanana',20);
		< / script >
		< / html >
	 
	 - Usando para páginas que serão chamadas dentro do iframe de uma DATA.PHP
	   colocar esse código no final da página

		...
		< / body>
		< script type="text/javascript" >
	      resizeIframeParent('< ? php echo(CFG_SYSTEM_NAME); ? >_detailiframe_< ? php echo(request("var_chavereg")); ? >',20);
		< / script>
		< / html>

	 esta função realiza um resize em um Iframe [com base em seu id]
	 pai e seta o o tamanho deste Iframe para o tamanho do body atual */
	
	// se segundo param informado, então atribui adicional ao height da pagina
	var intAddHeight = prIntMargemHeight;

	// coleta o elemento 'pai' Iframe informado
	if (window.parent != null) {
		if (window.parent.document != null) {
			var objIframeParent = window.parent.document.getElementById(prIdFrame);
			if (objIframeParent!= null) {
				// seta o height do Iframe pai para 0, 
				// para logo em seguida setar novamente 
				// para o tamanho do body da página corrente
				objIframeParent.style.height = "0px";
				// agora seta o height do elemento pai
				// para o tamanho da página corrente
				objIframeParent.style.height = document.body.scrollHeight + intAddHeight + "px";
				//Precisa colocar "px" para que funcione no Chrome, senão ele ignora; no IE funciona com e sem "px"
			}
		}
	}
}

// -------------------------------------------------------------------------------
// Função que efetua o RESIZE de um iFRAME de acordo com o tamanho do seu conteúdo
// ------------------------------------------------------------------- by Aless -- 
function reSizeiFrame(prFrameBody, prFrameID, prFlagX, prFlagY)
{
 /* 
    ATENÇÃO - o parâmetro prFrameBody deve ser passado da seguinte forma: MEUIFRAME.document.body

	OBSERVAÇÂO:	até 04/11/11 função 
				- compatível com IExplorer, Safari e Chrome
				- não compatível com FireFox e Opera
 */
 var oFrame, oBody;
 try {	
		//oBody	 = iframe_chamados.document.body;
		//oFrame = document.all("iframe_chamados");

		oBody	= prFrameBody;
		oFrame	= window.document.all(prFrameID);
		if (prFlagX) {
			oFrame.style.width	= oBody.scrollWidth + (oBody.offsetWidth - oBody.clientWidth);
			oFrame.width		= oBody.scrollWidth + (oBody.offsetWidth - oBody.clientWidth);
		}

		if (prFlagY) {
			oFrame.style.height = oBody.scrollHeight + (oBody.offsetHeight - oBody.clientHeight);
			oFrame.height		= oBody.scrollHeight + (oBody.offsetHeight - oBody.clientHeight);
		}
	 }
	 catch(e) {	
		//An error is raised if the IFrame domain != its container's domain
	 	window.status =	'Error: ' + e.number + '; ' + e.description; 
		alert ('Error: ' + e.number + '; ' + e.description); 
	 }
}

// Seta o focus no elemento do e formulários passados
function ATHSetFocus (formulario, campo) {
  eval('document.' + formulario + '.' + campo + '.focus()');
  return false;
}

// Troca estado do Campo Visível ou Não Visível - by Mauro
function displayAreaAR(prIDArea){
	var objIDArea = prIDArea;
	if(objIDArea != null){
		if(document.getElementById(objIDArea).style.display == 'none'){
			document.getElementById(objIDArea).style.display = 'block';
			// Calcula tamanho do Frame para não gerar Scroll
			parent.iframeAutoHeight(parent.document.getElementById('Conteudo'));
		}else{
			document.getElementById(objIDArea).style.display = 'none';
		}
	}
}
/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - Funções LAYOUT ----------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */



/* -------------------------------------------------------------------------------------------------------------- */
/* INI - Funções VALIDAÇÃO -------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */
function validateNumKey (prEvt){ 
	var inputKey = window.event ? prEvt.keyCode : prEvt.which;
	//var inputKey = event.keyCode;

	if ( inputKey > 47 && inputKey < 58 || inputKey == 32 || inputKey == 13 || inputKey == 8){ // numbers
	  	prEvt.returnValue = true;
	    return true;
	} else {
		if (navigator.appVersion.indexOf("MSIE")!=-1) { prEvt.cancelBubble = true; prEvt.returnValue = false; return false; } 
		else { prEvt.stopPropagation(); return false; }
	}
}


function somenteNumero(e){
    /* 
	Mantida por compatibilidade e funcionando como Wrapper da validateNumKey, 
	pois o cpidigo antigo desta função esta obsoleto abaixo  */
    validateNumKey(e)

	/*
	var tecla=(window.event)?event.keyCode:e.which;
    if((tecla > 47 && tecla < 58)) return true;
    else{
    if (tecla != 8) return false;
    else return true;
    }
	*/
}

/* Efetua a validação na digitaçãod e valores Float (by Aless) 
   Caso altere essa função revisar as seguintes funções na STscripts.js
   validateFloatKey6CD
   validateFloatKey4CD
   validateFloatKey3CD BY gs/clv 09/06/2011
*/
function validateFloatKeyNew(objTextBox, e, negativo) {
	/*Exemplos de uso

	
	<input type="text" dir="rtl" onkeypress="return validateFloatKeyNew(this, event);" />
	<input type="text" dir="rtl" onkeypress="return validateFloatKeyNew(this, event,'yes');" /> */
	var sep = 0;
    var key = '';
    var i = j = 0;
    var len = len2 = 0;
    var strCheck = '0123456789';
    var aux = aux2 = '';
	var SeparadorMilesimo = '.';
	var SeparadorDecimal  = ',';
	var SinalNegativo 	  = '';
	var auxVlrFinal       = ''
    var whichCode;

	if (typeof negativo == "undefined") { negativo = "NO";  }

    //whichCode = (window.Event) ? e.which : e.keyCode;  // Assim não funiona com o DOCTYPE
	if (!e) { var e=window.event; }  //Assim funciona :-)
	if (e.keyCode) { whichCode=e.keyCode; } else if (e.which) { whichCode=e.which; } //Assim funciona :-)

    // 13=enter, 8=backspace, 45=hífen(-) as demais retornam 0(zero)
    // whichCode==0 faz com que seja possivel usar todas as teclas como delete, setas, etc    
    if ((whichCode == 0) || (whichCode == 13) || (whichCode == 8) ) { return true; }
    //Permitir Negativos 
	if ( ( negativo.toLowerCase()=='sim') || (negativo.toLowerCase()=='yes') || (negativo.toLowerCase()=='true') ){
		if (whichCode == 45) { 
		 SinalNegativo = '-';
		 if (objTextBox.value.indexOf(SinalNegativo) == -1) { return true; } else { return false; }
		}
	}

    key = String.fromCharCode(whichCode); // Valor para o código da Chave
    if (strCheck.indexOf(key) == -1) { return false; } // Chave inválida

    len = objTextBox.value.length;
    for(i = 0; i < len; i++) { if ((objTextBox.value.charAt(i) != '0') && (objTextBox.value.charAt(i) != SeparadorDecimal) ) { break; } }			

    aux = '';
    for(; i < len; i++) { if ( (strCheck.indexOf(objTextBox.value.charAt(i))!=-1) ) { aux += objTextBox.value.charAt(i); } }

    aux += key;
    len = aux.length;
    if (objTextBox.value.indexOf("-") != -1) { SinalNegativo = '-'; }
    if (len == 0) {	auxVlrFinal = ''; }
    if (len == 1) {	auxVlrFinal = '0'+ SeparadorDecimal + '0' + aux }
    if (len == 2) {	auxVlrFinal = '0'+ SeparadorDecimal + aux }
    if (len > 2)  {
        aux2 = '';
        for (j = 0, i = len - 3; i >= 0; i--) {
            if (j == 3) { aux2 += SeparadorMilesimo; j = 0; }
            aux2 += aux.charAt(i);
            j++;
        }
		auxVlrFinal = '';
        len2 = aux2.length;
        for (i=len2 - 1; i >= 0; i--) { auxVlrFinal += aux2.charAt(i); }
        auxVlrFinal += SeparadorDecimal + aux.substr(len - 2, len);
    }
	objTextBox.value = '';

    //Obs.: O certo seria usar essa funão com o DIR do INPUT setado para RTL, mas como nem sempre isso é possível
	//tento fazer aqui a correção da posição do sinal, no caso de números negatidos e do DIR não estar como RTL.
    if (objTextBox.dir.toLowerCase() == 'rtl') { objTextBox.value = auxVlrFinal + SinalNegativo; }
	else 
	  { objTextBox.value = SinalNegativo + auxVlrFinal;
	    //objTextBox.value = objTextBox.value.replace("-.", "-0.");
	    objTextBox.value = objTextBox.value.replace("-00", "-");
	    objTextBox.value = objTextBox.value.replace("-0.0","-");  }
	
    return false;
}


function validateFloatKey() {
	var inputKey = event.keyCode;
	var returnCode = true;
	var inputValue = event.srcElement.value

	if(inputKey ==44 && inputValue.indexOf(',') != -1) { returnCode = false; event.keyCode = 0;}
	else {
		if((inputKey>47 && inputKey<58) || inputKey==44 ) { /* 0..9 (números); .  (vírgula); */ return; }
		else { returnCode = false; event.keyCode = 0; }
	}
	event.returnValue = returnCode;
}

/* Funções de validação de CPF e CNPJ */
function checkCNPJ(prCNPJ, prAviso){
	var varFirstChr = prCNPJ.charAt(0);
	var vlMult,vlControle,s1,s2 = "";
	var i,j,vlDgito,vlSoma = 0;
	var vaCharCNPJ = false;
	var retorno = true;
	
	if (prCNPJ != "") {
		for ( var i=0; i<=13; i++ ) {
		  var c = prCNPJ.charAt(i);
		  if( ! (c>="0")&&(c<="9") ) { retorno = false; }
		  if( c!=varFirstChr ) { vaCharCNPJ = true; }
		}
		if( ! vaCharCNPJ ) { retorno = false; }
		
		if (retorno) {
			s1 = prCNPJ.substring(0,12);
			s2 = prCNPJ.substring(12,15);
			vlMult = "543298765432";
			vlControle = "";
			for ( j=1; j<3; j++ ) {
			  vlSoma = 0;
			  for ( i=0; i<12; i++ ) { vlSoma += eval( s1.charAt(i) )* eval( vlMult.charAt(i) ); }
			  if( j == 2 ){ vlSoma += (2 * vlDgito); }
			  vlDgito = ((vlSoma*10) % 11);
			  if( vlDgito == 10 ){ vlDgito = 0; }
			  vlControle = vlControle + vlDgito;
			  vlMult = "654329876543";
			}
			if( vlControle != s2 ) retorno = false;
		}
		if (!retorno) { if (prAviso) alert("CNPJ Inválido"); }
	}
	else retorno = false;
	return retorno;
}

function checkCPF(prCPF, prAviso) {
	if(prCPF != ""){
		var auxBoolean = false;
		var strChars   = "";
		for(auxCounter = 0; auxCounter < prCPF.length; auxCounter++){
			if(auxCounter > 0){
				strChars = prCPF.charAt([auxCounter]-1);
				if(strChars != prCPF.charAt([auxCounter])){
					auxBoolean = true;
				}
			} else{
				strChars = prCPF.charAt([auxCounter]);
			}
			//alert(prCPF.charAt([auxCounter]));
		}
		if(!auxBoolean) { if(prAviso){ alert("CPF Inválido"); } return(false); }
		
		var x = 0;
		var soma = 0;
		var dig1 = 0;
		var dig2 = 0;
		var texto = "";
		var strCPFaux = "";
		var len = prCPF.length;
		var strAux1, strAux2;
		
   	    if (len < 11) {	if (prAviso) alert("CPF Inválido"); return false; }
		
		strAux1 = prCPF.substring(0, 3);
		strAux2 = prCPF.substring(8, 11);
		
		//Se começa e termina com 999 é porque é um CPF de estrangeiro
		if ((strAux1 == "999") && (strAux2 == "999")) {	return true; }
		else {
			x = len -1;
			
			for (var i=0; i <= len - 3; i++) {
				y = prCPF.substring(i,i+1);
				soma = soma + ( y * x);
				x = x - 1;
				texto = texto + y;
			}
			
			dig1 = 11 - (soma % 11);
			if (dig1 == 10) dig1=0 ;
			if (dig1 == 11) dig1=0 ;
			strCPFaux = prCPF.substring(0,len - 2) + dig1 ;	
			x = 11; soma=0;
			
			for (var i=0; i <= len - 2; i++) { soma = soma + (strCPFaux.substring(i,i+1) * x); x = x - 1; }
			
			dig2 = 11 - (soma % 11);
			if (dig2 == 10) dig2=0;
			if (dig2 == 11) dig2=0;
			if ((dig1 + "" + dig2) == prCPF.substring(len,len-2)) { return true; }
			else { if (prAviso) alert("CPF Inválido"); return false; }
		}
	}	
	else return false;
}

/* Preenchimento automático de campos quando CEP é digitado (by Leandro) */
function validaCep(prObject) {
	// Formata o número de CEP no momento que é digitado
	var currValue; 
	currValue = prObject.value;
    //arrValue = currValue.split ("-").join("");
	//inputKey = event.KeyCode;
	//if (inputKey!=8 && inputKey!=127 && inputKey!=39 && inputKey!=37 && inputKey!=46) {
	if(currValue.length == 5){
		prObject.value = prObject.value+"-";
	}
}

/* Valida campos marcados no ID com "ô". (by Aless) */
function validateRequestedFields(formID) {
	//Função utilizada pelo Kernel. Lembrando que os formulários do kernel setam NAME e ID dos elementos. 
	//Também marca em amarelo os campos obrigatórios não preenchidos
	var flagOk = true;
	var elementos = document.getElementById(formID).elements;
			
	for (var i=0; i< elementos.length; i++) {  
		if ((elementos[i].id.indexOf("ô")!=-1) && (elementos[i].disabled == false)) {
			if (elementos[i].value=="") { 
				elementos[i].style.backgroundColor="#FFFFCC";
				//elementos[i].style.borderColor="#FF0000";
				flagOk = false;    
			}
			else { elementos[i].style.backgroundColor="#FFFFFF"; }	
		} 
	} 
	if (flagOk==false) { alert("Favor preencher os campos obrigatórios."); }    
	return flagOk; 
}


function mailValidate(email,aviso){
  strMail = email;
  var re = new RegExp;
  var strMensagem = 'Informe um e-mail válido.';
  if ((aviso != '')&&(aviso != undefined)) {
    strMensagem = aviso;
  }
  re = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  var arr = re.exec(strMail);
  if ((arr == null)&&(strMail!="")) {
    alert(strMensagem );
	return(false);
  }
  else {
	return(true);
  }
}

function emailVerify(campo,aviso){
  strMail = campo.value;
  var re = new RegExp;
  var strMensagem = 'Informe um e-mail válido.';
  if ((aviso != '')&&(aviso != undefined)) {
    strMensagem = aviso;
  }
  re = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  var arr = re.exec(strMail);
  if ((arr == null)&&(strMail!="")) {
    alert(strMensagem );
	campo.value = '';
	return(false);
  }
  else {
	return(true);
  }
}


function autentica() { 
  if (verifica_formulario(document.form.tipopergunta.value) == false) {  
     alert("É obrigatório selecionar um tipo de pergunta!");
     return false;
  }
   
  if (verifica_formulario(document.form.nome.value) == false) {  
     alert("É obrigatório o preenchimento do Nome!");
     return false;
  }
  
  if (verifica_formulario(document.form.email.value) == false) {  
     alert("É obrigatório o preenchimento do E-mail!");
     return false;
  }
  
  if (verifica_formulario(document.form.mensagem.value) == false) {  
     alert("É obrigatório o preenchimento da mensagem!");
     return false;
  }
}


function verifica_formulario(CAMP) {
  if (CAMP.length < 1) { return false; } else { return true; }
} 

function verifica_form_fone(VAR) {
  if (VAR.length < 1) { return false; } else { return true; }
}


/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - Funções VALIDAÇÃO -------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */



/* -------------------------------------------------------------------------------------------------------------- */
/* INI - Funções MASCARA/FORMATAÇÃO ----------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */
/* Faz formatação de input de Datas (by Clv - 27/02/2009) */
function FormataInputData(prObject,prBoolDiffYear) {
var currValue, arrValue, inputKey;
	currValue = prObject.value;
	arrValue = currValue.split ("/").join("");
	inputKey = event.keyCode;
	
	if (inputKey!=8 && inputKey!=127 && inputKey!=39 && inputKey!=37 && inputKey!=46) {
		if (arrValue.length>3){
			if (arrValue.substr(2,2)<13){
				strAno = arrValue.substr(4);
				if(prBoolDiffYear != null && !isNaN(prBoolDiffYear)){
					if(arrValue.substr(4).length == 4){
						strAnoAtual = new Date();
						strAnoAtual = strAnoAtual.getFullYear()
						if((strAno >= strAnoAtual+prBoolDiffYear) || (strAno <= strAnoAtual-prBoolDiffYear)) { strAno = strAnoAtual	}
					}
				}
				prObject.value = arrValue.substr(0,2) + '/' + arrValue.substr(2,2) + '/' + strAno;
			} else {
				strAno = arrValue.substr(4);
				if(prBoolDiffYear != null && !isNaN(prBoolDiffYear)){
					if(arrValue.substr(4).length == 4){
						strAnoAtual = new Date();
						strAnoAtual = strAnoAtual.getFullYear()
						if((strAno >= strAnoAtual+prBoolDiffYear) || (strAno <= strAnoAtual-prBoolDiffYear)) { strAno = strAnoAtual }
					}
				}
				prObject.value = arrValue.substr(0,2) + '/12/' + strAno;
			}
		} else if (arrValue.length>1){
			if (arrValue.substr(0,2)<32){
				prObject.value = arrValue.substr(0,2) + '/' + arrValue.substr(2)
			} else {
				prObject.value = '31/' + arrValue.substr(2);
			}
		}
	}
}

/* Formata uma data em um input aceitando o formato inicial 'português' para datas (DD/MM/AAAA). Para TODOS NAVEGADORES.. (by Leandro) */
function FormataInputDataNew(prObject,prEvt){
    /* Exemplo de uso: <input type="text" name="var_data" size="12" maxlength="10" onkeypress="return FormataInputDataNew(this,event);" /> */
	var currValue, arrValue, inputKey;
	
	currValue = prObject.value;
	arrValue  = currValue.split ("/").join("");
	inputKey  = window.event ? prEvt.keyCode : prEvt.which;
	// var inputKey = event.keyCode;
	
	// TESTA NÚMEROS
	// alert(inputKey);
	if(inputKey > 45 && inputKey < 58 && inputKey != 32 || inputKey == 13 || inputKey == 8 || inputKey == 0){ // NUMBERS + '/'
		if(inputKey != 127 && inputKey != 39 && inputKey != 37 && inputKey != 46 && inputKey != 45|| inputKey == 8 || inputKey == 0){
			// alert(arrValue.length);
			// TESTE PARA NAO PODER INSERIR SEQUENCIA DE '/'
			if((arrValue.length == 0 || arrValue.length == 1 || arrValue.length == 3 || arrValue.length == 4 || arrValue.length == 6 || arrValue.length == 7 || arrValue.length == 8 || arrValue.length == 09) && inputKey == 47){
				return(false);
			} else{
				// TESTES PARA MESES MAIORES QUE 12
				if(arrValue.length > 3 && inputKey != 8 && inputKey != 0){
					if(arrValue.substr(2,2) < 13){
						prObject.value = arrValue.substr(0,2) + '/' + arrValue.substr(2,2) + '/' + arrValue.substr(4);
					} else{
						prObject.value = arrValue.substr(0,2) + '/12/' + arrValue.substr(4);
					}
				} else{ 
					// TESTE PARA DIAS MAIORES QUE 31
					if(arrValue.length > 1 && inputKey != 8 && inputKey != 0){
						if(arrValue.substr(0,2) < 32){
							prObject.value = arrValue.substr(0,2) + '/' + arrValue.substr(2)
						} else{
							prObject.value = '31/' + arrValue.substr(2);
						}
					}
				}
			}
		}
		prEvt.returnValue = true;
		return true;
	} else{
		// CASO NÃO SEJA UM NÚMERO OU CARACTER VÁLIDO
		if(navigator.appVersion.indexOf("MSIE") != -1){ 
			prEvt.cancelBubble = true;
			prEvt.returnValue = false;
			return false;
		} else{
			prEvt.stopPropagation();
			return false;
		}
	}
}

function FormataInputHoraMinuto(prObject,prEvt){
	var a = prObject.value.split(":").join("");
	var inputKey  = window.event ? prEvt.keyCode : prEvt.which;
	//var inputKey = event.keyCode;

	if((inputKey>=48 && inputKey<=57) || (inputKey>=95 && inputKey<=105) && a.length < 4){ // Verifica se é um número ou se estrapolou o número de caracteres permitidos
		if(prObject.value.indexOf(":") != 0 && prObject.value.indexOf(":") != 1){ // Flag para permitir a edição das horas
			if(a.length > 2) {
				if(a.substr(2,2) < 6){
					prObject.value = a.substr(0,2) + ":" + a.substr(2,2);
				} else {
					prEvt.cancelBubble = true;
					prEvt.returnValue = false;
					prObject.value = a.substr(0,2) + ":00";
					return false;
				}
			} else if(a.length > 1) {
				prObject.value = a.substr(0,2) + ":";
			}
		}
	}
	else if(inputKey!=8 && inputKey!=127 && inputKey!=39 && inputKey!=37 && inputKey!=34 && inputKey!=16 && inputKey!=46 && a.length >= 4){
		prEvt.cancelBubble = true;
		prEvt.returnValue = false;
		return false;
	}
}


function PrepExecASLW(prPagina, prFormCampo) {
	var rExp1, rExp2, myStrSQL = prFormCampo.value;

	//alert(myStrSQL);
	
	rExp1 = /#/g;
	rExp2 = /%/g;

	myStrSQL = myStrSQL.replace(rExp1,'<ASLW_SHARP>');
	myStrSQL = myStrSQL.replace(rExp2,'<ASLW_PERCENT>');
	rExp1 = /\n/g;
	rExp2 = /\r/g;

	myStrSQL = myStrSQL.replace(rExp1,' ');
	myStrSQL = myStrSQL.replace(rExp2,' ');
	//alert(myStrSQL);
	//alert('ExecASLW.asp?var_strParam=' + myStrSQL);

	//AbreJanelaPAGE_NOVA(prPagina, 'ExecASLW.asp?var_strParam=' + myStrSQL, '680', '460');
	AbreJanelaPAGE_NOVA('ExecASLW.asp?var_strParam=' + myStrSQL, '680', '460');
}

/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - Funções MASCARA/FORMATAÇÃO --------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */



/* -------------------------------------------------------------------------------------------------------------- */
/* INI - DATA/HORA ---------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */

/* Calcula a diferença em dias entre duas dastas. Formato de entrada mm/dd/aaaa (by Aless) */
var dateDif = { 
	dateDiff: function(strDate1,strDate2) 
				{
				 return (((Date.parse(strDate2))-(Date.parse(strDate1)))/(24*60*60*1000)).toFixed(0);
			 	}
}

/* Converte uma data em formato UTC para UNIX , aaaa-mm-dd HH:mm:ss (by Leandro) */

function convertUTCDate(prUTCDate){
	// Usada pelo Objeto DATASCHEDULER - AGENDA [MODULO]
	// extrai data, mes, ano, hora, dia, segundos e minutos
	var strDate = prUTCDate;
	var strDay  = strDate.getDate();
	var strMon  = strDate.getMonth()+1;
	var strYea  = strDate.getFullYear();
	var strHou  = strDate.getHours();
	var strMin  = strDate.getMinutes();
	var strSec  = strDate.getSeconds();
	
	// concatena zero caso o valor seja
	// menor que 10, para nao 2009-1-1
	if (strMon < 10){strMon = "0" + strMon;}
	if (strDay < 10){strDay = "0" + strDay;}
	if (strMin < 10){strMin = "0" + strMin;}
	if (strHou < 10){strHou = "0" + strHou;}
	if (strSec < 10){strSec = "0" + strSec;}
	strDate = strYea + "-" + strMon + "-" + strDay + " " + strHou + ":" + strMin + ":" + strSec;
	
	// retorno
	return(strDate);
}

//calcular a idade de uma pessoa 
//recebe a data como um string em formato portugues 
//devolve um inteiro com a idade. Devolve false em caso de que a data seja incorreta ou maior que o dia atual
function calcular_idade(data){ 
    //calculo a data de hoje 
    var hoje=new Date();
    //alert(hoje) 

    //calculo a data que recebo 
    //descomponho a data em um array 
    var array_data = data.split("/") 
    //se o array nao tem tres partes, a data eh incorreta 
    if (array_data.length!=3) { return false; }

    //comprovo que o ano, mes, dia são corretos 
    var ano;
    ano = parseInt(array_data[2]); 
    if (isNaN(ano)) { return false; }

    var mes;
    mes = parseInt(array_data[1]); 
    if (isNaN(mes)) { return false; }

    var dia;
    dia = parseInt(array_data[0]); 
    if (isNaN(dia)) { return false; }

    //se o ano da data que recebo so tem 2 cifras temos que muda-lo a 4 
    if (ano<=99) { ano +=1900; }

    //subtraio os anos das duas datas 
    var idade=hoje.getFullYear() - ano - 1; //-1 porque ainda nao fez anos durante este ano
 
    //se subtraio os meses e for menor que 0 entao nao cumpriu anos. Se for maior sim ja cumpriu
    if (hoje.getMonth() + 1 - mes < 0) { return idade; } //+ 1 porque os meses comecam em 0 

    if (hoje.getMonth() + 1 - mes > 0) { return idade+1; }

    //entao eh porque sao iguais. Vejo os dias 
    //se subtraio os dias e der menor que 0 entao nao cumpriu anos. Se der maior ou igual sim que já cumpriu
    if (hoje.getUTCDate() - dia >= 0) { return idade + 1; }

    return idade;
} 

/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - DATA/HORA ---------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */



/* -------------------------------------------------------------------------------------------------------------- */
/* INI - MATEMATICAS/CONVERSÔES --------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */
/* Recebe float/double no formato 1000000.00 e retorna STRING no formato 1.000.000,00 (by Aless/Aloisio) */
function FloatToMoeda(prValue) {
var myFloat, Moeda=prValue, StrAux="", i, j , ParteInt, ParteDec, arrAux;

    Moeda = String(prValue);
    if(Moeda.indexOf('.')>0) { 
      Moeda    = Moeda.split(".");
	  ParteInt = String(Moeda[0]);
      ParteDec = String(Moeda[1]);
	  if ( (parseInt(ParteDec)<10) && (Moeda[1].length == 1) ) { ParteDec = String(ParteDec) + "0" ; }
	}
	else { 
	  ParteInt = Moeda;
	  ParteDec = "00"; 
	  Moeda    = Moeda.split(".");
	}

    j = 1;
    i = Moeda[0].length-1;
	while (i>=0) {
	 //alert(StrAux + "  [" + (i % 3) + "]");
	 StrAux = StrAux + ParteInt.substr(i,1);
	 if ( (j==3) && (i>=1)) { StrAux = StrAux + "."; j=0; } 
	 i--; j++;
	};

    arrAux = StrAux.split("");
	arrAux.reverse();
	StrAux = arrAux.join("")

    myFloat = StrAux + "," + ParteDec; 
	return myFloat; 
}

/* Recebe COMO STRING no formato 1.000.000,00 e retorna float/double 1000000.00 (by Aless/Aloisio) */
function MoedaToFloat(prValue) {
   var myFloat="", Moeda=prValue ,i=0;

	//Moeda = toString(prValue);
	Moeda = String(prValue);
    while(Moeda.indexOf(',')>0) Moeda = Moeda.replace(',','.');

    if(Moeda.indexOf('.')>0){
		Moeda = Moeda.split('.');
		for(i=0;i<Moeda.length-1;i++){
			myFloat += Moeda[i];	
		}
		myFloat+= '.' + Moeda[Moeda.length-1];	
	}
	else { myFloat = Moeda + '.00'; }
  
  return parseFloat(myFloat);	
}

function RoundNumber(prValor, prNumCasas) {
	var newnumber;
	
	newnumber = (Math.round(prValor * Math.pow(10, prNumCasas))) / Math.pow(10, prNumCasas);
	return newnumber;
}
/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - MATEMATICAS/CONVERSÔES --------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */



/* -------------------------------------------------------------------------------------------------------------- */
/* INI - Funções AJAX ------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */
function createAjax() {
var xmlHttp=null;
 try { xmlHttp=new XMLHttpRequest(); } // Firefox, Opera 8.0+, Safari 
 catch (e) {
   try // Internet Explorer
    { xmlHttp=new ActiveXObject("Msxml2.XMLHTTP"); }
   catch (e) { xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");  }
  }
 return xmlHttp;
}

function ajaxMontaCombo(prID, prDados) {
	var Item1, Item2;
	var arrAux1 = null;
	var arrAux2 = null;
	var obj = document.getElementById(prID);
	var verificaErro = prDados.substr(0,6);

	//Limpa o objeto (combo) antes de adicionar os itens
	while (obj.options.length > 0) { obj.options[0] = null; }

	
	//alert (prID + " - " + prDados);
	//prDados = prDados.slice(0, prDados.length-1);
	arrAux1 = prDados.split("\n");
	
	// Cria uma opção em branco
	var optionBlank = document.createElement('option');
	obj.appendChild(optionBlank);
	
	//isto é quando da erro de sql ele nao popular combo com varios 'undefined'
	//if(verificaErro != '<html>'){
	if(prDados.length > 1) {
		for (Item1 in arrAux1) {
			Item2 = arrAux1[Item1];
			arrAux2 = Item2.split("|");
			
			var optionNew = document.createElement('option');
			optionNew.setAttribute('value',arrAux2[0]);
			var textOption =  document.createTextNode(arrAux2[1]);
			optionNew.appendChild(textOption);
			obj.appendChild(optionNew);
			
			//obj.add( new Option(caption,value) );
			//obj.add( new Option(arrAux2[1],arrAux2[0]) );
		}
	}
}


function ajaxMontaComboNotNull(prID, prDados) {
	// OBS: A diferença básica entre esta função
	// ea função montaCombo Normal é a geração
	// de um option nulo
	var Item1, Item2;
	var arrAux1 = null;
	var arrAux2 = null;
	var obj = document.getElementById(prID);
	var verificaErro = prDados.substr(0,6);

	//Limpa o objeto (combo) antes de adicionar os itens
	while (obj.options.length > 0) { obj.options[0] = null; }
	
	//alert (prID + " - " + prDados);
	//prDados = prDados.slice(0, prDados.length-1);
	arrAux1 = prDados.split("\n");
	
	// Cria uma opção em branco
	// var optionBlank = document.createElement('option');
	// obj.appendChild(optionBlank);
	
	//isto é quando da erro de sql ele nao popular combo com varios 'undefined'
	//if(verificaErro != '<html>'){
	if(prDados.length > 1) {
		for (Item1 in arrAux1) {
			Item2 = arrAux1[Item1];
			arrAux2 = Item2.split("|");
			
			var optionNew = document.createElement('option');
			optionNew.setAttribute('value',arrAux2[0]);
			var textOption =  document.createTextNode(arrAux2[1]);
			optionNew.appendChild(textOption);
			obj.appendChild(optionNew);
			
			//obj.add( new Option(caption,value) );
			//obj.add( new Option(arrAux2[1],arrAux2[0]) );
		}
	}
}

function ajaxMontaEdit(prID, prDados) {
	var Item1, Item2;
	var arrAux1 = null;
	var arrAux2 = null;
	var obj = document.getElementById(prID);
	var verificaErro = prDados.substr(0,6);
	
	//Limpa o objeto (edit) antes de colocar valor
	obj.value = '';
	
	if(prDados.length > 1) {
		arrAux1 = prDados.split("\n");
		for (Item1 in arrAux1) {
			Item2 = arrAux1[Item1];
			arrAux2 = Item2.split("|");
			obj.value = arrAux2[0];
		}
	}
}

function ajaxDetailData(prSQL, prFuncao, prID, prFuncExtra) {
	var objAjax;
	var strReturnValue;
	
	objAjax = createAjax();
	
	objAjax.onreadystatechange = function() {
		if(objAjax.readyState == 4) {
			if(objAjax.status == 200) {
				strReturnValue = objAjax.responseText.replace(/^\s*|\s*$/,"");
				switch (prFuncao) {
					case "ajaxMontaCombo":		  ajaxMontaCombo(prID, strReturnValue); if(prFuncExtra != '') eval(prFuncExtra); break;
					case "ajaxMontaComboNotNull": ajaxMontaComboNotNull(prID, strReturnValue); if(prFuncExtra != '') eval(prFuncExtra); break;
					case "ajaxMontaEdit":		  ajaxMontaEdit(prID, strReturnValue); if(prFuncExtra != '') eval(prFuncExtra); break;
				}
			} else {
				alert("Erro no processamento da página: " + objAjax.status + "\n\n" + objAjax.responseText);
			}
		}
	}
	objAjax.open("GET", "../_ajax/returndados.php?var_sql=" + prSQL,  true); 
	objAjax.send(null); 
}

function ajaxPreencheCamposTabela(prIDCombo, prIDMemo, prDados) {
	var Item;
	var arrDados = null;
	var obj1 = document.getElementById(prIDCombo);
	var obj2 = document.getElementById(prIDMemo);
	
	obj2.value = '';
	
	prDados = prDados.slice(0, prDados.length);
	arrDados = prDados.split("\n");
	
	for (Item in arrDados) { 
		if (obj2.value == '')
			obj2.value = 'SELECT ' + arrDados[Item]; 
		else 
			obj2.value += ', ' + arrDados[Item]; 
	}
	if (obj2.value != '') obj2.value += ' FROM ' + obj1.value;
}

function ajaxBuscaCamposTabela(prIDCombo, prIDMemo) {
	var objAjax;
	var obj = document.getElementById(prIDCombo);
	
	objAjax = createAjax();
	
	objAjax.onreadystatechange = function() {
		if(objAjax.readyState == 4) {
			if(objAjax.status == 200) {
				ajaxPreencheCamposTabela(prIDCombo, prIDMemo, objAjax.responseText);
			} else {
				alert("Erro no processamento da página: " + objAjax.status + "\n\n" + objAjax.responseText);
			}
		}
	}
	objAjax.open("GET", "../_ajax/returnfieldstable.php?var_table=" + obj.value, true); 
	objAjax.send(null); 
}

function ajaxBuscaCEP(prIDCep,prIDLog,prIDBai,prIDCid,prIDUF,prIDNum,prIDREPLACE){
	// Esta Função busca um cep através do ID de um campo CEP informado
	// e efetua busca de CEP ou em nossa base de dados TRADEUNION ou di-
	// retamente no site republicavirtual.com, que disponibiliza uma ba-
	// se de ceps atualizada de ENDEREÇOS. OBS: TODOS PARÂMETROS DEVEM
	// SER ENCAMINHADOS APENAS O ID DO CAMPO. O CAMPO de prIDNumero É O
	// QUE RECEBERÁ O FOCUS POSTERIORMENTE.
	var objCep, objLog, objBai, objCid, objEst, objNum, objAjax;
	var strReturn, arrReturn;
	// Cria os elementos para manipulação posterior
	objCep = document.getElementById(prIDCep);
	objLog = document.getElementById(prIDLog);
	objBai = document.getElementById(prIDBai);
	objCid = document.getElementById(prIDCid);
	objEst = document.getElementById(prIDUF);
	objNum = document.getElementById(prIDNum);
	objRep = document.getElementById(prIDREPLACE);
	// Testa se algum está vazio, anti-erros
	if(objCep == null || objLog == null || objBai == null || objCid == null || objEst == null || objNum == null || objCep.value == null || objCep.value == "") { return(null); }
	// LIMPEZA DOS VALORES DOS CAMPOS DE ENDEREÇO
	objLog.value = "";
	objNum.value = "";
	objBai.value = "";
	objCid.value = "";
	objEst.value = "";
	// Até aqui, campos garantidos que existem, not null
	// CRIA OBJETO AJAX
	objAjax = createAjax();
	// Caso ID de replace tenha sido informada, então tro-
	// ca o seu innerHTML por um loader, para melhor UI
	if(objRep != null){ objRep.innerHTML = "<img src='../img/icon_ajax_loader.gif' border='0' width='12' />"; }
	objAjax.onreadystatechange = function() {
		if(objAjax.readyState == 4) {
			if(objAjax.status == 200) {
				// alert(objAjax.responseText);
				// Quebra a STRING DE RETORNO, no formato
				// CSV e testa se é um logradouro único,
				// inexistente ou LOGRADOURO COMPLETO

				arrReturn = objAjax.responseText.split("<br>");
				
				// Caso LOGRADOURO ÚNICO
				if(arrReturn[0] == "2"){
					// Breve Tratamento para Campos
					arrReturn[1] = (arrReturn[1] == null) ? "" : arrReturn[1]; //CIDADE
					arrReturn[2] = (arrReturn[2] == null) ? "" : arrReturn[2]; //ESTADO
					objCid.value = arrReturn[1];
					objEst.value = arrReturn[2];
				}
				// CASO LOGRADOURO COMPLETO
				if(arrReturn[0] == "1"){
					// Breve Tratamento para Campos
					arrReturn[1] = (arrReturn[1] == null) ? "" : arrReturn[1]; //TIPO DE LOGRADOURO
					arrReturn[2] = (arrReturn[2] == null) ? "" : arrReturn[2]; //LOGRADOURO
					arrReturn[3] = (arrReturn[3] == null) ? "" : arrReturn[3]; //BAIRRO
					arrReturn[4] = (arrReturn[4] == null) ? "" : arrReturn[4]; //CIDADE
					arrReturn[5] = (arrReturn[5] == null) ? "" : arrReturn[5]; //ESTADO
					objLog.value = arrReturn[1]+" "+arrReturn[2];
					objBai.value = arrReturn[3];
					objCid.value = arrReturn[4];
					objEst.value = arrReturn[5];
				}
				// CASO LOGRADOURO INEXISTENTE
				if(arrReturn[0] == "0"){
					// Insere mensagem no LOADER que LOGRADOURO NÃO EXISTE
					if(objRep != null){ 
						objRep.innerHTML = "<span style='color:red;'>(NÃO existe logradouro para o cep <em><b>"+ objCep.value +"</b></em>)";
						setTimeout("objRep.innerHTML = '';",3000);
					}
					objCep.focus();
					return(null);
				}
				// SETA O LOADER PARA VAZIO E DÁ FOCUS
				// NO CAMPO DE ENDEREÇO 'NÚMERO', JÁ AVALIADO
				if(objRep != null){ objRep.innerHTML = ""; }
				objNum.focus();
			} else { alert("Erro no processamento da página: " + objAjax.status + "\n\n" + objAjax.responseText); }
		}
	}
	objAjax.open("GET","../_ajax/buscacep.php?var_cep="+objCep.value, true);
	objAjax.send(null);
}
/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - Funções AJAX ------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */



/* -------------------------------------------------------------------------------------------------------------- */
/* INI - Funções EMULAÇÃO ---------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */
/* Função para emular a funcionalidade do FF nas Combos (by Leandro) */
var inCombo = false;

var b = navigator.appName;
var ua = navigator.userAgent.toLowerCase();
var Browser = {};

Browser.ie = !Browser.opera && b == 'Microsoft Internet Explorer';

function blurCombo(obj) { if(Browser.ie) { obj.className='ctrDropDown'; inCombo=false;} }

function mouseDownCombo(obj){ if(Browser.ie) { obj.className='ctrDropDownClick'; } }

function mouseUpCombo(obj){
	if(Browser.ie){
		inCombo = !inCombo; 
		if(inCombo) 
			obj.className='ctrDropDownClick'; 
		else 
			obj.className='ctrDropDown';
	}
}

function changeCombo(obj) { if(Browser.ie) obj.className='ctrDropDown'; }


function EditaCampos(prChaveName,prChavereg,prTable,prField,prValue,prLocation,prCodResize){
   	/* Esta Função chama o EDITOR HTML para edição de campos HTML
	 * simulados através de um TEXTAREA. Dentro da função, o do-
	 * cumento corrente recebe a criação de um form e o submita.
	 * OBS: createElement funciona em memória. appendChild tam-
	 * bém pode funcionar em memória, se o elemento o qual ire-
	 * mos linkar o recém criado também estiver em memória. A so-
	 * lução para este problema é criar o FORMULÁRIO dentro de um
	 * elemento já existente no DOM corrente, ou seja, melhor es-
	 * colhendo, o BODY CORRENTE.
	 *
	 * O RESULTADO da CHAMADA DESTA FUNÇÃO RESULTARÁ, em MEMÓRIA:
		<form name="formeditor" id="formeditor" action="../modulo_Principal/athedithtml.php" method="POST">
			<input type="hidden" id="var_chavename"	name="var_chavename" value="">
			<input type="hidden" id="var_chavereg"  name="var_chavereg"  value="">
			<input type="hidden" id="var_table"     name="var_table"     value="">
			<input type="hidden" id="var_field"     name="var_field"     value="">
			<input type="hidden" id="var_value"     name="var_value"     value="">
			<input type="hidden" id="var_location"	name="var_location"  value="">
		</form>
	 */
	// TRATAMENTO CONTRA PARÂMETROS VAZIOS OU NULOS
	if(
	   (prChaveName == ""  )||(prChavereg == ""  )||(prTable == ""  )||(prField == ""  )||(prValue == ""  )||(prLocation == "")||
	   (prChaveName == null)||(prChavereg == null)||(prTable == null)||(prField == null)||(prValue == null)||(prLocation == null))
	{ return(null); }
	// CRIA VARIÁVEIS QUE RECEBERÃO OS ELEMENTOS EM MEMÓRIA
	var objBODY,objFORM,objCHAVENAME,objCHAVEREG,objTABLE,objFIELD,objVALUE,objLOCATION,objCODRESIZE;
	// COLETA O BODY, PARA CRIAÇÃO DE UM FORM DENTRO
	objBODY = document.getElementsByTagName("body");
	// CRIA ELEMENTO FORM E SETA SEUS ATRIBUTOS
	objFORM = document.createElement("form");
	objFORM.setAttribute("name"  ,"formhtmleditor");
	objFORM.setAttribute("id"    ,"formhtmleditor");
	objFORM.setAttribute("method","POST");
	objFORM.setAttribute("action","../modulo_Principal/athedithtml.php");
	// CRIA O OBJETO CHAVENAME
	objCHAVENAME = document.createElement("input");
	objCHAVENAME.setAttribute("type" ,"hidden");
	objCHAVENAME.setAttribute("name" ,"var_chavename");
	objCHAVENAME.setAttribute("id"   ,"var_chavename");
	objCHAVENAME.setAttribute("value",prChaveName);
	// CRIA O OBJETO CHAVEREG
	objCHAVEREG = document.createElement("input");
	objCHAVEREG.setAttribute("type" ,"hidden");
	objCHAVEREG.setAttribute("name" ,"var_chavereg");
	objCHAVEREG.setAttribute("id"   ,"var_chavereg");
	objCHAVEREG.setAttribute("value",prChavereg);
	// CRIA O OBJETO TABLE
	objTABLE = document.createElement("input");
	objTABLE.setAttribute("type" ,"hidden");
	objTABLE.setAttribute("name" ,"var_table");
	objTABLE.setAttribute("id"   ,"var_table");
	objTABLE.setAttribute("value",prTable);
	// CRIA O OBJETO FIELD [Campo TEXT do BANCO, a ser editado]
	objFIELD = document.createElement("input");
	objFIELD.setAttribute("type" ,"hidden");
	objFIELD.setAttribute("name" ,"var_field");
	objFIELD.setAttribute("id"   ,"var_field");
	objFIELD.setAttribute("value",prField);
	// CRIA O OBJETO VALUE [VAlor de FIELD, no BANCO]
	objVALUE = document.createElement("input");
	objVALUE.setAttribute("type" ,"hidden");
	objVALUE.setAttribute("name" ,"var_value");
	objVALUE.setAttribute("id"   ,"var_value");
	objVALUE.setAttribute("value",prValue);
	// CRIA O OBJETO LOCATION
	objLOCATION = document.createElement("input");
	objLOCATION.setAttribute("type" ,"hidden");
	objLOCATION.setAttribute("name" ,"var_location");

	objLOCATION.setAttribute("id"   ,"var_location");
	objLOCATION.setAttribute("value",prLocation);
	// CRIA O OBJETO CODIGO DO RESIZE, CASO NAO VENHA NULO
	if(prCodResize != "" || prCodResize != null){
		objCODRESIZE = document.createElement("input");
		objCODRESIZE.setAttribute("type" ,"hidden");
		objCODRESIZE.setAttribute("name" ,"var_cod_resize");
		objCODRESIZE.setAttribute("id"   ,"var_cod_resize");
		objCODRESIZE.setAttribute("value",prCodResize);
	}
	
	// FAZ APPEND DOS FIELDS
	objBODY[0].appendChild(objFORM);
	objFORM.appendChild(objCHAVENAME);
	objFORM.appendChild(objCHAVEREG);
	objFORM.appendChild(objTABLE);
	objFORM.appendChild(objFIELD);
	objFORM.appendChild(objVALUE);
	objFORM.appendChild(objLOCATION);
	objFORM.appendChild(objCODRESIZE);
	objFORM.submit();
	
	// DEEBUG
	// alert(document.getElementById("var_chavename").value);
	// var auxstr = "../modulo_AssistHTMLAREA/athEditor.php?var_TextBoxName="+ pr_fieldname + "&var_IndexForm=" + pr_formindex;
	// AbreJanelaPAGE(auxstr, '630', '480');
}
/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - Funções EMULÇÃO ---------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */



/* -------------------------------------------------------------------------------------------------------------- */
/* INI - Funções STRING ---------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */
function returnChar(prString){
	// 'E' COMERCIAL, DESCOMENTAR: prString.replace(/&amp\;/gi,"&");
	prString = prString.replace(/\&Agrave\;/g , "À");
	prString = prString.replace(/\&agrave\;/g , "à");
	prString = prString.replace(/\&Aacute\;/g , "Á");
	prString = prString.replace(/\&aacute\;/g , "á");
	prString = prString.replace(/\&Acirc\;/g  , "Â");
	prString = prString.replace(/\&acirc\;/g  , "â");
	prString = prString.replace(/\&Atilde\;/g , "Ã");
	prString = prString.replace(/\&atilde\;/g , "ã");
	prString = prString.replace(/\&Auml\;/g   , "Ä");
	prString = prString.replace(/\&auml\;/g   , "ä");
	prString = prString.replace(/\&Ccedil\;/g , "Ç");
	prString = prString.replace(/\&ccedil\;/g , "ç");
	prString = prString.replace(/\&Egrave\;/g , "È");
	prString = prString.replace(/\&egrave\;/g , "è");
	prString = prString.replace(/\&Eacute\;/g , "É");
	prString = prString.replace(/\&eacute\;/g , "é");
	prString = prString.replace(/\&Ecirc\;/g  , "Ê");
	prString = prString.replace(/\&ecirc\;/g  , "ê");
	prString = prString.replace(/\&Euml\;/g   , "Ë");
	prString = prString.replace(/\&euml\;/g   , "ë");
	prString = prString.replace(/\&Igrave\;/g , "Ì");
	prString = prString.replace(/\&igrave\;/g , "ì");
	prString = prString.replace(/\&Iacute\;/g , "Í");
	prString = prString.replace(/\&iacute\;/g , "í");
	prString = prString.replace(/\&Icirc\;/g  , "Î");
	prString = prString.replace(/\&icirc\;/g  , "î");
	prString = prString.replace(/\&Iuml\;/g   , "Ï");
	prString = prString.replace(/\&iuml\;/g   , "ï");
	prString = prString.replace(/\&Ntilde\;/g , "Ñ");
	prString = prString.replace(/\&ntilde\;/g , "ñ");
	prString = prString.replace(/\&Ograve\;/g , "ò");
	prString = prString.replace(/\&ograve\;/g , "ò");
	prString = prString.replace(/\&Oacute\;/g , "Ó");
	prString = prString.replace(/\&oacute\;/g , "ó");
	prString = prString.replace(/\&Ocirc\;/g  , "Ô");
	prString = prString.replace(/\&ocirc\;/g  , "ô");
	prString = prString.replace(/\&Otilde\;/g , "Õ");
	prString = prString.replace(/\&otilde\;/g , "õ");
	prString = prString.replace(/\&Ouml\;/g   , "Ö");
	prString = prString.replace(/\&Ouml\;/g   , "ö");
	prString = prString.replace(/\&Ugrave\;/g , "Ù");
	prString = prString.replace(/\&ugrave\;/g , "ù");
	prString = prString.replace(/\&Uacute\;/g , "Ú");
	prString = prString.replace(/\&uacute\;/g , "ú");
	prString = prString.replace(/\&Ucirc\;/g  , "Û");
	prString = prString.replace(/\&ucirc\;/g  , "û");
	prString = prString.replace(/\&Uuml\;/g   , "Ü");
	prString = prString.replace(/\&uuml\;/g   , "ü");
	prString = prString.replace(/ß/gi , "&szlig;" );
	prString = prString.replace(/÷/gi , "&divide;");
	prString = prString.replace(/ÿ/gi , "&yuml;"  );
	prString = prString.replace(/</gi , "&lt;"    );
	prString = prString.replace(/>/gi , "&gt;"    );
	// prString = prString.replace(/\"/gi, "&quot;"  );
	prString = prString.replace(/'/gi , "''"      );
	prString = prString.replace(/°/gi , "&deg;"   );
	return(prString);
}


function Trim(str){
    return str.replace(/^\s+|\s+$/g,"");
}

/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - Funções EMULAÇÃO ---------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */