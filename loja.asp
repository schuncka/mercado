<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<html>
<head>
<title>YOUR COMPANY NAME - WEB SITE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="_css/csm.css" rel="stylesheet" type="text/css">
</head>
<%
strPATH = UCase(Request("tp"))
strCOD_EVENTO = Request("cod_evento")

If strCOD_EVENTO = "" Then
  strCOD_EVENTO = Session("COD_EVENTO")
End If

Select Case strPATH
  Case "PJ"
    strPATH = "shoppj"
  Case Else
    strPATH = "shop"
End Select
%>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td align="center"><b>YOUR COMPANY NAME - WEB SITE</b></td>
  </tr>
  <tr> 
    <td align="center"><iframe name="ifrmshop" src="<%=strPATH%>/?cod_evento=<%=strCOD_EVENTO%>" width="560" height="450" frameborder="0"></iframe></td>
  </tr>
</table>
</body>
</html>
