<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
  VerficaAcesso("ADMIN")
  
  Dim objConn, objRS, objRSDetail
  Dim strSQL, strCOD_PROD, strCOD_PALESTRANTE, strFUNCAO, strTEMA, strIDAUTO
  Dim strHORA_INI, strHORA_FIM, strCONFIRMADO, strORDEM, strMATERIAL
  Dim strCONFLITO, strDT_OCORRENCIA
	
  strCOD_PROD = Replace(Request("var_cod_prod"),"'","''")
  strCOD_PALESTRANTE = Replace(Request("var_cod_palestrante"),"'","''")
  strIDAUTO = Replace(Request("var_idauto"),"'","''")
  strFUNCAO = Replace(Request("var_funcao"),"'","''")
  strTEMA = Replace(Request("var_tema"),"'","''")
  strMATERIAL = Replace(Request("var_material"),"'","''")
  strHORA_INI        = GetParam("var_hora_ini")
  strHORA_FIM        = GetParam("var_hora_fim")
  strCONFIRMADO      = GetParam("var_confirmado")
  strORDEM 		     = GetParam("var_ordem")
  strDT_OCORRENCIA   = GetParam("var_dt_ocorrencia")


  'Response.Write("[" & strCOD_PROD & "]<br>")
  'Response.Write("[" & strCOD_PALESTRANTE & "]<br>")
  'Response.Write("[" & strFUNCAO & "]<br>")
  'Response.Write("[" & strTEMA & "]<br>")
  'Response.End()

  If strHORA_INI = "" Then strHORA_INI = "NULL" Else strHORA_INI = "'" & strHORA_INI & "'"
  If strHORA_FIM = "" Then strHORA_FIM = "NULL" Else strHORA_FIM = "'" & strHORA_FIM & "'"

  If strCONFIRMADO = "" Then strCONFIRMADO = "NULL" End If

  If strORDEM="" Or not IsNumeric(strORDEM) Then strORDEM = "NULL" 
  
  strFUNCAO = strToSQL(strFUNCAO)

  strMATERIAL = strToSQL(strMATERIAL)
  
  strTEMA = strToSQL(strTEMA)
  
		
  AbreDBConn objConn, CFG_DB_DADOS


  If strIDAUTO <> "" Then
		'---------------
		'Já foi inserido
		'---------------
		
		strSQL =          " SELECT DISTINCT PP.IDAUTO, PP.FUNCAO, PP.TEMA, P.COD_PROD, P.TITULO, P.DESCRICAO, P.DT_OCORRENCIA, P.LOCAL, PP.HORA_INI, PP.HORA_FIM, PP.CONFIRMADO "
		strSQL = strSQL & "   FROM tbl_Palestrante_Evento PE, tbl_Produtos_Palestrante PP, tbl_Produtos P"
		strSQL = strSQL & "  WHERE PE.COD_PALESTRANTE = PP.COD_PALESTRANTE"
		strSQL = strSQL & "    AND PP.COD_PROD = P.COD_PROD "
		strSQL = strSQL & "    AND P.COD_EVENTO = " & Session("COD_EVENTO")
		strSQL = strSQL & "    AND PE.COD_PALESTRANTE = " & strCOD_PALESTRANTE
		strSQL = strSQL & "    AND P.COD_PROD <> " & strCOD_PROD
		strSQL = strSQL & "    AND P.DT_OCORRENCIA BETWEEN '"&PrepDataIve(strDT_OCORRENCIA,False,False)&" 00:00:00' AND '"&PrepDataIve(strDT_OCORRENCIA,False,False)&" 23:59:59'"
		strSQL = strSQL & "    AND ("
		strSQL = strSQL & "         (ADDTIME(pp.hora_ini, SEC_TO_TIME(1*60)) BETWEEN " & strHORA_INI & " AND " & strHORA_FIM & ") "
		strSQL = strSQL & "      OR (ADDTIME(pp.hora_fim, -1 * SEC_TO_TIME(1*60)) BETWEEN " & strHORA_INI & " AND " & strHORA_FIM& ")"
		strSQL = strSQL & "      OR (ADDTIME(pp.hora_ini, SEC_TO_TIME(1*60)) < " & strHORA_INI & " AND ADDTIME(pp.hora_fim, -1 * SEC_TO_TIME(1*60)) > " & strHORA_FIM & ")"
		strSQL = strSQL & "      )"
		strSQL = strSQL & "  ORDER BY P.DT_OCORRENCIA, PP.HORA_INI, PP.HORA_FIM"
		'response.Write(strSQL)
		'response.End()
		
		Set objRSDetail = objConn.Execute(strSQL)
		
		If not objRSDetail.EOF Then
		
		    Do While not objRSDetail.EOF
			  strCONFLITO = strCONFLITO & "- " & PrepData(objRSDetail("DT_OCORRENCIA"),True,False) & " " & Right("0"&Hour(objRSDetail("HORA_INI")),2) & ":" & Right("0"&Minute(objRSDetail("HORA_INI")),2) & "/" & Right("0"&Hour(objRSDetail("HORA_FIM")),2) & ":" & Right("0"&Minute(objRSDetail("HORA_FIM")),2) & ": " & objRSDetail("TITULO") & "\n"
			  objRSDetail.MoveNext
			Loop
				
		    Response.Write("<script>alert('Conflito de horário com: \n"&strCONFLITO&"');</script>")
			Response.Write("<div align='center'><br><br><input type='button' name='btVoltar' value='Voltar' onClick='javascript:history.back();'></div>")
			Response.End()
			
		Else		

	
			strSQL = " UPDATE tbl_Produtos_Palestrante " &_
					 " SET FUNCAO = " & strFUNCAO & ", TEMA = " & strTEMA & ", MATERIAL = " & strMATERIAL & ", HORA_INI = " & strHORA_INI & ", HORA_FIM = " & strHORA_FIM & ", CONFIRMADO = " & strCONFIRMADO & ", ORDEM = " & strORDEM  &_
					 " WHERE IDAUTO = " & strIDAUTO
			
				'response.Write(strSQL)
		'response.End()	
			
			
			objConn.Execute(strSQL)
			
			Response.Write("<script>javascript:window.opener.location.reload();window.close();</script>")
			Response.End()
		
		End If
		FechaRecordSet objRSDetail
		
  Else
		'----------------
		'Não foi inserido
		'----------------
		
		strSQL =          " SELECT DISTINCT PP.IDAUTO, PP.FUNCAO, PP.TEMA, P.COD_PROD, P.TITULO, P.DESCRICAO, P.DT_OCORRENCIA, P.LOCAL, PP.HORA_INI, PP.HORA_FIM, PP.CONFIRMADO "
		strSQL = strSQL & "   FROM tbl_Palestrante_Evento PE, tbl_Produtos_Palestrante PP, tbl_Produtos P"
		strSQL = strSQL & "  WHERE PE.COD_PALESTRANTE = PP.COD_PALESTRANTE"
		strSQL = strSQL & "    AND PP.COD_PROD = P.COD_PROD "
		strSQL = strSQL & "    AND P.COD_EVENTO = " & Session("COD_EVENTO")
		strSQL = strSQL & "    AND PE.COD_PALESTRANTE = " & strCOD_PALESTRANTE
		strSQL = strSQL & "    AND P.DT_OCORRENCIA BETWEEN '"&PrepDataIve(strDT_OCORRENCIA,False,False)&" 00:00:00' AND '"&PrepDataIve(strDT_OCORRENCIA,False,False)&" 23:59:59'"
		strSQL = strSQL & "    AND ("
		strSQL = strSQL & "         (ADDTIME(pp.hora_ini, SEC_TO_TIME(1*60)) BETWEEN " & strHORA_INI & " AND " & strHORA_FIM & ") "
		strSQL = strSQL & "      OR (ADDTIME(pp.hora_fim, -1 * SEC_TO_TIME(1*60)) BETWEEN " & strHORA_INI & " AND " & strHORA_FIM& ")"
		strSQL = strSQL & "      OR (ADDTIME(pp.hora_ini, SEC_TO_TIME(1*60)) < " & strHORA_INI & " AND ADDTIME(pp.hora_fim, -1 * SEC_TO_TIME(1*60)) > " & strHORA_FIM & ")"
		strSQL = strSQL & "      )"
		strSQL = strSQL & "  ORDER BY P.DT_OCORRENCIA, PP.HORA_INI, PP.HORA_FIM"
		'response.Write(strSQL)
		'response.End()
		
		Set objRSDetail = objConn.Execute(strSQL)
		
		If not objRSDetail.EOF Then
		
		    Do While not objRSDetail.EOF
			  strCONFLITO = strCONFLITO & "- " & PrepData(objRSDetail("DT_OCORRENCIA"),True,False) & " " & Right("0"&Hour(objRSDetail("HORA_INI")),2) & ":" & Right("0"&Minute(objRSDetail("HORA_INI")),2) & "/" & Right("0"&Hour(objRSDetail("HORA_FIM")),2) & ":" & Right("0"&Minute(objRSDetail("HORA_FIM")),2) & ": " & objRSDetail("TITULO") & "\n"
			  objRSDetail.MoveNext
			Loop
				
		    Response.Write("<script>alert('Conflito de horário com: \n"&strCONFLITO&"');</script>")
			Response.Write("<div align='center'><br><br><input type='button' name='btVoltar' value='Voltar' onClick='javascript:history.back();'></div>")
			Response.End()

			
		Else		

			strSQL = " INSERT INTO tbl_Produtos_Palestrante (COD_PROD, COD_PALESTRANTE, FUNCAO, TEMA, MATERIAL, HORA_INI, HORA_FIM, CONFIRMADO, ORDEM) " &_
					 " VALUES (" & strCOD_PROD & "," & strCOD_PALESTRANTE & "," & strFUNCAO & "," & strTEMA & ","&strMATERIAL&"," & strHORA_INI & "," & strHORA_FIM & "," & strCONFIRMADO & ", " & strORDEM & ") " 
	
		'response.Write(strSQL)
		'response.End()	
	
			objConn.Execute(strSQL)
		
		End If
		
		FechaRecordSet objRSDetail


  End If
	
  FechaDBConn objConn
  Response.Redirect("update.asp?var_chavereg=" & strCOD_PROD)
%>