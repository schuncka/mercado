<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<!--#include file="../_scripts/scripts.js"-->
<!-- #include file="../_include/barcode39.asp"; -->
<!-- #include file="../_include/barcode25.asp"; -->
<%

 Dim strCOD_LOTE
	
 strCOD_LOTE = Request("var_chavereg")


 Dim strDT_INICIO, strDT_FIM, strCOD_INSCRICAO, strCOD_PROD, strNUM_COMPETIDOR, strCOD_STATUS_CRED
 Dim strMARCAIMPRESSAO, strSYS_DATACRED, strNOMINAL, strIMPRIME_CONTATO, strFLAG_IMPRIME_ETIQUETA, strNRO_ETIQUETA, strFLAG_SOMENTE_EMPRESA, strCEP_INICIO, strCEP_FIM
 Dim strEXTRA_TXT_1, strEXTRA_TXT_2, strEXTRA_TXT_3, strEXTRA_TXT_4, strEXTRA_TXT_5, strEXTRA_TXT_6, strEXTRA_TXT_7, strEXTRA_TXT_8, strEXTRA_TXT_9, strEXTRA_TXT_10
 Dim strEXTRA_TXT_1_EMPRESA
 Dim  strCAMPO_ANTERIOR, strNUM_CRED_PJ, strNUM_CRED_CONTATO, strCRITERIO_EVENTO, strSQL_CRITERIO, strSQL_INNER, strSQL_INNER_SUB, strSQL_CRITERIO_SUB

 Dim strCAMPO, strCRITERIO, strCRITERIO_OPERADOR, strVALOR
 Dim strSQL_IGNORAR_CONTATO, strSQL_CADASTRO_COM_FOTO

 strDT_INICIO = Replace(Request("var_dt_inicio"),"'","")
 strDT_FIM = Replace(Request("var_dt_fim"),"'","")
 strMARCAIMPRESSAO = Request("var_marcaimpressao")
 strCOD_INSCRICAO = Replace(Request("var_cod_inscricao"),"'","")
 strCOD_PROD = Request("var_cod_prod")
 strCOD_STATUS_CRED = Request("var_cod_status_cred")
 strSYS_DATACRED = Request("var_sys_datacred")
 strIMPRIME_CONTATO = Request("var_imprime_contato")
 strNRO_ETIQUETA = Request("var_imprime_etiqueta")
 
 strCEP_INICIO = Request("var_cep_inicio")
 strCEP_FIM    = Request("var_cep_fim")
 
 If IsNumeric(strNRO_ETIQUETA) and strNRO_ETIQUETA&"" <> "" Then 
   strFLAG_IMPRIME_ETIQUETA = "S"
   strNRO_ETIQUETA = cint(strNRO_ETIQUETA)
 Else
   strNRO_ETIQUETA = 0
 End If
 
 
 strNUM_CRED_CONTATO = 0
 If strNRO_ETIQUETA = "CONTATO" Then
   strNUM_CRED_CONTATO = 1
 End If
 
 strFLAG_SOMENTE_EMPRESA = False
 If Request("var_imprime_etiqueta") = "EMPRESA" Then
   strFLAG_IMPRIME_ETIQUETA = "S"
   strNRO_ETIQUETA = 1
   strFLAG_SOMENTE_EMPRESA = True
 End If
 
 
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
     numlinha = 1
   End If
   numlinha = CInt(numlinha)

   If numcol = "" Or not IsNumeric(numcol) Then
     numcol = 1
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
    NumPerPage = 50
  End If


Dim objConn, objRS, objRSDetail, strSQL, strSQLClause, strSQLClause2, strSQLLeftJoin, strSQLParenteses, strFLAG_EVENTO, strSQLOrdem, cont
Dim strEMPRESA, strNOME, strNOME_COMPLETO, strLOCAL, strATIV, strCODBARRA, strENTIDADE, strCARGO, strCIDADE, strESTADO, strCEP, strPAIS, strID_NUM_DOC1, strDT_ATUAL, strCOD_EMPRESA, strCOD_EMPRESA_ETIQUETA, strENDERECO
Dim strSTATUS_CRED, strSTATUS_PRECO, strSTATUS_PRECO_MINI

Dim strCREDENCIAL, strCREDENCIAL_MODELO


AbreDBConn objConn, CFG_DB_DADOS 


'Pega o layout padrão para colocar como modelo básico
strCREDENCIAL_MODELO = MontaLayoutCredencialSessao("")

'---------------------------------------------------------------------------------
'Trecho para pegar o MODELO DO LAYOUT do ETIQUETA DE ENDEREÇAMENTO / MALA DIRETA

Dim strMALADIRETA_MODELO, strMALADIRETA
Dim FSO, fich, strARQUIVO, strPATH

strPATH = Server.MapPath("../") & "\_database\"
' Response.Write(strPATH & "<BR>")

Set FSO = createObject("scripting.filesystemobject") 

strARQUIVO = strPATH & "modelo_maladireta" & "_" & Session("COD_EVENTO") & ".asp"
  If not FSO.FileExists(strARQUIVO) Then
strARQUIVO = strPATH & "modelo_maladireta.asp"
End If

' Response.Write(strARQUIVO)
' Response.End()

Set fich = FSO.OpenTextFile(strARQUIVO) 
strMALADIRETA_MODELO = fich.readAll() 
fich.close() 

Set fich = Nothing
Set FSO = Nothing

%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<%
Response.Buffer = True

 
 
