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
<html>
	<head>
		<title><%=ocdBrandText%></title>
		<link rel=stylesheet type="text/css" href="<%=ocdStyleSheet%>">
	</head>
<body>
	<p>
		Sua <%=ocdBrandText%> sess�o expirou.
	</p>
	<p>
		<a href="FreeConnect.asp" target="_parent">Clique aqui para continuar.</a>
	</p>
</body>
</html>

