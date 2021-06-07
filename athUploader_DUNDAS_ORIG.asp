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

auxmappath = Server.mappath(".")


strFORMNAME  = Request("var_formname")
strFIELDNAME = Request("var_fieldname")
DIR_UPLOAD   = Request("var_dir")
strID_FILE   = Request("id_file")		


strEXTENSAO  = Request("var_ext")
strEXT_ACAO  = Request("var_ext_acao")

If strEXTENSAO = "" Then
  strEXTENSAO = RetornaExtensaoUpload(auxmappath & DIR_UPLOAD,strEXT_ACAO)
End If

arrEXTENSAO = Split(strEXTENSAO&",",",")

If strEXT_ACAO = "" Then
  strEXT_ACAO = "ALLOW"
End If

strMAXBYTES = Request("maxbytes")

Set objUpload = Server.CreateObject("Dundas.Upload.2")
objUpload.UseUniqueNames = false
If IsNumeric(strMAXBYTES) and strMAXBYTES&"" <> ""  Then
  objUpload.MaxFileSize = strMAXBYTES
End If

objUpload.SaveToMemory


For Each objUploadedFile in objUpload.Files

  strFILE = strID_FILE & objUpload.GetFileName(objUploadedFile.OriginalPath)
  strFILE = LimpaNomeArquivo(strFILE)

  'Se a extensão é valida  OU não tem extensao para validar entao salva o arquivo, senao dá o aviso de erro
  If verificaExtensao(arrEXTENSAO, objUpload.GetFileExt(objUploadedFile.OriginalPath), strEXT_ACAO) or strEXTENSAO = "" Then
	objUploadedFile.SaveAs auxmappath & DIR_UPLOAD & strFILE
  Else
	Select Case strEXT_ACAO
	  Case "ALLOW"
		strERRO = "Arquivo(s) permitido(s): " & strEXTENSAO
	  Case "DENY"
		strERRO = "Arquivo(s) proibido(s): " & strEXTENSAO
	End Select
  End If

  strFUNC = 2
Next

Set objUpload = Nothing

If ERR.Number <> 0 Then
	strERRO = Err.Description
	strFUNC = 2
End If



Response.Redirect("athUploader.asp?f=" & strFILE & "&err=" & strERRO & "&var_formname=" & strFORMNAME & "&var_fieldname=" & strFIELDNAME & "&var_func=" & strFUNC & "&var_dir=" & DIR_UPLOAD & "&id_file=" & strID_FILE & "&var_ext=" & strEXTENSAO & "&var_ext_acao=" & strEXT_ACAO & "&maxbytes=" & strMAXBYTES)
%>