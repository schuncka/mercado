<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="_scripts/scripts.js"-->
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<!--#include file="_database/athUtils.asp"-->
<%
 Dim objConn, objRS, objCDO, strSQL, strBody 
 Dim strID_USER, strNome, strEMAIL, strSENHA

 strEMAIL = Trim(Request.QueryString("var_email"))
 
 AbreDBConn objConn, CFG_DB_DADOS 
	
 strSQL = "SELECT ID_USER, NOME, SENHA, EMAIL FROM tbl_USUARIO WHERE EMAIL ='" & strEMAIL  & "'" 

 set objRS = objConn.execute(strSQL)

 if not objRS.EOF then 
   strID_USER = objRS("ID_USER") 
   strSENHA   = objRS("SENHA") 
   strNome    = objRS("NOME") 
   strEMAIL   = objRS("EMAIL") 
 else  
   strEMAIL   = NULL
 end if 

 strBody = "Olá " & strNome & ","   & vbCrLf & vbCrLf  & _
           "Esta é uma mensagem automática do Sistema ProEvento. "     & vbCrLf & vbCrLf

 if ( (not IsNull(strEMAIL)) and (strEMAIL<>" ") and (strEMAIL<>"") ) then
   strBody = strBody & _
	         "Foi solicitada a senha de acesso ao sistema para o email: """ & strEMAIL & """"        & vbCrLf & vbCrLf & _
             "Estes são seus dados de acesso: "               & vbCrLf & vbCrLf & _ 
             "UserID: " & strID_USER                      & vbCrLf & _
             "Senha: "  & strSENHA                        & vbCrLf & vbCrLf
 else 
   strBody = strBody & _
	         "O email digitado (" & _
			 Trim(Request.QueryString("var_email"))& ") não foi encontrado no cadastro de usuários do sistema. "                                         & vbCrLf & vbCrLf & _
             "Sua solicitação esta sendo encaminhada para o Suporte do ProEvento, que estará entrando em contato o mais breve possível."        & vbCrLf & vbCrLf  
 end if
 
 strBody = strBody & _
           "Atenciosamente,"                                   & vbCrLf & _ 
		   "ProEvento - Content Site Manager" & vbCrLf

 ' -----------
 ' Envia email
 ' -----------
 Set objCDO = Server.CreateObject("CDONTS.NewMail")

 if strEMAIL = null then
   objCDO.To = "webmaster@athenas.com.br"
 end if

 objCDO.Bcc 	   = "webmaster@athenas.com.br"
 objCDO.From       = "suporte@proevento.com.br"
 objCDO.Subject    = "ProEvento - AthCSM"
 objCDO.Body       = strBody
 objCDO.Importance = 1 'Normal
 objCDO.Send
 Set objCDO = Nothing

 ' ---------------------------------
 ' Gravando um LOG de solicitações 
 ' ---------------------------------
 Dim filesys, testfile, strFileName, strData, auxmappath
 
 strData = now
 strFileName = Session.SessionId & "_" & year(strData) & month(strData) & day(strData) & hour(strData) & minute(strData) & second(strData)  
 Set filesys = CreateObject("Scripting.FileSystemObject") 

 auxmappath = server.mappath(".")
 auxmappath = auxmappath & "\_log\"

' Set testfile = filesys.CreateTextFile(auxmappath & strFilename & ".txt", True)
' testfile.WriteLine "-------------------------" 
' testfile.WriteLine strFileName & " - " & strData
' testfile.WriteLine "-------------------------" 
' testfile.WriteLine strBody
' testfile.WriteLine "-------------------------" 
' testfile.Close   
 
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="_css/csm.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#FFFFFF" background="img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td align="center" valign="middle">
<table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="492" height="4"><img src="img/inbox_top_blue.gif" width="492" height="4"></td>
      <td width="4" height="4"><img src="img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="492"><table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;AVISO</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="450" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <tr> 
                      <td align="center" valign="top"> <span class="Tahomacinza10"> 
                        Sua solicita&ccedil;&atilde;o foi enviada para o email 
                        digitado.<br>
                        <br>
                        Conforme os procedimentos de localiza&ccedil;&atilde;o 
                        dos dados apartir do email digitado, <br>
                        voc&ecirc; estar&aacute; recebendo nesta conta de email 
                        as informa&ccedil;&otilde;s para login no <br>
                        sistema ou nosso WebMaster estar entrando em contato em 
                        breve.</span></td>
                    </tr>
                    <!--
					<tr> 
                      <td align="left" valign="top"><%=strBody%></td>
                    </tr>
					-->
                  </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="img/inbox_bottom_blue.gif"><img src="img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="img/inbox_bottom_big3.gif"><img src="img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
</tr></td></table>
</body>
</html>

<%
 FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>


