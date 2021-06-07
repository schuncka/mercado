<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"--> 
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
 Dim objConn, objRS
 Dim NumPerPage

 NumPerPage = 18 'Valor padrão

 AbreDBConn objConn, CFG_DB_DADOS 

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
 Dim strCOD_EVENTO, strNOME, strTITULO,  strSQL, strSQLClause, iResult, strResult, strLANG

 strCOD_EVENTO   = Replace(Request("var_cod_evento"),"'","''")
 strNOME 		 = Replace(Request("var_nome"),"'","''")
 strLANG 		 = Replace(Request("var_lang"),"'","''")
 strTITULO  	 = Replace(Request("var_titulo"),"'","''")
 
strSQLClause = ""

strCOD_EVENTO = Session("COD_EVENTO")

If strCOD_EVENTO <> "" Then
  strSQLClause = strSQLClause & " AND t1.cod_evento  = " & strCOD_EVENTO
End If

If strNOME <> "" Then
  strSQLClause = strSQLClause & " AND t2.nome LIKE '" & strNOME & "%'"
End If

If strLANG <> "" Then
  strSQLClause = strSQLClause & " AND t1.lang LIKE '" & strLANG & "'"
End If

strSQL = " SELECT t1.idauto, t1.cod_evento, t2.nome, t1.lang, t1.dt_ini, t1.dt_fim, t1.sys_inativo" & _
         "   FROM tbl_area_restrita_expositor AS t1 " &_
		 "        INNER JOIN tbl_evento AS t2 ON (t1.cod_evento = t2.cod_evento) " & _
         "  WHERE 1 = 1 " & _
		  strSQLClause & _
         "  ORDER BY t2.nome, t1.lang, t1.dt_ini"
set objRS = Server.CreateObject("ADODB.Recordset")

'==========================================================
' Define o tamanho das páginas de visualização
'==========================================================

objRS.CursorLocation = adUseClient
objRS.CacheSize = NumPerPage

objRS.Open strSQL, objConn

If not objRS.BOF and not objRS.EOF Then
'==========================================================
' Define o número de ocorrências e a página atual para
' as ocorrências encontradas nesta consulta
'==========================================================
iResult = objRS.RecordCount
If iResult < 10 Then
  strResult = "0" & Cstr(iResult)
Else
  strResult = Cstr(iResult)
End If


objRS.MoveFirst
objRS.PageSize = NumPerPage

'Get the max number of pages
Dim TotalPages
TotalPages = objRS.PageCount

'Set the absolute page
objRS.AbsolutePage = CurPage

'Counting variable for our recordset
Dim count
%>
<html>

<head>
<title></title>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">

<script language="JavaScript">
<!--
function ToggleCheckAll () {
var i = 0;
while ( (i < <%=NumPerPage%>) && (eval("document.forms[0].msguid_" + i) != null) )
    {
      eval("document.forms[0].msguid_" + i).checked = ! eval("document.forms[0].msguid_" + i).checked;
      i = i + 1;
    }
}

function DeleteSelect () 
{
 codigos = '';
 var i = 0;
 while ( (i < <%=NumPerPage%>) && (eval("document.forms[0].msguid_" + i) != null) )
  {
    if (eval("document.forms[0].msguid_" + i) != null) 
	{
      if (eval("document.forms[0].msguid_" + i).checked) 
       {
	    if (codigos != '') 
	     {
	      codigos = codigos + ',' + eval("document.forms[0].msguid_" + i).value;
	     }
	    else
	     {
	      codigos = eval("document.forms[0].msguid_" + i).value;
	     }
      }
    }
    i = i + 1;
  }
 if (codigos != '') 
 {
  a=confirm("Você quer apagar definitivamente os ítens selecionados?");
  if (a==true)
  {
	document.location = 'deleteexec.asp?var_chavereg=' + codigos;
  }
}

return false;
}


//-->
</script>

</head>

<body topmargin="0" leftmargin="0" bgcolor="#FFFFFF" marginwidth="0" marginheight="0" >
<form name="items" action="" method="get">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td colspan="2" align="center"><BR> 
	  <table width="95%" border="0" cellspacing="0" cellpadding="1">
          <!-- header da tabela -->
          <tr> 
            <td align="left" bgcolor="#7DACC5" class="arial10">&nbsp;</td>
            <!--td align="left" bgcolor="#7DACC5" class="arial10"><img height="1" src="../img/1x1.gif" width="1"></td//-->
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Nome Evento</strong></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Língua</strong></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Data Início</strong></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Data Fim</strong></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Ativo</strong></td>
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
          Response.Write("<tr>")
          Response.Write("  <td width='25' align='right' bgcolor='" & strBgColor & "'> ")
          Response.Write("    <div align='center'><a href=""javascript:AbreJanelaPAGE('update.asp?var_chavereg=" & GetValue(objRS,"idauto") & "&var_cod_evento=" & GetValue(objRS,"cod_evento") & "&var_lang=" & GetValue(objRS,"lang") & "','600', '550')""><img src='../img/icon_write.gif' width='20' height='17' border='0'></a></div>")
		  Response.Write("  </td>")
          'Response.Write("  <td width='25' align='right' bgcolor='" & strBgColor & "'> ")
          'Response.Write("    <div align='center'><a href=""javascript:AbreJanelaPAGE('detail.asp?var_chavereg=" & GetValue(objRS,"idauto") & "&var_cod_evento=" & GetValue(objRS,"cod_evento") & "&var_lang=" & GetValue(objRS,"lang") & "','600', '550')""><img src='../img/icon_zoom.gif' width='20' height='17' border='0'></a></div>")
          'Response.Write("  </td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "'>" & objRS("nome") & "</td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "'>" & objRS("lang") & "</td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "'>" & PrepData(objRS("dt_ini"),True,False) & "</td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "'>" & PrepData(objRS("dt_fim"),True,False) & "</td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "'>")
		  
		  If NOT ISNULL(objRS("SYS_INATIVO")) Then 
			Response.Write("Não") 
		  Else
			Response.Write("Sim") 
		  End If
		 
		  Response.Write("  </td>")
          Response.Write("</tr>")
          Count = Count + 1
          objRS.MoveNext
          i = i + 1
     Loop
%>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2" align="center"> <table width="95%">
          <tr> 
            <td bgcolor="#7DACC5" height="20"></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2" align="center"><img src="../img/separator.gif" width="95%" height="2" vspace="5"></td>
    </tr>
    <tr> 
      <td align="left" class="arial10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=strResult & " ocorrências."%> </td>
      <td align="right" class="arial10">
        <%
          if CurPage > 1 then
            Response.Write("<a href='data.asp?curpage=" & curpage - 1 & "' class='Tahomaazulforte11'> << </a>")
          End If
          Response.Write("Página " & CurPage & " de " & TotalPages)

          if CInt(CurPage) <> CInt(TotalPages) then
            Response.Write("<a href='data.asp?curpage=" & curpage + 1 & "' class='Tahomaazul11'> >> </a>")
          End If
         %>&nbsp;&nbsp;&nbsp;&nbsp;
      </td>
    </tr>
  </table>
</form>
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
