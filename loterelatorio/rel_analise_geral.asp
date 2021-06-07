<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.Expires = -1

 Dim strDT_INICIO, strDT_FIM

 strDT_INICIO = Replace(Request("var_dt_inicio"),"'","")
 strDT_FIM = Replace(Request("var_dt_fim"),"'","")
 
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
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<title>ProEvento <%=Session("NOME_EVENTO")%> </title></head>
<body text="#916E28" link="#916E28" vlink="#916E28" alink="#916E28" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td align="center" class="arial10">&nbsp;</td>
  </tr>
  <tr> 
    <td align="center" class="arial12Bold">RC01 - An&aacute;lise 
      do Cadastro - Geral 
      <%
	  If strDT_INICIO <> "" And strDT_INICIO <> "" Then
	    Response.Write("<br>Período: " & PrepData(strDT_INICIO,True,False) & " a " & PrepData(strDT_FIM,True,False))
	  Else
	    Response.Write("<br>Listagem completa")
	  End If
	  %>
    </td>
  </tr>
  <tr> 
    <td align="right" class="arial12Bold"><a href="javascript:window.print();" class="Tahomacinza9"><img src="../img/ico_impressora_mini.gif" border="0">imprimir</a></td>
  </tr>
</table>
<table width="100%" border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" class="arial12">
  <tr bgcolor='#FFD988'> 
    <td width="170" class="arial12Bold">POR PA&Iacute;S</td>
    <td width="194" class="arial12Bold">POR ESTADO</td>
    <td width="256" class="arial12Bold">POR ATIVIDADE</td>
  </tr>
  <tr valign="top" bgcolor='#FFD988'> 
    <td align="center" class="arial12Bold"><table width="80%" border="0" cellpadding="3" cellspacing="0" class="arial12">
        <%
		
    Dim strPAIS, strEND_PAIS, cont

    ' Totalizacao por PAIS
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO, "
	strSQL = strSQL & "   if( (isnull(tbl_Empresas.END_PAIS) Or tbl_Empresas.END_PAIS = ''),' Indefinido',tbl_Empresas.END_PAIS) AS END_PAIS "
	strSQL = strSQL & "   FROM tbl_Empresas "
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00'  AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	strSQL = strSQL & "  GROUP BY if( (isnull(tbl_Empresas.END_PAIS) Or tbl_Empresas.END_PAIS = ''),'Indefinido',tbl_Empresas.END_PAIS)"
	strSQL = strSQL & "  ORDER BY 2"


    strTOT_CADASTRO = 0
    cont = 0  
    strPAIS = ""
    strEND_PAIS = ""
	i = 0

    set objRS = objConn.Execute(strSQL)  

    Do While Not objRS.EOF    

      If i mod 2 = 0 Then
	    strBgColor = "#FFE8B7"
	  Else
	    strBgColor = "#FFFFFF"
	  End If
	  cont = objRS("TOT_CADASTRO")
	  strPAIS = objRS("END_PAIS")
	  If IsNull(cont) Then
	    cont = 0
	  End If
	  i = i + 1
%>
        <tr> 
          <td width="80" bgcolor='<%=strBgColor%>'><a href="rel_analise_geral_lista.asp?end_pais=<%=UCase(Trim(strPAIS))%>&var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>"><%=strPAIS%></a></td>
          <td width="30" bgcolor='<%=strBgColor%>' align="right"><%=cont%></td>
        </tr>
        <%
      strTOT_CADASTRO = strTOT_CADASTRO + Clng(cont)
	  objRS.MoveNext
	Loop
	FechaRecordSet objRS
%>
        <tr class="arial12Bold"> 
          <td align="right">Total:</td>
          <td align="right"><%=strTOT_CADASTRO%></td>
        </tr>
      </table></td>
    <td align="center" class="arial12Bold"> 
        <%
    Dim strESTADO, strEND_ESTADO, strVLR_COMPRADO, strVLR_PAGO, strSALDO

    ' Totalizacao por ESTADO sendo PAIS = BRASIL
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO, "
	strSQL = strSQL & "   if( (isnull(tbl_Empresas.END_ESTADO) Or tbl_Empresas.END_ESTADO = ''),' Indefinido',tbl_Empresas.END_ESTADO) AS END_ESTADO "
	strSQL = strSQL & "   FROM tbl_Empresas"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS = 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	strSQL = strSQL & "  GROUP BY if( (isnull(tbl_Empresas.END_ESTADO) Or tbl_Empresas.END_ESTADO = ''),' Indefinido',tbl_Empresas.END_ESTADO)"
	strSQL = strSQL & "  ORDER BY 2"


    strTOT_CADASTRO = 0
    cont = 0  
    strESTADO = ""
    strEND_ESTADO = ""
	i = 0

    set objRS = objConn.Execute(strSQL)  
	If not objRS.EOF Then
	%>
	<table width="80%" border="0" cellpadding="3" cellspacing="0" class="arial12">
	<%

     Do While Not objRS.EOF    

      If i mod 2 = 0 Then
	    strBgColor = "#FFE8B7"
	  Else
	    strBgColor = "#FFFFFF"
	  End If
	  cont = objRS("TOT_CADASTRO")
	  strESTADO = objRS("END_ESTADO")
	  If IsNull(cont) Then
	    cont = 0
	  End If
	  i = i + 1
