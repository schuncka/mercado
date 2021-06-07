<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"-->
<!--#include file="../_database/config.inc"--> 
<!--#include file="../_scripts/scripts.js"-->
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/athdbConn.asp"-->
<!--#include file="../_database/secure.asp"--> 
<%
 VerficaAcesso("ADMIN")
  
 Dim objConn, objRS
 Dim NumPerPage, strALL_PARAMS

 NumPerPage = 18 'Valor padrão

 AbreDBConn objConn, CFG_DB_DADOS 

 'Retrieve what page we're currently on
 Dim CurPage
 If Request.QueryString("CurPage") = "" then
    CurPage = 1 'We're on the first page
 Else
   CurPage = Request.QueryString("CurPage")
 End If

 ' Declaração para variáveis de consulta SQL
 '==========================================================
 Dim strCODIGO, strNOME, strSQL, strSQLClause, iResult, strResult

 strCODIGO      = Trim(Replace(Request("var_codigo"),"'","''"))
 strNOME        = Replace(Request("var_nome"),"'","''")

 strALL_PARAMS = Request.QueryString
 if strALL_PARAMS = "" then
   strALL_PARAMS = Request.Form
 end if	

 strSQLClause = ""

  If strCODIGO <> "" Then
    strSQLClause = " AND L.COD_LOTE = " & strCODIGO
  End If

  If strNOME <> "" Then
    strSQLClause = strSQLClause & " AND L.NOME LIKE '" & strNOME & "%'"
  End If

'==========================================================
' Monta SQL para consulta na tabela EXEMPLAR
'==========================================================
  strSQL = "          SELECT L.COD_LOTE, L.NOME, L.TOTAL_REGISTROS, L.DT_CRIACAO "
  strSQL = strSQL & " FROM tbl_LOTE L"
  strSQL = strSQL & " WHERE L.COD_LOTE = L.COD_LOTE "
  strSQL = strSQL & strSQLClause
  strSQL = strSQL & " ORDER BY L.NOME"

'==========================================================
' Define o tamanho das páginas de visualização
'==========================================================
  set objRS = Server.CreateObject("ADODB.Recordset")

  objRS.CursorLocation = adUseClient
  objRS.CacheSize = NumPerPage
  objRS.Open strSQL, objConn

  If not objRS.EOF Then
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

function DeleteSelect (pr_params) 
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
  a=confirm("Você quer apagar definitivamente o(s) lote(s) selecionado(s)?");
  if (a==true)
  {
	document.location = 'deleteexec.asp?codigo=' + codigos + '&' + pr_params;
  }
}

return false;
}


//-->
</script>

</head>

