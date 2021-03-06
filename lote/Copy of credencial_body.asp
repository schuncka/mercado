<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<!--#include file="../_scripts/scripts.js"-->
<!-- #include file="../_include/barcode39.asp"; -->
<%
 Dim strCOD_LOTE
	
 strCOD_LOTE = Request("var_chavereg")


 Dim strDT_INICIO, strDT_FIM, strCOD_INSCRICAO, strCOD_PROD, strNUM_COMPETIDOR, strCOD_STATUS_CRED
 Dim strMARCAIMPRESSAO, strSYS_DATACRED, strNOMINAL

 strDT_INICIO = Replace(Request("var_dt_inicio"),"'","")
 strDT_FIM = Replace(Request("var_dt_fim"),"'","")
 strMARCAIMPRESSAO = Request("var_marcaimpressao")
 strCOD_INSCRICAO = Replace(Request("var_cod_inscricao"),"'","")
 strCOD_PROD = Request("var_cod_prod")
 strCOD_STATUS_CRED = Request("var_cod_status_cred")
 strSYS_DATACRED = Request("var_sys_datacred")
 
 If not IsDate(strDT_INICIO) Then
   strDT_INICIO = ""
 End If
 If not IsDate(strDT_FIM) Then
   strDT_FIM = ""
 End If

   Dim tamtable, numcol, numlinha, tamcol, altTabela, posinicial, numetiqueta
   posinicial = Request("posinicial")
   numlinha = Request("numlinha")
   numcol = Request("numcol")

   If posinicial = "" Or not IsNumeric(posinicial) Then
     posinicial = 1
   End If
   posinicial = CInt(posinicial)

   If numlinha = "" Or not IsNumeric(numlinha) Then
     numlinha = 4
   End If
   numlinha = CInt(numlinha)

   If numcol = "" Or not IsNumeric(numcol) Then
     numcol = 2
   End If
   numcol = CInt(numcol)
   
   tamtable = 640
   tamcol = fix(tamtable / numcol)
   numetiqueta = numcol * numlinha
'   If posinicial > 1 and posinicial <= numetiqueta Then
'     numetiqueta = numetiqueta - posinicial + 1
'   Else 
'     posinicial = 1
'   End If
   
   
   
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
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<%
Dim objConn, objRS, objRSDetail, strSQL, strSQLClause, strSQLOrdem
Dim strEMPRESA, strNOME, strLOCAL, strATIV, strCODBARRA, strCEP, strENTIDADE, strPAIS
 
 
If UCase(Request("var_impressao")) = "TRUE" Then

   Dim  strCAMPO_ANTERIOR, strNUM_CRED_PJ
   
   AbreDBConn objConn, CFG_DB_DADOS 

   strNUM_CRED_PJ = 0
   strNOMINAL = ""
   
   ' Consulta para pegar o campo NUM_CRED_PJ do Lote pra impress�o de credencias pra empresa
   strSQL = " SELECT NUM_CRED_PJ, NOMINAL FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
     strNUM_CRED_PJ = objRS("NUM_CRED_PJ")
	 strNOMINAL = objRS("NOMINAL")&""
   End If
   FechaRecordSet objRS
   
   strCAMPO_ANTERIOR = ""
   strSQL = " SELECT * FROM tbl_Lote_Criterio WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   Do While not objRS.EOF
     If strCAMPO_ANTERIOR <> objRS("CAMPO") Then
	   strCAMPO_ANTERIOR = objRS("CAMPO")
       strSQLClause = strSQLClause & ") AND ("
'	   strSQLClause = strSQLClause & " tbl_Empresas." & objRS("CAMPO") & " "
'	   strSQLClause = strSQLClause  & objRS("CAMPO") & " "
	   If InStr(objRS("CAMPO")&"","IDIOMA") > 0 Then
	     strSQLClause = strSQLClause & " [tbl_Pais]." & objRS("CAMPO") & " "
	   Else
	     strSQLClause = strSQLClause & " tbl_Empresas." & objRS("CAMPO") & " "
	   End If

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
'	   strSQLClause = strSQLClause & " tbl_Empresas." & objRS("CAMPO") & " "
'	   strSQLClause = strSQLClause & objRS("CAMPO") & " "
	   If InStr(objRS("CAMPO")&"","IDIOMA") > 0 Then
	     strSQLClause = strSQLClause & " [tbl_Pais]." & objRS("CAMPO") & " "
	   Else
	     strSQLClause = strSQLClause & " tbl_Empresas." & objRS("CAMPO") & " "
	   End If
	   
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

