<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|RUN|", BuscaDireitosFromDB("modulo_AreaGeo",Session("METRO_USER_ID_USER")), true %>
<!--#include file="../_scripts/scriptsCS.js"-->
<%
 Dim objConn, objRS
 Dim NumPerPage

 NumPerPage = 18 'Valor padrão

 AbreDBConn objConn, CFG_DB

 'Retrieve what page we're currently on
 Dim CurPage
 If Request("CurPage") = "" then
   CurPage = 1 'We're on the first page
 Else
   CurPage = Request("CurPage")
 End If

 '==========================================================
 ' Declaração para variáveis de consulta SQL
 '==========================================================
 Dim strCODAREA, strAREA,  strSQL, strSQLClause, iResult, strResult, strEVENTO,strACAO, Count

 strCODAREA   = Replace(Request("var_Id_Areageo"),"'","''")
 strAREA      = Replace(Request("var_areageo"),"'","''")
 strEVENTO 	  = Session("Cod_Evento")
 strACAO      = Replace(Request("var_acao"),"'","''")

strSQLClause = ""

If strCODAREA <> "" Then
  strSQLClause = strSQLClause & " AND tbl_areageo_Cep.ID_AreaGeo_Cep LIKE '" & strCODAREA & "%'"
End If

If strAREA <> "" Then
  strSQLClause = strSQLClause & " AND tbl_areageo.Nome_AreaGeo LIKE '" & strAREA & "%'"
End If

strSQL = "SELECT tbl_areageo.ID_AreaGeo,tbl_areageo.Nome_AreaGeo,tbl_areageo_cep.Id_areageo_cep, tbl_areageo_cep.Cep_Ini, tbl_areageo_cep.Cep_Fim, (SELECT tbl_pais.PAIS FROM tbl_pais WHERE ID_PAIS = tbl_areageo_cep.ID_Pais) AS Pais, tbl_evento.NOME "&_
		 " FROM (tbl_areageo LEFT JOIN tbl_areageo_cep ON tbl_areageo.id_AreaGeo = tbl_areageo_cep.Id_AreaGeo) INNER JOIN tbl_evento ON tbl_areageo.Cod_Evento = tbl_evento.COD_EVENTO"&_
		 " WHERE tbl_areageo.Cod_Evento="&strEVENTO&_
         strSQLClause &_
		" ORDER BY tbl_areageo_cep.ID_AreaGeo_Cep"

'==========================================================
' Define o tamanho das páginas de visualização
'==========================================================
set objRS = Server.CreateObject("ADODB.Recordset")

Set objRS = objConn.Execute(strSQL)

If not objRS.EOF Then
 iResult = 0

 If strACAO = ".xls" Or strACAO = ".doc" Then
	Response.AddHeader "Content-Type","application/x-msdownload"
	Response.AddHeader "Content-Disposition","attachment; filename=Relatorio_" & Session.SessionID & "_" & Replace(Time,":","") & strACAO
 End If
%>

<html>
<head>
<title>ProEvento</title>
<%
 If strACAO <> ".xls" And strACAO <> ".doc" Then
%>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<%
 End If
%>
</head>
<body topmargin="0" leftmargin="0" bgcolor="#FFFFFF" marginwidth="0" marginheight="0" >
  
	  <table width="100%" border="0" cellspacing="0" cellpadding="1">
          <!-- header da tabela -->
          <tr> 
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Código</strong></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Descrição</strong></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Cep inical</strong></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Cep final</strong></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>País</strong></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Evento</strong></td>

          </tr>
          <!-- /header da tabela -->
          <%
    Dim i, strBgColor
    i = 0
    Count = 0
    Do While Not objRS.EOF And Count < objRS.PageSize
'     Do While not objRS.EOF
        If (i mod 2) = 0 Then
           strBgColor = "#E0ECF0"
        Else 
           strBgColor = "#FFFFFF"         
        End If 
		%>
         <tr>
		   <td noWrap bgcolor='<%=strBgColor%>' align="left"><%=objRS("Id_areageo_cep")%></td>
		   <td noWrap bgcolor='<%=strBgColor%>'><%=objRS("Nome_Areageo")%></td>
		   <td noWrap bgcolor='<%=strBgColor%>' align="left"><%=objRS("Cep_ini")%></td>
		   <td noWrap bgcolor='<%=strBgColor%>' align="left"><%=objRS("Cep_fim")%></td>
		   <td noWrap bgcolor='<%=strBgColor%>'><%=objRS("Pais")%></td>		 
		   <td noWrap bgcolor='<%=strBgColor%>'><%=objRS("NOME")%></td>
		</tr>
		<%   
          Count = Count + 1
          objRS.MoveNext
          i = i + 1
     Loop
	%>
        </table>
<%
 If strACAO = "printall" Then
%>
<script language="JavaScript">
 window.print();
</script>
<%
 End If
%>
</body>
</html>
<%
Else
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
</head>
  <% Mensagem "Não existem dados para esta consulta.<br>Informe novos critérios para efetuar a pesquisa.", "" %>
  <!--  <div align="middle" class="arial10"> Não existem dados para esta consulta. </div> -->
</body>
</html>
<%
End If
 FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>
