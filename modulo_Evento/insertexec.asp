<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<%
 Dim strCOD_PROD, strGRUPO, strTITULO, strDESCRICAO, strCAPACIDADE, strDT_OCORRENCIA, strCERTIFICADO_TEXTO, strDIPLOMA_TEXTO
 Dim strLOCAL, strCARGA_HORARIA, strLOJA_SHOW, strNUM_COMPETIDOR_START
 
 strCOD_PROD     = Replace(Request("var_cod_prod"),"'","''")
 strGRUPO        = Replace(Request("var_grupo"),"'","''")
 strTITULO       = Replace(Request("var_titulo"),"'","''")
 strDESCRICAO    = Replace(Request("var_descricao"),"'","''")
 strCERTIFICADO_TEXTO = Replace(Request("var_certificado_texto"),"'","''")
 strDIPLOMA_TEXTO = Replace(Request("var_diploma_texto"),"'","''")

 strCAPACIDADE   = Replace(Request("var_capacidade"),"'","''")
 If strCAPACIDADE = "" Or not IsNumeric(strCAPACIDADE) Then
   strCAPACIDADE = 0
 End If
 strDT_OCORRENCIA = Replace(Request("var_dt_ocorrencia"),"'","''")
 If IsDate(strDT_OCORRENCIA) Then
   strDT_OCORRENCIA = "'" & strDT_OCORRENCIA & "'"
 Else
   strDT_OCORRENCIA = "NULL"
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

 If not IsNumeric(strCOD_PROD) Then
   strCOD_PROD = 0
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
' Faz a consistência para saber se os campos informados já existem
' ========================================================================
Function CheckFieldsExist()
Dim strSQL, objRS, bolTemRegistro

	strSQL = "SELECT COD_PROD " &_
             "  FROM tbl_PRODUTOS " &_ 
             " WHERE COD_PROD = " & strCOD_PROD &_
			 "   AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")

	Set objRS = objConn.Execute(strSQL)
	
	bolTemRegistro = not (objRS.BOF and objRS.EOF)
	
	If bolTemRegistro Then
		Mensagem "O identificador para o produto desejado <b>[" & strCOD_PROD & "]</b> não está disponível, <br>por favor indique outro identificador." _
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
  
  strSQL = "INSERT INTO tbl_PRODUTOS (COD_PROD, GRUPO, TITULO, DESCRICAO, CAPACIDADE, DT_OCORRENCIA, COD_EVENTO,  LOCAL, CARGA_HORARIA, LOJA_SHOW, NUM_COMPETIDOR_START, CERTIFICADO_TEXTO, DIPLOMA_TEXTO) " &_
           "VALUES (" & strCOD_PROD & ",'" & strGRUPO & "','" & strTITULO & "','" & strDESCRICAO& "'," & strCAPACIDADE & "," & PrepDataIve(strDT_OCORRENCIA),false,false) & "," & Session("COD_EVENTO") & ", " & strLOCAL & ", " & strCARGA_HORARIA & ", " & strLOJA_SHOW & ", " & strNUM_COMPETIDOR_START & ", " & strCERTIFICADO_TEXTO & ", " & strDIPLOMA_TEXTO & ") "

  REsponse.Write(strSQL)
  Response.End()
  objConn.Execute(strSQL)	
End Sub

' ========================================================================
' Principal ==============================================================
' ========================================================================

Dim objConn

	AbreDBConn objConn, CFG_DB_DADOS
	
	If (FiedsRequired((strCOD_PROD="")Or(strDESCRICAO="")Or(strGRUPO="")Or(strTITULO="")) And CheckFieldsExist()) Then
		GravaCadastro()
		response.Redirect("insert.asp")
	End If
	
	FechaDBConn ObjConn
' ========================================================================
%>