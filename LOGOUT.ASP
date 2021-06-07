<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<!--#include file="_database/secure.asp"-->
<%
 
 Session.Contents.RemoveAll() 
 Session.Abandon()
%>
<!DOCTYPE html>
<html>
<head>
<title>Mercado</title>
<!--#include file="_metroui/meta_css_js.inc"--> 
<script src="_scripts/scriptsCS.js"></script>

</head>
<body class="metro" id="metrotablevista" onLoad="document.formulario.submit()">
<form name="formulario" id="formulario" action="login.asp" target="_top" method="post">
</form>
</body>
</html>