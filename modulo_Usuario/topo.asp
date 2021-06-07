<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim strNome, strData, strStatus
Dim strMes, strAno, staFirst, i

AbreDBConn objConn, CFG_DB          

strMes = month(date)
if (len(strMes)=1) then
	strMes = "0" & strMes
	staFirst = true
end if

staFirst  = false
strStatus = "REALIZADO"
strAno    = Year(Date)
strNome   = Request.Cookies("VBOSS")("ID_USUARIO")
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript">
function ExecAcao(pr_form, pr_input) {
	var form = eval("document." + pr_form + "." + pr_input);
	if (form.value=="INSERIR") { parent.frames["vbMainFrame"].document.location.href = "Insert.asp"; }
	else { parent.frames["vbMainFrame"].document.location.href = "InsertCopia.asp?var_tipo=" + form.value; }
	form.value='';
}
</script>
<script type="text/javascript" language="javascript" src="../_scripts/checkbox.js"></script>
</head>
<body onLoad="javascript:init();document.form_principal.submit();">
<table class="top_table" style="width:100%; height:58px; border:0px; margin:0px; padding:0px; vertical-align:top; border-collapse:collapse; ">
<tr> 
 	<td width="1%" class="top_menu" style="background-image:url(../img/Menu_TopBgLeft.jpg); vertical-align:top; padding:10px 0px 0px 10px;  border-collapse:collapse;">
	    <b><a href="Help.htm" target="vbMainFrame" title="sobre este módulo...">[?]&nbsp;</a>Usuários</b><br>
		<%=montaMenuCombo("form_acoes","selNome","width:120px","ExecAcao(this.form.name,this.name);","INSERIR:INSERIR;COPIAR_DIREITOS:CLONAR DIREITOS;COPIAR_ATALHOS:CLONAR ATALHOS")%>
	</td>
	<td width="1%"  class="top_middle"  style="background-image:url(../img/Menu_TopImgCenter.jpg); vertical-align:top; padding:0px; margin:0px;  border-collapse:collapse;"><img src="../img/Menu_TopImgCenter.jpg"></td>
	<td width="98%" class="top_filtros" style="background-image:url(../img/Menu_TopBgRight.jpg); vertical-align:bottom; padding:0px 5px 5px 0px; margin:0px; text-align:right; border:none; border-collapse:collapse;">
		<div class="form_line">
			<form name="form_principal" id="form_principal" method="get" action="<%=CFG_MAIN_GRID%>" target="vbMainFrame">
				<div class="form_label_nowidth">ID:</div><input name="var_id" type="text" size="20" class="edtext"> 
				<select name="var_situacao" class="edtext_combo" style="width:100px">
					<option value="ATIVO" selected>Ativo</option>
					<option value="INATIVO">Inativo</option>
				</select>
				<select name="var_grp_user" class="edtext_combo" style="width:100px">
					<option value="">[grupo]</option>
					<option value="NORMAL" selected>Normal</option>
					<option value="CLIENTE">Cliente</option>
					<option value="MANAGER">Manager</option>
					<option value="SU">SU</option>
				</select> 
				<select name="var_inicial" class="edtext_combo" style="width:60px">
					<option value="" selected>[letra]</option>
					<option value="0-9">0-9</option>
					<% 
						for i=65 to 90 'A..Z
							Response.Write("<option value='" & chr(i) & "'>" & chr(i) & "</option>")												
						next
					%>
				</select>
				<!-- Para diminuir ou eliminar a ocorrência de cahce passamso um parâmetro DUMMY com um número diferente 
				a cada execução. Isso força o navegador a interpretar como um request diferente a página,m evitando cache - by Aless 06/10/10 -->
				<input type="hidden" id="rndrequest" name="rndrequest" value="">
				<div onClick="document.form_principal.rndrequest.value=(new Date()).valueOf(); document.form_principal.submit();" class="btsearch"></div>
			</form>
		</div>
	</td>
</tr>
</table>
</body>
</html>
<%
  FechaDBConn objConn 
%>