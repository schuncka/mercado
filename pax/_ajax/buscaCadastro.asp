<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../../_database/adovbs.inc"-->
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/athDbConn.asp"--> 
<!--#include file="../../_database/athUtils.asp"-->
<!--#include file="../../_database/athSendMail.asp"--> 
<%
Dim strCOD_EVENTO, strDado, strCodEmpresa,strReturn,strCodPaperCadastro
Dim objConn, objRS, strSQL

strDado = Request("var_dado")
strCodEmpresa = Request("var_cod_empresa")
strCodPaperCadastro = Request("var_cod_paper_cadastro")



If strDado = "" Then
%>
<form name="formwebservice" action="buscaCadastro.asp" method="post" > 
  CPF/EMAIL: <input type="text" name="var_dado" value=""  /><br>
  COD_EMPRESA AUTOR: <input type="text" name="var_cod_empresa" value=""  />
  <input type="submit" name="butsend" id="butsend" value="Pesquisar">
</form>
<%
Else

    AbreDBConn objConn, CFG_DB_DADOS

	If strDado <> "" Then	 
	  strSQL =          "  SELECT	                                                 "
 	  strSQL = strSQL & "      cod_empresa                                           "
 	  strSQL = strSQL & "      , nomecli                                             "
 	  strSQL = strSQL & " FROM tbl_empresas                                          " 	  
 	  strSQL = strSQL & " WHERE                                                      "	  
		strSQL = strSQL & " cod_empresa NOT IN (select cod_empresa from tbl_paper_autores where cod_paper_cadastro = " & strCodPaperCadastro & ")"
		strSQL = strSQL & " AND sys_inativo is null and( (id_num_doc1 LIKE '"& strDado & "') "
	  
		strSQL = strSQL & " OR ( (upper(email1) LIKE upper('"& strDado & "')) OR (upper(email2) LIKE upper('"& strDado & "')) OR (upper(NOMECLI) Like '%" & ucase(strDado) & "%') )  )"

	  'response.write(strSQL)
	  Set objRS = objConn.Execute(strSQL)
	  If not objRS.EOF  Then
			Do While not objRS.EOF
				strReturn = strReturn & objRS("cod_empresa")&"|"&objRS("nomecli") & ","			
				objRS.movenext
				
			Loop
			strReturn = left(strReturn,(len(strReturn)-1))
			response.write(strReturn)
	  Else 
		  response.Write("err|Registro N&atilde;o Encontrado")
	  End If
	  FechaRecordSet objRS	
	End If
	
FechaDBConn objConn	  

End If
%>