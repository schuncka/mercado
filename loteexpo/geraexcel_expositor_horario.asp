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
For i = strNUM_DIA_FEIRA - 1 To 0 step -1

  strDIA = DateAdd("D",i,strDT_INICIO_FEIRA)
			   

	strSQL = "SELECT " &_
		 "  date_format(dt_insert,'%H') as 'HORA' "&_
		 ", COUNT( DISTINCT tbl_visitacao_expositor.Codbarra ) as TOTAL" &_
		 "	 FROM tbl_visitacao_expositor" &_
		 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_visitacao_expositor.cod_empresa)" &_
		 "	 WHERE tbl_visitacao_expositor.COD_EMPRESA_EXPOSITOR='"&objRS("COD_EMPRESA_EXPOSITOR")&"' "&_
		 "     AND tbl_visitacao_expositor.COD_EVENTO = " & strCOD_EVENTO &_
		 "     AND tbl_visitacao_expositor.dt_insert between '"&PrepDataIve(strDIA,false,false)&" 00:00' and '"&PrepDataIve(strDIA,false,false)&" 23:59' "
		 If objRS("GRUPO")&"" <> "" Then
		   strSQL = strSQL & "	   AND tbl_visitacao_expositor.GRUPO='"&objRS("GRUPO")&"'"
		 End If
		 strSQL = strSQL & " GROUP BY 1" 
		 strSQL = strSQL & " ORDER BY 1"
		 
		 'response.Write(strSQL)
		 'response.End()
	
	
	Set objRSDetail = objConn.Execute(strSQL)
	
	If not objRSDetail.EOF Then
	
		
		Set objWorksheet = oWbook.Sheets.Add
		objWorksheet.Name = Day(strDIA)&left(MesExtenso(month(strDIA)),3)
		
		rowcont = 2
		objWorksheet.Cells(1,1) = Day(strDIA)&left(MesExtenso(month(strDIA)),3)
		Do While not objRSDetail.EOF 
		  strNOME_COLUNA = objRSDetail("HORA")&"h"
		  If strNOME_COLUNA = "" Then
			strNOME_COLUNA = "N/A"
		  End If
		  objWorksheet.Cells(rowcont,1) = strNOME_COLUNA
		  objRSDetail.MoveNext
		  rowcont = rowcont + 1
		Loop
		
		objRSDetail.MoveFirst
		
		rowcont = 2
		objWorksheet.Cells(1,2) = "Leituras por Hora"
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
		objChart.Name = "Grafico " & Day(strDIA)&left(MesExtenso(month(strDIA)),3)
	
		
		objChart.HasLegend = False
		'objChart.ChartTitle.Text = "Operating System Use"
		
	End If
	FechaRecordSet objRSDetail
'------------------------------------------------

Next



'------------------------------------------------
	strSQL = "SELECT " &_
		 "  date_format(dt_insert,'%d/%m/%Y') as 'DIA' "&_
		 ", COUNT( DISTINCT tbl_visitacao_expositor.Codbarra ) as TOTAL" &_
		 "	 FROM tbl_visitacao_expositor" &_
		 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_visitacao_expositor.cod_empresa)" &_
		 "	 WHERE tbl_visitacao_expositor.COD_EMPRESA_EXPOSITOR='"&objRS("COD_EMPRESA_EXPOSITOR")&"' "&_
		 "     AND tbl_visitacao_expositor.COD_EVENTO = " & strCOD_EVENTO
		 If objRS("GRUPO")&"" <> "" Then
		   strSQL = strSQL & "	   AND tbl_visitacao_expositor.GRUPO='"&objRS("GRUPO")&"'"
		 End If
		 strSQL = strSQL & " GROUP BY 1"
		 strSQL = strSQL & " ORDER BY 1"
		 
		 'response.Write(strSQL)
		 'response.End()
	
	
	Set objRSDetail = objConn.Execute(strSQL)
	
	If not objRSDetail.EOF Then
	
		
		Set objWorksheet = oWbook.Sheets.Add
		objWorksheet.Name = "Periodo"
		
		rowcont = 2
		objWorksheet.Cells(1,1) = "Dia"
		Do While not objRSDetail.EOF 
		  strNOME_COLUNA = objRSDetail("DIA")&""
		  If strNOME_COLUNA = "" Then
			strNOME_COLUNA = "N/A"
		  End If
		  objWorksheet.Cells(rowcont,1) = strNOME_COLUNA
		  objRSDetail.MoveNext
		  rowcont = rowcont + 1
		Loop
		
		objRSDetail.MoveFirst
		
		rowcont = 2
		objWorksheet.Cells(1,2) = "Leituras por Dia"
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
		objChart.Name = "Grafico Periodo"
	
		
		objChart.HasLegend = False
		'objChart.ChartTitle.Text = "Operating System Use"
		
	End If
	FechaRecordSet objRSDetail
'------------------------------------------------

'=========================
'INTRODUZ PLANILHA MAILING
'=========================

Set oWSheet = oWbook.Sheets.Add
oWSheet.Name = "Leituras Geral"

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

Dim strCOD_EVENTO, strCOD_EMPRESA_EXPOSITOR, strGRUPO

strCOD_EVENTO = Request("cod_evento")
If strCOD_EVENTO = "" Then
  strCOD_EVENTO = Session("cod_evento")
End If

