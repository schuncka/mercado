<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.Expires = -1
 Server.ScriptTimeout = 1200

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
    <td align="center" class="arial12Bold">Relat&oacute;rio Visitantes 02 - An&aacute;lise 
      do Cadastro - Por Atividade 
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
    <td colspan="3" align="center" class="arial12Bold">EXTERIOR</td>
  </tr>
  <tr bgcolor='#FFD988'> 
    <td width="430" class="arial12Bold">ATIVIDADE</td>
    <td width="70" align="center" class="arial12Bold">PF</td>
    <td width="70" align="center" class="arial12Bold">PJ</td>
    <td width="70" align="center" class="arial12Bold">Contato</td>
    <td width="70" align="center" class="arial12Bold">PF</td>
    <td width="70" align="center" class="arial12Bold">PJ</td>
    <td width="70" align="center" class="arial12Bold">Contato</td>
  </tr>
  <%
Dim strCONT_PF, strCONT_PF_TOTAL, strCONT_PJ, strCONT_PJ_TOTAL, strCONT_PJ_CONTATO, strCONT_PJ_CONTATO_TOTAL
strCONT_PF_TOTAL = 0
strCONT_PJ_TOTAL = 0
strCONT_PJ_CONTATO_TOTAL = 0

Dim strCONT_PF_EXT, strCONT_PF_EXT_TOTAL, strCONT_PJ_EXT, strCONT_PJ_EXT_TOTAL, strCONT_PJ_EXT_CONTATO, strCONT_PJ_EXT_CONTATO_TOTAL
strCONT_PF_EXT_TOTAL = 0
strCONT_PJ_EXT_TOTAL = 0
strCONT_PJ_EXT_CONTATO_TOTAL = 0

	' SELECAO DAS ATIVIDADES PAI (CODATIV_PAI IS NULL)
    strSQL =          "  SELECT "
    strSQL = strSQL & "   tbl_Atividade.CODATIV "
	strSQL = strSQL & " , tbl_Atividade.ATIVMINI"
	strSQL = strSQL & " , tbl_Atividade.ATIVIDADE"
	strSQL = strSQL & "   FROM tbl_Atividade "
	strSQL = strSQL & "  WHERE tbl_Atividade.CODATIV_PAI IS NULL "
	strSQL = strSQL & "  ORDER BY tbl_Atividade.CODATIV, tbl_Atividade.ATIVMINI "

' Response.Write(strSQL)
' Response.End()
	  
	Dim strCODATIV, strCODATIV1, strATIVIDADE
    strTOT_CADASTRO = 0

    strCODATIV   = ""
	strCODATIV1  = ""
    strATIVIDADE = ""
	
	i = 0

    set objRS = objConn.Execute(strSQL)  
    Do While Not objRS.EOF    

      strATIVIDADE = objRS("ATIVIDADE")&""
      strCODATIV = Trim(objRS("CODATIV")&"")

