<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Dim strNOME_ARQUIVO, strCOD_EMPRESA, strCODBARRA, base64String
base64String    = Request.form("mydata")

Set tmpDoc = Server.CreateObject("MSXML2.DomDocument")
Set nodeB64 = tmpDoc.CreateElement("b64")
nodeB64.DataType = "bin.base64" ' stores binary as base64 string
nodeB64.Text = Mid(base64String, InStr(base64String, ",") + 1) ' append data text (all data after the comma)

strNOME_ARQUIVO = Request("id") & "_foto.jpg"
strCOD_EMPRESA  = Request("cod_empresa")
strCODBARRA     = Request("codbarra")


dim bStream : set bStream = server.CreateObject("ADODB.stream")
bStream.type =  1
call bStream.Open()
call bStream.Write( nodeB64.NodeTypedValue )
call bStream.SaveToFile(Server.MapPath(".") & "/imgphoto/" &strNOME_ARQUIVO , 2 )
call bStream.close()
set bStream = nothing

%>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%

Dim strSQL, objRS, ObjConn
	
AbreDBConn objConn, CFG_DB_DADOS

If strCODBARRA <> "" Then
  strSQL = "update tbl_Empresas_sub SET IMG_FOTO = '" & strNOME_ARQUIVO & "' WHERE CODBARRA = '" & strCODBARRA & "'" 
  'response.Write(strSQL)
  objConn.Execute(strSQL)
End If

'S� atualiza na TBL_EMPRESAS se for codigo de barras da PF (final) "010"
If strCOD_EMPRESA <> "" and right(strCODBARRA,3) = "010" Then
  strSQL = "update tbl_Empresas SET IMG_FOTO = '" & strNOME_ARQUIVO & "' WHERE COD_EMPRESA = '" & strCOD_EMPRESA & "'" 
  'response.Write(strSQL)
  objConn.Execute(strSQL)
End If

FechaDBConn ObjConn

'Response.End()
%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%>  - Contato</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--
function SetParentField () {
try 
  {
  self.opener.SetFormField('forms[0]','var_img_foto','<%=strNOME_ARQUIVO%>');
  }
catch(err)
  {
  }
  
try 
  {
  self.parent.SetFormField('forms[0]','var_img_foto','<%=strNOME_ARQUIVO%>');
  }
catch(err)
  {
  }
}
//-->
</script>
</head>

<body bgcolor="#F0F0F0" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script language="javascript">
SetParentField(); 
window.close();
</script>
</body>
</html>




