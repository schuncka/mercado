<!--#include file="../_database/athdbConnCS.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtilsCS.asp"-->
<%
Dim objConn, objRS, objRSCT, objRSa, strSQL
Dim strCOD_LCTO_EM_CONTA, strCOD_CONTA
Dim strVLR_SALDO, strNOVO_SALDO, strDT_LCTO
Dim strVLR_LCTO, strOPERACAO
		
strCOD_LCTO_EM_CONTA 	= GetParam("var_chavereg")
strCOD_CONTA 			= GetParam("var_conta")
strOPERACAO 			= GetParam("var_op")
strVLR_LCTO 			= GetParam("var_vlr")


'athDebug "COD LCTO CONTA"&strCOD_LCTO_EM_CONTA&"<BR>COD CONTA"&strCOD_CONTA&"<BR>OPERACAO"&strOPERACAO&"<BR>VALOR LCTO"&strVLR_LCTO , FALSE 

if strCOD_LCTO_EM_CONTA <> "" then
	

	AbreDBConn objConn, CFG_DB 
	
	 strSQL = "SELECT "	
	 strSQL = strSQL & "		  LCTO.COD_LCTO_EM_CONTA,"		 
	 strSQL = strSQL & "		  LCTO.OPERACAO, "	
	 strSQL = strSQL & "		  LCTO.COD_CONTA,"		 
	 strSQL = strSQL & "		  LCTO.VLR_LCTO "	
	 strSQL = strSQL & "		  FROM FIN_LCTO_EM_CONTA LCTO "		 
	 strSQL = strSQL & "		  LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA = LCTO.COD_PLANO_CONTA) " 	  
	 strSQL = strSQL & "		  LEFT OUTER JOIN FIN_CENTRO_CUSTO CUST ON (CUST.COD_CENTRO_CUSTO = LCTO.COD_CENTRO_CUSTO) "  
	 strSQL = strSQL & "		  LEFT OUTER JOIN FIN_CONTA CTA ON (LCTO.COD_CONTA = CTA.COD_CONTA) "  
	 strSQL = strSQL & "WHERE COD_LCTO_EM_CONTA =" & strCOD_LCTO_EM_CONTA
	 strSQL = strSQL & " ORDER BY DT_LCTO DESC "
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	IF strCOD_CONTA = "" THEN
		strCOD_CONTA = getValue(objRS,"COD_CONTA")
	end if
	IF strOPERACAO = "" THEN
		strOPERACAO = getValue(objRS,"OPERACAO")
	end if
	IF strVLR_LCTO = "" THEN
		strVLR_LCTO = getValue(objRS,"VLR_LCTO")
	end if
	
	'athDebug "COD LCTO CONTA"&strCOD_LCTO_EM_CONTA&"<BR>COD CONTA"&strCOD_CONTA&"<BR>OPERACAO"&strOPERACAO&"<BR>VALOR LCTO"&strVLR_LCTO , true 
	
	
	strSQL = "SELECT COD_CONTA, VLR_SALDO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if GetValue(objRS,"VLR_SALDO")<>"" then
		strVLR_SALDO = GetValue(objRS,"VLR_SALDO")
	else
		strVLR_SALDO = "0,00"
	end if
	
	if strOPERACAO="DESPESA" then	
		strNOVO_SALDO = strVLR_SALDO + strVLR_LCTO
	else
		strNOVO_SALDO = strVLR_SALDO - strVLR_LCTO
	end if
	'athDebug "COD LCTO CONTA"&strCOD_LCTO_EM_CONTA&"<BR>COD CONTA"&strCOD_CONTA&"<BR>OPERACAO"&strOPERACAO&"<BR>VALOR LCTO"&strVLR_LCTO , true 

	strSQL = "UPDATE FIN_CONTA SET VLR_SALDO=" & Replace(strNOVO_SALDO,",",".") & " WHERE COD_CONTA=" & GetValue(objRS,"COD_CONTA")
	'AQUI: NEW TRANSACTION
	'	set objRSCT  = objConn.Execute("start transaction")
	'	set objRSCT  = objConn.Execute("set autocommit = 0")
	Set objRSCT = objConn.Execute(strSQL)
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	  Set objRSCT = objConn.Execute(strSQL)
	  Mensagem "modulo_FINLCTOCONTA.DeleteExec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	   
		Set objRSCT = objConn.Execute(strSQL)
	End If
	
	strSQL = "SELECT DT_LCTO FROM FIN_LCTO_EM_CONTA WHERE COD_LCTO_EM_CONTA=" & strCOD_LCTO_EM_CONTA
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	strDT_LCTO = GetValue(objRS,"DT_LCTO")
	FechaRecordSet objRS
	
	strSQL = "DELETE FROM FIN_LCTO_EM_CONTA WHERE COD_LCTO_EM_CONTA=" & strCOD_LCTO_EM_CONTA
	'AQUI: NEW TRANSACTION
'	set objRSCT  = objConn.Execute("start transaction")
'	set objRSCT  = objConn.Execute("set autocommit = 0")
	Set objRSCT = objConn.Execute(strSQL)
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	'	set objRSCT  = objConn.Execute("start transaction")
	'	set objRSCT  = objConn.Execute("set autocommit = 0")
	Set objRSCT = objConn.Execute(strSQL)
	  Mensagem "modulo_FINLCTOCONTA.DeleteExec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	  
	'	set objRSCT  = objConn.Execute("start transaction")
	'	set objRSCT  = objConn.Execute("set autocommit = 0")
	Set objRSCT = objConn.Execute(strSQL)
	End If
	
	if strOPERACAO="DESPESA" then	 
		AcumulaSaldoNovo objConn, strCOD_CONTA, strDT_LCTO, strVLR_LCTO 
	else
		AcumulaSaldoNovo objConn, strCOD_CONTA, strDT_LCTO, -strVLR_LCTO 
	end if
	
	FechaDBConn objConn
end if
response.Redirect("../modulo_FINLCTOCONTA/default.asp")
%>
<!--<script>
   //ASSIM SÓ FUNCIONA NO IE (só no IE): parent.vbTopFrame.form_principal.submit();
   //ASSIM FUNCIONA NO IE e no FIREFOX
   parent.frames["vbTopFrame"].document.form_principal.submit();
</script>-->