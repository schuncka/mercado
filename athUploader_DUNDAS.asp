<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="_database/athFileTools.asp"-->
<!--#include file="_database/athUtils.asp"-->
<!--#include file="_database/athDbConn.asp"--> 
<!--#include file="_database/Config.Inc"-->
<%
On Error resume Next

Dim objUpload, objUploadedFile, strERRO
Dim strFORMNAME, strFIELDNAME, DIR_UPLOAD, strFUNC, strID_FILE, strMAXBYTES
Dim auxFile, strFILE, auxmappath
Dim strEXTENSAO, strEXT_ACAO, arrEXTENSAO

strERRO = ""

auxmappath   = Server.mappath(".")
strFORMNAME  = Request("var_formname")
strFIELDNAME = Request("var_fieldname")
DIR_UPLOAD   = Request("var_dir")
strID_FILE   = Request("id_file")		

strEXTENSAO  = Request("var_ext")
strEXT_ACAO  = Request("var_ext_acao")
strMAXBYTES  = Request("maxbytes")

If strEXT_ACAO = "" Then
  strEXT_ACAO = "ALLOW"
End If

If strEXTENSAO = "" Then
  strEXTENSAO = RetornaExtensaoUpload(auxmappath & DIR_UPLOAD,strEXT_ACAO)
End If
arrEXTENSAO = Split(strEXTENSAO&",",",")

'DEBUG
response.write ("auxmappath   [" & auxmappath   & "]<br>")
response.write ("DIR_UPLOAD   [" & DIR_UPLOAD   & "]<br>")
response.write ("strEXTENSAO  [" & strEXTENSAO  & "]<br>")
response.write ("strMAXBYTES  [" & strMAXBYTES  & "]<br>")
response.write ("strFIELDNAME [" & strFIELDNAME & "]<br>")
response.write ("strID_FILE   [" & strID_FILE   & "]<br>")

Set objUpload = Server.CreateObject("Dundas.Upload.2")
objUpload.UseUniqueNames = false
If IsNumeric(strMAXBYTES) and strMAXBYTES&"" <> ""  Then
  objUpload.MaxFileSize = strMAXBYTES
End If

objUpload.SaveToMemory

For Each objUploadedFile in objUpload.Files
  strFILE = strID_FILE & objUpload.GetFileName(objUploadedFile.OriginalPath)
  strFILE = LimpaNomeArquivo(strFILE)
  response.write ("strFILE: [" & strFILE & "]<br>")
  response.write ("strEXT_ACAO: [" & strEXT_ACAO & "]<br>")

  'Se a extens�o � valida OU n�o tem extensao para validar entao salva o arquivo, senao d� o aviso de erro
  'If verificaExtensao(arrEXTENSAO, objUpload.GetFileExt(objUploadedFile.OriginalPath), strEXT_ACAO) or strEXTENSAO = "" Then
  If verificaExtensao(arrEXTENSAO, objUpload.GetFileExt(strFILE), strEXT_ACAO) or strEXTENSAO = "" Then
	objUploadedFile.SaveAs auxmappath & DIR_UPLOAD & strFILE
	response.write ("objUploadedFile.SaveAs: [" & auxmappath & DIR_UPLOAD & strFILE & "]<br>")
  Else
    Select Case strEXT_ACAO
	  Case "ALLOW" 	strERRO = "Arquivo(s) permitido(s): " & strEXTENSAO
	  Case "DENY"	strERRO = "Arquivo(s) proibido(s): " & strEXTENSAO
	End Select
  End If
  strFUNC = 2
Next

Set objUpload = Nothing

If ERR.Number <> 0 Then
	strERRO = Err.Description
	strFUNC = 2
End If

response.write (strERRO)
'response.end

Response.Redirect("athUploader.asp?f=" & strFILE & "&err=" & strERRO & "&var_formname=" & strFORMNAME & "&var_fieldname=" & strFIELDNAME & "&var_func=" & strFUNC & "&var_dir=" & DIR_UPLOAD & "&id_file=" & strID_FILE & "&var_ext=" & strEXTENSAO & "&var_ext_acao=" & strEXT_ACAO & "&maxbytes=" & strMAXBYTES)
%>