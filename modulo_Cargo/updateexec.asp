<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<%
  Dim strCOD_CARGOS, strCAMPO1, strCAMPO2, strCAMPO3

  strCOD_CARGOS = Replace(Request("var_cod_cargos"),"'","''")
  strCAMPO1     = Replace(Request("var_campo1"),"'","''")
  strCAMPO2     = Replace(Request("var_campo2"),"'","''")
  strCAMPO3     = Replace(Request("var_campo3"),"'","''")
  
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

    If not bolTemRegistro Then
      Mensagem "Não existe no sistema nenhuma informação sobre o cargo <b>[" & strCAMPO1 & "]</b>, por favor tente novamente." _
              ,"Javascript:history.back()"
    End If

    CheckFieldsExist = bolTemRegistro

    FechaRecordSet ObjRS	
End Function

' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro()
	Dim strSQL
	Dim strDT_INATIVO
	
	strSQL = "UPDATE tbl_CARGOS SET CAMPO1 = '" & strCAMPO1 & "', CAMPO2 = '" & strCAMPO2 & "', CAMPO3 = '" & strCAMPO3 & "' " &_
	         "WHERE COD_CARGOS = " & strCOD_CARGOS
	
	'Response.Write strSQL
	objConn.Execute(strSQL)	
End Sub

' ========================================================================
' Principal ==============================================================
' ========================================================================
 Dim objConn

 AbreDBConn objConn, CFG_DB_DADOS

 If (FiedsRequired((strCAMPO1="")Or(strCAMPO2="")Or(strCAMPO3="")) And CheckFieldsExist()) Then
   GravaCadastro()
   Response.Redirect("detail.asp?var_chavereg=" & strCOD_CARGOS)
 End If

 FechaDBConn ObjConn
' ========================================================================
%>