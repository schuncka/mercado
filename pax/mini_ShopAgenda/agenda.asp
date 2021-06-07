<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PaxShopAgenda",Session("METRO_USER_ID_USER")), true %>
<%
 Response.Buffer = true		'Para uso do FLUSH()

 Const MATRIX_COLS			= 22

 Const ATIV_ID_AUTO			= 0
 Const ATIV_COD_PROD		= 1
 Const ATIV_COD_INSCR		= 2
 Const ATIV_GRUPO			= 3
 Const ATIV_SALA			= 4
 Const ATIV_TITULO			= 5	
 Const ATIV_TITULO_MINI 	= 6
 Const ATIV_DESCRICAO		= 7
 Const ATIV_DATA			= 8
 Const ATIV_DTT_INI			= 9
 Const ATIV_DTT_FIM 		= 10
 Const ATIV_HORA_INI		= 11
 Const ATIV_MINUTO_INI		= 12
 Const ATIV_HORA_FIM		= 13
 Const ATIV_MINUTO_FIM		= 14
 Const ATIV_CARGA_HORARIA	= 15
 Const ATIV_CAPACIADE		= 16
 Const ATIV_OCUPACAO		= 17
 Const ATIV_COD_PALESTRANTE = 18
 Const ATIV_PALESTRANTE		= 20
 Const ATIV_BGCOLOR			= 21

 Const RELACAO_PIXEL_HORA   = 90
 Const HORA_INICIAL_DIA 	= 6
 
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, objLang
 'Adicionais
 Dim i, j, k, horaPrev
 Dim strCOD_EVENTO,strCOD_STATUS_PRECO
 Dim strCOD_EMPRESA,strCOD_INSCR,strCSP,strCSC,strCNPJ,strID_TIPO,strID_CAMPO,strCODINSCR, strNOME_EVENTO
 Dim strONEVENTO

 Dim auxData, arrData, auxSalas, arrSalas, auxSalaAtual
 Dim matAtiv, TamMatAtiv
 Dim strHINT, strICON, strCOR,strIMG
 Dim tpFILTRO, tpFILTRODISPLAY
 Dim strSEARCH, strTP_BROWSER, strShareMode ,flagMobile
 'Teste
 Dim intCurrent_Unix_Time,formatDate,olddate,UDate,intTimeStamp,unUDate,Resposta,DateAgora,strDifSixMouth
 Dim fromDate,toDate
 
 'Inicializa a matriz DIA, ATRIBUTOS - linhas atividade
 ReDim matAtiv(MATRIX_COLS,1)
 
 tpFILTRO 		= Session("METRO_SHOPAG_FILTRO")
 strTP_BROWSER	= Request.Cookies("METRO_pax")("tp_browser")
 'athDebug strTP_BROWSER, true

 strCOD_EVENTO			= getParam("var_cod_evento") 
 strCOD_EMPRESA 		= getParam("var_cod_empresa")		
 strCOD_INSCR   		= getParam("var_cod_inscricao") 
 strNOME_EVENTO			= getParam("var_nome_evento") 
 strCOD_STATUS_PRECO 	= getParam("var_cod_status_preco")'status preço inscrição  	
 strSEARCH				= getParam("var_str_search") ' String de pesquisa
 strShareMode			= getParam("var_share_mode") ' Serve para o controle quando a janela aberta em POUP (caso print, por exemplo deve esconder a DIV)


 strCSC     			= getParam("csc")'representa cod_status_cred vem do form de cadastrodet        
 strCNPJ 				= getParam("var_cnpj")    	
 strID_TIPO 			= getParam("var_id_tipo")'vem do form de cadastrodet value=DT_NASC   	
 strID_CAMPO 			= getParam("var_id_campo")	

 if ( (strCOD_EVENTO = "") OR (strCOD_INSCR = "") ) then 
 	Mensagem objLang.SearchIndex("mini_shopagenda_bloq",0), "","", true  
	Response.End
 end if

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------

 AbreDBConn objConn, CFG_DB

 'INI: Busca DATAS que tem produtos/salas (retorna array de DT e um array com SALAS por dia
 strSQL = "         SELECT date_format(DT_OCORRENCIA,'%d/%m/%Y') as DATA "
 strSQL = strSQL & "     , GROUP_CONCAT(Distinct `LOCAL`) as SALAS"
 strSQL = strSQL & "  FROM tbl_Produtos p"
 strSQL = strSQL & " WHERE COD_EVENTO  = " & strCOD_EVENTO  
 strSQL = strSQL & "   AND DT_OCORRENCIA IS NOT NULL "
 strSQL = strSQL & "   AND LOJA_AGENDA_SHOW = 1 "
 'ATENÇÃO: Validação para trazer somente produtos/atividades vinculadas pela 
 'restrição (relação) em modo OR. 
 'Corolário: Só mostra produtos que tenham vinculo com  (pelo menos 1 - OR) produto obrigatório que constem na inscrição do vivente.
 strSQL = strSQL & " AND ( SELECT DISTINCT PR.COD_PROD " 
 strSQL = strSQL & "         FROM tbl_Inscricao_Produto IP2, tbl_Produtos_Restricao PR" 
 strSQL = strSQL & "			  WHERE PR.COD_PROD_RELACAO = IP2.COD_PROD " 
 strSQL = strSQL & "			    AND PR.COD_PROD = p.COD_PROD " 
 strSQL = strSQL & "          AND IP2.COD_INSCRICAO = " & strToSQL(strCOD_INSCR) & ") IS NOT NULL " 
 '----------------------------------------------------------------------------------------- 
 strSQL = strSQL & " GROUP BY 1 ORDER BY 1 "
 'athDebug strSQL, false
 auxData  = "|"
 auxSalas = "|"
 set objRS = objConn.Execute(strSQL)
 Do While not objRS.EOF 
	auxData  = auxData  & "|" & getValue(objRS,"DATA")
	auxSalas = auxSalas & "|" & getValue(objRS,"SALAS")
	objRS.movenext
 Loop
 arrData  = split(replace(auxData ,"||",""),"|")
 arrSalas = split(replace(auxSalas,"||",""),"|")
 FechaRecordSet objRS
 ' FIM: Busca DATAS que tem produtos/salas -------------------------------------------------------------------------------------------------
 
 ' INI: Busca ATIVIDADES -------------------------------------------------------------------------------------------------------------------
 For i=LBound(arrData) to UBound(arrData) 
	 strSQL =          "  SELECT DISTINCT p.id_auto, p.cod_prod,count(p.id_auto)"
 	 strSQL = strSQL & " 		 ,replace(GROUP_CONCAT(if(ip.cod_Inscricao = " & strCOD_INSCR & ",ip.cod_Inscricao,null)),',','') as cod_inscricao" 
	 If lcase(Request.Cookies("METRO_pax")("locale")) <> "pt-br" Then
		strSQL = strSQL & "		 ,p.grupo_intl as grupo, p.`local` as sala, p.titulo_intl as titulo, p.titulo_mini, p.descricao_intl as descricao "
	 Else
		strSQL = strSQL & "		 ,p.grupo, p.`local` as sala, p.titulo, p.titulo_mini, p.descricao "
	 End if
	 strSQL = strSQL & "         ,date_format(p.DT_OCORRENCIA,'%d/%m/%Y') as data, p.dt_ocorrencia, p.dt_termino, p.carga_horaria"
	 strSQL = strSQL & "         ,time_format(p.DT_OCORRENCIA,'%H') as hora_ini, time_format(p.dt_termino,'%H') as hora_fim"
	 strSQL = strSQL & "         ,time_format(p.DT_OCORRENCIA,'%i') as minuto_ini, time_format(p.dt_termino,'%i') as minuto_fim"
	 strSQL = strSQL & "		 ,p.capacidade, p.ocupacao "
	 strSQL = strSQL & "         ,p.cod_palestrante, p.palestrante, p.bgcolor "
	 strSQL = strSQL & "    FROM tbl_Produtos as p"
	 strSQL = strSQL & "    left JOIN tbl_Inscricao_Produto IP on p.cod_prod = ip.cod_prod "
	 strSQL = strSQL & "   WHERE p.COD_EVENTO = " & strCOD_EVENTO 
	 strSQL = strSQL & "     AND p.DT_OCORRENCIA IS NOT NULL "
	 strSQL = strSQL & "     AND p.LOJA_AGENDA_SHOW = 1 "
	 if strSEARCH <>"" then
		'Adicionado LOCAL na pesquisa, [TAREFA 31071 - Busca por auditório (112 - HSM EXPOMANAGEMENT)] 
		'strSQL = strSQL & " AND ( p.titulo like '%" & strSEARCH & "%' OR p.descricao like '%" & strSEARCH & "%' OR p.GRUPO like '%" & strSEARCH & "%' ) "
		strSQL = strSQL & "  AND ( p.titulo like '%" & strSEARCH & "%' OR p.descricao like '%" & strSEARCH & "%' OR p.GRUPO like '%" & strSEARCH & "%' OR p.`local` like '%" & strSEARCH & "%' ) "
	 end if
	 'ATENÇÃO: Validação para trazer somente prostos/ativodades vinculadas pela 
	 'restrição (relação) em modo OR. 
	 'Corolário: Só mostra produtos que tenham vinculo com  (pelo menos 1 - OR) produto obrigatório que constem na inscrição do vivente.
	 strSQL = strSQL & " AND ( SELECT DISTINCT PR.COD_PROD " 
	 strSQL = strSQL & "         FROM tbl_Inscricao_Produto IP2, tbl_Produtos_Restricao PR" 
	 strSQL = strSQL & "			  WHERE PR.COD_PROD_RELACAO = IP2.COD_PROD " 
	 strSQL = strSQL & "			    AND PR.COD_PROD = p.COD_PROD " 
	 strSQL = strSQL & "          AND IP2.COD_INSCRICAO = '" & strCOD_INSCR & "') IS NOT NULL " 
	 '----------------------------------------------------------------------------------------- 
	 strSQL = strSQL & "   GROUP BY 1,2,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21 "
	 strSQL = strSQL & "   ORDER BY p.DT_OCORRENCIA "
	 
	 'athDebug "strSQL [ " & strSQL & "] <br><br>", false
	
	 j = 0
	 set objRS = objConn.Execute(strSQL)  
	 Do While not objRS.EOF 
	 	matAtiv(ATIV_ID_AUTO,j)			= getValue(objRS,"id_auto")
	 	matAtiv(ATIV_COD_PROD,j)		= getValue(objRS,"cod_prod")
	 	matAtiv(ATIV_COD_INSCR,j)		= TRIM(getValue(objRS,"cod_Inscricao"))		
	 	matAtiv(ATIV_GRUPO,j)			= getValue(objRS,"grupo")
	 	matAtiv(ATIV_SALA,j)			= getValue(objRS,"sala")
	 	matAtiv(ATIV_TITULO,j)			= getValue(objRS,"titulo")
	 	matAtiv(ATIV_TITULO_MINI,j) 	= getValue(objRS,"titulo_mini")
	 	matAtiv(ATIV_DESCRICAO,j)		= getValue(objRS,"descricao")
	 	matAtiv(ATIV_DATA,j)			= getValue(objRS,"data")
	 	matAtiv(ATIV_DTT_INI,j)			= getValue(objRS,"dt_ocorrencia")
	 	matAtiv(ATIV_DTT_FIM,j)			= getValue(objRS,"dt_termino")
	 	matAtiv(ATIV_HORA_INI,j)		= getValue(objRS,"hora_ini") 
	 	matAtiv(ATIV_MINUTO_INI,j)		= getValue(objRS,"minuto_ini") 
	 	matAtiv(ATIV_HORA_FIM,j)		= getValue(objRS,"hora_fim")
	 	matAtiv(ATIV_MINUTO_FIM,j)		= getValue(objRS,"minuto_fim")
	 	matAtiv(ATIV_CARGA_HORARIA,j) 	= getValue(objRS,"carga_horaria")
	 	matAtiv(ATIV_CAPACIADE,j)		= getValue(objRS,"capacidade")
	 	matAtiv(ATIV_OCUPACAO,j)		= getValue(objRS,"ocupacao")
	 	matAtiv(ATIV_COD_PALESTRANTE,j) = getValue(objRS,"cod_palestrante")
	 	matAtiv(ATIV_PALESTRANTE,j)		= getValue(objRS,"palestrante")
	 	matAtiv(ATIV_BGCOLOR,j)			= getValue(objRS,"bgcolor")
	 	if matAtiv(ATIV_DTT_FIM,j)= "" then
			matAtiv(ATIV_DTT_FIM,j)		= matAtiv(ATIV_DATA,j) & " 23:59:00"
		 	matAtiv(ATIV_HORA_FIM,j)	= "23"
		 	matAtiv(ATIV_MINUTO_FIM,j)	= "59"
		end if
		if matAtiv(ATIV_BGCOLOR,j) = "" then
			matAtiv(ATIV_BGCOLOR,j) = "bg-steel"
		end if

		j = j + 1
		ReDim Preserve matAtiv(MATRIX_COLS, j)
		objRS.MoveNext
		TamMatAtiv = j
	 Loop
 Next	
 FechaRecordSet objRS
 ' FIM: Busca ATIVIDADES -------------------------------------------------------------------------------


 'MODO BROWSER TOTEM mantido apenas  para abertura do TECLADO em MODAL
 function ifModoTotem (prStrClass,prStrCaseFalse)
   If (ucase(strTP_BROWSER) = "T") or (ucase(strTP_BROWSER) = "TOTEM") Then 
	   ifModoTotem = prStrClass
   else
	   ifModoTotem = prStrCaseFalse
   End if 
 End function

 flagMobile = isMobile()
 
