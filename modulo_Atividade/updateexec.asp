<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
 Dim strCODIGO, strDESCRICAO, strSINTESE, strSINTESE_INTL, strSINTESE_SP, strTTO_M, strTTO_F, strLOJA_SHOW, strTIPOPESS, strCODATIV_PAI

 strCODIGO    = Replace(Request("var_codigo"),"'","''")
 strCODATIV_PAI = Replace(Request("var_codativ_pai"),"'","''")
 strDESCRICAO = Replace(Request("var_descricao"),"'","''")
 strSINTESE   = Replace(Request("var_sintese"),"'","''")
 strSINTESE_INTL = Replace(Request("var_sintese_intl"),"'","''")
 strSINTESE_SP = Replace(Request("var_sintese_sp"),"'","''")
 strTTO_M     = Replace(Request("var_tto_m"),"'","''")
 strTTO_F     = Replace(Request("var_tto_f"),"'","''")
 strTIPOPESS  = Replace(Request("var_tipopess"),"'","''")
 If strTTO_M = "" Then
  strTTO_M = "NULL"
 Else
  strTTO_M = "'" & strTTO_M & "'"
 End If
 If strTTO_F = "" Then
  strTTO_F = "NULL"
 Else
  strTTO_F = "'" & strTTO_F & "'"
 End If
 strLOJA_SHOW = Replace(Request("var_loja_show"),"'","''")
 If strLOJA_SHOW = "" Then
   strLOJA_SHOW = "0"
 End If 
 
 If strCODATIV_PAI = "" Then
  strCODATIV_PAI = "NULL"
 Else
  strCODATIV_PAI = "'" & strCODATIV_PAI & "'"
 End If

 If strSINTESE_INTL = "" Then
  strSINTESE_INTL = "NULL"
 Else
  strSINTESE_INTL = "'" & strSINTESE_INTL & "'"
 End If
 
 If strSINTESE_SP = "" Then
  strSINTESE_SP = "NULL"
 Else
  strSINTESE_SP = "'" & strSINTESE_SP & "'"
 End If

' ========================================================================
' Faz a consistência para saber se os campos informados já existem
' ========================================================================
Function CheckFieldsExist()
Dim strSQL, objRS, bolTemRegistro

	strSQL = "SELECT CODATIV " &_
             "  FROM tbl_ATIVIDADE " &_
             " WHERE CODATIV = '" & strCODIGO & "'"

	Set objRS = objConn.Execute(strSQL)
	
	bolTemRegistro = not (objRS.BOF and objRS.EOF)
	
	If bolTemRegistro Then
		Mensagem "O identificador para a atividade desejada <b>[" & strCODIGO & "]</b> não está disponível, <br>por favor indique outro identificador." _
                ,"Javascript:history.back()"
	End If
	
	CheckFieldsExist = not bolTemRegistro
	
	FechaRecordSet ObjRS	
End Function

' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro()
	Dim strSQL
	Dim strDT_INATIVO
	
    strSQL = " UPDATE tbl_ATIVIDADE " & _
	         "    SET ATIVIDADE = '" & strDESCRICAO & "', ATIVMINI = '" & strSINTESE & "', ATIVMINI_INTL = " & strSINTESE_INTL & ", ATIVMINI_SP = " & strSINTESE_SP & ", TTO_M = " & strTTO_M & ", TTO_F = " & strTTO_F & ", LOJA_SHOW = " & strLOJA_SHOW & ",TIPOPESS = '" & strTIPOPESS & "', CODATIV_PAI = " & strCODATIV_PAI & "" & _
	         "  WHERE CODATIV = '" & strCODIGO & "'"
	
	'Response.Write strSQL
	objConn.Execute(strSQL)	
End Sub

' ========================================================================
' Principal ==============================================================
' ========================================================================
 Dim objConn

 AbreDBConn objConn, CFG_DB_DADOS

 If FiedsRequired((strCODIGO="")Or(strDESCRICAO="")Or(strSINTESE="")) Then
   GravaCadastro()
   Response.Redirect("detail.asp?var_chavereg=" & strCODIGO)
 End If

 FechaDBConn ObjConn
' ========================================================================
%>