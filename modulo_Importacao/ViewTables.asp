<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->  

<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 

<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
	
	Dim objConn, objRS, strSQL
	Dim queryType, criteria, strTABLE, i, rsSchema, strMarcaPK
	strTABLE = GetParam("var_tables")
	'response.Write	strTABLE
	AbreDBConn objConn, CFG_DB 	
	
	
	
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<title>Mercado</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro" id="metrotablevista" >
<div style="padding-top:3px;">
	<%
       if (strTABLE<>"") then
  	     strSQL = "SHOW COLUMNS FROM " & strTABLE
         set objRS = objConn.Execute(strSQL)	     
		 if not objRS.EOF then	       
           While Not objRS.Eof  
			  If getValue(objRS,"Key") = "PRI" Then strMarcaPK = "'code-text text-info' title='Primary Key'" Else strMarcaPK = "'code-text';" End If
			  Response.Write("<span class=" & strMarcaPK & ">" & ucase(getValue(objRS,"Field")) & " (" & getValue(objRS,"Type") & ")</span><br>") 
			  athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
            Wend		 
         end if
       end if	   
    %>
</div>

</body>
</html>
<%
'FechaDBConn ObjConn
%>

