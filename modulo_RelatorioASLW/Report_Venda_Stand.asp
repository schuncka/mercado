<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<%
 Dim strNOME, strCATEGORIA, strDESCRICAO, strSQL
 
 strNOME      = Request("var_nome")
 strCATEGORIA = Request("var_categoria")
 strSQL       = Request("var_strParam")
 strDESCRICAO = Request("var_descricao")

 'Response.Write("strCOD_REL:" & strCOD_REL & "<br>")
 'Response.Write("strSQL:" & strSQL & "<br>")
 'Response.End
%>
<html>
<head>
<title>ASLW</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset rows="30,*,30" cols="*" framespacing="0" frameborder="no" border="0">
  <frame name="frm_rpt_venda_stand_header" src="Report_Venda_Stand_Header.asp?var_nome=<%=strNOME%>&var_categoria=<%=strCATEGORIA%>" scrolling="no">
  <frame frameborder="1" name="frm_rpt_venda_stand_detail" src="Report_Venda_Stand_Detail.asp?var_strParam=<%=strSQL%>&var_descricao=<%=strDESCRICAO%>">
  <frame frameborder="1" name="frm_rpt_venda_stand_footer" src="Report_Venda_Stand_Footer.asp?var_strParam=<%=strSQL%>" scrolling="no">
</frameset>
<noframes><body>
</body></noframes>
</html>
