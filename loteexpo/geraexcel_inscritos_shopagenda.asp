<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<%
 Server.ScriptTimeout = 2400
 Response.Expires = 0
 Response.Buffer = True
%>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">

<%

Server.Execute("../modulo_admproduto/geraviewprodutos.asp")
'Gerando a Planilha do Excel, através de um recordset
Sub gerarPlanilhaPorRecorset(ORs,nomearquivo)
		Dim objRSDetail, rowcont, strNOME_COLUNA, strVALOR
		Dim strMetodo, objEx
		Dim oWbook, oWSheet
		Dim i2, i
		Dim objWorksheet, objRange, colCharts, objChart
		
		Set objEx = Server.CreateObject("Excel.Application")
		
		objEx.Visible = False
		objEx.DisplayAlerts = False
		objEx.UserControl = False

		Set oWbook = objEx.Workbooks.Add
		
		
		'------------------------------------------------
		' Tabela e gráfico de ATIVIDADES
		strSQL = "SELECT " &_
			 "  if(tbl_atividade_pai.ATIVIDADE is null,tbl_atividade.ATIVIDADE,tbl_atividade_pai.ATIVIDADE) as 'ATIVIDADE' "&_
			 ", COUNT( DISTINCT tbl_inscricao.Codbarra ) as TOTAL" &_
			 "	 FROM tbl_inscricao" &_
			 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_inscricao.cod_empresa)" &_
			 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
			 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
			 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
			 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_inscricao.codbarra)" &_
			 "	 WHERE tbl_inscricao.COD_EVENTO = " & strCOD_EVENTO &_
			 "	   AND tbl_inscricao.SYS_INATIVO IS NULL" &_
			 " GROUP BY 1" &_	 
			 " ORDER BY 1"
			 'response.Write(strSQL)
			 'response.End()
		
		Set objRSDetail = objConn.Execute(strSQL)
		
		If not objRSDetail.EOF Then
			Set objWorksheet = oWbook.Sheets.Add
			objWorksheet.Name = "Atividade"
			
			rowcont = 2
			objWorksheet.Cells(1,1) = "Atividade"
			Do While not objRSDetail.EOF 
			  strNOME_COLUNA = objRSDetail("ATIVIDADE")&""
			  If strNOME_COLUNA = "" Then
				strNOME_COLUNA = "N/A"
			  End If
			  objWorksheet.Cells(rowcont,1) = strNOME_COLUNA
			  objRSDetail.MoveNext
			  rowcont = rowcont + 1
			Loop
			
			objRSDetail.MoveFirst
			
			rowcont = 2
			objWorksheet.Cells(1,2) = "Congressistas Unicos por Atividade"
			Do While not objRSDetail.EOF 
			  objWorksheet.Cells(rowcont,2) = objRSDetail("TOTAL")
			  objRSDetail.MoveNext
			  rowcont = rowcont + 1
			Loop
			
			Set objRange = objWorksheet.UsedRange
			objRange.Select
			
			objEx.Selection.CurrentRegion.Columns.AutoFit
			objEx.Selection.CurrentRegion.Rows.AutoFit
			
			Set colCharts = objEx.Charts
			colCharts.Add()
			
			Set objChart = colCharts(1)
			objChart.Activate
			objChart.Name = "Grafico Atividade"
		
			objChart.HasLegend = False
			'objChart.ChartTitle.Text = "Operating System Use"
		End If
		FechaRecordSet objRSDetail
		'------------------------------------------------
		
		'------------------------------------------------
		' Tabela e gráfico de ESTADOS do BRASIL
		strSQL = "SELECT " &_
			 "  tbl_empresas.END_ESTADO as 'Estado' "&_
			 ", COUNT( DISTINCT tbl_inscricao.Codbarra ) as TOTAL" &_
			 "	 FROM tbl_inscricao" &_
			 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_inscricao.cod_empresa)" &_
			 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
			 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
			 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
			 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_inscricao.codbarra)" &_
			 "	 WHERE tbl_inscricao.COD_EVENTO = " & strCOD_EVENTO &_
			 "	   AND tbl_inscricao.SYS_INATIVO IS NULL" &_
			 "     AND tbl_empresas.END_PAIS = 'BRASIL' " &_
			 " GROUP BY 1" &_	 
			 " ORDER BY 1"
			 
			 'response.Write(strSQL)
			 'response.End()
		
		Set objRSDetail = objConn.Execute(strSQL)
		
		If not objRSDetail.EOF Then
			Set objWorksheet = oWbook.Sheets.Add
			objWorksheet.Name = "Estado"
			
			rowcont = 2
			objWorksheet.Cells(1,1) = "Estado"
			Do While not objRSDetail.EOF 
			  strNOME_COLUNA = objRSDetail("ESTADO")&""
			  If strNOME_COLUNA = "" Then
				strNOME_COLUNA = "N/A"
			  End If
			  objWorksheet.Cells(rowcont,1) = strNOME_COLUNA
			  objRSDetail.MoveNext
			  rowcont = rowcont + 1
			Loop
			
			objRSDetail.MoveFirst
			
			rowcont = 2
			objWorksheet.Cells(1,2) = "Congressistas Unicos por Estado (BRASIL)"
			Do While not objRSDetail.EOF 
			  objWorksheet.Cells(rowcont,2) = objRSDetail("TOTAL")
			  objRSDetail.MoveNext
			  rowcont = rowcont + 1
			Loop
			
			Set objRange = objWorksheet.UsedRange
			objRange.Select
			
			objEx.Selection.CurrentRegion.Columns.AutoFit
			objEx.Selection.CurrentRegion.Rows.AutoFit
			
			Set colCharts = objEx.Charts
			colCharts.Add()
			
			Set objChart = colCharts(1)
			objChart.Activate
			objChart.Name = "Grafico Estado"
			
			objChart.HasLegend = False
			'objChart.ChartTitle.Text = "Operating System Use"
		End If
		FechaRecordSet objRSDetail
		'------------------------------------------------
		
		
		'------------------------------------------------
		' Tabela e gráfico de PAISES
		strSQL = "SELECT " &_
			 "  tbl_empresas.END_PAIS as 'PAIS' "&_
			 ", COUNT( DISTINCT tbl_inscricao.Codbarra ) as TOTAL" &_
			 "	 FROM tbl_inscricao" &_
			 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_inscricao.cod_empresa)" &_
			 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
			 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
			 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
			 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_inscricao.codbarra)" &_
			 "	 WHERE tbl_inscricao.COD_EVENTO = " & strCOD_EVENTO &_
			 "	   AND tbl_inscricao.SYS_INATIVO IS NULL" &_
			 " GROUP BY 1" &_	 
			 " ORDER BY 1"
			 'response.Write(strSQL)
			 'response.End()
		
		Set objRSDetail = objConn.Execute(strSQL)
		If not objRSDetail.EOF Then
			Set objWorksheet = oWbook.Sheets.Add
			objWorksheet.Name = "Pais"
			
			rowcont = 2
			objWorksheet.Cells(1,1) = "Pais"
			Do While not objRSDetail.EOF 
			  strNOME_COLUNA = objRSDetail("PAIS")&""
			  If strNOME_COLUNA = "" Then
				strNOME_COLUNA = "N/A"
			  End If
			  objWorksheet.Cells(rowcont,1) = strNOME_COLUNA
			  objRSDetail.MoveNext
			  rowcont = rowcont + 1
			Loop
			
			objRSDetail.MoveFirst
			
			rowcont = 2
			objWorksheet.Cells(1,2) = "Congressistas Unicos por Pais"
			Do While not objRSDetail.EOF 
			  objWorksheet.Cells(rowcont,2) = objRSDetail("TOTAL")
			  objRSDetail.MoveNext
			  rowcont = rowcont + 1
			Loop
			
			Set objRange = objWorksheet.UsedRange
			objRange.Select
			
			objEx.Selection.CurrentRegion.Columns.AutoFit
			objEx.Selection.CurrentRegion.Rows.AutoFit
			
			Set colCharts = objEx.Charts
			colCharts.Add()
			
			Set objChart = colCharts(1)
			objChart.Activate
			objChart.Name = "Grafico Pais"
			
			objChart.HasLegend = False
			'objChart.ChartTitle.Text = "Operating System Use"
		End If
		FechaRecordSet objRSDetail
		'------------------------------------------------
		
		
		'------------------------------------------------
		' Tabela HISTORICO DAS INSCRIÇÕES
		strSQL = "SELECT i.COD_INSCRICAO as 'Inscrição', ih.HISTORICO, ih.SYS_DATACA as 'Data', ih.SYS_USERCA as 'Usuário' " &_
		     "  FROM tbl_inscricao i INNER JOIN tbl_inscricao_hist ih on i.cod_inscricao = ih.cod_inscricao" &_
			 "	 WHERE i.COD_EVENTO = " & strCOD_EVENTO &_
			 "	   AND i.SYS_INATIVO IS NULL" &_
			 " ORDER BY 1"
			 'response.Write(strSQL)
			 'response.End()
		
		Set objRSDetail = objConn.Execute(strSQL)
		
		If not objRSDetail.EOF Then

			Set objWorksheet = oWbook.Sheets.Add
			objWorksheet.Name = "Historico"
			For i = 0 To objRSDetail.Fields.Count - 1
				objWorksheet.Cells(1, i + 1) = objRSDetail.Fields.Item(i).Name
			Next
			
			objRSDetail.MoveFirst
			
			rowcont = 2
			Do While not objRSDetail.EOF 
				For i = 0 To objRSDetail.Fields.Count - 1
				    strVALOR = objRSDetail.Fields.Item(i).Value
					objWorksheet.Cells(rowcont, i + 1) = strVALOR
				Next
			  objRSDetail.MoveNext
			  rowcont = rowcont + 1
			Loop
			
			Set objRange = objWorksheet.UsedRange
			objRange.Select
			
			objEx.Selection.CurrentRegion.Columns.AutoFit
			objEx.Selection.CurrentRegion.Rows.AutoFit
		
		End If
		FechaRecordSet objRSDetail
		'------------------------------------------------

		
		'=========================
		'INTRODUZ PLANILHA MAILING
		'=========================
		Set oWSheet = oWbook.Sheets.Add
		oWSheet.Name = "Congressistas Unicos"
		For i = 0 To ORs.Fields.Count - 1
			oWSheet.Cells(1, i + 1) = ORs.Fields.Item(i).Name
		Next
		
		'=========================
		'COPIA RECORDSET PARA A PLANILHA
		'=========================
		Call oWSheet.Cells(2, 1).CopyFromRecordset(ORs)
		objEx.Selection.CurrentRegion.Columns.AutoFit
		objEx.Selection.CurrentRegion.Rows.AutoFit
		
		Dim ds_nome_relatorio
		
		ds_nome_relatorio = Server.MapPath(nomearquivo&".xlsx")
		oWSheet.SaveAs ds_nome_relatorio
		oWbook.Close
		
		Set oWSheet = Nothing
		Set oWbook = Nothing
		Set objEx = Nothing
