<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/athdbConn.asp"--> 
<%
 VerficaAcesso("ADMIN")

Dim strSQL, objRS, ObjConn
Dim strCOD_LOTE, strSQL_CRITERIO, strSQL_INNER
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strCOD_LOTE = Request("var_chavereg")
	
  strSQL = "          SELECT L.COD_LOTE, L.NOME, L.DESCRICAO, L.NOMINAL, L.NUM_CRED_PJ, L.TOTAL_REGISTROS, L.DT_CRIACAO, L.DT_LASTUPDATE, L.SYS_USERCA, L.CRITERIO_EVENTO, L.SQL_CRITERIO, L.SQL_INNER, L.TOTAL_PJ_PF, L.TOTAL_CONTATO, L.IGNORAR_CONTATO, L.CADASTRO_COM_FOTO "
  strSQL = strSQL & " FROM tbl_LOTE L"
  strSQL = strSQL & " WHERE L.COD_LOTE = " & strCOD_LOTE


 'Set objRS = Server.CreateObject("ADODB.Recordset")
 'objRS.Open strSQL, objConn
	Set objRS = objConn.Execute(strSQL)
	
	
'*********************************************************************
'           Função para montar tabela de Lote_Criterio
'*********************************************************************
Function MontaLote
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Nome Campo</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Critério</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Valor</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = "SELECT COD_LOTE_CRITERIO, COD_LOTE, CAMPO, CRITERIO, VALOR " &_
	         "FROM tbl_Lote_Criterio " &_
			 "WHERE COD_LOTE = " & strCOD_LOTE &_
			 " ORDER BY COD_LOTE_CRITERIO"
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("CAMPO") & "</td>")
     	Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("CRITERIO") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("VALOR") & "</td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='95%' border='0' cellspacing='0' cellpadding='0'>")
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

'*********************************************************************
'           Função para montar tabela de Lote_Evento
'*********************************************************************
Function MontaLoteEvento
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Evento</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Critério</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = " SELECT LE.COD_LOTE_EVENTO, LE.COD_LOTE, LE.COD_EVENTO, LE.CRITERIO, E.NOME " &_
	         "   FROM tbl_Lote_Evento AS LE, tbl_Evento AS E " &_
			 "  WHERE LE.COD_EVENTO = E.COD_EVENTO" &_
			 "    AND LE.COD_LOTE = " & strCOD_LOTE &_
			 "  ORDER BY LE.COD_LOTE_EVENTO"
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("NOME") & "</td>")
     	Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("CRITERIO") & "</td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='95%' border='0' cellspacing='0' cellpadding='0'>")
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

'*********************************************************************
'           Função para montar tabela de tbl_Lote_Ordem
'*********************************************************************
Function MontaLoteOrdem
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Nome Campo</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Direção</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Ordem</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = "SELECT COD_LOTE_ORDEM, COD_LOTE, CAMPO, DIRECAO, ORDEM " &_
	         "FROM tbl_Lote_Ordem " &_
			 "WHERE COD_LOTE = " & strCOD_LOTE &_
			 " ORDER BY ORDEM"
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("CAMPO") & "</td>")
     	Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("DIRECAO") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("ORDEM") & "</td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='95%' border='0' cellspacing='0' cellpadding='0'>")
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
	
%>

<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="formdetail" action="update.asp" method="POST">
   <input type="hidden" name="CODIGO" value="<%=objRS("COD_LOTE")%>">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle">
   <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  <td bgcolor="#7DACC5">&nbsp;&nbsp;Detalhes do Lote</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
                  <td align="center"> <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial12">
                      <tr> 
                        <td width="120" align="right">C&oacute;digo:&nbsp;</td>
                        <td><%=objRS("COD_LOTE")%></td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Nome:&nbsp;</td>
                        <td><%=objRS("NOME")%>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Descri&ccedil;&atilde;o:&nbsp;</td>
                        <td><%=objRS("DESCRICAO")%>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Nominal:&nbsp;</td>
                        <td><%=objRS("NOMINAL")%>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Credencial PJ:&nbsp;</td>
                        <td><%=objRS("NUM_CRED_PJ")%>&nbsp;</td>
                      </tr>
                      <tr>
                        <td align="right">Desconsiderar contatos:&nbsp;</td>
                        <td><b><% If objRS("IGNORAR_CONTATO")&""="1" Then Response.Write("Sim") Else Response.Write("Não") End If %>
                        </b> (ao marcar esta opção somente os cadastros <strong>PJ e PF</strong> serão considerados)</td>
                      </tr>
                      <tr>
                        <td align="right">Filtrar cadastro com foto:&nbsp;</td>
                        <td><b>
                          <% If objRS("CADASTRO_COM_FOTO")&""="1" Then Response.Write("Sim") Else Response.Write("N&atilde;o") End If %>
                        </b> (ao marcar esta op&ccedil;&atilde;o somente os <strong>cadastros com foto</strong> serão considerados)</td>
                      </tr>
                      <tr>
                        <td align="right">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="120" align="right">N&uacute;mero Registros:&nbsp;</td>
                        <td>
						<%=objRS("TOTAL_REGISTROS")%>&nbsp;&nbsp;&nbsp;
                        <%
						If objRS("TOTAL_PJ_PF")&"" <> "" Then
						%>
                        (<%=objRS("TOTAL_PJ_PF")%> PJ/PF x <%=objRS("TOTAL_CONTATO")%> Contatos)
                        <%
						End If
						%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Data Cria&ccedil;&atilde;o:&nbsp;</td>
                        <td><%=PrepData(objRS("DT_CRIACAO"),True,True)%>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">&Uacute;ltima Atualiza&ccedil;&atilde;o:&nbsp;</td>
                        <td><%=PrepData(objRS("DT_LASTUPDATE"),True,True)%>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Usu&aacute;rio:&nbsp;</td>
                        <td><%=objRS("SYS_USERCA")%>&nbsp;</td>
                      </tr>
                  </table></td>
          </tr>
          <tr> 
            <td align="center">&nbsp;</td>
          </tr>
