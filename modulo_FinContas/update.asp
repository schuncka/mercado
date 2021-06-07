<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CfgPanel",Session("ID_USER")), true %>
<%
 Const LTB = "fin_conta"	 ' - Nome da Tabela...
 Const DKN = "COD_CONTA"    ' - Campo chave...
 Const TIT = "FinContaBanco"        ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Relativas a FILTRAGEM e Seleção	
 Dim  i,  arrICON, arrBG
 Dim  strCODCONTA ,strROTULO, strLINK, strLINKPARAM, strTILEVIEW, strTILETYPE, strTILEBGCOLOR, strTILEICON,  strATIVO,strDESCRICAO,strORDEM
  
  
 strCODCONTA = Replace(GetParam("var_chavereg"),"'","''")

  
'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
 
' Monta SQL e abre a consulta ----------------------------------------------------------------------------------

 strSQL = strSQL & " SELECT COD_CONTA      "
 strSQL = strSQL & "      , NOME           "
 strSQL = strSQL & "      , DESCRICAO      "
 strSQL = strSQL & "      , TIPO           "
 strSQL = strSQL & "      , COD_BANCO      "
 strSQL = strSQL & "      , AGENCIA        "
 strSQL = strSQL & "      , CONTA          "
 strSQL = strSQL & "      , DT_CADASTRO    "
 strSQL = strSQL & "      , VLR_SALDO_INI  "
 strSQL = strSQL & "      , VLR_SALDO      "
 strSQL = strSQL & "      , ORDEM          "
 strSQL = strSQL & "      , DT_INATIVO     "
 strSQL = strSQL & "    FROM " & LTB  
 strSQL = strSQL & "    WHERE COD_CONTA =  " & strCODCONTA
 strSQL = strSQL & "    ORDER BY cod_conta "

