<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<%
Response.Expires = 0
Server.ScriptTimeout = 2400
%>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athutils.asp"--> 
<%
Function tipoCAMPO(strCAMPO,strTIPO,strUPPER)


	Select case Int(strTIPO)
		Case  3, 19 :'Inteiro

				if strCAMPO <>"" And IsNumeric(strCAMPO) Then
					tipoCAMPO = clng(strCAMPO)
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
				    If strUPPER = "S" Then
					  strCAMPO = UCase(strCAMPO)
					End If
					tipoCAMPO = "'"&Replace(Trim(strCAMPO),"'","''")&"'"
				else
					tipoCAMPO = "NULL"
				End If		
	End Select	
	
End Function

Response.Buffer = True		
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
</head>
<script language="JavaScript">
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
	document.location.reload();
  }
} 
</script>
<body bgcolor="#FFFFFF">
<%
' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro(CAMPOS, VALORES)

strCOLUNAS = Left(Replace(CAMPOS,"|",","), len(CAMPOS)-1)
strLINHAS  = Left(Replace(VALORES,"|",","), len(VALORES)-1)

  On Error Resume Next

	strSQL = "INSERT INTO "&strTABELA&" ("&strCOLUNAS&") VALUES ("&strLINHAS&")"
	'Response.Write(strSQL & "<BR><BR>")
	objConn.Execute(strSQL)

 If Err.Number <> 0 Then
   Response.Write("<li>Erro: <b>" & strLINHAS & "</b> (" & err.Description & ")<BR>")
   strERRO = strERRO & "<li>Erro: <b>" & strLINHAS & "</b> (" & err.Description & ")<BR>"
   conterro = conterro + 1
 Else 
   Response.Write("<li>Sucesso: <b>" & strLINHAS & "</b><BR>")
   contsucesso = contsucesso + 1
 End If

End Sub
'=============================================================================
  Dim objConn, objRS, strSQL
  Dim objFSO, strPath, objFolder, objItem, CAMPOS, VALORES, strLINHAS
  Dim bolAlreadyExists, strHyperLink, strMensagem 
  Dim strARQUIVO, strERRO
  Const adOpenStatic = 3
  Const adLockPessimistic = 2
  Dim cnnExcel
  Dim rstExcel, strCAMPOS, strACAO, strCAMPOS2, strCAMPOFIM, strCOLUNAS, arrCOLUNAS, n, arrCAMPOS, k, strCAMPOS3, strTIPOS, arrEXCEL, arrTABELA, arrTIPOS, strVALOR , strUPPER, arrUPPER
  Dim I, contador
  Dim iCols
  Dim conterro, contsucesso
  Dim strTABELA, strCONEXAO
  
  conterro = 0
  contsucesso = 0
  
  AbreDBConn objConn, CFG_DB_DADOS

  strARQUIVO = Request.Form("var_ARQUIVO")
  strACAO = Cstr(Request.Form("var_acao"))
  strTABELA = Request.Form("var_tabela")

  contador = 0