End Sub


AbreDBConn objConn, CFG_DB_DADOS 


Dim strCOD_EVENTO, strNOME_EVENTO

strCOD_EVENTO = Request("cod_evento")
If strCOD_EVENTO = "" Then
  strCOD_EVENTO = Session("cod_evento")
End If

Dim strCAEX_SHOW, strPESQUISA_SHOW
 
strCAEX_SHOW = Request("var_caex_show")
If strCAEX_SHOW = "" or not isNumeric(strCAEX_SHOW) Then
  strCAEX_SHOW = "0"
End If

strPESQUISA_SHOW = Request("var_pesquisa_show")
If strPESQUISA_SHOW = "" or not isNumeric(strPESQUISA_SHOW) Then
  strPESQUISA_SHOW = "0"
End If

If Request("var_acao") = "GERAR" and strCOD_EVENTO <> "" Then
	 Dim objConn, objRS, objRSDetail, strSQL, strACAO, vFiltro, strSQLClause
	 Dim NumPerPage, cont, i
	 Dim strNOME, strID_NUM_DOC1, strFILENAME
	
	 NumPerPage = 18 'Valor padrão
	 cont = 0
	

	 Dim strDT_INICIO_FEIRA, strDT_FIM_FEIRA, strNUM_DIA_FEIRA, strNOME_FEIRA, strDIA
	 
	 strSQL = "SELECT NOME, DT_INICIO, DT_FIM FROM tbl_EVENTO WHERE COD_EVENTO = " & strCOD_EVENTO
	 
	 'Response.write(strSQL)
	 'Response.End()
	 Set objRS = objConn.Execute(strSQL)
	 If not objRS.EOF Then
	   strNOME_FEIRA = objRS("NOME")
	   strDT_INICIO_FEIRA = objRS("DT_INICIO")
	   strDT_FIM_FEIRA = objRS("DT_FIM")
	 Else
	   strNOME_FEIRA = "ProEvento " & Year(Date())
	   strDT_INICIO_FEIRA = Date()
	   strDT_FIM_FEIRA = Date()
	 End If
	 FechaRecordSet objRS 
	 
	 'Força pra ser no formato DD/MM/AAAA
	 strDT_INICIO_FEIRA = Day(strDT_INICIO_FEIRA)&"/"&Month(strDT_INICIO_FEIRA)&"/"& Year(strDT_INICIO_FEIRA)
	 strDT_FIM_FEIRA = Day(strDT_FIM_FEIRA)&"/"&Month(strDT_FIM_FEIRA)&"/"& Year(strDT_FIM_FEIRA)
	 
	 'Response.Write(strDT_INICIO_FEIRA&"<BR>")
	 'Response.Write(strDT_FIM_FEIRA&"<BR>")
	
	 strNUM_DIA_FEIRA = Abs(DateDiff("D",strDT_FIM_FEIRA, strDT_INICIO_FEIRA)) + 1
	 Response.Write("<B>"&strNOME_FEIRA & "</B><BR><BR>")
		 
	 strNOME = strNOME_FEIRA
	 If strNOME <> "" Then
	   strFILENAME = strFILENAME & "_" & strNOME
	 End If
	 strFILENAME = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(strFILENAME,"'",""),"/",""),"&","")," ","_"),".",""),"(",""),")",""),",","")
	 
	 strSQL = "SELECT DISTINCT t1.Codbarra as 'Codigo'" &_
	 		 " , t1.cod_empresa AS cod_empresa" &_
			 ", IF(tbl_empresas.COD_EMPRESA IS NULL,'CADASTRO NÃO PREENCHIDO',tbl_empresas.NOMECLI) as 'Razao Social / Nome '" &_
			 ", tbl_empresas.NOMEFAN as 'Nome Fantasia / Nome Credencial'" &_
			 ", tbl_empresas.ID_NUM_DOC1 as 'CNPJ / CPF ' " &_
			 ", tbl_empresas.ID_INSCR_EST as 'IE / RG ' " &_			 
			 ", tbl_empresas.END_FULL as 'Endereco'" &_
			 ", tbl_empresas.END_BAIRRO as 'Bairro' " &_
			 ", tbl_empresas.END_CIDADE as 'Cidade' " &_
			 ", tbl_empresas.END_ESTADO as 'Estado' " &_
			 ", tbl_empresas.END_PAIS as 'Pais' " &_
			 ", tbl_empresas.END_CEP as 'CEP' " &_
			 ", tbl_empresas.FONE4 as 'Fone1' " &_
			 ", tbl_empresas.FONE1 as 'Fone2' " &_
			 ", tbl_empresas.FONE3 as 'Celular' " &_
			 ", tbl_empresas.FONE2 as 'Fax' " &_
			 ", tbl_empresas.CODATIV1 as 'Cód. Ativ.' " &_
			 ", if(tbl_atividade_pai.ATIVIDADE is not null,concat(tbl_atividade_pai.ATIVIDADE,' - ',tbl_atividade.ATIVIDADE),tbl_atividade.ATIVIDADE) as 'Atividade'" &_
			 ", tbl_empresas.EMAIL1 as 'E-mail' " &_
			 ", tbl_empresas.HOMEPAGE as 'Site' " &_
			 ", tbl_empresas.AUTORIZA_DIVULGACAO_DADOS as 'Autoriza Divulgacao Dados' " &_
			 ", sc.STATUS as 'Credencial'" &_
			 ", tbl_empresas.ENTIDADE as 'Entidade'" &_
			 ", tbl_empresas.ENTIDADE_CNPJ as 'Entidade CNPJ' " &_
			 ", tbl_empresas_sub.nome_completo AS 'Contato'" &_
			 ", tbl_empresas_sub.id_cpf AS 'Contato CPF' " &_
			 ", tbl_empresas_sub.email AS 'Contato E-mail' " &_
			 ", tbl_empresas_sub.fone1 AS 'Contato Fone' " &_
			 ", if(sc2.status is null, sc.STATUS, sc2.STATUS) as 'Contato Credencial'" &_
			 ", if(tbl_empresas_sub.cargo_nome is null, tbl_empresas.ENTIDADE_CARGO,tbl_empresas_sub.cargo_nome) as 'Cargo' " &_
			 ", tbl_empresas.ENTIDADE_DEPARTAMENTO as 'Departamento' "
				 
	Dim objRSMapeamento, strNOME_CAMPO, strSQLMapeamento
	
	strSQLMapeamento =          " SELECT NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, CAMPO_COMBOLIST, CAMPO_TIPO, CAMPO_COR_DESTAQUE "
	strSQLMapeamento = strSQLMapeamento & "   FROM tbl_MAPEAMENTO_CAMPO WHERE COD_EVENTO = " & strCOD_EVENTO
	Set objRSMapeamento = objConn.Execute(strSQLMapeamento)
	If not objRSMapeamento.EOF Then
	  Do While not objRSMapeamento.EOF
		strNOME_CAMPO = "tbl_empresas."&objRSMapeamento("NOME_CAMPO_PROEVENTO")&""
		strSQL = strSQL & ", if('"&objRSMapeamento("CAMPO_TIPO")&"' = 'FILE',concat('http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/upload/',"&strNOME_CAMPO& ") , "&strNOME_CAMPO&") AS '" & objRSMapeamento("NOME_DESCRITIVO") & "'"
		objRSMapeamento.MoveNext
	  Loop
	End If
	FechaRecordSet objRSMapeamento
	
	 strSQL = strSQL & ", t1.COD_INSCRICAO as 'Inscricao'" &_
	 ", IF(t1.INSCR_MASTER > 0,t1.INSCR_MASTER,NULL) as  'Grupo'" & _
	 ", t1.DT_ChegadaFicha  AS 'Data Inscricao'" & _
	 ", t1.SYS_DATAAT  AS 'Data Alteracao'" & _
	 ", t1.SYS_CREDENCIAL  AS 'Impressao Credencial'" & _
	 ", MAX(TBL_SENHA_PROMO.CODIGO) AS 'Codigo Promo'"
	 
	 Dim objRSProdutos, strSQLProdutos
	 strSQLProdutos =                  " SELECT DISTINCT P.COD_PROD, P.GRUPO, P.TITULO "
	 strSQLProdutos = strSQLProdutos & "   FROM TBL_PRODUTOS P INNER JOIN TBL_INSCRICAO_PRODUTO IP ON P.COD_PROD = IP.COD_PROD"
	 strSQLProdutos = strSQLProdutos & "                       INNER JOIN TBL_INSCRICAO I ON IP.COD_INSCRICAO = I.COD_INSCRICAO"
	 strSQLProdutos = strSQLProdutos & " WHERE I.COD_EVENTO = " & strCOD_EVENTO
	 strSQLProdutos = strSQLProdutos & "   AND P.CAEX_SHOW = " & strCAEX_SHOW
	 strSQLProdutos = strSQLProdutos & "  AND (ucase(P.GRUPO) NOT LIKE '%TESTE%' OR ucase(p.titulo) NOT LIKE '%TESTE%')" 
	 strSQLProdutos = strSQLProdutos & " ORDER BY P.GRUPO, P.TITULO "
	 Set objRSProdutos = objConn.Execute(strSQLProdutos)
	 Do While not objRSProdutos.EOF 
