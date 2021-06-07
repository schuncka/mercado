<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->




<html>
<head>
<title>Mercado</title>
<script src="../../metro-calendar.js"></script>
<script src="../../metro-datepicker.js"></script>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>

<%
	response.Write("resultado do envio: " &request("dbvar_str_cod_status_preco"))
      
%>
<body>

<script language="javascript" type="text/javascript">

const testeId = (prForm,prPrefixo, prCampoRetorno) => { 
      var valorSelecionado = '';
      var check = document.getElementById(prForm).elements;
      for( i = 0; i < check.length; i++) {
            if (check[i].nodeName === "INPUT" && check[i].type === "checkbox" && check[i].checked === true){
                 // alert(prPrefixo + ': ' + check[i].id.indexOf(prPrefixo));
                 if(check[i].id.indexOf(prPrefixo)!=-1){ 
                        valorSelecionado += check[i].value +  ',';
                }
            }
      }   
         valorSelecionado = valorSelecionado.substr(0,(valorSelecionado.length - 1));
         document.getElementById(prCampoRetorno).value = valorSelecionado;
        // console.log(valorSelecionado);
         //return valorSelecionado;
}
</script>

<!--<form name="forminsert" id="forminsert" action="../../_database/athinserttodb.asp" method="post"> -->

<form id="teste" name="teste" action="form_teste.asp" method="post">

       <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_295" value="295"> APOIO <br /> <br>
      
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco1_296" value="296" onclick="testeId('teste','cod_status_preco1','cod_status_preco');"> Espaço Oportunidade e Startups <br /> <br>
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco1_297" value="297" onclick="testeId('teste','cod_status_preco1','cod_status_preco');">  Expositor <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco1_298" value="298" onclick="testeId('teste','cod_status_preco1','cod_status_preco');">  MONTADOR <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco1_299" value="299" onclick="testeId('teste','cod_status_preco1','cod_status_preco');"> Patrocinador <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco1_311" value="311" onclick="testeId('teste','cod_status_preco1','cod_status_preco');">  Rodada de Negócios <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco1_306" value="306" onclick="testeId('teste','cod_status_preco1','cod_status_preco');">  SERVIÇOS <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco1_308" value="308" onclick="testeId('teste','cod_status_preco1','cod_status_preco');">  TESTE <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco1_307" value="307" onclick="testeId('teste','cod_status_preco1','cod_status_preco');">  VIGIA <br /> <br>
<hr>

            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco2_296" value="1" onclick="testeId('teste','cod_status_preco2','obrigatorio');"> >>>>>Espaço Oportunidade e Startups <br /> <br>
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco2_297" value="2" onclick="testeId('teste','cod_status_preco2','obrigatorio');"> >>>>> Expositor <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco2_298" value="3" onclick="testeId('teste','cod_status_preco2','obrigatorio');"> >>>>> MONTADOR <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco2_299" value="4" onclick="testeId('teste','cod_status_preco2','obrigatorio');"> >>>>>> Patrocinador <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco2_311" value="5" onclick="testeId('teste','cod_status_preco2','obrigatorio');"> >>>>> Rodada de Negócios <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco2_306" value="6" onclick="testeId('teste','cod_status_preco2','obrigatorio');"> >>>>> SERVIÇOS <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco2_308" value="7" onclick="testeId('teste','cod_status_preco2','obrigatorio');"> >>>>> TESTE <br /> <br>            
            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_cod_status_preco2_307" value="8" onclick="testeId('teste','cod_status_preco2','obrigatorio');"> >>>>> VIGIA <br /> <br>


<hr>
cod_status_preco :  <input type="text" id="cod_status_preco"><br>
cod_status_preco2 : <input type="text" id="obrigatorio"><br>



            <input type="submit" value="enviar"/>
         
</form>

<script>


</script>
</body>
</html>
