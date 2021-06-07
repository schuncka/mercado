<!--#include file="./_database/athdbConnCS.asp"-->
<!--#include file="./_database/athUtilsCS.asp"--> 
<%
 'Response.Buffer = True
 
 Dim objUpload,  strFUNC , strFORMNAME, strFIELDNAME, strFILE
 Dim strEXTENSAO, strEXT_ACAO, strMAXBYTES
 Dim FileName, strErr, strID_FILE, strDIR_UPLOAD
 Dim strDundas

 strErr			= GetParam("err")
 FileName		= GetParam("f")
 strID_FILE 	= GetParam("id_file")
 strDIR_UPLOAD	= GetParam("var_dir")
 strFORMNAME	= GetParam("var_formname")	
 strFIELDNAME	= GetParam("var_fieldname")

 strEXTENSAO	= GetParam("var_ext")
 strEXT_ACAO	= GetParam("var_ext_acao") 'ALLOW ou DENY
 strMAXBYTES	= GetParam("maxbytes")
	
 strFUNC 		= GetParam("var_func")

 If IsEmpty(strFUNC) Then
	strFUNC = 1
 End If

 'DEBUG
 'response.write ("[" & strDIR_UPLOAD & "]")
 'response.write ("[" & strID_FILE & "]")
 'response.write ("[" & strFIELDNAME & "]")
 '[//subpaper//upload//][700078_10_][var_campo_sub_452ô]
 'response.end 
  
 ' Código para bloquear temporariamente o upload generico de arquivos => strFUNC = 666
%>
<html>
<head>
 <title>pVISTA.uploader</title>
 <!--#include file="metacssjs_root.inc"--> 
 <script src="./_scripts/scriptsCS.js"></script>
 <style>
    .indent { height: 40px; }
 </style>
 <script language="JavaScript">
	function SetParentField () {
		//alert ("Debug - CALL [self.opener.SetFormField('<%=strFORMNAME%>','<%=strFIELDNAME%>','<%=FileName%>')]");
		self.opener.SetFormField('<%=strFORMNAME%>','<%=strFIELDNAME%>','<%=FileName%>');
		window.close();
	}
 </script>
</head>
<body class='metro'>
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class='bg-dark fg-white' style='width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;'>
   UPLOADER&nbsp;<sup><span style='font-size:12px;'>FILES</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class='container padding20'>
    <div class='padding20 border'>
        <div class='grid' style='border:0px solid #F00'>  
            <div class='row'>
                    <div class='span2'><p></p></div>
                    <div class='span8'>
                            <%
                                Select Case strFUNC
                                    Case 666 	response.write ("<script language='JavaScript'>")
                                                response.write ("  alert('Upload indisponível no momento.');")
                                                response.write ("  window.close();")
                                                response.write ("</script>")
                            
                                    Case 1		strDundas = "athUploader_DUNDAS.asp?var_formname=" & strFORMNAME & "&var_fieldname=" & strFIELDNAME & "&var_dir=" & strDIR_UPLOAD
												strDundas = strDundas & "&id_file=" & strID_FILE & "&var_ext=" & strEXTENSAO & "&var_ext_acao=" & strEXT_ACAO & "&maxbytes=" & strMAXBYTES
												response.write ("<form name='formupload' action='" & strDundas & "' method='POST' enctype='multipart/form-data'> " & vbnewline)
                                                response.write ("  <p class='input-control ' data-role='input-control'> " & vbnewline)
                                                response.write ("     <input type='file' id='file1' name='file1'> " & vbnewline)
                                                response.write ("  </p> " & vbnewline)
                                                response.write ("</form> " & vbnewline)
                            
                                    Case 2		If strErr <> "" Then
                                                    response.write ("<p>Ocorreu um erro ao tentar enviar o seu arquivo! <br>(An error has occurred - " & strErr & ") </p> ")
                                                Else
                                                    response.write ("<p>Upload [" & FileName & "]<br><br><b><font color='red'>ATENÇÃO!</font> O upload ainda não foi finalizado! Clique <font color='red'>OK</font> para concluir!")
	                                            End If
                                End Select
                            %>
                    </div>
            </div><!-- row //-->
        </div><!-- grid //-->
    </div><!-- div frame //-->

    <div style='padding-top:16px;'><!--INI: BOTÕES/MENSAGENS//-->
        <div style='float:left'>
	       	<%
			Select Case strFUNC
				Case 1  response.write ("<input id='butok' class='primary' type='button' value='Ok' onClick='formupload.submit(); return false;'>")
				Case 2  If strErr = "" Then
							response.write ("<input id='butok' class='primary' type='button' value='OK' onClick='SetParentField(); return false;'>")
                            %>
                            <script language="javascript">
                                SetParentField(); 
                                

                            </script>
                            <%
						End If
			End Select
			%>
            <input id='butcancel'  type='button'  value='CANCEL'  onClick='window.close();'>
        </div>
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
    
</div><!-- container //-->          

</body>
</html>