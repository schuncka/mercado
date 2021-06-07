<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|",BuscaDireitosFromDB("modulo_AdmServico",Session("METRO_USER_ID_USER")), true %>
<%
 
  
 Dim objConn, objRS, strSQL
 Dim strCOD_SERV, arrCOD_SERV
 Dim indexCOD_SERV, strMENSAGEM
 Dim strFlagSERVPERI, strFlagSERVRESTR

 
 strMENSAGEM = "" 'string de mensagem esta vazia
	
 strCOD_SERV = Replace(GetParam("var_chavereg"),"'","''") 'recebe a chave do registro
 arrCOD_SERV = split(strCOD_SERV,",") 'feito o split para quebrar e pegar o cod_prod

 If (strCOD_SERV <> "") Then
	'abertura do banco de dados e configurações de conexão
	AbreDBConn objConn, CFG_DB 

	strFlagSERVPERI   = false
	strFlagSERVRESTR  = false

	'INI - TESTA se o PRODUTO (ou produtos) estão sendo referenciados(usados) em otras tabelas 
	'(*pelo menos nas 3 principais - como estava no projeto original antes da METRODOCs)
	strSQL = "SELECT ID_AUTO FROM tbl_aux_servicos_periodo WHERE COD_SERV IN (" & strCOD_SERV & ")"
    AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, 0
	While (NOT objRS.EOF) 
		IF GetValue(objRS,"ID_AUTO")<>"" Then strFlagSERVPERI=true  End IF   
		objRS.MoveNext
	Wend
	FechaRecordSet ObjRS
	
	strSQL = "SELECT ID_AUTO FROM tbl_aux_servicos_restricao WHERE COD_SERV IN (" & strCOD_SERV & ")"
    AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, 0
	While (NOT objRS.EOF) 
		IF GetValue(objRS,"ID_AUTO")<>"" Then strFlagSERVRESTR=true End IF   
		objRS.MoveNext
	WEnd	
	
	'FIM - TESTA se o PRODUTO... ------------------------------------------------------------------

	 If ( (strFlagSERVPERI=true)  OR (strFlagSERVRESTR=true) )  Then
	    strMENSAGEM = "Algum dos SERVIÇOS selecionados possui vinculo com pelo menos uma destes elementos: SERVIÇO_RESGITRO, SERVIÇOS_RESTIÇÃO.<br>"
	 Else
		On Error Resume Next
		    For Each indexCOD_SERV In arrCOD_SERV
		       strSQL = "DELETE FROM tbl_AUX_SERVICOS WHERE COD_SERV = " & indexCOD_SERV & " AND COD_EVENTO = " & Session("COD_EVENTO")
	  objConn.Execute strSQL
	  If err.Number <> 0 Then
	    strMENSAGEM = strMENSAGEM & "- O serviço com código [" & indexCOD_SERV & "] não pode ser removido pois possui vinculo com pelo menos uma destas tabelas: PEDIDO_EXPOSITOR.<br>"
	  End If
			Next
	 End if
	End if
	 
	FechaDBConn ObjConn 
  

 If (strMENSAGEM <> "") Then
   Mensagem strMENSAGEM, "default.asp", "[voltar]", true 
 Else
   Response.Redirect("default.asp")
 End If
%>