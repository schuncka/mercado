<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
    VerficaAcesso("ADMIN")

	Dim strSQL, objRS, ObjConn
	Dim strCOD_PROD, strIMG, strSec
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strCOD_PROD = Replace(Request("var_chavereg"),"'","''")
	strSec = request("sec")
	strSQL = "SELECT * " & _
	         "  FROM tbl_PRODUTOS " & _
			 " WHERE COD_PROD = " & strCOD_PROD & _
			 "   AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")

	set objRS = objConn.Execute(strSQL)

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
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_listaprecos'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='15'><img width='15' height='1' src='../img/1x1.gif'></td>")	
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Data Início</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Data Término</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>$$ Lista</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Categoria</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Qtde. Início</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Qtde. Fim</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Capacidade</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Usr At.</strong></td>")
'	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Dt. At.</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = "SELECT PL.COD_PRLISTA, PL.COD_PROD, PL.PRC_LISTA, PL.DT_VIGENCIA_INIC, PL.DT_VIGENCIA_FIM, SP.COD_STATUS_PRECO, SP.STATUS, PL.QTDE_INIC, PL.QTDE_FIM, PL.CAPACIDADE, PL.SYS_DATAAT, PL.SYS_USERAT " &_
	         "FROM tbl_PrcLista PL, tbl_Status_Preco SP, tbl_Produtos P " &_
			 "WHERE PL.COD_PROD = " & strCOD_PROD &_
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
		Response.Write("       <td width='15' align='center'>")
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("COD_PRLISTA") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'><a style=""cursor:pointer"" onClick=""javascript:window.open('update_produto_preco.asp?var_chavereg=" & objRS_LOCAL("COD_PRLISTA") & "&var_cod_prod=" & strCOD_PROD & "','proevento_produto_preco','width=600,height=250,scrollbars=yes')""><img src=""../img/icon_write.gif"" border=""0""></a></td>")	
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & PrepData(objRS_LOCAL("DT_VIGENCIA_INIC"),True,False) & "</td>")
     	Response.Write("       <td noWrap align='left' bgcolor='" & strBgColor & "'>" & PrepData(objRS_LOCAL("DT_VIGENCIA_FIM"),True,False) & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>")
		If objRS_LOCAL("PRC_LISTA")&"" <> "" Then
		  Response.Write(FormatNumber(objRS_LOCAL("PRC_LISTA")))
		End If
		Response.Write("       </td>")
        Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("STATUS") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("QTDE_INIC") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("QTDE_FIM") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("CAPACIDADE") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "' class='triangle-up-right' alt='" & PrepData(objRS_LOCAL("SYS_DATAAT"),True,True) & "' title='"& PrepData(objRS_LOCAL("SYS_DATAAT"),True,True) &"'>" & objRS_LOCAL("SYS_USERAT") &"</td>")
'		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" &  & "</td>")
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
	Response.Write("          <td bgcolor='#7DACC5'> <img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_listaprecos'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a>")
	Response.Write("          </td>")
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
'           Função para montar tabela de palestrantes
'*********************************************************************
Function MontaListaPalestrantes
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellpadding='1' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_listapalestrantes'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='15'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Nome</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Tema</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Função</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>e-mail</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Início</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Término</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Confirmado</strong></td>")
	Response.Write("        </tr>")
    '<!-- header da tabela ----------------------------------------------------------->
	
	strSQL = " SELECT P.COD_PALESTRANTE, E.NOMECLI, E.EMAIL1, P.CARGO, PP.FUNCAO, PP.TEMA, PP.IDAUTO, PP.HORA_INI, PP.HORA_FIM, PP.CONFIRMADO, PP.ORDEM " &_
			 " FROM tbl_Palestrante AS P, tbl_Palestrante_Evento AS PE, tbl_Produtos_Palestrante AS PP, tbl_Empresas AS E" &_
			 " WHERE P.COD_PALESTRANTE = PE.COD_PALESTRANTE " &_
			 " AND PE.COD_EVENTO = " & Session("COD_EVENTO") &_
			 " AND P.COD_PALESTRANTE = PP.COD_PALESTRANTE " &_
			 " AND PP.COD_PALESTRANTE = PE.COD_PALESTRANTE " &_
			 " AND PP.COD_PROD = " & strCOD_PROD &_
			 " AND P.COD_EMPRESA = E.COD_EMPRESA " &_
			 " ORDER BY PP.ORDEM, PP.FUNCAO, PP.HORA_INI, PP.HORA_FIM, E.NOMECLI " 
			 
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td width='15' align='center'>")
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("IDAUTO") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'><a style=""cursor:pointer"" onClick=""javascript:window.open('update_produto_palestrante.asp?var_chavereg=" & objRS_LOCAL("IDAUTO") & "&var_cod_prod=" & strCOD_PROD & "','proevento_produto_palestrante','width=600,height=400,scrollbars=yes')""><img src=""../img/icon_write.gif"" border=""0""></a></td>")	
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("NOMECLI") & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("TEMA") & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("FUNCAO") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("EMAIL1") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>")
		If IsDate(objRS_LOCAL("HORA_INI")) Then
		  Response.Write( Right("0"&Hour(objRS_LOCAL("HORA_INI")),2) & ":" & Right("0"&Minute(objRS_LOCAL("HORA_INI")),2) )
	    End If
		Response.Write("       </td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>")
		If IsDate(objRS_LOCAL("HORA_FIM")) Then
		  Response.Write( Right("0"&Hour(objRS_LOCAL("HORA_FIM")),2) & ":" & Right("0"&Minute(objRS_LOCAL("HORA_FIM")),2) )
	    End If
		Response.Write("       </td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" )
		Select Case objRS_LOCAL("CONFIRMADO")&""
		  Case "0"
			Response.Write("Não")
		  Case "1"
			Response.Write("Sim")
		  Case Else 
			Response.Write("-") 
		End Select
		Response.Write("       </td>")
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
	Response.Write("          <td bgcolor='#7DACC5'> <img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_listapalestrantes'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a>")
	Response.Write("          </td>")
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

