<%
'1 Click DB Free copyright 1997-2003 David Kawliche, AccessHelp.net

'1 Click DB Free source code is protected by international
'laws and treaties.  Never use, distribute, or redistribute
'any software and/or source code in violation of its licensing.

'See License.txt for Open Source License
'More info online at http://1ClickDB.com/
'Email inquiries to info@1ClickDB.com
        
'**Start Encode**

' Begin Include Logic
Option Explicit

Response.Buffer = True
Response.Clear

'Declare constants for ocdCompatibility bitmap
Const ocdNoFrames = 1
Const ocdNoCookies = 16
Const ocdNoJavascript = 256

'Declare global configuration variables for FreeConfig.asp
Dim ocdFormNullToken, ocdQuotePrefix, ocdQuoteSuffix, ocdBrandText, ocdBrandLogo, ocdDBTimeout, ocdShowCheckedSearchFields, ocdForceExportDownload, ocdReadOnly, ocdDisableTextDriver, ocdAdminPassword, ocdUseCustomEditPages, ocdMultipleFieldSort, ocdAllowExport, ocdHeaderHTML, ocdMaxURLLength, ocdDefaultTextCompare, ocdSessionTimeout, ocdShowDefaults,  ocdFooterHTML, ocdADOConnection, ocdADOUsername, ocdADOPassword, ocdShowRelatedRecords, ocdSelectForeignKey, ocdCompatibility, ocdComputeTimeOut, ocdHomeAddress, ocdGridHighlightSelected, ocdDebug, ocdCodePage, ocdCharset, ocdStyleSheet, ocdPageSizeDefault, ocdSessionLCID, ocdMotif, ocdUseFrameset, ocdDefaultMotif, ocdIsODBC, ocdMaxRecordsRetrieve, ocdMaxRecordsDisplay, ocdServerScriptTimeout, ocdUseRegExKeywordSearch, ocdConnectURL, ocdMaxRelatedValues, ocdShowSQLText, ocdRenderAsHTML, ocdGridIcons

Call SetGlobalDefaults()

%>
<!--#INCLUDE FILE=FreeConfig.asp-->
<%

'Declare global system variables
Dim ocdPageName, ocdDatabaseType, ocdIsHome, ocdAppVersion, ocdTargetConn, ocdnscSQLConnect, ocdnscSQLUser, ocdnscSQLPass, ocdnscCompatibility

If not ocdDebug Then
	On Error Resume Next 
End If

Call init()

'End Include Logic

'Begin Include Functions

