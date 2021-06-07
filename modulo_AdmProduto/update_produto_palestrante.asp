<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim objRS, strSQL, objConn
Dim strCOD_PROD, strIDAUTO

strCOD_PROD = request("var_cod_prod")
strIDAUTO   = request("var_chavereg")

If strCOD_PROD <> "" And strIDAUTO <> "" Then
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strSQL = " SELECT PP.*, P.DT_OCORRENCIA FROM TBL_PRODUTOS_PALESTRANTE PP INNER JOIN TBL_PRODUTOS P ON PP.COD_PROD = P.COD_PROD WHERE PP.IDAUTO = " & strIDAUTO
	Set objRS = objConn.execute(strSQL)
	
%>
<html>
<head>
	<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../_css/csm.css" rel="stylesheet" type="text/css">
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
                	
          <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Palestrantes - Produto - 
            Edi&ccedil;&atilde;o </td>
	  	        </tr>
         		<tr> 
		            <td height="16" align="center">&nbsp;</td>
	            </tr>
  		        <tr> 
        		    <td align="center">
			 			<form name="formproduto" action="InsUpdProdPalestranteExec.asp" method="post">
                            <input type="hidden" name="VAR_IDAUTO" value="<%=objRS("IDAUTO")%>">
                            <input type="hidden" name="var_cod_prod" value="<%=objRS("COD_PROD")%>">
                            <input type="hidden" name="var_cod_palestrante" value="<%=objRS("COD_PALESTRANTE")%>">
                            <input type="hidden" name="var_dt_ocorrencia" value="<%=PrepData(objRS("DT_OCORRENCIA"),True,False)%>">
							<input type="hidden" name="DEFAULT_TABLE" value="TBL_PRODUTOS_PALESTRANTE">
							<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
							<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
							<input type="hidden" name="RECORD_KEY_NAME" value="IDAUTO">
							<input type="hidden" name="RECORD_KEY_VALUE" value="<%=objRS("IDAUTO")%>">
<!--							<input type="hidden" name="DEFAULT_LOCATION" value="../adm_produto/update.asp?var_chavereg=<%=strCOD_PROD%>"> -->
							<input type="hidden" name="DEFAULT_LOCATION" value="javascript:window.opener.location.reload();window.close();">
			 			<table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">  
							<tr> 
				                
                  <td colspan="2" align="center">
				    <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr> 
                        <td width="100" align="right">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="right">Função:&nbsp;</td>
                        <td> <input name="VAR_FUNCAO" type="text" class="textbox380" maxlength="50" value="<%=objRS("FUNCAO")%>"> 
                        </td>
                      </tr>
                      <tr> 
                        <td align="right">Tema:&nbsp;</td>
                        <td> <textarea name="VAR_TEMA" rows="6" class="textbox380"><%=objRS("TEMA")%></textarea> 
                        </td>
                      </tr>
                      <tr> 
                        <td align="right">Material:&nbsp;</td>
                        <td> <textarea name="VAR_material" rows="6" class="textbox380"><%=objRS("MATERIAL")%></textarea> 
                        </td>
                      </tr>
                      <tr> 
                        <td align="right">Hora Início:&nbsp;</td>
                        <td> <input name="VAR_HORA_INI" type="text" class="textbox70" maxlength="5" value="<% If IsDate(objRS("HORA_INI")) Then Response.Write( Right("0"&Hour(objRS("HORA_INI")),2) & ":" & Right("0"&Minute(objRS("HORA_INI")),2) ) End If %>">
                          (formato: HH:MM)</td>
                      </tr>
                      <tr> 
                        <td align="right">Hora Término:&nbsp;</td>
                        <td> <input name="VAR_HORA_FIM" type="text" class="textbox70" maxlength="5" value="<% If IsDate(objRS("HORA_FIM")) Then Response.Write( Right("0"&Hour(objRS("HORA_FIM")),2) & ":" & Right("0"&Minute(objRS("HORA_FIM")),2) ) End If %>">
                          (formato: HH:MM)</td>
                      </tr>
                      <tr> 
                        <td align="right">Confirmado:&nbsp;</td>
                        <td>
                        <select name="VAR_CONFIRMADO" class="textbox100">
                          <option value="" <% If objRS("CONFIRMADO")&""="" Then Response.Write("selected") End If %>>Indefinido</option>
                          <option value="1" <% If objRS("CONFIRMADO")=1 Then Response.Write("selected") End If %>>Sim</option>
                          <option value="0" <% If objRS("CONFIRMADO")=0 Then Response.Write("selected") End If %>>Não</option>
                        </select>
						</td>
                      </tr>
                      <tr> 
                        <td align="right">Ordem:&nbsp;</td>
                        <td> <input name="VAR_ORDEM" type="text" class="textbox70" maxlength="5" value="<%=objRS("ORDEM")%>"> </td>
                      </tr>
                      <tr>
                        <td align="right">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                    </table></td>
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