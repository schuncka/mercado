<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->
<%

 Dim objConn, objRS, objLang, strSQL 'banco
 Dim arrScodi,arrSdesc 'controle
 Dim strLng, strLOCALE
 Dim strCOD_EVENTO
 Dim strNomeEvento,strNomeCompleto,strCabecalhoLoja,strRodapeLoja,strSite,strDtInicio,strDtFim,strHrInicio,strHrFim
 Dim strCodMoedaEvento, strCodMoedaRef, strSimboloMoedaRef, strMoedaCotacaoRef, strSimboloMoeda
 Dim strLogradouro, strBairro,	strPais, strCidade, strEstado, strCEP, strPavilhao 	
 Dim strEmailEvento, strEmailContato1, strEmailContato2, strCategoria, strLink 
 Dim arrImagem, x, strBanner, strDescricao, strGoogleMaps
 Dim strByPass
 Dim strEventoFree 
 strLng			= getParam("lng") 'BR, [US ou EN], ES
 strCOD_EVENTO  = cint(getParam("cod_evento"))
 strCategoria   = cint(getParam("categoria"))
 strByPass		= getParam("bypass")
  ' -------------------------------------------------------------------------------------------------------
 CFG_DB = Request.Cookies("pVISTA")("DBNAME") 					'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
 if ( (CFG_DB = Empty) OR (Cstr(CFG_DB) = "") ) then
	auxStr = lcase(Request.ServerVariables("PATH_INFO"))      	'retorna: /aspsystems/virtualboss/proevento/login.asp ou /proevento/login.asp
	auxStr = Mid(auxStr,1,inStr(auxStr,"/proshoppf/default.asp")-1) 	'retorna: /aspsystems/virtualboss/proevento ou /proevento
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
	Case "US","EN","INTL"	
		strLOCALE = "en-us" 
		strLng = "US" 'colocar idioma INTL
	Case "SP","ES"		
		strLOCALE = "es"
		strLng    = "SP"
	Case Else 
		strLOCALE = "pt-br"
		strLng = "BR"
 End Select
 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang strLOCALE,"./lang/"
 ' FIM: LANG (ex. de uso: response.wrire(objLang.SearchIndex("area_restrita",0))
 ' -------------------------------------------------------------------------------


 ' -------------------------------------------------------------------------------
 ' INI: Busca dados relativos as informações de ambiente do sistema (SITE_INFO)

 ' Cookies de ambiente PAX (não optamos por session, pq expira muito fácil/rápido e cokies são acessíveis fora da caixa de areia ------------------------------- '
 Response.Cookies("METRO_ProShopPF").Expires = DateAdd("h",2,now)
 Response.Cookies("METRO_ProShopPF")("locale")	  = strLOCALE
 MontaArrySiteInfo arrScodi, arrSdesc

