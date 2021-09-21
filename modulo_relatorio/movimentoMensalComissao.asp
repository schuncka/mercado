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
 Dim strORDERBY, strDIRECTION, vlrComissaoC,vlrComissaoV, bgColor, strIdRepre,vlrComissao
 Dim dblVlrComissaoParticipacao
 Dim dblVlrComissaoMercado     
 Dim acumdblVlrComissaoParticipacao 
 Dim acumdblVlrComissaoMercado     
 Dim acumDblVlrOperacao 
 Dim preco      
 Dim quantidade 
 Dim vlrTotal   

 acumdblVlrComissaoParticipacao = 0  
 acumdblVlrComissaoMercado     = 0
 acumDblVlrOperacao = 0
 
   AbreDBConn objConn, CFG_DB_DADOS 

 strDT_INICIO = Replace(Request("var_dt_inicio"),"'","")
 strDT_FIM    = Replace(Request("var_dt_fim"),"'","")
 strIdRepre   = Replace(Request("DBVAR_STR_IDREPRE"),"'","")
  
   

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



Function calculaComissao(comissaoComprador , comissaoVendedor , PRECO , Quantidade , comissaoMercado ) 

If IsNull(comissaoComprador) Then
    comissaoComprador = 0
End If

If IsNull(comissaoVendedor) Then
    comissaoVendedor = 0
End If

If IsNull(PRECO) Then
    PRECO = 0
End If

If IsNull(Quantidade) Then
    Quantidade = 0
End If

If IsNull(comissaoMercado) Then
    comissaoMercado = 0
End If
calculaComissao = ((comissaoComprador * PRECO * Quantidade) * comissaoMercado) + ((comissaoVendedor * PRECO * Quantidade) * comissaoMercado)

'COMISSAOC]*[preco]*[quantidade])*[COMISSAO])+(([COMISSAOV]*[preco]*[quantidade])*[COMISSAO])

End Function

'Function calcComissaoMercado(IDREPRE As String, PRECO As Double, Quantidade As Double, ComissaoV As Double, ComissaoC As Double, comissao As Double) As Double
Function calcComissaoMercado(IDREPRE , PRECO , Quantidade , ComissaoV , ComissaoC , COMISSAO )
Dim valor1, valor2 , valor_comissao
If IDREPRE = "104835" Or IDREPRE = "108631" Then
    valor_comissao = ((PRECO * Quantidade) * ComissaoV) + ((ComissaoC * PRECO * Quantidade) * COMISSAO)
Else
    valor1 = ((PRECO * Quantidade) * ComissaoV) - ((ComissaoV * PRECO * Quantidade) * COMISSAO)
    valor2 = ((ComissaoC * PRECO * Quantidade) * COMISSAO)
    valor_comissao = valor1 + valor2
End If
calcComissaoMercado = valor_comissao
'calcComissaoMercado = PRECO * Quantidade * ComissaoV
End Function




Function calcComissaoRepre(IDREPRE , ComissaoV , PRECO , Quantidade , COMISSAO , ComissaoC )
Dim valor_comissao 
Dim valor1, valor2 
'COMISSAO_REPRE: (([COMISSAOV]*[preco]*[quantidade])*[COMISSAO])+SeImed(ï¿½Nulo(([COMISSAOC]*[preco]*[quantidade])*[COMISSAO]);0;([COMISSAOC]*[preco]*[quantidade])*[COMISSAO])
If IDREPRE = "104835" Then
    valor_comissao = 0
Else
    valor1 = (ComissaoV * PRECO * Quantidade) * COMISSAO
    valor2 = (ComissaoC * PRECO * Quantidade) * COMISSAO
    valor_comissao = valor1 + valor2
End If
calcComissaoRepre = valor_comissao

End Function


