<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"-->
<%
  VerficaAcesso("ADMIN")
  
  Dim strMODE
  strMODE = "caex"
%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
<!--
function viewdoc(doc) {
  var conteudo = '';
  
  if(doc=='certificado') {
    conteudo = document.forminsert.var_certificado_texto.value;
  }
  if(doc=='diploma') {
    conteudo = document.forminsert.var_diploma_texto.value;
  }
  
  if(doc=='certificadopdf') {
    conteudo = document.forminsert.var_certificadopdf_texto.value;
  }
  if(doc=='diplomapdf') {
    conteudo = document.forminsert.var_diplomapdf_texto.value;
  }
  if(doc=='grupointl') {
    conteudo = document.forminsert.var_grupointl_texto.value;
  }
  if(doc=='titulointl') {
    conteudo = document.forminsert.var_titulointl_texto.value;
  }
  if(doc=='descricaointl') {
    conteudo = document.forminsert.var_descricaointl_texto.value;
  }        
  
  if(doc=='certificadointl') {
    conteudo = document.forminsert.var_certificado_texto.value;
  }
  if(doc=='diplomaintl') {
    conteudo = document.forminsert.var_diploma_texto.value;
  }
  
  if(doc=='certificadopdfintl') {
    conteudo = document.forminsert.var_certificadopdf_texto.value;
  }
  if(doc=='diplomapdfintl') {
    conteudo = document.forminsert.var_diplomapdf_texto.value;
  }

  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}

//-->
</script>
</head>

<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="forminsert" action="insertexec.asp" method="POST">
<input type="hidden" name="mode" value="<%=strMODE%>">
<input type="hidden" name="var_caex_show" value="1">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle"><br>
  <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr><td bgcolor="#7DACC5">&nbsp;&nbsp;Inserção de Produtos</td></tr>
          <tr><td height="16" align="center">&nbsp;</td></tr>
          <tr> 
            <td align="center">
			  <table width="98%" border="0" cellpadding="2" cellspacing="0" class="arial11">
                      <tr> 
                        <td width="120" align="right">*C&oacute;digo:&nbsp;</td>
                        <td><input name="var_cod_prod" type="text" class="textbox100"></td>
                 </tr>
                 <tr> 
                        <td align="right">*Grupo:&nbsp;</td>
                        <td><input name="var_grupo" type="text" class="textbox180"></td>
                 </tr>
                 <tr> 
                        <td align="right">*T&iacute;tulo:&nbsp;</td>
                        <td align="left"><input name="var_titulo" type="text" class="textbox380"></td>
                 </tr>
                 <tr> 
                        <td align="right" valign="top">*Descri&ccedil;&atilde;o:&nbsp;</td>
                        <td align="left"><textarea name="var_descricao" rows="3" class="textbox380"></textarea></td>
                 </tr>
                 <tr> 
                        <td align="right">Capacidade:&nbsp;</td>
                        <td align="left"><input name="var_capacidade" type="text" class="textbox70"></td>
                 </tr>
				 <tr> 
                        <td align="right">Refer&ecirc;ncia Num&eacute;rica:&nbsp;</td>
                        <td align="left"><input name="var_ref_numerica" type="text" class="textbox70"></td>
                 </tr>
                 <tr> 
                        <td align="right">Local:&nbsp;</td>
                        <td align="left"><input name="var_local" type="text" class="textbox380"></td>
                  </tr>                 
                  
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
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
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:forminsert.submit();"><img src="../img/bt_save.gif" width="78" height="17" border="0"></a><a href="javascript:forminsert.reset();"><img src="../img/bt_clear.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
</tr></td></table></form>
</body>
</html>
