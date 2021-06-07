<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<%
  Dim pwidth
  pwidth = Request.QueryString("var_pwidth")
%>
<html>
<head>
</head>
<body bgcolor="#FFFFFF" background="" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<% if pwidth<>"*" then 
     response.write "<table height='100%' align='center' border='0' cellspacing='0' cellpadding='0' >"
     response.write "  <tr>" 
     response.write "     <td>"
     response.write "     </td>"
     response.write "  </tr>"
     response.write "  <tr> "
     response.write "    <td height='10' align='center' valign='bottom' " 
     response.write "        width='" & pwidth + 12 & "' background='img/outer_top_shadow.jpg'></td>"
     response.write "  </tr>"
     response.write "</table>"
   end if
%>	 

</body>
</html>
