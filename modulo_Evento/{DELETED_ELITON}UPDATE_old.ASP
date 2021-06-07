<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
    VerficaAcesso("ADMIN")

	Dim strSQL, objRS, ObjConn
	Dim strCOD_PROD
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strCOD_PROD = Replace(Request("var_chavereg"),"'","''")
	
	strSQL = "SELECT COD_PROD, GRUPO, TITULO, DESCRICAO, CAPACIDADE, DT_OCORRENCIA, " & _
	         "  LOCAL, CARGA_HORARIA, LOJA_SHOW, NUM_COMPETIDOR_START, CERTIFICADO_TEXTO, DIPLOMA_TEXTO " & _
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
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_listaprecos'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")	
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='1' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Data Início</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Data Término</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>$$ Lista</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Status</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = "SELECT PL.COD_PRLISTA, PL.COD_PROD, PL.PRC_LISTA, PL.DT_VIGENCIA_INIC, PL.DT_VIGENCIA_FIM, SP.COD_STATUS_PRECO, SP.STATUS " &_
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
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & PrepData(objRS_LOCAL("DT_VIGENCIA_INIC"),True,False) & "</td>")
     	Response.Write("       <td noWrap align='left' bgcolor='" & strBgColor & "'>" & PrepData(objRS_LOCAL("DT_VIGENCIA_FIM"),True,False) & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & FormatNumber(objRS_LOCAL("PRC_LISTA")) & "</td>")
        Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("STATUS") & "</td>")
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
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_listapalestrantes'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")	
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Nome</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Grupo</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Função</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>e-mail</strong></td>")
	Response.Write("        </tr>")
    '<!-- header da tabela ----------------------------------------------------------->
	
	strSQL = " SELECT T2.IDAUTO, T1.COD_PALESTRANTE, T1.GRP_USER, T1.NOME, T1.EMAIL, T2.FUNCAO " &_
			 " FROM tbl_Palestrante AS T1, tbl_Produtos_Palestrante AS T2 " &_
			 " WHERE T1.COD_PALESTRANTE = T2.COD_PALESTRANTE " &_
			 " AND T2.COD_PROD = " & strCOD_PROD &_
			 " ORDER BY T1.NOME " 
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
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("NOME") & "</td>")
     	Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("GRP_USER") & "</td>")
     	Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("FUNCAO") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("EMAIL") & "</td>")
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
		strpath = '../_database/athDeleteToDB.asp?default_table=tbl_PrcLista' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=COD_PRLISTA' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../adm_produto/update.asp?var_chavereg=<%=strCOD_PROD%>';
  	if (formname == 'form_listapalestrantes') 
		strpath = '../_database/athDeleteToDB.asp?default_table=tbl_Produtos_Palestrante' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=IDAUTO' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../adm_produto/update.asp?var_chavereg=<%=strCOD_PROD%>';
	document.location = strpath;
  }
}

return false;
}

function viewdoc(doc) {
  var conteudo = '';
  
  if(doc=='certificado') {
    conteudo = document.formupdate.var_certificado_texto.value;
  }
  if(doc=='diploma') {
    conteudo = document.formupdate.var_diploma_texto.value;
  }
  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}

//-->
</script>
</head>

