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
<!--#INCLUDE FILE=ocdFunctions.asp-->
<%
'on error goto 0
If err.number <> 0 Then
	Response.Write err.description
	Response.Write err.number
	Response.End
End If
Dim strMTMFooter, intMCount, strMName, strSQLFrom, rsSchema, intI, arrSchema, strSQLFromName, strMTMenuText
Dim arrSchemaFields (2) 
strMTMFooter = "<form target=\""_parent\"" action=\""FreeFrame.asp\"" method=\""post\""><p align=\""center\"">Estilo : <select onchange=\""document.forms[0].submit();\"" name=\""ocdMotif\""><option value=\""Classic\"" "
Select Case UCase(ocdMotif)
	Case "","CLASSIC"
		strMTMFooter = strMTMFooter & " selected"
End Select
strMTMFooter = strMTMFooter & ">Classic</option><option value=\""Autumn\"" "
if UCASE(ocdMotif) = "AUTUMN" Then
	strMTMFooter = strMTMFooter & " selected"
End If
strMTMFooter = strMTMFooter & ">Autumn</option><option value=\""Night\"" "
if UCASE(ocdMotif) = "NIGHT" Then
	strMTMFooter = strMTMFooter & " selected"
End If
strMTMFooter = strMTMFooter & ">Night</option><option value=\""System\"" "
if UCASE(ocdMotif) = "SYSTEM" Then
	strMTMFooter = strMTMFooter & " selected"
End If
strMTMFooter = strMTMFooter & ">None</option></select></p><p align=\""center\""><a href=\""MTMFREECODE.ASP\"" target=\""code\"" class=\""Menu\"">Atualizar Menu</a></p></form>"
if ocdnscSQLConnect = "" Then
	Response.Write "Sem Conexão"
	Response.End
End If
if err <>0 then
	Response.Write err.description '"Could not connect to database.  <A HREF=connect.asp target=_parent>Click here to continue.</a>"
	Response.End
End If
'strMTMenuText = "<a href=FreeConnect.asp target=_parent class=menu>"
'		strMTMenuText = strMTMenuText & "Connect"
'strMTMenuText = strMTMenuText  & "</a>"
if ocdDatabaseType = "Oracle" Then
	set rsSchema = ocdTargetConn.execute ("SELECT OBJECT_TYPE AS TABLE_TYPE, OBJECT_NAME AS TABLE_NAME, OWNER AS TABLE_SCHEMA FROM ALL_OBJECTS WHERE (OBJECT_TYPE = 'TABLE' OR OBJECT_TYPE = 'VIEW') AND NOT OWNER = 'SYS' AND NOT OWNER = 'WKSYS' AND NOT OWNER = 'MDSYS' AND NOT OWNER = 'OLAPSYS' AND NOT OWNER ='CTXSYS' AND NOT OWNER='SYSTEM'")
	if err <>0 then 
		Response.clear
		Response.write err.description
		Response.Write "Não foi possível buscar as informações do banco de dados.  <A HREF=Connect.asp target=_parent>Clique aqui para continuar.</a>"	
		Response.end
	End If
	arrSchemaFields (0) = "TABLE_TYPE"
	arrSchemaFields (1) = "TABLE_NAME"
	arrSchemaFields (2) = "TABLE_SCHEMA"
	arrSchema = rsSchema.GetRows(,, arrSchemaFields )
	rsSchema.Close
	Set rsSchema = nothing
ElseIf ocdDatabaseType <> "IXS" Then
	Set rsSchema = ocdTargetConn.OpenSchema(20) 	
	If rsSchema.eof then
		redim arrSchema(2,1)
	Else
		arrSchemaFields (0) = "TABLE_TYPE"
		arrSchemaFields (1) = "TABLE_NAME"
		arrSchemaFields (2) = "TABLE_SCHEMA"
		arrSchema = rsSchema.GetRows(,, arrSchemaFields )
	End If
	rsSchema.Close
	set rsSchema = nothing
