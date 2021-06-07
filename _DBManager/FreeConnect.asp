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
Dim strConnectReturn, strDisConnectReturn, strSourceContext,strAC, strAU, strAP, strCM, strConnectCaption
Sub setConnectionInfo(ByVal strAction, ByVal strConnect, ByVal strUser, ByVal strPass, ByVal strCompatibility)
	Select Case UCase(strAction)
		Case "CONNECT"
			Session("ocdCompatibility") = strCompatibility
			Session("ocdSQLConnect") = strConnect
			Session("ocdSQLUser") = strUser
			Session("ocdSQLPass") = strPass
			Response.Clear()
			Response.Redirect(strConnectReturn)
			Response.End()
		Case "DISCONNECT"
			Session("ocdCompatibility") = strCompatibility
			Session("ocdSQLConnect") = ""
			Session("ocdSQLUser") = ""
			Session("ocdSQLPass") = ""
			Response.Clear()
			Response.Redirect(strDisconnectReturn)
			Response.End()
	End Select
End Sub
strConnectReturn = "FreeSchema.asp"
strDisConnectReturn = "FreeConnect.asp?nocache=" & server.urlencode(Cstr(now))
If (ocdADOConnection <> "") Then
	Response.Clear()
	Response.Redirect(strConnectReturn)
	Response.End()
End If
strAC = Session("ocdSQLConnect") 
strAU = Session("ocdSQLUser") 
strAP = Session("ocdSQLPass")
Select Case UCase(Request("Action"))
	Case "CONNECT"
		If (Request("connect") <> "") Then
			ocdnscSQLConnect = Request("connect")
		End If
		If (ocdnscSQLConnect <> "") Then
			ocdnscSQLUser = Request("user")
			ocdnscSQLPass = Request("pass")
			ocdnscCompatibility = 0
			If Request("UseTreemenu") = "" Then
			  ocdnscCompatibility = ocdnscCompatibility + ocdNoFrames 
			End If
		End If
		Call setConnectionInfo ("Connect",ocdnscSQLConnect,ocdnscSQLUser,ocdnscSQLPass,ocdnscCompatibility)
	Case "DISCONNECT"
		Call setConnectionInfo ("Disconnect",ocdnscSQLConnect,ocdnscSQLUser,ocdnscSQLPass,ocdnscCompatibility)
End Select

strConnectCaption = strConnectCaption  & (" Connect To Database")

Call WriteHeader("")

Response.Write("<center>")
Response.Write(DrawDialogBox("DIALOG_START",strConnectCaption, ""))
Response.Write("<form method=""post"" action=""")
Response.Write(Request.ServerVariables("SCRIPT_NAME"))
Response.Write(""">")
Response.Write("<table class=""DialogBoxRow"">")
Response.Write("<tr class=""DialogBoxRow""><td valign=""top"" nowrap><span class=""FieldName"">Connect&nbsp;String:</span><br><small>(Can Be DSN)</small><p></td><td valign=""top""><textarea name=""connect"" rows=""2"" cols=""35"">")
If (strAC <> "") Then
	Response.Write(Server.HTMLEncode(strAC))
End If
Response.Write("</textarea>")
Response.Write("</td></tr>")
Response.Write("<tr class=""DialogBoxRow""><td valign=""top"" align=""left""><span class=""FieldName"">User Name:</span></td><td valign=""bottom"" align=""left""><input type=""text"" class=""ConnectInput"" name=""user"" size=""35"" maxlength=""255"" value=""")
If (Request("user") <> "") Then
	Response.Write(Server.HTMLEncode(Request("user")))
ElseIf (Request("datasource") = "") Then
	Response.Write(Server.HTMLEncode(strAU))
End If
Response.Write("""></td></tr><tr class=""DialogBoxRow""><td align=""left"" valign=""top""><span class=""FieldName"">Password:</span></td><td align=""left"" valign=""bottom""><input class=""ConnectInput"" type=""Password"" name=""pass"" size=""35"" maxlength=""255"" value=""")
If (Request("pass") <> "") Then
	Response.Write(Server.HTMLEncode(Request("pass")))
ElseIf (Request("datasource") = "") Then
	Response.Write(Server.HTMLEncode(strAP))
End If
Response.Write("""></td></tr><tr class=""DialogBoxRow""><td colspan=""2"" valign=""top""><p><input type=""hidden"" name=""ocdCSSFix""><input type=""submit"" name=""Action"" class=""submit"" value=""Connect"">")
If (strAC <> "" And Request("datasource") = "") Then
	Response.Write("<input type=""submit"" class=""Submit"" name=""Action"" value=""Disconnect"">")
End If
If (Not (CBool(ocdCompatibility And ocdNoFrames) Or CBool(ocdCompatibility And ocdNoJavaScript))) Then
	Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
	Response.Write("<input type=""checkbox"" name=""UseTreeMenu""")
	If (Not (CBool(ocdnscCompatibility And ocdNoFrames) Or CBool(ocdnscCompatibility And ocdNoJavaScript))) Then
		Response.Write(" checked")
	End If
	Response.Write(">Use&nbsp;TreeMenu")
End If
Response.Write("</td></tr></table>")
Response.Write("</form>")
Response.Write(DrawDialogBox("DIALOG_END", "", ""))
Response.Write("</center>")

Call WriteFooter("")

%>