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
    <td align="center" class="arial12Bold">RC04 - An&aacute;lise 
      do Cadastro Internacional - Por Atividade 
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
    <td colspan="3" align="center" class="arial12Bold">INGL&Ecirc;S</td>
    <td colspan="3" align="center" class="arial12Bold">ESPANHOL</td>
    <td colspan="3" align="center" class="arial12Bold">PORTUGUÊS</td>
  </tr>
  <tr bgcolor='#FFD988'> 
    <td width="430" class="arial12Bold">ATIVIDADE</td>
    <td width="70" align="center" class="arial12Bold">PF</td>
    <td width="70" align="center" class="arial12Bold">PJ</td>
    <td width="70" align="center" class="arial12Bold">Contato</td>
    <td width="70" align="center" class="arial12Bold">PF</td>
    <td width="70" align="center" class="arial12Bold">PJ</td>
    <td width="70" align="center" class="arial12Bold">Contato</td>
    <td width="70" align="center" class="arial12Bold">PF</td>
    <td width="70" align="center" class="arial12Bold">PJ</td>
    <td width="70" align="center" class="arial12Bold">Contato</td>
  </tr>
  <%
Dim strCONT_PF_I, strCONT_PF_I_TOTAL, strCONT_PJ_I, strCONT_PJ_I_TOTAL, strCONT_PJ_I_CONTATO, strCONT_PJ_I_CONTATO_TOTAL
strCONT_PF_I_TOTAL = 0
strCONT_PJ_I_TOTAL = 0
strCONT_PJ_I_CONTATO_TOTAL = 0

Dim strCONT_PF_E, strCONT_PF_E_TOTAL, strCONT_PJ_E, strCONT_PJ_E_TOTAL, strCONT_PJ_E_CONTATO, strCONT_PJ_E_CONTATO_TOTAL
strCONT_PF_E_TOTAL = 0
strCONT_PJ_E_TOTAL = 0
strCONT_PJ_E_CONTATO_TOTAL = 0

