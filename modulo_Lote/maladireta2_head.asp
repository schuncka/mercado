<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<%
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
function ImprimeMala() {
  window.parent.frames['frm_maladetail'].focus();
  window.parent.frames['frm_maladetail'].print();
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="640" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="2" align="center" class="arial10">&nbsp;</td>
  </tr>
  <tr> 
    <td height="17" colspan="2" align="center" class="arial12Bold">Lotes - Etiquetas</td>
  </tr>
  <tr> 
    <form name="form1" method="post" action="maladireta_body.asp" target="frm_maladetail">
      <input name="var_chavereg" type="hidden" value="<%=strCOD_LOTE%>">
      <td colspan="2" align="center">Modelo Etiqueta 
        <select name="cod_etiqueta" class="textbox250" onChange="form1.submit();">
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
        &nbsp;&nbsp;&nbsp;&nbsp; Imprimir a partir da posi&ccedil;&atilde;o 
        <input name="posinicial" type="text" class="textbox30" id="posinicial" value="1" maxlength="2">
        &nbsp;&nbsp; <input name="Submit" type="submit" class="edbutton" value="Montar"> 
      </td>
    </form>
  </tr>
  <tr> 
    <td align="right" class="arial12Bold">&nbsp;</td>
    <td align="right" class="arial12Bold"><a href="javascript:ImprimeMala();" class="Tahomacinza9">imprimir</a></td>
  </tr>
</table>
</body>
</html>
