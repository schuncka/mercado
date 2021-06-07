<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_Transporte",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_palestrante_hospedagem"	' - Nome da Tabela...
 Const DKN = "COD_PALESTRANTE_EVENTO"		' - Campo chave...
 Const TIT = "Hospedagem"     				' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
  
'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2, objLang
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage

 Dim strCOD_PALESTRANTE_EVENTO, strNOME_EVENTO


 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------


 strCOD_PALESTRANTE_EVENTO 	= GetParam("var_cod_pal_evento")
 strNOME_EVENTO				= GetParam("var_nome_evento")

 AbreDBConn objConn, CFG_DB

		  strSQL = " SELECT COD_PALESTRANTE_HOSP,COD_PALESTRANTE_EVENTO,DT_CHECKIN,DT_CHECKOUT,VALOR_DIARIA,CATEGORIA,VALOR_CONG,FORMA_PGTO,OBS,LOCAL,ACOMP "
 strSQL = strSQL & "  FROM tbl_palestrante_hospedagem " 
 strSQL = strSQL & " WHERE COD_PALESTRANTE_EVENTO = " & strToSQL(strCOD_PALESTRANTE_EVENTO)

 'athDebug strSQL, false
 	
 set objRS = objConn.execute(strSQL)
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript"></script>
</head>
<body class="metro">
<!-- Barra que contem o título do módulo e ação da dialog//-->
<div class="bg-darkOrange fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=strNOME_EVENTO%>&nbsp;<sup><span style="font-size:12px"><%=objLang.SearchIndex("dialog_hospedagem",0)%></span></sup>
</div>
<!-- FIM -------------------------------Barra//-->
<div class="container padding20">
<form name="formprint" id="formprint" action="" method="">
<%        
If not objRS.EOF Then
	do while not objRS.eof
%>
<h3 style="color: gray"><i class="icon-briefcase-2" style="color: gray"></i> <strong><%=getValue(objRS,"LOCAL")%></strong></h3>
<table class="tablesort table hovered striped">
    <tbody>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_checkin",0)%>:</td>
           	<td><strong><%=getValue(objRS,"DT_CHECKIN")%></strong></td>
        </tr>        
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_checkout",0)%>:</td>
           	<td><strong><%=getValue(objRS,"DT_CHECKOUT")%></strong></td>
        </tr>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_categoria",0)%>:</td>
           	<td><strong><%=UCase(getValue(objRS,"CATEGORIA"))%></strong></td>
        </tr>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_acompanhante",0)%>:</td>
           	<td><strong><%=UCase(getValue(objRS,"ACOMP"))%></strong></td>
        </tr>
    </tbody>
</table>
<hr>
<%
objRS.MoveNext
loop
End If
%>
    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class=""        type="button"  value="PRINT"  onClick="javascript:window.print();">                               
        </div>
        <div style="float:right">
            <small class="text-left fg-teal" style="float:right"> </small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
</form>     


</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
<%
 FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>