<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 Dim ivariableserver 
 
 
 
'for each x in Request.ServerVariables
'  response.write(x & "<br>")
'next

%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
        <div class="padding20">
            <h1><i class="icon-auction fg-black on-right on-left"></i>Session</h1>
            <h2>Session Variables </h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:400px; overflow:scroll; overflow-x:hidden;">
					<% 'for each isessao in session.contents %>
                        <!-- 
                        <div style="width:220px; height:60px; border:0px solid #F00; display:block; float:left; overflow:hidden;">
                            <%'response.write ("<b>" & isessao & "</b>" & ":<br>" & (session.contents(isessao)) & vbnewline) %>
                        </div>
                        //-->
					<% 'next %>
					<% 
						for each ivariableserver in ServerVariables.contents 
                        	response.write ("<b>" & ivariableserver & "</b>" & ":<br>" )
							auxSTR = ServerVariables.contents(ivariableserver)
							If (auxSTR<>"") then
								response.write (Server.HTMLEncode(auxSTR))
							End If
							response.write ("<hr>" & vbnewline )                    
						next 
					%>

                </div>
                <br>
        </div>
</div>
</body>
</html>
<%
Response.Flush
%>