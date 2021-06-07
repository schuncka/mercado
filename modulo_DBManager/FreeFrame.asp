<%@ LANGUAGE = VBScript.Encode %>
<% ' Except for @ Directives, there should be no ASP or HTML codes above this line
' Setting LANGUAGE = VBScript.Encode enables mixing of encoded and unencoded ASP scripts

'1 Click DB Free copyright 1997-2003 David Kawliche, AccessHelp.net

'1 Click DB Free source code is protected by international
'laws and treaties.  Never use, distribute, or redistribute
'any software and/or source code in violation of its licensing.

'See License.txt for Open Source License
'More info online at http://1ClickDB.com/
'Email inquiries to info@1ClickDB.com
        
'**Start Encode**
%>
<!--#INCLUDE FILE=FreeInit.asp-->
<%
Response.Write(vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF)

Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Frameset//EN"">") & vbCRLF
Response.Write("<html><head><title>")
Response.Write(ocdBrandText)
Response.Write("</title></head>")
Response.Write("<frameset bordercolor=""white"" cols=""160,*""><frameset  bordercolor=""white"" rows=""*,0""><frame src=""MTMFREEMENU_EMPTY.ASP"" name=""menu"" scrolling=""Auto"" frameborder=""0""><frame src=""MTMFREECODE.ASP"" name=""code"" scrolling=""no"" frameborder=""0""></frameset>")
If (Request("contenturl") = "") Then
	Response.Write("<frame src=""FreeSchema.asp?show=tables"" name=""text"" scrolling=""Auto"" frameborder=""1"">")
Else
	Response.Write("<frame src=""")
	Response.Write(server.htmlencode(request("contenturl")))
	Response.Write(""" name=""text"" scrolling=""Auto"" frameborder=""1"">")
End If
Response.Write("</frameset><noframes><body>Seu navegador não suporta frames <a href=""Connect.asp"">Clique aqui e escolha a opção Sem Frames para continuar</a>.</body></noframes>")
Response.Write ("</frameset>")
Response.Write("</html>")
%>