<%
		  strSQL_CRITERIO = objRS("SQL_CRITERIO")&""
		  If strSQL_CRITERIO <> "" Then
		    strSQL_CRITERIO = Replace(strSQL_CRITERIO,vbNewLine,"<BR>")
		  %>
          <tr>
            <td align="center"><br><b>Este lote utiliza o(s) seguinte(s) critério(s) extra(s):</b>&nbsp;</td>
          </tr>
		  <tr>
            <td align="center"><%=strSQL_CRITERIO%></td>
          </tr>
		  <tr>
            <td align="center">&nbsp;</td>
          </tr>
		  <%
		  End If
		  %>
		  <%
		  strSQL_INNER = objRS("SQL_INNER")&""
		  If strSQL_INNER <> "" Then
		    strSQL_INNER = Replace(strSQL_INNER,vbNewLine,"<BR>")
		  %>
          <tr>
            <td align="center"><br><b>Este lote esta vinculado a esta(s) consulta(s):</b>&nbsp;</td>
          </tr>
		  <tr>
            <td align="center"><%=strSQL_INNER%></td>
          </tr>
		  <tr>
            <td align="center">&nbsp;</td>
          </tr>
		  <%
		  End If
		  %>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
            <td align="right" background="../img/inbox_bottom_big3.gif"><a href="updateexec.asp?var_chavereg=<%=strCOD_LOTE%>"><img src="../img/Bt_send.gif" width="63" height="17" border="0"></a><a href="update.asp?var_chavereg=<%=strCOD_LOTE%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
        <br>

      <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  
                  <td bgcolor="#7DACC5">&nbsp;Crit&eacute;rios de Pesquisa</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr> 
                        <td colspan="2" align="center"><% MontaLote %></td>
                      </tr>
                  </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strCOD_LOTE%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>

        <br>
        <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
            <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
            <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
          </tr>
        </table>
        <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
          <tr>
            <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
            <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
                <tr>
                  <td bgcolor="#7DACC5">&nbsp;Crit&eacute;rios de Evento </td>
                </tr>
                <tr>
                  <td height="16" align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td align="center">
				     <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
					 <tr>
                        <td colspan="2" align="center">Quando houver mais de um evento voc&ecirc; deseja que a pesquisa seja:</td>
                    </tr>
				    <tr>
				        <td width="100" align="right"><input name="DBVAR_STR_CRITERIO_EVENTO" type="radio" value="AND" <% If objRS("CRITERIO_EVENTO")&"" = "" Or objRS("CRITERIO_EVENTO")&"" = "AND" Then Response.Write("checked") End If %> disabled="disabled"></td>
			            <td width="370">&nbsp;em TODOS os eventos (AND) </td>
			        </tr>
				      <tr>
				        <td align="right"><input name="DBVAR_STR_CRITERIO_EVENTO" type="radio" value="OR" <% If objRS("CRITERIO_EVENTO")&"" = "OR" Then Response.Write("checked") End If %> disabled="disabled"></td>
			            <td align="left">&nbsp;em PELO MENOS um dos eventos (OR) </td>
			        </tr>
                      <tr>
                        <td colspan="2" align="center"><% MontaLoteEvento %></td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
            </table></td>
            <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
          </tr>
        </table>
        <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
            <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
            <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
            <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strCOD_LOTE%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
            <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
          </tr>
        </table>
        <br>

      <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  
                  <td bgcolor="#7DACC5">&nbsp;Ordena&ccedil;&atilde;o do Resultado</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr> 
                        <td colspan="2" align="center"><% MontaLoteOrdem %></td>
                      </tr>
                  </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strCOD_LOTE%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>

        <br>

</tr></td></table>
</form>
</body>
</html>
<%
	FechaRecordSet ObjRS
	FechaDBConn ObjConn
%>