<script language="JavaScript">
<!--
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


//-->
</script>

