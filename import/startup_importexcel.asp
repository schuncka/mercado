<%@LANGUAGE="VBSCRIPT" %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athutils.asp"--> 
<%
' ========================================================================
' Tratamento para inserir campo formatado no SQL
' ========================================================================
Function tipoCAMPO(strCAMPO,strTIPO)

	Select case Int(strTIPO)
		Case  3, 19 :'Inteiro

				if strCAMPO <>"" Then
					tipoCAMPO = int(strCAMPO)
				else
					tipoCAMPO ="NULL"
				End If
				
		Case 135 :'DataTime
				
				if strCAMPO <>"" Then
					tipoCAMPO = "'"&PrepDataIve(strCAMPO, true,true)&"'"
				else
					tipoCAMPO = "NULL"
				End If
				
		Case 16 :'boleano

				if strCAMPO <>"" Then
					tipoCAMPO = strCAMPO
				else
					tipoCAMPO = "NULL"
				End If

		Case 5 :'DOUBLE
				if strCAMPO <>"" Then
					tipoCAMPO = FormataDouble(strCAMPO,2)
				else
					tipoCAMPO = "NULL"
				End If	
					
		Case 200, 202, 203 :'Text
				if strCAMPO <>"" Then
					tipoCAMPO = "'"&Replace(UCase(Trim(strCAMPO)),"'","''")&"'"
				else
					tipoCAMPO = "NULL"
				End If		
	End Select	
	
End Function

'=============================================================================


' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Function GravaCadastro(CAMPOS, VALORES)
strCOLUNAS = Left(Replace(CAMPOS,"|",","), len(CAMPOS)-1)
strLINHAS  = Left(Replace(VALORES,"|",","), len(VALORES)-1)

  On Error Resume Next

	strSQL = "INSERT INTO "&strTABELA&" ("&strCOLUNAS&") VALUES ("&strLINHAS&")"
	objConn.Execute(strSQL)

 If Err.Number <> 0 Then
    If strURL = "" Then
	   Response.Write("<li>Erro: <b>" & strLINHAS & "</b> (" & err.Description & ")<BR>")
	   strERRO = strERRO & "<li>Erro: <b>" & strLINHAS & "</b> (" & err.Description & ")<BR>"
	End If
   GravaCadastro = false
 Else 
	If strURL = "" Then
		Response.Write("<li>Sucesso: <b>" & strLINHAS & "</b><BR>")
    End If
	GravaCadastro = True
 End If

End Function

'=============================================================================







'=============================================================================
' Início do código geral
'=============================================================================
Dim objConn, objRS, strSQL
Dim objFSO, strPath, objFolder, objItem, CAMPOS, VALORES, strLINHAS
Dim bolAlreadyExists, strHyperLink, strMensagem 
Dim strARQUIVO, strERRO
Const adOpenStatic = 3
Const adLockPessimistic = 2
Dim cnnExcel
Dim rstExcel, strCAMPOS, strNOMES, strACAO, strCAMPOS2, strCAMPOFIM, strCOLUNAS, arrCOLUNAS, n, arrCAMPOS, arrNOMES, k, strCAMPOS3, strTIPOS, arrEXCEL, arrTABELA, arrTIPOS, strVALOR, strPREACAO
Dim I, contador
Dim iCols, strLABEL, strURL, strPERMISSION, contador_valido, strCAMPO_AUX, strVALOR_AUX
Dim strEXTENSAO, strCONEXAO

Dim strCOD_EVENTO, strEV_NOME

strCOD_EVENTO = GetParam("cod_evento")
strARQUIVO    = GetParam("var_ARQUIVO")
strACAO       = GetParam("var_acao")
strLABEL      = GetParam("var_label")
strURL        = GetParam("var_url")
strPERMISSION = GetParam("var_permission")
strPREACAO    = GetParam("var_preacao")

If strLABEL & "" = "" Then
  strLABEL = "Importação de Arquivos"
End IF
contador = 0

AbreDBConn objConn, CFG_DB_DADOS

