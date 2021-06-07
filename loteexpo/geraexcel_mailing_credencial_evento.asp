<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/adovbs.inc"--> 
<!--#include file="../_scripts/scripts.js"-->
<!-- #include file="../_include/barcode39.asp"; -->
<%
 
Dim objConn, objRS, objRSDetail, strSQL, strSQLAux, strSQLClause
Dim strGRU_CRED, strAUX,strCOD_SERV,strCOD_EVENTO
Dim strDT_INICIO_FEIRA, strDT_FIM_FEIRA, strNUM_DIA_FEIRA, strNOME_FEIRA, strDIA, strNOME, strFILENAME



AbreDBConn objConn, CFG_DB_DADOS

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
oWSheet.Name = "Credencial Expositor Evento"

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



strCOD_EVENTO = Request("cod_evento")
If strCOD_EVENTO = "" Then
  strCOD_EVENTO = Session("cod_evento")
End If

If strCOD_EVENTO <> "" Then

		
		
		strSQL = "SELECT NOME, DT_INICIO, DT_FIM FROM tbl_EVENTO WHERE COD_EVENTO = '" & strCOD_EVENTO &"'"
		 
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
		 strSQL = ""
		
		%>
		<html>
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link rel="stylesheet" href="../_css/csm.css">
		<title>ProEvento <%=Session("NOME_EVENTO")%>  - Relat&oacute;rio Gerencial</title>
		<style type="text/css" media="screen">
			.showscreen { display:block; }
		</style>
		<style type="text/css" media="print">
			.showscreen { display:none; }
		</style>
		</head>
		<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
		
		<% 'Response.Write("<table width='100%' cellpadding='2' border='1' bordercolor='#000000' style='visibility:hidden;'>
		'	<tr bgcolor='#CCCCCC'>
		'		<td>cod</td>
		'		<td>NomeCredencial</td>
		'		<td>NomeFull</td>
		'		<td>ENTIDADE</td>
		'		<td>ENTIDADE_CARGO</td>
		'		<td>Email</td>
		'		<td>Endereco</td>
		'		<td>Cidade</td>
		'		<td>Estado</td>
		'		<td>CEP</td>
		'		<td>Pais</td>
		'		<td>StatusCred</td>
		'		<td>Atividade</td>
		'		<td>CodBarra</td>
		'		<td>dt_pedido_credencial</td>
		'	</tr>")
		
		
		
		   
		  
		  strSQLClause = ""    
			
			  strSQLAux =             " SELECT apgs.GRU_CRED, apg.DATA_PEDIDO "
			  strSQLAux = strSQLAux & "   FROM tbl_aux_pedido_geral apg inner join tbl_aux_pedido_geral_servico apgs on apg.cod_ped = apgs.cod_ped "
			  strSQLAux = strSQLAux & "  WHERE apg.sys_inativo is null"
			  strSQLAux = strSQLAux & "    AND apg.cod_evento = " & strCOD_EVENTO
			  strSQLAux = strSQLAux & "    AND apgs.GRU_CRED IS NOT NULL "
			   strSQLAux = strSQLAux & "    AND apgs.cod_serv = 294 "
			  If strCOD_SERV <> "" Then
				strSQLAux = strSQLAux & "    AND apgs.cod_serv = " & strCOD_SERV
			  End If
			  
			'  response.write(strSQLaux & "<br><br><br>")
			  'response.end()
		Set objRSDetail = objConn.Execute(strSQLAux)
		If objRSDetail.EOF Then 
			 Response.Write("<BR>" & "Não há dados de credenciais de expositores para o evento " & strNOME_FEIRA & "<br>")
			 response.End()
		End If
		Do While not objRSDetail.EOF 
				strGRU_CRED = "0"
				strAUX =  Trim(objRSDetail("GRU_CRED")&"")
				If strAUX <> "" Then
					strGRU_CRED = strGRU_CRED & "," & strAUX
				End If	
				
				If Right(strGRU_CRED,1) = "," Then
					strGRU_CRED = strGRU_CRED & "0"
				End If
				strGRU_CRED = Replace(strGRU_CRED ,",,",",")
						
					
				strSQL = strSQL & "SELECT tbl_Empresas_Sub.COD_EMPRESA                      AS cod," & _
					   "         tbl_Empresas_Sub.NOME_CREDENCIAL                           AS NomeCredencial," & _
					   "         tbl_Empresas_Sub.NOME_COMPLETO                             AS NomeFull," & _
					   "         tbl_Empresas.NOMEFAN                                       AS ENTIDADE," & _
					   "         tbl_Empresas_Sub.CARGO_NOME                                AS ENTIDADE_CARGO," & _  	  	       
					   "         tbl_Empresas_Sub.email                                     AS Email," & _  	  	       
					   "         tbl_Empresas.END_FULL                                      AS Endereco," & _ 
					   "         tbl_Empresas.END_CIDADE                                    AS Cidade," & _
					   "         tbl_Empresas.END_ESTADO                                    AS Estado," & _
					   "         tbl_Empresas.END_CEP                                       AS CEP," & _
					   "         tbl_Empresas.END_PAIS                                      AS Pais," & _
					   "         tbl_Empresas.COD_STATUS_CRED                               AS StatusCred," & _
					   "         tbl_Empresas.CODATIV1                                      AS Atividade," & _
					   "         tbl_Empresas_Sub.CODBARRA                                  AS CodBarra," & _		       
					   "         '"& objRSDetail("data_pedido") & "'                        AS dt_pedido_credencial" & _	    
					   "  FROM tbl_Empresas " & _ 
					   "  INNER JOIN tbl_Empresas_Sub ON (tbl_Empresas.COD_EMPRESA = tbl_Empresas_Sub.COD_EMPRESA) " & _
					   "  WHERE tbl_Empresas.SYS_INATIVO IS NULL " & _
					   "     AND CAST(tbl_Empresas_Sub.CODBARRA AS UNSIGNED) IN " & " (" & strGRU_CRED & ") " & _
					   
				objRSDetail.MoveNext
				If not objRSDetail.EOF Then 
					strSQL = strSQL & " UNION "
				End If
				
		Loop
		strSQL = strSQL & "  ORDER BY 10, 1, 4 "
		  'Response.Write strSQL & "<BR><BR><BR><BR><BR>"
		  Set objRS = objConn.Execute(strSQL)
		  strFILENAME = "MAILING_CRED_EXPO_" & strCOD_EVENTO & "_" & strFILENAME 
		  gerarPlanilhaPorRecorset objRS,strFILENAME
		  'Do While not objRS.EOF 
		'		Response.Write("<tr bgcolor='#E0ECF0'>")   
		'			Response.Write("<td>" & objRS("cod") & "</td>")
		'			Response.Write("<td>" & objRS("NomeCredencial") & "</td>")
		'			Response.Write("<td>" & objRS("NomeFull") & "</td>")
		'			Response.Write("<td>" & objRS("ENTIDADE") & "</td>")
		'			Response.Write("<td>" & objRS("ENTIDADE_CARGO") & "</td>")
		'			Response.Write("<td>" & objRS("Email") & "</td>")
		'			Response.Write("<td>" & objRS("Endereco") & "</td>")
		'			Response.Write("<td>" & objRS("Cidade") & "</td>")
		'			Response.Write("<td>" & objRS("Estado") & "</td>")
		'			Response.Write("<td>" & objRS("CEP") & "</td>")
		'			Response.Write("<td>" & objRS("Pais") & "</td>")
		'			Response.Write("<td>" & objRS("StatusCred") & "</td>")
		'			Response.Write("<td>" & objRS("Atividade") & "</td>")
		'			Response.Write("<td>" & objRS("CodBarra") & "</td>")
		'			Response.Write("<td>" & objRS("dt_pedido_credencial") & "</td>")
		'		Response.Write("</tr>")
		'  		objRS.MoveNext
		'  Loop
			
		  'objRSDetail.MoveNext
			
		  Response.Flush()
		'Loop
		FechaRecordSet objRS
		FechaRecordSet objRSDetail
		  
		   
		'Response.Write("</table><br />)
		
		 Response.Write("- <a href='"& strFILENAME & ".xlsx' target='_blank'>" & strFILENAME & ".xlsx</a>" & "<BR>")
		 Response.Flush()
Else

 Response.Write("<BR>" & "Informe o código do evento." & "<br>")

End If

%>
</body>
</html>