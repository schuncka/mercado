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
<%
'Gerando a Planilha do Excel, através de um recordset
Sub gerarPlanilhaPorRecorset(ORs,nomearquivo)

Dim objRSDetail, rowcont, strNOME_COLUNA

Dim strMetodo, objEx
Dim oWbook
Dim oWSheet
Dim i2
Dim i

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
	 ", COUNT( tbl_empresas.COD_EMPRESA) as TOTAL" &_
	 "	 FROM tbl_empresas " &_
	 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
	 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
	 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
	 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa)" &_
	 "	 WHERE tbl_empresas.SYS_INATIVO IS NULL" &_
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
	objWorksheet.Cells(1,2) = "Cadastros por Atividade"
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
	 ", COUNT(tbl_empresas.COD_EMPRESA) as TOTAL" &_
	 "	 FROM tbl_empresas" &_
	 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
	 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
	 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
	 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa )" &_
	 "	 WHERE tbl_empresas.SYS_INATIVO IS NULL" &_
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
	objWorksheet.Cells(1,2) = "Cadastros por Estado (BRASIL)"
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
	 ", COUNT(tbl_empresas.COD_EMPRESA) as TOTAL" &_
	 "	 FROM tbl_empresas " &_
	 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
	 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
	 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
	 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa)" &_
	 "	 WHERE tbl_empresas.SYS_INATIVO IS NULL" &_
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
	objWorksheet.Cells(1,2) = "Cadastros por Pais"
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

'=========================
'INTRODUZ PLANILHA MAILING
'=========================

Set oWSheet = oWbook.Sheets.Add
oWSheet.Name = "Cadastros"

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

Dim strCOD_EVENTO

strCOD_EVENTO = Request("cod_evento")
If strCOD_EVENTO = "" Then
  strCOD_EVENTO = Session("cod_evento")
End If

If strCOD_EVENTO <> "" Then

 Dim objConn, objRS, objRSDetail, strSQL, strACAO, vFiltro, strSQLClause
 Dim NumPerPage, cont, i
 Dim strNOME, strID_NUM_DOC1, strFILENAME

 NumPerPage = 18 'Valor padrão
 
 cont = 0

 
 AbreDBConn objConn, CFG_DB_DADOS 
 

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
 
