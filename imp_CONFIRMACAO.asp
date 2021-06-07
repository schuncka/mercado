<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/adovbs.inc"-->
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_include/barcode39.asp"-->
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%>  - ARM</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<SCRIPT LANGUAGE="JavaScript">
<!--
function printThis() 
{
 vbPrintPage();
}
// -->
</SCRIPT>
<script language=vbscript>
<!--
Sub window_onunload
  On Error Resume Next
  Set WB = nothing
End Sub

Sub vbPrintPage
  OLECMDID_PRINT = 6
  OLECMDEXECOPT_DONTPROMPTUSER = 6
  OLECMDEXECOPT_PROMPTUSER = 1
  On Error Resume Next
  WB.ExecWB OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER
End Sub
//<body onFocus="window.close();">
//-->
</script>
<link href="../_CSS/CSM.CSS" rel="stylesheet" type="text/css">
</head>
<body>
<!-- <OBJECT ID="WB" WIDTH="0" HEIGHT="0" CLASSID="clsid:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT> //-->
<%
dim strCOD_INSC, strCOD_EVENTO
dim objConn, strSQL, objRS
dim i,arrCOD_INSC
Dim strNOMECLI, strENDER, strBAIRRO, strCIDADE, strESTADO, strCEP
Dim strEV_NOME, strEV_CABECALHO, strEV_RODAPE, strEV_CABECALHO_LOJA, strEV_RODAPE_LOJA, strEV_SITE, strEV_DT_MATERIAL, strEV_HR_MATERIAL
Dim strEV_PAVILHAO, strEV_CIDADE, strEV_AGENCIA_TURISMO, strEV_EMAIL, strEV_EMAIL_SENDER, strEV_FONE
Dim strEV_ARM_TEXTO, strEV_ARM_TEXTO_INTL, strEV_ARM_TEXTO_ORIGINAL, strBODY
Dim strCOD_PAIS

strCOD_EVENTO = Session("COD_EVENTO")

AbreDBConn objConn, CFG_DB_DADOS 

strSQL=	" SELECT NOME, " &_
        " CABECALHO, " &_ 
		" RODAPE, " &_ 
        " CABECALHO_LOJA, " &_ 
		" RODAPE_LOJA, " &_ 
		" SITE, " &_ 
		" DT_MATERIAL, " &_ 
		" HR_MATERIAL, " &_ 
		" PAVILHAO, " &_ 
		" CIDADE, " &_ 		 
		" AGENCIA_TURISMO, " &_ 
		" EMAIL, " &_ 
		" EMAIL_SENDER, " &_
		" FONE, " &_
		" ARM_TEXTO, " &_ 
		" ARM_TEXTO_INTL " &_ 
		" FROM tbl_EVENTO" &_ 
		" WHERE  COD_EVENTO = " & strCOD_EVENTO
		
'FechaRecordSet objRS
'objConnCSM.open objRS, strSQL

set objRS = objConn.Execute(strSQL)

If not objRs.EOF then
  strEV_NOME = objRS("NOME")&""
  strEV_CABECALHO = objRS("CABECALHO")&""
  strEV_RODAPE = objRS("RODAPE")&""
  strEV_CABECALHO_LOJA = objRS("CABECALHO_LOJA")&""
  strEV_RODAPE_LOJA = objRS("RODAPE_LOJA")&""
  strEV_SITE = objRS("SITE")&""
  strEV_DT_MATERIAL = objRS("DT_MATERIAL")&""
  strEV_HR_MATERIAL = objRS("HR_MATERIAL")&""
  strEV_PAVILHAO = objRS("PAVILHAO")&""
  strEV_CIDADE = objRS("CIDADE")&""
  strEV_AGENCIA_TURISMO = objRS("AGENCIA_TURISMO")&""
  strEV_EMAIL = objRS("EMAIL")&""
  strEV_EMAIL_SENDER = objRS("EMAIL_SENDER")&""
  strEV_ARM_TEXTO = objRS("ARM_TEXTO")&""
  strEV_ARM_TEXTO_INTL = objRS("ARM_TEXTO_INTL")&""
  strEV_ARM_TEXTO_ORIGINAL = strEV_ARM_TEXTO
  strEV_FONE = objRS("FONE")&""
end if

FechaRecordSet objRS

'********************************************
' O objetivo é fazer receber um array, fazer um loop até o fim do mesmo
' e para cada um deles imprimir uma ficha
'********************************************

'--------------------------------------------
strCOD_INSC = request("var_cod_INSC")
arrCOD_INSC = SPLIT(strCOD_INSC,",")
AbreDBConn objConn, CFG_DB_DADOS 

'---------------------------------------
for i=0 to ubound(arrCOD_INSC)

strSQL=	" SELECT tbl_EMPRESAS.NOMECLI, " &_
        "        tbl_EMPRESAS.END_FULL, " &_ 
		"        tbl_EMPRESAS.END_BAIRRO, " &_ 
		"        tbl_EMPRESAS.END_CIDADE, " &_ 
		"        tbl_EMPRESAS.END_ESTADO, " &_ 
		"        tbl_EMPRESAS.END_CEP, " &_ 
		"        tbl_INSCRICAO.COD_PAIS " &_ 
		" FROM tbl_INSCRICAO, tbl_EMPRESAS" &_ 
		" WHERE tbl_INSCRICAO.COD_EMPRESA = tbl_EMPRESAS.COD_EMPRESA " &_ 
		" AND tbl_Inscricao.COD_EVENTO = " & Session("COD_EVENTO") & _
		" AND tbl_INSCRICAO.COD_INSCRICAO = "& arrCOD_INSC(i)