'BUSCA DADOS DO EVENTO
	strSQL =  " SELECT    e.COD_EVENTO "
	strSQL = strSQL & " , e.NOME "
	strSQL = strSQL & " , e.nome_completo "
	strSQL = strSQL & " , e.cabecalho_loja "
	strSQL = strSQL & " , e.rodape_loja "
	strSQL = strSQL & " , e.site "
	strSQL = strSQL & " , e.dt_inicio "
	strSQL = strSQL & " , e.dt_fim "
	strSQL = strSQL & " , e.hora_inicio "
	strSQL = strSQL & " , e.hora_fim "
	strSQL = strSQL & " , e.descricao "
	strSQL = strSQL & " , e.logradouro "
	strSQL = strSQL & " , e.bairro "
	strSQL = strSQL & " , e.pais "
	strSQL = strSQL & " , e.cidade "
	strSQL = strSQL & " , e.estado_evento "
	strSQL = strSQL & " , e.cep_evento "
	strSQL = strSQL & " , e.pavilhao "	
	strSQL = strSQL & " , e.cod_moeda_evento "
	strSQL = strSQL & " , e.cod_moeda_referencia "
	strSQL = strSQL & " , e.proshop_banner_carossel_pt "
	strSQL = strSQL & " , e.proshop_banner_carossel_en "
	strSQL = strSQL & " , e.proshop_banner_carossel_es "
	strSQL = strSQL & " , e.proshop_descricao_pt "
	strSQL = strSQL & " , e.proshop_descricao_en "
	strSQL = strSQL & " , e.proshop_descricao_es "
	strSQL = strSQL & " , e.proshop_google_maps  "
	strSQL = strSQL & " , e.email "
	strSQL = strSQL & " , e.limite_idade "
	strSQL = strSQL & " , e.proshop_email_evento "
	strSQL = strSQL & " , e.proshop_email_contato1 "
	strSQL = strSQL & " , e.proshop_email_contato2 "
	strSQL = strSQL & " , e.bypass_cortesia "	
	strSQL = strSQL & " , m.simbolo "
	strSQL = strSQL & " , e.proshop_token "
	strSQL = strSQL & " , e.proshop_campanha "
	strSQL = strSQL & " , e.regulamento_loja "
	strSQL = strSQL & " , e.regulamento_loja_intl "
	strSQL = strSQL & " , e.regulamento_loja_intl2 "
	strSQL = strSQL & " , e.proshop_campos_obrigatorios "
	strSQL = strSQL & " , e.proshop_campos_obrigatorios_es "
	strSQL = strSQL & " , e.proshop_campos_obrigatorios_en "
	strSQL = strSQL & " , e.proshop_campos_exibir_es "
	strSQL = strSQL & " , e.proshop_campos_exibir_en "
	strSQL = strSQL & " , e.proshop_campos_exibir "
	strSQL = strSQL & " , e.free "
	strSQL = strSQL & " , e.proshop_gtm_id "
	'strSQL = strSQL & " FROM tbl_evento "
	strSQL = strSQL & " FROM tbl_EVENTO e LEFT OUTER JOIN tbl_MOEDA M ON (E.COD_MOEDA_EVENTO = M.COD_MOEDA) "
	strSQL = strSQL & " WHERE cod_evento = " & strCOD_EVENTO
'OBS_TATI
' para pegar o símboldo da moeda oficial do evento
' M.SIMBOLO / FROM tbl_EVENTO E LEFT OUTER JOIN tbl_MOEDA M ON (E.COD_MOEDA_EVENTO = M.COD_MOEDA)

  set objRS = objConn.execute(strSQL)
 
  If NOT objRS.EOF Then
  	session("METRO_ProShopPF_strNomeEvento")			= getValue(objRS,"nome")
	session("METRO_ProShopPF_strNomeCompleto")			= getValue(objRS,"nome_completo")
	session("METRO_ProShopPF_strCabecalhoLoja")		= getValue(objRS,"cabecalho_loja")
	session("METRO_ProShopPF_strRodapeLoja")			= getValue(objRS,"rodape_loja")
	session("METRO_ProShopPF_strLimiteIdade")			= getValue(objRS,"limite_idade")
	session("METRO_ProShopPF_strByPassCortesia")		= getValue(objRS,"bypass_cortesia")
	session("METRO_ProShopPF_IntegracaoToken")			= getValue(objRS,"proshop_token")
	session("METRO_ProShopPF_IntegracaoCampanha")		= getValue(objRS,"proshop_campanha")
	'session("METRO_ProShopPF_CamposObrigatorios")		= getValue(objRS,"proshop_campos_obrigatorios")
	'session("METRO_ProShopPF_CamposExibir")	    	= getValue(objRS,"proshop_campos_exibir")

	session("METRO_ProShopPF_strGoogleMapsEvento")   	= getValue(objRS,"proshop_google_maps")
	session("METRO_ProShopPF_strEmailEvento")   		= getValue(objRS,"proshop_email_evento")
	session("METRO_ProShopPF_strEmailContato1") 		= getValue(objRS,"proshop_email_contato1")
	session("METRO_ProShopPF_strEmailContato2") 		= getValue(objRS,"proshop_email_contato2")
	session("METRO_ProShopPF_strGtmId")		 		= ucase(getValue(objRS,"proshop_gtm_id"))
	
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
	strCodMoedaEvento	= getValue(objRS,"cod_moeda_evento")
	strCodMoedaRef		= getValue(objRS,"cod_moeda_referencia")	
	
	strLogradouro 	= getValue(objRS,"logradouro")
	strBairro 		= getValue(objRS,"bairro")
	strPais 		= getValue(objRS,"pais")
	strCidade 		= getValue(objRS,"cidade")
	strEstado 		= getValue(objRS,"estado_evento")
	strCEP 			= getValue(objRS,"cep_evento")
	strPavilhao 	= getValue(objRS,"pavilhao")
	strEventoFree 	= getValue(objRS,"free")
	
	
		

