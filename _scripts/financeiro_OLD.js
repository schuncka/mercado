<SCRIPT LANGUAGE="JavaScript">

<!-- // para browsers sem suporte a java script

function check_cpf (StrCPF) {
x = 0;
soma = 0;
dig1 = 0;
dig2 = 0;
texto = "";
StrCPF1="";
len = StrCPF.length;
x = len -1;
for (var i=0; i <= len - 3; i++) {
  y = StrCPF.substring(i,i+1);
  soma = soma + ( y * x);
  x = x - 1;
  texto = texto + y;
}

dig1 = 11 - (soma % 11);
if (dig1 == 10) dig1=0 ;
if (dig1 == 11) dig1=0 ;
StrCPF1 = StrCPF.substring(0,len - 2) + dig1 ;
x = 11; soma=0;
for (var i=0; i <= len - 2; i++) {
  soma = soma + (StrCPF1.substring(i,i+1) * x);
  x = x - 1;
}
dig2= 11 - (soma % 11);
if (dig2 == 10) dig2=0;
if (dig2 == 11) dig2=0;
if ((dig1 + "" + dig2) == StrCPF.substring(len,len-2)) {
//  alert ("Número do CPF Válido !");
  return true;
}

alert ("Número do CPF Inválido !");
//document.formgeral.var_cnpj.focus();
return false;
}


function check_cgc (StrCGC)
{
var varFirstChr = StrCGC.charAt(0);
var vlMult,vlControle,s1, s2 = "";
var i,j,vlDgito,vlSoma = 0;

for ( var i=0; i<=13; i++ ) {
  var c = StrCGC.charAt(i);
  if( ! (c>="0")&&(c<="9") ) {
    alert("Número do CGC Inválido !");
//    document.formgeral.var_cnpj.focus();
    return false; 
  }
  if( c!=varFirstChr ) { vaCharCGC = true; }
}

if( ! vaCharCGC ) {
  alert("Número do CGC Inválido !");
//  document.formgeral.var_cnpj.focus();
  return false ;
}

s1 = StrCGC.substring(0,12);
s2 = StrCGC.substring(12,15);
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

if( vlControle != s2 ) {
  alert("Número do CGC Inválido !");
//  document.formgeral.var_cnpj.focus();
  return false;
  return false;
}
else {
//  alert("Número do CGC Válido !");
  return true;
}


}


function validaCGC_CPF(campo) {

//var StrData = document.formgeral.var_cnpj.value;
var StrData = campo;

rExp = '.';
StrData = StrData.replace(rExp, '');
rExp = '.';
StrData = StrData.replace(rExp, '');
rExp = '/';
StrData = StrData.replace(rExp, '');
rExp = '-';
StrData = StrData.replace(rExp, '');

var CGCPat = /^(\d{2}).(\d{3}).(\d{3})\/(\d{4})-(\d{2})/;
var CGCPat2 = /^(\d{14})/;
var CPFPat = /^(\d{3}).(\d{3}).(\d{3})-(\d{2})/;
var CPFPat2 = /^(\d{11})/;

var matchCGCArray = StrData.match(CGCPat);
var matchCGCArray2 = StrData.match(CGCPat2);
var matchCPFArray = StrData.match(CPFPat);
var matchCPFArray2 = StrData.match(CPFPat2);

if (matchCGCArray == null && matchCGCArray2 == null && matchCPFArray == null && matchCPFArray2 == null) {
    cpfalert = 'O número do CPF deve ser informado com 11 dígitos.\nExemplo: 000.000.000-00 ou 00000000000\n\n';
    cgcalert = 'O número do CNPj deve ser informado com 14 dígitos.\nExemplo: 00.000.000\/0000-00 ou 00000000000000';
    alert('Você deve fornecer um CNPj ou um CPF válido!\n\n' + cpfalert + cgcalert);
    return false;
    return false;
  }
  else if(matchCGCArray != null) {
    StrData = matchCGCArray[1] + matchCGCArray[2] + matchCGCArray[3] +
    matchCGCArray[4] + matchCGCArray[5] ;
    check_cgc(StrData);
  }
  else if(matchCGCArray2 != null) {
    StrData = matchCGCArray2[1];
    check_cgc(StrData);
  }
  else if(matchCPFArray != null) {
    StrData = matchCPFArray[1] + matchCPFArray[2] + matchCPFArray[3] +
    matchCPFArray[4];
    check_cpf(StrData);
  }
  else if(matchCPFArray2 != null) {
    StrData = matchCPFArray2[1];
    check_cpf(StrData);
  }
  return false;
}

		
		
function validaonlyCPF(campo) {

//var StrData = document.formgeral.var_cnpj.value;
var StrData = campo;

rExp = '.';
StrData = StrData.replace(rExp, '');
rExp = '.';
StrData = StrData.replace(rExp, '');
rExp = '-';
StrData = StrData.replace(rExp, '');

var CPFPat = /^(\d{3}).(\d{3}).(\d{3})-(\d{2})/;
var CPFPat2 = /^(\d{11})/;

var matchCPFArray = StrData.match(CPFPat);
var matchCPFArray2 = StrData.match(CPFPat2);

if (matchCPFArray == null && matchCPFArray2 == null) {
    cpfalert = 'O número do CPF deve ser informado com 11 dígitos.\nExemplo: 000.000.000-00 ou 00000000000\n\n';
    alert('Você deve fornecer um CPF válido!\n\n' + cpfalert);
    return false;
  }
  else if(matchCPFArray != null) {
    StrData = matchCPFArray[1] + matchCPFArray[2] + matchCPFArray[3] +
    matchCPFArray[4];
    return check_cpf(StrData);
  }
  else if(matchCPFArray2 != null) {
    StrData = matchCPFArray2[1];
    return check_cpf(StrData);
  }
  return true;
}
 
