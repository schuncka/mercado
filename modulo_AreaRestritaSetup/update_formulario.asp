<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objRS, objRSDetail, strSQL, objConn
Dim strCOD_FORMAPGTO, strID_DOCUMENTO, strLANG

strID_DOCUMENTO = request("var_chavereg")

strLANG = GetParam("var_lang")

If strLANG = "" Then
  strLANG = "PT"
End If


If strID_DOCUMENTO <> "" Then
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strSQL = " SELECT * FROM tbl_formularios WHERE cod_formulario = " & strID_DOCUMENTO
	Set objRS = objConn.execute(strSQL)

Function MontaListaServico
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellpadding='1' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='middle' width='15'>")
	Response.Write("            <a onmouseover=""window.status='Selecionar/Deselecionar Todos';return true"" onclick=""ToggleCheckAll('form_listaservico'); return false"" href=""javascript:;"">")
	Response.Write("              <img src='../img/setabaixo.gif' border='0' width='11' height='12'>")
	Response.Write("            </a>")
	Response.Write("          </td>")	
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Serviço</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Qtde Fixa</strong></td>")	
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='15%'><strong>Ordem</strong></td>")
	Response.Write("        </tr>")
    '<!-- header da tabela ----------------------------------------------------------->
	
	strSQL = " SELECT fs.IDAUTO, aserv.titulo, fs.qtde_fixa, fs.ordem  " &_
			 "   FROM tbl_formularios_servicos AS fs left join tbl_aux_servicos as ASERV ON fs.COD_SERV = aserv.COD_SERV " &_
			 "  WHERE fs.COD_FORMULARIO = " & strID_DOCUMENTO &_
			 "  ORDER BY ORDEM, TITULO " 
			 
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
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("TITULO") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("QTDE_FIXA") & "</td>")		
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("ORDEM") & "</td>")
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
	Response.Write("            <a onmouseover=""window.status='Apagar Todos Selecionados';return true"" onclick=""DeleteSelect('form_listaservico'); return false"" href=""javascript:;""><img src='../img/lx_apagara.gif' vspace='2' border='0' width='12' height='18'></a>")
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
	<script type="text/javascript">
		function UploadImage(formname,fieldname, dir_upload) {
		 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
		 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
		}
		
		function SetFormField(formname, fieldname, valor) {
		  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
		  {
			eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
			document.location.reload();
		  }
		}
		
		function joinCategoriaValues () {
			var strCodigos = "";
			var i;
			
			try {
				for(i=0;i<document.formformapgto.var_cod_status_preco.length;i++) {
					strCodigos += (document.formformapgto.var_cod_status_preco[i].checked && i != 0) ? "," : "";
					strCodigos += (document.formformapgto.var_cod_status_preco[i].checked) ? document.formformapgto.var_cod_status_preco[i].value : "";
				}
			}
			catch(err) {
			}
			
			document.formformapgto.dbvar_str_cod_status_preco.value = strCodigos;
			
			strCodigos = "";
			try { 
				for(i=0;i<document.formformapgto.var_preenchimento_obrigatorio.length;i++) {
					strCodigos += (document.formformapgto.var_preenchimento_obrigatorio[i].checked && i != 0) ? "," : "";
					strCodigos += (document.formformapgto.var_preenchimento_obrigatorio[i].checked) ? document.formformapgto.var_preenchimento_obrigatorio[i].value : "";
				}
			}
			catch(err) {
			}
			
			document.formformapgto.dbvar_str_preenchimento_obrigatorio.value = strCodigos;
		}
		
		function UploadImage(formname,fieldname, dir_upload) {
		 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
		 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
		}
		
		function SetFormField(formname, fieldname, valor) {
		  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
		  {
			eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
			document.location.reload();
		  }
		} 
	
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
  	if (formname == 'form_listaservico')
		strpath = '../_database/athDeleteToDB.asp?default_table=tbl_formularios_servicos' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=IDAUTO' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../arearestritasetup/update_formulario.asp?var_chavereg=<%=strID_DOCUMENTO%>';
	document.location = strpath;
  }
}

