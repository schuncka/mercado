<%
Sub RegistrarLogAcao(pObjConn, pRecurso, pChave, pTipoChave, pHistorico)

Dim sSQL
Dim sNavegador, sIp

sNavegador = Request.ServerVariables("HTTP_USER_AGENT")
sIp = Request.ServerVariables("REMOTE_ADDR")

sSQL = "insert into tbl_log_acesso (recurso, navegador, dt_insert, ip, chave, tipo_chave, cod_evento, sys_userca, sys_dataca, historico)"
sSQL = sSQL & " values ("&strToSQL(pRecurso)&","&strToSQL(sNavegador)&",NOW(),"&strToSQL(sIp)&","&strToSQL(pChave)&","&strToSQL(pTipoChave)&","&Session("COD_EVENTO")&",'"&Session("ID_USER")&"',NOW(),"&strToSQL(pHistorico)&")"

pObjConn.Execute(sSQL)

End Sub
%>