<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<!--#include file="../_scripts/scripts.js"-->
<!-- #include file="../_include/barcode39.asp"; -->
<%
 Response.Expires = -1

Dim FSO, fich, strARQUIVO, strPATH
Dim strMALADIRETA_MODELO, strMALADIRETA

strPATH = Server.MapPath("../") & "\_database\"
' Response.Write(strPATH & "<BR>")

Set FSO = createObject("scripting.filesystemobject") 

strARQUIVO = strPATH & "modelo_maladireta" & "_" & Session("COD_EVENTO") & ".asp"
If not FSO.FileExists(strARQUIVO) Then
strARQUIVO = strPATH & "modelo_maladireta.asp"
End If

' Response.Write(strARQUIVO)
' Response.End()

Set fich = FSO.OpenTextFile(strARQUIVO) 
strMALADIRETA_MODELO = fich.readAll() 
fich.close() 

Set fich = Nothing
Set FSO = Nothing

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
   Dim numALTURA, numLARGURA, numESPACO_COLUNA, numESPACO_LINHA, numMARGEM_SUPERIOR, numMARGEM_ESQUERDA
   posinicial = Request("posinicial")

   Dim strCOD_ETIQUETA
   strCOD_ETIQUETA = Request("cod_etiqueta")&""

If IsNumeric(strCOD_ETIQUETA) Then   
'Lê o formato escolhido da etiqueta e pega os paramentros deste modelo
 strSQL = " SELECT COD_ETIQUETA, FABRICANTE, MODELO, NRO_LINHAS, NRO_COLUNAS, ALTURA, LARGURA, ESPACO_LINHA, ESPACO_COLUNA, MARGEM_SUPERIOR, MARGEM_ESQUERDA"
 strSQL = strSQL & " FROM tbl_ETIQUETA WHERE COD_ETIQUETA = " & strCOD_ETIQUETA
 
 AbreDBConn objConn, CFG_DB_DADOS 
 set objRS = objConn.execute(strSQL)	
  
 If not objRS.EOF Then
   numMARGEM_SUPERIOR = objRS("MARGEM_SUPERIOR") & ""
   numMARGEM_ESQUERDA = objRS("MARGEM_ESQUERDA") & ""
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
     numMARGEM_SUPERIOR = 0
   End If
   numMARGEM_SUPERIOR = Round(numMARGEM_SUPERIOR * numPIXEL_CM)

   If numMARGEM_ESQUERDA = "" Then
     numMARGEM_ESQUERDA = 0
   End If
   numMARGEM_ESQUERDA = Round(numMARGEM_ESQUERDA * numPIXEL_CM)

   If numLARGURA = "" Then
     numLARGURA = 0
   End If
   numLARGURA = numLARGURA + (numESPACO_COLUNA * 1.0)
   numLARGURA = Round(numLARGURA * numPIXEL_CM)

   If numALTURA = "" Then
     numALTURA = 0
   End If
   numALTURA = numALTURA + (numESPACO_LINHA * 1.0)
   numALTURA = Round(numALTURA * numPIXEL_CM)

   If posinicial = "" Or not IsNumeric(posinicial) Then
     posinicial = 1
   End If
   posinicial = CInt(posinicial)
   
   If numLINHA = "" Or not IsNumeric(numLINHA) Then
     numLINHA = 1
   End If
   numLINHA = CInt(numLINHA)

   If numCOLUNA = "" Or not IsNumeric(numCOLUNA) Then
     numCOLUNA = 1
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
    NumPerPage = 50
  End If
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<title>ProEvento <%=Session("NOME_EVENTO")%>  - Relat&oacute;rio Gerencial</title></head>
<body leftmargin="<%=numMARGEM_ESQUERDA%>" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<%
Dim strEMPRESA, strNOME, strNOME_COMPLETO, strLOCAL, strATIV, strCODBARRA, strENTIDADE, strCARGO, strCIDADE, strESTADO, strCEP, strPAIS, strID_NUM_DOC1, strDT_ATUAL, strCOD_EMPRESA, strENDERECO
Dim strEXTRA_TXT_1, strEXTRA_TXT_2, strEXTRA_TXT_3
Dim strSTATUS_CRED, strSQL_IGNORAR_CONTATO

 Dim strCAMPO_ANTERIOR, strNOMINAL, strCRITERIO_EVENTO, strSQL_CRITERIO, strSQL_INNER, strSQL_INNER_SUB, strSQL_CRITERIO_SUB, strCRITERIO_OPERADOR

