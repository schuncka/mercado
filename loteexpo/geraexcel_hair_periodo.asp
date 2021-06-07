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

 
 Dim objFile, objFSO, objCDO
 Dim objTextStream, strAux, arrLinha, strARQUIVO

 strARQUIVO     = GetParam("ARQUIVO")
 If strARQUIVO <> "" Then
   Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
   Set objTextStream = objFSO.OpenTextFile(Server.MapPath(".") & "\" & strARQUIVO)

   strSQL = objTextStream.ReadAll
   
   objTextStream.Close

   set objTextStream = Nothing
   set objFSO = Nothing
 
 End If

strSQL = Request("sql")

If strSQL = "" Then

strSQL = "SELECT tbl_controle_in.CODBARRA, tbl_Empresas.COD_EMPRESA, tbl_Empresas.NOMECLI AS RAZAO, tbl_Empresas.NOMEFAN AS FANTASIA, tbl_Empresas.ID_NUM_DOC1 AS 'CPF_CNPJ', IF(tbl_Empresas.TIPO_PESS = 'N','PJ','PF') AS TIPO, tbl_Empresas.END_FULL AS ENDEREÇO, tbl_Empresas.END_BAIRRO AS BAIRRO, tbl_Empresas.END_CIDADE AS CIDADE, tbl_Empresas.END_ESTADO AS UF, tbl_Empresas.END_CEP AS CEP, tbl_Empresas.END_PAIS AS PAIS, tbl_Empresas.FONE1, tbl_Empresas.FONE2, tbl_Empresas.FONE3, tbl_Empresas.FONE4, tbl_Empresas.EMAIL1 AS EMAIL, tbl_empresas.HOMEPAGE as 'Site', tbl_status_cred.STATUS, tbl_empresas.CODATIV1, if(tbl_atividade_pai.ATIVIDADE is null,tbl_atividade.ATIVIDADE,concat(tbl_atividade_pai.ATIVIDADE,' - ',tbl_atividade.ATIVIDADE)) as 'ATIVIDADE', tbl_Empresas.ENTIDADE, tbl_Empresas.DT_NASC, tbl_Empresas_Sub.NOME_COMPLETO AS CONTATO_NOME, tbl_Empresas_Sub.CARGO_NOME AS CONTATO_CARGO, tbl_Empresas_Sub.EMAIL AS CONTATO_EMAIL, tbl_Empresas.SYS_INATIVO AS EXCLUIDO"&_
",min(if(date_format(tbl_controle_in.dt_insert,'%Y') = '2009' and tbl_controle_in.COD_EVENTO = 218,'X',NULL)) as HAIR2009"&_
",min(if(date_format(tbl_controle_in.dt_insert,'%Y') = '2010' and tbl_controle_in.COD_EVENTO = 238,'X',NULL)) as HAIR2010"&_
",min(if(date_format(tbl_controle_in.dt_insert,'%Y') = '2011' and tbl_controle_in.COD_EVENTO = 251,'X',NULL)) as HAIR2011"&_
",min(if(date_format(tbl_controle_in.dt_insert,'%Y') = '2012' and tbl_controle_in.COD_EVENTO = 267,'X',NULL)) as HAIR2012"&_
",min(if(date_format(tbl_controle_in.dt_insert,'%Y') = '2013' and tbl_controle_in.COD_EVENTO = 268,'X',NULL)) as HAIR2013"&_
" FROM tbl_controle_in  LEFT JOIN  tbl_Empresas ON tbl_Empresas.COD_EMPRESA = tbl_controle_in.COD_EMPRESA"&_
"                  LEFT JOIN tbl_Empresas_Sub ON tbl_empresas.cod_empresa = tbl_empresas_sub.cod_empresa AND tbl_empresas_sub.codbarra = tbl_controle_in.codbarra"&_
"                  LEFT JOIN tbl_Atividade ON tbl_Atividade.CODATIV = tbl_Empresas.CODATIV1"&_
"	               LEFT JOIN tbl_atividade AS tbl_atividade_pai ON tbl_atividade.codativ_pai = tbl_atividade_pai.codativ"&_
"                  LEFT JOIN tbl_status_cred ON tbl_status_cred.cod_status_cred = tbl_empresas.cod_status_cred"&_
" WHERE tbl_controle_in.COD_EVENTO in (218,238,251,267,268)"&_
" GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27"&_
" ORDER BY tbl_Empresas.COD_EMPRESA, tbl_controle_in.CODBARRA, tbl_Empresas.NOMECLI"			 

End If

			 'response.Write(strSQL)
			 'response.End()
			 
Set objRSDetail = objConn.Execute(strSQL)

If strARQUIVO <> "" Then
 strFILENAME = Replace(strARQUIVO,".txt","")
Else
 strFILENAME = "HAIRBRASIL_2009_ATE_2013" & strCOD_EVENTO & "_" & strFILENAME & "_" & Replace(Date,"/","") & "_" & Replace(Time,":","")
End If
 
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
