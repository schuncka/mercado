<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="_database/ADOVBS.INC"--> 
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"--> 
<%
 Dim strSQL, objRS, ObjConn
 Dim strCOD_USUARIO

 AbreDBConn objConn, CFG_DB_DADOS 

%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="_css/csm.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#FFFFFF" background="img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="formsolicitacao" action="SolicitacaoResult.asp" method="GET">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td align="center" valign="middle">
<table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="492" height="4"><img src="img/inbox_top_blue.gif" width="492" height="4"></td>
      <td width="4" height="4"><img src="img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="492"><table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  <td bgcolor="#7DACC5">&nbsp;&nbsp;Esqueci minha senha</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="450" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr> 
                        <td width="100" align="right" valign="top">*email:&nbsp;</td>
                        <td width="350" align="left"> <input name="var_email" type="text" class="textbox180"> 
                          <span class="Tahomacinza10"><br>
                          Este email deve ser o mesmo cadastrado no sistema, pois 
                          este efetuar&aacute; uma busca e, caso o encontre em 
                          seus reguistros, ir&aacute; enviar a voc&ecirc; automaticamente 
                          os dados de sua conta, caso contr&aacute;rio ser&aacute; 
                          enviada uma mensagem ao webmaster para que este possa 
                          entrar em contao o mais breve poss&iacute;vel para averiguar 
                          seu problema</span>.</td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">Nome:&nbsp;</td>
                        <td width="350"><input name="var_nome" type="text" class="textbox380"> 
                        </td>
                      </tr>
                      <tr> 
                        <td width="100" align="right" valign="top">Mensagem:&nbsp;</td>
                        <td width="350"><textarea  name="var_obs" type="text" class="textbox380media"></textarea></td>
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
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="img/inbox_bottom_blue.gif"><img src="img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="img/inbox_bottom_big3.gif"><a href="javascript:formsolicitacao.submit();"><img src="img/bt_send.gif" width="63" height="17" hspace="10" border="0"></a><img src="img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
</tr></td></table></form>
</body>
</html>

<%
 'FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>
