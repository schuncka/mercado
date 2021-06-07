<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true 
 
 Dim objConn, objRS, strSQL, strSQLClause
 Dim strAno, strINICIAL, strSITUACAO, strENTIDADE, strID, strGRP_USER
 Dim  strCOLOR, strArquivo

 AbreDBConn objConn, CFG_DB 

 strID       = GetParam("var_id")
 strSITUACAO = GetParam("var_situacao")
 strINICIAL  = GetParam("var_inicial")
 strGRP_USER = GetParam("var_grp_user")

 strSql =          " SELECT COD_USUARIO, NOME, ID_USUARIO, GRP_USER, TIPO, EMAIL "
 strSql = strSql & " FROM USUARIO "
 strSql = strSql & " WHERE COD_USUARIO > 0 " 

 strSQLClause = ""
 if strID <> ""             then strSQLClause = strSQLClause & " AND ID_USUARIO LIKE '" & strID & "%'"
 if strSITUACAO = "INATIVO" then strSQLClause = strSQLClause & " AND DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"   then strSQLClause = strSQLClause & " AND DT_INATIVO IS NULL "
 if strGRP_USER <> ""       then strSQLClause = strSQLClause & " AND GRP_USER LIKE '" & strGRP_USER & "' "
 
 if strINICIAL <> "" then
  if strINICIAL <> "0-9" then
  	strSQLClause = strSQLClause & " AND ID_USUARIO LIKE '" & strINICIAL & "%'"
  else 
  	strSQLClause = strSQLClause & " AND (ID_USUARIO LIKE '0%' "
    strSQLClause = strSQLClause & "  OR ID_USUARIO LIKE '1%' "
	strSQLClause = strSQLClause & "  OR ID_USUARIO LIKE '2%' "
	strSQLClause = strSQLClause & "  OR ID_USUARIO LIKE '3%' "
	strSQLClause = strSQLClause & "  OR ID_USUARIO LIKE '4%' "
	strSQLClause = strSQLClause & "  OR ID_USUARIO LIKE '5%' "
	strSQLClause = strSQLClause & "  OR ID_USUARIO LIKE '6%' "
	strSQLClause = strSQLClause & "  OR ID_USUARIO LIKE '7%' "
	strSQLClause = strSQLClause & "  OR ID_USUARIO LIKE '8%' "
	strSQLClause = strSQLClause & "  OR ID_USUARIO LIKE '9%') "
  end if
 end if
 
 if (strSQLClause <> "") then strSql = strSql & strSQLClause 
 
 strSql = strSql & " ORDER BY ID_USUARIO, NOME, COD_USUARIO "
 
 Set objRs = objConn.Execute(strSql) 
 
 If Not objRS.EOF Then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr> 
    <th width="1%"></th>
    <th width="1%"></th>
    <th width="1%"></th>
    <th width="1%"></th>
    <th width="1%"></th>
    <th width="1%"  class="sortable" nowrap>ID Usuário</th>
	<th width="91%" class="sortable">Nome</th>
	<th width="1%"  class="sortable" nowrap>Grupo</th>
    <th width="1%"  class="sortable" nowrap>E-mail</th>
    <th width="1%"  class="sortable" nowrap>Entidade</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
 	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		
		strENTIDADE = ""
		If getValue(objRS,"TIPO") = "ENT_COLABORADOR" Then strENTIDADE = "Colaborador"
		If getValue(objRS,"TIPO") = "ENT_CLIENTE" Then strENTIDADE = "Cliente"
  %>
      <tr bgcolor=<%=strCOLOR%>> 
		<td width="1%"><%=MontaLinkGrade("modulo_USUARIO","Delete.asp",GetValue(objRS,"COD_USUARIO"),"IconAction_DEL.gif","REMOVER")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_USUARIO","Update.asp",GetValue(objRS,"COD_USUARIO"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_USUARIO","DireitosFull.asp","&var_iduser=" & getValue(objRS,"ID_USUARIO"),"IconAction_DIREITOS.gif","DIREITOS")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_USUARIO","Detail.asp",GetValue(objRS,"COD_USUARIO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_USUARIO","InsertCopiaUser.asp",getValue(objRS,"COD_USUARIO"),"IconAction_COPY.gif","COPIAR USUÁRIO")%></td>
        <td nowrap><%=getValue(objRS,"ID_USUARIO")%></td>
        <td><%=getValue(objRS,"NOME")%></td>
        <td nowrap><%=getValue(objRS,"GRP_USER")%></td>
        <td nowrap><%=getValue(objRS,"EMAIL")%></td>
        <td nowrap><%=strENTIDADE%></td>
      </tr>
  <%
        athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
      Wend
  %>
  </tbody>  
</table>
</body>
</html>
<%
 else
   Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
 end if
 
 FechaRecordSet ObjRS
 FechaDBConn objConn
%>