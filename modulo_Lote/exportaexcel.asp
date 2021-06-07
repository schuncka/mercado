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
 
 
 Dim objConn, objRS, objRSEvento, objRSMapeamentoPJ, objRSMapeamentoPF
 Dim strSQL, strSQLClause, strSQLClause2, strSQLLeftJoin, strSQLParenteses, strFLAG_EVENTO, strSQLOrdem, auxstr, MyChecked, cont
 Dim strSQLVisitacao
 Dim auxTimeInic, auxTimeFim, strCAMPO_ANTERIOR
 Dim strNOME_CAMPO
 
 Dim strCRITERIO_EVENTO, strSQL_CRITERIO, strSQL_INNER, strSQL_INNER_SUB, strSQL_CRITERIO_SUB
 Dim strCAMPO, strCRITERIO, strCRITERIO_OPERADOR, strVALOR
 Dim strSQL_IGNORAR_CONTATO, strSQL_CADASTRO_COM_FOTO
 
 Dim  strFONE1, strDDI_FONE1, strDDD_FONE1
 Dim  strFONE2, strDDI_FONE2, strDDD_FONE2
 Dim  strFONE3, strDDI_FONE3, strDDD_FONE3
 Dim  strFONE4, strDDI_FONE4, strDDD_FONE4
 Dim strNomeArquivoLote
 Dim flagSEPARAR_DDI_DDD
 Dim strBgColor, i 
 Dim strEVENTO_VISITACAO
 
 flagSEPARAR_DDI_DDD = True

 If ucase(CFG_IDEMPRESA) = "HP" or ucase(CFG_IDEMPRESA) = "SP" or ucase(CFG_IDEMPRESA) = "CM" Then
   flagSEPARAR_DDI_DDD = False
 End If


  
 AbreDBConn objConn, CFG_DB_DADOS 
 
   
   strEVENTO_VISITACAO = "0"
   
   strSQL_CRITERIO = ""
   strSQL_INNER = ""
   
   strSQL = " SELECT NUM_CRED_PJ,NOME, NOMINAL, CRITERIO_EVENTO, SQL_CRITERIO, SQL_INNER, SQL_INNER_SUB, SQL_CRITERIO_SUB, IGNORAR_CONTATO, CADASTRO_COM_FOTO FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
     strCRITERIO_EVENTO = objRS("CRITERIO_EVENTO")&""
	 strSQL_CRITERIO = objRS("SQL_CRITERIO")&""
	 strSQL_INNER = objRS("SQL_INNER")&""
	 strSQL_INNER_SUB = objRS("SQL_INNER_SUB")&""
	 strSQL_CRITERIO_SUB = objRS("SQL_CRITERIO_SUB")&""
	 strSQL_IGNORAR_CONTATO = objRS("IGNORAR_CONTATO")&""
	 strNomeArquivoLote = objRS("NOME")&""
	 strSQL_CADASTRO_COM_FOTO = objRS("CADASTRO_COM_FOTO")&""
   End If
   FechaRecordSet objRS
   
   'Colocado o header para excel nesse ponto, pois aqui temos o nome do relatorio
    Response.AddHeader "Content-Type","application/x-msdownload"
 	Response.AddHeader "Content-Disposition","attachment; filename=" & LimpaNomeArquivo(ucase(strNomeArquivoLote)) & "_" & Session.SessionID & "_" & strCOD_LOTE & ".xls"
   
   
   If strCRITERIO_EVENTO = "" Then
     strCRITERIO_EVENTO = "AND"
   End If
   
   ' Montagem dos campos de critério da pesquisa
   strCAMPO_ANTERIOR = ""
   strSQL = " SELECT * FROM tbl_Lote_Criterio WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   Do While not objRS.EOF

     strCAMPO = objRS("CAMPO")&""
   
     'Testa para montar clausula do mesmo tipo de campo com OR dentro de parenteses  
	 ' AND (CAMPO1 = 1 or CAMPO1 = 2)
	 'Se o campo for diferente do anterior entao coloca AND fechando o parantese anterior
	 
     If strCAMPO_ANTERIOR <> strCAMPO Then
	 
	   strCAMPO_ANTERIOR = strCAMPO
       strSQLClause = strSQLClause & ") AND ("
	   strSQLClause = strSQLClause & strCAMPO & " "
	   
	 Else
	 
	   strCRITERIO_OPERADOR = objRS("OPERADOR")&""
	   If strCRITERIO_OPERADOR = "" Then
	     strCRITERIO_OPERADOR = "OR"
	   End If
       strSQLClause = strSQLClause & " "&strCRITERIO_OPERADOR&" "
	   strSQLClause = strSQLClause & strCAMPO & " "
	 
	 End If	   

	 strCRITERIO = objRS("CRITERIO")&""
	 strVALOR = Replace(objRS("VALOR")&"","'","''")
	 'Forçando para ver se o campo é do tipo DATA pelo nome literal do campo no banco
	 'Ideal é usar função que pega o tipo de dado do banco
	 If InStr(strCAMPO,"SYS_DATA") > 0 Then
	   strVALOR = PrepDataIve(strVALOR,False,True)
	 End If

	   
	 Select Case strCRITERIO
	     Case "IN"
		   strSQLClause = strSQLClause & strCRITERIO & " ('" & Replace(Replace(strVALOR,"'","''"),",","','") & "') "
		 Case "LIKE","LIKE_CONTEM"
		   strSQLClause = strSQLClause & " LIKE '%" & Replace(Replace(strVALOR,"'","''"),",","','") & "%' "
		 Case "LIKE_COMECA"
		   strSQLClause = strSQLClause & " LIKE '" & Replace(Replace(strVALOR,"'","''"),",","','") & "%'"
		 Case Else
		   strSQLClause = strSQLClause & strCRITERIO & " '" & strVALOR & "' "
	 End Select
	
	 'Se incluir o criterio de pesquisa na visitação do evento então insere as colunas de visitação do(s) evento(s) passador por parametro 
	 If strCAMPO = "v.COD_EVENTO" and strVALOR <> "" Then  
	   strEVENTO_VISITACAO = strEVENTO_VISITACAO&","&strVALOR
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

