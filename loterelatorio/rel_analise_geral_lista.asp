<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.Expires = -1

 Response.Buffer = True
 
 Dim strDT_INICIO, strDT_FIM
 Dim strCOD_STATUS_CRED, strCOD_STATUS_PRECO, strCODATIV, strEND_ESTADO, strEND_PAIS

 
 strDT_INICIO = Replace(Request("var_dt_inicio"),"'","")
 strDT_FIM = Replace(Request("var_dt_fim"),"'","")
 strCOD_STATUS_CRED = Request("cod_status_cred")
 strCOD_STATUS_PRECO = Request("cod_status_preco")
 strCODATIV = Request("cod_ativ")
 strEND_ESTADO = Request("end_estado")
 strEND_PAIS = Request("end_pais")
 
 If not IsDate(strDT_INICIO) Then
   strDT_INICIO = ""
 End If
 If not IsDate(strDT_FIM) Then
   strDT_FIM = ""
 End If

 Dim strTITULO
 Dim objConn, ObjRS, objRSDetail
 Dim strSQL, strSQLClause, auxstr, MyChecked
 Dim strORDERBY, strDIRECTION
 
 strORDERBY = Request("order")
 strDIRECTION = Request("direction")

 
 AbreDBConn objConn, CFG_DB_DADOS 
 
 If strCODATIV <> "" Then
   If strCODATIV = "INDEFINIDO" Then
       strTITULO = strTITULO & " CATEGORIA = Indefinido"
   Else
     strSQL = "select ativmini from tbl_ATIVIDADE where codativ = '" & strCODATIV&"" & "'"
     Set objRS = objConn.Execute(strSQL)
	 If not objRS.EOF Then
       strTITULO = strTITULO & " ATIVIDADE = " & objRS("ativmini")
	 End IF
     FechaRecordSet objRS
   End If
 End If

 If strCOD_STATUS_CRED <> "" Then
   If strCOD_STATUS_CRED = "INDEFINIDO" Then
       strTITULO = strTITULO & " CREDENCIAL = Indefinido"
   Else
     strSQL = "select status from tbl_status_Cred where cod_status_Cred = " & strCOD_STATUS_CRED&""
     Set objRS = objConn.Execute(strSQL)
	 If not objRS.EOF Then
       strTITULO = strTITULO & " CREDENCIAL = " & objRS("status")
	 End IF
     FechaRecordSet objRS
   End If
 End If
 
 If strEND_ESTADO <> "" Then
   strTITULO = strTITULO & " ESTADO = " & strEND_ESTADO
 End If

 If strEND_PAIS <> "" Then
   strTITULO = strTITULO & " PAÍS = " & strEND_PAIS
 End If

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<title>ProEvento <%=Session("NOME_EVENTO")%> </title></head>
<body text="#916E28" link="#916E28" vlink="#916E28" alink="#916E28" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="640" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" align="center" class="arial12Bold">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" align="center" class="arial12Bold">Relat&oacute;rio Visitantes 
      01 - An&aacute;lise Geral<br>
      Listagem de Visitantes - <%=strTITULO%> <%
	  If strDT_INICIO <> "" And strDT_INICIO <> "" Then
	    Response.Write("<br>Período: " & PrepData(strDT_INICIO,True,False) & " a " & PrepData(strDT_FIM,True,False))
	  Else
	    Response.Write("<br>Período: Completo")
	  End If
	  %> </td>
  </tr>
  <tr> 
    <td width="334" class="arial12Bold"><a href="javascript:history.back();" class="Tahomacinza9"><img src="../img/bt_back.gif" width="15" height="15" border="0" align="absmiddle"> 
      voltar</a></td>
    <td width="306" align="right" class="arial12Bold"> <a href="javascript:window.print();" class="Tahomacinza9"><img src="../img/ico_impressora_mini.gif" border="0">imprimir</a>&nbsp;</td>
  </tr>
