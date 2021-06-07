<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<%
Dim strCAMPO1, strCAMPO2, strCAMPO3

	strCAMPO1 = Replace(Request("var_campo1"),"'","''")
	strCAMPO2 = Replace(Request("var_campo2"),"'","''")
	strCAMPO3 = Replace(Request("var_campo3"),"'","''")

' ========================================================================
' Faz a consistência para saber se os campos informados já existem
' ========================================================================
Function CheckFieldsExist()
Dim strSQL, objRS, bolTemRegistro

	strSQL = "SELECT COD_CARGOS " &_
             "  FROM tbl_CARGOS " &_
             " WHERE CAMPO1 = '" & strCAMPO1 & "'"

	Set objRS = objConn.Execute(strSQL)
	
	bolTemRegistro = not (objRS.BOF and objRS.EOF)
	
	If bolTemRegistro Then
		Mensagem "O identificador para o cargo desejado <b>[" & strCAMPO1 & "]</b> não está disponível, <br>por favor indique outro identificador." _
                ,"Javascript:history.back()"
	End If
	
	CheckFieldsExist = not bolTemRegistro
	
	FechaRecordSet ObjRS	
End Function

' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro()
  Dim strSQL, strDT_INATIVO
  
  strSQL = "INSERT INTO tbl_CARGOS (CAMPO1, CAMPO2, CAMPO3) " &_
           "VALUES ('" & strCAMPO1 & "','" & strCAMPO2 & "','" & strCAMPO3 & "') "

  objConn.Execute(strSQL)	
End Sub

' ========================================================================
' Principal ==============================================================
' ========================================================================

Dim objConn

	AbreDBConn objConn, CFG_DB_DADOS
	
	If (FiedsRequired((strCAMPO1="")Or(strCAMPO2="")Or(strCAMPO3="")) And CheckFieldsExist()) Then
		GravaCadastro()
		response.Redirect("insert.asp")
	End If
	
	FechaDBConn ObjConn
' ========================================================================
%>