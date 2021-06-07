<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/athBBSI.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<!--#include file="../_include/barcode39.asp"-->
<%
	 Dim strFICHA_MODELO, strFICHA
	 Dim FSO, fich, strARQUIVO, strPATH
	 
	 strPATH = Server.MapPath(".")&"\"
	 'Response.Write(strPATH & "<BR>")
	 
	 Set FSO = createObject("scripting.filesystemobject") 
	 
	 strARQUIVO = strPATH & "modelo_ficha_atualizacao_pj" & "_" & Session("COD_EVENTO") & ".html"
	 If not FSO.FileExists(strARQUIVO) Then
	   strARQUIVO = strPATH & "modelo_ficha_atualizacao_pj.html"
	 End If
	 
	 'Response.Write(strARQUIVO)
	 'Response.End()
	 
	 Set fich = FSO.OpenTextFile(strARQUIVO) 
	 strFICHA_MODELO = fich.readAll() 
	 fich.close() 
	 
	 Set fich = Nothing
	 Set FSO = Nothing
	 
 Response.Expires = -1

 Dim objConn, ObjRS, objRSDetail
 Dim strSQL, strSQLClause, strSQLClause2, strSQLLeftJoin, strSQLParenteses, strFLAG_EVENTO, strSQLOrdem, auxstr, MyChecked
 Dim numPIXEL_CM
 
 numPIXEL_CM = 3.85

 Dim strDT_INICIO, strDT_FIM
 Dim strCOD_LOTE
	
 strCOD_LOTE = Request("var_chavereg")
 strDT_INICIO = Replace(Request("var_dt_inicio"),"'","")
 strDT_FIM = Replace(Request("var_dt_fim"),"'","")
 
 If not IsDate(strDT_INICIO) Then
   strDT_INICIO = ""
 End If
 If not IsDate(strDT_FIM) Then
   strDT_FIM = ""
 End If

  'Retrieve what page we're currently on
  Dim CurPage, NumPerPage
  If Request("var_CurPage") = "" then
     CurPage = 1 'We're on the first page
  Else
    CurPage = Request("var_CurPage")
  End If 

  NumPerPage = Request("var_numperpage")
  If (Not IsNumeric(NumPerPage)) or (NumPerPage = "") Then
    NumPerPage = 50
  End If
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>ProEvento <%=Session("NOME_EVENTO")%>  - Relat&oacute;rio Gerencial</title></head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<%
 Dim strCAMPO_ANTERIOR, strCRITERIO_EVENTO, strSQL_CRITERIO, cont, strSQL_INNER

' if strVAR <> "" then
   AbreDBConn objConn, CFG_DB_DADOS 

   strSQL_CRITERIO = ""
   strSQL_INNER = ""
   
   strSQL = " SELECT CRITERIO_EVENTO, SQL_CRITERIO, SQL_INNER FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
	 strCRITERIO_EVENTO = objRS("CRITERIO_EVENTO")&""
	 strSQL_CRITERIO = objRS("SQL_CRITERIO")&""
	 strSQL_INNER = objRS("SQL_INNER")&""
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
'   strSQL = strSQL & " FROM tbl_Empresas "
'   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
'   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
'   strSQL = strSQL & strSQLClause
'   strSQL = strSQL & strSQLOrdem

'Mauro - 30/03/2007
'Novo SQL incluindo a opção de criterios de pesquisa na tabela "tbl_PAIS"
   strSQL = " SELECT DISTINCT tbl_Empresas.COD_EMPRESA"
   strSQL = strSQL & " ,tbl_Empresas.ID_NUM_DOC1"
   strSQL = strSQL & " ,tbl_Empresas.ID_NUM_DOC2"
   strSQL = strSQL & " ,tbl_Empresas.ID_INSCR_EST"
   strSQL = strSQL & " ,tbl_Empresas.NOMECLI"
   strSQL = strSQL & " ,tbl_Empresas.NOMEFAN"
   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
   strSQL = strSQL & " ,tbl_Empresas.HOMEPAGE"
   strSQL = strSQL & " ,tbl_Empresas.EMAIL1"
   strSQL = strSQL & " ,tbl_Empresas.FONE1"
   strSQL = strSQL & " ,tbl_Empresas.FONE2"
   strSQL = strSQL & " ,tbl_Empresas.FONE3"
   strSQL = strSQL & " ,tbl_Empresas.FONE4"
   strSQL = strSQL & " ,tbl_PAIS.IDIOMA"
   strSQL = strSQL & " FROM " & strSQLParenteses & "( tbl_Empresas LEFT OUTER JOIN tbl_PAIS ON (tbl_Empresas.END_PAIS = tbl_PAIS.PAIS) )"
   strSQL = strSQL & strSQLLeftJoin
   strSQL = strSQL & strSQL_INNER
   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
   strSQL = strSQL & strSQLClause
   strSQL = strSQL & strSQLClause2
   strSQL = strSQL & strSQL_CRITERIO
   strSQL = strSQL & strSQLOrdem
   
   'Response.Write(strSQL)
   'Response.End()
   
   
  Set objRS = Server.CreateObject("ADODB.Recordset")
  '==========================================================
  ' Define o tamanho das páginas de visualização
  '==========================================================
  'Set the cursor location property
  objRS.CursorLocation = adUseClient

  'Set the cache size = to the # of records/page
  objRS.CacheSize = NumPerPage

  'Response.Write strSQL
  objRS.Open strSQL, objConn 

  Dim TotalPages, TotalLotes
  If not objRS.EOF Then

    objRS.MoveFirst
    objRS.PageSize = NumPerPage

    'Get the max number of pages
    TotalPages = objRS.PageCount * NumPerPage
    TotalLotes = objRS.PageCount
    'Set the absolute page
    objRS.AbsolutePage = CurPage
  End If

   %>
