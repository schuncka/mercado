<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"-->
<!--#include file="../_database/athutils.asp"--> 
<%
 Dim strCOD_PROD, strGRUPO, strTITULO, strTITULO_MINI, strDESCRICAO, strCAPACIDADE, strREF_NUMERICA, strDT_OCORRENCIA, strDT_TERMINO, strIMG
 Dim strLOCAL, strCARGA_HORARIA, strLOJA_SHOW, strCAEX_SHOW, strNUM_COMPETIDOR_START, strCERTIFICADO_TEXTO, strDIPLOMA_TEXTO, strVOUCHER_TEXTO, strVOUCHER_TEXTO_US, strVOUCHER_TEXTO_ES, strCOD_PROD_VALIDA, strCERTIFICADO_COD_PROD_VALIDA, strCERTIFICADO_COD_MATERIAL, strCERTIFICADO_COD_QUESTIONARIO, strCERTIFICADO_COD_PROD_MIN, strCERTIFICADO_DT_RETIRADA_MATERIAL
 Dim strSINOPSE, strDINAMICA, strBGCOLOR, strCERTIFICADO_PDF_OR, strORDEM
 Dim strCertificadopdf, strDiplomapdf, strGrupointl, strTitulointl, strDescricaointl
 Dim strCERTIFICADO_TEXTO_INTL, strDIPLOMA_TEXTO_INTL, strCertificadopdf_INTL, strDiplomapdf_INTL
 Dim strCOMPL_SHOW, strCOMPL_2_SHOW, strCOMPL_3_SHOW, strCOMPL_4_SHOW
 Dim strCOMPL_REQ, strCOMPL_2_REQ, strCOMPL_3_REQ, strCOMPL_4_REQ
 Dim strCOMPL_MSG, strCOMPL_2_MSG, strCOMPL_3_MSG, strCOMPL_4_MSG
 Dim strCERTIFICADO_VINCULO_COD_QUESTIONARIO, strCERTIFICADO_NRO_PRODUTOS_MIN, strCERTIFICADO_CARGA_HORARIA_MIN
 Dim strLOJA_EDIT_QTDE, strQTDE_MAX_UNIT,strLOJA_AGENDA_SHOW,strLOJA_TIPO_RESTRICAO, strCHECKIN_SHOW, strDESCRICAO_HTML, strDESCRICAO_HTML_ING, strDESCRICAO_HTML_ESP
 Dim strDownloadVinculoQuestionario, intProshopQuestionario
 

 intProshopQuestionario = Replace(Request("var_proshop_questionario"),"'","''")
 
 
 strCertificadopdf		= Replace(Request("var_certificadopdf_texto"),"'","''") 
 strDiplomapdf	   		= Replace(Request("var_diplomapdf_texto"),"'","''") 
 strGrupointl			= Replace(Request("var_grupointl_texto"),"'","''")
 strTitulointl			= Replace(Request("var_titulointl_texto"),"'","''") 
 strDescricaointl		= Replace(Request("var_descricaointl_texto"),"'","''")	 
  
 strCOD_PROD 		 	= Replace(Request("var_cod_prod"),"'","''")
 strCOD_PROD_VALIDA  	= Replace(Request("var_cod_prod_valida"),"'","''")
 
 strCERTIFICADO_COD_PROD_VALIDA	= Replace(Request("var_certificado_cod_prod_valida"),"'","''")
 strCERTIFICADO_VINCULO_COD_QUESTIONARIO	    = Replace(Request("var_certificado_vinculo_cod_questionario"),"'","''")
 strCERTIFICADO_NRO_PRODUTOS_MIN				= Replace(Request("var_certificado_nro_produtos_min"),"'","''")
 strCERTIFICADO_CARGA_HORARIA_MIN	   		    = Replace(Request("var_certificado_carga_horaria_min"),"'","''")
 
 strCERTIFICADO_DT_RETIRADA_MATERIAL = Replace(Request("var_certificado_dt_retirada_material"),"'","''")
 strGRUPO			 	= Replace(Request("var_grupo"),"'","''")
 strTITULO				= Replace(Request("var_titulo"),"'","''")
 strTITULO_MINI			= Replace(Request("var_titulo_mini"),"'","''")
 strDESCRICAO			= Replace(Request("var_descricao"),"'","''")
 strDESCRICAO_HTML		= Replace(Request("var_descricao_html"),"'","''")
 strDESCRICAO_HTML_ING	= Replace(Request("var_descricao_html_ing"),"'","''")
 strDESCRICAO_HTML_ESP	= Replace(Request("var_descricao_html_esp"),"'","''")
 strSINOPSE   			= Replace(Request("var_sinopse"),"'","''")
 strDINAMICA   			= Replace(Request("var_dinamica"),"'","''")
 strCERTIFICADO_TEXTO   = Replace(Request("var_certificado_texto"),"'","''")
 strDIPLOMA_TEXTO 		= Replace(Request("var_diploma_texto"),"'","''")
 strVOUCHER_TEXTO 		= Replace(Request("var_voucher_texto"),"'","''")
 strVOUCHER_TEXTO_US	= Replace(Request("var_voucher_texto_us"),"'","''")
 strVOUCHER_TEXTO_ES	= Replace(Request("var_voucher_texto_es"),"'","''")
 
 strDownloadVinculoQuestionario = replace(request("var_download_vinculo_cod_questionario"),"'","''")
   
 strCOMPL_MSG			= Replace(Request("var_extra_info_msg"),"'","''")
 strCOMPL_2_MSG			= Replace(Request("var_extra_info_2_msg"),"'","''")
 strCOMPL_3_MSG			= Replace(Request("var_extra_info_3_msg"),"'","''")
 strCOMPL_4_MSG			= Replace(Request("var_extra_info_4_msg"),"'","''")

 strBGCOLOR				= Replace(Request("var_bgcolor"),"'","''")
 strIMG 				= Replace(Request("var_img"),"'","''")
 strORDEM               = Replace(Request("var_ordem"),"'","''")

 strCERTIFICADO_TEXTO_INTL  = Replace(Request("var_certificadointl_texto"),"'","''")
 strDIPLOMA_TEXTO_INTL 		= Replace(Request("var_diplomaintl_texto"),"'","''")
 strCertificadopdf_INTL		= Replace(Request("var_certificadopdfintl_texto"),"'","''") 
 strDiplomapdf_INTL	   		= Replace(Request("var_diplomapdfintl_texto"),"'","''") 



 strCERTIFICADO_PDF_OR	= Replace(Request("var_certificado_pdf_orientacao"),"'","''")

 strCAPACIDADE  = Replace(Request("var_capacidade"),"'","''")
 If strCAPACIDADE = "" Or not IsNumeric(strCAPACIDADE) Then
   strCAPACIDADE = 0
 End If
 
 strREF_NUMERICA   = Replace(Request("var_ref_numerica"),"'","''")
 If strREF_NUMERICA = "" Or not IsNumeric(strREF_NUMERICA) Then
   strREF_NUMERICA = 0
 Else
   strREF_NUMERICA = Replace(Replace(strREF_NUMERICA,".",""),",",".")
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
'-----------SHOPAGENDA 29/08/16------------------------------------------  
 strLOJA_AGENDA_SHOW = Replace(Request("var_loja_agenda_show"),"'","''")
 If strLOJA_AGENDA_SHOW = "" Then
   strLOJA_AGENDA_SHOW = "0"
 End If 
