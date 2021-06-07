<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PaxShopAgenda",Session("METRO_USER_ID_USER")), true %>
<%
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

 Dim objConn, objRS, strSQL, objRSPalestrante, objLang		
 Dim strHINT,strICON,strCOR
 Dim strCODPALESTRANTE	,strNOMECLIPA ,strEMAIL1PA ,strCARGOPA , strCURRICULOPA ,strIMFFTOPA ,strIMGPA ,strIMG,auxTAB,arrTAB,strALL_PARAMETERS
 Dim matAtiv, TamMatAtiv, j, i
 Dim strONEVENTO
 Dim strCOD_PROD, strCOD_EVENTO, strCOD_INSCR, strCOD_EMPRESA, strNOME_EVENTO, strCOD_STATUS_PRECO
 
 'Inicializa a matriz DIA, ATRIBUTOS - linhas atividade
 ReDim matAtiv(MATRIX_COLS,1)

 strCOD_EVENTO		 = getParam("var_cod_evento") 
 strCOD_EMPRESA		 = getParam("var_cod_empresa")		
 strCOD_INSCR  		 = getParam("var_cod_inscricao") 
 strNOME_EVENTO		 = getParam("var_nome_evento") 
 strCOD_PROD		 = getParam("var_cod_prod")
 strCOD_STATUS_PRECO = getParam("var_cod_status_preco")
 
 If strCOD_PROD = "" or strCOD_EVENTO = "" or strCOD_INSCR = "" Then
	Mensagem objLang.SearchIndex("mini_shopagenda_bloqadd",0), "","", true 
	response.End()
 end if
 
 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------


 AbreDBConn objConn, CFG_DB

 strSQL =          "  SELECT DISTINCT p.id_auto "
 strSQL = strSQL & "		 ,p.cod_prod,count(p.id_auto)"
 strSQL = strSQL & " 		 ,replace(GROUP_CONCAT(if(ip.cod_Inscricao = " & strCOD_INSCR & ",ip.cod_Inscricao,null)),',','') as cod_inscricao" 
 If lcase(Request.Cookies("METRO_pax")("locale")) <> "pt-br" Then
	strSQL = strSQL & "		 ,p.grupo_intl as grupo, p.`local` as sala, p.titulo_intl as titulo, p.titulo_mini, p.descricao_intl as descricao "
 Else
	strSQL = strSQL & "		 ,p.grupo, p.`local` as sala, p.titulo, p.titulo_mini, p.descricao "
 End If
 strSQL = strSQL & "         ,date_format(p.DT_OCORRENCIA,'%d/%m/%Y') as data, p.dt_ocorrencia, p.dt_termino, p.carga_horaria"
 strSQL = strSQL & "         ,time_format(p.DT_OCORRENCIA,'%H') as hora_ini, time_format(p.dt_termino,'%H') as hora_fim"
 strSQL = strSQL & "         ,time_format(p.DT_OCORRENCIA,'%i') as minuto_ini, time_format(p.dt_termino,'%i') as minuto_fim"
 strSQL = strSQL & "		 ,p.capacidade, p.ocupacao "
 strSQL = strSQL & "         ,p.cod_palestrante, p.palestrante, p.bgcolor "
 strSQL = strSQL & "    FROM tbl_Produtos as p"
 strSQL = strSQL & "    left JOIN tbl_Inscricao_Produto IP on p.cod_prod = ip.cod_prod "
 strSQL = strSQL & "   WHERE p.COD_EVENTO = " & strCOD_EVENTO 
 strSQL = strSQL & "     AND p.cod_prod = " & strCOD_PROD
 strSQL = strSQL & "     AND p.DT_OCORRENCIA IS NOT NULL "
 strSQL = strSQL & "   GROUP BY 1,2,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21 "
		 
 'athDebug strSQL, false
	
 set objRS = objConn.Execute(strSQL)  
 
 If not objRS.EOF Then
	 	matAtiv(ATIV_ID_AUTO,0)			= getValue(objRS,"id_auto")
	 	matAtiv(ATIV_COD_PROD,0)		= getValue(objRS,"cod_prod")
	 	matAtiv(ATIV_COD_INSCR,0)		= trim(getValue(objRS,"cod_inscricao"))
	 	matAtiv(ATIV_GRUPO,0)			= getValue(objRS,"grupo")
	 	matAtiv(ATIV_SALA,0)			= getValue(objRS,"sala")
	 	matAtiv(ATIV_TITULO,0)			= getValue(objRS,"titulo")
	 	matAtiv(ATIV_TITULO_MINI,0) 	= getValue(objRS,"titulo_mini")
	 	matAtiv(ATIV_DESCRICAO,0)		= getValue(objRS,"descricao")
	 	matAtiv(ATIV_DATA,0)			= getValue(objRS,"data")
	 	matAtiv(ATIV_DTT_INI,0)			= getValue(objRS,"dt_ocorrencia")
	 	matAtiv(ATIV_DTT_FIM,0)			= getValue(objRS,"dt_termino")
	 	matAtiv(ATIV_HORA_INI,0)		= getValue(objRS,"hora_ini") 
	 	matAtiv(ATIV_MINUTO_INI,0)		= getValue(objRS,"minuto_ini") 
	 	matAtiv(ATIV_HORA_FIM,0)		= getValue(objRS,"hora_fim")
	 	matAtiv(ATIV_MINUTO_FIM,0)		= getValue(objRS,"minuto_fim")
	 	matAtiv(ATIV_CARGA_HORARIA,0) 	= getValue(objRS,"carga_horaria")
	 	matAtiv(ATIV_CAPACIADE,0)		= getValue(objRS,"capacidade")
	 	matAtiv(ATIV_OCUPACAO,0)		= getValue(objRS,"ocupacao")
	 	matAtiv(ATIV_COD_PALESTRANTE,0) = getValue(objRS,"cod_palestrante")
	 	matAtiv(ATIV_PALESTRANTE,0)		= getValue(objRS,"palestrante")
	 	matAtiv(ATIV_BGCOLOR,0)			= getValue(objRS,"bgcolor")
	 	if matAtiv(ATIV_DTT_FIM,0)="" then
			matAtiv(ATIV_DTT_FIM,0)		= matAtiv(ATIV_DATA,0) & " 23:59:00"
		 	matAtiv(ATIV_HORA_FIM,0)	= "23"
		 	matAtiv(ATIV_MINUTO_FIM,0)	= "59"
		end if
		if matAtiv(ATIV_BGCOLOR,0) = "" then
			matAtiv(ATIV_BGCOLOR,0) = "bg-steel"
		end if
		ReDim Preserve matAtiv(MATRIX_COLS, 0)
 end if
 
 FechaRecordSet objRS

 ' FIM: Busca ATIVIDADES -------------------------------------------------------------------------------
