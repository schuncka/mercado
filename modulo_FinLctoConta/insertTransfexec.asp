<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->   
<%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%
	Dim strSQL, objRS, ObjConn, objRSTs, objRSCT
	Dim strSYS_DT_CRIACAO, strSYS_COD_USER_CRIACAO
	Dim strCOD_CONTA_ORIG, strCOD_CONTA_DEST
	Dim strNUM_LCTO, strVLR_LCTO, strDT_LCTO, strMSG
	Dim strHISTORICO, strOBS, strNOVO_SALDO, strVLR_SALDO
	Dim strJSCRIPT_ACTION, strLOCATION
	
	strCOD_CONTA_ORIG = GetParam("var_cod_conta_orig")
	strCOD_CONTA_DEST = GetParam("var_cod_conta_dest")
	strNUM_LCTO = GetParam("var_num_lcto")
	strVLR_LCTO = Replace(GetParam("var_vlr_lcto"),".","")
	strDT_LCTO = GetParam("var_dt_lcto")
	strHISTORICO = GetParam("var_historico")
	strOBS = GetParam("var_obs")
	strJSCRIPT_ACTION 		= GetParam("JSCRIPT_ACTION")
	strLOCATION 			= GetParam("DEFAULT_LOCATION")
	'athdebug strLOCATION, true	
	strSYS_DT_CRIACAO		= Now()
	strSYS_COD_USER_CRIACAO = ""
	
	AbreDBConn objConn, CFG_DB
	
		'Insere os dados e valores da nova transferência
		strSQL = "INSERT INTO FIN_LCTO_TRANSF"	 	  
	 strSQL = strSQL & "		  (	COD_CONTA_ORIG,"	 	  
	 strSQL = strSQL & "		  COD_CONTA_DEST,"	 	  
	 strSQL = strSQL & "		  NUM_LCTO,"	 	  
	 strSQL = strSQL & "		  VLR_LCTO,"	 	  
	 strSQL = strSQL & "		  DT_LCTO,"	 	  
	 strSQL = strSQL & "		  HISTORICO,"	 	  
	 strSQL = strSQL & "		  OBS,"	 	  
	 strSQL = strSQL & "		  SYS_DT_CRIACAO,"	 	  
	 strSQL = strSQL & "		  SYS_COD_USER_CRIACAO"	 	  
	 strSQL = strSQL & "		  ) "		 	  
	 strSQL = strSQL & "		  VALUES"		 	  
	 strSQL = strSQL & "		  ('"& 	strCOD_CONTA_ORIG	& "',"  	  
	 strSQL = strSQL & "		  '" &	strCOD_CONTA_DEST	& "',"  	  
	 strSQL = strSQL & "		  '" &	strNUM_LCTO 		& "',"  	  
	 strSQL = strSQL & "		  " &	Replace(strVLR_LCTO,",",".") & ","  	  
	 strSQL = strSQL & "		  '" &	PrepDataBrToUni(strDT_LCTO,false) & "',"  	   
	 strSQL = strSQL & "		  '"	& 	strHISTORICO		& "',"  	   
	 strSQL = strSQL & "		  '"	&	strOBS				& "',"  	   
	 strSQL = strSQL & "		  '"	&	PrepDataBrToUni(strSYS_DT_CRIACAO,true) & "',"  	   
	 strSQL = strSQL & "		  '"	&	strSYS_COD_USER_CRIACAO & "'"  	   
	 strSQL = strSQL & "		  )"
	'Response.Write(strSQL & "<br><br>")	

	'AQUI: NEW TRANSACTION
	set objRSTs  = objConn.Execute("start transaction")
	set objRSTs  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)  
	If Err.Number <> 0 Then
	set objRSTs = objConn.Execute("rollback")
	Mensagem "modulo_FINLCTOCONTA.InsertTransf_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	Response.End()
	else
	set objRSTs = objConn.Execute("commit")
	End If
	'response.End()
	
	
	
	
	'Insere novo saldo na conta de ORIGEM
	strSQL = "SELECT VLR_SALDO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA_ORIG
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if GetValue(objRS,"VLR_SALDO")<>"" then
		strVLR_SALDO = GetValue(objRS,"VLR_SALDO")
	else
		strVLR_SALDO = "0,00"
	end if
	strNOVO_SALDO = strVLR_SALDO - strVLR_LCTO
	strNOVO_SALDO = FormataDecimal(strNOVO_SALDO, 2)
	strNOVO_SALDO = FormataDouble(strNOVO_SALDO, 2)
	
AcumulaSaldoNovo objConn, strCOD_CONTA_ORIG, strDT_LCTO, -strVLR_LCTO 
	
	'Insere novo saldo na conta DESTINO
	strSQL = "SELECT VLR_SALDO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA_DEST
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if GetValue(objRS,"VLR_SALDO")<>"" then
		strVLR_SALDO = GetValue(objRS,"VLR_SALDO")
	else
		strVLR_SALDO = "0,00"
	end if
	
	strNOVO_SALDO = strVLR_SALDO + strVLR_LCTO
	strNOVO_SALDO = FormataDecimal(strNOVO_SALDO, 2)
	strNOVO_SALDO = FormataDouble(strNOVO_SALDO, 2)
		
	AcumulaSaldoNovo objConn, strCOD_CONTA_DEST, strDT_LCTO, strVLR_LCTO
	
	FechaDBConn objConn	

	'athdebug strLOCATION, true
	
	if strLOCATION = "" then
	 response.Write("<script>")
	 response.Write("window.close();")
	 response.Write("</script>")
	 response.End()
	end if  
	
	response.Redirect(strLOCATION)
	
%>