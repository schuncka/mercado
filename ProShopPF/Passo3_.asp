<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->
<%
 
  
Dim objConn, objRS, objLang, strSQL 'banco
Dim arrScodi,arrSdesc 'controle
Dim strLng, strLOCALE
Dim strCOD_EVENTO, strCategoria
Dim strLinkDefault, i
Dim strTitulo, strDescricao, strCodProd, dblDescontoPromo, dblVlrFixoPromo, strCodProdPromo, flagCodigoPromo, dblValorProduto
Dim strCodigoPromo, dblDescontoProduto, dblVlrFixo, objRSPromo
Dim strEV_NOME,strDtInicio, strDtFim, strHrInicio, strHrFim, strLogradouroEv,  strBairroEv, strCidadeEv, strEstadoEv, strCEPEv,strPaisEv, strPavilhao
Dim arrCampos  ,strcodInscricao,strCOD_FORMAPGTO,strCOD_EMPRESA,strValorComprado,dblValorInscricao


strLng		    = getParam("lng") 'BR, [US ou EN], ES
CFG_DB          = getParam("db")
strCOD_EVENTO   = getParam("cod_evento")
strCategoria    = getParam("var_categoria")
strCodProd      = getParam("cod_prod")
dblValorProduto = getParam("vlr_prod")
strcodInscricao = getParam("var_cod_inscricao")
strCOD_EMPRESA   = getParam("var_cod_empresa")
strCOD_FORMAPGTO = getParam("var_cod_formapgto")
dblValorInscricao = getParam("var_valor_comprado")



AbreDBConn objConn, CFG_DB 


'BUSCA DADOS DO EVENTO
	strSQL =  " SELECT    e.COD_EVENTO "
	strSQL = strSQL & " , e.NOME "
	strSQL = strSQL & " , e.nome_completo "
	strSQL = strSQL & " , e.dt_inicio "
	strSQL = strSQL & " , e.dt_fim "
	strSQL = strSQL & " , e.descricao "
	strSQL = strSQL & " , e.logradouro "
	strSQL = strSQL & " , e.bairro "
	strSQL = strSQL & " , e.pais "
	strSQL = strSQL & " , e.cidade "
	strSQL = strSQL & " , e.estado_evento "
	strSQL = strSQL & " , e.cep_evento "
	strSQL = strSQL & " , e.pavilhao "	
	strSQL = strSQL & " FROM tbl_EVENTO e LEFT OUTER JOIN tbl_MOEDA M ON (E.COD_MOEDA_EVENTO = M.COD_MOEDA) "
	strSQL = strSQL & " WHERE cod_evento = " & strCOD_EVENTO
'response.Write(strSQL)
set objRS = objConn.Execute(strSQL)

If not objRs.EOF then
	strPavilhao         = getValue(objRS,"pavilhao")
	strDtInicio			= getValue(objRS,"dt_inicio")
	strDtFim			= getValue(objRS,"dt_fim")
	strLogradouroEv 	= getValue(objRS,"logradouro")
	strBairroEv 		= getValue(objRS,"bairro")
	strPaisEv 			= getValue(objRS,"pais")
	strCidadeEv 		= getValue(objRS,"cidade")
	strEstadoEv 		= getValue(objRS,"estado_evento")
	strCEPEv 			= getValue(objRS,"cep_evento")
    strEV_NOME = objRS("NOME_COMPLETO")&""
end if
'  CFG_DB         = getParam("db")
' 
' if CFG_DB = "" Then  ' -------------------------------------------------------------------------------------------------------
'	 CFG_DB = Request.Cookies("pVISTA")("DBNAME") 					'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
'	 if ( (CFG_DB = Empty) OR (Cstr(CFG_DB) = "") ) then
'		auxStr = lcase(Request.ServerVariables("PATH_INFO"))      	'retorna: /aspsystems/virtualboss/proevento/login.asp ou /proevento/login.asp
'		response.Write(auxStr)
'		auxStr = Mid(auxStr,1,inStr(auxStr,"/proshoppf/Passo3_.asp")-1) 	'retorna: /aspsystems/virtualboss/proevento ou /proevento
'		auxStr = replace(auxStr,"/aspsystems/_pvista/","")        	'retorna: proevento ou /proevento
'		auxStr = replace(auxStr,"/","")                           	'retorna: proevento
'		CFG_DB = auxStr + "_dados"
'		CFG_DB = replace(CFG_DB,"_METRO_dados","METRO_dados") 	'Caso especial, banco do ambiente /_pvista não tem o "_" no nome "
'		Response.Cookies("sysMetro")("DBNAME") = CFG_DB			'cfg_db nao esta vazio grava no cookie
'	 end if 
'End If
 ' ----------------------------------------------------------------------------------------------------------

