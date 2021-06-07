<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<%
 Dim strCOD_LOTE
	
 strCOD_LOTE = Request("var_chavereg")


 Dim MyCurPage, MyPageCount, TotalPages, strALL_PARAMS, NumPerPage
 'Relativas aos resultados da consulta SQL

 NumPerPage = Request("var_numperpage")
 If (Not IsNumeric(NumPerPage)) or (NumPerPage = "") Then
   NumPerPage = 50
 End If

 MyCurPage = Request("var_curpage")
 If (Not isNumeric(MyCurPage)) or (MyCurPage = "")  then
   MyCurPage = 1 
 Else
   If cint(MyCurPage) < 1 Then
	 MyCurPage = 1 
   End If
 End If


%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_CSS/CSM.CSS" rel="stylesheet" type="text/css">
<script language="JavaScript">
<!--
function ImprimeCredencial() {
  window.parent.frames['frm_credencialdetail'].focus();
  window.parent.frames['frm_credencialdetail'].print();
}

function incrementa(){
//	if (formulario.var_curpage.value<100) {
		formulario.var_curpage.value++;
		formulario.submit();
//	}
	//else {alert("Não há mais páginas a serem exibidas")}

}

function decrementa(){
	if (formulario.var_curpage.value>1){
		formulario.var_curpage.value--;
		formulario.submit();
		}
}

//-->
</script>
</head>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="680" border="0" cellspacing="0" cellpadding="0">
  <form name="formulario" method="post" action="credencial_body.asp" target="frm_credencialdetail">
    <input name="var_chavereg" type="hidden" value="<%=strCOD_LOTE%>">
    <input name="var_impressao" type="hidden" value="TRUE">
    <tr> 
      <td height="17" colspan="4" align="center" class="arial12Bold">Lotes - Credenciais</td>
    </tr>
    <tr> 
      <td width="36%" align="center">&nbsp;&nbsp;Linhas
        <input name="numlinha" type="text" class="textbox20" value="1" maxlength="2">
x Colunas
<input name="numcol" type="text" class="textbox20" value="1" maxlength="2">
&nbsp; Posi&ccedil;&atilde;o inicial
<input name="posinicial" type="text" class="textbox20" id="posinicial" value="1" maxlength="2"></td>
      <td width="18%" align="center">&nbsp;&nbsp; <input name="dec" type="image" src="../img/seta_ant.jpg" onClick="decrementa()"> 
        &nbsp; Lote 
        <input name="var_curpage" type="text" class="arial8" value="<%=MyCurPage%>" size="4"> 
      &nbsp; <input name="inc" type="image" src="../img/seta_prox.jpg" onClick="incrementa(<%=TotalPages%>)">      </td>
      <td width="22%" align="center">N&ordm; P&aacute;ginas por Lote 
        <input name="var_numperpage" type="text" class="arial8" value="<%=NumPerPage%>" size="4">
      &nbsp; </td>
      <td width="24%" align="center">Credencial:
        <select name="var_sys_datacred" class="textbox100">
          <option value="" selected>Todas</option>
          <option value="IS NOT NULL">Impressas</option>
          <option value="IS NULL">Não Impressas</option>
        </select></td>
    </tr>
    <tr>
      <td colspan="2" align="center">Marcar  impresso (C.O.E.) 
        <input name="var_marcaimpressao" type="checkbox" value="S">  
        &nbsp;&nbsp;&nbsp;&nbsp;      
        Mala-Direta 
        <!--input name="var_imprime_etiqueta" type="checkbox" value="S"//-->
        <select name="var_imprime_etiqueta" class="textbox100">
          <option value="" selected>Não</option>
          <option value="1">1</option>
          <option value="2">2</option>
          <option value="3">3</option>
          <option value="EMPRESA">Empresa</option>
        </select>      </td>
      <td colspan="2" align="center"> CEP
        <input name="var_cep_inicio" type="text" class="textbox70" value="" maxlength="8">
        a
      <input name="var_cep_fim" type="text" class="textbox70" value="" maxlength="8"></td>
    </tr>
    <tr> 
      <td colspan="4" align="right"><a href="javascript:ImprimeCredencial();" class="Tahomacinza9">
        <input name="Submit" type="submit" class="edbutton" value="Montar Lote">
        &nbsp;&nbsp;&nbsp;&nbsp;
      <img src="../img/ico_impressora_mini.gif" border="0">imprimir</a></td>
    </tr>
  </form>
</table>
</body>
</html>
