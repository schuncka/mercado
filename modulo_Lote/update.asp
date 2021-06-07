<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"--> 
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
  VerficaAcesso("ADMIN")

  Dim strSQL, objRS, objRSMapeamento, ObjConn
  Dim strCOD_LOTE, strSQL_CRITERIO, strSQL_INNER
 	
  AbreDBConn objConn, CFG_DB_DADOS
	
  strCOD_LOTE = Replace(Request("var_chavereg"),"'","''")
	
  strSQL = "          SELECT L.COD_LOTE, L.NOME, L.DESCRICAO, L.NOMINAL, L.NUM_CRED_PJ, L.TOTAL_REGISTROS, L.DT_INATIVO ,L.DT_CRIACAO, L.DT_LASTUPDATE, L.SYS_USERCA, L.CRITERIO_EVENTO, L.SQL_CRITERIO, L.SQL_INNER, L.TOTAL_PJ_PF, L.TOTAL_CONTATO, L.IGNORAR_CONTATO, L.CADASTRO_COM_FOTO "
  strSQL = strSQL & " FROM tbl_LOTE L"
  strSQL = strSQL & " WHERE L.COD_LOTE = " & strCOD_LOTE

  Set objRS = objConn.Execute(strSQL)
	
	
'*********************************************************************
'           Função para montar tabela de info
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
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_lotecriterio'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")	
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='1' height='1' src='../img/1x1.gif'></td>")
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
		Response.Write("       <td width='15' align='center'>")
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("COD_LOTE_CRITERIO") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
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
	Response.Write("          <td bgcolor='#7DACC5'> <img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_lotecriterio'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a>")
	Response.Write("          </td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><img src='../img/separator.gif' width='100%' height='2' vspace='5'></td>")
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
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_loteevento'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")	
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='1' height='1' src='../img/1x1.gif'></td>")
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
		Response.Write("       <td width='15' align='center'>")
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("COD_LOTE_EVENTO") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
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
	Response.Write("          <td bgcolor='#7DACC5'> <img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_loteevento'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a>")
	Response.Write("          </td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><img src='../img/separator.gif' width='100%' height='2' vspace='5'></td>")
	Response.Write("  </tr>")
	Response.Write("</table>")
	
	FechaRecordSet objRS_LOCAL
End Function

'*********************************************************************
'           Função para montar tabela de info
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
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_loteordem'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")	
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='1' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Nome Campo</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Critério</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Valor</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = "SELECT COD_LOTE_ORDEM, COD_LOTE, CAMPO, DIRECAO, ORDEM " &_
	         "FROM tbl_Lote_Ordem " &_
			 "WHERE COD_LOTE = " & strCOD_LOTE &_
			 " ORDER BY COD_LOTE_ORDEM"
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
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("COD_LOTE_ORDEM") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
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
	Response.Write("          <td bgcolor='#7DACC5'> <img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_loteordem'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a>")
	Response.Write("          </td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><img src='../img/separator.gif' width='100%' height='2' vspace='5'></td>")
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
    if (formname == 'form_lotecriterio') {
	  document.location = '../_database/athDeleteToDB.asp?default_table=tbl_Lote_Criterio' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=COD_LOTE_CRITERIO' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_lote//update.asp?var_chavereg=<%=strCOD_LOTE%>';
	}
    if (formname == 'form_loteevento') {
	  document.location = '../_database/athDeleteToDB.asp?default_table=tbl_Lote_Evento' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=COD_LOTE_EVENTO' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_lote//update.asp?var_chavereg=<%=strCOD_LOTE%>';
	}
    if (formname == 'form_loteordem') {
	  document.location = '../_database/athDeleteToDB.asp?default_table=tbl_Lote_Ordem' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=COD_LOTE_ORDEM' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_lote//update.asp?var_chavereg=<%=strCOD_LOTE%>';
	}	
  }
}

return false;
}


function SetParentField(formulario, campo, valor) {
  eval('document.' + formulario + '.' + campo + '.value="' + valor + '"');
}

//-->
</script>
</head>

