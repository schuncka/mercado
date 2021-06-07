
<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
 
  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<%
Dim objConn, objConnSchema, objRS, objRSSchema, strSQL
Dim strDATABASE, arrDATABASE, strSCRIPT, arrSCRIPT, strBgColor
Dim i
Dim arrScodi, arrSdesc,strAlteraCor

Dim strCLIENTE,strCNPJ,strCONTRATO,strGERENTE, strCheckinDbl, strCheckin
'Dim CFG_DB
Dim strIO, strState, strSQLStatus, strPath




CFG_DB       = request("var_db")
strCheckin   = request("var_checkin")

strPath = left(CFG_DB,instr(CFG_DB,"_")-1)


'response.Write(CFG_DB)
'response.End()
AbreDBConn objConn, CFG_DB


MontaArrySiteInfo arrScodi, arrSdesc

 strCLIENTE = ""
 if ArrayIndexOf(arrScodi,"CLIENTE") <> -1 THEN 
  strCLIENTE = arrSDesc(ArrayIndexOf(arrScodi,"CLIENTE"))
 end if
 
 strCNPJ = ""
 if ArrayIndexOf(arrScodi,"CNPJ") <> -1 THEN 
  strCNPJ = arrSDesc(ArrayIndexOf(arrScodi,"CNPJ"))
 end if
 
 strCONTRATO = ""
 if ArrayIndexOf(arrScodi,"CONTRATO") <> -1 THEN 
  strCONTRATO = arrSDesc(ArrayIndexOf(arrScodi,"CONTRATO"))
 end if
 
 strGERENTE = ""
 if ArrayIndexOf(arrScodi,"GERENTE") <> -1 THEN 
  strGERENTE = arrSDesc(ArrayIndexOf(arrScodi,"GERENTE"))
 end if
 strCheckinDbl = "CLIENTE: " & strCLIENTE & " | CNPJ: " & strCNPJ & " | CONTRATO: " & strCONTRATO & " | GERENTE: " & strGERENTE
  
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>

</head>
<body class="metro" id="metrotablevista">
	<div class="padding10" style="border:1px solid #999; width:100%; height:50px;">       
		<p class="tertiary-text no-margin"><strong>CHECK-IN DOUBLE</strong> <small>(table sys_site_info online)</small></p>
		<p class="tertiary-text no-margin"><%=strCheckinDbl%></p>		
	</div>                               
	<form id="form_valida" name="form_valida" target="_top" action="http://localhost/<%=strPath%>/_database/athValidaReplica.asp" method="post">
		 <input id="var_errorDblC" name="var_errorDblC" type="hidden" value="erro" style="background-color:transparent; width:100%">
	</form>				
</body>
<script language="javascript">
<%IF cstr(trim(strCheckinDbl)) <> cstr(trim(strCheckin)) THEN%>
		document.getElementById("form_valida").submit();
<%	END IF %>
</script>
</html>
<%
'Response.Flush
%>