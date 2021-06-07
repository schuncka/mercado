<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objRS, strSQL, objConn
Dim strCOD_PROD, strCOD_PRLISTA

strCOD_PROD = request("var_cod_prod")
strCOD_PRLISTA   = request("var_chavereg")

If strCOD_PROD <> "" And strCOD_PRLISTA <> "" Then
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strSQL = " SELECT * FROM tbl_PrcLista WHERE COD_PRLISTA = " & strCOD_PRLISTA
	Set objRS = objConn.execute(strSQL)
	
%>
<html>
<head>
	<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../_css/csm.css" rel="stylesheet" type="text/css">
<!-- jQuery -->
<script type="text/javascript" src="../_scripts/jquery-1.2.1.min.js"></script>

<!-- required plugins -->
<script type="text/javascript" src="../_scripts/date.js"></script>

<!-- jquery.datePicker.js -->
<script type="text/javascript" src="../_scripts/jquery.datePicker.js"></script>
<!-- datePicker required styles -->

<!-- page specific scripts -->
<script type="text/javascript" charset="utf-8">
            $(
			function()
            {
				$('.date-pick').datePicker();
            }
			);
</script>
<link rel="stylesheet" type="text/css" media="screen" href="../_css/datePicker.css">
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br>
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
                	
          <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Pre&ccedil;os - Produto - 
            Edi&ccedil;&atilde;o </td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr> 
        		    <td align="center">
			 			<form name="formproduto" action="../_database/athupdatetodb.asp" method="post">
							<input type="hidden" name="DEFAULT_TABLE" value="tbl_PrcLista">
							<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
							<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
							<input type="hidden" name="RECORD_KEY_NAME" value="COD_PRLISTA">
							<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_PRLISTA%>">
                            <input type="hidden" name="DBVAR_STR_SYS_USERAT" value="<%=SESSION("METRO_USER_ID_USER")%>">
							<input type="hidden" name="DBVAR_AUTODATE_SYS_DATAAT" value="">                            
<!--							<input type="hidden" name="DEFAULT_LOCATION" value="../adm_produto/update.asp?var_chavereg=<%=strCOD_PROD%>"> -->
							<input type="hidden" name="DEFAULT_LOCATION" value="javascript:window.opener.location.reload();window.close();">
			 			<table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">  
							  <tr> 
								<td width="100" align="right"><label for="date1">*Data de Vig&ecirc;ncia:</label>&nbsp;</td>
								<td width="125">
		<input name="DBVAR_DATE_DT_VIGENCIA_INICô" type="text" size="10" maxlength="10" value="<%=PrepData(objRS("DT_VIGENCIA_INIC"),True,False)%>" id="date1" class="date-pick"></td>
								<td width="15">a</td>
							    <td><input name="DBVAR_DATE_DT_VIGENCIA_FIM&ocirc;" type="text" size="10" maxlength="10" value="<%=PrepData(objRS("DT_VIGENCIA_FIM"),True,False)%>" id="DBVAR_DATE_DT_VIGENCIA_FIM&ocirc;" class="date-pick"></td>
							  </tr>
							  <tr> 
								<td align="right">*Pre&ccedil;o Lista:&nbsp;</td>
								<td colspan="3"><input name="DBVAR_FLOAT_PRC_LISTAô" type="text" class="textbox100" size="10" maxlength="10" value="<%								If not IsNull(objRS("PRC_LISTA")) Then Response.Write(FormatNumber(objRS("PRC_LISTA"))) End If %>"></td>
							  </tr>
							  <tr>
								<td align="right">Quant. In&iacute;cio:&nbsp;</td>
								<td colspan="3"><input name="DBVAR_NUM_QTDE_INICô" type="text" class="textbox100" size="10" maxlength="10" value="<%=objRS("QTDE_INIC")%>"></td>
							  </tr>
							  <tr>
								<td align="right">Quant. Fim:&nbsp;</td>
								<td colspan="3"><input name="DBVAR_NUM_QTDE_FIMô" type="text" class="textbox100" size="10" maxlength="10" value="<%=objRS("QTDE_FIM")%>"></td>
							  </tr>
							  <tr> 
								<td align="right">Status de Compra:&nbsp;</td>
								<td colspan="3">
								<select name="DBVAR_NUM_COD_STATUS_PRECOô" class="textbox180">
								<%
								strSQL = " SELECT COD_STATUS_PRECO, STATUS FROM tbl_STATUS_PRECO WHERE COD_EVENTO = " & Session("COD_EVENTO")
								MontaCombo strSQL, "COD_STATUS_PRECO", "STATUS", objRS("COD_STATUS_PRECO")&""
								%>
								</select>						</td>
							  </tr>
                              <tr>
								<td align="right">Capacidade:&nbsp;</td>
								<td colspan="3">
                                <%
								If Session("USER_OCULTO") = 1 Then
								%>
                                <input name="DBVAR_NUM_CAPACIDADEô" type="text" class="textbox100" size="10" maxlength="10" value="<%=objRS("CAPACIDADE")%>">
                                <%
								Else
								  Response.Write(objRS("CAPACIDADE"))
								End If
								%>
                                </td>
							  </tr>
                              <tr>
                              	<td>Última Alteração:</td>
                                <td><%=objRS("SYS_DATAAT")%></td>
                              </tr>
                              <tr>
                              	<td>Usuário:</td>
                                <td><%=objRS("SYS_USERAT")%></td>
                              </tr>
						  </table>
						<br>
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
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:document.formproduto.submit();"><img src="../img/bt_SAVE.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
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