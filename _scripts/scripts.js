<script language="JavaScript">

var winpopup=null;
var winpopup_csm=null;

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
  winpopup = window.open(strcode,'PROEVENTO_IMG_DETAIL', auxstr);
}

function AbreJanelaPAGE(prpage, prwidth, prheight) 
{ 
  var auxstr;

  auxstr  = 'width=' + prwidth;
  auxstr  = auxstr + ',height=' + prheight;
  auxstr  = auxstr + ',top=30,left=30,scrollbars=1,resizable=yes';

  if (winpopup_csm != null) 
  {
    winpopup_csm.close();
  }
  winpopup_csm = window.open(prpage, 'PROEVENTO_PAGE_DETAIL', auxstr);
}



function AbreJanelaPAGE_NOVA(prpage, prwidth, prheight) 
{ 
  var auxstr;

  auxstr  = 'width=' + prwidth;
  auxstr  = auxstr + ',height=' + prheight;
  auxstr  = auxstr + ',top=30,left=30,scrollbars=yes,resizable=yes';

  if (winpopup_csm != null) 
  {
    winpopup_csm.close();
  }
  winpopup_csm = window.open(prpage, 'PROEVENTO_PAGE_DETAIL', auxstr);
}


/* ----------------------------------------------------------------------------------
   ABRE janela POP_UP permitindo envio de parâmetrso via POST                        
   ---------------------------------------------------------------------------------- 
   Exemplo de uso:
  
   function openPopupPage_ARM(prUrl, prCodInsc, prCodEvent)	{
	 var param = { 'var_cod_inscricao' : prCodInsc, 'var_cod_evento': prCodEvent, 'var_tipo' : '' , 'lng' : '' };
	 OpenWindowWithPost(prUrl, "width=720, height=600, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
   }
   ...
   <button onClick="openPopupPage_ARM('confirmacao_arm.asp','123','3332');"></button>
  --------------------------------------------------------------------- 10/03/2017 - */
function OpenWindowWithPost(url, windowoption, name, params)
{
 var form = document.createElement("form");
 form.setAttribute("method", "post");
 form.setAttribute("action", url);
 form.setAttribute("target", name);
 for (var i in params)
 {
   if (params.hasOwnProperty(i))
   {
     var input = document.createElement('input');
     input.type = 'hidden';
     input.name = i;
     input.value = params[i];
     form.appendChild(input);
   }
 }
 document.body.appendChild(form);
 //essa páginapot.ht serve apena de placeholder até o conteúdo ser carregado na janela alocada
 window.open("post.htm", name, windowoption);
 form.submit();
 document.body.removeChild(form);
}


