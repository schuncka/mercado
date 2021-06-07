<%
'1 Click DB ASP Library - Pop Up Calendar for Input
'copyright 1997-2003 David Kawliche, AccessHelp.net

'1 Click DB ASP Library source code is protected by international
'laws and treaties.  Never use, distribute, or redistribute
'any software and/or source code in violation of its licensing.

'Use of this software and/or source code is strictly at your own risk.
'All warranties are specifically disclaimed except as required by law.

'For more information see : http://1ClickDB.com

'**Start Encode**

Option explicit
response.buffer=true

Dim strCallingForm, strDateField, strInitialDate, strInitialMonth
Dim strInitialYear, datControl, intMonth, intMonthNext, intMonthPrev
Dim intCount, intWeekday, intYearPrev, intYearNext
Dim auxStr

'If request.querystring("InitialMonth") = "" Then
  strInitialDate = Request("InitialDate")
'Else
'  strInitialDate = ""
'End if
strCallingForm = Request("CallingForm")
strDateField   = Request("DateField") 

If ( (IsDate(strInitialDate)) AND (CStr(strInitialDate)<>"") ) Then 
	datControl 		= strInitialDate
	strInitialYear  = year(CDate(datControl))
	strInitialMonth = cstr(Month(CDate(datControl)))
Else 
	If CStr(Request("InitialMonth")) = "" Then 
		strInitialMonth = Month(Now) 
	Else 
		strInitialMonth = Request("InitialMonth") 
	End If 

	If CStr(Request("initialYear")) <> "" Then 
		'datControl     = strInitialMonth & "/" & "1" & "/" & Request("InitialYear") 
		datControl     = "1" & "/" & strInitialMonth & "/" &  Request("InitialYear") 
		strInitialYear = Request("initialyear")
	Else 
		'datControl = strInitialMonth & "/" & "1" & "/" & Year(Now)
		datControl = "1" & "/" & strInitialMonth & "/" & Year(Now)
		strInitialYear = year(now)
	End If 
	strInitialDate = date
End If 

%>
<html>
<head>
<title>Choose Date</title>
<script language="JavaScript">
<!-- 
function writebackdate(selecteddate) { 
 var tmp = selecteddate;
 if ('12:00:00 AM' != document.forms[0].elements['dTime'].value) 
   {
    tmp = tmp + ' ' + document.forms[0].elements['dTime'].value;
   }
  window.opener.document.forms['<%=strCallingForm%>'].elements['<%=strDateField%>'].value = tmp;
  self.close();
}

function acwstopError() { return true; }