End If
ocdTargetConn.close
set ocdTargetConn = nothing
if err <> 0 then 
'	Response.clear
	response.write err.description
	Response.Write "Não foi possível buscar as informações do banco de dados.  <A HREF=Connect.asp target=_parent>Clique aqui para continuar.</a>"	
	Response.end
End If	

%>

<html>
<head>
<title><%=ocdBrandText%></title>

<script type="text/javascript" src="mtmcode.js">
</script>

<script type="text/javascript">
<!--
// Morten's JavaScript Tree Menu
// version 2.3.0, dated 2001-04-30
// http://www.treemenu.com/

// Copyright (c) 2001, Morten Wang & contributors
// All rights reserved.

// This software is released under the BSD License which should accompany
// it in the file "MTMCOPYING.TXT".  If you do not have this file you can access
// the license through the WWW at http://www.treemenu.com/license.txt

/******************************************************************************
* User-configurable options.                                                  *
******************************************************************************/

// Menu table width, either a pixel-value (number) or a percentage value.
var MTMTableWidth = "100%";

// Name of the frame where the menu is to appear.
var MTMenuFrame = "menu";

// Variable for determining how a sub-menu gets a plus-sign.
// "Never" means it never gets a plus sign, "Always" means always,
// "Submenu" means when it contains another submenu.
var MTMSubsGetPlus = "Always";

// variable that defines whether the menu emulates the behaviour of
// Windows Explorer
var MTMEmulateWE = true;

// Directory of menu images/icons
var MTMenuImageDirectory = "";

// Variables for controlling colors in the menu document.
// Regular BODY atttributes as in HTML documents.
var MTMBGColor = "#ffffff";
var MTMBackground = "";
var MTMTextColor = "#000000";

// color for all menu items
var MTMLinkColor = "#300066";

// Hover color, when the mouse is over a menu link
var MTMAhoverColor = "#990000";

// Foreground color for the tracking & clicked submenu item
var MTMTrackColor ="#000000";
var MTMSubExpandColor = "#666699";
var MTMSubClosedColor = "#666699";

// All options regarding the root text and it's icon
<%
If ocdADOConnection = "" Then
%>
var MTMRootIcon = "AppConnect.gif";
var MTMenuText = "<a href=FreeConnect.asp target=_parent class=Menu>Conectar</a>";
<%
ElseIf ocdAdminPassword <> "" Then
%>
var MTMRootIcon = "AppStart.gif";
var MTMenuText = "<a href=FreeLogon.asp target=_parent class=Menu>Início</a>";
<%
Else
%>
var MTMRootIcon = "AppDB.gif";
var MTMenuText = "Database";
<%
End If
%>
var MTMRootColor = "#000000";
var MTMRootFont = "Tahoma, Arial, sans-serif";
var MTMRootCSSize = "8pt";
var MTMRootFontSize = "-1";

// Font for menu items.
var MTMenuFont = "Tahoma, Arial, sans-serif";
var MTMenuCSSize = "8pt";
var MTMenuFontSize = "-1";

// Variables for style sheet usage
// 'true' means use a linked style sheet.
//var MTMLinkedSS = false;
//var MTMSSHREF = "style/menu.css";

var MTMLinkedSS = true;
var MTMSSHREF = "<%=ocdStyleSheet%>";

// Additional style sheet properties if you're not using a linked style sheet. 
// See the documentation for details on IDs, classes & elements used in the menu.
// Empty string if not used.
var MTMExtraCSS = "";

// Header & footer, these are plain HTML.
// Leave them to be "" if you're not using them
//var MTMHeader = "<p><a href='dbadmin.asp' target='_parent'><span class=Information>MDB Schema</span></a></p><p><span class=Information>1 Click DB Free</span></p>";
var MTMHeader = "";
//var MTMHeader = "<p><span class=Information>1 Click DB Free</span></p>";
var MTMFooter = "<%=strMTMFooter%>";

// Whether you want an open sub-menu to close automagically
// when another sub-menu is opened.  'true' means auto-close
var MTMSubsAutoClose = false;

