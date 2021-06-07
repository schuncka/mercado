<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_AdmProdutoCaex",Session("METRO_USER_ID_USER")), true %>
<%

  
 Dim objConn, objRS, strSQL
 Dim strCOD_PROD, arrCOD_PROD
 Dim indexCOD_PROD, strMENSAGEM
 Dim strFlagTemINSC, strFlagTemPRCLST, strFlagTemPALEST

 
 strMENSAGEM = "" 'string de mensagem esta vazia
	
 strCOD_PROD = Replace(GetParam("var_chavereg"),"'","''") 'recebe a chave do registro
 arrCOD_PROD = split(strCOD_PROD,",") 'feito o split para quebrar e pegar o cod_prod

 If (strCOD_PROD <> "") Then
	'abertura do banco de dados e configurações de conexão
	AbreDBConn objConn, CFG_DB 

	strFlagTemINSC   = false
	strFlagTemPALEST = false
	strFlagTemPRCLST = false

	'INI - TESTA se o PRODUTO (ou produtos) estão sendo referenciados(usados) em otras tabelas 
	'(*pelo menos nas 3 principais - como estava no projeto original antes da METRODOCs)
	strSQL = "SELECT COD_INSCRICAO FROM tbl_Inscricao_Produto WHERE COD_PROD IN (" & strCOD_PROD & ")"
    AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, 0
	While (NOT objRS.EOF) 
		IF GetValue(objRS,"COD_INSCRICAO")<>"" Then strFlagTemINSC=true  End IF   
		objRS.MoveNext
	Wend
	FechaRecordSet ObjRS
	
	strSQL = "SELECT IDAUTO FROM tbl_produtos_palestrante WHERE COD_PROD IN (" & strCOD_PROD & ")"
    AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, 0
	While (NOT objRS.EOF) 
		IF GetValue(objRS,"IDAUTO")<>"" Then strFlagTemPALEST=true End IF   
		objRS.MoveNext
	WEnd	
	FechaRecordSet ObjRS
	 
	strSQL = "SELECT COD_PRLISTA FROM tbl_prclista WHERE COD_PROD IN (" & strCOD_PROD & ")"
    AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, 0
	While (NOT objRS.EOF) 
		IF GetValue(objRS,"COD_PRLISTA")<>"" Then strFlagTemPRCLST=true End IF 
		objRS.MoveNext
	Wend
	FechaRecordSet ObjRS
	'FIM - TESTA se o PRODUTO... ------------------------------------------------------------------
 

	'athdebug (strFlagTemINSC & strFlagTemPRCLST  & strFlagTemPALEST), true
	 If ( (strFlagTemINSC=true) OR (strFlagTemPRCLST=true) OR (strFlagTemPALEST=true) )  Then
	    strMENSAGEM = "Algum dos produtos selecionados possui vinculo com pelo menos uma destes elementos: INSCRIÇÃO, PALESTRANTE ou PREÇO DE LISTA.<br>"
	 Else
		On Error Resume Next
		    For Each indexCOD_PROD In arrCOD_PROD
		      'strSQL = "DELETE FROM tbl_Inscricao_Produto WHERE COD_PROD IN (" & strCOD_PROD & ")"
			  'objConn.Execute strSQL 
		      'strSQL = "DELETE FROM tbl_PrcLista WHERE COD_PROD IN (" & strCOD_PROD & ")"
			  'objConn.Execute strSQL
		      'strSQL = "DELETE FROM tbl_Produtos_Palestrante WHERE COD_PROD IN (" & strCOD_PROD & ")"
			  'objConn.Execute strSQL
		      strSQL = "DELETE FROM tbl_PRODUTOS WHERE COD_PROD = " & indexCOD_PROD & " AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")
			  objConn.Execute strSQL
			  If err.Number <> 0 Then
			    strMENSAGEM = strMENSAGEM & "- Problema na deleção do produto [" & indexCOD_PROD & "].<br>"
			  End If
			Next
			Server.Execute("geraviewprodutos.asp")	
	 End if

	FechaDBConn ObjConn 
 End If
  

 If (strMENSAGEM <> "") Then
   Mensagem strMENSAGEM, "default.asp", "[voltar]", true 
 Else
   'Response.Redirect("default.asp")
 End If
%>