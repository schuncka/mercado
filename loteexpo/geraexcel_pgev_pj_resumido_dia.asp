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


'=========================
'INTRODUZ PLANILHA MAILING
'=========================

Set oWSheet = oWbook.Sheets.Add
oWSheet.Name = "Resumo Diario"

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
 

 Dim strDT_INICIO_FEIRA, strDT_FIM_FEIRA, strNUM_DIA_FEIRA, strNOME_FEIRA, strDIA, strLABEL_DIA
 
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



 
	strSQL = "select if(e.extra_txt_2 is not null, e.extra_txt_2, 'NOVOS' ) as segmento"
	
	For i = 0 To strNUM_DIA_FEIRA - 1
		strDIA = DateAdd("D",i,strDT_INICIO_FEIRA)
		
		strLABEL_DIA = cstr(i+1) & " DIA - " & day(strDIA)&"/"&Left(MesExtenso(month(strDIA)),3)
		
		strSQL = strSQL & ", COUNT(DISTINCT if(c.dt_insert between '"&PrepDataIve(strDIA,False,False)&" 00:00' and '"&PrepDataIve(strDIA,False,False)&" 23:59' and (select count(distinct cod_empresa) from tbl_controle_in where cod_Evento = "&strCOD_EVENTO&" and cod_empresa = e.cod_Empresa and dt_insert < '"&PrepDataIve(strDIA,False,False)&"') <= 0,c.COD_EMPRESA,null)) as '"&strLABEL_DIA&" - NOVOS'"
		strSQL = strSQL & ", COUNT(DISTINCT if(c.dt_insert between '"&PrepDataIve(strDIA,False,False)&" 00:00' and '"&PrepDataIve(strDIA,False,False)&" 23:59' and (select count(distinct cod_empresa) from tbl_controle_in where cod_Evento = "&strCOD_EVENTO&" and cod_empresa = e.cod_Empresa and dt_insert < '"&PrepDataIve(strDIA,False,False)&"') > 0,c.COD_EMPRESA,null)) as '"&strLABEL_DIA&" - RETORNO'"
		strSQL = strSQL & ", COUNT(DISTINCT if(c.dt_insert between '"&PrepDataIve(strDIA,False,False)&" 00:00' and '"&PrepDataIve(strDIA,False,False)&" 23:59',c.COD_EMPRESA,null)) as '"&strLABEL_DIA&" - TOTAL'"
	
	Next
	
	strSQL = strSQL & ", count(distinct c.cod_empresa) as 'TOTAL UNICAS PERIODO'"
	strSQL = strSQL & " from tbl_controle_in c inner join tbl_empresas e on c.cod_empresa = e.cod_Empresa"
	strSQL = strSQL & "                                left join tbl_status_cred sc on sc.cod_status_cred = e.cod_status_cred"
	strSQL = strSQL & "                                left join tbl_status_preco sp on sp.cod_status_preco = e.cod_status_preco"
	strSQL = strSQL & " where c.cod_Evento = " & strCOD_EVENTO
	strSQL = strSQL & "   and c.dt_insert between '"&PrepDataIve(strDT_INICIO_FEIRA,False,False)&" 00:00' and '"&PrepDataIve(strDT_FIM_FEIRA,False,False)&" 23:59'"
	strSQL = strSQL & " group by 1"
	strSQL = strSQL & " order by 1"
	
	'response.Write(strSQL)
	'response.End()
			 
	 Set objRSDetail = objConn.Execute(strSQL)

 
 strFILENAME = "PGEVPJ_RESUMO_" & strCOD_EVENTO & "_" & strFILENAME & "_" & Replace(Date,"/","") & "_" & Replace(Time,":","")
 
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