If UCase(Request("var_impressao")) = "TRUE" Then
   


   strNUM_CRED_PJ = 0
   strNOMINAL = ""
   strSQL_CRITERIO = ""
   strSQL_INNER = ""
   strSQL_INNER_SUB = ""
   strCOD_EMPRESA_ETIQUETA = ""
   
   ' Consulta para pegar o campo NUM_CRED_PJ do Lote pra impressão de credencias pra empresa
   strSQL = " SELECT NUM_CRED_PJ, NOMINAL, CRITERIO_EVENTO, SQL_CRITERIO, SQL_INNER, SQL_INNER_SUB, SQL_CRITERIO_SUB, IGNORAR_CONTATO, CADASTRO_COM_FOTO FROM tbl_Lote WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
     strNUM_CRED_PJ = clng(objRS("NUM_CRED_PJ"))
	 strNOMINAL = objRS("NOMINAL")&""
	 strCRITERIO_EVENTO = objRS("CRITERIO_EVENTO")&""
	 strSQL_CRITERIO = objRS("SQL_CRITERIO")&""
	 strSQL_INNER = objRS("SQL_INNER")&""
	 strSQL_INNER_SUB = objRS("SQL_INNER_SUB")&""
	 strSQL_CRITERIO_SUB = objRS("SQL_CRITERIO_SUB")&""
	 strSQL_IGNORAR_CONTATO = objRS("IGNORAR_CONTATO")&""
	 strSQL_CADASTRO_COM_FOTO = objRS("CADASTRO_COM_FOTO")&""
   End If
   FechaRecordSet objRS
   
   If strCRITERIO_EVENTO = "" Then
     strCRITERIO_EVENTO = "AND"
   End If
   
   strCAMPO_ANTERIOR = ""
   strSQL = " SELECT * FROM tbl_Lote_Criterio WHERE COD_LOTE = " & strCOD_LOTE
   Set objRS = objConn.Execute(strSQL)
   Do While not objRS.EOF

     strCAMPO = objRS("CAMPO")&""
   
     'Testa para montar clausula do mesmo tipo de campo com OR dentro de parenteses  
	 ' AND (CAMPO1 = 1 or CAMPO1 = 2)
	 'Se o campo for diferente do anterior entao coloca AND fechando o parantese anterior
	 
     If strCAMPO_ANTERIOR <> strCAMPO Then
	 
	   strCAMPO_ANTERIOR = strCAMPO
       strSQLClause = strSQLClause & ") AND ("
	   strSQLClause = strSQLClause & strCAMPO & " "
	   
	 Else
	 
	   strCRITERIO_OPERADOR = objRS("OPERADOR")&""
	   If strCRITERIO_OPERADOR = "" Then
	     strCRITERIO_OPERADOR = "OR"
	   End If
       strSQLClause = strSQLClause & " "&strCRITERIO_OPERADOR&" "
	   strSQLClause = strSQLClause & strCAMPO & " "
	 
	 End If	   

	 strCRITERIO = objRS("CRITERIO")&""
	 strVALOR = Replace(objRS("VALOR")&"","'","''")
	 'Forçando para ver se o campo é do tipo DATA pelo nome literal do campo no banco
	 'Ideal é usar função que pega o tipo de dado do banco
	 If InStr(strCAMPO,"SYS_DATA") > 0 Then
	   strVALOR = PrepDataIve(strVALOR,False,True)
	 End If

	   
	 Select Case strCRITERIO
	     Case "IN"
		   strSQLClause = strSQLClause & strCRITERIO & " ('" & Replace(Replace(strVALOR,"'","''"),",","','") & "') "
		 Case "LIKE","LIKE_CONTEM"
		   strSQLClause = strSQLClause & " LIKE '%" & Replace(Replace(strVALOR,"'","''"),",","','") & "%' "
		 Case "LIKE_COMECA"
		   strSQLClause = strSQLClause & " LIKE '" & Replace(Replace(strVALOR,"'","''"),",","','") & "%'"
		 Case Else
		   strSQLClause = strSQLClause & strCRITERIO & " '" & strVALOR & "' "
	 End Select

     objRS.MoveNext
   Loop
   strSQLClause = strSQLClause & ") "
   FechaRecordSet objRS

    strFLAG_EVENTO = False
	cont = 1
	
    strSQL = " SELECT COD_EVENTO, CRITERIO FROM tbl_LOTE_EVENTO WHERE COD_LOTE = " & strCOD_LOTE
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then	
	 
	 strFLAG_EVENTO = True
	 
	 strSQLParenteses = strSQLParenteses & " ( "
	   
	 strSQLLeftJoin = strSQLLeftJoin & " LEFT OUTER JOIN VIEW_RESUMO_VISITACAO ON (tbl_Empresas.COD_EMPRESA = VIEW_RESUMO_VISITACAO.COD_EMPRESA_VISITACAO) "
	 strSQLLeftJoin = strSQLLeftJoin & ")"
	 
	 strSQLClause2 = strSQLClause2 & " AND ("
	 
	 Do While not objRS.EOF
	  
	  If objRS("CRITERIO") = "<>" Then
		strSQLClause2 = strSQLClause2 & " VIEW_RESUMO_VISITACAO.`" & objRS("COD_EVENTO") & "` = 0"
	  Else
		strSQLClause2 = strSQLClause2 & " VIEW_RESUMO_VISITACAO.`" & objRS("COD_EVENTO") & "` > 0"
	  End If
	  cont = cont + 1
	  objRS.MoveNext
	  If not objRS.EOF Then
	    strSQLClause2 = strSQLClause2 & " " & strCRITERIO_EVENTO & " "
	  End If
	 Loop
	 strSQLClause2 = strSQLClause2 & ")"
	End If
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
         'strSQLOrdem = strSQLOrdem & " tbl_Pais." & objRS("CAMPO") & " " & objRS("DIRECAO") & ", "
		 strSQLOrdem = strSQLOrdem & " " & objRS("CAMPO") & " " & objRS("DIRECAO") & ", "
       Else
		 'strSQLOrdem = strSQLOrdem & " tbl_Empresas." & objRS("CAMPO") & " " & objRS("DIRECAO") & ", "
		 strSQLOrdem = strSQLOrdem & " " & objRS("CAMPO") & " " & objRS("DIRECAO") & ", "
	   End If
       objRS.MoveNext
     Loop
     strSQLOrdem = strSQLOrdem & " 1 "
   End If
   FechaRecordSet objRS
   
   If strFLAG_IMPRIME_ETIQUETA = "S" Then
	 If strSQLOrdem <> "" Then
	   strSQLOrdem = strSQLOrdem & ", COD_EMPRESA, CODBARRA"
	 Else
	   strSQLOrdem = " ORDER BY END_CEP, COD_EMPRESA, CODBARRA, NOMECLI, NOME_CREDENCIAL"
	 End If
   End If


   If strSQLOrdem = "" Then
     strSQLOrdem = " ORDER BY COD_EMPRESA, CODBARRA, NOMECLI"
   End If	 

   
   strSQL = ""
   
   If strNUM_CRED_PJ > 0 Then
     strSQL = strSQL & "(" 

     For i = 1 To strNUM_CRED_PJ
	   strSQL = strSQL & " SELECT tbl_Empresas.COD_EMPRESA"	   
	   strSQL = strSQL & ", concat(tbl_Empresas.COD_EMPRESA,'00" & i & "') AS CODBARRA"
	   strSQL = strSQL & ", tbl_Empresas.NOMECLI"
	   strSQL = strSQL & ", tbl_Empresas.NOMEFAN"
	   strSQL = strSQL & ", tbl_Empresas.END_FULL"
	   strSQL = strSQL & ", tbl_Empresas.END_BAIRRO"
	   strSQL = strSQL & ", tbl_Empresas.END_CIDADE"
	   strSQL = strSQL & ", tbl_Empresas.END_ESTADO"
	   strSQL = strSQL & ", tbl_Empresas.END_CEP"
	   strSQL = strSQL & ", tbl_Empresas.END_PAIS"
	   strSQL = strSQL & ", tbl_Empresas.EMAIL1"
	   strSQL = strSQL & ", tbl_Empresas.EMAIL2"
	   strSQL = strSQL & ", tbl_Empresas.FONE1"
	   strSQL = strSQL & ", tbl_Empresas.FONE2"
	   strSQL = strSQL & ", tbl_Empresas.FONE3"
	   strSQL = strSQL & ", tbl_Empresas.FONE4"
	   strSQL = strSQL & ", tbl_Empresas.ENTIDADE"
	   strSQL = strSQL & ", tbl_Empresas.ENTIDADE_FANTASIA"
	   strSQL = strSQL & ", tbl_Empresas.ENTIDADE_CARGO"
	   strSQL = strSQL & ", tbl_Empresas.CODATIV1"
	   strSQL = strSQL & ", tbl_Empresas.ID_NUM_DOC1"
	   strSQL = strSQL & ", tbl_Status_Preco.STATUS as CATEGORIA"
	   strSQL = strSQL & ", tbl_Status_Preco.STATUS_MINI as CATEG_MINI"
	   strSQL = strSQL & ", tbl_Status_Cred.STATUS as CREDENCIAL"
	   strSQL = strSQL & ", tbl_Empresas.HOMEPAGE"
	   strSQL = strSQL & ", tbl_Empresas.SYS_DATACA"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_1"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_2"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_3"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_4"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_5"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_6"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_7"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_8"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_9"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_10"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_NUM_1"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_NUM_2"
	   strSQL = strSQL & ", tbl_Empresas.EXTRA_NUM_3"
	   strSQL = strSQL & ", tbl_Empresas.DT_NASC"
	   strSQL = strSQL & ", tbl_Empresas.SEXO"
	   strSQL = strSQL & ", tbl_Empresas.SENHA"
	   strSQL = strSQL & ", tbl_Empresas.TIPO_PESS"
	   strSQL = strSQL & ", tbl_Pais.IDIOMA"
	   strSQL = strSQL & ", if(tbl_Atividade.ATIVMINI IS NULL,tbl_Atividade.ATIVIDADE,tbl_Atividade.ATIVMINI) as ATIVIDADE"
	   strSQL = strSQL & ", tbl_Atividade.TTO_F"
	   strSQL = strSQL & ", tbl_Atividade.TTO_M"
	   strSQL = strSQL & ", '' as ID_CPF"
	   strSQL = strSQL & " ,'" & strNOMINAL & "' AS NOME_COMPLETO"
	   strSQL = strSQL & " ,'" & strNOMINAL & "' AS NOME_CREDENCIAL"
	   strSQL = strSQL & ", '' AS CARGO_NOME"
	   strSQL = strSQL & ", '' AS DT_NASC"
	   strSQL = strSQL & ", '' AS EMAIL"
       strSQL = strSQL & ", '' as EXTRA_TXT_1_SUB"
       strSQL = strSQL & ", '' as EXTRA_TXT_2_SUB"
       strSQL = strSQL & ", '' as EXTRA_TXT_3_SUB"
       strSQL = strSQL & ", '' as EXTRA_TXT_4_SUB"
       strSQL = strSQL & ", '' as EXTRA_TXT_5_SUB"
       strSQL = strSQL & ", '' as EXTRA_TXT_6_SUB"
       strSQL = strSQL & ", '' as EXTRA_TXT_7_SUB"
       strSQL = strSQL & ", '' as EXTRA_TXT_8_SUB"
       strSQL = strSQL & ", '' as EXTRA_TXT_9_SUB"
       strSQL = strSQL & ", '' as EXTRA_TXT_10_SUB"  	   
	   strSQL = strSQL & ", tbl_empresas.cod_status_cred"
	   strSQL = strSQL & ", t1.cod_inscricao "
	   strSQL = strSQL & " FROM " & strSQLParenteses & " ( tbl_Empresas "
	   strSQL = strSQL & "       LEFT JOIN tbl_Pais ON tbl_Empresas.END_PAIS = tbl_Pais.PAIS"
	   strSQL = strSQL & "       LEFT JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV"
	   strSQL = strSQL & "       LEFT JOIN tbl_Status_Cred ON tbl_Empresas.COD_STATUS_CRED = tbl_Status_Cred.COD_STATUS_CRED "
	   strSQL = strSQL & "       LEFT JOIN tbl_Status_Preco ON tbl_Empresas.COD_STATUS_PRECO = tbl_Status_Preco.COD_STATUS_PRECO "
	   'strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON tbl_empresas.codbarra = v.codbarra "
	   If strSQL_IGNORAR_CONTATO&"" = "1" Then
     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON tbl_empresas.cod_empresa = v.cod_empresa "
   Else
     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON if(tbl_empresas_sub.codbarra is null,tbl_empresas.codbarra,tbl_empresas_sub.codbarra) = v.codbarra "
   End If
	   strSQL = strSQL & "       LEFT JOIN tbl_inscricao t1 ON tbl_empresas.cod_empresa = t1.cod_empresa and t1.cod_evento = "&session("COD_EVENTO") &")"
	   strSQL = strSQL & strSQLLeftJoin
	   strSQL = strSQL & " WHERE  (tbl_Empresas.COD_EMPRESA IS NOT NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.SYS_INATIVO IS NULL "
	   strSQL = strSQL & "    AND  tbl_Empresas.TIPO_PESS = 'N' "
	   strSQL = strSQL & strSQLClause
	   strSQL = strSQL & strSQLClause2
	   strSQL = strSQL  & ")" 
	   strSQL = strSQL & " UNION " 
	   strSQL = strSQL & "("  
	 Next
     
   End If

   strSQL = strSQL & " SELECT tbl_Empresas.COD_EMPRESA"
   strSQL = strSQL & ", if(tbl_empresas_sub.codbarra is null, tbl_empresas.codbarra,tbl_empresas_sub.codbarra) as CODBARRA"
   strSQL = strSQL & ", tbl_Empresas.NOMECLI"
   strSQL = strSQL & ", tbl_Empresas.NOMEFAN"
   strSQL = strSQL & ", tbl_Empresas.END_FULL"
   strSQL = strSQL & ", tbl_Empresas.END_BAIRRO"
   strSQL = strSQL & ", tbl_Empresas.END_CIDADE"
   strSQL = strSQL & ", tbl_Empresas.END_ESTADO"
   strSQL = strSQL & ", tbl_Empresas.END_CEP"
   strSQL = strSQL & ", tbl_Empresas.END_PAIS"
   strSQL = strSQL & ", tbl_Empresas.EMAIL1"
   strSQL = strSQL & ", tbl_Empresas.EMAIL2"
   strSQL = strSQL & ", tbl_Empresas.FONE1"
   strSQL = strSQL & ", tbl_Empresas.FONE2"
   strSQL = strSQL & ", tbl_Empresas.FONE3"
   strSQL = strSQL & ", tbl_Empresas.FONE4"
   strSQL = strSQL & ", tbl_Empresas.ENTIDADE"
   strSQL = strSQL & ", tbl_Empresas.ENTIDADE_FANTASIA"
   strSQL = strSQL & ", tbl_Empresas.ENTIDADE_CARGO"
   strSQL = strSQL & ", tbl_Empresas.CODATIV1"
   strSQL = strSQL & ", tbl_Empresas.ID_NUM_DOC1"
   strSQL = strSQL & ", tbl_Status_Preco.STATUS as CATEGORIA"
   strSQL = strSQL & ", tbl_Status_Preco.STATUS_MINI as CATEG_MINI"
   strSQL = strSQL & ", tbl_Status_Cred.STATUS as CREDENCIAL"
   strSQL = strSQL & ", tbl_Empresas.HOMEPAGE"
   strSQL = strSQL & ", tbl_Empresas.SYS_DATACA"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_1 as EXTRA_TXT_1"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_2 as EXTRA_TXT_2"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_3 as EXTRA_TXT_3"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_4 as EXTRA_TXT_4"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_5 as EXTRA_TXT_5"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_6 as EXTRA_TXT_6"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_7 as EXTRA_TXT_7"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_8 as EXTRA_TXT_8"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_9 as EXTRA_TXT_9"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_TXT_10 as EXTRA_TXT_10"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_NUM_1"   
   strSQL = strSQL & ", tbl_Empresas.EXTRA_NUM_2"
   strSQL = strSQL & ", tbl_Empresas.EXTRA_NUM_3"
   strSQL = strSQL & ", tbl_Empresas.DT_NASC"
   strSQL = strSQL & ", tbl_Empresas.SEXO"
   strSQL = strSQL & ", tbl_Empresas.SENHA"
   strSQL = strSQL & ", tbl_Empresas.TIPO_PESS"
   strSQL = strSQL & ", tbl_Pais.IDIOMA"
   strSQL = strSQL & ", if(tbl_Atividade.ATIVMINI IS NULL,tbl_Atividade.ATIVIDADE,tbl_Atividade.ATIVMINI) as ATIVIDADE"
   strSQL = strSQL & ", tbl_Atividade.TTO_F"
   strSQL = strSQL & ", tbl_Atividade.TTO_M"
   strSQL = strSQL & ", tbl_Empresas_Sub.ID_CPF"
   strSQL = strSQL & ", tbl_Empresas_Sub.NOME_COMPLETO"
   strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_CREDENCIAL"
   strSQL = strSQL & ", tbl_Empresas_Sub.CARGO_NOME"
   strSQL = strSQL & ", tbl_Empresas_Sub.DT_NASC"
   strSQL = strSQL & ", tbl_Empresas_Sub.EMAIL"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_1 as EXTRA_TXT_1_SUB"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_2 as EXTRA_TXT_2_SUB"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_3 as EXTRA_TXT_3_SUB"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_4 as EXTRA_TXT_4_SUB"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_5 as EXTRA_TXT_5_SUB"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_6 as EXTRA_TXT_6_SUB"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_7 as EXTRA_TXT_7_SUB"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_8 as EXTRA_TXT_8_SUB"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_9 as EXTRA_TXT_9_SUB"
   strSQL = strSQL & ", tbl_Empresas_sub.EXTRA_TXT_10 as EXTRA_TXT_10_SUB"      
   strSQL = strSQL & ", t1.cod_inscricao"
   strSQL = strSQL & ", if(tbl_empresas_sub.cod_status_cred is null, tbl_empresas.cod_status_cred,tbl_empresas_sub.cod_status_cred) as COD_STATUS_CRED"
   strSQL = strSQL & " FROM " & strSQLParenteses & " ("
   strSQL = strSQL & "  tbl_Empresas LEFT JOIN tbl_Empresas_Sub ON tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA"
   If strSQL_IGNORAR_CONTATO&"" = "1" Then
      strSQL = strSQL & " AND tbl_Empresas_Sub.CODBARRA IS NULL"
   End If
   strSQL = strSQL & "       LEFT JOIN tbl_Pais ON tbl_Empresas.END_PAIS = tbl_Pais.PAIS"
   strSQL = strSQL & "       LEFT JOIN tbl_Atividade ON tbl_Empresas.CODATIV1 = tbl_Atividade.CODATIV "
   strSQL = strSQL & "       LEFT JOIN tbl_Status_Cred ON if(tbl_Empresas_Sub.COD_STATUS_CRED is null,tbl_Empresas.COD_STATUS_CRED,tbl_Empresas_Sub.COD_STATUS_CRED) = tbl_Status_Cred.COD_STATUS_CRED "
   strSQL = strSQL & "       LEFT JOIN tbl_Status_Preco ON tbl_Empresas.COD_STATUS_PRECO = tbl_Status_Preco.COD_STATUS_PRECO "
   'strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON if(tbl_empresas_sub.codbarra is null,tbl_empresas.codbarra,tbl_empresas_sub.codbarra) = v.codbarra "
   If strSQL_IGNORAR_CONTATO&"" = "1" Then
     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON tbl_empresas.cod_empresa = v.cod_empresa "
   Else
     strSQL = strSQL & "       LEFT JOIN tbl_controle_in v ON if(tbl_empresas_sub.codbarra is null,tbl_empresas.codbarra,tbl_empresas_sub.codbarra) = v.codbarra "
   End If
   strSQL = strSQL & "       LEFT JOIN tbl_inscricao t1 ON tbl_empresas.cod_empresa = t1.cod_empresa and t1.cod_evento = "&session("COD_EVENTO") &")"
   strSQL = strSQL & " " & strSQLLeftJoin
   strSQL = strSQL & " " & strSQL_INNER
   strSQL = strSQL & " " & strSQL_INNER_SUB
   strSQL = strSQL & " WHERE  ( tbl_Empresas.SYS_INATIVO IS NULL "
   strSQL = strSQL & " " & strSQLClause
   strSQL = strSQL & " " & strSQLClause2
   strSQL = strSQL & " " & strSQL_CRITERIO
   strSQL = strSQL & " " & strSQL_CRITERIO_SUB
   If strCEP_INICIO <> "" and strCEP_FIM <> "" Then
     strSQL = strSQL & " AND tbl_Empresas.END_CEP BETWEEN '"&strCEP_INICIO&"' AND '"&strCEP_FIM&"' "
   End If
   If strSQL_CADASTRO_COM_FOTO&"" = "1" Then
	      strSQL = strSQL & " AND if(tbl_Empresas_Sub.CODBARRA is null,tbl_Empresas.IMG_FOTO,tbl_Empresas_Sub.IMG_FOTO) IS NULL"
   End If
   strSQL = strSQL & " GROUP BY 1,2 "
   
   If strNUM_CRED_PJ > 0 Then
     strSQL = strSQL & ")"  
   End If
   
   
   strSQL = strSQL & strSQLOrdem

   '=======================================================================
  

  'Response.Write strSQL & "<BR>"
  'Response.End()		

  Set objRS = Server.CreateObject("ADODB.Recordset")
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

   Dim i, j, Contador, num_pagina, contadorflush
   Dim strBgColor, strPRODUTO, strTTO
   Dim strTOT_INSCRICAO
   strPRODUTO = ""
   %>