Sub init()
	ocdAppVersion = "4.303327"
	ocdPageName = mid(Request.ServerVariables("PATH_INFO"),instrRev(Request.ServerVariables("PATH_INFO"),"/") + 1)
	Server.ScriptTimeout = ocdServerScriptTimeout
	'BEGIN SESSION CHECKS
	If Not CBool(ocdCompatibility And ocdNoCookies) Then
		ocdUseFrameset = False
		Select Case CStr(request.servervariables("server_software"))
			Case "Microsoft-IIS/5.0", "Microsoft-IIS/5.1"
				Session.CodePage = ocdCodePage
		End Select
		Session.Timeout = ocdSessionTimeout
		If ocdSessionLCID = 0 Then
			ocdSessionLCID = Session.LCID
		Else
			Session.LCID = ocdSessionLCID
		End If
		If ocdAdminPassword <> "" Then		  'Check for session password
			If Session("ocdAdminAuthorized") = "" And UCASE(ocdPageName) <> "FREELOGON.ASP" And UCase(ocdPageName) <> "FREEHELP.ASP" Then
				Session("ocdSQLConnect") = ""
				Session("ocdSQLUser") = ""
				Session("ocdSQLPass") = ""
				Session("ocdCompatibility") = ""
				If UCASE(ocdPageName) = "FREECONNECT.ASP" Then
					Response.Redirect("FreeLogon.asp")
				Else
					Response.Redirect("FreeLogout.asp")
				End If
			End If
		End If
		Select Case UCase(ocdPageName)
			Case "FREEFRAME.ASP"
				If request.Form("ocdMotif") <> "" Then
					ocdMotif = Request.Form("ocdMotif")
				Else
					If Session("ocdMotif") = "" Then
						ocdMotif = ocdDefaultMotif
					Else
						ocdMotif = Session("ocdMotif")
					End If
				End If
		Case Else
			If Session("ocdMotif") = "" Then
				ocdMotif = ocdDefaultMotif
			Else
				ocdMotif = Session("ocdMotif")
			End If
		End Select
		Session("ocdMotif") = ocdMotif
		Select Case UCase(ocdMotif)
			Case "CLASSIC", ""
				ocdStyleSheet = "ocdStyleSheet.css"
			Case "NIGHT"
				ocdStyleSheet = "ocdStyleSheetNight.css"
			Case "AUTUMN"
				ocdStyleSheet = "ocdStyleSheetAutumn.css"
			Case "SOFT BLUE"
				ocdStyleSheet = "ocdStyleSheetSoftBlue.css"
			Case "SYSTEM"
				ocdStyleSheet = ""
		End Select
	End If
	If ocdADOConnection <> "" Then
		ocdnscSQLConnect = ocdADOConnection
		ocdnscSQLUser = ocdADOUsername
		ocdnscSQLPass = ocdADOPassword
		ocdnscCompatibility = ocdCompatibility
		If UCASE(ocdPageName) = "FREECONNECT.ASP" Then
			Response.Redirect("FreeSchema.asp")
		End If
	Else
		ocdnscSQLConnect = Session("ocdSQLConnect")
		ocdnscSQLUser = Session("ocdSQLUser")
		ocdnscSQLPass = Session("ocdSQLPass")
		If Session("ocdCompatibility") = "" Then
		Session("ocdCompatibility") = 0
		End If
		ocdnscCompatibility = Session("ocdCompatibility")
	End If
	'END SESSION CHECKS
	If Request.ServerVariables("LOCAL_ADDR") = ocdHomeAddress Then
		ocdIsHome = True
		ocdDisableTextDriver = True
	Else
		ocdIsHome = False
	End If
	If (ocdBrandText = "") Then
		ocdBrandText = "1 Click DB Free "
	End If
	If (ocdBrandLogo = "") Then
		ocdBrandLogo = ocdBrandLogo & "<span class=""information"">1 Click DB Free</span>"
	End If
	If Not CBool(ocdnscCompatibility And ocdNoFrames) Then
		ocdUseFrameset = True
	End If 
	If ocdFooterHTML = "" Then
		ocdFooterHTML = ("Thanks to AccessHelp.net - by Athenas ")
	End If 
	'Set Response.Headers
	'Prevent pages from being cached, disable for browse exports to overcome SSL incompatibility
	Response.Charset = ocdCharset
	If UCASE(ocdPageName) <> "FREEBROWSE.ASP" Or (UCASE(ocdPageName) = "FREEBROWSE.ASP" And Request.QueryString("ocdExportFormat_A") = "") Then
		Response.Expires = 0
		Response.ExpiresAbsolute = Now() - 1
		Call Response.addHeader("pragma", "no-cache")
		Call Response.addHeader("cache-control", "private")
		Response.CacheControl = "no-cache"
	Else	   'just set longer timeout for exports
	End If
	'End set Response.headers
	ocdQuotePrefix = """"
	ocdQuoteSuffix = """"
	If ocdnscCompatibility = "" Then
		ocdnscCompatibility = 0
	End If
	Select Case UCASE(ocdPageName)
		Case "FREECONNECT.ASP"
		Case "FREEBROWSE.ASP", "FREESCHEMA.ASP", "MTMFREECODE.ASP", "FREEEDIT.ASP"		'need to know DB Properties
			If ocdnscSQLConnect = "" Then
				Response.Clear
				If ocdUseFrameset Or CBool(ocdCompatibility And ocdNoCookies) Then
					Response.Redirect("FreeLogout.asp")
				Else
					Response.End
					Response.Redirect("FreeConnect.asp")
				End If
			End If
			Set ocdTargetConn = server.CreateObject("ADODB.Connection")
			ocdTargetConn.Mode = 1 'adMode
			Call ocdTargetConn.Open(ocdnscSQLConnect, ocdnscSQLUser, ocdnscSQLPass)

			If err <> 0 Then
				Call WriteHeader("NOCONNECT")
				Call WriteFooter("")
			End If

			'AQUI DEBUG
			'response.write ( UCASE(ocdTargetConn.Properties("DBMS Name")) )
			'response.end
			Select Case UCASE(ocdTargetConn.Provider)
				Case "ADSDSOOBJECT"
					ocdDatabaseType = "ADSI"
				Case Else
					Select Case UCASE(ocdTargetConn.Properties("DBMS Name"))
						Case "MS SQL SERVER", "MICROSOFT SQL SERVER"
							ocdDatabaseType = "SQLServer"
						Case "MYSQL"
							ocdDatabaseType = "MySQL"
							ocdQuoteSuffix = "`"
							ocdQuotePrefix = "`"
						Case "MS JET", "ACCESS"
							ocdDatabaseType = "Access"
							ocdQuoteSuffix = "]"
							ocdQuotePrefix = "["
						Case "TEXT"
							If ocdDisableTextDriver Then
								Call WriteHeader("")
								Call WriteFooter("Text Driver Disabled")
								Response.end()
							End If
						Case Else
							If instr(UCASE(ocdTargetConn.Properties("DBMS Name")), "ORAC") = 0 Then
								ocdDatabaseType = "Unknown"
							Else
								ocdDatabaseType = "Oracle"
							End If
					End Select
			End Select
			ocdFooterHTML = ocdFooterHTML & " (" & ocdDatabaseType & ")"

			If ocdTargetConn.Provider = "MSDASQL.1" Then
				ocdIsODBC = True
		End If
	End Select
