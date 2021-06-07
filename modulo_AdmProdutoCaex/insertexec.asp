<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"-->
<!--#include file="../_database/athutils.asp"--> 
<%
 Dim strCOD_PROD, strGRUPO, strTITULO, strDESCRICAO, strCAPACIDADE, strREF_NUMERICA, strDT_OCORRENCIA, strDT_TERMINO, strCERTIFICADO_TEXTO, strDIPLOMA_TEXTO
 Dim strLOCAL, strCARGA_HORARIA, strLOJA_SHOW, strCAEX_SHOW, strNUM_COMPETIDOR_START, strCOD_PROD_VALIDA, strSINOPSE, strDINAMICA
 Dim strCertificadopdf, strDiplomapdf, strGrupointl, strTitulointl, strDescricaointl, strCERTIFICADO_PDF_OR
 Dim strCERTIFICADO_TEXTO_INTL, strDIPLOMA_TEXTO_INTL, strCertificadopdf_INTL, strDiplomapdf_INTL
 Dim strCOMPL_SHOW, strCOMPL_2_SHOW, strCOMPL_3_SHOW, strCOMPL_4_SHOW
 Dim strCOMPL_REQ, strCOMPL_2_REQ, strCOMPL_3_REQ, strCOMPL_4_REQ
 Dim strCOMPL_MSG, strCOMPL_2_MSG, strCOMPL_3_MSG, strCOMPL_4_MSG

 
 strCertificadopdf	   = Replace(Request("var_certificadopdf_texto"),"'","''") 
 strDiplomapdf	       = Replace(Request("var_diplomapdf_texto"),"'","''") 
 strGrupointl		   = Replace(Request("var_grupointl_texto"),"'","''")
 strTitulointl		   = Replace(Request("var_titulointl_texto"),"'","''") 
 strDescricaointl	   = Replace(Request("var_descricaointl_texto"),"'","''")	
 
 strCOD_PROD    	   = Replace(Request("var_cod_prod"),"'","''")
 strCOD_PROD_VALIDA	   = Replace(Request("var_cod_prod_valida"),"'","''")
 strGRUPO       	   = Replace(Request("var_grupo"),"'","''")
 strTITULO      	   = Replace(Request("var_titulo"),"'","''")
 strDESCRICAO		   = Replace(Request("var_descricao"),"'","''")
 strSINOPSE   		   =  Replace(Request("var_sinopse"),"'","''")
 strDINAMICA  		   = Replace(Request("var_dinamica"),"'","''")
 strCERTIFICADO_TEXTO  = Replace(Request("var_certificado_texto"),"'","''")
 strDIPLOMA_TEXTO	   = Replace(Request("var_diploma_texto"),"'","''")
 
 strCOMPL_MSG      	   = Replace(Request("var_extra_info_msg"),"'","''")
 strCOMPL_2_MSG			= Replace(Request("var_extra_info_2_msg"),"'","''")
 strCOMPL_3_MSG			= Replace(Request("var_extra_info_3_msg"),"'","''")
 strCOMPL_4_MSG			= Replace(Request("var_extra_info_4_msg"),"'","''")

 strCERTIFICADO_TEXTO_INTL  = Replace(Request("var_certificadointl_texto"),"'","''")
 strDIPLOMA_TEXTO_INTL 		= Replace(Request("var_diplomaintl_texto"),"'","''")
 strCertificadopdf_INTL		= Replace(Request("var_certificadopdfintl_texto"),"'","''") 
 strDiplomapdf_INTL	   		= Replace(Request("var_diplomapdfintl_texto"),"'","''") 

 strCERTIFICADO_PDF_OR = Replace(Request("var_certificado_pdf_orientacao"),"'","''")

 strCAPACIDADE = Replace(Request("var_capacidade"),"'","''")
 If strCAPACIDADE = "" Or not IsNumeric(strCAPACIDADE) Then
   strCAPACIDADE = 0
 End If
 
 strREF_NUMERICA   = Replace(Request("var_ref_numerica"),"'","''")
 If strREF_NUMERICA = "" Or not IsNumeric(strREF_NUMERICA) Then
   strREF_NUMERICA = 0
 Else
   strREF_NUMERICA = Replace(Replace(strREF_NUMERICA,".",""),",",".")
 End If
 
 strDT_OCORRENCIA = Replace(Request("var_dt_ocorrencia"),"'","''")
 If IsDate(strDT_OCORRENCIA) Then
   strDT_OCORRENCIA = "'" & strIsoDate(strDT_OCORRENCIA) & "'"
 Else
   strDT_OCORRENCIA = "NULL"
 End If
 
 strDT_TERMINO = Replace(Request("var_dt_termino"),"'","''")
 If IsDate(strDT_TERMINO) Then
   strDT_TERMINO = "'" & strIsoDate(strDT_TERMINO) & "'"
 Else
   strDT_TERMINO = "NULL"
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
 
 strCAEX_SHOW = Replace(Request("var_caex_show"),"'","''")
 If strCAEX_SHOW = "" Then
   strCAEX_SHOW = "0"
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

 If strCOD_PROD_VALIDA <> "" Then
   strCOD_PROD_VALIDA = "'" & strCOD_PROD_VALIDA & "'"
 Else
   strCOD_PROD_VALIDA = "NULL"
 End If
  
 If strCertificadopdf <> "" Then
   strCertificadopdf = "'" & strCertificadopdf & "'"
 Else
   strCertificadopdf = "NULL"
 End If