</table>
<table width="640" border="1" cellpadding="1" cellspacing="0" bordercolor="#FFFFFF" class="arial12">
  <%
 Select Case strORDERBY
   Case "CODIGO"
     strORDERBY = "tbl_Empresas.COD_EMPRESA"
   Case "NOME"
     strORDERBY = "tbl_Empresas.NOMECLI"
   Case "DATA"
     strORDERBY = "tbl_Empresas.SYS_DATACA"
   Case Else
     strORDERBY = "tbl_Empresas.NOMECLI"
 End Select

  
 If strCODATIV <> "" Then
   If (UCase(strCODATIV) = "INDEFINIDO" OR UCase(strCODATIV) = "000") Then
     strSQLClause = strSQLClause & "    AND ( tbl_Empresas.CODATIV1 = '000' OR tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 IS NULL ) "
   Else
     strSQLClause = strSQLClause & "    AND tbl_Empresas.CODATIV1 = '" & strCODATIV & "'"
   End If
 End If
 If strCOD_STATUS_CRED <> "" Then
   If UCase(strCOD_STATUS_CRED) = "INDEFINIDO" Then
     strSQLClause = strSQLClause & "    AND ( tbl_Status_cred.STATUS = '' OR tbl_tbl_status_cred.STATUS IS NULL ) "
   Else
     strSQLClause = strSQLClause & "    AND tbl_Empresas.COD_STATUS_CRED = " & strCOD_STATUS_CRED
   End If
 End If
 If strEND_ESTADO <> "" Then
   If UCase(strEND_ESTADO) = "INDEFINIDO" Then
     strSQLClause = strSQLClause & "    AND ( TRIM(tbl_Empresas.END_ESTADO) = '' OR tbl_Empresas.END_ESTADO IS NULL ) AND tbl_Empresas.END_PAIS = 'BRASIL' "
   Else
     strSQLClause = strSQLClause & "    AND tbl_Empresas.END_ESTADO = '" & strEND_ESTADO & "'"
   End If
 End If
 If strEND_PAIS <> "" Then
   If UCase(strEND_PAIS) = "INDEFINIDO" Then
     strSQLClause = strSQLClause & "    AND ( TRIM(tbl_Empresas.END_PAIS) = '' OR tbl_Empresas.END_PAIS IS NULL ) "
   Else
     strSQLClause = strSQLClause & "    AND tbl_Empresas.END_PAIS = '" & strEND_PAIS & "'"
   End If
 End If
 If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
   strSQLClause = strSQLClause & "    AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
 End If

   strSQL = " SELECT tbl_Empresas.COD_EMPRESA"  & _
				  " ,tbl_Empresas.SYS_DATACA"  & _
				  " ,tbl_Empresas.NOMECLI AS NOME"  & _
             " FROM  tbl_Empresas left join tbl_status_cred on tbl_Empresas.cod_status_Cred = tbl_status_cred.cod_status_cred" & _
			 " WHERE tbl_Empresas.SYS_INATIVO IS NULL "  & _
	         strSQLClause & _
             " ORDER BY " & strORDERBY & " " & strDIRECTION

'   response.write strSQL
'   response.end
   set objRS = objConn.Execute(strSQL)  

   Dim i, strTOT_INSCRICAO, strNOME_COMPLETO
   Dim strVLR_COMPRADO, strVLR_PAGO, strSALDO
   i = 0
%>
  <tr bgcolor="#FFCC66" class="arial12Bold"> 
    <td width="84" align="left"><a href="rel_analise_geral_lista.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&cod_status_preco=<%=strCOD_STATUS_PRECO%>&cod_ativ=<%=strCODATIV%>&end_estado=<%=strEND_ESTADO%>&order=CODIGO&direction=ASC"><img src="../_DBManager/gridlnkASC.gif" width="11" height="11" border="0" align="absmiddle"></a><a href="rel_analise_geral_lista.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&cod_status_preco=<%=strCOD_STATUS_PRECO%>&cod_ativ=<%=strCODATIV%>&end_estado=<%=strEND_ESTADO%>&order=CODIGO&direction=DESC"><img src="../_DBManager/gridlnkDESC.gif" width="11" height="11" border="0" align="absmiddle"></a>&nbsp;C&oacute;digo</td>
    <td width="425" align="left"><a href="rel_analise_geral_lista.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&cod_status_preco=<%=strCOD_STATUS_PRECO%>&cod_ativ=<%=strCODATIV%>&end_estado=<%=strEND_ESTADO%>&order=NOME&direction=ASC"><img src="../_DBManager/gridlnkASC.gif" width="11" height="11" border="0" align="absmiddle"></a><a href="rel_analise_geral_lista.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&cod_status_preco=<%=strCOD_STATUS_PRECO%>&cod_ativ=<%=strCODATIV%>&end_estado=<%=strEND_ESTADO%>&order=NOME&direction=DESC"><img src="../_DBManager/gridlnkDESC.gif" width="11" height="11" border="0" align="absmiddle"></a>&nbsp;Nome</td>
    <td width="117"><a href="rel_analise_geral_lista.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&cod_status_preco=<%=strCOD_STATUS_PRECO%>&cod_ativ=<%=strCODATIV%>&end_estado=<%=strEND_ESTADO%>&order=DATA&direction=ASC"><img src="../_DBManager/gridlnkASC.gif" width="11" height="11" border="0" align="absmiddle"></a><a href="rel_analise_geral_lista.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&cod_status_preco=<%=strCOD_STATUS_PRECO%>&cod_ativ=<%=strCODATIV%>&end_estado=<%=strEND_ESTADO%>&order=DATA&direction=DESC"><img src="../_DBManager/gridlnkDESC.gif" width="11" height="11" border="0" align="absmiddle"></a>&nbsp;Data 
      Cadastro</td>
  </tr>
  <%
   strNOME_COMPLETO = ""
   Do While Not objRS.EOF  
     strNOME_COMPLETO = objRS("NOME")
%>
  <tr bgcolor="#FFE8B7" class="arial12"> 
    <td align="left">&nbsp;<%=AthFormataTamLeft(objRS("COD_EMPRESA"),6,"0")%></td>
    <td align="left">&nbsp;<%=strNOME_COMPLETO%></td>
    <td align="center">&nbsp;<%=PrepData(objRS("SYS_DATACA"),True,False)%></td>
  </tr>
<%	
     i = i + 1
  	 objRS.MoveNext
	 If i mod 50 = 0 Then
	   Response.Flush()
	 End If
   Loop
%>
</table>
<%
   FechaRecordSet ObjRS
   FechaDBConn ObjConn
%>
<table width="640" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="329" class="arial10"><%=AthFormataTamLeft(i,5,"0")%> registro(s)</td>
    <td width="303" align="right" class="arial10">Gerado em <%=PrepData(now(),true,true)%></td>
  </tr>
</table>
</body>
</html>
<%
Response.Flush()
%>