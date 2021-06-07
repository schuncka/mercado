<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/athbbsi.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<!--#include file="../_scripts/financeiro.js"-->
<%

  dim strSQL, objRS, objRS2, objRS3
  
  Dim objConn, strCODIGO, strACAO
  
  AbreDBConn objConn, CFG_DB_DADOS
  
  VerficaAcesso("ADMIN")

strACAO= Request("var_acao")

strCODIGO = Request("var_chavereg")



'*********************************************************************
'           Função para montar tabela de CEP
'*********************************************************************
Sub MontaTabelaCEP
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_cep'); return false"" href=""#"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")	
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='1' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>CEP Início</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>CEP Fim</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'>País</td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'>&nbsp;</td>")
	Response.Write("<form name='form_cep'>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
  strSQL = "SELECT id_AreaGeo_cep, Cep_Ini, Cep_Fim, ID_PAIS, ID_AreaGeo"&_
		   " FROM  tbl_areageo_cep  WHERE  id_AreaGeo="&strCODIGO
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
		Response.Write("         <input type='checkbox' value='" & objRS_LOCAL("ID_AREAGEO_CEP") & "' name='msguid_" & i &"'>")
		Response.Write("       </td>")
    	Response.Write("       <td noWrap align='left' bgcolor='" & strBgColor & "'>&nbsp;</td>")
        Response.Write("       <td noWrap align='left' bgcolor='" & strBgColor & "'> <input type='text' name='CEP_INICIO_" & i & "' class='arial11' size='10' maxlength='8' value='" & objRS_LOCAL("CEP_INI") & "'></td>")
        Response.Write("       <td noWrap align='left' bgcolor='" & strBgColor & "'> <input type='text' name='CEP_FIM_" & i & "' class='arial11' size='10' maxlength='8' value='" & objRS_LOCAL("CEP_FIM") & "'></td>")
    	Response.Write("       <td noWrap align='left' bgcolor='" & strBgColor & "'>")
    	Response.Write("       <select name='ID_PAIS_" & i & "' class='textbox180' size='1'>")
							strSQL = " SELECT ID_PAIS, PAIS " &_
							         "   FROM tbl_PAIS " &_
									 "  ORDER BY PAIS "
							MontaCombo strSQL, "ID_PAIS", "PAIS", objRS_LOCAL("ID_PAIS")&""
    	Response.Write("       </select>")
    	Response.Write("       </td>")
		Response.Write("       <td align='left'  bgcolor='" & strBgColor & "' class='premda'><a href=""#"" onClick=""UpdateCEP('form_cep','CEP_INICIO_" & i & "','CEP_FIM_" & i & "','ID_PAIS_" & i & "','msguid_" & i & "');"" Class=""premda"">Atualizar</a></td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("</form>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='95%'>")
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5'> <img src='../img/lx_seta.gif' width='18' height='20'>&nbsp;&nbsp;&nbsp;")
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteOthers('form_cep','TBL_AREAGEO_CEP','ID_AREAGEO_CEP'); return false"" href=""javascript://;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a>")
	Response.Write("          </td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td align='left' class='arial10'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>")
	Response.Write("    <td align='right' class='arial10'></td>")
	Response.Write("  </tr>")
	Response.Write("</table>")
	
	FechaRecordSet objRS_LOCAL
End Sub






	




  strSQL = "SELECT tbl_areageo.Nome_AreaGeo, tbl_areageo.id_AreaGeo "&_
		   " FROM tbl_areageo WHERE tbl_areageo.Cod_Evento="&Session("COD_EVENTO")&" AND tbl_areageo.id_AreaGeo="&strCODIGO
'Response.Write(strSQL)
'Response.End()

Set objRS = objConn.Execute(strSQL) 
  
%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
<script language="JavaScript">

function ToggleCheckAll(formname) 
{
 var i = 0;
 while ( eval("document." + formname + ".msguid_" + i) != null )
  {
   eval("document." + formname + ".msguid_" + i).checked = ! eval("document." + formname + ".msguid_" + i).checked;
   i = i + 1;
  }
}

function DeleteOthers(formname, default_table, record_key_name) 
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
	document.location = '../_database/athDeleteToDB.asp?default_table=' + default_table + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=' + record_key_name + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../areageo/update.asp?var_chavereg=<%=strCODIGO%>';
  }
}