%>
<html>
<head>
<title>
<% 
  if (strShareMode <> "SHARE_PRINT") then
	response.write ("pVISTA ShopAgenda")
  else
	response.write ("preparando impressão...")
  end if
%>
</title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<link rel="stylesheet" type="text/css" href="../../_css/subModal.css"/>
<script src="../../_scripts/scriptsCS.js	"></script>
<!---------------//para o modal//----------------------------->
<script type="text/javascript" src="../../_scripts/common.js"></script>
<script type="text/javascript" src="../../_scripts/subModal.js"></script>
<!-----------------//fim//------------------------------------>
<!-- script type="text/javascript" src="../_scripts/keylime.js" charset="utf-8"></script //-->
<script language="javascript" type="text/javascript">
//alert ("["+getCookie('CodObj')+"]");
if (getCookie('CodObj') == "") { setCookie('CodObj', '0', 1); }

/* INI: setTabDia - Faz a troca do display das DIVs masrcadas com a classe 
   "myframe, simulando um "tabcontrol com os botões dos dias de atividades */
function setTabDia(prCodObj,prid,prStrclass) {
  var objDivs = document.querySelectorAll(prStrclass);
  var objBut;
  for (var i = 0; i < objDivs.length; i++) {
        objDivs[i].style.display = "none";
    }
  document.getElementById(prid).style.display = "block";

  setCookie('CodObj', prCodObj, 1);
  objBut = document.getElementById('but_'+prCodObj)
  objBut.className = "active";
}
/* FIM: setTabDia. ------------------------------------------------------ */

