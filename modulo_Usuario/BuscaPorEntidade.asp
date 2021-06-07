<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
	Dim objConn, objRS, strSQL  
	Dim strNOME, strTABLE, strTYPE, strFORM
	Dim strCOLOR
	
	AbreDBConn objConn, CFG_DB 
	
	strNOME  = GetParam("var_nome")
	strTABLE = GetParam("var_table")
	strFORM  = GetParam("var_form")
	
	If strTABLE = "ENT_COLABORADOR" Then
		strSQL =          " SELECT COD_COLABORADOR AS CODIGO, EMAIL, NOME "
		strSQL = strSQL & " FROM ENT_COLABORADOR "
		strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
		If strNOME <> "" Then strSQL = strSQL & " AND NOME LIKE '" & strNOME & "%'"
		strSQL = strSQL & " ORDER BY 3 "
	End If
	
	If strTABLE = "ENT_CLIENTE" Then
		strSQL =          " SELECT COD_CLIENTE AS CODIGO, EMAIL, NOME_FANTASIA AS NOME "
		strSQL = strSQL & " FROM ENT_CLIENTE "
		strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
		If strNOME <> "" Then strSQL = strSQL & " AND NOME_FANTASIA LIKE '" & strNOME & "%'"
		strSQL = strSQL & " ORDER BY 3 "
	End If
	
	'If strTABLE = "ENT_FORNECEDOR" Then
	'	strSQL =          " SELECT COD_FORNECEDOR AS CODIGO, EMAIL, NOME_FANTASIA AS NOME "
	'	strSQL = strSQL & " FROM ENT_FORNECEDOR "
	'	strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
	'	If strNOME <> "" Then strSQL = strSQL & " AND NOME_FANTASIA LIKE '" & strNOME & "%'"
	'	strSQL = strSQL & " ORDER BY 3 "
	'End If
%>
<html>
<head>
<title>vboss</title>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<script>
function Retorna(pr_cod)
{
    window.opener.SetFormField('<%=strFORM%>','var_codigo','edit',pr_cod);
    window.opener.SetFormField('<%=strFORM%>','var_tipo','combo','<%=strTABLE%>');
	
	window.close();
}
</script>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body>
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px; border-collapse:collapse;"></td>
	<td width="1%" class="top_middle" style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px; border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
	<div class="form_line">
		<form name="form_principal" method="post" action="BuscaPorEntidade.asp">
			<input name="var_form" type="hidden" value="<%=strFORM%>">
			<div class="form_label_nowidth">Nome/N.Fantasia:</div><input name="var_nome" type="text" size="20" class="edtext" value="<%=strNOME%>">
			<select name="var_table" class="edtext_combo" style="width:120px">
                <option value="ENT_COLABORADOR" <%if strTABLE="ENT_COLABORADOR" then response.write "selected"%>>Colaborador</option>
                <option value="ENT_CLIENTE"     <%if strTABLE="ENT_CLIENTE"     then response.write "selected"%>>Cliente</option>
             </select>
			<div onClick="document.form_principal.submit();" class="btsearch"></div>
		</form>
	</div>
	</td>
</tr>
</table>
<%
 if strTABLE <>"" then
   Set objRS = objConn.Execute(strSQL) 
   If Not objRS.EOF Then
%>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
 <tr>
    <th width="01%"></th>
	<th width="09%" class="sortable-numeric">Cod</th>
	<th width="60%" class="sortable">Nome/N.Fantasia</th>
	<th width="30%" class="sortable">Email</th>
 </tr>
 </thead>
 <tbody style="text-align:left;">
<%
		while not objRS.Eof
			strCOLOR = swapString(strCOLOR,"#FFFFFF","#F5FAFA")
%>
	<tr bgcolor="<%=strCOLOR%>" style="cursor:hand;" onMouseOver="this.style.backgroundColor='#FFCC66';" onMouseOut="this.style.backgroundColor='';" onClick="Retorna('<%=GetValue(objRS,"CODIGO")%>');">
		<td></td>
		<td style="text-align:right;"><%=GetValue(objRS,"CODIGO")%></td>
		<td><%=GetValue(objRS,"NOME")%></td>
		<td><%=GetValue(objRS,"EMAIL")%></td>
	</tr>
<%
			objRS.MoveNext
		wend
%>
 </tbody>
</table>
<%
   else
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
   end if
   FechaRecordSet objRS
 end if
%>
</body>
</html>
<%
 FechaDBConn objConn
%>