<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/adovbs.inc"-->
<!--#include file="../../_database/athDbConn.asp"--> 
<!--#include file="../../_database/athUtils.asp"-->
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<%
Response.Expires = -1
 
Dim objConn, ObjRS, objRSDetail,objLang, strSQL, strSQLClause, strATESTADO_PDF, strATESTADO_ORIENTACAO
Dim strCOD_EMPRESA, strCOD_EVENTO, strCODBARRA, strORDER, strDT_LEITURA, strDT_INICIO, strDT_FIM
Dim auxstr, auxstr2, auxstr3, strFields
Dim strNOME, strCPF, strEND_PAIS
Dim strCOD_PAIS,strLOCALE

strCOD_EMPRESA = Request("var_cod_empresa")
strCODBARRA    = Request("var_codbarra")
strCOD_EVENTO  = Request("var_cod_evento")
strCOD_PAIS    = Request("lng")

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------


If strCODBARRA = "" Then
  strCODBARRA = strCOD_EMPRESA & "010"
End If

AbreDBConn objConn, CFG_DB_DADOS 

strSQL =          "SELECT IF(ES.CODBARRA IS NULL, E.NOMECLI, ES.NOME_COMPLETO) AS NOME"
strSQL = strSQL & ", IF(ES.CODBARRA IS NULL, E.ID_NUM_DOC1, ES.ID_CPF) AS CPF"
strSQL = strSQL & ", E.END_PAIS "
strSQL = strSQL & "  FROM TBL_EMPRESAS E LEFT JOIN TBL_EMPRESAS_SUB ES ON E.COD_EMPRESA = ES.COD_EMPRESA"
If strCODBARRA <> "" Then
  strSQL = strSQL & " AND ES.CODBARRA = '" & strCODBARRA & "'"
End If
strSQL = strSQL & " WHERE E.COD_EMPRESA = '" & strCOD_EMPRESA & "'"
strSQL = strSQL & "   AND E.SYS_INATIVO IS NULL"
Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
  strNOME = objRS("NOME")&""
  strCPF = objRS("CPF")&""
  strEND_PAIS = objRS("END_PAIS")&""
End If
FechaRecordSet objRS

strSQL =          " SELECT ATESTADO_PDF, ATESTADO_PDF_ORIENTACAO, DT_INICIO, DT_FIM "
strSQL = strSQL & " FROM tbl_EVENTO "
strSQL = strSQL & " WHERE  COD_EVENTO = " & strCOD_EVENTO
Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
  strATESTADO_PDF = objRS("ATESTADO_PDF")&""
  strATESTADO_ORIENTACAO = objRS("ATESTADO_PDF_ORIENTACAO")&""
  strDT_INICIO = objRS("DT_INICIO")
  strDT_FIM = objRS("DT_FIM")
End If
FechaRecordSet ObjRS


strSQL =          "SELECT DISTINCT DATE_FORMAT(C.DT_INSERT,'%d/%m/%Y') as DT_LEITURA "
strSQL = strSQL & "  FROM TBL_CONTROLE_IN C "
strSQL = strSQL & " WHERE C.COD_EVENTO = " & strCOD_EVENTO
strSQL = strSQL & "   AND C.CODBARRA = '" & strCODBARRA & "'"
If IsDate(strDT_INICIO) and IsDate(strDT_FIM) Then
  strSQL = strSQL & " AND C.DT_INSERT BETWEEN '"&PrepDataIve(strDT_INICIO,False,False)&" 00:00:00' AND '"&PrepDataIve(strDT_FIM,False,False)&" 23:59:59' "
End If

Set objRS = objConn.Execute(strSQL)
Do While not objRS.EOF 
  strDT_LEITURA = strDT_LEITURA & objRS("DT_LEITURA")&""
  
  objRS.MoveNext
  If not objRS.EOF Then
    strDT_LEITURA = strDT_LEITURA & ", "
  End If
Loop
FechaRecordSet objRS


	 
	 
If strATESTADO_PDF <> "" Then

  strATESTADO_PDF = Replace(strATESTADO_PDF,"<PRO_NOME>",strNOME)
  strATESTADO_PDF = Replace(strATESTADO_PDF,"<PRO_NOMECLI>",strNOME)
  strATESTADO_PDF = Replace(strATESTADO_PDF,"<PRO_ID_NUM_DOC1>",strCPF)
  strATESTADO_PDF = Replace(strATESTADO_PDF,"<PRO_DT_LEITURA>",strDT_LEITURA)
  strATESTADO_PDF = Replace(strATESTADO_PDF,"<PRO_DATAATUAL>",DataExtenso(Date()))
  

  strSQL = "INSERT INTO tbl_EMPRESAS_HIST (COD_EMPRESA, SYS_USERCA, SYS_DATACA, HISTORICO) VALUES ("&strCOD_EMPRESA&",'PAX',NOW(),'ATESTADO PDF " & strCODBARRA & "')"
  objConn.Execute(strSQL)
	 
  FechaDBConn ObjConn	


  Select Case UCase(strATESTADO_ORIENTACAO)
  Case "PAISAGEM"
    strATESTADO_ORIENTACAO = "true"
  Case "RETRATO"
    strATESTADO_ORIENTACAO = "false"
  Case Else
    strATESTADO_ORIENTACAO = "true"
  End Select


  Dim Pdf, Doc, Filename, strURL, log

'Response.Write(strATESTADO_PDF)
'response.End()


	Set Pdf = Server.CreateObject("Persits.Pdf")
	Set Doc = Pdf.CreateDocument
	'Doc.ImportFromUrl "<html>" & strATESTADO_PDF & "</html>", "landscape=true"
	Log = Doc.ImportFromUrl ("<html>" & strATESTADO_PDF & "</html>","Landscape="&strATESTADO_ORIENTACAO&",DrawBackground=true,LeftMargin=10,TopMargin=20,RightMargin=10,BottomMargin=20,PageWidth=598,PageHeight=842")
	Filename = Doc.Save( Server.MapPath("..")&"\export\"& "atestado_" & strCOD_EVENTO & "_" & strCODBARRA & ".pdf", True )
	Set Doc = Nothing
	Set Pdf = Nothing

'    response.Write("<BR>"&filename)
'    response.Write("<BR>"&Log)
'    response.End()
  Response.Redirect("../export/"&Filename)
	
Else

  FechaDBConn ObjConn	

%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>ProEvento - Atestado</title>
<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
}
-->
</style>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
  <center>
    <span class="style1"><br><br><%=objLang.SearchIndex("msg_erro_atestado",0)%></span>
  </center>
</body>
<%
End If

set objLang = Nothing
 
%>