End Sub

Sub WriteHeader(ByVal ocdAppStatus)

	Response.Write("<!DOCTYPE html PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
	Response.Write(vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF & vbCRLF)
	Response.Write("<html><head>" & vbCRLF & "<meta http-equiv=""Expires"" content=""Thu, 01 Dec 1994 16:00:00 GMT"">" & vbCRLF & "<meta http-equiv=""Pragma"" content=""no-cache"">" & vbCRLF & "<meta http-equiv=""Content-Type"" content=""text/html; charset=" & ocdCharSet & """>" & vbCRLF)
	If UCase(ocdPageName) = "FREECONNECT.ASP" Then
		Response.write ("<meta http-equiv=""Page-Enter"" content=""RevealTrans(Duration=.1,Transition=12)"">") & vbCRLF
	End If
	Response.Write("<title>" & ocdBrandText & " @ http://" & Request.Servervariables("SERVER_NAME") & "</title>" & vbCRLF)
	Response.Write("<link rel=""stylesheet"" type=""text/css"" href=""" & ocdStyleSheet & """>" & vbCRLF)
	Select Case UCase(ocdPageName)
		Case "FREECONNECT.ASP"
		Case Else
			If Not CBool(CInt(ocdnscCompatibility) And ocdNoJavaScript) Then
				Response.Write("<script type=""text/javascript"" language=""JavaScript"">" & vbCRLF)
				Response.Write("  <!--" & vbCRLF)
				Response.Write("    function ocdstopError() {" & vbCRLF)
				Response.Write("	    return true;" & vbCRLF)
				Response.Write("    }" & vbCRLF)
				Response.Write("    window.onerror = ocdstopError;" & vbCRLF)
				If ((UCase(ocdPageName) = "FREEBROWSE.ASP" And UCase(Request.QueryString("ocdGridMode_A")) <> "FILTER" And UCase(Request.QueryString("ocdGridMode_A")) <> "BUSCA" And UCase(Request.QueryString("ocdGridMode_A")) <> "PROCESS")) Then
					Response.Write("	function FinishLoad() {" & vbCRLF)
					Response.Write("		if (document.all) {" & vbCRLF)
					Response.Write("			document.all.loading.style.visibility = 'hidden';" & vbCRLF)
					Response.Write("		}" & vbCRLF)
					Response.Write("		}" & vbCRLF)
				End If
				Response.Write("  // -->" & vbCRLF)
				Response.Write("</script>" & vbCRLF)
			End If
	End Select
	Response.Write("</head>" & vbCRLF )
	If ((UCase(ocdPageName) = "FREEBROWSE.ASP" And UCase(Request.QueryString("ocdGridMode_A")) <> "FILTER" And UCase(Request.QueryString("ocdGridMode_A")) <> "BUSCA" And UCase(Request.QueryString("ocdGridMode_A")) <> "PROCESS")) And (Not CBool(CInt(ocdnscCompatibility) And ocdNoJavaScript)) Then

		Response.Write("<body onload=""javascript:FinishLoad()"" ")
		Response.Write(">")
		Response.Write("<script type=""text/javascript"" language=""JavaScript"">" & vbCRLF)
		Response.Write("  <!--" & vbCRLF)
		Response.Write("	if (document.all) {" & vbCRLF)
		Response.Write("		document.write('<div id=""loading"" onclick=""FinishLoad()""><table class=""Loading""><tr><td align=""center"" valign=""middle"" nowrap><span class=""Information"">")
		Response.Write("Buscando dados...")
		Response.Write("<\/span><\/td> <\/tr><\/table><\/div>');" & vbCRLF)
		Response.Write("	}" & vbCRLF)
		Response.Write("  // -->" & vbCRLF)
		Response.Write("</script>" & vbCRLF)
	Else
		Response.Write("<body>" & vbCRLF)
	End If
	If Not ocdUseFrameset or UCASE(ocdPageName) = "FREECONNECT.ASP" or UCASE(ocdPageName) = "FREELOGON.ASP"Then
		Call WriteTopMenu()
		Response.Write(vbCRLF & "<hr>" & vbCRLF)
	End If
End Sub

Sub WriteFooter(ByVal ocdAppStatus)
	Select Case ocdAppStatus
		Case ""
			Select Case Err.number
				Case 0
				Case Else
					Response.Write(DrawDialogBox("Aviso", "Processando Requisição", "<p><span class=""warning"">" & CStr(err.number) & "&nbsp;&nbsp;" & CStr(err.description) & "</span></p><p>Use o botão voltar de seu navegador para continuar ou tente enviar sua requisição novamente."))
			End Select
		Case Else
			Response.Write(DrawDialogBox("Aviso", "Processando Requisição", "<p>" & ocdAppStatus & "</p><p>Use o botão voltar de seu navegador para continuar."))
	End Select
	Response.Write("<p align=""left"">")
	Response.Write(ocdFooterHTML)
	Response.Write("</p>")
	Response.Write("</body></html>")
	Response.Flush()
	On Error Resume Next
	ocdTargetConn.Close
	set ocdTargetConn = Nothing
	Response.End()
End Sub
Sub WriteTopMenu()
	Dim strATarget, strBTarget
	strATarget = "_self"
	strBTarget = "_self"
	Response.Write("<table border=""0"" id=""Table1""><tr><td valign=""middle"">&nbsp;</td>")
	If (ocdAdminPassword <> "") Then
		Response.Write("<td valign=""middle""><a href=""FreeLogon.asp""><img src=""appStart.gif"" border=""0"" width=""18"" height=""18"" alt=""Start""></a></td><td valign=""middle""><a class=""Menu"" href=""FreeLogon.asp"">Start</a></td><td>&nbsp;</td>")
	End If
	If ocdADOConnection = "" And UCase(ocdPageName) <> "FREELOGON.ASP" Then
		Response.Write("<td valign=""middle""><a href=""FreeConnect.asp"" target=""" & strATarget & """><img src=""AppConnect.gif"" border=""0"" width=""18"" height=""18"" alt=""Conecta ao Banco de Dados""></a></td><td valign=""middle""><a class=""Menu"" href=""FreeConnect.asp"" target=""" & strATarget & """>Conectar</a></td><td>&nbsp;</td>")
	End If
	If UCase(ocdPageName) <> "FREECONNECT.ASP" Then
		If ocdnscSQLConnect <> "" Then
			Response.Write("<td valign=""middle""><a href=""FreeSchema.asp?show=tables""><img src=""AppTable.gif"" border=""0"" width=""18"" height=""18"" alt=""Tables""></a></td><td valign=""middle""><a class=""Menu"" href=""FreeSchema.asp?show=tables"">Tabelas</a></td><td>&nbsp;</td><td valign=""middle""><a href=""FreeSchema.asp?show=views""><img src=""AppView.gif"" border=""0"" width=""18"" height=""18"" alt=""Consultas""></a></td><td valign=""middle""><a class=""Menu"" href=""FreeSchema.asp?show=views"">Consultas</a></td>")
		End If
	End If
	Response.Write("<td align=""right"" width=""100%"" nowrap>" & ocdBrandLogo & "</td></tr></table>")
End Sub

Function DrawDialogBox(ByVal strType, ByVal strCaption, ByVal strInfo)
	Dim strTemp
	strTemp = "<table width=""50%"" class=""DialogBox""><tr><th class=""DialogBoxHeader"" nowrap align=""left"">" & strCaption & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th><tr class=""DialogBoxRow""><td valign=""top"">"
	Select Case UCASE(strType)
		Case "WARNING"
			strTemp = strTemp & "<table><tr><td valign=""top""><img src=""AppWarning.gif"" border=0 alt=""Aviso""></td><td>&nbsp;</td><td valign=""top"">"
			strTemp = strTemp & strInfo
			strTemp = strTemp & "</td></tr></table></td></tr></table>"
		Case "DIALOG_START"
		Case "DIALOG_END"
			strTemp = "</td></tr></table>"
		Case Else
			strTemp = strTemp & strInfo
			strTemp = strTemp & "</td></tr></table>"
	End Select
	DrawDialogBox = strTemp
End Function

Sub SetGlobalDefaults()
	'initialize defaults for global variables
	ocdMaxRelatedValues      = 1000
	ocdSessionLCID           = 0
	ocdDefaultMotif          = "Classic"
	ocdMaxRecordsRetrieve    = 10000
	ocdMaxRecordsDisplay     = 1000
	ocdServerScriptTimeout   = 120
	ocdUseRegExKeywordSearch = False
	ocdForceExportDownload   = True
	ocdConnectURL            = "FreeConnect.asp"
	ocdShowSQLText           = False
	ocdRenderAsHTML          = False
	ocdGridIcons             = True
	ocdDebug                 = False
End Sub
'End Include Functions
%>