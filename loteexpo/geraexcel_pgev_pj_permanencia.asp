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
	 ", COUNT( DISTINCT tbl_controle_in.cod_empresa ) as TOTAL" &_
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
	 ", COUNT( DISTINCT tbl_controle_in.cod_empresa ) as TOTAL" &_
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
	 ", COUNT( DISTINCT tbl_controle_in.cod_empresa ) as TOTAL" &_
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



 Dim strTEMP_TABLE_NAME, strSQLTable, strDT_LIMITE_SAIDA
' strTEMP_TABLE_NAME = "temp_controle_hora_"&Session.SessionID()&hour(now())&minute(now())&second(now())
 strTEMP_TABLE_NAME = "temp_controle_hora_pj_"&strCOD_EVENTO 
 strDT_LIMITE_SAIDA = "20:00"
 
 strSQLTable = "DROP TABLE IF EXISTS `"&strTEMP_TABLE_NAME&"`;"
 objConn.Execute(strSQLTable)
 
 strSQLTable = "CREATE TABLE `" & strTEMP_TABLE_NAME & "` ("
 strSQLTable = strSQLTable & "  `IDAUTO` int(11) NOT NULL AUTO_INCREMENT,"
 strSQLTable = strSQLTable & "  `CODBARRA` varchar(9) DEFAULT NULL,"
 strSQLTable = strSQLTable & "  `DT_DIA` datetime DEFAULT NULL,"
 strSQLTable = strSQLTable & "  `DT_ENTRADA` time DEFAULT NULL,"
 strSQLTable = strSQLTable & "  `DT_SAIDA` time DEFAULT NULL,"
 strSQLTable = strSQLTable & "  `TEMPO_PERMANENCIA` time DEFAULT NULL,"
 strSQLTable = strSQLTable & "  `TEMPO_PERMANENCIA_TOTAL` time DEFAULT NULL,"
 strSQLTable = strSQLTable & "  `COD_EVENTO` int(11) DEFAULT NULL,"
 strSQLTable = strSQLTable & "  `COD_EMPRESA` varchar(6) DEFAULT NULL,"
 strSQLTable = strSQLTable & "  PRIMARY KEY (`IDAUTO`),"
 strSQLTable = strSQLTable & "  KEY `CODBARRA` (`CODBARRA`),"
 strSQLTable = strSQLTable & "  KEY `COD_EMPRESA` (`COD_EMPRESA`)"
 strSQLTable = strSQLTable & ") ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;"
 
 objConn.Execute(strSQLTable)

  
    strSQL = "INSERT INTO " & strTEMP_TABLE_NAME & " (CODBARRA,COD_EMPRESA,DT_DIA,DT_ENTRADA,DT_SAIDA,TEMPO_PERMANENCIA,COD_EVENTO) "

	For i = 0 To strNUM_DIA_FEIRA - 1
		strDIA = DateAdd("D",i,strDT_INICIO_FEIRA)
	

		strSQL = strSQL &  " SELECT c.Codbarra, c.cod_Empresa" 
		strSQL = strSQL & ", date_format(c.dt_insert,'%Y-%m-%d') as DIA"						   
		strSQL = strSQL & ", min(date_format(c.dt_insert,'%H:%i')) as ENTRADA"
		strSQL = strSQL & ", (if(date_format(max(co.dt_insert),'%H:%i') is null or MAX(co.DT_INSERT) < MIN(c.DT_INSERT),'"&strDT_LIMITE_SAIDA&"',date_format(max(co.dt_insert),'%H:%i')) ) as SAIDA"
		strSQL = strSQL & ", fn_tempo_permanencia(c.cod_Empresa,c.Codbarra,c.Cod_Evento,'"&PrepDataIve(strDIA,False,False)&" 00:00','"&PrepDataIve(strDIA,False,False)&" 23:59','"&strDT_LIMITE_SAIDA&"') as PERMANENCIA"
		strSQL = strSQL & ", c.COD_EVENTO"
		strSQL = strSQL & "  FROM tbl_controle_in c INNER JOIN tbl_empresas e ON e.cod_empresa = c.cod_empresa "
		strSQL = strSQL & "                        LEFT JOIN tbl_controle_out co on c.codbarra = co.codbarra and co.cod_evento = "&strCOD_EVENTO&" and  co.DT_INSERT BETWEEN '"&PrepDataIve(strDIA,False,False)&" 00:00' AND '"&PrepDataIve(strDIA,False,False)&" 23:59'"
		strSQL = strSQL & " WHERE c.COD_EVENTO = " & strCOD_EVENTO
		strSQL = strSQL & "   AND c.DT_INSERT BETWEEN '"&PrepDataIve(strDIA,False,False)&" 00:00' AND '"&PrepDataIve(strDIA,False,False)&" 23:59'"
		strSQL = strSQL & " GROUP BY 1,2,3"	
		
		If i < strNUM_DIA_FEIRA - 1 Then
		  strSQL = strSQL & " UNION "
		End If
	Next
	
	strSQL = strSQL & " ORDER BY 1,2,3"


