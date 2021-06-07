<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<%
 Server.ScriptTimeout = 1200
 
 Dim strCOD_LOTE
	
 strCOD_LOTE = Request("var_chavereg")
 
 Response.Buffer = True
 
 Response.AddHeader "Content-Type","application/x-msdownload"
 Response.AddHeader "Content-Disposition","attachment; filename=rel_" & Session.SessionID & "_" & strCOD_LOTE & ".xls"
 
 Dim objConn, ObjRS, objRSMapeamentoPJ, objRSMapeamentoPF
 Dim strSQL, strSQLClause, strSQLClause2, strSQLLeftJoin, strSQLParenteses, strFLAG_EVENTO, strSQLOrdem, auxstr, MyChecked, cont
 Dim auxTimeInic, auxTimeFim, strCAMPO_ANTERIOR
 Dim strNOME_CAMPO
 
 Dim strCRITERIO_EVENTO, strSQL_CRITERIO, strSQL_INNER, strSQL_INNER_SUB, strSQL_CRITERIO_SUB, strCRITERIO_OPERADOR, strSQL_IGNORAR_CONTATO
 
 Dim  strFONE1, strDDI_FONE1, strDDD_FONE1
 Dim  strFONE2, strDDI_FONE2, strDDD_FONE2
 Dim  strFONE3, strDDI_FONE3, strDDD_FONE3
 Dim  strFONE4, strDDI_FONE4, strDDD_FONE4
 
 Dim strBgColor, i
  
   AbreDBConn objConn, CFG_DB_DADOS 
%>
<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="100%" border="0">
  <tr> 
    <td><b>Codigo</b></td>
    <td><b>Nome</b></td>
    <td><b>Fantasia</b></td>
    <td><b>Endereco</b></td>
    <td><b>Bairro</b></td>
    <td><b>Cidade</b></td>
    <td><b>UF</b></td>
    <td><b>CEP</b></td>
    <td><b>País</b></td>
    <td><b>E-mail</b></td>
    <td><b>E-mail 2</b></td>
    <td><b>DDI 1</b></td>
    <td><b>DDD 1</b></td>
    <td><b>Fone 1</b></td>
    <td><b>DDI 2</b></td>
    <td><b>DDD 2</b></td>
    <td><b>Fone 2</b></td>
    <td><b>DDI 3</b></td>
    <td><b>DDD 3</b></td>
    <td><b>Fone 3</b></td>
    <td><b>DDI 4</b></td>
    <td><b>DDD 4</b></td>
    <td><b>Fone 4</b></td>
    <td><b>Data Nasc</b></td>
    <td><b>Sexo</b></td>
	<td><b>Entidade</b></td>
    <td><b>Entidade Fantasia</b></td>
    <td><b>Entidade Cargo</b></td>
    <td><b>Cod. Atividade</b></td>
	<td><b>Atividade</b></td>
    <td><b>Tipo Pessoa</b></td>
	<td><b>CPF/CNPJ</b></td>
	<td><b>Tipo Credencial</b></td>
	<td><b>Categoria</b></td>
	<td><b>Idioma</b></td>
	<td><b>Site</b></td>
    <td><b>Senha</b></td>
    <%
	strSQL =          " SELECT NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, CAMPO_COMBOLIST, CAMPO_COR_DESTAQUE "
	strSQL = strSQL & "   FROM tbl_MAPEAMENTO_CAMPO WHERE COD_EVENTO = " & Session("COD_EVENTO")
	strSQL = strSQL & "                             AND (TIPO = 'PJ' or TIPO IS NULL)"
	Set objRSMapeamentoPJ = objConn.Execute(strSQL)
	If not objRSMapeamentoPJ.EOF Then
	  Do While not objRSMapeamentoPJ.EOF
	%>
    <td><b><%=objRSMapeamentoPJ("NOME_DESCRITIVO")%></b></td>
    <%
	    objRSMapeamentoPJ.MoveNext
	  Loop
	  objRSMapeamentoPJ.MoveFirst
	End If
	%>
    <td><b>Codigo Barras </b></td>
    <td><b>Contato CPF</b></td>
    <td><b>Contato Nome</b></td>
    <td><b>Contato E-mail</b></td>
	<td><b>Contato Cargo</b></td>
	<td><b>Contato Data Nascimento </b></td>
    <%
	strSQL =          " SELECT NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, CAMPO_COMBOLIST, CAMPO_COR_DESTAQUE "
	strSQL = strSQL & "   FROM tbl_MAPEAMENTO_CAMPO WHERE COD_EVENTO = " & Session("COD_EVENTO")
	strSQL = strSQL & "                             AND (TIPO = 'PF' or TIPO IS NULL)"
	Set objRSMapeamentoPF = objConn.Execute(strSQL)
	If not objRSMapeamentoPF.EOF Then
	  Do While not objRSMapeamentoPF.EOF
	%>
    <td><b><%=objRSMapeamentoPF("NOME_DESCRITIVO")%></b></td>
    <%
	    objRSMapeamentoPF.MoveNext
	  Loop
	  objRSMapeamentoPF.MoveFirst
	End If
	%>
    <td><b>Data Cadastro</b></td>
    <td><b>Usuario Cadastro</b></td>
    <td><b>Referencia</b></td>	
	<td><b>Nro Eventos</b></td>
    <td><b>Ultimo Evento</b></td>	
    <td><b>Scramble</b></td>
  </tr>
  <%