'   If strSYS_DATACRED <> "" Then
'     strSQLClause = strSQLClause & "    AND tbl_Empresas.SYS_DATACRED " & strSYS_DATACRED
'   End If


   ' Pesquisa os campos de ordena��o do resultado
   strSQL = " SELECT * FROM tbl_Lote_Ordem WHERE COD_LOTE = " & strCOD_LOTE & " ORDER BY ORDEM"
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
   strSQLOrdem = strSQLOrdem & " ORDER BY "
     Do While not objRS.EOF
	   If InStr(objRS("CAMPO")&"","IDIOMA") > 0 Then
         strSQLOrdem = strSQLOrdem & " tbl_Pais." & objRS("CAMPO") & " " & objRS("DIRECAO") & ", "
       Else
		 strSQLOrdem = strSQLOrdem & " tbl_Empresas." & objRS("CAMPO") & " " & objRS("DIRECAO") & ", "
	   End If
       objRS.MoveNext
     Loop
     strSQLOrdem = strSQLOrdem & " 1 "
   End If
   FechaRecordSet objRS

   
'   strSQL = " SELECT tbl_Empresas.COD_EMPRESA"
'   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOMEFAN"
'   strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_COMPLETO"
'   strSQL = strSQL & " ,tbl_Empresas_Sub.CODBARRA"
'   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
'   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
'   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
'   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
'   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
'   strSQL = strSQL & " FROM (tbl_Empresas LEFT OUTER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)  )"
'   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
'   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
'   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
'   strSQL = strSQL & strSQLClause
'   strSQL = strSQL & strSQLOrdem

'Mauro - 30/03/2007
'Novo SQL incluindo a op��o de criterios de pesquisa na tabela "tbl_PAIS"
'   strSQL = " SELECT tbl_Empresas.COD_EMPRESA"
'   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOMEFAN"
'   strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_COMPLETO"
'   strSQL = strSQL & " ,tbl_Empresas_Sub.CODBARRA"
'   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
'   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
'   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
'   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
'   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
'   strSQL = strSQL & " ,[tbl_Pais].IDIOMA"
'   strSQL = strSQL & " FROM ( (tbl_Empresas LEFT OUTER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)  )"
'   strSQL = strSQL & "       LEFT OUTER JOIN [tbl_PAIS] ON (tbl_Empresas.END_PAIS = [tbl_PAIS].PAIS) )"
'   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
'   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
'   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
'   strSQL = strSQL & strSQLClause
'   strSQL = strSQL & strSQLOrdem


'Mauro - 25/04/2007
'Novo SQL para "replicar" o numero de empresas quando o campo NUM_CRED_PJ > 0
   strSQL = ""
   If strNUM_CRED_PJ > 0 Then
     For i = 1 To strNUM_CRED_PJ
	   strSQL = strSQL & "(" 
	   strSQL = strSQL & " SELECT tbl_Empresas.COD_EMPRESA"
	   strSQL = strSQL & " ,tbl_Empresas.NOMECLI"
	   strSQL = strSQL & " ,tbl_Empresas.NOMEFAN"