'COMISSAO_MERCADO: SeImed([idrepre]='104835';(([preco]*[quantidade])*([comissaov]));((([preco]*[quantidade])*([comissaov]))-
'(([COMISSAOV]*[preco]*[quantidade])*[COMISSAO])+SeImed(ï¿½Nulo(([COMISSAOC]*[preco]*[quantidade])*[COMISSAO]);0;([COMISSAOC]*[preco]*[quantidade])*[COMISSAO])))


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
<title>Movimento Mensal</title>
</head>
<body text="#916E28" link="#916E28" vlink="#916E28" alink="#916E28" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="2" align="center" class="arial10">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" align="center" class="arial12Bold">Movimento Mensal 
      <%	  
	    Response.Write("<br>Período: " & PrepData(strDT_INICIO,True,false) & " a " & PrepData(strDT_FIM,True,false))
	  
	  %> </td>
  </tr>
  <tr> 
    <td width="299" class="arial12Bold">&nbsp;</td>
    <td align="right" class="arial12Bold">
      <a href="movimentoMensalComissaoExcel.asp?DBVAR_STR_IDREPRE=<%=strIdRepre%>&var_dt_inicio=<%=strDT_INICIO%>&var_dt_fim=<%=strDT_FIM%>&order=<%=Request("order")%>&direction=<%=Request("direction")%>" class="Tahomacinza9"><img src="../img/ico_excel_mini.gif" width="16" height="16" hspace="1" border="0">excel</a>&nbsp;&nbsp; 
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

    <td bgcolor="#FFCC66" class="arial12Bold"><b>		
        Contrato</b>
    </td>
    
    <td  bgcolor="#FFCC66" class="arial12Bold"><b>		
        Comprador</b>
    </td>

    <td  align="left" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	Vendedor</b>
    </td>
        
	<td  align="left" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	Representante</b>
    </td>
    <td  align="left" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	Produto</b>
    </td>
    <td  align="left" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	Quantidade</b>
    </td>
    <td  align="left" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	Preço</b>
    </td>
    <td  align="left" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	Valor Operação</b>
    </td>
    <td  align="right" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	% COMIS V/C</b>
    </td>
    <td  align="right" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	Participação</b>
    </td>
    <td  align="right" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	Total Participação</b>
    </td>
    <td  align="right" bgcolor="#FFCC66" class="arial12Bold" valign="middle"><b>		
    	Mercado</b>
    </td>
  </tr>
  <%

 
 

'strDT_INICIO = "01/01/2018"
'strDT_FIM = "31/12/2018"

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
'strSQL = strSQL & " , tComprador.NomeDoCliente AS COMPRADOR "
'strSQL = strSQL & " , tVendedor.NomeDoCliente  AS VENDEDOR "
'strSQL = strSQL & " , tRepre.NomeDoCliente     AS REPRE "
strSQL = strSQL & " , TBL_PRODUTOS.Produto "
strSQL = strSQL & " , (select NomeDoCliente from tbl_clientes where codigodocliente = tbl_contrato.vendedor) as VENDEDOR "
strSQL = strSQL & " , (select NomeDoCliente from tbl_clientes where codigodocliente = tbl_contrato.comprador) as COMPRADOR "
strSQL = strSQL & " , (select NomeDoCliente from tbl_clientes where codigodocliente = tbl_contrato.idrepre) as REPRE "
strSQL = strSQL & " FROM TBL_CONTRATO  "
'strSQL = strSQL & "   LEFT JOIN TBL_CLIENTES AS tComprador ON (TBL_CONTRATO.Comprador = tComprador.CodigoDoCliente) AND (TBL_CONTRATO.IDEMPRESA = tComprador.IDEMPRESA))  "
'strSQL = strSQL & " 	LEFT JOIN TBL_CLIENTES AS tVendedor ON (TBL_CONTRATO.IDEMPRESA = tVendedor.IDEMPRESA) AND (TBL_CONTRATO.Vendedor = tVendedor.CodigoDoCliente))  "
'strSQL = strSQL & " 	LEFT JOIN TBL_CLIENTES AS tRepre ON (TBL_CONTRATO.IDREPRE = tRepre.CodigoDoCliente) AND (TBL_CONTRATO.IDEMPRESA = tRepre.IDEMPRESA))  "
strSQL = strSQL & " 	LEFT JOIN TBL_PRODUTOS ON TBL_CONTRATO.IDEMPRESA = TBL_PRODUTOS.IDEMPRESA AND TBL_CONTRATO.Produto = TBL_PRODUTOS.IDPROD "
strSQL = strSQL & " WHERE TBL_CONTRATO.Data Between '" & PrepDataIve(strDT_INICIO, False, false) & " 00:00:00 ' And '" & PrepDataIve(strDT_FIM, False, false) & " 00:00:00' /*AND ((tRepre.NomeDoCliente) Is Not Null)*/ "
strSQL = strSQL & " AND TBL_CONTRATO.preco>0 "
if strIdRepre <> "" then
  strSQL = strSQL & " and tbl_contrato.idrepre = " & strIdRepre
end if
strSQL = strSQL & " ORDER BY TBL_CONTRATO.IDCONTRATO /*limit 30*/; "

