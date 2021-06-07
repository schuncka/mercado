<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("mini_CfgLinks",Session("METRO_USER_ID_USER")), true %>
<%
Const LTB = "TBL_EVENTO_LINK" 								' - Nome da Tabela...
 Const DKN = "COD_EVENTO_LINK"									' - Campo chave...
 Const TIT = "CFG Link"	
	
 Dim objConn, objRS, strSQL
 Dim  strCODLINK, strCOD_EVENTO,strCODLINKMINI,strLOCATION
	
  'Carraga os valores das varíáveis enviadaos pelo filtro 
	'---------------carrega cachereg do pai local cred-----------------
	strCODLINK 		= Replace(GetParam("var_masterreg"),"'","''")
	strCODLINKMINI	= Replace(GetParam("var_chavereg"),"'","''")
	strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")
	strLOCATION 	= Replace(GetParam("DEFAULT_LOCATION"),"'","''")
  
  'athDebug strCOD_EVENTO, true
  
  AbreDBConn objConn, CFG_DB
    
  if strCOD_EVENTO = "" then

	strSQL = "SELECT COD_EVENTO FROM "&LTB&" WHERE COD_EVENTO_LINK IN (" & strCODLINKMINI & ")"
	'athdebug strSQL, true
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
		  strCOD_EVENTO = GetValue(objRS,"COD_EVENTO")
	End If
	
	'FechaRecordSet objRS
	
  If strCODLINKMINI <> "" Then
    strSQL = "DELETE FROM "&LTB&" WHERE "&DKN&" IN (" & strCODLINKMINI & ")"
	objConn.Execute strSQL
'	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
  End If
  	
%>

<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
        <div class="padding20">
            <h1><i class="icon-copy fg-black on-right on-left"></i>Delete Exec</h1>
            <h2>Link Evento</h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:100px; overflow:scroll; overflow-x:hidden;">
                	<p>O sistema processou a deleção do <%=DKN%> <strong><%=strCODLINKMINI%></strong>.
                </div>
                <hr>
                <div><form id="" action="<%="default.asp?var_chavereg="&strCODLINKMINI&"&var_masterreg="&strCODLINK&"&var_cod_evento="&strCOD_EVENTO%>" method="post"> 
                <input class="primary" type="submit" name="btRun" value="OK" />
                </form></div>
                <br>
        </div>
</div>
</body>
</html>
<%
end if
'athdebug "<hr> [FIM]" , true
'response.Redirect(strLOCATION)

FechaRecordSet ObjRS
FechaDBConn ObjConn
%>