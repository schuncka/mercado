<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_Paper",Session("METRO_USER_ID_USER")), true %>
<%
 Dim objConn, ObjRS, objRSDetail, strSQL, strSQLClause, strCERTIFICADO
 Dim strCOD_PAPER, strCOD_PAPER_CADASTRO, strCOD_EMPRESA, strCOD_EVENTO, strORDER
 Dim auxstr2, auxstr3, strFields
 Dim strDT_OCORRENCIA
 Dim strSTATUS, strDT_APRESENTACAO,	strFORMA_APRESENTACAO
 Dim strAVALIACAO, i, strNOME
 Dim Pdf, Doc, Filename, strURL, strlog
 
 strCOD_PAPER_CADASTRO	= getParam("var_cod_paper_cadastro")
 strCOD_EMPRESA		 	= getParam("var_cod_empresa")
 strCOD_EVENTO			= getParam("var_cod_evento")

 If strCOD_PAPER_CADASTRO = "" Then
	strCOD_PAPER_CADASTRO = "0"
 End If

 AbreDBConn objConn, CFG_DB

 strSQL = "         SELECT p.COD_PAPER, ps.CERTIFICADO_PDF" 
 strSQL = strSQL & "  FROM tbl_Paper P INNER JOIN tbl_Paper_Cadastro PC on P.COD_PAPER = PC.COD_PAPER "
 strSQL = strSQL & " INNER JOIN tbl_Paper_Status PS on PC.COD_PAPER_STATUS = PS.COD_PAPER_STATUS "
 strSQL = strSQL & " WHERE p.COD_EVENTO = " & strCOD_EVENTO
 strSQL = strSQL & "   AND pc.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
			 
 strCERTIFICADO = ""
 strFields		= ""
 
 'Set objRS = Server.CreateObject("ADODB.RecordSet")
 'objRS.Open strSQL, objConn, adOpenKeySet
 set objRS = objConn.Execute(strSQL)  
 If not objRS.EOF then
	strCOD_PAPER	= getValue(objRS,"COD_PAPER")
	strCERTIFICADO	= getValue(objRS,"CERTIFICADO_PDF")
	while InStr(strCERTIFICADO,"[") > 0
		auxstr = Mid (strCERTIFICADO,InStr(strCERTIFICADO,"["),InStr(strCERTIFICADO,"]")-InStr(strCERTIFICADO,"[")+1)
		strFields = strFields & "," & auxstr   
		auxstr2 = Mid (auxstr, InStr(auxstr,".")+1, InStr(auxstr,"]")-InStr(auxstr,".")-1)
		strCERTIFICADO = replace (strCERTIFICADO, auxstr, "<ASP.BEGIN>"&auxstr2&"<ASP.END>" )
	wend
 End If
 FechaRecordSet ObjRS

 strFields = Replace(Replace(strFields,"[",""),"]","")
 strSQL = " SELECT tbl_Paper_Cadastro.COD_PAPER_CADASTRO" 
 strSQL = strSQL & "  ,tbl_Paper.COD_PAPER" 
 strSQL = strSQL & " ,tbl_Paper.DESCRICAO"  
 strSQL = strSQL & " ,tbl_Paper.CERTIFICADO" 
 strSQL = strSQL & " ,tbl_Paper.CERTIFICADO_PDF"  
 strSQL = strSQL & " ,tbl_Paper.CERTIFICADO_PDF_ORIENTACAO" 
 strSQL = strSQL & " ,tbl_Paper_Cadastro.SYS_DATAFINISH" 
 strSQL = strSQL & " ,tbl_Paper_Cadastro.DT_APRESENTACAO" 
 strSQL = strSQL & " ,tbl_Paper_Cadastro.FORMA_APRESENTACAO"  
 strSQL = strSQL & " ,tbl_Empresas.COD_EMPRESA" 
 strSQL = strSQL & " ,tbl_Empresas.NOMECLI"  
 strSQL = strSQL & " ,tbl_EMPRESAS.END_FULL " 
 strSQL = strSQL & " ,tbl_EMPRESAS.END_BAIRRO " 
 strSQL = strSQL & " ,tbl_EMPRESAS.END_CIDADE " 
 strSQL = strSQL & " ,tbl_EMPRESAS.END_ESTADO " 
 strSQL = strSQL & " ,tbl_EMPRESAS.END_CEP " 
 strSQL = strSQL & " ,tbl_EMPRESAS.END_PAIS " 
 strSQL = strSQL & " ,tbl_EMPRESAS.ID_NUM_DOC1 " 
 strSQL = strSQL & " ,tbl_EMPRESAS.SENHA " 
 strSQL = strSQL & " ,tbl_EMPRESAS.FONE1 " 
 strSQL = strSQL & " ,tbl_EMPRESAS.FONE2 " 
 strSQL = strSQL & " ,tbl_EMPRESAS.FONE3 " 
 strSQL = strSQL & " ,tbl_EMPRESAS.FONE4 " 
 strSQL = strSQL & " ,tbl_EMPRESAS.EMAIL1 " 
 strSQL = strSQL & " ,tbl_EMPRESAS.NOMEFAN " 
 strSQL = strSQL & " ,tbl_Paper_Area.AREA_PAPER "  
 strSQL = strSQL & " ,tbl_Paper_Status.STATUS"  
 strSQL = strSQL & strFields 
 strSQL = strSQL & " FROM (((tbl_Paper_Cadastro INNER JOIN tbl_Paper ON (tbl_Paper_Cadastro.COD_PAPER = tbl_Paper.COD_PAPER))" 
 strSQL = strSQL & "         INNER JOIN tbl_Empresas ON (tbl_Paper_Cadastro.COD_EMPRESA = tbl_Empresas.COD_EMPRESA)) " 
 strSQL = strSQL & "         LEFT OUTER JOIN tbl_Paper_Area ON (tbl_Paper_Cadastro.COD_PAPER_AREA = tbl_Paper_Area.COD_PAPER_AREA)) " 
 strSQL = strSQL & "         LEFT OUTER JOIN tbl_Paper_Status ON (tbl_Paper_Cadastro.COD_PAPER_STATUS = tbl_Paper_Status.COD_PAPER_STATUS) " 
 strSQL = strSQL & " WHERE tbl_Paper_Cadastro.SYS_DATAFINISH IS NOT NULL " 
 strSQL = strSQL & "   AND tbl_Paper.COD_EVENTO = " & strCOD_EVENTO 
 strSQL = strSQL & "   AND tbl_Paper_Cadastro.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO

 set objRS = objConn.Execute(strSQL)
 'set objRS = Server.CreateObject("ADODB.Recordset")
 'objRS.Open strSQL, objConn 

 If Not objRS.EOF Then
	auxstr  = strCERTIFICADO
	while InStr(auxstr,"<ASP.BEGIN>") > 0
		auxstr2 = Mid (auxstr,InStr(auxstr,"<ASP.BEGIN>"),InStr(auxstr,"<ASP.END>")-InStr(auxstr,"<ASP.BEGIN>")+9)
		auxstr3 = Replace(Replace(auxstr2,"<ASP.BEGIN>",""),"<ASP.END>","") ' Pega o nome do campo na tabela
		'TRatamento para ver qual nome utilizar no certificado: TBL_EMPRESAS ou tbl_Empresas_Sub
		'If (UCase(auxstr3) = "NOMECLI" Or UCase(auxstr3) = "NOMEFAN") AND objRS("TIPO_PESS") = "N" AND strNOME <> "" Then
			'  auxstr3 = strNOME
		'Else
			auxstr3 = getValue(ObjRS,auxstr3)
		'End If
		auxstr  = replace (auxstr, auxstr2, auxstr3)
	wend
	strSTATUS				= getValue(objRS,"STATUS")
	strDT_APRESENTACAO		= getValue(objRS,"DT_APRESENTACAO")
	strFORMA_APRESENTACAO	= getValue(objRS,"FORMA_APRESENTACAO")
 End If
 auxstr = Replace(auxstr, "<PRO_COD_PAPER_CADASTRO>", strCOD_PAPER_CADASTRO)
 auxstr = Replace(auxstr, "<PRO_STATUS>", strSTATUS)
 auxstr = Replace(auxstr, "<PRO_DT_APRESENTACAO>", strDT_APRESENTACAO)
 auxstr = Replace(auxstr, "<PRO_FORMA_APRESENTACAO>", strFORMA_APRESENTACAO)

 strSQL =          " SELECT PSV.COD_PAPER_SUB, PS.CAMPO_NOME, PSV.CAMPO_VALOR "
 strSQL = strSQL & "   FROM TBL_PAPER_CADASTRO PC INNER JOIN TBL_PAPER_SUB PS ON PC.COD_PAPER = PS.COD_PAPER"
 strSQL = strSQL & "                              LEFT  JOIN TBL_PAPER_SUB_VALOR PSV ON PC.COD_PAPER_CADASTRO = PSV.COD_PAPER_CADASTRO AND PS.COD_PAPER_SUB = PSV.COD_PAPER_SUB"
 strSQL = strSQL & "  WHERE PC.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
 strSQL = strSQL & "    AND PC.COD_EMPRESA = '" & strCOD_EMPRESA & "'"
 set objRSDetail = objConn.Execute(strSQL)
 Do While not objRSDetail.EOF 
	auxstr = Replace(auxstr&"", "<PRO_PAPER_" & getValue(objRSDetail,"CAMPO_NOME") & ">", getValue(objRSDetail,"CAMPO_VALOR") )
	objRSDetail.MoveNext
 Loop
 FechaRecordSet objRSDetail
	

 strSQL =          "SELECT * FROM tbl_paper_avaliacao "
 strSQL = strSQL & " WHERE cod_paper_cadastro = " & strCOD_PAPER_CADASTRO
 set objRSDetail = objConn.Execute(strSQL)
 Do While not objRSDetail.EOF 
	strAVALIACAO = strAVALIACAO & objRSDetail("EXPLICACAO")&"<br>"
	strAVALIACAO = strAVALIACAO & "<hr>"
	objRSDetail.MoveNext
 Loop
 auxstr = Replace(auxstr, "<PRO_AVALIACAO>", strAVALIACAO)
 FechaRecordSet objRSDetail
 FechaRecordSet ObjRS

	 
 If strCOD_EMPRESA <> "" Then
	strSQL = "INSERT INTO tbl_EMPRESAS_HIST (COD_EMPRESA, SYS_USERCA, SYS_DATACA, HISTORICO) VALUES ("&strCOD_EMPRESA&",'PAX',NOW(),'CERTIFICADO PDF - SUBMISSAO TRABALHO "& strCOD_PAPER_CADASTRO &"')"
	objConn.Execute(strSQL)
 End If
 FechaDBConn ObjConn


 auxstr = Replace(auxstr," ,",",")
 auxstr = Replace(auxstr,",,","")

 Set Pdf = Server.CreateObject("Persits.Pdf")
 Set Doc = Pdf.CreateDocument
 'Doc.ImportFromUrl "<html>" & auxstr & "</html>", "landscape=true"
 strLog = Doc.ImportFromUrl ("<html><body style='-webkit-print-color-adjust: exact;'>" & auxstr & "</body></html>","Landscape=true,DrawBackground=true,LeftMargin=10,TopMargin=20,RightMargin=10,BottomMargin=20,PageWidth=598,PageHeight=842")
 Filename = Doc.Save( Server.MapPath("..")&"\export\"& "certificado_paper_" & strCOD_PAPER & "_" & strCOD_PAPER_CADASTRO & ".pdf", True )
 set Doc = Nothing
 set Pdf = Nothing
 Response.Redirect("../export/"&Filename)
%>