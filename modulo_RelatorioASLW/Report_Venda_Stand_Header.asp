<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<%
 Dim strNOME, strCATEGORIA, strTEXTO
 
 strNOME = Request("var_nome")
 strCATEGORIA = Request("var_categoria")

 strTEXTO = strNOME
 If strCATEGORIA <> "" Then
	strTEXTO = strTEXTO & "  ( " & strCATEGORIA & " )"
 End If
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#F7F7F7" leftmargin="0" topmargin="0">
<table width="100%" height="100%" cellpadding="0" cellspacing="2" border="0">
	<tr>
		<td><div style="padding-left:10px;padding-top:3px">
			<b><%=strTEXTO%></b>
			</div>
		</td>
	</tr>
</table>
</body>
</html>
