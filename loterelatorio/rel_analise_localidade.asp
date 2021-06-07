<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.Expires = -1
 Server.ScriptTimeout = 2400

 Dim strDT_INICIO, strDT_FIM
 Dim strCEP_INICIO, strCEP_FIM

 strDT_INICIO = Replace(Request("var_dt_inicio"),"'","")
 strDT_FIM = Replace(Request("var_dt_fim"),"'","")
 
 strCEP_INICIO = Replace(Request("var_cep_inicio"),"'","")
 strCEP_FIM = Replace(Request("var_cep_fim"),"'","")
 
' Response.Write("<BR>"&strCEP_INICIO)
' Response.Write("<BR>"&strCEP_FIM)
 
 If not IsDate(strDT_INICIO) Then
   strDT_INICIO = ""
 End If
 If not IsDate(strDT_FIM) Then
   strDT_FIM = ""
 End If

 Dim strTOT_CADASTRO, i, strBgColor

 Dim objConn, ObjRS, objRSDetail, objRSDetailSub
 Dim strSQL, strSQLClause
 
 AbreDBConn objConn, CFG_DB_DADOS 
 
 Response.Buffer = True
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
</head>
<body text="#916E28" link="#916E28" vlink="#916E28" alink="#916E28" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="640" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td align="center" class="arial10">&nbsp;</td>
  </tr>
  <tr> 
    <td align="center" class="arial12Bold">RC03 - An&aacute;lise 
      do Cadastro - Por Estado/Pa&iacute;s 
      <%
	  If strDT_INICIO = "" And strDT_FIM = "" And strCEP_INICIO = "" And strCEP_FIM = "" Then
	    Response.Write("<br>Listagem completa")
	  Else
	    If strDT_INICIO <> "" And strDT_FIM <> "" Then
	      Response.Write("<br>Período: " & PrepData(strDT_INICIO,True,False) & " a " & PrepData(strDT_FIM,True,False))
	    End If
	    If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
	      Response.Write("<br>CEP: " & strCEP_INICIO & " até " & strCEP_FIM)
	    End If	    
	  End If
	  %>
    </td>
  </tr>
  <tr> 
    <td align="right" class="arial12Bold"><a href="javascript:window.print();" class="Tahomacinza9"><img src="../img/ico_impressora_mini.gif" border="0">imprimir</a></td>
  </tr>
</table>
<table width="640" border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" class="arial12">
  <tr bgcolor='#FFD988'> 
    <td class="arial12Bold">&nbsp;</td>
    <td colspan="3" align="center" class="arial12Bold">BRASIL</td>
  </tr>
  <tr bgcolor='#FFD988'> 
    <td class="arial12Bold">Estado</td>
    <td width="70" align="center" class="arial12Bold">PF</td>
    <td width="70" align="center" class="arial12Bold">PJ</td>
    <td width="70" align="center" class="arial12Bold">Contato</td>
  </tr>
  <%
Dim strCONT_PF, strCONT_PF_TOTAL, strCONT_PJ, strCONT_PJ_TOTAL, strCONT_PJ_CONTATO, strCONT_PJ_CONTATO_TOTAL
strCONT_PF_TOTAL = 0
strCONT_PJ_TOTAL = 0
strCONT_PJ_CONTATO_TOTAL = 0

	' SELECAO DOS ESTADOS DO BRASIL
    strSQL =          "  SELECT "
    strSQL = strSQL & "   if(end_estado is null or end_estado = '','',end_estado) as END_ESTADO "
	strSQL = strSQL & " , COUNT(*) AS TOTAL"
	strSQL = strSQL & "   FROM tbl_Empresas "
	strSQL = strSQL & "  WHERE SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND END_PAIS = 'BRASIL' "
	strSQL = strSQL & "  GROUP BY 1 "
	strSQL = strSQL & "  ORDER BY 1 "