Function MontaListaRestricoes
Dim objRS_LOCAL, strSQL
Dim i, strBgColor, strRestricao
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellpadding='1' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_listarestricao'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")	
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Produto</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Restrição</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Cod.Prod Equiv.</strong></td>")	
	Response.Write("        </tr>")
    '<!-- header da tabela ----------------------------------------------------------->
	
	strSQL = " SELECT PR.ID_AUTO, P.TITULO, PR.RESTRICAO,PR.COD_PROD_EQUIV " &_
			 " FROM TBL_PRODUTOS AS P, tbl_PRODUTOS_RESTRICAO AS PR " &_
			 " WHERE P.COD_PROD = PR.COD_PROD_RELACAO " &_
			 " AND PR.COD_PROD = " & strCOD_PROD &_
			 " ORDER BY TITULO " 
			 
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		
		If objRS_LOCAL("RESTRICAO") = -1 Then
			strRestricao = "Não permite comprar junto (Erro)"
		ElseIf objRS_LOCAL("RESTRICAO") = 1 Then
			strRestricao = "Não permite comprar junto (Alerta)"
		ElseIf objRS_LOCAL("RESTRICAO") = 0 Then
		    strRestricao = "Compra Obrigatória"
		End If
			
		
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td width='15' align='center'>")
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("ID_AUTO") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("TITULO") & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "'>" & strRestricao & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("COD_PROD_EQUIV") & "</td>")		
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
	Response.Write("          <td bgcolor='#7DACC5'> <img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_listarestricao'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a>")
	Response.Write("          </td>")
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

Function MontaListaCombo
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellpadding='1' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_listacombo'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")	
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='15'><img width='15' height='1' src='../img/1x1.gif'></td>")	
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='40%'><strong>Produto</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='30%'><strong>Status</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='15%'><strong>Desconto Perc.</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='15%'><strong>Desconto Valor</strong></td>")
	Response.Write("        </tr>")
    '<!-- header da tabela ----------------------------------------------------------->
	
	strSQL = " SELECT PC.ID_AUTO, P.TITULO, PC.DESCONTO_PERC, PC.DESCONTO_VLR, SP.STATUS  " &_
			 "   FROM TBL_PRODUTOS AS P, tbl_PRODUTOS_COMBO AS PC, tbl_STATUS_PRECO AS SP " &_
			 "  WHERE P.COD_PROD = PC.COD_PROD_RELACAO " &_
			 "    AND PC.COD_STATUS_PRECO = SP.COD_STATUS_PRECO " &_
			 "    AND PC.COD_PROD = " & strCOD_PROD &_
			 "  ORDER BY TITULO " 
			 
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td width='15' align='center'>")
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("ID_AUTO") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'><a style=""cursor:pointer"" onClick=""javascript:window.open('update_produto_combo.asp?var_chavereg=" & objRS_LOCAL("ID_AUTO") & "&var_cod_prod=" & strCOD_PROD & "','proevento_produto_preco','width=600,height=250,scrollbars=yes')""><img src=""../img/icon_write.gif"" border=""0""></a></td>")	
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("TITULO") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("STATUS") & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "' align='right'>&nbsp;" & objRS_LOCAL("DESCONTO_PERC") & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "' align='right'>&nbsp;" & objRS_LOCAL("DESCONTO_VLR") & "</td>")
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
	Response.Write("          <td bgcolor='#7DACC5'> <img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_listacombo'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a>")
	Response.Write("          </td>")
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


Function MontaTabelaDocumentos
Dim objRS_LOCAL, strSQL
Dim i, strBgColor

	strSQL = "SELECT t1.id_documento, t1.rotulo, area " &_
	         "FROM tbl_documentos AS t1 " &_
			 "WHERE t1.cod_evento = " & Session("COD_EVENTO") &_
			 "  AND t1.COD_PROD = " & strCOD_PROD &_
			 " ORDER BY t1.rotulo"
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	If Not objRS_LOCAL.EOF Then
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
	'<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_documentos'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Rotulo</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr height=""20"">")
		Response.Write("       <td width='15' align='center'>")
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("id_documento") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'><a style=""cursor:pointer"" onClick=""javascript:window.open('update_documento.asp?var_chavereg=" & objRS_LOCAL("id_documento") & "','proevento_forma_pgto','width=600,height=170,scrollbars=yes')""><img src=""../img/icon_write.gif"" border=""0""></a></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("rotulo") & "</td>")
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
	Response.Write("          <td bgcolor='#7DACC5'> <img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_documentos'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a></td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr><td height=""20"" colspan='2'></td></tr>")
	Response.Write("</table>")
	
	End If

	FechaRecordSet objRS_LOCAL
End Function

%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
<!--
function ToggleCheckAll(formname) 
{
 var i = 0;
 while ( eval("document." + formname + ".msguid_" + i) != null )
  {
   eval("document." + formname + ".msguid_" + i).checked = ! eval("document." + formname + ".msguid_" + i).checked;
   i = i + 1;
  }
}

function DeleteSelect (formname)
{
 codigos = '';
 var i = 0;
 while ( eval("document." + formname + ".msguid_" + i) != null )
  {
    if (eval("document." + formname + ".msguid_" + i) != null) 
	{
      if (eval("document." + formname + ".msguid_" + i).checked) 
       {
	    if (codigos != '') 
	     {
	      codigos = codigos + ',' + eval("document." + formname + ".msguid_" + i).value;
	     }
	    else
	     {
	      codigos = eval("document." + formname + ".msguid_" + i).value;
	     }
      }
    }
    i = i + 1;
  }
 if (codigos != '') 
 {
  a=confirm("Você quer apagar definitivamente o(s) ítem(ns) selecionado(s)?");
  if (a==true)
  {
    var strpath = '';
  	if (formname == 'form_listaprecos')
		strpath = '../_database/athDeleteToDB.asp?default_table=tbl_PrcLista' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=COD_PRLISTA' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_admproduto/update.asp?var_chavereg=<%=strCOD_PROD%>';
  	if (formname == 'form_listapalestrantes') 
		strpath = '../_database/athDeleteToDB.asp?default_table=tbl_Produtos_Palestrante' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=IDAUTO' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_admproduto/update.asp?var_chavereg=<%=strCOD_PROD%>';
		if (formname == 'form_listacombo')
		strpath = '../_database/athDeleteToDB.asp?default_table=tbl_Produtos_Combo' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=ID_AUTO' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_admproduto/update.asp?var_chavereg=<%=strCOD_PROD%>';
  	if (formname == 'form_listarestricao') 
		strpath = '../_database/athDeleteToDB.asp?default_table=tbl_Produtos_Restricao' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=ID_AUTO' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_admproduto/update.asp?var_chavereg=<%=strCOD_PROD%>';
		
	if (formname == 'form_documentos')
		strpath = '../_database/athDeleteToDB.asp?default_table=tbl_documentos' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=id_documento' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_admproduto/update.asp?var_chavereg=<%=strCOD_PROD%>';
	document.location = strpath;

	document.location = strpath;
  }
}

return false;
}

