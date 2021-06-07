<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<!--#include file="../_scripts/scripts.js"-->
<!-- #include file="../_include/barcode39.asp"; -->
<%
 Dim strCREDENCIAL_MODELO, strCREDENCIAL
 Dim FSO, fich, strARQUIVO, strPATH
 
 strPATH = Server.MapPath("../") & "\_database\"
' Response.Write(strPATH & "<BR>")
 
 Set FSO = createObject("scripting.filesystemobject") 
 
 strARQUIVO = strPATH & "modelo_credencial" & "_" & Session("COD_EVENTO") & ".asp"
 If not FSO.FileExists(strARQUIVO) Then
   strARQUIVO = strPATH & "modelo_credencial.asp"
 End If
 
' Response.Write(strARQUIVO)
' Response.End()
 
 Set fich = FSO.OpenTextFile(strARQUIVO) 
 strCREDENCIAL_MODELO = fich.readAll() 
 fich.close() 
 
 Set fich = Nothing
 Set FSO = Nothing

 Dim strCOD_LOTE
	
 strCOD_LOTE = Request("var_chavereg")


 Dim strDT_INICIO, strDT_FIM, strCOD_INSCRICAO, strCOD_PROD, strNUM_COMPETIDOR, strCOD_STATUS_CRED
 Dim strMARCAIMPRESSAO, strSYS_DATACRED, strNOMINAL, strIMPRIME_CONTATO, strFLAG_IMPRIME_ETIQUETA

 strDT_INICIO = Replace(Request("var_dt_inicio"),"'","")
 strDT_FIM = Replace(Request("var_dt_fim"),"'","")
 strMARCAIMPRESSAO = Request("var_marcaimpressao")
 strCOD_INSCRICAO = Replace(Request("var_cod_inscricao"),"'","")
 strCOD_PROD = Request("var_cod_prod")
 strCOD_STATUS_CRED = Request("var_cod_status_cred")
 strSYS_DATACRED = Request("var_sys_datacred")
 strIMPRIME_CONTATO = Request("var_imprime_contato")
 strFLAG_IMPRIME_ETIQUETA = Request("var_imprime_etiqueta")
 
 If not IsDate(strDT_INICIO) Then
   strDT_INICIO = ""
 End If
 If not IsDate(strDT_FIM) Then
   strDT_FIM = ""
 End If

   Dim tamtable, numcol, numlinha, tamcol, altTabela, posinicial, numetiqueta
   posinicial = Request("posinicial")
   numlinha = Request("numlinha")
   numcol = Request("numcol")

   If posinicial = "" Or not IsNumeric(posinicial) Then
     posinicial = 1
   End If
   posinicial = CInt(posinicial)

   If numlinha = "" Or not IsNumeric(numlinha) Then
     numlinha = 4
   End If
   numlinha = CInt(numlinha)

   If numcol = "" Or not IsNumeric(numcol) Then
     numcol = 2
   End If
   numcol = CInt(numcol)
   
   tamtable = 640
   tamcol = fix(tamtable / numcol)
   numetiqueta = numcol * numlinha
