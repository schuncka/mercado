<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_scripts/scripts.js"-->
<%
  VerficaAcesso("ADMIN")
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<script language="JavaScript">
<!--

function goReportFinanceiro() {
  var strcode = "";
  var opcao = document.form_financeiro.var_financeiro.value;
  var strparam = "?var_dt_inicio=" + var_dt_inicio.value + "&var_dt_fim=" + var_dt_fim.value;
  
  switch(opcao) {
  case "1": 
          strcode = "rel_fin_recebimento_data.asp";
          break;
  case "2": 
          strcode = "";
          break;
  case "3": 
          strcode = "rel_inscricao_produto.asp";
          break;
  case "4": 
          strcode = "";
          break;
  case "5": 
          strcode = "rel_inscricao_pendente.asp";
          break;
  case "6": 
          strcode = "rel_inscricao_pendente_historico.asp";
          break;
  default:
          strcode = "";
  }

  if (strcode != "") {
    AbreJanelaPAGE(strcode + strparam,'660', '600');
  }
}

function goReportGerencial() {
  var strcode = "";
  var opcao = document.form_gerencial.var_gerencial.value;
  
  switch(opcao) {
  case "1": 
          strcode = "rel_lista_inscricao_produto.asp";
          break;
  case "2": 
          strcode = "maladireta.asp";
          break;
  case "3": 
          strcode = "rel_resumo_inscricao.asp";
          break;
  case "4": 
          strcode = "listaenvelope.asp";
          break;
  case "5": 
          strcode = "listacredencial.asp";
          break;
  case "6": 
          strcode = "rel_lista_certificado.asp";
          break;
  case "7": 
          strcode = "rel_lista_diploma.asp";
          break;
  case "8": 
          strcode = "certificado_geral.asp";
          break;
  default:
          strcode = "";
  }

  if (strcode != "") {
    strcode += '?var_dt_inicio=' + document.all.var_dt_inicio.value + '&var_dt_fim=' + document.all.var_dt_fim.value;
//	alert(strcode);
    AbreJanelaPAGE(strcode,'660', '600');
  }
}

function goReportVisitacao() {
  var strcode = "";
  var opcao = document.form_visitacao.var_visitacao.value;
  
  switch(opcao) {
  case "1": 
          strcode = "rel_visitacao_geral.asp";
          break;
  case "2": 
          strcode = "rel_visitacao_pais.asp";
          break;
  case "3": 
          strcode = "rel_visitacao_pais_empresa.asp";
          break;
  case "4": 
          strcode = "rel_visitacao_atividade.asp";
          break;
  case "5": 
          strcode = "rel_visitacao_atividade_empresa.asp";
          break;
  case "6": 
          strcode = "rel_visitacao_estado.asp";
          break;
  case "7": 
          strcode = "rel_visitacao_capital.asp";
          break;
  default:
          strcode = "";
  }

  if (strcode != "") {
    AbreJanelaPAGE(strcode,'660', '600');
  }
}

//-->
</script>
</head>
<body text="#916E28" link="#916E28" vlink="#916E28" alink="#916E28" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td align="center" valign="top"><BR>
      <table height = "450" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="19" colspan="2" valign="top" class="arial14Bold"> &nbsp;Administra&ccedil;&atilde;o 
            - Relat&oacute;rios</td>
          <td align="right" valign="top" class="arial11">&nbsp; </td>
        </tr>
        <tr> 
          <td colspan="2" align="center" valign="middle"> </td>
        </tr>
        <tr> 
          <td colspan="2" valign="top"><br> 
            <table width="600" border="0" align="center" cellpadding="0" cellspacing="0" class="arial10">
              <tr>
                <td align="right">&nbsp;</td>
                <td>Per&iacute;odo</td>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <td><input name="var_dt_inicio" type="text" class="textbox70" id="var_dt_inicio">
                  at&eacute; <input name="var_dt_fim" type="text" class="textbox70" id="var_dt_fim"></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>Relat&oacute;rio Financeiro</td>
              </tr>
              <tr> 
                <td width="150" align="right">&nbsp;</td>
                <form name="form_financeiro" method="post" action="">
                  <td> <select name="var_financeiro" class="textbox250" id="form_financeiro">
                      <option value="1">Recebimentos por Data</option>
                      <option value="2">Recebimentos por Tipo</option>
                      <option value="3" selected>Inscri&ccedil;&otilde;es por 
                      Palestra com valor pago</option>
                      <option value="4">Inscri&ccedil;&otilde;es por Congressista 
                      com valor pago</option>
                      <option value="5">Inscri&ccedil;&otilde;es Pendentes</option>
                      <option value="6">Inscri&ccedil;&otilde;es Pendentes c/ Histórico</option>
                    </select> <input name="Button" type="button" class="edbutton" value="enviar" onClick="goReportFinanceiro()"> 
                  </td>
                </form>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <td> Relat&oacute;rio Gerencial&nbsp;</td>
              </tr>
              <tr> 
                <td width="150" align="right">&nbsp;</td>
                <form name="form_gerencial" method="post" action="">
                  <td> <select name="var_gerencial" class="textbox250" id="form_gerencial">
                      <option value="1">Listagem Geral dos Participantes</option>
                      <option value="2">Etiquetas da Palestra</option>
                      <option value="3" selected>Resumo das Inscri&ccedil;&otilde;es</option>
                      <option value="4">Envelopes Pendentes</option>
                      <option value="5">Credenciais Pendentes</option>
                      <option value="6">Emissão Certificados</option>
                      <option value="7">Emissão Diplomas</option>
                      <option value="8">Emissão Certificados - Geral</option>
                    </select> <input name="Submit2" type="button" class="edbutton" value="enviar" onClick="goReportGerencial()"> 
                  </td>
                </form>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <td> Relat&oacute;rio Visita&ccedil;&atilde;o</td>
              </tr>
              <tr> 
                <td width="150" align="right">&nbsp;</td>
                <form name="form_visitacao" method="post" action="">
                  <td> <select name="var_visitacao" class="textbox250">
                      <option value="1" selected>Resumo Geral</option>
                      <option value="2">Países - Visitas</option>
                      <option value="3">Países - Empresas</option>
                      <option value="4">Atividades - Visitas</option>
                      <option value="5">Atividades - Empresas</option>
                      <option value="6">Estados - Visitas</option>
                      <option value="7">Capital - Visitas</option>
                    </select> <input name="Submit2" type="button" class="edbutton" value="enviar" onClick="goReportVisitacao()"> 
                  </td>
                </form>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td width="270" valign="top"></td>
          <td width="470" height="11"></td>
        </tr>
      </table>
      </td>
  </tr>    
</table>
</body>
</html>
