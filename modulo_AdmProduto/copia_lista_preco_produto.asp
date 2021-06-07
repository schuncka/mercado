<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
'*********************************************************************
'           Função para montar tabela de info
'*********************************************************************
Function MontaTabelaPrecos
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellpadding='1' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'>&nbsp;</td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Data Início</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Data Término</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>$$ Lista</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Status</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Qtde. Início</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Qtde. Fim</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = "SELECT PL.COD_PRLISTA, PL.COD_PROD, PL.PRC_LISTA, PL.DT_VIGENCIA_INIC, PL.DT_VIGENCIA_FIM, SP.COD_STATUS_PRECO, SP.STATUS, PL.QTDE_INIC, PL.QTDE_FIM " &_
	         "FROM tbl_PrcLista PL, tbl_Status_Preco SP, tbl_Produtos P " &_
			 "WHERE PL.COD_PROD = " & strCOD_PROD_ORIG &_
			 "  AND PL.COD_STATUS_PRECO = SP.COD_STATUS_PRECO " &_
			 "  AND PL.COD_PROD = P.COD_PROD " &_
			 "  AND P.COD_EVENTO = " & Session("COD_EVENTO") &_
			 "  AND SP.COD_EVENTO = " & Session("COD_EVENTO") &_
			 " ORDER BY PL.DT_VIGENCIA_INIC, PL.DT_VIGENCIA_FIM, SP.COD_STATUS_PRECO"
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'><input type='checkbox' name='var_cod_prlista' value='" & objRS_LOCAL("COD_PRLISTA") & "' checked></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & PrepData(objRS_LOCAL("DT_VIGENCIA_INIC"),True,False) & "</td>")
     	Response.Write("       <td noWrap align='left' bgcolor='" & strBgColor & "'>" & PrepData(objRS_LOCAL("DT_VIGENCIA_FIM"),True,False) & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & FormatNumber(objRS_LOCAL("PRC_LISTA")) & "</td>")
        Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("STATUS") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("QTDE_INIC") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("QTDE_FIM") & "</td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellspacing='0' cellpadding='0'>")
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5'>&nbsp;</td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><img src='img/separator.gif' width='100%' height='2' vspace='5'></td>")
	Response.Write("  </tr>")
	Response.Write("</table>")
	
	FechaRecordSet objRS_LOCAL
End Function

Dim objRS, strSQL, objConn
Dim strCOD_PROD_ORIG, strCOD_PROD_DEST, strCOD_PRLISTA, strCOD_STATUS_PRECO

strCOD_PROD_ORIG = request("var_chavereg")
strCOD_PROD_DEST = request("var_cod_prod_dest")
strCOD_PRLISTA = request("var_cod_prlista")
strCOD_STATUS_PRECO = request("var_cod_status_preco")


%>
<html>
<head>
	<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../_css/csm.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br>

<%
If strCOD_PROD_ORIG <> "" Then
	
  AbreDBConn objConn, CFG_DB_DADOS
	
  If strCOD_PROD_DEST <> "" And strCOD_PRLISTA <> "" And Request("var_acao") = "COPIAR" Then
  
    If Request("var_remove_lista_anterior") = "DEL_LISTA" Then
	  strSQL = "DELETE FROM tbl_PrcLista WHERE COD_PROD = " & strCOD_PROD_DEST
	  objConn.Execute(strSQL)
	End If
  
    strSQL =          " SELECT COD_PROD, DT_VIGENCIA_INIC, DT_VIGENCIA_FIM, PRC_LISTA, QTDE_INIC, QTDE_FIM, COD_STATUS_PRECO"
	strSQL = strSQL & "   FROM tbl_PrcLista "
	strSQL = strSQL & "  WHERE COD_PROD = " & strCOD_PROD_ORIG
	strSQL = strSQL & "    AND COD_PRLISTA IN ("&strCOD_PRLISTA&")"
	
	
	Set objRS = objConn.Execute(strSQL)
	Do While not objRS.EOF
	  If request("var_cod_status_preco") = "" Then
	    strCOD_STATUS_PRECO = objRS("COD_STATUS_PRECO")
	  Else
	    strCOD_STATUS_PRECO = request("var_cod_status_preco")
	  End If
	  strSQL =          "INSERT INTO tbl_PrcLista (COD_PROD, DT_VIGENCIA_INIC, DT_VIGENCIA_FIM, PRC_LISTA, QTDE_INIC, QTDE_FIM, COD_STATUS_PRECO)"
	  strSQL = strSQL & "       VALUES ("&strCOD_PROD_DEST&",'"&PrepDataIve(objRS("DT_VIGENCIA_INIC"),True,False)&"','"&PrepDataIve(objRS("DT_VIGENCIA_FIM"),True,False)&"',"&Replace(Replace(objRS("PRC_LISTA"),".",""),",",".")&","&objRS("QTDE_INIC")&","&objRS("QTDE_FIM")&","&strCOD_STATUS_PRECO&")"
	  'Response.Write(strSQL)
	  'Response.End()
	  objConn.Execute(strSQL)
	  objRS.MoveNext 
	Loop
	FechaRecordSet objRS
  