strSQL = "SELECT COD_EVENTO, NOME FROM TBL_EVENTO"
strSQL = strSQL & " WHERE SYS_INATIVO IS NULL"
If isNumeric(strCOD_EVENTO) and strCOD_EVENTO&"" <> "" Then
  strSQL = strSQL & " AND COD_EVENTO = " & strCOD_EVENTO
End If
strSQL = strSQL & " ORDER BY DT_INICIO DESC"

Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
  strCOD_EVENTO = objRS("COD_EVENTO")
  strEV_NOME = objRS("NOME")&""
End If
FechaRecordSet objRS

If strCOD_EVENTO = "" or strEV_NOME = "" Then
  Response.Write("<center>Evento inválido!</center>")
  Response.End()
End If


%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<script language="javascript">
<!--

function UploadImage(formname,fieldname, dir_upload) 
{
  var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
  window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

function SetFormField(formname, fieldname, valor) 
{
  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
  {
	eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
	//document.location.reload();
  }
} 

function importar() {
	formimport.submit();
}

//-->
</script>
</head>

<body>

<%
Select Case strACAO

  Case "PREPARAR"
		Dim strTABELA, strPLANILHA, rsXLS
		
		strTABELA = GetParam("var_tabela")
		strCAMPOS = GetParam("var_campos")
		strNOMES  = GetParam("var_nomes")
		If strNOMES = "" Then
		  strNOMES = strCAMPOS
		End If
		
	  	'strSQL = "SELECT COD_EMPRESA, NOMECLI FROM TBL_EMPRESAS WHERE COD_EMPRESA = '" & strCOD_EMPRESA & "' AND SYS_INATIVO IS NULL" 
	  	'Set objRS = objConn.Execute(strSQL)

		On Error Resume Next
		strEXTENSAO = lcase(strreverse( left(strreverse(strARQUIVO),instr(strreverse(strARQUIVO),".")) ))
		'Response.Write("<div align='center'>Formato de arquivo ["&strARQUIVO&"] = ["&strEXTENSAO&"].<br></div>")
		Select Case strEXTENSAO
		  Case ".xls"
		    'strCONEXAO = "DRIVER={Microsoft Excel Driver (*.xls)}; DBQ=" & Server.MapPath("../import/") & "\" & strARQUIVO
		  'Case ".xlsx"
		    'strCONEXAO = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&Server.MapPath("../import/") & "\" & strARQUIVO&";Extended Properties=Excel 12.0"
			strCONEXAO = "Provider=MSDASQL;DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)}; DBQ=" & Server.MapPath("../import/") & "\" & strARQUIVO
			'strCONEXAO = "DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)}; DBQ=" & Server.MapPath("../import/") & "\" & strARQUIVO
			'strCONEXAO = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("../import/") & "\" & strARQUIVO& ";Extended Properties=Excel 12.0;"
		  Case Else
		    Response.Write("<div align='center'>Formato de arquivo inválido ["&strEXTENSAO&"].<br> Enviar somente planilha Excel no formato .XLS</div>")
			response.Write("<div align='center'><input type='button' onclick='javascript:history.back();' value='Voltar'></div>")
		    Response.Write(err.Description)	
			Response.End()	  
		End Select


		Set cnnExcel = Server.CreateObject("ADODB.Connection")
		'response.Write("conexao = " & strCONEXAO & "<BR>")
		'response.End()
		cnnExcel.Open strCONEXAO
				
		If err.Number <> 0 Then
		  Response.Write("<div align='center'>Formato de arquivo inválido.<br> Enviar somente planilha Excel no formato .XLS ou .XLSx</div>")
		  response.Write("<div align='center'><input type='button' onclick='javascript:history.back();' value='Voltar'></div>")
		  Response.Write("<div align='center'>"&err.Description&"</div>")
		  Response.End()
		End If
		
		Set rsXLS = cnnExcel.OpenSchema(20)
		rsXLS.MoveFirst
		strPLANILHA = rsXLS("TABLE_NAME")
		
		'response.Write(strPLANILHA)
		'response.End()
 
  		Set rstExcel = Server.CreateObject("ADODB.Recordset")
  		rstExcel.Open "SELECT * FROM [" & strPLANILHA & "]",cnnExcel,adOpenStatic,adLockPessimistic
 
  		'Response.Write "Colunas: <br>"
  		iCols = rstExcel.Fields.Count
		strCOLUNAS=""
		
		For I = 0 To iCols - 1
			If Trim(rstExcel.Fields.Item(I).Name)<>"" Then
				strCOLUNAS = strCOLUNAS &"|"&Trim(rstExcel.Fields.Item(I).Name)
			End If	
		Next
		
		arrCOLUNAS=Split(strColunas,"|")
		
		%>
		<form name="FormImport2" id="FormImport2" action="startup_importexcel.asp" method="post">
	  	<input type="hidden" name="var_acao" value="IMPORTAR">
	  	<input type="hidden" name="var_ARQUIVO" value="<%=strARQUIVO%>">
		<input type="hidden" name="var_tabela" value="<%=strTABELA%>">
		<input type="hidden" name="var_url" value="<%=strURL%>">
        <input type="hidden" name="var_preacao" value="<%=strPREACAO%>">
		<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr> 
			<td align="center" valign="middle">

	  			<table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr> 
		  			<td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
		  			<td width="492" height="4"><img src="../img/inbox_top_blue.gif" width="492" height="4"></td>
		  			<td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
				</tr>
	  			</table>
	  			<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
				<tr> 
		  			<td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
		  			<td width="492"><table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="texto_corpo_mdo">
			  	<tr> 
					<td bgcolor="#808080" class="texto_contraste_mdo">&nbsp;&nbsp;<%=strLABEL%></td>
			  	</tr>
			  	<tr> 
					<td height="16" align="center">&nbsp;</td>
			  	</tr>
			  	<tr> 
					<td align="center">
				<!-- ------------------------------- -->
							<table width="450" border="0" cellpadding="0" cellspacing="0" class="texto_corpo_mdo">
				  			<tr>
								<td colspan="2" height="10"></td>
							</tr>
							<tr>
								<td align="right">Tabela:&nbsp;</td>
								<td height="10"><b><%=strTABELA%></b></td>
							</tr>
				  			<tr>
								<td colspan="2" height="10"></td>
							</tr>
				  			<tr>
								<td align="right">Relação dos campos:</td>
								<td height="10"><hr></td>
							</tr>
				  			<tr>
								<td colspan="2" height="10"></td>
							</tr>
							
							<%
							Dim strCAMPOS_AUX
							
							arrCAMPOS = Split(strCAMPOS,",")
							arrNOMES  = Split(strNOMES,",")
							
							strCAMPOS_AUX = ""
							For i = 0 To UBound(arrCAMPOS)
								ReDim Preserve arrDEFAULT_VALUES(i)
								
								If strCAMPOS_AUX <> "" Then
									strCAMPOS_AUX = strCAMPOS_AUX & ","
								End If	
								
								If InStr(1,arrCAMPOS(i),"-") <> 0 Then
									strCAMPOS_AUX = strCAMPOS_AUX & Trim(Mid(arrCAMPOS(i),1,InStr(1,arrCAMPOS(i),"-")-1))
									arrDEFAULT_VALUES(i) = Trim(Mid(arrCAMPOS(i),InStr(1,arrCAMPOS(i),"-")+1))
								Else
									strCAMPOS_AUX = strCAMPOS_AUX & arrCAMPOS(i)
									arrDEFAULT_VALUES(i) = ""
								End If
							Next
							
							strSQL = "SELECT " & strCAMPOS_AUX & " FROM " & strTABELA
							set objRS2 = Server.CreateObject("ADODB.Recordset")
							objRS2.Open strSQL, objConn

							For i = 0 to objRS2.fields.count - 1
								'strCAMPOS=strCAMPOS&objRS2.Fields(i).Name&"|"
							%>
				  			<tr> 
								<td align="right"><%=arrNOMES(i)%>:&nbsp;</td>
								<td>
								<input type="hidden" name="var_tipo_<%=objRS2.Fields(i).Name%>" value="<%=objRS2.Fields(i).type%>">
								<% If arrDEFAULT_VALUES(i)&"" = "" Then %>
								<select name="var_<%=objRS2.Fields(i).Name%>" class="textbox180">
									<option value="" selected>Selecione o campo</option>
									<% for n=0 to Ubound(arrCOLUNAS) %>
										<option value="<%=arrCOLUNAS(n)%>" <% If UCase(cstr(objRS2.Fields(i).Name&"")) = UCase(cstr(arrCOLUNAS(n)&"")) Then Response.Write("selected") End If %>><%=arrCOLUNAS(n)%></option>
									<% Next	%>	
								</select>	
								<% Else %>
								<input type="hidden" name="var_<%=objRS2.Fields(i).Name%>" value="<%=objRS2.Fields(i).Name%>">
								<strong><%=arrDEFAULT_VALUES(i)%></strong>
								<% End If %>
								</td>
				  			</tr>
							<%
							Next
							%>
							<input type="hidden" name="var_campos" value="<%=Replace(strCAMPOS,",","|")%>">
								<tr><td colspan="2" height="15"></td></tr>
								<tr><td colspan="2" height="10"></td></tr>
								</table>
				<!--------------------------------- -->
							</td>
			  			</tr>
			 			<tr> 
							<td>&nbsp;</td>
			  			</tr>
						</table>
					</td>
		  			<td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
				</tr>
	  			</table>
	  			<table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
				<tr> 
					<td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
		  			<td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
		  			<td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
		  			<td align="right" background="../img/inbox_bottom_big3.gif"><a href="JavaScript:FormImport2.submit();" target="_self"><img src="../img/bt_importar.gif" width="78" height="17" hspace="10" border="0"></a><br></td>
		  			<td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
				</tr>
	  			</table>
			</td>
		</tr>
		</table>
		</form>
	<%
  Case "IMPORTAR"
		If strPREACAO <> "" Then
		  objConn.Execute(strPREACAO)
		End If
		
		strTABELA = GetParam("var_tabela")
		strCAMPOS = GetParam("var_campos")
		strNOMES  = GetParam("var_nomes")

		arrCAMPOS = split(strCAMPOS,"|")
		For k = 0 To UBound(arrCAMPOS)
			ReDim Preserve arrDEFAULT_VALUES(k)
			
			If InStr(1,arrCAMPOS(k),"-") <> 0 Then
				strCAMPO_AUX = Trim(Mid(arrCAMPOS(k),1,InStr(1,arrCAMPOS(k),"-")-1))
			Else
				strCAMPO_AUX = Trim(arrCAMPOS(k))
			End If
			
			strCAMPOS2=GetParam("var_"&strCAMPO_AUX)
			'Response.Write strCAMPOS2
			If strCAMPOS2 <> "" then
				strCAMPOFIM = strCAMPOFIM&Trim(arrCAMPOS(k))&"|"
				strCAMPOS3  = strCAMPOS3&strCAMPOS2&"|"
				strTIPOS    = strTIPOS & GetParam("var_tipo_" & strCAMPO_AUX) & "|"
			End If	
		Next

		arrEXCEL  = Split(strCAMPOS3,"|")
		arrTABELA =	Split(strCAMPOFIM,"|")
		' Response.Write(strCAMPOS3 & "<br>")
		' Response.Write(strCAMPOFIM)
		' Response.End()
		arrTIPOS  = Split(strTIPOS,"|")
		
		On Error Resume Next
		strEXTENSAO = lcase(strreverse( left(strreverse(strARQUIVO),instr(strreverse(strARQUIVO),".")) ))
		'Response.Write("<div align='center'>Formato de arquivo ["&strARQUIVO&"] = ["&strEXTENSAO&"].<br></div>")
		Select Case strEXTENSAO
		  Case ".xls"
		    strCONEXAO = "Provider=MSDASQL;DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)}; DBQ=" & Server.MapPath("../import/") & "\" & strARQUIVO
		  Case Else
		    Response.Write("<div align='center'>Formato de arquivo inválido ["&strEXTENSAO&"].<br> Enviar somente planilha Excel no formato .XLS</div>")
			response.Write("<div align='center'><input type='button' onclick='javascript:history.back();' value='Voltar'></div>")
		    Response.Write(err.Description)	
			Response.End()	  
		End Select


		Set cnnExcel = Server.CreateObject("ADODB.Connection")
		'response.Write("conexao = " & strCONEXAO)
		'response.End()
		cnnExcel.Open strCONEXAO
		
		If err.Number <> 0 Then
		  Response.Write("<div align='center'>Formato de arquivo inválido.<br> Enviar somente planilha Excel no formato .XLS ou .XLSx</div>")
		  'Response.Write(err.Description)
		  Response.End()
		End If
 
  		Set rsXLS = cnnExcel.OpenSchema(20)
		rsXLS.MoveFirst
		strPLANILHA = rsXLS("TABLE_NAME")
		'response.Write(strPLANILHA)
		'Response.End()
 
  		Set rstExcel = Server.CreateObject("ADODB.Recordset")
  		rstExcel.Open "SELECT * FROM [" & strPLANILHA & "]",cnnExcel,adOpenStatic,adLockPessimistic
 
  		'Response.Write "Colunas: <br>"
  		iCols = rstExcel.Fields.Count
		contador_valido = 0
  		If not rstExcel.EOF Then
   			rstExcel.MoveFirst
			Dim strCOD_BARRA
			Dim boolVazio
			
   			While Not rstExcel.EOF
				strVALOR=""
				strCAMPOFIM=""
				boolVazio = true 
				For k=0 to Ubound(arrEXCEL)
					If InStr(1,arrTABELA(k),"-") <> 0 Then
						strCAMPOFIM = strCAMPOFIM & Trim(Mid(arrTABELA(k),1,InStr(1,arrTABELA(k),"-")-1)) & "|"
					Else
						strCAMPOFIM = strCAMPOFIM & Trim(arrTABELA(k)) & "|"
					End If
					
					If InStr(1,arrTABELA(k),"-") = 0 Then
						For I = 0 To iCols-1
							If Trim(rstExcel.Fields.Item(I).Name) = arrEXCEL(K) Then
							
								If rstExcel.Fields.Item(I).Value&"" <> "" Then
									boolVazio = false
								End If
								
								strVALOR =strVALOR&tipoCAMPO(rstExcel.Fields.Item(I).Value, arrTIPOS(k))&"|"
							End If
						Next
					Else
						strVALOR_AUX = Trim(Mid(arrTABELA(k),InStr(1,arrTABELA(k),"-")+1))
						strVALOR = strVALOR&tipoCAMPO(strVALOR_AUX, arrTIPOS(k))&"|"
					End If
				Next
				 
		 		If GravaCadastro(Mid(strCAMPOFIM,1,Len(strCAMPOFIM)-1), strVALOR) And Not boolVazio Then 
					contador_valido = contador_valido + 1
				End If
				
				contador = contador + 1
	 			rstExcel.MoveNext
				If contador mod 100 = 0 Then
				  If strURL = "" Then
					Response.Write("<br>*** " & contador & " ***<br><br>")
				  End If
				  Response.Flush()
				End If
   			Wend
		End If
		rstExcel.Close
	
	Set rstExcel = Nothing
  	cnnExcel.Close
  	Set cnnExcel = Nothing
	
	If strURL = "" Then
		Response.Write("<br><br>*** TOTAL = " & contador & " VALIDOS = " & contador_valido & "***<br><br>")
		%>
        <script language="javascript">
		alert('TOTAL REGISTROS = <%= contador %> \nREGISTROS VALIDOS = <%= contador_valido %>');
		</script>
        <%
	End If
	
  	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
  	'objFSO.MoveFile Server.MapPath("../import") & "\" & strARQUIVO, Server.MapPath("../import") & "\_"&year(now)&month(now)&day(now)&"_"&hour(now)&minute(now)&"_"&strARQUIVO
  	set objFSO = Nothing
	
	If strURL <> "" Then
		Dim arrURL
		
		arrURL = Split(strURL,"?")
		
		If UBound(arrURL) > 0 Then
			strURL = arrURL(0) & "?var_qtde_total=" & contador & "&var_qtde_validos=" & contador_valido 
			strURL = strURL & "&" & arrURL(1)
		End If
		
		%><script language="javascript">location.href="<%=strURL%>"</script><%
	End If 
%>
  	<script language="javascript">
	self.opener.ifrm_visitante.RefreshIframe();
	<%
	If strERRO = "" Then
	%>
    window.close();
	<%
	End If
	%>
  	</script>
	<%
	
  Case "UPLOAD"
		strTABELA = GetParam("var_tabela")
		strCAMPOS = GetParam("var_campos")
		strNOMES  = GetParam("var_nomes")
	  	'strSQL = "SELECT COD_EMPRESA, NOMECLI FROM TBL_EMPRESAS WHERE COD_EMPRESA = '" & strCOD_EMPRESA & "' AND SYS_INATIVO IS NULL" 
	  'Set objRS = objConn.Execute(strSQL)
	  'If not objRS.EOF Then
	%>
	<script type="text/javascript">
		function submeterForm() {
			if(document.FormImport.var_ARQUIVO.value != "") {
				document.FormImport.submit();
			} else {
				alert("Por favor, selecione um arquivo para fazer o upload");
			}
		}
	</script>
	<form name="FormImport" id="FormImport" action="startup_importexcel.asp" method="post">
	  <input type="hidden" name="var_acao" value="PREPARAR">
	  <input type="hidden" name="var_label" value="<%=strLABEL%>">
	  <input type="hidden" name="var_url" value="<%=strURL%>">
      <input type="hidden" name="var_preacao" value="<%=strPREACAO%>">
	<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr> 
	<td align="center" valign="middle">
	  <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr> 
		  <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
		  <td width="492" height="4"><img src="../img/inbox_top_blue.gif" width="492" height="4"></td>
		  <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
		</tr>
	  </table>
	  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
		<tr> 
		  <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
		  <td width="492"><table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="texto_corpo_mdo">
			  <tr> 
				<td bgcolor="#808080" class="texto_contraste_mdo">&nbsp;&nbsp;<%=strLABEL%></td>
			  </tr>
			  <tr> 
				<td height="16" align="center">&nbsp;</td>
			  </tr>
			  <tr> 
				<td align="center">
				<!-- ------------------------------- -->
				<table width="450" border="0" cellpadding="0" cellspacing="0" class="texto_corpo_mdo">
				  
				  <tr><td colspan="2" height="10"></td></tr>
				  	<%
						If strTABELA = "" Then
							dim objRS2
							strSQL="show tables "
							set objRS2 = Server.CreateObject("ADODB.Recordset")
							objRS2.Open strSQL, objConn
					%>	
				  <tr>
  				 	<td nowrap="nowrap">*Tabela para importação:&nbsp;</td>
				  	<td>
						<select name="var_tabela" id="var_tabela" class="textbox180">
					 		<option value="" selected>Selecione a tabela...</option>
							<%
							while not objRS2.EOF
								Response.Write("<option value="&objRS2("tables_in_"&CFG_DB_DADOS)&">"&objRS2("tables_in_"&CFG_DB_DADOS)&"</option>")
								objRS2.Movenext
							Wend
							%>
						</select>
					</td>
				 </tr>
					<%
						Else
							Response.Write("<input type=""hidden"" name=""var_tabela"" value=""" & strTABELA & """>")
							Response.Write("<input type=""hidden"" name=""var_campos"" value=""" & strCAMPOS & """>")
							Response.Write("<input type=""hidden"" name=""var_nomes""  value=""" & strNOMES & """>")
						End If
					%>
				  <tr><td colspan="2" height="10"></td></tr>
				  <tr> 
					<td width="100" align="right">*Arquivo:&nbsp;</td>
					<td width="350">
					<% If strPERMISSION = "SU" Then %>
					<select name="var_ARQUIVO" id="var_ARQUIVO" class="textbox250">
					 <option value="" selected>Selecione o arquivo...</option>
					 <%  
					  strPath = "." 'Tem que terminar com barra
					  Set objFSO    = Server.CreateObject("Scripting.FileSystemObject")
					  Set objFolder = objFSO.GetFolder(Server.MapPath(strPath))
					  For Each objItem In objFolder.Files
						  If (InStr(lcase(objItem.Name),".xls") > 0) and ( left(objItem.Name,1) <> "_" ) Then
							%> <option value="<%=objItem.Name%>"><%=objItem.Name%></option> <%
						  End If
					  Next 
					  Set objItem   = Nothing
					  Set objFolder = Nothing
					  Set objFSO    = Nothing
					  %>
					  </select>	
					  <input type="hidden" name="var_tmp" id="var_tmp" value="" onChange="javascript:document.location.reload();">
					  <a href="javascript:UploadImage('FormImport','var_tmp','//import//');">
						<img src="../IMG/bt_upload.gif" width="78" height="17" hspace="5" border="0" align="absmiddle">
					  </a>
					  <% Else %>
					  <input type="text" name="var_ARQUIVO" id="var_ARQUIVO" class="textbox250" readonly>
					  <a href="javascript:UploadImage('FormImport','var_ARQUIVO','//import//');">
						<img src="../IMG/bt_upload.gif" width="78" height="17" hspace="5" border="0" align="absmiddle">
					  </a>
					  <%End If%>
					  
					  </td>
				  </tr>
				  <tr><td colspan="2" height="15"></td></tr>
				  <tr><td colspan="2" height="10"></td></tr>
				</table>
				<!-- ------------------------------- -->
				</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
			  </tr>
			</table></td>
		  <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
		</tr>
	  </table>
	  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr> 
		  <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
		  <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
		  <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
		  <td align="right" background="../img/inbox_bottom_big3.gif"><a href="JavaScript:FormImport.submit();" target="_self"><img src="../img/bt_importar.gif" width="78" height="17" hspace="10" border="0"></a><br></td>
		  <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
		</tr>
	  </table>
	</td>
	</tr>
	</table>
	</form>

<%	
	
  Case Else
%>

<div class="arial12">
<p align="center"><strong>INSTRU&Ccedil;&Otilde;ES PARA IMPORTA&Ccedil;&Atilde;O - <%=strEV_NOME%></strong></p>
<p><strong>Passo 1</strong> &ndash; Verifique se a Planilha Excel (.XLS - vers&atilde;o Excel 97-2003) a ser importada segue o modelo espec&iacute;fico para importa&ccedil;&atilde;o (<a href="MODELO_IMPORTACAO_<%=ucase(CFG_IDCLIENTE)%>.xls" class="arial12Bold"><u>clique aqui para baixar o modelo</u></a>).</p>
<p>
a)&nbsp;&nbsp; Nome da Planilha (aba &ndash; inferior da          p&aacute;gina) deve permanecer Plan1;<br>
b)&nbsp;&nbsp; Os n&uacute;meros de CPF/CNPJ n&atilde;o pode conter          pontos e tra&ccedil;os;<br>
c)&nbsp;&nbsp;&nbsp; A primeira linha sempre deve          constar o nome espec&iacute;fico dos dados de cada coluna &ndash; CPF/CNPJ, NOME,          CATEGORIA, E-MAIL;<br>
d)&nbsp;&nbsp; Altere os dados da coluna CATEGORIA          para o c&oacute;digo da categoria no sistema ProEvento:<br>
</p>
<div style="background-color:#CCC; padding:10px;">
CATEGORIAS<br><br>
<%
strSQL = "SELECT COD_STATUS_PRECO, STATUS FROM TBL_STATUS_PRECO WHERE COD_EVENTO = " & strCOD_EVENTO & " ORDER BY STATUS"
Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
	Do While not objRS.EOF 
	%>
	<li><%=objRS("STATUS")%> - <b>Cod.: <%=objRS("COD_STATUS_PRECO")%></b><br>
	<%
	  objRS.MoveNext
	Loop
Else
%>
  - Nenhuma catetoria cadastrada para este evento.<br>
<%
End If
FechaRecordSet objRS
%>
</div>
<p><strong>Passo 2</strong> &ndash;          Clique no &iacute;cone de importa&ccedil;&atilde;o logo abaixo;</p>
<p><strong>Passo 3</strong> &ndash;          Clique em UPLOAD, escolha o arquivo em seu computador e clique          em ENVIAR. Aguarde at&eacute; que a barra de carregamento do arquivo          seja preenchida e o aviso de upload completo apare&ccedil;a na pop-up;</p>
<p><strong>Passo 4</strong> &ndash;          Feche a pop-up e clique em IMPORTAR;<br>
  <br>
  <strong> Passo 5</strong> - Relacione os nomes dos campos nos respectivos combos            e clique em IMPORTAR; </p>
<p><strong>Passo 6</strong> &ndash;          Aguarde algum tempo at&eacute; que o box de mensagem informando a          quantidade de registros importados apare&ccedil;a. N&atilde;o feche a janela          antes que este aviso seja mostrado. Compare com sua planilha          para ver se a quantidade importada e informada na mensagem &eacute; a          mesma.</p>
<p><u>IMPORTANTE</u> &ndash; Cada nova importa&ccedil;&atilde;o, a lista          anterior &eacute; apagada, valendo sempre a &uacute;ltima importa&ccedil;&atilde;o.<br>
</p>
<hr>
<div align="center">
Escolha o evento e clique no icone abaixo para iniciar o processo de importação de dados.<br />
<br />
<form name="formimport" action="startup_importexcel.asp" method="post">
  <input type="hidden" name="var_acao" value="UPLOAD">
            <select name="var_cod_evento" onChange="document.location='startup_importexcel.asp?cod_evento='+this.value;" style="width:240px;">
				<%
                	strSQL = "SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR),' - ',NOME) AS CNOME FROM TBL_EVENTO WHERE SYS_INATIVO IS NULL ORDER BY DT_INICIO DESC"
                	MontaCombo strSQL, "COD_EVENTO", "CNOME", strCOD_EVENTO
                %>
            </select>
			<input type="hidden" name="var_tabela"  value="tbl_empresas_startup">
			<input type="hidden" name="var_campos"  value="cod_evento - <%=strCOD_EVENTO%>, id_num_doc1, nome, descricao, cod_status_preco, email">
            <input type="hidden" name="var_nomes"   value="<%=Server.HTMLEncode("Cod.Evento,CPF/CNPJ,Nome,Descricao,Categoria,E-mail")%>">
			<input type="hidden" name="var_label"   value="<%=Server.HTMLEncode("Importar Status Cadastral "& ucase(CFG_IDCLIENTE) ) %>">
			<input type="hidden" name="var_url"     value="">
   			<input type="hidden" name="var_preacao" value="delete from tbl_empresas_startup where cod_evento = <%=strCOD_EVENTO%>">
</form><br>
<a onClick="javascript:importar();" href="#">
  <img src='../img/ico_excel.gif' alt='Importar p/ STARTUP (<%=ucase(CFG_IDCLIENTE)%>) do Excel'  border='0' title='Importar p/ STARTUP'>
</a>
</div>
<%
End Select
%>
</body>
</html>
<%
FechaDBConn objConn
%>