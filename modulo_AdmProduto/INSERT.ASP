<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"-->
<%
  VerficaAcesso("ADMIN")
  
  Dim strMODE
  strMODE = Request("mode")
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
                        <td align="right" valign="top">Descri&ccedil;&atilde;o HTML:&nbsp;</td>
                        <td align="left"><textarea name="var_descricao_html" rows="3" class="textbox380"></textarea></td>
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
                        <td align="right">Data/Hora In&iacute;cio:&nbsp;</td>
                        <td align="left"><input name="var_dt_ocorrencia" type="text" class="textbox180">(DD/MM/AAAA HH:MM)</td>
                 </tr>
                 <tr> 
                        <td align="right">Data/Hora T&eacute;rminio:&nbsp;</td>
                        <td align="left"><input name="var_dt_termino" type="text" class="textbox180">(DD/MM/AAAA HH:MM)</td>
                 </tr>
                      <tr> 
                        <td align="right">Local:&nbsp;</td>
                        <td align="left"><input name="var_local" type="text" class="textbox380"></td>
                      </tr>
                      <tr> 
                        <td align="right">Carga Hor&aacute;ria:&nbsp;</td>
                        <td align="left"><input name="var_carga_horaria" type="text" class="textbox380"></td>
                      </tr>
                      <tr> 
                        <td align="right">ID Start Comp.:&nbsp;</td>
                        <td align="left"><input name="var_num_competidor_start" type="text" class="textbox70"></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Sinopse:&nbsp;</td>
                        <td align="left"><textarea name="var_sinopse" rows="3" class="textbox380" cols="20"></textarea></td>
                      </tr>
                      <tr> 
                        <td align="right">Dinâmica:&nbsp;</td>
                        <td><textarea name="var_dinamica" rows="3" class="textbox380"></textarea></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Config. Certificado:&nbsp;</td>
                        <td align="left"><textarea name="var_certificado_texto" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificado');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Config. Diploma:&nbsp;</td>
                        <td align="left">
<textarea name="var_diploma_texto" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diploma');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
					  
					  
					  
					  
					  
					  
					  
                      <tr> 
                        <td align="right" valign="top">Certificado PDF:&nbsp;</td>
                        <td align="left"><textarea name="var_certificadopdf_texto" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">Orientação:</td>
                        <td align="left">
                         <select id="var_certificado_pdf_orientacao" name="var_certificado_pdf_orientacao" class="textbox100">
                           <option value="RETRATO">RETRATO</option>
                           <option value="PAISAGEM" selected>PAISAGEM</option>
                         </select>
                        </td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificadopdf');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      
                      <tr> 
                        <td align="right" valign="top">Diploma PDF:&nbsp;</td>
                        <td align="left"><textarea name="var_diplomapdf_texto" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diplomapdf');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td align="right" valign="top">Grupo Intl:&nbsp;</td>
                        <td align="left">