<table border="0" cellspacing="0" cellpadding="0">
<%
  If Cstr(numcol) <> "1" And Cstr(numlinha) <> "1" Then
%>
  <tr> 
    <td colspan="<%=numcol%>" valign="top"><img src="../img/transparent.gif" width="10" height="10" border="0"></td>
  </tr>
<%
  End If
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
  
  contadorflush = 0

  'On Error Resume Next
  Do While (Not objRS.EOF) And (i <= objRS.PageSize)
    If Contador = numetiqueta Then
      ' Fecha a linha da tabela
	  %>
             </tr>
        </table>
	  <%If Cstr(numcol) <> "1" Or Cstr(numlinha) <> "1" Then
    %>
	  <table border="0" cellspacing="0" cellpadding="0" class="arial10" >
      <tr>   
        <td align="center"><font color="#999999">Página <%=num_pagina%> de <%=TotalPages%> (Lote <%=CurPage%> de <%=TotalLotes%>)</font></td>
      </tr>
	  </table>
    <%
	  End IF
	%>
      <!--este comando faz a quebra de página forçada, o problema é que quando foi utilizado ele imprimiu uma página em branco //-->
      <div style="page-break-before:always; width:1px;height:1px;visibility:collapse;"></div>
	  <table border="0" cellspacing="0" cellpadding="0">
	<%
      If Cstr(numcol) <> "1" And Cstr(numlinha) <> "1" Then
    %>
      <tr> 
        <td colspan="<%=numcol%>" valign="top"><img src="../img/transparent.gif" width="10" height="10" border="0"></td>
      </tr>
	<%
	  End If
	  
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
	
	strCOD_EMPRESA = objRS("COD_EMPRESA")&""
    strCODBARRA  = objRS("CODBARRA")&""
	if strCOD_INSCRICAO = "" THEN
		strCOD_INSCRICAO  = objRS("COD_INSCRICAO")&""
	End if
    strEMPRESA   = Trim(objRS("NomeFan")&"")
	strNOME_COMPLETO = Trim(objRS("NOMECLI")&"")
	strENDERECO  = Trim(objRS("END_FULL")&"")
    strCIDADE    = Trim(objRS("END_CIDADE")&"")
	strESTADO    = Trim(objRS("END_ESTADO")&"")
    strLOCAL     = strCIDADE & "/" & strESTADO
	strPAIS      = Trim(objRS("END_PAIS")&"")
	strCEP       = objRS("END_CEP")&""
	strSTATUS_CRED = objRS("CREDENCIAL")&""
	strSTATUS_PRECO = objRS("CATEGORIA")&""
	strSTATUS_PRECO_MINI = objRS("CATEG_MINI")&""

	strNOME = Trim(objRS("NOME_CREDENCIAL") & "")
    strID_NUM_DOC1 = objRS("ID_NUM_DOC1") & ""

   	If strNOME = "" Then
      strNOME      = Trim(objRS("NomeFan")&"")
	End If
	
   	If Trim(objRS("NOME_COMPLETO")&"") = "" and Trim(objRS("NOME_CREDENCIAL")&"") = "" Then
      strCODBARRA  = objRS("COD_EMPRESA") & "010"
	  strSQL = " UPDATE tbl_EMPRESAS SET SYS_DATACRED = NOW() WHERE COD_EMPRESA = '" & objRS("COD_EMPRESA") & "'"
	Else
	  strSQL = " UPDATE tbl_EMPRESAS_SUB SET SYS_DATACRED = NOW() WHERE CODBARRA = '" & strCODBARRA & "'"
	  strNOME_COMPLETO = Trim(objRS("NOME_COMPLETO")&"")
	End If


	If strMARCAIMPRESSAO = "S" Then
	  objConn.Execute(strSQL)
    End If
	
	If strMARCAIMPRESSAO = "S" And strNUM_CRED_PJ > 0 Then
	  strSQL = " UPDATE tbl_EMPRESAS SET SYS_DATACRED = NOW() WHERE COD_EMPRESA = '" & objRS("COD_EMPRESA") & "'"
	  objConn.Execute(strSQL)
	End If
	
	

	strENTIDADE  = Trim(objRS("ENTIDADE_FANTASIA"))&""
	If strENTIDADE = "" Then
	  strENTIDADE  = Trim(objRS("ENTIDADE"))&""
	End If
	
	If strENTIDADE = "" Then
	  strENTIDADE  = strEMPRESA
	End If
	
		If strNOME <> "" And strNOME = strNOME_COMPLETO Then
	  strNOME_COMPLETO = ""
	End If

	If strNOME <> "" And strNOME = strENTIDADE Then
	  strENTIDADE = ""
	End If


	strCARGO = objRS("CARGO_NOME")&""
	If strCARGO = "" Then
		strCARGO = objRS("ENTIDADE_CARGO")&""
	End If

    strATIV      = Trim(objRS("ATIVIDADE")&"")

	If Trim(objRS("NOME_COMPLETO")&"") = "" and Trim(objRS("NOME_CREDENCIAL")&"") = "" Then
	
		strEXTRA_TXT_1 = objRS("EXTRA_TXT_1")&""
		strEXTRA_TXT_2 = objRS("EXTRA_TXT_2")&""
		strEXTRA_TXT_3 = objRS("EXTRA_TXT_3")&""
		strEXTRA_TXT_4 = objRS("EXTRA_TXT_4")&""
		strEXTRA_TXT_5 = objRS("EXTRA_TXT_5")&""
		strEXTRA_TXT_6 = objRS("EXTRA_TXT_6")&""
		strEXTRA_TXT_7 = objRS("EXTRA_TXT_7")&""
		strEXTRA_TXT_8 = objRS("EXTRA_TXT_8")&""
		strEXTRA_TXT_9 = objRS("EXTRA_TXT_9")&""
		strEXTRA_TXT_10 = objRS("EXTRA_TXT_10")&""			
	Else
   		strEXTRA_TXT_1 = objRS("EXTRA_TXT_1_SUB")&""
		strEXTRA_TXT_2 = objRS("EXTRA_TXT_2_SUB")&""
		strEXTRA_TXT_3 = objRS("EXTRA_TXT_3_SUB")&""
		strEXTRA_TXT_4 = objRS("EXTRA_TXT_4_SUB")&""
		strEXTRA_TXT_5 = objRS("EXTRA_TXT_5_SUB")&""
		strEXTRA_TXT_6 = objRS("EXTRA_TXT_6_SUB")&""
		strEXTRA_TXT_7 = objRS("EXTRA_TXT_7_SUB")&""
		strEXTRA_TXT_8 = objRS("EXTRA_TXT_8_SUB")&""
		strEXTRA_TXT_9 = objRS("EXTRA_TXT_9_SUB")&""
		strEXTRA_TXT_10 = objRS("EXTRA_TXT_10_SUB")&""
	End If			


	If (numetiqueta - Contador) > numcol Then
	  altTabela = "228"