function OnEnter(evt)
{
	var key_code =	evt.keyCode  ? evt.keyCode  :
					evt.charCode ? evt.charCode :
					evt.which    ? evt.which    : void 0;

	if (key_code == 13) { return true; }
}

/*Responsabel por envia a string  do imput para variavel strSEARCH 
que ao recarregar a pagina mostra a consulta concatenada com o valor desta variavel*/
function SendStringSearch(prObj,e) {
	if(OnEnter(e)) {
		//alert('O formulário pode ser enviado');
		document.getElementById("var_str_search").value = prObj.value;	
		document.action = "defaul.asp";
		document.getElementById("frm_search").submit();
		return false;
	} else {
		return true;
	}	
}

/* Essa função é utilizada apelas pelo teclado virtuall, que repassa pra cá o que foi digitado 
   após teclar ENTER, logo dispara a consulta na seuência */
function setSearchString(prVlr){
	document.getElementById("var_str_search").value = prVlr;	
	document.action = "defaul.asp";
	document.getElementById("frm_search").submit();
}

/* Mostra os style display da DIV para que seja visivel na imperessao 
visualizar qual página você esta imprimindo */
function showTitAgenda(){
	//alert ('entrei na funcaio filha');document.getElementById("panel")
	document.getElementById("tit_agenda").style.display = "block";
}

