<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/athSendMail.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<%
 Dim strCOD_LOTE, strASSUNTO, strMENSAGEM, strREMETENTE, strIMPORTANCIA
	
 strCOD_LOTE = Request.Form("var_chavereg")
 strASSUNTO = Request.Form("var_assunto")
 strMENSAGEM = Request.Form("var_mensagem")
 strREMETENTE = Request.Form("var_remetente")
 strIMPORTANCIA = Request.Form("var_importancia")
 
 If strREMETENTE = "" Then
   strREMETENTE = "noreply@proevento.com.br"
 End If
 If not IsNumeric(strIMPORTANCIA) Or strIMPORTANCIA = "" Then
   strIMPORTANCIA = 1
 End If
%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
</head>
<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<%
If strASSUNTO <> "" And strMENSAGEM <> "" Then
%>
<table width="100%" border="0">
  <tr> 
    <td><b>Resultado do Newsletter</b></td>
  </tr>
  <%
 Dim objConn, ObjRS
 Dim strSQL, strSQLClause, strSQLOrdem, auxstr
 Dim strCAMPO_ANTERIOR
 
 strMENSAGEM = "<body text='#000000' leftmargin='0' topmargin='0' marginwidth='0' marginheight='0' bgcolor='#FFFFFF'>" & strMENSAGEM & "</body>"

' if strVAR <> "" then
   AbreDBConn objConn, CFG_DB_DADOS 

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
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " '" & Replace(objRS("VALOR")&"","'","''") & "' "
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
'   strSQL = strSQL & " FROM tbl_Empresas "
'   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
'   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
'   strSQL = strSQL & strSQLClause
'   strSQL = strSQL & strSQLOrdem


'Mauro - 30/03/2007
'Novo SQL incluindo a opção de criterios de pesquisa na tabela "tbl_PAIS"
   strSQL = " SELECT tbl_Empresas.COD_EMPRESA"
   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOME"
   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
   strSQL = strSQL & " ,tbl_Empresas.EMAIL1"
   strSQL = strSQL & " ,tbl_Empresas.FONE1"
   strSQL = strSQL & " ,tbl_Pais.IDIOMA"
   strSQL = strSQL & " FROM tbl_Empresas LEFT OUTER JOIN tbl_PAIS ON (tbl_Empresas.END_PAIS = tbl_PAIS.PAIS)"
   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
   strSQL = strSQL & strSQLClause
   strSQL = strSQL & strSQLOrdem
   
  Set objRS = Server.CreateObject("ADODB.Recordset")
  'Response.Write strSQL
  objRS.Open strSQL, objConn 

  Dim strBgColor, i, cont
  Dim strEMAIL, strBCC

  i = 0
  cont = 0
  
  Do While Not objRS.EOF
    If (cont mod 100) = 0 And cont > 0 Then
      AthEnviaMail strREMETENTE, strREMETENTE, "", strBCC, strASSUNTO, strMENSAGEM, strIMPORTANCIA, 0, 0, ""
	%>
  <tr> 
    <td>Mensagens enviadas para e-mails válidos = <%=AthFormataTamLeft(cont,5,"0")%></td>
  </tr>
  <%
	  strBCC = ""
    End If
    strEMAIL = objRS("email1")&""
	If strEMAIL <> "" Then
	  strBCC = strEMAIL & ";" & strBCC
	  cont = cont + 1
	End If
    i = i + 1
    objRS.MoveNext
  Loop

  FechaRecordSet ObjRS
  FechaDBConn ObjConn
  
  If strBCC <> "" Then
    AthEnviaMail strREMETENTE, strREMETENTE, "", strBCC, strASSUNTO, strMENSAGEM, strIMPORTANCIA, 0, 0, ""
	%>
  <tr> 
    <td>Mensagens enviadas para e-mails válidos = <%=AthFormataTamLeft(cont,5,"0")%></td>
  </tr>
	<%
  End If
  %>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Total de Mensagens Enviadas (e-mails válidos) = <b><%=AthFormataTamLeft(cont,5,"0")%></b></td>
  </tr>
  <tr>
    <td>Total de Registros Encontrados = <b><%=AthFormataTamLeft(i,5,"0")%></b></td>
  </tr>
</table>
<%
Else
%>
<br><br>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="14" align="center" valign="middle">Você precisa informar o assunto 
      e a mensagem do newsletter.</td>
  </tr>
  <tr>
    <td align="center" valign="middle">&nbsp;</td>
  </tr>
  <tr> 
    <td align="center" valign="middle"><input name="Button" onClick="javascript:history.back(-1);" type="button" class="textbox70" value="voltar"></td>
  </tr>
</table>
<%
End If
%>
</body>
</html>
