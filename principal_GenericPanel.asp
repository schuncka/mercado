<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"--> 
<!--#include file="_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_Painel", Session("METRO_USER_ID_USER")), true %>

<%
 Dim objConn, objRS, strSQL,strSQL2
 Dim strURL_ENTRADA, strFlagLogin, strGrpUser, strSACUSER,strUSROCULTO
 Dim flagTILE_VIEW
 
 flagTILE_VIEW = GetParam("var_tileview")

 '-------------------teste direito de acesso ao PAINEL---------------------------------------------------------------------------------
 VerificaDireito "|"&trim(ucase(flagTILE_VIEW))&"|", BuscaDireitosFromDB("modulo_Painel",Session("METRO_USER_ID_USER")), true 
 '----------------------------------------------------------------------------------------------------------------------------------------
 'athDebug flagTILE_VIEW , true
 
 AbreDBConn objConn, CFG_DB
  
 strSQL = " SELECT     COD_PAINEL "
 strSQL = strSQL & "		  , ROTULO "
 strSQL = strSQL & "		  , DESCRICAO "
 strSQL = strSQL & "		  , LINK " 
 strSQL = strSQL & "		  , LINK_PARAM "
 strSQL = strSQL & "		  , TILE_VIEW "
 strSQL = strSQL & "		  , TILE_TYPE " 
 strSQL = strSQL & "		  , TILE_BGCOLOR " 
 strSQL = strSQL & "		  , TILE_ICON " 
 strSQL = strSQL & "   FROM  sys_painel "  
 strSQL = strSQL & "  WHERE DT_INATIVO IS NULL "
 strSQL = strSQL & "    AND TILE_VIEW like '" & flagTILE_VIEW & "'"
 strSQL = strSQL & "  ORDER BY ORDEM"
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
 
If (not objRS.BOF) and (not objRS.EOF) Then 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="./_metroui/meta_css_js.inc"--> 
<!--#include file="metacssjs_root.inc"--> 
<script src="./_scripts/scriptsCS.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro" bgcolor="#1D1D1D">
<center>
<div class="" style="text-align:left;padding:20px;">
    <h1 class="fg-white">
	    <a href="./principal.asp" class=""><i class="icon-arrow-left-3 fg-white smaller"></i></a>
		<%=flagTILE_VIEW%>
		<small class="fg-white on-right">Panel</small>
    </h1>
	<!--teste de uso para implementação de um painel que abrirá os atalho que hoje se encontram em _MOBILE.//-->    
	<p id="_general" class="description"></p>
    
	<%
    '------------Laço que cria os atalhos (publicos-verdes)------------- 
	DO WHILE NOT objRS.EOF
		auxSTR = trim(GetValue(objRS, "LINK")) & trim(GetValue(objRS, "LINK_PARAM"))
		auxSTR = replaceParametersSession(auxSTR)
		
		if (instr(auxSTR,"javascript:")>0) then
			response.write ("<a href='#' onclick=""" & auxSTR & """") 
		Else
			response.write ("<a href=""" & auxSTR & """") 
		End IF

		response.write (" class='tile " & trim(GetValue(objRS, "TILE_TYPE")) & " " & trim(GetValue(objRS, "TILE_BGCOLOR")) & " fg-white'") 
		response.write (" title='" & GetValue(objRS, "DESCRICAO") & "'>" & vbnewline)
		response.write ("<div class='tile-content icon'>" & vbnewline)
		response.write ("	<span class='" & trim(GetValue(objRS, "TILE_ICON")) & "' ></span>" & vbnewline)
		response.write ("</div>" & vbnewline)
		response.write ("<div class='tile-status'>" & vbnewline)
			response.write ("<div class='label'>" & vbnewline)
			if lcase(trim(GetValue(objRS,"TILE_TYPE")))<>"half"  then
				response.write GetValue(objRS, "ROTULO")
			ElseiF trim(GetValue(objRS,"TILE_ICON"))="" then
				response.write GetValue(objRS, "ROTULO")
			End if
		response.write ("</div>" & vbnewline)
		response.write ("</div>" & vbnewline)
		response.write ("</a>" & vbnewline)
		objRS.MoveNext
	loop	
    %>
</div>
<%
Else
  Mensagem "Não existem dados para esta consulta.<br>Informe novos critérios para efetuar a pesquisa.", "","", true 
End If
%>
</center>
</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>
