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
<!--#INCLUDE FILE=ocdForm.asp-->
<!--#INCLUDE FILE=ocdGrid.asp-->
<!--#INCLUDE FILE=ocdFunctions.asp-->
<%

Dim objForm, rsDef, evDef, evDefresult, hasdef, fkrelatedfield, fkrelatedtable, fldF
Dim strName, intSize, tQS, bintSize, rsFK, HasFK, intFKColumnCount, strFKColumnName
Dim strPKTables, elePKName, eleFKName, strFKTables, arrPKTables, arrFKTables
Dim prevPKTable, prevFKTable, cat, tblCat, astrTemp, keytblcat, colkeytblcat
Dim rsdefeval, arrrsdef, intrsdef, rtmpqs, intI, arrHomeField, arrfkRelatedField
Dim prevcolumn, objGrid, homefield, showrelated, intcountgrids, strSQLTName
Dim varFormNum, blnRedirectToBrowse

blnRedirectToBrowse = False
varFormNum 			= "0"
If Request.QueryString("SQLFrom") = "" Then
	Response.clear
	Response.Redirect("FreeSchema.asp"  )
End If


'React to Form events
Sub ocdOnCancel()
	If blnRedirectToBrowse Then
			Call RedirectToBrowse()
	End If
End Sub

Sub ocdBeforeUpNow()
End sub

Sub ocdAfterUpNow()
	If blnRedirectToBrowse Then
			Call RedirectToBrowse()
	End If
end sub

sub ocdBeforeInsert ()
	'not used	
End sub

sub ocdAfterInsert()
	If blnRedirectToBrowse Then
			Call RedirectToBrowse()
	End If
end sub

sub ocdAfterDelete()
	Call RedirectToBrowse()
End Sub