<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle">
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
      <td width="100%">
      
        <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
        <form name="formupdate" action="updateexec.asp" method="POST">
          <input name="var_chavereg" type="hidden" value="<%=objRS("COD_LOTE")%>">
          <input name="var_acao" type="hidden" value="UPDATE">
          <tr> 
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Alteração de Lotes</td>
          </tr>
          <tr> 
            <td height="18" align="center">&nbsp;</td>
          </tr>
          <tr> 
                  <td align="center">
				   <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr> 
                        <td width="120" align="right">C&oacute;digo:&nbsp;</td>
                        <td><%=objRS("COD_LOTE")%></td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Nome:&nbsp;</td>
                        <td><input name="VAR_NOME" type="text" class="textbox380" value="<%=objRS("NOME")%>">
                        </td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Descri&ccedil;&atilde;o:&nbsp;</td>
                        <td><textarea name="var_descricao" rows="4" class="textbox380"><%=objRS("DESCRICAO")%></textarea></td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Nominal:&nbsp;</td>
                        <td><textarea name="var_nominal" rows="2" class="textbox380"><%=objRS("NOMINAL")%></textarea></td>
                      </tr>
                      <tr> 
                        <td width="120" align="right">Credencial PJ:&nbsp;</td>
                        <td><select name="var_num_cred_pj" class="textbox50">
						<%
						Dim i
						For i = 0 To 9 
						%>
						<option value="<%=i%>"<% If CInt(i) = Cint(objRS("NUM_CRED_PJ")) Then Response.Write(" selected")%>><%=i%></option>
						<%
						Next
						%>
                          </select></td>
                      </tr>
                      <tr>
                        <td align="right">Desconsiderar contatos:&nbsp;</td>
                        <td><input type="checkbox" name="var_ignorar_contato" value="1" <% If objRS("IGNORAR_CONTATO")&""="1" Then Response.Write("checked") End If %>> 
                          (ao marcar esta op&ccedil;&atilde;o  somente as PJ e PF ser&atilde;o consideradas)</td>
                      </tr>
                      <tr>
                        <td align="right">Filtrar cadastro com foto:&nbsp;</td>
                        <td><input type="checkbox" name="var_cadastro_com_foto" value="1" <% If objRS("CADASTRO_COM_FOTO")&""="1" Then Response.Write("checked") End If %>> 
                          (ao marcar esta op&ccedil;&atilde;o somente os <strong>cadastros com foto</strong> ser&atilde;o considerados)</td>
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
                      <tr>
                        <td width="120" align="right">Status:</td>
                        <td>
						 <input name="var_dt_inativo" id="var_dt_inativo"  type="radio" value="" <% If ISNULL(objRS("DT_INATIVO")) Then Response.Write("checked") End If %>> Ativo
						 <input name="var_dt_inativo" id="var_dt_inativo"  type="radio" value="<%=now()%>" <% If objRS("DT_INATIVO")<>"" Then Response.Write("checked") end if %>> Inativo	
                         </td>	
                 	  	</tr>
                  </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
<%
		  strSQL_CRITERIO = objRS("SQL_CRITERIO")&""
'		  If strSQL_CRITERIO <> "" Then
		  %>
          <tr>
            <td align="center"><b>Este lote utiliza o(s) seguinte(s) critério(s) extra(s):</b>&nbsp;</td>
          </tr>
		  <tr>
            <td align="center"><textarea name="var_sql_criterio" rows="4" class="textbox380"><%=strSQL_CRITERIO%></textarea></td>
          </tr>
		  <tr>
            <td align="center">&nbsp;</td>
          </tr>
		  <%
'		  End If
		  %>
		  <%
		  strSQL_INNER = objRS("SQL_INNER")&""
		  If strSQL_INNER <> "" Then
		  %>
          <tr>
            <td align="center"><b>Este lote esta vinculado a esta(s) consulta(s):</b>&nbsp;</td>
          </tr>
		  <tr>
            <td align="center"><textarea name="var_sql_inner" rows="4" class="textbox380"><%=strSQL_INNER%></textarea></td>
          </tr>
		  <tr>
            <td align="center">&nbsp;</td>
          </tr>
		  <%
		  End If
		  %>
		</form>  
        </table>
        
      </td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr> 
      <td width="4"     height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td width="235"   height="4" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
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
          <tr> 
                  
                <td bgcolor="#7DACC5">&nbsp;Campos para Crit&eacute;rios de Pesquisa</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
            
<%
Dim objFSO, objTextStream
Dim strCAMPO_VALOR

Set objFSO = Server.CreateObject("Scripting.FileSystemObject")