/*fecha a popup após impressao*/
function ClosePrint() {
	window.onfocus =  setTimeout(function () { window.close(); }, 500); 
}
</script>
</head>
<body class  = "metro border" 
      style  = "height:100%;" 
	  onLoad ="<%
				If (tpFILTRO <> "TODOS") AND (strSEARCH = "") then 
					response.Write("setTabDia(getCookie('CodObj'),'StreamerPage_'+getCookie('CodObj'),'.myframe'); ")
				end if 
				if (strShareMode = "SHARE_PRINT") then 
					response.Write("showTitAgenda(); window.print(); ClosePrint(); ")
				end if 
				%>"           
><!--fim do body//-->

<%'Condição que ativa a div com classe metro  possibilitando assim usar mouseWheel(rodinha do mouse)
	'if (strShareMode <> "SHARE_PRINT") AND (not isMobile()) and  (   (Ucase(strTP_BROWSER) <> "TOTEM") and (Ucase(strTP_BROWSER) <> "T")   ) then 
%>
 <!--div id='ScrollForMouseWhell' name='ScrollForMouseWhell' class='bg-tranparent' data-role='scrollbox' data-scroll='vertical' style="background:#CCCCCC;"//-->
<%
	'end if 
%> 
<!--
 div class="bg-gray fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px; text-align:left">
   <%=strCOD_EVENTO & " - " & strNOME_EVENTO%>&nbsp;<sup><span style="font-size:12px">AGENDA</span></sup>   
   <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:0px; padding-right:10px;">
        <a href="#" onClick="document.getElementById('frm_search').submit();" title="Atualizar/Refresh">
            <i class="icon-cycle on-right on-left" style="background:green; color:white; padding:6px; border-radius: 50%"></i>
		</a>
   </div>
