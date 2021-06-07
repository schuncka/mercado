<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.Expires = -1

 Dim objConn, ObjRS
 Dim strSQL, strSQLClause, strSQLClause2, strSQLLeftJoin, strSQLParenteses, strFLAG_EVENTO, strSQLOrdem, auxstr, MyChecked, cont
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

   Dim tamtable, numCOLUNA, numLINHA, posinicial, numetiqueta
   Dim numALTURA, numLARGURA, numESPACO_COLUNA, numESPACO_LINHA, numMARGEM_SUPERIOR
   posinicial = Request("posinicial")

   Dim strCOD_ETIQUETA
   strCOD_ETIQUETA = Request("cod_etiqueta")&""

If IsNumeric(strCOD_ETIQUETA) Then   
'Lê o formato escolhido da etiqueta e pega os paramentros deste modelo
 strSQL = " SELECT COD_ETIQUETA, FABRICANTE, MODELO, NRO_LINHAS, NRO_COLUNAS, ALTURA, LARGURA, ESPACO_LINHA, ESPACO_COLUNA, MARGEM_SUPERIOR FROM tbl_ETIQUETA WHERE COD_ETIQUETA = " & strCOD_ETIQUETA
 
 AbreDBConn objConn, CFG_DB_DADOS 
 set objRS = objConn.execute(strSQL)	
  
 If not objRS.EOF Then
   numMARGEM_SUPERIOR = objRS("MARGEM_SUPERIOR") & ""
   numLINHA = objRS("NRO_LINHAS") & ""
   numCOLUNA = objRS("NRO_COLUNAS") & ""
   numALTURA = objRS("ALTURA") & ""
   numLARGURA = objRS("LARGURA") & ""
   numESPACO_LINHA = objRS("ESPACO_LINHA") & ""
   numESPACO_COLUNA = objRS("ESPACO_COLUNA") & ""
 End If

 FechaRecordSet objRS
 FechaDBConn objConn
End If

   If numMARGEM_SUPERIOR = "" Then
     numMARGEM_SUPERIOR = 10
   End If
   numMARGEM_SUPERIOR = Round(numMARGEM_SUPERIOR * numPIXEL_CM)

   If numLARGURA = "" Then
     numLARGURA = 105
   End If
   numLARGURA = numLARGURA + (numESPACO_COLUNA * 1.0)
   numLARGURA = Round(numLARGURA * numPIXEL_CM)

   If numALTURA = "" Then
     numALTURA = 25
   End If
   numALTURA = numALTURA + (numESPACO_LINHA * 1.0)
   numALTURA = Round(numALTURA * numPIXEL_CM)

   If posinicial = "" Or not IsNumeric(posinicial) Then
     posinicial = 1
   End If
   posinicial = CInt(posinicial)

   If numLINHA = "" Or not IsNumeric(numLINHA) Then
     numLINHA = 10
   End If
   numLINHA = CInt(numLINHA)

   If numCOLUNA = "" Or not IsNumeric(numCOLUNA) Then
     numCOLUNA = 2
   End If
   numCOLUNA = CInt(numCOLUNA)
   
   tamtable = Round(numLARGURA * numCOLUNA)

   numetiqueta = numCOLUNA * numLINHA
   If posinicial > 1 and posinicial <= numetiqueta Then
     numetiqueta = numetiqueta - posinicial + 1
   Else 
     posinicial = 1
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
    NumPerPage = 20
  End If
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<title>ProEvento <%=Session("NOME_EVENTO")%>  - Relat&oacute;rio Gerencial</title></head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<%
 Dim strLABEL_USUARIO, strLABEL_SENHA
 
 Dim strCAMPO_ANTERIOR, strCRITERIO_EVENTO, strSQL_CRITERIO, strSQL_INNER
 Dim strSQL_IGNORAR_CONTATO

' if strVAR <> "" then
   AbreDBConn objConn, CFG_DB_DADOS 
   
   strSQL_CRITERIO = ""
   strSQL_INNER = ""

   strSQL = " SELECT CRITERIO_EVENTO, SQL_CRITERIO, SQL_INNER, IGNORAR_CONTATO FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
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
   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOME"
   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
   strSQL = strSQL & " ,tbl_Empresas.SENHA"
   strSQL = strSQL & " ,tbl_PAIS.IDIOMA"
   strSQL = strSQL & " FROM " & strSQLParenteses & " ( tbl_Empresas LEFT OUTER JOIN tbl_PAIS ON (tbl_Empresas.END_PAIS = tbl_PAIS.PAIS) )"
   strSQL = strSQL & strSQLLeftJoin
   strSQL = strSQL & strSQL_INNER
   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
   strSQL = strSQL & strSQLClause
   strSQL = strSQL & strSQLClause2
   strSQL = strSQL & strSQL_CRITERIO
   strSQL = strSQL & strSQLOrdem
   
   
  Set objRS = Server.CreateObject("ADODB.Recordset")
  '==========================================================
  ' Define o tamanho das páginas de visualização
  '==========================================================
  'Set the cursor location property
  objRS.CursorLocation = adUseClient

  'Set the cache size = to the # of records/page
  objRS.CacheSize = numetiqueta * NumPerPage

  'Response.Write strSQL
  objRS.Open strSQL, objConn 

  Dim TotalPages, TotalLotes
  If not objRS.EOF Then

    objRS.MoveFirst
    objRS.PageSize = numetiqueta * NumPerPage

    'Get the max number of pages
    TotalPages = objRS.PageCount * NumPerPage
    TotalLotes = objRS.PageCount
    'Set the absolute page
    objRS.AbsolutePage = CurPage
  End If

   Dim strBgColor
