<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->
<%
 
  
 Dim objConn, objRS, objLang, strSQL 'banco
 Dim arrScodi,arrSdesc 'controle
 Dim strLng, strLOCALE
 Dim strCOD_EVENTO, strCategoria
 Dim strLinkDefault, i
 Dim strCodProd, dblDescontoPromo, dblVlrFixoPromo, strCodProdPromo, flagCodigoPromo, dblValorProduto
 Dim strCodigoPromo, dblDescontoProduto, dblVlrFixo, objRSPromo,CFG_DB_DADOS
 Dim strDescrProduto, strValor, intQuantidade
 Dim strTitulo, strDescricao, strCategoriaTxt

 
 CFG_DB          = getParam("db")
 CFG_DB_DADOS    = CFG_DB
 
 strLng			 = getParam("lng") 'BR, [US ou EN], ES 
 strCOD_EVENTO   = getParam("cod_evento")
 strCategoria    = getParam("var_categoria")
 strCodProd      = getParam("cod_prod")
 dblValorProduto = getParam("vlr_prod")
 intQuantidade   = getParam("combo_quantidade")
 
 if CFG_DB = "" Then  ' -------------------------------------------------------------------------------------------------------
	 CFG_DB = Request.Cookies("pVISTA")("DBNAME") 					'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
	 if ( (CFG_DB = Empty) OR (Cstr(CFG_DB) = "") ) then
		auxStr = lcase(Request.ServerVariables("PATH_INFO"))      	'retorna: /aspsystems/virtualboss/proevento/login.asp ou /proevento/login.asp
		response.Write(auxStr)
		auxStr = Mid(auxStr,1,inStr(auxStr,"/proshoppf/Passo2_.asp")-1) 	'retorna: /aspsystems/virtualboss/proevento ou /proevento
		auxStr = replace(auxStr,"/aspsystems/_pvista/","")        	'retorna: proevento ou /proevento
		auxStr = replace(auxStr,"/","")                           	'retorna: proevento
		CFG_DB = auxStr + "_dados"
		CFG_DB = replace(CFG_DB,"_METRO_dados","METRO_dados") 	'Caso especial, banco do ambiente /_pvista n�o tem o "_" no nome "
		Response.Cookies("sysMetro")("DBNAME") = CFG_DB			'cfg_db nao esta vazio grava no cookie		
	 end if 
End If
' ----------------------------------------------------------------------------------------------------------
  AbreDBConn objConn, CFG_DB 
 
' --------------------------------------------------------------------------------
 ' INI: LANG - tratando o Lng que por padr�o pVISTA � diferente de LOCALE da fun��o
 Select Case ucase(strLng)
	Case "BR"		strLOCALE = "pt-br"
	Case "US","EN","INTL"	strLOCALE = "en-us" 'colocar idioma INTL
	Case "SP","ES"		strLOCALE = "es"
	Case Else strLOCALE = "pt-br"
 End Select
 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang strLOCALE,"./lang/"
 ' FIM: LANG (ex. de uso: response.wrire(objLang.SearchIndex("area_restrita",0))
 ' -------------------------------------------------------------------------------


 ' -------------------------------------------------------------------------------
 ' INI: Busca dados relativos as informa��es de ambiente do sistema (SITE_INFO)

 ' Cookies de ambiente PAX (n�o optamos por session, pq expira muito f�cil/r�pido e cokies s�o acess�veis fora da caixa de areia ------------------------------- '
 Response.Cookies("METRO_ProShopPF").Expires = DateAdd("h",2,now)
 Response.Cookies("METRO_ProShopPF")("locale")	  = strLOCALE

  
  Dim flagCopy
  flagCopy = false
