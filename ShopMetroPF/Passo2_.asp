<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<%
  Option Explicit 
  Session.LCID     = 1046
  Session.Timeout  = 500
  Response.Expires = 0 
  
  Dim flagCopy
  flagCopy = false
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
 <div class="page container">


    <!-- INI: page-header -------------------------------------------------------------- //--> 
    <div class="page-header">

		<!-- INI: LOGO Promotora //-->	
        <div class="grid" style="margin-bottom:0px">
             <div class="row">
                 <div class="span114" style="background-color:#FFF;"><!-- level 1 column //-->
                     <div class="row">
                         <img class="" src="./imgdin/logo.png" style="margin-bottom:15px;margin-top:15px;">
                     </div>
                 </div>
             </div>
             <div class="row">
                <div class="stepper rounded" data-steps="4" data-role="stepper" data-start="2" style="width:100%;"></div>
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
                    <a href="#" class="element"><strong>Feira Couromoda 2019</strong></a>
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
                                    <h2>Resumo da inscrição</h2>
                                </div>
                                
                                
                                <div class="row">
                                
                                    <!-- INI: LISTA PRODUTOS SELECIONADOS//-->	
                                    <div class="tile selected" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:1px solid #4390DF;">
                                        <font size="+1">
                                            FEIRA - Credenciamento gratuito
                                            <br><span style="color:#009966;">GRATUITO</span>
                                        </font>
                                        <br><br>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                                        <!-- INI: Acordeon FORM INSCRIÇÃO //-->  
                                        <!-- div class="accordion margin10" data-role="accordion" data-closeany="false">
                                            <div class="accordion-frame">
                                                <a class="active heading bg-cyan fg-white" href="#">Inscrição 1 - Preencha os dados</a>
                                                <div class="content">
                                                	... include form
                                                </div>
                                            </div>
                                        </div //-->    
                                        <!-- FIM: Acordeon FORM INSCRIÇÃO //-->                   
                                    </div>
                    
                                    <div class="tile selected" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:1px solid #4390DF;">
                                        <font size="+1">
                                            Congresso + Feira (lote 2)
                                            <br><span style="color:#0099CC;">3x R$ 596,00</span>
                                        </font>
                                        <br><br>A determinação clara de objetivos causa impacto indireto na reavaliação das condições financeiras e administrativas exigidas. idas.


                                        <div class="accordion margin10" data-role="accordion" data-closeany="false">
                                            <div class="accordion-frame">
                                                <a class=" heading bg-cyan fg-white" href="#">Inscrição 1 - Preencha os dados</a>
                                                <div class="content">
                                                	<!--#include file="_include/IncludeFormInscricao.asp" -->                 
                                                </div>
                                            </div>
                                            <div class="accordion-frame">
                                                <a class=" heading bg-cyan fg-white" href="#">Inscrição 2 - Preencha os dados</a>
                                                <div class="content">
                                                	<!--#include file="_include/IncludeFormInscricao.asp" -->                 
                                                </div>
                                            </div>
                                            <div class="accordion-frame">
                                                <a class=" heading bg-cyan fg-white" href="#">Inscrição 3 - Preencha os dados</a>
                                                <div class="content">
                                                	<!--#include file="_include/IncludeFormInscricao.asp" -->                 
                                                </div>
                                            </div>
					                    </div>
                                    </div>

                    				<% flagCopy = true %>
                                    <div class="tile selected"  id="createFlatWindow" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:1px solid #4390DF;">
                                        <font size="+1">
                                            Workshop Joe Satriani
                                            <br><span style="color:#0099CC;">1x R$ 96,00</span>
                                        </font>
                                        <br><br>A determinação clara de objetivos causa impacto indireto na reavaliação das condições financeiras e administrativas exigidas. idas.
                                        <!--div class="brand">
                                            <span class="badge bg-lightBlue">1</span>
                                        </div //-->
                                        <div class="accordion margin10" data-role="accordion" data-closeany="false">
                                            <div class="accordion-frame">
                                                <a class=" heading bg-cyan fg-white" href="#">Inscrição 1 - Preencha os dados</a>
                                                <div class="content">
                                                	<!--#include file="_include/IncludeFormInscricao.asp" -->                 
                                                </div>
                                            </div>
					                    </div>
                                    </div>
                                    <!-- FIM: LISTA PRODUTOS SELECIONADOS//-->	                                

                                </div>
                                <div class="row">
                                    <div class="tile " style="width:100%; height:auto; margin:0 auto; margin-top:15px;
                                                              background-color:#CCC; color:#666; text-align:right; 
                                                              padding-top:7px; padding-right:10px; border:1px solid #FFF;">
                                        <font size="+2">
                                            TOTAL
                                            <br><span style="color:#009966;">R$ 1884,00</span>
                                        </font>
                                    </div>
								</div>


                                <div class="row" style="margin-top:15px">
                                    <div class="grid">
                                        <div class="row">
                                            <div class="span2">
                                                <a href="Passo1_.asp">
                                                <div style="width:100%; height:40px; cursor:pointer; background-color:#C00; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                                    <font size="+1"><b>VOLTAR</b></font>
                                                </div>
                                                </a>
                                            </div>
                                            <div class="span12">
                                                <a href="Passo3_.asp">
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