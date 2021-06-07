<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script src="../_ckeditor/ckeditor.js"></script>
<script language="javascript">
function atualizarHTML() {
	var valor =  CKEDITOR.instances['var_html'].getData();
	self.opener.SetParentField('<%=Request("var_campo")%>', valor);
	window.close();
}
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td align="center" valign="middle">   
    <textarea name="var_html" id="var_html" cols="80" rows="10" class="ckeditor" style="width:98%;"><%=Request("var_html")%></textarea>
    <br>
    <br>
    <input type="button" name="btOK" value="Atualizar HTML" onClick="atualizarHTML()">
	</td>
  </tr>
</table>
</body>
</html>
