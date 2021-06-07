<!-- script language="JavaScript" type="text/javascript" -->
var vboss_winpopup_page=null;
var vboss_winpopup_img=null;

// --------------------------------------------------------------------------------
// 
// -------------------------------------------------- by Aless e Alan 09/12/2006 --
function AbreJanelaIMGNew(imgname, prwidth, prheight, prextra, prscroll) 
{ 
  var strcode = 'viewimg.asp?img=' + imgname + '&extra=' + prextra;
  var auxstr;

  auxstr  = 'width=' + prwidth;
  auxstr  = auxstr + ',height=' + prheight;
  //Cria a janela no limite da screen (não visível), quem chamou deve se encarregar de reposicioná-la (ver ViewImg.asp)
  auxstr  = auxstr + ',top=' + screen.height + ',left=' + screen.width + ',scrollbars=' + prscroll + ',resizable=yes';

  if (vboss_winpopup_img != null) { vboss_winpopup_img.close(); }
  vboss_winpopup_img = window.open(strcode,'vboss_IMG_DETAIL', auxstr);
}

// --------------------------------------------------------------------------------
// 
// -------------------------------------------------- by Aless e Alan 09/12/2006 --
function AbreJanelaPAGENew(prpage, prwidth, prheight, prscroll) 
{ 
  var auxstr;
  auxstr  = 'width=' + prwidth;
  auxstr  = auxstr + ',height=' + prheight;
  auxstr  = auxstr + ',top=30,left=30,scrollbars=' + prscroll + ',resizable=yes';

  if (vboss_winpopup_page != null) { vboss_winpopup_page.close(); }
  vboss_winpopup_page = window.open(prpage, 'vboss_PAGE_DETAIL', auxstr);
}



function isMail(objField)
{
  var re = new RegExp, arr, strMail;

  if(objField.value !=""){
	  strMail = objField.value
	  re = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	  arr = re.exec(strMail);
	  if (arr == null) {alert('E-mail inválido'); objField.value=""; return false;   }
	  else { return true; }
  }else {return false;}
  
}

function Ath_over(src,clrOver) { if (!src.contains(event.fromElement)) {  src.style.cursor = 'hand';  src.bgColor = clrOver; } }
function Ath_out(src,clrIn) { if (!src.contains(event.toElement)) { src.style.cursor = 'default'; src.bgColor = clrIn; } }
function selecao() { return(false); }
function trataTecla() { if((event.keyCode == 121)&&(event.shiftKey)) alert(message); }
function athGo(loc) { window.location.href = loc; }
function limpainput(obj) { obj.value=""; } //SCRIPT LIMPA INPUT PREENCHIDO

// --------------------------------------------------------------------------------
// Função para efetuar o tab automático entre inputs e outros objetos do tipo Form
// --------------------------------------------------------------------------------
var isNN = (navigator.appName.indexOf("Netscape")!=-1);

function autoTab(input,len, e) 
{
   var keyCode = (isNN) ? e.which : e.keyCode; 
   var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
   if(input.value.length >= len && !containsElement(filter,keyCode)) 
   {
     input.value = input.value.slice(0, len);
     input.form[(getIndex(input)+1) % input.form.length].focus();
   }
   function containsElement(arr, ele) 
   {
     var found = false, index = 0;
     while(!found && index < arr.length)
       if(arr[index] == ele)
         found = true;
       else
         index++;
     return found;
   }
   function getIndex(input) 
   {
     var index = -1, i = 0, found = false;
     while (i < input.form.length && index == -1)
     if (input.form[i] == input)
       index = i;
     else 
       i++;
     return index; 
   }
 return true;
}

function diasemana()
{
 var diasdasemana = new Array("Domingo","Segunda-feira","Terça-feira","Quarta-feira","Quinta-feira","Sexta-feira","Sábado");
 var meses = new Array("Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro");
 var data = new Date();
 document.write(diasdasemana[data.getDay()] + ", " + data.getDate() + " de " + meses[data.getMonth()] + " de " + data.getFullYear() );
}


// --------------------------------------------------------------------------------
// DreamWeaver ...
// --------------------------------------------------------------------------------

function MM_swapImgRestore() { var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc; } //v3.0
function MM_openBrWindow(theURL,winName,features) {  window.open(theURL,winName,features); } //v2.0

function MM_preloadImages() 
{ //v3.0
  var d=document; 
  
  if(d.images)
  { 
    if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; 
	for(i=0; i<a.length; i++) if (a[i].indexOf("#")!=0) { d.MM_p[j]=new Image; d.MM_p[j++].src=a[i]; }
   }
}

function MM_swapImage() 
{ //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; 
  document.MM_sr=new Array; 
  for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null) { document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src;  x.src=a[i+2]; }
}

function MM_findObj(n, d) 
{ //v4.01
  var p,i,x;  
  if(!d) d=document; 
  if((p=n.indexOf("?"))>0&&parent.frames.length) { d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p); }
  if(!(x=d[n])&&d.all) x=d.all[n]; 
  for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}


function checkCPF(prCPF) {
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
		if(!auxBoolean) { return false; }
		
		var x = 0;
		var soma = 0;
		var dig1 = 0;
		var dig2 = 0;
		var texto = "";
		var strCPFaux = "";
		var len = prCPF.length;
		var strAux1, strAux2;
		
   	    if (len < 11) {	return false; }
		
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
			else { 	return false; }
		}
	}	
	else return false;
}


/* Funções de validação de CPF e CNPJ */
function checkCNPJ(prCNPJ){
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
		/*if (!retorno) { if (prAviso) alert("CNPJ Inválido"); }*/
	}
	else retorno = false;
	return retorno;
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

function formatData(prValor){
        var v = prValor;
        if (v.match(/^\d{2}$/) !== null) {
            this.value = v + '/';
        } else if (v.match(/^\d{2}\/\d{2}$/) !== null) {
            this.value = v + '/';
        }
		return false;
}

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

<!-- /script -->