function viewdoc(doc) {
  var conteudo = '';
 
  conteudo = eval('document.formupdate.var_' + doc + '_texto.value;');
  /* Estava enviadndo por metodo GET...  
     Foi modificado para enviao via metodo POST (by Aless)
     window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1'); */

  var myform  = document.createElement("form");
  var myinput = document.createElement("input");

  myinput.value = conteudo;
  myinput.type  = "hidden";
  myinput.name  = "var_html";
  myform.name   = "formviewdoc";
  myform.action = "viewhtml.asp";
  myform.method = "post";
  myform.target = "_blank";  
  myform.appendChild(myinput);
  document.body.appendChild(myform);
  myform.submit();
}

function SetFormField(formname, fieldname, valor) {
  if ( (formname != "") && (fieldname != "") && (valor != "") ) {
    eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
  }
}

function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}


//-->
</script>

<!-- jQuery -->
<script type="text/javascript" src="../_scripts/jquery-1.2.1.min.js"></script>

<!-- required plugins -->
<script type="text/javascript" src="../_scripts/date.js"></script>

<!-- jquery.datePicker.js -->
<script type="text/javascript" src="../_scripts/jquery.datePicker.js"></script>
<!-- datePicker required styles -->

<!-- page specific scripts -->
<script type="text/javascript" charset="utf-8">
            $(
			function()
            {
				$('.date-pick').datePicker();
            }
			);
</script>