%>
<html>
<head>
<title>pVISTA.PAX</title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" bgcolor="#CCCCCC">
<!-- Barra que contem o título do módulo e ação da dialog//-->
<div class="bg-darkOrange fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <!-- <%=strCOD_EVENTO & " - " & strNOME_EVENTO%>&nbsp;<sup><span style="font-size:12px">DETAIL</span></sup> //-->      
   DETAIL&nbsp;<sup><span style="font-size:12px"></span></sup>
</div>
<!-- FIM -------------------------------Barra//-->
<div class="container padding20">
<!-- div class TAB CONTROL -------------------------------------------------- //-->
    <div class="tab-control" data-effect="fade" data-role="tab-control" >
        <ul class="tabs"><!-- ABAS DO TAB CONTROL //-->
            <li class="active" style="background:#FDFDFD;"><a href="#DADOS"><%=strCOD_PROD%>.GERAL</a></li>
        </ul>
		<div class='frames' style='background:#FDFDFD;'>
                                <div class='padding20'>
                                            <div  style='width:100%; margin-right:5px;'>
                                                <span><h2 class='no-margin' style='font-size:20px;'>
													    <form id='form_OperaProd_0' name='form_OperaProd_0' action='' method='post' target='<%'fr_principal%>' style="display:none; visibility:hidden;">
															<input type='hidden' name='var_cod_evento'			value='<%=strCOD_EVENTO%>'>
															<input type='hidden' name='var_cod_empresa'			value='<%=strCOD_EMPRESA%>'>			
															<input type='hidden' name='var_cod_inscricao'		value='<%=strCOD_INSCR%>'>
															<input type='hidden' name='var_nome_evento'			value='<%=strNOME_EVENTO%>'>
															<input type='hidden' name='var_cod_prod'			value='<%=matAtiv(ATIV_COD_PROD,j)%>'>	
															<input type='hidden' name='var_cod_status_preco'	value='<%=strCOD_STATUS_PRECO%>'>
                                                        </form>                                                   
                                                   <%
														strHINT		= objLang.SearchIndex("mini_shopagenda_add",0) '"Clique aqui para adicionar à sua agenda."
														strICON		= "icon-plus" 
														strCOR	 	= "#1A1739" 
														strONEVENTO	= "shop_addprod.asp"
                                                    
                                                    if Cint(matAtiv(ATIV_CAPACIADE,0)) > Cint(matAtiv(ATIV_OCUPACAO,j)) AND Cdate(matAtiv(ATIV_DTT_INI,0)) >= now() AND matAtiv(ATIV_COD_INSCR,0) = "" Then 
													%>
                                                            <img style='color:<%=strCOR%>; cursor:pointer;' data-hint='<%=strHINT%>' data-hint-position='top'
                                                                 src='../../img/shopag_IconeAddPalestra.png' 
                                                              	 onClick="document.getElementById('form_OperaProd_0').action = '<%=strONEVENTO%>';  
                                                               		  	  document.getElementById('form_OperaProd_0').submit();" >
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
                                                                strCOR  	= "#A9A9A9" 
                                                                strONEVENTO = ""
                                                            end if
                                                            if matAtiv(ATIV_COD_INSCR,j) <> "" then 
                                                                strHINT 	= objLang.SearchIndex("mini_shopagenda_msgjatem",0) '"Este item já consta em sua agenda!"
                                                                strICON 	= "icon-checkbox" 
                                                                strIMG  	= "shopag_IconePalestraAdicionada.png"
                                                                strCOR  	= "#41A4A7"  
																strONEVENTO = "shop_deleteprod.asp" 
														end if
                                                    %>
                                                    	<img src='../../img/<%=strIMG%>' style='color:<%=strCOR%>;' data-hint='<%=strHINT%>' data-hint-position='top'>
                                                    <% end if%>
                                                 <span style="font-size:16px; line-height:20px; font-weight:bold;"><%=matAtiv(ATIV_TITULO,j)%></span></h2>
                                                </span>
                                                <span style="font-size:12px; line-height:16px; margin-bottom:10px;"><%=matAtiv(ATIV_DESCRICAO,0)%></span><br><br>
                                                <span class=""><b><i class="icon-location"></i></b>&nbsp;<%=matAtiv(ATIV_SALA,0)%></span><br>                                                
                                                <span class=""><b><i class="icon-clock"></i></b>&nbsp;
													  <%
                                                        response.write( matAtiv(ATIV_HORA_INI,0)&"h"& matAtiv(ATIV_MINUTO_INI,0) )
                                                        if matAtiv(ATIV_HORA_FIM,0) <>"" then
                                                          response.write ( "&nbsp;" & matAtiv(ATIV_HORA_FIM,0)&"h"& matAtiv(ATIV_MINUTO_FIM,0) )
                                                        end if
                                                        response.Write("&nbsp;("&matAtiv(ATIV_COD_PROD,0)&")")
                                                      %>                                                
                                                </span><br>
                                                <span class=""><%=objLang.SearchIndex("inscricao",0)%>:&nbsp;<%=strCOD_INSCR%></span><br> 
                                                <span class=""><%=objLang.SearchIndex("mini_data",0)%>:&nbsp;<%=matAtiv(ATIV_DATA,0)%></span><br> 
                                                <span class=""><%=objLang.SearchIndex("capacidade",0)%>:&nbsp;<%=matAtiv(ATIV_CAPACIADE,0)%></span>&nbsp;&nbsp;<!--span class="">Ocupação:&nbsp;<%'=getValue(objRS,"OCUPACAO")%></span//--><br>                                                                                                                                                 

                                                <!-- INI: REMOVE Icon -------------------------------------------------------------------- //-->
                                                <% if matAtiv(ATIV_COD_INSCR,0) <> "" then %>
                                                    <img src="../../img/but_excluir_ativ.png"  
                                                             style="margin-top:10px; margin-bottom:5px; height:24px; cursor:pointer;" class="fg-indigo" 
                                                             data-hint='<%=objLang.SearchIndex("mini_shopagenda_del",0)%>' data-hint-position="top" 
                                                             onClick="document.getElementById('form_OperaProd_0').action = '<%=strONEVENTO%>';  
                                                                      document.getElementById('form_OperaProd_0').submit();" >
                                                <% end if  %>
                                                <!-- FIM: REMOVE Icon -------------------------------------------------------------------- //-->
                                                <br>

                                                <div class=" fg-white <%=matAtiv(ATIV_BGCOLOR,0)%>" style="margin-top:8px;;width:100%; padding:5px;background: <%=corMetroToHex(matAtiv(ATIV_BGCOLOR,0))%>;height:30px;">
													  <%=matAtiv(ATIV_GRUPO,0)%>
	                                            </div>           

                                            </div><!-- End IN list-content //-->  
                        
                        <!-------------------------------------palestrante-------------------------------------------------------------------------------------------//-->            
					<%
                        strSQL = "SELECT DISTINCT P.COD_PALESTRANTE, E.NOMECLI, E.EMAIL1, P.CARGO, P.CURRICULO, E.IMG_FOTO, P.FOTO  " 
                        strSQL = strSQL & " FROM tbl_Palestrante P, tbl_Palestrante_Evento PE , tbl_Empresas E , tbl_Produtos_Palestrante PP  " 
                        strSQL = strSQL & "  WHERE P.COD_PALESTRANTE = PE.COD_PALESTRANTE  " 
                        strSQL = strSQL & "  AND PE.COD_EVENTO = " & strCOD_EVENTO
                        strSQL = strSQL & "  AND PE.COD_PALESTRANTE = PP.COD_PALESTRANTE  " 
                        strSQL = strSQL & "  AND P.COD_EMPRESA = E.COD_EMPRESA  " 
                        strSQL = strSQL & " 	 AND Pp.COD_PROD = " & strCOD_PROD
                        strSQL = strSQL & "  ORDER BY E.NOMECLI " 
                        'Response.Write(strSQL&"<br>")
                        'Response.End
                        
                        Set objRSPalestrante 	= objConn.Execute(strSQL)
                    
                    If not objRSPalestrante.EOF Then
                    
                    %>
                        <br><h2>Palestrante(s)</h2>
                    <%end if%>  
                    <%	
                    Do While not objRSPalestrante.EOF
                        strCODPALESTRANTE	= objRSPalestrante("COD_PALESTRANTE")
                        strNOMECLIPA 		= objRSPalestrante("NOMECLI")
                        strEMAIL1PA 		= objRSPalestrante("EMAIL1")
                        strCARGOPA 			= objRSPalestrante("CARGO")
                        strCURRICULOPA 		= objRSPalestrante("CURRICULO")
                        strIMFFTOPA 		= objRSPalestrante("IMG_FOTO")
                        strIMGPA 			= objRSPalestrante("FOTO")   
                        
                    %>     
                    <div class="listview-outlook " data-role="listview">
                        <div class="list-group collapsed " >
                        <a href="" class="group-title " style="height:120px;">
						<div  style="float:left;display:inline-block; margin-right:10px; ">
                                <%
									If objRSPalestrante("FOTO")&"" <> "" Then
										strIMFFTOPA = "../../palestrante/img/"&objRSPalestrante("FOTO")&""
									Else
										If objRSPalestrante("IMG_FOTO")& "" <> "" Then
											strIMFFTOPA = "../../webcam/imgphoto/"&objRSPalestrante("IMG_FOTO")&""
										Else
											strIMFFTOPA = "../../webcam/imgphoto/unknownuser.jpg"
										end if
									End If	
									
									%>
                                	<h3><img class="rounded " src="<%=strIMFFTOPA%>" border="1" style="height:80px;" title="<%=strIMFFTOPA%>"></h3>                                            
                                </div>
						<h6 class="">
							<%=strCODPALESTRANTE%><br>
							<%=strNOMECLIPA%><br>
                            <%=strEMAIL1PA%><br>
						</h6>
                        </a>
                        <div class="group-content">                                           
                        <a class="list marked-bg-yellow" href="#" style="border-bottom:#FFF solid 1px;height:100%;background:#F0F0F0">
                            <div class="list-content" style="padding:5px;">
                                <div  class="" style="width:100%;float:left;display:inline-block;  margin-right:10px;">
                                    <span class="readable-text"><%=strCURRICULOPA%></span>                                                    
                                </div>
                            </div>
                        </a>
                        </div>
                        </div> 
                         </div>                       
						<%
						i = i + 1
                        athMoveNext objRSPalestrante, ContFlush, CFG_FLUSH_LIMIT
                        Loop
                        %>      
					</div><!-- End list-content //-->  
		</div>
	</div>
    
    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"   onClick="javascript:window.history.back();">
        </div>
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
