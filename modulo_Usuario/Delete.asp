<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."
' -------------------------------------------------------------------------------

Dim objConn, objRS, strSQL 
Dim strCODIGO, Idx

strCODIGO = GetParam("var_chavereg")

If strCODIGO <> "" Then
  AbreDBConn objConn, CFG_DB 
  
  strSQL = "SELECT * FROM USUARIO WHERE COD_USUARIO = " & strCODIGO 
  Set objRS = objConn.Execute(strSQL)
  If Not objRS.Eof Then 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_delete.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Usuário - Dele&ccedil;&atilde;o")%>
<% for Idx = 0 to objRS.fields.count - 7  'NÃO QUIS EXIBIR TODOS OS DADOS... %> 
	<div class='form_label'><%=objRS.Fields(Idx).name%>:</div><div class="form_bypass"><%=GetValue(objRS, objRS.Fields(Idx).name)%></div><br>
<% next %>
<form name="form_delete" action="Delete_Exec.asp" method="post">
	<input name="var_cod_usuario" type="hidden" value="<%=strCODIGO%>">
	<input name="var_id_usuario"  type="hidden" value="<%=GetValue(objRS,"ID_USUARIO")%>">
	<input name="var_codigo"      type="hidden" value="<%=GetValue(objRS,"CODIGO")%>">
	<input name="var_tipo"        type="hidden" value="<%=GetValue(objRS,"TIPO")%>">	
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok()", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
  End If 
  FechaRecordSet objRS
  FechaDBConn objConn
End If 
%>