'	   strSQL = strSQL & ", TP." & objRSProdutos("COD_PROD") & " AS '" & replace(trim(objRSProdutos("TITULO")),"'","''") & "'"
	   strSQL = strSQL & ", (select sum(tbl_inscricao_produto.VLR_PAGO) from tbl_inscricao inner join tbl_inscricao_produto on tbl_inscricao.COD_INSCRICAO = tbl_inscricao_produto.COD_INSCRICAO where tbl_inscricao.cod_inscricao = t1.cod_inscricao and tbl_inscricao_produto.cod_prod  = " & objRSProdutos("COD_PROD") & " LIMIT 1) AS '" & replace(objRSProdutos("TITULO"),"'","`") &"'"
	   'strSQL = strSQL & ", fn_calcula_total_inscricao_produto(tbl_Inscricao.cod_inscricao, " & objRSProdutos("COD_PROD") & ") AS '" & objRSProdutos("TITULO") & "'"
	   objRSProdutos.MoveNext
	 Loop
	 FechaRecordSet objRSProdutos
	 
	 strSQL = strSQL & ", fn_calcula_total_inscricao(t1.cod_inscricao) AS TOTAL" &_
	 ", TBL_STATUS_PRECO.STATUS AS CATEGORIA" &_
	 ", tbl_formapgto.FORMAPGTO `FORMA PGTO LOJA`" &_
	 ", VIEW_TIPO_PAGTOS.TT_PAGO " &_
	 ", VIEW_TIPO_PAGTOS.`BOLETO`" &_
	 ", VIEW_TIPO_PAGTOS.`CHEQUE`" &_
	 ", VIEW_TIPO_PAGTOS.`DINHEIRO`" &_
	 ", VIEW_TIPO_PAGTOS.`DEPOSITO`" &_
	 ", VIEW_TIPO_PAGTOS.`VISA`" &_
	 ", VIEW_TIPO_PAGTOS.`MASTER`" &_
	 ", VIEW_TIPO_PAGTOS.`AMEX`" &_
	 ", VIEW_TIPO_PAGTOS.`DINERS`" &_
	 ", VIEW_TIPO_PAGTOS.`CARTAO CREDITO`" &_
	 ", VIEW_TIPO_PAGTOS.`CARTAO DEBITO`" &_
	 ", VIEW_TIPO_PAGTOS.`CARTAO OUTROS`" &_
	 ", VIEW_TIPO_PAGTOS.`EMPENHO`" &_
	 ", VIEW_TIPO_PAGTOS.`ESTORNO`" &_
	 ", VIEW_TIPO_PAGTOS.`TRANSF`" &_
	 ", VIEW_TIPO_PAGTOS.`DEVOLUCAO`" &_
	 ", TABELA_RETIRADA.MATERIAL " &_
	 ", tbl_Empresas.DT_NASC " &_
	 ", t1.FAT_RAZAO " &_
	 ", t1.FAT_CNPJ " &_
	 ", t1.FAT_ENDFULL " &_
	 ", t1.FAT_CIDADE " &_
	 ", t1.FAT_ESTADO " &_
	 ", t1.FAT_CEP " &_
	 ", t1.FAT_CONTATO_NOME " &_
	 ", t1.FAT_CONTATO_FONE " &_
	 ", t1.FAT_CONTATO_EMAIL " &_
	 ", t1.UTM_SOURCE as 'Origem'" &_
	 ", t1.UTM_CAMPAIGN as 'Campanha' "
 
	 Dim objRSAcessoSala, strSQLAcessoSala, strFLAG_TEM_ACESSO_SALA
	 strSQLAcessoSala =                  " SELECT DISTINCT P.COD_PROD, P.GRUPO, P.TITULO "
	 strSQLAcessoSala = strSQLAcessoSala & "   FROM TBL_PRODUTOS P INNER JOIN TBL_CONTROLE_PRODUTOS CP ON P.COD_PROD = CP.COD_PROD"
	 strSQLAcessoSala = strSQLAcessoSala & " WHERE CP.COD_EVENTO = " & strCOD_EVENTO
	 strSQLAcessoSala = strSQLAcessoSala & " ORDER BY P.GRUPO, P.TITULO "
	 Set objRSAcessoSala = objConn.Execute(strSQLAcessoSala)
	 Do While not objRSAcessoSala.EOF 
	   strSQL = strSQL & ", min(if(tbl_controle_produtos.COD_PROD = "&objRSAcessoSala("COD_PROD")&",'X',NULL)) as 'ACESSO - "&objRSAcessoSala("TITULO")&"' "
	   objRSAcessoSala.MoveNext
	   strFLAG_TEM_ACESSO_SALA = True
	 Loop
	 FechaRecordSet objRSAcessoSala
	 
	 'Trecho para incluir as respostas das pesquisas exibidas na loja
	 '-------------------------------------------------------------------------
	 If cstr(strPESQUISA_SHOW&"") = "1" Then
		 Dim strSQLQuestionario, objRSPergunta
		 
		 strSQLQuestionario =                      " SELECT Q.COD_QUESTIONARIO, QP.COD_QUESTIONARIO_PERGUNTA, QP.PERGUNTA, QG.GRUPO, QG.DESCRICAO "
		 strSQLQuestionario = strSQLQuestionario & "   FROM TBL_QUESTIONARIO_PERGUNTA QP LEFT JOIN TBL_QUESTIONARIO_GRUPO QG ON QP.COD_QUESTIONARIO_GRUPO = QG.COD_QUESTIONARIO_GRUPO "
		 strSQLQuestionario = strSQLQuestionario & "        INNER JOIN TBL_QUESTIONARIO Q ON Q.COD_QUESTIONARIO = QP.COD_QUESTIONARIO "
		 strSQLQuestionario = strSQLQuestionario & "  WHERE Q.LOJA_SHOW = 1" 
		 strSQLQuestionario = strSQLQuestionario & " ORDER BY Q.COD_QUESTIONARIO, QG.ORDEM, QP.ORDEM"
		 
		 Set objRSPergunta = objConn.Execute(strSQLQuestionario)   
		 
		 Do While not objRSPergunta.EOF 
	 
			strSQL = strSQL & ", ( SELECT if(QR.CODIGO = QRC.CODIGO, QR.RESPOSTA, concat(QR.RESPOSTA,': ',REPLACE( cast(QRC.CODIGO as char(500)),concat(QR.CODIGO,','),''))  ) "
			strSQL = strSQL & "   FROM TBL_QUESTIONARIO_CLIENTE QC INNER JOIN tbl_QUESTIONARIO_RESPOSTA_CLIENTE QRC ON QC.COD_QUESTIONARIO_CLIENTE = QRC.COD_QUESTIONARIO_CLIENTE"
			strSQL = strSQL & "                                    INNER JOIN TBL_QUESTIONARIO_RESPOSTA QR ON QR.COD_QUESTIONARIO_RESPOSTA = QRC.COD_QUESTIONARIO_RESPOSTA "
			strSQL = strSQL & "  WHERE QRC.COD_QUESTIONARIO_PERGUNTA = " & objRSPergunta("COD_QUESTIONARIO_PERGUNTA")
			strSQL = strSQL & "    AND QC.CODBARRA = tbl_inscricao.CODBARRA "
			strSQL = strSQL & " ORDER BY QRC.COD_QUESTIONARIO_CLIENTE LIMIT 1 ) as '"&objRSPergunta("COD_QUESTIONARIO")&" - "&objRSPergunta("PERGUNTA")&"'"
			
			
			objRSPergunta.MoveNext
		 Loop
		 FechaRecordSet objRSPergunta
	 End If
	 '------------------------------------------------------------