strSQL =          " SELECT NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, CAMPO_COMBOLIST, CAMPO_COR_DESTAQUE "
strSQL = strSQL & "   FROM tbl_MAPEAMENTO_CAMPO WHERE COD_EVENTO = " & Session("COD_EVENTO")
Set objRSMapeamento = objConn.Execute(strSQL)
%>
                        <script language="javascript">
						<!--
						var campo_selecionado = "";
						var campo_extra = "";
						
						function showValor(campo) {
							//alert(campo);
							document.getElementById("DBVAR_STR_VALOR").value = "";
							
							switch(campo) {
								case 'tbl_empresas.CODATIV1':
								  document.getElementById("div_help").style.display = 'inline';
								  campo_selecionado = 'ATIVIDADE';
								break;
								case 'tbl_empresas.COD_STATUS_CRED':
								  document.getElementById("div_help").style.display = 'inline';
								  campo_selecionado = 'CREDENCIAL';
								break;
								case 'tbl_empresas_sub.COD_STATUS_CRED':
								  document.getElementById("div_help").style.display = 'inline';
								  campo_selecionado = 'CREDENCIAL';
								break;
								case 'tbl_empresas.COD_STATUS_PRECO':
								  document.getElementById("div_help").style.display = 'inline';
								  campo_selecionado = 'CATEGORIA';
								break;
								case 'v.COD_EVENTO':
								  document.getElementById("div_help").style.display = 'inline';
								  campo_selecionado = 'EVENTO';
								break;
<%
	If not objRSMapeamento.EOF Then
	  Do While not objRSMapeamento.EOF
	    If objRSMapeamento("CAMPO_COMBOLIST")&"" <> "" Then
%>
								case 'tbl_empresas.<%=objRSMapeamento("NOME_CAMPO_PROEVENTO")%>':
								  document.getElementById("div_help").style.display = 'inline';
								  campo_selecionado = 'EXTRA';
								  campo_extra = '<%=objRSMapeamento("CAMPO_COMBOLIST")%>';
								break;
<%
        End If
	    objRSMapeamento.MoveNext
	  Loop
	  objRSMapeamento.MoveFirst
	End If
%>
								default:
								  document.getElementById("div_help").style.display = 'none';
								  campo_selecionado = '';
							}
						}
						
						function exibeAjuda() {
							//alert(campo_selecionado);
							var criterio = document.getElementById("VAR_CRITERIO").value;
							var janela = window.open('listacampos.asp?tipo='+campo_selecionado+'&criterio='+criterio+'&extra='+campo_extra,'Criterio','width=420,height=400,top=0,left=0,scrollbars=auto');
						}
						//-->
						</script>
			      <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="form_lotecriterio" action="../_database/AthInsertToDB.asp" method="POST">
                      <input type="hidden" name="DEFAULT_TABLE" value="tbl_Lote_Criterio">
                      <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                      <input type="hidden" name="FIELD_PREFIX"  value="DBVAR_">
                      <input type="hidden" name="RECORD_KEY_NAME" value="COD_LOTE_CRITERIO">
                      <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_lote/update.asp?var_chavereg=<%=objRS("COD_LOTE")%>">
                      <input type="hidden" name="DBVAR_NUM_COD_LOTE" value="<%=objRS("COD_LOTE")%>">
                      <tr> 
                        <td colspan="2" align="center"><% MontaLote %></td>
                      </tr>
                      <tr>
                        <td width="60" align="right">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="60" align="right">Campo:&nbsp;</td>
                        <td width="373">
						   <select name="DBVAR_STR_CAMPOô" class="textbox380" onChange="showValor(this.value);">
                            <option value="tbl_empresas.COD_EMPRESA" selected>Código</option>
                            <option value="tbl_empresas.NOMEFAN">Nome Fantasia</option>
                            <option value="tbl_empresas.NOMECLI">Raz&atilde;o Social</option>
                            <option value="tbl_empresas.ENTIDADE">Entidade</option>
                            <option value="tbl_empresas.END_FULL">Endereço</option>
                            <option value="tbl_empresas.END_CIDADE">Cidade</option>
                            <option value="tbl_empresas.END_ESTADO">Estado</option>
                            <option value="tbl_empresas.END_PAIS">Pa&iacute;s</option>
                            <option value="tbl_empresas.END_CEP">CEP</option>
                            <option value="tbl_empresas.SYS_DATACA">Data Cadastro</option>
                            <option value="tbl_empresas.NRO_EVENTOS_VISITADOS">Número Eventos Visitados</option>
                            <option value="tbl_empresas.ULTIMO_COD_EVENTO">Último Evento Visitado</option>
                            <option value="tbl_empresas.TIPO_PESS">Pessoa Física (S/N)</option>
                            <option value="tbl_empresas.CODATIV1">Atividade</option>
                            <option value="tbl_empresas.COD_STATUS_CRED">Tipo Credencial</option>
                            <option value="tbl_empresas.COD_STATUS_PRECO">Categoria Preço</option>
                            <option value="tbl_empresas_sub.CODBARRA">Contato - Código Barras</option>
                            <option value="tbl_empresas_sub.COD_STATUS_CRED">Contato - Tipo Credencial</option>
                            <option value="tbl_empresas_sub.SYS_DATACA">Contato - Data Cadastro</option>
                            <option value="tbl_empresas_sub.NRO_EVENTOS_VISITADOS">Contato - Número Eventos Visitados</option>
                            <option value="tbl_empresas_sub.ULTIMO_COD_EVENTO">Contato - Último Evento Visitado</option>
                            <option value="v.COD_EVENTO">Evento(s) Visitado(s)</option>
