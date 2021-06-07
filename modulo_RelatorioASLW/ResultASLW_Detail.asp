<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<%
 Response.Expires = 0 
 Server.ScriptTimeout = 1200
%>
<!--#include file="../_database/ADOVBS.INC"-->
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"-->

<%
Dim objConn, objRS, strSQL, i, cont, numerr, abouterr, aviso
Dim strBgColor, strBgColorHEADER, strBgColorINFO1, strBgColorINFO2, strBgColorSUBTOTAL
Dim strCOD_REL, strACAO, strDESCRICAO, strSQLRel

strACAO      = Request("var_acao")
strSQLRel    = Request("var_strParam") 
strDESCRICAO = Request("var_descricao")
strCOD_REL   = Request("var_chavereg")

  'Aqui fazemos DecodeASLW
  '-------------------------------------------------------
  strSQLRel = RemoveTagSQL(strSQLRel)
  '-------------------------------------------------------
    
  'Response.Write(strSQLRel)
  'Response.End()

  AbreDBConn ObjConn, CFG_DB_DADOS

  Sub ExibeMsg(StrAviso, StrDesc)
	response.write ("<p align='center'><font face='Arial' size='2'><b>.:: AVISO ::.</b></font></p>")
	response.write ("<p align='center'><font face='Arial' size='2'>" & StrAviso & "<br><br></font></p><hr>")
	response.write ("<p align='center'><table width='600' border='0'><tr><td><font face='Arial' size='2'>" & StrDesc & "</font></td></tr></table></p><hr>")	
	response.write ("<p align='right'><a href='JavaScript:history.back();location.reload();' target='_parent'><img src='../img/icon_exec.gif' width='20' height='17' border='0' alt='para executar novamente clique aqui'></a></p>")

	response.End
  End Sub
  
  if strACAO = ".xls" Or strACAO = ".doc" then
	Response.AddHeader "Content-Type","application/x-msdownload"
	Response.AddHeader "Content-Disposition","attachment; filename=Relatorio_" & Session.SessionID & "_" & Replace(Time,":","") & strACAO
  end if
  
  strBgColorHEADER   = "#FFCC66"
  strBgColorINFO1    = "#FFE8B7"
  strBgColorINFO2    = "#FFFFFF"
  strBgColorSUBTOTAL = "#FFD988"

  If strSQLRel <> "" Then
'	On Error Resume Next
      Set objRS = Server.CreateObject("ADODB.Recordset")

	  objRS.CursorLocation = adUseClient
	  objRS.Open strSQLRel, objConn
	  
	  If Not objRS.Eof And Not objRS.Bof Then
	      objRS.AbsolutePage = 1
	      'Err.Raise 6
    	  numerr = Err.number
	      abouterr = Err.description
    	  If numerr <> 0 Then
	        aviso = "Warning number " & numerr & " of the type <br>" & abouterr & "<br><br>Tipo de dado no parâmetro pode não ser compatível. Verifique na descrição do relatório as instruções sobre preenchimento adequado dos parâmetros da consulta. Para executar novamente utilize o ícone logo abaixo.<br><br>" 
			ExibeMsg aviso, strDescricao
	      End If
	  Else
		aviso = "Consulta não encontrou dados.<br><br><br>Favor avaliar consulta e/ou parâmetros. Verifique na descrição do relatório as instruções sobre preenchimento adequado dos parâmetros da consulta. Para executar novamente utilize o ícone logo abaixo.<br><br>" 
		ExibeMsg aviso, strDescricao
	  End If
	  
  Response.Buffer = True
%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<% if strACAO="" then %>
	<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<% end if %>