<textarea name="var_grupointl_texto" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('grupointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Titulo Intl:&nbsp;</td>
                        <td align="left">
<textarea name="var_titulointl_texto" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('titulointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Descrição Intl:&nbsp;</td>
                        <td align="left">
<textarea name="var_descricaointl_texto" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('descricaointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
					  
					  					  					  					  					  
					  
					  
                      <tr> 
                        <td align="right" valign="top">Config. Certificado Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_certificadointl_texto" rows="6" class="textbox380" cols="20"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificadointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">Config. Diploma Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_diplomaintl_texto" rows="6" class="textbox380" cols="20"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diplomaintl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>

					  
                      
                      <tr> 
                        <td align="right" valign="top">Certificado PDF Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_certificadopdfintl_texto" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificadopdfintl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td align="right" valign="top">Diploma PDF Intl:&nbsp;</td>
                        <td align="left"><textarea name="var_diplomapdfintl_texto" rows="6" class="textbox380"></textarea></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diplomapdfintl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                      </tr>

					  
					  
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
					  <tr> 
                        <td align="right">Outros produtos que&nbsp;<br>
                          garantem acesso:&nbsp;</td>
	                    <td align="left">
						  <table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190">
<input name="var_cod_prod_valida" type="text" class="textbox180">
                              </td>
                              <td width="190">Ex: &quot;3000,3001&quot; - Quem 
                                comprou o curso 3000 ou o curso 3001 TAMB&Eacute;M 
                                pode assistir esse curso</td>
                            </tr>
                          </table>
                          
                        </td>
	                  </tr>
                      <tr> 
                        <td align="right">Exibir na Loja:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_loja_show" type="radio" value="1" <% If strMODE <> "CAEX" Then %>checked<% End If %>>
                           Sim &nbsp;&nbsp;
						<input type="radio" name="var_loja_show" value="0" <% If strMODE = "CAEX" Then %>checked<% End If %>> Não &nbsp;&nbsp;						
						</td>
                      </tr>
                      <tr> 
                        <td align="right">Exibir no CAEX:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_caex_show" type="radio" value="1" <% If strMODE = "CAEX" Then %>checked<% End If %>>
                           Sim &nbsp;&nbsp;
						<input name="var_caex_show" type="radio" value="0" <% If strMODE <> "CAEX" Then %>checked<% End If %>> 
						Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
                      
					  <tr>
					    <td align="right" bgcolor="#CCCCCC">Complemento 1:</td>
					    <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
					  </tr>
					  <tr> 
                        <td align="right">Título:&nbsp;</td>
                        <td align="left"> <input name="var_extra_info_msg" type="text" value="" size="30" maxlength="50" class="textbox180"></td>
                      </tr>
					  <tr> 
                        <td align="right">Exibir:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_show" type="radio" value="1">
                          Sim &nbsp;&nbsp;
						  <input name="var_extra_info_show" type="radio" value="0" checked>
					      Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <tr> 
                        <td align="right">Requerido:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_requerido" type="radio" value="1">
                          Sim &nbsp;&nbsp;
						  <input name="var_extra_info_requerido" type="radio" value="0" checked>
					      Não &nbsp;&nbsp;						
						</td>
                      </tr>

                      
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
					  <tr>
					    <td align="right" bgcolor="#CCCCCC">Complemento 2:</td>
					    <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
					  </tr>
					  <tr> 
                        <td align="right">Título:&nbsp;</td>
                        <td align="left"> <input name="var_extra_info_2_msg" type="text" value="" size="30" maxlength="50" class="textbox180"></td>
                      </tr>
					  <tr> 
                        <td align="right">Exibir:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_2_show" type="radio" value="1">
                          Sim &nbsp;&nbsp;
						  <input name="var_extra_info_2_show" type="radio" value="0" checked>
					      Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <tr> 
                        <td align="right">Requerido:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_2_requerido" type="radio" value="1">
                          Sim &nbsp;&nbsp;
						  <input name="var_extra_info_2_requerido" type="radio" value="0" checked>
					      Não &nbsp;&nbsp;						
						</td>
                      </tr>
                      
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
                      <tr>
					    <td align="right" bgcolor="#CCCCCC">Complemento 3:</td>
					    <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
					  </tr>
					  <tr> 
                        <td align="right">Título:&nbsp;</td>
                        <td align="left"> <input name="var_extra_info_3_msg" type="text" value="" size="30" maxlength="50" class="textbox180"></td>
                      </tr>
					  <tr> 
                        <td align="right">Exibir:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_3_show" type="radio" value="1">
                          Sim &nbsp;&nbsp;
						  <input name="var_extra_info_3_show" type="radio" value="0" checked>
					      Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <tr> 
                        <td align="right">Requerido:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_3_requerido" type="radio" value="1">
                          Sim &nbsp;&nbsp;
						  <input name="var_extra_info_3_requerido" type="radio" value="0" checked>
					      Não &nbsp;&nbsp;						
						</td>
                      </tr>
                      
					  <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
                      <tr>
					    <td align="right" bgcolor="#CCCCCC">Complemento 4:</td>
					    <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
					  </tr>
					  <tr> 
                        <td align="right">Título:&nbsp;</td>
                        <td align="left"> <input name="var_extra_info_4_msg" type="text" value="" size="30" maxlength="50" class="textbox180"></td>
                      </tr>
					  <tr> 
                        <td align="right">Exibir:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_4_show" type="radio" value="1">
                          Sim &nbsp;&nbsp;
						  <input name="var_extra_info_4_show" type="radio" value="0" checked>
					      Não &nbsp;&nbsp;						
						</td>
                      </tr>
					  <tr> 
                        <td align="right">Requerido:&nbsp;</td>
                        <td align="left"> 
                          <input name="var_extra_info_4_requerido" type="radio" value="1">
                          Sim &nbsp;&nbsp;
						  <input name="var_extra_info_4_requerido" type="radio" value="0" checked>
					      Não &nbsp;&nbsp;						
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