'   If posinicial > 1 and posinicial <= numetiqueta Then
'     numetiqueta = numetiqueta - posinicial + 1
'   Else 
'     posinicial = 1
'   End If
   
   
   
  'Retrieve what page we're currently on
  Dim CurPage, NumPerPage
  
  If Request("var_CurPage") = "" then
     CurPage = 1 'We're on the first page
  Else
    CurPage = Request("var_CurPage")
  End If 

  NumPerPage = Request("var_numperpage")
  If (Not IsNumeric(NumPerPage)) or (NumPerPage = "") Then
    NumPerPage = 20
  End If

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<%
Dim objConn, objRS, objRSDetail, strSQL, strSQLClause, strSQLClause2, strSQLLeftJoin, strSQLParenteses, strFLAG_EVENTO, strSQLOrdem, cont
Dim strEMPRESA, strNOME, strNOME_COMPLETO, strLOCAL, strATIV, strCODBARRA, strENTIDADE, strCEP, strPAIS
 
 
If UCase(Request("var_impressao")) = "TRUE" Then

   Dim  strCAMPO_ANTERIOR, strNUM_CRED_PJ
   
   AbreDBConn objConn, CFG_DB_DADOS 

   strNUM_CRED_PJ = 0
   strNOMINAL = ""
   
   ' Consulta para pegar o campo NUM_CRED_PJ do Lote pra impressão de credencias pra empresa
   strSQL = " SELECT NUM_CRED_PJ, NOMINAL FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
     strNUM_CRED_PJ = objRS("NUM_CRED_PJ")
	 strNOMINAL = objRS("NOMINAL")&""
   End If
   FechaRecordSet objRS
   
   strCAMPO_ANTERIOR = ""
   strSQL = " SELECT * FROM tbl_Lote_Criterio WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   Do While not objRS.EOF
     If strCAMPO_ANTERIOR <> objRS("CAMPO") Then
	   strCAMPO_ANTERIOR = objRS("CAMPO")
       strSQLClause = strSQLClause & ") AND ("
'	   strSQLClause = strSQLClause & " tbl_Empresas." & objRS("CAMPO") & " "
'	   strSQLClause = strSQLClause  & objRS("CAMPO") & " "
	   If InStr(objRS("CAMPO")&"","IDIOMA") > 0 Then
	     strSQLClause = strSQLClause & " tbl_Pais." & objRS("CAMPO") & " "
	   Else
	     strSQLClause = strSQLClause & " tbl_Empresas." & objRS("CAMPO") & " "
	   End If

       If objRS("CRITERIO") = "IN" Then 
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " ('" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "') "
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " (" & Replace(objRS("VALOR")&"","'","''") & ") "
		 End If
  	   Else
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
		  if objRS("CRITERIO") = "LIKE" Or objRS("CRITERIO") = "LIKE_CONTEM" then
	       strSQLClause = strSQLClause & " LIKE '%" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  elseif objRS("CRITERIO") = "LIKE_COMECA" then
	       strSQLClause = strSQLClause & " LIKE '" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " '" & Replace(objRS("VALOR")&"","'","''") & "' "
		  end if
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " " & Replace(objRS("VALOR")&"","'","''") & " "
		 End If
	   End If
	 Else
       strSQLClause = strSQLClause & " OR "
'	   strSQLClause = strSQLClause & " tbl_Empresas." & objRS("CAMPO") & " "
'	   strSQLClause = strSQLClause & objRS("CAMPO") & " "
	   If InStr(objRS("CAMPO")&"","IDIOMA") > 0 Then
	     strSQLClause = strSQLClause & " tbl_Pais." & objRS("CAMPO") & " "
	   Else
	     strSQLClause = strSQLClause & " tbl_Empresas." & objRS("CAMPO") & " "
	   End If
	   
       If objRS("CRITERIO") = "IN" Then 
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " ('" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "') "
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " (" & Replace(objRS("VALOR")&"","'","''") & ") "
		 End If
	   Else
	     If InStr(objRS("CAMPO"),"COD_STATUS") <= 0 Then
		  if objRS("CRITERIO") = "LIKE" Or objRS("CRITERIO") = "LIKE_CONTEM" then
	       strSQLClause = strSQLClause & " LIKE '%" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  elseif objRS("CRITERIO") = "LIKE_COMECA" then
	       strSQLClause = strSQLClause & " LIKE '" & Replace(Replace(objRS("VALOR")&"","'","''"),",","','") & "%' "
		  else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " '" & Replace(objRS("VALOR")&"","'","''") & "' "
		  end if
		 Else
	       strSQLClause = strSQLClause & objRS("CRITERIO") & " " & Replace(objRS("VALOR")&"","'","''") & " "
		 End If
	   End If
	 End If
     objRS.MoveNext
   Loop
   strSQLClause = strSQLClause & ") "
   FechaRecordSet objRS

    strFLAG_EVENTO = False
	cont = 1
	
    strSQL = " SELECT COD_EVENTO, CRITERIO FROM tbl_LOTE_EVENTO WHERE COD_LOTE = " & strCOD_LOTE
	Set objRS = objConn.Execute(strSQL)
	Do While not objRS.EOF
	  strFLAG_EVENTO = True
	  strSQLParenteses = strSQLParenteses & " ( "
	  
	  strSQLLeftJoin = strSQLLeftJoin & "  LEFT OUTER JOIN tbl_Controle_IN_Hist AS tbl_VISITA_" & cont & " ON (tbl_Empresas.COD_EMPRESA = tbl_VISITA_" & cont & ".COD_EMPRESA AND tbl_VISITA_" & cont & ".COD_EVENTO=" & objRS("COD_EVENTO") & ") "
	  strSQLLeftJoin = strSQLLeftJoin & ")"
	  
	  If objRS("CRITERIO") = "<>" Then
	    strSQLClause2 = strSQLClause2 & " AND (tbl_VISITA_" & cont & ".COD_EVENTO IS NULL OR tbl_VISITA_" & cont & ".COD_EVENTO " & objRS("CRITERIO") & " " & objRS("COD_EVENTO") & ")"
	  Else
	    strSQLClause2 = strSQLClause2 & " AND  tbl_VISITA_" & cont & ".COD_EVENTO " & objRS("CRITERIO") & " " & objRS("COD_EVENTO") & ""
	  End If
	  cont = cont + 1
	  objRS.MoveNext
	Loop
	FechaRecordSet objRS

