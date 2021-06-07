<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objRS, objRSDetail, strSQL, objConn
Dim strCOD_PROD, strID_AUTO

strCOD_PROD = request("var_cod_prod")
strID_AUTO   = request("var_chavereg")

If strCOD_PROD <> "" And strID_AUTO <> "" Then
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strSQL = " SELECT * FROM tbl_produtos_combo WHERE ID_AUTO = " & strID_AUTO
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
                	
          <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Combos - Produto - 
            Edi&ccedil;&atilde;o </td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr> 
        		    <td align="center">
			 			<form name="formproduto" action="../_database/athupdatetodb.asp" method="post">
							<input type="hidden" name="DEFAULT_TABLE" value="tbl_produtos_combo">
							<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
							<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
							<input type="hidden" name="RECORD_KEY_NAME" value="ID_AUTO">
							<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strID_AUTO%>">
<!--							<input type="hidden" name="DEFAULT_LOCATION" value="../adm_produto/update.asp?var_chavereg=<%=strCOD_PROD%>"> -->
							<input type="hidden" name="DEFAULT_LOCATION" value="javascript:window.opener.location.reload();window.close();">
			 			<table width="95%" border="0" cellpadding="1" cellspacing="0" class="arial11">  
							  <tr> 
                              <tr>
                                <td align="right">Produto:&nbsp;</td>
                                <td>
								  <strong>
								  <%
								strSQL = "SELECT TITULO FROM TBL_PRODUTOS WHERE COD_PROD = " & strCOD_PROD
								Set objRSDetail = objConn.Execute(strSQL)
								If not objRSDetail.EOF Then
								  Response.Write(objRSDetail("TITULO"))
								End If
								FechaRecordSet objRSDetail
								%>
							    </strong></td>
                              </tr>
                          <tr>
                          <td align="right">Produto Relacionado:&nbsp;</td>
                          <td><select name="dbvar_str_cod_prod_relacao" class="textbox180">
                              <%
							strSQL = " SELECT COD_PROD, TITULO FROM tbl_PRODUTOS WHERE COD_PROD <> " & strCOD_PROD & " AND COD_EVENTO = " & Session("COD_EVENTO")
							MontaCombo strSQL, "COD_PROD", "TITULO", objRS("COD_PROD_RELACAO")&""
							  %>
                          </select></td>
                        </tr>
							  <tr> 
								<td align="right">Status de Compra:&nbsp;</td>
								<td>
								<select name="DBVAR_NUM_COD_STATUS_PRECOô" class="textbox180">
								<%
								strSQL = " SELECT COD_STATUS_PRECO, STATUS FROM tbl_STATUS_PRECO WHERE COD_EVENTO = " & Session("COD_EVENTO")
								MontaCombo strSQL, "COD_STATUS_PRECO", "STATUS", objRS("COD_STATUS_PRECO")&""
								%>
								</select>						</td>
							  </tr>
						<tr>
                          <td align="right">Desconto Perc.:&nbsp;</td>
                          <td><input type="text" name="DBVAR_FLOAT_DESCONTO_PERC" class="arial11" value="<% If not isNull(objRS("desconto_perc")) Then Response.Write(FormatNumber(objRS("desconto_perc"))) End If %>"></td>
						</tr>
						<tr>
                          <td align="right">Desconto Valor:&nbsp;</td>
                          <td><input type="text" name="DBVAR_FLOAT_DESCONTO_VLR" class="arial11" value="<% If not isNull(objRS("desconto_vlr")) Then Response.Write(FormatNumber(objRS("desconto_vlr"))) End If %>"></td>
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