%>
        <tr> 
          <td width="100" bgcolor='<%=strBgColor%>'><a href="rel_analise_geral_lista.asp?end_estado=<%=UCase(Trim(strESTADO))%>&var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>"><%=strESTADO%></a></td>
          <td width="30" bgcolor='<%=strBgColor%>' align="right"><%=cont%></td>
        </tr>
        <%
      strTOT_CADASTRO = strTOT_CADASTRO + Clng(cont)
	  objRS.MoveNext
	 Loop
	 FechaRecordSet objRS
%>
        <tr class="arial12Bold"> 
          <td align="right">Total:</td>
          <td align="right"><%=strTOT_CADASTRO%></td>
        </tr>
      </table>
	 <%
	 End If


    ' Totalizacao por ESTADO sendo PAIS <> BRASIL
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND (tbl_Empresas.END_PAIS <> 'BRASIL' OR tbl_Empresas.END_PAIS IS NULL)"
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	strSQL = strSQL & "  ORDER BY 1"


    strTOT_CADASTRO = 0
    cont = 0  
    strESTADO = ""
    strEND_ESTADO = ""

    set objRS = objConn.Execute(strSQL)  
	If not objRS.EOF Then
	%>
	<br>
	<table width="80%" border="0" cellpadding="3" cellspacing="0" class="arial12">
        <tr>
          <td colspan="2" bgcolor='<%=strBgColor%>'><b>Internacionais</b></td>
        </tr>
	<%
     i = 0
     Do While Not objRS.EOF    

	  strBgColor = "#FFFFFF"
	  cont = objRS("TOT_CADASTRO")
	  If IsNull(cont) Then
	    cont = 0
	  End If
	  i = i + 1
%>

        <tr> 
          <td width="100" bgcolor='<%=strBgColor%>'>Demais Cidades</td>
          <td width="30" bgcolor='<%=strBgColor%>' align="right"><%=cont%></td>
        </tr>
        <%
      strTOT_CADASTRO = strTOT_CADASTRO + Clng(cont)
	  objRS.MoveNext
	 Loop
	 FechaRecordSet objRS
%>
        <tr class="arial12Bold"> 
          <td align="right">Total:</td>
          <td align="right"><%=strTOT_CADASTRO%></td>
        </tr>
      </table>
	 <%
	 End If

	 %>
	</td>
    <td align="center" class="arial12Bold"> <table width="80%" border="0" cellpadding="3" cellspacing="0" class="arial12">
        <%
	' Totalização por ATIVIDADE
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO, "
    strSQL = strSQL & "   if( (isnull(tbl_Empresas.CODATIV1) Or tbl_Empresas.CODATIV1 = '' Or tbl_Empresas.CODATIV1 = '000'),'000',tbl_Empresas.CODATIV1) AS CODATIV1, "
	strSQL = strSQL & "   if( (isnull(tbl_Empresas.CODATIV1) Or tbl_Empresas.CODATIV1 = '' Or tbl_Empresas.CODATIV1 = '000'),' A CLASSIFICAR',tbl_Atividade.ATIVIDADE) AS ATIVIDADE"
	strSQL = strSQL & "   FROM tbl_Empresas LEFT OUTER JOIN tbl_Atividade ON (tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
    strSQL = strSQL & "  GROUP BY if( (isnull(tbl_Empresas.CODATIV1) Or tbl_Empresas.CODATIV1 = '' Or tbl_Empresas.CODATIV1 = '000'),'000',tbl_Empresas.CODATIV1), "
	strSQL = strSQL & "           if( (isnull(tbl_Empresas.CODATIV1) Or tbl_Empresas.CODATIV1 = '' Or tbl_Empresas.CODATIV1 = '000'),' A CLASSIFICAR',tbl_Atividade.ATIVIDADE)"
	strSQL = strSQL & "  ORDER BY 2, 3 "