' --------------------------------------------------------------------------------
 ' INI: LANG - tratando o Lng que por padrão pVISTA é diferente de LOCALE da função
 Select Case ucase(strLng)
	Case "BR"		
		strLOCALE = "pt-br"
		arrCampos  ="var_nome|var_sobrenome|var_end_numero|var_email|var_fone|var_tipo_pagamento|var_numeracao|var_num_cartao|var_cod_cartao|var_mes_cartao|var_ano_cartao|var_nome_titular|var_data_nasc_titular|var_cpf_titular|var_cel_ddd_titular|var_cel_titular|var_parcelas|var_razao_social|var_tipo_doc|var_num_doc1|var_num_doc2|var_pais|var_cep|var_endereco|var_end_cidade|var_end_bairro|var_endereco|var_cep"
	Case "US","EN","INTL"	
		strLOCALE = "en-us" 'colocar idioma INTL
		arrCampos  ="var_nome|var_sobrenome|var_end_numero|var_email|var_fone|var_tipo_pagamento|var_numeracao|var_num_cartao|var_cod_cartao|var_mes_cartao|var_ano_cartao|var_nome_titular|var_data_nasc_titular|var_cpf_titular|var_cel_ddd_titular|var_cel_titular|var_parcelas|var_razao_social|var_tipo_doc|var_num_doc1|var_num_doc2|var_pais|var_cep|var_endereco|var_end_cidade|var_end_bairro|var_endereco|var_cep"
	Case "SP","ES"		
		strLOCALE = "es"
		arrCampos  ="var_nome|var_sobrenome|var_end_numero|var_email|var_fone|var_tipo_pagamento|var_numeracao|var_num_cartao|var_cod_cartao|var_mes_cartao|var_ano_cartao|var_nome_titular|var_data_nasc_titular|var_cpf_titular|var_cel_ddd_titular|var_cel_titular|var_parcelas|var_razao_social|var_tipo_doc|var_num_doc1|var_num_doc2|var_pais|var_cep|var_endereco|var_end_cidade|var_end_bairro|var_endereco|var_cep"
	Case Else 
		strLOCALE = "pt-br"
		arrCampos  ="var_nome|var_sobrenome|var_end_numero|var_email|var_fone|var_tipo_pagamento|var_numeracao|var_num_cartao|var_cod_cartao|var_mes_cartao|var_ano_cartao|var_nome_titular|var_data_nasc_titular|var_cpf_titular|var_cel_ddd_titular|var_cel_titular|var_parcelas|var_razao_social|var_tipo_doc|var_num_doc1|var_num_doc2|var_pais|var_cep|var_endereco|var_end_cidade|var_end_bairro|var_endereco|var_cep"
 End Select
 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang strLOCALE,"../_lang/proshoppf/"
' FIM: LANG (ex. de uso: response.wrire(objLang.SearchIndex("area_restrita",0)) 



  strSQL =          " SELECT EF.COD_FORMAPGTO, EF.ID_LOJA, EF.CEDENTE, EF.RAZAO_SOCIAL, EF.ENDERECO, EF.CNPJ, EF.AGENCIA, EF.DV_AGENCIA, EF.CONTA, EF.DV_CONTA, EF.CARTEIRA, EF.COD_CONTRATO, EF.PARCELAS, EF.PARCELA_VLR_MINIMO, EF.INSTRUCOES, EF.DT_LIMITE_VCTO, EF.COD_MOEDA_COBRANCA, FP.URL_ENTRADA, EF.ASSINATURA, FP.FORMAPGTO_FULL, EF.NUM_DIAS_VCTO, EF.CAPTURA "
  strSQL = strSQL & "   FROM tbl_EVENTO_FORMAPGTO EF, tbl_FORMAPGTO FP"
  strSQL = strSQL & "  WHERE EF.COD_FORMAPGTO = FP.COD_FORMAPGTO"
  strSQL = strSQL & "    AND EF.EXIBIR_LOJA = 1"
  strSQL = strSQL & "    AND (EF.COD_PAIS IS NULL OR EF.COD_PAIS = '" & strLng & "')"
  strSQL = strSQL & "    AND (EF.TIPO = 'PF' OR EF.TIPO IS NULL)"
 ' strSQL = strSQL & "    AND (" & Replace(Replace(strVALOR_CONVERTIDO,".",""),",",".") & " >= EF.VALOR_MIN OR EF.VALOR_MIN  IS NULL)"
  strSQL = strSQL & "    AND EF.COD_EVENTO = " & strCOD_EVENTO
  strSQL = strSQL & "    ORDER BY FP.FORMAPGTO LIMIT 1"
  
 ' response.Write(strSQL&"<BR>")
  
  Set objRS = objConn.Execute(strSQL)
  'Do While not objRS.EOF
    strCOD_FORMAPGTO = getvalue(objRS,"COD_FORMAPGTO")
  'loop


 ' -------------------------------------------------------------------------------
 ' INI: Busca dados relativos as informações de ambiente do sistema (SITE_INFO)

 ' Cookies de ambiente PAX (não optamos por session, pq expira muito fácil/rápido e cokies são acessíveis fora da caixa de areia ------------------------------- '
 Response.Cookies("METRO_ProShopPF").Expires = DateAdd("h",2,now)
 Response.Cookies("METRO_ProShopPF")("locale")	  = strLOCALE


