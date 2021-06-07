<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("mini_DadosNpsNfe",Session("METRO_USER_ID_USER")), true %>
<%
	Const LTB = "tbl_fin_rps_evento" 		' - Nome da Tabela...
	Const DKN = "COD_RPS_EVENTO"		' - Campo chave...
	Const TIT = "Dados RPS/NFE"				' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro
	
  Dim objConn,ObjRS,strSQL
  
  Dim strINSTRUCAO,strCOD_EVENTO,strstrINSTRUCAOMINI,strCOD_PROD,strLOCATION
	
  strINSTRUCAO  = Replace(GetParam("var_chavereg"),"'","''")
  strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")
  strLOCATION 	= Replace(GetParam("DEFAULT_LOCATION"),"'","''")
  
  'athDebug strCOD_EVENTO, true
  
  AbreDBConn objConn, CFG_DB
    
  if strCOD_EVENTO = "" then

	strSQL = "SELECT COD_EVENTO FROM tbl_fin_rps_evento WHERE COD_RPS_EVENTO IN (" & strINSTRUCAO & ")"
	'athdebug strSQL, true
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
		  strCOD_EVENTO = GetValue(objRS,"COD_EVENTO")
	End If
	
	'FechaRecordSet objRS
	
  If strINSTRUCAO <> "" Then
    strSQL = "DELETE FROM tbl_fin_rps_evento WHERE COD_RPS_EVENTO IN (" & strINSTRUCAO & ")"
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
            <h2>RPS Evento</h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:100px; overflow:scroll; overflow-x:hidden;">
                	<p>O sistema processou a deleção do COD RPS <strong><%=strINSTRUCAO%></strong>.
                </div>
                <hr>
                <div><form id="" action="<%="default.asp?var_chavereg="&strINSTRUCAO&"&var_cod_evento="&strCOD_EVENTO%>" method="post"> 
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