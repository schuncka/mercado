<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objRS, strSQL, objConn
Dim strCOD_FORMAPGTO, strIDAUTO_EVENTO

strCOD_FORMAPGTO = request("var_chavereg")
strIDAUTO_EVENTO = request("var_idauto_evento")

If strCOD_FORMAPGTO <> "" Then
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strSQL = " SELECT * FROM TBL_EVENTO_FORMAPGTO WHERE IDAUTO = " & strCOD_FORMAPGTO
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
                	<td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Formas de Pagamento</td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr> 
        		    <td align="center">
			 			<form name="formformapgto" action="../_database/athupdatetodb.asp" method="post">
							<input type="hidden" name="DEFAULT_TABLE" value="TBL_EVENTO_FORMAPGTO">
							<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
							<input type="hidden" name="FIELD_PREFIX" value="dbvar_">
							<input type="hidden" name="RECORD_KEY_NAME" value="IDAUTO">
							<input type="hidden" name="RECORD_KEY_VALUE" value="<%=objRS("IDAUTO")%>">
							<!--input type="hidden" name="DEFAULT_LOCATION" value="../evento/update.asp?var_chavereg=<%'=strIDAUTO_EVENTO%>"-->
							<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_evento/update_forma_pgto.asp?var_chavereg=<%=strCOD_FORMAPGTO%>">
							<input type="hidden" name="dbvar_num_cod_evento" value="<%=objRS("COD_EVENTO")%>">
			 			<table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">  
							<tr> 
				                <td colspan="2" align="center">
									<table border="0" cellpadding="0" cellspacing="0" width="90%">
										<tr>
											<td width="120" align="right" style="font-weight:bold;"> Forma Pgto.:&nbsp;</td>
											<td>
												<select name="dbvar_num_cod_formapgto" class="textbox250">
													<% MontaCombo "SELECT cod_formapgto, formapgto FROM tbl_formapgto ORDER BY formapgto", "cod_formapgto", "formapgto", objRS("COD_FORMAPGTO") %>
												</select>											</td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Exibir Loja:&nbsp;</td>
											<td><input type="radio" name="dbvar_bool_exibir_loja" value="1" <% If cstr(objRS("EXIBIR_LOJA")&"") = "1" Then %> checked<% End If %>>Sim &nbsp;&nbsp;<input type="radio" name="dbvar_bool_exibir_loja" value="0" <% If cstr(objRS("EXIBIR_LOJA")&"") = "0" Then %> checked<% End If %>>Não</td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Pais:&nbsp;</td>
											<td><input type="text" name="dbvar_str_cod_pais" class="textbox50" value="<%=objRS("COD_PAIS")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Id. Loja:&nbsp;</td>
											<td><input type="text" name="dbvar_str_id_loja" class="textbox110" value="<%=objRS("ID_LOJA")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Cedente:&nbsp;</td>
											<td><input type="text" name="dbvar_str_cedente" class="textbox250" value="<%=objRS("CEDENTE")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Carteira:&nbsp;</td>
											<td><input type="text" name="dbvar_str_carteira" class="textbox110" value="<%=objRS("CARTEIRA")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Agência:&nbsp;</td>
											<td><input type="text" name="dbvar_str_agencia" class="textbox100" value="<%=objRS("AGENCIA")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Conta:&nbsp;</td>
											<td><input type="text" name="dbvar_str_conta" class="textbox100" value="<%=objRS("CONTA")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Gerente:&nbsp;</td>
											<td><input type="text" name="dbvar_str_gerente" class="textbox250" value="<%=objRS("GERENTE")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">CNPJ:&nbsp;</td>
											<td><input type="text" name="dbvar_str_cnpj" class="textbox250" value="<%=objRS("CNPJ")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Razão Social:&nbsp;</td>
											<td><input type="text" name="dbvar_str_razao_social" class="textbox250" value="<%=objRS("RAZAO_SOCIAL")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Parcelas:&nbsp;</td>
											<td><input type="text" name="dbvar_num_parcelas" class="textbox50" value="<%=objRS("PARCELAS")%>"></td>
										</tr>
                                        <tr>
											<td width="120" align="right" style="font-weight:bold;">Parc Valor Minimo:&nbsp;</td>
											<td><input type="text" name="dbvar_num_parcela_vlr_minimo" class="textbox50" value="<%=objRS("PARCELA_VLR_MINIMO")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Instruções:&nbsp;</td>
											<td><textarea name="dbvar_str_instrucoes" rows="4" cols="50" class="arial11"><%=objRS("INSTRUCOES")%></textarea></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Valor Min.:&nbsp;</td>
											<td><input type="text" name="dbvar_moeda_valor_min" class="textbox50" value="<%=objRS("VALOR_MIN")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Valor Max.:&nbsp;</td>
											<td><input type="text" name="dbvar_moeda_valor_max" class="textbox50" value="<%=objRS("VALOR_MAX")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Contrato:&nbsp;</td>
											<td><input type="text" name="dbvar_str_cod_contrato" class="textbox100" value="<%=objRS("COD_CONTRATO")%>"></td>
										</tr>
										<tr>
										  <td align="right" style="font-weight:bold;">Número Dias Vencto:&nbsp;</td>
										  <td><input type="text" name="dbvar_num_num_dias_vcto" class="textbox100" value="<%=objRS("NUM_DIAS_VCTO")%>"></td>
									  </tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Dt. Limite Vencto:&nbsp;</td>
											<td><input type="text" name="dbvar_date_dt_limite_vcto" class="textbox100" value="<%=objRS("DT_LIMITE_VCTO")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Dv. Agência:&nbsp;</td>
											<td><input type="text" name="dbvar_str_dv_agencia" class="textbox70" value="<%=objRS("DV_AGENCIA")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Dv. Conta:&nbsp;</td>
											<td><input type="text" name="dbvar_str_dv_conta" class="textbox70" value="<%=objRS("DV_CONTA")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Assinatura:&nbsp;</td>
											<td><textarea name="dbvar_str_assinatura" rows="4" cols="50" class="arial11"><%=objRS("ASSINATURA")%></textarea></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Moeda Cob.:&nbsp;</td>
											<td>
												<select name="dbvar_num_cod_moeda_cobranca" class="arial11">
													<option value="">Selecione...</option>
													<% MontaCombo "SELECT COD_MOEDA, MOEDA FROM TBL_MOEDA ORDER BY MOEDA", "COD_MOEDA", "MOEDA", objRS("COD_MOEDA_COBRANCA")&""%>
												</select>											</td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Ariel Assunto:&nbsp;</td>
											<td><input type="text" name="dbvar_str_ariel_assunto" class="textbox250" value="<%=objRS("ARIEL_ASSUNTO")%>"></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Ariel:&nbsp;</td>
											<td><textarea name="dbvar_str_ariel" rows="4" cols="50" class="arial11"><%=objRS("ARIEL")%></textarea></td>
										</tr>
										<tr>
											<td width="120" align="right" style="font-weight:bold;">Valor Taxa:&nbsp;</td>
											<td><input type="text" name="dbvar_moeda_valor_taxa" class="textbox70" value="<%=objRS("VALOR_TAXA")%>"></td>
										</tr>
                                        <tr>
                                          <td align="right" style="font-weight:bold;">Tipo Loja:&nbsp;</td>
                                          <td>
                                          <select name="dbvar_str_tipo" class="textbox250">
                                          <option value="" selected>Padrão (Loja PF e PJ)</option>
                                          <option value="PF" <% If objRS("TIPO")&"" = "PF" Then Response.Write("selected") End If %>>PF (Loja Pessoa Física)</option>
                                          <option value="PJ" <% If objRS("TIPO")&"" = "PJ" Then Response.Write("selected") End If %>>PJ (Loja Pessoa Jurídica)</option>
                                          <option value="CX" <% If objRS("TIPO")&"" = "CX" Then Response.Write("selected") End If %>>CX (AR CAEX)</option>
                                          </select>
                                          </td>
                                        </tr>
                                        <tr>
											<td width="120" align="right" style="font-weight:bold;">Captura Automática:&nbsp;</td>
											<td><input type="radio" name="dbvar_bool_captura" value="1" <% If cstr(objRS("CAPTURA")&"") = "1" Then %> checked<% End If %>>Sim &nbsp;&nbsp;<input type="radio" name="dbvar_bool_captura" value="0" <% If cstr(objRS("CAPTURA")&"") = "0" Then %> checked<% End If %>>Não</td>
										</tr>
                                        <tr>
											<td width="120" align="right" style="font-weight:bold;">Permite Finalizar Pagamento:&nbsp;</td>
											<td><input type="radio" name="dbvar_bool_controle_finalizar_compra" value="1" <% If cstr(objRS("controle_finalizar_compra")&"") = "1" Then %> checked<% End If %>>Sim &nbsp;&nbsp;<input type="radio" name="dbvar_bool_controle_finalizar_compra" value="0" <% If cstr(objRS("controle_finalizar_compra")&"") = "0" Then %> checked<% End If %>>Não</td>
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