Select Case Cstr(strACAO)
	Case "IMPORT" :
		strTABELA = Request.Form("var_tabela")
		strCAMPOS = Request.Form("var_campos")
		'Response.Write(strCAMPOS)
		'Response.End()
		arrCAMPOS = split(strCAMPOS,"|")
		for k=0 to ubound(arrCAMPOS)-1
			strCAMPOS2=Request.Form("var_"&arrCAMPOS(k))
			If strCAMPOS2<>"" then
				strCAMPOFIM=strCAMPOFIM&arrCAMPOS(k)&"|"
				strCAMPOS3=strCAMPOS3&strCAMPOS2&"|"
				strTIPOS = strTIPOS&Request.Form("var_tipo_"&arrCAMPOS(k))&"|"
				strUPPER = strUPPER&Request.Form("var_upper_"&arrCAMPOS(k))&"|"
			End If	
		Next

		arrEXCEL  = Split(strCAMPOS3,"|")
		arrTABELA =	Split(strCAMPOFIM,"|")
		arrTIPOS  = Split(strTIPOS,"|")
		arrUPPER  = Split(strUPPER,"|")
		
		Set cnnExcel = Server.CreateObject("ADODB.Connection")
  		'cnnExcel.Open "DRIVER={Microsoft Excel Driver (*.xls)}; DBQ=" & Server.MapPath(".") & "\" & strARQUIVO
		strCONEXAO = "Provider=MSDASQL;DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)}; DBQ=" & Server.MapPath("../import/") & "\" & strARQUIVO
		cnnExcel.Open strCONEXAO
 
  		Set rstExcel = Server.CreateObject("ADODB.Recordset")
  		rstExcel.Open "SELECT * FROM [PLAN1$]",cnnExcel,adOpenStatic,adLockPessimistic
 
  		'Response.Write "Colunas: <br>"
  		iCols = rstExcel.Fields.Count
		
		Response.Write "Colunas: " & iCols & "<br>"
		Response.Write "Linhas: " & rstExcel.RecordCount & "<br>"

  		If not rstExcel.EOF Then
   			rstExcel.MoveFirst
   			While Not rstExcel.EOF
				strVALOR=""
				For k=0 to Ubound(arrEXCEL)-1
		      		For I = 0 To iCols - 1
		    			If Trim(rstExcel.Fields.Item(I).Name) = arrEXCEL(K) Then
		  					strVALOR =strVALOR&tipoCAMPO(rstExcel.Fields.Item(I).Value, arrTIPOS(k), arrUPPER(k))&"|"
						End If
	     			Next
				 Next
		 		GravaCadastro strCAMPOFIM, strVALOR
				'Response.Write("** -> " & strCAMPOFIM & " - " & strVALOR & "<BR>")
				contador = contador + 1
	 			rstExcel.MoveNext
				If contador mod 100 = 0 Then
				  Response.Write("<br>*** " & contador & " ***<br><br>")
				  Response.Flush()
				End If
   			Wend
		End If
		rstExcel.Close
	
	Set rstExcel = Nothing
  	cnnExcel.Close
  	Set cnnExcel = Nothing
 
	Response.Write("<br><br>*** Erro(s) = " & conterro & " ***<br><br>")
	Response.Write("<br><br>*** Sucesso(s) = " & contsucesso & " ***<br><br>")
	Response.Write("<br><br>*** TOTAL = " & contador & " ***<br><br>")
%>
	<form name="FormNova" action="importexcel.asp" method="post">
	  <input type="hidden" name="var_tabela" value="<%=strTABELA%>">
      <div align="center">
      <input type="button" name="btNova" value="Nova importação" onClick="document.FormNova.submit();">
      </div>
    </form>