'   If strSYS_DATACRED <> "" Then
'     strSQLClause = strSQLClause & "    AND tbl_Empresas.SYS_DATACRED " & strSYS_DATACRED
'   End If


   ' Pesquisa os campos de ordenação do resultado
   strSQL = " SELECT * FROM tbl_Lote_Ordem WHERE COD_LOTE = " & strCOD_LOTE & " ORDER BY ORDEM"
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
   strSQLOrdem = strSQLOrdem & " ORDER BY "
     Do While not objRS.EOF
	   If InStr(objRS("CAMPO")&"","IDIOMA") > 0 Then
         strSQLOrdem = strSQLOrdem & " tbl_Pais." & objRS("CAMPO") & " " & objRS("DIRECAO") & ", "
       Else
		 strSQLOrdem = strSQLOrdem & " tbl_Empresas." & objRS("CAMPO") & " " & objRS("DIRECAO") & ", "
	   End If
       objRS.MoveNext
     Loop
     strSQLOrdem = strSQLOrdem & " 1 "
   End If
   FechaRecordSet objRS
   
   If strFLAG_IMPRIME_ETIQUETA = "S" Then
	 strSQLOrdem = " ORDER BY COD_EMPRESA, ENDERECAMENTO DESC"
   End If

   
'   strSQL = " SELECT tbl_Empresas.COD_EMPRESA"
'   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOMEFAN"
'   strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_COMPLETO"
'   strSQL = strSQL & " ,tbl_Empresas_Sub.CODBARRA"
'   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
'   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
'   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
'   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
'   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
'   strSQL = strSQL & " FROM (tbl_Empresas LEFT OUTER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)  )"
'   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
'   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
'   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
'   strSQL = strSQL & strSQLClause
'   strSQL = strSQL & strSQLOrdem

'Mauro - 30/03/2007
'Novo SQL incluindo a opção de criterios de pesquisa na tabela "tbl_PAIS"
'   strSQL = " SELECT tbl_Empresas.COD_EMPRESA"
'   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOMEFAN"
'   strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_COMPLETO"
'   strSQL = strSQL & " ,tbl_Empresas_Sub.CODBARRA"
'   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
'   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
'   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
'   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
'   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
'   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
'   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
'   strSQL = strSQL & " ,tbl_Pais.IDIOMA"
'   strSQL = strSQL & " FROM ( (tbl_Empresas LEFT OUTER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA)  )"
'   strSQL = strSQL & "       LEFT OUTER JOIN tbl_Pais ON (tbl_Empresas.END_PAIS = tbl_Pais.PAIS) )"
'   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
'   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
'   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
'   strSQL = strSQL & strSQLClause
'   strSQL = strSQL & strSQLOrdem


