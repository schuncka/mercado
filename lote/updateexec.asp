<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"--> 
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/ADOVBS.INC"--> 
<%
 Dim strCOD_LOTE, strNOME, strDESCRICAO, strNOMINAL, strNUM_CRED_PJ, strSQL_CRITERIO, strSQL_INNER
 Dim strTOTAL_PJ_PF, strTOTAL_CONTATO, strIGNORAR_CONTATO

 strCOD_LOTE  = Replace(Request("var_chavereg"),"'","''")
 strNOME      = Replace(Request("var_nome"),"'","''")
 strDESCRICAO = Replace(Request("var_descricao"),"'","''")
 strNOMINAL = Replace(Request("var_nominal"),"'","''")
 strNUM_CRED_PJ = Request("var_num_cred_pj")
 strSQL_CRITERIO = Request("var_sql_criterio")
 strSQL_INNER = Request("var_sql_inner")
 strIGNORAR_CONTATO = Request("var_ignorar_contato")
 
 If strIGNORAR_CONTATO <> "1"  Then
   strIGNORAR_CONTATO = "0"
 End If

' ========================================================================
' Realiza a pesquisa e atualiza o resultado na tabela lote
' ========================================================================
Sub PesquisaLote()
Dim strSQL, objRS, strSQLClause, strSQLClause2, strSQLLeftJoin, strSQLParenteses, strFLAG_EVENTO, strTOTAL_REGISTROS, strCAMPO_ANTERIOR, cont
Dim strCRITERIO_EVENTO, strSQL_CRITERIO, strSQL_INNER, strSQL_INNER_SUB, strSQL_CRITERIO_SUB, strCRITERIO_OPERADOR
Dim strSQL_IGNORAR_CONTATO

   strSQL_CRITERIO = ""

   strSQL = " SELECT CRITERIO_EVENTO, SQL_CRITERIO, SQL_INNER, SQL_INNER_SUB, SQL_CRITERIO_SUB, IGNORAR_CONTATO FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
	 strCRITERIO_EVENTO = objRS("CRITERIO_EVENTO")&""
	 strSQL_CRITERIO = objRS("SQL_CRITERIO")&""
	 strSQL_INNER = objRS("SQL_INNER")&""
	 strSQL_INNER_SUB = objRS("SQL_INNER_SUB")&""
	 strSQL_CRITERIO_SUB = objRS("SQL_CRITERIO_SUB")&""
	 strSQL_IGNORAR_CONTATO = objRS("IGNORAR_CONTATO")&""
   End If
   FechaRecordSet objRS
   
   If strCRITERIO_EVENTO = "" Then
     strCRITERIO_EVENTO = "AND"
   End If
   
   strCAMPO_ANTERIOR = ""
   strSQL = " SELECT * FROM tbl_Lote_Criterio WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   Do While not objRS.EOF
     If strCAMPO_ANTERIOR <> objRS("CAMPO") Then
	   strCAMPO_ANTERIOR = objRS("CAMPO")
       strSQLClause = strSQLClause & ") AND ("
	   strSQLClause = strSQLClause & objRS("CAMPO") & " "
       If objRS("CRITERIO") = "IN" Then 
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
		    strSQLClause = strSQLClause & objRS("CRITERIO") & " ('" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "') "
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " (" & Replace(objRS("VALOR")&"","'","''") & ") "
		 End If
  	   Else
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
		  if objRS("CRITERIO") = "LIKE" Or objRS("CRITERIO") = "LIKE_CONTEM" then
	       strSQLClause = strSQLClause & " LIKE '%" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  elseif objRS("CRITERIO") = "LIKE_COMECA" then
	       strSQLClause = strSQLClause & " LIKE '" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
'		  elseif InStr(objRS("CRITERIO"),"NULL") > 0 then
'		    strSQLClause = strSQLClause & objRS("CRITERIO") & " "
		  else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " '" & Replace(objRS("VALOR")&"","'","''") & "' "
		  end if
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " " & Replace(objRS("VALOR")&"","'","''") & " "
		 End If
	   End If
	 Else
	   strCRITERIO_OPERADOR = objRS("OPERADOR")&""
	   If strCRITERIO_OPERADOR = "" Then
	     strCRITERIO_OPERADOR = "OR"
	   End If
       strSQLClause = strSQLClause & " "&strCRITERIO_OPERADOR&" "
	   strSQLClause = strSQLClause & objRS("CAMPO") & " "
       If objRS("CRITERIO") = "IN" Then 
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " ('" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "') "
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " (" & Replace(objRS("VALOR")&"","'","''") & ") "
		 End If
	   Else
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
		  if objRS("CRITERIO") = "LIKE" Or objRS("CRITERIO") = "LIKE_CONTEM" then
	       strSQLClause = strSQLClause & " LIKE '%" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  elseif objRS("CRITERIO") = "LIKE_COMECA" then
	       strSQLClause = strSQLClause & " LIKE '" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
