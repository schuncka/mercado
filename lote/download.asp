<%
Dim strFileName

strFileName = Request("strFilename")

response.AddHeader "Content-Type","application/x-msdownload"
response.AddHeader "Content-Disposition","attachment; filename=" & strFileName
'Response.Flush

Response.Buffer = True
Const adTypeBinary = 1

Set binario = Server.CreateObject("ADODB.Stream")
binario.Open
binario.Type = adTypeBinary
binario.LoadFromFile Server.MapPath(strFileName)
Response.BinaryWrite binario.Read
binario.Close

Set binario = Nothing
Response.Flush
%>
