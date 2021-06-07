<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<%
  Option Explicit 
  Session.LCID     = 1046
  Session.Timeout  = 500
  Response.Expires = 0 
  
  dim i
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
                         <img class="" src="./imgdin/logo.png" style="margin-bottom:15px;margin-top:15px;">
                     </div>
                 </div>
             </div>
             <div class="row">
                <div class="stepper rounded" data-steps="4" data-role="stepper" data-start="4" style="width:100%;"></div>
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
                    <a href="default.asp" class="element"><strong>Feira Couromoda 2019</strong></a>
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
                            <BR>
                             Olá <b>Rodrigo Brunet.</b><br>
                             Esta é sua confirmação do pedido para o evento FEIRA COUROMODA 2019
                            <BR><BR>
                             Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
                             Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure 
                             dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
                             non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.                            
                            <BR><BR>
                             Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
                             Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure 
                             dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
                             non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.                            
                            <BR><BR>

                            <address>
                                <strong>São Paulo Feiras</strong><br />
                                Rua João Aboutt 319/503<br>
                                Porto Alegre/RS, Brasil<br>
                                <abbr title="Phone">P:</abbr> (123) 456-7890
                            </address>
                    
                            <address>
                                <strong>Dúvidas</strong><br>
                                <a href="mailto:#">atendimento@couromoda.com</a>
                            </address>



                            <legend>Resumo do pedido</legend>
                            <div style="display:block; background-color:#EEE; padding:10px;">
                                <!-- INI: Bloco produtos //-->
                                <div class="grid">
                                     <div class="row">
                                        <div class="tile no-border" style="width:100%; height:auto; margin:0 auto;  text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:5px; border:0px solid #4390DF;">
                                            <font size="+1">
                                                <!-- <b>Nº 03022018154531</b> //-->
                                                <font size="+1">
					                                <span style="color:#0099CC; font-weight:bold;">03/02/2018</span>
					                            </font>
                                                <br>Inscrições [9002345 | 9002346 | 9002347 | 9002348]
                                                <br><br>
                                                Forma de pagamento
                                                <br>MasterCard (final 1234)
                                            </font>
                                        </div>
                                     </div>
                        
                                     <div class="row">
                                        <div class="tile" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:5px; margin-top:5px; border:0px solid #4390DF;">
                                            <font size="+1">
                                                Congresso + Feira (lote 2)
                                                <br><span style="color:#0099CC;">3x R$ 596,00</span>
                                            </font><BR>
                                            
                                            <div class="accordion margin10" data-role="accordion" data-closeany="false">
                                                <div class="accordion-frame">
                                                    <a class=" heading bg-active-grayLight fg-darkCyan" href="#">Rodrigo Brunet</a>
                                                </div>
                                                <div class="accordion-frame">
                                                    <a class=" heading bg-active-grayLight fg-darkCyan" href="#">Tatiana Fliger</a>
                                                </div>
                                                <div class="accordion-frame">
                                                    <a class=" heading bg-active-grayLight fg-darkCyan" href="#">Gabriel Schunck</a>
                                                </div>
                                            </div>                    
                                        </div>
                                     </div>

                                     <div class="row">
                                        <div class="tile" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:5px; margin-top:5px; border:0px solid #4390DF;">
                                            <font size="+1">
                                                Workshop Joe Satriani
                                                <br><span style="color:#0099CC;">1x R$ 96,00</span>
                                            </font>
                        
                                            <div class="accordion margin10" data-role="accordion" data-closeany="false">
                                                <div class="accordion-frame">
                                                    <a class=" heading bg-active-grayLight fg-darkCyan" href="#">Rodrigo Brunet</a>
                                                </div>
                                            </div>                    
                                        </div>
                                     </div>

                                     <div class="row">
                                        <div class="tile" style="width:100%; height:auto; margin:0 auto;  background-color:#CCC; color:#666; text-align:right; padding-top:7px; padding-right:10px; padding-bottom:5px; margin-top:5px; border:0px solid #4390DF;">
                                            <font size="+1">
                                                TOTAL
                                                <br><span style="color:#0099CC; font-weight:bold;">R$ 1884,00</span>
                                            </font>
                                        </div>
                                     </div>
                                </div>                                
                                <!-- FIM: Bloco produtos //-->

                            </div>


                           
                         </div>
						 <!-- FIM: 1 COLUNA //-->


						 <!-- INI: 2 COLUNA //-->
                         <div class="span4">
                                <div class="row">
                                    <div class="tile " style="width:100%; height:auto; margin:0 auto; margin-bottom:10px; 
                                                              background-color:#CCC; color:#666; text-align:right; 
                                                              padding-top:7px; padding-right:10px; padding-bottom:25px; border:1px solid #FFF;">
                                        <font size="+2"><span style="color:#009966;">EVENTO</span></font>
                                        <br><br>
										<b>Feira Couromoda 2019</b>
                                        <br>
										De 12(sex) à 15(dom) de janeiro | 2019 | 09:00 - 19:00 (horário padrão de Brasília)                                         
                                    </div>
								</div>

                         	<div class="row">                                

                                <div class="grid">
                                    <div class="row">
                                            <div class="" style="text-align:left;">
												<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3658.582543663452!2d-46.61464328502308!3d-23.511541284707725!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x94ce58bd535698b1%3A0x32d44ab158b94c5d!2sExpo+Center+Norte!5e0!3m2!1spt-BR!2sbr!4v1516480962680"
                                                        width="100%" height="400" frameborder="0" style="border:0" allowfullscreen>
                                                </iframe>
                                                <h3><b>Expo Center Norte</b></h3>
                                                <p class="tertiary-text-secondary">
                                                    Rua José Bernardo Pinto, 333<br>
                                                    Vila Guilherme, São Paulo - SP, 02055-000	
                                                    <br><br>
                                                    <small></small>
                                                </p>
                                            </div>
                                    </div>   
                                </div>
                         </div>
                         
                         <!-- INI: Botão(es) ... //-->
                            <div class="row"  style="margin-top:15px;">
                                    <a href="default.asp">
                                    <div style="width:100%; height:40px; cursor:pointer; background-color:#0CF; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                        <font size="+1"><b>NOVO PEDIDO</b></font>
                                    </div>
                                    </a>
                            </div>
                         <!-- FIM: Botão(es) ... //-->

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