return false;
}

	</script>
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br>
<table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr> 
		<td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
		<td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
    	<td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
	<tr> 
    	<td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
        <td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              	<tr>   
                	<td bgcolor="#7DACC5">&nbsp;&nbsp;Edição de documento</td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr> 
        		    <td align="center">
			 			<form name="formformapgto" action="../_database/athupdatetodb.asp" method="post">
							<input type="hidden" name="DEFAULT_TABLE" value="tbl_formularios">
							<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
							<input type="hidden" name="FIELD_PREFIX" value="dbvar_">
							<input type="hidden" name="RECORD_KEY_NAME" value="cod_formulario">
							<input type="hidden" name="RECORD_KEY_VALUE" value="<%=objRS("cod_formulario")%>">
							<input type="hidden" name="DEFAULT_LOCATION" value="javascript:window.opener.document.location.reload(); window.close();">
							<input type="hidden" name="dbvar_num_cod_evento" value="<%=objRS("COD_EVENTO")%>">
							<input type="hidden" name="dbvar_str_lang" value="<%=objRS("LANG")%>">
							<input type="hidden" name="dbvar_str_cod_status_preco" value="">
							<input type="hidden" name="dbvar_str_preenchimento_obrigatorio" value="">
			 			<table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">  
							<tr> 
				                <td colspan="2" align="center">
									<table border="0" cellpadding="0" cellspacing="0" width="95%">
										<tr>
											<td width="150" align="right" style="font-weight:bold;">URL:&nbsp;</td>
										  <td>
                 <select name="dbvar_str_link" class="textbox250">
				 <option value="" selected>Selecione...</option>
                 <%
				  Dim objFSO, strPath, objFolder, objItem   
				  Dim strFormFolder
				  
				  strFormFolder = Session("COD_EVENTO")&lcase(strLANG)
                  strPath = "..\arearestrita\"&strFormFolder&"\" 'Tem que terminar com barra
				  'response.Write(strPath)
				  'response.End()
                  Set objFSO    = Server.CreateObject("Scripting.FileSystemObject")
				  
				  If not objFSO.FolderExists(Server.MapPath(strPath)) Then
				    'objFSO.CreateFolder(Server.MapPath(strPath))
					strFormFolder = "forms"
					strPath = "..\arearestrita\"&strFormFolder&"\" 'Tem que terminar com barra
				  End IF
				  
                  Set objFolder = objFSO.GetFolder(Server.MapPath(strPath))
                  For Each objItem In objFolder.Files
                      If (InStr(lcase(objItem.Name),".asp") > 0) and ( left(objItem.Name,1) <> "_" ) Then
                  	    %> <option value="<%=strFormFolder&"/"&objItem.Name%>" <% If objRS("link")&"" = (strFormFolder&"/"&objItem.Name) Then Response.Write("selected") End If %> ><%=objItem.Name%></option> <%
                	  End If
                  Next 
                  Set objItem   = Nothing
                  Set objFolder = Nothing
                  Set objFSO    = Nothing
                  %>
                  </select>
                                          </td>
										</tr>
										<tr>
											<td width="150" align="right" style="font-weight:bold;">Rotulo:&nbsp;</td>
										  <td><input type="text" name="dbvar_str_rotulo" class="textbox250" value="<%=objRS("rotulo")%>"></td>
										</tr>
										<tr>
											<td width="150" align="right" style="font-weight:bold;">Titulo:&nbsp;</td>
										  <td><input type="text" name="dbvar_str_titulo" class="textbox250" value="<%=objRS("titulo")%>"></td>
										</tr>
                                        <%
										If objRS("LINK") = "forms/form_termo_empresa.asp" Then
										%>
										<tr>
											<td width="150" align="right" style="font-weight:bold;">Tipo Termo:&nbsp;</td>
										  <td>
                                             <input name="dbvar_str_termo_tipo" id="dbvar_str_termo_tipo" type="radio" value="SEGURANCA" <% If getValue(objRS,"TERMO_TIPO") = "SEGURANCA" Then Response.Write("checked") End If %> >
                                             Segurança 

                                             <input name="dbvar_str_termo_tipo" id="dbvar_str_termo_tipo"  type="radio" value="AGENCIA" <% If getValue(objRS,"TERMO_TIPO") = "AGENCIA" Then Response.Write("checked") End If %>>
                                             Agência 
                                             
											 <input name="dbvar_str_termo_tipo" id="dbvar_str_termo_tipo"  type="radio" value="PRESTADOR" <% If getValue(objRS,"TERMO_TIPO") = "PRESTADOR" Then Response.Write("checked") End If %>>
                                             Prestador de Serviços                                              
										  </td>
										</tr>
                                        <% End if %>
                                        
                                        <tr>
											<td width="150" align="right" style="font-weight:bold;">Instrução:&nbsp;</td>
										  <td><textarea name="dbvar_str_instrucao" class="textbox380" rows="5"><%=objRS("instrucao")%></textarea></td>
										</tr>
                                        <tr>
											<td width="150" align="right" style="font-weight:bold;">Rodapé:&nbsp;</td>
										  <td><textarea name="dbvar_str_rodape" class="textbox380" rows="4"><%=objRS("rodape")%></textarea></td>
										</tr>
										<tr>
											<td width="150" align="right" style="font-weight:bold;">Rotulo Internacional:&nbsp;</td>
										  <td><input type="text" name="dbvar_str_rotulo_intl" class="textbox250" value="<%=objRS("rotulo_intl")%>"></td>
										</tr>
										<tr>
											<td width="150" align="right" style="font-weight:bold;">Titulo Internacional:&nbsp;</td>
										  <td><input type="text" name="dbvar_str_titulo_intl" class="textbox250" value="<%=objRS("titulo_intl")%>"></td>
										</tr>
                                        <tr>
											<td width="150" align="right" style="font-weight:bold;">Instrução Internacional:&nbsp;</td>
										  <td><textarea name="dbvar_str_instrucao_intl" class="textbox380" rows="5"><%=objRS("instrucao_intl")%></textarea></td>
										</tr>
                                        <tr>
											<td width="150" align="right" style="font-weight:bold;">Rodapé Internacional:&nbsp;</td>
										  <td><textarea name="dbvar_str_rodape_intl" class="textbox380" rows="4"><%=objRS("rodape_intl")%></textarea></td>
										</tr>
										<tr>
											<td width="150" align="right" style="font-weight:bold;">Dead Line:&nbsp;</td>
										  <td><input type="text" name="dbvar_date_dt_inativo" class="textbox100" value="<%=objRS("dt_inativo")%>"></td>
										</tr>
										<tr>
											<td width="150" valign="top" align="right" style="font-weight:bold;">Categorias:&nbsp;</td>
											<td>
											  <% 
												Dim objRSCat, arrCAT, arrCAT_OBRIGATORIO, strCHECKED, i
												
												strSQL = " SELECT cod_status_preco, status FROM tbl_status_preco WHERE cod_evento = " & objRS("COD_EVENTO") & " AND CAEX_SHOW = 1 ORDER BY status" 
												Set objRSCat = objConn.execute(strSQL)
												
												Do While Not objRSCat.EOF
													arrCAT = Split(""&objRS("cod_status_preco"),",")
													strCHECKED = ""
													For i = 0 To UBound(arrCAT)
														If CStr(arrCAT(i)) = CStr(objRSCat("cod_status_preco")) Then
															strCHECKED = " checked"
														End If
													Next
												%>
												<input type="checkbox" name="var_cod_status_preco"<%=strCHECKED%> id="check_<%=objRSCat("cod_status_preco")%>" value="<%=objRSCat("cod_status_preco")%>"> <%=objRSCat("status")%> <br />
												<%
													objRSCat.MoveNext
												Loop
												%>											</td>
										</tr>
										<tr>
											<td width="150" align="right" style="font-weight:bold;">Área:&nbsp;</td>
											<td>
											  <select name="dbvar_str_cod_status_cred" class="textbox180">
													<option value=""></option>
													<% MontaCombo "SELECT cod_status_cred, status FROM tbl_status_cred ORDER BY status", "cod_status_cred", "status", objRS("cod_status_cred") %>
												</select>											</td>
										</tr>
										<tr>
											<td width="150" valign="top" align="right" style="font-weight:bold;">Obrigatório para:&nbsp;</td>
											<td>
											  <% 
												
												strSQL = " SELECT cod_status_preco, status FROM tbl_status_preco WHERE cod_evento = " & objRS("COD_EVENTO") & " AND CAEX_SHOW = 1 ORDER BY status" 
												Set objRSCat = objConn.execute(strSQL)
												
												Do While Not objRSCat.EOF
													arrCAT_OBRIGATORIO = Split(""&objRS("preenchimento_obrigatorio"),",")
													strCHECKED = ""
													For i = 0 To UBound(arrCAT_OBRIGATORIO)
														If CStr(arrCAT_OBRIGATORIO(i)) = CStr(objRSCat("cod_status_preco")) Then
															strCHECKED = " checked"
														End If
													Next
												%>
												<input type="checkbox" name="var_preenchimento_obrigatorio"<%=strCHECKED%> id="check_obr_<%=objRSCat("cod_status_preco")%>" value="<%=objRSCat("cod_status_preco")%>"> <%=objRSCat("status")%> <br />
												<%
													objRSCat.MoveNext
												Loop
												%>											</td>
										</tr>
										<tr>
										  <td valign="top" align="right" style="font-weight:bold;">&nbsp;</td>
										  <td>&nbsp;</td>
									  </tr>
										<tr>
										  <td valign="top" align="right" style="font-weight:bold;">Campos Grade:</td>
										  <td><table width="200" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">&nbsp;</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#7DACC5">Sim</td>
                                              <td align="center" bgcolor="#7DACC5">N&atilde;o</td>
                                            </tr>
                                            <tr>
                                              <td width="100" align="right">C&oacute;digo</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td width="100" align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_bool_show_codigo" value="1" <% If objRS("show_codigo")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td width="100" align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_bool_show_codigo" value="0" <% If objRS("show_codigo")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>
                                            <tr>
                                              <td align="right">Quantidade</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_bool_show_qtde" value="1" <% If objRS("show_qtde")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_bool_show_qtde" value="0" <% If objRS("show_qtde")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>
                                            <tr>
                                              <td align="right">Valor</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_bool_show_valor" value="1" <% If objRS("show_valor")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_bool_show_valor" value="0" <% If objRS("show_valor")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>
                                            <tr>
                                              <td align="right">Sub-Total</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_bool_show_subtotal" value="1" <% If objRS("show_subtotal")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_bool_show_subtotal" value="0" <% If objRS("show_subtotal")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>
                                          </table></td>
									  </tr>
										<tr>
										  <td valign="top" align="right" style="font-weight:bold;">&nbsp;</td>
										  <td>&nbsp;</td>
									  </tr>
                                      <%
										strSQL =          " SELECT S.COD_SERV, S.TITULO FROM tbl_AUX_SERVICOS S INNER JOIN tbl_formularios_servicos FS ON S.COD_SERV = FS.COD_SERV "
										strSQL = strSQL & "  WHERE S.COD_EVENTO = " & Session("COD_EVENTO") 
										strSQL = strSQL & "    AND FS.COD_FORMULARIO = " & strID_DOCUMENTO 
										strSQL = strSQL & "    AND S.EMITE_CREDENCIAL = 1"
										
										Set objRSDetail = objConn.Execute(strSQL)

									    If not objRSDetail.EOF Then
									  %>
										<tr>
										  <td valign="top" align="right" style="font-weight:bold;">Campos Credencial:</td>
										  <td><table width="200" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">&nbsp;</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#7DACC5">Sim</td>
                                              <td align="center" bgcolor="#7DACC5">N&atilde;o</td>
                                            </tr>
                                            <tr>
                                              <td width="100" align="right">E-mail</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td width="100" align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_email" value="1" <% If objRS("show_Cred_email")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td width="100" align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_email" value="0" <% If objRS("show_Cred_email")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>
                                            <tr>
                                              <td align="right">CPF</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_cpf" value="1" <% If objRS("show_Cred_cpf")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_cpf" value="0" <% If objRS("show_Cred_cpf")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>
                                            <tr>
                                              <td align="right">RG</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_rg" value="1" <% If objRS("show_Cred_rg")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_rg" value="0" <% If objRS("show_Cred_rg")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>
                                            <tr>
                                              <td align="right">Cargo</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_cargo" value="1" <% If objRS("show_Cred_cargo")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_cargo" value="0" <% If objRS("show_Cred_cargo")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>
                                            <tr>
                                              <td align="right">Entidade</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_entidade" value="1" <% If objRS("show_Cred_entidade")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_entidade" value="0" <% If objRS("show_Cred_entidade")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>
                                            <tr>
                                              <td align="right">Fone</td>
                                              <td width="10" align="right">&nbsp;</td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_fone1" value="1" <% If objRS("show_Cred_fone1")&"" = "1" Then Response.Write("checked") End If %>></td>
                                              <td align="center" bgcolor="#E0ECF0"><input type="radio" name="dbvar_num_show_cred_fone1" value="0" <% If objRS("show_Cred_fone1")&"" <> "1" Then Response.Write("checked") End If %>></td>
                                            </tr>                                                                                        
                                          </table></td>
									  </tr>
										<tr>
										  <td valign="top" align="right" style="font-weight:bold;">&nbsp;</td>
										  <td>&nbsp;</td>
									  </tr>
                                      <%
									    End If
										FechaRecordSet objRSDetail
									  %>
									</table>
		 					  </td>
               					</tr>
							</table>
						</form>
					</td>
				</tr>
			</table>
		</td>
    	<td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
	</tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:joinCategoriaValues(); document.formformapgto.submit();"><img src="../img/bt_SAVE.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
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
                  <td bgcolor="#7DACC5">&nbsp;&nbsp;Servi&ccedil;os vinculados ao formul&aacute;rio</td>
                </tr>
                <tr>
                  <td height="16" align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td align="center"><table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <form name="form_listaservico" action="../_database/AthInsertToDB.asp" method="POST">
                        <input type="hidden" name="DEFAULT_TABLE" value="tbl_formularios_servicos">
                        <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                        <input type="hidden" name="FIELD_PREFIX"  value="dbvar_">
                        <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_AreaRestritaSetup/update_formulario.asp?var_chavereg=<%=strID_DOCUMENTO%>">
                        <input type="hidden" name="dbvar_num_cod_formulario" value="<%=strID_DOCUMENTO%>">
                        <tr>
                          <td colspan="2" align="center"><% MontaListaServico %></td>
                        </tr>
                        <tr>
                          <td width="100" align="right">&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td align="right">Servi&ccedil;o:&nbsp;</td>
                          <td><select name="dbvar_num_cod_serv" class="textbox380">
                              <%
							strSQL =          " SELECT COD_SERV, TITULO FROM tbl_AUX_SERVICOS "
							strSQL = strSQL & "  WHERE COD_EVENTO = " & Session("COD_EVENTO") 
							strSQL = strSQL & "    AND COD_SERV NOT IN ("
							strSQL = strSQL & "      SELECT COD_SERV FROM tbl_formularios_servicos WHERE COD_FORMULARIO = " & strID_DOCUMENTO 
							strSQL = strSQL & "    )"
							strSQL = strSQL & "  ORDER BY TITULO"
							MontaCombo strSQL, "COD_SERV", "TITULO", ""
							  %>
                          </select></td>
                        </tr>
                        <tr>
                          <td align="right">Qtde Fixa:&nbsp;</td>
                          <td><input name="dbvar_num_qtde_fixa" type="text" class="arial11" size="4" maxlength="4"></td>
						</tr>
                        <tr>
                          <td align="right">Ordem:&nbsp;</td>
                          <td><input type="text" name="dbvar_num_ordem" class="arial11"></td>
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
            <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_listaservico.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
            <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
          </tr>
        </table>
        <br>

</body>
</html>
<%
	FechaRecordSet(objRS)
	FechaDBConn(objConn)
End If
%>