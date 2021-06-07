<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<%
Dim MyCurPage, MyPageCount, TotalPages, strALL_PARAMS, NumPerPage
'Relativas aos resultados da consulta SQL

NumPerPage = Request("var_numperpage")
If (Not IsNumeric(NumPerPage)) or (NumPerPage = "") Then
  NumPerPage = 20
End If

MyCurPage = Request("var_curpage")
If (Not isNumeric(MyCurPage)) or (MyCurPage = "")  then
  MyCurPage = 1 
Else
  If cint(MyCurPage) < 1 Then
    MyCurPage = 1 
  End If
End If

Dim strCOD_LOTE
	
strCOD_LOTE = Request("var_chavereg")
%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_CSS/CSM.CSS" rel="stylesheet" type="text/css">
<script language="JavaScript">
<!--
function ImprimeChaveAcesso() {
  window.parent.frames['frm_chaveacessodetail'].focus();
  window.parent.frames['frm_chaveacessodetail'].print();
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
<table width="640" border="0" cellspacing="0" cellpadding="0">
  <form name="formulario" method="post" action="chaveacesso_body.asp" target="frm_chaveacessodetail">
  <input name="var_chavereg" type="hidden" value="<%=strCOD_LOTE%>">
  <tr> 
      <td height="17" colspan="3" align="center" class="arial12Bold">Lotes - Chave 
        de Acesso</td>
  </tr>
  <tr> 
      <td colspan="3" align="center">Modelo Etiqueta 
        <select name="cod_etiqueta" class="textbox250" onChange="formulario.submit();">
          <%
		 Dim objConn, objRS, strSQL
		 strSQL = " SELECT COD_ETIQUETA, FABRICANTE, MODELO, NRO_LINHAS, NRO_COLUNAS FROM tbl_ETIQUETA ORDER BY FABRICANTE, MODELO"		 
		 
		 AbreDBConn objConn, CFG_DB_DADOS 

		 set objRS = objConn.execute(strSQL)	
  
	     Do While not objRS.EOF
		   Response.Write "<option value=""" & objRS("COD_ETIQUETA") & """"
    	   If CStr(Request("cod_etiqueta")) = CStr(objRS("COD_ETIQUETA")&"") Then
	         Response.Write " selected"
    	   End If
           Response.Write ">" & objRS("FABRICANTE") & " - " & objRS("MODELO") & " (" & objRS("NRO_LINHAS") & " linhas x " & objRS("NRO_COLUNAS") & " colunas)" & "</option>"
           objRS.MoveNext
         Loop

	  FechaRecordSet objRS
	  FechaDBConn objConn

		 %>
        </select>
      </td>
  </tr>
  <tr> 
    <td width="278" align="center">Imprimir a partir da posi&ccedil;&atilde;o 
      <input name="posinicial" type="text" class="textbox30" value="1" maxlength="2"></td>
    <td width="150" align="center"> <input name="dec" type="image" src="../img/seta_ant.jpg" onClick="decrementa()"> 
      &nbsp; Lote 
      <input name="var_curpage" type="text" class="arial8" value="<%=MyCurPage%>" size="4"> 
      &nbsp; <input name="inc" type="image" src="../img/seta_prox.jpg" onClick="incrementa(<%=TotalPages%>)"></td>
    <td width="212" align="center">N&ordm; P&aacute;ginas por Lote 
      <input name="var_numperpage" type="text" class="arial8" value="<%=NumPerPage%>" size="4"> 
      &nbsp; <input name="Submit2" type="submit" class="edbutton" value="Montar"></td>
  </tr>
  <tr> 
    <td align="center" colspan="3" class="arial10" height="5"></td>
  </tr>
  <tr> 
    <td height="19" colspan="3" align="right" class="arial12Bold"><a href="javascript:ImprimeChaveAcesso();" class="Tahomacinza9"><img src="../img/ico_impressora_mini.gif" border="0">imprimir</a></td>
  </tr>
  </form>
</table>
</body>
</html>
