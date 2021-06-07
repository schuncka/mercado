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
 Dim strCodigoPromo, dblDescontoProduto, dblVlrFixo, objRSPromo,showCodigoPromo,strCategoriaTxt

 Dim strGrupo	 
 Dim strInicioOcorrencia, strFimOcorrencia

 
 strGrupo = ""
 showCodigoPromo = False
 
 strLng			= ucase(getParam("lng")) 'BR, [US ou EN], ES
 strCOD_EVENTO  = cint(getParam("cod_evento"))
 strCategoria   = (getParam("categoria"))

 strCodProdPromo  = getParam("cod_prod")
 dblDescontoPromo = getParam("vlr_desconto")
 dblVlrFixoPromo  = getParam("vlr_fixo")
 strCodigoPromo   = getParam("codigo_promo")
 
 flagCodigoPromo = false
 if strCodigoPromo <> "" Then
 	flagCodigoPromo = True
 End If
'response.write("cod_prod: "&strCodProdPromo&"  /  desc: "&dblDescontoPromo & "   /  fixo: " &dblVlrFixoPromo)
 CFG_DB         = getParam("db")
 
 if CFG_DB = "" Then  ' -------------------------------------------------------------------------------------------------------
	 CFG_DB = Request.Cookies("pVISTA")("DBNAME") 					'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
	 if ( (CFG_DB = Empty) OR (Cstr(CFG_DB) = "") ) then
		auxStr = lcase(Request.ServerVariables("PATH_INFO"))      	'retorna: /aspsystems/virtualboss/proevento/login.asp ou /proevento/login.asp
		'response.Write(auxStr)
		auxStr = Mid(auxStr,1,inStr(auxStr,"/proshoppf/Passo1_.asp")-1) 	'retorna: /aspsystems/virtualboss/proevento ou /proevento
		auxStr = replace(auxStr,"/aspsystems/_pvista/","")        	'retorna: proevento ou /proevento
		auxStr = replace(auxStr,"/","")                           	'retorna: proevento
		CFG_DB = auxStr + "_dados"
		CFG_DB = replace(CFG_DB,"_METRO_dados","METRO_dados") 	'Caso especial, banco do ambiente /_pvista não tem o "_" no nome "
		Response.Cookies("sysMetro")("DBNAME") = CFG_DB			'cfg_db nao esta vazio grava no cookie
	 end if 
End If
 ' ----------------------------------------------------------------------------------------------------------

 AbreDBConn objConn, CFG_DB 


 ' --------------------------------------------------------------------------------
 ' INI: LANG - tratando o Lng que por padrão pVISTA é diferente de LOCALE da função
 Select Case ucase(strLng)
	Case "BR"		strLOCALE = "pt-br"
	Case "US","EN","INTL"	strLOCALE = "en-us" 'colocar idioma INTL
	Case "SP","ES"		strLOCALE = "es"
	Case Else strLOCALE = "pt-br"
 End Select
 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang strLOCALE,"../_lang/proshoppf/"
 ' FIM: LANG (ex. de uso: response.wrire(objLang.SearchIndex("area_restrita",0))
 ' -------------------------------------------------------------------------------


 ' -------------------------------------------------------------------------------
 ' INI: Busca dados relativos as informações de ambiente do sistema (SITE_INFO)

 ' Cookies de ambiente PAX (não optamos por session, pq expira muito fácil/rápido e cokies são acessíveis fora da caixa de areia ------------------------------- '
 Response.Cookies("METRO_ProShopPF").Expires = DateAdd("h",2,now)
 Response.Cookies("METRO_ProShopPF")("locale")	  = strLOCALE
 MontaArrySiteInfo arrScodi, arrSdesc
 

	If strCategoria <> "0" Then
		strLinkDefault = "default.asp?cod_evento="&strCOD_EVENTO&"&lng="&strLng&"&categoria="&strCategoria
	Else
		strLinkDefault = "default.asp?cod_evento="&strCOD_EVENTO&"&lng="&strLng
	End If


