<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
 Response.Expires = -1
 Server.ScriptTimeout = 99999
 
 Response.Buffer = TRUE

 Dim strDT_INICIO, strDT_FIM, strBANCO
 

 
Dim objConn, ObjRS
 Dim strSQL, strSQLClause, auxstr, MyChecked
 Dim auxTimeInic, auxTimeFim
 Dim strBgColor, i, j, cont
 Dim strSALDO, objRSDetail
 Dim strGRUPO, strTITULO
 Dim strVLR_PREVISTO, strVLR_REALIZADO, strVLR_REALIZADO_ANTERIOR, strVLR_ECONOMIA
 Dim strSUB_VLR_PREVISTO, strSUB_VLR_REALIZADO, strSUB_VLR_REALIZADO_ANTERIOR, strSUB_VLR_ECONOMIA
 Dim strTOT_VLR_PREVISTO, strTOT_VLR_REALIZADO, strTOT_VLR_REALIZADO_ANTERIOR, strTOT_VLR_ECONOMIA
 Dim strORDERBY, strDIRECTION, vlrComissaoC,vlrComissaoV, bgColor
  
 
   AbreDBConn objConn, CFG_DB_DADOS 

 strDT_INICIO = Replace(Request("var_dt_inicio"),"'","")
 strDT_FIM = Replace(Request("var_dt_fim"),"'","")
  
   

Function HasTimeInside(DateToEvaluate)
   
   Dim strHora
   Dim strMinuto
   Dim strSegundo

   If isDate(DateToEvaluate) Then
     strHora    = Hour(DateToEvaluate)
     strMinuto  = Minute(DateToEvaluate)
     strSegundo = Second(DateToEvaluate)

     If (strHora <> "0") Or (strMinuto <> "0") Or (strSegundo <> "0") Then
       HasTimeInside = True
     Else
       HasTimeInside = False
     End If
   Else
     HasTimeInside = False
   End If

End Function



 If not IsDate(strDT_INICIO) Then
   strDT_INICIO = ""
 End If
 If not IsDate(strDT_FIM) Then
   strDT_FIM = ""
 Else
   If not HasTimeInside(strDT_FIM) Then
      strDT_FIM = strDT_FIM & " 23:59:59"
   End If
 End If


'Response.Write("<br>strDT_INICIO " & strDT_INICIO)
'Response.Write("<br>strDT_FIM " & strDT_FIM)


%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<title><%=Session("NOME_EVENTO")%>  - Movimento Mensal</title>
</head>
<body text="#916E28" link="#916E28" vlink="#916E28" alink="#916E28" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="2" align="center" class="arial10">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" align="center" class="arial12Bold">Movimento Mensal 
      <%	  
	    Response.Write("<br>Período: " & PrepData(strDT_INICIO,True,True) & " a " & PrepData(strDT_FIM,True,True))
	  
	  %> </td>
  </tr>
  <tr> 
    <td width="299" class="arial12Bold">&nbsp;</td>
    <td align="right" class="arial12Bold">
      <a href="rel_budget_excel.asp?var_banco=<%=strBANCO%>&var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&order=<%=Request("order")%>&direction=<%=Request("direction")%>" class="Tahomacinza9"><img src="../img/ico_excel_mini.gif" width="16" height="16" hspace="1" border="0">excel</a>&nbsp;&nbsp; 
      <a href="javascript:window.print();" class="Tahomacinza9"><img src="../img/ico_impressora_mini.gif" border="0">imprimir</a>
    </td>
  </tr>