%>
<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="100%" border="0">
  <tr> 
    <td><strong>Codigo</strong></td>
    <td><strong>Nome</strong></td>
    <td><strong>Fantasia</strong></td>
    <td><strong>Endereco</strong></td>
    <td><strong>Bairro</strong></td>
    <td><strong>Cidade</strong></td>
    <td><strong>UF</strong></td>
    <td><strong>CEP</strong></td>
    <td><strong>País</strong></td>
    <td><strong>E-mail</strong></td>
    <td><strong>E-mail 2</strong></td>
    <td><strong>DDI 1</strong></td>
    <td><strong>DDD 1</strong></td>
    <td><strong>Fone 1</strong></td>
    <td><strong>DDI 2</strong></td>
    <td><strong>DDD 2</strong></td>
    <td><strong>Fone 2</strong></td>
    <td><strong>DDI 3</strong></td>
    <td><strong>DDD 3</strong></td>
    <td><strong>Fone 3</strong></td>
    <td><strong>DDI 4</strong></td>
    <td><strong>DDD 4</strong></td>
    <td><strong>Fone 4</strong></td>
    <td><strong>Data Nasc</strong></td>
    <td><strong>Sexo</strong></td>
	<td><strong>Entidade</strong></td>
    <td><strong>Entidade Fantasia</strong></td>
    <td><strong>Entidade Cargo</strong></td>
    <td><strong>Cod. Atividade</strong></td>
	<td><strong>Atividade</strong></td>
    <td><strong>Tipo Pessoa</strong></td>
	<td><strong>CPF/CNPJ</strong></td>
	<td><strong>Tipo Credencial</strong></td>
	<td><strong>Categoria</strong></td>
	<td><strong>Idioma</strong></td>
	<td><strong>Site</strong></td>
    <td><strong>Senha</strong></td>
    <%
	strSQL =          " SELECT NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, CAMPO_COMBOLIST, CAMPO_COR_DESTAQUE "
	strSQL = strSQL & "   FROM tbl_MAPEAMENTO_CAMPO WHERE COD_EVENTO = " & Session("COD_EVENTO")
	strSQL = strSQL & "                             AND (TIPO = 'PJ' or TIPO IS NULL)"
	Set objRSMapeamentoPJ = objConn.Execute(strSQL)
	If not objRSMapeamentoPJ.EOF Then
	  Do While not objRSMapeamentoPJ.EOF
	%>
    <td><strong><%=objRSMapeamentoPJ("NOME_DESCRITIVO")%></strong></td>
    <%
	    objRSMapeamentoPJ.MoveNext
	  Loop
	  objRSMapeamentoPJ.MoveFirst
	End If
	%>
    <td><strong>Data Cadastro</strong></td>
    <td><strong>Data Ult.Alteraç.</strong></td>    
    <td><strong>Usuario Cadastro</strong></td>
    <td><strong>Codigo Barras</strong></td>
    <td><strong>Contato CPF</strong></td>
    <td><strong>Contato Nome</strong></td>
    <td><strong>Contato E-mail</strong></td>
	<td><strong>Contato Cargo</strong></td>
	<td><strong>Contato Data Nascimento</strong></td>
    <%
	strSQL =          " SELECT NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, CAMPO_COMBOLIST, CAMPO_COR_DESTAQUE "
	strSQL = strSQL & "   FROM tbl_MAPEAMENTO_CAMPO WHERE COD_EVENTO = " & Session("COD_EVENTO")
	strSQL = strSQL & "                             AND (TIPO = 'PF' or TIPO IS NULL)"
	Set objRSMapeamentoPF = objConn.Execute(strSQL)
	If not objRSMapeamentoPF.EOF Then
	  Do While not objRSMapeamentoPF.EOF
	%>
    <td><b>Contato - <%=objRSMapeamentoPF("NOME_DESCRITIVO")%></b></td>
    <%
	    objRSMapeamentoPF.MoveNext
	  Loop
	  objRSMapeamentoPF.MoveFirst
	End If
	%>
    <td><strong>Contato - Data Cadastro</strong></td>
    <td><strong>Contato - Usuario Cadastro</strong></td>
    <td><strong>Referencia</strong></td>	
	<td><strong>Nro Eventos</strong></td>
    <td><strong>Ultimo Evento</strong></td>	
    <td><strong>Scramble</strong></td>
    <td><strong>Data Cred</strong></td>
    <td><strong>Foto</strong></td>
    <td><strong>Foto Contato</strong></td>
    <%
	strSQL = "SELECT COD_EVENTO, NOME FROM TBL_EVENTO WHERE COD_EVENTO IN ("&strEVENTO_VISITACAO&") ORDER BY DT_INICIO"
	Set objRSEvento = objConn.Execute(strSQL)
	If not objRSEvento.EOF Then
	  Do While not objRSEvento.EOF
	%>
    <td><b><%=objRSEvento("NOME")%></b></td>
    <%
		objRSEvento.MoveNext
	  Loop
	  objRSEvento.MoveFirst
	End If
	%>
  </tr>
  <%