%>
  <tr bgcolor='#FFE8B7'> 
    <td><b>(<%=Trim(UCase(strCODATIV))%>) <%=strATIVIDADE%></b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b>
      <%
	' Totalização por ATIVIDADE
	strCONT_PF = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas LEFT OUTER JOIN tbl_Atividade ON (tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'S' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS = 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000' Or tbl_Atividade.CODATIV_PAI = '' OR tbl_Atividade.CODATIV_PAI = '000') "
	Else
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '" & objRS("CODATIV") & "' OR tbl_Atividade.CODATIV_PAI = '" & objRS("CODATIV") & "')"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PF = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PF)
	
	strCONT_PF_TOTAL = Clng(strCONT_PF_TOTAL) + Clng(strCONT_PF)
	%> 
      </b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b>
      <%
	' Totalização por ATIVIDADE
	strCONT_PJ = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas LEFT OUTER JOIN tbl_Atividade ON (tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS = 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepData(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000' Or tbl_Atividade.CODATIV_PAI = '' OR tbl_Atividade.CODATIV_PAI = '000') "
	Else
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '" & objRS("CODATIV") & "' OR tbl_Atividade.CODATIV_PAI = '" & objRS("CODATIV") & "')"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PJ = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PJ)
	
	strCONT_PJ_TOTAL = Clng(strCONT_PJ_TOTAL) + Clng(strCONT_PJ)
	%> 
      </b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b>
      <%
	' Totalização por ATIVIDADE
	strCONT_PJ_CONTATO = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas_Sub.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas LEFT OUTER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)"
	strSQL = strSQL & "                     LEFT OUTER JOIN tbl_Atividade ON (tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS = 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000' Or tbl_Atividade.CODATIV_PAI = '' OR tbl_Atividade.CODATIV_PAI = '000') "
	Else
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '" & objRS("CODATIV") & "' OR tbl_Atividade.CODATIV_PAI = '" & objRS("CODATIV") & "')"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PJ_CONTATO = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PJ_CONTATO)
	
	strCONT_PJ_CONTATO_TOTAL = Clng(strCONT_PJ_CONTATO_TOTAL) + Clng(strCONT_PJ_CONTATO)
	%> 
      </b></td>
    <td align="center"> 
      <b>
      <%
	' Totalização por ATIVIDADE
	strCONT_PF_EXT = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas LEFT OUTER JOIN tbl_Atividade ON (tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'S' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS <> 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000' Or tbl_Atividade.CODATIV_PAI = '' OR tbl_Atividade.CODATIV_PAI = '000') "
	Else
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '" & objRS("CODATIV") & "' OR tbl_Atividade.CODATIV_PAI = '" & objRS("CODATIV") & "')"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PF_EXT = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PF_EXT)
	
	strCONT_PF_EXT_TOTAL = Clng(strCONT_PF_EXT_TOTAL) + Clng(strCONT_PF_EXT)
	%>	
      </b></td>
    <td align="center"> 
      <b>
      <%
	' Totalização por ATIVIDADE
	strCONT_PJ_EXT = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas LEFT OUTER JOIN tbl_Atividade ON (tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS <> 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000' Or tbl_Atividade.CODATIV_PAI = '' OR tbl_Atividade.CODATIV_PAI = '000') "
	Else
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '" & objRS("CODATIV") & "' OR tbl_Atividade.CODATIV_PAI = '" & objRS("CODATIV") & "')"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PJ_EXT = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PJ_EXT)
	
	strCONT_PJ_EXT_TOTAL = Clng(strCONT_PJ_EXT_TOTAL) + Clng(strCONT_PJ_EXT)
	%>    
      </b></td>
    <td align="center"> 
      <b>
      <%
	' Totalização por ATIVIDADE
	strCONT_PJ_EXT_CONTATO = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas_Sub.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas LEFT OUTER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)"
	strSQL = strSQL & "                      LEFT OUTER JOIN tbl_Atividade ON (tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS <> 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000' Or tbl_Atividade.CODATIV_PAI = '' OR tbl_Atividade.CODATIV_PAI = '000') "
	Else
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '" & objRS("CODATIV") & "' OR tbl_Atividade.CODATIV_PAI = '" & objRS("CODATIV") & "')"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PJ_EXT_CONTATO = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PJ_EXT_CONTATO)
	
	strCONT_PJ_EXT_CONTATO_TOTAL = Clng(strCONT_PJ_EXT_CONTATO_TOTAL) + Clng(strCONT_PJ_EXT_CONTATO)
	%>    
      </b></td>
  </tr>
  <%
  '==========================================
  'AQUI MOSTRA AS DIVISOES DA ATIVIDADE PAI
  '==========================================
		' Totalização por ATIVIDADE
		strSQL =          "  SELECT "
		strSQL = strSQL & "    tbl_Atividade.CODATIV "
		strSQL = strSQL & "  , tbl_Atividade.ATIVMINI"
		strSQL = strSQL & "  , tbl_Atividade.ATIVIDADE"
		strSQL = strSQL & "   FROM tbl_Atividade"
		strSQL = strSQL & "  WHERE tbl_Atividade.CODATIV_PAI = " & objRS("CODATIV")
		strSQL = strSQL & "  ORDER BY tbl_Atividade.CODATIV, tbl_Atividade.ATIVMINI "
        
		Set objRSDetailSub = objConn.Execute(strSQL)
		
		Do While not objRSDetailSub.EOF
		  strATIVIDADE = objRSDetailSub("ATIVIDADE")&""
          strCODATIV = Trim(objRSDetailSub("CODATIV")&"")
  %>
  <tr bgcolor='#F2F2F2'> 
    <td>&nbsp;&nbsp;(<%=Trim(UCase(strCODATIV))%>) <%=strATIVIDADE%></td>
    <td align="center"> 
      <%
	' Totalização por ATIVIDADE
	strCONT_PF = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'S' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS = 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000') "
	Else
	  strSQL = strSQL & "    AND tbl_Empresas.CODATIV1 = '" & objRSDetailSub("CODATIV") & "'"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PF = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PF)
	
