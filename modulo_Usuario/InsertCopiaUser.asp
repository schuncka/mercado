<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_USUARIO",Session("METRO_USER_ID_USER")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_info.gif:ATENÇÃO! O USUÁRIO será copiado, seus DIREITOS, HORÁRIOS  ATALHOS. Também será criada a ENTIDADE correspondente."' -------------------------------------------------------------------------------

 Dim objConn, objRS, objRSAux, strSQL
 Dim strCODIGO 

 strCODIGO = GetParam("var_chavereg")
 
 AbreDBConn objConn, CFG_DB 

 strSQL = "SELECT ID_USUARIO, NOME, EMAIL, CODIGO, TIPO, GRP_USER, OBS, SENHA, DIR_DEFAULT, ENT_CLIENTE_REF FROM USUARIO WHERE COD_USUARIO = " & strCODIGO
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 
 If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() { document.form_copia.DEFAULT_LOCATION.value = ""; document.form_copia.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_copia.JSCRIPT_ACTION.value = "";	document.form_copia.submit(); }
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Usuários - Duplicação") %>
	<form name="form_copia" action="InsertCopiaUser_exec.asp" method="post">
	<input type="hidden" name="var_cod_usuario"  value="<%=strCODIGO%>">
	<input type="hidden" name="var_id_usuario"   value="<%=GetValue(objRS,"ID_USUARIO")%>">
	<input type="hidden" name="var_tipo"         value="<%=GetValue(objRS,"TIPO")%>">
	<input type="hidden" name="var_codigo"       value="<%=GetValue(objRS,"CODIGO")%>">
	<input type="hidden" name="var_grupo"        value="<%=GetValue(objRS,"GRP_USER")%>">
	<input type="hidden" name="var_obs"          value="<%=GetValue(objRS,"OBS")%>">
	<input type="hidden" name="var_dir_default"  value="<%=GetValue(objRS,"DIR_DEFAULT")%>">
	<input type="hidden" name="var_ent_cliente_ref" value="<%=GetValue(objRS,"ENT_CLIENTE_REF")%>">	
    <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
    <input type="hidden" name="DEFAULT_LOCATION" value='InsertCopiaUser.asp?var_chavereg=<%=strCODIGO%>'>
    <div class='form_label'>ID Usuário:</div><div class="form_bypass"><%=GetValue(objRS,"ID_USUARIO")%></div>
    <br><div class='form_label'>Novo ID Usuário:</div><div class="form_bypass"><input name="var_novo_id" type="text" style="width:150px;" value="<%="COPY_"&GetValue(objRS,"ID_USUARIO")%>"></div>
    <br><div class='form_label'>Nova SENHA:</div><div class="form_bypass"><input name="var_nova_senha" type="password" style="width:100px;" value=""></div>
    <br><div class='form_label'>Novo NOME:</div><div class="form_bypass"><input name="var_novo_nome" type="text" style="width:180px;" value="<%="COPY_"&GetValue(objRS,"NOME")%>"></div>
	<br><div class="form_label">Novo E-MAIL:</div><div class="form_bypass"><input name="var_novo_email" type="text" style="width:300px;" value="<%="COPY_"&GetValue(objRS,"EMAIL")%>"></div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
 End If
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>	