'OBS_TATI - para pegar o símboldo da moeda oficial do evento se adicionado LEFT JOIN
	strSimboloMoeda		= getValue(objRS,"simbolo")  
	If strSimboloMoeda = "" Then strSimboloMoeda = "$"   
  
	If strLOCALE = "pt-br" Then
		strBanner    = getValue(objRS,"proshop_banner_carossel_pt")
		strDescricao = getValue(objRS,"proshop_descricao_pt")
		session("METRO_ProShopPF_Regulamento")  = getValue(objRS,"regulamento_loja")
		session("METRO_ProShopPF_CamposObrigatorios")		= getValue(objRS,"proshop_campos_obrigatorios")
	    session("METRO_ProShopPF_CamposExibir")	    	= getValue(objRS,"proshop_campos_exibir")
	End If
	If strLOCALE = "en-us" Then
		strBanner    = getValue(objRS,"proshop_banner_carossel_en")
		strDescricao = getValue(objRS,"proshop_descricao_en")
		session("METRO_ProShopPF_Regulamento")  = getValue(objRS,"regulamento_loja_intl")
		session("METRO_ProShopPF_CamposObrigatorios")		= getValue(objRS,"proshop_campos_obrigatorios_en")
	session("METRO_ProShopPF_CamposExibir")	    	= getValue(objRS,"proshop_campos_exibir_en")
	End If
	If strLOCALE = "es" Then
		strBanner    = getValue(objRS,"proshop_banner_carossel_es")
		strDescricao = getValue(objRS,"proshop_descricao_es")
		session("METRO_ProShopPF_Regulamento")  = getValue(objRS,"regulamento_loja_intl2")
		session("METRO_ProShopPF_CamposObrigatorios")		= getValue(objRS,"proshop_campos_obrigatorios_es")
	session("METRO_ProShopPF_CamposExibir")	    	= getValue(objRS,"proshop_campos_exibir_es")
	End If	
		strGoogleMaps = getValue(objRS,"proshop_google_maps")
	Else
		Session.Abandon()
	End If

'OBS_TATI
'INICIO>>>>>
'---------------------------------------------------------------------------------
'Tratamento para ver se tem COTAÇÃO e SIMBOLO DA MOEDA DE CONVERSAO
 
  strMoedaCotacaoRef = 1
  'strCodMoedaRef     = 1
  If strCodMoedaEvento <> "" And strCodMoedaRef <> "" Then
    strSQL =          "SELECT COTACAO_DATA, COTACAO_TAXA "
	strSQL = strSQL & "  FROM tbl_MOEDA_COTACAO "
	strSQL = strSQL & " WHERE COD_MOEDA_ORIGEM = " & strCodMoedaEvento
	strSQL = strSQL & "   AND COD_MOEDA_DESTINO = " & strCodMoedaRef
	strSQL = strSQL & " ORDER BY COTACAO_DATA DESC "
	strSQL = strSQL & " LIMIT 1 "
	'Response.Write(strSQL)
	'Response.End
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
	  strMoedaCotacaoRef = objRS("COTACAO_TAXA")
	End If
	FechaRecordSet objRS
	
'Pega símbolo da moeda de conversão da cotação
	strSQL = "SELECT SIMBOLO, MOEDA FROM tbl_MOEDA WHERE COD_MOEDA = " & strCodMoedaRef
'	response.Write(strSQL)
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
	  strSimboloMoedaRef = objRS("SIMBOLO")&""
	End If
	FechaRecordSet objRS
  End If

  If strSimboloMoedaRef = "" Then strSimboloMoedaRef = "$"
'---------------------------------------------------------------------------------  
'>>>>>>>FIM
%>