<body topmargin="0" leftmargin="0" bgcolor="#FFFFFF" marginwidth="0" marginheight="0" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <form name="items" action="" method="get">
    <tr> 
      <td colspan="2" align="center"><BR> <table width="95%" border="0" cellpadding="1" cellspacing="0">
          <!-- header da tabela -->
          <tr> 
            <td align="middle" width="15"> <a onMouseOver="window.status='Selecionar/Deselecionar Todos';return true" onClick="ToggleCheckAll(); return false" href="#"> 
              <img src="../img/setabaixo.gif" border="0" width="11" height="12"></a> 
            </td>
            <td width="9" align="left" bgcolor="#7DACC5" class="arial10">&nbsp;</td>
            <td width="9" align="left" bgcolor="#7DACC5" class="arial10"> <img height="1" src="../img/1x1.gif" width="1"></td>
            <td align="left" bgcolor="#7DACC5" class="arial10"><strong>Nome</strong></td>
            <td width="120" align="left" bgcolor="#7DACC5" class="arial10"><strong>N&uacute;mero Registros</strong></td>
            <td width="120" align="left" bgcolor="#7DACC5" class="arial10"><strong>Data Criação</strong></td>
            <td width="35" align="left" bgcolor="#7DACC5" class="arial10"><strong>&nbsp;</strong></td>
            <td width="35" align="left" bgcolor="#7DACC5" class="arial10"><strong>&nbsp;</strong></td>
            <td width="35" align="left" bgcolor="#7DACC5" class="arial10"><strong>&nbsp;</strong></td>
            <td width="35" align="left" bgcolor="#7DACC5" class="arial10"><strong>&nbsp;</strong></td>
			<td width="35" align="left" bgcolor="#7DACC5" class="arial10"><strong>&nbsp;</strong></td>
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
          Response.Write("  <td width='15' align='center'>")
          Response.Write("    <input type='checkbox' value='" & objRS("COD_LOTE") & "' name='msguid_" & i &"'>")
          Response.Write("  </td>")
          Response.Write("  <td width='25' align='right' bgcolor='" & strBgColor & "'> ")
          Response.Write("    <div align='center'><a href=""javascript:AbreJanelaPAGE('update.asp?var_chavereg=" & objRS("COD_LOTE") & "','530', '400')""><img src='../img/icon_write.gif' width='20' height='17' border='0'></a></div>")
		  Response.Write("  </td>")
          Response.Write("  <td width='25' align='right' bgcolor='" & strBgColor & "'> ")
          Response.Write("    <div align='center'><a href=""javascript:AbreJanelaPAGE('detail.asp?var_chavereg=" & objRS("COD_LOTE") & "','530', '400')""><img src='../img/icon_zoom.gif' width='20' height='17' border='0'></a></div>")
          Response.Write("  </td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "'>" & Mid(objRS("NOME")&"",1,60) & "</td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "'>" & objRS("TOTAL_REGISTROS") & "</td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "'>" & PrepData(objRS("DT_CRIACAO"),True,False) & "</td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "' align='center'><a href=""exportaexcel.asp?var_chavereg=" & objRS("COD_LOTE") & """ class=""arial10""><img src=""../img/ico_excel_mini.gif"" width=""16"" height=""16"" border=""0"" alt=""Exportar Excel""></a></td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "' align='center'><a href=""javascript:AbreJanelaPAGE('maladireta.asp?var_chavereg=" & objRS("COD_LOTE") & "','660', '600')"" class=""arial10""><img src=""../img/ico_maladireta_mini.gif"" width=""24"" height=""20"" border=""0"" alt=""Imprimir Mala-Direta""></a></td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "' align='center'><a href=""javascript:AbreJanelaPAGE('credencial.asp?var_chavereg=" & objRS("COD_LOTE") & "','700', '600')"" class=""arial10""><img src=""../img/ico_impressora_mini.gif"" width=""18"" height=""16"" border=""0"" alt=""Imprimir Credenciais""></a></td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "' align='center'><a href=""javascript:AbreJanelaPAGE('chaveacesso.asp?var_chavereg=" & objRS("COD_LOTE") & "','660', '600')"" class=""arial10""><img src=""../img/ico_lock.gif"" width=""15"" height=""20"" border=""0"" alt=""Imprimir Senhas""></a></td>")
          Response.Write("  <td noWrap bgcolor='" & strBgColor & "' align='center'><a href=""javascript:AbreJanelaPAGE('fichaatualizacao.asp?var_chavereg=" & objRS("COD_LOTE") & "','660', '600')"" class=""arial10""><img src=""../img/icon_inscricao.gif"" border=""0"" alt=""Ficha Atualização""></a></td>")
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
            <td bgcolor="#7DACC5"> <img src="../img/lx_seta.gif" width="18" height="20">&nbsp;&nbsp;&nbsp; 
              <a onMouseOver="window.status='Apagar Todos Selecionados';return true" onClick="DeleteSelect('<%=strALL_PARAMS%>'); return false" href="#"> 
              <img src="../img/lx_apagara.gif" vspace="2" border="0" width="12" height="18"></a></td>
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
            Response.Write "<a href='data.asp?curpage=" & curpage - 1 & "&var_nome=" & strNOME & "&var_codigo=" & strCODIGO & "' class='Tahomaazulforte11'>"
            Response.Write " << </a>"
          End If
          Response.Write("Página " & CurPage & " de " & TotalPages)

          if CInt(CurPage) <> CInt(TotalPages) then
            Response.Write "<a href='data.asp?curpage=" & curpage + 1 & "&var_nome=" & strNOME & "&var_codigo=" & strCODIGO & "' class='Tahomaazul11'>"
            Response.Write " >> </a>"
          End If
         %>&nbsp;&nbsp;&nbsp;&nbsp;
      </td>
    </tr>
  </form>
  </table>
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
  FechaRecordSet ObjRS
 End If
 
FechaDBConn ObjConn
%>
