<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, strSQL
Dim strCODIGO, strID_USUARIO

strCODIGO = GetParam("var_cod_usuario")
strID_USUARIO = GetParam("var_id_usuario")

AbreDBConn objConn, CFG_DB 

objConn.Execute("DELETE FROM USUARIO WHERE COD_USUARIO=" & strCODIGO)
objConn.Execute("DELETE FROM USUARIO_HORARIO WHERE ID_USUARIO='" & strID_USUARIO & "'")
objConn.Execute("DELETE FROM SYS_APP_DIREITO_USUARIO WHERE ID_USUARIO = '" & strID_USUARIO & "'")

strSQL = "DELETE FROM USUARIO WHERE COD_USUARIO=" & strCODIGO & vbNewLine
strSQL = strSQL & "DELETE FROM USUARIO_HORARIO WHERE ID_USUARIO='" & strID_USUARIO & "'"& vbNewLine
strSQL = strSQL & "DELETE FROM SYS_APP_DIREITO_USUARIO WHERE ID_USUARIO = '" & strID_USUARIO & "'" & vbNewLine
athSaveLog "DEL", Request.Cookies("VBOSS")("ID_USUARIO"), "USUARIO e SYS_APP_DIREITO_USUARIO", strSQL

FechaDBConn objConn
%>
<script>
   //ASSIM S� FUNCIONA NO IE (s� no IE): parent.vbTopFrame.form_principal.submit();
   //ASSIM FUNCIONA NO IE e no FIREFOX
   parent.frames["vbTopFrame"].document.form_principal.submit();
</script>