'	"     LEFT JOIN VIEW_TABELA_PRODUTOS_"&Session("COD_EVENTO")&" TP ON (tbl_Inscricao.COD_INSCRICAO = TP.COD_INSCRICAO) " &_
	 strSQL = strSQL & " FROM tbl_inscricao t1" &_
	 "	   LEFT JOIN tbl_empresas ON (tbl_empresas.cod_empresa = t1.cod_empresa)" &_     
	 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
	 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
	 "	   LEFT JOIN tbl_status_preco ON (tbl_status_preco.cod_status_preco = t1.cod_status_preco)" &_
	 "	   LEFT JOIN tbl_formapgto ON (tbl_formapgto.COD_FORMAPGTO = t1.COD_FORMAPGTO)" &_
	 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = t1.codbarra)" &_
	 "	   LEFT JOIN tbl_status_cred sc ON (sc.cod_status_cred = tbl_empresas.cod_status_cred)" &_
	 "	   LEFT JOIN tbl_status_cred sc2 ON (sc2.cod_status_cred = tbl_empresas_sub.cod_status_cred)" &_
	 "     LEFT JOIN VIEW_TIPO_PAGTOS ON t1.COD_INSCRICAO = VIEW_TIPO_PAGTOS.COD_INSCRICAO " &_
	 "     LEFT JOIN TABELA_RETIRADA ON t1.COD_INSCRICAO = TABELA_RETIRADA.INSC " & _
	 "     LEFT JOIN TBL_SENHA_PROMO ON tbl_Senha_Promo.COD_INSCRICAO = t1.COD_INSCRICAO AND tbl_Senha_Promo.COD_EVENTO = " & strCOD_EVENTO
	 If strFLAG_TEM_ACESSO_SALA = True Then
	   strSQL = strSQL & "     LEFT JOIN tbl_CONTROLE_PRODUTOS ON t1.CODBARRA = tbl_CONTROLE_PRODUTOS.CODBARRA AND tbl_CONTROLE_PRODUTOS.COD_EVENTO = " & strCOD_EVENTO
	 End If
	 strSQL = strSQL & "	 WHERE t1.COD_EVENTO = " & strCOD_EVENTO &_
	 "	   AND t1.SYS_INATIVO IS NULL" &_
	 " GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,t1.cod_inscricao " &_
	 " ORDER BY Inscricao, Grupo, tbl_empresas.NOMECLI ASC" 
	 '" ORDER BY tbl_empresas.NOMECLI ASC"
	 