Sub ocdBeforeDelete()
	Call WriteHeader("")
	dim tmpeqs
	Response.Write ("<form action=""")
	Response.Write (request.servervariables("SCRIPT_NAME") & "?")
	for each tmpeqs in Request.QueryString
		if UCase(tmpeqs) <> "OCDEDITDELETE" Then
			Response.Write (tmpeqs & "=" & Server.URLEncode(Request.QueryString(tmpeqs)) & "&")
		End If
	next
	Response.Write (""" method=""post"">")
	Response.Write ("<center><TABLE WIDTH=""50%"" CLASS=""DialogBox""><tr><TH STYLE=""text-align:left;background-color:navy;color:white;"" ALIGN=LEFT><DIV STYLE=""color:white;"">Deletar</DIV></TH><tr><td BGCOLOR=Silver VALIGN=TOP>")
	Response.Write ("<TABLE><tr CLASS=DIALOGBOXROW><td VALIGN=TOP><IMG SRC=AppWarning.gif border=0 ALT=""Cuidado""></td><td>&nbsp;</td><td VALIGN=TOP><P>")
	If objForm.SQLID <> "" or objForm.SQLWHERE <> "" THen
		Response.Write ("<b>Você tem certeza que quer deletar o(s) registro(s) selecionado(s)?</b><P>Não há como desfazer essa operação.<P><INPUT TYPE=Submit SPAN CLASS=Submit Name=ocdEditConfirm Value=""OK"">&nbsp;<INPUT TYPE=submit Name=ocdEditCancel CLASS=Submit Value=""Cancelar""><INPUT TYPE=hidden Name=ocdEditCancelPage CLASS=Submit Value=""FreeBrowse.asp""><INPUT TYPE=hidden Name=ocdEditDelete CLASS=Submit Value=""Deletar""></td></tr></table></td></tr></TABLE></CENTER>")		
	Else
		Response.Write ("<b>Nenhum registro foi selecionado.</b><P>Use o botão voltar do seu navegador para continuar.</td></tr></table></td></tr></TABLE></CENTER>")		
	End If
	Response.Write ("</form>")
	Call writefooter("")
	
End Sub

Sub RedirectToBrowse()
	Dim strADURL, tmpadqs
	if Request.QueryString("SQLFROM_A") <> "" Then
		strADURL = "FreeBrowse.asp?"
		for each tmpadqs in Request.QueryString
			Select Case UCASE(tmpadqs) 
				Case "SQLFROM","SQLSELECT","SQLWHERE", "SQLID"
				Case Else
					strADURL = strADURL & tmpadqs & "=" & Server.URLEncode(Request.QueryString(tmpadqs)) & "&"
			End Select
		next
		Response.Clear
		Response.Redirect(strADURL)
	End If
End Sub

'----------------------------------------------------------------------------------------------------------------
'BEGIN MAIN CODE ------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------
Set objForm = New ocdForm
objForm.FormNullToken 		= ocdFormNullToken
objForm.MaxRelatedValues 	= ocdMaxRelatedValues
objForm.SQLConnect 			= ocdnscSQLConnect 'ADO Connect String, including uid and pw if necessary
objForm.AllowMultiDelete 	= True
objForm.SQLUser 			= ocdnscSQLUser
objForm.SQLPass 			= ocdnscSQLPass
objForm.SQLSelect 			= "*" 'Database Field List 
objForm.CallOnCancel 		= True
objForm.SQLFrom = Request.QueryString("sqlFrom")'Database Table Name
If ocdReadOnly Then
	objForm.AllowEdit	= False
	objForm.AllowAdd 	= False
	objForm.AllowDelete = False
Else
	objForm.AllowEdit 	= True
	objForm.AllowAdd 	= True
	objForm.AllowDelete = True
End If
objForm.HTMLCheckField      = "<SPAN CLASS=Warning> Check  </SPAN>"
objForm.HTMLAttribSaveBtn   = "TYPE=""Submit"" Value=""Salvar"" CLASS=""Submit"""
objForm.HTMLAttribCancelBtn = "TYPE=""Submit"" Value=""Cancelar"" CLASS=""Submit"""
objForm.HTMLAttribNewBtn    = "TYPE=""Submit"" Value=""Novo"" CLASS=""Submit"""
objForm.HTMLAttribDeleteBtn = "TYPE=""Submit"" Value=""Deletar"" CLASS=""Submit"""
objForm.Open

If (ocdDataBaseType =  "SQLServer") and Request.QueryString("ocdShowRelated") <> "Yes" Then
	ocdSelectForeignKey = false
	ocdShowRelatedRecords = false
End If

hasFK = False
select case ocdDatabaseType
	Case "Access"
		strSQLTName = CSTR(FormatForSQL(Request.QueryString("SQLFROM"), ocddatabasetype, "RemoveSQLIdentifier"))
	Case "SQLServer"
		strSQLTName = GetSQLIDFPart(Request.QueryString("SQLFROM"),"SQLOBJECTNAME", ocdQuotePrefix,ocdQuoteSuffix)
End Select

If (ocdSelectForeignKey Or ocdShowRelatedRecords ) And (objForm.ADOConnection.provider = "Microsoft.Jet.OLEDB.4.0" Or objForm.ADOConnection.provider ="SQLOLEDB.1") Then
	Set rsFK = objForm.ADOConnection.OpenSchema(27)
	If Err.Number = 0 Then
		If Not rsFK.eof Then
			HasFK = True
			strPKTables = ""
			strFKTables = ""
			prevPKTable = ""
			prevFKTable = ""
			Do While Not rsFK.eof
				If (rsFK.Fields("PK_TABLE_NAME").Value) = strSQLTName And (rsFK.Fields("FK_TABLE_NAME").Value) <> (prevFKTABLE) Then
					prevFKTable = (rsFK.Fields("FK_TABLE_NAME").Value)
					strFKTables = strFKTables & (rsFK.Fields("FK_TABLE_NAME").Value) & ","
				End If
				If (rsFK.Fields("FK_TABLE_NAME").Value) = strSQLTName And (rsFK.Fields("FK_NAME").Value) <> (prevPKTABLE) Then
					prevPKTable = (rsFK.Fields("FK_NAME").Value)
					strPKTables = strPKTables & (rsFK.Fields("FK_NAME").Value) & ","
				End If
				rsFK.movenext
			Loop
			If Len(strPKTables) > 0 Then
				strPKTables = Left(strPKTables, Len(strPKTables)-1)
			End If
			If Len(strFKTables) > 0 Then
				strFKTables = Left(strFKTables, Len(strFKTables)-1)
			End If
		Else
			rsFK.close
			Set rsFK = nothing
		End If
	Else
		Set rsFK = nothing
		Err.clear
	End If
End If

Call WriteHeader ("")

Response.Write ("<span class=""Information""> ")
If Request.QueryString("sqlid") = "" And Request.QueryString("SQLWHERE") = "" Then
	 Response.Write ("Adicionar Registro a ")
Else
	 Response.Write ("Editar Registro em ")
End If

Response.Write (" <a href=""Freebrowse.asp?sqlfrom_a=" & Server.URLEncode(Request.QueryString("sqlfrom")) & "&amp;")
For Each tQS In Request.QueryString
	If UCase(tQS) <> "SQLID" And UCase(tQS) <> "SQLFROM" And UCase(tQS) <> "NDBTNDELETE" And UCase(tQS) <> "SQLFROM_A" And UCase(tQS) <> "ACTION" And UCase(tQS) <> "SQLWHERE" Then
		Response.Write (tQS  & "=" &  Server.URLEncode(Request.QueryString(tQS)) & "&amp;")
	End If
Next

Response.Write (""">")
Response.Write (Server.HTMLEncode(Request.QueryString("SQLFrom")))
Response.Write ("</a></span>")
Select Case UCASE(ocdDatabaseType)
	Case "SQLSERVER"
		Response.Write (" <a class=""menu"" href=""" & ocdPageName & "?")
		If Request.QueryString("OCDSHOWRELATED") = "Yes" Then
			Response.Write "ocdShowRelated=&amp;"
		Else
			Response.Write "ocdShowRelated=Yes&amp;"
		End If
		For Each tQS In Request.QueryString
			If UCASE(tQS) <> "OCDSHOWRELATED" Then
				Response.Write (tQS  & "=" &  Server.URLEncode(Request.QueryString(tQS)) & "&amp;")
			End If
		Next
		If Request.QueryString("OCDSHOWRELATED") = "Yes" Then
			Response.Write (""">(Esconder ")
		Else
			Response.Write (""">(Mostrar ")
		End If
		Response.Write ("Relacionados)</a>")
End Select
Response.Write ("<P>")
Response.Flush

'start writing main body

objForm.Display("STATUS")
objForm.Display("START")
Response.Write ("<table>")
if ocdShowDefaults and Request.QueryString("Sqlid") = "" and Request.QueryString("sqlwhere") = "" Then
	if (objForm.ADOConnection.provider ="Microsoft.Jet.OLEDB.4.0") Then
		set rsdef = objForm.ADOConnection.OpenSchema(4,Array(Empty,Empty,CSTR(FormatForSQL(Request.QueryString("SQLFROM"), ocddatabasetype, "RemoveSQLIdentifier")))) 'columns
		if rsdef.eof then
			ocdShowDefaults = False
		Else
			arrrsdef = rsdef.getrows (,,Array("TABLE_NAME","COLUMN_NAME","COLUMN_DEFAULT"))
			rsdef.close
			set rsdef = nothing
		End If
		set rsdefeval = server.createobject("ADODB.Recordset")
 	ElseIf (objForm.ADOConnection.provider = "SQLOLEDB.1")Then
		set rsdef = objForm.ADOConnection.OpenSchema(4,Array(Empty,Empty,CSTR(GetSQLIDFPart(Request.QueryString("SQLFROM"),"SQLOBJECTNAME", ocdQuotePrefix,ocdQuoteSuffix)))) 'columns
		if rsdef.eof then
			ocdShowDefaults = False
		Else
			arrrsdef = rsdef.getrows (,,Array("TABLE_NAME","COLUMN_NAME","COLUMN_DEFAULT"))
			rsdef.close
			set rsdef = nothing
		End If
		set rsdefeval = server.createobject("ADODB.Recordset")
	Else
		ocdShowDefaults = False
	End If					
Else
	ocdShowDefaults = False
End If				

' format each field according to its type
For Each fldF in objForm.ADORecordset.Fields
	strName = fldF.Name
	
	Select Case strName 'check for replication columns
		Case "Gen_Description"
		'Response.Write fldF.type
	End Select
	intSize = fldF.DefinedSize
	if intSize = -1 Then
		intSize=50
	End If
	intFKColumnCount = 0
	strFKColumnName = ""
	fkrelatedtable = ""
	fkrelatedfield = ""
	Select Case fldF.Type
		Case 205, 128, 204 'adLongVarBinary, adBinary, adVarBinary
			Response.Write ("<tr><td nowrap valign='top' align=right>")
			Response.Write ("<SPAN CLASS=""FieldName"">" & strName & ":</SPAN>")
			Response.Write (" &nbsp;&nbsp;")
			Response.Write ("</td>")
			Response.Write ("<td align=left valign=baseline>")
			Response.Write ("<SPAN Class=Information>Dados Binários</SPAN> ")
			Response.Write ("</td></tr>")
		Case Else
			hasdef=false
			if ocdShowDefaults and Request.QueryString("sqlid") = "" and Request.QueryString("sqlwhere") = "" and not ocdDatabaseType = "Oracle" Then
				intrsdef = 0
				Do while intrsdef < ubound(arrrsdef,2)
					if ocdDataBaseType = "Access" Then				
				 		astrTemp =  FormatForSQL((Request.QueryString("sqlfrom")),ocddatabasetype,"REMOVESQLIDENTIFIER")
					ElseIf ocdDataBaseType = "SQLServer" Then
					astrTemp =  GetSQLIDFPart(Request.QueryString("SQLFROM"),"SQLOBJECTNAME", ocdQuotePrefix,ocdQuoteSuffix)
					End If
					if astrTemp = (arrrsdef(0,intrsdef)) Then
						if UCase(strName) = UCase(arrrsdef(1,intrsdef)) Then
							if not isnull(arrrsdef(2,intrsdef)) Then
								evdef = arrrsdef(2,intrsdef)
								hasdef = true
								exit do
							End If
						End If
					End If
					intrsdef = intrsdef + 1
				Loop
				if not hasdef then
					evdefresult = "" 
				Else
					call rsdefeval.open ("Select " & evdef & " as expr1", objForm.ADOConnection)
					evdefresult = rsDefeval.Fields(0).Value
					rsdefeval.close
				End If
			Else
				evdefresult = ""
			End If
			if isnull(evdefresult) then
				evdefresult = ""
			End If
			If ocdSelectForeignKey And HasFK And Not ocdReadOnly Then
				rsFK.movefirst
				Do While Not rsFK.EOF
					If (rsFK.Fields("FK_TABLE_NAME").Value) = strSQLTName And rsFK.Fields("FK_COLUMN_NAME").Value = strNAME Then	
						intFKColumnCount = intFKColumnCount + 1
						strFKColumnName = strName
						fkrelatedtable = rsFK.Fields("PK_TABLE_NAME").Value
						fkrelatedfield = rsFK.Fields("PK_COLUMN_NAME").Value
					End If
					rsFK.movenext
				Loop
			End If
			Response.Write ("<tr><td nowrap valign=""top"" align=""right"">")
			Response.Write ("<span Class=""FieldName"">" & strName & ":</span>")
			if CBool(fldF.Attributes and &H00000020) Then 'adFldIsNullable
				Response.Write (" &nbsp;&nbsp;")
			Else
				Response.Write (" <span class=""Warning"">*</span>")
			End If
			Response.Write ("</td>")
			if intfkcolumncount = 1 Then 'multicolumns not supported as dropdowns
				Response.Write ("<td align=""left"" valign=""top"">")
				if objForm.ADOConnection.provider ="Microsoft.Jet.OLEDB.4.0" Then
					Response.Write (objForm.DisplayFieldAsRelatedValues(Replace(fldF.Name,"""","""""") ,"Select [" & fkRelatedField & "] From [" & fkRelatedTable & "] Order By [" & fkRelatedField & "]",evdefresult,"CLASS=DataEntry"))
				Else
					Response.Write (objForm.DisplayFieldAsRelatedValues(Replace(fldF.Name,"""","""""") ,"Select """ & fkRelatedField & """ From """ & fkRelatedTable & """ Order By """ & fkRelatedField & """",evdefresult,"CLASS=DataEntry"))
				End If
				Response.Write ("</td></tr>")
			Else
				Select Case fldF.Type
					Case 201, 203 'adLongVarChar, adLongVarWChar
						Response.Write ("<td align=left valign=top>")
						Response.Write (objForm.DisplayFieldAsMemo(strName,evdefresult,"ROWS =""5"" COLS=""35"" CLASS=""DataEntry"" "))
						if not cbool(cint(ocdnscCompatibility) and ocdNoJavaScript) and Not ocdReadOnly Then
							Response.Write ("&nbsp;<A HREF="""" onclick=""javascript:window.open('ocdZoomText.asp?CallingForm=" & varformnum & "&amp;TextField=" & server.urlencode("ocdTF" & strName) & "', 'zoomtext','height=400,width=600,scrollbars=yes');return false""><IMG ALT=""Zoom Text"" SRC=""GridLnkEdit.gif"" Border=0></A>")
							Response.Write (vbCRLF & "<script TYPE=""text/javascript"" Language=""JavaScript"">" & vbCRLF)		
							Response.Write ("if (parseInt(navigator.appVersion) >= 4) {" & vbCRLF)
							Response.Write ("	if (navigator.appName == ""Microsoft Internet Explorer"") {" & vbCRLF)
							Response.Write ("document.write ('<IMG ALT=\""HTML Edit\"" SRC=\""AppHTMLEdit.gif\"" Border=0 onClick=\""javascript:window.open(\'ocdHTMLEdit.asp?CallingForm=" & varformnum & "&amp;TextField=" & server.urlencode("ocdTF" & strName) & "\', \'zoomtext\',\'height=400,width=600,scrollbars=yes\')\"">');" & vbCRLF)
							Response.Write ("	}" & vbCRLF)
							Response.Write ("}" & vbCRLF)
							Response.Write ("</SCRIPT>" & vbCRLF)
						End If
						Response.Write ("</td></tr>")
					Case 11 'adBoolean
						Response.Write ("<td align=left valign=top>")
												Response.Write ("<td align=left valign=top>")
						If not CBool(fldF.Attributes and &H00000020) Then
							Response.Write (objForm.DisplayFieldAsCheckBox(strName,True,False,True,""))
						Else
							Response.Write (objForm.DisplayFieldAsTextBox(strName,"","SIZE=""5"" MAXLENGTH=""12"" CLASS=""DataEntry"""))
							Response.Write ("</td></tr>")
						End If
					Case  133, 135, 134, 7 'adDBDate, adDBTimeStamp, adDBTime, adDate
						Response.Write ("<td align=left valign=top>")
						Response.Write (objForm.DisplayFieldAsTextBox(strName,evdefresult, "SIZE=""20"" MAXLENGTH=""50"" CLASS=""DataEntry"" "))
						if not (cbool(ocdnscCompatibility) and ocdNoJavaScript) and not ocdReadOnly Then
							Response.Write ("<A HREF="""" onClick=""javascript:window.open('ocdPickDate.asp?CallingForm=" & varformnum & "&amp;DateField=" & server.urlencode("ocdTF" & strName) & "&amp;InitialDate=' + document.forms[" & varformnum & "].elements['" & ("ocdTF" & strName) & "'].value, 'calendar','height=250,width=250,scrollbars=no');return false""><IMG WIDTH=17 HEIGHT=17 ALT=""Click for Calendar"" SRC=AppCalendar.gif BORDER=0></A>")
						End If
						Response.Write ("</td></tr>")
					Case 6 'adCurrency
						Response.Write ("<td align=left valign=top>")
						Response.Write (objForm.DisplayFieldAsTextBox(strName,evdefresult, "SIZE=""12"" MAXLENGTH=""50"" CLASS=""DataEntry"" "))
						Response.Write ("</td></tr>")
					Case 20, 14, 5, 131, 4, 2, 16, 21, 19, 18, 17, 3 'adBigInt, adDecimal, adDouble, adNumeric, adSingle, _
						' adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, _
						' adUnsignedSmallInt, adUnsignedTinyInt,adInteger
						Response.Write ("<td align=left valign=top>")
						Response.Write (objForm.DisplayFieldAsTextBox(strName,evdefResult, "SIZE=""24"" MAXLENGTH=""50"" CLASS=""DataEntry"" "))
						Response.Write ("</td></tr>")
					Case Else					
						Response.Write  ("<td align=left valign=top>")
						if intSize > 35 then
							bintSize = 35
						Else
							bintSize = intSize
						End If
						Response.Write (objForm.DisplayFieldAsTextBox(strName,evdefresult, "SIZE=""" & bintSize & """ MAXLENGTH=""" & intSize & """ CLASS=""DataEntry"" "))
						Response.Write ("</td></tr>")
				End Select
			End If
	End Select
	Response.flush
	response.clear
Next

If HasFK Then
	rsFK.close
	set rsFK = nothing
End If

if ocdShowDefaults Then
	set rsdefeval = nothing
End If

Response.Write ("</table><p>")

if not ocdReadOnly Then
	objForm.Display("BUTTONS")
End If

objForm.Display("END")	' and finally return the table
Response.Write ("<p><span class=""Warning"">*</span> indica campo requerido</p>")
Response.Flush

If err.number <> 0 Then
	Call WriteFooter("")
End If

If ocdShowRelatedRecords  Then
	Select Case ocdDatabaseType
		Case "Access","SQLServer"
			If ((objForm.ADOConnection.provider ="Microsoft.Jet.OLEDB.4.0" OR objForm.ADOConnection.provider ="SQLOLEDB.1") and (Request.QueryString("SQLID") <> "" or Request.QueryString("SQLWHERE") <> "") and not objForm.ADORecordset.eof) Then '
				set cat = server.createobject("ADOX.Catalog")
				if err <> 0 Then
					Response.Write ("Uma visão detalhada dos registros relatados não está disponível, um catálogo ADOX não pode ser criado.")
					call writefooter("")
				Else
					intcountgrids = 1
					cat.ActiveConnection = objForm.ADOConnection
					'check for foreign keys field
					if strPKTables <> "" Then '*
						homefield = ""
						fkrelatedfield = ""
						arrPKTables = split(strPKTables,",") '*
						set tblcat = cat.Tables(strSQLTName)
						for each elePKName in arrPKTables
							set keytblcat = tblcat.Keys(elePKName)
							if keytblcat.type = 2 Then
								if fkrelatedfield = "" then					
									For each colkeytblcat in keytblcat.Columns
										if keytblcat.RelatedTable <> "" THen 
											prevcolumn = ""
											if homefield = "" then
												homefield = colkeytblcat.Name
												fkrelatedfield =colkeytblcat.RelatedColumn
											Elseif prevcolumn <> homefield then
												homefield = homefield & "," &  colkeytblcat.Name
												fkrelatedfield = fkrelatedfield & "," &colkeytblcat.RelatedColumn
											End If
											prevcolumn = colkeytblcat.Name
											fkrelatedtable = keytblcat.RelatedTable
										End If
									next
								End If
								if fkRelatedTable <> "" Then
									Response.Write ("<SPAN CLASS=Information>Registro relatado em<A HREF=""FreeBrowse.asp?sqlfrom_a=" & server.urlencode(fkRelatedTable) & "&amp;")
									for each tQS in Request.QueryString
										if UCASE(tQS) <> "SQLID" AND UCASE(tQS) <> "SQLFROM" AND UCASE(tQS) <> "NDBTNDELETE" AND UCASE(tQS) <> "SQLFROM_A" AND UCASE(tQS) <> "SQLORDERBY_A" AND UCASE(tQS) <> "SQLWHERE_A" AND UCASE(tQS) <> "SQLGROUPBY_A" AND UCASE(tQS) <> "SQLHAVING_A" and UCASE(tQS) <> "ACTION" and UCASE(tQS) <> "SQLWHERE" Then
											Response.Write (tQS  & "=" &  Server.URLEncode(Request.QueryString(tQS)) & "&amp;")
										End If
									next
									Response.Write ("""> " & fkRelatedTable & "</a></span><P>")
									set objGrid = New ocdGrid
									objGrid.HTMLGridButtons		= "Primeiro|Primeiro;;anterior|Anterior;;próximo|Próximo;;último|Último;;Novo|Novo"
									objGrid.HTMLSortASCLink		= ""	'HTML to display inside sort ascending link
									objGrid.HTMLSortDESCLink	= ""	'HTML to display inside sort descending link	
									objGrid.HTMLFilterLink		= ""
									objGrid.SQLConnect 			= ocdnscSQLConnect
									objGrid.SQLUser 			= ocdnscSQLUser
									objGrid.SQLPass 			= ocdnscSQLPass
									objGrid.GridID 				= "Default" & intcountgrids
									objGrid.SQLSelect 			= "*"
									objGrid.SQLFrom 			= fkRelatedTable
									objGrid.SQLSelectPK 		= ""
									if instr(homefield,",") = 0 THen
										Select Case objForm.ADORecordset.Fields(homefield).Type
											Case 20, 14, 5, 131, 4, 2, 16, 21, 19, 18, 17, 3 
												'adBigInt, adDecimal, adDouble, adNumeric, adSingle, _
												' adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, 
												' adUnsignedSmallInt, adUnsignedTinyInt,adInteger
												if isnull(objForm.ADORecordset.Fields(homefield).Value) Then
													objGrid.SQLWhereExtra = "[" & fkrelatedfield & "] Is Null"
												Else
													objGrid.SQLWhereExtra = "[" & fkrelatedfield & "] =" & objForm.ADORecordset.Fields(homefield).Value
												End If
											Case Else
												if isnull(objForm.ADORecordset.Fields(homefield).Value) Then
													objGrid.SQLWhereExtra = "[" & fkrelatedfield & "] Is Null"
												Else
												objGrid.SQLWhereExtra = "[" & fkrelatedfield & "] ='"  & Replace(objForm.ADORecordset.Fields(homefield).Value,"'","''") & "'"
												End If
										End Select
									Else
										objGrid.SQLWhereExtra = ""
										arrhomefield = split (homefield,",")
										arrfkrelatedfield = split(fkrelatedfield,",")
										for intI = 0 to ubound (arrhomefield)
											Select Case objForm.ADORecordset.Fields(arrhomefield(intI)).Type
												Case 20, 14, 5, 131, 4, 2, 16, 21, 19, 18, 17, 3 
													' adBigInt, adDecimal, adDouble, adNumeric, adSingle, _
													' adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, 
													' adUnsignedSmallInt, adUnsignedTinyInt,adInteger
													if isnull(objForm.ADORecordset.Fields(arrhomefield(intI)).Value) Then
													objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & "[" & arrfkrelatedfield(intI) & "] Is Null AND "
													Else
														objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & "[" & arrfkrelatedfield(intI) & "] =" & objForm.ADORecordset.Fields(arrhomefield(intI)).Value & " AND "
													End If
											Case Else
												if isnull(objForm.ADORecordset.Fields(arrhomefield(intI)).Value) Then
													objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & "[" & arrfkrelatedfield(intI) & "] Is Null AND "
												Else
												objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & "[" & arrfkrelatedfield(intI) & "] ='"  & Replace(objForm.ADORecordset.Fields(arrhomefield(intI)).Value,"'","''") & "'" & " AND "
												End If
										End Select
									next
									objGrid.SQLWhereExtra = left(objGrid.SQLWhereExtra,len(objGrid.SQLWhereExtra)-5)
								End If
								objGrid.AllowEdit = True
								objGrid.AllowDelete = False
								objGrid.AllowAdd = False
								objGrid.AllowExport = False
								objGrid.FormEdit = "FreeEdit.asp"
'								objGrid.SQLSelectID = -1
								objGrid.SQLSelectPK = ""
								objGrid.Open
								objGrid.Display("GRID") 
								Response.Write ("<P>")
								Response.flush
								intcountgrids = intcountgrids + 1
								homefield = ""
								fkrelatedfield = ""
								Set objGrid = nothing
							End If
						Else 'not fkey
							homefield = ""
							fkrelatedfield = ""
						End If
						homefield = ""
						fkrelatedfield = ""
					next
				End If
				if strFKTables <> "" Then '*
					homefield = ""
					fkrelatedfield = ""
					arrFKTables = split(strFKTables,",") '*
					for each eleFKName in arrFKTables '*
						set tblcat = cat.Tables(eleFKNAME)
						for each keytblcat in tblcat.Keys
							if keytblcat.type = 2 Then
								For each colkeytblcat in keytblcat.Columns
									if (keytblcat.RelatedTable) = strSQLTName Then
										showrelated = true
										fkrelatedtable = keytblcat.RelatedTable
										if homefield = "" Then
											homefield = colkeytblcat.Name
											fkrelatedfield =colkeytblcat.relatedcolumn
										Else
											homefield = homefield & "," & colkeytblcat.Name
											fkrelatedfield =fkrelatedfield & "," & colkeytblcat.relatedcolumn
										End If
									Else 
										showrelated = false
									End If
								next
								if showrelated then
					set objGrid = New ocdGrid
									objGrid.HTMLGridButtons		= "Primeiro|Primeiro;;anterior|Anterior;;próximo|Próximo;;último|Último;;Novo|Novo"
									objGrid.HTMLSortASCLink		= ""	'HTML to display inside sort ascending link
									objGrid.HTMLSortDESCLink	= ""	'HTML to display inside sort descending link
									objGrid.HTMLFilterLink		= ""
									objGrid.SQLConnect 			= ocdnscSQLConnect
									objGrid.SQLUser 			= ocdnscSQLUser
									objGrid.SQLSelectPK 		= ""
									objGrid.SQLPass 			= ocdnscSQLPass
									objGrid.GridID 				= "Default" & intcountgrids
									objGrid.SQLSelect 			= "*"
									objGrid.SQLFrom 			= CStr(tblCat.Name)
									if instr(homefield,",") = 0 Then
										If isnull(objForm.ADORecordset.Fields(fkrelatedfield).Value) THen	
											if  (objForm.ADOConnection.provider ="Microsoft.Jet.OLEDB.4.0") Then
												objGrid.SQLWhereExtra = "[" & homefield & "] Is Null"
											Else
												objGrid.SQLWhereExtra = """" & homefield & """ Is Null" 
											End If
										Else
											Select Case objForm.ADORecordset.Fields(fkrelatedfield).Type
												Case 20, 14, 5, 131, 4, 2, 16, 21, 19, 18, 17, 3 
													'adBigInt, adDecimal, adDouble, adNumeric, adSingle, _
													' adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, 
													' adUnsignedSmallInt, adUnsignedTinyInt,adInteger
													If  (objForm.ADOConnection.provider ="Microsoft.Jet.OLEDB.4.0") Then
														objGrid.SQLWhereExtra = "[" & homefield & "] = " & objForm.ADORecordset.Fields(fkrelatedfield).Value
													Else
														objGrid.SQLWhereExtra = """" & homefield & """ = " & objForm.ADORecordset.Fields(fkrelatedfield).Value
													End If
												Case Else
													If  (objForm.ADOConnection.provider ="Microsoft.Jet.OLEDB.4.0") Then
														objGrid.SQLWhereExtra = "[" & homefield & "] ='"  & Replace(objForm.ADORecordset.Fields(fkrelatedfield).Value,"'","''") & "'"
													Else
														objGrid.SQLWhereExtra = """" & homefield & """ ='"  & Replace(objForm.ADORecordset.Fields(fkrelatedfield).Value,"'","''") & "'"
													End If
											End Select
										End If
									Else
										arrhomefield = split (homefield,",")
										arrfkrelatedfield = split(fkrelatedfield,",")
										objGrid.SQLWhereExtra = ""
										For intI = 0 to Ubound (arrhomefield)
											Select Case objForm.ADORecordset.Fields(arrfkrelatedfield(intI)).Type
												Case 20, 14, 5, 131, 4, 2, 16, 21, 19, 18, 17, 3 
										'adBigInt, adDecimal, adDouble, adNumeric, adSingle, _
										' adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, 
										' adUnsignedSmallInt, adUnsignedTinyInt,adInteger
													If  (objForm.ADOConnection.provider ="Microsoft.Jet.OLEDB.4.0") Then
														objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & "[" & arrhomefield(intI) & "]"
														If isnull(objForm.ADORecordset.Fields(arrfkrelatedfield(intI)).Value) Then
															objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & " Is Null AND "
														Else
															objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & "=" & objForm.ADORecordset.Fields(arrfkrelatedfield(intI)).Value & " AND "
														End If 
													Else
														if isnull(objForm.ADORecordset.Fields(arrfkrelatedfield(intI)).Value) Then
															objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & """" & arrhomefield(intI) & """ Is Null AND "
														Else
															objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & """" & arrhomefield(intI) & """ =" & objForm.ADORecordset.Fields(arrfkrelatedfield(intI)).Value & " AND "
														End If
													End If
											Case Else
												if  (objForm.ADOConnection.provider ="Microsoft.Jet.OLEDB.4.0") Then
													if isnull(objForm.ADORecordset.Fields(arrfkrelatedfield(intI)).Value) Then
														objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & "[" & arrhomefield(intI) & "] Is Null AND "
													Else
														objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & "[" & arrhomefield(intI) & "] ='"  & Replace(objForm.ADORecordset.Fields(arrfkrelatedfield(intI)).Value,"'","''") & "'" & " AND "
														End If
													Else
														if isnull(objForm.ADORecordset.Fields(arrfkrelatedfield(intI)).Value) Then
															objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & """" & arrhomefield(intI) & """ = Is Null AND "
														Else
															objGrid.SQLWhereExtra = objGrid.SQLWhereExtra & """" & arrhomefield(intI) & """ ='"  & Replace(objForm.ADORecordset.Fields(arrfkrelatedfield(intI)).Value,"'","''") & "'" & " AND "
														End If
													End If
											End Select
										next
										objGrid.SQLWhereExtra = left(objGrid.SQLWhereExtra,len(objGrid.SQLWhereExtra)-5)
									End If
									objGrid.SQLPageSize = ""
									objGrid.SQLPage = ""
									objGrid.AllowEdit = True
									If Not ocdReadOnly Then
										objGrid.AllowDelete = True
									Else
										objGrid.AllowDelete = True
									End If
									objGrid.AllowAdd = True
'									objGrid.SQLSelectID = -1
									objGrid.SQLSelectPK = ""
									objGrid.FormEdit = "FreeEdit.asp"
									objGrid.Open
									Response.Write ("<span class=""information"">")
									Response.Write objGrid.SQLRecordCount
									Response.Write (" Registros relacionados em <A HREF=""FreeBrowse.asp?sqlfrom_a=" & server.urlencode(tblcat.name) & "&amp;" )
									for each tQS in Request.QueryString
										if UCASE(tQS) <> "SQLID" AND UCASE(tQS) <> "SQLFROM" AND UCASE(tQS) <> "NDBTNDELETE" AND UCASE(tQS) <> "SQLFROM_A"  AND UCASE(tQS) <> "SQLORDERBY_A" AND UCASE(tQS) <> "SQLWHERE_A" AND UCASE(tQS) <> "SQLGROUPBY_A" AND UCASE(tQS) <> "SQLHAVING_A"  and UCASE(tQS) <> "ACTION" and UCASE(tQS) <> "SQLWHERE" Then
											Response.Write (tQS  & "=" &  Server.URLEncode(Request.QueryString(tQS)) & "&amp;")
										End If
									Next
									Response.Write ( """>")
									Response.Write (tblcat.name & "</A></span><BR>")
									objGrid.Display ("BUTTONS") 
									objGrid.Display ("GRID") 
									Response.Write ("<P>")
									Response.flush
									intcountgrids = intcountgrids + 1
									homefield = ""
									fkrelatedfield = ""
													Set objGrid = nothing
								End If
							Else 'not fkey
								homefield = ""
								fkrelatedfield = ""
							End If
						Next
					Next
				End If

				Set tblcat = nothing
				Set keytblcat = nothing
				Set cat = nothing
			End If'adox catalog not created
		End If
	End Select
End If 'check if related records should be displayed
'Response.Write objForm.SQLID
objForm.Close()

Call WriteFooter("")  

%>