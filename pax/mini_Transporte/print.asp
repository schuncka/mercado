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
<body class="metro" id="metrotablevista" >
    <div class="container page">
    	<h1><%=strNOME_EVENTO%></h1>    
			<%        
            If not objRS.EOF Then
                do while not objRS.eof
            %>       
            <div class="row">
                <div class="span8"><p>&nbsp;</p></div>
            </div>                 
            <h2 class="fg-amber" id="_description"><%=getValue(objRS,"DATA")%> - <%=getValue(objRS,"TIPO")%> (<%=getValue(objRS,"TRECHO")%>)</h2>
            <div class="row">
                <div class="span8"><p><%=objLang.SearchIndex("dialog_empresa",0)%>: <strong><%=getValue(objRS,"EMPRESA")%></strong></p></div>
            </div>
            <div class="row">                
                <div class="span8"><p><%=objLang.SearchIndex("dialog_voo",0)%>: <strong><%=getValue(objRS,"VOO")%></strong></p></div>                     
            </div>                    
    
            <div class="row">
                <div class="span8"><p><%=objLang.SearchIndex("dialog_localizador",0)%>: <strong><%=getValue(objRS,"LOC")%></strong></p></div>
            </div>
            <div class="row">                                
                <div class="span8"><p><%=objLang.SearchIndex("dialog_bilhete",0)%>: <strong><%=getValue(objRS,"BILHETE")%></strong></p></div>
            </div>
            <div class="row">
                <div class="span8"><p><%=objLang.SearchIndex("dialog_origem_destino",0)%>: <strong><%=getValue(objRS,"ORIGEM")%> - <%=getVALUE(objRS,"DESTINO")%></strong></p></div>
            </div>
            <div class="row">
                <div class="span8"><p><%=objLang.SearchIndex("dialog_embarque",0)%>: <strong><%=getValue(objRS,"HORA_EMBARQUE")%></strong></p></div>
            </div>   
            <div class="row">
                <div class="span8"><p><%=objLang.SearchIndex("dialog_desembarque",0)%>: <strong><%=getValue(objRS,"HORA_DESEMBARQUE")%></strong></p></div>
            </div>                                                                                                                               
            <div class="row">
                <div class="span8"><p><%=objLang.SearchIndex("dialog_tranferin",0)%>: <strong><%=getValue(objRS,"TRANSFERIN")%></strong></p></div>
            </div>                     
            <div class="row">
                <div class="span8"><p><%=objLang.SearchIndex("dialog_tranferout",0)%>: <strong><%=getValue(objRS,"TRANSFEROUT")%></strong></p></div>
            </div> 
            <div class="row">
                <div class="span8"><p>&nbsp;</p></div>
            </div>             
    
            <%
                objRS.MoveNext
                loop
            End If
            %>             
	</div> <!--FIM ----DIV CONTAINER//-->  
<script language="JavaScript">
<!--
window.print();
//-->
</script>    
</body>
</html>
<%
 FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>