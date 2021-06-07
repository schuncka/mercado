<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/secure.asp"-->

<!--#include file="../_scripts/scripts.js"-->
<%
  VerficaAcesso("ADMIN")
  
 Dim objConn, ObjRS, objRSDetail, objRSDetailSub
 Dim strSQL, strSQLClause
 
 AbreDBConn objConn, CFG_DB_DADOS 

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<script language="JavaScript">
<!--

function goReportGerencial() {
  var strcode = "";
  var opcao = document.form_cadastro.var_cadastro.value;
  
  switch(opcao) {
  case "1": 
          strcode = "rel_analise_geral.asp";
          break;
  case "2": 
          strcode = "rel_analise_atividade.asp";
          break;
  case "3": 
          strcode = "rel_analise_localidade.asp";
          break;
  case "4": 
          strcode = "rel_analise_atividade_intl.asp";
          break;
  default:
          strcode = "";
  }

  if (strcode != "") {
    strcode += '?var_dt_inicio=' + document.all.var_dt_inicio.value + '&var_dt_fim=' + document.all.var_dt_fim.value;
	strcode += '&var_cep_inicio=' + document.all.var_cep_inicio.value + '&var_cep_fim=' + document.all.var_cep_fim.value;
	strcode += '&var_cod_status_cred=' + document.all.var_cod_status_cred.value;
	
//	alert(strcode);
    AbreJanelaPAGE(strcode,'660', '600');
  }
  else {
    alert('Relatório não disponível.');
  }
}

function SetDate(dt_inicio, dt_fim) {
  document.all.var_dt_inicio.value = dt_inicio;
  document.all.var_dt_fim.value = dt_fim;
}

function SetCEP(cep_inicio, cep_fim) {
  document.all.var_cep_inicio.value = cep_inicio;
  document.all.var_cep_fim.value = cep_fim;
}

function SetStatusCred(statuscred){
  document.all.var_cod_status_cred.value = statuscred;
}

function searchAll() {
  SetDate('','');
}

function searchToday() {
  SetDate('<%=PrepData(date(),True,False)%>','<%=PrepData(date(),True,False)%>');
}

function showHideBox(opcao) {
 // alert(opcao);
  switch(opcao) {
  case "1": 
          document.getElementById('table_cep').style.display = "none";
		  document.getElementById('table_status_cred').style.display = "none";		  
          break;
  case "2": 
          document.getElementById('table_cep').style.display = "block";
		  document.getElementById('table_status_cred').style.display = "block";
          break;
  default:
          document.getElementById('table_cep').style.display = "none";
		  document.getElementById('table_status_cred').style.display = "none";
  }
}

function SomenteNumero(e){
    var tecla=(window.event)?event.keyCode:e.which;
    if((tecla > 47 && tecla < 58)) return true;
    else{
    if (tecla != 8) return false;
    else return true;
    }
}

function ConfereCEP(objeto){
  var str = objeto.value;
  objeto.value = str.replace(/^\s+|\s+$/g, '') ;
  
  if ( (isNaN(objeto.value))||(objeto.value=='') ) {
	objeto.value = '';
  }
  else {
    while(objeto.value.length < objeto.maxLength) {
	  objeto.value = '0' + objeto.value;
	}
  }
}
//-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF" onLoad="showHideBox('');">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td align="center" valign="top"><BR>
      <table height = "450" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="19" colspan="2" valign="top" class="arial14Bold"> &nbsp;Cadastro 
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
                <td width="50" align="right">&nbsp;</td>
                <td width="550">Per&iacute;odo do Cadastro</td>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <td bgcolor="#E4E4E4"> <table width="450" border="0" cellpadding="2" cellspacing="0" class="arial10">
                    <tr> 
                      <td width="5" rowspan="2">&nbsp;</td>
                      <td width="168" rowspan="2"><input name="var_dt_inicio" type="text" class="textbox70" id="var_dt_inicio" value="<%=PrepData(Date(),True,False)%>">
                        at&eacute; <input name="var_dt_fim" type="text" class="textbox70" id="var_dt_fim" value="<%=PrepData(Date(),True,False)%>"></td>
                      <td width="6">.:</td>
                      <td width="157"><a href="javascript:searchAll();">Pesquisar 
                        todos</a></td>
                    </tr>
                    <tr> 
                      <td>.:</td>
                      <td><a href="javascript:searchToday();">Pesquisar pelo dia 
                        atual</a></td>
                    </tr>
                  </table></td>
              </tr>
			</table>
			<table width="600" border="0" align="center" cellpadding="0" cellspacing="0" class="arial10" id="table_cep">
              <tr> 
                <td width="50" align="right">&nbsp;</td>
                <td>Intervalo de CEP</td>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <td bgcolor="#E4E4E4"> <table width="450" border="0" cellpadding="2" cellspacing="0" class="arial10">
                    <tr> 
                      <td width="5">&nbsp;</td>
                      <td width="168"><input name="var_cep_inicio" type="text" class="textbox70" id="var_cep_inicio" value="" maxlength="8" onkeypress='return SomenteNumero(event)' onBlur="ConfereCEP(this)">
                        at&eacute; <input name="var_cep_fim" type="text" class="textbox70" id="var_cep_fim" value="" maxlength="8" onkeypress='return SomenteNumero(event)' onBlur="ConfereCEP(this)"></td>
                      <td width="6">.:</td>
                      <td width="157"><a href="javascript:SetCEP('','');">Pesquisar 
                        todos</a></td>
                    </tr>
                    
                  </table></td>
              </tr>
			</table>
            
            <table width="600" border="0" align="center" cellpadding="0" cellspacing="0" class="arial10" id="table_status_cred">
              <tr> 
                <td width="50" align="right">&nbsp;</td>
                <td>Tipo de credencial</td>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <td bgcolor="#E4E4E4"> <table width="450" border="0" cellpadding="2" cellspacing="0" class="arial10">
                    <tr> 
                      <td width="5">&nbsp;</td>
                      <td width="168">
                      <select name="var_cod_status_cred" class="textbox100">
                      <option value="" selected>Todos</option>
                      <%
					  strSQL = "SELECT COD_STATUS_CRED, STATUS FROM TBL_STATUS_CRED ORDER BY 2"
					  MontaCombo strSQL,"COD_STATUS_CRED","STATUS",""
                      %>
                      </select>
                       </td>
                      <td width="6">.:</td>
                      <td width="157"><a href="javascript:SetStatusCred('');">Pesquisar 
                        todos</a></td>
                    </tr>
                    
                  </table></td>
              </tr>
			</table>
            
			<table width="600" border="0" align="center" cellpadding="0" cellspacing="0" class="arial10">
              <tr> 
                <td width="50">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>Relat&oacute;rio Cadastro </td>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <form name="form_cadastro" method="post" action="">
                  <td> <select name="var_cadastro" class="textbox380" id="form_cadastro" onChange="showHideBox(this.value);">
                       <option value="1" selected>RC01 - Análise do Cadastro - Geral</option>
                       <option value="2">RC02 - Análise do Cadastro - Por Atividade</option>
                       <option value="3">RC03 - Análise do Cadastro - Por Estado/País</option>
                       <option value="4">RC04 - Análise do Cadastro Internacional - Por Atividade</option>
                    </select> <input name="Submit2" type="button" class="edbutton" value="enviar" onClick="goReportGerencial()">                  </td>
                </form>
              </tr>
              <tr> 
                <td align="right">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              
              <tr>
                <td align="right">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td align="right">&nbsp;</td>
                <td>&nbsp;</td>
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

<%
 FechaDBConn objConn

%>
