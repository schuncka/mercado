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
</head>
<body>
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
	 ", COUNT( DISTINCT tbl_visitacao_expositor.Codbarra ) as TOTAL" &_
	 "	 FROM tbl_visitacao_expositor" &_
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
	 strSQL = strSQL & " GROUP BY 1" &_	 
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
	 ", COUNT( DISTINCT tbl_visitacao_expositor.Codbarra ) as TOTAL" &_
	 "	 FROM tbl_visitacao_expositor" &_
	 "		   INNER JOIN tbl_empresas ON (tbl_empresas.cod_empresa = tbl_visitacao_expositor.cod_empresa)" &_
	 "	   LEFT JOIN tbl_atividade ON (tbl_atividade.codativ = tbl_empresas.codativ1)" &_
	 "	   LEFT JOIN tbl_atividade AS tbl_atividade_pai ON (tbl_atividade.codativ_pai = tbl_atividade_pai.codativ)" &_
	 "	   LEFT JOIN tbl_status_cred ON (tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred)" &_
	 "	   LEFT JOIN tbl_empresas_sub ON (tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_visitacao_expositor.codbarra)" &_
	 "	 WHERE tbl_visitacao_expositor.COD_EMPRESA_EXPOSITOR='"&objRS("COD_EMPRESA_EXPOSITOR")&"' "&_
	 "     AND tbl_visitacao_expositor.COD_EVENTO = " & strCOD_EVENTO &_
	 "     AND tbl_empresas.END_PAIS = 'BRASIL' "
	 If objRS("GRUPO")&"" <> "" Then
	   strSQL = strSQL & "	   AND tbl_visitacao_expositor.GRUPO='"&objRS("GRUPO")&"'"
	 End If
	 strSQL = strSQL & " GROUP BY 1" &_	 
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
	 ", COUNT( DISTINCT tbl_visitacao_expositor.Codbarra ) as TOTAL" &_
	 "	 FROM tbl_visitacao_expositor" &_
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
	 strSQL = strSQL & " GROUP BY 1" &_	 
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


'===============================================================================
Dim strCOD_EVENTO, strCOD_EMPRESA_EXPOSITOR, strACAO

strCOD_EVENTO = Request("cod_evento")
strACAO = Request("var_acao")
strCOD_EMPRESA_EXPOSITOR = Request("cod_empresa_expositor")

If strCOD_EVENTO = "" Then
  strCOD_EVENTO = Session("cod_evento")
End If