<%
				  
  	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
  	objFSO.MoveFile Server.MapPath(".") & "\" & strARQUIVO, Server.MapPath(".") & "\_"&year(now)&month(now)&day(now)&"_"&hour(now)&minute(now)&"_"&strARQUIVO
  	set objFSO = Nothing

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
	
	Case "PREPARA":
		
		strTABELA=Request.Form("var_tabela")
		
	  	'strSQL = "SELECT COD_EMPRESA, NOMECLI FROM TBL_EMPRESAS WHERE COD_EMPRESA = '" & strCOD_EMPRESA & "' AND SYS_INATIVO IS NULL" 
	  	'Set objRS = objConn.Execute(strSQL)

		Set cnnExcel = Server.CreateObject("ADODB.Connection")
  		'cnnExcel.Open "DRIVER={Microsoft Excel Driver (*.xls)}; DBQ=" & Server.MapPath(".") & "\" & strARQUIVO
		strCONEXAO = "Provider=MSDASQL;DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)}; DBQ=" & Server.MapPath("../import/") & "\" & strARQUIVO
		cnnExcel.Open strCONEXAO
 
  		Set rstExcel = Server.CreateObject("ADODB.Recordset")
  		rstExcel.Open "SELECT * FROM [PLAN1$]",cnnExcel,adOpenStatic,adLockPessimistic
 
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
		<form name="FormImport2" action="importexcel.asp" method="post">
	  	<input type="hidden" name="var_acao" value="IMPORT">
	  	<input type="hidden" name="var_ARQUIVO" value="<%=strARQUIVO%>">
		<input type="hidden" name="var_tabela" value="<%=strTABELA%>">
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
					<td bgcolor="#808080" class="texto_contraste_mdo">&nbsp;&nbsp;Importação de Arquivos</td>
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
				  			<!--tr>
								<td align="right">C&oacute;digo:&nbsp;</td>
								<td><b><%'=objRS("COD_EMPRESA")%></b></td>
				  			</tr>
				  			<tr>
								<td align="right">Empresa:&nbsp;</td>
								<td><b><%'=objRS("NOMECLI")%></b></td>
				  			</tr-->
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
							strSQL="SELECT * FROM "&strTABELA

							set objRS2 = Server.CreateObject("ADODB.Recordset")
							objRS2.Open strSQL, objConn

							For i = 0 to objRS2.fields.count - 1
								strCAMPOS=strCAMPOS&objRS2.Fields(i).Name&"|"
								
										
							%>
				  			<tr> 
								<td align="right"><%=objRS2.Fields(i).Name%>:&nbsp;</td>
								<td>
								<input type="hidden" name="var_tipo_<%=objRS2.Fields(i).Name%>" value="<%=objRS2.Fields(i).type%>">
								<select name="var_<%=objRS2.Fields(i).Name%>" class="textbox180">
								
									<option value="" selected>Selecione o campo</option>
									<%
										for n=0 to Ubound(arrCOLUNAS)
									%>
										<option value="<%=arrCOLUNAS(n)%>" <% If UCase(objRS2.Fields(i).Name) = UCase(arrCOLUNAS(n)) Then Response.Write("selected") End If %>><%=arrCOLUNAS(n)%></option>
									<%
										Next
									%>	
								</select>
                                <%
								If objRS2.Fields(i).type = 200 or  objRS2.Fields(i).type = 202 or objRS2.Fields(i).type = 203 Then
								%>
                                <input type="checkbox" name="var_upper_<%=objRS2.Fields(i).Name%>" value="S" checked> Maiúsculo
                                <%
								Else
								%>
                                <input type="hidden" name="var_upper_<%=objRS2.Fields(i).Name%>" value="">
                                <%
								End If
								%>
								</td>
				  			</tr>
							<%
							Next
							%>
							<input type="hidden" name="var_campos" value="<%=strCAMPOS%>">
								<tr>
									<td colspan="2" height="15"></td>
								</tr>
								<tr>
									<td colspan="2" height="10"></td>
								</tr>
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
	
	Case Else :
	
	  	'strSQL = "SELECT COD_EMPRESA, NOMECLI FROM TBL_EMPRESAS WHERE COD_EMPRESA = '" & strCOD_EMPRESA & "' AND SYS_INATIVO IS NULL" 
	  'Set objRS = objConn.Execute(strSQL)
	  'If not objRS.EOF Then
	%>
	<form name="FormImport" action="importexcel.asp" method="post">
	  <input type="hidden" name="var_acao" value="PREPARA">
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
				<td bgcolor="#808080" class="texto_contraste_mdo">&nbsp;&nbsp;Importação de Arquivos</td>
			  </tr>
			  <tr> 
				<td height="16" align="center">&nbsp;</td>
			  </tr>
			  <tr> 
				<td align="center">
				<!-- ------------------------------- -->
				<table width="450" border="0" cellpadding="0" cellspacing="0" class="texto_corpo_mdo">
				  
				  <tr><td colspan="2" height="10"></td></tr>
				  <!--tr>
					<td align="right">C&oacute;digo:&nbsp;</td>
					<td><b><%'=objRS("COD_EMPRESA")%></b></td>
				  </tr>
				  <tr>
					<td align="right">Empresa:&nbsp;</td>
					<td><b><%'=objRS("NOMECLI")%></b></td>
				  </tr-->
				  
				  <tr>
  				 	<td nowrap="nowrap">*Tabela para importação:&nbsp;</td>

				  	<%
					dim objRS2
				  		strSQL="show tables "
						set objRS2 = Server.CreateObject("ADODB.Recordset")
						objRS2.Open strSQL, objConn
					%>	
				  	<td>
						<select name="var_tabela" class="textbox180">
					 		<option value="" selected>Selecione a tabela...</option>
							<%
							
							while not objRS2.EOF

								Response.Write("<option value="&objRS2("tables_in_"&CFG_DB_DADOS)&" ")
								If strTABELA = objRS2("tables_in_"&CFG_DB_DADOS)&"" Then
								  Response.Write("selected")
								End If
								Response.Write(">"&objRS2("tables_in_"&CFG_DB_DADOS)&"</option>")
							
								objRS2.Movenext
							Wend
							%>
						</select>
					</td>
				 </tr>

				  <tr><td colspan="2" height="10"></td></tr>
				  <tr>
					<td colspan="2" align="center">
					  <input type="hidden" name="var_tmp" id="var_tmp" value="" onChange="javascript:document.location.reload();">
					  <a href="javascript:UploadImage('FormImport','var_tmp','//import//');">
					  <img src="../IMG/bt_upload.gif" width="78" height="17" hspace="5" border="0" align="absmiddle"></a>			    </td>
				  </tr>
				  <tr><td colspan="2" height="10"></td></tr>
				  <tr> 
					<td width="100" align="right">*Arquivo:&nbsp;</td>
					<td width="350">
					<select name="var_ARQUIVO" class="textbox250">
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
	'End If 
End Select

FechaDBConn ObjConn

Response.Flush()
%>
</body>
</html>