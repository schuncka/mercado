<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_Usuario",Session("METRO_USER_ID_USER")), true %>
<%
 	Dim objConn, objRS, strSQL,strSQLfilho
  	Dim strCOD_USUARIO
	
  strCOD_USUARIO = Replace(GetParam("var_chavereg"),"'","''")
  'abertura do banco de dados e configura��es de conex�o
 
 AbreDBConn objConn, CFG_DB 
'---------------------------------------------------------------------------------------------------------------
  If strCOD_USUARIO <> "" Then
		
			
			strSQL="		DELETE FROM tbl_usuario"
			strSQL = strSQL &" WHERE COD_USUARIO IN ('" & strCOD_USUARIO & "')"
			objConn.Execute(strSQL)
			
			strSQL =		"DELETE FROM tbl_usuario_evento"
			strSQL = strSQL &" WHERE COD_USUARIO IN ('" & strCOD_USUARIO & "')"
			'athdebug strSQLfilho ,true
			objConn.Execute(strSQL)
			
  End If
  
	
			AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null
response.Write("Todos os dados vinculado ao C�digo "&strCOD_USUARIO& "foram excluidos junto com ele!")
Response.Redirect("DEFAULT.asp")
 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>