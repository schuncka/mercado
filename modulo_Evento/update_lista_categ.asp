<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objRS, strSQL, objConn
Dim strCHAVEREG, strCOD_STATUS_PRECO

strCHAVEREG = request("var_chavereg")
strCOD_STATUS_PRECO = request("var_cod_status_cred")

If strCHAVEREG <> "" Then
	
	AbreDBConn objConn, CFG_DB_DADOS

	strSQL = " SELECT EI.COD_STATUS_PRECO, EI.STATUS, EI.OBSERVACAO, EI.SENHA, EI.LOJA_SHOW,EI.ENTIDADE_OBRIGATORIO " &_
			 " FROM tbl_STATUS_PRECO AS EI " &_			 
			 " WHERE  EI.COD_STATUS_PRECO = " & strCOD_STATUS_PRECO &_			 
			 " ORDER BY EI.STATUS, EI.COD_STATUS_PRECO " 			  

	Set objRS = objConn.execute(strSQL)
	
%>
<html>
<head>
	<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../_css/csm.css" rel="stylesheet" type="text/css">
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
                	<td bgcolor="#7DACC5">&nbsp;&nbsp;Edição Status Credencial</td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr> 
        		    <td align="center">
			 			<form name="formformapgto" action="../_database/athupdatetodb.asp" method="post">
							<input type="hidden" name="DEFAULT_TABLE" value="tbl_STATUS_PRECO">
							<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
							<input type="hidden" name="FIELD_PREFIX" value="dbvar_">
							<input type="hidden" name="RECORD_KEY_NAME" value="COD_STATUS_PRECO">
							<input type="hidden" name="RECORD_KEY_VALUE" value="<%=objRS("COD_STATUS_PRECO")%>">
							<!--input type="hidden" name="DEFAULT_LOCATION" value="../evento/update.asp?var_chavereg=<%'=strCOD_STATUS_PRECO%>"-->
							<input type="hidden" name="DEFAULT_LOCATION" value="javascript:window.opener.location.reload();window.close();">
			 			<table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">  
							<tr> 
				                <td colspan="2" align="center">
									<table border="0" cellpadding="0" cellspacing="0" width="90%">
										<tr>
											<td width="120" align="right" style="font-weight:bold;"> Cod:&nbsp;</td>
											<td> <% Response.Write objRS("COD_STATUS_PRECO")%> </td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Status:&nbsp;</td>
											<td><input type="text" name="dbvar_str_STATUS" class="textbox250" value="<%=objRS("STATUS")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Senha:&nbsp;</td>
											<td><input type="text" name="dbvar_str_SENHA" class="textbox250" value="<%=objRS("SENHA")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Observação:&nbsp;</td>
											<td><input type="text" name="dbvar_str_OBSERVACAO" class="textbox250" value="<%=objRS("OBSERVACAO")%>"></td>
										</tr>								

										<tr>
											<td width="120" align="right" style="font-weight:bold;">Mostrar Loja:</td>
											<td>
											<input type='radio' name='dbvar_str_LOJA_SHOW' <%If objRS("LOJA_SHOW") = 1 Then %> checked="checked" <%  End If %> value='1'>Sim &nbsp; &nbsp; &nbsp;
											<input type='radio' name='dbvar_str_LOJA_SHOW' <%If objRS("LOJA_SHOW") = 0 Then %> checked="checked" <%  End If %> value='0'>Não
											</td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Entidade Obrigatória:</td>
											<td>
											<input type='radio' name='dbvar_str_ENTIDADE_OBRIGATORIO' <%If objRS("ENTIDADE_OBRIGATORIO") = 1 Then %> checked="checked" <%  End If %> value='1'>Sim &nbsp; &nbsp; &nbsp;
											<input type='radio' name='dbvar_str_ENTIDADE_OBRIGATORIO' <%If objRS("ENTIDADE_OBRIGATORIO") = 0 Then %> checked="checked" <%  End If %> value='0'>Não
											</td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">&nbsp;</td>
											<td>&nbsp;</td>
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