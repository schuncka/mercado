<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim strCOD_LOTE
strCOD_LOTE = Request("var_chavereg")

Dim strCOD_EVENTO, strEV_NOME, strEV_EMAIL_SENDER
strCOD_EVENTO = Session("COD_EVENTO")

Dim objConn, objRS, strSQL
AbreDBConn objConn, CFG_DB_DADOS

strSQL=	" SELECT NOME, " &_
		" SITE, " &_ 
		" EMAIL, " &_ 
		" EMAIL_SENDER " &_
		" FROM tbl_EVENTO" &_ 
		" WHERE  COD_EVENTO = " & strCOD_EVENTO
		
set objRS = objConn.Execute(strSQL)

If not objRS.EOF then
  strEV_NOME = objRS("NOME")&""
  strEV_EMAIL_SENDER = objRS("EMAIL_SENDER")&""
end if
FechaRecordSet objRS

%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
<script language="JavaScript">

function EditaCampos(pr_formindex, pr_fieldname) 
{
  var auxstr;

  auxstr = "../edithtml/athEditHTML.asp?var_TextBoxName="+ pr_fieldname + "&var_IndexForm=" + pr_formindex;
  window.open(auxstr,'ProEventoHTML', 'width=630,height=500');
}
</script>
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <form name="forminsert" action="newsletter.asp" method="POST">
<input type="hidden" name="var_chavereg" value="<%=strCOD_LOTE%>">
<tr> 
<td align="center" valign="middle">
  <table width="550" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
            <td width="492" height="4"><img src="../img/inbox_top_blue.gif" width="542" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="550" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="542"><table width="542" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
                <tr> 
                  <td bgcolor="#7DACC5">&nbsp;Newsletter - Envio de Mensagens</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="520" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <TR> 
                        <td width="100" align="right">*E-mail Remetente:&nbsp;</td>
                        <td colspan="2"><input name="var_remetente" type="text" class="textbox380" size="50" maxlength="255" value="<%=strEV_EMAIL_SENDER%>"> 
                        </td>
                      </tr>
                      <TR> 
                        <td width="100" align="right">*Assunto:&nbsp;</td>
                        <td colspan="2"><input name="var_assunto" type="text" class="textbox380" size="50" maxlength="255"> 
                        </td>
                      </tr>
                      <tr> 
                        <td width="100" align="right">*Mensagem:&nbsp;</td>
                        <td width="385"><textarea name="var_mensagem" cols="35" rows="20" class="textbox380"></textarea>
                          &nbsp; </td>
                        <td width="35"><a href="javascript:EditaCampos('0','<%=Server.URLEncode("var_mensagem")%>');"><img src="../img/bt_editHTML.gif" alt="Editor HTML" width="21" height="30" border="0"></a> 
                        </td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">Importância:&nbsp;</td>
                        <td colspan="2"><select name="var_importancia" class="textbox100">
                            <option value="0">Baixa</option>
                            <option value="1" selected>Normal</option>
                            <option value="2">Alta</option>
                          </select> </td>
                      </tr>
                    </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
        <table width="550" align="center" cellpadding="0" cellspacing="0" border="0">
          <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
            <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:forminsert.submit();"><img src="../img/Bt_send.gif" width="63" height="17" border="0"></a><a href="javascript:forminsert.reset();"><img src="../img/bt_clear.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
 </tr>
</td>
</form>
</table>
<br>
</body>
</html>