'Response.Write(strSQL)
' Response.End()
	  
	Dim strCODATIV1, strATIVIDADE
    strTOT_CADASTRO = 0
    cont = 0  
    strCODATIV1 = ""
    strATIVIDADE = ""
	i = 0

    set objRS = objConn.Execute(strSQL)  
    Do While Not objRS.EOF    


      strCODATIV1 = objRS("CODATIV1")&""
      strATIVIDADE = objRS("ATIVIDADE")&""

	  If strATIVIDADE = "" Then
	    strATIVIDADE = "INEXISTENTE - " & strCODATIV1
	  End If

	  cont = objRS("TOT_CADASTRO")
	  
      If i mod 2 = 0 Then
        strBgColor = "#FFE8B7"
	  Else
	    strBgColor = "#FFFFFF"
	  End If
	  If IsNull(cont) Then
	    cont = 0
	  End If
%>
        <tr>
          <td width="160" bgcolor='<%=strBgColor%>'><a href="rel_analise_geral_lista.asp?cod_ativ=<%=UCase(Trim(strCODATIV1))%>&var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>"><%=strATIVIDADE%></a></td>
          <td width="30" bgcolor='<%=strBgColor%>' align="right"><%=cont%></td>
        </tr>
        <%
      strTOT_CADASTRO = strTOT_CADASTRO + clng(cont)
      i = i + 1
      objRS.MoveNext
    Loop
	FechaRecordSet objRS
%>
        <tr class="arial12Bold">
          <td align="right">Total:</td>
          <td align="right"><%=strTOT_CADASTRO%></td>
        </tr>
      </table></td>
  </tr>
  <tr valign="top" bgcolor='#FFD988'>
    <td class="arial12Bold">POR CREDENCIAL</td>
    <td class="arial12Bold">&nbsp;</td>
    <td class="arial12Bold">&nbsp;</td>
  </tr>
  <tr valign="top" bgcolor='#FFD988'>
    <td align="center" class="arial12Bold"><table width="80%" border="0" cellpadding="3" cellspacing="0" class="arial12">
      <%
	' Totaliza&ccedil;&atilde;o por ATIVIDADE
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO, "
    strSQL = strSQL & "   if( isnull(tbl_Status_Cred.STATUS) or (tbl_Status_Cred.STATUS = ''),null,tbl_Status_Cred.COD_STATUS_CRED) AS COD_STATUS_CRED, "
	strSQL = strSQL & "   if( isnull(tbl_Status_Cred.STATUS) or (tbl_Status_Cred.STATUS = ''),' A CLASSIFICAR',tbl_Status_Cred.STATUS) AS CREDENCIAL"
	strSQL = strSQL & "   FROM tbl_Empresas LEFT JOIN tbl_Status_Cred ON (tbl_Empresas.COD_STATUS_CRED = tbl_Status_Cred.COD_STATUS_CRED)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
    strSQL = strSQL & "  GROUP BY 2"
	strSQL = strSQL & "  ORDER BY 3 "

'Response.Write(strSQL)
'Response.End()
	  
	Dim strCOD_STATUS_CRED, strCREDENCIAL
    strTOT_CADASTRO = 0
    cont = 0  
    strCOD_STATUS_CRED = ""
    strCREDENCIAL = ""
	i = 0

    set objRS = objConn.Execute(strSQL)  
    Do While Not objRS.EOF    


      strCOD_STATUS_CRED = objRS("COD_STATUS_CRED")&""
      strCREDENCIAL = objRS("CREDENCIAL")&""

	  If strCREDENCIAL = "" Then
	    strCREDENCIAL = "INEXISTENTE - " & strCODATIV1
	  End If

	  cont = objRS("TOT_CADASTRO")
	  
      If i mod 2 = 0 Then
        strBgColor = "#FFE8B7"
	  Else
	    strBgColor = "#FFFFFF"
	  End If
	  If IsNull(cont) Then
	    cont = 0
	  End If
%>
      <tr>
        <td width="160" bgcolor='<%=strBgColor%>'><a href="rel_analise_geral_lista.asp?cod_status_cred=<%=UCase(Trim(strCOD_STATUS_CRED))%>&var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>"><%=strCREDENCIAL%></a></td>
        <td width="30" bgcolor='<%=strBgColor%>' align="right"><%=cont%></td>
      </tr>
      <%
      strTOT_CADASTRO = strTOT_CADASTRO + clng(cont)
      i = i + 1
      objRS.MoveNext
    Loop
	FechaRecordSet objRS
%>
      <tr class="arial12Bold">
        <td align="right">Total:</td>
        <td align="right"><%=strTOT_CADASTRO%></td>
      </tr>
    </table></td>
    <td align="center" class="arial12Bold">&nbsp;</td>
    <td align="center" class="arial12Bold">&nbsp;</td>
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
 FechaDBConn ObjConn
%>