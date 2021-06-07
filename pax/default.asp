<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<%
 Dim objConn, objRS, objLang, strSQL 'banco
 Dim arrScodi,arrSdesc 'controle
 Dim strLng, strLOCALE, strTP_BROWSER
 Dim strIDCPF
 
 strLng			= getParam("lng") 'BR, [US ou EN], ES
 strTP_BROWSER	= UCase(GetParam("browser")) ' TIPO de navaegação (especial quando for T ou TOTEN, qualquer coisa diferetne disso seguira normalmente
 strIDCPF       = getParam("id_cpf")

 ' -------------------------------------------------------------------------------------------------------
 CFG_DB = Request.Cookies("pVISTA")("DBNAME") 					'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
 if ( (CFG_DB = Empty) OR (Cstr(CFG_DB) = "") ) then
	auxStr = lcase(Request.ServerVariables("PATH_INFO"))      	'retorna: /aspsystems/virtualboss/proevento/login.asp ou /proevento/login.asp
	auxStr = Mid(auxStr,1,inStr(auxStr,"/pax/default.asp")-1) 	'retorna: /aspsystems/virtualboss/proevento ou /proevento
	auxStr = replace(auxStr,"/aspsystems/_pvista/","")        	'retorna: proevento ou /proevento
	auxStr = replace(auxStr,"/","")                           	'retorna: proevento
	CFG_DB = auxStr + "_dados"
	CFG_DB = replace(CFG_DB,"_METRO_dados","METRO_dados") 	'Caso especial, banco do ambiente /_pvista não tem o "_" no nome "
	Response.Cookies("sysMetro")("DBNAME") = CFG_DB			'cfg_db nao esta vazio grava no cookie
 end if 
 ' ----------------------------------------------------------------------------------------------------------

 AbreDBConn objConn, CFG_DB 


 ' --------------------------------------------------------------------------------
 ' INI: LANG - tratando o Lng que por padrão pVISTA é diferente de LOCALE da função
 Select Case ucase(strLng)
	Case "BR"		strLOCALE = "pt-br"
	Case "US","EN"	strLOCALE = "en-us"
	Case "SP"		strLOCALE = "es"
	Case Else strLOCALE = "pt-br"
 End Select
 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang strLOCALE,"./lang/"
 ' FIM: LANG (ex. de uso: response.wrire(objLang.SearchIndex("area_restrita",0))
 ' -------------------------------------------------------------------------------


 ' -------------------------------------------------------------------------------
 ' INI: Busca dados relativos as informações de ambiente do sistema (SITE_INFO)

 ' Cookies de ambiente PAX (não optamos por session, pq expira muito fácil/rápido e cokies são acessíveis fora da caixa de areia ------------------------------- '
 Response.Cookies("METRO_pax").Expires = DateAdd("M",1,date)
 Response.Cookies("METRO_pax")("tp_browser") = strTP_BROWSER
 Response.Cookies("METRO_pax")("locale")	  = strLOCALE
 MontaArrySiteInfo arrScodi, arrSdesc
 If ArrayIndexOf(arrScodi,"PAX_VALIDA_SENHA") >= 0 Then
	 'Verificar se esta habilitado senha do pax no site info   
 	Response.Cookies("METRO_pax")("flagSenha") = Ucase( arrSdesc(ArrayIndexOf(arrScodi,"PAX_VALIDA_SENHA")))
 End If
 If ArrayIndexOf(arrScodi,"PAX_CADASTRO") >= 0 Then
 	' determina se grava ou envia e-mail solicitando (["EXIBIR" or "EDITAR" or "HOMOLOGAR"])
 	Response.Cookies("METRO_pax")("tp_cadastro") = ucase(arrSdesc(ArrayIndexOf(arrScodi,"PAX_CADASTRO")))
 End If
 If ArrayIndexOf(arrScodi,"PAX_CADASTRO_EMAIL") >= 0 Then
 	Response.Cookies("METRO_pax")("cadastro_email") = lcase(arrSdesc(ArrayIndexOf(arrScodi,"PAX_CADASTRO_EMAIL")))
 End If
 If ArrayIndexOf(arrScodi,"PAX_EMAIL_SENDER") >= 0 Then
 	Response.Cookies("METRO_pax")("email_sender") = lcase(arrSdesc(ArrayIndexOf(arrScodi,"PAX_EMAIL_SENDER")))
 End If
 If ArrayIndexOf(arrScodi,"PAX_EMAIL_AUDITORIA_PROEVENTO") >= 0 Then
 	Response.Cookies("METRO_pax")("email_auditoria_proevento") = lcase(arrSdesc(ArrayIndexOf(arrScodi,"PAX_EMAIL_AUDITORIA_PROEVENTO")))
 End If
 If ArrayIndexOf(arrScodi,"PAX_EMAIL_AUDITORIA_CLIENTE") >= 0 Then
 	Response.Cookies("METRO_pax")("email_auditoria_cliente") = lcase(arrSdesc(ArrayIndexOf(arrScodi,"PAX_EMAIL_AUDITORIA_CLIENTE")))
 End If

 ' FIM: Busca dados relativos as informações de ambiente do sistema (SITE_INFO)
 ' -------------------------------------------------------------------------------