' if strVAR <> "" then
   AbreDBConn objConn, CFG_DB_DADOS 

   strNOMINAL = ""
   strSQL_CRITERIO = ""
   strSQL_INNER = ""

   ' Consulta para pegar o campo NOMINAL do Lote pra impressão na mala direta
   strSQL = " SELECT NOMINAL, CRITERIO_EVENTO, SQL_CRITERIO, SQL_INNER, SQL_INNER_SUB, SQL_CRITERIO_SUB, IGNORAR_CONTATO FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
     strNOMINAL = objRS("NOMINAL")&""
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

   

   strSQL = " SELECT tbl_Empresas.COD_EMPRESA"
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_empresas.codbarra,tbl_empresas_sub.codbarra) as CODBARRA"
   strSQL = strSQL & ", tbl_Empresas.NOMECLI"
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
   strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_CREDENCIAL"
   strSQL = strSQL & ", tbl_Empresas_Sub.CARGO_NOME"
   strSQL = strSQL & ", tbl_Empresas_Sub.DT_NASC"
   strSQL = strSQL & ", tbl_Empresas_Sub.EMAIL"
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


   'Response.Write(strSQL)
   'response.End()
     
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
<%
  Dim i, j, contador, num_pagina
  Response.Write "        <tr> "
  
  i = 1
