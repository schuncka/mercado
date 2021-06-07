<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<%
  Dim strSQL
 
  strSQL = Request("var_strParam")
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<script language="JavaScript" type="text/JavaScript">
function Executa() {
	if ((document.formacao.var_acao.value == 'printall') || (document.formacao.var_acao.value == 'printthis')) {
		window.parent.frames['frm_rpt_venda_stand_detail'].focus();
		window.parent.frames['frm_rpt_venda_stand_detail'].print();
	}
	else {
		document.formacao.action = 'Report_Venda_Stand_Detail.asp';
		document.formacao.submit();
	}
}

</script>
</head>
<body bgcolor="#F7F7F7" leftmargin="0" topmargin="0">
<table width="100%" height="100%" cellpadding="0" cellspacing="2" border="0">
 <tr><td colspan="3"></td></tr>
 <tr>
   <td width="98%"></td>
   <td width="1%" align="right" valign="top"><img src="../img/PrintExport.gif">&nbsp;&nbsp;</td>
   <td width="1%" align="right" valign="middle">
    <form name="formacao" action="javascript:Executa();" method="post" target="frm_rpt_venda_stand_detail">
        <input type="hidden" value="<%=strSQL%>" name="var_strParam">
	 <select name="var_acao" onChange="javascript:Executa();">
	   <option value="" selected>Selecione...</option>
	   <option value="printall">Imprimir tudo</option>
	   <option value="printthis">Imprimir esta página</option>
	   <option value=".xls">Exportar para Excel</option>
	   <option value=".doc">Exportar para Word</option>
	 </select>
    </form>
   </td>
 </tr>
 <tr><td colspan="3"></td></tr>
</table>
</body>
</html>
