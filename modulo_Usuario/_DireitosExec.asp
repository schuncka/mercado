<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
  Dim strSQL, objRS, ObjConn, objRSTs, strAuxSQL
  Dim strIDUSER, strIDAPP, strDIREITOS, strTODOS
  Dim auxSTR, arrAUX, arrItem  
  
  strIDAPP    = GetParam("var_idapp")
  strIDUSER   = GetParam("var_iduser")
  strDIREITOS = GetParam("var_direitos")
  strTODOS    = GetParam("var_todos")

  AbreDBConn objConn, CFG_DB 

  'AQUI: NEW TRANSACTION
  set objRSTs  = objConn.Execute("start transaction")
  set objRSTs  = objConn.Execute("set autocommit = 0")
  strAuxSQL = ""

  'Remove os direitos deste usuário (strIDUSER) para esta app (strIDAPP)
  strSQL = "DELETE FROM SYS_APP_DIREITO_USUARIO " &_
           "WHERE ID_USUARIO = '" & strIDUSER & "' AND COD_APP_DIREITO IN " &_
		   "( SELECT COD_APP_DIREITO FROM SYS_APP_DIREITO WHERE ID_APP='" & strIDAPP & "')" 
  'response.write strSQL & "<BR>"
  set objRS = objConn.execute(strSQL)
  strAuxSQL = strSQL

  'Insere os direitos marcados (strDIREITOS)
  arrAUX = split(strDIREITOS,",")
  For each arrItem in arrAUX
   strSQL = "INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) VALUES (" & trim(arrItem) & ",'" & strIDUSER & "')" 
   'response.write strSQL & "<BR>"
   strAuxSQL = strAuxSQL & vbnewline & vbnewline & strSQL
   set objRS = objConn.execute(strSQL)
  next

  set objRSTs = objConn.Execute("commit")
  athSaveLog "UPD", Request.Cookies("VBOSS")("ID_USUARIO"), "SYS_APP_DIREITO_USUARIO - " & strIDUSER, strAuxSQL

  FechaDBConn objConn
  'Para quando for chamada da Direitos.asp descomentar essa linha e comentar a parte HTML logo abaixo
  'response.redirect ("Direitos.asp?var_iduser=" & strIDUSER & "&var_idapp=" & strIDAPP)
%>
<!-- Para quando for chamada da DireitosFull.asp -->
<html>
<head>
</head>
<script>
<% If strTODOS = "T" Then %>
	window.parent.SomaIGrava();
<% Else %>
	//window.parent.Recarrega();
<% End If %>
</script>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0">
<img src="../img/IconStatus_OK.gif" border="0">
</body>
</html>