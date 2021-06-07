<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_AdmProduto",Session("METRO_USER_ID_USER")), true %>
<%
 'Relativas a conexão com DB, RecordSet e SQL
 	Dim ObjConn, objRS, strSQL,strSQLplus, objRSProd, objRSDetail
	Dim strCOD_PROD,  strCOD_PROD_ORIGEM, strTITULO, strSESSIONEVENTO,strRESTRICAO,strCOD_PROX, numPerPage 
	Dim flagCopystrCOD_PROD, flagCopyPRECO, flagCopyPALESTR, flagCopystrRESTRPROD,flagCopyRESTRICAO,flagCopyCOMBO,flagCopyJURADOPROD,flagCopyPACOTE
	Dim strVERBOSE,strLOCATION,strTABLES
	Dim i


strVERBOSE 				= ""
strTABLES 				= ""

strCOD_PROD 		 	= Replace(GetParam("var_chavereg"),"'","''")
strCOD_PROD_ORIGEM 	    = Replace(GetParam("var_cod_prod_new"),"'","''")
'strCOD_PROX		 	    = Replace(GetParam("var_cod_prod_prox"),"'","''")
strTITULO 	 	        = Replace(GetParam("var_titulo"),"'","''")
strLOCATION 			= Replace(GetParam("DEFAULT_LOCATION"),"'","''")

flagCopystrCOD_PROD 	= Replace(GetParam("var_flagCpyCod_Prod"),"'","''")
flagCopyPRECO			= Replace(GetParam("var_flagCpypreco_Prod"),"'","''")
flagCopyPALESTR			= Replace(GetParam("var_flagCpyPalestr_Prod"),"'","''")
flagCopyRESTRICAO 		= Replace(GetParam("var_flagCopyRestricao_Prod"),"'","''")
flagCopyCOMBO 			= Replace(GetParam("var_flagCopyCombo_Prod"),"'","''")
flagCopyPACOTE			= Replace(GetParam("var_flagCopyPacote_Prod"),"'","''")
flagCopyJURADOPROD		= Replace(GetParam("var_flagCopyJurado_Prod"),"'","''")

'athDebug strCOD_PROD&strCOD_PROD_ORIGEM , true 

IF strSESSIONEVENTO = "" THEN
		strSESSIONEVENTO = session("COD_EVENTO")
	ELSE
		strSESSIONEVENTO = Session("METRO_EVENTO_COD_EVENTO")
END IF



		
 AbreDBConn objConn, CFG_DB 
 
 
