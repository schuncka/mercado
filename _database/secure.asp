<%
Dim strSECURE_PATH_CLIENTE

If Session("ID_USER") = "" Or Session("COD_EVENTO") = "" Then
	strSECURE_PATH_CLIENTE = Request.Servervariables("SCRIPT_NAME")
	strSECURE_PATH_CLIENTE = right(strSECURE_PATH_CLIENTE,len(strSECURE_PATH_CLIENTE)-1)
	strSECURE_PATH_CLIENTE = left(strSECURE_PATH_CLIENTE,instr(strSECURE_PATH_CLIENTE,"/")-1)	
%>
<script language="javascript">
<!--
function goLogin() {
	window.top.location='<%="http://"&Request.ServerVariables("HTTP_HOST")&"/"&strSECURE_PATH_CLIENTE%>';
}
//-->
</script>
<br />
<br />
<center><a href="javascript:void(0);" onClick="goLogin()">Sessão expirada.<br /> Por favor faça um novo login, clique aqui.</a></center>
<br />
<br />
<%
	Response.End()
'      Response.Redirect("../default.asp")
End If                                                                        
%>