%>
<!DOCTYPE html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <!--meta charset="utf-8"//-->
    <meta name="viewport"    content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="product"     content="PRO MetroUI  Framework">
    <meta name="description" content="Simple responsive css framework">
    <meta name="author" 	 content="Sergey P. - adapted by Aless">

    <link href="./_metroUI/css/metro-bootstrap.css" rel="stylesheet">
    <link href="./_metroUI/css/metro-bootstrap-responsive.css" rel="stylesheet">
    <link href="./_metroUI/css/iconFont.css" rel="stylesheet">
    <link href="./_metroUI/css/docs.css" rel="stylesheet">
    <link href="./_metroUI/js/prettify/prettify.css" rel="stylesheet">
    <!-- Load JavaScript Libraries -->
    <script src="./_metroUI/js/jquery/jquery.min.js"></script>
    <script src="./_metroUI/js/jquery/jquery.widget.min.js"></script>
    <script src="./_metroUI/js/jquery/jquery.mousewheel.js"></script>
    <script src="./_metroUI/js/prettify/prettify.js"></script>

    <!-- PRO  MetroUI  JavaScript plugins -->
    <script src="./_metroUI/js/load-metro.js"></script>

    <!-- Local JavaScript -->
    <script src="./_metroUI/js/docs.js"></script>
    <script src="./_metroUI/js/github.info.js"></script>

    <!-- Tablet Sort -->
	<script src="./_metroUI/js/tablesort_metro.js"></script>
    <script src="./_scripts/SiteScripts.js"></script>

    <% If request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId") <> "" Then %>	
    <!-- Google Tag Manager -->
    <script>
    (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','<%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId")%>');
    </script>
    <!-- End Google Tag Manager -->
    <% End If %>

    <script language="javascript">

function checkCreditCardFlag(cardNumber){
	
	document.getElementById('band_visa').style.opacity = 0.3;
	document.getElementById('band_master').style.opacity = 0.3;
	document.getElementById('band_amex').style.opacity = 0.3;
	 
    var isValid = false;
    var ccCheckRegExp = /[^\d ]/;
    isValid = !ccCheckRegExp.test(cardNumber);

    var cardNumbersOnly = cardNumber.replace(/ /g,"");
    var cardNumberLength = cardNumbersOnly.length;
    var lengthIsValid = false;
    var prefixIsValid = false;
    var prefixRegExp;

	//Master
    prefixRegExp = /^5[0-9][0-9]{14}/;
    prefixIsValid = prefixRegExp.test(cardNumbersOnly);
	if(prefixIsValid) { document.getElementById("bandeira").value = 'MASTER'; document.getElementById('band_master').style.opacity = 1; }

	//Visa
    prefixRegExp = /^4[0-9]{12}(?:[0-9]{3})?/;
    prefixIsValid = prefixRegExp.test(cardNumbersOnly);
	if(prefixIsValid) { document.getElementById("bandeira").value = 'VISA'; document.getElementById('band_visa').style.opacity = 1; }

	//Amex
    prefixRegExp = /^3[47][0-9]{13}/;
    prefixIsValid = prefixRegExp.test(cardNumbersOnly);
	if(prefixIsValid) { document.getElementById("bandeira").value = 'AMEX'; document.getElementById('band_amex').style.opacity = 1; }

	
}
function validaBandeira(cardNumber){

  var regexVisa = /^4[0-9]{12}(?:[0-9]{3})?/;
  var regexMaster = /^5[1-5][0-9]{14}/;
  var regexAmex = /^3[47][0-9]{13}/;
  var regexDiners = /^3(?:0[0-5]|[68][0-9])[0-9]{11}/;
  var regexDiscover = /^6(?:011|5[0-9]{2})[0-9]{12}/;
  var regexJCB = /^(?:2131|1800|35\d{3})\d{11}/;

  if(regexVisa.test(cardNumber)){
   document.getElementById("bandeiraCartao").src = "./img/bepaycard.gif";
   document.getElementById("bandeiraCartao").style.visibility = "visible";
  }
  if(regexMaster.test(cardNumber)){
   document.getElementById("bandeiraCartao").src = "./img/bepaycard.gif";
   document.getElementById("bandeiraCartao").style.visibility = "visible";
  }
  if(regexAmex.test(cardNumber)){
   return 'amex';
  }
  if(regexDiners.test(cardNumber)){
   return 'diners';
  }
  if(regexDiscover.test(cardNumber)){
   return 'discover';
  }
  if(regexJCB.test(cardNumber)){
   return 'jcb';
  }

  return 'Cartão não reconhecido';

}


function validaCampoPeloId2(formID, prPrefixoIgnorar) {
        var Ok = true;
        var elementos = document.getElementById(formID).elements;
		
		var str
if (prPrefixoIgnorar =='boleto'){prPrefixoIgnorar='cartao'}
		//alert(prPrefixoIgnorar);
	 if (prPrefixoIgnorar == "cartao"){
        for (var i=0; i< elementos.length; i++) {
		//alert(prPrefixoIgnorar);
			 if (elementos[i].id.indexOf(prPrefixoIgnorar) != -1 ){
			// alert(prPrefixoIgnorar);
				str = elementos[i].id
				elementos[i].id = str.replace("ô","");	 				 
			 }
		}
	  }
      for (var i=0; i< elementos.length; i++) {
			if ((elementos[i].id.indexOf("ô")!=-1)) {
                if (elementos[i].value == "") { 
                    elementos[i].style.backgroundColor="#FFFFCC";                    
                    Ok = false;    
                } 
				else {elementos[i].style.backgroundColor="#FFFFFF"; }
			}
		}
         if (Ok == false) {
             alert("Favor preencher os campos obrigatórios.");
        }    
        return Ok;        
}


function submeterPagamento(){
	
	var data = $('#dados_pagamento').serializeArray();
		
         arrResult = document.getElementById("var_tipo_pagamento").value.split("|");
		//if (validaCelular($("#<%="cartao_"&tornaCampoObrigatorio(arrCampos, "var_cel_titular")%>").val())==false){return false} 
		
        if(validaCampoPeloId2("dados_pagamento",arrResult[0])){ 
            
		
		$(document).ready(function() {
			$.ajax({ type: "POST"
					, url: "./ajax/pagamentoCartaobePay.asp"
					, data: data
					, success: function(result){
		var resultado = result;						
							var arrReturn = result.split("|"); 
							console.clear;
							console.log(resultado);
							
							if (arrReturn[3] !="APPROVED" && arrReturn[3] !="CREATED"){
								document.getElementById("retornoCartao").style.visibility = "visible";
								if (arrReturn[4].indexOf("mobilePhones") > 0){
									document.getElementById("txtRetornoCartao").innerHTML = "Número de telefone celular inválido!"
								}else{
									document.getElementById("txtRetornoCartao").innerHTML = arrReturn[3] + ": " + arrReturn[4];
								}
							}
							
							//arrResult = result.split("|");								
							//if(arrResult[0] == 'error') {								
							//	return false;
							
							if (arrReturn[3] =="APPROVED" || arrReturn[3]=="CREATED"){		
							//document.getElementById("var_linha_digitavel").value = 
							//alert("pagamento ok");
							//document.getElementById("var_tp_pagamento").value = arrResult[1];
							//document.getElementById("var_cod_formapgto").value = arrResult[2];
							document.getElementById("var_linha_digitavel").value = arrReturn[6];
							document.getElementById("var_linha_digitavel").select();
							document.execCommand("copy");
							document.getElementById("var_link_boleto").value = arrReturn[5];
							$.Notify({style: {background: 'green', color: 'white'}, content: "<%=objLang.SearchIndex("enviando_dados",0)%>...", timeout: 10000, shadow: true});		
							document.getElementById("dados_pagamento").submit();
						   }
					}});
		});	
	
       }else{return false;} 

} 


function validaCPF(prCPF){
    if (prCPF == ""){return false;}

        if (!checkCPF(prCPF)){
            alert("CPF Invalido");
            $("#<%="cartao_"&tornaCampoObrigatorio(arrCampos, "var_cpf_titular")%>").val("")
            return false;
        }
}

function cpfValida(prCPF){
if (prCPF== ""){return false; }
	if (!checkCPF(prCPF)){
	alert("CPF Invalido");
	$("#<%=tornaCampoObrigatorio(arrCampos, "var_num_doc1")%>").val("");
	return false;
	}
}

function validaCNPJ(prCNPJ){
	if (prCNPJ == "") {return false;}

        if (!checkCNPJ(prCNPJ)) {
            alert("CNPJ Invalido");
            $("#<%=tornaCampoObrigatorio(arrCampos, "var_num_doc1")%>").val("");
            return false;
        }
}



function validaDocumento(prDocumento){
    
    if (prDocumento.length < 11 || prDocumento.length == 12 || prDocumento.length == 13 || prDocumento.length > 14) {
       alert("Número de documento inválido");
	   $("#<%=tornaCampoObrigatorio(arrCampos, "var_num_doc1")%>").val(""); 
    }

    if (prDocumento.length == 11){
       validaCPF(prDocumento); 
    }

    if (prDocumento.length == 14){
       validaCNPJ(prDocumento); 
    }

    return false;
}

function buscaDadoCep() {
	//'                   0                1                   2                3                  4  
	//  response.write(strENDER & "|" & strBAIRRO & "|" & strCIDADE & "|" & strESTADO & "|" & "BRASIL")	
	$(document).ready(function() {
		$.ajax({url: "./ajax/buscaCEP.asp?var_cep="+$("#<%=tornaCampoObrigatorio(arrCampos, "var_cep")%>").val(), success: function(result){																		
			console.log(result);
			arrResult = result.split("|");								
			if(arrResult[0] == 'error') {								
				return false;
			} else {		
									
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_endereco")%>").val(arrResult[20]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_end_bairro")%>").val(arrResult[23]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_end_cidade")%>").val(arrResult[24]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_end_estado")%>").val(arrResult[25]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_pais")%>").val(arrResult[26]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_end_numero")%>	").focus();
		   }
	    }});
    });	
	
}






