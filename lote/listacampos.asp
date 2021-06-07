<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
 Response.Expires = 0
%>
<html>
<head>
<title>Lista de Atividades</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css">
<script language="JavaScript">
<!--
function SetField(valor) {
  self.opener.SetParentField('form_lotecriterio','DBVAR_STR_VALOR',valor);
  window.close();
}

function showValor() {
	var valor = "";
	var arrvalor = new Array;
	var objCheck = document.forms['formcampo'].elements['var_valor'];
		
	for(j=0;j<objCheck.length;j++){
		if (objCheck[j].checked){
			arrvalor.push(objCheck[j].value);
		}
	}
    valor = arrvalor.join(",");
	SetField(valor);
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="1" align="center" cellpadding="1" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#F2F2F2">
<form name="formcampo" id="formcampo" method="post" action="">
  <tr>
    <td width="30" align="center" bgcolor="#66CCFF"></td>
    <td width="50" align="center" bgcolor="#66CCFF">C&oacute;digo</td>
    <td bgcolor="#66CCFF">Descri&ccedil;&atilde;o</td>
  </tr>
      <%
Dim objConn, ObjRS
Dim strSQL

AbreDBConn objConn, CFG_DB_DADOS 


Dim strTIPO, strCRITERIO, strCAMPO_EXTRA
strTIPO = Request("tipo")
strCRITERIO = Request("criterio")
strCAMPO_EXTRA = Request("extra")

If strCRITERIO = "IN" Then
  strCRITERIO = "checkbox"
Else
  strCRITERIO = "radio"
End If

Dim i, strBgColor

Select Case UCase(strTIPO)

 Case "ATIVIDADE"
 
   strSQL = " SELECT tbl_Atividade.CODATIV" & _
                  " ,tbl_Atividade.ATIVIDADE" & _
                  " ,tbl_Atividade.ATIVMINI" & _
              " FROM tbl_Atividade " & _
             " ORDER BY 1 "
  
   set objRS = objConn.Execute(strSQL)  

   i = 0
   Do While Not objRS.EOF
   %>
       <tr>
       <td align="center"><input type="<%=strCRITERIO%>" name="var_valor" id="var_valor" value="<%=objRS("CODATIV")%>"></td>
       <td align="center"><%=objRS("CODATIV")%></a></td>
       <td><%=objRS("ATIVMINI")%></td>
       </tr>
    <%
       objRS.MoveNext
     Loop
 
   FechaRecordSet ObjRS

 Case "CREDENCIAL"

   strSQL = " SELECT COD_STATUS_CRED, STATUS FROM TBL_STATUS_CRED ORDER BY 1"
  
   set objRS = objConn.Execute(strSQL)  

   i = 0
   Do While Not objRS.EOF
   %>
       <tr>
       <td align="center"><input type="<%=strCRITERIO%>" name="var_valor" id="var_valor" value="<%=objRS("COD_STATUS_CRED")%>"></td>
       <td align="center"><%=objRS("COD_STATUS_CRED")%></a></td>
       <td><%=objRS("STATUS")%></td>
       </tr>
    <%
       objRS.MoveNext
     Loop
 
   FechaRecordSet ObjRS
 
 Case "CATEGORIA"

   strSQL = " SELECT COD_STATUS_PRECO, STATUS FROM TBL_STATUS_PRECO WHERE COD_EVENTO = " & Session("COD_EVENTO") & " ORDER BY 1 "
  
   set objRS = objConn.Execute(strSQL)  

   i = 0
   Do While Not objRS.EOF
   %>
       <tr>
       <td align="center"><input type="<%=strCRITERIO%>" name="var_valor" id="var_valor" value="<%=objRS("COD_STATUS_PRECO")%>"></td>
       <td align="center"><%=objRS("COD_STATUS_PRECO")%></a></td>
       <td><%=objRS("STATUS")%></td>
       </tr>
    <%
       objRS.MoveNext
     Loop
 
   FechaRecordSet ObjRS

 Case "EVENTO"

   strSQL = " SELECT COD_EVENTO, NOME FROM TBL_EVENTO ORDER BY 1 "
  
   set objRS = objConn.Execute(strSQL)  

   i = 0
   Do While Not objRS.EOF
   %>
       <tr>
       <td align="center"><input type="<%=strCRITERIO%>" name="var_valor" id="var_valor" value="<%=objRS("COD_EVENTO")%>"></td>
       <td align="center"><%=objRS("COD_EVENTO")%></a></td>
       <td><%=objRS("NOME")%></td>
       </tr>
    <%
       objRS.MoveNext
     Loop
 
   FechaRecordSet ObjRS
 
 Case "EXTRA"
     Dim objFSO, objTextStream
	 Dim strCAMPO_VALOR

     Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	 
	 If objFSO.FileExists(Server.MapPath("..\") & "\shop\" & strCAMPO_EXTRA) Then
	  Set objTextStream = objFSO.OpenTextFile(Server.MapPath("..\") & "\shop\" & strCAMPO_EXTRA)
	  Do While not objTextStream.AtEndOfStream
		strCAMPO_VALOR = objTextStream.ReadLine
	  %>
       <tr>
       <td align="center"><input type="<%=strCRITERIO%>" name="var_valor" id="var_valor" value="<%=strCAMPO_VALOR%>"></td>
       <td align="center">&nbsp;</a></td>
       <td><%=strCAMPO_VALOR%></td>
       </tr>
	  <%
	  Loop
	  objTextStream.Close
	  Set objTextStream = Nothing
	 End If
 
     Set objFSO = Nothing
   
End Select
   
FechaDBConn ObjConn
%>
</form>
</table>
<div align="center">
<input type="button" onClick="javascript:showValor();" value="Confirmar" name="btEnviar">
</div>
</body>
</html>
