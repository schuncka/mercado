<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_Certificado",Session("METRO_USER_ID_USER")), true %>
<%
 Dim objConn, ObjRS, objRSDetail, strSQL, strSQLClause, strDIPLOMA
 Dim strCOD_PROD, strCOD_PALESTRANTE, strCOD_EMPRESA, strCOD_EVENTO, strINSCRICAO_VISITADA, strORDER
 Dim auxstr2, auxstr3, strFields
 Dim strDT_OCORRENCIA, strCOD_PROD_CERTIFICADO_IMPRESSO, strEND_PAIS, strFuncao, strTEMA
 Dim i, strNOME, strDIPLOMA_ORIENTACAO
 Dim Pdf, Doc, Filename, strURL, strlog

 strCOD_PROD 		= GetParam("var_cod_prod")
 strCOD_PALESTRANTE = GetParam("var_cod_palestrante")
 strFuncao			= GetParam("var_funcao")
 strTEMA			= GetParam("var_tema")
 strCOD_EMPRESA 	= GetParam("var_cod_empresa")
 strCOD_EVENTO 		= GetParam("var_cod_evento")

 If strCOD_PROD = "" Then
	strCOD_PROD = "0"
 End If

 AbreDBConn objConn, CFG_DB

 strDT_OCORRENCIA = ""
 strSQL = "SELECT DT_OCORRENCIA FROM TBL_PRODUTOS WHERE COD_PROD = " & strCOD_PROD
 set objRSDetail = objConn.Execute(strSQL)
 If not objRSDetail.EOF Then
	strDT_OCORRENCIA = getValue(objRSDetail,"DT_OCORRENCIA")
 End If
 FechaRecordSet objRSDetail


 strSQL = "SELECT END_PAIS FROM TBL_EMPRESAS WHERE COD_EMPRESA = '" & strCOD_EMPRESA & "'"
 set objRSDetail = objConn.Execute(strSQL)
 strEND_PAIS = "BRASIL"
 If not objRSDetail.EOF Then
	strEND_PAIS = getValue(objRSDetail,"END_PAIS")
 End If
 FechaRecordSet objRSDetail


 strDIPLOMA	= ""
 strFields	= ""

 strSQL = "			  SELECT DIPLOMA_PDF, DIPLOMA_PDF_INTL, CERTIFICADO_PDF_ORIENTACAO "
 strSQL =  strSQL & "   FROM tbl_Produtos "
 strSQL =  strSQL & "  WHERE COD_EVENTO = " & strCOD_EVENTO
 strSQL =  strSQL & "    AND COD_PROD = " & strCOD_PROD
 set objRS = objConn.Execute(strSQL)  
 If not objRS.EOF then
	strDIPLOMA = getValue(objRS,"DIPLOMA_PDF_INTL")
	If not ((strEND_PAIS <> "BRASIL") and (strDIPLOMA <> "")) Then
		strDIPLOMA = getValue(objRS,"DIPLOMA_PDF")
	End If
	strDIPLOMA_ORIENTACAO = getValue(objRS,"CERTIFICADO_PDF_ORIENTACAO") 'usa amesma configuraçãod e orientação do CERTIFICADO
	
	while InStr(strDIPLOMA,"[") > 0
		auxstr		= Mid (strDIPLOMA,InStr(strDIPLOMA,"["),InStr(strDIPLOMA,"]")-InStr(strDIPLOMA,"[")+1)
		strFields	= strFields & "," & auxstr   
		auxstr2 	= Mid (auxstr, InStr(auxstr,".")+1, InStr(auxstr,"]")-InStr(auxstr,".")-1)
		strDIPLOMA	= replace (strDIPLOMA, auxstr, "<ASP.BEGIN>"&auxstr2&"<ASP.END>" )
		wend
 End If
 strFields = Replace(Replace(strFields,"[",""),"]","")
 FechaRecordSet ObjRS


 strSQL = " SELECT tbl_Empresas.COD_EMPRESA, tbl_Empresas.EMAIL1, tbl_Produtos.COD_PROD AS COD_PROD_DUMMY " & strFields 
 strSQL =  strSQL & " FROM tbl_Produtos, tbl_Palestrante, tbl_Produtos_Palestrante, tbl_Palestrante_Evento, tbl_Empresas" 
 strSQL =  strSQL & " WHERE  tbl_Produtos.COD_PROD = tbl_Produtos_Palestrante.COD_PROD " 
 strSQL =  strSQL & "   AND  tbl_Palestrante.COD_PALESTRANTE = tbl_Produtos_Palestrante.COD_PALESTRANTE " 
 strSQL =  strSQL & "   AND  tbl_Palestrante.COD_PALESTRANTE = tbl_Palestrante_Evento.COD_PALESTRANTE " 
 strSQL =  strSQL & "   AND  tbl_Palestrante_Evento.COD_EVENTO =  " & strCOD_EVENTO 
 strSQL =  strSQL & "   AND  tbl_Palestrante.COD_EMPRESA = tbl_Empresas.COD_EMPRESA " 
 strSQL =  strSQL & "   AND  tbl_Produtos.COD_PROD = " & strCOD_PROD 
 strSQL =  strSQL & "   AND  tbl_Produtos_Palestrante.COD_PALESTRANTE = " & strCOD_PALESTRANTE 
 strSQL =  strSQL & "   AND  tbl_Produtos.COD_EVENTO = " & strCOD_EVENTO 
 if strFuncao <> "" then
	strSQL = strsql & "   and tbl_Produtos_Palestrante.funcao LIKE '" & strFuncao & "'" 
 end if
 if strTEMA <> "" then
	strSQL = strsql & "   and tbl_Produtos_Palestrante.tema LIKE '" & strTEMA & "'" 
 end if 
 strSQL = strsql & " ORDER BY tbl_Produtos.GRUPO, tbl_Produtos.TITULO, tbl_Empresas.NOMECLI"
 set objRS = objConn.Execute(strSQL)
 'set objRS = Server.CreateObject("ADODB.Recordset")
 'objRS.Open strSQL, objConn 
 If Not objRS.EOF Then
	auxstr  = strDIPLOMA
    strNOME = ""
	while InStr(auxstr,"<ASP.BEGIN>") > 0
		auxstr2 = Mid (auxstr,InStr(auxstr,"<ASP.BEGIN>"),InStr(auxstr,"<ASP.END>")-InStr(auxstr,"<ASP.BEGIN>")+9)
		auxstr3 = Replace(Replace(auxstr2,"<ASP.BEGIN>",""),"<ASP.END>","") ' Pega o nome do campo na tabela
		'Tratamento para ver qual nome utilizar no certificado: TBL_EMPRESAS ou tbl_Empresas_Sub
		'If (UCase(auxstr3) = "NOMECLI" Or UCase(auxstr3) = "NOMEFAN") AND objRS("TIPO_PESS") = "N" AND strNOME <> "" Then
			'auxstr3 = strNOME
		'Else
			auxstr3 = getValue(ObjRS,auxstr3) & ""
		'End If
		auxstr  = replace (auxstr, auxstr2, auxstr3)
	wend
 End If
 FechaRecordSet ObjRS
	 
 objConn.Execute(strSQL)
	 
 If strCOD_EMPRESA <> "" Then
	strSQL = "INSERT INTO tbl_EMPRESAS_HIST (COD_EMPRESA, SYS_USERCA, SYS_DATACA, HISTORICO) VALUES (" & strCOD_EMPRESA & ",'PAX',NOW(),'DIPLOMA PDF - PRODUTO "& strCOD_PROD &"')"
	objConn.Execute(strSQL)
 End If
 FechaDBConn ObjConn


 Select Case UCase(strDIPLOMA_ORIENTACAO)
	Case "PAISAGEM"	strDIPLOMA_ORIENTACAO = "true"
	Case "RETRATO"	strDIPLOMA_ORIENTACAO = "false"
	Case Else		strDIPLOMA_ORIENTACAO = "true"
 End Select

 set Pdf = Server.CreateObject("Persits.Pdf")
 set Doc = Pdf.CreateDocument
 'Doc.ImportFromUrl "<html>" & auxstr & "</html>", "landscape=true"
 strLog = Doc.ImportFromUrl ("<html>" & auxstr & "</html>","Landscape=" & strDIPLOMA_ORIENTACAO & ",DrawBackground=true,LeftMargin=10,TopMargin=20,RightMargin=10,BottomMargin=20,PageWidth=598,PageHeight=842")
 Filename = Doc.Save( Server.MapPath("..")&"\export\"& "diploma_" & strCOD_PROD & "_" & strCOD_PALESTRANTE & ".pdf", True )
 set Doc = Nothing
 set Pdf = Nothing

 Response.Redirect("../export/" & Filename)
%>  