strSQL = "				SELECT tbl_PrcLista.COD_STATUS_PRECO "
strSQL = strSQL & "			  ,TBL_STATUS_PRECO.status "
strSQL = strSQL & "			  ,TBL_STATUS_PRECO.status_intl "
strSQL = strSQL & "			  ,TBL_STATUS_PRECO.status_intl_es "
strSQL = strSQL & "		  	  ,tbl_Produtos.COD_PROD "
strSQL = strSQL & "			  ,tbl_Produtos.TITULO "
strSQL = strSQL & "			  ,tbl_Produtos.TITULO_INTL "
strSQL = strSQL & "			  , tbl_Produtos.TITULO_INTL_ES "
strSQL = strSQL & "			  , tbl_Produtos.DESCRICAO_HTML AS DESCRICAO"
strSQL = strSQL & "			  , tbl_Produtos.DESCRICAO_HTML_ING AS DESCRICAO_INTL"
strSQL = strSQL & "			  , tbl_Produtos.DESCRICAO_HTML_ESP AS DESCRICAO_INTL_ES "
strSQL = strSQL & "			  ,tbl_Produtos.GRUPO "
strSQL = strSQL & "			  ,tbl_Produtos.GRUPO_INTL "
strSQL = strSQL & "			  ,tbl_Produtos.CAPACIDADE "
strSQL = strSQL & "			  ,tbl_Produtos.OCUPACAO "
strSQL = strSQL & "			  ,(tbl_Produtos.CAPACIDADE - tbl_Produtos.OCUPACAO) AS VAGAS "
strSQL = strSQL & "			  ,tbl_PrcLista.PRC_LISTA "
'strSQL = strSQL & "			  , left(right(dt_ocorrencia,8),5) as hr_ocorrencia "
strSQL = strSQL & "			  ,left(right(CONVERT(dt_ocorrencia, CHAR),8),5) as hr_ocorrencia "
strSQL = strSQL & "			  ,left(right(CONVERT(dt_termino, CHAR),8),5) as hr_termino "
strSQL = strSQL & "		FROM tbl_Produtos INNER JOIN tbl_PrcLista ON tbl_Produtos.COD_PROD = tbl_PrcLista.COD_PROD "
strSQL = strSQL & "		                       AND now() BETWEEN tbl_PrcLista.DT_VIGENCIA_INIC AND tbl_PrcLista.DT_VIGENCIA_FIM "
strSQL = strSQL & "							   AND 1 BETWEEN tbl_PrcLista.QTDE_INIC AND tbl_PrcLista.QTDE_FIM "
strSQL = strSQL & "						  INNER JOIN TBL_STATUS_PRECO ON TBL_STATUS_PRECO.COD_STATUS_PRECO = tbl_PrcLista.COD_STATUS_PRECO "
strSQL = strSQL & "		WHERE tbl_Produtos.LOJA_SHOW = 1 "
strSQL = strSQL & "		  AND tbl_status_preco.loja_show = 1 "
strSQL = strSQL & "		  AND tbl_Produtos.COD_EVENTO =  "& strCOD_EVENTO 
		if strCategoria <> "0" Then
strSQL = strSQL & "       AND tbl_PrcLista.cod_status_preco = " & strCategoria
					end if				
strSQL = strSQL & "		ORDER BY  grupo,TBL_STATUS_PRECO.status ,tbl_PrcLista.PRC_LISTA   "
'response.write(strSQL)
set objRS = objConn.execute(strSQL)
		if not objRS.eof Then			
			i=0	
					Do While not objRS.EOF 'OR i<=1						
							strCodProd       = getValue(objRS,"cod_prod")
							dblValorProduto  = getValue(objRS,"prc_lista")
							objRS.MoveNext
							i=i+1
					Loop
			objRS.MoveFirst
		end if		
	%>