function MM_findObj(n, d) 
{ //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
 var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
   var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
   if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function autentica() { 
    if (verifica_formulario(document.form.tipopergunta.value) == false) {  
        alert("É obrigatório selecionar um tipo de pergunta!");
        return false;}
   
	if (verifica_formulario(document.form.nome.value) == false) {  
        alert("É obrigatório o preenchimento do Nome!");
        return false;}
	if (verifica_formulario(document.form.email.value) == false) {  
        alert("É obrigatório o preenchimento do E-mail!");
        return false;}
	if (verifica_formulario(document.form.mensagem.value) == false) {  
        alert("É obrigatório o preenchimento da mensagem!");
        return false;}
	}   
	
function verifica_formulario(CAMP){
     if (CAMP.length < 1){
     return false;
     }
     else
     return true;
} 
function verifica_form_fone(VAR)
{
  if (VAR.length < 1){
	return false;
	}
	else
	return true;
}

function ATHSetFocus (formulario, campo) {
  eval('document.' + formulario + '.' + campo + '.focus()');
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

function somenteNumero(e){
    var tecla=(window.event)?event.keyCode:e.which;
    if((tecla > 47 && tecla < 58)) return true;
    else{
    if (tecla != 8) return false;
    else return true;
    }
}

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

function Trim(str){return str.replace(/^\s+|\s+$/g,"");}


// Troca estado do Campo Visível ou Não Visível
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
    if (array_data.length!=3) 
       return false;

    //comprovo que o ano, mes, dia são corretos 
    var ano;
    ano = parseInt(array_data[2]); 
    if (isNaN(ano)) 
       return false;

    var mes;
    mes = parseInt(array_data[1]); 
    if (isNaN(mes)) 
       return false;

    var dia;
    dia = parseInt(array_data[0]); 
    if (isNaN(dia)) 
       return false;

    //se o ano da data que recebo so tem 2 cifras temos que muda-lo a 4 
    if (ano<=99) 
       ano +=1900;

    //subtraio os anos das duas datas 
    var idade=hoje.getFullYear() - ano - 1; //-1 porque ainda nao fez anos durante este ano
 
    //se subtraio os meses e for menor que 0 entao nao cumpriu anos. Se for maior sim ja cumpriu
     if (hoje.getMonth() + 1 - mes < 0) //+ 1 porque os meses comecam em 0 
       return idade;
    if (hoje.getMonth() + 1 - mes > 0) 
       return idade+1;

    //entao eh porque sao iguais. Vejo os dias 
    //se subtraio os dias e der menor que 0 entao nao cumpriu anos. Se der maior ou igual sim que já cumpriu
     if (hoje.getUTCDate() - dia >= 0) 
       return idade + 1;

    return idade;
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


// Função para impressão SEM DIALOG quando carregar o ACTIVEX e caso não consigo então faz a impressão COM DIALOG
function printit() {  
  //try {
  //   var myStrWebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
  //	 document.body.insertAdjacentHTML('afterEnd', myStrWebBrowser);
  //   WebBrowser1.ExecWB(6, 2);
	   //Param01: 4-Salvar documento html  6-impressão em si  7-janela de preview de impressão  8-config de página de impressão
	   //Param02: 1-Prompt   2- not prompt
	// WebBrowser1.outerHTML = "";  
  //}
  //catch(e) { 
   //alert("Sem suporte ACTIVEX! \n" + e.message);
	   window.print();
 // }

  setTimeout("window.close()", 2500);     
}



//FUNCAOES INSRICAO ESTADUAL


var OrdZero = '0'.charCodeAt(0);

function CharToInt(ch)
	{
		return ch.charCodeAt(0) - OrdZero;
	}

function IntToChar(intt)
	{
		return String.fromCharCode(intt + OrdZero);
	}
//INI ACRE 
function CheckIEAC(ie){
	if (ie.length != 13)
		return false;
	var b = 4, soma = 0;

	for (var i = 0; i <= 10; i++)
	{
		soma += CharToInt(ie.charAt(i)) * b;
	 	--b;
		if (b == 1) { b = 9; }
	}
	dig = 11 - (soma % 11);
	if (dig >= 10) { dig = 0; }
	resultado = (IntToChar(dig) == ie.charAt(11));
	if (!resultado) { return false; }

	b = 5;
	soma = 0;
	for (var i = 0; i <= 11; i++)
		{
			soma += CharToInt(ie.charAt(i)) * b;
			--b;
			if (b == 1) { b = 9; }
		}
	dig = 11 - (soma % 11);
	if (dig >= 10) { dig = 0; }
	if (IntToChar(dig) == ie.charAt(12)) { return true; } else { return false; }
} 
//FIM ACRE

//INI ALAGOAS
function CheckIEAL(ie)
	{
		if (ie.length != 9)
		  return false;
	var b = 9, soma = 0;
	for (var i = 0; i <= 7; i++)
	{
	   soma += CharToInt(ie.charAt(i)) * b;
	   --b;
	}
	soma *= 10;
	dig = soma - Math.floor(soma / 11) * 11;
	if (dig == 10) { dig = 0; }
	return (IntToChar(dig) == ie.charAt(8));
} 
//FIM ALAGOAS

//INI AMAZONAS
function CheckIEAM(ie)
{
	if (ie.length != 9)
	  return false;
	var b = 9, soma = 0;
	for (var i = 0; i <= 7; i++)
	{
	  soma += CharToInt(ie.charAt(i)) * b;
	  b--;
	}
	if (soma < 11) { dig = 11 - soma; } 
	else { 
	   i = soma % 11;
	   if (i <= 1) { dig = 0; } else { dig = 11 - i; }
	}
	return (IntToChar(dig) == ie.charAt(8));
} 
//FIM AMAZONAS

//INI AMAPA
function CheckIEAP(ie)
{
	if (ie.length != 9)
	  return false;
	var p = 0, d = 0, i = ie.substring(1, 8);
	if ((i >= 3000001) && (i <= 3017000))
	{
	  p =5;
	  d = 0;
	}
	else if ((i >= 3017001) && (i <= 3019022))
	{
	  p = 9;
	  d = 1;
	}
	b = 9;
	soma = p;
	for (var i = 0; i <= 7; i++)
	{
	  soma += CharToInt(ie.charAt(i)) * b;
	  b--;
	}
	dig = 11 - (soma % 11);
	if (dig == 10)
	{
	   dig = 0;
	}
	else if (dig == 11)
	{
	   dig = d;
	}
	return (IntToChar(dig) == ie.charAt(8));
} 
//FIM AMAPA

//INI BAHIA
function CheckIEBA(ie)
{
	if (ie.length != 8)
	  return false;
	die = ie.substring(0, 8);
	var nro = new Array(8);
	var dig = -1;
	for (var i = 0; i <= 7; i++)
	{
	  nro[i] = CharToInt(die.charAt(i));
	}
	var NumMod = 0;
	if (String(nro[0]).match(/[0123458]/))
	   NumMod = 10;
	else
	   NumMod = 11;
	b = 7;
	soma = 0;
	for (i = 0; i <= 5; i++)
	{
	  soma += nro[i] * b;
	  b--;
	}
	i = soma % NumMod;
	if (NumMod == 10)
	{
	  if (i == 0) { dig = 0; } else { dig = NumMod - i; }
	}
	else
	{
	  if (i <= 1) { dig = 0; } else { dig = NumMod - i; }
	}
	resultado = (dig == nro[7]);
	if (!resultado) { return false; }
	b = 8;
	soma = 0;
	for (i = 0; i <= 5; i++)
	{
	  soma += nro[i] * b;
	  b--;
	}
	soma += nro[7] * 2;
	i = soma % NumMod;
	if (NumMod == 10)
	{
	  if (i == 0) { dig = 0; } else { dig = NumMod - i; }
	}
	else 
	{
	  if (i <= 1) { dig = 0; } else { dig = NumMod - i; }
	}
	return (dig == nro[6]);
} 
//FIM BAHIA

//INI CEARA 
function CheckIECE(ie)
{
	if (ie.length > 9)
	  return false;
	die = ie;
	if (ie.length < 9)
	{
	  while (die.length <= 8)
	   die = '0' + die;
	}
	var nro = Array(9);
	for (var i = 0; i <= 8; i++)
	  nro[i] = CharToInt(die[i]);
	b = 9;
	soma = 0;
	for (i = 0; i <= 7; i++)
	{
	  soma += nro[i] * b;
	  b--; 
	}
	dig = 11 - (soma % 11);
	if (dig >= 10)
	  dig = 0;
	return (dig == nro[8]);
} 
//FIM CEARA

//INI DISTRITO FEDERAL 
function CheckIEDF(ie)
{
	if (ie.length != 13)
	  return false;
	var nro = new Array(13);
	for (var i = 0; i <= 12; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 4;
	soma = 0;
	for (i = 0; i <= 10; i++)
	{
	  soma += nro[i] * b;
	  b--;
	  if (b == 1)
	   b = 9;
	}
	dig = 11 - (soma % 11);
	if (dig >= 10)
	  dig = 0;
	resultado = (dig == nro[11]);
	if (!resultado)
	  return false;  
	b = 5;
	soma = 0;
	for (i = 0; i <= 11; i++)
	{
	  soma += nro[i] * b;
	  b--;
	  if (b == 1)
	   b = 9;
	}
	dig = 11 - (soma % 11);
	if (dig >= 10)
	  dig = 0;
	return (dig == nro[12]);
}
//FIM DISTRITO FEDERAL


//INI ESPIRITO SANTO 
function CheckIEES(ie)
{
	if (ie.length != 9)
	  return false;
	var nro = new Array(9);
	for (var i = 0; i <= 8; i++)
	  nro[i] = CharToInt(ie.charAt(i)); 
	b = 9;
	soma = 0;
	for (i = 0; i <= 7; i++)
	{
	  soma += nro[i] * b;
	  b--;
	}
	i = soma % 11;
	if (i < 2)
	  dig = 0;
	else
	  dig = 11 - i;
	return (dig == nro[8]);
}
//FIM ESPIRITO SANTO

//INI GOIAS  
function CheckIEGO(ie)
{
	if (ie.length != 9)
	  return false;
	s = ie.substring(0, 2);
	if ((s == '10') || (s == '11') || (s == '15'))
	{
	  var nro = new Array(9);
	  for (var i = 0; i <= 8; i++)
	   nro[i] = CharToInt(ie.charAt(i));
	  n = Math.floor(ie / 10);
	  if (n = 11094402)
	  {
	   if ((nro[8] == 0) || (nro[8] == 1))
	return true;
	  }
	  b = 9;
	  soma = 0;
	  for (i = 0; i <= 7; i++)
	  {
	   soma += nro[i] * b;
	   b--;
	  }
	  i = soma % 11;
	  if (i == 0)
	   dig = 0;
	  else
	  {
	   if (i == 1)
	   {
	if ((n >= 10103105) && (n <= 10119997))
	  dig = 1;
	else
	  dig = 0;
	   }
	   else
	dig = 11 - i;
	  }
	  return (dig == nro[8]);
	}
}
//FIM GOIAS

//INI MARANHAO
function CheckIEMA(ie)
{
	if (ie.length != 9)
	  return false;
	var nro = new Array(9); 
	for (var i = 0; i <= 8; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 9;
	soma = 0;
	for (i = 0; i <= 7; i++)
	{
	  soma += nro[i] * b;
	  b--;
	}
	i = soma % 11;
	if (i <= 1)
	  dig = 0;
	else
	  dig = 11 - i;
	return (dig == nro[8]);
}
//FIM MARANHAO

//INI MATO GROSSO 
function CheckIEMT(ie)
{
	if (ie.length < 9)
	  return false;
	die = ie;
	if (die.length < 11)
	{
	  while (die.length <= 10)
	   die = '0' + die;
	  var nro = new Array(11);
	  for (var i = 0; i <= 10; i++)
	   nro[i] = CharToInt(die[i]);
	  b = 3;
	  soma = 0;
	  for (i = 0; i <= 9; i++)
	  {
	   soma += nro[i] * b;
	   b--;
	   if (b == 1)
	b = 9;
	  }
	  i = soma % 11;
	  if (i <= 1)
	   dig = 0;
	  else
	   dig = 11 - i;
	  return (dig == nro[10]);
	}
} 
//FIM MATO GROSSO

//INI MATO GROSSO SUL  
function CheckIEMS(ie)
{
	if (ie.length != 9)
	  return false;
	if (ie.substring(0,2) != '28')
	  return false;
	var nro = new Array(9);
	for (var i = 0; i <= 8; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 9;
	soma = 0;
	for (i = 0; i <= 7; i++)
	{
	  soma += nro[i] * b;
	  b--;
	}
	i = soma % 11;
	if (i <= 1)
	  dig = 0;
	else
	  dig = 11 - i;
	return (dig == nro[8]);
} //ms

function CheckIEPA(ie)
{
	if (ie.length != 9)
	  return false;
	if (ie.substring(0, 2) != '15')
	  return false;
	var nro = new Array(9);
	for (var i = 0; i <= 8; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 9;
	soma = 0;
	for (i = 0; i <= 7; i++)
	{
	  soma += nro[i] * b;
	  b--;
	}
	i = soma % 11;
	if (i <= 1)
	  dig = 0;
	else
	  dig = 11 - i;
	return (dig == nro[8]);
} //pra

function CheckIEPB(ie)
{
	if (ie.length != 9)
	  return false;
	var nro = new Array(9);
	for (var i = 0; i <= 8; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 9;
	soma = 0;
	for (i = 0; i <= 7; i++)
	{
	  soma += nro[i] * b;
	  b--;  
	}
	i = soma % 11;
	if (i <= 1)
	  dig = 0;
	else
	  dig = 11 - i;
	return (dig == nro[8]);
} //pb

function CheckIEPR(ie)
{
	if (ie.length != 10)
	  return false;
	var nro = new Array(10);
	for (var i = 0; i <= 9; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 3;
	soma = 0;
	for (i = 0; i <= 7; i++)
	{
	  soma += nro[i] * b;
	  b--;
	  if (b == 1)
	   b = 7;
	}
	i = soma % 11;
	if (i <= 1)
	  dig = 0;
	else
	  dig = 11 - i;
	resultado = (dig == nro[8]);
	if (!resultado)
	  return false;
	b = 4;
	soma = 0;
	for (i = 0; i <= 8; i++)
	{
	  soma += nro[i] * b;
	  b--;
	  if (b == 1)
	   b = 7;
	}
	i = soma % 11;
	if (i <= 1)
	  dig = 0;
	else
	  dig = 11 - i;
	return (dig == nro[9]);
} //pr

function CheckIEPE(ie)
{
	if (ie.length != 14)
	  return false;
	var nro = new Array(14);
	for (var i = 0; i <= 13; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 5;
	soma = 0;
	for (i = 0; i <= 12; i++)
	{
	  soma += nro[i] * b;
	  b--;
	  if (b == 0)
	   b = 9;
	}
	dig = 11 - (soma % 11);
	if (dig > 9)
	  dig = dig - 10;
	return (dig == nro[13]);
} //pe

function CheckIEPI(ie)
{
	if (ie.length != 9)
	  return false;
	var nro = new Array(9);
	for (var i = 0; i <= 8; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 9;
	soma = 0;
	for (i = 0; i <= 7; i++)
	{
	  soma += nro[i] * b;
	  b--;
	}
	i = soma % 11;
	if (i <= 1)
	  dig = 0;
	else
	  dig = 11 - i;
	return (dig == nro[8]);
} //pi

function CheckIERJ(ie)
{
	if (ie.length != 8)
	  return false;
	var nro = new Array(8);
	for (var i = 0; i <= 7; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 2;
	soma = 0;
	for (i = 0; i <= 6; i++)
	{
	  soma += nro[i] * b;
	  b--;
	  if (b == 1)
	   b = 7;
	}
	i = soma % 11;
	if (i <= 1)
	  dig = 0;
	else
	  dig = 11 - i;
	return (dig == nro[7]);
} //rj
// CHRISTOPHE T. C. <wG @ codingz.info>
function CheckIERN(ie)
{
	if (ie.length != 9)
	  return false;
	var nro = new Array(9);
	for (var i = 0; i <= 8; i++)
	  nro[i] = CharToInt(ie.charAt(i));
	b = 9;
	soma = 0;
	for (i = 0; i <= 7; i++)
	{
	  soma += nro[i] * b;
	  b--;
	}
	soma *= 10;
	dig = soma % 11;
	if (dig == 10)
	  dig = 0;
	return (dig == nro[8]);
} //rn

function CheckIERS(ie)
{
	if (ie.length != 10)
	  return false;
	i = ie.substring(0, 3);
	if ((i >= 1) && (i <= 467))
	{
	  var nro = new Array(10);
	  for (var i = 0; i <= 9; i++)
	   nro[i] = CharToInt(ie.charAt(i));
	  b = 2;
	  soma = 0;
	  for (i = 0; i <= 8; i++)
	  {
	   soma += nro[i] * b;
	   b--;
	   if (b == 1)
	b = 9;
	  }
	  dig = 11 - (soma % 11);
	  if (dig >= 10)
	   dig = 0;
	  return (dig == nro[9]);
	} //if i&&i
} //rs




function CheckIEROantigo(ie)
{
	if (ie.length != 9) {
	 return false;
	}
	
	var nro = new Array(9);
	b=6;
	soma =0;
	
	for( var i = 3; i <= 8; i++) {
	
		nro[i] = CharToInt(ie.charAt(i));
	
			if( i != 8 ) {
				soma = soma + ( nro[i] * b );
				b--;
			}
	
	}
	
	dig = 11 - (soma % 11);
	if (dig >= 10)
	  dig = dig - 10;
	
	return (dig == nro[8]);
	
} //ro-antiga





function CheckIERO(ie)
{

if (ie.length != 14) {
 return false;
}

var nro = new Array(14);
b=6;
soma=0;

        for(var i=0; i <= 4; i++) {
    
            nro[i] = CharToInt(ie.charAt(i));

        
                soma = soma + ( nro[i] * b );
                b--;

        }

        b=9;
        for(var i=5; i <= 13; i++) {
    
            nro[i] = CharToInt(ie.charAt(i));

                if ( i != 13 ) {        
                soma = soma + ( nro[i] * b );
                b--;
                }

        }

                        dig = 11 - ( soma % 11);
                            
                            if (dig >= 10)
                                  dig = dig - 10;

                                    return(dig == nro[13]);
                        
} //ro nova


function CheckIERR(ie)
{
if (ie.length != 9)
  return false;
if (ie.substring(0,2) != '24')
  return false;
var nro = new Array(9);
for (var i = 0; i <= 8; i++)
  nro[i] = CharToInt(ie.charAt(i));
var soma = 0;
var n = 0;
for (i = 0; i <= 7; i++)
  soma += nro[i] * ++n;
dig = soma % 9;
return (dig == nro[8]);
} //rr

function CheckIESC(ie)
{
if (ie.length != 9)
  return false;
var nro = new Array(9);
for (var i = 0; i <= 8; i++)
  nro[i] = CharToInt(ie.charAt(i));
b = 9;
soma = 0;
for (i = 0; i <= 7; i++)
{
  soma += nro[i] * b;
  b--;
}
i = soma % 11;
if (i <= 1)
  dig = 0;
else
  dig = 11 - i;
return (dig == nro[8]);
} //sc

// CHRISTOPHE T. C. <wG @ codingz.info>

function CheckIESP(ie)
{
if (((ie.substring(0,1)).toUpperCase()) == 'P')
{
  s = ie.substring(1, 9);
  var nro = new Array(12);
  for (var i = 0; i <= 7; i++)
   nro[i] = CharToInt(s[i]);
  soma = (nro[0] * 1) + (nro[1] * 3) + (nro[2] * 4) + (nro[3] * 5) +
   (nro[4] * 6) + (nro[5] * 7) + (nro[6] * 8) + (nro[7] * 10);
  dig = soma % 11;
  if (dig >= 10)
   dig = 0;
  resultado = (dig == nro[8]);
  if (!resultado)
   return false;
}
else
{
  if (ie.length < 12)
   return false;
  var nro = new Array(12);
  for (var i = 0; i <= 11; i++)
   nro[i] = CharToInt(ie.charAt(i));
  soma = (nro[0] * 1) + (nro[1] * 3) + (nro[2] * 4) + (nro[3] * 5) +
   (nro[4] * 6) + (nro[5] * 7) + (nro[6] * 8) + (nro[7] * 10);
  dig = soma % 11;
  if (dig >= 10)
   dig = 0;
  resultado = (dig == nro[8]);
  if (!resultado)
   return false;
  soma = (nro[0] * 3) + (nro[1] * 2) + (nro[2] * 10) + (nro[3] * 9) +
   (nro[4] * 8) + (nro[5] * 7) + (nro[6] * 6)  + (nro[7] * 5) +
   (nro[8] * 4) + (nro[9] * 3) + (nro[10] * 2);
  dig = soma % 11;
  if (dig >= 10)
   dig = 0;
  return (dig == nro[11]);
}
} //sp

function CheckIESE(ie)
{
if (ie.length != 9)
  return false;
var nro = new Array(9);
for (var i = 0; i <= 8; i++)
  nro[i] = CharToInt(ie.charAt(i));
b = 9;
soma = 0;
for (i = 0; i <= 7; i++)
{
  soma += nro[i] * b;
  b--;
}
dig = 11 - (soma % 11);
if (dig >= 10)
  dig = 0;
return (dig == nro[8]);
} //se



function CheckIETO(ie)
{
if (ie.length != 9) {
 return false;
}

var nro = new Array(9);
b=9;
soma=0;

for (var i=0; i <= 8; i++ ) {

nro[i] = CharToInt(ie.charAt(i));

if(i != 8) {
soma = soma + ( nro[i] * b );
b--;
}


}

ver = soma % 11;

if ( ver < 2 )

dig=0;

if ( ver >= 2 )
dig = 11 - ver;

return(dig == nro[8]);
} //to





//inscrição estadual antiga
function CheckIETOantigo(ie)
{

 if ( ie.length != 11 ) {
    return false;

}


var nro = new Array(11);
b=9;
soma=0;

s = ie.substring(2, 4);

    if( s != '01' || s != '02' || s != '03' || s != '99' ) {


        for ( var i=0; i <= 10; i++) 
        {

            nro[i] = CharToInt(ie.charAt(i));    

            if( i != 3 || i != 4) {

            soma = soma + ( nro[i] * b );
            b--;
            
            } // if ( i != 3 || i != 4 )

        } //fecha for


            resto = soma % 11;        
            
                if( resto < 2 ) {    

                    dig = 0;

                }


                if ( resto >= 2 ) {

                    dig = 11 - resto;

                }            

                return (dig == nro[10]);

    } // fecha if


}//fecha função CheckIETOantiga

function CheckIEMG(ie)
{
if (ie.substring(0,2) == 'PR')
  return true;
if (ie.substring(0,5) == 'ISENT')
  return true;
if (ie.length != 13)
  return false;
dig1 = ie.substring(11, 12);
dig2 = ie.substring(12, 13);
inscC = ie.substring(0, 3) + '0' + ie.substring(3, 11);
insc=inscC.split('');
npos = 11;
i = 1;
ptotal = 0;
psoma = 0;
while (npos >= 0)
{
  i++;
  psoma = CharToInt(insc[npos]) * i;  
  if (psoma >= 10)
   psoma -= 9;
  ptotal += psoma;
  if (i == 2)
   i = 0;
  npos--;
}
nresto = ptotal % 10;
if (nresto == 0)
  nresto = 10;
nresto = 10 - nresto;
if (nresto != CharToInt(dig1))
  return false;
npos = 11;
i = 1;
ptotal = 0;
is=ie.split('');
while (npos >= 0)
{
  i++;
  if (i == 12)
   i = 2;
  ptotal += CharToInt(is[npos]) * i;
  npos--;
}
nresto = ptotal % 11;
if ((nresto == 0) || (nresto == 1))
  nresto = 11;
nresto = 11 - nresto;  
return (nresto == CharToInt(dig2));
}


function CheckIE(ie, estado)
{
ie = ie.replace(/\./g, '');
ie = ie.replace(/\\/g, '');
ie = ie.replace(/\-/g, '');
ie = ie.replace(/\//g, '');
if ( ie == 'ISENTO') 
  return true;
switch (estado)
{
  case 'MG': return CheckIEMG(ie); break;
  case 'AC': return CheckIEAC(ie); break;
  case 'AL': return CheckIEAL(ie); break;
  case 'AM': return CheckIEAM(ie); break;
  case 'AP': return CheckIEAP(ie); break;
  case 'BA': return CheckIEBA(ie); break;
  case 'CE': return CheckIECE(ie); break;
  case 'DF': return CheckIEDF(ie); break;
  case 'ES': return CheckIEES(ie); break;
  case 'GO': return CheckIEGO(ie); break;
  case 'MA': return CheckIEMA(ie); break;
  case 'muito': return CheckIEMT(ie); break;
  case 'MS': return CheckIEMS(ie); break;
  case 'pra': return CheckIEPA(ie); break;
  case 'PB': return CheckIEPB(ie); break;
  case 'PR': return CheckIEPR(ie); break;
  case 'PE': return CheckIEPE(ie); break;
  case 'PI': return CheckIEPI(ie); break;
  case 'RJ': return CheckIERJ(ie); break;
  case 'RN': return CheckIERN(ie); break;
  case 'RS': return CheckIERS(ie); break;
  case 'RO': return ((CheckIERO(ie)) || (CheckIEROantigo(ie))); break;
  case 'RR': return CheckIERR(ie); break;
  case 'SC': return CheckIESC(ie); break;
  case 'SP': return CheckIESP(ie); break;
  case 'SE': return CheckIESE(ie); break;
  case 'TO': return ((CheckIETO(ie)) || (CheckIETOantigo(ie))); break;//return CheckIETO(ie); break;         
}
}

function valida_ie(prIE, prUF) {
    var ie =   prIE.value;
    var estado = prUF.value;
	if (ie.toLowerCase() == 'isento'){return false;}
	if (ie.toLowerCase() == 'isenta'){return false;}
    if (CheckIE(ie , estado)){
		return false;	
    }else{
        //alert('Inscrição Estadual invalida.');
    	//prIE.value = "";
		//prIE.focus();
		return true;
    }
}


//FIM FUNÇÕES INCRICAO ESTADUAL

/* -------------------------------------------------------------------------------------------------------------- */
/* INI - Funções COOKIE ---------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */
function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return '';
}	
/* -------------------------------------------------------------------------------------------------------------- */
/* FIM - Funções COOKIE ---------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------- */



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

</script>