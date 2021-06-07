<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objRS, strSQL, objConn
Dim strCHAVEREG, strCOD_STATUS_CRED

strCHAVEREG = request("var_chavereg")

If strCHAVEREG <> "" Then
	
	AbreDBConn objConn, CFG_DB_DADOS

	strSQL = " SELECT * " &_
			 " FROM tbl_fin_rps_evento " &_
			 " WHERE COD_RPS_EVENTO = " & strCHAVEREG &_
			 " ORDER BY 1 " 

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
                	<td bgcolor="#7DACC5">&nbsp;&nbsp;Edição RPS/NFE</td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr> 
        		    <td align="center">
			 			<form name="formformapgto" action="../_database/athupdatetodb.asp" method="post">
							<input type="hidden" name="DEFAULT_TABLE" value="tbl_fin_rps_evento">
							<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
							<input type="hidden" name="FIELD_PREFIX" value="dbvar_">
							<input type="hidden" name="RECORD_KEY_NAME" value="COD_RPS_EVENTO">
							<input type="hidden" name="RECORD_KEY_VALUE" value="<%=objRS("COD_RPS_EVENTO")%>">
							<!--input type="hidden" name="DEFAULT_LOCATION" value="../evento/update.asp?var_chavereg=<%'=strCOD_STATUS_CRED%>"-->
							<input type="hidden" name="DEFAULT_LOCATION" value="javascript:window.opener.location.reload();window.close();">
			 			<table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">  
							<tr> 
				                <td colspan="2" align="center">
									<table border="0" cellpadding="0" cellspacing="0" width="90%">
										<tr>
											<td width="120" align="right" style="font-weight:bold;"> Cod. RPS/NFE.:&nbsp;</td>
											<td> <% Response.Write objRS("COD_RPS_EVENTO")%> </td>
										</tr>
										<tr>
										  <td align="right" style="font-weight:bold;">Município:&nbsp;</td>
										  <td>
                                          <select name='dbvar_str_municipio' class='textbox180'>
                                          <option value='' <% If objRS("MUNICIPIO") = "" Then Response.Write("selected") End If %>>Selecione...</option>
                                          <option value='CURITIBA'<% If objRS("MUNICIPIO") = "CURITIBA" Then Response.Write("selected") End If %>>Curitiba</option>
                                          <option value='SAO PAULO' <% If objRS("MUNICIPIO") = "SAO PAULO" Then Response.Write("selected") End If %>>São Paulo</option>
                                          </select>
                                          </td>
									  </tr>
										<tr>
										  <td align="right" style="font-weight:bold;">CNPJ:&nbsp;</td>
										  <td><input type="text" name="dbvar_str_cnpj" class="textbox180" value="<%=objRS("CNPJ")%>"></td>
									  </tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Inscrição Municipal:&nbsp;</td>
											<td><input type="text" name="dbvar_str_inscr_municipal" class="textbox180" value="<%=objRS("INSCR_MUNICIPAL")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Código Serviço:&nbsp;</td>
											<td><input type="text" name="dbvar_str_cod_servico" class="textbox70" value="<%=objRS("COD_SERVICO")%>" maxlength="5"> Ex: 00000</td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Alíquota:&nbsp;</td>
											<td><input type="text" name="dbvar_str_aliquota" class="textbox70" value="<%=objRS("ALIQUOTA")%>" maxlength="4"> Ex: 5,00%  (SP preencher <b>0500</b>, PR preencher <b>0.05</b>)</td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Instrução:&nbsp;</td>
											<td><input type="text" name="dbvar_str_instrucao" class="textbox250" value="<%=objRS("INSTRUCAO")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Isento:</td>
											<td>
											<input type='radio' name='dbvar_str_isento' <%If objRS("ISENTO") = 1 Then %> checked="checked" <%  End If %> value='1'>Sim &nbsp; &nbsp; &nbsp;
											<input type='radio' name='dbvar_str_isento' <%If objRS("ISENTO") = 0 Then %> checked="checked" <%  End If %> value='0'>Não
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