<!DOCTYPE html>
<head>

    <!--meta charset="iso-8859-1"//-->
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

<% If session("METRO_ProShopPF_strGtmId") <> "" Then %>	
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','<%=session("METRO_ProShopPF_strGtmId")%>');</script>
<!-- End Google Tag Manager -->
<% End If %>	
	
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
<script language="javascript">
	function submeter(var_action){
		
	  if (var_action == 'default.asp'){
		document.getElementById("to_passo1").action = 'default.asp';
	  }
	  else{
		document.getElementById("to_passo1").action = 'passo1_.asp';
	  }
	document.getElementById("to_passo1").submit();
	}
</script>
</head>
<body class="metro" style="background-color:#F8F8F8">
<% If session("METRO_ProShopPF_strGtmId") <> "" Then %>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=<%=session("METRO_ProShopPF_strGtmId")%>"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<% End If %>
<% if strByPass <> "" Then %> 
 <form name="to_passo1" id="to_passo1" action="" method="post">
   <input type="hidden" name="cod_evento" value="<%=strCOD_EVENTO%>">
   <input type="hidden" name="lng" value="<%=strLng%>">
   <input type="hidden" name="categoria" value="<%=strCategoria%>">
   <input type="hidden" name="db" value="<%=CFG_DB%>">
 </form>

 	<script language="javascript">
		document.getElementById("to_passo1").action = 'passo1_.asp';
		document.getElementById("to_passo1").submit();
	</script> 