'response.write(strSQL)

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 

 arrICON = Array("","icon-home","icon-newspaper","icon-pencil","icon-droplet","icon-pictures","icon-camera","icon-music","icon-film","icon-camera-2", _
                 "icon-spades","icon-clubs","icon-diamonds","icon-broadcast","icon-mic","icon-book","icon-file","icon-new","icon-copy","icon-folder", _
				 "icon-folder-2","icon-tag","icon-cart","icon-basket","icon-calculate","icon-support","icon-phone","icon-mail","icon-location","icon-compass", _
				 "icon-history","icon-clock","icon-bell","icon-calendar","icon-printer","icon-mouse","icon-screen","icon-laptop","icon-mobile","icon-cabinet", _
				 "icon-drawer","icon-drawer-2","icon-box","icon-box-add","icon-box-remove","icon-download","icon-upload","icon-database","icon-flip","icon-flip-2", _
				 "icon-undo","icon-redo","icon-forward","icon-reply","icon-reply-2","icon-comments","icon-comments-2","icon-comments-3","icon-comments-4", _
				 "icon-comments-5","icon-user","icon-user-2","icon-user-3","icon-busy","icon-loading","icon-loading-2","icon-search","icon-zoom-in","icon-zoom-out", _
				 "icon-key","icon-key-2","icon-locked","icon-unlocked","icon-wrench","icon-equalizer","icon-cog","icon-pie","icon-bars","icon-stats-up","icon-gift", _
				 "icon-trophy","icon-diamond","icon-coffe","icon-rocket","icon-meter-slow","icon-meter-medium","meter-medium","icon-meter-fast","icon-dashboard", _
				 "icon-fire","icon-lab","icon-remove","icon-briefcase","icon-briefcase-2","icon-cars","icon-bus","icon-cube","icon-cube-2","icon-puzzle", _
				 "icon-glasses","icon-glasses-2","icon-accessibility","icon-accessibility-2","icon-target","icon-target-2","icon-lightning","icon-power", _
				 "icon-power-2","icon-clipboard","icon-clipboard-2","icon-playlist","icon-grid-view","icon-tree-view","icon-cloud","icon-cloud-2","icon-download-2", _
				 "icon-upload-2","icon-upload-3","icon-link","icon-link-2","icon-flag","icon-flag-2","icon-attachment","icon-eye","icon-bookmark","icon-bookmark-2", _
				 "icon-star","icon-star-2","icon-star-3","icon-heart","icon-heart-2","icon-thumbs-up","icon-thumbs-down","icon-plus","icon-minus","icon-help", _
				 "icon-help-2","icon-blocked","icon-cancel","icon-cancel-2","icon-checkmark","icon-minus-2","icon-plus-2","icon-enter","icon-exit","icon-loop", _
				 "icon-arrow-up-left","icon-arrow-up","icon-arrow-up-right","icon-arrow-right","icon-arrow-down-right","icon-arrow-down","icon-arrow-down-left", _
				 "icon-arrow-left","icon-arrow-up-2","icon-arrow-down-2","icon-arrow-down-2","icon-arrow-left-2","icon-arrow-up-3","icon-arrow-right-3","icon-arrow-down-3", _
				 "icon-arrow-left-3","icon-menu","icon-enter-2","icon-backspace","icon-backspace-2","icon-tab","icon-tab-2","icon-checkbox","icon-checkbox-unchecked", _
				 "icon-checkbox-partial","icon-radio-checked","icon-radio-unchecked","icon-font","icon-paragraph-left","icon-paragraph-center","icon-paragraph-right", _
				 "icon-paragraph-justify","icon-left-to-right","icon-right-to-left","icon-share","icon-new-tab","icon-new-tab-2","icon-embed","icon-code","icon-bluetooth", _
				 "icon-share-2","icon-share-3","icon-mail-2","icon-google","icon-google-plus","icon-google-drive","icon-facebook","icon-instagram","icon-twitter","icon-feed", _
				 "icon-youtube","icon-vimeo","icon-flickr","icon-picassa","icon-dribbble","icon-deviantart","icon-github","icon-github-2","icon-github-3","icon-github-4", _
				 "icon-github-5","icon-github-6","icon-git","icon-wordpress","icon-joomla","icon-blogger","icon-tumblr","icon-yahoo","icon-amazon","icon-tux","icon-apple", _
				 "icon-finder","icon-android","icon-windows","icon-soundcloud","icon-skype","icon-reddit","icon-linkedin","icon-lastfm","icon-delicious","icon-stumbleupon", _
				 "icon-pinterest","icon-xing","icon-flattr","icon-foursquare","icon-paypal","icon-yelp","icon-libreoffice","icon-file-pdf","icon-file-openoffice","icon-file-word", _
				 "icon-file-excel","icon-file-powerpoint","icon-file-zip","icon-file-xml","icon-file-css","icon-html5","icon-html5-2","icon-css3","icon-chrome","icon-firefox", _
				 "icon-IE","icon-opera","icon-safari","icon-IcoMoon","icon-sunrise","icon-sun","icon-moon","icon-sun-2","icon-windy","icon-wind","icon-snowflake","icon-cloudy", _
				 "icon-cloud-3","icon-weather","icon-weather-2","icon-weather-3","icon-lines","icon-cloud-4","icon-lightning-2","icon-lightning-3","icon-rainy","icon-rainy-2", _
				 "icon-windy-2","icon-windy-3","icon-snowy","icon-snowy-2","icon-snowy-3","icon-snowy-4","icon-cloudy-2","icon-cloudy-5","icon-lightning-4","icon-sun-3","icon-moon-2", _
				 "icon-cloudy-3","icon-cloud-6","icon-cloud-7","icon-lighting-5","icon-rainy-3","icon-rainy-4","icon-windy-4","icon-windy-5","icon-snowy-4","icon-snowy-5", _
				 "icon-weather-5","icon-cloudy-4","icon-lightning-6","icon-thermometer","icon-compass-2","icon-none","icon-Celsius","icon-Fahrenheit","icon-forrst", _
				 "icon-headphones","icon-bug","icon-cart-2","icon-earth","icon-earth","icon-list","icon-grid","icon-alarm","icon-location-2","icon-pointer","icon-diary", _
				 "icon-eye-2","icon-console","icon-location-3","icon-move","icon-monitor","icon-mobile-2","icon-switch","icon-star-4","icon-newspaper","icon-address-book", _ 
				 "icon-cone","icon-credit-card","icon-type","icon-volume","icon-volume-2","icon-locked-2","icon-warning","icon-info","icon-filter","icon-bookmark-3", _
				 "icon-newspaper-4","icon-stats","icon-compass-3","icon-keyboard","icon-award-fill","icon-award-stroke","icon-beaker-alt","icon-beaker","icon-move-vertical", _
				 "icon-move-horizontal","icon-steering-wheel","icon-volume-3","icon-volume-mute","icon-play","icon-pause","icon-stop","icon-eject","icon-first","icon-last", _
				 "icon-play-alt","icon-battery-empty","icon-battery-half","icon-battery-full","icon-battery-charging","icon-left-quote","icon-right-quote","icon-left-quote-alt", _
				 "icon-right-quote-alt","icon-smiley","icon-umbrella","icon-info-2","icon-chart-alt","icon-floppy","icon-at","icon-hash","icon-pilcrow","icon-fullscreen-alt", _
				 "icon-fullscreen-exit-alt","icon-layers-alt","icon-layers","icon-rainbow","icon-air","icon-spin","icon-auction","icon-auction","icon-dollar-2","icon-coins", _
				 "icon-file-2","icon-file-3","icon-file-4","icon-files","icon-phone-2","icon-tablet","icon-monitor-2","icon-window","icon-tv","icon-camera-3","icon-image", _
				 "icon-open","icon-sale","icon-direction","icon-medal","icon-medal-2","icon-satellite","icon-discout","icon-barcode","icon-ticket","icon-shipping","icon-globe", _
				 "icon-anchor","icon-pop-out","icon-pop-in","icon-resize","icon-battery-2","icon-battery-3","icon-battery-4","icon-battery-5","icon-tools","icon-alarm-2", _
				 "icon-alarm-cancel","icon-alarm-clock","icon-chronometer","icon-ruler","icon-lamp","icon-lamp-2","icon-scissors","icon-volume-4","icon-volume-5","icon-volume-6", _
				 "icon-zip","icon-zip-2","icon-play-2","icon-pause-2","icon-record","icon-stop-2","icon-next","icon-previous","icon-first-2","icon-last-2","icon-arrow-left-4", _
				 "icon-arrow-down-4","icon-arrow-up-4","icon-arrow-right-4","icon-arrow-right-4","icon-arrow-left-5","icon-arrow-down-5","icon-arrow-up-5","icon-arrow-right-5", _
				 "icon-cc","icon-cc-by","icon-cc-nc","icon-cc-nc-eu","icon-cc-nc-jp","icon-cc-sa","icon-cc-nd","icon-cc-pd","icon-cc-zero","icon-cc-share","icon-cc-share-2", _
				 "icon-cycle","icon-stop-3","icon-stats-2","icon-stats-3")

 arrBG= Array("","bg-black","bg-white","bg-lime" ,"bg-green","bg-emerald","bg-teal","bg-cyan" ,"bg-cobalt" ,"bg-indigo","bg-violet","bg-pink","bg-magenta","bg-crimson","bg-red" , _
			  "bg-orange","bg-amber","bg-yellow" ,"bg-brown" ,"bg-olive","bg-steel","bg-mauve","bg-taupe","bg-gray" ,"bg-dark" ,"bg-darker","bg-transparent","bg-darkBrown" ,_
			  "bg-darkCrimson","bg-darkMagenta","bg-darkIndigo" ,"bg-darkCyan" ,"bg-darkCobalt","bg-darkTeal" ,"bg-darkEmerald","bg-darkGreen","bg-darkOrange","bg-darkRed" ,_
			  "bg-darkPink","bg-darkViolet","bg-darkBlue","bg-lightBlue","bg-lightTeal","bg-lightOlive","bg-lightOrange","bg-lightPink","bg-lightRed","bg-lightGreen")
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<!-- funções para action dos botões OK, APLICAR,CANCELAR  e NOTIFICAÇÂO//-->
<script type="text/javascript" language="javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() {
	 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_FinContas/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %>  
	/*document.formupdate.DEFAULT_LOCATION.value="../_database/athWindowClose.asp"; */
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_FinContas/update.asp?var_chavereg=<%=strCODCONTA%>"; 
  if (validateRequestedFields("formupdate")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.formupdate.submit(); 
  }
}
function cancelar() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("window.history.back()")
	 else
  		response.write ("window.close();")
  	 end if
 %> 
}
</script>
<!-- FIM----------------------------------------- funções //-->