'  num_pagina = 1
  num_pagina = (CurPage * NumPerPage) - (NumPerPage - 1)
  Do While i < posinicial
    Response.Write "<td width=""" & numLARGURA & """ height=""" & numALTURA & """>"
	Response.Write strMALADIRETA_MODELO
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
	<% If Cstr(numCOLUNA) <> "1" Or Cstr(numLINHA) <> "1" Then  %>
	  <table  width="<%=tamtable%>" border="0" cellspacing="0" cellpadding="0" class="arial9">
      <tr>   
        <td align="center"><font color="#999999">Página <%=num_pagina%> de <%=TotalPages%> (Lote <%=CurPage%> de <%=TotalLotes%>)</font></td>
      </tr>
	  </table>
	<% End If %>
      <!--este comando faz a quebra de página forçada, o problema é que quando foi utilizado ele imprimiu uma página em branco //-->
      <div style="page-break-before:always; width:1px;height:1px; visibility:hidden;"></div>
	  
<table width="<%=tamtable%>" border="0" cellspacing="0" class="arial9">
  <%
	  Contador = 0
  	  num_pagina = num_pagina + 1
	End If
	 

	strCOD_EMPRESA = objRS("COD_EMPRESA")&""
    strCODBARRA  = objRS("CODBARRA")&""
	strNOME      = ""
    strEMPRESA   = Trim(objRS("NomeFan")&"")
	strNOME_COMPLETO = Trim(objRS("NOMECLI")&"")
	strENDERECO  = Trim(objRS("END_FULL")&"")
    strCIDADE    = Trim(objRS("END_CIDADE")&"")
	strESTADO    = Trim(objRS("END_ESTADO")&"")
    strLOCAL     = strCIDADE & "/" & strESTADO
	strPAIS      = Trim(objRS("END_PAIS")&"")
	strCEP       = objRS("END_CEP")&""
	strSTATUS_CRED = objRS("CREDENCIAL")&""

	'strNOME = objRS("NOME_CREDENCIAL") & ""
    strID_NUM_DOC1 = objRS("ID_NUM_DOC1") & ""

   	If strNOME = "" Then
      strNOME      = Trim(objRS("NomeFan")&"")
	End If
	
   	If strCODBARRA = "" Then
      strCODBARRA  = objRS("COD_EMPRESA") & "010"
	End If			

	strENTIDADE  = Trim(objRS("ENTIDADE_FANTASIA"))&""
	If strENTIDADE = "" Then
	  strENTIDADE  = Trim(objRS("ENTIDADE"))&""
	End If
	
	If strENTIDADE = "" Then
	  strENTIDADE  = strEMPRESA
	End If
	
		If strNOME <> "" And strNOME = strNOME_COMPLETO Then
	  strNOME_COMPLETO = ""
	End If

	If (strNOME <> "" And strNOME = strENTIDADE) or objRS("TIPO_PESS")&"" = "S" Then
	  strENTIDADE = ""
	End If

	
	strCARGO = objRS("ENTIDADE_CARGO")&""
    strATIV      = Trim(objRS("ATIVIDADE")&"")

	strEXTRA_TXT_1 = objRS("EXTRA_TXT_1")&""
	strEXTRA_TXT_2 = objRS("EXTRA_TXT_2")&""
	strEXTRA_TXT_3 = objRS("EXTRA_TXT_3")&""

    ' Inicio da primeira linha da tabela
    Response.Write "<td width=""" & numLARGURA & """ height=""" & numALTURA & """>"

	
	
	strMALADIRETA = strMALADIRETA_MODELO&""
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_NOME_CREDENCIAL>",Left(strNOME&"",CFG_MAXLEN_LABEL_NOME))
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_NOME_COMPLETO>",strNOME_COMPLETO&"")
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_ENTIDADE>",Left(strENTIDADE&"",25))
	If strNOME <> strEMPRESA Then
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_EMPRESA>",Left(strEMPRESA&"",25))
	End If
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_COD_EMPRESA>",strCOD_EMPRESA&"")
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_CODBARRA>",strCODBARRA&"")
   	strMALADIRETA = Replace(strMALADIRETA,"<PRO_ENDERECO>",strENDERECO)
    strMALADIRETA = Replace(strMALADIRETA,"<PRO_CEP>",strCEP&"")
	
	If strPAIS = "BRASIL" Then 
      If strLOCAL <> "/" Then
	    strMALADIRETA = Replace(strMALADIRETA,"<PRO_LOCAL>",strLOCAL)
	  End If
	  
	  If strCIDADE&"" <> "" And strESTADO&""<> "" Then
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_LOCAL_SEP>","/")
	  End If
	  
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_CIDADE>",strCIDADE)
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_ESTADO>",strESTADO)
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_PAIS>",strPAIS)
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_LOCAL_SEP_PAIS>","/")
	Else	  
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_LOCAL_SEP_PAIS>","/")
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_CIDADE>",strCIDADE)	  
      strMALADIRETA = Replace(strMALADIRETA,"<PRO_ESTADO>","")	  
      strMALADIRETA = Replace(strMALADIRETA,"<PRO_PAIS>",strPAIS)
	End If
	
    strMALADIRETA = Replace(strMALADIRETA,"<PRO_BARCODE>", ReturnBarCode39(strCODBARRA, 30, 1.5, "../img/"))
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_BARCODE_VERTICAL>", ReturnBarCode39Vertical(strCODBARRA, 30, 1.5, "../img/"))
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_NRO_BARCODE>", strCODBARRA)
    strMALADIRETA = Replace(strMALADIRETA,"<PRO_ATIVIDADE>",strATIV&"")
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_CARGO>",strCARGO)
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_ID_NUM_DOC1>",strID_NUM_DOC1)
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_STATUS_CRED>",strSTATUS_CRED)
	
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_1>",strEXTRA_TXT_1)
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_2>",strEXTRA_TXT_2)
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_3>",strEXTRA_TXT_3)
	
	strDT_ATUAL = PrepData(now(),true,false) 
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_DATA_DDMMAAAA>",strDT_ATUAL)
	strDT_ATUAL = PrepData(now(),true,true) 
	strMALADIRETA = Replace(strMALADIRETA,"<PRO_HORA_HHMMSS>",right(strDT_ATUAL,Len(strDT_ATUAL) - InStr(strDT_ATUAL," ") + 1) )
    
	Response.Write(strMALADIRETA)
	
	Response.Write "</td>"
    If i mod numCOLUNA = 0 And Contador < numetiqueta And Cstr(numCOLUNA) <> "1" And Cstr(numLINHA) <> "1" Then
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