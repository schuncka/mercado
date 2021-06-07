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
   Response.Write("<B>"& "GERANDO : VIEW_RESUMO_VISITACAO" & "</B><BR><BR>")
 
   Response.Write("<B>"& "GERANDO : TBL_RESUMO_VISITACAO" & "</B><BR><BR>")
 End IF



'-------------------------------------------------------
' PEGANDO OS CODIGOS DE EVENTO DA  TBL_EVENTO e TBL_CONTROLE_IN
 strSQL =          " SELECT E.COD_EVENTO FROM tbl_EVENTO E"
 strSQL = strSQL & " UNION "
 strSQL = strSQL & " SELECT C.COD_EVENTO FROM tbl_CONTROLE_IN C"
 strSQL = strSQL & " ORDER BY 1"
 
 Set objRS = objConn.Execute(strSQL)
 
 If not objRS.EOF Then

   '========================================================================================
   'Tratamento para a VIEW do resumo da visitação
   strSQL = ""
   strSQL = strSQL & "DROP VIEW IF EXISTS `view_resumo_visitacao`;"
   objConn.Execute(strSQL)

   strSQL = ""
   strSQL = strSQL & "CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` "
   strSQL = strSQL & " SQL SECURITY DEFINER VIEW `view_resumo_visitacao` AS "
   strSQL = strSQL & " SELECT `c`.`COD_EMPRESA` AS `COD_EMPRESA_VISITACAO`"
   Do While not objRS.EOF 
     strSQL = strSQL & ", COUNT(IF((`c`.`COD_EVENTO` = '"&objRS("COD_EVENTO")&"'),1,null)) AS `"&objRS("COD_EVENTO")&"`"
     objRS.MoveNext
   Loop
   strSQL = strSQL & "  FROM `tbl_controle_in` AS `c`"
   strSQL = strSQL & " GROUP BY `c`.`COD_EMPRESA`;   "
   objConn.Execute(strSQL)
   
   '========================================================================================
   'Tratamento para a TABELA física com indices para o resumo da visitação
   'Remove a tabela se exisitir
   strSQL = ""
   strSQL = strSQL & "   DROP TABLE IF EXISTS `tbl_resumo_visitacao`; "
   'objConn.Execute(strSQL)

   'Cria a tabela
   strSQL = ""
   strSQL = strSQL & " CREATE TABLE IF NOT EXISTS  `tbl_resumo_visitacao` ("
   strSQL = strSQL & "  `IDAUTO` int(11) NOT NULL AUTO_INCREMENT,"
   strSQL = strSQL & "  `COD_EMPRESA` varchar(6) NOT NULL,"
   strSQL = strSQL & "  `CODBARRA` varchar(9) NOT NULL,"
   Do While not objRS.EOF 
     strSQL = strSQL & "  `"&objRS("COD_EVENTO")&"` int(11) NOT NULL DEFAULT 0,"
     objRS.MoveNext
   Loop
   strSQL = strSQL & "  PRIMARY KEY (`IDAUTO`)"
   strSQL = strSQL & ") ENGINE=MyISAM DEFAULT CHARSET=latin1;"
   'objConn.Execute(strSQL)
   
   'Popular a tabela com as visitações por evento
   strSQL = ""
   strSQL = strSQL & " INSERT INTO `tbl_resumo_visitacao` (COD_EMPRESA"
   strSQL = strSQL & ",CODBARRA"
   objRS.MoveFirst  
   Do While not objRS.EOF     
     strSQL = strSQL & ", `"&objRS("COD_EVENTO")&"`"
     objRS.MoveNext
   Loop
   strSQL = strSQL & ")"  
   
   strSQL = strSQL & " SELECT"
   strSQL = strSQL & "  e.cod_empresa"
   strSQL = strSQL & ", if(es.codbarra is null, e.codbarra, es.codbarra)"

   objRS.MoveFirst  
   Do While not objRS.EOF
     strSQL = strSQL & ", sum(if(c.cod_evento = "&objRS("COD_EVENTO")&",1,0)) as `"&objRS("COD_EVENTO")&"`"
     objRS.MoveNext
   Loop

   strSQL = strSQL & " FROM tbl_empresas e left join tbl_empresas_sub es on e.cod_empresa = es.cod_empresa"
   strSQL = strSQL & "                    left join tbl_controle_in c on c.cod_empresa = e.cod_empresa and c.codbarra = (if(es.codbarra is null, e.codbarra, es.codbarra))"
   strSQL = strSQL & " GROUP BY 1, 2"
   strSQL = strSQL & " ORDER BY 1, 2"
   
   If strFLAG_DEBUG = "1" Then
   '  Response.Write(strSQL & "<BR>")
   End If

   'objConn.Execute(strSQL)
   
   
   'Crias os indices
   'objConn.Execute("ALTER TABLE `tbl_resumo_visitacao` ADD INDEX `COD_EMPRESA`(`COD_EMPRESA`), ADD INDEX `CODBARRA`(`CODBARRA`)")
   
 End If
 FechaRecordSet ObjRS
'--------------------------------------------------

 
 
 
   If strFLAG_DEBUG = "1" Then
     Response.Write("<BR>" & "Processo finalizado.<br>")
   End If

 
 FechaDBConn ObjConn
%>