'------------------------------------------------------------------------
'-----------SHOPAGENDA 29/08/16------------------------------------------  
 strLOJA_TIPO_RESTRICAO = Replace(Request("var_loja_tipo_restricao"),"'","''")
 If strLOJA_TIPO_RESTRICAO = "" Then
   strLOJA_TIPO_RESTRICAO = "OR"
 End If 
'------------------------------------------------------------------------



 strLOJA_SHOW = Replace(Request("var_loja_show"),"'","''")
 If strLOJA_SHOW = "" Then
   strLOJA_SHOW = "0"
 End If 

 strCAEX_SHOW = Replace(Request("var_caex_show"),"'","''")
 If strCAEX_SHOW = "" Then
   strCAEX_SHOW = "0"
 End If 
  
 strCHECKIN_SHOW = Replace(Request("var_checkin_show"),"'","''")
 If strCHECKIN_SHOW = "" Then
   strCHECKIN_SHOW = "0"
 End If
  
 strNUM_COMPETIDOR_START = Replace(Request("var_num_competidor_start"),"'","''")
 If strNUM_COMPETIDOR_START = "" Then
   strNUM_COMPETIDOR_START = "0"
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

 If strCERTIFICADO_TEXTO <> "" Then
   strCERTIFICADO_TEXTO = "'" & strCERTIFICADO_TEXTO & "'"
 Else
   strCERTIFICADO_TEXTO = "NULL"
 End If

 If strVOUCHER_TEXTO <> "" Then
   strVOUCHER_TEXTO = "'" & strVOUCHER_TEXTO & "'"
 Else
   strVOUCHER_TEXTO = "NULL"
 End If

 If strVOUCHER_TEXTO_US <> "" Then
   strVOUCHER_TEXTO_US = "'" & strVOUCHER_TEXTO_US & "'"
 Else
   strVOUCHER_TEXTO_US = "NULL"
 End If

 If strVOUCHER_TEXTO_ES <> "" Then
   strVOUCHER_TEXTO_ES = "'" & strVOUCHER_TEXTO_ES & "'"
 Else
   strVOUCHER_TEXTO_ES = "NULL"
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

 strCERTIFICADO_COD_PROD_VALIDA = strToSQL(strCERTIFICADO_COD_PROD_VALIDA)
 If IsDate(strCERTIFICADO_DT_RETIRADA_MATERIAL) Then
   strCERTIFICADO_DT_RETIRADA_MATERIAL = "'" & strIsoDate(strCERTIFICADO_DT_RETIRADA_MATERIAL) & "'"
 Else
   strCERTIFICADO_DT_RETIRADA_MATERIAL = "NULL"
 End If
 '********************************************************  
 
 If intProshopQuestionario <> "" Then
   intProshopQuestionario =  intProshopQuestionario 
 Else
   intProshopQuestionario = "NULL"
 End If
 
 
 If strCERTIFICADO_VINCULO_COD_QUESTIONARIO <> "" Then
   strCERTIFICADO_VINCULO_COD_QUESTIONARIO = "'" & strCERTIFICADO_VINCULO_COD_QUESTIONARIO & "'"
 Else
   strCERTIFICADO_VINCULO_COD_QUESTIONARIO = "NULL"
 End If
 
 If strCERTIFICADO_NRO_PRODUTOS_MIN <> "" Then
   strCERTIFICADO_NRO_PRODUTOS_MIN = "'" & strCERTIFICADO_NRO_PRODUTOS_MIN & "'"
 Else
   strCERTIFICADO_NRO_PRODUTOS_MIN = "NULL"
 End If
 
 If strCERTIFICADO_CARGA_HORARIA_MIN <> "" Then
   strCERTIFICADO_CARGA_HORARIA_MIN = "'" & strCERTIFICADO_CARGA_HORARIA_MIN & "'"
 Else
   strCERTIFICADO_CARGA_HORARIA_MIN = "NULL"
 End If
 '********************************************************
 
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
 
 
 If not IsNumeric(strDownloadVinculoQuestionario) Then
 	strDownloadVinculoQuestionario = "NULL"
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

 If strBGCOLOR <> "" Then
   strBGCOLOR = "'" & strBGCOLOR & "'"
 Else
   strBGCOLOR = "NULL"
 End If
 
 If strTITULO_MINI <> "" Then
   strTITULO_MINI = "'" & strTITULO_MINI & "'"
 Else
   strTITULO_MINI = "NULL"
 End If


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
 
 If not IsNumeric(strORDEM) Then
   strORDEM = "null"
 End If
 
 strLOJA_EDIT_QTDE  = Replace(Request("var_loja_edit_qtde"),"'","''")
 If strLOJA_EDIT_QTDE = "" Or not IsNumeric(strLOJA_EDIT_QTDE) Then
   strLOJA_EDIT_QTDE = 0
 End If
 
 strQTDE_MAX_UNIT  = Replace(Request("var_qtde_max_unit"),"'","''")
 If strQTDE_MAX_UNIT = "" Or not IsNumeric(strQTDE_MAX_UNIT) Then
   strQTDE_MAX_UNIT = 0
 End If
 

' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro()
	Dim strSQL
	Dim strDT_INATIVO
	
    strSQL = " UPDATE tbl_PRODUTOS SET COD_PROD = " & strCOD_PROD &_
			 ", GRUPO = '" & strGRUPO &_
			 "', TITULO = '" & strTITULO &_
			 "', TITULO_MINI = " & strTITULO_MINI &_
			 ", DESCRICAO = '" & strDESCRICAO &_
			 "', DESCRICAO_HTML = '" &strDESCRICAO_HTML &_
			 "', DESCRICAO_HTML_ING = '" &strDESCRICAO_HTML_ING &_
			 "', DESCRICAO_HTML_ESP = '" &strDESCRICAO_HTML_ESP &_
			 "', CAPACIDADE = " & strCAPACIDADE &_
			 ", REF_NUMERICA = " & strREF_NUMERICA &_
			 ", DT_OCORRENCIA = " & strDT_OCORRENCIA &_
			 ", DT_TERMINO = " & strDT_TERMINO & "," & _
	         "  LOCAL = " & strLOCAL &_
			 ", CHECKIN_SHOW = " & strCHECKIN_SHOW &_
			 ", CARGA_HORARIA = " & strCARGA_HORARIA &_
			 ", LOJA_AGENDA_SHOW = " & strLOJA_AGENDA_SHOW &_
			 ", LOJA_TIPO_RESTRICAO = '" & strLOJA_TIPO_RESTRICAO & 	"'"&_			 
			 ", LOJA_SHOW = " & strLOJA_SHOW &_
			 ", CAEX_SHOW = " & strCAEX_SHOW &_
			 ", NUM_COMPETIDOR_START = " & strNUM_COMPETIDOR_START &_
			 ", CERTIFICADO_TEXTO = " & strCERTIFICADO_TEXTO &_
			 ", DIPLOMA_TEXTO = " & strDIPLOMA_TEXTO &_
			 ", VOUCHER_TEXTO = " & strVOUCHER_TEXTO &_
			 ", VOUCHER_TEXTO_US = " & strVOUCHER_TEXTO_US &_
			 ", VOUCHER_TEXTO_ES = " & strVOUCHER_TEXTO_ES &_
			 ", COD_PROD_VALIDA = " & strCOD_PROD_VALIDA &_
			 ", CERTIFICADO_DT_RETIRADA_MATERIAL = " & strCERTIFICADO_DT_RETIRADA_MATERIAL &_
			 ", CERTIFICADO_COD_PROD_VALIDA = " & strCERTIFICADO_COD_PROD_VALIDA &_
			 ", CERTIFICADO_VINCULO_COD_QUESTIONARIO = " & strCERTIFICADO_VINCULO_COD_QUESTIONARIO &_	 
			 ", CERTIFICADO_NRO_PRODUTOS_MIN = " & strCERTIFICADO_NRO_PRODUTOS_MIN &_
			 ", CERTIFICADO_CARGA_HORARIA_MIN = " & strCERTIFICADO_CARGA_HORARIA_MIN &_	
			 ", EXTRA_INFO_SHOW = " & strCOMPL_SHOW &_
			 ", EXTRA_INFO_MSG = " & strToSQL(strCOMPL_MSG) &_
			 ", EXTRA_INFO_REQUERIDO = " & strCOMPL_REQ &_
			 ", EXTRA_INFO_2_SHOW = " & strCOMPL_2_SHOW &_
			 ", EXTRA_INFO_2_MSG = " & strToSQL(strCOMPL_2_MSG) &_
			 ", EXTRA_INFO_2_REQUERIDO = " & strCOMPL_2_REQ &_
			 ", EXTRA_INFO_3_SHOW = " & strCOMPL_3_SHOW &_
			 ", EXTRA_INFO_3_MSG = " & strToSQL(strCOMPL_3_MSG) &_
			 ", EXTRA_INFO_3_REQUERIDO = " & strCOMPL_3_REQ &_
			 ", EXTRA_INFO_4_SHOW = " & strCOMPL_4_SHOW &_
			 ", EXTRA_INFO_4_MSG = " & strToSQL(strCOMPL_4_MSG) &_
			 ", EXTRA_INFO_4_REQUERIDO = " & strCOMPL_4_REQ &_
			 ", CERTIFICADO_PDF = " & strCertificadopdf &_
			 ", DIPLOMA_PDF = " & strDiplomapdf &_
			 ", GRUPO_INTL = " & strGrupointl &_
			 ", TITULO_INTL = " & strTitulointl &_
			 ", DESCRICAO_INTL = " & strDescricaointl &_
			 ", SINOPSE = " & strSINOPSE &_
			 ", DINAMICA = "& strDINAMICA &_
			 ", BGCOLOR = " & strBGCOLOR &_
			 ", ORDEM = " & strORDEM &_
			 ", IMG = " & strToSQL(strIMG) &_
			 ", CERTIFICADO_PDF_ORIENTACAO = " & strCERTIFICADO_PDF_OR &_
			 ", CERTIFICADO_TEXTO_INTL = " & strToSQL(strCERTIFICADO_TEXTO_INTL) &_
			 ", DIPLOMA_TEXTO_INTL = " & strToSQL(strDIPLOMA_TEXTO_INTL) &_
			 ", CERTIFICADO_PDF_INTL = " & strToSQL(strCertificadopdf_INTL)  &_
			 ", DIPLOMA_PDF_INTL = " & strToSQL(strDiplomapdf_INTL) &_
			 ", LOJA_EDIT_QTDE = " & strLOJA_EDIT_QTDE &_
			 ", QTDE_MAX_UNIT = " & strQTDE_MAX_UNIT &_
			 ", DOWNLOAD_VINCULO_COD_QUESTIONARIO = " & strDownloadVinculoQuestionario &_
			 ", PROSHOP_QUESTIONARIO = " & intProshopQuestionario &_
			 " WHERE COD_PROD = " & strCOD_PROD &_
			 "   AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")
	
	'DEBUG: 
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