set objRS = objConn.Execute(strSQL)		
strNOMECLI = objRS("NOMECLI")
strENDER = objRS("END_FULL")
strBAIRRO = objRS("END_BAIRRO")
strCIDADE = objRS("END_CIDADE")
strESTADO = objRS("END_ESTADO")
strCEP = objRS("END_CEP")
strCOD_PAIS = objRS("COD_PAIS")&""

strEV_ARM_TEXTO = strEV_ARM_TEXTO_ORIGINAL

'Teste se o COD_PAIS for alguma lingua diferente do BR - Brasil ou se não está em branco para utilizar o ARM_INTL
If strCOD_PAIS <> "" And strCOD_PAIS <> "BR" Then
  strEV_ARM_TEXTO = strEV_ARM_TEXTO_INTL
End If


strSQL=	" SELECT TBL_PRODUTOS.COD_PROD, GRUPO, TITULO, DESCRICAO, OBS, PALESTRANTE, DT_OCORRENCIA " &_ 
		" FROM TBL_PRODUTOS, TBL_INSCRICAO_PRODUTO " &_
		" WHERE TBL_PRODUTOS.COD_PROD=TBL_INSCRICAO_PRODUTO.COD_PROD " &_ 
		"   AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO") & _
		"   AND TBL_INSCRICAO_PRODUTO.COD_INSCRICAO= "&arrCOD_INSC(i)

set objRSImg = objConn.Execute(strSQL)
StrBody = ""
If not objRSImg.EOF Then
  strBody = StrBody & "<table width=""500"" border=""0"" align=""center"">"
  do while not objRSImg.eof
      strBody = StrBody &  "<tr>"
      strBody = StrBody &    "<td><b>(" & objRSImg("COD_PROD") & ") " & objRSImg("TITULO") & "</b></td>"
      strBody = StrBody &  "</tr>"
    objRSImg.movenext
  loop
  strBody = StrBody & "</table>"
End If
FechaRecordSet objRSImg

strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_CABECALHO>", strEV_CABECALHO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_NOMEEVENTO>", strEV_NOME)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_CIDADEEVENTO>", strEV_CIDADE)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DATAATUAL>", DataExtenso(now()))
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DATAATUAL_US>", DataExtensoIntl(now(),1033))
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_DIAATUAL>", Right("0"&Day(date()),2) )
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_MESATUAL>", Right("0"&Month(date()),2) )
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_ANOATUAL>", Year(date()) )
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_NOMECLIENTE>", strNOMECLI)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_INSCRICAO>", arrCOD_INSC(i))
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_SITEEVENTO>", "<a href='http://" & strEV_SITE & "' target='_blank'>" & strEV_SITE & "</a>")
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_AGENCIATURISMO>", strEV_AGENCIA_TURISMO)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_EMAILEVENTO>", "<a href='mailto:" & strEV_EMAIL & "'>" & strEV_EMAIL & "</a>")
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_FONEEVENTO>", strEV_FONE)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_RODAPE>", strEV_RODAPE)
strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_PRODUTOS>", strBody)

'strBody = BarCode39Size(arrCOD_INSC(i),15,1.5)
'strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_BARCODE>", strBody)

 strBody = ""
 Dim objRSImg, strALTURA, strLARGURA
 strSQL = " SELECT ARQUIVO, ALTURA, LARGURA FROM tbl_EVENTO_IMG WHERE AREA = 'ARM' AND COD_EVENTO = " & strCOD_EVENTO
 Set objRSImg = objConn.Execute(strSQL)
 If not objRSImg.EOF Then
   strBody = StrBody & "<br><table border=0>"
   strBody = StrBody & "  <tr><td align='justify' valign='top'>"
   Do While not objRSImg.EOF
     strLARGURA = objRSImg("LARGURA") & ""
     strALTURA = objRSImg("ALTURA") & ""
     If strLARGURA <> "0" And strLARGURA <> "" And not IsNull(strLARGURA) Then
       strLARGURA = " width='" & strLARGURA &"'"
     End If
     If strALTURA <> "0" And strALTURA <> "" And not IsNull(strALTURA) Then
       strALTURA = " height='" & strALTURA &"'"
     End If
     strBody = StrBody &	"<div align=""center""><img src=""../imgdin/" & objRSImg("ARQUIVO") & """ " & strALTURA & strLARGURA & " border=""0""></div><br>"
     objRSImg.MoveNext
   Loop
   strBody = StrBody & "  </td></tr>"
   strBody = StrBody & "</table><br>"
 End If
 FechaRecordSet objRSImg

strEV_ARM_TEXTO = Replace(strEV_ARM_TEXTO, "<PRO_IMAGEM>", strBody)
%>
<table cellpadding="0" cellspacing="0" border="0">
<tr>
  <td height="20" valign="top" align="center"><% BarCode39Size arrCOD_INSC(i),15,1.5 %></td>
</tr>
<tr>
    <td height="700" valign="top"><%= strEV_ARM_TEXTO %> <br>
    </td>
  </tr>
  <tr> 
    <td  height="60"><br> 
	  <table width="400" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr> 
          <td><%=strNOMECLI%></td>
        </tr>
        <tr> 
          <td><%=strENDER%></td>
        </tr>
        <tr> 
          <td><%=strCIDADE%> - <%=strESTADO%></td>
        </tr>
        <tr> 
          <td><%=strCEP%></td>
        </tr>
      </table>
	</td>
  </tr>
</table>

<!--este comando faz a quebra de página forçada, o problema é que quando foi utilizado ele imprimiu uma página em branco //-->
<div style="page-break-before:always;"></div>
<%NEXT

FechaRecordSet objRS
FechaDBConn objConn
'---------------------------------------------%>

<script language="JavaScript">
<!--
//  printThis();
window.print();
//-->
</script>
</body>
</html>