' ================================================================================
' Grava o cadastro no banco de dados
' =====================PRODUTOS===================================================
if flagCopystrCOD_PROD = "true" then
	
	strSQL = "SELECT COD_PROD FROM TBL_produtos WHERE COD_PROD = " & strCOD_PROD_ORIGEM
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
			strSQL =  "SELECT MAX(COD_PROD) as PROX_PROD FROM TBL_produtos WHERE COD_PROD <> 9999" 'Cod Original: [WHERE COD_PROD <> 9999] "
			Set objRS = objConn.Execute(strSQL)
		
		If not objRS.EOF Then
		  strCOD_PROD_ORIGEM = GetValue(objRS,"PROX_PROD")
		End If
		
		If strCOD_PROD_ORIGEM = "" Then 
		strCOD_PROD_ORIGEM = 1
		End If
		
		else
		
		strCOD_PROD_ORIGEM = strCOD_PROD_ORIGEM
		
		
	End If
		
	strSQL = "INSERT INTO TBL_PRODUTOS ( COD_PROD, COD_EVENTO, GRUPO, TITULO, DESCRICAO, OBS, CAPACIDADE, OCUPACAO, DT_OCORRENCIA, "
		strSQL = strSQL & "DT_TERMINO, COD_PALESTRANTE, SYS_DT_INATIVO, NUM_COMPETIDOR_START, LOCAL, CARGA_HORARIA, LOJA_SHOW, LOJA_EDIT_QTDE, PALESTRANTE,"
		strSQL = strSQL & "CERTIFICADO_TEXTO, DIPLOMA_TEXTO, COD_PROD_VALIDA, EXTRA_INFO_SHOW, EXTRA_INFO_MSG, EXTRA_INFO_REQUERIDO, VOUCHER_TEXTO, CERTIFICADO_PDF, "
		strSQL = strSQL & "CONCURSO, REF_NUMERICA, GRUPO_INTL, TITULO_INTL, DESCRICAO_INTL, IMG, TITULO_MINI, CERTIFICADO_PDF_ORIENTACAO, VOUCHER_TEXTO_US, VOUCHER_TEXTO_ES,"
		strSQL = strSQL & "BGCOLOR, DINAMICA, SINOPSE, GRUPO_SUB, DIPLOMA_PDF, CUPOM_FISCAL, ORDEM, DESCRICAO_HTML) "
	strSQL = strSQL & "SELECT  "&strCOD_PROD_ORIGEM&" ,COD_EVENTO, GRUPO,  IF('"&Trim(strTITULO)&"' = '', TITULO,'"&strTITULO&"') as TITULO , DESCRICAO, OBS, CAPACIDADE, OCUPACAO, DT_OCORRENCIA, DT_TERMINO, COD_PALESTRANTE, "
		strSQL = strSQL & "SYS_DT_INATIVO, NUM_COMPETIDOR_START, LOCAL, CARGA_HORARIA, LOJA_SHOW, LOJA_EDIT_QTDE, PALESTRANTE, CERTIFICADO_TEXTO, DIPLOMA_TEXTO, COD_PROD_VALIDA, "
		strSQL = strSQL & "EXTRA_INFO_SHOW, EXTRA_INFO_MSG, EXTRA_INFO_REQUERIDO, VOUCHER_TEXTO, CERTIFICADO_PDF, CONCURSO, REF_NUMERICA, GRUPO_INTL, TITULO_INTL, DESCRICAO_INTL, "
		strSQL = strSQL & "IMG, TITULO_MINI, CERTIFICADO_PDF_ORIENTACAO, VOUCHER_TEXTO_US, VOUCHER_TEXTO_ES, BGCOLOR, DINAMICA, SINOPSE, GRUPO_SUB, DIPLOMA_PDF, "
		strSQL = strSQL & "CUPOM_FISCAL, ORDEM,DESCRICAO_HTML "
		strSQL = strSQL & " FROM TBL_PRODUTOS WHERE COD_PROD = " & strCOD_PROD
	 	'athDebug strSQL&"<hr>" , true
		strVERBOSE = strVERBOSE & strSQL&"<hr>"
		strTABLES  = strTABLES & "<li>TBL_produtos</li>"	
	    objConn.Execute(strSQL)
	
end if
'========================PRODUTOS PALESTRANTE=====================================================
if flagCopyPALESTR = "true" then

	strSQL = "INSERT INTO tbl_produtos_palestrante  (COD_PROD"
		strSQL = strSQL & " ,MATERIAL"
		strSQL = strSQL & " ,FUNCAO"
		strSQL = strSQL & " ,TEMA"
		strSQL = strSQL & " ,HORA_INI"
		strSQL = strSQL & " ,HORA_FIM"
		strSQL = strSQL & " ,CONFIRMADO"
		strSQL = strSQL & " ,OBS"
		strSQL = strSQL & " ,ORDEM"
		strSQL = strSQL & " ,COD_PALESTRANTE)"
	strSQL = strSQL & " SELECT COD_PROD"
		strSQL = strSQL & " ,MATERIAL"
		strSQL = strSQL & " ,FUNCAO"
		strSQL = strSQL & " ,TEMA"
		strSQL = strSQL & " ,HORA_INI"
		strSQL = strSQL & " ,HORA_FIM"
		strSQL = strSQL & " ,CONFIRMADO"
		strSQL = strSQL & " ,OBS"
		strSQL = strSQL & " ,ORDEM"
		strSQL = strSQL & " ,COD_PALESTRANTE FROM  tbl_Produtos_Palestrante"  
		strSQL = strSQL & " WHERE COD_PROD =" & strCOD_PROD 
 
	    'athdebug strSQL&"<hr>" , false
	strVERBOSE = strVERBOSE & strSQL&"<hr>"
	strTABLES  = strTABLES & "<li>tbl_produtos_palestrante </li>"		
	    objConn.Execute(strSQL)
end if	
'==================================================================================================	