'	response.Write(strSQL)
'	response.End()
				 
	 Set objRSDetail = objConn.Execute(strSQL)
	
     strFILENAME = "PGE_" & strCOD_EVENTO & "_" & strFILENAME
	 strFILENAME = LimpaNomeArquivo(strFILENAME)
	 
	 gerarPlanilhaPorRecorset objRSDetail,strFILENAME
	 
	 FechaRecordSet objRSDetail
	 
	 Response.Write("- <a href='"& strFILENAME & ".xlsx' target='_blank'>" & strFILENAME & ".xlsx</a>" & "<BR>")
	 Response.Flush()
	 'Response.Write("<BR>" & cont & " arquivo(s) processado(s).<br>")
Else
%>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="texto_corpo_mdo">
              <form name="formimporta" action="geraexcel_congresso.asp" method="post">
              <input type="hidden" name="var_acao" value="GERAR" />
               <tr> 
                <td width="20%" align="right">Evento:&nbsp;</td>
                <td>
                <%
				If strCOD_EVENTO = "" Then
				%>
                   <select name="cod_evento" class="textbox380">
                      <%
					    strSQL =          "SELECT COD_EVENTO, NOME AS NOME_EVENTO "
						strSQL = strSQL & "  FROM tbl_EVENTO"
						strSQL = strSQL & " WHERE SYS_INATIVO IS NULL"
						If strCOD_EVENTO <> "" Then
						  strSQL = strSQL & " AND COD_EVENTO = " & strCOD_EVENTO
						End If
						strSQL = strSQL & " ORDER BY DT_INICIO DESC"
                        MontaCombo strSQL, "COD_EVENTO", "NOME_EVENTO", Session("cod_evento")
                   	  %>
                   </select>
                <%
				Else
					    strSQL =          "SELECT COD_EVENTO, NOME "
						strSQL = strSQL & "  FROM tbl_EVENTO"
						strSQL = strSQL & " WHERE SYS_INATIVO IS NULL"
						strSQL = strSQL & " AND COD_EVENTO = " & strCOD_EVENTO
						
						Set objRS = objConn.Execute(strSQL)
						If not objRS.EOF Then
						  strNOME_EVENTO = objRS("NOME")
						End If
						FechaRecordSet objRS  
						Response.Write(strNOME_EVENTO) 
				%>  
                <input type="hidden" name="cod_evento" value="<%=strCOD_EVENTO%>" />
                <%
				End If
				%> 
                </td>
               </tr>
               <tr>
                 <td align="right">Incluir Pesquisa:&nbsp;</td>
                 <td>
                 <input type="radio" name="var_pesquisa_show"  value="1"/> Sim &nbsp;
                 <input type="radio" name="var_pesquisa_show"  value="0" checked="checked"/> Não
                 (este recurso pode deixar o sistema muito lento)
                 </td>
               </tr>
               <tr>
                 <td align="right">&nbsp;</td>
                 <td>&nbsp;</td>
               </tr>
               <tr>
                 <td align="right">&nbsp;</td>
                 <td><input type="submit" name="btSend" value="gerar planilha"></td>
               </tr>
               </form>
             </table>
<%

End If

Response.Flush()
%>
</body>
</html>