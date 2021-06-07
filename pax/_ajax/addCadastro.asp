<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../../_database/adovbs.inc"-->
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/athDbConn.asp"--> 
<!--#include file="../../_database/athUtils.asp"-->
<!--#include file="../../_database/athSendMail.asp"--> 
<%
Dim strCOD_EVENTO, strDado, strCodEmpresa,strReturn, strCodPaperCadastro
Dim objConn, objRS, strSQL

strCodPaperCadastro = Request("var_cod_paper_cadastro")
strCodEmpresa       = Request("var_cod_empresa")


	
    AbreDBConn objConn, CFG_DB_DADOS

	If strCodPaperCadastro <> "" Then	 
	  strSQL =          "  insert into tbl_paper_autores (cod_paper_cadastro, cod_empresa)"
 	  strSQL = strSQL & "  values(" & strCodPaperCadastro & ",'" & strCodEmpresa & "')"	  
	  objConn.Execute(strSQL)
	 ' response.write("inserido")
	   
	  strSQL =  "Select cod_paper_autor, cod_paper_cadastro, (select nomecli from tbl_empresas where cod_empresa = t1.cod_empresa) as nome, cod_empresa, funcao "
	  strSQL = strSQL & " From tbl_paper_autores t1 where cod_paper_cadastro = " & strCodPaperCadastro
	  
	  
	  Set objRS = objConn.Execute(strSQL)
	  If not objRS.EOF  Then
			Do While not objRS.EOF
				strReturn = strReturn & objRS("cod_paper_autor") & "|" & objRS("cod_paper_cadastro")&"|"&objRS("nome") & "|"& objRS("cod_empresa") & "|" & objRS("funcao") & ","			
				objRS.movenext				
			Loop
			strReturn = left(strReturn,(len(strReturn)-1))
			response.write(strReturn)
	  Else 
		  response.Write("err|Registro N&atilde;o Encontrado")
	  End If
	  FechaRecordSet objRS
	  
	  
	  
	'else
	'response.Write("invalida")
	End If
	
FechaDBConn objConn	  

'End If
%>