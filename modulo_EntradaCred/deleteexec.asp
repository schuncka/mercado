<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_EntradaCred",Session("METRO_USER_ID_USER")), true %>
<%
 	Dim objConn, objRS, strSQL,strSQL2,strSQLfilho
  	Dim strCODLOCALCREDENCIAL
	
  strCODLOCALCREDENCIAL = Replace(GetParam("var_chavereg"),"'","''")
  'abertura do banco de dados e configurações de conexão
 
 AbreDBConn objConn, CFG_DB 
'---------------------------------------------------------------------------------------------------------------
  If strCODLOCALCREDENCIAL <> "" Then
		
			strSQL="		DELETE FROM tbl_local_credencial_site"
			strSQL = strSQL &" WHERE COD_LOCAL_CREDENCIAL in ("& strCODLOCALCREDENCIAL & ")"
			objConn.Execute(strSQL)
			
			strSQL2 =		"DELETE FROM tbl_local_credencial"
			strSQL2 = strSQL2 &" WHERE COD_LOCAL_CREDENCIAL in ("& strCODLOCALCREDENCIAL & ")"
			'athdebug strSQL&"<br>"&strSQL2 ,true
			objConn.Execute(strSQL2)
  End If
  
	
			AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null
response.Write("Todos os dados vinculado ao Código "&strCODLOCALCREDENCIAL& "foram excluidos junto com ele!")
Response.Redirect("DEFAULT.asp")

 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>