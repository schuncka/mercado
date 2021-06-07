<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<SCRIPT>
function toggleTable(pstrTable)
{
if(document.getElementById("tbl" + pstrTable).style.display =="none")
	{
		document.getElementById("tbl" + pstrTable).style.display="block";
		document.getElementById("cmd" + pstrTable).value="Hide";
	}
else
	{
		document.getElementById("tbl" + pstrTable).style.display="none";
		document.getElementById("cmd" + pstrTable).value="Show";
	}
}
</SCRIPT>
</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
        <div class="padding20">
            <h1><i class="icon-auction fg-black on-right on-left"></i>Session</h1>
            <h2>Session Variables </h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:400px; overflow:scroll; overflow-x:hidden;">


                    <FORM><INPUT id=cmdCurrentIISContext style="WIDTH: 32pt" onclick='toggleTable("CurrentIISContext");' type=button value=Show> 
                    <B>Current server context running IIS (Environment)</B> 
                    <TABLE id=tblCurrentIISContext style="DISPLAY: none" border=1>
                      <TBODY>
                      <TR>
                        <TD><B>Key</B></TD>
                        <TD><B>Value</B></TD></TR><!--
                    <tr>
                    <td>System.Security.Principal.WindowsIdentity.GetC urrent().Name</td>
                    <td><%// = System.Security.Principal.WindowsIdentity.GetCurre nt().Name
                    %></td>
                    </tr>
                    -->
                      <TR>
                        <TD>System.Environment.CurrentDirectory</TD>
                        <TD><% = System.Environment.CurrentDirectory.ToString() %></TD></TR>
                      <TR>
                        <TD>System.Environment.MachineName</TD>
                        <TD><% = System.Environment.MachineName.ToString() %></TD></TR>
                      <TR>
                        <TD>System.Environment.OSVersion</TD>
                        <TD><%
                    
                    '4.00.1381 Windows NT 4.0