<!DOCTYPE html>	
	<%		
	
	if request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strByPassCortesia") = 1 AND i = 1 Then		%>
				<body>
                <% If request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId") <> "" Then %>
                <!-- Google Tag Manager (noscript) -->
                <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=<%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId")%>" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
                <!-- End Google Tag Manager (noscript) -->
                <% End If %>	
    	    			<form name="frm_carrinho_" id="frm_carrinho_" method="post" action="passo2_.asp">
            				<input type="hidden" id="db"             name="db"              value="<%=CFG_DB%>">
                            <input type="hidden" id="cod_evento"     name="cod_evento"      value="<%=strCOD_EVENTO%>">
                            <input type="hidden" id="lng"            name="lng"             value="<%=strLng%>">                            
            			
						<%	If clng(getValue(objRS,"vagas")) > 0 Then 
						
						'aqui deve fazer o insert na tabela de produto da sessao para que garanta o funcionamento para eventos ja configurados.
						strSQL = "delete from tbl_inscricao_produto_session where id_session = "&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId")& " and cod_prod = " & strCodProd & " AND cod_evento = " & strCOD_EVENTO & ";"
						objConn.Execute(strSQL)	
						strSQL =  "insert into tbl_inscricao_produto_session(    id_session                                                           ,    cod_evento       ,     cod_prod            ,        qtde         ,          vlr_pago        ,       vlr_original       ) "
						strSQL = strSQL & "		  values                    (" & request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId") & "," & strCOD_EVENTO & "," & strCodProd &        ",         1           ," & dblValorProduto & "   , " & dblValorProduto   & ")"
						objConn.Execute(strSQL)	
						%>
            					<input type="hidden" id="cod_prod"         name="cod_prod" value="<%=strCodProd%>">
                                <input type="hidden" id="vlr_prod"         name="vlr_prod" value="<%=dblValorProduto%>">
                                <input type="hidden" id="var_categoria"    name="var_categoria" value="<%=strCategoria%>">
                                <input type="hidden" id="combo_quantidade" name="combo_quantidade" value="1">
             		<%		End If %>
					</form>
					<script language="javascript">document.getElementById("frm_carrinho_").submit();</script>	 
				</body>
             </html>
			<%	end if %>
<head>
        <!--meta charset="utf-8"//-->
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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

