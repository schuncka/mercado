<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_Certificado",Session("METRO_USER_ID_USER")), true %>
<%
 Dim objConn, ObjRS, objRSDetail, objLang, strSQL
 Dim strCOD_PROD, strCOD_INSCRICAO, strCOD_EMPRESA, strCOD_EVENTO 
 Dim strCERTIFICADO, strCERTIFICADO_ORIENTACAO, strCARGA_HORA_TOTAL, strPROD_PRESENCA_TOTAL
 Dim auxstr2, auxstr3, strFields
 Dim strDT_OCORRENCIA, strCOD_PROD_CERTIFICADO_IMPRESSO, strEND_PAIS,strCOD_STATUS_PRC,strSTATUS_PRECO,strCOD_STATUS_CRED,strSTATUS_CRED
 Dim i, strNOME
 Dim Pdf, Doc, Filename, strURL, strlog
 Dim strLOCALE

 strCOD_PROD		= getParam("var_cod_prod")
 strCOD_INSCRICAO	= getParam("var_cod_inscricao")
 strCOD_EMPRESA		= getParam("var_cod_empresa")
 strCOD_EVENTO		= getParam("var_cod_evento")

 If strCOD_PROD = "" Then
	strCOD_PROD = "0"
 End If

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------

 AbreDBConn objConn, CFG_DB


 strDT_OCORRENCIA = ""
 strSQL = "SELECT DT_OCORRENCIA FROM TBL_PRODUTOS WHERE COD_PROD = " & strCOD_PROD
 set objRSDetail = objConn.Execute(strSQL)
 If not objRSDetail.EOF Then
	strDT_OCORRENCIA = objRSDetail("DT_OCORRENCIA")
 End If
 FechaRecordSet objRSDetail


 strSQL = "SELECT END_PAIS FROM TBL_EMPRESAS WHERE COD_EMPRESA = '" & strCOD_EMPRESA & "'"
 set objRSDetail = objConn.Execute(strSQL)
 strEND_PAIS = "BRASIL"
 If not objRSDetail.EOF Then
	strEND_PAIS = getValue(objRSDetail,"END_PAIS")
 End If
 FechaRecordSet objRSDetail


 strCOD_PROD_CERTIFICADO_IMPRESSO = ""
 strSQL =          "SELECT COD_PROD FROM TBL_CERTIFICADO_LOG WHERE COD_EMPRESA = '"&strCOD_EMPRESA&"'"
 strSQL = strSQL & "   AND (COD_PROD = "&strCOD_PROD&" OR COD_PROD IN "
 strSQL = strSQL & "   (SELECT COD_PROD FROM TBL_PRODUTOS WHERE COD_EVENTO = "&strCOD_EVENTO
 strSQL = strSQL & "            AND DT_OCORRENCIA IS NOT NULL" 
 If IsNull(strDT_OCORRENCIA) Then
	strSQL = strSQL & "         AND DT_OCORRENCIA = '" & PrepDataIve(strDT_OCORRENCIA,True,False) & "'" 
 End If
 strSQL = strSQL & "            )"
 strSQL = strSQL & "    )"

 set objRSDetail = objConn.Execute(strSQL)
 If not objRSDetail.EOF Then
	'  strCOD_PROD_CERTIFICADO_IMPRESSO = objRSDetail("COD_PROD")
 End If
 FechaRecordSet objRSDetail


 If Cstr(strCOD_PROD_CERTIFICADO_IMPRESSO) = Cstr(strCOD_PROD) Or Cstr(strCOD_PROD_CERTIFICADO_IMPRESSO) = "" Then

	strSQL = " 		   SELECT CERTIFICADO_PDF, CERTIFICADO_PDF_INTL, CERTIFICADO_PDF_ORIENTACAO " 
	strSQL = strSQL & "  FROM tbl_Produtos " 
	strSQL = strSQL & " WHERE COD_EVENTO = " & strCOD_EVENTO 
	strSQL = strSQL & "   AND COD_PROD = "   & strCOD_PROD
	'set objRS = Server.CreateObject("ADODB.RecordSet")
	'objRS.Open strSQL, objConn, adOpenKeySet
	set objRS = objConn.Execute(strSQL)

	strCERTIFICADO	= ""
	strFields 		= ""
	If not objRS.EOF then
		strCERTIFICADO = getValue(objRS,"CERTIFICADO_PDF_INTL")
		If not ((strEND_PAIS <> "BRASIL") and (strCERTIFICADO <> "")) Then
			strCERTIFICADO = getValue(objRS,"CERTIFICADO_PDF")
		End If
		strCERTIFICADO_ORIENTACAO = getValue(objRS,"CERTIFICADO_PDF_ORIENTACAO")
		while InStr(strCERTIFICADO,"[") > 0
			auxstr			 = Mid (strCERTIFICADO,InStr(strCERTIFICADO,"["),InStr(strCERTIFICADO,"]")-InStr(strCERTIFICADO,"[")+1)
			strFields		 = strFields & "," & auxstr   
			auxstr2			 = Mid (auxstr, InStr(auxstr,".")+1, InStr(auxstr,"]")-InStr(auxstr,".")-1)
			strCERTIFICADO	 = replace (strCERTIFICADO, auxstr, "<ASP.BEGIN>" & auxstr2 & "<ASP.END>" )
		wend
	End If
	FechaRecordSet ObjRS


	strSQL =          " SELECT tbl_Produtos.COD_PROD AS COD_PROD_DUMMY,tbl_Empresas.COD_STATUS_CRED, tbl_Empresas.cod_status_preco, tbl_Inscricao.CODBARRA, tbl_Empresas.END_PAIS, tbl_Empresas.nomecli, tbl_Empresas.TIPO_PESS, IF(tbl_Empresas.SEXO='F',tbl_Atividade.TTO_F,tbl_Atividade.TTO_M) As TTO " & Replace(Replace(strFields,"[",""),"]","") 