response.write strSQL
  

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
        vlrComissao  = 0

        if objRS("comissaoc") <> "" Then
            vlrComissaoC = replace(objRS("comissaoc"),".",",")
        else 
            vlrComissaoC = 0
        end if

        if objRS("comissaov") <> "" Then
            vlrComissaoV = replace(objRS("comissaov"),".",",")
        else 
            vlrComissaoV = 0
        end if

        if objRS("comissao") <> "" Then
            vlrComissao = replace(objRS("comissao"),".",",")
        else 
            vlrComissao = 0
        end if

        if bgColor = "#DCDCDC" then
            bgColor = "#F5FFFA"
        else
            bgColor = "#DCDCDC"
        end if
        
        
        preco      = 0
        quantidade = 0
        vlrTotal   = 0

        if objRS("preco") <> "" then
          preco = replace(objRS("preco"),".",",")
        end if
        
        if objRS("quantidade") <> "" then
          quantidade = replace(objRS("quantidade"),".",",")
        end if
        
        if objRS("vlrTotal") <> "" then
          vlrTotal = replace(objRS("vlrTotal"),".",",")
        end if


        dblVlrComissaoParticipacao = calcComissaoRepre (objRS("repre"), vlrComissaoV, preco, quantidade, vlrComissao, vlrComissaoC)
                                      'calcComissaoRepre(IDREPRE       , ComissaoV    , PRECO        , Quantidade         , COMISSAO   , ComissaoC )
        dblVlrComissaoMercado = calcComissaoMercado (objRS("repre"), preco, quantidade, vlrComissaoV, vlrComissaoC, vlrComissao)
                                'calcComissaoMercado (IDREPRE       , PRECO         , Quantidade         , ComissaoV   , ComissaoC   , COMISSAO )
        acumdblVlrComissaoParticipacao = dblVlrComissaoParticipacao+acumdblVlrComissaoParticipacao
        acumdblVlrComissaoMercado      = dblVlrComissaoMercado+acumdblVlrComissaoMercado
        acumDblVlrOperacao             = vlrTotal+acumDblVlrOperacao
 %>
 <tr align='left'> 

    <td  bgcolor="<%=bgColor%>" class="arial12"><%=left(objRS("data")&"",10)%></td>
    <td  bgcolor="<%=bgColor%>" class="arial12"><%=objRS("contrato")&""%></td>    
    <td  bgcolor="<%=bgColor%>" class="arial12"><%=objRS("comprador")&""%></td>
    <td  align="left" bgcolor="<%=bgColor%>" class="arial12"><%=objRS("vendedor")&""%></td>        
	  <td  align="left" bgcolor="<%=bgColor%>" class="arial12"><%=objRS("repre")&""%></td>
    <td  align="left" bgcolor="<%=bgColor%>" class="arial12"><%=objRS("produto")&""%></td>
    <td  align="right" bgcolor="<%=bgColor%>" class="arial12"><%=FormatNumber(quantidade,2)%></td>
    <td  align="right" bgcolor="<%=bgColor%>" class="arial12"><%=FormatNumber(preco,2)%></td>
    <td  align="right" bgcolor="<%=bgColor%>" class="arial12"><%=FormatNumber(vlrTotal,2)%></b>
    </td>
    <td  align="right" bgcolor="<%=bgColor%>" class="arial12"><b>		
    	<%=FormatNumber((vlrComissaoV*100),2)%> / <%=FormatNumber((vlrComissaoC*100),2)%></b>      
    </td>
    <td  align="right" bgcolor="<%=bgColor%>" class="arial12"><b>		
    	<%=FormatNumber((vlrComissao*100),2)%></b>
    </td>
    <td  align="right" bgcolor="<%=bgColor%>" class="arial12"><b>		
    	<%=FormatNumber(dblVlrComissaoParticipacao,2)%></b>
    </td>
    <td  align="right" bgcolor="<%=bgColor%>" class="arial12"><b>		
    	<%
        'response.write(dblVlrComissaoMercado)
        if dblVlrComissaoMercado < 0 then
          dblVlrComissaoMercado = dblVlrComissaoMercado *-1
        end if
      %>
      <%=FormatNumber(dblVlrComissaoMercado,2)%>
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
    <td colspan="8" align="right" bgcolor="#FFCC66" class="arial12Bold">Total Geral&nbsp;&nbsp;</td>
	<td align="right" bgcolor="#FFCC66" class="arial12Bold">&nbsp;<%=FormatNumber(acumDblVlrOperacao)%></td>
	<td colspan="2" align="right" bgcolor="#FFCC66" class="arial12Bold">&nbsp;</td>
	<td align="right" bgcolor="#FFCC66" class="arial12Bold">&nbsp;<b><%=FormatNumber(acumdblVlrComissaoMercado)%></b></td>
	<td align="right" bgcolor="#FFCC66" class="arial12Bold">&nbsp;<b><%=FormatNumber(acumdblVlrComissaoParticipacao)%></b></td>
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