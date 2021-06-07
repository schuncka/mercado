<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<%
	Dim strSQL, objRS, ObjConn
	Dim strCODATIV
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strCODATIV = Replace(Request("var_chavereg"),"'","''")
	
	strSQL = "SELECT A1.CODATIV, A1.ATIVIDADE, A1.ATIVMINI, A1.ATIVMINI_INTL, A1.ATIVMINI_SP, A1.TTO_M, A1.TTO_F, A1.LOJA_SHOW, A1.TIPOPESS, A1.CODATIV_PAI, A2.ATIVIDADE AS ATIVIDADE_PAI " & _
	         "  FROM tbl_ATIVIDADE A1 LEFT OUTER JOIN tbl_ATIVIDADE A2 ON (A1.CODATIV_PAI = A2.CODATIV)" & _
			 " WHERE A1.CODATIV = '" & strCODATIV & "'"

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
<form name="formdetail" action="update.asp" method="POST">
   <input type="hidden" name="var_chavereg" value="<%=objRS("CODATIV")%>">
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
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Detalhes de Atividades</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="480" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr>
                        <td width="125" align="right">*Atividade Pai:&nbsp;</td>
                        <td><%
						 If ObjRS("ATIVIDADE_PAI")&"" = "" Then
						   Response.Write("ATIVIDADE PAI")
						 Else
						   Response.Write(UCase(ObjRS("CODATIV_PAI") & " - " & ObjRS("ATIVIDADE_PAI")))
						 End If
						%></td>
                      </tr>
                      <tr> 
                   <td align="right">*C&oacute;digo:&nbsp;</td>
                   <td><%=ObjRS("CODATIV")%></td>
                 </tr>
                 <tr> 
                   <td align="right">*Descrição:&nbsp;</td>
                   <td><%=ObjRS("ATIVIDADE")%></td>
                 </tr>
                 <tr> 
                   <td align="right" valign="top">*S&iacute;ntese:&nbsp;</td>
                   <td align="left"><%=ObjRS("ATIVMINI")%></td>
                 </tr>
				 <tr> 
                   <td align="right" valign="top">*S&iacute;ntese Inglês:&nbsp;</td>
                   <td align="left"><%=ObjRS("ATIVMINI_INTL")%></td>
                 </tr>
				 <tr> 
                   <td align="right" valign="top">*S&iacute;ntese Espanhol:&nbsp;</td>
                   <td align="left"><%=ObjRS("ATIVMINI_SP")%></td>
                 </tr>
                 <tr> 
                   <td align="right" valign="top">Tratamento Masculino:&nbsp;</td>
                   <td align="left"><%=ObjRS("TTO_M")%></td>
                 </tr>
                 <tr> 
                   <td align="right" valign="top">Tratamento Feminino:&nbsp;</td>
                   <td align="left"><%=ObjRS("TTO_F")%></td>
                 </tr>
                 <tr> 
                   <td align="right" valign="top">Tipo Pessoa:&nbsp;</td>
                   <td align="left">
				   <%
				    Select Case ObjRS("TIPOPESS")&""
					  Case "F"
					    Response.Write("Física")
					  Case "J"
					    Response.Write("Jurídica")
					  Case "A"
					    Response.Write("Ambos")
				      Case Else
					    Response.Write("Não definido")
				    End Select
				   %>				   </td>
                 </tr>
                    <tr> 
                      <td align="right" valign="top">Exibir na Loja:&nbsp;</td>
                      <td align="left"><%
					   If objRS("LOJA_SHOW") Then
					     Response.Write("Sim")
					   Else
					     Response.Write("Não")
					   End If
					   %></td>
                    </tr>
              </table></td>
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
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:formdetail.submit();"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
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