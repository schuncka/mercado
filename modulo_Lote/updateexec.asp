<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"--> 
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/ADOVBS.INC"--> 
<%
 Dim strCOD_LOTE, strNOME, strDESCRICAO, strNOMINAL, strNUM_CRED_PJ, strSQL_CRITERIO, strSQL_INNER
 Dim strTOTAL_PJ_PF, strTOTAL_CONTATO, strIGNORAR_CONTATO, strDT_INATIVO, strCADASTRO_COM_FOTO

 strCOD_LOTE  = Replace(Request("var_chavereg"),"'","''")
 strNOME      = Replace(Request("var_nome"),"'","''")
 strDESCRICAO = Replace(Request("var_descricao"),"'","''")
 strNOMINAL = Replace(Request("var_nominal"),"'","''")
 strNUM_CRED_PJ = Request("var_num_cred_pj")
 strSQL_CRITERIO = Request("var_sql_criterio")
 strSQL_INNER = Request("var_sql_inner")
 strIGNORAR_CONTATO = Request("var_ignorar_contato")
 strDT_INATIVO = Request("var_dt_inativo")
 strCADASTRO_COM_FOTO = Request("var_cadastro_com_foto")
 
 If strIGNORAR_CONTATO <> "1"  Then
   strIGNORAR_CONTATO = "0"
 End If
 
 If strCADASTRO_COM_FOTO <> "1" Then
   strCADASTRO_COM_FOTO = "0"
 End If
 
 If Request.Form("var_dt_inativo") = "" Then
		strDT_INATIVO = "NULL"
	Else
       strDT_INATIVO =  "'" & PrepDataIve(strDT_INATIVO, false, true) & "'"
'MDB       strDT_INATIVO = date()
	End If
'	
	 'Response.Write(strDT_INATIVO)
     'Response.End()