%>
<table width="550" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr> 
		<td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
		<td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
    	<td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
	</tr>
</table>
<table width="550" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
	<tr> 
    	<td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
        <td>
		
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              	<tr>   
                	
          <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Pre&ccedil;os - C&oacute;pia para outro produto </td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr>
  		          <td align="center">Lista de preço copiada com sucesso.</td>
	          </tr>
  		        <tr>
  		          <td align="center">&nbsp;</td>
	          </tr>
			</table>
		</td>
    	<td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
	</tr>
</table>
<table width="550" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:window.close();"><img src="../img/Bt_fecha.gif" width="63" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
</table>
<%
 
  Else
	
	strSQL = " SELECT * FROM tbl_Produtos WHERE COD_PROD = " & strCOD_PROD_ORIG
	Set objRS = objConn.execute(strSQL)
	
%>

<table width="550" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr> 
		<td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
		<td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
    	<td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
	</tr>
</table>
<table width="550" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
	<tr> 
    	<td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
        <td>
		
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              	<tr>   
                	
          <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Pre&ccedil;os - C&oacute;pia para outro produto </td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr>
  		          <td align="center">

                   <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="formproduto" action="copia_lista_preco_produto.asp" method="POST">
                      <input type="hidden" name="var_acao" value="COPIAR">
                      <input type="hidden" name="var_chavereg" value="<%=strCOD_PROD_ORIG%>">
                      <tr>
                        <td colspan="2"><%=objRS("TITULO")%></td>
                      </tr>
                      <tr>
                        <td colspan="2" align="center"><% MontaTabelaPrecos %></td>
                      </tr>
                      <tr>
                        <td width="100" align="right">&nbsp;</td>
                        <td >&nbsp;</td>
                      </tr>

                      <tr>
                        <td align="right">Produto:&nbsp;</td>
                        <td><select name="var_cod_prod_dest" class="textbox380">
                            <%
						strSQL =          " SELECT COD_PROD, TITULO FROM tbl_PRODUTOS "
						strSQL = strSQL & "  WHERE COD_EVENTO = " & Session("COD_EVENTO")
						'strSQL = strSQL & "    AND COD_PROD <> " & strCOD_PROD_ORIG
						MontaCombo strSQL, "COD_PROD", "TITULO", ""
						%>
                          </select>                        </td>
                      </tr>
                      <tr>
                        <td align="right">Categoria:&nbsp;</td>
                        <td><select name="var_cod_status_preco" class="textbox380">
                              <option value="" selected>Manter a(s) mesma(s) categoria(s)</option>
                            <%
						strSQL =          " SELECT COD_STATUS_PRECO, STATUS FROM TBL_STATUS_PRECO "
						strSQL = strSQL & "  WHERE COD_EVENTO = " & Session("COD_EVENTO")
						MontaCombo strSQL, "COD_STATUS_PRECO", "STATUS", ""
						%>
                          </select>                        </td>
                      </tr>
                      <tr>
                        <td align="right">&nbsp;</td>
                        <td><label>
                        <input type="checkbox" name="var_remove_lista_anterior" value="DEL_LISTA">
 remover registro(s) anterior(es) da lista de pre&ccedil;o deste produto                </label></td>
                      </tr>
                    </form>
	              </table></td>
	          </tr>
  		        <tr>
  		          <td align="center">&nbsp;</td>
	          </tr>
			</table>
		</td>
    	<td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
	</tr>
</table>
<table width="550" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:document.formproduto.submit();"><img src="../img/bt_SAVE.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
</table>
<%
    FechaRecordSet(objRS)
  End If
 
  FechaDBConn(objConn)
End If
%>
<br>
</body>
</html>