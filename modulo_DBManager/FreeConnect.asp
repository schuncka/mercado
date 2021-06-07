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
		Case "CONECTAR"
			Session("ocdCompatibility") = strCompatibility
			Session("ocdSQLConnect") = strConnect
			Session("ocdSQLUser") = strUser
			Session("ocdSQLPass") = strPass
			Response.Clear()
			Response.Redirect(strConnectReturn)
			Response.End()
		Case "DESCONECTAR"
			Session("ocdCompatibility") = strCompatibility
			Session("ocdSQLConnect") = ""
			Session("ocdSQLUser") = ""
			Session("ocdSQLPass") = ""
			Response.Clear()
			Response.Redirect(strDisconnectReturn)
			Response.End()
	End Select
End Sub

strConnectReturn    = "FreeSchema.asp"
strDisConnectReturn = "FreeConnect.asp?nocache=" & server.urlencode(Cstr(now))

If (ocdADOConnection <> "") Then
	Response.Clear()
	Response.Redirect(strConnectReturn)
	Response.End()
End If

strAC = Session("ocdSQLConnect") 
strAU = Session("ocdSQLUser") 
strAP = Session("ocdSQLPass")

'AQUI DEBUG
'response.Write(request.QueryString() & "<br>")
Select Case UCase(Request("Action"))
	Case "CONECTAR"
		If (Request("conectar") <> "") Then
			ocdnscSQLConnect = Request("conectar")
		End If

		If (ocdnscSQLConnect <> "") Then
			ocdnscSQLUser = Request("user")
			ocdnscSQLPass = Request("pass")
			ocdnscCompatibility = 0
			If Request("UseTreemenu") = "" Then
			  ocdnscCompatibility = ocdnscCompatibility + ocdNoFrames 
			End If
		End If
		'AQUI DEBUG
		'response.Write(ocdnscSQLConnect & "<br>")
		'response.Write(ocdnscSQLUser & "<br>")
		'response.Write(ocdnscSQLPass & "<br>")
		'response.end
		Call setConnectionInfo ("Conectar",ocdnscSQLConnect,ocdnscSQLUser,ocdnscSQLPass,ocdnscCompatibility)
	Case "DESCONECTAR"
		Call setConnectionInfo ("Desconectar",ocdnscSQLConnect,ocdnscSQLUser,ocdnscSQLPass,ocdnscCompatibility)
End Select

strConnectCaption = strConnectCaption  & (" Conecta ao Banco de Dados")

Call WriteHeader("")

Response.Write("<center>")
Response.Write(DrawDialogBox("DIALOG_START",strConnectCaption, ""))
Response.Write("<form method=""post"" action=""")
Response.Write(Request.ServerVariables("SCRIPT_NAME"))
Response.Write(""">")
Response.Write("<table class=""DialogBoxRow"">")
Response.Write("<tr class=""DialogBoxRow""><td valign=""top"" nowrap><span class=""FieldName"">String de Conexão:</span><br><small>(Aceita-se DSN)</small><p></td><td valign=""top""><textarea name=""conectar"" rows=""2"" cols=""35"">")
If (strAC <> "") Then
	Response.Write(Server.HTMLEncode(strAC))
End If
Response.Write("</textarea>")
Response.Write("</td></tr>")
Response.Write("<tr class=""DialogBoxRow""><td valign=""top"" align=""left""><span class=""FieldName"">Usuário:</span></td><td valign=""bottom"" align=""left""><input type=""text"" class=""ConnectInput"" name=""user"" size=""35"" maxlength=""255"" value=""")
If (Request("user") <> "") Then
	Response.Write(Server.HTMLEncode(Request("user")))
ElseIf (Request("datasource") = "") Then
	Response.Write(Server.HTMLEncode(strAU))
End If
Response.Write("""></td></tr><tr class=""DialogBoxRow""><td align=""left"" valign=""top""><span class=""FieldName"">Senha:</span></td><td align=""left"" valign=""bottom""><input class=""ConnectInput"" type=""Password"" name=""pass"" size=""35"" maxlength=""255"" value=""")
If (Request("pass") <> "") Then
	Response.Write(Server.HTMLEncode(Request("pass")))
ElseIf (Request("datasource") = "") Then
	Response.Write(Server.HTMLEncode(strAP))
End If
Response.Write("""></td></tr><tr class=""DialogBoxRow""><td colspan=""2"" valign=""top""><p><input type=""hidden"" name=""ocdCSSFix""><input type=""submit"" name=""Action"" class=""submit"" value=""Conectar"">")
If (strAC <> "" And Request("datasource") = "") Then
	Response.Write("<input type=""submit"" class=""Submit"" name=""Action"" value=""Desconectar"">")
End If
If (Not (CBool(ocdCompatibility And ocdNoFrames) Or CBool(ocdCompatibility And ocdNoJavaScript))) Then
	Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
	Response.Write("<input type=""checkbox"" name=""UseTreeMenu""")
	If (Not (CBool(ocdnscCompatibility And ocdNoFrames) Or CBool(ocdnscCompatibility And ocdNoJavaScript))) Then
		Response.Write(" checked")
	End If
	Response.Write(">Usar Menu Árvore")
End If
Response.Write("</td></tr></table>")
Response.Write("</form>")
Response.Write(DrawDialogBox("DIALOG_END", "", ""))
Response.Write("</center>")

Call WriteFooter("")

%>