%>
<html>
<head>
<title>pVISTA PAX METRO</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script type="text/javascript" language="javascript">

/* nesta dialog precisamos bloquear o ENTER (para todos os inputs) com a função abaixo */
$(document).ready(function () {
   $('input').keypress(function (e) {
        var code = null;
        code = (e.keyCode ? e.keyCode : e.which);                
        return (code == 13) ? false : true;
   });
});

function setAndSubmitForm(prArrParam){
	var arrAtrib;
	//alert(document.getElementById("formulario"));
	//O AJAX retorna os elementos da seguinte forma:[...|...|...|]{...|...|...]...
	//COD_EMPRESA |  IDAUTO_EMP | IDAUTO_SUB | CODBARRA_EMP | CODBARRA_SUB | NOMEFAN AS NOME_EMP | NOME_CREDENCIAL AS NOME_CRED | ES.ID_CPF ou E.ID_NUM_DOC1 | EMAIL | FOTO |TIPO_PESS | TABELA 

	arrAtrib = prArrParam.split('|');

	//DEBUG
	//alert(prArrParam);	
	
	document.getElementById("var_cod_emp").value 			= arrAtrib[0]; 
	document.getElementById("var_idauto_emp").value 		= arrAtrib[1]; 	
	document.getElementById("var_idauto_sub").value 		= arrAtrib[2];		
	document.getElementById("var_codbarra_emp").value 		= arrAtrib[3]; 	
	document.getElementById("var_codbarra_sub").value 		= arrAtrib[4]; 		

	document.getElementById("var_nomefan_emp").value 		= arrAtrib[5]; 	 
	document.getElementById("var_nomecred_sub").value 		= arrAtrib[6]; 
	document.getElementById("var_identificador").value 		= arrAtrib[7]; /* ID_NUM_DOC1 (da tbl_emresas) OU ID_CPF (da empresas_sub)*/
	document.getElementById("var_email").value 				= arrAtrib[8]; 
	document.getElementById("var_foto").value 				= arrAtrib[9]; 
	document.getElementById("var_tipopess_emp").value 		= arrAtrib[10]; 

	document.getElementById("var_tabela").value 			= arrAtrib[11]; 

	document.formulario.submit();
	//return true;			
}

function goBack() {
	location.href = "default.asp";
}

//----------------------------------------------------------------------------------------------------------