</div  
//-->
<% 
  If Trim(arrData(0)) <> "" then ' teste da consulta vazia pelo ubounce 
%>
	<div class="" id="logCab"><!--img do top//--></div><!--fim img//-->
        <div id="viewagenda" class="padding5"><!-- principal //-->
                <div class="button-set" data-role="button-group" style="width:100%"> 
                <!-- h3 id="tit_agenda" style="display:none;">AGENDA DO EVENTO</h3 //--> 
                    <form name="frm_search" 	id="frm_search" action="" method="post">
                        <input type="hidden"  	name="var_cod_evento" 		 id="var_cod_evento" 		value="<%=strCOD_EVENTO%>">  
                        <input type="hidden" 	name="var_cod_empresa" 		 id="var_cod_empresa" 		value="<%=strCOD_EMPRESA%>"> 		
                        <input type="hidden" 	name="var_cod_inscricao"	 id="var_cod_inscricao"		value="<%=strCOD_INSCR%>">  
                        <input type="hidden" 	name="var_cod_status_preco"	 id="var_cod_status_preco"	value="<%=strCOD_STATUS_PRECO%>">
                        <input type="hidden" 	name="var_str_search"		 id="var_str_search"		value="<%=strSEARCH%>"> 
                        <input type="hidden" 	name="var_share_mode"	 	 id="var_share_mode"		value="<%=strShareMode%>"> 
                        <input type="hidden" 	name="var_nome_evento"		 id="var_nome_evento"		value="<%=strNOME_EVENTO%>"> 
                        <label> 
                            <% If (ucase(tpFILTRO) <> "TODOS") AND (strSEARCH="") then %>
                                <% For i=LBound(arrData) to UBound(arrData) %>
                                    <button id="but_<%=i%>" onClick="javascript:setTabDia('<%=i%>','StreamerPage_<%=i%>','.myframe'); return false;"><%=arrData(i)%></button>
                                <% Next	%>
                               	<button onClick="AbreJanelaPAGE('_SetTipoFiltro.asp?var_filtro=TODOS', '10', '10');"><%=objLang.SearchIndex("mini_shopagenda_todos",0)%></button>  
                            <% else %>
                                <% If (strSEARCH="") then %>
									<button onClick="AbreJanelaPAGE('_SetTipoFiltro.asp?var_filtro=PDIAS', '10', '10');"><%=objLang.SearchIndex("mini_shopagenda_pordia",0)%></button>  
                                <% End if %> 					
                            <% end if %>            
                        </label>
                        <script>
                            $(document).ready( function() { $('a.submodal_teclado').attr('href', '../shopagenda/mui_tecladototem.asp'); } );
                        </script>
                        <style>
                            #btn-search {	}
                        </style>
                        <div class="input-control text span2" style="float:left;height:26px;display:block">
							<a href="javascript:void(0);" id="link" class="<%=ifModoTotem("submodal_teclado","")%>" style="text-decoration:none;cursor:pointer;">
								<input id='input_search' name='input_search'  type='text'  style='height:26px;' class='<%'="unselectable"%>' onKeyPress='SendStringSearch(this,event);' value='<%=strSEARCH%>'/>
							</a>
							<span class='btn-search' style='padding-bottom:5px;' ></span>
                        </div>                
                      </form>
                </div>
                <br>  
                <% 
                For i=LBound(arrData) to UBound(arrData) 
                %>
                    <% If (tpFILTRO <> "TODOS") AND (strSEARCH="") then
                        if (i=LBound(arrData)) then 
                            tpFILTRODISPLAY = "inline-block"
                        else 
                            tpFILTRODISPLAY = "none" 
                        end if
                     else 
                        response.Write("<div class='button-set' data-role='button-group' style='background:#E9E9E9; margin-top:25px; margin-bottom:25px;'>")
                        response.Write("<button class='active'>"&arrData(i)&"</button>")
                        response.Write("</div>")
                        tpFILTRODISPLAY = "block"
                     end if
                    %>
                    <div class="myframe padding5 " id="StreamerPage_<%=i%>" style='display:<%=tpFILTRODISPLAY%>; border:0px solid #F00;width:100%;'>
    
                        <div class="listview-outlook" data-role="listview">
                        <% 
                        For j=0 to TamMatAtiv 'TamMatAtiv são as atividade que serão distribudas na agenda
                            If  ( arrData(i) = matAtiv(ATIV_DATA,j) )  then
                        %>
                                <!-- marked //-->
                                <div class="list" id="<%=matAtiv(ATIV_GRUPO,j)%>" href="javascript:void(0);" style="border-bottom:#CCC solid 1px; height:60%">
                                    <div class="list-content">
                                                <div style="width:100%; margin-left:0px; border:0px solid #F00;">
                                                    <span class=""><h2 class="no-margin" style="font-size:20px;">
													    <form id='form_OperaProd_<%=j%>' name='form_OperaProd_<%=j%>' action='' method='post' target='<%'fr_principal%>' style='display:none; visibility:hidden;'>
															<input type='hidden' name='var_cod_evento'			value='<%=strCOD_EVENTO%>'>
															<input type='hidden' name='var_cod_empresa'			value='<%=strCOD_EMPRESA%>'>			
															<input type='hidden' name='var_cod_inscricao'		value='<%=strCOD_INSCR%>'>
															<input type='hidden' name='var_nome_evento'			value='<%=strNOME_EVENTO%>'>
															<input type='hidden' name='var_cod_prod'			value='<%=matAtiv(ATIV_COD_PROD,j)%>'>	
															<input type='hidden' name='var_cod_status_preco'	value='<%=strCOD_STATUS_PRECO%>'>

															<input type='hidden' name='var_id_prod'			value='<%=matAtiv(ATIV_ID_AUTO,j)%>'>
															<input type='hidden' name='csc'					value='<%=strCSC%>'>
															<input type='hidden' name='var_cnpj'			value='<%=strCNPJ%>'>
															<input type='hidden' name='var_id_tipo'			value='<%=strID_TIPO%>'>
															<input type='hidden' name='var_id_campo'		value='<%=strID_CAMPO%>'>
                                                        </form>                                                   
                                                        <%
                                                        strHINT		= objLang.SearchIndex("mini_shopagenda_add",0) '"Clique aqui para adicionar à sua agenda."
                                                        strICON		= "icon-plus" 
                                                        strCOR	 	= "#1A1739" 
                                                        strONEVENTO	= "shop_addprod.asp" 
                                                        
                                                        if Cint(matAtiv(ATIV_CAPACIADE,j)) > Cint(matAtiv(ATIV_OCUPACAO,j)) AND Cdate(matAtiv(ATIV_DTT_INI,j)) >= now() AND matAtiv(ATIV_COD_INSCR,j) = "" Then 
														%>
                                                            <img style='color:<%=strCOR%>;' data-hint='<%=strHINT%>' data-hint-position='top'  
                                                                 src='../../img/shopag_IconeAddPalestra.png' 
                                                              	 onClick="document.getElementById('form_OperaProd_<%=j%>').action = '<%=strONEVENTO%>';  
                                                               		  	  document.getElementById('form_OperaProd_<%=j%>').submit();" >
                                                        <% 
                                                        else 
                                                            if Cint(matAtiv(ATIV_CAPACIADE,j)) <= Cint(matAtiv(ATIV_OCUPACAO,j)) then 
                                                                strHINT 	= objLang.SearchIndex("mini_shopagenda_msgvagas",0) '"Vagas esgotadas!"
                                                                strICON 	= "icon-blocked" 
                                                                strIMG  	= "shopag_IconePalestraBloqueado.png"															
                                                                strCOR  	= "#A9A9A9" 
                                                                strONEVENTO = ""
                                                            end if
                                                            if Cdate(matAtiv(ATIV_DTT_INI,j))  < now() 	then 
                                                                strHINT 	= objLang.SearchIndex("mini_shopagenda_msgprazo",0)  '"O prazo de inscrição esta encerrado!"
                                                                strICON 	= "icon-blocked"
                                                                strIMG  	= "shopag_IconePalestraBloqueado.png"
                                                                strCOR  	= "#A9A9A9" &vbnewline
                                                                strONEVENTO = ""
                                                            end if
                                                            if matAtiv(ATIV_COD_INSCR,j) <> "" then 
                                                                strHINT 	= objLang.SearchIndex("mini_shopagenda_msgjatem",0) '"Este item já consta em sua agenda!"
                                                                strICON 	= "icon-checkbox" &vbnewline
                                                                strIMG  	= "shopag_IconePalestraAdicionada.png"
                                                                strCOR  	= "#41A4A7"  &vbnewline
                                                                strONEVENTO = "shop_deleteprod.asp"
                                                            end if
                                                        %>
                                                            <img src='../../img/<%=strIMG%>' style='color:<%=strCOR%>;' data-hint='<%=strHINT%>' data-hint-position='top'>
                                                        <% end if%>
                                                     <span style="font-size:16px; line-height:20px; font-weight:bold;"><%=matAtiv(ATIV_TITULO,j)%></span></h2>
                                                    </span>
    
                                                    <span style="font-size:12px; line-height:16px; margin-bottom:10px;"><%=matAtiv(ATIV_DESCRICAO,j)%></span>
                                                    <span class="list-remark"><b><i class="icon-location"></i></b>&nbsp;<%=matAtiv(ATIV_SALA,j)%></span>                                                
                                                    <span class="list-remark"><b><i class="icon-clock"></i></b>&nbsp;
                                                          <%
                                                            response.write( matAtiv(ATIV_HORA_INI,j)&"h"& matAtiv(ATIV_MINUTO_INI,j) )
                                                            if matAtiv(ATIV_HORA_FIM,j) <>"" then
                                                              response.write ( "&nbsp;" & matAtiv(ATIV_HORA_FIM,j)&"h"& matAtiv(ATIV_MINUTO_FIM,j) )
                                                            end if
                                                            response.Write("&nbsp;("&matAtiv(ATIV_COD_PROD,j)&")")
                                                          %>                                                
                                                    </span><br>
                                                    
                                                    <!-- INI: REMOVE Icon -------------------------------------------------------------------- //-->
                                                    <%if matAtiv(ATIV_COD_INSCR,j) <> "" then %>
														<img src="../../img/but_excluir_ativ.png"  
                                                                 style="margin-top:10px; margin-bottom:5px; height:24px;" class="fg-indigo" 
                                                                 data-hint='<%=objLang.SearchIndex("mini_shopagenda_del",0)%>' data-hint-position="top"
                                                                 onClick="document.getElementById('form_OperaProd_<%=j%>').action = '<%=strONEVENTO%>';  
                                                                 		  document.getElementById('form_OperaProd_<%=j%>').submit();" >
                                                    <% end if  %>
													<!-- FIM: REMOVE Icon -------------------------------------------------------------------- //-->
    
                                                    <!-- INI: INFO Icon... ------------------------------------------------------------------- //-->
														<img src="../../img/but_more_info.gif" class="fg-indigo" style="margin-top:10px;margin-bottom:5px;height:24px;" 
                                                        	 onClick="document.getElementById('form_OperaProd_<%=j%>').action = 'shop_detailprod.asp';  
																	  document.getElementById('form_OperaProd_<%=j%>').submit();">
                                                    <br>
                                                    <!-- FIM: INFO Icon... ------------------------------------------------------------------- //-->
    
                                                    <span class="list-title  <% if (strShareMode <> "SHARE_PRINT") then response.write(" fg-white ") else response.write(" fg-black ") end if %>
                                                          <%=matAtiv(ATIV_BGCOLOR,j)%>" style="width:100%; padding:5px;background:<%=corMetroToHex(matAtiv(ATIV_BGCOLOR,j))%>;border:<%=corMetroToHex(matAtiv(ATIV_BGCOLOR,j))%> 1px solid;">
                                                          <%=matAtiv(ATIV_GRUPO,j)%>
                                                    </span> 
                                                </div><!-- End IN list-content //-->  
                                    </div><!-- End list-content //-->  
                                </div>
                        <% 
                            End if
												
							if ( (j mod 2) = 0 ) then 
								Response.Flush()
							end if
                        Next
                        %>
                        </div><!-- End lisview outlook //-->   
                    </div> <!-- End myframe //-->    
                <% 
                Next	
                %>
        </div><!-- principal //-->
<%
  Else
	Mensagem objLang.SearchIndex("mini_shopagenda_nodata",0), "","", true  
  End if ' teste da consulta vazia pelo ubounce 
%>
<%
' if (strShareMode <> "SHARE_PRINT") AND (not isMobile()) and (strTP_BROWSER = Trim("totem")) then
%>
 <!--/div//--><!-- fecha div scroll que faz funcionar a mouse whell //-->
<% 
 'end if 
%> 
</body>
</html>
<%
 FechaDBConn objConn
%>		 