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


                                <form>
                                    <fieldset>
                                        <legend><b>Comprador</b></legend>
                                        <label>Identificação</label>
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
                                                <option value="Card">Cartão de crédito</option>
                                                <option value="Boleto">Boleto bancário</option>
                                            </select>
                                        </div>                                        
                                        <div id="dados_card" style="display:block; background-color:#EEE; padding:10px;">
                                            <label>Número do cartão</label>
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
                                        <legend><b>Informações de cobrança</b></legend>




                                            <label>Nome do Tomador / Razão Social</label>
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
                                                <option value="Albânia">Albânia</option>
                                                <option value="Alemanha">Alemanha</option>
                                                <option value="Andorra">Andorra</option>
                                                <option value="Angola">Angola</option>
                                                <option value="Anguilla">Anguilla</option>
                                                <option value="Antigua">Antigua</option>
                                                <option value="Arábia Saudita">Arábia Saudita</option>
                                                <option value="Argentina">Argentina</option>
                                                <option value="Armênia">Armênia</option>
                                                <option value="Aruba">Aruba</option>
                                                <option value="Austrália">Austrália</option>
                                                <option value="Áustria">Áustria</option>
                                                <option value="Azerbaijão">Azerbaijão</option>
                                                <option value="Bahamas">Bahamas</option>
                                                <option value="Bahrein">Bahrein</option>
                                                <option value="Bangladesh">Bangladesh</option>
                                                <option value="Barbados">Barbados</option>
                                                <option value="Bélgica">Bélgica</option>
                                                <option value="Benin">Benin</option>
                                                <option value="Bermudas">Bermudas</option>
                                                <option value="Botsuana">Botsuana</option>
                                                <option value="Brasil" selected>Brasil</option>
                                                <option value="Brunei">Brunei</option>
                                                <option value="Bulgária">Bulgária</option>
                                                <option value="Burkina Fasso">Burkina Fasso</option>
                                                <option value="botão">botão</option>
                                                <option value="Cabo Verde">Cabo Verde</option>
                                                <option value="Camarões">Camarões</option>
                                                <option value="Camboja">Camboja</option>
                                                <option value="Canadá">Canadá</option>
                                                <option value="Cazaquistão">Cazaquistão</option>
                                                <option value="Chade">Chade</option>
                                                <option value="Chile">Chile</option>
                                                <option value="China">China</option>
                                                <option value="Cidade do Vaticano">Cidade do Vaticano</option>
                                                <option value="Colômbia">Colômbia</option>
                                                <option value="Congo">Congo</option>
                                                <option value="Coréia do Sul">Coréia do Sul</option>
                                                <option value="Costa do Marfim">Costa do Marfim</option>
                                                <option value="Costa Rica">Costa Rica</option>
                                                <option value="Croácia">Croácia</option>
                                                <option value="Dinamarca">Dinamarca</option>
                                                <option value="Djibuti">Djibuti</option>
                                                <option value="Dominica">Dominica</option>
                                                <option value="EUA">EUA</option>
                                                <option value="Egito">Egito</option>
                                                <option value="El Salvador">El Salvador</option>
                                                <option value="Emirados Árabes">Emirados Árabes</option>
                                                <option value="Equador">Equador</option>
                                                <option value="Eritréia">Eritréia</option>
                                                <option value="Escócia">Escócia</option>
                                                <option value="Eslováquia">Eslováquia</option>
                                                <option value="Eslovênia">Eslovênia</option>
                                                <option value="Espanha">Espanha</option>
                                                <option value="Estônia">Estônia</option>
                                                <option value="Etiópia">Etiópia</option>
                                                <option value="Fiji">Fiji</option>
                                                <option value="Filipinas">Filipinas</option>
                                                <option value="Finlândia">Finlândia</option>
                                                <option value="França">França</option>
                                                <option value="Gabão">Gabão</option>
                                                <option value="Gâmbia">Gâmbia</option>
                                                <option value="Gana">Gana</option>
                                                <option value="Geórgia">Geórgia</option>
                                                <option value="Gibraltar">Gibraltar</option>
                                                <option value="Granada">Granada</option>
                                                <option value="Grécia">Grécia</option>
                                                <option value="Guadalupe">Guadalupe</option>
                                                <option value="Guam">Guam</option>
                                                <option value="Guatemala">Guatemala</option>
                                                <option value="Guiana">Guiana</option>
                                                <option value="Guiana Francesa">Guiana Francesa</option>
                                                <option value="Guiné-bissau">Guiné-bissau</option>
                                                <option value="Haiti">Haiti</option>
                                                <option value="Holanda">Holanda</option>
                                                <option value="Honduras">Honduras</option>
                                                <option value="Hong Kong">Hong Kong</option>
                                                <option value="Hungria">Hungria</option>
                                                <option value="Iêmen">Iêmen</option>
                                                <option value="Ilhas Cayman">Ilhas Cayman</option>
                                                <option value="Ilhas Cook">Ilhas Cook</option>
                                                <option value="Ilhas Curaçao">Ilhas Curaçao</option>
                                                <option value="Ilhas Marshall">Ilhas Marshall</option>
                                                <option value="Ilhas Turks & Caicos">Ilhas Turks & Caicos</option>
                                                <option value="Ilhas Virgens (brit.)">Ilhas Virgens (brit.)</option>
                                                <option value="Ilhas Virgens(amer.)">Ilhas Virgens(amer.)</option>
                                                <option value="Ilhas Wallis e Futuna">Ilhas Wallis e Futuna</option>
                                                <option value="Índia">Índia</option>
                                                <option value="Indonésia">Indonésia</option>
                                                <option value="Inglaterra">Inglaterra</option>
                                                <option value="Irlanda">Irlanda</option>
                                                <option value="Islândia">Islândia</option>
                                                <option value="Israel">Israel</option>
                                                <option value="Itália">Itália</option>
                                                <option value="Jamaica">Jamaica</option>
                                                <option value="Japão">Japão</option>
                                                <option value="Jordânia">Jordânia</option>
                                                <option value="Kuwait">Kuwait</option>
                                                <option value="Latvia">Latvia</option>
                                                <option value="Líbano">Líbano</option>
                                                <option value="Liechtenstein">Liechtenstein</option>
                                                <option value="Lituânia">Lituânia</option>
                                                <option value="Luxemburgo">Luxemburgo</option>
                                                <option value="Macau">Macau</option>
                                                <option value="Macedônia">Macedônia</option>
                                                <option value="Madagascar">Madagascar</option>
                                                <option value="Malásia">Malásia</option>
                                                <option value="Malaui">Malaui</option>
                                                <option value="Mali">Mali</option>
                                                <option value="Malta">Malta</option>
                                                <option value="Marrocos">Marrocos</option>
                                                <option value="Martinica">Martinica</option>
                                                <option value="Mauritânia">Mauritânia</option>
                                                <option value="Mauritius">Mauritius</option>
                                                <option value="México">México</option>
                                                <option value="Moldova">Moldova</option>
                                                <option value="Mônaco">Mônaco</option>
                                                <option value="Montserrat">Montserrat</option>
                                                <option value="Nepal">Nepal</option>
                                                <option value="Nicarágua">Nicarágua</option>
                                                <option value="Niger">Niger</option>
                                                <option value="Nigéria">Nigéria</option>
                                                <option value="Noruega">Noruega</option>
                                                <option value="Nova Caledônia">Nova Caledônia</option>
                                                <option value="Nova Zelândia">Nova Zelândia</option>
                                                <option value="Omã">Omã</option>
                                                <option value="Palau">Palau</option>
                                                <option value="Panamá">Panamá</option>
                                                <option value="Papua-nova Guiné">Papua-nova Guiné</option>
                                                <option value="Paquistão">Paquistão</option>
                                                <option value="Peru">Peru</option>
                                                <option value="Polinésia Francesa">Polinésia Francesa</option>
                                                <option value="Polônia">Polônia</option>
                                                <option value="Porto Rico">Porto Rico</option>
                                                <option value="Portugal">Portugal</option>
                                                <option value="Qatar">Qatar</option>
                                                <option value="Quênia">Quênia</option>
                                                <option value="Rep. Dominicana">Rep. Dominicana</option>
                                                <option value="Rep. Tcheca">Rep. Tcheca</option>
                                                <option value="Reunion">Reunion</option>
                                                <option value="Romênia">Romênia</option>
                                                <option value="Ruanda">Ruanda</option>
                                                <option value="Rússia">Rússia</option>
                                                <option value="Saipan">Saipan</option>
                                                <option value="Samoa Americana">Samoa Americana</option>
                                                <option value="Senegal">Senegal</option>
                                                <option value="Serra Leone">Serra Leone</option>
                                                <option value="Seychelles">Seychelles</option>
                                                <option value="Singapura">Singapura</option>
                                                <option value="Síria">Síria</option>
                                                <option value="Sri Lanka">Sri Lanka</option>
                                                <option value="St. Kitts & Nevis">St. Kitts & Nevis</option>
                                                <option value="St. Lúcia">St. Lúcia</option>
                                                <option value="St. Vincent">St. Vincent</option>
                                                <option value="Sudão">Sudão</option>
                                                <option value="Suécia">Suécia</option>
                                                <option value="Suiça">Suiça</option>
                                                <option value="Suriname">Suriname</option>
                                                <option value="Tailândia">Tailândia</option>
                                                <option value="Taiwan">Taiwan</option>
                                                <option value="Tanzânia">Tanzânia</option>
                                                <option value="Togo">Togo</option>
                                                <option value="Trinidad & Tobago">Trinidad & Tobago</option>
                                                <option value="Tunísia">Tunísia</option>
                                                <option value="Turquia">Turquia</option>
                                                <option value="Ucrânia">Ucrânia</option>
                                                <option value="Uganda">Uganda</option>
                                                <option value="Uruguai">Uruguai</option>
                                                <option value="Venezuela">Venezuela</option>
                                                <option value="Vietnã">Vietnã</option>
                                                <option value="Zaire">Zaire</option>
                                                <option value="Zâmbia">Zâmbia</option>
                                                <option value="Zimbábue">Zimbábue</option>
                                                </select>
                                            </div>                                        
                                            <label>CEP</label>
                                            <div class="input-control text size2" data-role="input-control">
                                                <input type="text" placeholder="type text" autofocus>
                                                <button class="btn-clear" tabindex="-1"></button>
                                            </div>
                                            <label>Endereço</label>
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
                                                    <option value="AP">Amapá</option>
                                                    <option value="AM">Amazonas</option>
                                                    <option value="BA">Bahia</option>
                                                    <option value="CE">Ceará</option>
                                                    <option value="DF">Distrito Federal</option>
                                                    <option value="ES">Espírito Santo</option>
                                                    <option value="GO">Goiás</option>
                                                    <option value="MA">Maranhão</option>
                                                    <option value="MT">Mato Grosso</option>
                                                    <option value="MS">Mato Grosso do Sul</option>
                                                    <option value="MG">Minas Gerais</option>
                                                    <option value="PA">Pará</option>
                                                    <option value="PB">Paraíba</option>
                                                    <option value="PR">Paraná</option>
                                                    <option value="PE">Pernambuco</option>
                                                    <option value="PI">Piauí</option>
                                                    <option value="RJ">Rio de Janeiro</option>
                                                    <option value="RN">Rio Grande do Norte</option>
                                                    <option value="RS">Rio Grande do Sul</option>
                                                    <option value="RO">Rondônia</option>
                                                    <option value="RR">Roraima</option>
                                                    <option value="SC">Santa Catarina</option>
                                                    <option value="SP">São Paulo</option>
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