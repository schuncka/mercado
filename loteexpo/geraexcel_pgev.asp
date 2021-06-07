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
	 ", COUNT( DISTINCT tbl_controle_in.Codbarra ) as TOTAL" &_
	 "	 FROM tbl_controle_in" &_
	 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_controle_in.cod_empresa)" &_
	 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
	 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
	 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
	 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_controle_in.codbarra)" &_
	 "	 WHERE tbl_controle_in.COD_EVENTO = " & strCOD_EVENTO &_
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
	objWorksheet.Cells(1,2) = "Visitantes Unicos por Atividade"
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
	 ", COUNT( DISTINCT tbl_controle_in.Codbarra ) as TOTAL" &_
	 "	 FROM tbl_controle_in" &_
	 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_controle_in.cod_empresa)" &_
	 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
	 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
	 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
	 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_controle_in.codbarra)" &_
	 "	 WHERE tbl_controle_in.COD_EVENTO = " & strCOD_EVENTO &_
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
	objWorksheet.Cells(1,2) = "Visitantes Unicos por Estado (BRASIL)"
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
	 ", COUNT( DISTINCT tbl_controle_in.Codbarra ) as TOTAL" &_
	 "	 FROM tbl_controle_in" &_
	 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_controle_in.cod_empresa)" &_
	 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
	 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
	 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
	 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_controle_in.codbarra)" &_
	 "	 WHERE tbl_controle_in.COD_EVENTO = " & strCOD_EVENTO &_
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
	objWorksheet.Cells(1,2) = "Visitantes Unicos por Pais"
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
oWSheet.Name = "Visitantes Unicos"

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

 
	 strSQL = "SELECT DISTINCT tbl_controle_in.Codbarra as 'Cod. Barra'" &_
	         ", tbl_empresas.cod_empresa AS 'Cod. Empresa'" &_
	         ", if(tbl_empresas.tipo_pess LIKE 'N',tbl_empresas_sub.nome_completo,tbl_empresas.NOMECLI) as 'Nome'" &_			 
	         ", if(tbl_empresas.tipo_pess LIKE 'N',tbl_empresas.NOMECLI ,tbl_empresas.ENTIDADE) as 'Razao Social'" &_
			 ", if(tbl_empresas.tipo_pess LIKE 'S',tbl_empresas.NOMEFAN ,tbl_empresas.ENTIDADE_FANTASIA) as 'Nome Fantasia'" &_
			 ", if(tbl_empresas.tipo_pess LIKE 'N',tbl_empresas.ID_NUM_DOC1,tbl_empresas.ENTIDADE_CNPJ ) as 'CNPJ' " &_			
			 ", if(tbl_empresas.tipo_pess LIKE 'S',tbl_empresas.ID_NUM_DOC1,tbl_empresas_sub.id_cpf) as 'CPF ' " &_			 
			 ", tbl_empresas.END_FULL as 'Endereco'" &_
			 ", tbl_empresas.END_BAIRRO as 'Bairro' " &_
			 ", tbl_empresas.END_CIDADE as 'Cidade' " &_
			 ", tbl_empresas.END_ESTADO as 'Estado' " &_
			 ", tbl_empresas.END_PAIS as 'Pais' " &_
			 ", (select case idioma when 'I' THEN 'INGLES' WHEN 'P' THEN 'PORTUGUES' WHEN 'E' THEN 'ESPANHOL' end  from tbl_pais t1 INNER JOIN tbl_paises t2 ON t1.id_pais = t2.id_pais WHERE t2.pais = tbl_empresas.end_pais LIMIT 1) AS 'Idioma'" &_
			 ", tbl_empresas.END_CEP as 'CEP' " &_
 			 ", tbl_empresas.FONE4 as 'Fone1' " &_
			 ", tbl_empresas.FONE1 as 'Fone2' " &_
			 ", tbl_empresas.FONE3 as 'Celular' " &_
			 ", tbl_empresas.FONE2 as 'Fax' " &_
			 ", tbl_empresas.CODATIV1 as 'Cod. Ativ.' " &_
			 ", if(tbl_atividade_pai.ATIVIDADE is not null,concat(tbl_atividade_pai.ATIVIDADE,' - ',tbl_atividade.ATIVIDADE),tbl_atividade.ATIVIDADE) as 'Atividade'" &_
			 ", tbl_empresas.EMAIL1 as 'E-mail' " &_
			 ", tbl_empresas.HOMEPAGE as 'Site' " &_
			 ", tbl_empresas.SYS_DATACA as 'Data Cadastro' " &_
			 ", tbl_empresas.SYS_USERCA as 'Usuário Cadastro' " &_
			 ", tbl_empresas.IMG_FOTO as 'Foto' " &_			 
			 ", sc.STATUS as 'Credencial'" &_
			 ", sp.STATUS as 'Categoria'" &_
			 ", tbl_empresas_sub.email AS 'Contato E-mail' " &_
			 ", tbl_empresas_sub.fone1 AS 'Contato Fone' " &_
			 ", tbl_empresas_sub.IMG_FOTO as 'Contato Foto' " &_					 
			 ", if(sc2.status is null, sc.STATUS, sc2.STATUS) as 'Contato Credencial'" &_
			 ", if(tbl_empresas_sub.cargo_nome is null, tbl_empresas.ENTIDADE_CARGO,tbl_empresas_sub.cargo_nome) as 'Cargo' " &_
			 ", tbl_empresas.ENTIDADE_DEPARTAMENTO as 'Departamento' " &_
			 ", if(tbl_empresas_sub.codbarra is null,tbl_empresas.IMG_FOTO,tbl_empresas_sub.IMG_FOTO) as 'Foto' " &_
			 ", if(tbl_empresas_sub.codbarra is null,tbl_empresas.NRO_EVENTOS_VISITADOS,tbl_empresas_sub.NRO_EVENTOS_VISITADOS) as 'Nro Eventos Visitados' " 
			 
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


			 
			 For i = 0 To strNUM_DIA_FEIRA - 1
			   strDIA = DateAdd("D",i,strDT_INICIO_FEIRA)
			   
			   strSQL = strSQL & ", max(if(date_format(tbl_controle_in.dt_insert,'%d/%m/%Y') = '"&PrepData(strDIA,True,False)&"','X',NULL)) as '"&day(strDIA)&Left(MesExtenso(month(strDIA)),3)&"' "
			   
			 Next
			 strSQL = strSQL & ", tbl_empresas.AUTORIZA_DIVULGACAO_DADOS "
			 strSQL = strSQL & "	 FROM tbl_controle_in" &_
			 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_controle_in.cod_empresa)" &_
			 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
			 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
			 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_controle_in.codbarra)" &_
			 "	   LEFT JOIN tbl_status_cred sc ON (sc.cod_status_cred = tbl_empresas.cod_status_cred)" &_
			 "	   LEFT JOIN tbl_status_cred sc2 ON (sc2.cod_status_cred = tbl_empresas_sub.cod_status_cred)" &_
			 "	   LEFT JOIN tbl_status_preco sp ON (sp.cod_status_preco = tbl_empresas.cod_status_preco)" &_
			 "	 WHERE tbl_controle_in.COD_EVENTO = " & strCOD_EVENTO &_
			 " GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25 " &_
			 " ORDER BY tbl_empresas.NOMECLI ASC"
			 
			 'response.Write(strSQL)
			 'response.End()
			 
	 Set objRSDetail = objConn.Execute(strSQL)

 
 strFILENAME = "PGEV_" & strCOD_EVENTO & "_" & strFILENAME & "_" & Replace(Date,"/","") & "_" & Replace(Time,":","")
 
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

