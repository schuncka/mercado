<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->
<%

 Dim objConn, objRS, objLang, strSQL 'banco
 Dim arrScodi,arrSdesc 'controle
 Dim strLng, strLOCALE, strTP_BROWSER
 Dim strIDCPF, strCOD_EVENTO
 Dim strNomeEvento,strNomeCompleto,strCabecalhoLoja,strRodapeLoja,strSite,strDtInicio,strDtFim,strHrInicio,strHrFim,strLogradouro,strBairro,strPais,strCidade
 Dim arrImagem, x, strBanner, strDescricao, strGoogleMaps
 strLng			= getParam("lng") 'BR, [US ou EN], ES
 strCOD_EVENTO  = getParam("cod_evento")
  ' -------------------------------------------------------------------------------------------------------
 CFG_DB = Request.Cookies("pVISTA")("DBNAME") 					'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
 if ( (CFG_DB = Empty) OR (Cstr(CFG_DB) = "") ) then
	auxStr = lcase(Request.ServerVariables("PATH_INFO"))      	'retorna: /aspsystems/virtualboss/proevento/login.asp ou /proevento/login.asp
	auxStr = Mid(auxStr,1,inStr(auxStr,"/shopmetropf/default.asp")-1) 	'retorna: /aspsystems/virtualboss/proevento ou /proevento
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
 objLang.LoadLang strLOCALE,"../lang/"
 ' FIM: LANG (ex. de uso: response.wrire(objLang.SearchIndex("area_restrita",0))
 ' -------------------------------------------------------------------------------


 ' -------------------------------------------------------------------------------
 ' INI: Busca dados relativos as informações de ambiente do sistema (SITE_INFO)

 ' Cookies de ambiente PAX (não optamos por session, pq expira muito fácil/rápido e cokies são acessíveis fora da caixa de areia ------------------------------- '
 Response.Cookies("METRO_shopMetroPF").Expires = DateAdd("M",1,date)
 Response.Cookies("METRO_shopMetroPF")("locale")	  = strLOCALE
 MontaArrySiteInfo arrScodi, arrSdesc

'BUSCA DADOS DO EVENTO
	strSQL =  " SELECT    COD_EVENTO "
	strSQL = strSQL & " , NOME "
	strSQL = strSQL & " , nome_completo "
	strSQL = strSQL & " , cabecalho_loja "
	strSQL = strSQL & " , rodape_loja "
	strSQL = strSQL & " , site "
	strSQL = strSQL & " , dt_inicio "
	strSQL = strSQL & " , dt_fim "
	strSQL = strSQL & " , hora_inicio "
	strSQL = strSQL & " , hora_fim "
	strSQL = strSQL & " , descricao "
	strSQL = strSQL & " , logradouro "
	strSQL = strSQL & " , bairro "
	strSQL = strSQL & " , pais "
	strSQL = strSQL & " , cidade "
	strSQL = strSQL & " , proshop_banner_carossel_pt "
	strSQL = strSQL & " , proshop_banner_carossel_en "
	strSQL = strSQL & " , proshop_banner_carossel_es "
	strSQL = strSQL & " , proshop_descricao_pt "
	strSQL = strSQL & " , proshop_descricao_en "
	strSQL = strSQL & " , proshop_descricao_es "
	strSQL = strSQL & " , proshop_google_maps  "
	strSQL = strSQL & " FROM tbl_evento "
	strSQL = strSQL & " WHERE cod_evento = " & strCOD_EVENTO


  set objRS = objConn.execute(strSQL)
  
  If NOT objRS.EOF Then
  	strNomeEvento		= getValue(objRS,"nome")
	strNomeCompleto		= getValue(objRS,"nome_completo")
	strCabecalhoLoja	= getValue(objRS,"cabecalho_loja")
	strRodapeLoja		= getValue(objRS,"rodape_loja")
	strSite				= getValue(objRS,"site")
	strDtInicio			= getValue(objRS,"dt_inicio")
	strDtFim			= getValue(objRS,"dt_fim")
	strHrInicio			= getValue(objRS,"hora_inicio")
	strHrFim			= getValue(objRS,"hora_fim")
	strDescricao		= getValue(objRS,"descricao")
	strLogradouro		= getValue(objRS,"logradouro")
	strBairro			= getValue(objRS,"bairro")
	strPais				= getValue(objRS,"pais")
	strCidade			= getValue(objRS,"cidade")
  
If strLOCALE = "pt-br" Then
	strBanner    = getValue(objRS,"proshop_banner_carossel_pt")
	strDescricao = getValue(objRS,"proshop_descricao_pt")
End If
If strLOCALE = "en-us" Then
	strBanner    = getValue(objRS,"proshop_banner_carossel_en")
	strDescricao = getValue(objRS,"proshop_descricao_en")
End If
If strLOCALE = "es" Then
	strBanner    = getValue(objRS,"proshop_banner_carossel_es")
	strDescricao = getValue(objRS,"proshop_descricao_es")
End If	
	strGoogleMaps = getValue(objRS,"proshop_google_maps")
  
  
  
  End If