'Mauro - 25/04/2007
'Novo SQL para "replicar" o numero de empresas quando o campo NUM_CRED_PJ > 0
   strSQL = ""
   
   If strFLAG_IMPRIME_ETIQUETA = "S" Then 'Teste para verificar se imprime e etiqueta de enderaçamento
   
	   strSQL = strSQL & "("  
	   strSQL = strSQL & " SELECT tbl_Empresas.COD_EMPRESA"
	   strSQL = strSQL & " ,tbl_Empresas.NOMECLI"
	   strSQL = strSQL & " ,tbl_Empresas.NOMEFAN"
	   strSQL = strSQL & " ,'' AS NOME_COMPLETO"
	   strSQL = strSQL & " ,'' AS CODBARRA"
	   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
	   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
	   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
	   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
	   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
	   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.SEXO"
	   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
	   strSQL = strSQL & " ,tbl_Atividade.TTO_F"
	   strSQL = strSQL & " ,tbl_Atividade.TTO_M"
	   strSQL = strSQL & " ,tbl_Pais.IDIOMA"
	   strSQL = strSQL & " ,'ETIQUETA' AS ENDERECAMENTO "
	   strSQL = strSQL & " FROM " & strSQLParenteses & " ( ( tbl_Empresas"
	   strSQL = strSQL & "       INNER JOIN tbl_Pais ON (tbl_Empresas.END_PAIS = tbl_Pais.PAIS) )"
	   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV )"
	   strSQL = strSQL & strSQLLeftJoin
	   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
	   strSQL = strSQL & strSQLClause
	   strSQL = strSQL & strSQLClause2
	   strSQL = strSQL & ")"  

	   strSQL = strSQL & " UNION"  
   End If
      
   If strNUM_CRED_PJ > 0 Then
     For i = 1 To strNUM_CRED_PJ
	   strSQL = strSQL & "(" 
	   strSQL = strSQL & " SELECT tbl_Empresas.COD_EMPRESA"
	   strSQL = strSQL & " ,tbl_Empresas.NOMECLI"
	   strSQL = strSQL & " ,tbl_Empresas.NOMEFAN"