// This variable controls how long it will take for the menu
// to appear if the tracking code in the content frame has
// failed to display the menu. Number if in tenths of a second
// (1/10) so 10 means "wait 1 second".
var MTMTimeOut = 15;

// Cookie usage.  First is use cookie (yes/no, true/false).
// Second is cookie name to use.
// Third is how many days we want the cookie to be stored.

var MTMUseCookies = false;
var MTMCookieName = "MTMCookie";
var MTMCookieDays = 3;

// Tool tips.  A true/false-value defining whether the support
// for tool tips should exist or not.
var MTMUseToolTips = true;

/******************************************************************************
* User-configurable list of icons.                                            *
******************************************************************************/

var MTMIconList = null;
MTMIconList = new IconList();

/******************************************************************************
* User-configurable menu.                                                     *
******************************************************************************/

var menu = null;
menu = new MTMenu();

//MTMenuText = "<%=strMTMenuText%>";

// Main menu.

<%

if ocdDatabaseType = "ADSI" Then
	'no tree menu
Elseif ocdDatabaseType = "IXS" Then
	Response.Write "menu.MTMAddItem(new MTMenuItem(""Scope"",""FreeBrowse.asp?sqlfrom_A=SCOPE()&sqlselect_A=doctitle,rank,write,characterization,dockeywords,filename,size,path,vpath"",""text"","""",""AppTable.gif""));" & vbCRLF
	Response.Write "menu.MTMAddItem(new MTMenuItem(""CGI Variables"", ""FreeSchema.asp?show=cgi"", ""text""));" & vbCRLF
Else
	Response.Write "menu.MTMAddItem(new MTMenuItem(""Tabelas"",""FreeSchema.asp?show=tables"",""text"","""",""AppTable.gif""));" & vbCRLF
	Response.Write "menu.MTMAddItem(new MTMenuItem(""Consultas"",""FreeSchema.asp?show=views"",""text"","""",""AppTable.gif""));" & vbCRLF
	'//Response.Write  vbCRLF & "menu.MTMAddItem(new MTMenuItem(""Ajuda Online"", ""http://1ClickDB.com/support/"", ""_blank"","""",""AppHelpSmall.gif""));" & vbCRLF

	Response.Write vbCRLF & "var tablelist = null;" & vbCRLF
	Response.Write vbCRLF & "tablelist = new MTMenu();" & vbCRLF
	If ocdDataBaseType = "SQLServer" or ocdDatabaseType = "Oracle" Then
		for intI = 0 to UBound( arrSchema ,2)
			if arrSchema (0, intI ) = "TABLE" and UCASE(left(arrSchema(1,intI),4)) <> "MSYS" then
				strSQLFrom = ocdQuotePrefix & arrSchema(2,intI) & ocdQUoteSuffix & "." & ocdQUotePrefix & arrSchema(1,intI) & ocdQuoteSuffix
				strSQLFromName = arrSchema(1,intI)
				Response.Write (vbCRLF & "tablelist.MTMAddItem(new MTMenuItem(""" & server.htmlencode(strSQLFromName) & """,""FreeBrowse.asp?sqlfrom_A=" & server.urlencode(strSQLFrom) & """,""text""));" & vbCRLF)
 			End If
		next
	Else
		for intI = 0 to UBound( arrSchema ,2)
			if arrSchema (0, intI ) = "TABLE" and UCASE(left(arrSchema(1,intI),4)) <> "MSYS" then
				Response.Write (vbCRLF & "tablelist.MTMAddItem(new MTMenuItem(""" & server.htmlencode( arrSchema(1,intI) ) & """,""FreeBrowse.asp?sqlfrom_A=" & server.urlencode(ocdQuotePrefix & arrSchema(1,intI) & ocdQUoteSuffix) & """,""text""));" & vbCRLF) 
			End If
		next
	End If
	Response.Write vbCRLF & "menu.items[0].MTMakeSubmenu(tablelist,"""",""AppTable.gif"",""AppTable.gif"");" & vbCRLF
	strMName = ""
	intMCount = 0
	if ocdDatabaseType = "SQLServer" Then
		for intI = 0 to UBound( arrSchema ,2)
			if arrSchema (0, intI ) = "TABLE" and UCASE(left(arrSchema(1,intI),4)) <> "MSYS" then
strMName = safename(arrSchema(1,intI))
				Response.Write vbCRLF
				strSQLFrom = ocdQuotePrefix & arrSchema(2,intI) & ocdQUoteSuffix & "." & ocdQUotePrefix & arrSchema(1,intI) & ocdQuoteSuffix
				Response.Write "var tablelist_" & strMName & " = null;" & vbCRLF
				Response.Write "tablelist_" & strMName & " = new MTMenu();" & vbCRLF
				Response.Write (vbCRLF & "tablelist_" & strMName & ".MTMAddItem(new MTMenuItem(""Buscar"",""FreeBrowse.asp?ocdGridMode_A=Busca&sqlfrom_A=" & server.urlencode(strSQLFrom) & """,""text"","""",""AppSearch.gif""));" & vbCRLF)
				If Not ocdReadOnly Then
					If ocdUseCustomEditPages Then
						Response.Write (vbCRLF & "tablelist_" & strMName & ".MTMAddItem(new MTMenuItem(""Adicionar"",""" & Replace(Replace(arrSchema(1,intI)," ","_"),"/","_") & "_FreeEdit.asp"",""text"","""",""AppNew.gif""));" & vbCRLF)
					Else
						Response.Write (vbCRLF & "tablelist_" & strMName & ".MTMAddItem(new MTMenuItem(""Adicionar"",""FreeEdit.asp?sqlfrom=" & server.urlencode(strSQLFrom) & """,""text"","""",""AppNew.gif""));" & vbCRLF)
					End If
				End If
				Response.Write "tablelist.items[" & intMCount & "].MTMakeSubmenu(tablelist_" & strMName & ","""",""AppTable.gif"",""AppTable.gif"");" & vbCRLF
				intMCount = intMCount + 1
			End If
		Next
	Else
		For intI = 0 To UBound( arrSchema ,2)
			If arrSchema (0, intI ) = "TABLE" and UCASE(left(arrSchema(1,intI),4)) <> "MSYS" Then