%>
<!--DOCTYPE html//-->
<html>
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
    
    <script language="javascript">
	function CapturaImage(formname,fieldname,id,campoFoto)
	{
	 	var strcaminho = './webcam/default.asp?id='+id+'&formulario='+formname+'&campo='+fieldname+'&campo_foto='+campoFoto;
	 	if(id!=""){
	 		window.open(strcaminho,'Imagem','width=340,height=385,top=50,left=50,scrollbars=1');
		}else{
	 		alert("O campo CPF deve ser preenchido antes da captura da imgagem.")
	 	}
	}
	function SetFormField(formname, fieldname, valor, prImgFoto) {	  	  
	  if ( (formname != "") && (fieldname != "") && (valor != "") ) {
		eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
		eval("document.getElementById('" + prImgFoto + "').src = '../webcam/imgphoto/" + valor + "';");		
	  }
	}
	function submitForm(){
				
		if(validateRequestedFields("frm_dados")){
			$.Notify({style: {background: 'green', color: 'white'}, content: "<%=objLang.SearchIndex("enviando_dados",0)%>...", timeout: 10000, shadow: true});
			var form = $('#frm_dados');

		    //function(ev) {
			  //alert('teste');
		      var inputs = form.find(':input');
		      RdIntegration.post(inputs.serializeArray());
		    //};
			document.getElementById("frm_dados").submit();
			
		}else{return false;}
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
<div id="fb-root"></div>
 <!-- INI: HeaderBAR --------------------------------------------------------------------- //-->
<div class="page-footer padding5" style="background-color:#282828;"></div>
 <!-- FIM: HeaderBAR --------------------------------------------------------------------- //-->

 <!-- INI: PAGE CONTAINER ------------------------------------------------------------- //-->
 <div class="page container">


    <div class="page-header">

		<!-- INI: LOGO Promotora //-->	       		
        <div class="grid" style="margin-bottom:0px">
             <div class="row">
                 <div class="span14" style="background-color:#FFF;"><!-- level 1 column //-->
                     <div class="row">
                         <img class="" src="../imgdin/<%=session("METRO_ProShopPF_strCabecalhoLoja")%>" style="margin-bottom:15px;margin-top:15px;">                         
                     </div>
                 </div>
             </div>
             <div class="row">
                 <div class="stepper rounded" data-steps="4" data-role="stepper" data-start="2" style="width:100%;"></div>
             	 <form name="to_passo1" id="to_passo1" action="passo1_.asp" method="post">
				   <input type="hidden" name="cod_evento" value="<%=strCOD_EVENTO%>">
                   <input type="hidden" name="lng" value="<%=strLng%>">
                   <input type="hidden" name="categoria" value="<%=strCategoria%>">
                   <input type="hidden" name="db" value="<%=CFG_DB%>">
                </form>
             </div>
        </div>
		<!-- FIM: LOGO Promotora //-->	
        
        
		<!-- INI: MENU  //-->	
        <div class="navigation-bar dark">
                <div class="navbar-content">
                    <a href="<%=strLinkDefault%>" class="element"><strong><%=session("METRO_ProShopPF_strNomeEvento")%></strong></a>
                </div> 
        </div>
		<!-- FIM: MENU  //-->	 

	</div> 
    <!-- FIM: page-header -------------------------------------------------------------- //--> 


    <div class="page-region-content">
    
        <div class="grid">
             <div class="row">

						 <!-- INI: 1 COLUNA //-->
                         <div class="span14" style="text-align:left;">
                                <!--div class="row">
                                    <a href="Passo3_.asp">
                                    <div style="width:100%; height:40px; cursor:pointer; background-color:#CCC; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-top:20px;">
                                        <font size="+1"><b>Resumo do Pedido</b></font>
                                    </div>
                                    </a>
                                </div//-->
                                <div class="row">
                                    <h2><%=objLang.SearchIndex("resumo_inscricao",0)%></h2>
                                </div>
                                
                                
                           <div class="row">
<%                                
                                strSQL = "				SELECT tbl_PrcLista.COD_STATUS_PRECO "
                                strSQL = strSQL & "			  ,TBL_STATUS_PRECO.status "
                                strSQL = strSQL & "			  ,TBL_STATUS_PRECO.status_intl "
                                strSQL = strSQL & "			  ,TBL_STATUS_PRECO.status_intl_es "
                                strSQL = strSQL & "		  	  ,tbl_Produtos.COD_PROD "
                                strSQL = strSQL & "			  ,tbl_Produtos.TITULO "
                                strSQL = strSQL & "			  ,tbl_Produtos.TITULO_INTL "
								strSQL = strSQL & "			  ,tbl_Produtos.TITULO_INTL_ES "
                                strSQL = strSQL & "			  ,tbl_Produtos.DESCRICAO "
                                strSQL = strSQL & "			  ,tbl_Produtos.DESCRICAO_INTL "
                                strSQL = strSQL & "			  ,tbl_Produtos.DESCRICAO_INTL_ES "
                                strSQL = strSQL & "			  ,tbl_Produtos.GRUPO "
                                strSQL = strSQL & "			  ,tbl_Produtos.GRUPO_INTL "
                                strSQL = strSQL & "			  ,tbl_Produtos.CAPACIDADE "
                                strSQL = strSQL & "			  ,tbl_Produtos.OCUPACAO "
                                strSQL = strSQL & "			  ,(tbl_Produtos.CAPACIDADE - tbl_Produtos.OCUPACAO) AS VAGAS "
                                strSQL = strSQL & "			  ,tbl_PrcLista.PRC_LISTA "
                                strSQL = strSQL & "		FROM tbl_Produtos INNER JOIN tbl_PrcLista ON tbl_Produtos.COD_PROD = tbl_PrcLista.COD_PROD "
                                strSQL = strSQL & "		                       AND now() BETWEEN tbl_PrcLista.DT_VIGENCIA_INIC AND tbl_PrcLista.DT_VIGENCIA_FIM "
                                strSQL = strSQL & "							   AND 1 BETWEEN tbl_PrcLista.QTDE_INIC AND tbl_PrcLista.QTDE_FIM "
                                strSQL = strSQL & "						  INNER JOIN TBL_STATUS_PRECO ON TBL_STATUS_PRECO.COD_STATUS_PRECO = tbl_PrcLista.COD_STATUS_PRECO "
                                strSQL = strSQL & "		WHERE tbl_Produtos.LOJA_SHOW = 1 "
                                strSQL = strSQL & "		  AND tbl_status_preco.loja_show = 1 "
                                strSQL = strSQL & "		  AND tbl_PrcLista.PRC_LISTA = 0 "
                                strSQL = strSQL & "       AND tbl_produtos.COD_PROD = " & strCodProd
								strSQL = strSQL & "		  AND tbl_Produtos.COD_EVENTO =  "& strCOD_EVENTO 
                                        if strCategoria <> "0" Then
                                strSQL = strSQL & "       AND tbl_PrcLista.cod_status_preco = " & strCategoria
                                                    end if				
                                strSQL = strSQL & "		ORDER BY TBL_STATUS_PRECO.status ,tbl_PrcLista.PRC_LISTA "
                        set objRS  = objCONN.execute(strSQL)
					Do While not objRS.EOF
								i = i+1  
								Select Case ucase(strLng)
								Case "BR"
										strTitulo    = getValue(objRS,"titulo")
										strDescricao = getValue(objRS,"descricao")
										strCategoriaTxt = getValue(objRS,"status")
									Case "US","EN","INTL"	
										strTitulo = getValue(objRS,"titulo_intl")
										strDescricao = getValue(objRS,"descricao_intl")
										strCategoriaTxt = getValue(objRS,"status_intl")
									Case "SP","ES"		strLOCALE = "es"
										strTitulo = getValue(objRS,"titulo_intl_es")
										strDescricao = getValue(objRS,"descricao_intl_es")
										strCategoriaTxt = getValue(objRS,"status_intl_es")
								End Select
								
								
								
								strCodProd       = getValue(objRS,"cod_prod")
								dblValorProduto  = getValue(objRS,"prc_lista")
								
'								If flagCodigoPromo Then
'									strSQL = "          SELECT DESCONTO "
'									strSQL = strSQL & "      , VLR_FIXO "
'									strSQL = strSQL & " FROM  tbl_SENHA_PROMO_PROD "
'									strSQL = strSQL & " WHERE COD_PROD = " & strCodProd & " AND CODIGO = '" & strCodigoPromo & "'"
'									Set objRSPromo = objConn.Execute(strSQL)
'									If not objRSPromo.EOF Then
'										dblDescontoProduto = getValue(objRSPromo,"DESCONTO")
'										dblVlrFixo         = getValue(objRSPromo,"VLR_FIXO")
'									End If
'									FechaRecordSet objRSPromo
'							
'									If IsNull(dblVlrFixo) Or dblVlrFixo = "" Then
'										If IsNull(dblDescontoProduto) Or dblDescontoProduto = "" Then
'										  dblDescontoProduto = 0
'										End If		  
'										dblDescontoProduto = 1 - (dblDescontoProduto / 100)
'										dblValorProduto = dblValorProduto * dblDescontoProduto
'									Else
'										dblValorProduto = dblVlrFixo
'									 End If
'							
'									If IsNull(dblValorProduto) Then 
'										dblValorProduto = 0
'									End If
'								End If


%>                                
                                    <!-- INI: LISTA PRODUTOS SELECIONADOS//-->	
					<%		'if cdbl(dblValorProduto) = 0 then %>
                                    <div class="tile selected" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:1px solid #4390DF;">
                                        <font size="+1">
                                            <%=strTitulo%>
                                            <%if dblValorProduto <=0 Then %>
	                                            <br><span style="color:#009966;"><%=objLang.SearchIndex("gratuito",0)%></span>
                                            <%else %>
                                            	<br><span style="color:#009966;"><%=dblValorProduto%></span>
                                            <%end if%>
                                        </font>
                                        <br><br><%=strDescricao%>
                                        <!-- INI: Acordeon FORM INSCRI��O //-->  
                                        <div class="accordion margin10" data-role="accordion" data-closeany="false">
                                            <div class="accordion-frame">
                                                <a class="active heading bg-cyan fg-white" href="#"><%=objLang.SearchIndex("preencha_dados",0)%></a>
                                                <div class="content">
                                                	<!--#include file="_include/IncludeFormInscricao_.asp" -->
                                                </div>
                                            </div>
                                        </div >    
                                        <!-- FIM: Acordeon FORM INSCRI��O //-->                   
                                    </div>
										
<% 
				    objRS.movenext
					loop 
%>  

                    				
                                    <!-- FIM: LISTA PRODUTOS SELECIONADOS//-->	                                

                                </div>
                                <%if cdbl(dblValorProduto) > 0 then%>
                                <div class="row">
                                    <div class="tile " style="width:100%; height:auto; margin:0 auto; margin-top:15px;
                                                              background-color:#CCC; color:#666; text-align:right; 
                                                              padding-top:7px; padding-right:10px; border:1px solid #FFF;">
                                        <font size="+2">
                                            TOTAL
                                            <br><span style="color:#009966;">R$ 0,00</span>
                                        </font>
                                    </div>
								</div>
								<%end if%>
					
                                <div class="row" style="margin-top:15px">
                                    <div class="grid">
                                        <div class="row">
                                            <div class="span2" onClick="javascript:document.getElementById('to_passo1').submit();" style="cursor:pointer;">
                                                
                                                <div style="width:100%; height:40px; cursor:pointer; background-color:#C00; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                                    <font size="+1"><b><%=objLang.SearchIndex("voltar",0)%></b></font>
                                                </div>                                                
                                            </div>
                                            <div class="span12">
                                                <!--a href="#" onClick="javascript:submitForm();" id="btn_avancar"-->
                                                <a href="#" id="btn_avancar">
                                                <div style="width:100%; height:40px; cursor:pointer; background-color:#090; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                                    <font size="+1"><b><%=objLang.SearchIndex("CONFIRMAR",0)%></b></font>
                                                </div>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                         </div>
						 <!-- FIM: 1 COLUNA //-->
					
             </div>
        </div>
    
    </div>  <!-- page-region-content //--> 
    

 </div> 
 <!-- FIM: PAGE CONTAINER ------------------------------------------------------------- //-->


 <!-- INI: Footer --------------------------------------------------------------------- //-->
 <!-- div class="page-footer padding5" style="background-color:#CCC; color:#FFF"></div //-->
 </div> <!-- esse div � importante para o efeito de rodap� que transpa�a a �rea de container //-->

 <!--#include file="_include/IncludeFooter.asp" -->
 <!-- FIM: Footer --------------------------------------------------------------------- //-->
<script type ='text/javascript' src="https://d335luupugsy2.cloudfront.net/js/integration/stable/rd-js-integration.min.js"></script>

  <script type="text/javascript">
/*    var form = $('#frm_dados');

    form.on('submit', function(ev) {
		alert('teste');
      var inputs = form.find(':input');
      RdIntegration.post(inputs.serializeArray());
    });
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = 'https://connect.facebook.net/pt_BR/sdk.js#xfbml=1&version=v3.0&appId=394920950887370&autoLogAppEvents=1';
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));*/
</script>

</body>
</html>


<script type="text/javascript" language="javascript">
		
/*		$(window).load(function() {
                            $.Dialog({
                                overlay: true,
                                shadow: true,
                                flat: true,
                                draggable: true,
                                icon: '<img src="images/excel2013icon.png">',
                                title: 'Flat window',
                                content: '',
                                padding: 10,
                                onShow: function(_dialog){
                                    var content = '<form class="user-input">' +
                                            '<label>Cpf</label>' +
                                            '<div class="input-control text"><input type="text" name="login"><button class="btn-clear"></button></div>' +
                                            '<label>Senha</label>'+
                                            '<div class="input-control password"><input type="password" name="password"><button class="btn-reveal"></button></div>' +                                            
                                            '<div class="form-actions">' +
                                            '<button class="button primary">Login to...</button>&nbsp;'+
                                            '<button class="button" type="button" onclick="$.Dialog.close()">Cancel</button> '+
                                            '</div>'+
                                            '</form>';

                                    $.Dialog.title("User login");
                                    $.Dialog.content(content);
                                    $.Metro.initInputs('.user-input');
                                }
                            });
                        });
*/
		
		$("#btn_avancar").on("click",function() {
                            if ('<%=left(replace(session("METRO_ProShopPF_Regulamento"),"'",""),10)%>' != ''){
								$.Dialog({
									overlay: true,
									shadow: true,
									flat: true,
									draggable: true,
									icon: '<img src="images/excel2013icon.png">',
									title: 'Flat window',
									content: '',										
									padding: 10,									 
									onShow: function(_dialog){										
										content = "<iframe  width='370' height='200' src='exibeRegulamento.asp?var_aceitar_traduzido=<%=objLang.SearchIndex("aceite_regulamento",0)%>' frameborder='0' style='overflow-x: hidden; overflow-y: scroll'></iframe>"
											content = content + "<div onClick='javascript:submitForm();$.Dialog.close();' id='enviar_regulamento' style='visibility:hidden;	 width:100%; height:40px; cursor:pointer; background-color:#090; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;'>"
                                                              + "<font size='+1'><strong><%=objLang.SearchIndex("CONFIRMAR",0)%></strong></font></div>"
										$.Dialog.title("<%=objLang.SearchIndex("titulo_dialog_regulamento",0)%>");
										$.Dialog.content(content);
										$.Metro.initInputs('.user-input');
									}
								});
							}
							else{submitForm();$.Dialog.close();}
                        });					
						
		
</script>

<% 'flagCopy = true 

'<div class="tile selected"  id="createFlatWindow" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:1px solid #4390DF;">
'    <font size="+1">
'        Ingresso - Visita Feira
'        <br><span style="color:#0099CC;"><!-- 1x R$ 96,00 //--></span>
'    </font>
'    <br><br>A determina&ccedil;&atilde;o clara de objetivos causa impacto indireto na reavalia&ccedil;&atilde;o das condi&ccedil;&otilde;es financeiras e administrativas exigidas. idas.
'    <!--div class="brand">
'        <span class="badge bg-lightBlue">1</span>
'    </div //-->
'    <div class="accordion margin10" data-role="accordion" data-closeany="false">
'        <div class="accordion-frame">
'            <a class=" heading bg-cyan fg-white" href="#">Inscri&ccedil;&atilde;o 1 - Preencha os dados</a>
'            <div class="content">
'                <%i=4
'                <!--include file="_include/IncludeFormInscricao.asp" -->                 
'            </div>
'        </div>
'    </div>
'</div>%>

