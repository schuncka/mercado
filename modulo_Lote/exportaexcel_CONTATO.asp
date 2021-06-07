<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<%
 Dim strCOD_LOTE
	
 strCOD_LOTE = Request("var_chavereg")
 
 Response.Buffer = True
 
 Response.AddHeader "Content-Type","application/x-msdownload"
 Response.AddHeader "Content-Disposition","attachment; filename=rel_" & Session.SessionID & "_" & strCOD_LOTE & ".xls"
 
%>
<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="100%" border="0">
  <tr> 
    <td><strong>Código</strong></td>
    <td><strong>Nome</strong></td>
    <td><strong>Endereço</strong></td>
    <td><strong>Bairro</strong></td>
    <td><strong>Cidade</strong></td>
    <td><strong>UF</strong></td>
    <td><strong>CEP</strong></td>
    <td><strong>País</strong></td>
    <td><strong>E-mail</strong></td>
    <td><strong>Telefone</strong></td>
	<td><strong>Entidade</strong></td>
    <td><strong>Cod. Atividade</strong></td>
	<td><strong>CPF/CNPJ</strong></td>
	<td><strong>Status Credencial</strong></td>
	<td><strong>Status Preço</strong></td>
	<td><strong>Idioma</strong></td>
	<td><b>Nome Contato</b></td>
	<td><b>Cargo</b></td>
	<td><b>CPF</b></td>
	<td><b>Data Aniv</b></td>
	<td><b>E-mail</b></td>
  </tr>
  <%
 Dim objConn, ObjRS, objRSDetail
 Dim strSQL, strSQLClause, strSQLClause2, strSQLLeftJoin, strSQLParenteses, strFLAG_EVENTO, strSQLOrdem, auxstr, MyChecked, cont
 Dim auxTimeInic, auxTimeFim, strCAMPO_ANTERIOR
 
 Dim strCRITERIO_EVENTO, strSQL_CRITERIO
 
' if strVAR <> "" then
   AbreDBConn objConn, CFG_DB_DADOS 

   strSQL_CRITERIO = ""
   
   strSQL = " SELECT NUM_CRED_PJ, NOMINAL, CRITERIO_EVENTO, SQL_CRITERIO FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
     strCRITERIO_EVENTO = objRS("CRITERIO_EVENTO")&""
	 strSQL_CRITERIO = objRS("SQL_CRITERIO")&""
   End If
   FechaRecordSet objRS
   
   ' Montagem dos campos de critério da pesquisa
   strCAMPO_ANTERIOR = ""
   strSQL = " SELECT * FROM tbl_Lote_Criterio WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   Do While not objRS.EOF
     If strCAMPO_ANTERIOR <> objRS("CAMPO") Then
	   strCAMPO_ANTERIOR = objRS("CAMPO")
       strSQLClause = strSQLClause & ") AND ("
	   strSQLClause = strSQLClause & objRS("CAMPO") & " "
	   
       If objRS("CRITERIO") = "IN" Then 
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " ('" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "') "
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " (" & Replace(objRS("VALOR")&"","'","''") & ") "
		 End If
  	   Else
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
		  if objRS("CRITERIO") = "LIKE" Or objRS("CRITERIO") = "LIKE_CONTEM" then
	       strSQLClause = strSQLClause & " LIKE '%" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  elseif objRS("CRITERIO") = "LIKE_COMECA" then
	       strSQLClause = strSQLClause & " LIKE '" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " '" & Replace(objRS("VALOR")&"","'","''") & "' "
		  end if
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " " & Replace(objRS("VALOR")&"","'","''") & " "
		 End If
	   End If
	 Else
       strSQLClause = strSQLClause & " OR "
	   strSQLClause = strSQLClause & objRS("CAMPO") & " "
       If objRS("CRITERIO") = "IN" Then 
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " ('" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "') "
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " (" & Replace(objRS("VALOR")&"","'","''") & ") "
		 End If
	   Else
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
		  if objRS("CRITERIO") = "LIKE" Or objRS("CRITERIO") = "LIKE_CONTEM" then
	       strSQLClause = strSQLClause & " LIKE '%" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  elseif objRS("CRITERIO") = "LIKE_COMECA" then
	       strSQLClause = strSQLClause & " LIKE '" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " '" & Replace(objRS("VALOR")&"","'","''") & "' "
		  end if
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " " & Replace(objRS("VALOR")&"","'","''") & " "
		 End If
	   End If
	 End If
     objRS.MoveNext
   Loop
   strSQLClause = strSQLClause & ") "
   FechaRecordSet objRS
   
    strFLAG_EVENTO = False
	cont = 1
	
    strSQL = " SELECT COD_EVENTO, CRITERIO FROM tbl_LOTE_EVENTO WHERE COD_LOTE = " & strCOD_LOTE
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then	
	 
	 strFLAG_EVENTO = True
	 
	 strSQLParenteses = strSQLParenteses & " ( "
	   
	 strSQLLeftJoin = strSQLLeftJoin & " LEFT OUTER JOIN VIEW_RESUMO_VISITACAO ON (tbl_Empresas.COD_EMPRESA = VIEW_RESUMO_VISITACAO.COD_EMPRESA_VISITACAO) "
	 strSQLLeftJoin = strSQLLeftJoin & ")"
	 
	 strSQLClause2 = strSQLClause2 & " AND ("
	 
	 Do While not objRS.EOF
	  
	  If objRS("CRITERIO") = "<>" Then
		strSQLClause2 = strSQLClause2 & " VIEW_RESUMO_VISITACAO.`" & objRS("COD_EVENTO") & "` = 0"
	  Else
		strSQLClause2 = strSQLClause2 & " VIEW_RESUMO_VISITACAO.`" & objRS("COD_EVENTO") & "` > 0"
	  End If
	  cont = cont + 1
	  objRS.MoveNext
	  If not objRS.EOF Then
	    strSQLClause2 = strSQLClause2 & " " & strCRITERIO_EVENTO & " "
	  End If
	 Loop
	 strSQLClause2 = strSQLClause2 & ")"
	End If
	FechaRecordSet objRS

   ' Pesquisa os campos de ordenação do resultado
   strSQL = " SELECT * FROM tbl_Lote_Ordem WHERE COD_LOTE = " & strCOD_LOTE & " ORDER BY ORDEM"
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
   strSQLOrdem = strSQLOrdem & " ORDER BY "
     Do While not objRS.EOF
       strSQLOrdem = strSQLOrdem & " " & objRS("CAMPO") & " " & objRS("DIRECAO") & ", "
       objRS.MoveNext
     Loop
     strSQLOrdem = strSQLOrdem & " 1 "
   End If
   FechaRecordSet objRS
 

