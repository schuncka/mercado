<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"-->
<!--#include file="../_database/athutils.asp"--> 
<%
Function proximoRegistro()
	Dim strSQL_Local, objRS_Local
	
	proximoRegistro = 0
	
	strSQL_Local = " SELECT MAX(COD_SERV) AS COD_SERV FROM tbl_AUX_SERVICOS ORDER BY COD_SERV DESC"
	Set objRS_Local = objConn.execute(strSQL_Local)
	if not objRS_Local.EOF Then
	  if objRS_Local("COD_SERV")&""<>"" Then
	    proximoRegistro = objRS_Local("COD_SERV") 
	  end if
	end if
	
	If proximoRegistro&"" = "" or IsNull(proximoRegistro) Then 
	  proximoRegistro = 0
	End If
	
	proximoRegistro = Clng(proximoRegistro+1)
	
	FechaRecordSet(objRS_Local)
End Function


 Dim strCOD_SERV, strGRUPO, strTITULO, strTITULO_INTL, strDESCRICAO, strQTDE, strPRC_LISTA, strPRC_LISTA_INTL, strTRIBUTADO, strEMITE_CREDENCIAL, strLOJA_SHOW, strCOD_STATUS_CRED, strQTDE_LIMITE_MAX
 
 strCOD_SERV     = Replace(Request("var_cod_serv"),"'","''")
 strGRUPO        = Replace(Request("var_grupo"),"'","''")
 strTITULO       = Replace(Request("var_titulo"),"'","''")
 strTITULO_INTL       = Replace(Request("var_titulo_intl"),"'","''")
 strDESCRICAO    = Replace(Request("var_descricao"),"'","''")
 strCOD_STATUS_CRED = Replace(Request("var_contato_cod_status_cred"),"'","''")
 
 strQTDE   = Replace(Request("var_qtde"),"'","''")
 If strQTDE = "" Or not IsNumeric(strQTDE) Then
   strQTDE = 0
 End If
 
 strQTDE_LIMITE_MAX   = Replace(Request("var_qtde_limite_max"),"'","''")
 If strQTDE_LIMITE_MAX = "" Or not IsNumeric(strQTDE_LIMITE_MAX) Then
   strQTDE_LIMITE_MAX = "NULL"
 End If
 
 strPRC_LISTA   = Replace(Request("var_prc_lista"),"'","''")
 If strPRC_LISTA = "" Or not IsNumeric(strPRC_LISTA) Then
   strPRC_LISTA = 0
 Else
   strPRC_LISTA = FormataDouble(strPRC_LISTA,2)
 End If
 
 strPRC_LISTA_INTL   = Replace(Request("var_prc_lista_intl"),"'","''")
 If strPRC_LISTA_INTL = "" Or not IsNumeric(strPRC_LISTA_INTL) Then
   strPRC_LISTA_INTL = 0
 Else
   strPRC_LISTA_INTL = FormataDouble(strPRC_LISTA_INTL,2)
 End If
 
 strLOJA_SHOW = Replace(Request("var_loja_show"),"'","''")
 If strLOJA_SHOW = "" Then
   strLOJA_SHOW = "0"
 End If

 strTRIBUTADO = Replace(Request("var_tributado"),"'","''")
 If strTRIBUTADO = "" Then
   strTRIBUTADO = "0"
 End If

 strEMITE_CREDENCIAL = Replace(Request("var_emite_credencial"),"'","''")
 If strEMITE_CREDENCIAL = "" Then
   strEMITE_CREDENCIAL = "0"
 End If
 
 If strCOD_STATUS_CRED = "" Then
   strCOD_STATUS_CRED = "NULL"
 Else 
   strCOD_STATUS_CRED = "'" & strCOD_STATUS_CRED & "'"
 End If
 
' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro()
  Dim strSQL, strDT_INATIVO
  
  strSQL = "INSERT INTO tbl_AUX_SERVICOS (COD_SERV, GRUPO, TITULO, TITULO_INTL, DESCRICAO, QTDE, PRC_LISTA, PRC_LISTA_INTL, COD_EVENTO, LOJA_SHOW, TRIBUTADO, EMITE_CREDENCIAL, CONTATO_COD_STATUS_CRED, QTDE_LIMITE_MAX) " &_
           "VALUES (" & strCOD_SERV & ", '" & strGRUPO & "','" & strTITULO & "'," & strToSql(strTITULO_INTL) & "," & strToSQL(strDESCRICAO)& "," & strQTDE & "," & strPRC_LISTA & "," & strPRC_LISTA_INTL & "," & Session("COD_EVENTO") & ", " & strLOJA_SHOW & ", " & strTRIBUTADO & ", " & strEMITE_CREDENCIAL & ", " & strCOD_STATUS_CRED & " ," & strQTDE_LIMITE_MAX &  ") "

  objConn.Execute(strSQL)	
End Sub

' ========================================================================
' Principal ==============================================================
' ========================================================================

Dim objConn

	AbreDBConn objConn, CFG_DB_DADOS
	
	If strCOD_SERV = "" Or Cstr(strCOD_SERV) = "0" Then
	  strCOD_SERV = proximoRegistro() 
	End If
		
	If (FiedsRequired((strGRUPO="")Or(strTITULO="")Or(strPRC_LISTA="")) ) Then
		GravaCadastro()
		response.Redirect("insert.asp")
	End If
	
	FechaDBConn ObjConn
' ========================================================================
%>