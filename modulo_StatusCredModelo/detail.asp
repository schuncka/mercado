<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %>
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_ShopIntlCartaoVisao",Session("METRO_USER_ID_USER")), true %>
<%

Const MDL = "DEFAULT"		' - Default do Modulo...
Const LTB = "tbl_STATUS_CRED_MODELO"	    				' - Nome da Tabela...
Const DKN = "COD_STATUS_CRED_MODELO" 
Const DLD = "../modulo_StatusCredModelo/default.asp" 	' "../evento/data.asp" - 'Default Location ap�s Dele��o         				' - Campo chave...
Const TIT = "ShopIntl Passo1"    						' - Nome/Titulo sendo referencia como titulo do m�dulo no bot�o de filtro
	
 Dim objConn, objRS, strSQL
 Dim strID_AUTO ,Idx , strFIELD, strTYPE, strVALUE
  
 strID_AUTO = GetParam("var_chavereg")
  
 If strID_AUTO <> "" Then
	  AbreDBConn objConn, CFG_DB 
	  
	  strSQL = "SELECT * FROM " & LTB & " WHERE " & DKN & " = " & strID_AUTO
      Set objRS = objConn.Execute(strSQL)

      If Not objRS.Eof Then  
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
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
