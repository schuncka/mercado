<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD_DIR|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Dim WMD_WIDTH, WMD_WIDTHTTITLES
 WMD_WIDTH = 520
 WMD_WIDTHTTITLES = 100
 ' -------------------------------------------------------------------------------

  Dim strSQL, objRS, ObjConn
  Dim strIDUSER, strIDAPP, auxSTR, arrAUX
  
  strIDAPP  = getPARAM("var_idapp")
  strIDUSER = getPARAM("var_iduser")
  AbreDBConn objConn, CFG_DB 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
function PegaIdApp()
{ window.document.location = 'direitos.asp?var_idapp=' + formdir.var_idapp.value + '&var_iduser=' + formdir.var_iduser.value; }
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Usuário - Direitos")%>
  <form name="formdir" action="DireitosExec.asp" method="post">
  <input type="hidden" name="var_iduser" value="<%=strIDUSER%>">
  <table width="100%" border="0" cellpadding="1" cellspacing="0">
    <tr> 
      <td width="170" style="text-align:right;">Usuário:&nbsp;</td>
      <td width="350">&nbsp;<%=strIDUSER%></td>
    </tr>
    <tr> 
      <td style="text-align:right;">Aplica&ccedil;&otilde;es (m&oacute;dulos):&nbsp;</td>
      <td>&nbsp;<select name="var_idapp" class="edtext" style="width:200px" onChange="PegaIdApp();">
	    <option value="">[selecione]</option>
	     <% montaCombo "STR", "SELECT DISTINCT (ID_APP) FROM SYS_APP_DIREITO ORDER BY ID_APP", "ID_APP", "ID_APP", strIDAPP %>
        </select></td>
    </tr>
	<% 
	 strSQL = "SELECT T2.ID_DIREITO FROM SYS_APP_DIREITO_USUARIO T1, SYS_APP_DIREITO T2 " &_
	          " WHERE T1.ID_USUARIO = '" & strIDUSER & "'" &_
	          "   AND T2.ID_APP = '" & strIDAPP & "' AND T1.COD_APP_DIREITO = T2.COD_APP_DIREITO"
			  
	 auxSTR = ""
	 set objRS = objConn.execute(strSQL)
	 while not objRs.EOF
	  auxSTR = auxSTR & getValue(objRS,"ID_DIREITO") & "|"
	  objRS.MoveNext
     Wend	
	 arrAux = split(auxSTR,"|")

     FechaRecordSet objRS
	 strSQL = "SELECT SAD.COD_APP_DIREITO, SAD.ID_APP, SAD.ID_DIREITO, SD.DESCRICAO " &_ 
	          "  FROM SYS_APP_DIREITO SAD, SYS_DIREITO SD " &_
	          " WHERE SAD.ID_APP = '" & strIDAPP & "' AND SAD.ID_DIREITO = SD.ID_DIREITO" &_
	          " ORDER BY SD.ORDEM"
	 set objRS = objConn.execute(strSQL)
	 while not objRs.EOF
	%>
    <tr> 
      <td width="170" style="text-align:right;"><%=getValue(objRS,"ID_DIREITO")%>:&nbsp;</td>
      <td width="350">&nbsp;
	   <input type="checkbox" id="var_direitos" name="var_direitos" value="<%=getValue(objRS,"COD_APP_DIREITO")%>" 
	     <% if ArrayIndexOf(arrAUX,getValue(objRS,"ID_DIREITO")) <>-1 then response.write "checked"%>>&nbsp;<%=getValue(objRS,"DESCRICAO")%>
	  </td>
    </tr>
	<%
	   objRS.MoveNext
     Wend	
     FechaRecordSet objRS
	%>
  </table>
</form>
<%=athEndDialog ("", "../img/bt_save.gif", "document.formdir.submit();", "", "", "", "")%>
</body>
</html>
<%
  FechaDBConn objConn
%>