' if strVAR <> "" then


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
   strSQL = strSQL & ", tbl_Empresas.SYS_DATACA"
   strSQL = strSQL & ", tbl_Empresas.SYS_DATAAT"   
   strSQL = strSQL & ", tbl_Empresas.SYS_USERCA"
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
   strSQL = strSQL & ", if(tbl_Empresas_SUB.DT_NASC IS NULL , tbl_Empresas.DT_NASC , tbl_Empresas_SUB.DT_NASC ) AS DT_NASC"
   strSQL = strSQL & ", tbl_Empresas.SEXO"
   strSQL = strSQL & ", tbl_Empresas.SENHA"
   strSQL = strSQL & ", tbl_Empresas.TIPO_PESS"
   strSQL = strSQL & ", tbl_Empresas.SYS_DATACRED"
   strSQL = strSQL & ", tbl_Empresas.IMG_FOTO AS FOTO"
   strSQL = strSQL & ", tbl_Empresas_sub.IMG_FOTO AS FOTO_CONTATO"
   strSQL = strSQL & ", tbl_Pais.IDIOMA"
   strSQL = strSQL & ", tbl_Atividade.ATIVIDADE"
   strSQL = strSQL & ", tbl_Empresas_Sub.ID_CPF"
   strSQL = strSQL & ", tbl_Empresas_Sub.NOME_COMPLETO"
   strSQL = strSQL & ", tbl_Empresas_Sub.CARGO_NOME"
