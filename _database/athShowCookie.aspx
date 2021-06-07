<!DOCTYPE HTML>
<%@ Page language="c#" %>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script language="javascript">
function ShowHideCookies(formID) {
  var objDivs = document.querySelectorAll(formID);
  for (var i = 0; i < objDivs.length; i++) {
	if  (objDivs[i].style.display == "none") {
		//alert ("then: " + objDivs[i].id);
		objDivs[i].style.display = "block";
	} else {
		//alert ("else: " + objDivs[i].id);		
        objDivs[i].style.display = "none";
    }
  }
}
</script>
<META http-equiv=Content-Type content="text/html; charset=iso-8859-1">
<META content="MSHTML 6.00.6000.16640" name=GENERATOR>
<META content=C# name=CODE_LANGUAGE>
<META content=JavaScript name=vs_defaultClientScript>
<META content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
<META http-equiv=Pragma content=no-cache>
</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
        <div class="padding20">
            <h1><i class="icon-tag fg-black on-right on-left"></i>Cookie</h1>
            <h2>Server Connections Cookie </h2><span class="tertiary-text-secondary"></span>            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:400px; overflow:scroll; overflow-x:hidden;">
					<% 
					  	int loop1, loop2;
						HttpCookieCollection MyCookieColl;
						HttpCookie MyCookie;
						
						MyCookieColl = Request.Cookies;
						
						// Capture all cookie names into a string array.
						String[] arr1 = MyCookieColl.AllKeys;
						
						// Grab individual cookie objects by cookie name.
						for (loop1 = 0; loop1 < arr1.Length; loop1++) 
						{
						   MyCookie = MyCookieColl[arr1[loop1]];
						   //Response.Write("Cookie: " + MyCookie.Name + "<br>");
						   //Response.Write("Secure:" + MyCookie.Secure + "<br>");
						
						   //Grab all values for single cookie into an object array.
						   String[] arr2 = MyCookie.Values.AllKeys;
						
						   //Loop through cookie Value collection and print all values.
						   for (loop2 = 0; loop2 < arr2.Length; loop2++) 
						   {
							  if (MyCookie.Name == "sysMetro") {
								  Response.Write("<div class='myform' id='div_proev_"+loop2+"' style='display:block;'><b> ");
								  Response.Write(" " + MyCookie.Name + "." + Server.UrlEncode(arr2[loop2]) + "</b><br>");
								  Response.Write("  <span>" + MyCookie.Values[loop2] + "</span> ");
								  Response.Write("<hr></div> ");
							  } else {
								  Response.Write("<div class='myform' id='div_outros_"+loop2+"' style='display:none;'><b> ");
								  Response.Write("<b> ");
								  Response.Write(" " + MyCookie.Name + "." + Server.UrlEncode(arr2[loop2]) + "</b><br>");
								  Response.Write("  <span>" + MyCookie.Values[loop2] + "</span> ");
								  Response.Write("<hr></div> ");
							  }
						   }
						}
					%>

                </div>
                <br>
                <div class="input-control checkbox" data-role="input-control">
                        <label>
                            <input type="checkbox" checked value="1" onChange="ShowHideCookies('.myform');"/>
                            <span class="check"></span>
                            Cookie Proevento
                        </label>
                </div>        
        </div>
</div>
</BODY>
</HTML>