Dim strCONT_PF_P, strCONT_PF_P_TOTAL, strCONT_PJ_P, strCONT_PJ_P_TOTAL, strCONT_PJ_P_CONTATO, strCONT_PJ_P_CONTATO_TOTAL
strCONT_PF_P_TOTAL = 0
strCONT_PJ_P_TOTAL = 0
strCONT_PJ_P_CONTATO_TOTAL = 0

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
	  
		' Totalização por ATIVIDADE de CADASTROS do BRASIL agrupados por TIPO_PESS e ATIVIDADE PAI
		strCONT_PF_I = 0 
		strCONT_PJ_I = 0 
		strCONT_PJ_I_CONTATO = 0 
		
		strCONT_PF_E = 0 
		strCONT_PJ_E = 0
		strCONT_PJ_E_CONTATO = 0

		strCONT_PF_P = 0 
		strCONT_PJ_P = 0
		strCONT_PJ_P_CONTATO = 0
		
		strSQL =          "  SELECT "
		strSQL = strSQL & "  COUNT(distinct(if(e.tipo_pess='S' and COALESCE(p.IDIOMA,'') in ('I',''),e.COD_EMPRESA,null))) AS TOT_CADASTRO_PF_I"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='N' and COALESCE(p.IDIOMA,'') in ('I',''),e.COD_EMPRESA,null))) AS TOT_CADASTRO_PJ_I"
		strSQL = strSQL & ", COUNT(if( COALESCE(p.IDIOMA,'') in ('I',''),es.CODBARRA,null)) AS TOT_CONTATO_PJ_I"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='S' and COALESCE(p.IDIOMA,'')='E',e.COD_EMPRESA,null))) AS TOT_CADASTRO_PF_E"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='N' and COALESCE(p.IDIOMA,'')='E',e.COD_EMPRESA,null))) AS TOT_CADASTRO_PJ_E"
		strSQL = strSQL & ", COUNT(if(COALESCE(p.IDIOMA,'')='E',es.CODBARRA,null)) AS TOT_CONTATO_PJ_E"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='S' and COALESCE(p.IDIOMA,'')='P',e.COD_EMPRESA,null))) AS TOT_CADASTRO_PF_P"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='N' and COALESCE(p.IDIOMA,'')='P',e.COD_EMPRESA,null))) AS TOT_CADASTRO_PJ_P"
		strSQL = strSQL & ", COUNT(if(COALESCE(p.IDIOMA,'')='P',es.CODBARRA,null)) AS TOT_CONTATO_PJ_P"
		strSQL = strSQL & "   FROM tbl_Empresas e LEFT JOIN tbl_Atividade ON (e.CODATIV1 = tbl_Atividade.CODATIV)"
		strSQL = strSQL & "                      LEFT JOIN tbl_Empresas_sub es  ON (e.COD_EMPRESA = es.COD_EMPRESA)"
		strSQL = strSQL & "                      LEFT JOIN tbl_Pais p  ON (e.END_PAIS  = p.PAIS)"
		strSQL = strSQL & "  WHERE e.SYS_INATIVO IS NULL "
		strSQL = strSQL & "    AND e.END_PAIS <> 'BRASIL' "
		If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
		  strSQL = strSQL & "      AND e.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
		End If
		If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
		  strSQL = strSQL & "      AND e.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
		End If
		If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
		  strSQL = strSQL & "    AND (e.CODATIV1 = '' OR e.CODATIV1 = '000' Or tbl_Atividade.CODATIV_PAI = '' OR tbl_Atividade.CODATIV_PAI = '000') "
		Else
		  strSQL = strSQL & "    AND (e.CODATIV1 = '" & strCODATIV & "' OR tbl_Atividade.CODATIV_PAI = '" & strCODATIV & "')"
		End If
		
		Set objRSDetail = objConn.Execute(strSQL)
		If not objRSDetail.EOF Then
		      strCONT_PF_I           = objRSDetail("TOT_CADASTRO_PF_I")
			  strCONT_PJ_I           = objRSDetail("TOT_CADASTRO_PJ_I")
			  strCONT_PJ_I_CONTATO   = objRSDetail("TOT_CONTATO_PJ_I")
			  
		      strCONT_PF_E           = objRSDetail("TOT_CADASTRO_PF_E")
			  strCONT_PJ_E           = objRSDetail("TOT_CADASTRO_PJ_E")
			  strCONT_PJ_E_CONTATO   = objRSDetail("TOT_CONTATO_PJ_E")
			  
		      strCONT_PF_P           = objRSDetail("TOT_CADASTRO_PF_P")
			  strCONT_PJ_P           = objRSDetail("TOT_CADASTRO_PJ_P")
			  strCONT_PJ_P_CONTATO   = objRSDetail("TOT_CONTATO_PJ_P")
		End If
		FechaRecordSet objRSDetail
		
		strCONT_PF_I_TOTAL = Clng(strCONT_PF_I_TOTAL) + Clng(strCONT_PF_I)
		strCONT_PJ_I_TOTAL = Clng(strCONT_PJ_I_TOTAL) + Clng(strCONT_PJ_I)
		strCONT_PJ_I_CONTATO_TOTAL = Clng(strCONT_PJ_I_CONTATO_TOTAL) + Clng(strCONT_PJ_I_CONTATO)
		
		strCONT_PF_E_TOTAL = Clng(strCONT_PF_E_TOTAL) + Clng(strCONT_PF_E)
		strCONT_PJ_E_TOTAL = Clng(strCONT_PJ_E_TOTAL) + Clng(strCONT_PJ_E)
		strCONT_PJ_E_CONTATO_TOTAL = Clng(strCONT_PJ_E_CONTATO_TOTAL) + Clng(strCONT_PJ_E_CONTATO)

		strCONT_PF_P_TOTAL = Clng(strCONT_PF_P_TOTAL) + Clng(strCONT_PF_P)
		strCONT_PJ_P_TOTAL = Clng(strCONT_PJ_P_TOTAL) + Clng(strCONT_PJ_P)
		strCONT_PJ_P_CONTATO_TOTAL = Clng(strCONT_PJ_P_CONTATO_TOTAL) + Clng(strCONT_PJ_P_CONTATO)