'===========================pacotes de produtos=========================================================
if flagCopyPACOTE = "true" then
		
		strSQL = " INSERT INTO TBL_PRODUTOS_PACOTE(COD_PROD_PACOTE"
			strSQL = strSQL & " ,COD_PROD "
			strSQL = strSQL & " , QTDE_COMPRADA "
			strSQL = strSQL & " ,QTDE_PACOTE "
			strSQL = strSQL & " ,VLR_FIXO "
			strSQL = strSQL & " ,DESCONTO_PERC "
			strSQL = strSQL & " ,COD_PROD_RELACAO "
			strSQL = strSQL & " ,DESCONTO_VLR "
			strSQL = strSQL & " ,REPETIR_QTDE "
			strSQL = strSQL & " ,COD_EVENTO "
			strSQL = strSQL & " ,COD_STATUS_PRECO "
			strSQL = strSQL & " ,COD_PROD_REQUERIDO "
			strSQL = strSQL & " ,COD_PROD_GRUPO)"
		strSQL = strSQL & " select COD_PROD_PACOTE "
			strSQL = strSQL & " ,COD_PROD "
			strSQL = strSQL & " , QTDE_COMPRADA "
			strSQL = strSQL & " ,QTDE_PACOTE "
			strSQL = strSQL & " ,VLR_FIXO "
			strSQL = strSQL & " ,DESCONTO_PERC "
			strSQL = strSQL & " ,COD_PROD_RELACAO "
			strSQL = strSQL & " ,DESCONTO_VLR "
			strSQL = strSQL & " ,REPETIR_QTDE "
			strSQL = strSQL & " ,COD_EVENTO "
			strSQL = strSQL & " ,COD_STATUS_PRECO "
			strSQL = strSQL & " ,COD_PROD_REQUERIDO "
			strSQL = strSQL & " ,COD_PROD_GRUPO from tbl_produtos_pacote "
			strSQL = strSQL & " WHERE COD_PROD = " & strCOD_PROD
			
			 'athdebug strSQL&"<hr>" , false
		strVERBOSE = strVERBOSE & strSQL&"<hr>"
		strTABLES  = strTABLES & "<li>tbl_produtos_pacote </li>"		
		
			objConn.Execute(strSQL)
		
end if		
'==============================================================================================	
'===================Lista de Restrições==============================================
if flagCopyRESTRICAO = "true" then

		strSQL = "INSERT INTO tbl_produtos_restricao" 
			strSQL = strSQL & " (COD_PROD"
			strSQL = strSQL & " ,COD_PROD_RELACAO"
			strSQL = strSQL & " ,RESTRICAO"
			strSQL = strSQL & " ,ID_AUTO"
			strSQL = strSQL & " ,COD_PROD_EQUIV)"
		strSQL = strSQL & " select COD_PROD"
			strSQL = strSQL & " ,COD_PROD_RELACAO"
			strSQL = strSQL & " ,RESTRICAO"
			strSQL = strSQL & " ,ID_AUTO"
			strSQL = strSQL & " ,COD_PROD_EQUIV"
			strSQL = strSQL & " FROM tbl_produtos_restricao "
			strSQL = strSQL & " WHERE COD_PROD =" & strCOD_PROD 
	
	 'athdebug strSQL&"<hr>" , false
		strVERBOSE = strVERBOSE & strSQL&"<hr>"
		strTABLES  = strTABLES & "<li>tbl_produtos_restricao </li>"		
			objConn.Execute(strSQL)

end if

'==========================FIM AREA CHECKS====================================================================

' painel ================================================================================================================================================================================================

%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
        <div class="padding20">
            <h1><i class="icon-copy fg-black on-right on-left"></i>Product Copy</h1>
            <h2>C&oacute;pia de Produto <%=strCOD_PROD_ORIGEM%></h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:400px; overflow:scroll; overflow-x:hidden;">
                	<p>O sistema procedeu a cópia do Produto <strong><%=strCOD_PROD%></strong>, gerando o produto <strong><%=strCOD_PROD_ORIGEM%></strong>. As tabelas envolvidas nesta cópia foram:</p>
                    <ul><%=ucase(strTABLES)%></ul>
                	<p>Abaixo segue, como informação técnica, o LOG de execução de script SQL relativos as tabelas copiadas:</p>
					<hr/>
					<%=ucase(strVERBOSE)%>
                </div>
                <hr>
                <div><form id="" action="<%=strLOCATION&"?var_chavereg="&strCOD_PROD%>" ><!--form id="" action="update.asp?var_chavereg=<'%=strCOD_PROD_ORIGEM%>"//--> 
                <input class="primary" type="submit" name="btRun" value="OK" />
                </form></div>
                <br>
        </div>
</div>
</body>
</html>

<%
FechaRecordSet ObjRS
FechaDBConn ObjConn
%>