<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("mini_ListaEvento",Session("METRO_USER_ID_USER")), true %>
<%
 	'Dim objConn, objRS, strSQL,strSQLfilho
'  	Dim strCOD_USUARIOLISTA
'	
'strCOD_USUARIOLISTA = Replace(GetParam("var_chavereg"),"'","''")
'  'abertura do banco de dados e configurações de conexão
' 
' AbreDBConn objConn, CFG_DB 
''---------------------------------------------------------------------------------------------------------------
'  If strCOD_USUARIOLISTA <> "" Then
'					
'			strSQL =		"DELETE FROM tbl_usuario_evento"
'			strSQL = strSQL &" WHERE COD_USUARIO = "& strCOD_USUARIOLISTA
'			'athdebug strSQLfilho ,true
'			objConn.Execute(strSQL)
'  End If
'  
'	
'			AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null
'response.Write("Todos os dados vinculado ao Código "&strCOD_USUARIOLISTA& "foram excluidos junto com ele!")
'Response.Redirect("DEFAULT.asp")
'
' 
'  FechaRecordSet ObjRS
'  FechaDBConn ObjConn 
response.Write("Em manutenção!")
%>