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
 
 strLng			= getParam("lng") 'BR, [US ou EN], ES
 
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
	Case "BR"		strLOCALE = "pt-br"
	Case "US","EN"	strLOCALE = "en-us" 'colocar idioma INTL
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
<% If session("METRO_ProShopPF_strGtmId") <> "" Then %>	
	<!-- Google Tag Manager -->
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
	new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
	j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
	'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
	})(window,document,'script','dataLayer','<%=session("METRO_ProShopPF_strGtmId")%>');</script>
	<!-- End Google Tag Manager -->
<% End If %>
</head>
<body class="metro" style="background-color:#F8F8F8">
<% If session("METRO_ProShopPF_strGtmId") <> "" Then %>
	<!-- Google Tag Manager (noscript) -->
	<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=<%=session("METRO_ProShopPF_strGtmId")%>"
	height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
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
                         <img class="" src="../imgdin/logotipo-couromoda2018.png" style="margin-bottom:15px;margin-top:15px;">
                     </div>
                 </div>
             </div>
             <div class="row">
                <div class="stepper rounded" data-steps="4" data-role="stepper" data-start="3" style="width:100%;"></div>
                <!-- nav class="breadcrumbs small">
                    <ul>
                        <li><a href="#">1</a></li>
                        <li class="active"><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                    </ul>
                </nav //-->
             </div>
        </div>
		<!-- FIM: LOGO Promotora //-->	
        
        
		<!-- INI: MENU  //-->	
        <div class="navigation-bar dark">
                <div class="navbar-content">
                    <a href="default.asp" class="element"><strong>Feira + Fórum Couromoda 2019</strong></a>
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


                                <form>
                                    <fieldset>
                                        <legend><b>Comprador</b></legend>
                                        <label>Identifica&ccedil;&atilde;o</label>
                                        <div class="input-control text size3" data-role="input-control">
                                            <input type="text" placeholder="nome">
                                        </div>
                                        <div class="input-control text size3" data-role="input-control">
                                            <input type="text" placeholder="sobrenome">
                                        </div>                                        
                                        
                                        <label>e-mail</label>
                                        <div class="input-control text size3 " data-role="input-control">
                                            <input type="text" placeholder="e-mail" autofocus>
                                        </div>
                                        <div class="input-control text size3 " data-role="input-control">
                                            <input type="text" placeholder="confirmar e-mail" autofocus>
                                        </div>
                                    </fieldset>

                                    <fieldset>
                                        <legend><b>Pagamento</b></legend>
                                        <label>Forma de pagamento</label>
                                        <div class="input-control select size3">
                                            <select onChange="if (this.value=='Boleto') {document.getElementById('dados_card').style='display:none; background-color:#EEE; padding:10px;'} else {document.getElementById('dados_card').style='display:block; background-color:#EEE; padding:10px;'}; return false;">
                                                <option value="Card">Cart&atilde;o de cr&eacute;dito</option>
                                                <option value="Boleto">Boleto banc&aacute;rio</option>
                                            </select>
                                        </div>                                        
                                        <div id="dados_card" style="display:block; background-color:#EEE; padding:10px;">
                                            <label>N&uacute;mero do cart&atilde;o</label>
                                            <div class="input-control text size3" data-role="input-control">
                                                <input type="text" placeholder="Número do cartão de crédito" autofocus>
                                            </div>
                                            <div class="input-control text size1" data-role="input-control">
                                                <input type="text" placeholder="CSC" autofocus>
                                            </div>
                                            <label>Validade</label>
                                            <div class="input-control select size1">
                                                <select>
                                                    <% for i=1 to 12 %>
                                                    <option><%=i%></option>
                                                    <% next %>
                                                </select>
                                            </div>                                        
                                            <div class="input-control select size2">
                                                <select>
                                                    <% for i=year(now) to year(now) + 12 %>
                                                    <option><%=i%></option>
                                                    <% next %>
                                                </select>
                                            </div>                                        
                                            <label>Titular</label>
                                            <div class="input-control text" data-role="input-control">
                                                <input type="text" placeholder="Nome como aparece no cartão">
                                            </div>
                                            <label>Data nascimento e CFP do titular</label>
                                            <div class="input-control text size2" data-role="input-control">
                                                <input type="text" placeholder="DD/MM/AAAA">
                                            </div>
                                            <div class="input-control text size2" data-role="input-control">
                                                <input type="text" placeholder="CPF">
                                            </div>
                                            <label>Celular do titular</label>
                                            <div class="input-control text size1" data-role="input-control">
                                                <input type="text" placeholder="DDD ">
                                            </div>
                                            <div class="input-control text size2" data-role="input-control">
                                                <input type="text" placeholder="número ">
                                            </div>

                                            <label>Parcelas</label>
                                            <div class="input-control select size1">
                                                <select>
                                                    <% for i=1 to 12 %>
                                                    <option><%=i%></option>
                                                    <% next %>
                                                </select>
                                            </div>    
                                        </div>
                                    </fieldset>

                                    <fieldset>
                                        <legend><b>Informa&ccedil;&otilde;es de cobran&ccedil;a</b></legend>




                                            <label>Nome do Tomador / Raz&atilde;o Social</label>
                                            <div class="input-control text" data-role="input-control">
                                                <input type="text" placeholder="">
                                            </div>


                                            <label>Tipo documento</label>
                                            <div class="input-control select size1">
                                                <select>
                                                    <option>CPF</option>
                                                    <option>CNPJ</option>
                                                </select>
                                            </div>                                        
                                            <div class="input-control text size3" data-role="input-control">
                                                <input type="text" placeholder="número ">
                                            </div>

                                            <label>Pais</label>
                                            <div class="input-control select size3">
                                                <select>
                                                <option value="África do Sul">África do Sul</option>
                                                <option value="Albânia">Alb&acirc;nia</option>
                                                <option value="Alemanha">Alemanha</option>
                                                <option value="Andorra">Andorra</option>
                                                <option value="Angola">Angola</option>
                                                <option value="Anguilla">Anguilla</option>
                                                <option value="Antigua">Antigua</option>
                                                <option value="Arábia Saudita">Ar&aacute;bia Saudita</option>
                                                <option value="Argentina">Argentina</option>
                                                <option value="Armênia">Arm&ecirc;nia</option>
                                                <option value="Aruba">Aruba</option>
                                                <option value="Austrália">Austr&aacute;lia</option>
                                                <option value="Áustria">Áustria</option>
                                                <option value="Azerbaijão">Azerbaij&atilde;o</option>
                                                <option value="Bahamas">Bahamas</option>
                                                <option value="Bahrein">Bahrein</option>
                                                <option value="Bangladesh">Bangladesh</option>
                                                <option value="Barbados">Barbados</option>
                                                <option value="Bélgica">B&eacute;lgica</option>
                                                <option value="Benin">Benin</option>
                                                <option value="Bermudas">Bermudas</option>
                                                <option value="Botsuana">Botsuana</option>
                                                <option value="Brasil" selected>Brasil</option>
                                                <option value="Brunei">Brunei</option>
                                                <option value="Bulgária">Bulg&aacute;ria</option>
                                                <option value="Burkina Fasso">Burkina Fasso</option>
                                                <option value="botão">bot&atilde;o</option>
                                                <option value="Cabo Verde">Cabo Verde</option>
                                                <option value="Camarões">Camar&otilde;es</option>
                                                <option value="Camboja">Camboja</option>
                                                <option value="Canadá">Canad&aacute;</option>
                                                <option value="Cazaquistão">Cazaquist&atilde;o</option>
                                                <option value="Chade">Chade</option>
                                                <option value="Chile">Chile</option>
                                                <option value="China">China</option>
                                                <option value="Cidade do Vaticano">Cidade do Vaticano</option>
                                                <option value="Colômbia">Col&ocirc;mbia</option>
                                                <option value="Congo">Congo</option>
                                                <option value="Coréia do Sul">Cor&eacute;ia do Sul</option>
                                                <option value="Costa do Marfim">Costa do Marfim</option>
                                                <option value="Costa Rica">Costa Rica</option>
                                                <option value="Croácia">Cro&aacute;cia</option>
                                                <option value="Dinamarca">Dinamarca</option>
                                                <option value="Djibuti">Djibuti</option>
                                                <option value="Dominica">Dominica</option>
                                                <option value="EUA">EUA</option>
                                                <option value="Egito">Egito</option>
                                                <option value="El Salvador">El Salvador</option>
                                                <option value="Emirados Árabes">Emirados &Aacute;rabes</option>
                                                <option value="Equador">Equador</option>
                                                <option value="Eritréia">Eritr&eacute;ia</option>
                                                <option value="Escócia">Esc&oacute;cia</option>
                                                <option value="Eslováquia">Eslov&aacute;quia</option>
                                                <option value="Eslovênia">Eslov&ecirc;nia</option>
                                                <option value="Espanha">Espanha</option>
                                                <option value="Estônia">Est&ocirc;nia</option>
                                                <option value="Etiópia">Eti&oacute;pia</option>
                                                <option value="Fiji">Fiji</option>
                                                <option value="Filipinas">Filipinas</option>
                                                <option value="Finlândia">Finl&acirc;ndia</option>
                                                <option value="França">Fran&ccedil;a</option>
                                                <option value="Gabão">Gab&atilde;o</option>
                                                <option value="Gâmbia">G&acirc;mbia</option>
                                                <option value="Gana">Gana</option>
                                                <option value="Geórgia">Ge&oacute;rgia</option>
                                                <option value="Gibraltar">Gibraltar</option>
                                                <option value="Granada">Granada</option>
                                                <option value="Grécia">Gr&eacute;cia</option>
                                                <option value="Guadalupe">Guadalupe</option>
                                                <option value="Guam">Guam</option>
                                                <option value="Guatemala">Guatemala</option>
                                                <option value="Guiana">Guiana</option>
                                                <option value="Guiana Francesa">Guiana Francesa</option>
                                                <option value="Guiné-bissau">Guin&eacute;-bissau</option>
                                                <option value="Haiti">Haiti</option>
                                                <option value="Holanda">Holanda</option>
                                                <option value="Honduras">Honduras</option>
                                                <option value="Hong Kong">Hong Kong</option>
                                                <option value="Hungria">Hungria</option>
                                                <option value="Iêmen">I&ecirc;men</option>
                                                <option value="Ilhas Cayman">Ilhas Cayman</option>
                                                <option value="Ilhas Cook">Ilhas Cook</option>
                                                <option value="Ilhas Curaçao">Ilhas Cura&ccedil;ao</option>
                                                <option value="Ilhas Marshall">Ilhas Marshall</option>
                                                <option value="Ilhas Turks & Caicos">Ilhas Turks & Caicos</option>
                                                <option value="Ilhas Virgens (brit.)">Ilhas Virgens (brit.)</option>
                                                <option value="Ilhas Virgens(amer.)">Ilhas Virgens(amer.)</option>
                                                <option value="Ilhas Wallis e Futuna">Ilhas Wallis e Futuna</option>
                                                <option value="Índia">Índia</option>
                                                <option value="Indonésia">Indon&eacute;sia</option>
                                                <option value="Inglaterra">Inglaterra</option>
                                                <option value="Irlanda">Irlanda</option>
                                                <option value="Islândia">Isl&acirc;ndia</option>
                                                <option value="Israel">Israel</option>
                                                <option value="Itália">It&aacute;lia</option>
                                                <option value="Jamaica">Jamaica</option>
                                                <option value="Japão">Jap&atilde;o</option>
                                                <option value="Jordânia">Jord&acirc;nia</option>
                                                <option value="Kuwait">Kuwait</option>
                                                <option value="Latvia">Latvia</option>
                                                <option value="Líbano">L&iacute;bano</option>
                                                <option value="Liechtenstein">Liechtenstein</option>
                                                <option value="Lituânia">Litu&acirc;nia</option>
                                                <option value="Luxemburgo">Luxemburgo</option>
                                                <option value="Macau">Macau</option>
                                                <option value="Macedônia">Maced&ocirc;nia</option>
                                                <option value="Madagascar">Madagascar</option>
                                                <option value="Malásia">Mal&aacute;sia</option>
                                                <option value="Malaui">Malaui</option>
                                                <option value="Mali">Mali</option>
                                                <option value="Malta">Malta</option>
                                                <option value="Marrocos">Marrocos</option>
                                                <option value="Martinica">Martinica</option>
                                                <option value="Mauritânia">Maurit&acirc;nia</option>
                                                <option value="Mauritius">Mauritius</option>
                                                <option value="México">M&eacute;xico</option>
                                                <option value="Moldova">Moldova</option>
                                                <option value="Mônaco">M&ocirc;naco</option>
                                                <option value="Montserrat">Montserrat</option>
                                                <option value="Nepal">Nepal</option>
                                                <option value="Nicarágua">Nicar&aacute;gua</option>
                                                <option value="Niger">Niger</option>
                                                <option value="Nigéria">Nig&eacute;ria</option>
                                                <option value="Noruega">Noruega</option>
                                                <option value="Nova Caledônia">Nova Caled&ocirc;nia</option>
                                                <option value="Nova Zelândia">Nova Zel&acirc;ndia</option>
                                                <option value="Omã">Om&atilde;</option>
                                                <option value="Palau">Palau</option>
                                                <option value="Panamá">Panam&aacute;</option>
                                                <option value="Papua-nova Guiné">Papua-nova Guin&eacute;</option>
                                                <option value="Paquistão">Paquist&atilde;o</option>
                                                <option value="Peru">Peru</option>
                                                <option value="Polinésia Francesa">Polin&eacute;sia Francesa</option>
                                                <option value="Polônia">Pol&ocirc;nia</option>
                                                <option value="Porto Rico">Porto Rico</option>
                                                <option value="Portugal">Portugal</option>
                                                <option value="Qatar">Qatar</option>
                                                <option value="Quênia">Qu&ecirc;nia</option>
                                                <option value="Rep. Dominicana">Rep. Dominicana</option>
                                                <option value="Rep. Tcheca">Rep. Tcheca</option>
                                                <option value="Reunion">Reunion</option>
                                                <option value="Romênia">Rom&ecirc;nia</option>
                                                <option value="Ruanda">Ruanda</option>
                                                <option value="Rússia">R&uacute;ssia</option>
                                                <option value="Saipan">Saipan</option>
                                                <option value="Samoa Americana">Samoa Americana</option>
                                                <option value="Senegal">Senegal</option>
                                                <option value="Serra Leone">Serra Leone</option>
                                                <option value="Seychelles">Seychelles</option>
                                                <option value="Singapura">Singapura</option>
                                                <option value="Síria">S&iacute;ria</option>
                                                <option value="Sri Lanka">Sri Lanka</option>
                                                <option value="St. Kitts & Nevis">St. Kitts & Nevis</option>
                                                <option value="St. Lúcia">St. L&uacute;cia</option>
                                                <option value="St. Vincent">St. Vincent</option>
                                                <option value="Sudão">Sud&atilde;o</option>
                                                <option value="Suécia">Su&eacute;cia</option>
                                                <option value="Suiça">Sui&ccedil;a</option>
                                                <option value="Suriname">Suriname</option>
                                                <option value="Tailândia">Tail&acirc;ndia</option>
                                                <option value="Taiwan">Taiwan</option>
                                                <option value="Tanzânia">Tanz&acirc;nia</option>
                                                <option value="Togo">Togo</option>
                                                <option value="Trinidad & Tobago">Trinidad & Tobago</option>
                                                <option value="Tunísia">Tun&iacute;sia</option>
                                                <option value="Turquia">Turquia</option>
                                                <option value="Ucrânia">Ucr&acirc;nia</option>
                                                <option value="Uganda">Uganda</option>
                                                <option value="Uruguai">Uruguai</option>
                                                <option value="Venezuela">Venezuela</option>
                                                <option value="Vietnã">Vietn&atilde;</option>
                                                <option value="Zaire">Zaire</option>
                                                <option value="Zâmbia">Z&acirc;mbia</option>
                                                <option value="Zimbábue">Zimb&aacute;bue</option>
                                                </select>
                                            </div>                                        
                                            <label>CEP</label>
                                            <div class="input-control text size2" data-role="input-control">
                                                <input type="text" placeholder="type text" autofocus>
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>
                                            <label>Endere&ccedil;o</label>
                                            <div class="input-control text" data-role="input-control">
                                                <input type="text" placeholder="type text" autofocus>
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>
                                            <label>Complemento/Bairro</label>
                                            <div class="input-control text" data-role="input-control">
                                                <input type="text" placeholder="type text" autofocus>
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>
                                            
                                            <label>Estado / Cidade</label>
                                            <div class="input-control select size2">
                                                <select name="estados-brasil">
                                                    <option value="AC">Acre</option>
                                                    <option value="AL">Alagoas</option>
                                                    <option value="AP">Amap&aacute;</option>
                                                    <option value="AM">Amazonas</option>
                                                    <option value="BA">Bahia</option>
                                                    <option value="CE">Cear&aacute;</option>
                                                    <option value="DF">Distrito Federal</option>
                                                    <option value="ES">Esp&iacute;rito Santo</option>
                                                    <option value="GO">Goi&aacute;s</option>
                                                    <option value="MA">Maranh&atilde;o</option>
                                                    <option value="MT">Mato Grosso</option>
                                                    <option value="MS">Mato Grosso do Sul</option>
                                                    <option value="MG">Minas Gerais</option>
                                                    <option value="PA">Par&aacute;</option>
                                                    <option value="PB">Para&iacute;ba</option>
                                                    <option value="PR">Paran&aacute;</option>
                                                    <option value="PE">Pernambuco</option>
                                                    <option value="PI">Piau&iacute;</option>
                                                    <option value="RJ">Rio de Janeiro</option>
                                                    <option value="RN">Rio Grande do Norte</option>
                                                    <option value="RS">Rio Grande do Sul</option>
                                                    <option value="RO">Rond&ocirc;nia</option>
                                                    <option value="RR">Roraima</option>
                                                    <option value="SC">Santa Catarina</option>
                                                    <option value="SP">S&atilde;o Paulo</option>
                                                    <option value="SE">Sergipe</option>
                                                    <option value="TO">Tocantins</option>
                                                </select>
                                            </div>                                        
                                            <div class="input-control text size3" data-role="input-control">
                                                <input type="text" placeholder="type text" autofocus>
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>


                                    </fieldset>


                                </form>

                                <div class="row">
                                    <div class="grid">
                                        <div class="row">
                                            <div class="span2">
                                                <a href="Passo2_.asp">
                                                <div style="width:100%; height:40px; cursor:pointer; background-color:#C00; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                                    <font size="+1"><b>VOLTAR</b></font>
                                                </div>
                                                </a>
                                            </div>
                                            <div class="span8">
                                                <a href="Passo4_.asp">
                                                <div style="width:100%; height:40px; cursor:pointer; background-color:#090; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                                    <font size="+1"><b>CONFIRMAR</b></font>
                                                </div>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                         </div>
						 <!-- FIM: 1 COLUNA //-->


						 <!-- INI: 2 COLUNA //-->
                         <div class="span4">
                                <div class="row">
                                    <div class="tile " style="width:100%; height:auto; margin:0 auto; margin-bottom:10px; 
                                                              background-color:#CCC; color:#666; text-align:right; 
                                                              padding-top:7px; padding-right:10px; padding-bottom:25px; border:1px solid #FFF;">
                                        <font size="+2"><span style="color:#009966;">Sobre o Evento</span></font>
                                        <br><br>
										<b>Feira Couromoda 2019</b>
                                        <br>
										De 12(sex) &agrave; 15(dom) de janeiro | 2019 | 09:00 - 19:00 (hor&aacute;rio padr&atilde;o de Bras&iacute;lia)                                         
                                    </div>
								</div>

                         	<div class="row">                                

                                
                                <div class="grid">
                                    <div class="row">
                                            <div class="" style="text-align:left;">
												<% if session("METRO_ProShopPF_strGoogleMapsEvento") <> "" Then %>
                                                <iframe src="<%=session("METRO_ProShopPF_strGoogleMapsEvento")%>"
                                                        width="100%" height="400" frameborder="0" style="border:0" allowfullscreen>
                                                </iframe>                                                
                                                
                                              <% End If %>
                                               
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