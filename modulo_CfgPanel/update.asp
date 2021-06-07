<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CfgPanel",Session("ID_USER")), true %>
<%
 Const LTB = "sys_painel"	 ' - Nome da Tabela...
 Const DKN = "cod_painel"    ' - Campo chave...
 Const TIT = "PAINEL"        ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Relativas a FILTRAGEM e Seleção	
 Dim  i,  arrICON, arrBG
 Dim  strCODPAINEL ,strROTULO, strLINK, strLINKPARAM, strTILEVIEW, strTILETYPE, strTILEBGCOLOR, strTILEICON,  strATIVO,strDESCRICAO,strORDEM
  
  
 strCODPAINEL = Replace(GetParam("var_chavereg"),"'","''")

  
'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
 
' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     COD_PAINEL "
 strSQL = strSQL & "		  , ROTULO"
 strSQL = strSQL & "		  , DESCRICAO "
 strSQL = strSQL & "		  , LINK "
 strSQL = strSQL & "		  , LINK_PARAM "
  strSQL = strSQL & "		  , LINK_TARGET " 
 strSQL = strSQL & "		  , TILE_VIEW " 
 strSQL = strSQL & "		  , TILE_TYPE "
 strSQL = strSQL & "		  , TILE_BGCOLOR "
 strSQL = strSQL & "		  , TILE_ICON "
 strSQL = strSQL & "		  , ORDEM "
 strSQL = strSQL & "		  , DT_INATIVO "
 strSQL = strSQL & "    FROM " & LTB 
 strSQL = strSQL & "    WHERE COD_PAINEL = " & strCODPAINEL 
 strSQL = strSQL & "    ORDER BY cod_painel"

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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_CfgPanel/default.asp';") 
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
  document.formupdate.DEFAULT_LOCATION.value="../modulo_CfgPanel/update.asp?var_chavereg=<%=strCODPAINEL%>"; 
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
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODPAINEL%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">

   <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCODPAINEL%>.GERAL</a></li>
            <li class=""><a href="#LAYOUT">LAYOUT</a></li>
          <!--  <li class=""><a href="#HELP">HELP</a></li>-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>Rotulo/Título:</p></div>
                                <div class="span8">
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_ROTULOô" name="DBVAR_STR_ROTULOô" type="text" placeholder="" value="<%=GetValue(objRS,"ROTULO")%>" maxlength="250"></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Descrição:</p></div>	
                                <div class="span8"> 
                                    	<div class="input-control text " data-role="input-control">
                                            <p><input id="DBVAR_STR_DESCRICAO" name="DBVAR_STR_DESCRICAO" type="text" placeholder="descrição do modulo" value="<%=GetValue(objRS,"DESCRICAO")%>" maxlength="250"></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Link/Url:</p></div>
                                <div class="span8">  
                                    <div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_LINKô" name="DBVAR_STR_LINKô" type="text" placeholder="ex.: modulo_CFGPainel/default.asp" value="<%=GetValue(objRS,"LINK")%>"></p>
                                    </div>
                                    <span class="tertiary-text-secondary">Ex: c/JS [javscript:javascript:AbreJanelaPAGE('link','largura', 'altura')],<br>direto:[http://caminho/arquivo]</span>
                                </div> 
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Parâmetro do Link:</p></div>
                                <div class="span8">
                                    <div class="input-control text " data-role="input-control">
                                            <p><input id="DBVAR_STR_LINK_PARAM" name="DBVAR_STR_LINK_PARAM" type="text" placeholder="ex.:?par1=100&amp;par2={cod_evento}" value="<%=GetValue(objRS,"LINK_PARAM")%>" ></p>
                                    </div>
                                    <span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span>  
                                </div> 
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Target do Link:</p></div>
                                <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_LINK_TARGETô" name="DBVAR_STR_LINK_TARGET" type="text" placeholder="ex.:_blank,_self,_top,_parent" value="<%=GetValue(objRS,"LINK_TARGET")%>" ></p>
                                    </div>
                                    <span class="tertiary-text-secondary">[taget para quando link não tiver [javascript:])</span>  
                                </div> 
                     </div> 
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
             <div class="frame" id="LAYOUT" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row ">
                                <div class="span2"><p>Visualização/Tipo:</p></div>
                                <div class="span8">
                                    <div class="input-control  select size2" data-role="input-control">
                                                <p>
                                                    <select name="DBVAR_STR_TILE_VIEW" id="DBVAR_STR_TILE_VIEW" class="">
                                                    <option value="PUBLIC" <%if lcase(getVALUE(objRS,"TILE_VIEW")) = lcase("Public") then response.Write("selected") end if %>  >PUBLIC</option>
                                                    <option value="PRIVATE"<%if lcase(getVALUE(objRS,"TILE_VIEW")) = lcase("Private") then response.Write("selected") end if %> >PRIVATE</option>
                                                    <option value="MOBILE"<%if lcase(getVALUE(objRS,"TILE_VIEW")) = lcase("MOBILE") then response.Write("selected") end if %> >MOBILE</option>
                                                    <option value="PVISTA LINKS"<%if lcase(getVALUE(objRS,"TILE_VIEW")) = lcase("PVISTA LINKS") then response.Write("selected") end if %> >PVISTA LINKS</option>
                                                    </select>
                                                </p>
                                    </div>
                                    <div class="input-control  select size2" data-role="input-control">                                        
                                                <p>
                                                    <select name="DBVAR_STR_TILE_TYPE" id="DBVAR_STR_TILE_TYPE" class="">
                                                    <option value="" 	   <%if (getVALUE(objRS,"TILE_TYPE") = "") or (lcase(getVALUE(objRS,"TILE_TYPE")) =lcase("tile")) then response.Write("selected") end if %> selected>tile</option>
                                                    <option value="half"   <%if lcase(getVALUE(objRS,"TILE_TYPE")) =lcase("half") then response.Write("selected") end if %>  >half</option>
                                                    <option value="double" <%if lcase(getVALUE(objRS,"TILE_TYPE")) =lcase("double") then response.Write("selected") end if %> >double</option>
                                                    <option value="triple" <%if lcase(getVALUE(objRS,"TILE_TYPE")) =lcase("triple") then response.Write("selected") end if %>>triple</option>
                                                    </select>
                                                <p>
                                    </div>
                                    <span class="tertiary-text-secondary">(agrupamento e tamanho do box.)</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Icone/Cor:</p></div>
                                <div class="span8"> 
                                <p>
                                    <div class="input-control  select size2" data-role="input-control">
                                                <p>
                                                    <select name="DBVAR_STR_TILE_ICON" id="DBVAR_STR_TILE_ICON" class="" onChange='javascript:document.getElementById("tile_icon_ex").className = this.value;'>
                                                     <%  For i=0 to ubound(arrICON)  %>
                                                       <option value="<%=trim(arrICON(i))%>"  <%if  trim(getVALUE(objRS,"TILE_ICON")) = trim(arrICON(i)) then response.Write("selected") end if	%>><%=trim(arrICON(i))%></option>
                                                     <% Next %>
                                                    </select>
                                                </p>
                                    </div>
                                &nbsp;&nbsp;<i id="tile_icon_ex" class=""></i>&nbsp;&nbsp;
                                    <div class="input-control text select size2 " data-role="input-control">
                                                <p>                                            
                                                    <select name="DBVAR_STR_TILE_BGCOLOR" id="DBVAR_STR_TILE_BGCOLOR" class="" onChange='javascript:document.getElementById("tile_bgcolor_ex").className = ("icon-checkbox-unchecked " + this.value);'>
                                                     <%  For i=0 to ubound(arrBG)  %>
                                                       <option value="<%=trim(arrBG(i))%>"  <%if  trim(getVALUE(objRS,"TILE_BGCOLOR")) = trim(arrBG(i)) then response.Write("selected") end if	%>><%=trim(arrBG(i))%></option>
                                                     <% Next %>
                                                     </select>
                                              </p>
                                </div>
                                &nbsp;&nbsp;<i id="tile_bgcolor_ex" class="icon-checkbox-unchecked bg-darkGreen"></i>&nbsp;&nbsp;
                                </div>
                            </p>                       
                    </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Ordem:</p></div>
                                <div class="span8"> 
									<div class="input-control text " data-role="input-control">
                                            <p><input class="" id="DBVAR_STR_ORDEM" name="DBVAR_STR_ORDEM" type="text" placeholder="posição no atalho" value="<%=GetValue(objRS,"ORDEM")%>" maxlength="9" onKeyPress="return validateNumKey(event);"></p>
                                    </div>
                                    <span class="tertiary-text-secondary"><!--Aqui comentario sobre o campo se necessario//--></span> 
                                </div> 
                     </div>  
                     <div class="row ">
                                <div class="span2"><p>Situação:</p></div>
                                <div class="span8"><p>
                                    <input type="radio"   name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO1"  value="NULL" <%if Trim(GetValue(objRS,"DT_INATIVO")) = "" then response.Write("checked/") end if %> >
                                    	Ativo&nbsp;
                                    <input  type="radio"  name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO2"  value="<%=Date()%>" <%if Trim(GetValue(objRS,"DT_INATIVO")) <> "" then response.Write("checked/") end if %>>
                                    	Inativo
                                    </p><span class="tertiary-text-secondary"><!--aqui comentário sobre o campo se necessario//--></span>
                                </div>
                     </div>
            	</div><!--fim grid layout//-->
            </div><!--fim frame layout//-->
           
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL//--> 

    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
            <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e (*)</strong> campos obrigatórios</small>
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