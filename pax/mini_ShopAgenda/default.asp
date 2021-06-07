<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PAX", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<% 
 Dim objConn, objRS, objLang, strSQL

 Dim strCOD_EMP, strIDAUTO_EMP, strIDAUTO_SUB, strCODBARRA_EMP, strCODBARRA_SUB
 Dim strNOMEFAN_EMP, strNOMECRED_SUB
 Dim strIDENTIFICADOR, strEMAIL, strFOTO
 Dim strTIPO_PESS, strTABELA
 Dim strSEARCH, strShareMode, strTP_BROWSER, tpFILTRO

 Dim strCOD_EVENTO,strCOD_STATUS_PRECO
 Dim strCOD_EMPRESA,strCOD_INSCR,strCSP,strCSC,strCNPJ,strID_TIPO,strID_CAMPO,strCODINSCR, strNOME_EVENTO
  
 tpFILTRO 		= Session("METRO_SHOPAG_FILTRO")
 strTP_BROWSER	= Request.Cookies("METRO_pax")("tp_browser")
 'athDebug strTP_BROWSER, true

 strCOD_EVENTO			= getParam("var_cod_evento") 
 strCOD_EMPRESA 		= getParam("var_cod_empresa")		
 strCOD_INSCR   		= getParam("var_cod_inscricao") 
 strNOME_EVENTO			= getParam("var_nome_evento") 
 strCOD_STATUS_PRECO 	= getParam("var_cod_status_preco")'status preço inscrição  	
 strSEARCH				= getParam("var_str_search") ' String de pesquisa
 strShareMode			= getParam("var_share_mode") ' Serve para o controle quando a janela aberta em POUP (caso print, por exemplo deve esconder a DIV)


 AbreDBConn objConn, CFG_DB 
%>
<html>
<head>
<title>pVISTA PAX</title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js	"></script>
<script language='Javascript'>
//Função para calcular e ajustar a principal e frame principal de acordo com a responsividade
function adjustWindow() {
	var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	document.getElementById('frmini_principal').height = h-62; //= h-96;
}

//Submete o formulario da principla recebendo dois paramentros;
//prAction - para acão que sera tomada pelo form de acordo a pagina chamada;
//prCall - se Chmar MENU manda para frprincipal , se chamar SHARE_PRINT manda para link de impressão;
function SubmitForm(prAction, prCall){
	document.getElementById("formgeral").action = prAction;
	if (prCall == 'MENU') {	// Quando chama do MENU tem de fazer asim... 
		//document.getElementById("var_page").value 	= prAction;
		document.getElementById("formgeral").target = "fr_principal";
	} else { //Quando for chamado pelo SHARE (tem de abrire em POP para alguns tratamentos especiais)
	   	window.open('', 'winpopup_temp', 'width=520,height=620,resizeable,scrollbars');
   		document.getElementById("formgeral").target = "winpopup_temp";	
	}
    //document.getElementById("var_share_mode").value = prCall;	
	document.getElementById("formgeral").submit();
}
</script>
<style>
 .indent      { height: 50px; background:#E8E8E8; }
 .indent_mini { height:  5px; background:#FFFFFF; }
</style>
</head>
<body class="metro" style="margin:0px; padding:0px; background:#333;" onResize="adjustWindow();" onLoad="adjustWindow(); document.getElementById('formgeral').submit(); return false;">
<div style="border:0px solid #0F0;">

  <div class="fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px; text-align:left; background-color:333333;">
	PAX.AGENDA&nbsp;<sup><span style="font-size:12px"><%=strCOD_EVENTO & " - " & strNOME_EVENTO%></span></sup>   
    <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:0px; padding-right:10px;">
        <a href="#" onClick="document.getElementById('formgeral').submit();" title="Atualizar/Refresh">
            <i class="icon-cycle on-right on-left" style="background:green; color:white; padding:6px; border-radius: 50%"></i>
        </a>
    </div>
  </div>

  <div class="indent_mini" style="background-color:#333333;"></div>

  <center>
      <iframe scrolling="auto" 
                    id="frmini_principal" 
                    name="frmini_principal" 
                    src=""
                    width="99%" 
                    height="10" 
                    frameborder="0" style="border:0px dashed #cccccc;background:#FFF">
      </iframe>
  </center>

  <!-- 
  <div style=" border:#FF0 0px solid; width:100%;height:24px; padding-left:10px;padding-top:0px;margin:0px;">
    <div class='' style='float:right; text-align:right; padding-right:10px; margin:0px; padding-top:0px;'>
        <p style='font-family:Arial; color:#FFF; font-size:10px;line-height:160%;'>	
            ....
        </p>
    </div>
  </div>
  //-->
  
</div> <!-- container //-->
<form name="formgeral" id="formgeral" action="agenda.asp" method="post" target="frmini_principal">
    <input type="hidden"  	name="var_cod_evento" 		 id="var_cod_evento" 		value="<%=strCOD_EVENTO%>">  
    <input type="hidden" 	name="var_cod_empresa" 		 id="var_cod_empresa" 		value="<%=strCOD_EMPRESA%>"> 		
    <input type="hidden" 	name="var_cod_inscricao"	 id="var_cod_inscricao"		value="<%=strCOD_INSCR%>">  
    <input type="hidden" 	name="var_cod_status_preco"	 id="var_cod_status_preco"	value="<%=strCOD_STATUS_PRECO%>">
    <input type="hidden" 	name="var_str_search"		 id="var_str_search"		value="<%=strSEARCH%>"> 
    <input type="hidden" 	name="var_share_mode"	 	 id="var_share_mode"		value="<%=strShareMode%>"> 
    <input type="hidden" 	name="var_nome_evento"		 id="var_nome_evento"		value="<%=strNOME_EVENTO%>"> 
</form>
</body>
</html>
<%
  FechaDBConn objConn
%>