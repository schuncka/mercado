<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<%
 Dim strNOME, strDESCRICAO, strNOMINAL, strNUM_CRED_PJ, icodlote 

 strNOME = Replace(Request("var_nome"),"'","''")
 strDESCRICAO = Replace(Request("var_descricao"),"'","''")
 strNOMINAL = Replace(Request("var_nominal"),"'","''")
 If strNOMINAL <> "" Then
   strNOMINAL = "'" & strNOMINAL & "'"
 Else
   strNOMINAL = "NULL"
 End If
 strNUM_CRED_PJ = Request("var_num_cred_pj")

' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro()
  Dim strSQL, objRS, strDT_INATIVO
  
  strSQL = "INSERT INTO tbl_Lote (NOME, DESCRICAO, NOMINAL, NUM_CRED_PJ, SYS_USERCA, DT_CRIACAO) " &_
           "VALUES ('" & strNOME & "','" & strDESCRICAO & "'," & strNOMINAL & "," & strNUM_CRED_PJ & ",'" & Session("ID_USER") & "', NOW() ) "
  objConn.Execute(strSQL)	
  
  strSQL = "SELECT MAX(COD_LOTE) FROM tbl_Lote WHERE NOME = '" & strNOME & "'"
  Set objRS = objConn.Execute(strSQL)
  icodlote = objRS(0)
  FechaRecordSet objRS
End Sub

' ========================================================================
' Principal ==============================================================
' ========================================================================

Dim objConn

	AbreDBConn objConn, CFG_DB_DADOS
	GravaCadastro()
	FechaDBConn ObjConn
	
	response.Redirect("update.asp?var_chavereg=" & icodlote)
	
' ========================================================================
%>