window.onError = acwstopError();
-->
</script>
<LINK rel=stylesheet type='text/css' href='acwc.css'>
<STYLE>
a { font-size : 10pt; font-family : Tahoma, Arial, sans-serif; color : #330066; }
a:hover { font-size : 10pt; font-family : Tahoma, Arial, sans-serif; color : #990000; } 
body {
	font-size : 10pt;
	font-family : Tahoma, Arial, sans-serif;
	scrollbar-base-color : #300066;
	scrollbar-face-color : #666690;
	scrollbar-shadow-color : Silver;
	scrollbar-highlight-color : Silver;
	scrollbar-3dlight-color : #ffffff;
	scrollbar-darkshadow-color : Silver;
	scrollbar-track-color : #CCCCCC;
	scrollbar-arrow-color : #ffffff;
	background : #FFFFFF;
	margin : 10px;
}
p   { font-size : 10pt; font-family : Tahoma, Arial, sans-serif; }
td  { font-size : 10pt; font-family : Tahoma, Arial, sans-serif; }
th  { font-size : 10pt;	font-family : Tahoma, Arial, sans-serif; }
</STYLE>
</head>
<body  onload="javascript:self.focus();">
<%
'strInitialDate = datControl 
intMonth = Month(datControl) 

auxStr = request.servervariables("SCRIPT_NAME") & "?callingform=" &_
         server.URLEncode(request.querystring("callingform")) & "&amp;DateField=" &_
		 server.URLEncode(request.querystring("datefield")) & "&amp;InitialDate=" &_
		 server.URLEncode(request.querystring("InitialDate"))
%>
<center>
<table style="margin:0; padding:0; vertical-align:middle; text-align:center;" border="1">
<form method='post' action='<%=auxStr%>'>
<tr>
	<td colspan='7' style="text-align:center; vertical-align:top;">
		<%
		If intMonth < 12 then 
			intMonthNext = intMonth + 1 & "&InitialYear=" & Year(datControl) 
		Else 
			intMonthNext = "1&InitialYear=" & Year(DateAdd("yyyy", 1, datControl)) 
		End if 
		
		If intMonth > 1 then 
			intMonthPrev = intMonth - 1 & "&InitialYear=" & Year(datControl) 
		Else 
			intMonthPrev = "12&InitialYear=" & Year(DateAdd ("yyyy", -1, datControl)) 
		End If 
		
		
		auxStr = request.servervariables("SCRIPT_NAME") & "?CallingForm=" &_
				 server.urlencode(request.querystring("CallingForm")) & "&DateField="  &_
				 server.urlencode(request.querystring("DateField"))  & "&InitialMonth=" & intMonthPrev  
		%>
		<a href="<%=auxStr%>"><img src="gridsmbtnPrev.gif" border="0" /></a>
		<B><%=MonthName(intMonth)%></b>
		<%
		auxStr = request.servervariables("SCRIPT_NAME") & "?CallingForm=" &_
				 server.urlencode(request.querystring("CallingForm")) & "&DateField="  &_
				 server.urlencode(request.querystring("DateField")) & "&InitialMonth=" & intMonthNext  
		%>
		<a href="<%=auxStr%>"><img src="gridsmbtnNext.gif" border="0" /></a>
		&nbsp;&nbsp;&nbsp;
		<%
		intyearNext = intMonth & "&InitialYear=" & Year(DateAdd ("yyyy", 1, datControl))
		intyearPrev = intMonth & "&InitialYear=" & Year(DateAdd ("yyyy", -1, datControl))
		auxStr = request.servervariables("SCRIPT_NAME") & "?CallingForm=" &_
				 server.urlencode(request.querystring("CallingForm")) & "&DateField=" &_
				 server.urlencode(request.querystring("DateField")) & "&InitialMonth=" & intYearPrev
		%>
		<a href="<%=auxStr%>"><img src="gridsmbtnPrev.gif" border="0" /></a>
		<B><%=Year(datControl)%></b>
		<%
		auxStr = request.servervariables("SCRIPT_NAME") & "?CallingForm=" &_
				 server.urlencode(request.querystring("CallingForm")) & "&DateField=" &_
				 server.urlencode(request.querystring("DateField")) & "&InitialMonth=" & intYearNext
		%>
		<a href="<%=auxStr%>"><img src="gridsmbtnNext.gif" border="0" /></a>
	</TD>
</TR>
<TR>
	<TD COLSPAN=7 NOWRAP BGCOLOR=YELLOW>
		<%
		If request.form("dTime") <> "" Then
			auxStr=Server.HTMLEncode(request.form("dTime"))
		Else
			auxStr=FormatDateTime((CDate(strInitialDate)),3)
		End If
		%>
		<font size=2><b>Time : </b></FONT>
		<INPUT SIZE=12 MaxLength=24 NAME=dTime ID=dTime VALUE='<%=auxStr%>'>
	</TD>
</TR>
<TR>
	<TD ALIGN=CENTER><b>Su</b></TD>
	<TD ALIGN=CENTER><b>Mo</b></TD>
	<TD ALIGN=CENTER><b>Tu</b></TD>
	<TD ALIGN=CENTER><b>We</b></TD>
	<TD ALIGN=CENTER><b>Th</b></TD>
	<TD ALIGN=CENTER><b>Fr</b></TD>
	<TD ALIGN=CENTER><b>Sa</b></TD>
</TR>
<TR>
<%
'datControl = CDATE(Cstr(strInitialMonth & "/" & "1" & "/" & strInitialYear ))
datControl = CDATE(Cstr("1" & "/" & strInitialMonth & "/" & strInitialYear ))
intWeekday = Weekday(datControl) 
For intCount = 1 to intWeekday - 1 
  response.write ("<TD>&nbsp;</TD>")
Next 

Do Until intMonth <> Month(datControl) 
	While intWeekday <> 8 
		If CDATE(datControl) = CDATE((FormatDateTime(CDate(strInitialDate),2))) Then 
			auxStr="bgcolor='YELLOW'"
		ElseIf CDATE(datControl) = Now() Then 
			auxStr="bgcolor='#FF0000'"
		End if
		'Response.write (FormatDateTime(CDate(strInitialDate),2))
%>
	<td valign="top" width="20" height="20" style="text-align:center;" <%=auxStr%>>
		<a href="javascript:void(0);" onClick="<%=auxStr%>"><%=Day(datControl)%></a>
    </td>
<%
		auxStr= "writebackdate('" & Year(datControl) & "-" & Month(datControl) & "-" & Day(datControl) & "')" 
		intWeekday = intWeekday + 1 
		datControl=DateAdd("d", 1, datControl) 
		If intMonth <> Month(datControl) then 
			intWeekday = 8 
		End If 
	Wend 
	intWeekday = 1 
%>	
</TR>
<TR>
<%
Loop 
%>
</TR>
<TR>
	<TD colspan="7" ALIGN=CENTER><%=(strInitialMonth & "/" & strInitialYear)%></TD>
</TR>
</FORM>
</TABLE>
</center>
</BODY>
</HTML>