strMName = safename(arrSchema(1,intI))
				Response.Write vbCRLF
				Response.Write "var tablelist_" & strMName & " = null;" & vbCRLF
				Response.Write "tablelist_" & strMName & " = new MTMenu();" & vbCRLF
				Response.Write (vbCRLF & "tablelist_" & strMName & ".MTMAddItem(new MTMenuItem(""Buscar"",""FreeBrowse.asp?ocdGridMode_A=Busca&sqlfrom_A=" & server.urlencode(ocdQuotePrefix & arrSchema(1,intI) & ocdQuoteSuffix) & """,""text"","""",""AppSearch.gif""));" & vbCRLF)
				if not ocdReadOnly Then
					if ocdUseCustomEditPages Then
						Response.Write (vbCRLF & "tablelist_" & strMName & ".MTMAddItem(new MTMenuItem(""Adicionar"",""" & Replace(Replace(arrSchema(1,intI)," ","_"),"/","_") & "_FreeEdit.asp"",""text"","""",""AppNew.gif""));" & vbCRLF)
					Else
						Response.Write (vbCRLF & "tablelist_" & strMName & ".MTMAddItem(new MTMenuItem(""Adicionar"",""FreeEdit.asp?sqlfrom=" & server.urlencode(ocdQuotePrefix & arrSchema(1,intI) & ocdQuoteSuffix) & """,""text"","""",""AppNew.gif""));" & vbCRLF)
					End If
				End If
				Response.Write "tablelist.items[" & intMCount & "].MTMakeSubmenu(tablelist_" & strMName & ","""",""AppTable.gif"",""AppTable.gif"");" & vbCRLF
				intMCount = intMCount + 1
			End If
		next
	End If
	Response.Write vbCRLF & "var viewlist = null;" & vbCRLF
	Response.Write "viewlist = new MTMenu();" & vbCRLF
	If ocdDataBaseType = "SQLServer" Then
		for intI = 0 to UBound( arrSchema ,2)
			if arrSchema (0, intI ) = "VIEW" and UCASE(left(arrSchema(1,intI),4)) <> "MSYS" then
				strSQLFrom = ocdQuotePrefix & arrSchema(2,intI) & ocdQUoteSuffix & "." & ocdQUotePrefix & arrSchema(1,intI) & ocdQuoteSuffix
				strSQLFromName = arrSchema(1,intI)
				
				Response.Write (vbCRLF & "viewlist.MTMAddItem(new MTMenuItem(""" & arrSchema(1,intI) & """,""FreeBrowse.asp?sqlfrom_A=" & server.urlencode(strSQLFrom) & """,""text"",""View"", ""AppView.gif""));" & vbCRLF) 
			End If
		next
	Else
		for intI = 0 to UBound( arrSchema ,2)
			if arrSchema (0, intI ) = "VIEW" and UCASE(left(arrSchema(1,intI),4)) <> "MSYS" then
				Response.Write (vbCRLF & "viewlist.MTMAddItem(new MTMenuItem(""" & server.htmlencode(arrSchema(1,intI)) & """,""FreeBrowse.asp?sqlfrom_A=" & server.urlencode(arrSchema(1,intI)) & """,""text""));" & vbCRLF) 
			End If
		next
	End If
	Response.Write vbCRLF & "menu.items[1].MTMakeSubmenu(viewlist,"""",""AppView.gif"",""AppView.gif"");" & vbCRLF
	strMName = ""
	intMCount = 0
	If ocdDatabaseType = "SQLServer" Then
		For intI = 0 to UBound( arrSchema ,2)
			If arrSchema (0, intI ) = "VIEW" and UCASE(left(arrSchema(1,intI),4)) <> "MSYS" then
				strSQLFrom = ocdQuotePrefix & arrSchema(2,intI) & ocdQUoteSuffix & "." & ocdQUotePrefix & arrSchema(1,intI) & ocdQuoteSuffix
				strMName = safename(arrSchema(1,intI))
				Response.Write vbCRLF
				Response.Write "var viewlist_" & strMName & " = null;" & vbCRLF
				Response.Write "viewlist_" & strMName & " = new MTMenu();" & vbCRLF
				Response.Write (vbCRLF & "viewlist_" & strMName & ".MTMAddItem(new MTMenuItem(""Buscar"",""FreeBrowse.asp?ocdGridMode_A=Busca&sqlfrom_A=" & server.urlencode(strSQLFrom) & """,""text"","""",""AppSearch.gif""));" & vbCRLF)
			End If
		Next
	Else
		For intI = 0 to UBound( arrSchema ,2)
			if arrSchema (0, intI ) = "VIEW" and UCASE(left(arrSchema(1,intI),4)) <> "MSYS" then
				strMName = safename(arrSchema(1,intI))
				Response.Write vbCRLF
				Response.Write "var viewlist_" & strMName & " = null;" & vbCRLF
				Response.Write "viewlist_" & strMName & " = new MTMenu();" & vbCRLF
				Response.Write (vbCRLF & "viewlist_" & strMName & ".MTMAddItem(new MTMenuItem(""Buscar"",""FreeBrowse.asp?ocdGridMode_A=Busca&sqlfrom_A=" & server.urlencode(arrSchema(1,intI)) & """,""text"","""",""AppSearch.gif""));" & vbCRLF)
				Response.Write "viewlist.items[" & intMCount & "].MTMakeSubmenu(viewlist_" & strMName & ","""",""AppView.gif"",""AppView.gif"");" & vbCRLF
				intMCount = intMCount + 1
			End If
		next
	End If
End If	
%>
-->
</script>
</head>
<body onLoad="MTMStartMenu()" bgcolor="#ffffff" text="#000000" link="#300066" vlink="#666699" alink="#990000">
</body>
</html>