</table>
<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#FFFFFF" class="arial12">
  <tr align='left'> 
    <td  bgcolor="#FFCC66" class="arial12Bold">&nbsp;<b>
		<!--a href="rel_budget.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&order=COD_REDUZIDO&direction=ASC"><img src="../_DBManager/gridlnkASC.gif" width="11" height="11" border="0" align="absmiddle"></a>
		<a href="rel_budget.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&order=COD_REDUZIDO&direction=DESC"><img src="../_DBManager/gridlnkDESC.gif" width="11" height="11" border="0" align="absmiddle"></a-->
        Data</b>
    </td>

    <td bgcolor="#FFCC66" class="arial12Bold">&nbsp;<b>
		<!--a href="rel_budget.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&order=TITULO&direction=ASC"><img src="../_DBManager/gridlnkASC.gif" width="11" height="11" border="0" align="absmiddle"></a>
		<a href="rel_budget.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&order=TITULO&direction=DESC"><img src="../_DBManager/gridlnkDESC.gif" width="11" height="11" border="0" align="absmiddle"></a-->
        Contrato</b>
    </td>
    
    <td  bgcolor="#FFCC66" class="arial12Bold">&nbsp;<b>
		<!--a href="rel_budget.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&order=RESUMIDO&direction=ASC"><img src="../_DBManager/gridlnkASC.gif" width="11" height="11" border="0" align="absmiddle"></a>
		<a href="rel_budget.asp?var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&order=RESUMIDO&direction=DESC"><img src="../_DBManager/gridlnkDESC.gif" width="11" height="11" border="0" align="absmiddle"></a-->
        Comprador</b>
    </td>

    <td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	Vendedor</b>
    </td>
        
	<td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	Representante</b>
    </td>
    <td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	Produto</b>
    </td>
    <td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	Quantidade</b>
    </td>
    <td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	Preço</b>
    </td>
    <td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	Valor Operação</b>
    </td>
    <td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	% COMIS V/C</b>
    </td>
    <td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	Participação</b>
    </td>
    <td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	Total Participação</b>
    </td>
    <td  align="center" bgcolor="#FFCC66" class="arial12Bold"><b>		
    	Mercado</b>
    </td>
  </tr>
  <%

 
 

strDT_INICIO = "01/01/2018"
strDT_FIM = "31/12/2018"

strSQL = strSQL & " SELECT DISTINCT "
strSQL = strSQL & "  TBL_CONTRATO.Data, tbl_contrato.idcontrato "
strSQL = strSQL & " , TBL_CONTRATO.IDREPRE "
strSQL = strSQL & " , TBL_CONTRATO.preco "
strSQL = strSQL & " , TBL_CONTRATO.quantidade "
strSQL = strSQL & " , TBL_CONTRATO.comissao "
strSQL = strSQL & " , TBL_CONTRATO.ComissaoV "
strSQL = strSQL & " , TBL_CONTRATO.Comissaoc "
strSQL = strSQL & " , TBL_CONTRATO.preco * TBL_CONTRATO.quantidade AS vlrTotal "
strSQL = strSQL & " /*, calcComissaoRepre([tbl_contrato]![IDREPRE],IIf(IsNull([ComissaoV]),0,[ComissaoV]),IIf(IsNull([PRECO]),0,[PRECO]),IIf(IsNull([Quantidade]),0,[quantidade]),IIf(IsNull([comissao]),0,[comissao]),IIf(IsNull([comissaoc]),0,[comissaoc])) AS COMISSAO_REPRESENTANTE "
strSQL = strSQL & " , IIf(IsNull([COMISSAO]),0,[COMISSAO])*100 AS Comissao "
strSQL = strSQL & " , ((IIf(IsNull([preco]),0,[preco]))*IIf(IsNull([quantidade]),0,[quantidade]))*(IIf(IsNull([comissaov]),0,[comissaov])+IIf(IsNull([comissaoc]),0,[comissaoc])) AS Resultado "
strSQL = strSQL & " , calcComissaoMercado([tbl_contrato]![idrepre],IIf(IsNull([tbl_contrato]![preco]),0,[tbl_contrato]![preco]),IIf(IsNull([tbl_contrato]![quantidade]),0,[tbl_contrato]![quantidade]),IIf(IsNull([tbl_contrato]![comissaov]),0,[tbl_contrato]![comissaov]),IIf(IsNull([tbl_contrato]![comissaoc]),0,[tbl_contrato]![comissaoc]),IIf(IsNull([tbl_contrato]![comissao]),0,[tbl_contrato]![comissao])) AS COMISSAO_MERCADO "
strSQL = strSQL & " */ "
strSQL = strSQL & " , TBL_CONTRATO.IDCONTRATO AS CONTRATO "
strSQL = strSQL & " , tComprador.NomeDoCliente AS COMPRADOR "
strSQL = strSQL & " , tVendedor.NomeDoCliente  AS VENDEDOR "
strSQL = strSQL & " , tRepre.NomeDoCliente     AS REPRE "
strSQL = strSQL & " , TBL_PRODUTOS.Produto "
strSQL = strSQL & " FROM (((TBL_CONTRATO  "
strSQL = strSQL & "     LEFT JOIN TBL_CLIENTES AS tComprador ON (TBL_CONTRATO.Comprador = tComprador.CodigoDoCliente) AND (TBL_CONTRATO.IDEMPRESA = tComprador.IDEMPRESA))  "
strSQL = strSQL & " 	LEFT JOIN TBL_CLIENTES AS tVendedor ON (TBL_CONTRATO.IDEMPRESA = tVendedor.IDEMPRESA) AND (TBL_CONTRATO.Vendedor = tVendedor.CodigoDoCliente))  "
strSQL = strSQL & " 	LEFT JOIN TBL_CLIENTES AS tRepre ON (TBL_CONTRATO.IDREPRE = tRepre.CodigoDoCliente) AND (TBL_CONTRATO.IDEMPRESA = tRepre.IDEMPRESA))  "
strSQL = strSQL & " 	LEFT JOIN TBL_PRODUTOS ON (TBL_CONTRATO.IDEMPRESA = TBL_PRODUTOS.IDEMPRESA) AND (TBL_CONTRATO.Produto = TBL_PRODUTOS.IDPROD) "
strSQL = strSQL & " WHERE (((TBL_CONTRATO.Data) Between '" & PrepDataIve(strDT_INICIO, False, False) & "' And '" & PrepDataIve(strDT_FIM, False, False) & "') AND ((tRepre.NomeDoCliente) Is Not Null)) "
strSQL = strSQL & " ORDER BY TBL_CONTRATO.IDCONTRATO limit 30; "


  

   set objRS = objConn.Execute(strSQL)  

   i = 0
   j = 0
   
   bgColor = "#DCDCDC"
  

   If not objRS.BOF Then
		strGRUPO = "BOF"
   End If
   Do While Not objRS.EOF   
		    vlrComissaoC = 0
        vlrComissaoV = 0

        if objRS("comissaoc") <> "" Then
            vlrComissaoC = objRS("comissaoc")
        else 
            vlrComissaoC = 0
        end if

        if objRS("comissaov") <> "" Then
            vlrComissaoV = objRS("comissaov")
        else 
            vlrComissaoV = 0
        end if

        if bgColor = "#DCDCDC" then
            bgColor = "#F5FFFA"
        else
            bgColor = "#DCDCDC"
        end if
 %>
 <tr align='left'> 
    <td  bgcolor="<%=bgColor%>" class="arial12"><%=left(objRS("data")&"",9)%></td>
    <td  bgcolor="<%=bgColor%>" class="arial12"><%=objRS("contrato")&""%></td>    
    <td  bgcolor="<%=bgColor%>" class="arial12"><%=objRS("comprador")&""%></td>
    <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><%=objRS("vendedor")&""%></td>        
	  <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><%=objRS("repre")&""%></td>
    <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><%=objRS("produto")&""%></td>
    <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><%=FormataDouble(objRS("quantidade"),2)%></td>
    <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><%=FormataDouble(objRS("preco"),2)%></td>
    <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><%=FormataDouble(objRS("vlrTotal"),2)%></b>
    </td>
    <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><b>		
    	<%=FormataDouble(vlrComissaoV,2)%> / <%=FormataDouble(vlrComissaoC,2)%></b>
    </td>
    <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><b>		
    	0,00</b>
    </td>
    <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><b>		
    	0,00</b>
    </td>
    <td  align="center" bgcolor="<%=bgColor%>" class="arial12"><b>		
    	0,00</b>
    </td>
  </tr>

