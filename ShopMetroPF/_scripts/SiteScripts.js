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



function isMail(form, campo)
{
  var re = new RegExp, arr, strMail;

  strMail = eval('document.' + form +  '.' + campo + '.value');
  re = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  arr = re.exec(strMail);
  if (arr == null) { return false; /*alert('E-mail inválido'); */ }
  else { return true; }
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
<!-- /script -->