<% If request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId") <> "" Then %>	
<!-- Google Tag Manager -->
<script>
(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','<%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strGtmId")%>');
</script>
<!-- End Google Tag Manager -->
<% End If %>


<script>
function validaCodigoPromo(){
	$(document).ready(function(){
				$.ajax({url: "./ajax/valida_codigo_promo.asp?var_codigo_promo="+$("#codigo_promo_busca").val()+"&cod_evento=<%=strCOD_EVENTO%>", success: function(result){																		
							var arrResult = result.split("|")							
							if(arrResult[0] == 'err'){
								alert(arrResult[1]);
								return false;
							}
							else{
								if (arrResult[0] != ""){
									$("#categoria").val(arrResult[0]);					
								}
								if (arrResult[1] != ""){
									$("#cod_prod").val(arrResult[1]);
								}
								if (arrResult[2] != ""){
									$("#vlr_desconto").val(arrResult[2]);
								}
								if (arrResult[3] != ""){
									$("#vlr_fixo").val(arrResult[3]);
								}
								if (arrResult[4] == "ok"){
									$("#codigo_promo").val($("#codigo_promo_busca").val())
									$("#frm_codPromo").submit();
								}
							}
						}});
		
		});	
}		

  
   
     
  

function adicionaProduto(prQuantidade, prCodProd, prCampoValor){
var elementos = document.getElementById("frm_carrinho").elements;
		$(document).ready(function(){
				$.ajax({url: "./ajax/adicionaProduto.asp?var_codigo_prod="+prCodProd+"&cod_evento=<%=strCOD_EVENTO%>&var_quantidade="+prQuantidade+"&var_categoria="+$("#var_categoria").val(), success: function(result){																		
							//console.log(result);
							var arrResult = result.split("|")							
							//alert(arrResult);
							if(arrResult[0] == 'err'){
								//alert(arrResult[1]);
								return false;
							}
							else{
								for (var j=0;j<arrResult.length-1;j++){
                                     for (var i=0; i< elementos.length; i++) {  
                                       // alert('nome-elemento: '+ elementos[i].id + '   /   valor:' +elementos[i].value);
                                        //alert('j:' +arrResult[j] + ' - id:'+ elementos[i].id + ' ' +elementos[i].id.indexOf(arrResult[j]));
                                        if ((elementos[i].id.indexOf(arrResult[j])!=-1)) {
                                            elementos[i].value = "0"; 
                                            }                                            
                                        }   
                                }
							}
						}});
		
		});
}
		//validação do codigo promocional 
		$(document).ready(function(){
			$("#btn_valida_promo").click(function() {									
					validaCodigoPromo();
			});			
			$("#codigo_promo_busca").blur(function() {									
					validaCodigoPromo();
			});
			$("#div_categoria").click(function(){
				$("#codigo_promo_literal").attr("style", "display:none")				
				$("#div_cod_promo").attr("style", "display:inline");		
				$("#codigo_promo_busca").focus();
			});			
		 });
			

		//fim validação do codigo promocional 






function enviaForm(){
	var result;
		$(document).ready(function(){
				$.ajax({url: "./ajax/verificaProdutoCarrinho.asp", success: function(result){																				
							console.log(result);
							if(result == "true"){
								document.getElementById("frm_carrinho").submit();
							}else{
								alert('<%=objLang.SearchIndex("carrinho_vazio",0)%>');
								return false;
							}
						}});
		
		});
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
          /* Phones portrait*/
        @media only screen and (min-width: 350px) {
             .metro .stepper >  li  { 
              left: 25%;
        html {
            font-size: 40%;
        }
        .no-phone-landscape,
        .no-phone {
            display: none !important;
            visibility: hidden !important;
        }
        .container {
            width: 100% !important;
        }
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
       <% If request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strCabecalhoLoja") <>"" Then %>
            <div class="grid" style="margin-bottom:0px">
                 <div class="row">
                     <div class="span14" style="background-color:#F8F8F8;"><!-- level 1 column //-->
                         <div class="row">
                             <img class="" src="../imgdin/<%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strCabecalhoLoja")%>" style="margin-bottom:15px;margin-top:15px;background-color:#F8F8F8;">
                         </div>
                     </div>
                </div>

                <div class="row">
                    <div class="row">
                        <div class="stepper rounded" data-steps="4" data-role="stepper" data-start="1" style="width:100%;"></div>
                    </div>
                </div>
            </div>
            
            
        <% End If %>
		<!-- FIM: LOGO Promotora //-->	
        
        
		<!-- INI: MENU  //-->	
        <div class="navigation-bar dark">
                <div class="navbar-content">
                    <a href="<%=strLinkDefault%>" class="element"><strong><%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strNomeEvento")%></strong></a>
                </div> 
        </div>
		<!-- FIM: MENU  //-->	 

	</div> 
    <!-- FIM: page-header -------------------------------------------------------------- //--> 
    <div class="page-region-content" id="produtos">
        <div class="grid">

             <div class="row">
                <!-- a href="Passo2_.asp" //-->
                <%if showCodigoPromo then%>
                <div id="div_categoria" style="width:100%;  height:40px; cursor:pointer; background-color:#F60; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; padding-right:7px; padding-left:7px; padding-bottom:7px; margin-top:20px;">
                    <font size="+1" id="codigo_promo_literal"><b>C&Oacute;DIGO PROMOCIONAL</b></font>
                    <div class="place-center">
                            <div class="element input-element" >
                                <div class="input-control text" id="div_cod_promo" style="display:none;">
                                    	<input type="text" value="" class="size5 image-left" id="codigo_promo_busca" name="codigo_promo_busca" placeholder="Digite seu c&oacute;digo promocional" style="background-color:#FFFFFF; border:1px; color:#0000000; text-align:center">                                
                                        <icon  id="btn_valida_promo" class="btn-search fg-gray" ></icon>
                                    </div>
                                
                                <form id="frm_codPromo" name="frm_codPromo" method="post" action="Passo1_.asp">
                                    <!--input type="hidden" value="" id="codigo_promo" name="codigo_promo" placeholder="Digite seu c&oacute;digo promocional" onBlur="validaCodigoPromo(this.value)"//-->                               
                                    <input type="hidden" id="codigo_promo"   name="codigo_promo"    value="">                                
                                    <input type="hidden" id="cod_evento"     name="cod_evento"      value="<%=strCOD_EVENTO%>">
                                    <input type="hidden" id="lng"            name="lng"             value="<%=strLng%>">
                                    <input type="hidden" id="categoria"      name="categoria"       value="<%=strCategoria%>">
                                    <input type="hidden" id="cod_prod"       name="cod_prod"        value="">
                                    <input type="hidden" id="vlr_desconto"   name="vlr_desconto"    value="">
                                    <input type="hidden" id="vlr_fixo"       name="vlr_fixo"        value="">
                                    <input type="hidden" id="db"             name="db"              value="<%=CFG_DB%>">
                                </form>  
                            </div>
                </div>
                <!-- /a //-->
             </div>
			<% End If %>
             <div class="row">
                <h2><%=objLang.SearchIndex("selecione_prod",0)%></h2>
             </div>

             <div class="row">
              <form name="frm_carrinho" id="frm_carrinho" method="post" action="passo2_.asp">
                <input type="hidden" id="db"             name="db" value="<%=CFG_DB%>">
                <input type="hidden" id="cod_evento"     name="cod_evento"      value="<%=strCOD_EVENTO%>">
                <input type="hidden" id="lng"            name="lng"             value="<%=strLng%>"> 
                <input type="hidden" id="var_categoria"   name="var_categoria" value="<%=strCategoria%>">
             <% 'set objRS = objConn.execute(strSQL)
			
							  
		 	if not objRS.eof Then
				i = 0
					Do While not objRS.EOF
						if strGrupo <> getValue(objRS,"grupo") then
						%>							
                        <div class="tile bg-cyan fg-white" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:white; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:10px; margin-top:15px;">
                            <%=getValue(objRS,"grupo")%>                                            
                        </div>
					<%	end if
						strGrupo = getValue(objRS,"grupo")
						i = i+1
						
						Select Case ucase(strLng)
							Case "BR"
								strTitulo       = getValue(objRS,"titulo")
								strDescricao    = getValue(objRS,"descricao")
								strCategoriaTxt = getValue(objRS,"status")
							Case "US","EN","INTL"	
								strTitulo       = getValue(objRS,"titulo_intl")
								strDescricao    = getValue(objRS,"descricao_intl")
								strCategoriaTxt = getValue(objRS,"status_intl")
							Case "SP","ES"		
								strLOCALE = "es"
								strTitulo       = getValue(objRS,"titulo_intl_es")
								strDescricao    = getValue(objRS,"descricao_intl_es")
								strCategoriaTxt = getValue(objRS,"status_intl_es")
						End Select
						
						
						
						
					'	if strLng <> "BR" Then
					'		strTitulo = getValue(objRS,"titulo_intl")
					'		strDescricao = getValue(objRS,"descricao_intl")
					'		strCategoriaTxt = getValue(objRS,"status_intl")
					'	else 
					'		strTitulo    = getValue(objRS,"titulo")
					'		strDescricao = getValue(objRS,"descricao")
					'		strCategoriaTxt = getValue(objRS,"status")
					'	End If
						
						strInicioOcorrencia     = getValue(objRS,"hr_ocorrencia")
						strFimOcorrencia = getValue(objRS,"hr_termino")
						strCodProd       = getValue(objRS,"cod_prod")
						dblValorProduto  = getValue(objRS,"prc_lista")
						
						If flagCodigoPromo Then
							strSQL = "          SELECT DESCONTO "
							strSQL = strSQL & "      , VLR_FIXO "
							strSQL = strSQL & " FROM  tbl_SENHA_PROMO_PROD "
							strSQL = strSQL & " WHERE COD_PROD = " & strCodProd & " AND CODIGO = '" & strCodigoPromo & "'"
							Set objRSPromo = objConn.Execute(strSQL)
							If not objRSPromo.EOF Then
								dblDescontoProduto = getValue(objRSPromo,"DESCONTO")
								dblVlrFixo         = getValue(objRSPromo,"VLR_FIXO")
							End If
							FechaRecordSet objRSPromo
					
							If IsNull(dblVlrFixo) Or dblVlrFixo = "" Then
								If IsNull(dblDescontoProduto) Or dblDescontoProduto = "" Then
								  dblDescontoProduto = 0
								End If		  
								dblDescontoProduto = 1 - (dblDescontoProduto / 100)
								dblValorProduto = dblValorProduto * dblDescontoProduto
							Else
								dblValorProduto = dblVlrFixo
							 End If
					
							If IsNull(dblValorProduto) Then 
								dblValorProduto = 0
							End If
						End If
						
						
			            %>
                            
            			<% 'só coloca o codigo do produto e valor em formato do formulario caso haja vagas 
							If clng(getValue(objRS,"vagas")) > 0 Then %>
            					<input type="hidden" id="cod_prod"       name="cod_prod" value="<%=strCodProd%>">
                                <input type="hidden" id="vlr_prod"       name="vlr_prod" value="<%=dblValorProduto%>">
                                <!--input type="hidden" id="var_categoria"   name="var_categoria" value="<%=strCategoria%>"//-->                        
            			<% End If%>
            
                                <% if getValue(objRS,"prc_lista") = 0 Then 'produto gratuito%>    <!-- INI: LISTA PRODUTOS //-->	
                                    <div class="tile" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding: 20px; margin-top:15px; border:1px solid #4390DF;">
                                        <font size="+1">
                                            <%=strCategoriaTxt%> - <%=strTitulo%><p><small>(<%=strCodProd%>)</small></p>
                                        </font>
                                        <p><%=strDescricao%></p>
                                               	<%if strInicioOcorrencia <> "" Then %>
	                                                <p><small><%=objLang.SearchIndex("horário",0)%>&nbsp;<%=strInicioOcorrencia%> - <%=strFimOcorrencia%></small></p>
                                                    <span style="color:#009966;" id="span_<%=i%>"><%=objLang.SearchIndex("gratuito",0)%></span>
                                                <%end if%>

                                        <div class="brand">
                                            <!--span class="badge bg-lightBlue">1</span//-->
                                            <div class="badge bg-lightBlue" style="width:50px; height:auto; bottom: 10px !important;"> 
                                              <select name="combo_quantidade" id="combo_quantidade" onChange="adicionaProduto(this.value,<%=strCodProd%>,span_<%=i%>);" style="width:40px;">
                                                <option value="0" selected >0</option> 
                                                <option value="1"  >1</option>                                                
                                              </select>
                                            </div>
                                        </div>
                                    </div>
                    			<% Else if clng(getValue(objRS,"vagas")) <=0 Then 'Vagas zeradas%>
                                			<div class="tile" style=" width:100%; height:auto; margin:0 auto;  background-color:#EBEBEB; color:#999; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:0px solid #666;">
                                                <font size="+1">
                                                    <%=strCategoriaTxt%> - <%=strTitulo%><p><small>(<%=strCodProd%>)</small></p>                                                    
                                                    VENDAS ENCERRADAS
                                              </font>
                                                <p><%=strDescricao%></p>
                                               	<%if strInicioOcorrencia <> "" Then %>
	                                                <p><small><%=objLang.SearchIndex("horario",0)%>&nbsp;<%=strInicioOcorrencia%> - <%=strFimOcorrencia%></small></p>
                                                <%end if%>
                                            </div>
                                    <!--div class="tile selected"  id="createFlatWindow" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:1px solid #4390DF;">
                                        <font size="+1">
                                            <%'=strTitulo%>
                                            <br><span style="color:#0099CC;">R$ <%'=getValue(objRS,"prc_lista")%></span>
                                        </font>
                                        <br><br><%'=strDescricao%>
                                        <div class="brand">
                                            <span class="badge bg-lightBlue">0</span>
                                        </div>
                                    </div//-->
                                    
                                    	<% Else 'Produtos a venda%>
                                                <div class="tile" id="tile_<%=i%>" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding: 20px; margin-top:15px; border:1px solid #4390DF;">
                                                    <font size="+1">
                                                        
                                                        <%=strCategoriaTxt%> - <%=strTitulo%><p><small>(<%=strCodProd%>)</small></p>
                                                        <% 'if trim(strCodProd) <> trim(strCodProdPromo) Then %>
	                                                        <span style="color:#009966;" id="span_<%=i%>">R$ <%=FormatNumber(dblValorProduto)%></span>
                                                        <%' else %>
                                                        	<!--br><span style="color:#0099CC;">R$ <%=FormatNumber(dblVlrFixoPromo)%></span><strong></strong//-->
                                                        <%' end if %>
                                                    </font>
                                                   <p><%=strDescricao%></p> 
                                               	<%if strInicioOcorrencia <> "" Then %>
	                                                <p><small><%=objLang.SearchIndex("horario",0)%>&nbsp;<%=strInicioOcorrencia%> - <%=strFimOcorrencia%></small></p>
                                                <%end if%>
                                                    <div class="brand">
                                                        <!-- span class="badge bg-lightBlue">1</span //-->
                                                        <!-- Uma alternativa seria colocar COMBOS aqui como badge //-->
                                                            <div class="badge bg-lightBlue" style="width:50px; height:auto; bottom: 10px !important;"> 
                                                              <select name="combo_quantidade_<%=i%>" id="combo_quantidade_<%=i%>_<%=strCodProd%>" onChange="adicionaProduto(this.value,<%=strCodProd%>,span_<%=i%>);" style="width:40px;">
                                                                <option value="0" selected >0</option> 
                                                                <option value="1"  >1</option>
                                                              </select>
                                                            </div>      
                                                    </div>
                                                </div>
                                    
								<%	End If 'Segundo if
                                 End If 'primeiro if%>  
                                <!--    <div class="tile" style="width:100%; height:auto; margin:0 auto;  background-color:#EBEBEB; color:#999; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:0px solid #666;">
                                        <font size="+1">
                                            1º Lote Individual
                                            <br>VENDAS ENCERRADAS
                                        </font>
                                        <br><br>Caros amigos, a determinação clara de objetivos causa impacto indireto na reavaliação das condições financeiras e administrativas exigidas. idas.
                                    </div>
                    
                    
                                    <div class="tile" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:0px solid #666;">
                                      <font size="+1"> 2º Lote Individual <br>
                                      <span style="color:#0099CC;">R$ 879,00</span> </font> <br>
                                      <br>
                                      A determinação clara de objetivos causa impacto indireto na reavaliação das condições financeiras e administrativas exigidas. idas. 
                                    </div>
                                    
                                    <div class="tile" style=" width:100%; height:auto; margin:0 auto;  background-color:#EBEBEB; color:#999; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:0px solid #666;">
                                        <font size="+1">
                                            3º Lote Individual
                                            <br>
                                            VENDAS ENCERRADAS
                                      </font>
                                        <br><br>Caros amigos, a determinação clara de objetivos causa impacto indireto na reavaliação das condições financeiras e administrativas exigidas. idas.
                                    </div>
                    
                                    <div class="tile selected"  style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:1px solid #4390DF;">
                                        <font size="+1">
                                            Workshop Joe Satriani
                                            <br><span style="color:#0099CC;">R$ 96,00</span>
                                        </font>
                                        <br><br>A determinação clara de objetivos causa impacto indireto na reavaliação das condições financeiras e administrativas exigidas. idas.
                                        <div class="brand">
                                            <!-- span class="badge bg-lightBlue">1</span //-->
                                            <!-- Uma alternativa seria colocar COMBOS aqui como badge //-->
                                                <!--div class="badge bg-lightBlue" style="width:50px; height:auto;"> 
                                                  <select name="combo_numpage" id="combo_numpage">
                                                    <option value="0"  >0</option> 
                                                    <option value="1"  selected>1</option>
                                                    <option value="2"  >2</option>
                                                    <option value="3"  >3</option>
                                                    <option value="4"  >4</option>
                                                    <option value="5"  >5</option>
                                                    <option value="6"  >6</option>
                                                    <option value="7"  >7</option>
                                                    <option value="8"  >8</option>
                                                    <option value="9"  >9</option>
                                                    <option value="10" >10</option>
                                                  </select>
                                                </div>      
                                        </div>
                                    </div>-->
			  <%
			  		objRS.movenext
				Loop
			  	End If
			  %>
              </form>
             
                <!-- FIM: LISTA PRODUTOS //-->
             </div>

             <div class="row" style="margin-top:15px">
                <div class="grid">
                    <div class="row">
                        <div class="span2" style="margin-right: 20px !important;">
                        <a href="<%=strLinkDefault%>">
                            <button class="button danger" style="padding: 10px; margin-bottom: 10px; width: 100%; border-radius: 5px;">
                                <strong><%=objLang.SearchIndex("voltar",0)%></strong>
                            </button>
                        </a>
                        </div>
                        <div class="span12"  style="margin-left: 0px;">
                        <button class="button" style="padding: 10px; margin-bottom: 10px; width: 100%; border-radius: 5px; background-color: #090; color: #FFFFFF" onClick="javascritp:enviaForm();">
                            <strong><%=objLang.SearchIndex("continuar",0)%></strong>
                        </button>
                        </div>
                    </div>
                </div>
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
</html>

<script type="text/javascript" language="javascript">
	  $("#createFlatWindow").on('click', function(){
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
					var content = '<form class="user-input" method="post">' +
							'<label>Quantidade</label>' +
							'<div class="input-control select">' +
							'  <select name="combo_numpage" id="combo_numpage">'+
							'    <option value="0"  >0</option>'  +
							'    <option value="1"  >1</option>'  +
							'    <option value="2"  >2</option>'  +
							'    <option value="3"  >3</option>'  +
							'    <option value="4"  >4</option>'  +
							'    <option value="5"  >5</option>'  +
							'    <option value="6"  >6</option>'  +
							'    <option value="7"  >7</option>'  +
							'    <option value="8"  >8</option>'  +
							'    <option value="9"  >9</option>'  +
							'    <option value="10" >10</option>' +
							'  </select></div>'            +
							'  <input type="hidden" name="db" value="<%=CFG_DB%>"> ' +
							'  <input type="hidden" name="cod_evento" value="<%=strCOD_EVENTO%>"> ' +
							'  <input type="hidden" name="categoria" value="<%=strCategoria%>"> ' +
							'  <input type="hidden" name="lng" value="<%=strLng%>"> ' +
							'<div class="form-actions">' +
							'<button class="button primary">Ok</button>&nbsp;'+
							'<button class="button" type="button" onclick="$.Dialog.close()">Cancel</button> '+
							'</div>'+
							'</form>';
					$.Dialog.title("Selecione");
					$.Dialog.content(content);
					$.Metro.initInputs('.user-input');
				}
			});
		});
</script>