function habilitaCardCred() {

var arrResult = document.getElementById("var_tipo_pagamento").value.split("|");	
//alert(arrResult[0]);
if ("cartao" == arrResult[0] ) {
    document.getElementById('dados_card').style='display:block; background-color:#EEE; padding:10px;'
    
    } else {
        document.getElementById('dados_card').style='display:none; background-color:#EEE; padding:10px;'
        
    };  
}
    </script>

    <title>pVISTA ProShopUI</title>
    <style>
        .indent {
            height: 40px;
        }
        .super-menu {
            position: fixed;
            top: 45px;
            left: 0;
            right: 0;
            z-index: 100;
        }
        .page {
            /*padding-top: 130px !important;*/
        }
        .super-menu li {
        }
        .super-menu a {
            text-decoration: underline;
        }
    </style>
<script language="JavaScript" type="text/javascript" src="_scripts/SiteScripts.js"></script>
</head>
<body class="metro" style="background-color:#F8F8F8">
<% If request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId") <> "" Then %>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=<%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId")%>" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<% End If %>
 <!-- INI: HeaderBAR --------------------------------------------------------------------- //-->
<div class="page-footer padding5" style="background-color:#282828;"></div>
 <!-- FIM: HeaderBAR --------------------------------------------------------------------- //-->

 <!-- INI: PAGE CONTAINER ------------------------------------------------------------- //-->
 <div class="page container"> <!-- container-phone | container-tablet | container-large //-->


    <!-- INI: page-header -------------------------------------------------------------- //--> 
    <div class="page-header">

		<!-- INI: LOGO Promotora //-->	
        <div class="grid" style="margin-bottom:35px">
             <div class="row">
                 <div class="span114" style="background-color:#FFF;"><!-- level 1 column //-->
                     <div sclass="row">
                         <img class="" src="../imgdin/<%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strCabecalhoLoja")%>" style="margin-bottom:15px;margin-top:15px;">
                     </div>
                 </div>
             </div>
             <div class="row">
                <div class="stepper rounded" data-steps="4" data-role="stepper" data-start="3" style="width:100%;"></div>
             </div>
        </div>
		<!-- FIM: LOGO Promotora //-->	
        
        
		<!-- INI: MENU  //-->	
        <div class="navigation-bar  dark">
            <div class="navbar-content">
                <div style="float: left; width: 40%;">
                    <a href="<%=strLinkDefault%>" class="element"><strong><%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strNomeEvento")%></strong></a>
                </div>
                <div style="float: right; width: 60%;">
                    <button class="command-button primary" style="float: right;padding: 8px;" onClick="javascript:buscaDadosPagador();;">
                        <!--i class="icon-share-2 on-left"></i-->
                        Autopreenchimento
                        <small>Se participante e pagador</small>
                    </button>
                </div>
            </div>
        </div>

		<!-- FIM: MENU  //-->	

	</div> 
    <!-- FIM: page-header -------------------------------------------------------------- //--> 


    <div class="page-region-content">
    
        <div class="grid">
             <div class="row">
						 <!-- INI: 1 COLUNA //-->
                         <div class="span10" style="text-align:left;">

                              

                                <form id="dados_pagamento" name="dados_pagamento" method="post" action="processa_pagamento.asp">
              
                                    <input type="hidden" id="db"                  name="db"                  value="<%=CFG_DB%>">
                                    <input type="hidden" id="lng"                 name="lng"                 value="<%=strLng%>">
                                    <input type="hidden" id="cod_evento"          name="cod_evento"          value="<%=strCOD_EVENTO%>">
                                    <input type="hidden" id="var_categoria"       name="var_categoria"       value="<%=strCategoria%>">
                                    <input type="hidden" id="var_cod_inscricao"   name="var_cod_inscricao"   value="<%=strCodInscricao%>">    
                                    <input type="hidden" id="var_cod_empresa"     name="var_cod_empresa"     value="<%=strCOD_EMPRESA%>">    
                                    <input type="hidden" id="var_cod_formapgto"   name="var_cod_formapgto"   value="<%=replace(strCOD_FORMAPGTO,"'","")%>">    
                                    <input type="hidden" id="var_tp_pagamento"    name="var_tp_pagamento"    value="">
                                    <input type="hidden" id="var_valor_comprado"  name="var_valor_comprado"  value="<%=dblValorInscricao%>">
									<input type="hidden"   id="var_linha_digitavel" name="var_linha_digitavel" value="">
									<input type="hidden"   id="var_link_boleto"     name="var_link_boleto"     value="">
                                    
                                    <fieldset>
                                        <legend><strong><%=objLang.SearchIndex("comprador",0)%></strong></legend>

                                        <label><%=objLang.SearchIndex("identificacao",0)%></label>
                                        <div class="input-control text size5" data-role="input-control">
                                            <input type="text" class="form-control" placeholder="<%=objLang.SearchIndex("placeholder_nome",0)%>" id="<%=tornaCampoObrigatorio(arrCampos,"var_nome")%>" name="var_nome" autofocus maxlength="49">
                                        </div>    

                                        <div class="input-control text size5" data-role="input-control">
                                            <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_nome_completo",0)%>" id="<%=tornaCampoObrigatorio(arrCampos, "var_sobrenome")%>" name="var_sobrenome" maxlength="50">
                                        </div>                                   
                                        
                                        <label><%=objLang.SearchIndex("e_mail",0)%></label>
                                        <div class="input-control text size6 " data-role="input-control">
                                            <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_email",0)%>" id="<%=tornaCampoObrigatorio(arrCampos, "var_email")%>" name="var_email"  maxlength="100">
                                        </div>
                                        <label><%=objLang.SearchIndex("cel_titular",0)%></label>
                                            <div class="input-control text size1" data-role="input-control" maxlength="3" >
                                                <input type="text" placeholder="DDD " id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_cel_ddd_titular")%>" name="var_cel_ddd_titular" >
                                            </div>
											
                                            <div class="input-control text size2" data-role="input-control">
                                                <input type="text" onBlur="javascript:validaCelular(this.value);" placeholder="<%=objLang.SearchIndex("placeholder_cel",0)%>" maxlength="11" id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_cel_titular")%>" name="var_cel_titular">
                                            </div>
                                        <label><%=objLang.SearchIndex("departamento3",0)%></label>
                                        <!--div class="input-control text size5 " data-role="input-control"-->
                                            <!--input type="text" placeholder="<%=objLang.SearchIndex("placeholder_fone",0)%>" id="<%=tornaCampoObrigatorio(arrCampos, "var_fone")%>" name="var_fone"  maxlength="15"/-->
                                        <!--/div-->
                                 
                                        <div class="input-control text size5" data-role="input-control">
                                            <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_departamento",0)%>" id="<%=tornaCampoObrigatorio(arrCampos, "var_departamento")%>" name="var_departamento" maxlength="100">
                                        </div>
										
										
                                    </fieldset>

                                    <fieldset>
                                        <legend><strong><%=objLang.SearchIndex("pagamento",0)%></strong></legend>
                                        <label><%=objLang.SearchIndex("formapagamento",0)%></label>
                                        <div class="input-control select size3">
                                            <select name="var_tipo_pagamento" id="var_tipo_pagamento" onChange="habilitaCardCred();return false;">
                                                <!--option value="empenho|empenho|<%=strCOD_FORMAPGTO%>"><%=objLang.SearchIndex("empenho",0)%></option-->
                                                <option value="boleto|boleto|8002"><%=objLang.SearchIndex("boleto",0)%></option-->
                                                <option value="cartao|cartao|8001"><%=objLang.SearchIndex("cartao_credito",0)%></option>                                                
                                            </select>
                                        </div>   
                                        
                                        <div id="dados_card" style="display:none; background-color:#EEE; padding:10px; ">
                                            <label><%=objLang.SearchIndex("numero_cartao",0)%></label>
                                            <div class="input-control text size3" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cartao",0)%>" id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_num_cartao")%>" name="var_cartao" autofocus maxlength="16" onBlur="checkCreditCardFlag(this.value)"  >
                                                <input type="hidden"  id="bandeira" name="var_bandeira" >
                                            </div>

                                            <div class="input-control text size1" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_csc",0)%>" id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_cod_cartao")%>" name="var_cod_cartao" maxlength="5" autofocus>
                                            </div>
                                            <div style="width:100%; padding: 5px;">
                                                <div id="band_visa" style="margin:auto; width:100px; height:100%; display:inline-block; opacity:0.3;"><img src="./img/band_visa.jpg" border="0"></div>
                                                <div id="band_master" style="margin:auto; width:100px; height:100%; display:inline-block; opacity:0.3;"><img src="./img/band_mastercard.jpg" border="0"></div>
                                                <div id="band_amex" style="margin:auto; width:100px; height:100%; display:inline-block; opacity:0.3;"><img src="./img/band_amex.jpg" border="0"></div>
                                            </div>                                        

                                            <label><%=objLang.SearchIndex("validade",0)%></label>
                                            <div class="input-control select size1">
                                                <select name="var_mes_cartao"id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_mes_cartao")%>">
                                                    <% for i=1 to 12 %>
                                                    <option value="<%=i%>"><%=i%></option>
                                                    <% next %>
                                                </select>
                                            </div>  
											
                                            <div class="input-control select size2">
                                                <select name="var_ano_cartao" id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_ano_cartao")%>">
                                                    <% for i=year(now) to year(now) + 12 %>
                                                       <option  value="<%=i%>"><%=i%></option>
                                                    <% next %>
                                                </select>
                                            </div> 
											
                                            <label><%=objLang.SearchIndex("titular",0)%></label>
                                            <div class="input-control text" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_nome_cartao",0)%>" id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_nome_titular")%>" name="var_nome_titular" maxlength="140">
                                            </div>
											
                                            <label><%=objLang.SearchIndex("dados_titular",0)%></label>
                                            <div class="input-control text size2" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_data_nasc",0)%>" id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_data_nasc_titular")%>" name="var_data_nasc_titular"maxlength="10" onKeyPress="Javascript:return validateNumKey(event);return false;"  onkeyup="var v = this.value;if (v.match(/^\d{2}$/) !== null) {this.value = v + '/';} else if (v.match(/^\d{2}\/\d{2}$/) !== null) {this.value = v + '/';}" onblur="javascript:buscaDadoContato(this);return false;"> 
                                            </div>
											
                                            <div class="input-control text size3" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cpf",0)%>" id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_cpf_titular")%>" name="var_cpf_titular" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="11" onBlur="Javascript:cpfValida(this.value);return false;">
                                            </div>
											
                                            

                                            <label><%=objLang.SearchIndex("parcelas",0)%></label>
                                            <div class="input-control select size1">
                                                <select id="cartao_<%=tornaCampoObrigatorio(arrCampos, "var_parcelas")%>" name="var_parcelas">
                                                    <% for i=1 to 10 %>
                                                    <option value="<%=i%>"><%=i%></option>
                                                    <% next %>
                                                </select>
                                            </div> 
                                            
                                        </div>
                                    </fieldset>

                                    <fieldset>
                                        <legend><strong><%=objLang.SearchIndex("info_cobrancas",0)%></strong></legend>

                                            <label><%=objLang.SearchIndex("razao_social_nome",0)%></label>
                                            <div class="input-control text " data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_razao_social_nome",0)%>" id="<%=tornaCampoObrigatorio(arrCampos, "var_razao_social")%>" name="var_razao_social">
                                            </div>


                                            <label><%=objLang.SearchIndex("tipo_doc",0)%></label>
                                                                                  
                                            <div class="input-control text size5" data-role="input-control" id="cpf">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_numero",0)%>" maxlength="14" onKeyPress="Javascript:return validateNumKey(event);return false;" onBlur="javascript:validaDocumento(this.value);"  id="<%=tornaCampoObrigatorio(arrCampos, "var_num_doc1")%>" name="var_num_doc1">
                                            </div> 
                                        
                                            <label><%=objLang.SearchIndex("cep",0)%></label>
                                            <div class="input-control text size2" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cep",0)%>" id="<%=tornaCampoObrigatorio(arrCampos, "var_cep")%>"  onKeyPress="Javascript:return validateNumKey(event);return false;"  name="var_cep" maxlength="8" onBlur="javascript:buscaDadoCep();">
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>
                                            <label><%=objLang.SearchIndex("endereco",0)%></label>
                                            <div class="input-control text " data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_end",0)%>"  id="<%=tornaCampoObrigatorio(arrCampos, "var_endereco")%>" name="var_endereco">
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>
                                            <label><%=objLang.SearchIndex("numero",0)%> / <%=objLang.SearchIndex("complemento",0)%></label>
                                            <div class="input-control text size5" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_numero",0)%>"  id="<%=tornaCampoObrigatorio(arrCampos, "var_end_numero")%>" name="var_end_numero" maxlength="5">
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>
                                            <div class="input-control text size5" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_complemento",0)%>"  id="<%=tornaCampoObrigatorio(arrCampos, "var_end_complemento")%>" name="var_end_complemento" maxlength="5">
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>

                                            <label><%=objLang.SearchIndex("bairro",0)%> / <%=objLang.SearchIndex("cidade",0)%> / <%=objLang.SearchIndex("estado",0)%></label>
                                            <div class="input-control text size3" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_bairro",0)%>"  id="<%=tornaCampoObrigatorio(arrCampos, "var_end_bairro")%>" name="var_end_bairro" maxlength="150">
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">
                                                <input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cidade",0)%>" id="<%=tornaCampoObrigatorio(arrCampos, "var_end_cidade")%>" name="var_end_cidade">
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div> 

                                            
                                            <div class="input-control select size3">
                                                <select id="<%=tornaCampoObrigatorio(arrCampos, "var_end_estado")%>" name="var_end_estado">
                                                <option value="" selected><%=objLang.SearchIndex("estado",0)%></option>
                                                 <%		                    
                                                     strSQL = "SELECT SIGLA_UF, NOME_UF FROM TBL_ESTADOS ORDER BY SIGLA_UF"
                                                     response.write(MontaComboReturn(strSQL, "SIGLA_UF", "NOME_UF", ""))
						                         %>  
                                                </select>
                                            </div>
                                            <label><%=objLang.SearchIndex("pais",0)%></label>
                                            	<div class="input-control select size5">
                                                    <select name="var_pais" id="<%=tornaCampoObrigatorio(arrCampos, "var_pais")%>">
                                                        <option value="" selected><%=objLang.SearchIndex("pais",0)%></option>
                                                            <% 			
                                                                strSQL =          " SELECT DISTINCT tbl_PAISES.PAIS, tbl_PAIS.PAIS AS COD_PAIS "
                                                                strSQL = strSQL & "   FROM tbl_PAIS, tbl_PAISES "
                                                                strSQL = strSQL & "  WHERE tbl_PAIS.ID_PAIS = tbl_PAISES.ID_PAIS"
                                                                strSQL = strSQL & "  ORDER BY ORDEM DESC, tbl_PAISES.PAIS  "
                                                                response.write(MontaComboReturn(strSQL, "COD_PAIS", "PAIS", ""))
                                                            %>  			
                                                    </select>
                                                </div>                                        

                                    </fieldset>
                                </form>

                                <!-- color button background-color:#C00; color:#FFFFFF; -->

								
								<div class="row" style="margin-top:15px;visibility:none;" id="retornoCartao">
                                    <div class="grid">
                                        <h4 id="txtRetornoCartao" class="fg-red"></h4>
                                    </div>
                                </div>
								
								
                                <form name="to_passo1" id="to_passo2" action="passo2_.asp" method="post">
                                    <input type="hidden" name="cod_evento" value="<%=strCOD_EVENTO%>">
                                    <input type="hidden" name="lng" value="<%=strLng%>">
                                    <input type="hidden" name="categoria" value="<%=strCategoria%>">
                                    <input type="hidden" name="db" value="<%=CFG_DB%>">
                                </form>
                                
                                <div class="row" style="margin-top:15px">
                                    <div class="grid">
                                        <div class="row">
                                            <div class="span2" style="margin-right: 20px !important;">
                                               <!--a href="Passo2_.asp"/-->
                                               <button class="button danger" style="padding: 10px; margin-bottom: 10px; width: 100%; border-radius: 5px;" onClick="javascript:document.getElementById('to_passo2').submit();">
                                                    <strong><%=objLang.SearchIndex("voltar",0)%></strong>
                                                </button>
                                                <!--/a/-->
                                            </div>
                                            <div class="span8"  style="margin-left: 0px;">
                                                <!--a href="Passo4_.asp" id="btn_avancar"/-->
                                                    <button class="button" style="padding: 10px; margin-bottom: 10px; width: 100%; border-radius: 5px; background-color: #090; color: #FFFFFF" onClick="javascript:submeterPagamento();">
                                                        <strong><%=objLang.SearchIndex("continuar",0)%></strong>
                                                    </button>
                                                <!--</a>/-->
                                            </div>
                                        </div>
                                    </div>
                                </div>


                         </div>
						 <!-- FIM: 1 COLUNA //-->


						 <!-- INI: 2 COLUNA //-->          
                         <div class="span4">    
                            <div class="grid">
                                 <div class="row">
                                    <div class="tile " style="width:100%; height:auto; margin:0 auto; margin-bottom:10px; 
                                                            background-color:#CCC; color:#666; text-align:right; 
                                                            padding-top:7px; padding-right:10px; padding-bottom:25px; border:1px solid #FFF;">
                                        <font size="+2"><span style="color:#009966;"><%=objLang.SearchIndex("evento",0)%></span></font>
                                        <br><br>
                                        <b><%=strEV_NOME%></b>
                                        <br>
                                        <% if year(strDtInicio) <> year(strDtFim) Then %> 

                                            <%=(objLang.SearchIndex("de ", 0))%><%=" "%><%=DAY(strDtInicio)%> (<%=objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtInicio)))),0)%>)
                                            <%=(objLang.SearchIndex("de ", 0))%><%=" "%> <%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtInicio)))),0)%> | <%=year(strDtInicio)%> 
                                            <%=(objLang.SearchIndex("a_craseado",0))%><%=" "%> <%=DAY(strDtFim)%> (<%=objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtFim)))),0)%>) 
                                            de <%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtFim)))),0)%> | <%=year(strDtFim)%><br>

                                        <% else if (month(strDtInicio) <> month(strDtFim)) AND year(strDtInicio) = year(strDtFim) Then %>
                                                <%=(objLang.SearchIndex("de ", 0))%><%=" "%> <%=DAY(strDtInicio)%> (<%=objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtInicio)))),0)%>)
                                                <%=(objLang.SearchIndex("de",0))%><%=" "%> <%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtInicio)))),0)%> <%=(objLang.SearchIndex("a_craseado",0))%>
                                                <%=" "%><%=DAY(strDtFim)%> (<%=objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtFim)))),0)%>) <%=(objLang.SearchIndex("de",0))%> 
                                                <%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtFim)))),0)%> | <%=year(strDtFim)%><br>
                                        <% else %>
                                                <%=(objLang.SearchIndex("de ", 0))%><%=" "%><%=DAY(strDtInicio)%> (<%=objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtInicio)))),0)%>) 
                                                <%=(objLang.SearchIndex("a_craseado",0))%><%=" "%><%=DAY(strDtFim)%> (<%=objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtFim)))),0)%>) 
                                                <%=(objLang.SearchIndex("de",0))%><%=" "%><%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtFim)))),0)%> | <%=year(strDtFim)%><br>
                                        <% end if %>
                                        <% end if %> 
                                                                 
                                    </div>
                                </div>
                                <div class="" style="text-align:left;">
                                    <%
                                        'session("METRO_ProShopPF_strgoogleMapsEvento") = "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3453.828106902864!2d-51.18828538436066!3d-30.041788938114816!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x95197823928efe6b%3A0x71b00d0d3e0c07be!2sRua+Jo%C3%A3o+Abbott+-+Petr%C3%B3polis%2C+Porto+Alegre+-+RS!5e0!3m2!1sen!2sbr!4v1523899730301'"
                                        if request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGoogleMapsEvento") <> "" Then %>
                                        <iframe src="<%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGoogleMapsEvento")%>"
                                                width="100%" height="400" frameborder="0" style="border:0" allowfullscreen>
                                        </iframe>
                                        
                                        
                                       <% End If %>
                                        <h3><b><%=strPavilhao%></b></h3>
                                        <p class="tertiary-text-secondary">
                                            <%=strLogradouroEv%><br>
                                            <%=strBairroEv%>, <%=strCidadeEv%> - <%=strEstadoEv%>, <%=strCEPEv%>
                                            <br><br>
                                            <small></small>
                                        </p>
                            </div>   
                        </div>
                        <!--/div//-->
                        <!-- FIM: 2 COLUNA //-->
             </div>
        </div>
    
    </div>  <!-- page-region-content //--> 
    
    


 </div> 
 <!-- FIM: PAGE CONTAINER ------------------------------------------------------------- //-->


 <!-- INI: Footer --------------------------------------------------------------------- //-->
 <!-- div class="page-footer padding5" style="background-color:#CCC; color:#FFF"></div //-->
 </div> <!-- esse div é importante para o efeito de rodapé que transpaça a área de container //-->
 <!--#include file="_include/IncludeFooter.asp" -->
 <!-- FIM: Footer --------------------------------------------------------------------- //-->