<% end if %>
 
 <!-- INI: HeaderBAR --------------------------------------------------------------------- //-->
 <div class="page-footer padding5" style="background-color:#282828;"></div>
 <!-- FIM: HeaderBAR --------------------------------------------------------------------- //-->

 <!-- INI: PAGE CONTAINER ------------------------------------------------------------- //-->
 <div class="page container"> <!-- container-phone | container-tablet | container-large //-->


    <!-- INI: page-header -------------------------------------------------------------- //--> 
    <div class="page-header">

		<!-- INI: LOGO Promotora //-->	
        <% If session("METRO_ProShopPF_strCabecalhoLoja") <>"" Then %>
            <div class="grid" style="margin-bottom:35px">
                 <div class="row">
                     <div class="span114" style="background-color:#FFF;"><!-- level 1 column //-->
                         <div sclass="row">
                             <img class='' src='../imgdin/<%=session("METRO_ProShopPF_strCabecalhoLoja")%>' style='margin-bottom:15px;margin-top:15px;'>
                         </div>
                     </div>
                 </div>
            </div>
        <% End If %>
        <!-- FIM: LOGO Promotora //-->	     		
	    
		<!-- INI: MENU  //-->	
        <div class="navigation-bar dark">
                <div class="navbar-content" id="eventBar">

                    <a href="" onClick="javascript:submeter('default.asp');" class="element"><strong><%=session("METRO_ProShopPF_strNomeEvento")%></strong></a>
                                                                                                  
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
                        <!--div class="element input-element" >
                            <form>
                                <div class="input-control text">
                                    <input type="text" style="background-color:#555555; border:0px; color:#ffffff">
                                    <button class="btn-search fg-white" ></button>
                                </div>
                            </form>
                    	</div//-->

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
    <%
	'caso de algum problema em abrir a loja emite aviso.
	if strCOD_EVENTO = "0" Then%>
    <div class="page-region-content">
    
        <div class="grid">
             <div class="row">
    			<p>C&Oacute;DIGO DE EVENTO INV&Aacute;LIDO, E/OU A LOJA ESTA FECHADA</p>
                <script language="javascript">
					document.getElementById("eventBar").innerHTML = "ProShop Aviso.";				
				</script>         
             </div>
        </div>
    </div>
    <% 
		response.end() 
		End If
		
	%>
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
                                    <h3><b><%=(objLang.SearchIndex("data_hora",0))%></b></h3>
                                    <p class="tertiary-text-secondary">                                    
										<% if year(strDtInicio) <> year(strDtFim) Then %>
	                                       <%=DAY(strDtInicio)&" ("&objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtInicio)))),0)&")"%>&nbsp;<%=(objLang.SearchIndex("de",0))%>&nbsp;<%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtInicio)))),0)%> | <%=year(strDtInicio)%>&nbsp;<%=(objLang.SearchIndex("a_craseado",0))%>&nbsp;<%=DAY(strDtFim)&" ("&objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtFim)))),0)&")"%> de <%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtFim)))),0)%> | <%=year(strDtFim)%> <br>
                                  		<% else if (month(strDtInicio) <> month(strDtFim)) AND year(strDtInicio) = year(strDtFim) Then %>
											<%=DAY(strDtInicio)&" ("&objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtInicio)))),0)&")"%>&nbsp;<%=(objLang.SearchIndex("de",0))%>&nbsp;<%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtInicio)))),0)%>&nbsp;<%=(objLang.SearchIndex("a_craseado",0))%>&nbsp;<%=DAY(strDtFim)&" ("&objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtFim)))),0)&")"%>&nbsp;<%=(objLang.SearchIndex("de",0))%>&nbsp;<%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtFim)))),0)%> | <%=year(strDtFim)%> <br>										
                                        <% 		else %>
											<%=DAY(strDtInicio)&" ("&objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtInicio)))),0)&")"%>&nbsp;<%=(objLang.SearchIndex("a_craseado",0))%>&nbsp;<%=DAY(strDtFim)&" ("&objLang.SearchIndex(lcase(RemoveAcento(DiaSemanaAbreviado(weekday(strDtFim)))),0)&")"%>&nbsp;<%=(objLang.SearchIndex("de",0))%>&nbsp;<%=objLang.SearchIndex(lcase(RemoveAcento(MesExtenso(month(strDtFim)))),0)%> | <%=year(strDtFim)%> <br>
										<% 		end if 
										    end if
										%>
                                        <%if strHrInicio <> "" Then%>
											<%=strHrInicio%> - <%=strHrFim%> <%=(objLang.SearchIndex("horario_de_brasilia",0))%>
                                        <%end if%>
                                    </p>

                                  <%
								  strSQL = " SELECT  min(tbl_PrcLista.PRC_LISTA) AS prc_min, max(tbl_PrcLista.PRC_LISTA) AS prc_max"
								  strSQL = strSQL & " FROM tbl_Produtos LEFT OUTER JOIN tbl_PrcLista ON (tbl_Produtos.COD_PROD = tbl_PrcLista.COD_PROD AND 1 BETWEEN tbl_PrcLista.QTDE_INIC AND tbl_PrcLista.QTDE_FIM)"
								  strSQL = strSQL & " LEFT JOIN tbl_produtos_grupo on (tbl_Produtos.GRUPO = tbl_produtos_grupo.GRUPO AND tbl_produtos_grupo.COD_EVENTO = " & strCOD_EVENTO & ")"
								  strSQL = strSQL & " WHERE tbl_Produtos.LOJA_SHOW = 1"
								  strSQL = strSQL & " AND tbl_PrcLista.PRC_LISTA > 0"
								  strSQL = strSQL & " AND tbl_Produtos.COD_EVENTO = " & strCOD_EVENTO 
								  if strCategoria <> "0" Then
								  	strSQL = strSQL & " AND tbl_PrcLista.cod_status_preco = " & strCategoria
								  end if
								  'response.write strSQL
								  set objRS = objConn.execute(strSQL)
								  
								  if not objRS.eof Then
								  %> 
                                    <!--div style="width:100%; height:40px; background-color:#EBEBEB; color:#999999; text-align:center; padding-top:7px; border:1px solid #666;"//-->

