<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_EntradaCred",Session("ID_USER")), true %>
<%
 Const LTB = "TBL_LOCAL_CREDENCIAL" 		' - Nome da Tabela...
 Const DKN = "COD_LOCAL_CREDENCIAL" 		' - Campo chave...
 Const TIT = "LCredencial" 					' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

  'Relativas a conexão com DB, RecordSet e SQL
  
 
 Dim strCODIGO ,Idx , strFIELD, strTYPE, strVALUE
 
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 
 Dim  strCODLOCALCREDENCIAL, strNOME, strLOCAL, strDESCRICAO
 
 strCODLOCALCREDENCIAL = Replace(GetParam("var_chavereg"),"'","''")
  
 If strCODLOCALCREDENCIAL <> "" Then
	  AbreDBConn objConn, CFG_DB 
	  
	  strSQL = "SELECT * FROM " & LTB & " WHERE " & DKN & " = " & strCODLOCALCREDENCIAL
      Set objRS = objConn.Execute(strSQL)

      If Not objRS.Eof Then  
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
</head>
<body class="metro">
<!-- Barra que contem o título do módulo e ação da dialog//-->
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
