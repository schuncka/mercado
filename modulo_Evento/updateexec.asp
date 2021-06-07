<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<%
 Dim strCOD_PROD, strGRUPO, strTITULO, strDESCRICAO, strCAPACIDADE, strDT_OCORRENCIA
 Dim strLOCAL, strCARGA_HORARIA, strLOJA_SHOW, strNUM_COMPETIDOR_START, strCERTIFICADO_TEXTO, strDIPLOMA_TEXTO

 strCOD_PROD    = Replace(Request("var_cod_prod"),"'","''")
 strGRUPO = Replace(Request("var_grupo"),"'","''")
 strTITULO = Replace(Request("var_titulo"),"'","''")
 strDESCRICAO = Replace(Request("var_descricao"),"'","''")
 strCERTIFICADO_TEXTO = Replace(Request("var_certificado_texto"),"'","''")
 strDIPLOMA_TEXTO = Replace(Request("var_diploma_texto"),"'","''")

 strCAPACIDADE   = Replace(Request("var_capacidade"),"'","''")
 If strCAPACIDADE = "" Or not IsNumeric(strCAPACIDADE) Then
   strCAPACIDADE = 0
 End If
 
 strLOCAL = Replace(Request("var_local"),"'","''")
 If strLOCAL <> "" Then
   strLOCAL = "'" & strLOCAL & "'"
 Else
   strLOCAL = "NULL"
 End If
 
 strCARGA_HORARIA = Replace(Request("var_carga_horaria"),"'","''")
 If strCARGA_HORARIA <> "" Then
   strCARGA_HORARIA = "'" & strCARGA_HORARIA & "'"
 Else
   strCARGA_HORARIA = "NULL"
 End If
 
 strLOJA_SHOW = Replace(Request("var_loja_show"),"'","''")
 If strLOJA_SHOW = "" Then
   strLOJA_SHOW = "0"
 End If 
 
 strNUM_COMPETIDOR_START = Replace(Request("var_num_competidor_start"),"'","''")
 If strNUM_COMPETIDOR_START = "" Then
   strNUM_COMPETIDOR_START = "0"
 End If 
 
 strDT_OCORRENCIA = Replace(Request("var_dt_ocorrencia"),"'","''")
 If IsDate(strDT_OCORRENCIA) Then
   strDT_OCORRENCIA = "'" & strDT_OCORRENCIA & "'"
 Else
   strDT_OCORRENCIA = "NULL"
 End If
  
 If strCERTIFICADO_TEXTO <> "" Then
   strCERTIFICADO_TEXTO = "'" & strCERTIFICADO_TEXTO & "'"
 Else
   strCERTIFICADO_TEXTO = "NULL"
 End If

 If strDIPLOMA_TEXTO <> "" Then
   strDIPLOMA_TEXTO = "'" & strDIPLOMA_TEXTO & "'"
 Else
   strDIPLOMA_TEXTO = "NULL"
 End If


' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro()
	Dim strSQL
	Dim strDT_INATIVO
	
    strSQL = " UPDATE tbl_PRODUTOS SET COD_PROD = " & strCOD_PROD & ", GRUPO = '" & strGRUPO & "', TITULO = '" & strTITULO & "', DESCRICAO = '" & strDESCRICAO & "', CAPACIDADE = " & strCAPACIDADE & ", DT_OCORRENCIA = " & PrepDataIve(strDT_OCORRENCIA,false,false) & ", " & _
	         "  LOCAL = " & strLOCAL & ", CARGA_HORARIA = " & strCARGA_HORARIA & ", LOJA_SHOW = " & strLOJA_SHOW & ", NUM_COMPETIDOR_START = " & strNUM_COMPETIDOR_START & ", CERTIFICADO_TEXTO = " & strCERTIFICADO_TEXTO & ", DIPLOMA_TEXTO = " & strDIPLOMA_TEXTO & " " & _
	         " WHERE COD_PROD = " & strCOD_PROD & _
			 "   AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")
	
'Response.Write strSQL
'Response.End()
	objConn.Execute(strSQL)	
End Sub

' ========================================================================
' Principal ==============================================================
' ========================================================================
 Dim objConn

 AbreDBConn objConn, CFG_DB_DADOS

 If FiedsRequired((strCOD_PROD="")Or(strGRUPO="")Or(strDESCRICAO="")Or(strTITULO="")) Then
   GravaCadastro()
   Response.Redirect("detail.asp?var_chavereg=" & strCOD_PROD)
 End If

 FechaDBConn ObjConn
' ========================================================================
%>