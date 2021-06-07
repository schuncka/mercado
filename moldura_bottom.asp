<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<%
  Dim pwidth

  pwidth = Request.QueryString("var_pwidth")

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<%
 if pwidth <> "*" then 
   response.write "<table "
   response.write "width='" & pwidth + 12 & "' background='img/outer_botton_shadow.jpg'" 
   response.write "height='10' align='center' border='0' cellspacing='0' cellpadding='0'> "
   response.write "<tr>" 
   response.write "  <td></td>"
   response.write "</tr>"
   response.write "</table>"
 end if
%> 
</body>
</html>