'	   strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOME_COMPLETO"
	   strSQL = strSQL & " ,'" & strNOMINAL & "' AS NOME_COMPLETO"
	   strSQL = strSQL & " ,tbl_Empresas.COD_EMPRESA & '00" & i & "' AS CODBARRA"
	   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
	   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
	   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
	   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
	   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
	   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.SEXO"
	   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
	   strSQL = strSQL & " ,'' AS TTO_F"
	   strSQL = strSQL & " ,'' AS TTO_M"
	   strSQL = strSQL & " ,tbl_Pais.IDIOMA"
	   strSQL = strSQL & " ,'' AS ENDERECAMENTO "
	   strSQL = strSQL & " FROM " & strSQLParenteses & " ( ( tbl_Empresas "
	   strSQL = strSQL & "       LEFT OUTER JOIN tbl_Pais ON (tbl_Empresas.END_PAIS = tbl_Pais.PAIS) )"
	   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV )"
	   strSQL = strSQL & strSQLLeftJoin
	   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.TIPO_PESS = 'N' "
	   strSQL = strSQL & strSQLClause
	   strSQL = strSQL & strSQLClause2
	   strSQL = strSQL  & ")" 
	   strSQL = strSQL & " UNION " 
	 Next
     strSQL = strSQL & "("  
   End If

   If strNUM_CRED_PJ = 0 Then 'Se não imprimiu a credencial da empresa ainda
   
	   strSQL = strSQL & "("  
	   strSQL = strSQL & " SELECT tbl_Empresas.COD_EMPRESA"
	   strSQL = strSQL & " ,tbl_Empresas.NOMECLI"
	   strSQL = strSQL & " ,tbl_Empresas.NOMEFAN"
	   strSQL = strSQL & " ,'' AS NOME_COMPLETO"
	   strSQL = strSQL & " ,'' AS CODBARRA"
	   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
	   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
	   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
	   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
	   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
	   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
	   strSQL = strSQL & " ,tbl_Empresas.SEXO"
	   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
	   strSQL = strSQL & " ,tbl_Atividade.TTO_F"
	   strSQL = strSQL & " ,tbl_Atividade.TTO_M"
	   strSQL = strSQL & " ,tbl_Pais.IDIOMA"
	   strSQL = strSQL & " ,'' AS ENDERECAMENTO "
	   strSQL = strSQL & " FROM " & strSQLParenteses & " ( ( tbl_Empresas"
	   strSQL = strSQL & "       INNER JOIN tbl_Pais ON (tbl_Empresas.END_PAIS = tbl_Pais.PAIS) )"
	   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV )"
	   strSQL = strSQL & strSQLLeftJoin
	   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
	   strSQL = strSQL & strSQLClause
	   strSQL = strSQL & strSQLClause2
	   strSQL = strSQL & ")"  

	   strSQL = strSQL & " UNION"  
   End If

   strSQL = strSQL & "("  
   strSQL = strSQL & " SELECT tbl_Empresas.COD_EMPRESA"
   strSQL = strSQL & " ,tbl_Empresas.NOMECLI"
   strSQL = strSQL & " ,tbl_Empresas.NOMEFAN"
   strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_COMPLETO"
   strSQL = strSQL & " ,tbl_Empresas_Sub.CODBARRA"
   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
   strSQL = strSQL & " ,tbl_Empresas.END_FULL"
   strSQL = strSQL & " ,tbl_Empresas.END_BAIRRO"
   strSQL = strSQL & " ,tbl_Empresas.END_CIDADE"
   strSQL = strSQL & " ,tbl_Empresas.END_ESTADO"
   strSQL = strSQL & " ,tbl_Empresas.END_CEP"
   strSQL = strSQL & " ,tbl_Empresas.END_PAIS"
   strSQL = strSQL & " ,tbl_Empresas.ENTIDADE"
   strSQL = strSQL & " ,tbl_Empresas.SEXO"
   strSQL = strSQL & " ,tbl_Atividade.ATIVMINI AS ATIVIDADE"
   strSQL = strSQL & " ,tbl_Atividade.TTO_F"
   strSQL = strSQL & " ,tbl_Atividade.TTO_M"
   strSQL = strSQL & " ,tbl_Pais.IDIOMA"
   strSQL = strSQL & " ,'' AS ENDERECAMENTO "	
   strSQL = strSQL & " FROM " & strSQLParenteses & " ( ( (tbl_Empresas INNER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA) )"
   strSQL = strSQL & "       INNER JOIN tbl_Pais ON (tbl_Empresas.END_PAIS = tbl_Pais.PAIS) )"
   strSQL = strSQL & "       INNER JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV )"
   strSQL = strSQL & strSQLLeftJoin
   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
   strSQL = strSQL & "    AND  tbl_Empresas.TIPO_PESS = 'N' "
   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
   If strIMPRIME_CONTATO <> "S" Then 'Se não é para imprimir os contatos a consulta vem "zerada"
     strSQL = strSQL & "    AND  tbl_Empresas.COD_EMPRESA IS NULL "
   End If
   strSQL = strSQL & strSQLClause
   strSQL = strSQL & strSQLClause2
   strSQL = strSQL & ")"  
   
   If strNUM_CRED_PJ > 0 Then 'Para fechar o UNION do LACO
     strSQL = strSQL  & ")"  
   End If

   strSQL = strSQL & strSQLOrdem

' Response.Write strSQL
  'Response.End()		

  Set objRS = Server.CreateObject("ADODB.Recordset")
  Set objRSDetail = Server.CreateObject("ADODB.Recordset")
  '==========================================================
  ' Define o tamanho das páginas de visualização
  '==========================================================
  'Set the cursor location property
  objRS.CursorLocation = adUseClient

  'Set the cache size = to the # of records/page
  objRS.CacheSize = numetiqueta * NumPerPage

  'Response.Write strSQL
  objRS.Open strSQL, objConn 

  Dim TotalPages, TotalLotes
  If not objRS.EOF Then

    objRS.MoveFirst
    objRS.PageSize = numetiqueta * NumPerPage

    'Get the max number of pages
    TotalPages = objRS.PageCount * NumPerPage
    TotalLotes = objRS.PageCount
    'Set the absolute page
    objRS.AbsolutePage = CurPage
  End If

   Dim strBgColor, strPRODUTO, strTTO
   Dim strTOT_INSCRICAO
   strPRODUTO = ""
   %>