<%
  Dim i, j, contador, num_pagina
  
  i = 1
  num_pagina = (CurPage * NumPerPage) - (NumPerPage - 1)

  Do While (Not objRS.EOF) And (i <= objRS.PageSize)
    strFICHA = strFICHA_MODELO
	strFICHA = Replace(strFICHA,"<IDEMPRESA>",CFG_IDEMPRESA&"")
	strFICHA = Replace(strFICHA,"<NOME_EVENTO>",Session("NOME_EVENTO")&"")
	strFICHA = Replace(strFICHA,"<COD_EMPRESA>",objRS("COD_EMPRESA")&"")
	strFICHA = Replace(strFICHA,"<SENHA>",CalculaSenhaBBSI(objRS("COD_EMPRESA")))
	strFICHA = Replace(strFICHA,"<ID_NUM_DOC1>",objRS("ID_NUM_DOC1")&"")
	strFICHA = Replace(strFICHA,"<NOMECLI>",objRS("NOMECLI")&"")
	strFICHA = Replace(strFICHA,"<NOMEFAN>",objRS("NOMEFAN")&"")
	strFICHA = Replace(strFICHA,"<END_CEP>",objRS("END_CEP")&"")
	strFICHA = Replace(strFICHA,"<END_CIDADE>",objRS("END_CIDADE")&"")
	strFICHA = Replace(strFICHA,"<END_ESTADO>",objRS("END_ESTADO")&"")
	strFICHA = Replace(strFICHA,"<END_FULL>",objRS("END_FULL")&"")
	strFICHA = Replace(strFICHA,"<END_BAIRRO>",objRS("END_BAIRRO")&"")
	strFICHA = Replace(strFICHA,"<ID_INSCR_EST>",objRS("ID_INSCR_EST")&"")
	strFICHA = Replace(strFICHA,"<HOMEPAGE>",objRS("HOMEPAGE")&"")
	strFICHA = Replace(strFICHA,"<FONE_COML>",objRS("FONE4")&" "&objRS("FONE1"))
	strFICHA = Replace(strFICHA,"<EMAIL>",objRS("EMAIL1")&"")
	strFICHA = Replace(strFICHA,"<FONE_FAX>",objRS("FONE2")&"")
	strFICHA = Replace(strFICHA,"<BARCODE>", ReturnBarCode39(objRS("COD_EMPRESA")&"", 30, 1.5, "../img/"))
	
	j = 1
	strSQL = "SELECT NOME_COMPLETO,CARGO_NOME,DT_ANIV FROM TBL_EMPRESAS_SUB WHERE COD_EMPRESA = '" & objRS("COD_EMPRESA") & "'"
	Set objRSDetail = objConn.Execute(strSQL)
	Do While not objRSDetail.EOF
	  strFICHA = Replace(strFICHA,"<CONTATO"&j&">",objRSDetail("NOME_COMPLETO")&"")
	  strFICHA = Replace(strFICHA,"<CARGO_NOME"&j&">",objRSDetail("CARGO_NOME")&"")
	  strFICHA = Replace(strFICHA,"<DT_ANIV"&j&">",objRSDetail("DT_ANIV")&"")
	  j = j + 1
	  objRSDetail.MoveNext
	Loop
	FechaRecordSet objRSDetail

    Response.Write(strFICHA)

    i = i + 1
    Contador = Contador + 1
    objRS.MoveNext
    If not objRS.EOF And (i <= objRS.PageSize) Then
%>
<div style="page-break-before:always; width:1px;height:1px;visibility:collapse;">&nbsp;</div>
<%
	End If
  Loop
  FechaRecordSet ObjRS
  FechaDBConn ObjConn
%>
</body>
</html>