</body>
<script language="javascript">
function buscaDadosPagador() {
	//'                   0                1                   2                3                  4  
	//  response.write(strENDER & "|" & strBAIRRO & "|" & strCIDADE & "|" & strESTADO & "|" & "BRASIL")	

	$(document).ready(function() {
		$.ajax({url: "./ajax/buscaDadoCPFPagamento.asp?var_cod_empresa="+$("#<%=tornaCampoObrigatorio(arrCampos, "var_cod_empresa")%>").val(), success: function(result){																		
			//console.log(result);
			arrResult = result.split("|");								
			if(arrResult[0] == 'error') {								
				return false;
			} else {		
				
				var nome = arrResult[2];
				nome = nome.split(" ");
				$("#<%=tornaCampoObrigatorio(arrCampos,"var_nome")%>").val(nome[0]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_sobrenome")%>").val(nome[nome.length-1]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_email")%>").val(arrResult[1]);
				$("#cartao_<%=tornaCampoObrigatorio(arrCampos, "var_cel_ddd_titular")%>").val(arrResult[11]);
				$("#cartao_<%=tornaCampoObrigatorio(arrCampos, "var_cel_titular")%>").val(arrResult[12]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_departamento")%>").val(arrResult[17]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_razao_social")%>").val(arrResult[2]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_num_doc1")%>").val(arrResult[0]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_cep")%>").val(arrResult[27]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_endereco")%>").val(arrResult[20]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_end_numero")%>").val(arrResult[21]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_end_complemento")%>").val(arrResult[22]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_end_bairro")%>").val(arrResult[23]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_end_cidade")%>").val(arrResult[24]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_end_estado")%>").val(arrResult[25]);
				$("#<%=tornaCampoObrigatorio(arrCampos, "var_pais")%>").val(arrResult[26]);
		   }
	    }});
   });	
	
}

function validaCelular(prCel){
//	alert(prCel);
	var msg="";
	if (prCel.length < 9 || prCel.length > 11) {
        msg="aqui 1 numero invalido";
    }
    if ([ "7", "8", "9"].indexOf(prCel.substring(0,1)) == -1) {
        msg="aqui 2 numero invalido";
    }
    if (msg != ""){
		alert("Número de celular invalido.\r\nPara pagamento por favor informe um número valido.")
		//alert(msg);
		return false;
	}
}

</script>
</html>