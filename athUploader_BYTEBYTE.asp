<!-- include file="_database/athDbConn.asp"--> 
<%
'----------------------------------------------
' Obtain specific URL Parameter from URL string
'---------------------------------- by Aless --
function GetParam(ParamName)
Dim auxStr
  if ParamName="" then 
    auxStr = Request.QueryString
	if auxStr="" then auxStr = Request.Form
  end if

  if Request.QueryString(ParamName).Count > 0 then 
    auxStr = Request.QueryString(ParamName)
  elseif Request.Form(ParamName).Count > 0 then
    auxStr = Request.Form(ParamName)
  else 
    auxStr = ""
  end if
  
  if auxStr = "" then
    GetParam = Empty
  else
    GetParam = Trim(auxStr)
  end if
end function

	strErr = ""
	strFORMNAME = GetParam("var_formname")
	strFIELDNAME = GetParam("var_fieldname")
	DIR_UPLOAD = GetParam("var_dir")
	strID_FILE = GetParam("id_file")

	ForWriting = 2
    adLongVarChar = 201
    lngNumberUploaded = 0

	'Get binary data from form		
	noBytes = Request.TotalBytes
	binData = Request.BinaryRead(noBytes)
	'convery the binary data to a string
	Set RST = CreateObject("ADODB.Recordset")
	LenBinary = LenB(binData)

	If LenBinary > 0 Then
		RST.Fields.Append "myBinary", adLongVarChar, LenBinary
		RST.Open
		RST.AddNew
		RST("myBinary").AppendChunk BinData
		RST.Update
		strDataWhole = RST("myBinary")
	End If
	'Response.Write "A - " & strDataWhole & "<BR>"
	'get the boundry indicator
	strBoundry = Request.ServerVariables ("HTTP_CONTENT_TYPE")
	'Response.Write "B - " & strBoundry & "<BR>"
	lngBoundryPos = instr(1,strBoundry,"boundary=") + 8 
	strBoundry = "--" & right(strBoundry,len(strBoundry)-lngBoundryPos)
	'Response.Write "C - " & strBoundry & "<BR>"
	'Get first file boundry positions.
	lngCurrentBegin = instr(1,strDataWhole,strBoundry)
	lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1
	Do While lngCurrentEnd > 0
		'Get the data between current boundry and remove it from the whole.
		strData = mid(strDataWhole,lngCurrentBegin, lngCurrentEnd - lngCurrentBegin)
		'Response.Write "D - " & strData & "<BR>"
		'Response.End()
		strDataWhole = replace(strDataWhole,strData,"")

		'Get the full path of the current file.
		lngBeginFileName = instr(1,strdata,"filename=") + 10
'Response.Write("lngBeginFileName= " & lngBeginFileName & "<br>")
		lngEndFileName = instr(lngBeginFileName,strData,chr(34)) 
'Response.Write("lngEndFileName= " & lngEndFileName & "<br>")
		'There could be one or more empty file boxes.	
		If lngBeginFileName <> lngEndFileName Then
			strFilename = mid(strData,lngBeginFileName,lngEndFileName - lngBeginFileName)
'Response.Write("strFilename=" & strFilename & "<br>")
			'Loose the path information and keep just the file name.
			tmpLng = instr(1,strFilename,"\")
			Do While tmpLng > 0
				PrevPos = tmpLng
				tmpLng = instr(PrevPos + 1,strFilename,"\")
			Loop
			FileName = right(strFilename,len(strFileName) - PrevPos)
			'Get the begining position of the file data sent.
			'if the file type is registered with the browser then there will be a Content-Type
			lngCT = instr(1,strData,"Content-Type:")
			If lngCT > 0 Then
				lngBeginPos = instr(lngCT,strData,chr(13) & chr(10)) + 4
			Else
				lngBeginPos = lngEndFileName
			End If
			'Get the ending position of the file data sent.
			lngEndPos = len(strData) 

			'Calculate the file size.	
			lngDataLenth = lngEndPos - lngBeginPos
			'Get the file data	
			strFileData = mid(strData,lngBeginPos,lngDataLenth)
			'Create the file.	
			Set fso = CreateObject("Scripting.FileSystemObject")
			auxmappath = Server.mappath(".") & DIR_UPLOAD
'		Response.Write(auxmappath)
'		Response.End()

			PathFile = auxmappath

'Response.Write(PathFile & FileName & "<BR>")
'Response.End()
            If strID_FILE <> "" Then
			  FileName = strID_FILE & "_" & FileName
			End If
			
			Set f = fso.OpenTextFile(PathFile & FileName, ForWriting, True)
			f.Write strFileData
			Set f = Nothing
			Set fso = Nothing
			lngNumberUploaded = lngNumberUploaded + 1
		End If

		'Get then next boundry postitions if any.
		lngCurrentBegin = instr(1,strDataWhole,strBoundry)
		lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1
    Loop
	If ERR.Number <> 0 Then
		strErr = Err.Description
		strFUNC = 1
	Else
		strFUNC = 2
	End If
	Response.Redirect("athUploader.asp?f=" & FileName & "&err=" & strErr & "&var_formname=" & strFORMNAME & "&var_fieldname=" & strFIELDNAME & "&id_file=" & strID_FILE & "&var_func=" & strFUNC & "&var_dir=" & DIR_UPLOAD)
%>