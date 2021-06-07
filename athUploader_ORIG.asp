<%@ LANGUAGE="vbscript" %>
<!--#include file="_database/athDbConn.asp"--> 
<!--#include file="_database/athUtils.asp"--> 
<%
Response.Expires = 0 
Response.Buffer = True

	Dim objUpload,  strFUNC , strFORMNAME, strFIELDNAME, strFILE
	Dim strEXTENSAO, strEXT_ACAO, strMAXBYTES
	Dim FileName, strErr

	strErr			= GetParam("err")
	FileName		= GetParam("f")
	strFORMNAME		= GetParam("var_formname")	
	strFIELDNAME	= GetParam("var_fieldname")
	strID_FILE 		= GetParam("id_file")
	'strDIR_UPLOAD = Replace(GetParam("var_dir"), "\", "\\")
	strDIR_UPLOAD	= GetParam("var_dir")

    strEXTENSAO		= Request("var_ext")
	strEXT_ACAO		= Request("var_ext_acao") 'ALLOW ou DENY
	strMAXBYTES		= Request("maxbytes")
	
	strFUNC = GetParam("var_func")

	If IsEmpty(strFUNC) Then
		strFUNC = 1
	End If

  'DEBUG
  'response.write ("[" & strDIR_UPLOAD & "]")
  'response.write ("[" & strID_FILE & "]")
  'response.write ("[" & strFIELDNAME & "]")
  '[//subpaper//upload//][700078_10_][var_campo_sub_452ô]
  'response.end 
  
' Código para bloquear temporariamente o upload generico de arquivos		
'	strFUNC = 666

	Select Case strFUNC
		Case 666 %>
			<html>
			<head>
				<title>UpLoad</title>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
				<link href="_CSS/Csm.css" rel="stylesheet" type="text/css">
				<script language="JavaScript">
					alert('Upload indisponível no momento.');
					window.close();
				</script>
			</head>
	<%		
		Case 1
%>
			<html>
			<head>
				<title>UpLoad</title>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
				<link href="_CSS/Csm.css" rel="stylesheet" type="text/css">
				<script language="JavaScript">
					function EnviaForm()
					{
						for (i = 0; i < document.formupload.type_upload.length; i++)
						{
							if (eval('document.formupload.type_upload[' + i + '].checked'))
							{
								var valor = eval('document.formupload.type_upload[' + i + '].value');
								break;
							}
						}
						document.formupload.action = valor + '?var_formname=<%=strFORMNAME%>&var_fieldname=<%=strFIELDNAME%>&var_dir=<%=strDIR_UPLOAD%>&id_file=<%=strID_FILE%>&var_ext=<%=strEXTENSAO%>&var_ext_acao=<%=strEXT_ACAO%>&maxbytes=<%=strMAXBYTES%>';
						formupload.submit();
					}
				</script>
			</head>
			<body bgcolor="#FFFFFF" background="img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
			  <Form name="formupload" action="athUploader_DUNDAS.asp?var_formname=<%=strFORMNAME%>&var_fieldname=<%=strFIELDNAME%>&var_dir=<%=strDIR_UPLOAD%>&id_file=<%=strID_FILE%>&var_ext=<%=strEXTENSAO%>&var_ext_acao=<%=strEXT_ACAO%>&maxbytes=<%=strMAXBYTES%>" method="post" enctype="multipart/form-data">
			    <table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				  <tr>
				    <td align="center" valign="middle">
					  <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
					    <tr>
						  <td width="4" height="4"><img src="img/inbox_left_top_corner.gif" width="4" height="4"></td>
						  <td width="492" height="4"><img src="img/inbox_top_blue.gif" width="492" height="4" border="0"></td>
						  <td width="4" height="4"><img src="img/inbox_right_top_corner.gif" width="4" height="4"></td>
						</tr>
					  </table>
					  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
					    <tr>
						  <td width="4" background="img/inbox_left_blue.gif">&nbsp;</td>
						  <td width="492">
						    <table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
							  <tr>
							    <td bgcolor="#7DACC5">&nbsp;&nbsp;UpLoad</td>
							  </tr>
							  <tr>
							    <td height="16" align="center">&nbsp;</td>
							  </tr>
							  <tr>
							    <td align="center">
								  <table width="450" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <!--//
                      <tr> 
                        <td colspan="2" align="left"><strong>Instruções:</strong>&nbsp; 
                          Para enviar o seu arquivo siga as instruções abaixo:</td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="right">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="left">1. Clique no bot&atilde;o 
                          PROCURAR&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="left">2. Selecione o arquivo no 
                          seu computador&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="left">3. Clique no botão ENVIAR&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="left">&nbsp;</td>
                      </tr>
                      //-->
                      <tr> 
                        <td width="100" height="21" align="center" nowrap></td>
                        <td width="204" align="left"> <input name="file1" type="file" style="width:300px;" ></td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="right">&nbsp;</td>
                      </tr>
                      <!--
                      <tr> 
                        <td colspan="2" align="left"><strong>Nota:</strong> Por 
                          favor seja paciente, você não irá receber nenhuma notificação 
                          até que a transferência do arquivo seja concluída por 
                          completo.&nbsp;</td>
                      </tr>
                      //-->
                    </table>
								</td>
							  </tr>
							  <tr>
							    <td>&nbsp;</td>
							  </tr>
							</table>
						  </td>
						  <td width="4" background="img/inbox_right_blue.gif">&nbsp;</td>
						</tr>
					  </table>
					  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
					    <tr>
						  <td width="4"   height="4" background="img/inbox_left_bottom_corner.gif">&nbsp;</td>
						  <td height="4" width="235" background="img/inbox_bottom_blue.gif"><img src="img/blank.gif" alt="" border="0" width="1" height="32"></td>
						  <td width="21"  height="26"><img src="img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
						  <td align="right" background="img/inbox_bottom_big3.gif"><input type="button" value="OK" onClick="javascript:formupload.submit();">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="Cancel" onClick="javascript:window.close();"><br></td>
						  <td width="4"   height="4"><img src="img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
						</tr>
					  </table>
					</td>
				  </tr>
				</table>
			  </form>
			</body>
			</html>
