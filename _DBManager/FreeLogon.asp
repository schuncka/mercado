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
If (ocdAdminPassword = "") Then
	Response.Clear()
	Response.Redirect(ocdConnectURL)
	Response.End()
End If
Dim arrPasswords, elePassword
arrPasswords = Split(ocdAdminPassword,",")
If ocdAdminPassword = ""  Then
	Response.Clear()
	Response.Redirect(ocdConnectURL)
	Response.End()
End If
arrPasswords = Split(ocdAdminPassword,",")
Select Case UCase(Request("Action"))
	Case "LOGON", ""
		If (Request.Form <> "") Then
			For Each elePassword In arrPasswords
				If (Request.Form("AdminPassword")) = elePassword then
					Session("ocdAdminAuthorized") = "True"
					Response.Clear()
					Response.Redirect(ocdConnectURL)
					Response.End()
				End If
			Next
		End If
	Case "LOGOUT"
		Session("ocdAdminAuthorized") = ""
		Session("ocdSQLConnect") = ""
		Session("ocdSQLUser") = ""
		Session("ocdSQLPass") = ""
		Session("ocdCompatibility") = ""
		Response.Clear()
		Response.Redirect(ocdPageName)
		Response.End()
End Select
Call WriteHeader("")
Session("ocdAppInit") = True
Response.Write("<center><form method=post action=""")
Response.Write(Request.ServerVariables("SCRIPT_NAME"))
Response.Write("?")
Response.Write(server.urlencode(request.querystring("datasource")))
Response.Write("""")
Response.Write(" target=""_top""")
Response.Write(">")
Response.Write(DrawDIalogBox("DIALOG_START","Please Logon",""))
Response.Write("<table cellspacing=""3"" cellpadding=""3"">")
If (Request.Form <> "") Then
	Response.Write("<tr><td colspan=""2""><p><span class=""Warning""><img src=""appWarningSmall.gif"" alt=""Warning""> Incorrect Password</span></p></td></tr>")
End If
Response.Write("<tr><td>")
Response.Write("<span class=""FieldName"">Authorization:</td><td>")
Response.Write("Admin")
Response.Write("</td></tr>")
Response.Write("<tr><td align=""left"" valign=""top""><strong>Password:</strong></td><td align=""left"" valign=""bottom""><input type=""Password"" name=""adminpassword"" size=""35"" maxlength=""255"" value=""")
If (Request("pass") <> "") Then
	Response.Write(Server.HTMLEncode(Request("pass")))
End If
Response.Write("""></td></tr>")
Response.Write("<tr><td colspan=""2"" valign=""top""><p><input type=""submit"" name=""Action"" class=""Submit"" value=""Logon"">")
If Session("ocdAdminAuthorized") = "True" Then
	Response.Write("<input type=""submit"" class=""Submit"" name=""Action"" value=""Logout"">")
End If
Response.Write("</td></tr></table></td></tr></table></form></center>")
Call WriteFooter("")
%>