<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<%
 Server.ScriptTimeout = 2400
 Response.Expires = 0
%>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
Dim strCOD_EVENTO, strFLAG_DEBUG

strCOD_EVENTO = Request("cod_evento")
If strCOD_EVENTO = "" Then
  strCOD_EVENTO = Session("cod_evento")
End If

strFLAG_DEBUG = Request("debug")


 Dim objConn, objRS, objRSDetail, strSQL, strACAO, vFiltro, strSQLClause
 Dim NumPerPage, cont, i
 Dim strNOME, strID_NUM_DOC1, strFILENAME

 
 AbreDBConn objConn, CFG_DB_DADOS 
 

 If strFLAG_DEBUG = "1" Then
   Response.Write("<B>"& "GERANDO VIEW: TABELA_PRODUTOS" & "</B><BR><BR>")
 End IF



'-------------------------------------------------------
' View da TABELA DE PRODUTOS por EVENTO
 strSQL =          "SELECT DISTINCT ip.cod_prod "
 strSQL = strSQL & "  FROM tbl_inscricao_produto ip INNER JOIN tbl_inscricao i ON i.cod_inscricao = ip.cod_inscricao"
 strSQL = strSQL & " WHERE i.cod_Evento = " & Session("COD_EVENTO")
 strSQL = strSQL & " ORDER BY 1"
 
 Set objRS = objConn.Execute(strSQL)
 
 If not objRS.EOF Then

   strSQL = ""
   strSQL = strSQL & "   DROP VIEW IF EXISTS `view_tabela_produtos_"&Session("COD_EVENTO")&"`; "
   objConn.Execute(strSQL)
   strSQL = " drop table IF EXISTS `view_tabela_produtos_"&Session("COD_EVENTO")&"`; "
   objConn.Execute(strSQL)

 
   strSQL = ""
   strSQL = strSQL & " CREATE OR REPLACE VIEW  `view_tabela_produtos_"&Session("COD_EVENTO")&"` AS "
   strSQL = strSQL & " select `tbl_inscricao_produto`.`COD_INSCRICAO` AS `COD_INSCRICAO` "
   strSQL = strSQL & ",sum(`tbl_inscricao_produto`.`VLR_PAGO`) AS `Total_VLR_PAGO` "
 
   Do While not objRS.EOF
     
     strSQL = strSQL & ",sum(if((`tbl_inscricao_produto`.`COD_PROD` = '"&objRS("COD_PROD")&"'),`tbl_inscricao_produto`.`VLR_PAGO`,NULL)) AS `"&objRS("COD_PROD")&"` "
     objRS.MoveNext
     cont = cont + 1
   Loop

   strSQL = strSQL & "   from `tbl_inscricao` join `tbl_inscricao_produto` on `tbl_inscricao`.`COD_INSCRICAO` = `tbl_inscricao_produto`.`COD_INSCRICAO`"
   strSQL = strSQL & " where `tbl_inscricao`.`COD_EVENTO` = " & Session("COD_EVENTO")
   strSQL = strSQL & " group by `tbl_inscricao_produto`.`COD_INSCRICAO`;"   
   
   objConn.Execute(strSQL)
   
 End If
 FechaRecordSet ObjRS
'--------------------------------------------------

 
 
 strSQL = " SELECT e.cod_evento, p.cod_prod "&_
          "   FROM tbl_evento e inner join tbl_produtos p on e.cod_evento = p.cod_evento " &_
		  "   WHERE p.cod_prod in (select distinct cod_prod from tbl_inscricao_produto) " &_
          "  ORDER BY 1, 2"
 
 Set objRS = objConn.Execute(strSQL)
 
 If not objRS.EOF Then

   strSQL = ""
   strSQL = strSQL & "   DROP VIEW IF EXISTS `vw_tabela_produtos`; "
   objConn.Execute(strSQL)

 
   strSQL = ""
   strSQL = strSQL & " CREATE OR REPLACE VIEW  `vw_tabela_produtos` AS "
   strSQL = strSQL & " select `tbl_inscricao_produto`.`COD_INSCRICAO` AS `COD_INSCRICAO` "
   strSQL = strSQL & ",sum(`tbl_inscricao_produto`.`VLR_PAGO`) AS `Total_VLR_PAGO` "
 
   Do While not objRS.EOF
     
     strSQL = strSQL & ",sum(if((`tbl_inscricao_produto`.`COD_PROD` = '"&objRS("COD_PROD")&"'),`tbl_inscricao_produto`.`VLR_PAGO`,NULL)) AS `"&objRS("COD_PROD")&"` "
     objRS.MoveNext
     cont = cont + 1
   Loop

   strSQL = strSQL & "   from (`tbl_inscricao` join `tbl_inscricao_produto` on((`tbl_inscricao`.`COD_INSCRICAO` = `tbl_inscricao_produto`.`COD_INSCRICAO`)))"
   strSQL = strSQL & " group by `tbl_inscricao_produto`.`COD_INSCRICAO`;"   
 End If
 FechaRecordSet ObjRS
 
 If strSQL <> "" Then
 
   objConn.Execute(strSQL)
   
   If strFLAG_DEBUG = "1" Then
     Response.Write(strSQL & "<BR>")
     Response.Write("<BR>" & "Processo finalizado.<br>")
   End If
   
 End If

 
 FechaDBConn ObjConn
%>
