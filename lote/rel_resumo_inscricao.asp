<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/athdbConn.asp"--> 
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

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<title>ProEvento <%=Session("NOME_EVENTO")%>  - Relatório Gerencial 01</title></head>
<body text="#916E28" link="#916E28" vlink="#916E28" alink="#916E28" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="640" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td align="center" class="arial10">&nbsp;</td>
  </tr>
  <tr> 
    <td align="center" class="arial12Bold">Relat&oacute;rio Gerencial - Resumo 
      das Inscri&ccedil;&otilde;es</td>
  </tr>
  <tr> 
    <td align="right" class="arial12Bold"><a href="javascript:window.print();" class="Tahomacinza9">imprimir</a></td>
  </tr>
</table>
<table width="640" border="1" cellpadding="1" cellspacing="0" bordercolor="#FFFFFF" class="arial12">
  <%
 Dim objConn, ObjRS
 Dim strSQL, strSQLClause, auxstr, MyChecked
 Dim auxTimeInic, auxTimeFim
 
' if strVAR <> "" then
   AbreDBConn objConn, CFG_DB_DADOS 

   strSQL = " SELECT tbl_Produtos.COD_PROD"
   strSQL = strSQL & " ,tbl_Produtos.TITULO"
   strSQL = strSQL & " ,tbl_Produtos.GRUPO"
   strSQL = strSQL & " ,tbl_Produtos.CAPACIDADE"
   strSQL = strSQL & " ,SUM(tbl_Inscricao_Produto.QTDE) As NUM_INSCRICOES"
   strSQL = strSQL & " FROM ((tbl_ProdutosLEFT OUTER JOIN tbl_Inscricao_Produto ON ("
   strSQL = strSQL & "                         tbl_Produtos.COD_PROD = tbl_Inscricao_Produto.COD_PROD )) "
   If IsDate(strDT_INICIO) And IsDate(strDT_FIM) Then
     strSQL = strSQL & "                          LEFT OUTER JOIN tbl_Inscricao ON ( tbl_Inscricao_Produto.COD_INSCRICAO = tbl_Inscricao.COD_INSCRICAO "
     strSQL = strSQL & "                          AND tbl_Inscricao.DT_CHEGADAFICHA BETWEEN '" & PrepDataIve(strDT_INICIO,false,false) & "' AND '" & PrepDataIve(strDT_FIM,false,false) & "' )"
   End If
   strSQL = strSQL & "       ) "
   strSQL = strSQL & " WHERE tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")
   strSQL = strSQL & " GROUP BY tbl_Produtos.COD_PROD"
   strSQL = strSQL & "         ,tbl_Produtos.TITULO"
   strSQL = strSQL & "         ,tbl_Produtos.GRUPO"
   strSQL = strSQL & "         ,tbl_Produtos.CAPACIDADE"
   strSQL = strSQL & " ORDER BY tbl_Produtos.GRUPO, tbl_Produtos.TITULO"

'  response.write strSQL
'  response.end
   set objRS = objConn.Execute(strSQL)  

   Dim strBgColor, strGRUPO, strPRC_VENDA, i
   Dim strTOT_VAGAS, strTOT_INSCRICAO, strTOT_SALDO, strNUM_INSCRICOES
   strTOT_VAGAS = 0
   strTOT_INSCRICAO = 0
   strTOT_SALDO = 0
   i = 0
   strGRUPO = ""
   Do While Not objRS.EOF
          strNUM_INSCRICOES = objRS("NUM_INSCRICOES")
		  If not IsNumeric(strNUM_INSCRICOES ) Then
		    strNUM_INSCRICOES = 0
		  End If
		  If strGRUPO <> objRS("GRUPO") Then
			  If i > 0 Then
          %>
			  <tr align='left' bgcolor='#FFD988'> 
			    <td align="right" class="arial12Bold">&nbsp;</td>
			    <td width="80" align="right" class="arial12Bold">&nbsp;<b><%=strTOT_VAGAS%></b></td>
			    <td align="right" class="arial12Bold">&nbsp;<b><%=strTOT_INSCRICAO%></b></td>
			    <td align="right" class="arial12Bold">&nbsp;<b><%=strTOT_SALDO%></b></td>
			  </tr>		 
		  <%
    	         strTOT_VAGAS = 0
    	   	     strTOT_INSCRICAO = 0
    	         strTOT_SALDO = 0
	    	  End If
   %>
		  <tr align='left' bgcolor='#FFCC66'> 
		    <td class="arial12Bold">&nbsp;<b><%=objRS("GRUPO")%></b></td>
		    <td width="80" align="center" class="arial12Bold">&nbsp;<b>Vagas</b></td>
		    <td align="center" class="arial12Bold">&nbsp;<b>Inscrições</b></td>
		    <td align="center" class="arial12Bold">&nbsp;<b>Saldo</b></td>
		  </tr>
  <%	
			strGRUPO = objRS("GRUPO")
            strBgColor = "#FFE8B7"
		  End If
		  %>
  <tr> 
    <td width='400' bgcolor='<%=strBgColor%>'>&nbsp;(<%=objRS("COD_PROD")%>) <a href="rel_lista_inscricao_produto.asp?var_cod_prod=<%=objRS("COD_PROD")%>" class="Tahomapreta10"><%=objRS("TITULO")%></a></td>
    <td width='80'  bgcolor='<%=strBgColor%>' align='right'><%=objRS("CAPACIDADE")%></td>
    <td width='80'  bgcolor='<%=strBgColor%>' align='right'><%=strNUM_INSCRICOES%></td>
    <td width='80'  bgcolor='<%=strBgColor%>' align='right'><%=objRS("CAPACIDADE") - strNUM_INSCRICOES%></td>
  </tr>
  <%
          strTOT_VAGAS = strTOT_VAGAS + objRS("CAPACIDADE")
          strTOT_INSCRICAO = strTOT_INSCRICAO + strNUM_INSCRICOES
          strTOT_SALDO = strTOT_SALDO + objRS("CAPACIDADE") - strNUM_INSCRICOES
  		  objRS.MoveNext
		  If objRS.EOF Then
          %>
			  <tr align='left' bgcolor='#FFD988'> 
			    <td align="right" class="arial12Bold">&nbsp;</td>
			    <td width="80" align="right" class="arial12Bold">&nbsp;<b><%=strTOT_VAGAS%></b></td>
			    <td align="right" class="arial12Bold">&nbsp;<b><%=strTOT_INSCRICAO%></b></td>
			    <td align="right" class="arial12Bold">&nbsp;<b><%=strTOT_SALDO%></b></td>
			  </tr>		 
		  <%
	      End If
          i = i + 1
     Loop
 
   FechaRecordSet ObjRS
   FechaDBConn ObjConn
' end if
%>
</table>
<table width="640" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td align="right" class="arial10">Gerado em <%=PrepData(now(),true,true)%></td>
  </tr>
</table>
</body>
</html>