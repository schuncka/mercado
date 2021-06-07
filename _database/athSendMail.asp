<%
  ' ========================================================================
  ' SubRotina para envio de mensagem
  ' ========================================================================
Public Function ATHEnviaMail(pmTO, pmFROM, pmCC, pmBCC, pmSUBJECT, pmBODY, pmREPLY, pmBODYFORMAT, pmMAILFORMAT, pmATTACH)
Dim strFileName, arrArquivos
Dim objCDOSYSMail, objCDOSYSCon
Dim strFROM, strREPLY
Dim strSMTP_SERVER, strSMTP_USER, strSMTP_PWD, strSMTP_PORT

'Alterado em 21/10/2014 para pegar os dados de SMTP do Session atual, unificando assim a antiga função ATHEnvialEMailSMTP que passava parametros de SMTP

'CHAMADO 27242 e 28343
'Alterado em 06/11/2015 para pegar o email de retorno (REPLYTO) para cada tipo de perfil de envio: PALESTRANTE, CONGRESSISTA, CAEX, VISITANTE, PAPER

'Verifica se o paramentro novo parametro pmREPLY tem um email válido informado (substitui o antigo parametro pmIMPORTANCE
' não é usado a função Verifica_Email pois pode ser email no formato "Fulando <fulano@site.com>"
If InStr(pmREPLY,"@") > 0 and InStr(pmREPLY,".") > 0 Then
  strREPLY = pmREPLY
Else
  strREPLY = strFROM
End If

'strSMTP_SERVER = Session("SMTP_SERVER")
'strSMTP_USER   = Session("SMTP_USER")
'strSMTP_PWD    = Session("SMTP_PWD")
'strSMTP_PORT   = Session("SMTP_PORT")
'If strSMTP_PORT = "" Then
'  strSMTP_PORT = "25"
'End If
'******* comentei o codigo acima pois no localhost do servidor online só funciona o envio de emails com os dados do local host
'******* abaixo limpo o que vier nos parametros para garantir o envio
strSMTP_SERVER = ""
strSMTP_USER   = ""
strSMTP_PWD    = ""
strSMTP_PORT   = "25"

 On Error Resume Next
 
  'cria o objeto para o envio de e-mail 
  Set objCDOSYSMail = Server.CreateObject("CDO.Message") 
  'cria o objeto para configuração do SMTP 
  Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration") 
   
 ' If strSMTP_SERVER <> "" and strSMTP_USER <> "" and strSMTP_PWD <> "" and strSMTP_PORT <> "" Then
'
'	  strFROM = pmFROM
'  
'	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = strSMTP_SERVER 'SMTP
'	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = strSMTP_PORT 'porta do SMTP
'	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 'porta do CDO
'	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30  'timeout 
'	  
'	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1 'basic (clear text) authentication
'	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusername") = strSMTP_USER 
'	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendpassword") = strSMTP_PWD 
'  Else

	  strFROM  = "noreply@proeventovista.com.br"  
	  If inStr(pmFROM,"<") > 0 Then
		strFROM = Left(pmFROM ,inStr(pmFROM,"<")-1) & "<" & strFROM & ">"
	  End If

	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "localhost" 'SMTP
	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 'porta do SMTP
	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 'porta do CDO
	  objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30  'timeout 
 ' End If
  
  objCDOSYSCon.Fields.update   
  'atualiza a configuração do CDOSYS para o envio do e-mail 
  Set objCDOSYSMail.Configuration = objCDOSYSCon 
  
  'Response.Write("From: " & strFROM & "<BR>")
  'Response.Write("Reply: " & strREPLY & "<BR>")
  'Response.Write("Server: " & strSMTP_SERVER & "<BR>")
  'Response.Write("User: " & strSMTP_USER & "<BR>")
  'Response.Write("Pwd: " & strSMTP_PWD& "<BR>")
  'Response.Write("Port: " & strSMTP_PORT & "<BR>")
  
  objCDOSYSMail.From    = strFROM
  objCDOSYSMail.ReplyTo = strREPLY
  objCDOSYSMail.To      = pmTO      
  objCDOSYSMail.Cc      = pmCC      
  objCDOSYSMail.Bcc     = pmBCC     
  objCDOSYSMail.Subject = pmSUBJECT 
  If pmATTACH <> "" Then
    arrArquivos = split(pmATTACH,"|")
    For Each strFileName In arrArquivos
      objCDOSYSMail.AddAttachment(strFileName)
    Next
  End If

  'conteúdo da mensagem  
  If pmBODYFORMAT = 0 Then objCDOSYSMail.TextBody = pmBODY
  'para envio da mensagem no formato html altere o TextBody para HtmlBody 
  If pmBODYFORMAT = 1 Then objCDOSYSMail.HtmlBody = pmBODY
  objCDOSYSMail.HtmlBody = pmBODY

  'objCDOSYSMail.fields.update 
  'envia o e-mail 
  objCDOSYSMail.Send 

  'destrói os objetos 
  Set objCDOSYSMail = Nothing 
  Set objCDOSYSCon = Nothing 

'  If err.Number <> 0 Then
'    Response.Write("<html><body>Serviço de entrega de e-mail indisponível.<br> ")
'    Response.Write("<font face=courier>")
' 	 Response.Write("Erro: " & err.Description)
'    Response.Write("<br><br>Para entrar em contato conosco utilize o e-mail: <a href='noreply@proeventovista.com.br'>noreply@proeventovista.com.br</a><br><hr>")
'    Response.Write("<hr>Pedimos desculpas pelo inconveniente.</body></html>")
'	Response.End()
'  End If
  ATHEnviaMailSMTP = err.Number
End Function



%>