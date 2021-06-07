<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"--> 
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PaxShopAgenda", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 Dim objConn, objRS, objRSAux, strSQL, objLang		
 Dim strCOD_PROD, strCOD_EVENTO, strCOD_INSCR, strCOD_EMPRESA, strNOME_EVENTO, strCOD_STATUS_PRECO

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
 
 strSQL = "          SELECT p.id_auto, p.cod_prod, p.`local` as sala, p.titulo_mini "
 If lcase(Request.Cookies("METRO_pax")("locale")) <> "pt-br" Then
	 strSQL = strSQL & "    ,p.grupo_intl as grupo, p.titulo_intl as titulo, p.descricao_intl as descricao "
 Else
	 strSQL = strSQL & "    ,p.grupo, p.titulo, p.descricao "
 End If
 strSQL = strSQL & "         ,date_format(p.DT_OCORRENCIA,'%d/%m/%Y') as data, p.dt_ocorrencia, p.dt_termino, p.carga_horaria"
 strSQL = strSQL & "         ,time_format(p.DT_OCORRENCIA,'%H') as hora_ini, time_format(p.dt_termino,'%H') as hora_fim"
 strSQL = strSQL & "         ,time_format(p.DT_OCORRENCIA,'%i') as minuto_ini, time_format(p.dt_termino,'%i') as minuto_fim"
 strSQL = strSQL & "		 ,p.capacidade, p.ocupacao "
 strSQL = strSQL & "         ,p.cod_palestrante, p.palestrante, p.bgcolor "
 strSQL = strSQL & "    FROM tbl_Produtos as p"
 strSQL = strSQL & "   WHERE p.COD_EVENTO = "	& strCOD_EVENTO 
 strSQL = strSQL & "     AND p.cod_prod = "	& strCOD_PROD  
 strSQL = strSQL & "   ORDER BY p.DT_OCORRENCIA "
 
 set objRS = objConn.Execute(strSQL)  
 
%>
<html>
<head>
<title>pVISTA.PAX</title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<script type="text/javascript" language="javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
<%	if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formproduto.DEFAULT_LOCATION.value='../../_database/athWindowClose.asp';") 
	 else
  		response.write ("document.formproduto.DEFAULT_LOCATION.value='../../_database/athWindowClose.asp';")  
  	 end if
%> 
	if (validateRequestedFields("formproduto")) { 
		document.formproduto.submit(); 
	} 
}

function cancelar() { 
	window.history.back();
}
</script>
</head>
<body class="metro" bgcolor="#CCCCCC"><!--onLoad="ok();return false;style="display:none;""//-->
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <!-- <%=strCOD_EVENTO & " - " & strNOME_EVENTO%>&nbsp;<sup><span style="font-size:12px">INSERT</span></sup> //-->
   INSERT&nbsp;<sup><span style="font-size:12px"></span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
    <form name="formproduto" id="formproduto" action="shop_addprod_exec.asp" method="post" target="_self">
		<input type='hidden' name='var_cod_evento'			value='<%=strCOD_EVENTO%>'>
		<input type='hidden' name='var_cod_empresa'			value='<%=strCOD_EMPRESA%>'>			
		<input type='hidden' name='var_cod_inscricao'		value='<%=strCOD_INSCR%>'>
		<input type='hidden' name='var_nome_evento'			value='<%=strNOME_EVENTO%>'>	
        <input type='hidden' name='var_cod_prod'			value='<%=strCOD_PROD%>'>	
		<input type='hidden' name='var_cod_status_preco'	value='<%=strCOD_STATUS_PRECO%>'>
		<input type='hidden' name='DEFAULT_LOCATION'		value="">

		<!--div class TAB CONTROL --------------------------------------------------//-->
        <div class="tab-control" data-effect="fade" data-role="tab-control">
            <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
				<li class="active" style="background:#FDFDFD;"><a href="#DADOS">GERAL</a></li>
            </ul>	
		<div class="frames" style="background:#FDFDFD;">
				<div class="padding20">
					<div  style="width:100%; margin-right:5px;">
							<h2><%=objLang.SearchIndex("mini_shopagenda_confadd",0)%></h2>
                            <hr>
                            <div style="width:100%; margin-left:0px; border:0px solid #F00;">
                                <span class=""><h2 class="no-margin" style="font-size:20px;">
                                <span style="font-size:16px; line-height:20px; font-weight:bold;"><%=getValue(objRS,"TITULO")%></span></h2>
                                </span>
                                <span style="font-size:12px; line-height:16px; margin-bottom:10px;"><%=getValue(objRS,"DESCRICAO")%></span><br>
                                <span class="list-remark"><b><i class="icon-location"></i></b>&nbsp;<%=getValue(objRS,"SALA")%></span><br>                                                
                                <span class="list-remark"><b><i class="icon-clock"></i></b>&nbsp;
									<%
                                    response.write( getValue(objRS,"HORA_INI")&"h"& getValue(objRS,"MINUTO_INI") )
                                    if getValue(objRS,"HORA_FIM") <>"" then
                                    	response.write ( "&nbsp;" & getValue(objRS,"HORA_FIM")&"h"& getValue(objRS,"MINUTO_FIM") )
                                    end if
                                    response.Write("&nbsp;("&getValue(objRS,"COD_PROD")&")")
                                    %>                                                
                                </span><br>
                                <span class=""><%=objLang.SearchIndex("inscricao",0)%>:&nbsp;<%=strCOD_INSCR%></span><br> 
                                <span class=""><%=objLang.SearchIndex("mini_data",0)%>:&nbsp;<%=getValue(objRS,"DATA")%></span><br> 
                                <span class=""><%=objLang.SearchIndex("capacidade",0)%>:&nbsp;<%=getValue(objRS,"CAPACIDADE")%></span>&nbsp;&nbsp;<!--span class="">Ocupação:&nbsp;<%'=getValue(objRS,"OCUPACAO")%></span//--><br>                                                                                                                                                 

                                <div class="list-title fg-white <%=getValue(objRS,"BGCOLOR")%>" style="margin-top:8px;;width:100%; padding:5px;background: <%=corMetroToHex(getValue(objRS,"BGCOLOR"))%>;height:30px;">
                                	<%=getValue(objRS,"GRUPO")%>
                                </div> 
                            </div><!-- End row//-->  
                        </div><!-- padding20//-->
                    </div><!-- End frames//-->   
                </div><!--fim do frame dados//-->
            </div><!--FIM - FRAMES//-->
            <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
                <div style="float:left">
                    <input type="button" class="primary" value="OK"     onClick="javascript:ok();return false;">
                    <input type="button" class="" 		 value="CANCEL" onClick="javascript:cancelar();return false;"> 
                </div>
            </div><!--FIM: BOTÕES/MENSAGENS //--> 
    </form>  
        </div><!--FIM TABCONTROL //--> 
   </div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
<% 
 FechaRecordSet objRS
%>