' if strVAR <> "" then
   
   strSQL_CRITERIO = ""
   strSQL_INNER = ""
   
   strSQL = " SELECT NUM_CRED_PJ, NOMINAL, CRITERIO_EVENTO, SQL_CRITERIO, SQL_INNER, SQL_INNER_SUB, SQL_CRITERIO_SUB, IGNORAR_CONTATO FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
     strCRITERIO_EVENTO = objRS("CRITERIO_EVENTO")&""
	 strSQL_CRITERIO = objRS("SQL_CRITERIO")&""
	 strSQL_INNER = objRS("SQL_INNER")&""
	 strSQL_INNER_SUB = objRS("SQL_INNER_SUB")&""
	 strSQL_CRITERIO_SUB = objRS("SQL_CRITERIO_SUB")&""
	 strSQL_IGNORAR_CONTATO = objRS("IGNORAR_CONTATO")&""
   End If
   FechaRecordSet objRS
   
   If strCRITERIO_EVENTO = "" Then
     strCRITERIO_EVENTO = "AND"
   End If
   
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
	   strCRITERIO_OPERADOR = objRS("OPERADOR")&""
	   If strCRITERIO_OPERADOR = "" Then
	     strCRITERIO_OPERADOR = "OR"
	   End If
       strSQLClause = strSQLClause & " "&strCRITERIO_OPERADOR&" "
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
 
   If strSQLOrdem = "" Then
     strSQLOrdem = " ORDER BY tbl_Empresas.COD_EMPRESA"
   End If


   strSQL = " SELECT tbl_Empresas.COD_EMPRESA"
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_empresas.codbarra,tbl_empresas_sub.codbarra) as CODBARRA"
   strSQL = strSQL & ", tbl_Empresas.NOMECLI AS NOME"
   strSQL = strSQL & ", tbl_Empresas.NOMEFAN"
   strSQL = strSQL & ", tbl_Empresas.END_FULL"
   strSQL = strSQL & ", tbl_Empresas.END_BAIRRO"
   strSQL = strSQL & ", tbl_Empresas.END_CIDADE"
   strSQL = strSQL & ", tbl_Empresas.END_ESTADO"
   strSQL = strSQL & ", tbl_Empresas.END_CEP"
   strSQL = strSQL & ", tbl_Empresas.END_PAIS"
   strSQL = strSQL & ", tbl_Empresas.EMAIL1"
   strSQL = strSQL & ", tbl_Empresas.EMAIL2"
   strSQL = strSQL & ", tbl_Empresas.FONE1"
   strSQL = strSQL & ", tbl_Empresas.FONE2"
   strSQL = strSQL & ", tbl_Empresas.FONE3"
   strSQL = strSQL & ", tbl_Empresas.FONE4"
   strSQL = strSQL & ", tbl_Empresas.ENTIDADE"
   strSQL = strSQL & ", tbl_Empresas.ENTIDADE_FANTASIA"
   strSQL = strSQL & ", tbl_Empresas.ENTIDADE_CARGO"
   strSQL = strSQL & ", tbl_Empresas.CODATIV1"
   strSQL = strSQL & ", tbl_Empresas.ID_NUM_DOC1"
   strSQL = strSQL & ", tbl_Status_Preco.STATUS as CATEGORIA"
   strSQL = strSQL & ", tbl_Status_Cred.STATUS as CREDENCIAL"
   strSQL = strSQL & ", tbl_Empresas.HOMEPAGE"
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_Empresas.SYS_DATACA, tbl_Empresas_Sub.SYS_DATACA) as SYS_DATACA"
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_Empresas.SYS_USERCA, tbl_Empresas_Sub.SYS_USERCA) as SYS_USERCA"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_1"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_2"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_3"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_4"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_5"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_6"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_7"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_8"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_9"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_10"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_NUM_1"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_NUM_2"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_NUM_3"
   strSQL = strSQL & ", tbl_Empresas.DT_NASC"
   strSQL = strSQL & ", tbl_Empresas.SEXO"
   strSQL = strSQL & ", tbl_Empresas.SENHA"
   strSQL = strSQL & ", tbl_Empresas.TIPO_PESS"
   strSQL = strSQL & ", tbl_Pais.IDIOMA"
   strSQL = strSQL & ", tbl_Atividade.ATIVIDADE"
   strSQL = strSQL & ", tbl_Empresas_Sub.ID_CPF"
   strSQL = strSQL & ", tbl_Empresas_Sub.NOME_COMPLETO"
   strSQL = strSQL & ", tbl_Empresas_Sub.CARGO_NOME"
   strSQL = strSQL & ", tbl_Empresas_Sub.DT_NASC"
   strSQL = strSQL & ", tbl_Empresas_Sub.EMAIL"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_1 as CONTATO_EXTRA_TXT_1"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_2 as CONTATO_EXTRA_TXT_2"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_3 as CONTATO_EXTRA_TXT_3"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_4 as CONTATO_EXTRA_TXT_4"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_5 as CONTATO_EXTRA_TXT_5"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_6 as CONTATO_EXTRA_TXT_6"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_7 as CONTATO_EXTRA_TXT_7"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_8 as CONTATO_EXTRA_TXT_8"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_9 as CONTATO_EXTRA_TXT_9"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_TXT_10 as CONTATO_EXTRA_TXT_10"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_NUM_1 as CONTATO_EXTRA_NUM_1"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_NUM_2 as CONTATO_EXTRA_NUM_2"
   strSQL = strSQL & ", tbl_Empresas_Sub.EXTRA_NUM_3 as CONTATO_EXTRA_NUM_3"
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_Empresas.NRO_EVENTOS_VISITADOS,  tbl_Empresas_sub.NRO_EVENTOS_VISITADOS) as NRO_EVENTOS_VISITADOS "
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_Empresas.REFERENCIA,  tbl_Empresas_sub.REFERENCIA) as REFERENCIA "
   strSQL = strSQL & ", max(v.COD_EVENTO) as MAX_COD_EVENTO "
   strSQL = strSQL & " FROM " & strSQLParenteses & " ("
   strSQL = strSQL & "  tbl_Empresas LEFT JOIN tbl_Empresas_Sub ON tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA"
   If strSQL_IGNORAR_CONTATO&"" = "1" Then
      strSQL = strSQL & " AND tbl_Empresas_Sub.CODBARRA IS NULL"
   End If
   strSQL = strSQL & "       LEFT JOIN tbl_Pais ON tbl_Empresas.END_PAIS = tbl_Pais.PAIS"
   strSQL = strSQL & "       LEFT JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
   strSQL = strSQL & "       LEFT JOIN tbl_Status_Cred ON if(tbl_Empresas_Sub.COD_STATUS_CRED is null,tbl_Empresas.COD_STATUS_CRED,tbl_Empresas_Sub.COD_STATUS_CRED) = tbl_Status_Cred.COD_STATUS_CRED "
   strSQL = strSQL & "       LEFT JOIN tbl_Status_Preco ON tbl_Empresas.COD_STATUS_PRECO = tbl_Status_Preco.COD_STATUS_PRECO "
   strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON if(tbl_empresas_sub.codbarra is null,tbl_empresas.codbarra,tbl_empresas_sub.codbarra) = v.codbarra )"
   strSQL = strSQL & " " & strSQLLeftJoin
   strSQL = strSQL & " " & strSQL_INNER
   strSQL = strSQL & " " & strSQL_INNER_SUB
   strSQL = strSQL & " WHERE  ( tbl_Empresas.SYS_INATIVO IS NULL "
   strSQL = strSQL & " " & strSQLClause
   strSQL = strSQL & " " & strSQLClause2
   strSQL = strSQL & " " & strSQL_CRITERIO
   strSQL = strSQL & " " & strSQL_CRITERIO_SUB
   strSQL = strSQL & " GROUP BY 1,2 "
   strSQL = strSQL & strSQLOrdem



  'Response.Write strSQL
  'Response.End()
   
  Set objRS = Server.CreateObject("ADODB.Recordset")
  objRS.Open strSQL, objConn 

  

  i = 0
  Do While Not objRS.EOF
  

    
  strFONE1     = objRS("FONE1")&""
	  If InStr(strFONE1," ") > 0 Then
	  
	    strDDD_FONE1 = Trim(Left(strFONE1,InStr(strFONE1," ")))
		strFONE1 = Trim(Right(strFONE1,Len(strFONE1)-InStr(strFONE1," ")))
		If InStr(strFONE1," ") > 0 Then
	      strDDI_FONE1 = strDDD_FONE1
		  strDDD_FONE1 = Trim(Left(strFONE1,InStr(strFONE1," ")))
		  strFONE1 = Trim(Right(strFONE1,Len(strFONE1)-InStr(strFONE1," ")))
		ElseIf InStr(strDDD_FONE1,"-") > 0 Then
	      strDDI_FONE1 = Trim(Left(strDDD_FONE1,InStr(strDDD_FONE1,"-")-1))
		  strDDD_FONE1 = Trim(Right(strDDD_FONE1,Len(strDDD_FONE1)-InStr(strDDD_FONE1,"-")))
		ElseIf InStr(strDDD_FONE1,")") > 0 Then
	      strDDI_FONE1 = Trim(Left(strDDD_FONE1,InStr(strDDD_FONE1,")")-1))
		  strDDD_FONE1 = Trim(Right(strDDD_FONE1,Len(strDDD_FONE1)-InStr(strDDD_FONE1,")")))
		ElseIf InStr(strDDD_FONE1,"(") > 0 Then
	      strDDI_FONE1 = Trim(Left(strDDD_FONE1,InStr(strDDD_FONE1,"(")-1))
		  strDDD_FONE1 = Trim(Right(strDDD_FONE1,Len(strDDD_FONE1)-InStr(strDDD_FONE1,"(")))
		End If

	  End If
	  
	  strFONE2     = objRS("FONE2")&""
	  If InStr(strFONE2," ") > 0 Then
	  
	    strDDD_FONE2 = Trim(Left(strFONE2,InStr(strFONE2," ")))
		strFONE2 = Trim(Right(strFONE2,Len(strFONE2)-InStr(strFONE2," ")))
		If InStr(strFONE2," ") > 0 Then
	      strDDI_FONE2 = strDDD_FONE2
		  strDDD_FONE2 = Trim(Left(strFONE2,InStr(strFONE2," ")))
		  strFONE2 = Trim(Right(strFONE2,Len(strFONE2)-InStr(strFONE2," ")))
		ElseIf InStr(strDDD_FONE2,"-") > 0 Then
	      strDDI_FONE2 = Trim(Left(strDDD_FONE2,InStr(strDDD_FONE2,"-")-1))
		  strDDD_FONE2 = Trim(Right(strDDD_FONE2,Len(strDDD_FONE2)-InStr(strDDD_FONE2,"-")))
		ElseIf InStr(strDDD_FONE2,")") > 0 Then
	      strDDI_FONE2 = Trim(Left(strDDD_FONE2,InStr(strDDD_FONE2,")")-1))
		  strDDD_FONE2 = Trim(Right(strDDD_FONE2,Len(strDDD_FONE2)-InStr(strDDD_FONE2,")")))
		ElseIf InStr(strDDD_FONE2,"(") > 0 Then
	      strDDI_FONE2 = Trim(Left(strDDD_FONE1,InStr(strDDD_FONE2,"(")-1))
		  strDDD_FONE2 = Trim(Right(strDDD_FONE1,Len(strDDD_FONE2)-InStr(strDDD_FONE2,"(")))
		End If		

	  End If
	  
	  strFONE3     = objRS("FONE3")&""
	  If InStr(strFONE3," ") > 0 Then
	  
	    strDDD_FONE3 = Trim(Left(strFONE3,InStr(strFONE3," ")))
		strFONE3 = Trim(Right(strFONE3,Len(strFONE3)-InStr(strFONE3," ")))
		If InStr(strFONE3," ") > 0 Then
	      strDDI_FONE3 = strDDD_FONE3
		  strDDD_FONE3 = Trim(Left(strFONE3,InStr(strFONE3," ")))
		  strFONE3 = Trim(Right(strFONE3,Len(strFONE3)-InStr(strFONE3," ")))
		ElseIf InStr(strDDD_FONE3,"-") > 0 Then
	      strDDI_FONE3 = Trim(Left(strDDD_FONE3,InStr(strDDD_FONE3,"-")-1))
		  strDDD_FONE3 = Trim(Right(strDDD_FONE3,Len(strDDD_FONE3)-InStr(strDDD_FONE3,"-")))
		ElseIf InStr(strDDD_FONE3,")") > 0 Then
	      strDDI_FONE3 = Trim(Left(strDDD_FONE3,InStr(strDDD_FONE3,")")-1))
		  strDDD_FONE3 = Trim(Right(strDDD_FONE3,Len(strDDD_FONE3)-InStr(strDDD_FONE3,")")))
		ElseIf InStr(strDDD_FONE3,"(") > 0 Then
	      strDDI_FONE3 = Trim(Left(strDDD_FONE3,InStr(strDDD_FONE3,"(")-1))
		  strDDD_FONE3 = Trim(Right(strDDD_FONE3,Len(strDDD_FONE3)-InStr(strDDD_FONE3,"(")))
		End If

	  End If
	  
	  strFONE4     = objRS("FONE4")&""
	  If InStr(strFONE4," ") > 0 Then
	  
	    strDDD_FONE4 = Trim(Left(strFONE4,InStr(strFONE4," ")))
		strFONE4 = Trim(Right(strFONE4,Len(strFONE4)-InStr(strFONE4," ")))
		If InStr(strFONE4," ") > 0 Then
	      strDDI_FONE4 = strDDD_FONE4
		  strDDD_FONE4 = Trim(Left(strFONE4,InStr(strFONE4," ")))
		  strFONE4 = Trim(Right(strFONE4,Len(strFONE4)-InStr(strFONE4," ")))
		ElseIf InStr(strDDD_FONE4,"-") > 0 Then
	      strDDI_FONE4 = Trim(Left(strDDD_FONE4,InStr(strDDD_FONE4,"-")-1))
		  strDDD_FONE4 = Trim(Right(strDDD_FONE4,Len(strDDD_FONE4)-InStr(strDDD_FONE4,"-")))
		ElseIf InStr(strDDD_FONE4,")") > 0 Then
	      strDDI_FONE4 = Trim(Left(strDDD_FONE4,InStr(strDDD_FONE4,")")-1))
		  strDDD_FONE4 = Trim(Right(strDDD_FONE4,Len(strDDD_FONE4)-InStr(strDDD_FONE4,")")))
		ElseIf InStr(strDDD_FONE4,"(") > 0 Then
	      strDDI_FONE4 = Trim(Left(strDDD_FONE4,InStr(strDDD_FONE4,"(")-1))
		  strDDD_FONE4 = Trim(Right(strDDD_FONE4,Len(strDDD_FONE4)-InStr(strDDD_FONE4,"(")))
		End If

	  End If
  
  
  
  