return false;
}

function UpdateCEP(formname, cep_inicio, cep_fim, id_pais, id_areageo_cep) 
{
//alert(eval("document." + formname + "." + id_areageo_cep + ".value"))
 if(eval("document." + formname + "." + id_areageo_cep + ".value")!="")
  {
  	codigo = eval("document." + formname + "." + id_areageo_cep + ".value");
	cep1 = eval("document." + formname + "." + cep_inicio + ".value");
	cep2 = eval("document." + formname + "." + cep_fim + ".value");
	id_pais = eval("document." + formname + "." + id_pais + ".value");
	
	document.location ='updateexec.asp?var_id_areageo_cep=' + codigo + '&var_cep_inicial=' + cep1 + '&var_cep_final=' + cep2 + '&var_pais=' + id_pais + '&var_id_areageo=<%=strCODIGO%>&var_acao=upd';
  }
// return false;
}

</script>


</head>

<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle">

<form name="Formarea" action="updateexec.asp" method="POST">
<input type="hidden" name="var_id_areageo" value="<%=objRS("Id_areageo")%>">
<input type="hidden" name="var_acao" value="GEO">
<table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="492" height="4"><img src="../img/inbox_top_blue.gif" width="492" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="492"><table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  <td bgcolor="#7DACC5">&nbsp;Altera&ccedil;&atilde;o da Area Geogr&aacute;fica </td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			  <table width="480" border="0" cellpadding="0" cellspacing="0" class="arial11">
                 <tr> 
                   <td width="100" align="right">*Area :&nbsp;</td>
                   <td width="350"><input name="var_Areageo" type="text" class="textbox380" value="<%=objRS("Nome_Areageo")%>"></td>
                 </tr>
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
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:Formarea.submit();"><img src="../img/bt_save.gif" width="78" height="17" border="0"></a><a href="javascript:forminsert.reset();"><img src="../img/bt_clear.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
</form>

<% MontaTabelaCEP %>

<hr noshade="noshade" width="100%">
<form name="formIns" action="updateexec.asp" method="POST">
<input type="hidden" name="var_id_areageo" value="<%=objRS("Id_areageo")%>">
<input type="hidden" name="var_acao" value="INS">
  <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="492" height="4"><img src="../img/inbox_top_blue.gif" width="492" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="492"><table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  <td bgcolor="#7DACC5">&nbsp;Inclusão de area de CEP </td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			  <table width="480" border="0" cellpadding="0" cellspacing="0" class="arial11">
                 <tr> 
                   <td width="100" align="right">*CEP Inicial:&nbsp;</td>
                   <td width="350" align="left"><input name="var_Cep_Inicial" maxlength="8" value="" type="text" class="textbox70">&nbsp;&nbsp;*CEP Final:&nbsp;<input name="var_Cep_Final" value="" type="text" class="textbox70" maxlength="8"></td>
                 </tr>
                 <tr> 
                	 <td width="100" align="right">*Pa&iacute;s:&nbsp;</td>
                     		
							<%
							
						  	strSQL =  " SELECT PAIS, ID_PAIS FROM tbl_PAIS ORDER BY PAIS"
						  	Set objRS2 = objConn.Execute(strSQL)
					
							%>
					 
					 <td width="350" align="left"> 
                    	 <select name="var_pais" class="textbox180">
							<option value="">Selecione...</option>
							<%
							While Not objRS2.EOF
							%>
							<option value="<%=objRS2("ID_PAIS")%>"><%=objRS2("PAIS")%></option>
							<%
								objRS2.Movenext()
							Wend
							%>
						  </select>					</td>
              </tr>
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
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:formIns.submit();"><img src="../img/bt_save.gif" width="78" height="17" border="0"></a><a href="javascript:forminsert.reset();"><img src="../img/bt_clear.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
</form>


</tr></td>

</table>
</body>
</html>
<%
objRS2.Close()
objRS.close()

%>