' ========================================================================
' Realiza a pesquisa e atualiza o resultado na tabela lote
' ========================================================================
Sub PesquisaLote()
Dim strSQL, objRS, strSQLClause, strSQLClause2, strSQLLeftJoin, strSQLParenteses, strFLAG_EVENTO, strTOTAL_REGISTROS, strCAMPO_ANTERIOR, cont
Dim strCRITERIO_EVENTO, strSQL_CRITERIO, strSQL_INNER, strSQL_INNER_SUB, strSQL_CRITERIO_SUB
Dim strCAMPO, strCRITERIO, strCRITERIO_OPERADOR, strVALOR
Dim strSQL_IGNORAR_CONTATO, strSQL_CADASTRO_COM_FOTO

   strSQL_CRITERIO = ""

   strSQL = " SELECT CRITERIO_EVENTO, SQL_CRITERIO, SQL_INNER, SQL_INNER_SUB, SQL_CRITERIO_SUB, IGNORAR_CONTATO, CADASTRO_COM_FOTO FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
	 strCRITERIO_EVENTO = objRS("CRITERIO_EVENTO")&""
	 strSQL_CRITERIO = objRS("SQL_CRITERIO")&""
	 strSQL_INNER = objRS("SQL_INNER")&""
	 strSQL_INNER_SUB = objRS("SQL_INNER_SUB")&""
	 strSQL_CRITERIO_SUB = objRS("SQL_CRITERIO_SUB")&""
	 strSQL_IGNORAR_CONTATO = objRS("IGNORAR_CONTATO")&""
	 strSQL_CADASTRO_COM_FOTO = objRS("CADASTRO_COM_FOTO")&""
   End If
   FechaRecordSet objRS
   
   If strCRITERIO_EVENTO = "" Then
     strCRITERIO_EVENTO = "AND"
   End If
   
   strCAMPO_ANTERIOR = ""
   strSQL = " SELECT * FROM tbl_Lote_Criterio WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   Do While not objRS.EOF
   
     strCAMPO = objRS("CAMPO")&""
   
     'Testa para montar clausula do mesmo tipo de campo com OR dentro de parenteses  
	 ' AND (CAMPO1 = 1 or CAMPO1 = 2)
	 'Se o campo for diferente do anterior entao coloca AND fechando o parantese anterior
	 
     If strCAMPO_ANTERIOR <> strCAMPO Then
	 
	   strCAMPO_ANTERIOR = strCAMPO
       strSQLClause = strSQLClause & ") AND ("
	   strSQLClause = strSQLClause & strCAMPO & " "
	   
	 Else
	 
	   strCRITERIO_OPERADOR = objRS("OPERADOR")&""
	   If strCRITERIO_OPERADOR = "" Then
	     strCRITERIO_OPERADOR = "OR"
	   End If
       strSQLClause = strSQLClause & " "&strCRITERIO_OPERADOR&" "
	   strSQLClause = strSQLClause & strCAMPO & " "
	 
	 End If	   

	 strCRITERIO = objRS("CRITERIO")&""
	 strVALOR = Replace(objRS("VALOR")&"","'","''")
	 'Forçando para ver se o campo é do tipo DATA pelo nome literal do campo no banco
	 'Ideal é usar função que pega o tipo de dado do banco
	 If InStr(strCAMPO,"SYS_DATA") > 0 Then
	   strVALOR = PrepDataIve(strVALOR,False,True)
	 End If

	   
	 Select Case strCRITERIO
	     Case "IN"
		   strSQLClause = strSQLClause & strCRITERIO & " ('" & Replace(Replace(strVALOR,"'","''"),",","','") & "') "
		 Case "LIKE","LIKE_CONTEM"
		   strSQLClause = strSQLClause & " LIKE '%" & Replace(Replace(strVALOR,"'","''"),",","','") & "%' "
		 Case "LIKE_COMECA"
		   strSQLClause = strSQLClause & " LIKE '" & Replace(Replace(strVALOR,"'","''"),",","','") & "%'"
		 Case Else
		   strSQLClause = strSQLClause & strCRITERIO & " '" & strVALOR & "' "
	 End Select
	   
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
	   If strSQL_CADASTRO_COM_FOTO&"" = "1" Then
	      strSQL = strSQL & " AND if(tbl_Empresas_Sub.CODBARRA is null,tbl_Empresas.IMG_FOTO,tbl_Empresas_Sub.IMG_FOTO) IS NULL"
	   End If
	   strSQL = strSQL & "       LEFT JOIN tbl_Pais ON tbl_Empresas.END_PAIS = tbl_Pais.PAIS"
	   strSQL = strSQL & "       LEFT JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
	   strSQL = strSQL & "       LEFT JOIN tbl_Status_Cred ON if(tbl_Empresas_Sub.COD_STATUS_CRED is null,tbl_Empresas.COD_STATUS_CRED,tbl_Empresas_Sub.COD_STATUS_CRED) = tbl_Status_Cred.COD_STATUS_CRED "
	   If strSQL_IGNORAR_CONTATO&"" = "1" Then
	     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON tbl_empresas.cod_empresa = v.cod_empresa )"
	   Else
	     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON if(tbl_empresas_sub.codbarra is null,tbl_empresas.codbarra,tbl_empresas_sub.codbarra) = v.codbarra )"
	   End If
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
	   If strSQL_IGNORAR_CONTATO&"" = "1" Then
	     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON tbl_empresas.cod_empresa = v.cod_empresa )"
	   Else
	     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON if(tbl_empresas_sub.codbarra is null,tbl_empresas.codbarra,tbl_empresas_sub.codbarra) = v.codbarra )"
	   End If
	   strSQL = strSQL & " " & strSQLLeftJoin
	   strSQL = strSQL & " " & strSQL_INNER
	   strSQL = strSQL & " " & strSQL_INNER_SUB
	   strSQL = strSQL & " WHERE  ( tbl_Empresas.COD_EMPRESA IS NOT NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
	   strSQL = strSQL & " " & strSQLClause
	   strSQL = strSQL & " " & strSQLClause2
	   strSQL = strSQL & " " & strSQL_CRITERIO
	   strSQL = strSQL & " " & strSQL_CRITERIO_SUB
  ' Response.Write(strSQL)
  ' Response.End()
   
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
	 strSQL = strSQL & " , DT_INATIVO = " & strDT_INATIVO 
	 strSQL = strSQL & " , NOMINAL = " & strToSQL(Replace(strNOMINAL&"",vbNewLine,"<br>"))
	 strSQL = strSQL & " , NUM_CRED_PJ = " & strToSQL(strNUM_CRED_PJ)
	 strSQL = strSQL & " , SQL_CRITERIO = " & strToSQL(strSQL_CRITERIO)
	 strSQL = strSQL & " , SQL_INNER = " & strToSQL(strSQL_INNER)
	 strSQL = strSQL & " , IGNORAR_CONTATO = " & strIGNORAR_CONTATO
	 strSQL = strSQL & " , CADASTRO_COM_FOTO = " & strCADASTRO_COM_FOTO
	 strSQL = strSQL & " WHERE COD_LOTE = " & strCOD_LOTE
	 
	' response.Write(strSQL)
	' response.End()
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