'	strCONT_PF_TOTAL = Clng(strCONT_PF_TOTAL) + Clng(strCONT_PF)
	%> 
      </td>
    <td align="center"> 
      <%
	' Totalização por ATIVIDADE
	strCONT_PJ = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS = 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepData(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000') "
	Else
	  strSQL = strSQL & "    AND tbl_Empresas.CODATIV1 = '" & objRSDetailSub("CODATIV") & "'"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PJ = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PJ)
	
'	strCONT_PJ_TOTAL = Clng(strCONT_PJ_TOTAL) + Clng(strCONT_PJ)
	%> 
      </td>
    <td align="center"> 
      <%
	' Totalização por ATIVIDADE
	strCONT_PJ_CONTATO = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas_Sub.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas LEFT OUTER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS = 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000') "
	Else
	  strSQL = strSQL & "    AND tbl_Empresas.CODATIV1 = '" & objRSDetailSub("CODATIV") & "'"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PJ_CONTATO = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PJ_CONTATO)
	
'	strCONT_PJ_CONTATO_TOTAL = Clng(strCONT_PJ_CONTATO_TOTAL) + Clng(strCONT_PJ_CONTATO)
	%> 
     </td>
    <td align="center"> 
      <%
	' Totalização por ATIVIDADE
	strCONT_PF_EXT = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'S' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS <> 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000') "
	Else
	  strSQL = strSQL & "    AND tbl_Empresas.CODATIV1 = '" & objRSDetailSub("CODATIV") & "'"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PF_EXT = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PF_EXT)
	
'	strCONT_PF_EXT_TOTAL = Clng(strCONT_PF_EXT_TOTAL) + Clng(strCONT_PF_EXT)
	%>	
    </td>
    <td align="center"> 
      <%
	' Totalização por ATIVIDADE
	strCONT_PJ_EXT = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS <> 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000') "
	Else
	  strSQL = strSQL & "    AND tbl_Empresas.CODATIV1 = '" & objRSDetailSub("CODATIV") & "'"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PJ_EXT = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PJ_EXT)
	
'	strCONT_PJ_EXT_TOTAL = Clng(strCONT_PJ_EXT_TOTAL) + Clng(strCONT_PJ_EXT)
	%>    
    </td>
    <td align="center"> 
      <%
	' Totalização por ATIVIDADE
	strCONT_PJ_EXT_CONTATO = 0 
    strSQL =          "  SELECT COUNT(tbl_Empresas_Sub.COD_EMPRESA) AS TOT_CADASTRO "
	strSQL = strSQL & "   FROM tbl_Empresas LEFT OUTER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)"
	strSQL = strSQL & "  WHERE tbl_Empresas.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND tbl_Empresas.TIPO_PESS = 'N' "
	strSQL = strSQL & "    AND tbl_Empresas.END_PAIS <> 'BRASIL' "
    If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
      strSQL = strSQL & "      AND tbl_Empresas.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
    End If
	If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
      strSQL = strSQL & "      AND tbl_Empresas.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
    End If
	If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
	  strSQL = strSQL & "    AND (tbl_Empresas.CODATIV1 = '' OR tbl_Empresas.CODATIV1 = '000') "
	Else
	  strSQL = strSQL & "    AND tbl_Empresas.CODATIV1 = '" & objRSDetailSub("CODATIV") & "'"
	End If
    Set objRSDetail = objConn.Execute(strSQL)
	If not objRSDetail.EOF Then
	  strCONT_PJ_EXT_CONTATO = objRSDetail("TOT_CADASTRO")
	End If
	FechaRecordSet objRSDetail
	Response.Write(strCONT_PJ_EXT_CONTATO)
	
'	strCONT_PJ_EXT_CONTATO_TOTAL = Clng(strCONT_PJ_EXT_CONTATO_TOTAL) + Clng(strCONT_PJ_EXT_CONTATO)
	%>    
    </td>
  </tr>
  <%
          objRSDetailSub.MoveNext
          Response.Flush()
		  
        Loop
		FechaRecordSet objRSDetailSub
		
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