<%
    Case 2
		If strErr <> "" Then
%>
			<html>
			<head>
			<title>UpLoad de Arquivo</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="_CSS/Csm.css" rel="stylesheet" type="text/css">
			</head>
			<body  bgcolor="#FFFFFF" background="img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
			  <form name="formuploaderror" action="athUploader.asp?var_formname=<%=strFORMNAME%>&var_fieldname=<%=strFIELDNAME%>&var_dir=<%=strDIR_UPLOAD%>&id_file=<%=strID_FILE%>&var_ext=<%=strEXTENSAO%>&var_ext_acao=<%=strEXT_ACAO%>&maxbytes=<%=strMAXBYTES%>&var_func=1" method="POST">
			    <table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				  <tr>
				    <td align="center" valign="middle">
					  <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
					    <tr>
						  <td width="4" height="4"><img src="img/inbox_left_top_corner.gif" width="4" height="4"></td>
						  <td width="492" height="4"><img src="img/inbox_top_blue.gif" width="492" height="4"></td>
						  <td width="4" height="4"><img src="img/inbox_right_top_corner.gif" width="4" height="4"></td>
						</tr>
					  </table>
					  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
					    <tr>
						  <td width="4" background="img/inbox_left_blue.gif">&nbsp;</td>
						  <td width="492">
						    <table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
							  <tr>
							    <td bgcolor="#7DACC5">&nbsp;&nbsp;UpLoad</td>
							  </tr>
							  <tr>
							    <td height="16" align="center">&nbsp;</td>
							  </tr>
							  <tr>
							    <td align="center">
								  <table width="450" border="0" cellpadding="0" cellspacing="0" class="arial11">
								    <tr>
									  <td  align="left">&nbsp; Ocorreu um erro ao tentar enviar o seu arquivo!
                                      <br><br>&nbsp; An error has occurred!</td>
									</tr>
                                    <!--
									<tr>
									  <td align="left">&nbsp;</td>
									</tr>
								    <tr>
									  <td  align="left"><strong>ERRO:</strong>&nbsp;<%'=strErr%></td>
									</tr>
									<tr>
									  <td align="left">&nbsp; Clique no botão VOLTAR para tentar novamente o upload ou em FECHAR para sair.</td>
									</tr>
									<tr>
									  <td align="left">&nbsp;</td>
									</tr>
                                    //-->
								  </table>
								</td>
							  </tr>
							  <tr>
							    <td>&nbsp;</td>
							  </tr>
							</table>
						  </td>
						  <td width="4" background="img/inbox_right_blue.gif">&nbsp;</td>
						</tr>
					  </table>
					  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
					    <tr>
						  <td width="4"   height="4" background="img/inbox_left_bottom_corner.gif">&nbsp;</td>
						  <td height="4" width="235" background="img/inbox_bottom_blue.gif"><img src="img/blank.gif" alt="" border="0" width="1" height="32"></td>
						  <td width="21"  height="26"><img src="img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
						  <td align="right" background="img/inbox_bottom_big3.gif">
                          <!-- <a href="javascript:formuploaderror.submit();"><img src="img/bt_voltar.gif" width="63" height="17" hspace="10" border="0"></a> //-->
                          <input type="button" value="OK" onClick="javascript:window.close();"><img src="img/t.gif" width="3" height="3"><br></td>
						  <td width="4"   height="4"><img src="img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
						</tr>
					  </table>
					</td>
				  </tr>
				</table>
			  </form>
			</body>
			</html>