<!--                                        <font size="+1">R$ <%'=getValue(objRS,"prc_min")%> - R$ <%'=getValue(objRS,"prc_max")%></font>//-->

                                        <% 'OBS_TATI - como ficaria
										' se tem moeda de referencia com cotação e é INTL mostra + " / preços cotação "
										'---------------------------------------------------------------------------------------------------------------------------
										%>
                                        <font size="+1">
										<% if getValue(objRS,"prc_min") = "" AND getValue(objRS,"prc_max") = "" Then 
                                        	if strEventoFree = 1 then%>
											<div style="width:100%; height:40px; background-color:#EBEBEB; color:#999999; text-align:center; padding-top:7px; border:1px solid #666;">
											<font size="+1">
											<%=objLang.SearchIndex("evento_gratuito",0)%>
											<font></div>
										<%	end if
										 Else %>
										 <div style="width:100%; height:40px; background-color:#EBEBEB; color:#999999; text-align:center; padding-top:7px; border:1px solid #666;">
											<font size="+1">
											<%	if getValue(objRS,"prc_min") = getValue(objRS,"prc_max") Then %>
													<%=strSimboloMoeda & " " & getValue(objRS,"prc_min")%>
													<% IF strSimboloMoedaRef <> "" AND strLOCALE <> "pt-br" Then %>
														(<%= strSimboloMoedaRef & " " & FormatNumber(getValue(objRS,"prc_min") * strMoedaCotacaoRef )%> )
													<% End if
												Else %>
													<%= strSimboloMoeda & " " & getValue(objRS,"prc_min")%> - <%= strSimboloMoeda & " " & getValue(objRS,"prc_max")%>
													<% IF strSimboloMoedaRef <> "" AND strLOCALE <> "pt-br" Then %>
														(<%= strSimboloMoedaRef & " " & FormatNumber(getValue(objRS,"prc_min") * strMoedaCotacaoRef )%> - <%= strSimboloMoedaRef & " " & FormatNumber(getValue(objRS,"prc_max") * strMoedaCotacaoRef )%>)
													<% End if 
												end if %>
											</div></font>
										<%	End If 
										'---------------------------------------------------------------------------------------------------------------------------										
										'FIM OBS_TATI%>
                                        
                                  <%
								  end if%>
								  <br>
                                  <div onClick="javascript:submeter('Passo1.asp');" style="width:100%; height:40px; cursor:pointer; background-color:#090; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                        <font size="+1"><b><%=(objLang.SearchIndex("botao_inscreva",0))%></b></font>
                                    </div>
                                  <br>
								  <% if strDescricao <> "" Then								  
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
                         	<!--div class="row"//-->                                								                          
                                <!--div onClick="javascript:submeter('Passo1.asp');" style="width:100%; height:40px; cursor:pointer; background-color:#090; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                    <font size="+1"><b><%=(objLang.SearchIndex("botao_inscreva",0))%></b></font>
                                </div>
                                </a//-->
                                <div class="grid">
                                    <div class="row">
                                            <div class="" style="text-align:left;">
											  <%
											  	'session("METRO_ProShopPF_strgoogleMapsEvento") = "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3453.828106902864!2d-51.18828538436066!3d-30.041788938114816!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x95197823928efe6b%3A0x71b00d0d3e0c07be!2sRua+Jo%C3%A3o+Abbott+-+Petr%C3%B3polis%2C+Porto+Alegre+-+RS!5e0!3m2!1sen!2sbr!4v1523899730301'"
											  	 if session("METRO_ProShopPF_strGoogleMapsEvento") <> "" Then %>
                                                <iframe src="<%=session("METRO_ProShopPF_strGoogleMapsEvento")%>"
                                                        width="100%" height="400" frameborder="0" style="border:0" allowfullscreen>
                                                </iframe>
                                                
                                                
                                              <% End If %>
                                                <h3><b><%=strPavilhao%></b></h3>
                                                <p class="tertiary-text-secondary">
                                                    <%=strLogradouro%><br>
                                                    <%=strBairro%>,<%=strCidade%> - <%=strEstado%>, <%=strCEP%>
                                                    <br><br>
                                                    <small></small>
                                                </p>
                                            </div>
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
 <form name="to_passo1" id="to_passo1" action="" method="post">
   <input type="hidden" name="cod_evento" value="<%=strCOD_EVENTO%>">
   <input type="hidden" name="lng" value="<%=strLng%>">
   <input type="hidden" name="categoria" value="<%=strCategoria%>">
   <input type="hidden" name="db" value="<%=CFG_DB%>">
 </form>
 <!--#include file="_include/IncludeFooter.asp" -->
 <!-- FIM: Footer --------------------------------------------------------------------- //-->


</body>
</html>