' Response.Write(strSQL)
' Response.End()
	  
	Dim strEND_ESTADO, strEND_ESTADO_TOTAL
	
    strTOT_CADASTRO = 0
	strEND_ESTADO_TOTAL = 0
	strEND_ESTADO = ""
	
	i = 0

    set objRS = objConn.Execute(strSQL)  
    Do While Not objRS.EOF    

      strEND_ESTADO = objRS("END_ESTADO")&""
      strEND_ESTADO_TOTAL = objRS("TOTAL")&""
	  
		' Totalização por ATIVIDADE de CADASTROS do BRASIL agrupados por TIPO_PESS e ATIVIDADE PAI
		strCONT_PF = 0 
		strCONT_PJ = 0 
		
		strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO, tbl_Empresas.TIPO_PESS "
		strSQL = strSQL & "   FROM tbl_Empresas "
		strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
		strSQL = strSQL & "    AND tbl_Empresas.END_PAIS = 'BRASIL' "
		If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
		  strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
		End If
		If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
		  strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
		End If
		If strEND_ESTADO&"" = "" Then
		  strSQL = strSQL & "    AND (trim(tbl_Empresas.END_ESTADO = '') OR tbl_Empresas.END_ESTADO IS NULL) "
		Else
		  strSQL = strSQL & "    AND (tbl_Empresas.END_ESTADO = '" & strEND_ESTADO & "')"
		End If
		strSQL = strSQL & " GROUP BY  tbl_Empresas.TIPO_PESS "
		
		Set objRSDetail = objConn.Execute(strSQL)
		If not objRSDetail.EOF Then
		  Do While not objRSDetail.EOF
		  
		    If objRSDetail("TIPO_PESS") = "S" Then
		      strCONT_PF = objRSDetail("TOT_CADASTRO")
			End If
			
			If objRSDetail("TIPO_PESS") = "N" Then
			  strCONT_PJ = objRSDetail("TOT_CADASTRO")
			End If
			
			objRSDetail.MoveNext
		  Loop
		End If
		FechaRecordSet objRSDetail
		
		strCONT_PF_TOTAL = Clng(strCONT_PF_TOTAL) + Clng(strCONT_PF)
		strCONT_PJ_TOTAL = Clng(strCONT_PJ_TOTAL) + Clng(strCONT_PJ)


		' Totalização por ATIVIDADE de CONTATOS DE CADASTROS (PESSOA JURIDICA) agrupados por ORIGEM - (BRASIL ou EXTERIOR)
		strCONT_PJ_CONTATO = 0 
		
		strSQL =          "  SELECT tbl_Empresas.END_ESTADO AS ORIGEM, COUNT(tbl_Empresas_Sub.COD_EMPRESA) AS TOT_CADASTRO "
		strSQL = strSQL & "   FROM tbl_Empresas LEFT JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)"
		strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
		strSQL = strSQL & "    AND tbl_Empresas.END_PAIS = 'BRASIL' "
		strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
		If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
		  strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
		End If
		If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
		  strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
		End If
		If strEND_ESTADO&"" = "" Then
		  strSQL = strSQL & "    AND (trim(tbl_Empresas.END_ESTADO = '') OR tbl_Empresas.END_ESTADO IS NULL) "
		Else
		  strSQL = strSQL & "    AND (tbl_Empresas.END_ESTADO = '" & strEND_ESTADO & "')"
		End If
		strSQL = strSQL & " GROUP BY  1 "
		
		
		Set objRSDetail = objConn.Execute(strSQL)
		If not objRSDetail.EOF Then
		  strCONT_PJ_CONTATO = objRSDetail("TOT_CADASTRO")
		End If
		FechaRecordSet objRSDetail
		
		strCONT_PJ_CONTATO_TOTAL = Clng(strCONT_PJ_CONTATO_TOTAL) + Clng(strCONT_PJ_CONTATO)
%>
  <tr bgcolor='#FFE8B7'> 
    <td><b><%=strEND_ESTADO%></b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b>
      <% Response.Write(strCONT_PF) %> 
      </b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b>
      <% Response.Write(strCONT_PJ) %> 
      </b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b><% Response.Write(strCONT_PJ_CONTATO) %></b></td>
  </tr>
  <%
      objRS.MoveNext
	  Response.Flush()
	  i = i + 1

    Loop
	FechaRecordSet objRS
%>
  <tr bgcolor='#FFD988'> 
    <td class="arial12Bold">&nbsp;</td>
    <td align="center" class="arial12Bold"><%=strCONT_PF_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_CONTATO_TOTAL%></td>
  </tr>
</table>

<br>

<table width="640" border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" class="arial12">
  <tr bgcolor='#FFD988'>
    <td class="arial12Bold">&nbsp;</td>
    <td colspan="3" align="center" class="arial12Bold">EXTERIOR</td>
  </tr>
  <tr bgcolor='#FFD988'>
    <td class="arial12Bold">Pa&iacute;s</td>
    <td width="70" align="center" class="arial12Bold">PF</td>
    <td width="70" align="center" class="arial12Bold">PJ</td>
    <td width="70" align="center" class="arial12Bold">Contato</td>
  </tr>
  <%
Dim strCONT_PF_EXT, strCONT_PF_EXT_TOTAL, strCONT_PJ_EXT, strCONT_PJ_EXT_TOTAL, strCONT_PJ_EXT_CONTATO, strCONT_PJ_EXT_CONTATO_TOTAL
strCONT_PF_EXT_TOTAL = 0
strCONT_PJ_EXT_TOTAL = 0
strCONT_PJ_EXT_CONTATO_TOTAL = 0

	' SELECAO DOS PAISES DIFERENTE DE BRASIL
    strSQL =          "  SELECT "
    strSQL = strSQL & "   if(end_pais is null or end_pais = '','',end_pais) as END_PAIS "
	strSQL = strSQL & " , COUNT(*) AS TOTAL"
	strSQL = strSQL & "   FROM tbl_Empresas "
	strSQL = strSQL & "  WHERE SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND END_PAIS <> 'BRASIL' "
	strSQL = strSQL & "  GROUP BY 1 "
	strSQL = strSQL & "  ORDER BY 1 "

