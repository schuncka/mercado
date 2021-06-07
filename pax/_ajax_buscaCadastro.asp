<!--#include file="../_database/athdbConnCS.asp"-->
<%
 Dim objConn, objRS, strSQL
 Dim i, strIDENTIF, strSENHA

 strIDENTIF =  GetParam("var_identificador")
 strSENHA   =  GetParam("var_senha")	
	
 AbreDBConn objConn, CFG_DB
 
 strSQL =		   " SELECT E.COD_EMPRESA "
 strSQL = strSQL & "       ,E.ID_AUTO    as IDAUTO_EMP "
 strSQL = strSQL & "       ,null           as IDAUTO_SUB "
 strSQL = strSQL & "       ,E.CODBARRA   as CODBARRA_EMP "
 strSQL = strSQL & "       ,''           as CODBARRA_SUB "
 strSQL = strSQL & "       ,E.NOMEFAN AS NOME_EMP "
 strSQL = strSQL & "       ,E.NOMECLI AS NOME_CRED "
 strSQL = strSQL & "       ,E.ID_NUM_DOC1 as IDENTIFICADOR "
 strSQL = strSQL & "       ,E.EMAIL1 AS EMAIL "
 strSQL = strSQL & "       ,COALESCE(E.IMG_FOTO,'') AS FOTO "
 strSQL = strSQL & "       ,E.TIPO_PESS "
 strSQL = strSQL & "       ,'tbL_empresas' as TABELA "
 strSQL = strSQL & "   FROM TBL_EMPRESAS AS E "
 strSQL = strSQL & "  WHERE E.SYS_INATIVO IS NULL "
 strSQL = strSQL & "    AND (E.ID_NUM_DOC1 = '" & strIDENTIF & "' or E.EMAIL1 LIKE '" & strIDENTIF & "') "
 strSQL = strSQL & "    AND (E.SENHA LIKE '" & strSENHA & "' or '" & strSENHA & "' = '') "
 strSQL = strSQL & "  UNION "
 strSQL = strSQL & " SELECT distinct E.COD_EMPRESA "
 strSQL = strSQL & "       ,E.ID_AUTO    as IDAUTO_EMP "
 strSQL = strSQL & "       ,ES.ID_AUTO   as IDAUTO_SUB "
 strSQL = strSQL & "       ,E.CODBARRA   as CODBARRA_EMP "
 strSQL = strSQL & "       ,ES.CODBARRA  as CODBARRA_SUB "
 strSQL = strSQL & "       ,E.NOMEFAN AS NOME_EMP "
 strSQL = strSQL & "       ,ES.NOME_CREDENCIAL AS NOME_CRED "
 strSQL = strSQL & "       ,ES.ID_CPF as IDENTIFICADOR "
 strSQL = strSQL & "       ,ES.EMAIL AS EMAIL "
 strSQL = strSQL & "       ,COALESCE(ES.IMG_FOTO,'') AS FOTO "
 strSQL = strSQL & "       ,'' as TIPO_PESS "
 strSQL = strSQL & "       ,'tbL_empresas_sub' as TABELA "
 strSQL = strSQL & "   FROM TBL_EMPRESAS AS E "
 strSQL = strSQL & "  INNER JOIN TBL_EMPRESAS_SUB ES ON E.COD_EMPRESA = ES.COD_EMPRESA "
 strSQL = strSQL & "  WHERE E.SYS_INATIVO IS NULL "
 strSQL = strSQL & "    AND (ES.ID_CPF = '" & strIDENTIF & "' OR ES.EMAIL = '" & strIDENTIF & "') "
 strSQL = strSQL & "    AND (E.SENHA LIKE '" & strSENHA & "' or '" & strSENHA & "' = '') "
 strSQL = strSQL & "  ORDER BY NOME_CRED "
 'athDebug strSQL, false
 
 set objRS = objConn.execute(strSQL)
 
 'O AJAX retorna os elementos da seguinte forma:[...|...|...|]{...|...|...]...
 'COD_EMPRESA |  IDAUTO_EMP | IDAUTO_SUB | CODBARRA_EMP | CODBARRA_SUB | NOMEFAN AS NOME_EMP | NOME_CREDENCIAL AS NOME_CRED | ES.ID_CPF ou E.ID_NUM_DOC1 | EMAIL | FOTO | TIPO_PESS | TABELA 
 ' ---------------------------------------------------------------------------------------------------------------------------------------------------------- 03/03/2017 - by Aless -
 i=0
 Do While not objRS.EOF 
	response.Write("[")
	for i = 0 to objRS.fields.Count - 1
		if isNull(objRS.fields(i)) then 
			response.write ( objRS.fields(i) & "|")
		else
			response.write ( replace(objRS.fields(i),"|","") & "|")
		end if
	next
	response.Write("]") 
	athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	i = i + 1
 Loop

 FechaRecordSet objRS
 FechaDBConn objConn
%>