<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle">
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
                  <td bgcolor="#7DACC5">&nbsp;&nbsp;Alteração de Produtos</td>
          </tr>
          <tr> 
            <td height="18" align="center">&nbsp;</td>
          </tr>
          <tr> 
                  <td align="center">
				   <table width="460" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="formupdate" action="updateexec.asp" method="POST">
                      <tr> 
                        <td width="100" align="right">*C&oacute;digo:&nbsp;</td>
                        <td width="350"><input name="var_cod_prod" type="text" class="textbox100" value="<%=objRS("COD_PROD")%>"></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right">*Grupo:&nbsp;</td>
                        <td width="350"><input name="var_grupo" type="text" class="textbox180" value="<%=objRS("GRUPO")%>"></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">*T&iacute;tulo:&nbsp;</td>
                        <td width="350" align="left"><input name="var_titulo" type="text" class="textbox380" value="<%=objRS("TITULO")%>"></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">*Descri&ccedil;&atilde;o:&nbsp;</td>
                        <td width="350" align="left"><textarea name="var_descricao" rows="3" class="textbox380"><%=objRS("DESCRICAO")%></textarea></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">Capacidade:&nbsp;</td>
                        <td width="350" align="left"><input name="var_capacidade" type="text" class="textbox70" value="<%=objRS("CAPACIDADE")%>"></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">Data/Hora:&nbsp;</td>
                        <td width="350" align="left"><input name="var_dt_ocorrencia" type="text" class="textbox180" value="<%=PrepData(objRS("DT_OCORRENCIA"),True,True)%>"></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">Local:&nbsp;</td>
                        <td width="350" align="left"><input name="var_local" type="text" class="textbox380" value="<%=objRS("LOCAL")%>"></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">Carga Hor&aacute;ria:&nbsp;</td>
                        <td width="350" align="left"><input name="var_carga_horaria" type="text" class="textbox380" value="<%=objRS("CARGA_HORARIA")%>"></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">ID Start Comp.:&nbsp;</td>
                        <td width="350" align="left"><input name="var_num_competidor_start" type="text" class="textbox70" value="<%=objRS("NUM_COMPETIDOR_START")%>"></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">Configuração do Certificado:</td>
                        <td width="350" align="left"><textarea name="var_certificado_texto" rows="6" class="textbox380"><%=ReturnCaracterEspecial(objRS("CERTIFICADO_TEXTO")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td width="100" align="right" valign="top">&nbsp;</td>
                        <td width="350" align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificado');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                        <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">Configuração do Diploma:</td>
                        <td width="350" align="left"><textarea name="var_diploma_texto" rows="6" class="textbox380"><%=ReturnCaracterEspecial(objRS("DIPLOMA_TEXTO")&"")%></textarea></td>
                      </tr>
                      <tr>
                        <td width="100" align="right" valign="top">&nbsp;</td>
                        <td width="350" align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diploma');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                        <strong>visualizar</strong></a></td>
                      </tr>
                       <tr> 
                        <td width="100" align="right" valign="top">Exibir na Loja:&nbsp;</td>
                        <td width="350" align="left">
                          <%
						 Dim strSIM, strNAO
					     If objRS("LOJA_SHOW") Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
						<input type="radio" name="var_loja_show" value="1"<%=strSIM%>> Sim &nbsp;&nbsp;
						<input type="radio" name="var_loja_show" value="0"<%=strNAO%>> Não &nbsp;&nbsp;						
						</td>
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
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr> 
      <td width="4"     height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td width="235"   height="4" background="../img/inbox_bottom_blue.gif"><img src="img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"    height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:formupdate.submit();"><img src="../img/bt_save.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"     height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
  
   <br>

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
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Pre&ccedil;os - Produto</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			      <table width="470" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="form_listaprecos" action="../_database/AthInsertToDB.asp" method="POST">
                      <input type="hidden" name="DEFAULT_TABLE" value="tbl_PrcLista">
                      <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                      <input type="hidden" name="FIELD_PREFIX"  value="DBVAR_">
                      <input type="hidden" name="RECORD_KEY_NAME" value="COD_PRLISTA">
                      <input type="hidden" name="DEFAULT_LOCATION" value="../adm_produto/update.asp?var_chavereg=<%=objRS("COD_PROD")%>">
                      <input type="hidden" name="DBVAR_NUM_COD_PROD" value="<%=objRS("COD_PROD")%>">
                      <tr> 
                        <td colspan="2" align="center"><% MontaTabelaPrecos %></td>
                      </tr>
                      <tr>
                        <td align="right">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="109" align="right">Data de Vig&ecirc;ncia:&nbsp;</td>
                        <td width="373"><input name="DBVAR_DATE_DT_VIGENCIA_INICô" type="text" class="textbox100" size="10" maxlength="10" value="">
                          a
                          <input name="DBVAR_DATE_DT_VIGENCIA_FIMô" type="text" class="textbox100" size="10" maxlength="10"></td>
                      </tr>
                      <tr> 
                        <td align="right">Pre&ccedil;o Lista:&nbsp;</td>
                        <td><input name="DBVAR_FLOAT_PRC_LISTAô" type="text" class="textbox100" size="10" maxlength="10"></td>
                      </tr>
                      <tr> 
                        <td align="right">Status de Compra:&nbsp;</td>
                        <td>
						<select name="DBVAR_NUM_COD_STATUS_PRECOô" class="textbox180">
						<%
						strSQL = " SELECT COD_STATUS_PRECO, STATUS FROM tbl_STATUS_PRECO WHERE COD_EVENTO = " & Session("COD_EVENTO")
						MontaCombo strSQL, "COD_STATUS_PRECO", "STATUS", ""
						%>
                        </select>
						</td>
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
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_listaprecos.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>

        <br>
		
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
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Palestrantes - Produto</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			      <table width="470" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="form_listapalestrantes" action="InsUpdProdPalestranteExec.asp" method="POST">
                      <input type="hidden" name="var_cod_prod" value="<%=objRS("COD_PROD")%>">
                      <tr> 
                        <td colspan="2" align="center">
                          <% MontaListaPalestrantes %>
                        </td>
                      </tr>
                      <tr>
                        <td align="right">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="right">Palestrante:&nbsp;</td>
                        <td>
						<select name="var_cod_palestrante" class="textbox180">
						<%
						strSQL = " SELECT T1.COD_PALESTRANTE, T1.NOME " &_
								 " FROM tbl_PALESTRANTE T1, tbl_Palestrante_Evento T2 " &_
								 " WHERE T1.OCULTO = 0 " &_
								 " AND T1.COD_PALESTRANTE = T2.COD_PALESTRANTE " &_
								 " AND T2.COD_EVENTO = " & Session("COD_EVENTO") &_
								 " ORDER BY T1.NOME "
						MontaCombo strSQL, "COD_PALESTRANTE", "NOME", ""
						%>
                        </select>
						</td>
                      </tr>
                      <tr> 
                        <td align="right">Função:&nbsp;</td>
                        <td><input name="var_funcao" type="text" class="textbox180" maxlength="50">
						</td>
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
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_listapalestrantes.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>

</tr></td></table>
</body>
</html>
<%
  FechaRecordSet ObjRS
  FechaDBConn ObjConn
%>