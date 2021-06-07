<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<!--#include file="montatabelas.asp"-->
<%

Dim objConn, objRS, strSQL
Dim strCOD_EVENTO, strLANG, strID_AUTO

strID_AUTO    = GetParam("var_chavereg")
strCOD_EVENTO = GetParam("var_cod_evento")
strLANG       = GetParam("var_lang")

If strLANG = "" Then
  strLANG = "PT"
End If


AbreDBConn objConn, CFG_DB_DADOS 


'Busca o idauto do ultimo registro inserido, caso não venha por parâmtro (como acontece a partir da insert)
'com este idauto monta o sql para busca dos dados a serem alteradso nessa update
if strID_AUTO = "" then
	strSQL = "          SELECT MAX(idauto) as ult_idauto "
	strSQL = strSQL & "   FROM tbl_area_restrita_expositor "
	strSQL = strSQL & "  WHERE cod_evento = " & ValidateValueSQL(strCOD_EVENTO,"STR",false)  
	strSQL = strSQL & "    AND lang = " & ValidateValueSQL(strLANG,"STR",false)
	Set objRS = objConn.execute(strSQL)

	If Not objRS.EOF Then
	  strID_AUTO = GetValue(objRS,"ult_idauto")
	End if
end if


if strID_AUTO <> "" then
	strSQL = " SELECT         idauto "
	strSQL = strSQL & "		, cod_evento "
	strSQL = strSQL & "		, lang "
	strSQL = strSQL & "		, dt_ini "
	strSQL = strSQL & "		, dt_fim "
	strSQL = strSQL & "		, email_auditoria_caex "
	strSQL = strSQL & "		, convite_eletronico_texto "
	strSQL = strSQL & "		, convite_vip_texto "
	strSQL = strSQL & "		, cabecalho_form, rodape_form "
	strSQL = strSQL & "		, sys_inativo "
	strSQL = strSQL & "		, apresentacao "
	strSQL = strSQL & "		, apresentacao_intl "
	strSQL = strSQL & "		, dt_limite_pgto "
	strSQL = strSQL & "		, contrato_texto "
	strSQL = strSQL & " FROM tbl_area_restrita_expositor "
	strSQL = strSQL & " WHERE idauto = " & strID_AUTO 
	
	Set objRS = objConn.execute(strSQL)
Else
	response.End()
End if