If strCOD_EVENTO <> "" and  ucase(strACAO) = "GERAR" Then

 Dim objConn, objRS, objRSDetail, strSQL, vFiltro, strSQLClause
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
 
 strSQL = " SELECT ve.cod_empresa_expositor, ve.grupo, e.nomecli, e.nomefan, e.id_num_doc1, count(*) "&_
		  "   FROM tbl_visitacao_expositor ve left join tbl_empresas e on ve.cod_empresa_expositor = e.cod_empresa " &_
		  "  WHERE ve.cod_evento = " & strCOD_EVENTO &_
		  strSQLClause & _
		  "  GROUP BY 1, 2 " &_
		  "  ORDER BY 1"
 
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

 
	 strSQL = "SELECT DISTINCT tbl_visitacao_expositor.Codbarra as 'Codigo'" &_
			 ", if(tbl_empresas.tipo_pess = 'S', tbl_empresas.NOMECLI, tbl_empresas_sub.NOME_COMPLETO) as 'Nome Visitante'" &_
			 ", if(tbl_empresas.tipo_pess = 'S', tbl_empresas.ENTIDADE, tbl_empresas.NOMECLI) as 'Empresa (Razao Social)'" &_
			 ", if(tbl_empresas.tipo_pess = 'S', tbl_empresas.ENTIDADE_FANTASIA, tbl_empresas.NOMEFAN) as 'Empresa (Nome Fantasia)'" &_
			 ", if(tbl_empresas.tipo_pess = 'S', tbl_empresas.ID_NUM_DOC1, tbl_empresas_sub.ID_CPF) as 'CPF' " &_			 
			 ", if(tbl_empresas.tipo_pess = 'S', tbl_empresas.ENTIDADE_CNPJ, tbl_empresas.ID_NUM_DOC1) as 'CNPJ' " &_			 
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
			 ", tbl_empresas_sub.email AS 'E-mail 2' " &_
			 ", tbl_empresas.HOMEPAGE as 'Site' " &_
			 ", tbl_status_cred.STATUS" &_
			 ", if(tbl_empresas.tipo_pess = 'S', tbl_empresas.ENTIDADE_CARGO,tbl_empresas_sub.cargo_nome) as 'Cargo' " &_
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


			 
			 For i = 0 To strNUM_DIA_FEIRA - 1
			   strDIA = DateAdd("D",i,strDT_INICIO_FEIRA)
			   
			   strSQL = strSQL & ", max(if(date_format(tbl_visitacao_expositor.dt_insert,'%d/%m/%Y') = '"&PrepData(strDIA,True,False)&"','X',NULL)) as '"&day(strDIA)&Left(MesExtenso(month(strDIA)),3)&"' "
			   
			 Next

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
	 strSQL = strSQL & " GROUP BY  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24 " &_
			 " ORDER BY tbl_empresas.NOMECLI ASC"
			 
			 'response.Write(strSQL)
			 'response.End()
			 
	 Set objRSDetail = objConn.Execute(strSQL)

 
	 strFILENAME = LimpaNomeArquivo(strCOD_EVENTO & "_" & strFILENAME)
	 
	 gerarPlanilhaPorRecorset objRSDetail,strFILENAME
	 
	 FechaRecordSet objRSDetail
	 
	 Response.Write("- <a href='" & strFILENAME & ".xlsx'>" & strFILENAME & ".xlsx" & "</a><BR>")
	 Response.Flush()

   objRS.MoveNext
   cont = cont + 1
 Loop
 FechaRecordSet ObjRS
 
 Response.Write("<BR>" & cont & " arquivo(s) processado(s).<br>")
	 
  FechaDBConn ObjConn
 
Else
%>
<div>
<p><b>INFORMAÇÃO:</b><br><br>
  Geração dos arquivos EXCEL para entrega a clientes locatários de COLETORES. &lt;br&gt;<br />
  Observar que, para geração destes arquivos a, tabela <i><b>tbl_ visitacao_expositor</b></i>; deve ter sido preenchida no processo de importação dos dados de coletores - 1) &quot;Importação/Upload dos txts de coletores (../loteexpo/upload/importageral.asp)&quot;.<br>
  <br />
  Os arquivos gerados (planilhas excel) ficam na pasta /loteexpo.</p>
<hr>
</div>  
<div>
              <table width="450" border="0" cellpadding="0" cellspacing="0" class="texto_corpo_mdo">
              <form name="formimporta" action="geraexcel_grafico.asp" method="post">
              <input type="hidden" name="var_acao" value="GERAR" />
               <tr> 
                <td width="151" align="right">Evento:&nbsp;</td>
                <td width="299">
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
                   </select></td>
               </tr>
               <tr>
                 <td align="right">Expositor:&nbsp;</td>
                 <td>
                 <select name="cod_empresa_expositor" class="textbox380">
                    <option value="" selected="selected">Todos</option>
                      <%
					  If strCOD_EVENTO <> "" Then
					    strSQL =          "SELECT DISTINCT V.COD_EMPRESA_EXPOSITOR, E.NOMECLI, concat(v.cod_empresa_expositor,' ',if(e.nomecli is null,'',e.nomecli)) as EXPO "
						strSQL = strSQL & " FROM TBL_VISITACAO_EXPOSITOR V LEFT JOIN TBL_EMPRESAS E ON V.COD_EMPRESA_EXPOSITOR = E.COD_EMPRESA "
						strSQL = strSQL & " WHERE V.COD_EVENTO = " & strCOD_EVENTO
						strSQL = strSQL & " ORDER BY V.COD_EMPRESA_EXPOSITOR"
                        MontaCombo strSQL, "COD_EMPRESA_EXPOSITOR", "EXPO", ""
					  End If
                   	  %>
                   </select>
                 </td>
               </tr>
               <tr>
                 <td align="right">&nbsp;</td>
                 <td><input type="submit" name="btSend" value="gerar planilha"></td>
               </tr>
               </form>
             </table>
  </div>

<%

End If

Response.Flush()
%>
</body>
</html>