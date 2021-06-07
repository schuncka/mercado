<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<html>
<head>
	<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../_css/csm.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" language="javascript">
		<!--
		function viewdoc(doc) {
		  var conteudo = '';
		  
		  if(doc!='') {
			conteudo = eval('document.formdetail.dbvar_str_' + doc + '.value');
		  }
		  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
		}
		
		function mountRedirect() {
			var cod_evento = document.formdetail.dbvar_num_cod_evento.value;
			var lang = document.formdetail.dbvar_str_lang.value;
			
			document.formdetail.DEFAULT_LOCATION.value = "../modulo_AreaRestritaSetup/update.asp?var_cod_evento=" + cod_evento + "&var_lang=" + lang;
			
		}
		-->
	</script>
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle"><img src="../img/spacer.gif" width="10" height="5"></td>
</tr>
<tr> 
<td align="center" valign="middle">
   <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
          <td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
      <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
        <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              <tr> 
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Configuração de Área Restrita</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
                <td align="center"> 
				  <table width="99%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="formdetail" action="../_database/athinserttodb.asp" method="post">
						<input type="hidden" name="DEFAULT_TABLE" value="tbl_area_restrita_expositor">
  						<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
  						<input type="hidden" name="FIELD_PREFIX" value="dbvar_">
  						<input type="hidden" name="RECORD_KEY_NAME" value="cod_evento">
  						<input type="hidden" name="RECORD_KEY_NAME_EXTRA" value="lang">
  						<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_AreaRestritaSetup/update.asp">
                      <tr> 
                        <td align="right"><strong>*Evento:&nbsp;</strong></td>
                        <td>
							<select name="dbvar_num_cod_evento" class="textbox180">
								<% MontaCombo "SELECT cod_evento, nome FROM tbl_evento ORDER BY dt_inicio DESC", "cod_evento", "nome", "" %>
							</select>
						</td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>*Lingua:&nbsp;</strong></td>
                        <td>
							<select name="dbvar_str_lang" class="textbox180">
								<option value="PT">Português (PT)</option>
								<option value="EN">Inglês (EN)</option>
								<option value="SP">Espanhol (SP)</option>
							</select>
						</td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>*Data Início:&nbsp;</strong></td>
                        <td><input type="text" name="dbvar_date_dt_ini" value="" class="textbox70"></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Data Término:&nbsp;</strong></td>
                        <td><input type="text" name="dbvar_date_dt_fim" value="" class="textbox70"></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Email Auditoria:&nbsp;</strong></td>
                        <td><input type="text" name="dbvar_str_email_auditoria_caex" value="" class="textbox380"></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Convite Eletrônico:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_convite_eletronico_texto" cols="40" rows="6" class="textbox380"></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('convite_eletronico_texto');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Convite VIP:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_convite_vip_texto" cols="40" rows="6" class="textbox380"></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('convite_vip_texto');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Cabeçalho Formulários:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_cabecalho_form" cols="60" rows="6" class="textbox380"></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('cabecalho_form');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Rodapé Formulários:&nbsp;</strong></td>
                        <td><textarea name="dbvar_str_rodape_form" cols="60" rows="6" class="textbox380"></textarea></td>
                      </tr>
					  <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('rodape_form');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Inativo:&nbsp;</strong></td>
                        <td align="left">
						<input name="dbvar_date_sys_inativo"  type="radio" value="<%=Now()%>"> Sim 
						<input name="dbvar_date_sys_inativo"  type="radio" value="" checked> Não 
                      </tr>
                    </form>
                  </table>
				</td>
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
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:mountRedirect(); document.formdetail.submit();"><img src="../img/bt_save.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
    </tr></td>
<tr> 
<td align="center" valign="middle"><img src="../img/spacer.gif" width="10" height="5"></td>
</tr>
</table>
</body>
</html>