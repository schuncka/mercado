<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PAX", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<% 
 Dim objConn, objRS, objLang, strSQL

 Dim strCOD_EMP, strIDAUTO_EMP, strIDAUTO_SUB, strCODBARRA_EMP, strCODBARRA_SUB
 Dim strNOMEFAN_EMP, strNOMECRED_SUB
 Dim strIDENTIFICADOR, strEMAIL, strFOTO
 Dim strTIPO_PESS, strTABELA
  
 strCOD_EMP 		= getParam("var_cod_emp")
 strIDAUTO_EMP	 	= getParam("var_idauto_emp")
 strIDAUTO_SUB 		= getParam("var_idauto_sub")
 strCODBARRA_EMP 	= getParam("var_codbarra_emp" )
 strCODBARRA_SUB 	= getParam("var_codbarra_sub")
 strNOMEFAN_EMP 	= getParam("var_nomefan_emp")
 strIDENTIFICADOR	= getParam("var_identificador")
 strNOMECRED_SUB	= getParam("var_nomecred_sub")
 strEMAIL			= getParam("var_email")
 strFOTO			= getParam("var_foto")
 strTIPO_PESS		= getParam("var_tipopess_emp") 
 strTABELA			= getParam("var_tabela")

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"./lang/"
 ' -------------------------------------------------------------------------------
 
 AbreDBConn objConn, CFG_DB 

 ' QAP... 
 ' Aqui vai alguma consutla de dados que sejam necessários repassar para painel, 
 ' shopagenda ou qualquer outra página aberta dentro do iframe
 
 
%>
<html>
<head>
<title>pVISTA PAX</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script language='Javascript'>
//Função para calcular e ajustar a principal e frame principal de acordo com a responsividade
function adjustWindow() {
	var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	document.getElementById('fr_principal').height = h-96;
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

//marca com fonte amarela a pagaina que vc clicou e esta navegadno dentro do frame;
function marcaSwap(prObj, prId, prId2){
  //alert(prObj.id +","+prId+","+prId2);
  prObj.className = 'titulogrande fg-yellow';
  document.getElementById(prId).setAttribute('class','titulogrande fg-white');
  document.getElementById(prId2).setAttribute('class','titulogrande fg-white');
  //document.getElementById(prId2).className = 'titulogrande fg-white';
  //document.getElementById(prId2).className = 'titulogrande fg-white';
  return false;		
}

</script>
<style>
 .indent      { height: 50px; background:#E8E8E8; }
 .indent_mini { height:  5px; background:#FFFFFF; }
</style>
</head>
<body class="metro" style="margin:0px; padding:0px; background:#333;" onResize="adjustWindow();" onLoad="adjustWindow(); document.formgeral.submit(); return false;">
<div style="border:0px solid #0F0;">
    <div class="navigation-bar dark">
        <div class="navigation-bar-content">
        <a href="javascript:void();"  class="element" target="fr_principal"></span>PROEVENTO <sup>PAX</sup></a>
        <span class="element-divider"></span>
        
        <a class="element1 pull-menu" href="#"></a> <!-- Faz o menu ficar MINI quando em mobiles //-->
        	<ul class="element-menu">
        		<li>
                	<a href="javascript:void();" id="painel" 	   
                       onClick="SubmitForm('painel.asp','MENU'); marcaSwap(this,'cadastro','palestrante'); return false;" class="titulogrande fg-yellow">
                       <span><%=ucase(objLang.SearchIndex("painel",0))%></span>
                    </a>
                </li>
                <!--
                <li><a href="javascript: void();" id="cadastro"    onClick="SubmitForm('Cadastro.asp','MENU');marcaSwap(this,'painel','palestrante');" class="titulogrande fg-white" target="fr_principal" ><span>CADASTRO</span></a></li>        
        		<li><a href="javascript: void();" id="palestrante" onClick="SubmitForm('View_Check_Palestrante.asp','MENU');marcaSwap(this,'painel','cadastro');" class="titulogrande fg-white" 						target="fr_principal" ><span>PALESTRANTE</span></a></li>            		  		        	               
                //-->     		      
                <a class="element place-right"  href="logout.asp"><span class="icon-exit"></span>&nbsp;<%=ucase(objLang.SearchIndex("sair_pax",0))%></a>               
        	</ul>
        </div>
  </div>
        <div class="indent_mini" style="background-color:#333333;"></div>
  <center>
  <iframe scrolling="auto" 
                id="fr_principal" 
                name="fr_principal" 
                src=""
                width="99%" 
                height="10" 
                frameborder="0" style="border:0px dashed #cccccc;background:#FFF">
  </iframe>
  </center>
  <div style=" border:#FF0 0px solid; width:100%;height:24px; padding-left:10px;padding-top:0px;margin:0px;">
    <div class='' style='float:right; text-align:right; padding-right:10px; margin:0px; padding-top:0px;'>
        <p style='font-family:Arial; color:#FFF; font-size:10px;line-height:160%;'>	
            <%=strCOD_EMP & "." & strIDENTIFICADOR & " - Cod.BARRA [" & strCODBARRA_EMP & " / " & strCODBARRA_SUB & "]<br>"%>
            <%=strNOMEFAN_EMP & " (" & strNOMECRED_SUB & " | " & strTABELA & ")"%>
        </p>
    </div>
  </div>
</div> <!-- container //-->
<form name="formgeral" id="formgeral" action="painel.asp" method="post" target="fr_principal">
    <input type="hidden" id="var_cod_emp"		name="var_cod_emp"		 value="<%=strCOD_EMP%>">
    <input type="hidden" id="var_idauto_emp"	name="var_idauto_emp"	 value="<%=strIDAUTO_EMP%>">
    <input type="hidden" id="var_idauto_sub"	name="var_idauto_sub"	 value="<%=strIDAUTO_SUB%>">
    <input type="hidden" id="var_codbarra_emp"	name="var_codbarra_emp"  value="<%=strCODBARRA_EMP%>">
    <input type="hidden" id="var_codbarra_sub"	name="var_codbarra_sub"	 value="<%=strCODBARRA_SUB%>">
    <input type="hidden" id="var_nomefan_emp"	name="var_nomefan_emp"	 value="<%=strNOMEFAN_EMP%>">
    <input type="hidden" id="var_identificador"	name="var_identificador" value="<%=strIDENTIFICADOR%>">
    <input type="hidden" id="var_nomecred_sub"	name="var_nomecred_sub"	 value="<%=strNOMECRED_SUB%>">
    <input type="hidden" id="var_email"			name="var_email"		 value="<%=strEMAIL%>">
    <input type="hidden" id="var_foto"			name="var_foto"		 	 value="<%=strFOTO%>">
    <input type="hidden" id="var_tipopess_emp"	name="var_tipopess_emp"  value="<%=strTIPO_PESS%>">
    <input type="hidden" id="var_tabela"		name="var_tabela"		 value="<%=strTABELA%>">
</form>
</body>
</html>
<%
  FechaDBConn objConn
%>