strCOD_EMPRESA_EXPOSITOR = Request("cod_empresa_expositor")
strGRUPO = Request("grupo")

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
 
 
 If strCOD_EMPRESA_EXPOSITOR <> "" Then
   strSQLClause = strSQLClause & " AND ve.cod_empresa_expositor = '" & strCOD_EMPRESA_EXPOSITOR & "'"
 End If
 
 If strGRUPO <> "" Then
   strSQLClause = strSQLClause & " AND ve.grupo = '" & strGRUPO & "'"
 End If
 
 strSQL = " SELECT ve.cod_empresa_expositor, ve.grupo, e.nomecli, e.nomefan, e.id_num_doc1, count(*) "&_
          "   FROM tbl_visitacao_expositor ve left join tbl_empresas e on ve.cod_empresa_expositor = e.cod_empresa " &_
          "  WHERE ve.cod_evento = " & strCOD_EVENTO &_
		  strSQLClause & _
          "  GROUP BY 1, 2 " &_
          "  ORDER BY 1"
		  
 'Response.Write(strSQL)
 'Response.End()
 
 Set objRS = objConn.Execute(strSQL)
 
 Do While not objRS.EOF
     
	 strNOME = objRS("NOMEFAN")&""
	 If strNOME = "" Then
	   strNOME = objRS("NOMECLI")&""
	 End If
     strID_NUM_DOC1 = objRS("ID_NUM_DOC1")&""
	 
	 strFILENAME = objRS("COD_EMPRESA_EXPOSITOR")

	 If strID_NUM_DOC1 <> "" Then
	   strFILENAME = strFILENAME & "_" & strID_NUM_DOC1
	 End If

	 If strNOME <> "" Then
	   strFILENAME = strFILENAME & "_" & strNOME
	 End If
	 
	 If objRS("GRUPO")&"" <> "" Then
	   strFILENAME = strFILENAME & "_" & objRS("GRUPO")
	 End If
	 
	 strFILENAME = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(strFILENAME,"/",""),"&","")," ","_"),".",""),"(",""),")",""),",",""),"|","_")

 
	 strSQL = "SELECT tbl_visitacao_expositor.Codbarra as 'Codigo'" &_
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
			 ", tbl_status_cred.STATUS" &_
			 ", tbl_empresas.ENTIDADE as 'Entidade'" &_
			 ", tbl_empresas.ENTIDADE_CNPJ as 'Entidade CNPJ' " &_
			 ", tbl_empresas_sub.nome_completo AS 'Contato'" &_
			 ", tbl_empresas_sub.email AS 'Contato E-mail' " &_
			 ", if(tbl_empresas_sub.cargo_nome is null, tbl_empresas.ENTIDADE_CARGO,tbl_empresas_sub.cargo_nome) as 'Cargo' " &_
			 ", tbl_empresas.ENTIDADE_DEPARTAMENTO as 'Departamento' "
			 
    Dim objRSMapeamento, strNOME_CAMPO, strSQLMapeamento
	
	strSQLMapeamento =          " SELECT NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, CAMPO_COMBOLIST, CAMPO_TIPO, CAMPO_COR_DESTAQUE "
	strSQLMapeamento = strSQLMapeamento & "   FROM tbl_MAPEAMENTO_CAMPO WHERE LOJA_SHOW = 1 AND COD_EVENTO = " & strCOD_EVENTO
	Set objRSMapeamento = objConn.Execute(strSQLMapeamento)
	If not objRSMapeamento.EOF Then
	  Do While not objRSMapeamento.EOF
	    strNOME_CAMPO = "tbl_empresas."&objRSMapeamento("NOME_CAMPO_PROEVENTO")&""
		strSQL = strSQL & ", if('"&objRSMapeamento("CAMPO_TIPO")&"' = 'FILE',concat('http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/upload/',"&strNOME_CAMPO& ") , "&strNOME_CAMPO&") AS '" & objRSMapeamento("NOME_DESCRITIVO") & "'"
		
	    objRSMapeamento.MoveNext
	  Loop
	End If
	
	FechaRecordSet objRSMapeamento


			 
		     strSQL = strSQL & ", date_format(tbl_visitacao_expositor.dt_insert,'%d/%m/%Y %H:%i') as 'Data Leitura'"

			 strSQL = strSQL & "	 FROM tbl_visitacao_expositor" &_
			 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_visitacao_expositor.cod_empresa)" &_
			 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
			 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
			 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
			 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_visitacao_expositor.codbarra)" &_
			 "	 WHERE tbl_visitacao_expositor.COD_EMPRESA_EXPOSITOR='"&objRS("COD_EMPRESA_EXPOSITOR")&"' "&_
			 "     AND tbl_visitacao_expositor.COD_EVENTO = " & strCOD_EVENTO 
	 If objRS("GRUPO")&"" <> "" Then
	   strSQL = strSQL & "	   AND tbl_visitacao_expositor.GRUPO='"&objRS("GRUPO")&"'"
	 End If
	 strSQL = strSQL & " ORDER BY tbl_visitacao_expositor.dt_insert ASC"
			 
			 'response.Write(strSQL)
			 'response.End()
			 
	 Set objRSDetail = objConn.Execute(strSQL)

 
     strFILENAME = strCOD_EVENTO & "_" & strFILENAME & "_H"
	 
	 gerarPlanilhaPorRecorset objRSDetail,strFILENAME
	 
	 FechaRecordSet objRSDetail
	 
	 Response.Write("- " & strFILENAME & ".xlsx" & "<BR>")
	 Response.Flush()

   objRS.MoveNext
   cont = cont + 1
 Loop
 FechaRecordSet ObjRS
 FechaDBConn ObjConn
 
 Response.Write("<BR>" & cont & " arquivo(s) processado(s).<br>")
 
Else

 Response.Write("<BR>" & "Informe o código do evento." & "<br>")

End If

Response.Flush()
%>