<%
	If not objRSMapeamento.EOF Then
	  Do While not objRSMapeamento.EOF
%>
							<option value="tbl_empresas.<%=objRSMapeamento("NOME_CAMPO_PROEVENTO")%>"><%=objRSMapeamento("NOME_DESCRITIVO")%></option>
<%
	    objRSMapeamento.MoveNext
	  Loop
	  objRSMapeamento.MoveFirst
	End If
%>
                            <option value="tbl_pais.IDIOMA">Idioma</option>
                          </select>
                        </td>
                      </tr>
                      <tr> 
                        <td align="right">Crit&eacute;rio:&nbsp;</td>
                        <td><select name="DBVAR_STR_CRITERIOô" id="VAR_CRITERIO" class="textbox380">
                            <option value="=" selected>Igual</option>
                            <option value="&lt;&gt;">Diferente</option>
                            <option value="&gt;">Maior</option>
                            <option value="&lt;">Menor</option>
                            <option value="&gt;=">Maior/Igual</option>
                            <option value="&lt;=">Menor/Igual</option>
                            <option value="LIKE_COMECA">Come&ccedil;a por</option>
                            <option value="LIKE_CONTEM">Cont&eacute;m</option>
                            <option value="IN">Conjunto</option>
                            <!--
                            <option value="IS NULL">É nulo</option>
                            <option value="IS NOT NULL">Não é nulo</option>
                            //-->
                          </select></td>
                      </tr>
                	  <tr> 
                        <td align="right">Valor:&nbsp;</td>
                        <td>
                        <div style="display:inline-block">
                            <div style="width:390;float:left;"> <input name="DBVAR_STR_VALOR" id="DBVAR_STR_VALOR" type="text" class="textbox380"></div>
                            <div id="div_help" style="display:none;">
                              <a href="javascript:;" onClick="exibeAjuda();"><img src="../img/ico_ajuda.gif" border="0"></a>
                            </div>
                        </div>
                        </td>
                      </tr>
                    </form>
                  </table>