'Response.Write("->"&strSQL&"<BR><br>")
'response.End()

  objConn.Execute(strSQL)
  
  
  strSQL =          " SELECT cod_empresa, codbarra, sum(time_to_sec(tempo_permanencia)) as total"
  strSQL = strSQL & "   FROM " & strTEMP_TABLE_NAME
  strSQL = strSQL & "  GROUP BY 1,2"
  strSQL = strSQL & "  ORDER BY 1,2"
  Set objRS = objConn.Execute(strSQL)
  Do While not objRS.EOF

    strSQL = "UPDATE " & strTEMP_TABLE_NAME & " SET TEMPO_PERMANENCIA_TOTAL = sec_to_time("&objRS("TOTAL")&") WHERE COD_EVENTO = "&strCOD_EVENTO&" AND COD_EMPRESA='"&objRS("COD_EMPRESA")&"' AND CODBARRA = '"&objRS("CODBARRA")&"'"
	'response.Write(strSQL)
	'response.End()
	objConn.Execute(strSQL)
	
	objRS.MoveNext
  Loop
  FechaRecordSet objRS
  


 
	 strSQL = "SELECT c.Cod_empresa as 'Codigo Empresa'" & vbnewline &_
	         ", tbl_empresas.NOMECLI as 'Razao Social'"  & vbnewline &_
			 ", tbl_empresas.NOMEFAN as 'Nome Fantasia'"  & vbnewline &_
			 ", tbl_empresas.ID_NUM_DOC1 as 'CNPJ / CPF ' "  & vbnewline &_			 
			 ", tbl_empresas.END_FULL as 'Endereco'"  & vbnewline &_
			 ", tbl_empresas.END_BAIRRO as 'Bairro' "  & vbnewline &_
			 ", tbl_empresas.END_CIDADE as 'Cidade' "  & vbnewline &_
			 ", tbl_empresas.END_ESTADO as 'Estado' "  & vbnewline &_
			 ", tbl_empresas.END_PAIS as 'Pais' "  & vbnewline &_
			 ", tbl_empresas.END_CEP as 'CEP' "  & vbnewline &_
 			 ", tbl_empresas.FONE4 as 'Fone1' "  & vbnewline &_
			 ", tbl_empresas.FONE1 as 'Fone2' "  & vbnewline &_
			 ", tbl_empresas.FONE3 as 'Celular' "  & vbnewline &_
			 ", tbl_empresas.FONE2 as 'Fax' "  & vbnewline &_
			 ", tbl_empresas.CODATIV1 as 'Cod. Ativ.' "  & vbnewline &_
			 ", if(tbl_atividade_pai.ATIVIDADE is not null,concat(tbl_atividade_pai.ATIVIDADE,' - ',tbl_atividade.ATIVIDADE),tbl_atividade.ATIVIDADE) as 'Atividade'"  & vbnewline &_
			 ", tbl_empresas.EMAIL1 as 'E-mail' "  & vbnewline &_
			 ", tbl_empresas.HOMEPAGE as 'Site' "  & vbnewline &_
			 ", tbl_empresas.SYS_DATACA as 'Data Cadastro' "  & vbnewline &_
			 ", tbl_empresas.SYS_USERCA as 'Usuario Cadastro' "  & vbnewline &_
			 ", tbl_empresas.SYS_INATIVO as 'Data Inativo' "  & vbnewline &_
			 ", if(tbl_empresas.SYS_INATIVO is not null, tbl_empresas.SYS_USERAT, null) as 'Usuario Inativou' "  & vbnewline &_
			 ", tbl_status_cred.STATUS "  & vbnewline &_
  			 ", tbl_status_preco.STATUS as 'CATEGORIA'" & vbnewline 			 
			 
			 Dim objRSMapeamento, strNOME_CAMPO, strSQLMapeamento
			 strSQLMapeamento = " SELECT NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, CAMPO_COMBOLIST, CAMPO_TIPO, CAMPO_COR_DESTAQUE "
			 strSQLMapeamento = strSQLMapeamento & " FROM tbl_MAPEAMENTO_CAMPO WHERE COD_EVENTO = " & strCOD_EVENTO & " AND (TIPOPESS IS NULL or TIPOPESS = 'J' or TIPOPESS = 'A') "
			 Set objRSMapeamento = objConn.Execute(strSQLMapeamento)
			 If not objRSMapeamento.EOF Then
				Do While not objRSMapeamento.EOF
					strNOME_CAMPO = "tbl_empresas."&objRSMapeamento("NOME_CAMPO_PROEVENTO") & ""
					strSQL = strSQL & ", if('"&objRSMapeamento("CAMPO_TIPO")&"' = 'FILE',concat('http://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/upload/',"&strNOME_CAMPO& ") , "&strNOME_CAMPO&") AS '" & objRSMapeamento("NOME_DESCRITIVO") & "'" & vbnewline 
					objRSMapeamento.MoveNext
			 	Loop
			 End If
			 FechaRecordSet objRSMapeamento

			 strSQL = strSQL & ", count(distinct c.codbarra) as 'QTDE VISITANTES'" & vbnewline
			 strSQL = strSQL & ", (select CAST(SEC_TO_TIME(sum(time_to_sec(tempo_permanencia))) AS CHAR) from " & strTEMP_TABLE_NAME & " where cod_Empresa = c.cod_empresa and cod_evento = "&strCOD_EVENTO&" ) as 'PERMANENCIA TOTAL EMPRESA' " & vbnewline
			 strSQL = strSQL & ", (select CAST((sum(time_to_sec(tempo_permanencia))) AS CHAR) from " & strTEMP_TABLE_NAME & " where cod_Empresa = c.cod_empresa and cod_evento = "&strCOD_EVENTO&" ) as 'PERMANENCIA TOTAL EMPRESA SEGUNDOS' " & vbnewline

			 strSQL = strSQL & ", (" & vbnewline
			 strSQL = strSQL & " select concat(c1.codbarra, ' - ', es1.nome_completo, '(Safira: ', if(es1.extra_txt_1 is null,'',es1.extra_txt_1), ')',  ' (', CAST(SEC_TO_TIME(time_to_sec(c1.tempo_permanencia_total)) AS CHAR), ')')" & vbnewline
			 strSQL = strSQL & "  from " & strTEMP_TABLE_NAME & " c1 inner join tbl_empresas_sub es1 on c1.codbarra = es1.codbarra" & vbnewline
			 strSQL = strSQL & "  where c1.cod_Empresa = c.cod_empresa and c1.cod_evento = " & strCOD_EVENTO & vbnewline
			 strSQL = strSQL & " group by 1" & vbnewline
			 strSQL = strSQL & " order by time_to_sec(c1.tempo_permanencia_total) desc" & vbnewline
			 strSQL = strSQL & " limit 1" & vbnewline
			 strSQL = strSQL & ") as 'CONTATO MAIOR PERMANENCIA'" & vbnewline

			 For i = 0 To strNUM_DIA_FEIRA - 1
			   strDIA = DateAdd("D",i,strDT_INICIO_FEIRA)
			   strSQL = strSQL & ",CAST((select SEC_TO_TIME(sum(time_to_sec(tempo_permanencia))) from " & strTEMP_TABLE_NAME  & vbnewline
			   strSQL = strSQL & "   where cod_Empresa = c.cod_empresa and cod_evento = " & strCOD_EVENTO  & vbnewline
			   strSQL = strSQL & "         and date_format(dt_dia,'%d/%m/%Y') = '" & PrepData(strDIA,True,False) & "'" & vbnewline
			   strSQL = strSQL & " ) AS CHAR)  as '" & day(strDIA)&Left(MesExtenso(month(strDIA)),3) & "' " & vbnewline
			 Next
			 
			 strSQL = strSQL & "	 FROM "&strTEMP_TABLE_NAME&" c"  & vbnewline  &_ 
			 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = c.cod_empresa)" & vbnewline &_
			 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" & vbnewline &_
			 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" & vbnewline &_
			 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" & vbnewline &_
  			 "	   LEFT JOIN tbl_status_preco ON (tbl_status_preco.cod_status_preco = tbl_empresas.cod_status_preco)" & vbnewline &_
			 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = c.codbarra)" & vbnewline &_
			 "	 WHERE c.COD_EVENTO = " & strCOD_EVENTO & vbnewline &_
			 " GROUP BY c.Cod_empresa " & vbnewline &_
			 " ORDER BY tbl_empresas.NOMECLI ASC"
			 
			 'response.Write("<br>[" & strSQL & "]")
			 'response.End()
			 
	 Set objRSDetail = objConn.Execute(strSQL)

 
 strFILENAME = "PGEVPJ_" & strCOD_EVENTO & "_" & strFILENAME & "_" & Replace(Date,"/","") & "_" & Replace(Time,":","")
 
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