<table border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="<%=numcol%>" valign="top"><img src="../img/transparent.gif" width="10" height="10" border="0"></td>
  </tr>
<%
  Dim i, j, Contador, num_pagina
%>
  <tr> 
<%
  i = 1
  num_pagina = (CurPage * NumPerPage) - (NumPerPage - 1)
  Do While i < posinicial
  %>
    <td width="<%=tamcol%>">
	<%=strCREDENCIAL_MODELO%>
	</td>
   <%
    If i mod numcol = 0 Then
    ' Se ja colocou n colunas então cria nova linha na tabela
    %>
      </tr>
      <tr>
	<%
    End If
    i = i + 1
  Loop

  Contador = 0 + i - 1

  On Error Resume Next
  Do While (Not objRS.EOF) And (i <= objRS.PageSize)
    If Contador = numetiqueta Then
      ' Fecha a linha da tabela
	  %>
             </tr>
        </table>
	  <%If Cstr(numcol) <> "1" Or Cstr(numlinha) <> "1" Then
    %>
	  <table border="0" cellspacing="0" cellpadding="0" class="arial10" align="center">
      <tr>   
        <td align="center"><font color="#999999">Página <%=num_pagina%> de <%=TotalPages%> (Lote <%=CurPage%> de <%=TotalLotes%>)</font></td>
      </tr>
	  </table>
    <%
	  End IF
	%>
      <!--este comando faz a quebra de página forçada, o problema é que quando foi utilizado ele imprimiu uma página em branco //-->
      <div style="page-break-before:always; width:1px;height:1px;visibility:collapse;">&nbsp;</div>
	  <table border="0" cellspacing="0" cellpadding="0">
      <tr> 
        <td colspan="<%=numcol%>" valign="top"><img src="../img/transparent.gif" width="10" height="10" border="0"></td>
      </tr>
	<%
	  Contador = 0
	  num_pagina = num_pagina + 1
	End If

	Select Case objRS("SEXO")&""
	  Case "F"	    
	    strTTO = Trim(objRS("TTO_F")&"")&" "
	  Case "M"	    
	    strTTO = Trim(objRS("TTO_M")&"")&" "
	  Case Else
	    strTTO = ""
	End Select

    strCODBARRA  = objRS("CODBARRA")&""
    strEMPRESA   = UCase(objRS("NomeFan"))
	If objRS("END_CIDADE")&"" <> "ZZCONTATO" Then
      strLOCAL     = UCase(objRS("END_CIDADE")) & "/" & UCase(objRS("END_ESTADO"))
	  strCEP       = objRS("END_CEP") & ""
	  strPAIS      = objRS("END_PAIS") & ""
      strATIV      = UCase(objRS("ATIVIDADE")&"")
	End If
    strNOME = objRS("Nome_Completo") & ""
   	If strNOME = "" And strCODBARRA = "" Then
      strNOME      = UCase(objRS("NomeFan"))
      strCODBARRA  = objRS("COD_EMPRESA") & "010"
	  strSQL = " UPDATE tbl_EMPRESAS SET SYS_DATACRED = NOW() WHERE COD_EMPRESA = '" & objRS("COD_EMPRESA") & "'"
	Else
	  strSQL = " UPDATE tbl_EMPRESAS_SUB SET SYS_DATACRED = NOW() WHERE CODBARRA = '" & strCODBARRA & "'"
	End If
	If strMARCAIMPRESSAO = "S" Then
	  objConn.Execute(strSQL)
    End If
	
	If strMARCAIMPRESSAO = "S" And strNUM_CRED_PJ > 0 Then
	  strSQL = " UPDATE tbl_EMPRESAS SET SYS_DATACRED = NOW() WHERE COD_EMPRESA = '" & objRS("COD_EMPRESA") & "'"
	  objConn.Execute(strSQL)
	End If

    strENTIDADE = objRS("ENTIDADE") & ""
	If strENTIDADE <> "" Then
	  strENTIDADE = "<br>" & strENTIDADE
	End If


	If (numetiqueta - Contador) > numcol Then
	  altTabela = "228"