%>
<!DOCTYPE html>
<head>

    <meta charset="utf-8">
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

    <title>pVISTA ShopMetroUI</title>
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
                         <img class="" src="../img/<%=arrSdesc(ArrayIndexOf(arrScodi,"LOGOMARCA"))%>" style="margin-bottom:15px;margin-top:15px;">
                     </div>
                 </div>
             </div>
        </div>
		<!-- FIM: LOGO Promotora //-->	
          		
	

        
		<!-- INI: MENU  //-->	
        <div class="navigation-bar dark">
                <div class="navbar-content">

                    <a href="default.asp" class="element"><strong><%=strNomeEvento%></strong></a>
                                                                                                  
                    <!--
                    <a class="pull-menu" href="#"></a>
                    <ul class="element-menu">
                        <li>
                            <a class="dropdown-toggle" href="#"><strongreservado>RESERVADO1</strong></a>
                            <ul class="dropdown-menu" data-role="dropdown">
                                <li>
                                    <a href="#" class="dropdown-toggle">Sobre Nós</a>
                                    <ul class="dropdown-menu" data-role="dropdown">
                                        <li><a href="#">Acomodações</a></li>
                                        <li><a href="#">Vá de metrô</a></li>                                    
                                    </ul>
                                </li>
                                <li><a href="#">Segurança</a></li>
                                <li><a href="#">Contato</a></li>                                
                            </ul>
                        </li>
                    </ul>
					//-->

                    <div class="no-tablet-portrait place-right">
                        <div class="element input-element" >
                            <form>
                                <div class="input-control text">
                                    <input type="text" style="background-color:#555555; border:0px; color:#ffffff">
                                    <button class="btn-search fg-white" ></button>
                                </div>
                            </form>
                        </div>

                        <span class="element-divider place-right"></span>
                    </div>
                </div>
        </div>
		<!-- FIM: MENU  //-->	

	</div> 
    <!-- FIM: page-header -------------------------------------------------------------- //--> 

	<!--strNomeCompleto		= getValue(objRS,"nome_completo")
	strCabecalhoLoja	= getValue(objRS,"cabecalho_loja")
	strRodapeLoja		= getValue(objRS,"rodape_loja")
	strSite				= getValue(objRS,"site")
	strDtInicio			= getValue(objRS,"dt_inicio")
	strDtFim			= getValue(objRS,"dt_fim")
	strHrInicio			= getValue(objRS,"hora_inicio")
	strHrFim			= getValue(objRS,"hora_fim")
	strDescricao		= getValue(objRS,"descricao")
	strLogradouro		= getValue(objRS,"logradouro")
	strBairro			= getValue(objRS,"bairro")
	strPais				= getValue(objRS,"pais")
	strCidade			= getValue(objRS,"cidade")-->
    <div class="page-region-content">
    
        <div class="grid">
             <div class="row">
						<% 						
						arrImagem = split(strBanner,"|")							
						'arrImagem = split("./imgdin/carrousel.jpg|","|")
						%>
						 <!-- INI: 1 COLUNA //-->
                         <div class="span10" style="text-align:left;">
                                <!-- INI:Carrousel //-->
                                <% if ubound(arrImagem)>0 Then%>
                                <div class="example"> <!-- Case EXAMPLE colocada propositalmente para que o "carrousel" não apareça em MOBILE //-->
                                    <div class="row">
                                            <div class="carousel" id="carousel2">
                                                <% 	x = 0
													Do while x <= ubound(arrImagem)-1
													response.write("<div class='slide'><img src='"& arrImagem(x) &"' class='cover1' /></div>")
													x = x+1
												   Loop %>
                                            </div>
                                            <script>
                                                $(function(){
                                                    $("#carousel2").carousel({
                                                        width: '100%',
                                                        height: 435,
                                                        effect: 'slide',
                                                        period: 3000,
                                                        markers: {
                                                            show: true,
                                                            type: 'default',
                                                            position: 'bottom-center'
                                                        }
                                                    });
                                                })
                                            </script>
                                    </div>
                                </div>
                                <%End If%>         
								<!-- FIM: Carrousel //-->

                                
                                <div class="row">
                                    <h3><b>DATA E HORA</b></h3>
                                    <p class="tertiary-text-secondary">                                    
                                        <% if year(strDtInicio) <> year(strDtFim) Then %>
	                                        De <%=DAY(strDtInicio)&" ("&DiaSemanaAbreviado(weekday(strDtInicio))&")"%> de <%=MesExtenso(month(strDtInicio))%> | <%=year(strDtInicio)%> &agrave; <%=DAY(strDtFim)&" ("&DiaSemanaAbreviado(weekday(strDtFim))&")"%> de <%=MesExtenso(month(strDtFim))%> | <%=year(strDtFim)%> |<br>
                                  		<% else if (month(strDtInicio) <> month(strDtFim)) AND year(strDtInicio) = year(strDtFim) Then %>
											De <%=DAY(strDtInicio)&" ("&DiaSemanaAbreviado(weekday(strDtInicio))&")"%> de <%=MesExtenso(month(strDtInicio))%> &agrave; <%=DAY(strDtFim)&" ("&DiaSemanaAbreviado(weekday(strDtFim))&")"%> de <%=MesExtenso(month(strDtFim))%> | <%=year(strDtFim)%> |<br>										
                                        <% 		else %>
											De <%=DAY(strDtInicio)&" ("&DiaSemanaAbreviado(weekday(strDtInicio))&")"%> &agrave; <%=DAY(strDtFim)&" ("&DiaSemanaAbreviado(weekday(strDtFim))&")"%> de <%=MesExtenso(month(strDtFim))%> | <%=year(strDtFim)%> |<br>
										<% 		end if 
										    end if
										%>
                                        <%if strHrInicio <> "" Then%>
											<%=strHrInicio%> - <%=strHrFim%> (hor&aacute;rio padr&atilde;o de Bras&iacute;lia)
                                        <%end if%>
                                    </p>

                                  <%
								  strSQL = " SELECT  min(tbl_PrcLista.PRC_LISTA) AS prc_min, max(tbl_PrcLista.PRC_LISTA), max(tbl_PrcLista.PRC_LISTA) AS prc_max"
								  strSQL = strSQL & " FROM tbl_Produtos LEFT OUTER JOIN tbl_PrcLista ON (tbl_Produtos.COD_PROD = tbl_PrcLista.COD_PROD AND 1 BETWEEN tbl_PrcLista.QTDE_INIC AND tbl_PrcLista.QTDE_FIM)"
								  strSQL = strSQL & " LEFT JOIN tbl_produtos_grupo on (tbl_Produtos.GRUPO = tbl_produtos_grupo.GRUPO AND tbl_produtos_grupo.COD_EVENTO = " & strCOD_EVENTO & ")"
								  strSQL = strSQL & " WHERE tbl_Produtos.LOJA_SHOW = 1"
								  strSQL = strSQL & " AND tbl_PrcLista.PRC_LISTA >= 0"
								  strSQL = strSQL & " AND tbl_Produtos.COD_EVENTO = " & strCOD_EVENTO 
								  set objRS = objConn.execute(strSQL)
								  
								  if not objRS.eof Then
								  %> 
                                    <div style="width:55%; height:40px; background-color:#EBEBEB; color:#999999; text-align:center; padding-top:7px; border:1px solid #666;">
                                        <font size="+1">R$ <%=getValue(objRS,"prc_min")%> - R$ <%=getValue(objRS,"prc_max")%></font>
                                    </div>
                                  <%
								  end if
								  if strDescricao <> "" Then								  
								  %>  
                                    
                                    <!-- INI: DESCRIÇÃO do EVENTO - opcional //-->
                                    <%=strDescricao%>
                                    <!--h3><b>Descri&ccedil;&atilde;o</b></h3>
                                    <p class="tertiary-text-secondary text-justify">
                                        Aqui vai a descri&ccedil;&atilde;o do evento, dados que estejam cadastrados no pvista vinculados ao evento, caso esteja vazio o campo, recomenda-se ocultar essa &aacute;rea juntamente como o titulo respectivo)
                                    </p>
                                    <ul class="tertiary-text-secondary">
                                          <li>N&atilde;o obstante, o in&iacute;cio da atividade geral de </li>
                                          <li>forma&ccedil;&atilde;o de atitudes obstaculiza a aprecia&ccedil;&atilde;o </li> 
                                          <li>da import&acirc;ncia das formas de a&ccedil;&atilde;o. Gostaria de  </li>
                                          <li>enfatizar que a consulta aos diversos militantes  </li>
                                    </ul>
                                    <p class="tertiary-text-secondary text-justify">
                                        Ainda assim, existem d&uacute;vidas a respeito de como a expans&atilde;o dos mercados mundiais 
                                        estimula a padroniza&ccedil;&atilde;o dos paradigmas corporativos. Por outro lado, o aumento do.
                                    </p//-->                                    
                                    <!-- FIM: DESCREIÇÃO do EVENTO - opcional //-->
                                  <%End If%>
                                </div>
                         </div>
						 <!-- FIM: 1 COLUNA //-->


						 <!-- INI: 2 COLUNA //-->
                         <div class="span4">
                         	<div class="row">                                

                                <a href="Passo1_.asp">
                                <div style="width:100%; height:40px; cursor:pointer; background-color:#090; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                    <font size="+1"><b>INSCREVA-SE</b></font>
                                </div>
                                </a>

                                <div class="grid">
                                    <div class="row">
                                            <div class="" style="text-align:left;">
												<iframe src="https://maps.google.com/maps?q=Rua José Bernardo Pinto, 333&t=&z=13&ie=UTF8&iwloc=&output=embed"
                                                        width="100%" height="400" frameborder="0" style="border:0" allowfullscreen>
                                                </iframe>
                                                
                                                
                                                
                                                <h3><b>Expo Center Norte</b></h3>
                                                <p class="tertiary-text-secondary">
                                                    Rua Jos&eacute; Bernardo Pinto, 333<br>
                                                    Vila Guilherme, S&atilde;o Paulo - SP, 02055-000	
                                                    <br><br>
                                                    <small></small>
                                                </p>
                                            </div>
                                    </div>   
                                </div>
                         </div>
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
</html>