'   Response.Write(tamtable & "<br>")
   %>
<table width="<%=tamtable%>" border="0" cellspacing="0" cellpadding="0" class="arial9">
  <tr> 
    <td colspan="<%=numCOLUNA%>" height="<%=numMARGEM_SUPERIOR%>" valign="top"><img src="../img/transparent.gif" width="1" height="<%=numMARGEM_SUPERIOR%>"></td>
  </tr>
</table>
<table width="<%=tamtable%>" border="0" cellspacing="0" cellpadding="5" class="arial9">
<%
  Dim i, j, contador, num_pagina
  Response.Write "        <tr> "
  
  i = 1
'  num_pagina = 1
  num_pagina = (CurPage * NumPerPage) - (NumPerPage - 1)
  Do While i < posinicial
    Response.Write "<td width=""" & numLARGURA & """ height=""" & numALTURA & """>"
	Response.Write "&nbsp;" & "<br>"
	Response.Write "&nbsp;" & "<br>"
	Response.Write "</td>"
    If i mod numCOLUNA = 0 Then
    ' Se ja colocou n colunas então cria nova linha na tabela
       Response.Write "        </tr>"
       Response.Write "        <tr> "
    End If
    i = i + 1
  Loop


  Contador = 0 + i - 1
  Do While (Not objRS.EOF) And (i <= objRS.PageSize)
    If Contador = numetiqueta Then
      ' Fecha a linha da tabela
      Response.Write "        </tr>"
      Response.Write "   </table>"
    %>
	  <table  width="<%=tamtable%>" border="0" cellspacing="0" cellpadding="0" class="arial9">
      <tr>   
        <td align="center"><font color="#999999">Página <%=num_pagina%> de <%=TotalPages%> (Lote <%=CurPage%> de <%=TotalLotes%>)</font></td>
      </tr>
	  </table>
      <!--este comando faz a quebra de página forçada, o problema é que quando foi utilizado ele imprimiu uma página em branco //-->
     <div style="page-break-before:always; width:1px;height:1px;visibility:collapse;">&nbsp;</div>
	  <table width="<%=tamtable%>" border="0" cellspacing="0" cellpadding="0" class="arial10">
      <tr> 
        <td colspan="<%=numCOLUNA%>" height="<%=numMARGEM_SUPERIOR%>" valign="top"><img src="../img/transparent.gif" width="1" height="<%=numMARGEM_SUPERIOR%>"></td>
      </tr>
	  </table>
	  
<table width="<%=tamtable%>" border="0" cellspacing="0" cellpadding="5" class="arial9">
  <%
	  Contador = 0
  	  num_pagina = num_pagina + 1
	End If

    Select Case Ucase(objRS("IDIOMA")&"")
	  Case "I"
	    strLABEL_USUARIO = "User"
		strLABEL_SENHA = "Password"
	  Case "E"
	    strLABEL_USUARIO = "Usuario"
		strLABEL_SENHA = "Contraseña"
	  Case Else
	    strLABEL_USUARIO = "Usuário"
		strLABEL_SENHA = "Senha"
    End Select	  
    ' Inicio da primeira linha da tabela
    Response.Write "<td width=""" & numLARGURA & """ height=""" & numALTURA & """ class=""arial9"" align=""center"" valign=""center"">"
	Response.Write strLABEL_USUARIO & ": <b>" & UCase(CFG_IDEMPRESA) & AthFormataTamLeft(objRS("COD_EMPRESA"),6,"0") & "</b><br>"
	Response.Write strLABEL_SENHA & ": <b>" & objRS("SENHA") & "</b><br>"
	Response.Write "<span class=""arial6"">CEP: " & objRS("END_CEP") & "</span>"
	Response.Write "</td>"
    If i mod numCOLUNA = 0 And Contador < numetiqueta Then
    ' Se ja colocou n colunas então cria nova linha na tabela
       Response.Write "        </tr>"
       Response.Write "        <tr> "
    End If
    i = i + 1
    Contador = Contador + 1
    objRS.MoveNext
  Loop
	' Verifica se preencheu toda a linha com imagens senao coloca coluna em branco
	If ((i-1) mod numCOLUNA) > 0 Then
      For j = ((i-1) mod numCOLUNA) + 1 To numCOLUNA
         Response.Write "          <td width=""" & numLARGURA & """ height=""" & numALTURA & """>&nbsp;</td>"
      Next
	End If
	' Fecha a linha da tabela
    Response.Write "        </tr>"
%>
</table>
<% 
   FechaRecordSet ObjRS
   FechaDBConn ObjConn
%>
</body>
</html>