' Response.Write(strSQL)
' Response.End()
	  
	Dim strEND_PAIS, strEND_PAIS_TOTAL
	
    strTOT_CADASTRO = 0
	strEND_PAIS_TOTAL = 0
	strEND_PAIS = ""
	
	i = 0

    set objRS = objConn.Execute(strSQL)  
    Do While Not objRS.EOF    

      strEND_PAIS = objRS("END_PAIS")&""
      strEND_PAIS_TOTAL = objRS("TOTAL")&""
	  
		' Totaliza&ccedil;&atilde;o por ATIVIDADE de CADASTROS do BRASIL agrupados por TIPO_PESS e ATIVIDADE PAI
		strCONT_PF_EXT = 0 
		strCONT_PJ_EXT = 0 
		
		strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO, tbl_Empresas.TIPO_PESS "
		strSQL = strSQL & "   FROM tbl_Empresas "
		strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
		strSQL = strSQL & "    AND tbl_Empresas.END_PAIS <> 'BRASIL' "
		If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
		  strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
		End If
		If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
		  strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
		End If
		If strEND_PAIS&"" = "" Then
		  strSQL = strSQL & "    AND (trim(tbl_Empresas.END_PAIS = '') OR tbl_Empresas.END_PAIS IS NULL) "
		Else
		  strSQL = strSQL & "    AND (tbl_Empresas.END_PAIS = '" & strEND_PAIS & "')"
		End If
		strSQL = strSQL & " GROUP BY  tbl_Empresas.TIPO_PESS "
		
		Set objRSDetail = objConn.Execute(strSQL)
		If not objRSDetail.EOF Then
		  Do While not objRSDetail.EOF
		  
		    If objRSDetail("TIPO_PESS") = "S" Then
		      strCONT_PF_EXT = objRSDetail("TOT_CADASTRO")
			End If
			
			If objRSDetail("TIPO_PESS") = "N" Then
			  strCONT_PJ_EXT = objRSDetail("TOT_CADASTRO")
			End If
			
			objRSDetail.MoveNext
		  Loop
		End If
		FechaRecordSet objRSDetail
		
	strCONT_PF_EXT_TOTAL = Clng(strCONT_PF_EXT_TOTAL) + Clng(strCONT_PF_EXT)
	strCONT_PJ_EXT_TOTAL = Clng(strCONT_PJ_EXT_TOTAL) + Clng(strCONT_PJ_EXT)
		
		' Totaliza&ccedil;&atilde;o por ATIVIDADE de CONTATOS DE CADASTROS (PESSOA JURIDICA) agrupados por ORIGEM - (BRASIL ou EXTERIOR)
		strCONT_PJ_EXT_CONTATO = 0
		
		strSQL =          "  SELECT tbl_Empresas.END_ESTADO AS ORIGEM, COUNT(tbl_Empresas_Sub.COD_EMPRESA) AS TOT_CADASTRO "
		strSQL = strSQL & "   FROM tbl_Empresas LEFT JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)"
		strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
		strSQL = strSQL & "    AND tbl_Empresas.END_PAIS <> 'BRASIL' "
		strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
		If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
		  strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
		End If
		If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
		  strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
		End If
		If strEND_PAIS&"" = "" Then
		  strSQL = strSQL & "    AND (trim(tbl_Empresas.END_PAIS = '') OR tbl_Empresas.END_PAIS IS NULL) "
		Else
		  strSQL = strSQL & "    AND (tbl_Empresas.END_PAIS = '" & strEND_PAIS & "')"
		End If
		strSQL = strSQL & " GROUP BY  1 "
		
		
		Set objRSDetail = objConn.Execute(strSQL)
		If not objRSDetail.EOF Then		  
		  strCONT_PJ_EXT_CONTATO = objRSDetail("TOT_CADASTRO")
		End If
		FechaRecordSet objRSDetail
		
		strCONT_PJ_EXT_CONTATO_TOTAL = Clng(strCONT_PJ_EXT_CONTATO_TOTAL) + Clng(strCONT_PJ_EXT_CONTATO)

%>
  <tr bgcolor='#FFE8B7'>
    <td><b><%=strEND_PAIS%></b></td>
    <td align="center"><b>
      <% Response.Write(strCONT_PF_EXT)	%>
    </b></td>
    <td align="center"><b>
      <% Response.Write(strCONT_PJ_EXT)	%>
    </b></td>
    <td align="center"><b>
      <% Response.Write(strCONT_PJ_EXT_CONTATO) %>
    </b></td>
  </tr>
  <%		
      objRS.MoveNext
	  Response.Flush()
	  i = i + 1

    Loop
	FechaRecordSet objRS
%>
  <tr bgcolor='#FFD988'>
    <td class="arial12Bold">&nbsp;</td>
    <td align="center" class="arial12Bold"><%=strCONT_PF_EXT_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_EXT_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_EXT_CONTATO_TOTAL%></td>
  </tr>
</table>
<table width="640" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td align="right" class="arial10">Gerado em <%=PrepData(now(),true,true)%></td>
  </tr>
</table>
</body>
</html>
<%
 Response.Flush
 
 FechaDBConn ObjConn
%>