function ajax_showResult(prStr,prPwd) {
	var strLinkAjax  = "";

	if (validateRequestedFields("formulario")) { 
	

	var auxStr = "";
    if (prStr.length == 0) {
        document.getElementById("text_result").innerHTML = "Buscando...";
        return;
    } else {
		//alert("chamando XMLHttpRequest...");
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
				var objStrHtml = "" ;
				var objStr = this.responseText;
				var arrReg, arrAtrib, i , j, strAllArray;
				
				objStr = objStr.replace("<!DOCTYPE html>","");
				objStr = objStr.trim();
				
				if (objStr.replace(/^\s+|\s+$/gm,'') != "") { 
					objStr = objStr.replace(/\[/gi,"");

					arrReg  = objStr.split("]");
					/* O AJAX retorna os elementos da seguinte forma:[...|...|...|]{...|...|...]...
					   COD_EMPRESA |  IDAUTO_EMP | IDAUTO_SUB | CODBARRA_EMP | CODBARRA_SUB | NOMEFAN AS NOME_EMP | NOME_CREDENCIAL AS NOME_CRED | ES.ID_CPF ou E.ID_NUM_DOC1 | EMAIL | FOTO | TIPO_PESS | TABELA 
					   ---------------------------------------------------------------------------------------------------------------------------------------------------------- 03/03/2017 - by Aless - */
					objStrHtml = objStrHtml + "<div class='listview-outlook' style='background:#E9E9E9'> "					
					for (i = 0; i < arrReg.length-1; i++) {
						arrAtrib = arrReg[i].split('|');
						
						//for (j = 0; j < arrAtrib.length; j++){ //alert("DEBUG: " + arrAtrib[j]); }
							
						objStrHtml = objStrHtml + "<a href=\'#\' class=\'list\' title=\'" + arrAtrib[0] + "/" + arrAtrib[1] + "\' onclick=\"setAndSubmitForm('"+ arrReg[i] +"');\" id=\'count_pax_" + i + "\'> "
						strSub = arrReg[i]
						objStrHtml = objStrHtml + "<div class='list-content'> "
						objStrHtml = objStrHtml + "	<div  style='float:left;display:inline-block; margin-right:10px;border:0px solid #F00 '> "
						objStrHtml = objStrHtml + "		<h1>"
						if (arrAtrib[10].toLowerCase() == "s") {
							objStrHtml = objStrHtml + "   <i class='icon-user-3'></i>"
						} else 	{
							objStrHtml = objStrHtml + "   <i class='icon-user-2'></i>"
						}
						objStrHtml = objStrHtml + "		</h1> "
						objStrHtml = objStrHtml + "	</div> "		
						objStrHtml = objStrHtml + "	<div style='float:left;vertical-align:bottom;'> "
						objStrHtml = objStrHtml + "		<span class='list-remark' title=''>"    + arrAtrib[6] + " </span> "
						objStrHtml = objStrHtml + "		<span class='list-subtitle'>" + arrAtrib[5] + "</span> "
						objStrHtml = objStrHtml + "		<span class='list-remark'>"   + arrAtrib[7] + "</span> "
						objStrHtml = objStrHtml + "		<span class='list-remark'><small>"   + arrAtrib[8] + "</small></span> "
						objStrHtml = objStrHtml + "	</div> "
						objStrHtml = objStrHtml + "	<div class='brand' style=''> "
						objStrHtml = objStrHtml + "		<div class='badge'><!-- <i class='icon-rocket'></i> //--></div> "
						objStrHtml = objStrHtml + "	</div> "
						objStrHtml = objStrHtml + "</div> "//fim da list-content
						objStrHtml = objStrHtml + "</a> " 						
					}					
					if (i == 1){
						setAndSubmitForm(strSub)
					}
					objStrHtml = objStrHtml + "</div><br><button class='button' type='button' onClick='javascript:goBack();'>Cancelar</button>";
			 	} else {
					//alert("entrei no erro");
					objStrHtml = objStrHtml + "<div class='listview-outlook' style='background:#E9E9E9'> "					
						objStrHtml = objStrHtml + "<a href='#' class='list ' title='' onclik=''> "
						objStrHtml = objStrHtml + "<div class=list-content> "
						objStrHtml = objStrHtml + "		<div  style='float:left;display:inline-block; margin-right:10px;'> "
						objStrHtml = objStrHtml + "			<h1><i class='icon-cancel-2 fg-gray' ></i></h1> "
						objStrHtml = objStrHtml + "		</div> "
						objStrHtml = objStrHtml + "	<div  class='' style='float:left;> "
						objStrHtml = objStrHtml + "		<span class='list-title' title=''><b>ERRO DE INDENTIFICAÇÃO<b></span> "
						objStrHtml = objStrHtml + "		<span class='list-subtitle'>Cadastro (CPF/E-MAIL)</span> "
						objStrHtml = objStrHtml + "		<span class='list-remark'></span> "
						objStrHtml = objStrHtml + "		<span class='list-remark'>não identificado ou senha não confere.</span> "
						objStrHtml = objStrHtml + "	</div> "
						objStrHtml = objStrHtml + "	<div class='brand' style=''> "
						objStrHtml = objStrHtml + "		<div class='badge'><!-- <i class='icon-rocket'></i> //--></div> "
						objStrHtml = objStrHtml + "	</div> "
						objStrHtml = objStrHtml + "</div> "//fim da list-content
						objStrHtml = objStrHtml + "</a> "
					objStrHtml = objStrHtml + "</div><br><button class='button' type='button' onClick='javascript:goBack();'>Cancelar</button>";	
				}
				//-------------------------------------------------------------
				 document.getElementById("text_result").innerHTML = "<%=objLang.SearchIndex("escolhe_perfil",0)%><br>" + objStrHtml ;
				//------------------------------------------------------------
            }
        };
        //xmlhttp.open("GET","pesquisa_cadastro.asp?var_identificador=" + prStr, true);
				
		strLinkAjax = "_ajax_buscaCadastro.asp?var_identificador=" + prStr;
		if (prPwd != null) {
		 strLinkAjax = strLinkAjax + "&var_senha=" + prPwd.value;
		}
		xmlhttp.open("GET", strLinkAjax , true);		
        xmlhttp.send();
    }
	} 
}

function abreLembrete(){
	var strIdentificador;
	strIdentificador = document.getElementById("var_ajax_cpfemailô").value;
	AbreJanelaPAGE_NOVA('lembrete.asp?var_identificador=' + strIdentificador, '400', '580');
}
</script>
<style>
	.indent { height: 40px; }