'		  elseif InStr(objRS("CRITERIO"),"NULL") > 0 then
'		    strSQLClause = strSQLClause & objRS("CRITERIO") & " "
		  else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " '" & Replace(objRS("VALOR")&"","'","''") & "' "
		  end if
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " " & Replace(objRS("VALOR")&"","'","''") & " "
		 End If
	   End If
	 End If
     objRS.MoveNext
   Loop
   strSQLClause = strSQLClause & ") "
   FechaRecordSet objRS
   
   
    strFLAG_EVENTO = False
	cont = 1
	
    strSQL = " SELECT COD_EVENTO, CRITERIO FROM tbl_LOTE_EVENTO WHERE COD_LOTE = " & strCOD_LOTE
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then	
	 
	 strFLAG_EVENTO = True
	 
	 strSQLParenteses = strSQLParenteses & " ( "
	   
	 strSQLLeftJoin = strSQLLeftJoin & " LEFT JOIN VIEW_RESUMO_VISITACAO ON (tbl_Empresas.COD_EMPRESA = VIEW_RESUMO_VISITACAO.COD_EMPRESA_VISITACAO) "
	 strSQLLeftJoin = strSQLLeftJoin & ")"
	 
	 strSQLClause2 = strSQLClause2 & " AND ("
	 
	 Do While not objRS.EOF
	  
	  If objRS("CRITERIO") = "<>" Then
		strSQLClause2 = strSQLClause2 & " VIEW_RESUMO_VISITACAO.`" & objRS("COD_EVENTO") & "` = 0"
	  Else
		strSQLClause2 = strSQLClause2 & " VIEW_RESUMO_VISITACAO.`" & objRS("COD_EVENTO") & "` > 0"
	  End If
	  cont = cont + 1
	  objRS.MoveNext
	  If not objRS.EOF Then
	    strSQLClause2 = strSQLClause2 & " " & strCRITERIO_EVENTO & " "
	  End If
	 Loop
	 strSQLClause2 = strSQLClause2 & ")"
	End If
	FechaRecordSet objRS
		
 


	   strSQL = " SELECT tbl_Empresas.COD_EMPRESA, if(tbl_empresas_sub.codbarra is null, tbl_empresas.codbarra,tbl_empresas_sub.codbarra) as CODBARRA  "
	   strSQL = strSQL & " FROM " & strSQLParenteses & " ( "
	   strSQL = strSQL & "  tbl_Empresas LEFT JOIN tbl_Empresas_Sub ON tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA"
	   If strSQL_IGNORAR_CONTATO&"" = "1" Then
	      strSQL = strSQL & " AND tbl_Empresas_Sub.CODBARRA IS NULL"
	   End If
	   strSQL = strSQL & "       LEFT JOIN tbl_Pais ON tbl_Empresas.END_PAIS = tbl_Pais.PAIS"
	   strSQL = strSQL & "       LEFT JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
	   strSQL = strSQL & "       LEFT JOIN tbl_Status_Cred ON if(tbl_Empresas_Sub.COD_STATUS_CRED is null,tbl_Empresas.COD_STATUS_CRED,tbl_Empresas_Sub.COD_STATUS_CRED) = tbl_Status_Cred.COD_STATUS_CRED "
	   strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON if(tbl_empresas_sub.codbarra is null,tbl_empresas.codbarra,tbl_empresas_sub.codbarra) = v.codbarra )"
	   strSQL = strSQL & " " & strSQLLeftJoin
	   strSQL = strSQL & " " & strSQL_INNER
	   strSQL = strSQL & " " & strSQL_INNER_SUB
	   strSQL = strSQL & " WHERE  ( tbl_Empresas.COD_EMPRESA IS NOT NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
	   strSQL = strSQL & " " & strSQLClause
	   strSQL = strSQL & " " & strSQLClause2
	   strSQL = strSQL & " " & strSQL_CRITERIO
	   strSQL = strSQL & " " & strSQL_CRITERIO_SUB
	   strSQL = strSQL & " GROUP BY 1,2 "
   'Response.Write(strSQL)
   'Response.End()



   
   Set objRS = Server.CreateObject("ADODB.RecordSet")
   objRS.CursorLocation = 3
   objRS.Open strSQL, objConn
   If not objRS.EOF Then
     strTOTAL_REGISTROS = objRS.RecordCount
   Else
     strTOTAL_REGISTROS = 0
   End If
   FechaRecordSet objRS
	
   strSQL = " UPDATE tbl_LOTE SET TOTAL_REGISTROS = " & strTOTAL_REGISTROS
   strSQL = strSQL & " WHERE COD_LOTE = " & strCOD_LOTE
	objConn.Execute(strSQL)	
	