If Not objRS.EOF Then
%>
<html>
<head>
	<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../_css/csm.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" language="javascript">
		<!--
		function viewdoc(doc) {
		  var conteudo = '';
		  
		  if(doc!='') {
			conteudo = eval('document.formdetail.dbvar_str_' + doc + '.value');
		  }
		  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
		}
		
		function UploadImage(formname,fieldname, dir_upload) {
		 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
		 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
		}
		
		function SetFormField(formname, fieldname, valor) {
		  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
		  {
			eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
			//document.location.reload();
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

		
		function DeleteSelect (formname){
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
			 if (codigos != '')  {			  
			  a=confirm("Você quer apagar definitivamente o(s) ítem(ns) selecionado(s)?");
			  if (a==true)  {
				var strpath = '';
				if (formname == 'form_documentos')
					strpath = '../_database/athDeleteToDB.asp?default_table=tbl_documentos' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=id_documento' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_AreaRestritaSetup/update.asp?var_chavereg=<%=strID_AUTO&Server.URLEncode("&")%>var_cod_evento=<%=strCOD_EVENTO&Server.URLEncode("&")%>&var_lang=<%=strLANG%>';
				document.location = strpath;

				if (formname == 'formstatuspreco')
					strpath = '../_database/athDeleteToDB.asp?default_table=tbl_status_preco' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=cod_status_preco' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_AreaRestritaSetup/update.asp?var_chavereg=<%=strID_AUTO&Server.URLEncode("&")%>var_cod_evento=<%=strCOD_EVENTO&Server.URLEncode("&")%>&var_lang=<%=strLANG%>';
				document.location = strpath;
				
				if (formname == 'form_formularios')
					strpath = '../_database/athDeleteToDB.asp?default_table=tbl_formularios' + '&default_db=<%=CFG_DB_DADOS%>' + '&record_key_name=cod_formulario' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../modulo_AreaRestritaSetup/update.asp?var_chavereg=<%=strID_AUTO&Server.URLEncode("&")%>var_cod_evento=<%=strCOD_EVENTO&Server.URLEncode("&")%>&var_lang=<%=strLANG%>';
				document.location = strpath;
			  }
			}
		}

		-->
	</script>
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle"><img src="../img/spacer.gif" width="10" height="5"></td>
</tr>
<tr> 
<td align="center" valign="middle">
   <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
          <td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
      <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
        <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              <tr> 
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Configuração de Área Restrita</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
                <td align="center"> 
				  <table width="99%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="formdetail" action="../_database/athupdatetodb.asp" method="post">
						<input type="hidden" name="DEFAULT_TABLE" value="tbl_area_restrita_expositor">
  						<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
  						<input type="hidden" name="FIELD_PREFIX" value="dbvar_">
  						<input type="hidden" name="RECORD_KEY_NAME" value="idauto">
  						<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strID_AUTO%>">
  						<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_AreaRestritaSetup/update.asp?var_chavereg=<%=strID_AUTO%>&var_cod_evento=<%=strCOD_EVENTO%>&var_lang=<%=strLANG%>">
                      <tr> 
                        <td align="right" width="120"><strong>*Evento:&nbsp;</strong></td>
                        <td>
							<select name="dbvar_num_cod_evento" class="textbox180" disabled>
								<% MontaCombo "SELECT cod_evento, nome FROM tbl_evento ORDER BY dt_inicio DESC", "cod_evento", "nome", strCOD_EVENTO %>
							</select>
						</td>
                      </tr>
                      <tr>
                        <td align="right"><strong>*Lingua:&nbsp;</strong></td>
                        <td>
							<select name="dbvar_str_lang" class="textbox180" disabled>
                                <option value=""<% If strLANG = "" Then Response.Write(" selected") End If%>>Todos</option>
								<option value="PT"<% If strLANG = "PT" Then Response.Write(" selected") End If%>>Português (PT)</option>
								<option value="EN"<% If strLANG = "EN" Then Response.Write(" selected") End If%>>Inglês (EN)</option>
								<option value="SP"<% If strLANG = "SP" Then Response.Write(" selected") End If%>>Espanhol (SP)</option>
							</select>
						</td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>*Data Início:&nbsp;</strong></td>
                        <td><input type="text" name="dbvar_date_dt_ini" value="<%=GetValue(objRS,"dt_ini")%>" class="textbox70"></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Data Término:&nbsp;</strong></td>
                        <td><input type="text" name="dbvar_date_dt_fim" value="<%=GetValue(objRS,"dt_fim")%>" class="textbox70"></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Email Auditoria:&nbsp;</strong></td>
                        <td><input type="text" name="dbvar_str_email_auditoria_caex" value="<%=GetValue(objRS,"email_auditoria_caex")%>" class="textbox380"></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Data Limite Cobrança:&nbsp;</strong></td>
                        <td><input type="text" name="dbvar_date_dt_limite_pgto" value="<%=GetValue(objRS,"dt_limite_pgto")%>" class="textbox70"></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Convite Eletrônico:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_convite_eletronico_texto" cols="40" rows="6" class="textbox380"><%=GetValue(objRS,"convite_eletronico_texto")%></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('convite_eletronico_texto');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Convite VIP:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_convite_vip_texto" rows="6" class="textbox380"><%=GetValue(objRS,"convite_vip_texto")%></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('convite_vip_texto');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Cabeçalho Formulários:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_cabecalho_form" rows="6" class="textbox380"><%=GetValue(objRS,"cabecalho_form")%></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('cabecalho_form');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Rodapé Formulários:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_rodape_form" rows="6" class="textbox380"><%=GetValue(objRS,"rodape_form")%></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('rodape_form');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>	
                      <tr> 
                        <td align="right"><strong>Apresentação:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_apresentacao" rows="6" class="textbox380"><%=GetValue(objRS,"apresentacao")%></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('apresentacao');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>	
                      <tr> 
                        <td align="right"><strong>Apresentação Intl:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_apresentacao_intl" rows="6" class="textbox380"><%=GetValue(objRS,"apresentacao_intl")%></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('apresentacao_intl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>	
                      <tr> 
                        <td align="right"><strong>Contrato:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_contrato_texto" rows="6" class="textbox380"><%=GetValue(objRS,"contrato_texto")%></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('contrato_texto');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
						<tr>
							<td width="120" align="right" style="font-weight:bold;">Upload de Imagens:&nbsp;</td>
							<td>
								<a href="javascript:UploadImage('','','\\AreaRestrita<% If objRS("LANG") <> "PT" Then Response.Write("Intl") End If %>\\img\\');">
									<img src="../IMG/bt_upload.gif" width="78" height="17" hspace="5" border="0" align="absmiddle">
								</a>
							</td>
						</tr>
                      <tr>
                        <td align="right"><strong>Inativo:&nbsp;</strong></td>
                        <td align="left">
						<input name="dbvar_date_sys_inativo" type="radio"<% If GetValue(objRS,"sys_inativo") <> "" Then Response.Write(" checked") End If %> value="<%=Now()%>"> Sim 
						<input name="dbvar_date_sys_inativo" type="radio"<% If GetValue(objRS,"sys_inativo") = "" Then Response.Write(" checked") End If %> value=""> Não 
                      </tr>
                    </form>
                  </table>
				</td>
          </tr>
          <tr> 
            <td align="center">&nbsp;</td>
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
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:document.formdetail.submit();"><img src="../img/bt_save.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
    <br /><br />
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
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Formulários</td>
          </tr> 
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>                    
          
          
          <tr> 
            <td align="center">
			      <table width="470" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="form_formularios" action="../_database/AthInsertToDB.asp" method="POST">
							<input type="hidden" name="DEFAULT_TABLE" value="tbl_formularios">
							<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
							<input type="hidden" name="FIELD_PREFIX" value="dbvar_">
							<input type="hidden" name="RECORD_KEY_NAME" value="cod_formulario">
                    <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_AreaRestritaSetup/update.asp?=<%=strID_AUTO%>&var_cod_evento=<%=strCOD_EVENTO%>&var_lang=<%=strLANG%>">
							<input type="hidden" name="dbvar_num_cod_evento" value="<%=objRS("COD_EVENTO")%>">
							<input type="hidden" name="dbvar_str_lang" value="<%=objRS("LANG")%>">
                      <tr> 
                        <td align="center"><% MontaTabelaFormularios %></td>
                      </tr>

                      <tr> 
                        <td height="16" align="center">
                        <strong><font color="#FF0000">Atenção</font>
                        <br>Antes de configurar os formulários verifique<br>a funcionalidade de cada um clicando 
                        <a href="javascript:AbreJanelaPAGE('info_forms.asp','1050', '750')"> aqui </a>!</strong>                        
                        </td>
                      </tr>
                     <tr> 
                        <td height="16" align="center">&nbsp;</td>
                      </tr>                                            
                      <tr>
                        <td>
                        
                        
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td align="right" style="font-weight:bold;">URL:&nbsp;</td>
											<td><!--input type="text" name="dbvar_str_link" class="textbox250" value="" //-->
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
                  	    %> <option value="<%=strFormFolder&"/"&objItem.Name%>"><%=objItem.Name%></option> <%
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
											<td align="right" style="font-weight:bold;">Rotulo:&nbsp;</td>
											<td><input type="text" name="dbvar_str_rotulo" class="textbox250" value=""></td>
										</tr>
										<tr>
											<td align="right" style="font-weight:bold;">Titulo:&nbsp;</td>
											<td><input type="text" name="dbvar_str_titulo" class="textbox250" value=""></td>
										</tr>
										<tr>
											<td align="right" style="font-weight:bold;">Dead Line:&nbsp;</td>
											<td><input type="text" name="dbvar_date_dt_inativo" class="textbox100" value=""></td>
										</tr>
										<tr>
											<td valign="top" align="right" style="font-weight:bold;">Categorias:&nbsp;</td>
											<td>
												<% 
												Dim objRSCat, arrCAT, strCHECKED, i
												
												strSQL = " SELECT cod_status_preco, status FROM tbl_status_preco WHERE cod_evento = " & objRS("COD_EVENTO") & " AND CAEX_SHOW = 1 ORDER BY status" 
												Set objRSCat = objConn.execute(strSQL)
												
												Do While Not objRSCat.EOF
												%>
												<input type="checkbox" name="var_cod_status_preco" id="check_<%=objRSCat("cod_status_preco")%>" value="<%=objRSCat("cod_status_preco")%>"> <%=objRSCat("status")%> <br />
												<%
													objRSCat.MoveNext
												Loop
												%>
											</td>
										</tr>
										<tr>
											<td align="right" style="font-weight:bold;">Área:&nbsp;</td>
											<td>
												<select name="dbvar_str_cod_status_cred" class="textbox180">
													<option value=""></option>
													<% MontaCombo "SELECT cod_status_cred, status FROM tbl_status_cred ORDER BY status", "cod_status_cred", "status", "" %>
												</select>
											</td>
										</tr>
										<tr>
											<td valign="top" align="right" style="font-weight:bold;">Obrigatório para:&nbsp;</td>
											<td>
												<% 
												
												strSQL = " SELECT cod_status_preco, status FROM tbl_status_preco WHERE cod_evento = " & objRS("COD_EVENTO") & " AND CAEX_SHOW = 1 ORDER BY status" 
												Set objRSCat = objConn.execute(strSQL)
												
												Do While Not objRSCat.EOF
												%>
												<input type="checkbox" name="var_preenchimento_obrigatorio" id="check_obr_<%=objRSCat("cod_status_preco")%>" value="<%=objRSCat("cod_status_preco")%>"> <%=objRSCat("status")%> <br />
												<%
													objRSCat.MoveNext
												Loop
												%>
											</td>
										</tr>
									</table>
                        
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
          <td align="right" background="../img/inbox_bottom_big3.gif">
		  <a href="javascript:form_formularios.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a>
		  <img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
  <br /><br />
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
                    <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_AreaRestritaSetup/update.asp?=<%=strID_AUTO%>&var_cod_evento=<%=strCOD_EVENTO%>&var_lang=<%=strLANG%>">
						<input type="hidden" name="dbvar_num_cod_evento" value="<%=objRS("COD_EVENTO")%>">
						<input type="hidden" name="dbvar_str_lang" value="<%=objRS("LANG")%>">
                      <tr> 
                        <td colspan="3" align="center"><% MontaTabelaDocumentos %></td>
                      </tr>
					  <tr>
							<td width="120" align="right" style="font-weight:bold;">Documento:&nbsp;</td>
							<td>
								<input type="text" name="dbvar_str_documento" class="textbox250">
								<a href="javascript:UploadImage('form_documentos','dbvar_str_documento','\\AreaRestrita<% If strLANG <> "PT" Then Response.Write("Intl") End If %>\\download\\');">
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
						<tr>
							<td width="120" align="right" style="font-weight:bold;">Área:&nbsp;</td>
							<td>
								<select name="dbvar_str_area" class="textbox180">
									<option value=""></option>
									<% MontaCombo "SELECT status FROM tbl_status_cred ORDER BY status", "status", "status", "" %>
								</select>
							</td>
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
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:form_documentos.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
  <br>
  <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
          <td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
          <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
        </tr>
      </table>
      <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
        <tr>
          <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              <tr>
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Categoria </td>
              </tr>
              <tr>
                <td height="16" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td align="center"><form name="formstatuspreco" action="../_database/athinserttodb.asp" method="post">
                    <input type="hidden" name="DEFAULT_TABLE" value="TBL_STATUS_PRECO">
                    <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                    <input type="hidden" name="FIELD_PREFIX" value="dbvar_">
                    <input type="hidden" name="RECORD_KEY_NAME" value="COD_STATUS_CRED">
                    <input type="hidden" name="DEFAULT_LOCATION" value="../modulo_AreaRestritaSetup/update.asp?=<%=strID_AUTO%>&var_cod_evento=<%=strCOD_EVENTO%>&var_lang=<%=strLANG%>">
                    <input type="hidden" name="dbvar_num_cod_evento" value="<%=objRS("COD_EVENTO")%>">
                    <input type="hidden" name="dbvar_num_caex_show" value="1">
                    <table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr>
                        <td colspan="2" align="center"><% MontaListaStatusPreco %></td>
                      </tr>
                    </table>
                </form></td>
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
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:document.formstatuspreco.submit();"><img src="../img/bt_adic.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
          <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
        </tr>
      </table>
    </tr></td>
<tr> 
<td align="center" valign="middle"><img src="../img/spacer.gif" width="10" height="5"></td>
</tr>
</table>
</body>
</html>
<%
End If

FechaRecordSet objRS
FechaDBConn objConn
%>