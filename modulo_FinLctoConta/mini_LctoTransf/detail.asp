<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_CfgLinks",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          					' - Default do Modulo...
 Const LTB = "FIN_LCTO_TRANSF"	    			' - Nome da Tabela...
 Const DKN = "COD_LCTO_TRANSF"          			' - Campo chave...
 Const DLD = "../modulo_FinLctoConta/mini_LCTOTransf/default.asp" 		' "../evento/data.asp" - 'Default Location ap�s Dele��o
 Const TIT = "LCTO TRANSF"    						' - Nome/Titulo sendo referencia como titulo do m�dulo no bot�o de filtro
  
 
 Dim strCODIGO ,Idx , strFIELD, strTYPE, strVALUE
 
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Pagina��o	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 
 Dim  strCODLINK, strCOD_EVENTO
 
 strCODLINK = Replace(GetParam("var_chavereg"),"'","''")
  
 If strCODLINK <> "" Then
	  AbreDBConn objConn, CFG_DB 
	  
	  strSQL = "SELECT * FROM " & LTB & " WHERE " & DKN & " = " & strCODLINK
      Set objRS = objConn.Execute(strSQL)

      If Not objRS.Eof Then  
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro">
<!-- Barra que contem o t�tulo do m�dulo e a��o da dialog//-->
<div class="bg-darkOrange fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">DETAIL</span></sup>
</div>
<!-- FIM -------------------------------Barra//-->
<div class="container padding20">
<table class="tablesort table hovered striped">
    <thead>
        <tr>
            <th style="width:05%;" class="sortable-numeric">&nbsp;</th>
            <th style="width:15%;" class="sortable">Campo</th>
            <th style="width:80%;" class="sortable">Dado</th>
        </tr>
    </thead>
    <tbody>
		<% for Idx = 0 to objRS.fields.count -1 
				strFIELD = objRS.Fields(Idx).name
				strTYPE  = Replace(RetDataTypeEnum(objRS.Fields(Idx).type),"ad","")
	 	        strVALUE = GetValue(objRS,strFIELD) 
				if (lcase(DKN) = lcase(strFIELD)) then strFIELD = "<strong>" & Ucase(strFIELD) & "</strong>" end if  %> 
            <tr>
               <td><%=Idx%></td>
               <td title="DB Datatype: <%=ucase(strTYPE)%>" style="cursor:help;"><%=Ucase(strFIELD)%></td>
               <td><%=server.HTMLEncode(strVALUE)%></td>
            </tr>
        <% next %>
    </tbody>
    <tfoot bgcolor="#F8F8F8">
        <tr>
            <td colspan="3">
                <div style="width:180px; height:25px; float:right; text-align:right; padding-right:5px; cursor:help;">
                	<small class="text-left fg-teal"  title="DATA BASE TABLE REFERENCE"><%=lcase(LTB)%></small>
                </div>
            </td>
        </tr>
    </tfoot>
</table>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
<%
	 End If 
      FechaRecordSet objRS
	  FechaDBConn objConn
 End If 
 'athDebug strSQL, true '---para testes'
%>