'	Else
'	  altTabela = ""
	End If

    Response.Write "<td width=""" & tamcol & """>"
	
	
	
	'strCREDENCIAL = strCREDENCIAL_MODELO
		
	strCREDENCIAL = MontaLayoutCredencialSessao(objRS("COD_STATUS_CRED"))
	
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_NOME_CREDENCIAL>",Left(strNOME,CFG_MAXLEN_LABEL_NOME))
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_NOME_COMPLETO>",strNOME_COMPLETO)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_TTO>",strTTO)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_ID_NUM_DOC1>",strID_NUM_DOC1)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_ENTIDADE>",Left(strENTIDADE,25))
	If strNOME <> strEMPRESA Then
	  strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EMPRESA>",Left(strEMPRESA,25))
	End If
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_CODBARRA>",strCODBARRA)
	
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_PINCODE>",right(strCOD_INSCRICAO,4))

	
	If strPAIS = "BRASIL" Then 
      If strLOCAL <> "/" Then
	    strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_LOCAL>",strLOCAL)
	  End If
	  
	  If strCIDADE&"" <> "" And strESTADO&""<> "" Then
		strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_LOCAL_SEP>","/")
	  End If
	  
	  strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_CIDADE>",strCIDADE)
	  strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_ESTADO>",strESTADO)
	  strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_PAIS>",strPAIS)
	Else
	  ' Trecho para atender a demanda da couromoda: se BRASIL entao cidade+estado, senao somente pais
	  strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_CIDADE>",strPAIS)

      strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_ESTADO>","")	  
      strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_LOCAL>",strPAIS)
	End If
	
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_CIDADE>",strCIDADE)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_ESTADO>",strESTADO)
    strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_PAIS>",strPAIS&"")
	
	
    'strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_BARCODE>", ReturnBarCode25(strCODBARRA, 30, 1.5, "../img/"))
    strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_BARCODE>", ReturnBarCode39(strCODBARRA, 30, 1.5, "../img/"))
	
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_BARCODE_VERTICAL>", ReturnBarCode39Vertical(strCODBARRA, 30, 1.5, "../img/"))
	
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_NRO_BARCODE>", strCODBARRA)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_ENDERECO>",strENDERECO)
    strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_CEP>",strCEP)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_ATIVIDADE>",strATIV)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_CARGO>",strCARGO)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_STATUS_CRED>",strSTATUS_CRED)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_STATUS_PRECO>",strSTATUS_PRECO)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_STATUS_PRECO_MINI>",strSTATUS_PRECO_MINI)
	
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_1>",strEXTRA_TXT_1)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_2>",strEXTRA_TXT_2)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_3>",strEXTRA_TXT_3)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_4>",strEXTRA_TXT_4)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_5>",strEXTRA_TXT_5)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_6>",strEXTRA_TXT_6)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_7>",strEXTRA_TXT_7)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_8>",strEXTRA_TXT_8)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_9>",strEXTRA_TXT_9)
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_EXTRA_TXT_10>",strEXTRA_TXT_10)
	
	strDT_ATUAL = PrepData(now(),true,false) 
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_DATA_DDMMAAAA>",strDT_ATUAL)
	strDT_ATUAL = PrepData(now(),true,true) 
	strCREDENCIAL = Replace(strCREDENCIAL,"<PRO_HORA_HHMMSS>",right(strDT_ATUAL,Len(strDT_ATUAL) - InStr(strDT_ATUAL," ") + 1) )

	If strFLAG_IMPRIME_ETIQUETA = "S" Then
	
		strMALADIRETA = strMALADIRETA_MODELO&""
		
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_NOMINAL>",strNOMINAL)
		
		If strFLAG_SOMENTE_EMPRESA = False or objRS("TIPO_PESS")&"" = "S" Then
		  strMALADIRETA = Replace(strMALADIRETA,"<PRO_NOME_CREDENCIAL>",Left(strNOME&"",CFG_MAXLEN_LABEL_NOME))
		  strMALADIRETA = Replace(strMALADIRETA,"<PRO_NOME_COMPLETO>",strNOME_COMPLETO&"")
		End If
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_ENTIDADE>",Left(strENTIDADE&"",25))
		If strNOME <> strEMPRESA Then
		  strMALADIRETA = Replace(strMALADIRETA,"<PRO_EMPRESA>",Left(strEMPRESA&"",25))
		End If
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_COD_EMPRESA>",strCOD_EMPRESA&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_CODBARRA>",strCODBARRA&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_ENDERECO>",strENDERECO)
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_CEP>",strCEP&"")

		
		If strPAIS = "BRASIL" Then 
      If strLOCAL <> "/" Then
	    strMALADIRETA = Replace(strMALADIRETA,"<PRO_LOCAL>",strLOCAL)
	  End If
	  
	  If strCIDADE&"" <> "" And strESTADO&""<> "" Then
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_LOCAL_SEP>","/")
	  End If
	  
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_CIDADE>",strCIDADE)
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_ESTADO>",strESTADO)
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_PAIS>",strPAIS)
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_LOCAL_SEP_PAIS>","/")
	Else
	  ' Trecho para atender a demanda da couromoda: se BRASIL entao cidade+estado, senao somente pais
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_LOCAL_SEP_PAIS>","/")
	  strMALADIRETA = Replace(strMALADIRETA,"<PRO_CIDADE>",strCIDADE)	  
      strMALADIRETA = Replace(strMALADIRETA,"<PRO_ESTADO>","")	  
      strMALADIRETA = Replace(strMALADIRETA,"<PRO_PAIS>",strPAIS)
	End If
		
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_BARCODE>", ReturnBarCode39(strCODBARRA, 30, 1.5, "../img/"))
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_BARCODE_VERTICAL>", ReturnBarCode39Vertical(strCODBARRA, 30, 1.5, "../img/"))
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_NRO_BARCODE>", strCODBARRA)
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_ATIVIDADE>",strATIV&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_CARGO>",strCARGO)
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_ID_NUM_DOC1>",strID_NUM_DOC1)
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_STATUS_CRED>",strSTATUS_CRED)
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_STATUS_PRECO>",strSTATUS_PRECO)
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_STATUS_PRECO_MINI>",strSTATUS_PRECO_MINI)
		
		'Mala direta precisa pegar estes dados da empresa e não dos contatos
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_1>",objRS("EXTRA_TXT_1")&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_2>",objRS("EXTRA_TXT_2")&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_3>",objRS("EXTRA_TXT_3")&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_4>",objRS("EXTRA_TXT_4")&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_5>",objRS("EXTRA_TXT_5")&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_6>",objRS("EXTRA_TXT_6")&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_7>",objRS("EXTRA_TXT_7")&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_8>",objRS("EXTRA_TXT_8")&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_9>",objRS("EXTRA_TXT_9")&"")
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_EXTRA_TXT_10>",objRS("EXTRA_TXT_10")&"")		
	
		
		strDT_ATUAL = PrepData(now(),true,false) 
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_DATA_DDMMAAAA>",strDT_ATUAL)
		strDT_ATUAL = PrepData(now(),true,true) 
		strMALADIRETA = Replace(strMALADIRETA,"<PRO_HORA_HHMMSS>",right(strDT_ATUAL,Len(strDT_ATUAL) - InStr(strDT_ATUAL," ") + 1) )
		
		'Exibe a maladireta
		If  (strCOD_EMPRESA_ETIQUETA <> strCOD_EMPRESA and strFLAG_SOMENTE_EMPRESA) or (not strFLAG_SOMENTE_EMPRESA) Then
			
			strCOD_EMPRESA_ETIQUETA = strCOD_EMPRESA
		
			For j = 1 to strNRO_ETIQUETA
			  Response.Write(strMALADIRETA)
			  %>
			  <div style="page-break-before:always; width:1px;height:1px;visibility:collapse;"></div>
			  <%
			Next

		End If

	End If
		

	'Exibe a credencial
	Response.Write(strCREDENCIAL)
	
	strSQL = "INSERT INTO tbl_Credencial (" & _
			 "  CREDENCIAL" & _
			 ", SYS_DATACA" & _
			 ", SYS_USERCA" & _
			 ", COD_EVENTO" & _
			 ", TIPO" & _
			 ", CODBARRA" & _
			 ", COD_EMPRESA" & _
	         ") VALUES (" & _
			 "  '" & strCODBARRA & "'" & _
	         ", NOW()" & _
			 ", '" & Session("ID_USER") & "'" & _
			 ", " & Session("COD_EVENTO") & _
			 ", 'LOTE'" & _
			 ", '" & strCODBARRA & "'" & _
			 ", '" & strCOD_EMPRESA & "'" & _
			 ")"
    objConn.Execute(strSQL)

	Response.Write "</td>"
    If i mod numcol = 0 And Contador < numetiqueta Then
    ' Se ja colocou n colunas e não é o fim da tabela então cria nova linha na tabela
       Response.Write "        </tr>"
       Response.Write "        <tr>"
    End If
    i = i + 1
    Contador = Contador + 1
	contadorflush = contadorflush + 1
	
	If contadorflush mod 10 = 0 Then
	  Response.Flush()
	End If
	
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
Else
%>
<div align="center"> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong><font face="Arial, Helvetica, sans-serif">.: 
  AVISO :.</font></strong><font face="Arial, Helvetica, sans-serif"><br>
  Informe os critérios acima para montagem das credenciais. </font></font> </div>
  <%
End If

Response.Flush()
%>
</body>
</html>
<%
FechaDBConn ObjConn
%>