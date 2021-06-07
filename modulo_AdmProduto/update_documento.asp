<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objRS, strSQL, objConn
Dim strCOD_FORMAPGTO, strID_DOCUMENTO

strID_DOCUMENTO = request("var_chavereg")

If strID_DOCUMENTO <> "" Then
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strSQL = " SELECT * FROM tbl_documentos WHERE id_documento = " & strID_DOCUMENTO
	Set objRS = objConn.execute(strSQL)
	
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
	</script>
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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
                	<td bgcolor="#7DACC5">&nbsp;&nbsp;Edição de documento</td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr> 
        		    <td align="center">
			 			<form name="formformapgto" action="../_database/athupdatetodb.asp" method="post">
							<input type="hidden" name="DEFAULT_TABLE" value="tbl_documentos">
							<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
							<input type="hidden" name="FIELD_PREFIX" value="dbvar_">
							<input type="hidden" name="RECORD_KEY_NAME" value="id_documento">
							<input type="hidden" name="RECORD_KEY_VALUE" value="<%=objRS("id_documento")%>">
							<input type="hidden" name="DEFAULT_LOCATION" value="javascript:window.opener.document.location.reload(); window.close();">
							<input type="hidden" name="dbvar_num_cod_evento" value="<%=objRS("COD_EVENTO")%>">
                            <input type="hidden" name="dbvar_num_cod_prod" value="<%=objRS("COD_PROD")%>">
			 			<table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">  
							<tr> 
				                <td colspan="2" align="center">
									<table border="0" cellpadding="0" cellspacing="0" width="90%">
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Documento:&nbsp;</td>
											<td>
												<input type="text" name="dbvar_str_documento" value="<%=objRS("documento")%>" class="textbox250">
												<a href="javascript:UploadImage('form_documentos','dbvar_str_documento','\\modulo_admproduto\\docs\\');">
													<img src="../IMG/bt_upload.gif" width="78" height="17" hspace="5" border="0" align="absmiddle">
												</a>
											</td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Rotulo:&nbsp;</td>
											<td><input type="text" name="dbvar_str_rotulo" class="textbox250" value="<%=objRS("rotulo")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">URL:&nbsp;</td>
											<td><input type="text" name="dbvar_str_url" class="textbox250" value="<%=objRS("url")%>"></td>
										</tr>
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
<table width="550" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:document.formformapgto.submit();"><img src="../img/bt_SAVE.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
</table>
</body>
</html>
<%
	FechaRecordSet(objRS)
	FechaDBConn(objConn)
End If
%>