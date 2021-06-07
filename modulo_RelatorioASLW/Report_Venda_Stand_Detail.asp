<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"-->
<!--#include file="../_scripts/scripts.js"-->
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"-->
<%
Function CalculaSaldo(prCOD_INSCRICAO)
Dim objRSDetail, strVLR_COMPRADO, strVLR_PAGO
   
	 strVLR_COMPRADO = 0
	 strVLR_PAGO = 0
	  
     strSQL = " SELECT " & _
  	          "   SUM(if( isnull( tbl_Inscricao_Produto.VLR_PAGO ),0,tbl_Inscricao_Produto.VLR_PAGO ) * tbl_Inscricao_Produto.QTDE) As TOT_VLR_COMPRADO " & _
  	          " FROM tbl_Inscricao_Produto" & _
    	      " WHERE tbl_Inscricao_Produto.COD_INSCRICAO = " & prCOD_INSCRICAO
'     objRSDetail.Open strSQL, objConn
     set objRSDetail = objConn.Execute(strSQL)  
     If not objRSDetail.EOF Then
       If not IsNull(objRSDetail("TOT_VLR_COMPRADO")) Then
         strVLR_COMPRADO = objRSDetail("TOT_VLR_COMPRADO")
       End If
     End If
     ObjRSDetail.Close

     ' Pega tudo que ele já pagou
     strSQL = " SELECT " & _
              "   SUM(tbl_Caixa_Sub_INSC.VLR) As TOT_VLR_PAGO" & _
              " FROM tbl_Caixa_Sub_INSC" & _
              " WHERE tbl_Caixa_Sub_INSC.COD_INSCRICAO = " & prCOD_INSCRICAO
'     objRSDetail.Open strSQL, objConn
     set objRSDetail = objConn.Execute(strSQL)  
	 If not objRSDetail.EOF Then
       If not IsNull(objRSDetail("TOT_VLR_PAGO")) Then
         strVLR_PAGO =  objRSDetail("TOT_VLR_PAGO")
       End If
     End If
	 ObjRSDetail.Close
	 
  strVLR_COMPRADO = FormatNumber(strVLR_COMPRADO)
  strVLR_PAGO = FormatNumber(strVLR_PAGO)
	 
'  Response.Write(prCOD_INSCRICAO & " : " & strVLR_PAGO & " - " & strVLR_COMPRADO  & " = " & strVLR_PAGO - strVLR_COMPRADO & "<BR>")
  CalculaSaldo = strVLR_PAGO - strVLR_COMPRADO 
End Function

'--------------------------------------------------------------------
  Dim objConn, objRS, objRSDetail, strSQL, i, cont, numerr, abouterr, aviso
  Dim strBgColor, strBgColorHEADER, strBgColorINFO1, strBgColorINFO2, strBgColorSUBTOTAL
  Dim strCOD_REL, strACAO, strDESCRICAO, strPARCELAS, strSQLRel
  
  strACAO      = Request("var_acao")
  strSQLRel    = Request("var_strParam") 
  strDESCRICAO = Request("var_descricao")


  AbreDBConn ObjConn, CFG_DB_DADOS

  Sub ExibeMsg(StrAviso, StrDesc)
	response.write ("<p align='center'><font face='Arial' size='2'><b>.:: AVISO ::.</b></font></p>")
	response.write ("<p align='center'><font face='Arial' size='2'>" & StrAviso & "<br><br></font></p><hr>")
	response.write ("<p align='center'><table width='600' border='0'><tr><td><font face='Arial' size='2'>" & StrDesc & "</font></td></tr></table></p><hr>")	
	response.write ("<p align='right'><a href='JavaScript:history.back();location.reload();' target='_parent'><img src='../img/icon_exec.gif' width='20' height='17' border='0' alt='para executar novamente clique aqui'></a></p>")

	response.End
  End Sub
  
  if strACAO = ".xls" Or strACAO = ".doc" then
	Response.AddHeader "Content-Type","application/x-msdownload"
	Response.AddHeader "Content-Disposition","attachment; filename=Relatorio_" & Session.SessionID & "_" & Replace(Time,":","") & strACAO
  end if
  
  strBgColorHEADER   = "#FFCC66"
  strBgColorINFO1    = "#FFE8B7"
  strBgColorINFO2    = "#FFFFFF"
  strBgColorSUBTOTAL = "#FFD988"

  strSQLRel =             " SELECT tbl_Produtos.COD_PROD, tbl_Produtos.TITULO, tbl_Produtos.DESCRICAO, tbl_Produtos.REF_NUMERICA, "
  strSQLRel = strSQLRel & "        tbl_Inscricao_Produto.COD_INSCRICAO, tbl_Inscricao_Expositor.NOME_MAPA, tbl_Inscricao_Produto.VLR_PAGO "
  strSQLRel = strSQLRel & "   FROM (tbl_Produtos LEFT JOIN tbl_Inscricao_Produto ON tbl_Produtos.COD_PROD = tbl_Inscricao_Produto.COD_PROD) "
  strSQLRel = strSQLRel & "                      LEFT JOIN tbl_Inscricao_Expositor ON tbl_Inscricao_Produto.COD_INSCRICAO = tbl_Inscricao_Expositor.COD_INSCRICAO "
  strSQLRel = strSQLRel & " WHERE tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")
  strSQLRel = strSQLRel & " ORDER BY tbl_Produtos.COD_PROD"

