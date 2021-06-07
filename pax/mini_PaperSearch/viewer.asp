<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<%
 Dim strFileName, strDOWNLOADFILE
 Dim strCOD_EVENTO, strCOD_PAPER, objLang

 strFileName	= getParam("strFilename")
 strCOD_PAPER	= getParam("cod_paper")

 strDOWNLOADFILE = strFileName
 'If inStr(LCase(strDOWNLOADFILE),".txt") > 0 Then
 '  strDOWNLOADFILE =  Replace(LCase(strDOWNLOADFILE),".txt",".doc")
 'End If

 'DEBUG
 'Response.Write(Server.MapPath("../") & "/subpaper/extra/upload/" & strFileName)
 'Response.End()

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------
%>
<html>
<head>
<title>Mercado</title>
<link rel="stylesheet" href="../_css/csm.css">
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body marginheight="0" marginwidth="0" leftmargin="0" rightmargin="0">
<div align="center" style="padding:10px; width:100%;">
<%
  Mensagem objLang.SearchIndex("mini_papersearch_infoarq",0), "javascript:window.close();","["&objLang.SearchIndex("mini_papersearch_fechar",0)&"]", true 
%>
<iframe name="ifrmppt" src="../../subpaper/upload/<%=strDOWNLOADFILE%>" width="90%" height="90%" frameborder="1" scrolling="yes" ></iframe>
<%="<br><small>(" & mid(strFileName,1,70) & " ...)</small>"%>
</div>
</body>
</html>