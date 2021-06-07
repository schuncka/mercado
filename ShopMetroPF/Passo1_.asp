<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<%
  Option Explicit 
  Session.LCID     = 1046
  Session.Timeout  = 500
  Response.Expires = 0 
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
        <div class="grid" style="margin-bottom:0px">
             <div class="row">
                 <div class="span114" style="background-color:#FFF;"><!-- level 1 column //-->
                     <div class="row">
                         <img class="" src="./imgdin/logo.png" style="margin-bottom:15px;margin-top:15px;">
                     </div>
                 </div>
             </div>
             <div class="row">
                 <div class="stepper rounded" data-steps="4" data-role="stepper" data-start="1" style="width:100%;"></div>
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
                <!-- a href="Passo2_.asp" //-->
                <div style="width:100%; height:40px; cursor:pointer; background-color:#F60; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-top:20px;">
                    <font size="+1"><b>CÓDIGO PROMOCIONAL</b></font>
                </div>
                <!-- /a //-->
             </div>

             <div class="row">
                <h2>Selecione os produtos</h2>
             </div>

             <div class="row">
             
				<!-- INI: LISTA PRODUTOS //-->	
                <div class="tile selected" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:1px solid #4390DF;">
                    <font size="+1">
                    	FEIRA - Credenciamento gratuito
                    	<br><span style="color:#009966;">GRATUITO</span>
					</font>
					<br><br>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                    <div class="brand">
                        <span class="badge bg-lightBlue">1</span>
                    </div>
                </div>

                <div class="tile selected"  id="createFlatWindow" style="width:100%; height:auto; margin:0 auto;  background-color:#FFF; color:#666; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:1px solid #4390DF;">
                    <font size="+1">
                    	Congresso + Feira (lote 2)
	                    <br><span style="color:#0099CC;">R$ 596,00</span>
                    </font>
					<br><br>A determinação clara de objetivos causa impacto indireto na reavaliação das condições financeiras e administrativas exigidas. idas.
                    <div class="brand">
                        <span class="badge bg-lightBlue">3</span>
                    </div>
                </div>
                
                <div class="tile" style="width:100%; height:auto; margin:0 auto;  background-color:#EBEBEB; color:#999; text-align:LEFT; padding-top:7px; padding-left:10px; padding-bottom:25px; margin-top:15px; border:0px solid #666;">
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
                            <div class="badge bg-lightBlue" style="width:50px; height:auto;"> 
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
                </div>

                <!-- FIM: LISTA PRODUTOS //-->
             </div>

             <div class="row" style="margin-top:15px">
                <div class="grid">
                    <div class="row">
                        <div class="span2">
                            <a href="Default.asp">
                            <div style="width:100%; height:40px; cursor:pointer; background-color:#C00; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                <font size="+1"><b>VOLTAR</b></font>
                            </div>
                            </a>
                        </div>
                        <div class="span12">
                            <a href="Passo2_.asp">
                            <div style="width:100%; height:40px; cursor:pointer; background-color:#090; color:#FFFFFF; vertical-align:middle; text-align:center; padding-top:7px; margin-bottom:20px;">
                                <font size="+1"><b>CONTINUAR</b></font>
                            </div>
                            </a>
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
					var content = '<form class="user-input">' +
							'<label>Quantidade</label>' +
							'<div class="input-control select">' +
							'  <select name="combo_numpage" id="combo_numpage">'+
							'    <option value="0"  >0</option>'  +
							'    <option value="1"  >1</option>'  +
							'    <option value="2"  >2</option>'  +
							'    <option value="3" selected  >3</option>'  +
							'    <option value="4"  >4</option>'  +
							'    <option value="5"  >5</option>'  +
							'    <option value="6"  >6</option>'  +
							'    <option value="7"  >7</option>'  +
							'    <option value="8"  >8</option>'  +
							'    <option value="9"  >9</option>'  +
							'    <option value="10" >10</option>' +
							'  </select></div>'            +
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