'chamado cnseg pediu tag para total carga horaria assistida
	strSQL = strSQL & " , (SELECT substring(convert(SEC_TO_TIME(sum(TIME_TO_SEC(P.carga_horaria))),CHAR),1,5) FROM tbl_produtos p WHERE p.cod_prod IN (select distinct cp.cod_prod from tbl_controle_produtos cp  where cp.codbarra = tbl_INSCRICAO.codbarra and cp.cod_evento = tbl_INSCRICAO.cod_evento)) as CARGA_HORA_TOTAL "
	strSQL = strSQL & " , (select count(distinct(cp.cod_prod)) from tbl_controle_produtos cp where cp.codbarra = tbl_INSCRICAO.codbarra and cp.cod_evento = tbl_INSCRICAO.cod_evento) as PROD_PRESENCA_TOTAL "	
	strSQL = strSQL & "   FROM tbl_INSCRICAO INNER JOIN tbl_INSCRICAO_PRODUTO ON tbl_INSCRICAO.COD_INSCRICAO = tbl_INSCRICAO_PRODUTO.COD_INSCRICAO"
	strSQL = strSQL & "                       LEFT JOIN tbl_EMPRESAS ON tbl_INSCRICAO.COD_EMPRESA = tbl_EMPRESAS.COD_EMPRESA"
	strSQL = strSQL & "                       LEFT JOIN tbl_ATIVIDADE ON tbl_EMPRESAS.CODATIV1 = tbl_ATIVIDADE.CODATIV"
	strSQL = strSQL & "                       LEFT JOIN tbl_PRODUTOS ON (tbl_PRODUTOS.COD_PROD = tbl_INSCRICAO_PRODUTO.COD_PROD OR concat(',',tbl_PRODUTOS.COD_PROD_VALIDA,',') LIKE concat('%,',tbl_INSCRICAO_PRODUTO.COD_PROD,',%') ) "
	strSQL = strSQL & "                       LEFT JOIN tbl_produtos_palestrante ON (tbl_produtos_palestrante.cod_prod = tbl_produtos.cod_prod AND tbl_produtos_palestrante.cod_palestrante = (SELECT cod_palestrante FROM tbl_palestrante where tbl_palestrante.cod_empresa = '"&strCOD_EMPRESA&"'))"
	strSQL = strSQL & "  WHERE tbl_INSCRICAO.COD_EMPRESA = '"  & strCOD_EMPRESA & "'"
	strSQL = strSQL & "    AND tbl_INSCRICAO.COD_INSCRICAO = " & strCOD_INSCRICAO 
	strSQL = strSQL & "    AND tbl_PRODUTOS.COD_PROD = " 	   & strCOD_PROD
	strSQL = strSQL & "    AND tbl_INSCRICAO.COD_EVENTO = "    & strCOD_EVENTO
	' teste para ver se tem controle de leitura de salas minima para imprimir o certificado   
	strSQL = strSQL & "    AND ("
	strSQL = strSQL & "    ( tbl_PRODUTOS.CERTIFICADO_NRO_PRODUTOS_MIN IS NULL  AND tbl_PRODUTOS.CERTIFICADO_COD_PROD_VALIDA IS NULL )  "
	strSQL = strSQL & "    OR"
	strSQL = strSQL & "   IF(tbl_PRODUTOS.CERTIFICADO_NRO_PRODUTOS_MIN IS NULL,1,tbl_PRODUTOS.CERTIFICADO_NRO_PRODUTOS_MIN) <= (select count(distinct cod_prod) from tbl_controle_produtos where codbarra = tbl_INSCRICAO.codbarra and cod_evento = tbl_INSCRICAO.cod_evento and concat(',',tbl_PRODUTOS.CERTIFICADO_COD_PROD_VALIDA,',') LIKE concat('%,',cod_prod,',%') )"
	strSQL = strSQL & "    )"
	' teste para ver se tem carga horaria minima para imprimir o certificado
	strSQL = strSQL & "    AND ("
	strSQL = strSQL & "    tbl_PRODUTOS.CERTIFICADO_CARGA_HORARIA_MIN IS NULL "
	strSQL = strSQL & "    OR"
	strSQL = strSQL & "    tbl_PRODUTOS.CERTIFICADO_CARGA_HORARIA_MIN IS NULL < ("
	strSQL = strSQL & "    select sum(prod.carga_horaria)"
	strSQL = strSQL & "     from tbl_produtos prod"
	strSQL = strSQL & "    where prod.cod_prod in ("
	strSQL = strSQL & "             select distinct cp.cod_prod from tbl_controle_produtos cp  where cp.codbarra = tbl_INSCRICAO.codbarra and cp.cod_evento = tbl_INSCRICAO.cod_evento  and concat(',',tbl_PRODUTOS.CERTIFICADO_COD_PROD_VALIDA,',') LIKE concat('%,',cod_prod,',%')"
	strSQL = strSQL & "                           )"
	strSQL = strSQL & "                                      )"
	strSQL = strSQL & "    )"
	' teste para ver se a retirada de material autoriza  imprimir o certificado   
	strSQL = strSQL & "    AND ("
	strSQL = strSQL & "    tbl_PRODUTOS.CERTIFICADO_DT_RETIRADA_MATERIAL IS NULL  "
	strSQL = strSQL & "    OR"
	strSQL = strSQL & "    tbl_INSCRICAO_PRODUTO.SYS_DATAMAT > tbl_PRODUTOS.CERTIFICADO_DT_RETIRADA_MATERIAL"
	strSQL = strSQL & "    )"