</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
                <form name="formupdate" id="formupdate" action="../_database/athupdatetodb.asp" method="post">
                <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
                <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODCONTA%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">

   <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCODCONTA%>.GERAL</a></li>
            

        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    
                    <div class="row ">
                                <div class="span2"><p>*Banco:</p></div>
                                <div class="span8">
                                    	<div class="input-control  select size3" data-role="input-control">
                                            <p>
                                            	<select name="DBVAR_STR_COD_BANCOô" id="DBVAR_STR_COD_BANCOô" class="">
                                                    <option value=""></option>
													<option value="1" <%if getValue(objRS,"cod_banco") = "1" Then response.Write("selected") END IF %>>Banco do Brasil</option>
                                                    <option value="2" <%if getValue(objRS,"cod_banco") = "2" Then response.Write("selected") END IF %>>Itaú</option>
                                                    <option value="3" <%if getValue(objRS,"cod_banco") = "3" Then response.Write("selected") END IF %>>Banrisul</option>
                                                    <option value="4" <%if getValue(objRS,"cod_banco") = "4" Then response.Write("selected") END IF %>>Unibanco</option>
                                                    <option value="5" <%if getValue(objRS,"cod_banco") = "5" Then response.Write("selected") END IF %>>Bradesco</option>
                                                    <option value="6" <%if getValue(objRS,"cod_banco") = "6" Then response.Write("selected") END IF %>>Caixa Economica Federal</option>
                                                    <option value="7" <%if getValue(objRS,"cod_banco") = "7" Then response.Write("selected") END IF %>>Santander</option>
                                                </select>
                                            </p>
                                    	</div>                                    	
                                </div>
                     </div>
                    <div class="row ">
                            <div class="span2"><p>*Agência/ Conta:</p></div>
                            <div class="span8">
                                <div class="input-control select text size2" data-role="input-control">
                                	<p><input id="DBVAR_STR_AGENCIAô" name="DBVAR_STR_AGENCIAô" type="text" placeholder="ex.: 0,00" value="<%=getValue(objRS,"agencia")%>" maxlength="50" class=""></p>
                                </div>
                                <div class="input-control select text size3" data-role="input-control">
                                	<p><input id="DBVAR_STR_CONTAô" name="DBVAR_STR_CONTAô" type="text" placeholder="ex.: 0,00" value="<%=getValue(objRS,"conta")%>" maxlength="50" class=""></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                            </div> 
                     </div>
                    
                    <div class="row">
                                <div class="span2"><p>Nome:</p></div>
                                <div class="span8">
                                    	<div class="input-control select text size3" data-role="input-control">
                                            <p><input id="DBVAR_STR_NOME" name="DBVAR_STR_NOME" type="text" placeholder="" value="<%=GetValue(objRS,"NOME")%>" maxlength="250"></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                      
                     <div class="row ">
                                <div class="span2" style=""><p>Tipo:</p></div>
                                <div class="span8"> 
                                    	<div class="input-control  select size2" data-role="input-control">
                                            <p>
                                            	<select name="DBVAR_STR_TIPO" id="DBVAR_STR_TIPO" class="">
                                                    <option value="">[selecione]</option>
                                                    <option value="CONTA CORRENTE"    <%if getValue(objRS,"tipo") = "CONTA CORRENTE" Then response.Write("SELECTED") END IF %>>Conta Corrente</option>
                                                    <option value="CARTAO DE CREDITO" <%if getValue(objRS,"tipo") = "CARTAO DE CREDITO" Then response.Write("SELECTED") END IF %>>Cartão de Crédito</option>
                                                    <option value="DINHEIRO"          <%if getValue(objRS,"tipo") = "DINHEIRO" Then response.Write("SELECTED") END IF %>>Dinheiro</option>
                                                    <option value="INVESTIMENTOS"     <%if getValue(objRS,"tipo") = "INVESTIMENTOS" Then response.Write("SELECTED") END IF %>>Investimentos</option>
                                                    <option value="POUPANCA"          <%if getValue(objRS,"tipo") = "POUPANCA" Then response.Write("SELECTED") END IF %>>Poupança</option>
                                                    <option value="OUTROS"            <%if getValue(objRS,"tipo") = "OUTROS" Then response.Write("SELECTED") END IF %>>Outros</option>	
                                                </select>
                                            </p>
                                    	</div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Saldo Inicial / Saldo Atual:</p></div>
                                <div class="span8">
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><%=getValue(objRS,"VLR_SALDO_INI")%> / <%=getValue(objRS,"VLR_SALDO")%></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                    
                      
                      <div class="row">
                        <div class="span2"><p>*Data Cadastro:</p></div><!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer. Ele modifica automaticamente para data setada dentro da função//-->
                        <div class="span8">
                            <div class="input-control text size3" data-role="input-control">
                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                    <input id="DBVAR_DATE_DT_CADASTROô" name="DBVAR_DATE_DT_CADASTROô" type="text" placeholder="" value="<%=PrepData(getValue(objRS,"DT_CADASTRO"),True,False)%> " maxlength="11" class=""  >
                                    <span class="btn-date"></span>
                                </p>
                            </div>                                           
                        </div>
                    </div>
                      
                     <div class="row ">
                                <div class="span2" style=""><p>Descrição:&nbsp;</p></div>
                                <div class="span8">  
                                     <p class="input-control textarea" data-role="input-control"><textarea name="DBVAR_STR_DESCRICAO" id="DBVAR_STR_DESCRICAO" cols="40" rows="6"><%=getValue(objRS,"descricao")%></textarea></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2" style=""><p>Ordem:</p></div>
                                <div class="span8">
                                    <div class="input-control text " data-role="input-control">
                                            <p><input id="DBVAR_STR_ORDEM" name="DBVAR_STR_ORDEM" type="text" placeholder="ex.: 1" value="<%=getValue(objRS,"ordem")%>" ></p>
                                    </div>
                                    <span class="tertiary-text-secondary"></span>  
                                </div> 
                     </div>  
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->            
           
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL//--> 

    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>


<%
	FechaRecordSet ObjRS
	FechaDBConn ObjConn
	
	'athDebug strSQL, true '---para testes'
%>