<%
FechaRecordSet objRSMapeamento
%>
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
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_lotecriterio.submit();"><img src="../img/bt_adic.gif" width="78" height="17" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
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
                <td bgcolor="#7DACC5">&nbsp;Campos para Crit&eacute;rios de Evento </td>
              </tr>
              <tr>
                <td height="16" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td align="center">
				
				  <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
				    <form name="form_lotecriterio_evento" action="../_database/athupdatetodb.asp" method="POST">
                      <input type="hidden" name="DEFAULT_TABLE" value="tbl_Lote">
                      <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                      <input type="hidden" name="FIELD_PREFIX"  value="DBVAR_">
                      <input type="hidden" name="RECORD_KEY_NAME" value="COD_LOTE">
					  <input type="hidden" name="RECORD_KEY_VALUE" value="<%=objRS("COD_LOTE")%>">
                      <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_lote/update.asp?var_chavereg=<%=objRS("COD_LOTE")%>">
				    <tr>
                        <td colspan="2" align="center">Quando houver mais de um evento voc&ecirc; deseja que a pesquisa seja:</td>
                    </tr>
				    <tr>
				        <td align="right"><input name="DBVAR_STR_CRITERIO_EVENTO" type="radio" value="AND" onClick="document.form_lotecriterio_evento.submit();" <% If objRS("CRITERIO_EVENTO")&"" = "" Or objRS("CRITERIO_EVENTO")&"" = "AND" Then Response.Write("checked") End If %>></td>
			            <td>&nbsp;em TODOS os eventos (AND) </td>
			        </tr>
				      <tr>
				        <td align="right"><input name="DBVAR_STR_CRITERIO_EVENTO" type="radio" value="OR" onClick="document.form_lotecriterio_evento.submit();" <% If objRS("CRITERIO_EVENTO")&"" = "OR" Then Response.Write("checked") End If %>></td>
			            <td align="left">&nbsp;em PELO MENOS um dos eventos (OR) </td>
			        </tr>
					</form>
					
                    <form name="form_loteevento" action="../_database/AthInsertToDB.asp" method="POST">
                      <input type="hidden" name="DEFAULT_TABLE" value="tbl_Lote_Evento">
                      <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                      <input type="hidden" name="FIELD_PREFIX"  value="DBVAR_">
                      <input type="hidden" name="RECORD_KEY_NAME" value="COD_LOTE_EVENTO">
                      <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_lote/update.asp?var_chavereg=<%=objRS("COD_LOTE")%>">
                      <input type="hidden" name="DBVAR_NUM_COD_LOTE" value="<%=objRS("COD_LOTE")%>">
                      <tr>
                        <td colspan="2" align="center"><% MontaLoteEvento %></td>
                      </tr>
                      <tr>
                        <td align="right">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="100" align="right">Evento:&nbsp;</td>
                        <td width="380">
						  <select name="DBVAR_NUM_COD_EVENTO" class="textbox380">
						  <%
						  strSQL = "SELECT COD_EVENTO, NOME FROM tbl_EVENTO ORDER BY COD_EVENTO"
						  MontaCombo strSQL, "COD_EVENTO", "NOME", Session("COD_EVENTO")
						  %>
                          </select>                        
						</td>
                      </tr>
                      <tr>
                        <td align="right">Crit&eacute;rio:&nbsp;</td>
                        <td><select name="DBVAR_STR_CRITERIO" class="textbox180">
                            <option value="=" selected="selected">Visitou</option>
							<option value="<>">Não Visitou</option>
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
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_loteevento.submit();"><img src="../img/bt_adic.gif" width="78" height="17" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
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
                  
                <td bgcolor="#7DACC5">&nbsp;Campos para Ordena&ccedil;&atilde;o 
                  do Resultado</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			      <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <form name="form_loteordem" action="../_database/AthInsertToDB.asp" method="POST">
                      <input type="hidden" name="DEFAULT_TABLE" value="tbl_Lote_Ordem">
                      <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                      <input type="hidden" name="FIELD_PREFIX"  value="DBVAR_">
                      <input type="hidden" name="RECORD_KEY_NAME" value="COD_LOTE_ORDEM">
                      <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_lote/update.asp?var_chavereg=<%=objRS("COD_LOTE")%>">
                      <input type="hidden" name="DBVAR_NUM_COD_LOTE" value="<%=objRS("COD_LOTE")%>">
                      
                      <tr> 
                        <td colspan="2" align="center"><% MontaLoteOrdem %></td>
                      </tr>
                      <tr>
                        <td align="right">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="109" align="right">Campo:&nbsp;</td>
                        <td width="373">
						   <select name="DBVAR_STR_CAMPOô" class="textbox180">
                            <option value="COD_EMPRESA" selected>Código</option>
                            <option value="NOMEFAN" selected>Nome Fantasia</option>
                            <option value="NOMECLI">Raz&atilde;o Social</option>
                            <option value="ENTIDADE" selected>Entidade</option>
                            <option value="END_CIDADE">Cidade</option>
                            <option value="END_ESTADO">Estado</option>
                            <option value="END_PAIS">Pa&iacute;s</option>
                            <option value="END_CEP">CEP</option>
                            <option value="CODATIV1">Atividade</option>
                            <option value="COD_STATUS_CRED">Tipo Credencial</option>
                            <option value="COD_STATUS_PRECO">Status Preço</option>
                            <option value="IDIOMA">Idioma</option>
                          </select>                        </td>
                      </tr>
                      <tr> 
                        <td align="right">Dire&ccedil;&atilde;o:&nbsp;</td>
                        <td><select name="DBVAR_STR_DIRECAOô" class="textbox180">
                            <option value="ASC" selected>Ascendente</option>
                            <option value="DESC">Descendente</option>
                          </select></td>
                      </tr>
                      <tr> 
                        <td align="right">Ordem:&nbsp;</td>
                        <td><input name="DBVAR_NUM_ORDEMô" type="text" class="textbox70"></td>
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
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_loteordem.submit();"><img src="../img/bt_adic.gif" width="78" height="17" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>

        <br>
</tr></td></table>
</body>
</html>
<%
  FechaRecordSet ObjRS
  FechaDBConn ObjConn
%>