'	   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOME_COMPLETO"
	   strSQL = strSQL & " ,'" & strNOMINAL & "' AS NOME_COMPLETO"
	   strSQL = strSQL & " ,tbl_Empresas.COD_EMPRESA & '00" & i & "' AS CODBARRA"
	   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
	   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
	   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
	   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
	   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
	   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
	   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
	   strSQL = strSQL & " ,tbl_Pais.IDIOMA"
	   strSQL = strSQL & " FROM ( tbl_Empresas "
	   strSQL = strSQL & "       LEFT OUTER JOIN tbl_PAIS ON (tbl_Empresas.END_PAIS = tbl_PAIS.PAIS) )"
	   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
	   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.TIPO_PESS = 'N' "
	   strSQL = strSQL & strSQLClause
	   strSQL = strSQL  & ")" 
	   strSQL = strSQL & " UNION " 
	 Next
     strSQL = strSQL & "("  
   End If
   strSQL = strSQL & " SELECT tbl_Empresas.COD_EMPRESA"
   strSQL = strSQL & " ,tbl_Empresas.NOMECLI"
   strSQL = strSQL & " ,tbl_Empresas.NOMEFAN"
   strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_COMPLETO"
   strSQL = strSQL & " ,tbl_Empresas_Sub.CODBARRA"
   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
   strSQL = strSQL & " ,tbl_Pais.IDIOMA"
   strSQL = strSQL & " FROM ( (tbl_Empresas LEFT OUTER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA) )"
   strSQL = strSQL & "       LEFT OUTER JOIN tbl_PAIS ON (tbl_Empresas.END_PAIS = tbl_PAIS.PAIS) )"
   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
'   If strNUM_CRED_PJ > 0 Then
'     strSQL = strSQL & "    AND  tbl_Empresas.TIPO_PESS = 'S' "
'   End If
   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
   strSQL = strSQL & strSQLClause
   
   If strNUM_CRED_PJ > 0 Then 'Para fechar o UNION
     strSQL = strSQL  & ")"  
   End If

   strSQL = strSQL & strSQLOrdem


'  Response.Write strSQL
'  Response.End()		

  Set objRS = Server.CreateObject("ADODB.Recordset")
  Set objRSDetail = Server.CreateObject("ADODB.Recordset")
  '==========================================================
  ' Define o tamanho das p�ginas de visualiza��o
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

   Dim strBgColor, strPRODUTO
   Dim strTOT_INSCRICAO
   strPRODUTO = ""
   %>
<table width="620" border="0" cellspacing="0" cellpadding="7" class="arial12">
  <tr> 
    <td colspan="<%=numcol%>" valign="top"><img src="../img/transparent.gif" width="10" height="10" border="0"></td>
  </tr>