'response.write(strSQL)
'response.end()
	Set objRS = Server.CreateObject("ADODB.Recordset")
	objRS.Open strSQL, objConn 
	If Not objRS.EOF Then
			auxstr  = strCERTIFICADO
			strNOME = ""
			strCOD_STATUS_PRC = getValue(objRS,"COD_STATUS_PRECO")
				
			If strCOD_STATUS_PRC <> "" Then
				strSQL = " SELECT STATUS FROM tbl_STATUS_PRECO WHERE COD_STATUS_PRECO = " & strCOD_STATUS_PRC
				Set objRSDetail = objConn.Execute(strSQL)
				If not objRSDetail.EOF then
					strSTATUS_PRECO = Trim(objRSDetail("STATUS"))
				End If
				FechaRecordSet objRSDetail
			End If
				
			auxstr = Replace(auxstr,"<PRO_STATUS_PRECO>",strSTATUS_PRECO&"")
			strCOD_STATUS_CRED = objRS("COD_STATUS_CRED")
	   
			If strCOD_STATUS_CRED <> "" Then
				strSQL = " SELECT STATUS FROM tbl_status_cred WHERE tbl_status_cred.cod_status_cred = " & strCOD_STATUS_CRED
				Set objRSDetail = objConn.Execute(strSQL)
				If not objRSDetail.EOF then
					strSTATUS_CRED = Trim(objRSDetail("STATUS"))
				End If
				FechaRecordSet objRSDetail
			End If
			auxstr = Replace(auxstr,"<PRO_STATUS_CRED>",strSTATUS_CRED&"")
	   
			strSQL = "SELECT NOME_COMPLETO from tbl_Empresas_Sub WHERE CODBARRA = " & strToSQL(getValue(objRS,"CODBARRA"))  
			set objRSDetail = objConn.Execute(strSQL)
			If not objRSDetail.EOF Then
				strNOME = getValue(objRSDetail,"NOME_COMPLETO")
			End If
			FechaRecordSet objRSDetail
	  
			If strNOME = "" Then
				strNOME = getValue(objRS,"nomecli")
			End If
			
			strCARGA_HORA_TOTAL	= objRS("CARGA_HORA_TOTAL")
			auxstr = Replace(auxstr,"<PRO_CARGA_HORA_TOTAL>",strCARGA_HORA_TOTAL&"")
			
			strPROD_PRESENCA_TOTAL = objRS("PROD_PRESENCA_TOTAL")
			auxstr = Replace(auxstr,"<PRO_PROD_PRESENCA_TOTAL>",strPROD_PRESENCA_TOTAL&"")

			while InStr(auxstr,"<ASP.BEGIN>") > 0
				auxstr2 = Mid (auxstr,InStr(auxstr,"<ASP.BEGIN>"),InStr(auxstr,"<ASP.END>")-InStr(auxstr,"<ASP.BEGIN>")+9)
				auxstr3 = Replace(Replace(auxstr2,"<ASP.BEGIN>",""),"<ASP.END>","") ' Pega o nome do campo na tabela
				'TRatamento para ver qual nome utilizar no certificado: TBL_EMPRESAS ou tbl_Empresas_Sub
				If (UCase(auxstr3) = "NOMECLI" Or UCase(auxstr3) = "NOMEFAN") AND objRS("TIPO_PESS") = "N" AND strNOME <> "" Then
					auxstr3 = strNOME
				Else
					auxstr3 = ObjRS(auxstr3) & ""
				End If
				auxstr  = replace (auxstr, auxstr2, auxstr3)
			wend
			If getValue(objRS,"TTO")<>"" Then  
				auxstr = Replace(auxstr, "<PRO_TTO>", getValue(objRS,"TTO"))
			End if
	End If
    FechaRecordSet ObjRS
	 
	strSQL = "SELECT ID_AUTO FROM TBL_CERTIFICADO_LOG WHERE COD_PROD = " & strCOD_PROD & " AND COD_EMPRESA = '" & strCOD_EMPRESA & "'"
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
		strSQL = "UPDATE TBL_CERTIFICADO_LOG SET DT_REIMPRESSAO = NOW() WHERE ID_AUTO = " & getValue(objRS,"ID_AUTO")
	Else
		strSQL = "INSERT INTO TBL_CERTIFICADO_LOG (COD_PROD,COD_EMPRESA,GRUPO,DT_IMPRESSAO) VALUES (" & strCOD_PROD & ",'" & strCOD_EMPRESA & "','NULL',NOW())"
	End If
	FechaRecordSet objRS
	 
	objConn.Execute(strSQL)
	If strCOD_INSCRICAO <> "" Then
		strSQL = "INSERT INTO tbl_INSCRICAO_HIST (COD_INSCRICAO, SYS_USERCA, SYS_DATACA, HISTORICO, COD_INSCRICAO_HIST_CATEG) VALUES ("&strCOD_INSCRICAO&",'PAX',NOW(),'CERTIFICADO PDF - PRODUTO " & strCOD_PROD & "',1)"
		'Response.Write(strSQL)
		objConn.Execute(strSQL)
	End If
	 

	FechaDBConn ObjConn


	Select Case UCase(strCERTIFICADO_ORIENTACAO)
		Case "PAISAGEM"	strCERTIFICADO_ORIENTACAO = "true"
		Case "RETRATO"	strCERTIFICADO_ORIENTACAO = "false"
		Case Else		strCERTIFICADO_ORIENTACAO = "true"
	End Select

	Set Pdf = Server.CreateObject("Persits.Pdf")
	Set Doc = Pdf.CreateDocument
	'Doc.ImportFromUrl "<html>" & auxstr & "</html>", "landscape=true"
	strLog	 = Doc.ImportFromUrl ("<html><body style='-webkit-print-color-adjust: exact;'>" & auxstr & "</body></html>","Landscape="&strCERTIFICADO_ORIENTACAO&",DrawBackground=true,LeftMargin=10,TopMargin=20,RightMargin=10,BottomMargin=20,PageWidth=598,PageHeight=842")
	Filename = Doc.Save( Server.MapPath("..")&"\export\"& "certificado_" & strCOD_PROD & "_" & Trim(strCOD_EMPRESA) & ".pdf", True )
	Set Doc = Nothing
	Set Pdf = Nothing

	Response.Redirect("../export/" & Filename)

Else

%>
    <html>
        <head>
            <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
            <title>PROEVENTO.PAX - Certificado</title>
        </head>
        <body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0' bgcolor='#FFFFFF'>
            <center>
                <span style='font-family: Arial, Helvetica, sans-serif; font-weight: bold;'>
                	<br><br><%=objLang.SearchIndex("msg_erroimp_certif",0)%>
                </span>
            </center>
        </body>
    </html>
<%

End If
set objLang = Nothing
%>