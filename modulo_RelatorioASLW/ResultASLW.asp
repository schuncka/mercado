<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<%
 Dim strNOME, strCATEGORIA, strDESCRICAO, strTEXTO, strSQL, strCOD_REL
 
 strNOME      = Request("var_nome")
 strCATEGORIA = Request("var_categoria")
 strSQL       = Request("var_strParam")
 strDESCRICAO = Request("var_descricao")
 strCOD_REL   = Request("var_chavereg")

 strTEXTO = strNOME
 If strCATEGORIA <> "" Then
	strTEXTO = strTEXTO & "  ( " & strCATEGORIA & " )"
 End If

 'Response.Write("strCOD_REL:" & strCOD_REL & "<br>")

 'Response.Write("** strSQL: <br>" & Request("var_strParam")& "<br>")
 'Response.Write("strSQL:" & strSQL & "<br>")
 'Response.End
%>
<html>
<head>
<title>ASLW</title>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style>
html, body {
	height: 100%;
	}

#tudo {
	min-height: 100%;
	}

* html #tudo {
	height: 100%; /* hack para IE6 que trata height como min-height */
	}

#topo {
	position: absolute;
	top: 0;
	width: 100%;
	}
	
#conteudo {
	padding-top: 30px;
	padding-bottom: 30px;
	}
	
#rodape {
	position: absolute;
	bottom: 0;
	width: 100%;
	}
</style>
<script language="JavaScript" type="text/JavaScript">
function Executa() {
	if ((document.formacao.var_acao.value == 'printall') || (document.formacao.var_acao.value == 'printthis')) {
		window.frames['frm_resulaslw_detail'].focus();
		window.frames['frm_resulaslw_detail'].print();
	}
	else {
		document.formacao.action = 'ResultASLW_Detail.asp';
		document.formacao.submit();
	}
}

function adjustWindow() {
var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
//  alert(h);
  document.getElementById('frm_resulaslw_detail').height = h-80;
}

</script>
</head>
<body bgcolor="#F7F7F7" leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0" onResize="adjustWindow();" onLoad="adjustWindow(); Executa(); return false;">
<div id="tudo">
  <div id="topo">
    <table width="99%" height="30" cellpadding="0" cellspacing="2" border="0" bgcolor="#F7F7F7">
        <tr>
            <td><div style="padding-left:10px;padding-top:3px"><b><%=strTEXTO%></b></div></td>
        </tr>
    </table>
    </div>
  <div id="conteudo">
    <iframe frameborder="1" name="frm_resulaslw_detail" id="frm_resulaslw_detail" src="ResultASLW_Detail.asp" width="99%" height="100%"></iframe>
    </div>
    <div id="rodape">
    <table width="99%" height="30" cellpadding="0" cellspacing="0" border="0" bgcolor="#F7F7F7">
     <tr>
       <td valign="middle">&nbsp;</td>
       <td width="30" align="right" valign="middle"><img src="../img/PrintExport.gif" width="35" height="23" align="middle"></td>
       <td width="190" align="right" valign="middle">
        <form name="formacao" action="ResultASLW_Detail.asp" method="post" target="frm_resulaslw_detail">
            <input type="hidden" value="<%=strSQL%>" name="var_strParam">
            <input name="var_chavereg" type="hidden" value="<%=strCOD_REL%>">
         <select name="var_acao" onChange="javascript:Executa();" class="textbox180">
           <option value="" selected>Selecione...</option>
           <option value="printall">Imprimir tudo</option>
           <option value="printthis">Imprimir esta p&aacute;gina</option>
           <option value=".xls">Exportar para Excel</option>
           <option value=".doc">Exportar para Word</option>
         </select>
        </form>
       </td>
     </tr>
    </table>
    </div>
</div>
</body>
</html>