<%
	   
	'End If

 	 i = i + 1
      objRS.movenext
	 If i mod 10 = 0 Then
	   Response.Flush()
	 End If
   Loop
 
   FechaRecordSet ObjRS
   FechaDBConn ObjConn
' end if
%>
  <tr align='left'> 
    <td colspan="10" align="right" bgcolor="#FFCC66" class="arial12Bold">Total Geral&nbsp;&nbsp;</td>
	<td align="right" bgcolor="#FFCC66" class="arial12Bold">&nbsp;<b><%=FormatNumber(strTOT_VLR_REALIZADO_ANTERIOR)%></b></td>
	<td align="right" bgcolor="#FFCC66" class="arial12Bold">&nbsp;<b><%=FormatNumber(strTOT_VLR_PREVISTO)%></b></td>
	<td align="right" bgcolor="#FFCC66" class="arial12Bold">&nbsp;<b><%=FormatNumber(strTOT_VLR_REALIZADO)%></b></td>
	<td align="right" bgcolor="#FFCC66" class="arial12Bold">&nbsp;<b><%=FormatNumber(strTOT_VLR_ECONOMIA)%></b></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="329" class="arial10"><%=AthFormataTamLeft(i,5,"0")%> registro(s)</td>
    <td align="right" class="arial10">Gerado em <%=PrepData(now(),true,true)%></td>
  </tr>
</table>
</body>
</html>
<%
Response.Flush()
%>