</style>
</head>
<body class="metro"  background="../img/bg_login.jpg"  onLoad="document.getElementById('formulario');">
     <div style="width:100%; height:100%;padding:1.25em;">
     <form name="formulario" id="formulario" action="login_verify.asp"  method="post">
		<!-- COD_EMPRESA |  IDAUTO_EMP | IDAUTO_SUB | CODBARRA_EMP | CODBARRA_SUB | NOMEFAN AS NOME_EMP | NOME_CREDENCIAL AS NOME_CRED | ES.ID_CPF ou E.ID_NUM_DOC1 | EMAIL | TIPO_PESS | TABELA //-->
        <input type="hidden" name="var_cod_emp" 			id="var_cod_emp"  			value="" >
        <input type="hidden" name="var_idauto_emp" 			id="var_idauto_emp"  		value="" >
        <input type="hidden" name="var_idauto_sub" 			id="var_idauto_sub"  		value="" >
        <input type="hidden" name="var_codbarra_emp" 		id="var_codbarra_emp"  		value="" >
        <input type="hidden" name="var_codbarra_sub" 		id="var_codbarra_sub"  		value="" >
        <input type="hidden" name="var_nomefan_emp" 		id="var_nomefan_emp"  		value="" >
        <input type="hidden" name="var_nomecred_sub" 		id="var_nomecred_sub"  		value="" >
        <input type="hidden" name="var_identificador" 		id="var_identificador"  	value="" >  <!--  ID_NUM_DOC1 (da tbl_emresas) OU ID_CPF (da empresas_sub) | será o valor que ele digitou pra logar na verdade //-->
        <input type="hidden" name="var_senha" 				id="var_senha"  			value="" >                             
        <input type="hidden" name="var_email" 				id="var_email"  			value="" >
        <input type="hidden" name="var_foto" 				id="var_foto"  				value="" >
        <input type="hidden" name="var_tipopess_emp" 		id="var_tipopess_emp"  		value="" >   
        <input type="hidden" name="var_tabela" 				id="var_tabela"  			value="" >  

        <center>
            <div class="padding20 border text-center" style="width:22em; background-color:#FFF; text-align:left;">
                 <a href="default.asp"><img src="../img/<%=arrSdesc(ArrayIndexOf(arrScodi,"LOGOMARCA"))%>" border="0" style="padding-left:20px;" onClick=""></a>
                 
                <h3 class="no-bold" id="_heading" style="padding-top:20px;"></i>PROEVENTO.PAX</h3>
                <div id="text_result" style="display:block;">
                    <div class="grid" id="">
                                                                            
                                                                                                              
                            <div class="input-control text" data-role="input-control">
                                <input type="text" name="var_ajax_cpfemail" id="var_ajax_cpfemailô" placeholder="CPF / E-MAIL" value="<%=strIDCPF%>" onDblClick="this.value='00510772307';" maxlength="150" on>
                                <button class="btn-clear" tabindex="-1"></button>
                            </div>
                            <!-- label>Senha</label //-->
							<% if Request.Cookies("METRO_pax")("flagSenha") = "TRUE" then %> 
                                <div class="input-control password" data-role="input-control">
                                    <input type="password" name="var_ajax_senha" id="var_ajax_senhaô" placeholder="SENHA" value="" maxlength="150" onBlur="document.getElementById('var_senha').value = this.value;" autofocus >
                                    <button class="btn-reveal" tabindex="-1"></button>
                                </div>
						    <% end if %>    
                            <div class="form-actions" id="div_bt" style="display:block;">
                                    <input  class="primary" name="bt_ok" id="bt_ok" type="button"  value="OK"   onClick="ajax_showResult(document.getElementById('var_ajax_cpfemailô').value,document.getElementById('var_ajax_senhaô'));return false;">      
                            </div>
                         <%if strIDCPF <> "" Then%>   
                           <script language="javascript">
								ajax_showResult(document.getElementById('var_ajax_cpfemailô').value,document.getElementById('var_ajax_senhaô'));
						   </script>
						 <% End If%>
	                	
                    </div>
                    <% if Request.Cookies("METRO_pax")("flagSenha") = "TRUE" then %> 
                    <p class="tertiary-text-secondary text-center">                            
                        <%=objLang.SearchIndex("esqueceu_senha",0)%><a href="" onClick="javascript:abreLembrete();"><strong>[<%=objLang.SearchIndex("clique_aqui",0)%>]</strong></a>
                    </p>
					<% end if %>                    
                </div>	
            </div><!--  box/dialog //-->
        </center>
	</form> 
    </div> <!-- 100% (equiv. container) //-->
       

</body>
</html>
<%
 FechaDBConn ObjConn
%>