<%
  Dim i, j, Contador, num_pagina
  Response.Write "        <tr> "
  
  i = 1
  num_pagina = (CurPage * NumPerPage) - (NumPerPage - 1)
  Do While i < posinicial
    Response.Write "<td width=""" & tamcol & """ height=""228"">"
    Response.Write "<table width=""320"" height=""228"" border=""0"" cellpadding=""0"" cellspacing=""0"" class=""arial10"">"
    Response.Write "    <tr> "
    Response.Write "      <td height=""15"">&nbsp;</td>"
    Response.Write "    </tr>"
    Response.Write "    <tr> "
    Response.Write "      <td height=""15"">&nbsp;</td>"
    Response.Write "    </tr>"
    Response.Write "    <tr> "
    Response.Write "      <td height=""15"">&nbsp;</td>"
    Response.Write "    </tr>"
    Response.Write "      <tr> "
    Response.Write "    <td height=""15"">&nbsp;</td>"
    Response.Write "      </tr>"
    Response.Write "    <tr> "
    Response.Write "      <td height=""15"">&nbsp;</td>"
    Response.Write "    </tr>"
    Response.Write "      <tr> "
    Response.Write "    <td height=""15"">&nbsp;</td>"
    Response.Write "      </tr>"
    Response.Write "    <tr> "
    Response.Write "      <td valign=""top"">"
    Response.Write "        <table width=""300"" border=""0"" align=""center"" cellpadding=""0"" cellspacing=""0"" class=""arial10"">"
    Response.Write "          <tr> "
    Response.Write "            <td>&nbsp;</td>"
    Response.Write "          </tr>"
    Response.Write "        </table><br>"
    Response.Write "      </td>"
    Response.Write "    </tr>"
    Response.Write "</table>"
	Response.Write "</td>"
    If i mod numcol = 0 Then
    ' Se ja colocou n colunas ent�o cria nova linha na tabela
       Response.Write "        </tr>"
       Response.Write "        <tr> "
    End If
    i = i + 1
  Loop

  Contador = 0 + i - 1

  'On Error Resume Next
  Do While (Not objRS.EOF) And (i <= objRS.PageSize)
    If Contador = numetiqueta Then
      ' Fecha a linha da tabela
      Response.Write "        </tr>"
      Response.Write "   </table>"
    %>
	  <table width="620" border="0" cellspacing="0" cellpadding="0" class="arial10">
      <tr>   
        <td align="center"><font color="#999999">P�gina <%=num_pagina%> de <%=TotalPages%> (Lote <%=CurPage%> de <%=TotalLotes%>)</font></td>
      </tr>
	  </table>
      <!--este comando faz a quebra de p�gina for�ada, o problema � que quando foi utilizado ele imprimiu uma p�gina em branco //-->
      <div style="page-break-before:always; width:1px;height:1px;visibility:collapse;">&nbsp;</div>
	  <table width="620" border="0" cellspacing="0" cellpadding="7" class="arial12">
      <tr> 
        <td colspan="<%=numcol%>" valign="top"><img src="../img/transparent.gif" width="10" height="10" border="0"></td>
      </tr>
	<%
	  Contador = 0
	  num_pagina = num_pagina + 1
	End If
    strCODBARRA  = objRS("CODBARRA")&""
    strEMPRESA   = UCase(objRS("NomeFan"))
    strLOCAL     = UCase(objRS("END_CIDADE")) & "/" & UCase(objRS("END_ESTADO"))
	strCEP       = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	strCEP       = objRS("END_CEP") & ""
	strPAIS      = objRS("END_PAIS") & ""
    strNOME = objRS("Nome_Completo") & ""
   	If strNOME = "" And strCODBARRA = "" Then
      strNOME      = UCase(objRS("NomeFan"))
      strCODBARRA  = objRS("COD_EMPRESA") & "010"
	  strSQL = " UPDATE tbl_EMPRESAS SET SYS_DATACRED = NOW() WHERE COD_EMPRESA = '" & objRS("COD_EMPRESA") & "'"
	Else
	  strSQL = " UPDATE tbl_EMPRESAS_SUB SET SYS_DATACRED = NOW() WHERE CODBARRA = '" & strCODBARRA & "'"
	End If
	If strMARCAIMPRESSAO = "S" Then
	  objConn.Execute(strSQL)
    End If
	
	If strMARCAIMPRESSAO = "S" And strNUM_CRED_PJ > 0 Then
	  strSQL = " UPDATE tbl_EMPRESAS SET SYS_DATACRED = NOW() WHERE COD_EMPRESA = '" & objRS("COD_EMPRESA") & "'"
	  objConn.Execute(strSQL)
	End If

    strENTIDADE = objRS("ENTIDADE") & ""
	If strENTIDADE <> "" Then
	  strENTIDADE = "<br>" & strENTIDADE
	End If

    strATIV      = UCase(objRS("ATIVIDADE")&"")

	If (numetiqueta - Contador) > numcol Then
	  altTabela = "228"
'	Else
'	  altTabela = ""
	End If

    Response.Write "<td valign=""top"" width=""" & tamcol & """ height=""" & altTabela & """>"
	%>
<table width="310" height="<%=altTabela%>" border="0" cellpadding="0" cellspacing="0" class="arial10">
  <tr> 
    <td width="310" height="55" align="center" valign="top">
	<font size="3" face="Arial Narrow, Arial"><b><%=Left(strNOME,30)%></b></font>
	<font size="5" face="Arial Narrow, Arial"><%=Left(strENTIDADE,20)%></font>
	</td>
  </tr>
  <tr> 
    <td height="1" align="center"><img src="../img/dot_gray.gif" width="280" height="1" vspace="4"></td>
  </tr>
  <tr> 
    <td width="310" align="center">
      <% If strNOME <> strEMPRESA Then %>
	  <font size="5" face="Arial Narrow, Arial"><b><%=Left(strEMPRESA,20)%></b></font> 
	  <br>
	  <% End If %>
      <%
	     If strPAIS = "BRASIL" Then 
	       If strLOCAL <> "/" Then
	  %>
	   <font size="3" face="Arial Narrow, Arial"><%=strLOCAL%></font>
	  <%
		   End If
		 Else
	  %>
	   <font size="3" face="Arial Narrow, Arial"><%=strPAIS%></font>
	  <%
		 End If
	  %>
    </td>
  </tr>
  <tr> 
    <td height="1" align="center"><img src="../img/dot_gray.gif" width="280" height="1" vspace="4"></td>
  </tr>
  <tr> 
    <td width="310" valign="top" align="center" class="arial6"><br>
      <% 
	     BarCode39(strCODBARRA)
	     Response.Write("<br>")
		 Response.Write("<font class=""arial6"">")
		 Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
		 Response.Write("* " & strCODBARRA & " *")
		 Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & strCEP )
		 Response.Write("</font>")
      %>
	  <br><br>
	  <font size="2" face="Arial Narrow, Arial"><b><%=strATIV%></b></font>
    </td>
  </tr>
</table>
	<%
	Response.Write "</td>"
    If i mod numcol = 0 And Contador < numetiqueta Then
    ' Se ja colocou n colunas e n�o � o fim da tabela ent�o cria nova linha na tabela
       Response.Write "        </tr>"
       Response.Write "        <tr>"
    End If
    i = i + 1
    Contador = Contador + 1
    objRS.MoveNext
	
	if err.Number<>0 Then
	  Response.Write("Problemas no processamento desta consulta.<br>")
	  Response.Write(err.Description & "<br>")
	  Response.End()
	End If
  Loop
	' Verifica se preencheu toda a linha com imagens senao coloca coluna em branco
	If ((i-1) mod numcol) > 0 Then
      For j = ((i-1) mod numcol) + 1 To numcol
         Response.Write "          <td width=""" & tamcol & """>"
         Response.Write "<table width=""300"" border=""0"" cellpadding=""0"" cellspacing=""0"" class=""arial10"">"
         Response.Write "    <tr> "
         Response.Write "      <td height=""15"">&nbsp;</td>"
         Response.Write "    </tr>"
         Response.Write "    <tr> "
         Response.Write "      <td height=""15"">&nbsp;</td>"
         Response.Write "    </tr>"
         Response.Write "    <tr> "
         Response.Write "      <td height=""15"">&nbsp;</td>"
         Response.Write "    </tr>"
         Response.Write "      <tr> "
         Response.Write "    <td height=""15"">&nbsp;</td>"
         Response.Write "      </tr>"
         Response.Write "    <tr> "
         Response.Write "      <td height=""15"">&nbsp;</td>"
         Response.Write "    </tr>"
         Response.Write "      <tr> "
         Response.Write "    <td height=""15"">&nbsp;</td>"
         Response.Write "      </tr>"
         Response.Write "    <tr> "
         Response.Write "      <td valign=""top"">"
         Response.Write "        <table width=""300"" border=""0"" align=""center"" cellpadding=""0"" cellspacing=""0"" class=""arial10"">"
         Response.Write "          <tr> "
         Response.Write "            <td>&nbsp;</td>"
         Response.Write "          </tr>"
         Response.Write "        </table><br>"
         Response.Write "      </td>"
         Response.Write "    </tr>"
         Response.Write "</table>"
         Response.Write "</td>"
      Next
	End If
	' Fecha a linha da tabela
    Response.Write "        </tr>"
%>
</table>
<!--
<table width="620" border="0" cellspacing="0" cellpadding="0" class="arial10">
  <tr> 
   <td align="center"><font color="#999999">P�gina <%=num_pagina%> de <%=TotalPages%></font></td>
  </tr>
</table>
//-->
  <% 
   FechaRecordSet ObjRS
   FechaDBConn ObjConn
Else
%>
<div align="center"> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong><font face="Arial, Helvetica, sans-serif">.: 
  AVISO :.</font></strong><font face="Arial, Helvetica, sans-serif"><br>
  Informe os crit�rios acima para montagem das credenciais. </font></font> </div>
  <%
End If

'Response.Flush()
%>
</body>
</html>