' Response.Write(strDT_INICIO_FEIRA&"<BR>")
' Response.Write(strDT_FIM_FEIRA&"<BR>")


 strNUM_DIA_FEIRA = Abs(DateDiff("D",strDT_FIM_FEIRA, strDT_INICIO_FEIRA)) + 1

 Response.Write("<B>"&strNOME_FEIRA & "</B><BR><BR>")
 
 
     
 strNOME = strNOME_FEIRA

 If strNOME <> "" Then
   strFILENAME = strFILENAME & "_" & strNOME
 End If
 
 strFILENAME = Replace(Replace(Replace(Replace(Replace(Replace(Replace(strFILENAME,"/",""),"&","")," ","_"),".",""),"(",""),")",""),",","")

 
	 strSQL = "SELECT DISTINCT if(tbl_empresas_sub.CODBARRA is null, concat(tbl_empresas.COD_EMPRESA,'010'), tbl_empresas_sub.CODBARRA) as 'Codigo Barras'" &_
	         ", tbl_empresas.COD_EMPRESA as 'Codigo'" &_
			 ", tbl_empresas.NOMECLI as 'Razao Social / Nome '" &_
			 ", tbl_empresas.NOMEFAN as 'Nome Fantasia / Nome Credencial'" &_
			 ", tbl_empresas.ID_NUM_DOC1 as 'CNPJ / CPF ' " &_			 
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
			 ", tbl_status_cred.STATUS as 'Credencial'" &_
			 ", tbl_empresas.ENTIDADE as 'Entidade'" &_
			 ", tbl_empresas.ENTIDADE_CNPJ as 'Entidade CNPJ' " &_
			 ", tbl_empresas_sub.nome_completo AS 'Contato'" &_
			 ", tbl_empresas_sub.email AS 'Contato E-mail' " &_
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

			 strSQL = strSQL & ", tbl_empresas.SYS_USERCA as 'Usuario Cadastro'"
			 strSQL = strSQL & ", tbl_empresas.SYS_DATACA as 'Data Cadastro'"
			 strSQL = strSQL & ", tbl_empresas.SYS_USERAT as 'Usuario Alteracao Cadastro'"
			 strSQL = strSQL & ", tbl_empresas.SYS_DATAAT as 'Data Alteracao Cadastro'"

			 strSQL = strSQL & ", if(tbl_Inscricao.SYS_CREDENCIAL is null, max(tbl_CREDENCIAL.SYS_DATACA), tbl_Inscricao.SYS_CREDENCIAL)  AS 'Impressao Credencial'"
             strSQL = strSQL & ", tbl_inscricao.COD_INSCRICAO as 'Inscricao'"
			 strSQL = strSQL & ", tbl_Inscricao.DT_ChegadaFicha  AS 'Data Inscricao'"
			 
			 
			 Dim objRSProdutos, strSQLProdutos
			 strSQLProdutos =                  " SELECT DISTINCT P.COD_PROD, P.GRUPO, P.TITULO "
			 strSQLProdutos = strSQLProdutos & "   FROM TBL_PRODUTOS P INNER JOIN TBL_INSCRICAO_PRODUTO IP ON P.COD_PROD = IP.COD_PROD"
			 strSQLProdutos = strSQLProdutos & "                       INNER JOIN TBL_INSCRICAO I ON IP.COD_INSCRICAO = I.COD_INSCRICAO"
			 strSQLProdutos = strSQLProdutos & " WHERE I.COD_EVENTO = " & strCOD_EVENTO
			 strSQLProdutos = strSQLProdutos & " ORDER BY P.GRUPO, P.TITULO "
			 Set objRSProdutos = objConn.Execute(strSQLProdutos)
			 Do While not objRSProdutos.EOF 
			   strSQL = strSQL & ", TABELA_PRODUTOS." & objRSProdutos("COD_PROD") & " AS '" & objRSProdutos("TITULO") & "'"
			   objRSProdutos.MoveNext
			 Loop
			 FechaRecordSet objRSProdutos
			 
			 strSQL = strSQL & ", TABELA_PRODUTOS.TOTAL_VLR_PAGO AS TOTAL" &_
             ", TBL_STATUS_PRECO.STATUS AS CATEGORIA" &_
             ", VIEW_TIPO_PAGTOS.TT_PAGO " &_
			 ", VIEW_TIPO_PAGTOS.`BOLETO`" &_
			 ", VIEW_TIPO_PAGTOS.`CHEQUE`" &_
			 ", VIEW_TIPO_PAGTOS.`DINHEIRO`" &_
			 ", VIEW_TIPO_PAGTOS.`DEPOSITO`" &_
			 ", VIEW_TIPO_PAGTOS.`VISA`" &_
			 ", VIEW_TIPO_PAGTOS.`MASTER`" &_
			 ", VIEW_TIPO_PAGTOS.`AMEX`" &_
			 ", VIEW_TIPO_PAGTOS.`CARTAO OUTROS`" &_
			 ", VIEW_TIPO_PAGTOS.`EMPENHO`" &_
			 ", VIEW_TIPO_PAGTOS.`ESTORNO`" &_
			 ", VIEW_TIPO_PAGTOS.`TRANSF`" &_
			 ", VIEW_TIPO_PAGTOS.`DEVOLUCAO`" &_
			 ", TABELA_RETIRADA.MATERIAL " &_
			 ", tbl_Empresas.DT_NASC " &_
			 ", tbl_inscricao.FAT_RAZAO " &_
			 ", tbl_inscricao.FAT_CNPJ " &_
			 ", tbl_inscricao.FAT_ENDFULL " &_
			 ", tbl_inscricao.FAT_CIDADE " &_
			 ", tbl_inscricao.FAT_ESTADO " &_
			 ", tbl_inscricao.FAT_CEP " &_
			 ", tbl_inscricao.FAT_CONTATO_NOME " &_
			 ", tbl_inscricao.FAT_CONTATO_FONE "
		 

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
			 
			 strSQL = strSQL & "	 FROM tbl_empresas" &_
			 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa)" &_
			 "	   LEFT JOIN tbl_inscricao ON (tbl_inscricao.COD_EVENTO = " & strCOD_EVENTO & " AND tbl_inscricao.CODBARRA = if(tbl_empresas_sub.CODBARRA is null, concat(tbl_empresas.COD_EMPRESA,'010'), tbl_empresas_sub.CODBARRA))" &_
			 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
			 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
			 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
			 "	   LEFT JOIN tbl_status_preco ON (tbl_status_preco.cod_status_preco = tbl_inscricao.cod_status_preco)" &_
			 "     LEFT JOIN TABELA_PRODUTOS ON tbl_Inscricao.COD_INSCRICAO = TABELA_PRODUTOS.COD_INSCRICAO " &_
			 "     LEFT JOIN VIEW_TIPO_PAGTOS ON tbl_Inscricao.COD_INSCRICAO = VIEW_TIPO_PAGTOS.COD_INSCRICAO " &_
			 "     LEFT JOIN TABELA_RETIRADA ON tbl_Inscricao.COD_INSCRICAO = TABELA_RETIRADA.INSC " &_
			 "     LEFT JOIN tbl_CREDENCIAL ON (tbl_CREDENCIAL.COD_EVENTO = " & strCOD_EVENTO & " AND tbl_CREDENCIAL.CODBARRA = if(tbl_empresas_sub.CODBARRA is null, concat(tbl_empresas.COD_EMPRESA,'010'), tbl_empresas_sub.CODBARRA))" 
			 If strFLAG_TEM_ACESSO_SALA = True Then
			   strSQL = strSQL & "     LEFT JOIN tbl_CONTROLE_PRODUTOS ON tbl_CONTROLE_PRODUTOS.CODBARRA = if(tbl_empresas_sub.CODBARRA is null, concat(tbl_empresas.COD_EMPRESA,'010'), tbl_empresas_sub.CODBARRA) AND tbl_CONTROLE_PRODUTOS.COD_EVENTO = " & strCOD_EVENTO
			 End If
			 strSQL = strSQL & "	 WHERE tbl_empresas.SYS_INATIVO IS NULL" &_
			 " GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,tbl_inscricao.cod_inscricao, tbl_credencial.codbarra " &_
			 " ORDER BY tbl_empresas.NOMECLI ASC"
			 
			 'response.Write(strSQL)
			 'response.End()
			 
	 Set objRSDetail = objConn.Execute(strSQL)

 
 strFILENAME = "PGCADASTRO_" & strCOD_EVENTO & "_" & strFILENAME & "_" & Replace(Date,"/","") & "_" & Replace(Time,":","")
 
 gerarPlanilhaPorRecorset objRSDetail,strFILENAME
 
 FechaRecordSet objRSDetail
 
 Response.Write("- <a href='"& strFILENAME & ".xlsx' target='_blank'>" & strFILENAME & ".xlsx</a>" & "<BR>")
 Response.Flush()

 
 'Response.Write("<BR>" & cont & " arquivo(s) processado(s).<br>")
 
Else

 Response.Write("<BR>" & "Informe o código do evento." & "<br>")

End If

Response.Flush()
%>