<%
        Else
%>
			<html>
			<head>
			<title>UpLoad</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="_CSS/Csm.css" rel="stylesheet" type="text/css">

			<script language="JavaScript">
			<!--
			function SetParentField () {
				self.opener.SetFormField('<%=strFORMNAME%>','<%=strFIELDNAME%>','<%=FileName%>');

				/*SETA POR NAME
				var objFiedX, i;
				objFiedX = self.opener.document.getElementsByName("<%=strFIELDNAME%>";
				for (i = 0; i < x.length; i++) {
					objFiedX[i].value = '<%=FileName%>';
				}*/
			}
			//-->
			</script>
			
			</head>
			<body onLoad="SetParentField();" bgcolor="#FFFFFF" background="img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
			  <table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			    <tr>
				  <td align="center" valign="middle">
				    <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
					    <td width="4" height="4"><img src="img/inbox_left_top_corner.gif" width="4" height="4"></td>
						<td width="492" height="4"><img src="img/inbox_top_blue.gif" width="492" height="4"></td>
						<td width="4" height="4"><img src="img/inbox_right_top_corner.gif" width="4" height="4"></td>
					  </tr>
					</table>
					<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
					  <tr>
					    <td width="4" background="img/inbox_left_blue.gif">&nbsp;</td>
						<td width="492">
						  <table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
						    <tr>
							  <td bgcolor="#7DACC5">&nbsp;&nbsp;UpLoad</td>
							</tr>
							<tr>
							  <td height="16" align="center">&nbsp;</td>
							</tr>
							<tr>
							  <td align="center">
							    <table width="450" border="0" cellpadding="0" cellspacing="0" class="arial11">
								  <tr>
								    <td  align="left">&nbsp; Upload [<%=FileName%>] 
                                    <br><br>
                                    &nbsp; Completed / Finalizado</td>
								  </tr>
                                  <!--
								  <tr>
								    <td align="left">&nbsp;</td>
								  </tr>
								  <tr>
								    <td align="left">&nbsp; Clique no botão FECHAR para sair ou simplesmente feche essa janela.</td>
								  </tr>
								  <tr>
								    <td align="left">&nbsp;</td>
								  </tr>
                                  //-->
								</table>
							  </td>
							</tr>
							<tr>
							  <td>&nbsp;</td>
							</tr>
						  </table>
						</td>
						<td width="4" background="img/inbox_right_blue.gif">&nbsp;</td>
					  </tr>
					</table>
					<table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
					  <tr>
					    <td width="4"   height="4" background="img/inbox_left_bottom_corner.gif">&nbsp;</td>
						<td height="4" width="235" background="img/inbox_bottom_blue.gif"><img src="img/blank.gif" alt="" border="0" width="1" height="32"></td>
						<td width="21"  height="26"><img src="img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
						<td align="right" background="img/inbox_bottom_big3.gif"><input type="button" value="OK" onClick="javascript:window.close();"><img src="img/t.gif" width="3" height="3"><br></td>
						<td width="4"   height="4"><img src="img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
					  </tr>
					</table>
				  </td>
				</tr>
			  </table>
			</body>
			</html>
<%
		End If
	End Select
%>