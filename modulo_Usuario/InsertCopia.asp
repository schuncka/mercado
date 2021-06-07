<!--#include file="../_database/athdbConn.asp"--><!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn -->VerificaDireito
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Usuario",Session("METRO_USER_ID_USER")), true %>
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Efetuar a cópia de direitos de usuário. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

Dim strSQL, objRS, ObjConn
Dim strTIPO

AbreDBConn objConn, CFG_DB 

strTIPO = GetParam("var_tipo")

if InStr(strTIPO,"_") then strTIPO=mid(strTIPO,InStrRev(strTIPO,"_")+1)
strTIPO = UCase(mid(strTIPO,1,1)) & LCase(mid(strTIPO,2))
%>
<html>
<head>
<title>Mercado</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_copia.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_copia.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	if (document.form_copia.var_id_usuario_o.value != document.form_copia.var_id_usuario_d.value)
	 { document.form_copia.submit(); }
	else
	 { alert('Os usuários escolhidos devem ser distintos!'); }
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Usuário - Copiar " & strTIPO) %>
	<form name="form_copia" action="InsertCopia_Exec.asp" method="post">
	<input type="hidden" name="var_tipo"         value="<%=strTIPO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='InsertCopia.asp?var_tipo=<%=UCase(strTIPO)%>'>
	<div class='form_label'>Copiar de:</div><select name="var_id_usuario_o" size="1">
			<% montaCombo "STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO", "ID_USUARIO", "ID_USUARIO", Session("METRO_USER_ID_USER")) %>
		</select>
  	<br><div class='form_label'>Para:</div><select name="var_id_usuario_d" size="1">
			<% montaCombo "STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY ID_USUARIO", "ID_USUARIO", "ID_USUARIO", Session("METRO_USER_ID_USER")) %>
		</select>
	</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<%
  FechaDBConn objConn
%>
</body>
</html>