%>
  <tr bgcolor='#FFE8B7'> 
    <td><b>(<%=Trim(UCase(strCODATIV))%>) <%=strATIVIDADE%></b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b>
      <% Response.Write(strCONT_PF_I) %> 
      </b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b>
      <% Response.Write(strCONT_PJ_I) %> 
      </b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b><% Response.Write(strCONT_PJ_I_CONTATO) %></b></td>	
    <td align="center"> 
      <b>
      <% Response.Write(strCONT_PF_E)	%>	
      </b></td>
    <td align="center"> 
      <b>
      <% Response.Write(strCONT_PJ_E)	%>    
      </b></td>
    <td align="center"> 
      <b><% Response.Write(strCONT_PJ_E_CONTATO) %></b>
	</td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b>
      <% Response.Write(strCONT_PF_P)	%>	
      </b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b>
      <% Response.Write(strCONT_PJ_P)	%>    
      </b></td>
    <td align="center" bgcolor="#FFFFCC"> 
      <b><% Response.Write(strCONT_PJ_P_CONTATO) %></b>
	</td>
  </tr>
  <%
  Response.Flush()
  '==========================================
  'AQUI MOSTRA AS DIVISOES DA ATIVIDADE PAI
  '==========================================

	
	' Totalização por ATIVIDADE FILHA
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

		strCONT_PF_I = 0 
		strCONT_PJ_I = 0 
		strCONT_PJ_I_CONTATO = 0 
		
		strCONT_PF_E = 0 
		strCONT_PJ_E = 0
		strCONT_PJ_E_CONTATO = 0

		strCONT_PF_P = 0 
		strCONT_PJ_P = 0
		strCONT_PJ_P_CONTATO = 0
		
		strSQL =          "  SELECT "
		strSQL = strSQL & "  COUNT(distinct(if(e.tipo_pess='S' and COALESCE(p.IDIOMA,'') in ('I',''),e.COD_EMPRESA,null))) AS TOT_CADASTRO_PF_I"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='N' and  COALESCE(p.IDIOMA,'') in ('I',''),e.COD_EMPRESA,null))) AS TOT_CADASTRO_PJ_I"
		strSQL = strSQL & ", COUNT(if(COALESCE(p.IDIOMA,'') in ('I',''),es.CODBARRA,null)) AS TOT_CONTATO_PJ_I"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='S' and COALESCE(p.IDIOMA,'')='E',e.COD_EMPRESA,null))) AS TOT_CADASTRO_PF_E"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='N' and COALESCE(p.IDIOMA,'')='E',e.COD_EMPRESA,null))) AS TOT_CADASTRO_PJ_E"
		strSQL = strSQL & ", COUNT(if(COALESCE(p.IDIOMA,'')='E',es.CODBARRA,null)) AS TOT_CONTATO_PJ_E"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='S' and COALESCE(p.IDIOMA,'')='P',e.COD_EMPRESA,null))) AS TOT_CADASTRO_PF_P"
		strSQL = strSQL & ", COUNT(distinct(if(e.tipo_pess='N' and COALESCE(p.IDIOMA,'')='P',e.COD_EMPRESA,null))) AS TOT_CADASTRO_PJ_P"
		strSQL = strSQL & ", COUNT(if(COALESCE(p.IDIOMA,'')='P',es.CODBARRA,null)) AS TOT_CONTATO_PJ_P"
		strSQL = strSQL & "   FROM tbl_Empresas e LEFT JOIN tbl_Atividade ON (e.CODATIV1 = tbl_Atividade.CODATIV)"
		strSQL = strSQL & "                      LEFT JOIN tbl_Empresas_sub es  ON (e.COD_EMPRESA = es.COD_EMPRESA)"
		strSQL = strSQL & "                      LEFT JOIN tbl_Pais p  ON (e.END_PAIS  = p.PAIS)"
		strSQL = strSQL & "  WHERE e.SYS_INATIVO IS NULL "
		strSQL = strSQL & "    AND e.END_PAIS <> 'BRASIL' "
		If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
		  strSQL = strSQL & "      AND e.SYS_DATACA BETWEEN '" & PrepDataIve(strDT_INICIO,False,False) & " 00:00:00' AND '" & PrepDataIve(strDT_FIM,False,False) & " 23:59:59'"
		End If
		If strCEP_INICIO <> "" And strCEP_FIM <> "" Then
		  strSQL = strSQL & "      AND e.END_CEP BETWEEN '" & strCEP_INICIO & "' AND '" & strCEP_FIM & "'"
		End If
		If Trim(UCase(strCODATIV)) = "INDEFINIDO" or Trim(UCase(strCODATIV)) = "000" Then
		  strSQL = strSQL & "    AND (e.CODATIV1 = '' OR e.CODATIV1 = '000' "
		Else
		  strSQL = strSQL & "    AND (e.CODATIV1 = '" & strCODATIV & "')"
		End If
		
		Set objRSDetail = objConn.Execute(strSQL)
		If not objRSDetail.EOF Then
		      strCONT_PF_I           = objRSDetail("TOT_CADASTRO_PF_I")
			  strCONT_PJ_I           = objRSDetail("TOT_CADASTRO_PJ_I")
			  strCONT_PJ_I_CONTATO   = objRSDetail("TOT_CONTATO_PJ_I")
			  
		      strCONT_PF_E           = objRSDetail("TOT_CADASTRO_PF_E")
			  strCONT_PJ_E           = objRSDetail("TOT_CADASTRO_PJ_E")
			  strCONT_PJ_E_CONTATO   = objRSDetail("TOT_CONTATO_PJ_E")

		      strCONT_PF_P           = objRSDetail("TOT_CADASTRO_PF_P")
			  strCONT_PJ_P           = objRSDetail("TOT_CADASTRO_PJ_P")
			  strCONT_PJ_P_CONTATO   = objRSDetail("TOT_CONTATO_PJ_P")

		End If
		FechaRecordSet objRSDetail
		
		'strCONT_PF_I_TOTAL = Clng(strCONT_PF_I_TOTAL) + Clng(strCONT_PF_I)
		'strCONT_PJ_I_TOTAL = Clng(strCONT_PJ_I_TOTAL) + Clng(strCONT_PJ_I)
		'strCONT_PJ_I_CONTATO_TOTAL = Clng(strCONT_PJ_I_CONTATO_TOTAL) + Clng(strCONT_PJ_I_CONTATO)
		
		'strCONT_PF_E_TOTAL = Clng(strCONT_PF_E_TOTAL) + Clng(strCONT_PF_E)
		'strCONT_PJ_E_TOTAL = Clng(strCONT_PJ_E_TOTAL) + Clng(strCONT_PJ_E)
		'strCONT_PJ_E_CONTATO_TOTAL = Clng(strCONT_PJ_E_CONTATO_TOTAL) + Clng(strCONT_PJ_E_CONTATO)

		'strCONT_PF_P_TOTAL = Clng(strCONT_PF_P_TOTAL) + Clng(strCONT_PF_P)
		'strCONT_PJ_P_TOTAL = Clng(strCONT_PJ_P_TOTAL) + Clng(strCONT_PJ_P)
		'strCONT_PJ_P_CONTATO_TOTAL = Clng(strCONT_PJ_P_CONTATO_TOTAL) + Clng(strCONT_PJ_P_CONTATO)

  %>
  <tr bgcolor='#F2F2F2'> 
    <td>&nbsp;&nbsp;(<%=Trim(UCase(strCODATIV))%>) <%=strATIVIDADE%></td>
    <td align="center"> 
      <% Response.Write(strCONT_PF_I) %> 
      </td>
    <td align="center"> 
      <% Response.Write(strCONT_PJ_I) %>  
    </td>
    <td align="center"> 
        <% Response.Write(strCONT_PJ_I_CONTATO) %> 
  </td>
    <td align="center"> 
      <% Response.Write(strCONT_PF_E) %>	
    </td>
    <td align="center"> 
      <% Response.Write(strCONT_PJ_E) %>
    </td>
    <td align="center"> 
	  <% Response.Write(strCONT_PJ_E_CONTATO) %>    
    </td>
    <td align="center"> 
      <% Response.Write(strCONT_PF_P) %>	
    </td>
    <td align="center"> 
      <% Response.Write(strCONT_PJ_P) %>
    </td>
    <td align="center"> 
	  <% Response.Write(strCONT_PJ_P_CONTATO) %>    
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
    <td align="center" class="arial12Bold"><%=strCONT_PF_I_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_I_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_I_CONTATO_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PF_E_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_E_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_E_CONTATO_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PF_P_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_P_TOTAL%></td>
    <td align="center" class="arial12Bold"><%=strCONT_PJ_P_CONTATO_TOTAL%></td>
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