'   strSQL = strSQL & ", tbl_Empresas_Sub.DT_NASC"
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
   strSQL = strSQL & ", tbl_Empresas_Sub.SYS_DATACA as CONTATO_SYS_DATACA"
   strSQL = strSQL & ", tbl_Empresas_Sub.SYS_USERCA as CONTATO_SYS_USERCA"
   strSQL = strSQL & ", tbl_Empresas_Sub.EMAIL"
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_Empresas.NRO_EVENTOS_VISITADOS,  tbl_Empresas_sub.NRO_EVENTOS_VISITADOS) as NRO_EVENTOS_VISITADOS "
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_Empresas.REFERENCIA,  tbl_Empresas_sub.REFERENCIA) as REFERENCIA "
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_Empresas.ULTIMO_COD_EVENTO,  tbl_Empresas_sub.ULTIMO_COD_EVENTO) as ULTIMO_COD_EVENTO "
   'Se tem criterio de pesquisa por evento entao inclui as colunas
   If not objRSEvento.EOF Then
	  Do While not objRSEvento.EOF
	    strSQL = strSQL & ", max(if(v.cod_evento = "&objRSEvento("COD_EVENTO")& ",'X',NULL)) as '"&objRSEvento("COD_EVENTO")&"'"
	    objRSEvento.MoveNext
	  Loop
	  objRSEvento.MoveFirst
   End If
   strSQL = strSQL & " FROM " & strSQLParenteses & " ("
   strSQL = strSQL & "  tbl_Empresas LEFT JOIN tbl_Empresas_Sub ON tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA"
   If strSQL_IGNORAR_CONTATO&"" = "1" Then
      strSQL = strSQL & " AND tbl_Empresas_Sub.CODBARRA IS NULL"
   End If
   strSQL = strSQL & "       LEFT JOIN tbl_Pais ON tbl_Empresas.END_PAIS = tbl_Pais.PAIS"
   strSQL = strSQL & "       LEFT JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
   strSQL = strSQL & "       LEFT JOIN tbl_Status_Cred ON if(tbl_Empresas_Sub.COD_STATUS_CRED is null,tbl_Empresas.COD_STATUS_CRED,tbl_Empresas_Sub.COD_STATUS_CRED) = tbl_Status_Cred.COD_STATUS_CRED "
   strSQL = strSQL & "       LEFT JOIN tbl_Status_Preco ON tbl_Empresas.COD_STATUS_PRECO = tbl_Status_Preco.COD_STATUS_PRECO "
   If strSQL_IGNORAR_CONTATO&"" = "1" Then
     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON tbl_empresas.cod_empresa = v.cod_empresa )"
   Else
     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON if(tbl_empresas_sub.codbarra is null,tbl_empresas.codbarra,tbl_empresas_sub.codbarra) = v.codbarra )"
   End If
   strSQL = strSQL & " " & strSQLLeftJoin
   strSQL = strSQL & " " & strSQL_INNER
   strSQL = strSQL & " " & strSQL_INNER_SUB
   strSQL = strSQL & " WHERE  ( tbl_Empresas.SYS_INATIVO IS NULL "
   strSQL = strSQL & " " & strSQLClause
   strSQL = strSQL & " " & strSQLClause2
   strSQL = strSQL & " " & strSQL_CRITERIO
   strSQL = strSQL & " " & strSQL_CRITERIO_SUB
   If strSQL_CADASTRO_COM_FOTO&"" = "1" Then
	      strSQL = strSQL & " AND if(tbl_Empresas_Sub.CODBARRA is null,tbl_Empresas.IMG_FOTO,tbl_Empresas_Sub.IMG_FOTO) IS NULL"
   End If
   strSQL = strSQL & " GROUP BY 1,2 "
   strSQL = strSQL & strSQLOrdem

   On Error Resume Next
	Set objRS = Server.CreateObject("ADODB.Recordset")
	objRS.Open strSQL, objConn 
   If Err.Number = 0 Then
	WScript.Echo "It worked!"
   Else
    WScript.Echo "Error:"
    WScript.Echo Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description
    Err.Clear
    Response.Write ("ERROR: [Executar SQL]<br><br>")
    Response.Write (strSQL)
    Response.Write ("<hr>")
	Response.End()
   End If

  i = 0
  Do While Not objRS.EOF
  

    
          strDDI_FONE1 = ""
          strDDD_FONE1 = ""
	  strFONE1     = trim(objRS("FONE1")&"")
	  If InStr(strFONE1," ") > 0 and flagSEPARAR_DDI_DDD Then
	  
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
	  
          strDDI_FONE2 = ""
          strDDD_FONE2 = ""
	  strFONE2     = trim(objRS("FONE2")&"")
	  If InStr(strFONE2," ") > 0 and flagSEPARAR_DDI_DDD Then
	  
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
	  
          strDDI_FONE3 = ""
          strDDD_FONE3 = ""
	  strFONE3     = trim(objRS("FONE3")&"")
	  If InStr(strFONE3," ") > 0 and flagSEPARAR_DDI_DDD Then
	  
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
	  
          strDDI_FONE4 = ""
          strDDD_FONE4 = ""
	  strFONE4     = trim(objRS("FONE4")&"")
	  If InStr(strFONE4," ") > 0 and flagSEPARAR_DDI_DDD Then
	  
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
    <td><%=PrepData(objRS("SYS_DATACA"),True,True)%></td>
    <td><%=objRS("SYS_DATAAT")%></td>    
	<td><%=objRS("SYS_USERCA")%></td>
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
	<td><%=PrepData(objRS("CONTATO_SYS_DATACA"),True,True)%></td>
	<td><%=objRS("CONTATO_SYS_USERCA")%></td>
    <td><%=objRS("REFERENCIA")%></td>
    <td><%=objRS("NRO_EVENTOS_VISITADOS")%></td>
    <td><%=objRS("ULTIMO_COD_EVENTO")%></td>
    <td><%=ScrambleNum(objRS("CODBARRA")&"")%>&nbsp;</td>
    <td><%=PrepData(objRS("SYS_DATACRED"),True,True)%>&nbsp;</td>
    <td><%=objRS("FOTO")%></td>
    <td><%=objRS("FOTO_CONTATO")%></td>
    <%
	If not objRSEvento.EOF Then
	  Do While not objRSEvento.EOF
	     strNOME_CAMPO = objRSEvento("COD_EVENTO")&""
	%>
    <td><%=objRS(strNOME_CAMPO)%></td>
    <%
	    objRSEvento.MoveNext
	  Loop
	  objRSEvento.MoveFirst
    End If
	%>
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
  FechaRecordSet objRSEvento  

  RegistrarLogAcao ObjConn, "LOTE EXCEL", strCOD_LOTE, "tbl_LOTE", strSQL

  FechaDBConn ObjConn
%>
</table>
</body>
</html>
<%
 Response.Flush
%>