'	Else
'	  altTabela = ""
	End If

    Response.Write "<td align=""center"" width=""" & tamcol & """>"
	
	strCREDENCIAL = strCREDENCIAL_MODELO
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_NOME_CREDENCIAL>",Left(strNOME,CFG_MAXLEN_LABEL_NOME))
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_NOME_COMPLETO>",strNOME_COMPLETO)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_ENTIDADE>",Left(strENTIDADE,25))
	If strNOME <> strEMPRESA Then
	  strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EMPRESA>",Left(strEMPRESA,25))
	End If
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_CODBARRA>",strCODBARRA)
    If strPAIS = "BRASIL" Then 
      If strLOCAL <> "/" Then
	    strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_LOCAL>",strLOCAL)
	  End If
	Else
      strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_LOCAL>",strPAIS)
	End If
    strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_PAIS>",strPAIS)
    strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_BARCODE>", ReturnBarCode39(strCODBARRA, 30, 1.5, "../img/"))
    strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_CEP>",strCEP)
    strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_ATIVIDADE>",strATIV)


	If objRS("ENDERECAMENTO") = "ETIQUETA" Then
	  strCREDENCIAL = "<TABLE CELLSPACING=0 CELLPADDING=0><TR><TD>" 
	  strCREDENCIAL = strCREDENCIAL & UCase(objRS("NOMECLI")&"") & "<br>"
	  strCREDENCIAL = strCREDENCIAL & UCase(objRS("END_FULL")) & "<br>"
	  strCREDENCIAL = strCREDENCIAL & UCase(objRS("END_CIDADE")) & "/" & UCase(objRS("END_ESTADO")) & "<br>"
	  strCREDENCIAL = strCREDENCIAL & UCase(objRS("END_CEP")) & "<br>"
	  strCREDENCIAL = strCREDENCIAL & "</TD></TR></TABLE>"
	End If
		
	'Exibe a credencial
	Response.Write(strCREDENCIAL)

	Response.Write "</td>"
    If i mod numcol = 0 And Contador < numetiqueta Then
    ' Se ja colocou n colunas e não é o fim da tabela então cria nova linha na tabela
       Response.Write "        </tr>"
       Response.Write "        <tr>"
    End If
    i = i + 1
    Contador = Contador + 1
    objRS.MoveNext
	
	if err.Number<>0 Then
	  Response.Write("Problemas no processamento desta consulta.<br>")
	  Response.Write(err.Description & "<br>")
	  Response.End()
	End If
  Loop
	' Verifica se preencheu toda a linha com imagens senao coloca coluna em branco
	If ((i-1) mod numcol) > 0 Then
      For j = ((i-1) mod numcol) + 1 To numcol
	  %>
        <td width="<%=tamcol%>">
		<%=strCREDENCIAL_MODELO%>
        </td>
	  <%
      Next
	End If
	' Fecha a linha da tabela
%>
   </tr>
</table>
<!--
<table width="620" border="0" cellspacing="0" cellpadding="0" class="arial10">
  <tr> 
   <td align="center"><font color="#999999">Página <%=num_pagina%> de <%=TotalPages%></font></td>
  </tr>
</table>
//-->
  <% 
   FechaRecordSet ObjRS
   FechaDBConn ObjConn
Else
%>
<div align="center"> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong><font face="Arial, Helvetica, sans-serif">.: 
  AVISO :.</font></strong><font face="Arial, Helvetica, sans-serif"><br>
  Informe os critérios acima para montagem das credenciais. </font></font> </div>
  <%
End If

'Response.Flush()
%>
</body>
</html>