%>
  <tr> 
    <td><%=objRS("COD_EMPRESA")%>&nbsp;</td>
    <td><%=objRS("NOME")%></td>
    <td><%=objRS("NOMEFAN")%></td>
    <td><%=objRS("END_FULL")%></td>
    <td><%=objRS("END_BAIRRO")%></td>
    <td><%=objRS("END_CIDADE")%></td>
    <td><%=objRS("END_ESTADO")%></td>
    <td><%=objRS("END_CEP")%>&nbsp;</td>
    <td><%=objRS("END_PAIS")%></td>
    <td><%=objRS("EMAIL1")%></td>
    <td><%=objRS("EMAIL2")%></td>
    <td><%=strDDI_FONE4%></td>
    <td><%=strDDD_FONE4%></td>
    <td><%=strFONE4%></td>
    <td><%=strDDI_FONE1%></td>
    <td><%=strDDD_FONE1%></td>
    <td><%=strFONE1%></td>
    <td><%=strDDI_FONE3%></td>
    <td><%=strDDD_FONE3%></td>
    <td><%=strFONE3%></td>
    <td><%=strDDI_FONE2%></td>
    <td><%=strDDD_FONE2%></td>
    <td><%=strFONE2%></td>
    <td><%=PrepData(objRS("DT_NASC"),True,True)%></td>
    <td><%=UCase(objRS("SEXO")&"")%></td>
    <td><%=objRS("ENTIDADE")%></td>
    <td><%=objRS("ENTIDADE_FANTASIA")%></td>
    <td><%=objRS("ENTIDADE_CARGO")%></td>
	<td><%=objRS("CODATIV1")%></td>
	<td><%=objRS("ATIVIDADE")%></td>
    <td><%=objRS("TIPO_PESS")%></td>
	<td><%=objRS("ID_NUM_DOC1")%>&nbsp;</td>
	<td><%=objRS("CREDENCIAL")%></td>
	<td><%=objRS("CATEGORIA")%></td>
	<td><%=objRS("IDIOMA")%></td>
	<td><%=objRS("HOMEPAGE")%></td>
    <td><%=objRS("SENHA")%></td>
    <%
	If not objRSMapeamentoPJ.EOF Then
	  Do While not objRSMapeamentoPJ.EOF
	    strNOME_CAMPO = objRSMapeamentoPJ("NOME_CAMPO_PROEVENTO")&""
	%>
    <td><%=objRS(strNOME_CAMPO)%></td>
    <%
	    objRSMapeamentoPJ.MoveNext
	  Loop
	  objRSMapeamentoPJ.MoveFirst
	End If
	%>
    <td><%=objRS("CODBARRA")%></td>
    <td><%=objRS("ID_CPF")%></td>
    <td><%=objRS("NOME_COMPLETO")%></td>
    <td><%=objRS("EMAIL")%></td>
	<td><%=objRS("CARGO_NOME")%></td>
	<td><%=objRS("DT_NASC")%></td>
    <%
	If not objRSMapeamentoPF.EOF Then
	  Do While not objRSMapeamentoPF.EOF
	    strNOME_CAMPO = objRSMapeamentoPF("NOME_CAMPO_PROEVENTO")&""
	%>
    <td><%=objRS("CONTATO_"&strNOME_CAMPO)%></td>
    <%
	    objRSMapeamentoPF.MoveNext
	  Loop
	  objRSMapeamentoPF.MoveFirst
	End If
	%>
	<td><%=PrepData(objRS("SYS_DATACA"),True,True)%></td>
	<td><%=objRS("SYS_USERCA")%></td>
    <td><%=objRS("REFERENCIA")%></td>
    <td><%=objRS("NRO_EVENTOS_VISITADOS")%></td>
    <td><%=objRS("MAX_COD_EVENTO")%></td>
    <td><%=ScrambleNum(objRS("CODBARRA"))%>&nbsp;</td>
  </tr>
  <%
    i = i + 1
	If i mod 100 = 0 Then
	   Response.Flush
	End If
    objRS.MoveNext
  Loop
  
  FechaRecordSet ObjRS


  FechaRecordSet objRSMapeamentoPJ
  FechaRecordSet objRSMapeamentoPF

  FechaDBConn ObjConn
%>
</table>
</body>
</html>
<%
 Response.Flush
%>