'   strSQL = " SELECT tbl_Empresas.COD_EMPRESA"
'   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOME"
'   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
'   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
'   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
'   strSQL = strSQL & " ,tbl_Empresas.EMAIL1"
'   strSQL = strSQL & " ,tbl_Empresas.FONE1"
'   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.CODATIV1"
'   strSQL = strSQL & " ,tbl_Empresas.ID_NUM_DOC1"
'   strSQL = strSQL & " ,tbl_Empresas.COD_STATUS_PRECO"
'   strSQL = strSQL & " ,tbl_Empresas.COD_STATUS_CRED"
'   strSQL = strSQL & " FROM tbl_Empresas "
'   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
'   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
'   strSQL = strSQL & strSQLClause
'   strSQL = strSQL & strSQLOrdem
   'response.write strSQL
   'response.end  

'Mauro - 30/03/2007
'Novo SQL incluindo a opção de criterios de pesquisa na tabela "tbl_PAIS"
   strSQL = " SELECT DISTINCT tbl_Empresas.COD_EMPRESA"
   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOME"
   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
   strSQL = strSQL & " ,tbl_Empresas.EMAIL1"
   strSQL = strSQL & " ,tbl_Empresas.FONE1"
   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
   strSQL = strSQL & " ,tbl_Empresas.CODATIV1"
   strSQL = strSQL & " ,tbl_Empresas.ID_NUM_DOC1"
   strSQL = strSQL & " ,tbl_Empresas.COD_STATUS_PRECO"
   strSQL = strSQL & " ,tbl_Empresas.COD_STATUS_CRED"
   strSQL = strSQL & " ,tbl_Pais.IDIOMA"
   strSQL = strSQL & " FROM " & strSQLParenteses & " (tbl_Empresas LEFT OUTER JOIN tbl_PAIS ON (tbl_Empresas.END_PAIS = tbl_PAIS.PAIS) )"
   strSQL = strSQL & strSQLLeftJoin
   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
   strSQL = strSQL & strSQLClause
   strSQL = strSQL & strSQLClause2
   strSQL = strSQL & strSQL_CRITERIO
   strSQL = strSQL & strSQLOrdem
   
  Set objRS = Server.CreateObject("ADODB.Recordset")
  'Response.Write strSQL
  objRS.Open strSQL, objConn 

  Dim strBgColor, i

  i = 0
  Do While Not objRS.EOF
%>
  <tr> 
    <td><%=objRS("COD_EMPRESA")%>&nbsp;</td>
    <td><%=objRS("NOME")%></td>
    <td><%=objRS("END_FULL")%></td>
    <td><%=objRS("END_BAIRRO")%></td>
    <td><%=objRS("END_CIDADE")%></td>
    <td><%=objRS("END_ESTADO")%></td>
    <td><%=objRS("END_CEP")%>&nbsp;</td>
    <td><%=objRS("END_PAIS")%></td>
    <td><%=objRS("EMAIL1")%></td>
    <td><%=objRS("FONE1")%></td>
    <td><%=objRS("ENTIDADE")%></td>
	<td><%=objRS("CODATIV1")%></td>
	<td><%=objRS("ID_NUM_DOC1")%>&nbsp;</td>
	<td><%=objRS("COD_STATUS_CRED")%></td>
	<td><%=objRS("COD_STATUS_PRECO")%></td>
	<td><%=objRS("IDIOMA")%></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
  </tr>
  <%
    strSQL = "SELECT CODBARRA, NOME_COMPLETO, CARGO_NOME, DT_ANIV, ID_CPF, EMAIL FROM tbl_Empresas_Sub WHERE COD_EMPRESA = '" & objRS("COD_EMPRESA") & "' ORDER BY CODBARRA, NOME_COMPLETO"
	Set objRSDetail = objConn.Execute(strSQL)
	Do While not objRSDetail.EOF
	%>
	  <tr> 
		<td><%=objRSDetail("CODBARRA")%></td>
		<td><%=objRSDetail("NOME_COMPLETO")%></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td><%=objRSDetail("NOME_COMPLETO")%></td>
		<td><%=objRSDetail("CARGO_NOME")%></td>
		<td><%=objRSDetail("ID_CPF")%></td>
		<td><%=objRSDetail("DT_ANIV")%></td>
		<td><%=objRSDetail("EMAIL")%></td>
	  </tr>
	<%
	  objRSDetail.MoveNext
	Loop
	FechaRecordSet objRSDetail
	
    i = i + 1
	If i mod 1000 = 0 Then
	   Response.Flush
	End If
    objRS.MoveNext
  Loop

  FechaRecordSet ObjRS
  FechaDBConn ObjConn
%>
</table>
</body>
</html>
<%
 Response.Flush
%>
