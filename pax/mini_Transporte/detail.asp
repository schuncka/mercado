<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_Transporte",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_palestrante_transp"	' - Nome da Tabela...
 Const DKN = "COD_PALESTRANTE_EVENTO"	' - Campo chave...
 Const TIT = "Translado"     			' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
  
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

		  strSQL = " SELECT COD_PALESTRANTE_EVENTO,TIPO,DATA,VOO,ORIGEM,DESTINO,LOC,HORA_EMBARQUE,HORA_DESEMBARQUE,VALOR,TAXA,OBS,TRANSFERIN,TRANSFEROUT,BILHETE,EMPRESA,TRECHO "
 strSQL = strSQL & "  FROM tbl_palestrante_transp " 
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
   <%=strNOME_EVENTO%>&nbsp;<sup><span style="font-size:12px"><%=objLang.SearchIndex("dialog_translado",0)%></span></sup>
</div>
<!-- FIM -------------------------------Barra//-->
<div class="container padding20">
<form name="formprint" id="formprint" action="" method="">
<%        
If not objRS.EOF Then
	do while not objRS.eof
%>
<h3 style="color: gray"><i class="icon-calendar" style="color: gray"></i> <strong><%=getValue(objRS,"DATA")%></strong></h3>
<table class="tablesort table hovered striped">
    <tbody>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_trecho",0)%>:</td>
           	<td><strong><%=UCase(getValue(objRS,"TRECHO"))%></strong></td>
        </tr>        
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_tipo",0)%>:</td>
           	<td><strong><%=UCase(getValue(objRS,"TIPO"))%></strong></td>
        </tr>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_empresa",0)%>: </td>
           	<td><strong><%=UCase(getValue(objRS,"EMPRESA"))%></strong></td>
        </tr>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_voo",0)%>:</td>
           	<td><strong><%=UCase(getValue(objRS,"VOO"))%></strong></td>
        </tr>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_localizador",0)%>:</td>
           	<td><strong><%=UCase(getValue(objRS,"LOC"))%></strong></td>
        </tr>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_bilhete",0)%>:</td>
           	<td><strong><%=UCase(getValue(objRS,"BILHETE"))%></strong></td>
        </tr>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_origem_destino",0)%>:</td>
           	<td><strong><%=UCase(getValue(objRS,"ORIGEM"))%> - <%=UCase(getVALUE(objRS,"DESTINO"))%></strong></td>
        </tr>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_embarque",0)%>:</td>
           	<td><strong><%=getValue(objRS,"HORA_EMBARQUE")%></strong></td>
        </tr>
    	<tr>
        	<td><%=objLang.SearchIndex("dialog_desembarque",0)%>:</td>
           	<td><strong><%=getValue(objRS,"HORA_DESEMBARQUE")%></strong></td>
        </tr>
        <tr>
        	<td><%=objLang.SearchIndex("dialog_tranferin",0)%>:</td>
        	<td><strong><%=UCase(getValue(objRS,"TRANSFERIN"))%></strong></td>
        </tr>     
        <tr>
        	<td><%=objLang.SearchIndex("dialog_tranferout",0)%>:</td>
        	<td><strong><%=UCase(getValue(objRS,"TRANSFEROUT"))%></strong></td>
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