<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<frameset rows="85,*" cols="*" framespacing="0" frameborder="no" border="0">
  <frame name="frm_chaveacessohead" src="chaveacesso_head.asp?var_chavereg=<%=Request("var_chavereg")%>">
  <frame name="frm_chaveacessodetail" src="chaveacesso_body.asp?var_chavereg=<%=Request("var_chavereg")%>">
</frameset>
<noframes><body>

</body></noframes>
</html>