'	On Error Resume Next
      Set objRS = Server.CreateObject("ADODB.Recordset")
      objRS.CursorType = adOpenStatic
      objRS.PageSize = CInt(3)
      objRS.Open strSQLRel, objConn
	  
	  If Not objRS.Eof And Not objRS.Bof Then
	      objRS.AbsolutePage = 1
	
	      'Err.Raise 6
    	  numerr = Err.number
	      abouterr = Err.description
    	  If numerr <> 0 Then
	        aviso = "Warning number " & numerr & " of the type <br>" & abouterr & "<br><br>Tipo de dado no parâmetro pode não ser compatível. Verifique na descrição do relatório as instruções sobre preenchimento adequado dos parâmetros da consulta. Para executar novamente utilize o ícone logo abaixo.<br><br>" 
			ExibeMsg aviso, strDescricao
	      End If
	  Else
		aviso = "Consulta não encontrou dados.<br><br><br>Favor avaliar consulta e/ou parâmetros. Verifique na descrição do relatório as instruções sobre preenchimento adequado dos parâmetros da consulta. Para executar novamente utilize o ícone logo abaixo.<br><br>" 
		ExibeMsg aviso, strDescricao
	  End If
	  
  Response.Buffer = True
%>
<html>
<head>
<title></title>
<% if strACAO="" then %>
	<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<% end if %>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form name="FormPrSQL" >
  <input name="sqlBUFFER"  type="hidden" value="<%=strSQLRel%>">
  <input name="acaoBUFFER" type="hidden" value="<%=strACAO%>">
  <input name="descBUFFER" type="hidden" value="<%=strDESCRICAO%>">
</form>
<table width='100%' cellspacing='0' cellpadding='0' border='1' bordercolor="#FFFFFF">
  <tr bgcolor='<%=strBgColorHEADER%>' class='arial12Bold'> 
    <td><b>CODIGO</b> </td>
    <td><b>TITULO</b></td>
    <td><b>DESCRICAO</b></td>
    <td><b>REFERENCIA</b></td>
<% 
    Dim j
	Dim arrSTATUS_PRECO()
	j = 0
    strSQL = "SELECT COD_STATUS_PRECO, STATUS FROM tbl_STATUS_PRECO WHERE COD_EVENTO = " & Session("COD_EVENTO") & " ORDER BY COD_STATUS_PRECO"
	Set objRSDetail = objConn.Execute(strSQL)
	Do While not objRSDetail.EOF
	%>
	<td><b><%=objRSDetail("STATUS")%></b></td>
	<%
	  ReDim PRESERVE arrSTATUS_PRECO(j+1)
	  arrSTATUS_PRECO(j) = objRSDetail("COD_STATUS_PRECO")
	  j = j + 1
	  objRSDetail.MoveNext 
	Loop
	FechaRecordSet objRSDetail
%>
    <td><b>COMPRADOR</b></td>
	<td><b>VALOR FINAL</b></td>
	<td><b>PRAZOS</b></td>
	<td><b>SALDO</b></td>
  </tr>
<%
  strBgColor = strBgColorINFO1
  cont = 0
  Do While Not objRS.EOF
    strPARCELAS = ""
    If not IsNull(objRS("COD_INSCRICAO")) Then
      strSQL = "SELECT PARCELAS FROM tbl_INSCRICAO WHERE COD_INSCRICAO = " & objRS("COD_INSCRICAO") & " AND COD_EVENTO = " & Session("COD_EVENTO")
	  Set objRSDetail = objConn.Execute(strSQL)
	  If not objRSDetail.EOF Then
	    strPARCELAS = objRSDetail("PARCELAS")
	  End If
	  FechaRecordSet objRSDetail
	End If
%>
  <tr bgcolor='<%=strBgColor%>' class='arial11'> 
    <td><%=objRS("COD_PROD")%></td>
    <td><%=objRS("TITULO")%></td>
    <td><%=objRS("DESCRICAO")%></td>
    <td><%=objRS("REF_NUMERICA")%></td>
<%
    strSQL = "SELECT PRC_LISTA FROM tbl_PRCLISTA WHERE COD_PROD = " & objRS("COD_PROD") & " AND COD_STATUS_PRECO IN (" & join(arrSTATUS_PRECO,",") & "0) ORDER BY COD_STATUS_PRECO"
	Set objRSDetail = objConn.Execute(strSQL)
	Do While not objRSDetail.EOF
	%>
	<td align="right"><% If not IsNull(objRSDetail("PRC_LISTA")) Then Response.Write(FormatNumber(objRSDetail("PRC_LISTA"))) End If %></td>
	<%
	  objRSDetail.MoveNext
	Loop
	FechaRecordSet objRSDetail	
%>
    <td><%=objRS("NOME_MAPA")%></td>
	<td align="right"><% If not IsNull(objRS("VLR_PAGO")) Then Response.Write(FormatNumber(objRS("VLR_PAGO"))) End If %></td>
	<td align="center"><%=strPARCELAS%></td>
	<td align="right"><% If not IsNull(objRS("COD_INSCRICAO")) Then Response.Write(FormatNumber(CalculaSaldo(objRS("COD_INSCRICAO")))) End If %></td>
  </tr>
<%
		objRS.MoveNext
		cont = cont + 1
		If cont mod 1000 Then
		  Response.Flush
		End If
	Loop
%>
</table>
</body>
</html>
<%
	
  FechaRecordSet ObjRS
  FechaDBConn ObjConn
  Response.Flush
%>