If strCERTIFICADO_PDF_OR <> "" Then
   strCERTIFICADO_PDF_OR = "'" & strCERTIFICADO_PDF_OR & "'"
 Else
   strCERTIFICADO_PDF_OR = "NULL"
 End If


 If strDiplomapdf <> "" Then
   strDiplomapdf = "'" & strDiplomapdf & "'"
 Else
   strDiplomapdf = "NULL"
 End If
 
 
 If strGrupointl <> "" Then
   strGrupointl = "'" & strGrupointl & "'"
 Else
   strGrupointl = "NULL"
 End If
 
  
 If strTitulointl <> "" Then
   strTitulointl = "'" & strTitulointl & "'"
 Else
   strTitulointl = "NULL"
 End If
 
 
 If strDescricaointl <> "" Then
   strDescricaointl = "'" & strDescricaointl & "'"
 Else
   strDescricaointl = "NULL"
 End If 
 
 If strSINOPSE <> "" Then
   strSINOPSE = "'" & strSINOPSE & "'"
 Else
   strSINOPSE = "NULL"
 End If
 
 strDINAMICA = strToSQL(strDINAMICA)


 strCOMPL_SHOW = Replace(Request("var_extra_info_show"),"'","''")
 If strCOMPL_SHOW = "" Then
   strCOMPL_SHOW = "0"
 End If 
 strCOMPL_REQ = Replace(Request("var_extra_info_requerido"),"'","''")
 If strCOMPL_REQ = "" Then
   strCOMPL_REQ = "0"
 End If

 strCOMPL_2_SHOW = Replace(Request("var_extra_info_2_show"),"'","''")
 If strCOMPL_2_SHOW = "" Then
   strCOMPL_2_SHOW = "0"
 End If 
 strCOMPL_2_REQ = Replace(Request("var_extra_info_2_requerido"),"'","''")
 If strCOMPL_2_REQ = "" Then
   strCOMPL_2_REQ = "0"
 End If

 strCOMPL_3_SHOW = Replace(Request("var_extra_info_3_show"),"'","''")
 If strCOMPL_3_SHOW = "" Then
   strCOMPL_3_SHOW = "0"
 End If 
 strCOMPL_3_REQ = Replace(Request("var_extra_info_3_requerido"),"'","''")
 If strCOMPL_3_REQ = "" Then
   strCOMPL_3_REQ = "0"
 End If

 strCOMPL_4_SHOW = Replace(Request("var_extra_info_4_show"),"'","''")
 If strCOMPL_4_SHOW = "" Then
   strCOMPL_4_SHOW = "0"
 End If 
 strCOMPL_4_REQ = Replace(Request("var_extra_info_4_requerido"),"'","''")
 If strCOMPL_4_REQ = "" Then
   strCOMPL_4_REQ = "0"
 End If

' ========================================================================
' Faz a consistência para saber se os campos informados já existem
' ========================================================================
Function CheckFieldsExist()
Dim strSQL, objRS, bolTemRegistro

	strSQL = "SELECT COD_PROD " &_
             "  FROM tbl_PRODUTOS " &_ 
             " WHERE COD_PROD = " & strCOD_PROD 
