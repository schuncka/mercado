<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<%
  Dim strMenuOPen
  strMenuOPen = Request.QueryString("var_open")

  if strMenuOPen="" then 
    strMenuOPen="FALSE"
  end if	 
%>
<HTML>
<HEAD>
<meta http-equiv=Content-Type content="text/html;  charset=ISO-8859-1">
<TITLE>Mercado</TITLE>
<SCRIPT language="JavaScript" src="_scripts/flash.js"></SCRIPT>
</HEAD>
<BODY bgcolor="#FFFFFF" topmargin="0" leftmargin="0" background="img/BGTopMenu.jpg">

<SCRIPT>FlashSemBorda('athMenu_CSM',778,120,'FFFFFF','')</SCRIPT>

</BODY>
</HTML>