function validaCPF() {
var cpf = document.formgeral.var_cnpj.value;
var erro = new String;
var retorno = true;

   retorno = validaonlyCPF(cpf);
   rExp = '.';
   cpf = cpf.replace(rExp, '');
   rExp = '.';
   cpf = cpf.replace(rExp, '');
   rExp = '-';
   cpf = cpf.replace(rExp, '');
  
   if ((cpf.length != 11) || cpf == "00000000000" || cpf == "11111111111" || cpf == "22222222222" || cpf == "33333333333" || cpf == "44444444444" || cpf == "55555555555" || cpf == "66666666666" || cpf == "77777777777" || cpf == "88888888888" || cpf == "99999999999"){
     alert("Número de CPF inválido!");
	 retorno = false;
   }
	
   if (!retorno)  {
     document.formgeral.var_cnpj.value="";
     document.formgeral.var_cnpj.focus();
	 return false;
   }
   return true;		
}

function validaonlyCNPJ(campo) {

//var StrData = document.formgeral.var_cnpj.value;
var StrData = campo;

rExp = '.';
StrData = StrData.replace(rExp, '');
rExp = '.';
StrData = StrData.replace(rExp, '');
rExp = '/';
StrData = StrData.replace(rExp, '');
rExp = '-';
StrData = StrData.replace(rExp, '');

var CNPJPat = /^(\d{2}).(\d{3}).(\d{3})\/(\d{4})-(\d{2})/;
var CNPJPat2 = /^(\d{14})/;

var matchCNPJArray = StrData.match(CNPJPat);
var matchCNPJArray2 = StrData.match(CNPJPat2);

if (matchCNPJArray == null && matchCNPJArray2 == null) {
    cnpjalert = 'O número do CNPJ deve ser informado com 14 dígitos.\nExemplo: 00.000.000/0000-00 ou 00000000000000\n\n';
    alert('Você deve fornecer um CNPJ válido!\n\n' + cnpjalert);
    return false;
  }
  else if(matchCNPJArray != null) {
    StrData = matchCNPJArray[1] + matchCNPJArray[2] + matchCNPJArray[3] +
    matchCNPJArray[4];
    return check_cgc(StrData);
  }
  else if(matchCNPJArray2 != null) {
    StrData = matchCNPJArray2[1];
    return check_cgc(StrData);
  }

return false;

}

function validaCNPJ() {
var cnpj = document.formgeral.var_cnpj.value;
var erro = new String;
var retorno = true;

   retorno = validaonlyCNPJ(cnpj);
   rExp = '.';
   cnpj = cnpj.replace(rExp, '');
   rExp = '.';
   cnpj = cnpj.replace(rExp, '');
   rExp = '/';
   cnpj = cnpj.replace(rExp, '');
   rExp = '-';
   cnpj = cnpj.replace(rExp, '');
  
   if ((cnpj.length != 14) || cnpj.string == "00000000000000" || cnpj == "11111111111111" || cnpj == "22222222222222" || cnpj == "33333333333333" || cnpj == "44444444444444" || cnpj == "55555555555555" || cnpj == "66666666666666" || cnpj == "77777777777777" || cnpj == "88888888888888" || cnpj == "99999999999999"){
     alert("Número de CNPJ inválido!");
	 retorno = false;
   }
	
   if (!retorno)  {
     document.formgeral.var_cnpj.value="";
     document.formgeral.var_cnpj.focus();
	 return false;
   }
   return retorno;		
}



function validaCNPJ_RF(valor) {
		CNPJ = valor;

		CNPJ = CNPJ.replace('.', '');
		CNPJ = CNPJ.replace('.', '');
		CNPJ = CNPJ.replace('/', '');
		CNPJ = CNPJ.replace('-', '');
		
		erro = new String;
		if ( (CNPJ.length != 14) || (CNPJ = '00000000000000') ){ 
			erro = "O número do CNPJ deve ser informado com 14 dígitos.\nExemplo: 00.000.000/0000-00 ou 00000000000000\n";
			alert(erro);
			return false;
		}		
		var nonNumbers = /\D/;
		if (nonNumbers.test(CNPJ)){ 
			erro = "A verificação de CNPJ suporta apenas números!";
			alert(erro);
			return false;
		}
		var a = [];
		var b = new Number;
		var c = [6,5,4,3,2,9,8,7,6,5,4,3,2];
		for (i=0; i<12; i++){
			a[i] = CNPJ.charAt(i);
			b += a[i] * c[i+1];
		}
		if ((x = b % 11) < 2) { a[12] = 0 } else { a[12] = 11-x }
		b = 0;
		for (y=0; y<13; y++) {
			b += (a[y] * c[y]); 
		}
		if ((x = b % 11) < 2) { a[13] = 0; } else { a[13] = 11-x; }
		if ((CNPJ.charAt(12) != a[12]) || (CNPJ.charAt(13) != a[13])){
			erro ="Dígito verificador do CNPJ não confere!";
			alert(erro);
			return false;
		}

	return true;
}


//-->

</SCRIPT>
