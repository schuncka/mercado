<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"-->
<%
    VerficaAcesso("ADMIN")

	Dim strSQL, objRS, ObjConn
	Dim strCODATIV
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strCODATIV = Replace(Request("var_chavereg"),"'","''")

	strSQL = "SELECT CODATIV, ATIVIDADE, ATIVMINI, ATIVMINI_INTL, ATIVMINI_SP, TTO_M, TTO_F, LOJA_SHOW, TIPOPESS, CODATIV_PAI " &_
	         "  FROM tbl_ATIVIDADE " &_
			 " WHERE CODATIV = '" & strCODATIV & "'"
	
	set objRS = objConn.Execute(strSQL)
%>

<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<form name="formupdate" action="updateexec.asp" method="POST">
   <input type="hidden" name="var_codigo" value="<%=objRS("CODATIV")%>">
<tr> 
<td align="center" valign="middle">
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
                  <td bgcolor="#7DACC5">&nbsp;&nbsp;Alteração de Atividades</td>
          </tr>
          <tr> 
            <td height="18" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			  <table width="480" border="0" cellpadding="0" cellspacing="0" class="arial11">
			     <tr>
					<td align="right">* Atividade Pai:&nbsp;</td>
					<td>
					  <select name="var_codativ_pai" class="textbox380">
					  <option value="" <% If objRS("CODATIV_PAI")&"" = "" Then Response.Write("selected") End If %>>ATIVIDADE PAI</option>
					  <%
						strSQL = "SELECT CODATIV, ATIVIDADE, ATIVMINI " & _
								 "  FROM tbl_ATIVIDADE " & _
								 " WHERE CODATIV_PAI IS NULL" & _
								 "  ORDER BY ATIVIDADE"
					MontaCombo strSQL, "CODATIV", "ATIVIDADE",objRS("CODATIV_PAI")&""
					%>
					  </select>
					</td>
				  </tr>
                 <tr> 
                   <td width="100" align="right">*C&oacute;digo:&nbsp;</td>
                   <td width="350"><%=OBJrs("CODATIV")%></td>
                 </tr>
                 <tr> 
                        <td width="100" align="right">*Descrição:&nbsp;</td>
                   <td width="350"><input name="var_descricao" type="text" class="textbox380" value="<%=OBJrs("ATIVIDADE")%>"></td>
                 </tr>
                 <tr> 
                        <td width="100" align="right">*S&iacute;ntese:&nbsp;</td>
                   <td width="350" align="left"><input name="var_sintese" type="text" class="textbox180" value="<%=OBJrs("ATIVMINI")%>"></td>
                 </tr>
				 <tr> 
                        <td width="100" align="right">S&iacute;ntese Ingl&ecirc;s:&nbsp;</td>
                        <td width="350" align="left"><input name="var_sintese_intl" type="text" class="textbox180" value="<%=OBJrs("ATIVMINI_INTL")%>"></td>
                 </tr>
				 <tr> 
                        <td width="100" align="right">S&iacute;ntese Espanhol:&nbsp;</td>
                        <td width="350" align="left"><input name="var_sintese_sp" type="text" class="textbox180" value="<%=OBJrs("ATIVMINI_SP")%>"></td>
                 </tr>
                 <tr> 
                        <td width="100" align="right">Tratamento Masc.:&nbsp;</td>
                   <td width="350" align="left"><input name="var_tto_m" type="text" class="textbox180" value="<%=OBJrs("TTO_M")%>"></td>
                 </tr>
                 <tr> 
                        <td width="100" align="right">Tratamento Fem.:&nbsp;</td>
                   <td width="350" align="left"><input name="var_tto_f" type="text" class="textbox180" value="<%=OBJrs("TTO_F")%>"></td>
                 </tr>
                 <tr> 
                   <td width="100" align="right">Tipo Pessoa:&nbsp;</td>
                   <td width="350" align="left">
				          <select name="var_tipopess" class="textbox180">
				            <option value="A" <% If objRS("TIPOPESS")&"" = "A" Then Response.Write(" selected") %>>Ambos</option>
				            <option value="F" <% If objRS("TIPOPESS")&"" = "F" Then Response.Write(" selected") %>>Física</option>
				            <option value="J" <% If objRS("TIPOPESS")&"" = "J" Then Response.Write(" selected") %>>Jurídica</option>
                          </select> </td>
                 </tr>
                 <tr> 
                   <td width="100" align="right" valign="top">Exibir na Loja:&nbsp;</td>
                   <td width="350" align="left">
                          <%
						 Dim strSIM, strNAO
					     If objRS("LOJA_SHOW") = 1 Then
						   strSIM = " checked"
						   strNAO = ""
						 Else
						   strSIM = ""
						   strNAO = " checked"
						 End If
						%>
						<input type="radio" name="var_loja_show" value="1"<%=strSIM%>> Sim &nbsp;&nbsp;
						<input type="radio" name="var_loja_show" value="0"<%=strNAO%>> Não &nbsp;&nbsp;						
				   </td>
                 </tr>
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
      <td width="4"     height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td width="235"   height="4" background="../img/inbox_bottom_blue.gif"><img src="img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"    height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:formupdate.submit();"><img src="../img/bt_save.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"     height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
</tr></td>
</form>
</table>
</body>
</html>
<%
  FechaRecordSet ObjRS
  FechaDBConn ObjConn
%>