<link rel="stylesheet" type="text/css" media="screen" href="../_css/datePicker.css">
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle"><br>
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
          <tr><td bgcolor="#7DACC5">&nbsp;&nbsp;Alteração de Produtos</td></tr>
          <tr><td height="18" align="center">&nbsp;</td></tr>
          <tr> 
                  <td align="center">
				   <table width="98%" border="0" cellpadding="2" cellspacing="0" class="arial11">
                    <form name="formupdate" action="updateexec.asp" method="POST">
                      <tr> 
                        <td width="120" align="right">*C&oacute;digo:&nbsp;</td>
                        <td><input name="var_cod_prod" type="text" class="textbox100" value="<%=objRS("COD_PROD")%>" size="20"></td>
                      </tr>
                      <tr> 
                        <td align="right">*Grupo:&nbsp;</td>
                        <td><input name="var_grupo" type="text" class="textbox180" value="<%=objRS("GRUPO")%>" size="20"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">*T&iacute;tulo:&nbsp;</td>
                        <td align="left"><input name="var_titulo" type="text" class="textbox380" value="<%=replace(objRS("TITULO")&"","""","&quot;")%>" size="20"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">*T&iacute;tulo Abreviado:&nbsp;</td>
                        <td align="left"><input name="var_titulo_mini" type="text" class="textbox380" value="<%=replace(objRS("TITULO_MINI")&"","""","&quot;")%>" size="20" maxlength="45"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">*Descri&ccedil;&atilde;o:&nbsp;</td>
                        <td align="left"><textarea name="var_descricao" rows="3" class="textbox380" cols="20"><%=objRS("DESCRICAO")%></textarea>
                        </td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">*Descri&ccedil;&atilde;o HTML:&nbsp;</td>
                        <td align="left"><textarea name="var_descricao_html" rows="3" class="textbox380" cols="20"><%=objRS("DESCRICAO_HTML")%></textarea>
                        </td>
                      </tr>
                      
                      <tr> 
                        <td align="right" valign="top">*Descri&ccedil;&atilde;o HTML Inglês:&nbsp;</td>
                        <td align="left"><textarea name="var_descricao_html_ing" rows="3" class="textbox380" cols="20"><%=objRS("DESCRICAO_HTML_ING")%></textarea>
                        </td>
                      </tr>
                      
                      <tr> 
                        <td align="right" valign="top">*Descri&ccedil;&atilde;o HTML Espanhol:&nbsp;</td>
                        <td align="left"><textarea name="var_descricao_html_esp" rows="3" class="textbox380" cols="20"><%=objRS("DESCRICAO_HTML_ESP")%></textarea>
                        </td>
                      </tr>
                      
                      <tr> 
                        <td align="right">Capacidade:&nbsp;</td>
                        <td align="left"><input name="var_capacidade" type="text" class="textbox70" value="<%=objRS("CAPACIDADE")%>" size="20"></td>
                      </tr>
					  <tr> 
                        <td align="right">Refer&ecirc;ncia Num&eacute;rica:&nbsp;</td>
                        <td align="left"><input name="var_ref_numerica" type="text" class="textbox70" value="<%=objRS("REF_NUMERICA")%>" size="20"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Data/Hora In&iacute;cio:&nbsp;</td>
                        <td align="left"><input name="var_dt_ocorrencia" type="text" value="<%=PrepData(objRS("DT_OCORRENCIA"),True,True)%>" size="20" id="date1" class="date-pick"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Data/Hora T&eacute;rmino:&nbsp;</td>
                        <td align="left"><input name="var_dt_termino" type="text" value="<%=PrepData(objRS("DT_TERMINO"),True,True)%>" size="20" id="date2" class="date-pick"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Local:&nbsp;</td>
                        <td align="left"><input name="var_local" type="text" class="textbox380" value="<%=objRS("LOCAL")%>" size="20"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Carga Hor&aacute;ria:&nbsp;</td>
                        <td align="left"><input name="var_carga_horaria" type="text" class="textbox380" value="<%=objRS("CARGA_HORARIA")%>" size="20"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">ID Start Comp.:&nbsp;</td>
                        <td align="left"><input name="var_num_competidor_start" type="text" class="textbox70" value="<%=objRS("NUM_COMPETIDOR_START")%>" size="20"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Proshop Questionário:&nbsp;</td>
                        <td align="left"><input name="var_proshop_questionario" type="text" class="textbox70" value="<%=objRS("proshop_questionario")%>" size="20"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Sinopse:&nbsp;</td>
                        <td align="left"><textarea name="var_sinopse" rows="3" class="textbox380" cols="20"><%=objRS("SINOPSE")%></textarea></td>
                      </tr>
                      <tr> 
                        <td align="right">Dinâmica:&nbsp;</td>
                        <td><textarea name="var_dinamica" rows="3" class="textbox380"><%=objRS("DINAMICA")%></textarea></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Config. Certificado:&nbsp;</td>
                        <td align="left"><textarea name="var_certificado_texto" rows="6" class="textbox380" cols="20"><%=ReturnCaracterEspecial(objRS("CERTIFICADO_TEXTO")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificado');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Config. Diploma:&nbsp;</td>
                        <td align="left"><textarea name="var_diploma_texto" rows="6" class="textbox380" cols="20"><%=ReturnCaracterEspecial(objRS("DIPLOMA_TEXTO")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diploma');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Config. Voucher:&nbsp;</td>
                        <td align="left"><textarea name="var_voucher_texto" rows="6" class="textbox380" cols="20"><%=ReturnCaracterEspecial(objRS("VOUCHER_TEXTO")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('voucher');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>
					  
                      <tr> 
                        <td align="right" valign="top">Config. Voucher US:&nbsp;</td>
                        <td align="left"><textarea name="var_voucher_texto_us" rows="6" class="textbox380" cols="20"><%=ReturnCaracterEspecial(objRS("VOUCHER_TEXTO_US")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('voucher_us');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>
					  
                      <tr> 
                        <td align="right" valign="top">Config. Voucher ES:&nbsp;</td>
                        <td align="left"><textarea name="var_voucher_texto_es" rows="6" class="textbox380" cols="20"><%=ReturnCaracterEspecial(objRS("VOUCHER_TEXTO_ES")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('voucher_es');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td align="right" valign="top">Certificado PDF:&nbsp;</td>
                        <td align="left"><textarea name="var_certificadopdf_texto" rows="6" class="textbox380"><%=ReturnCaracterEspecial(objRS("CERTIFICADO_PDF")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">Orientação:</td>
                        <td align="left">
                         <select id="var_certificado_pdf_orientacao" name="var_certificado_pdf_orientacao" class="textbox100">
                           <option value="RETRATO"  <%if (objRS("CERTIFICADO_PDF_ORIENTACAO")="RETRATO")  then response.write("selected") %>>RETRATO</option>
                           <option value="PAISAGEM" <%if (objRS("CERTIFICADO_PDF_ORIENTACAO")="PAISAGEM") then response.write("selected") %>>PAISAGEM</option>
                         </select>
                        </td>
                      </tr>

                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificadopdf');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td align="right" valign="top">Diploma PDF:&nbsp;</td>
                        <td align="left"><textarea name="var_diplomapdf_texto" rows="6" class="textbox380"><%=ReturnCaracterEspecial(objRS("DIPLOMA_PDF")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diplomapdf');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td align="right" valign="top">Grupo Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_grupointl_texto" rows="6" class="textbox380"><%=ReturnCaracterEspecial(objRS("GRUPO_INTL")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('grupointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Titulo Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_titulointl_texto" rows="6" class="textbox380"><%=ReturnCaracterEspecial(objRS("TITULO_INTL")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('titulointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Descrição Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_descricaointl_texto" rows="6" class="textbox380"><%=ReturnCaracterEspecial(objRS("DESCRICAO_INTL")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('descricaointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td align="right" valign="top">Config. Certificado Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_certificadointl_texto" rows="6" class="textbox380" cols="20"><%=ReturnCaracterEspecial(objRS("CERTIFICADO_TEXTO_INTL")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificadointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Config. Diploma Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_diplomaintl_texto" rows="6" class="textbox380" cols="20"><%=ReturnCaracterEspecial(objRS("DIPLOMA_TEXTO_INTL")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diplomaintl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>

					  
                      
                      <tr> 
                        <td align="right" valign="top">Certificado PDF Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_certificadopdfintl_texto" rows="6" class="textbox380"><%=ReturnCaracterEspecial(objRS("CERTIFICADO_PDF_INTL")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificadopdfintl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td align="right" valign="top">Diploma PDF Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_diplomapdfintl_texto" rows="6" class="textbox380"><%=ReturnCaracterEspecial(objRS("DIPLOMA_PDF_INTL")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diplomapdfintl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>


	                  <tr>
	                    <td align="right">&nbsp;</td>
	                    <td align="left">&nbsp;</td>
                      </tr>
	                  <tr> 
                        <td align="right">Outros produtos que&nbsp;<br>garantem acesso:&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190"><input name="var_cod_prod_valida" type="text" class="textbox180" value="<%=objRS("COD_PROD_VALIDA")%>" size="20"></td>
                              <td width="190">Ex: &quot;3000,3001&quot; - Quem 
                                comprou o curso 3000 ou o curso 3001 TAMB&Eacute;M 
                                pode assistir esse curso</td>
                            </tr>
                          </table>
                          
                        </td>
	                  </tr>
                      <tr>
					    <td align="right" bgcolor="#CCCCCC">Regra para Exibir</td>
					    <td align="left" bgcolor="#CCCCCC"> do Certificado do PAX:&nbsp;&nbsp;</td>
				      </tr>
                      <tr> 
                        <td align="right">Exibir Certificado PAX
                        somente&nbsp;<br>com <strong>presen&ccedil;a</strong> no(s) produto(s):&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190"><input name="var_certificado_cod_prod_valida" id="var_certificado_cod_prod_valida" type="text" class="textbox180" value="<%=objRS("CERTIFICADO_COD_PROD_VALIDA")%>" size="20"></td>
                              <td width="190">Ex: &quot;3000,3001&quot; - Quem 
                                teve leitura neste(s) produto(s)</td>
                            </tr>
                          </table>
                          
                        </td>
	                  </tr>
                      <tr> 
                        <td align="right" valign="top">Exibir Certificado PAX com<br>
                         <strong>retirada de material </strong>ap&oacute;s data:&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190"><input name="var_certificado_dt_retirada_material" id="var_certificado_dt_retirada_material" type="text"  value="<%=objRS("CERTIFICADO_DT_RETIRADA_MATERIAL")%>" size="20" class="date-pick"></td>
                              <td width="190">Ex: &quot;3000,3001&quot; - Quem 
                                teve leitura neste(s) produto(s)</td>
                            </tr>
                          </table>
                          
                        </td>
	                  </tr>
                       
                        <tr> 
                        <td align="right">Exibir Certificado PAX<br>
                         <strong>se respondido </strong>questionario:&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190"><input name="var_certificado_vinculo_cod_questionario" id="var_certificado_vinculo_cod_questionario" type="text" value="<%=getValue(objRS,"CERTIFICADO_VINCULO_COD_QUESTIONARIO")%>" size="20"  onKeyPress="return somenteNumero(event)"></td>
                              <td width="190">Ex: &quot;"31" (código de questionário)</td>
                            </tr>
                          </table>
                        </td>
	                  </tr>
                       <tr> 
                        <td align="right" valign="top">Quantidade Minima<br>
                         <strong>de produtos distintos </strong>com leitura:&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190"><input name="var_certificado_nro_produtos_min" id="var_certificado_nro_prosdutos_min" type="text" value="<%=getValue(objRS,"CERTIFICADO_NRO_PRODUTOS_MIN")%>" size="20" onKeyPress="return somenteNumero(event)"></td>
                      	<td width="190">Ex: &quot;"3" - leitura/presença em no mínimo 3 produtos</td>
                            </tr>
                          </table>
                        </td>
	                  </tr>
                       <tr> 
                         <td align="right" valign="top">Quantidade de horas<br>
                         <strong>mínima</strong>de presença:&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                             <td align="left"><input name="var_certificado_carga_horaria_min" id="var_certificado_carga_horaria_min" type="text" value="<%=getValue(objRS,"CERTIFICADO_CARGA_HORARIA_MIN")%>" size="20" onKeyPress="return somenteNumero(event)">
                         </td>
                       <td width="190">Ex: &quot;"8" - (soma das cargas horárias dos produtos que teve presença)</td>
                            </tr>
                          </table>
                        </td>
	                  </tr>
                       <tr> 
                        <td align="right" valign="top">Exibir na Loja Agenda:&nbsp;</td>
                        <td align="left"> 
                          <%
						 Dim strSIM, strNAO
					     If objRS("LOJA_AGENDA_SHOW") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
						<input type="radio" name="var_loja_agenda_show" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						<input type="radio" name="var_loja_agenda_show" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
                       <tr> 
                        <td align="right" valign="top">Tipo Restrição:&nbsp;</td>
                        <td align="left"> 
                          <%'LOJA_TIPO_RESTRICAO
						 Dim strAND, strOR
					     If getValue(objRS,"LOJA_TIPO_RESTRICAO") = "AND" Then
						   strAND = " checked"
						   strOR = ""
						 Else
							 If getValue(objRS,"LOJA_TIPO_RESTRICAO") = "OR" Then
							   strAND = ""
							   strOR = " checked"
							 End If
						 End If						 
						%>
						<input type="radio" name="var_loja_tipo_restricao" value="AND" <%=strAND%>> AND &nbsp;&nbsp;
						<input type="radio" name="var_loja_tipo_restricao" value="OR" <%=strOR%>> OR &nbsp;&nbsp;						
						</td>
                      </tr>

                       <tr> 
                        <td align="right" valign="top">Exibir na Loja:&nbsp;</td>
                        <td align="left"> 
                          <%
						 'Dim strSIM, strNAO
					     If objRS("LOJA_SHOW") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
						<input type="radio" name="var_loja_show" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						<input type="radio" name="var_loja_show" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Editar na Loja:&nbsp;</td>
                        <td align="left"> 
                          <%
					    
						 If objRS("LOJA_EDIT_QTDE") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
						<input type="radio" name="var_loja_edit_qtde" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						<input type="radio" name="var_loja_edit_qtde" value="0"<%=strNAO%> > Não &nbsp;&nbsp;
                        Qtde. Max. Unit. <input name="var_qtde_max_unit" type="text" class="textbox70" value="<%=objRS("QTDE_MAX_UNIT")%>" size="10">						
						</td>
                      </tr>
                       <tr> 
                        <td align="right" valign="top">Exibir no CAEX:&nbsp;</td>
                        <td align="left"> 
                          <%
					     If objRS("CAEX_SHOW") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
						<input type="radio" name="var_caex_show" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						<input type="radio" name="var_caex_show" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
                       <tr> 
                        <td align="right" valign="top">Exibir no Check-in:&nbsp;</td>
                        <td align="left"> 
                          <%
					     If objRS("CHECKIN_SHOW") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
						<input type="radio" name="var_checkin_show" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						<input type="radio" name="var_checkin_show" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <tr> 
                        <td align="right">Cor Fundo:&nbsp;</td>
                        <td align="left" bgcolor="<%=objRS("BGCOLOR")%>"> <input name="var_bgcolor" type="text" value="<%=objRS("BGCOLOR")%>" size="30" maxlength="50" class="textbox180"></td>
                      </tr>
					  <tr>
					    <td align="right">Ordem:&nbsp;</td>
					    <td align="left"><input name="var_ordem" type="text" class="textbox70" value="<%=objRS("ORDEM")%>" size="5"></td>
				      </tr>
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
                      <tr> 
                        <td align="right" width="150">Imagem:&nbsp;</td>
                        <td align="left">
						<%
						strIMG = objRS("IMG")&""
						If strIMG <> "" Then
						%>
                        <img src='../imgdin/<%=strIMG%>' border='0'>
                        <br>
                        <%
						End If
						%>
                        <input name="var_img" id="var_img" type="text" class="textbox180" value="<%=strIMG%>"> <a href="javascript:UploadImage('formupdate','var_img','\\imgdin\\');"><img src="../IMG/bt_upload.gif" width="78" height="17" hspace="5" border="0" align="absmiddle"></a>
                        </td>
                    </tr>
                    
                    
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
					  
                      <tr>
					    <td align="right" bgcolor="#CCCCCC">Regra para Exibir</td>
					    <td align="left" bgcolor="#CCCCCC"> Download de arquivos do PAX:&nbsp;&nbsp;</td>
				      </tr>
                      
                      <tr> 
                        <td align="right" valign="top">Exibir Download Arquivos PAX <strong>se respondido</strong> questionario:&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190"><input name="var_download_vinculo_cod_questionario" id="var_download_vinculo_cod_questionario" type="text"  value="<%=objRS("DOWNLOAD_VINCULO_COD_QUESTIONARIO")%>" size="20"></td>
                              <td width="190">Ex: ""31" (código de questionário)</td>
                            </tr>
                          </table>
                          
                        </td>
	                  </tr>
                      
                      <tr>
					    <td align="right" bgcolor="#CCCCCC">Complemento 1:&nbsp;</td>
					    <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
				      </tr>
					  <tr> 
                        <td align="right">Título:&nbsp;</td>
                        <td align="left"> <input name="var_extra_info_msg" type="text" value="<%=objRS("EXTRA_INFO_MSG")%>" size="30" maxlength="50" class="textbox180"></td>
                      </tr>
					  <%
					     If objRS("EXTRA_INFO_SHOW") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
					  <tr> 
                        <td align="right">Exibir:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_show" type="radio" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						  <input type="radio" name="var_extra_info_show" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <%
					     If objRS("EXTRA_INFO_REQUERIDO") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
					  <tr> 
                        <td align="right">Requerido:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_requerido" type="radio" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						  <input type="radio" name="var_extra_info_requerido" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>

                    
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
					  <tr>
					    <td align="right" bgcolor="#CCCCCC">Complemento 2:&nbsp;</td>
					    <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
				      </tr>
					  <tr> 
                        <td align="right">Título:&nbsp;</td>
                        <td align="left"> <input name="var_extra_info_2_msg" type="text" value="<%=objRS("EXTRA_INFO_2_MSG")%>" size="30" maxlength="50" class="textbox180"></td>
                      </tr>
					  <%
					     If objRS("EXTRA_INFO_2_SHOW") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
					  <tr> 
                        <td align="right">Exibir:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_2_show" type="radio" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						  <input type="radio" name="var_extra_info_2_show" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <%
					     If objRS("EXTRA_INFO_2_REQUERIDO") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
					  <tr> 
                        <td align="right">Requerido:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_2_requerido" type="radio" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						  <input type="radio" name="var_extra_info_2_requerido" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
                    
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
					  <tr>
					    <td align="right" bgcolor="#CCCCCC">Complemento 3:&nbsp;</td>
					    <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
				      </tr>
					  <tr> 
                        <td align="right">Título:&nbsp;</td>
                        <td align="left"> <input name="var_extra_info_3_msg" type="text" value="<%=objRS("EXTRA_INFO_3_MSG")%>" size="30" maxlength="50" class="textbox180"></td>
                      </tr>
					  <%
					     If objRS("EXTRA_INFO_3_SHOW") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
					  <tr> 
                        <td align="right">Exibir:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_3_show" type="radio" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						  <input type="radio" name="var_extra_info_3_show" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <%
					     If objRS("EXTRA_INFO_3_REQUERIDO") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
					  <tr> 
                        <td align="right">Requerido:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_3_requerido" type="radio" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						  <input type="radio" name="var_extra_info_3_requerido" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
                    
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
					  <tr>
					    <td align="right" bgcolor="#CCCCCC">Complemento 4:&nbsp;</td>
					    <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
				      </tr>
					  <%
					     If objRS("EXTRA_INFO_4_SHOW") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
					  <tr> 
                        <td align="right">Título:&nbsp;</td>
                        <td align="left"> <input name="var_extra_info_4_msg" type="text" value="<%=objRS("EXTRA_INFO_4_MSG")%>" size="30" maxlength="50" class="textbox180"></td>
                      </tr>
					  <tr> 
                        <td align="right">Exibir:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_4_show" type="radio" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						  <input type="radio" name="var_extra_info_4_show" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <%
					     If objRS("EXTRA_INFO_4_REQUERIDO") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
					  <tr> 
                        <td align="right">Requerido:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_4_requerido" type="radio" value="1"<%=strSIM%> > Sim &nbsp;&nbsp;
						  <input type="radio" name="var_extra_info_4_requerido" value="0"<%=strNAO%> > Não &nbsp;&nbsp;						
						</td>
                      </tr>

					</form>
                    </table></td>
          </tr>
          <tr><td>&nbsp;</td></tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr> 
      <td width="4"     height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td width="235"   height="4" background="../img/inbox_bottom_blue.gif"><img src="img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"    height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:formupdate.submit();"><img src="../img/bt_save.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"     height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
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
          <tr><td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Pre&ccedil;os - Produto</td></tr>
          <tr><td height="16" align="center">&nbsp;</td></tr>
          <tr> 
            <td align="center">
			      <table width="98%" border="0" cellpadding="2" cellspacing="0" class="arial11">
                    <form name="form_listaprecos" action="../_database/AthInsertToDB.asp" method="POST">
                      <input type="hidden" name="DEFAULT_TABLE" value="tbl_PrcLista">
                      <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                      <input type="hidden" name="FIELD_PREFIX"  value="DBVAR_">
                      <input type="hidden" name="RECORD_KEY_NAME" value="COD_PRLISTA">
                      <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_admproduto/update.asp?var_chavereg=<%=objRS("COD_PROD")%>">
                      <input type="hidden" name="DBVAR_NUM_COD_PROD" value="<%=objRS("COD_PROD")%>">
                      <tr> 
                        <td colspan="4" align="center"><% MontaTabelaPrecos %>
                        <a href="javascript:AbreJanelaPAGE('copia_lista_preco_produto.asp?var_chavereg=<%=strCOD_PROD%>','600', '300');"><img src="../img/Bt_copiar.gif" alt="Copiar lista de pre&ccedil;o para outro produto" width="78" height="17" hspace="10" border="0"></a></td>
                      </tr>
                      <tr>
                        <td height="25" align="right">&nbsp;</td>
                        <td colspan="3">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="120" align="right" nowrap>*Data de Vig&ecirc;ncia:&nbsp;</td>
                        <td width="125" nowrap><input name="DBVAR_DATE_DT_VIGENCIA_INICô" type="text" size="10" maxlength="10" value="" id="date3" class="date-pick"></td>
                        <td width="15" nowrap>a</td>
                        <td width="100%" nowrap><input name="DBVAR_DATE_DT_VIGENCIA_FIM&ocirc;" type="text" size="10" maxlength="10" id="date4" class="date-pick"></td>
                      </tr>
                      <tr> 
                        <td align="right">*Pre&ccedil;o Lista:&nbsp;</td>
                        <td colspan="3"><input name="DBVAR_FLOAT_PRC_LISTAô" type="text" class="textbox100" size="10" maxlength="10"></td>
                      </tr>
                      <tr>
                        <td align="right">Quant. In&iacute;cio:&nbsp;</td>
                        <td colspan="3"><input name="DBVAR_NUM_QTDE_INICô" type="text" value="0" class="textbox100" size="10" maxlength="10"></td>
                      </tr>
                      <tr>
                        <td align="right">Quant. Fim:&nbsp;</td>
                        <td colspan="3"><input name="DBVAR_NUM_QTDE_FIMô" type="text" value="1" class="textbox100" size="10" maxlength="10"></td>
                      </tr>
                      <tr> 
                        <td align="right">Categoria de Compra:&nbsp;</td>
                        <td colspan="3">
						<select name="DBVAR_NUM_COD_STATUS_PRECOô" class="textbox180">
						<%
						strSQL = " SELECT COD_STATUS_PRECO, STATUS FROM tbl_STATUS_PRECO WHERE COD_EVENTO = " & Session("COD_EVENTO")
						MontaCombo strSQL, "COD_STATUS_PRECO", "STATUS", ""
						%>
                        </select>						</td>
                      </tr>
                    </form>
                  </table>
		    </td>
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
          <td align="right" background="../img/inbox_bottom_big3.gif">
		  <a href="javascript:form_listaprecos.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a>
		  <img src="../img/t.gif" width="3" height="3"><br></td>
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
                  <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Restri&ccedil;&otilde;es- Produto</td>
                </tr>
                <tr>
                  <td height="16" align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td align="center">
                    <table width="98%" border="0" cellpadding="2" cellspacing="0" class="arial11">
                      <form name="form_listarestricao" action="../_database/AthInsertToDB.asp" method="POST">
                        <input type="hidden" name="DEFAULT_TABLE" value="tbl_produtos_restricao">
                        <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                        <input type="hidden" name="FIELD_PREFIX"  value="dbvar_">
                        <input type="hidden" name="RECORD_KEY_NAME" value="ID_AUTO">
                        <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_admproduto/update.asp?var_chavereg=<%=objRS("COD_PROD")%>">
                        <input type="hidden" name="dbvar_str_cod_prod" value="<%=objRS("COD_PROD")%>">
                        <tr>
                          <td colspan="2" align="center"><% MontaListaRestricoes %></td>
                        </tr>
                        <tr>
                          <td width="100" align="right">&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td align="right">Produto:&nbsp;</td>
                          <td><select name="dbvar_str_cod_prod_relacao" class="textbox180">
                            <%
						strSQL = " SELECT P.COD_PROD, P.TITULO FROM tbl_PRODUTOS P WHERE P.COD_PROD <> " & strCOD_PROD & " AND P.COD_PROD NOT IN (SELECT PR.COD_PROD_RELACAO FROM tbl_PRODUTOS_RESTRICAO PR WHERE PR.COD_PROD = " & strCOD_PROD & ") AND COD_EVENTO = " & Session("COD_EVENTO") & " ORDER BY P.TITULO"
						MontaCombo strSQL, "COD_PROD", "TITULO", ""
						%>
                          </select></td>
                        </tr>
                        <tr>
                          <td align="right">Restri&ccedil;&atilde;o:&nbsp;</td>
                          <td>
						  	<select name="dbvar_num_restricao" class="textbox180">
                            	<option value="-1">Não permite comprar junto (Erro)</option>
								<option value="1" >Não permite comprar junto (Alerta)</option>
                            	<option value="0" >Compra Obrigatória</option> 	
                            </select>
                          </td>
                        </tr>
						<tr>
                          <td align="right">Cód.Produto Equivalente:&nbsp;</td>
                          <td><select name="dbvar_num_cod_prod_equiv" class="textbox180">
                            	<option value="" selected>[Selecione]</option>                          
                            <%
							'ex:"      SELECT ID_PAIS,  CONCAT(ID_PAIS ,'-',PAIS)   AS PAIS   FROM TBL_PAISES  ORDER BY PAIS   "
							strSQL = " SELECT COD_PROD ,CONCAT(CAST(COD_PROD AS CHAR),'-',TITULO) as TEXTO FROM tbl_PRODUTOS WHERE COD_EVENTO = " & Session("COD_EVENTO") & " ORDER BY TITULO"
							'strSQL = " SELECT COD_PROD, titulo FROM tbl_PRODUTOS ORDER BY TITULO"
								'response.Write(strSQL)
								'response.end()							
							MontaCombo strSQL, "COD_PROD", "TEXTO", ""
							%>
                          </select></td>
                        </tr>
                      </form>	
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
            <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_listarestricao.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
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
                  <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Combos- Produto</td>
                </tr>
                <tr>
                  <td height="16" align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td align="center">
                    <table width="98%" border="0" cellpadding="2" cellspacing="0" class="arial11">
                      <form name="form_listacombo" action="../_database/AthInsertToDB.asp" method="POST">
                        <input type="hidden" name="DEFAULT_TABLE" value="tbl_produtos_combo">
                        <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                        <input type="hidden" name="FIELD_PREFIX"  value="dbvar_">
                        <input type="hidden" name="RECORD_KEY_NAME" value="COD_PROD">
                        <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_admproduto/update.asp?var_chavereg=<%=objRS("COD_PROD")%>">
                        <input type="hidden" name="dbvar_str_cod_prod" value="<%=objRS("COD_PROD")%>">
                        <tr>
                          <td colspan="2" align="center"><% MontaListaCombo %></td>
                        </tr>
                        <tr>
                          <td width="100" align="right">&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td align="right">Produto:&nbsp;</td>
                          <td><select name="dbvar_str_cod_prod_relacao" class="textbox180">
                              <%
							strSQL = " SELECT COD_PROD, TITULO FROM tbl_PRODUTOS WHERE COD_PROD <> " & strCOD_PROD & " AND COD_EVENTO = " & Session("COD_EVENTO")
							MontaCombo strSQL, "COD_PROD", "TITULO", ""
							  %>
                          </select></td>
                        </tr>
                        <tr>
                          <td align="right">Status Preço:&nbsp;</td>
                          <td><select name="dbvar_str_cod_status_preco" class="textbox180">
                              <%
							strSQL = " SELECT COD_STATUS_PRECO, STATUS FROM tbl_STATUS_PRECO WHERE COD_EVENTO = " & Session("COD_EVENTO")
							MontaCombo strSQL, "COD_STATUS_PRECO", "STATUS", ""
							  %>
                            </select>
                          </td>
                        </tr>
						<tr>
                          <td align="right">Desconto Perc.:&nbsp;</td>
                          <td><input type="text" name="dbvar_float_desconto_perc" class="arial11"></td>
						</tr>
						<tr>
                          <td align="right">Desconto Valor:&nbsp;</td>
                          <td><input type="text" name="dbvar_float_desconto_vlr" class="arial11"></td>
						</tr>
                      </form>
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
            <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_listacombo.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
            <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
          </tr>
        </table>
        <br>
<div id="dv_palestrantes">
      <table width="100%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Palestrantes - Produto</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			      <table width="98%" border="0" cellpadding="2" cellspacing="0" class="arial11">
                    <form name="form_listapalestrantes" action="InsUpdProdPalestranteExec.asp" method="POST">
                      <input type="hidden" name="var_cod_prod" value="<%=objRS("COD_PROD")%>">
                      <input type="hidden" name="var_dt_ocorrencia" value="<%=PrepData(objRS("DT_OCORRENCIA"),True,False)%>">
                      <tr> 
                        <td colspan="2" align="center">
                          <% MontaListaPalestrantes %>                        </td>
                      </tr>
                      <tr>
                        <td width="100" align="right">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="right">Palestrante:&nbsp;</td>
                        <td>
						<select name="var_cod_palestrante" class="textbox380">
						<%
						strSQL = " SELECT DISTINCT T1.COD_PALESTRANTE, E.NOMECLI " &_
								 " FROM tbl_PALESTRANTE T1, tbl_EMPRESAS AS E, tbl_Palestrante_Evento T2 " &_
								 " WHERE T1.COD_EMPRESA = E.COD_EMPRESA " &_
								 " AND T1.COD_PALESTRANTE = T2.COD_PALESTRANTE " &_
								 " AND T2.COD_EVENTO = " & Session("COD_EVENTO") &_
								 " AND E.SYS_INATIVO IS NULL" &_
								 " ORDER BY E.NOMECLI "
						MontaCombo strSQL, "COD_PALESTRANTE", "NOMECLI", ""
						%>
                        </select>						</td>
                      </tr>
                      <tr> 
                        <td align="right">Função:&nbsp;</td>
                        <td>
                        <input name="var_funcao" type="text" class="textbox380" maxlength="50"></td>
                      </tr>                     
                      <tr> 
                        <td align="right">Tema*:&nbsp;</td>
                        <td>
						 <textarea name="var_tema" rows="6" class="textbox380"></textarea>
                         <br>
                         <i>(*)Em caso de diploma por "tema" diferencie a função<br>
                         do palestrante para cada tema (mesmo que com espaço ou ponto etc).</i>
                         </td>
                      </tr>
                      <tr> 
                        <td align="right">Material:&nbsp;</td>
                        <td>
						 <textarea name="var_material" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr> 
                        <td align="right">Hora Início:&nbsp;</td>
                        <td> <input name="var_hora_ini" type="text" class="textbox70" maxlength="5"> (formato: HH:MM) </td>
                      </tr>
                      <tr> 
                        <td align="right">Hora Término:&nbsp;</td>
                        <td> <input name="var_hora_fim" type="text" class="textbox70" maxlength="5">   (formato: HH:MM)</td>
                      </tr>
                      <tr> 
                        <td align="right">Confirmado:&nbsp;</td>
                        <td>
                        <select name="var_confirmado" class="textbox100">
                          <option value="" selected>Indefinido</option>
                          <option value="1">Sim</option>
                          <option value="0">Não</option>
                        </select>
                        </td>
                      </tr>
                      <tr> 
                        <td align="right">Ordem:&nbsp;</td>
                        <td> <input name="var_ordem" type="text" class="textbox70" maxlength="5"> </td>
                      </tr>
                    </form>
                  </table>
		    </td>
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
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_listapalestrantes.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
</div>
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
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Documentos</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			      <table width="470" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="form_documentos" action="../_database/AthInsertToDB.asp" method="POST">
						<input type="hidden" name="DEFAULT_TABLE" value="tbl_documentos">
						<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
						<input type="hidden" name="FIELD_PREFIX" value="dbvar_">
						<input type="hidden" name="RECORD_KEY_NAME" value="id_documento">
						<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_admproduto/update.asp?var_chavereg=<%=strCOD_PROD%>">
						<input type="hidden" name="dbvar_num_cod_evento" value="<%=Session("COD_EVENTO")%>">
                        <input type="hidden" name="dbvar_num_cod_prod" value="<%=strCOD_PROD%>">
                      <tr> 
                        <td colspan="3" align="center"><% MontaTabelaDocumentos %></td>
                      </tr>
					  <tr>
							<td width="120" align="right" style="font-weight:bold;">Documento:&nbsp;</td>
							<td>
								<input type="text" name="dbvar_str_documento" class="textbox250">
								<a href="javascript:UploadImage('form_documentos','dbvar_str_documento','\\modulo_admproduto\\docs\\');">
									<img src="../IMG/bt_upload.gif" width="78" height="17" hspace="5" border="0" align="absmiddle">
								</a>
							</td>
						</tr>
						<tr>
							<td width="120" align="right" style="font-weight:bold;">Rotulo:&nbsp;</td>
							<td><input type="text" name="dbvar_str_rotulo" class="textbox250" value=""></td>
						</tr>
						<tr>
							<td width="120" align="right" style="font-weight:bold;">URL:&nbsp;</td>
							<td><input type="text" name="dbvar_str_url" class="textbox250" value=""></td>
						</tr>
                    </form>
                  </table>
		    </td>
          </tr>
          <tr><td>&nbsp;</td></tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%0" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_documentos.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
  <br>

      
  </tr></td></table>
</body>
<% if strSec <> "" then %>
<script language="javascript">
	document.getElementById("<%=strSec%>").scrollIntoView();
</script>
<% end if %>
</html>
<%
  FechaRecordSet ObjRS
  FechaDBConn ObjConn
%>