<script language="JavaScript">
function SetOrderBy(prStrOrder,prStrDirect) 
{
  var myStrSQL, myAuxStrSQL, myPos;
  myStrSQL = document.FormPrSQL.sqlBUFFER.value.toLowerCase();
  myAuxStrSQL = myStrSQL.split('order by');
  myStrSQL = myAuxStrSQL[0] + ' order by ' + prStrOrder + ' ' + prStrDirect;

 
  document.FormPrSQL.var_acao.value = document.FormPrSQL.acaoBUFFER.value;
  document.FormPrSQL.var_descricao.value = document.FormPrSQL.descBUFFER.value;
  document.FormPrSQL.var_strParam.value = myStrSQL;
  document.FormPrSQL.submit();
}
</script>


<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<% if strACAO="" then %>
<form name="FormPrSQL" method="post" action="ResultASLW_Detail.asp">
  <input name="sqlBUFFER"     type="hidden" value="<%=strSQLRel%>">
  <input name="acaoBUFFER"    type="hidden" value="<%=strACAO%>">
  <input name="descBUFFER"    type="hidden" value="<%=strDESCRICAO%>">  
  <input name="var_strParam"  type="hidden" value="<%=strSQLRel%>">
  <input name="var_acao"      type="hidden" value="<%=strACAO%>">
  <input name="var_descricao" type="hidden" value="<%=strDESCRICAO%>">
  <input name="var_chavereg" type="hidden" value="<%=strCOD_REL%>">
</form>
<% End if %>
<table width='100%' cellspacing='0' cellpadding='0' border='1' bordercolor="#FFFFFF">
<%
	Response.Write("<tr>")
	For i = 0 to objRS.fields.count - 1
	  Response.Write("<td bgcolor='" & strBgColorHEADER & "' class='arial12Bold'>&nbsp;")
	  if strACAO="" then
	    'Não ordena mais por nome porque não será possível ordenar campos calculados
		'Mas por posição é possível
	    'Response.Write("<a href=""JavaScript:SetOrderBy('"&objRS.Fields(i).Name&"','DESC');""><img src='../_img/gridlnkASC.gif'  border='0' align='absmiddle'></a>")
	    'Response.Write("<a href=""JavaScript:SetOrderBy('"&objRS.Fields(i).Name&"','ASC');""><img src='../_img/gridlnkDESC.gif' border='0' align='absmiddle'></a>")
	    Response.Write("<a href=""JavaScript:SetOrderBy('"&CStr(i+1)&"','ASC');""><img src='../img/gridlnkASC.gif'  border='0' align='absmiddle'></a>")
	    Response.Write("<a href=""JavaScript:SetOrderBy('"&CStr(i+1)&"','DESC');""><img src='../img/gridlnkDESC.gif' border='0' align='absmiddle'></a>")
	  end if
	  Response.Write("<b>&nbsp;" & objRS.Fields(i).Name & "</b></td>")
	Next
	Response.Write("</tr>")

	'objRS.MoveFirst
	'on error resume next
	
	strBgColor = strBgColorINFO1
	cont = 0
	Do While Not objRS.EOF
		Response.Write("<tr valign='top' align='left'>")
		For i = 0 to objRS.fields.count - 1
		  Response.Write("<td bgcolor='" & strBgColor & "' class='texto_corpo_mdo'>" & Server.HTMLEncode(objRS.Fields(i).value&"") & "</td>")
		Next
		Response.Write("</tr>")
		objRS.MoveNext
		cont = cont + 1
		If cont mod 500 = 0 Then
		  Response.Flush
		End If
		'If (strBgColor = strBgColorINFO1) Then
		'	strBgColor = strBgColorINFO2
		'Else
		'	strBgColor = strBgColorINFO1
		'End If
	Loop
%>
<tr>
<td colspan="<%=objRS.fields.count%>"><%=ATHFormataTamLeft(cont,5,"0")%> registro(s)</td>
</tr>
</table>
<%
    FechaRecordSet ObjRS
	'RegistrarLogAcao ObjConn, "ASLW", strCOD_REL, "tbl_ASLW_RELATORIO", strSQLRel
  End If
	
  FechaDBConn ObjConn
  Response.Flush
%>
</body>
</html>