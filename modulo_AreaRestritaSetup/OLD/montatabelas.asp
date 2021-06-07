<%
Function MontaTabelaFormularios
Dim objRS_LOCAL, strSQL
Dim i, strBgColor, strDisable
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("              <!--a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_formularios'); return false"" href=""javascript:;"">")
	Response.Write("                <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("              </a //-->")
	Response.Write("          </td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Rotulo</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Dead line</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Área</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
'	"WHERE t1.cod_evento = " & ValidateValueSQL(strCOD_EVENTO,"NUM",false) &_
	strSQL = " SELECT t1.cod_formulario, t1.rotulo, t1.dt_inativo, t2.status, (select count(cod_serv) from tbl_formularios_servicos WHERE cod_formulario = t1.cod_formulario) AS servico" &_
	         " FROM tbl_formularios AS t1 LEFT JOIN tbl_status_cred AS t2 ON (t1.cod_status_cred = t2.cod_status_cred)" &_			 
			 " WHERE t1.cod_evento = " & session("cod_evento") &_
			 "  AND t1.lang like '%" & strLANG & "%'" &_
			 " ORDER BY t1.rotulo"
	'response.Write(strSQL)
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	
	'response.End()
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		strDisable =""
		
		If getValue(objRS_LOCAL,"servico") <> "0" Then
			strDisable = " disabled='disabled' "
		End If
		
		Response.Write("     <tr height=""20"">")
		Response.Write("       <td width='15' align='center'>")
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("cod_formulario") & "' name='msguid_" & i &"' "& strDisable &">")
		Response.Write("       </td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'><a style=""cursor:pointer"" onClick=""javascript:window.open('update_formulario.asp?var_chavereg=" & objRS_LOCAL("cod_formulario") & "','proevento_forma_pgto','width=600,height=400,scrollbars=yes')""><img src=""../img/icon_write.gif"" border=""0""></a></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("rotulo") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("dt_inativo") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("status") & "</td>")
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
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_formularios'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a></td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr><td height=""20"" colspan='2'></td></tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("		<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""80%"">")
	' Response.Write("			<tr>")
	' Response.Write("				<td width=""120"" align=""right"" style=""font-weight:bold;""> Forma Pgto.:&nbsp;</td>")
	' Response.Write("				<td><select name=""dbvar_num_cod_formapgto"" class=""arial11"">")
	' MontaCombo "SELECT cod_formapgto, formapgto FROM tbl_formapgto ORDER BY formapgto", "cod_formapgto", "formapgto", ""
	' Response.Write("				</select></td>")
	' Response.Write("			</tr>")
	Response.Write("		</table>")
	Response.Write("	</td>")
	Response.Write("  </tr>")
	Response.Write("</table>")
	
	FechaRecordSet objRS_LOCAL
End Function

Function MontaTabelaDocumentos
Dim objRS_LOCAL, strSQL
Dim i, strBgColor

' "WHERE t1.cod_evento = " & ValidateValueSQL(strCOD_EVENTO,"NUM",false) &_
	strSQL = "SELECT t1.id_documento, t1.rotulo, area " &_
	         "FROM tbl_documentos AS t1 " &_
			 "WHERE t1.cod_evento = " & session("cod_evento") &_
			 "  AND (t1.lang = " & ValidateValueSQL(strLANG,"STR",false) & " or t1.lang is null)"&_
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
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Área</strong></td>")
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
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("area") & "</td>")
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

Function MontaListaStatusPreco
Dim objRS_LOCAL, strSQL
Dim i, strBgColor, strOBSERVACAO
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('formstatuspreco'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Código</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Status</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Observação</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = " SELECT EI.COD_STATUS_PRECO, EI.STATUS, EI.OBSERVACAO, EI.SENHA, EI.LOJA_SHOW " &_
			 " FROM tbl_STATUS_PRECO AS EI " &_
			 " WHERE COD_EVENTO = " & ValidateValueSQL(strCOD_EVENTO,"NUM",false) &_ 
			 " AND CAEX_SHOW = 1 "&_
			 " ORDER BY EI.STATUS, EI.COD_STATUS_PRECO " 
			 'response.Write(strSQL)
			 'response.End()
			 
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		
		strOBSERVACAO = objRS_LOCAL("OBSERVACAO")
'		If Len(objRS_LOCAL("OBSERVACAO")) > 100 Then
'			strOBSERVACAO = Mid(objRS_LOCAL("OBSERVACAO"),1,35)
'		Else
'			strOBSERVACAO = objRS_LOCAL("OBSERVACAO")
'		End If
		
		Response.Write("     <tr>")
		Response.Write("       <td width='15' align='center'>")
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("COD_STATUS_PRECO") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("COD_STATUS_PRECO") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("STATUS") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & strOBSERVACAO & "</td>")
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
	Response.Write("          <td bgcolor='#7DACC5'><img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('formstatuspreco'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a></td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr><td colspan=""2"" height=""20""></td></tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("		<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""80%"">")
	Response.Write("			<tr>")
	Response.Write("				<td width=""120"" align=""right"" style=""font-weight:bold;"">Categoria:&nbsp;</td>")
	Response.Write("				<td><input type=""text"" name=""dbvar_str_status"" class=""textbox250""></td>")
	Response.Write("			</tr>")
	Response.Write("			<tr>")
	Response.Write("				<td width=""120"" align=""right"" style=""font-weight:bold;"">Observação:&nbsp;</td>")
	Response.Write("				<td><input type=""text"" name=""dbvar_str_observacao"" class=""textbox250""></td>")
	Response.Write("			</tr>")
	Response.Write("			</tr>")
	Response.Write("		</table>")
	Response.Write("	</td>")
	Response.Write("  </tr>")
	Response.Write("</table>")
	
	FechaRecordSet objRS_LOCAL
End Function


%>