'			 " AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")

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
  
  strSQL = "INSERT INTO tbl_PRODUTOS (COD_PROD, GRUPO, TITULO, DESCRICAO, CAPACIDADE, REF_NUMERICA, DT_OCORRENCIA, DT_TERMINO, COD_EVENTO,  LOCAL, CARGA_HORARIA, LOJA_SHOW, CAEX_SHOW, NUM_COMPETIDOR_START, CERTIFICADO_TEXTO, DIPLOMA_TEXTO, COD_PROD_VALIDA"&_ 
  ", EXTRA_INFO_SHOW, EXTRA_INFO_MSG, EXTRA_INFO_REQUERIDO"&_
  ", EXTRA_INFO_2_SHOW, EXTRA_INFO_2_MSG, EXTRA_INFO_2_REQUERIDO"&_ 
  ", EXTRA_INFO_3_SHOW, EXTRA_INFO_3_MSG, EXTRA_INFO_3_REQUERIDO"&_ 
  ", EXTRA_INFO_4_SHOW, EXTRA_INFO_4_MSG, EXTRA_INFO_4_REQUERIDO"&_ 
  ", CERTIFICADO_PDF, DIPLOMA_PDF, GRUPO_INTL, TITULO_INTL, DESCRICAO_INTL, SINOPSE, DINAMICA, CERTIFICADO_PDF_ORIENTACAO, CERTIFICADO_TEXTO_INTL, DIPLOMA_TEXTO_INTL, CERTIFICADO_PDF_INTL, DIPLOMA_PDF_INTL ) " &_
           "VALUES (" & strCOD_PROD &_
		   			",'" & strGRUPO &_
					"','" & strTITULO &_
					"','" & strDESCRICAO &_
					"'," & strCAPACIDADE &_
					"," & strREF_NUMERICA &_
					"," & strDT_OCORRENCIA &_
					"," & strDT_TERMINO &_
					"," & Session("COD_EVENTO") &_
					"," & strLOCAL &_
					"," & strCARGA_HORARIA &_
					"," & strLOJA_SHOW &_
					"," & strCAEX_SHOW &_
					"," & strNUM_COMPETIDOR_START &_
					"," & strCERTIFICADO_TEXTO &_
					"," & strDIPLOMA_TEXTO &_
					"," & strCOD_PROD_VALIDA &_
					"," & strCOMPL_SHOW &_
					"," & strToSQL(strCOMPL_MSG) &_
					"," & strCOMPL_REQ &_
					"," & strCOMPL_2_SHOW &_
					"," & strToSQL(strCOMPL_2_MSG) &_
					"," & strCOMPL_2_REQ &_
					"," & strCOMPL_3_SHOW &_
					"," & strToSQL(strCOMPL_3_MSG) &_
					"," & strCOMPL_3_REQ &_
					"," & strCOMPL_4_SHOW &_
					"," & strToSQL(strCOMPL_3_MSG) &_
					"," & strCOMPL_4_REQ &_
					"," & strCertificadopdf &_
					"," & strDiplomapdf &_
					"," & strGrupointl &_
					"," & strTitulointl &_
					"," & strDescricaointl &_
					"," & strSINOPSE &_
					"," & strDINAMICA &_
					"," & strCERTIFICADO_PDF_OR &_
					"," & strToSQL(strCERTIFICADO_TEXTO_INTL) &_
					"," & strToSQL(strDIPLOMA_TEXTO_INTL) &_
					"," & strToSQL(strCertificadopdf_INTL) &_
					"," & strToSQL(strDiplomapdf_INTL) &_
					") "

  objConn.Execute(strSQL)	
End Sub

Function proximoRegistro()
	Dim strSQL_Local, objRS_Local
	
	strSQL_Local = " SELECT MAX(COD_PROD) AS COD_PROD FROM tbl_PRODUTOS ORDER BY COD_PROD DESC"
	Set objRS_Local = objConn.execute(strSQL_Local)
	
	If objRS_Local("COD_PROD")&"" = "" or IsNull(objRS_Local("COD_PROD")) Then 
	  proximoRegistro = 1
	Else
	  proximoRegistro = Clng(objRS_Local("COD_PROD")) + 1
	End If
	
	FechaRecordSet(objRS_Local)
End Function

' ========================================================================
' Principal ==============================================================
' ========================================================================

Dim objConn

	AbreDBConn objConn, CFG_DB_DADOS
	
	If strCOD_PROD = "" Or strCOD_PROD = 0 Then strCOD_PROD = proximoRegistro() End If
	
	If (FiedsRequired((strDESCRICAO="")Or(strGRUPO="")Or(strTITULO="")) And CheckFieldsExist()) Then
		GravaCadastro()
		
		Server.Execute("geraviewprodutos.asp")
		
		response.Redirect("insert.asp?mode="&Request("mode"))
	End If
	
	FechaDBConn ObjConn
' ========================================================================
%>