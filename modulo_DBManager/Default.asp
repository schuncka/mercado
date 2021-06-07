<%@ LANGUAGE = VBScript.Encode %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"-->
<%
  VerficaAcesso("ADMIN")
  VerficaAcessoOculto(Session("ID_USER"))
%> 
<%
' Except for @ Directives, there should be no ASP or HTML codes above this line
' Setting LANGUAGE = VBScript.Encode enables mixing of encoded and unencoded ASP scripts

'1 Click DB Free copyright 1997-2003 David Kawliche, AccessHelp.net

'1 Click DB Free source code is protected by international
'laws and treaties.  Never use, distribute, or redistribute
'any software and/or source code in violation of its licensing.

'See License.txt for Open Source License
'More info online at http://1ClickDB.com/
'Email inquiries to info@1ClickDB.com
        
'If you are reading this text in your web browser, please check to see if your 
'webserver is properly configured to execute ASP scripts from this directory.

'1 Click DB copyright 1997-2002 David Kawliche, AccessHelp.net

'1 Click DB technology is protected by national and international
'laws and treaties.  Never use, distribute, or redistribute
'any software and/or source code in violation of its licensing.

'Use of this software and/or source code is strictly at your own risk.
'All warranties are specifically disclaimed except as required by law.

'IMPORTANT : THIS CODE USES PASS-THROUGH SECURITY !
'
'To enforce application security, set logins and permissions
'for all web server and database users as appropriate.

'For more information see : http://1ClickDB.com
        
'**Start Encode**

On Error Resume Next
Response.Buffer = true
Response.Clear
Call Response.Redirect ("FreeConnect.asp")
Response.End
%>