'                    4.00.1381 Windows NT 4.0 Service Pack 6a 1999-11-30
'                    5.00.2195 Windows 2000 (Windows NT 5.0)
'                    5.00.2195 Windows 2000 (Windows NT 5.0) Service Pack 4 2003-06-26
'                    5.1.2600 Windows XP (Windows NT 5.1)
'                    5.1.2600.2096 Windows XP (Windows NT 5.1) Service Pack 2 RC1 2004-03-11
'                    5.1.2600.2149 Windows XP (Windows NT 5.1) Service Pack 2 RC2 2004-06-10
'                    5.2.3663 Windows Server 2003 RC1
'                    5.2.3718 Windows Server 2003 RC2
'                    5.2.3790 Windows Server 2003 RTM (Windows NT 5.2) 2003-04
'                    6.0.4051 Windows "Longhorn" Client Preview 1 2003-11-02
'                    6.0.4074 Windows "Longhorn" Client Preview 2 2004-05-04
                    
                    Response.Write(System.Environment.OSVersion.ToString());
                    System.OperatingSystem osInfo = System.Environment.OSVersion;
                    
                    switch(osInfo.Platform) // determine the platform
                    {
                    case System.PlatformID.Win32Windows: // Win95, Win98, Win98SE, WinMe
                    {
                    switch (osInfo.Version.Minor)
                    {
                    case 0:
                    {
                    Response.Write(" (Windows 95)");
                    break;
                    }
                    case 10:
                    {
                    if(osInfo.Version.Revision.ToString() == "2222A")
                    {
                    Response.Write(" (Windows 98 Second Edition)");
                    }
                    else
                    {
                    Response.Write(" (Windows 9");
                    }
                    break;
                    }
                    case 90:
                    {
                    Response.Write(" (Windows Me)");
                    break;
                    }
                    }
                    break;
                    }
                    case System.PlatformID.Win32NT: // WinNT Win2k, WinXP, Win2k3
                    {
                    switch(osInfo.Version.Major)
                    {
                    case 3:
                    {
                    Response.Write(" (Windows NT 3.51)");
                    break;
                    }
                    case 4:
                    {
                    Response.Write(" (Windows NT 4.0)");
                    break;
                    }
                    case 5:
                    {
                    switch(osInfo.Version.Minor)
                    {
                    case 0:
                    {
                    Response.Write(" (Windows 2000)");
                    break;
                    }
                    case 1:
                    {
                    Response.Write(" (Windows XP)");
                    break;
                    }
                    case 2:
                    {
                    switch(osInfo.Version.Build)
                    {
                    case 3663:
                    {
                    Response.Write(" (Windows Server 2003 RC1)");
                    break;
                    }
                    case 3718:
                    {
                    Response.Write(" (Windows Server 2003 RC2)");
                    break;
                    }
                    case 3790:
                    {
                    Response.Write(" (Windows Server 2003)");
                    break;
                    }
                    }
                    break;
                    }
                    }
                    break;
                    }
                    case 6:
                    {
                    switch(osInfo.Version.Build)
                    {
                    case 4051:
                    {
                    Response.Write(" (Windows \"Longhorn\" Client Preview 1)");
                    break;
                    }
                    case 4074:
                    {
                    Response.Write(" (Windows \"Longhorn\" Client Preview 2)");
                    break;
                    }
                    }
                    break;
                    }
                    default :
                    {
                    Response.Write(" (Unknown)");
                    break;
                    }
                    }
                    break;
                    }
                    }
                    %></TD></TR>
                      <TR>
                        <TD>System.Environment.SystemDirectory</TD>
                        <TD><% = System.Environment.SystemDirectory.ToString() %></TD></TR>
                      <TR>
                        <TD>System.Environment.UserDomainName</TD>
                        <TD><% = System.Environment.UserDomainName.ToString() %></TD></TR>
                      <TR>
                        <TD>System.Environment.UserName</TD>
                        <TD><% = System.Environment.UserName.ToString() %></TD></TR>
                      <TR>
                        <TD>System.Environment.Version</TD>
                        <TD><%
                    Response.Write(System.Environment.Version.ToString ());
                    switch(System.Environment.Version.ToString())
                    {
                    case "1.0.3705.000" :
                    {
                    Response.Write(" (.NET 1.0)");
                    break;
                    }
                    case "1.0.3705.209" :
                    {
                    Response.Write(" (.NET 1.0 SP1)");
                    break;
                    }
                    case "1.0.3705.288" :
                    {
                    Response.Write(" (.NET 1.0 SP2)");
                    break;
                    }
                    case "1.0.3705.6018" :
                    {
                    Response.Write(" (.NET 1.0 SP3)");
                    break;
                    }
                    case "1.1.4322.573" :
                    {
                    Response.Write(" (.NET 1.1)");
                    break;
                    }
                    case "1.1.4322.2032" :
                    {
                    Response.Write(" (.NET 1.1 SP1)");
                    break;
                    }
                    }
                    %></TD></TR>
                      <TR>
                        <TD>System.Environment.WorkingSet</TD>
                        <TD><% = (System.Environment.WorkingSet / (1000 *
                    1024)).ToString("#,###0") + "Mb (" +
                    System.Environment.WorkingSet.ToString("#,###0") + ")" %></TD></TR></TBODY></TABLE>
                    <HR>
                    <INPUT id=cmdEnvironment style="WIDTH: 32pt" onclick='toggleTable("Environment");' type=button value=Show> 
                    <B>Environment Variables (Environment.GetEnvironmentVariables())</B><BR>
                    <TABLE id=tblEnvironment style="DISPLAY: none" border=1>
                      <TBODY>
                      <TR>
                        <TD><B>Key</B></TD>
                        <TD><B>Value</B></TD></TR><%foreach (DictionaryEntry de in Environment.GetEnvironmentVariables()) {%>
                      <TR>
                        <TD><%= de.Key %></TD>
                        <TD><%= de.Value %></TD></TR><% } %></TBODY></TABLE>
                    <HR>
                    <INPUT id=cmdRequest style="WIDTH: 32pt" onclick='toggleTable("Request");' type=button value=Show> 
                    <B>Request Object (HttpContext.Current.Request)</B><BR>
                    <TABLE id=tblRequest style="DISPLAY: none" border=1>
                      <TBODY>
                      <TR>
                        <TD><B>Key</B></TD>
                        <TD><B>Value</B></TD></TR>
                      <TR>
                        <TD>.UserHostAddress </TD>
                        <TD><%= Request.UserHostAddress %></TD></TR>
                      <TR>
                        <TD>.UserHostName </TD>
                        <TD><%= Request.UserHostName %></TD></TR></TBODY></TABLE>
                    <HR>
                    <INPUT id=cmdRequestServerVariables style="WIDTH: 32pt" onclick='toggleTable("RequestServerVariables");' type=button value=Show> 
                    <B>Server Variables (HttpContext.Current.Request.ServerVariables)</B><BR>
                    <TABLE id=tblRequestServerVariables style="DISPLAY: none" border=1>
                      <TBODY>
                      <TR>
                        <TD><B>Key</B></TD>
                        <TD><B>Value</B></TD></TR><%foreach (string name in HttpContext.Current.Request.ServerVariables) {%>
                      <TR>
                        <TD><%= name %></TD>
                        <TD><%
                    if (Request.ServerVariables[name] != "")
                    {
                    Response.Write(Request.ServerVariables[name]);
                    }
                    else
                    {
                    Response.Write("&nbsp;");
                    }
                    %></TD></TR><% } %></TBODY></TABLE>
                    <HR>
                    <INPUT id=cmdApplication style="WIDTH: 32pt" onclick='toggleTable("Application");' type=button value=Show> 
                    <B>Application Variables (HttpContext.Current.Application)</B><BR>
                    <TABLE id=tblApplication style="DISPLAY: none" border=1>
                      <TBODY>
                      <TR>
                        <TD><B>Key</B></TD>
                        <TD><B>Value</B></TD></TR><%foreach (string name in HttpContext.Current.Application) {%>
                      <TR>
                        <TD><%= name %></TD>
                        <TD><%= Application[name] %></TD></TR><% } %></TBODY></TABLE>
                    <HR>
                    <INPUT id=cmdSession style="WIDTH: 32pt" onclick='toggleTable("Session");' type=button value=Show> 
                    <B>Session Variables (HttpContext.Current.Session)</B><BR>
                    <TABLE id=tblSession style="DISPLAY: none" border=1>
                      <TBODY>
                      <TR>
                        <TD><B>Key</B></TD>
                        <TD><B>Value</B></TD></TR><%foreach (string name in HttpContext.Current.Session) {%>
                      <TR>
                        <TD><%= name %></TD>
                        <TD><%= Session[name] %></TD></TR><% } %></TBODY></TABLE>
                    <HR>
                    <INPUT id=cmdRequestCookies style="WIDTH: 32pt" onclick='toggleTable("RequestCookies");' type=button value=Show> 
                    <B>Cookies (HttpContext.Current.Request.Cookies)</B><BR>
                    <TABLE id=tblRequestCookies style="DISPLAY: none" border=1>
                      <TBODY>
                      <TR>
                        <TD><B>Key</B></TD>
                        <TD><B>Value</B></TD></TR><%foreach (string name in HttpContext.Current.Request.Cookies) {%>
                      <TR>
                        <TD><%= name %></TD>
                        <TD><%= Request.Cookies[name] %></TD></TR><% } %></TBODY></TABLE>
    <HR>
    <%
    /*
    'System.Web.HttpBrowserCapabilities' does not contain a definition for
    'GetEnumerator'
    */
    %><INPUT id=cmdRequestBrowser style="WIDTH: 32pt" onclick='toggleTable("RequestBrowser");' type=button value=Show> 
    <B>Browser (HttpContext.Current.Request.Browser)</B><BR>
    <TABLE id=tblRequestBrowser style="DISPLAY: none" border=1>
      <TBODY>
      <TR>
        <TD><B>Key</B></TD>
        <TD><B>Value</B></TD></TR>
      <TR>
        <TD>.ActiveXControls</TD>
        <TD><%= HttpContext.Current.Request.Browser.ActiveXControls %></TD></TR>
      <TR>
        <TD>.AOL</TD>
        <TD><%= HttpContext.Current.Request.Browser.AOL %></TD></TR>
      <TR>
        <TD>.BackgroundSounds</TD>
        <TD><%= HttpContext.Current.Request.Browser.BackgroundSounds %></TD></TR>
      <TR>
        <TD>.Beta</TD>
        <TD><%= HttpContext.Current.Request.Browser.Beta %></TD></TR>
      <TR>
        <TD>.Browser</TD>
        <TD><%= HttpContext.Current.Request.Browser.Browser %></TD></TR>
      <TR>
        <TD>.CDF</TD>
        <TD><%= HttpContext.Current.Request.Browser.CDF %></TD></TR>
      <TR>
        <TD>.ClrVersion</TD>
        <TD><%= HttpContext.Current.Request.Browser.ClrVersion %></TD></TR>
      <TR>
        <TD>.Cookies</TD>
        <TD><%= HttpContext.Current.Request.Browser.Cookies %></TD></TR>
      <TR>
        <TD>.Crawler</TD>
        <TD><%= HttpContext.Current.Request.Browser.Crawler %></TD></TR>
      <TR>
        <TD>.EcmaScriptVersion</TD>
        <TD><%= HttpContext.Current.Request.Browser.EcmaScriptVersion %></TD></TR>
      <TR>
        <TD>.Frames</TD>
        <TD><%= HttpContext.Current.Request.Browser.Frames %></TD></TR>
      <TR>
        <TD>.JavaApplets</TD>
        <TD><%= HttpContext.Current.Request.Browser.JavaApplets %></TD></TR>
      <TR>
        <TD>.JavaScript</TD>
        <TD><%= HttpContext.Current.Request.Browser.JavaScript %></TD></TR>
      <TR>
        <TD>.MajorVersion</TD>
        <TD><%= HttpContext.Current.Request.Browser.MajorVersion %></TD></TR>
      <TR>
        <TD>.MinorVersion</TD>
        <TD><%= HttpContext.Current.Request.Browser.MinorVersion %></TD></TR>
      <TR>
        <TD>.MSDomVersion</TD>
        <TD><%= HttpContext.Current.Request.Browser.MSDomVersion %></TD></TR>
      <TR>
        <TD>.Platform</TD>
        <TD><%= HttpContext.Current.Request.Browser.Platform %></TD></TR>
      <TR>
        <TD>.Tables</TD>
        <TD><%= HttpContext.Current.Request.Browser.Tables %></TD></TR>
      <TR>
        <TD>.Type</TD>
        <TD><%= HttpContext.Current.Request.Browser.Type %></TD></TR>
      <TR>
        <TD>.VBScript</TD>
        <TD><%= HttpContext.Current.Request.Browser.VBScript %></TD></TR>
      <TR>
        <TD>.Version</TD>
        <TD><%= HttpContext.Current.Request.Browser.Version %></TD></TR>
      <TR>
        <TD>.W3CDomVersion</TD>
        <TD><%= HttpContext.Current.Request.Browser.W3CDomVersion %></TD></TR>
      <TR>
        <TD>.Win16</TD>
        <TD><%= HttpContext.Current.Request.Browser.Win16 %></TD></TR>
      <TR>
        <TD>.Win32</TD>
        <TD><%= HttpContext.Current.Request.Browser.Win32 %></TD></TR></TBODY></TABLE>
    <HR>
    <INPUT id=cmdNavigator style="WIDTH: 32pt" onclick='toggleTable("Navigator");' type=button value=Show> 
    <B>Navigator Properties (javascript:navigator)</B><BR>
    <TABLE id=tblNavigator style="DISPLAY: none" border=1>
      <TBODY>
      <TR>
        <TD><B>Property</B></TD>
        <TD><B>Value</B></TD></TR>
      <TR>
        <TD>appCodeName</TD>
        <TD>
          <SCRIPT>document.write(navigator.appCodeName); </SCRIPT>
        </TD></TR>
      <TR>
        <TD>appMinorVersion</TD><!--appMajorVersion doesn't exist, for some
    reason!-->
        <TD>
          <SCRIPT>document.write(navigator.appMinorVersion);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>appName</TD>
        <TD>
          <SCRIPT>document.write(navigator.appName);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>appVersion</TD>
        <TD><SCRIPT>document.write(navigator.appVersion);</script></td>
    </tr>
    <tr>
    <td>browserLanguage</td>
    <td><script>document.write(navigator.browserLanguage);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>constructor</TD>
        <TD>
          <SCRIPT>document.write(navigator.constructor); </SCRIPT>
        </TD></TR>
      <TR>
        <TD>cookieEnabled</TD>
        <TD>
          <SCRIPT>document.write(navigator.cookieEnabled );</SCRIPT>
        </TD></TR>
      <TR>
        <TD>cpuClass</TD>
        <TD>
          <SCRIPT>document.write(navigator.cpuClass);< /script></td>
    </tr>
    <tr>
    <td>javaEnabled()</td>
    <td><script>document.write(navigator.javaEnabled() );</SCRIPT>
        </TD></TR>
      <TR>
        <TD>language</TD>
        <TD>
          <SCRIPT>document.write(navigator.language);< /script></td>
    </tr>
    <tr>
    <td>onLine</td>
    <td><script>document.write(navigator.onLine);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>opsProfile</TD>
        <TD>
          <SCRIPT>document.write(navigator.opsProfile);< /script></td>
    </tr>
    <tr>
    <td>platform</td>
    <td><script>document.write(navigator.platform);< /script></td>
    </tr>
    <tr>
    <td>securityPolicy</td>
    <td><script>document.write(navigator.securityPolicy);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>systemLanguage</TD>
        <TD>
          <SCRIPT>document.write(navigator.systemLanguage);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>taintEnabled()</TD>
        <TD>
          <SCRIPT>document.write(navigator.taintEnabled( ));</SCRIPT>
        </TD></TR>
      <TR>
        <TD>userAgent</TD>
        <TD>
          <SCRIPT>document.write(navigator.userAgent); </SCRIPT>
        </TD></TR>
      <TR>
        <TD>userLanguage</TD>
        <TD>
          <SCRIPT>document.write(navigator.userLanguage) ;</SCRIPT>
        </TD></TR>
      <TR>
        <TD>userProfile</TD>
        <TD>
          <SCRIPT>document.write(navigator.userProfile); </SCRIPT>
        </TD></TR></TBODY></TABLE>
    <HR>
    <INPUT id=cmdScreen style="WIDTH: 32pt" onclick='toggleTable("Screen");' type=button value=Show> 
    <B>Screen Properties (javascript:screen)</B><BR>
    <TABLE id=tblScreen style="DISPLAY: none" border=1>
      <TBODY>
      <TR>
        <TD><B>Property</B></TD>
        <TD><B>Value</B></TD></TR>
      <TR>
        <TD>availHeight</TD>
        <TD>
          <SCRIPT>document.write(screen.availHeight);< /script></td>
    </tr>
    <tr>
    <td>availLeft</td>
    <td><script>document.write(screen.availLeft);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>availTop</TD>
        <TD>
          <SCRIPT>document.write(screen.availTop);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>availWidth</TD>
        <TD>
          <SCRIPT>document.write(screen.availWidth);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>colorDepth</TD>
        <TD>
          <SCRIPT>document.write(screen.colorDepth);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>height</TD>
        <TD>
          <SCRIPT>document.write(screen.height);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>pixelDepth</TD>
        <TD>
          <SCRIPT>document.write(screen.pixelDepth);</SCRIPT>
        </TD></TR>
      <TR>
        <TD>width</TD>
        <TD><SCRIPT>document.write(screen.width);</SCRIPT></TD></TR>
    </TBODY>
    </TABLE>
    </FORM>
    





                </div>
                <br>
        </div>
</div>
</body>
</html>
<%
Response.Flush
%>