'CONTAGEM DE CADASTROS PJ/PF E CONTATOS PARA ATUALIZAR NO LOTE	
	   strSQL = " SELECT COUNT(DISTINCT tbl_Empresas.COD_EMPRESA) AS 'PJ_PF', COUNT(DISTINCT tbl_empresas_sub.CODBARRA) as 'CONTATO'  "
	   strSQL = strSQL & " FROM " & strSQLParenteses & " ( "
	   strSQL = strSQL & "  tbl_Empresas LEFT JOIN tbl_Empresas_Sub ON tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA"
	   If strSQL_IGNORAR_CONTATO&"" = "1" Then
	      strSQL = strSQL & " AND tbl_Empresas_Sub.CODBARRA IS NULL"
	   End If
	   strSQL = strSQL & "       LEFT JOIN tbl_Pais ON tbl_Empresas.END_PAIS = tbl_Pais.PAIS"
	   strSQL = strSQL & "       LEFT JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
	   strSQL = strSQL & "       LEFT JOIN tbl_Status_Cred ON if(tbl_Empresas_Sub.COD_STATUS_CRED is null,tbl_Empresas.COD_STATUS_CRED,tbl_Empresas_Sub.COD_STATUS_CRED) = tbl_Status_Cred.COD_STATUS_CRED "
	   strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON if(tbl_empresas_sub.codbarra is null,tbl_empresas.codbarra,tbl_empresas_sub.codbarra) = v.codbarra )"
	   strSQL = strSQL & " " & strSQLLeftJoin
	   strSQL = strSQL & " " & strSQL_INNER
	   strSQL = strSQL & " " & strSQL_INNER_SUB
	   strSQL = strSQL & " WHERE  ( tbl_Empresas.COD_EMPRESA IS NOT NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
	   strSQL = strSQL & " " & strSQLClause
	   strSQL = strSQL & " " & strSQLClause2
	   strSQL = strSQL & " " & strSQL_CRITERIO
	   strSQL = strSQL & " " & strSQL_CRITERIO_SUB
   'Response.Write(strSQL)
   'Response.End()
   
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
     strTOTAL_PJ_PF = objRS("PJ_PF")
     strTOTAL_CONTATO = objRS("CONTATO")
   End If
   
   If strTOTAL_PJ_PF&"" = "" Then
     strTOTAL_PJ_PF = 0
   End If
   If strTOTAL_CONTATO&"" = "" Then
     strTOTAL_CONTATO = 0
   End If
   
   FechaRecordSet objRS
	
   strSQL = " UPDATE tbl_LOTE SET TOTAL_PJ_PF = " & strTOTAL_PJ_PF & ", TOTAL_CONTATO = " & strTOTAL_CONTATO
   strSQL = strSQL & " WHERE COD_LOTE = " & strCOD_LOTE
   objConn.Execute(strSQL)	

End Sub

' ========================================================================
' Principal ==============================================================
' ========================================================================
 Dim objConn, strSQL

'On Error Resume Next
 AbreDBConn objConn, CFG_DB_DADOS
 
 If Request("var_acao") = "UPDATE" Then 
	 strSQL = " UPDATE tbl_LOTE SET DT_LASTUPDATE = NOW()"
	 strSQL = strSQL & " , NOME = " & strToSQL(strNOME)
	 strSQL = strSQL & " , DESCRICAO = " & strToSQL(Replace(strDESCRICAO&"",vbNewLine,"<br>"))
	 strSQL = strSQL & " , NOMINAL = " & strToSQL(Replace(strNOMINAL&"",vbNewLine,"<br>"))
	 strSQL = strSQL & " , NUM_CRED_PJ = " & strToSQL(strNUM_CRED_PJ)
	 strSQL = strSQL & " , SQL_CRITERIO = " & strToSQL(strSQL_CRITERIO)
	 strSQL = strSQL & " , SQL_INNER = " & strToSQL(strSQL_INNER)
	 strSQL = strSQL & " , IGNORAR_CONTATO = " & strIGNORAR_CONTATO
	 strSQL = strSQL & " WHERE COD_LOTE = " & strCOD_LOTE
	 objConn.Execute(strSQL)	
 End If
  
 PesquisaLote()
 
'If err.Number <> 0 Then
'  Response.Write(err.Description)
'  Response.End()
'End If
 Response.Redirect("detail.asp?var_chavereg=" & strCOD_LOTE)

 FechaDBConn ObjConn
' ========================================================================
%>