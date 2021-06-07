<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="_database/adovbs.inc"-->
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<!--#include file="_database/athUtils.asp"-->
<%
 Server.ScriptTimeout = 24000
 Response.Buffer = True
 
 Dim objConn, ObjRS, objRSDetail, objRSNextNumber
 Dim strSQL, strvalor, cont, strCODBARRA, strCOD_EMPRESA, strENTIDADE_CNPJ, strID_USER
 Dim icodempresa

 strCOD_EMPRESA = Request("cod_empresa")
 
 strID_USER = Session("ID_USER")
 
 If Request("iduser") <> "" Then
   strID_USER = Request("iduser")
 End If 
 
 If strID_USER = "" then
   response.Write "Você precisa estar logado no sistema."
   response.End
 End If
 
 If strCOD_EMPRESA = "" then
   response.Write "Informe o código de uma empresa."
   response.End
 End If
 
 cont = 0
 
 Response.Write "*** Start - " & now() & "<BR><BR>"
 Response.Flush()
 
 AbreDBConn objConn, CFG_DB_DADOS 


 Response.Write "*** Cleaning... " & "<BR><BR>"
 Response.Flush()
 
 'apagar todos cadastros inativos
 strSQL = "delete from tbl_empresas where sys_inativo is not null"
 objConn.Execute(strSQL) 

 'apagar todos contatos sem referencia com cadastros
 strSQL = "delete from tbl_empresas_sub where cod_empresa not in ( select cod_empresa from tbl_empresas ) "
 objConn.Execute(strSQL) 

 strSQL = "UPDATE tbl_empresas_sub SET id_cpf = replace(replace(replace(replace(id_cpf,' ',''),'''',''),'.',''),'-','')"
 objConn.Execute(strSQL) 
 
 strSQL = "UPDATE tbl_empresas SET id_num_doc1 = replace(replace(replace(replace(id_num_doc1,' ',''),'''',''),'.',''),'-','')"
 objConn.Execute(strSQL) 

 
 Response.Write "*** Processing... " & "<BR><BR>"
 Response.Flush()
 
 strSQL = " SELECT es.*"
 strSQL = strSQL & ",e.NOMECLI as E_ENTIDADE"
 strSQL = strSQL & ",e.ID_NUM_DOC1 as E_ENTIDADE_CNPJ"
 strSQL = strSQL & ",e.NOMEFAN as E_ENTIDADE_FANTASIA"
 strSQL = strSQL & ",e.EMAIL1 as E_ENTIDADE_EMAIL"
 strSQL = strSQL & ",e.FONE4 as E_ENTIDADE_FONE"
 strSQL = strSQL & ",e.END_PAIS as E_END_PAIS"
 strSQL = strSQL & ",e.CODATIV1 as E_CODATIV1"
 strSQL = strSQL & ",e.COD_STATUS_CRED as E_COD_STATUS_CRED"
 strSQL = strSQL & ",e.COD_STATUS_PRECO as E_COD_STATUS_PRECO"
 strSQL = strSQL & " FROM tbl_empresas_sub es inner join tbl_empresas e on es.cod_empresa = e.cod_Empresa"
 'strSQL = strSQL & " AND es.ID_CPF IS NOT NULL AND trim(es.ID_CPF) <> ''"
 If strCOD_EMPRESA <> "" and strCOD_EMPRESA <> "999999" Then
   strSQL = strSQL & " AND e.COD_EMPRESA = '" & strCOD_EMPRESA & "'"
 End If
 'strSQL = strSQL & " AND e.COD_EMPRESA BETWEEN 100000 and 900000" 
 strSQL = strSQL & " ORDER BY COD_EMPRESA, CODBARRA"
			
 Set objRS = Server.CreateObject("ADODB.Recordset")
 objRS.Open strSQL, objConn

 Do While Not objRS.EOF 
 
   
   strSQL = "SELECT * FROM tbl_empresas WHERE ID_NUM_DOC1 = '" & Replace(objRS("ID_CPF")&"","'","") & "' and ID_NUM_DOC1 is not null and  ID_NUM_DOC1 <> '' and sys_inativo is null"
   Set objRSDetail = objConn.Execute(strSQL)
   If not objRSDetail.EOF Then
   
	'Deleta TBL_EMPRESAS_SUB
	strSQL = "DELETE FROM TBL_EMPRESAS_SUB WHERE COD_EMPRESA = '"& objRS("COD_EMPRESA") &"' AND CODBARRA = '"& objRS("CODBARRA") &"'"
	If lcase(Request("contatodel")) = "true" or lcase(Request("contatodel")) = "1" Then
		objConn.Execute(strSQL)
		'Response.Write "- " & strSQL & "<BR>"
		'Response.Write objRS("CODBARRA") & " - CONTATO REMOVIDO<BR>"
	End If

   Else

    Response.Write(objRS("COD_EMPRESA") & " - " & objRS("CODBARRA") & "<BR>")
   
	'Insere TBL_EMPRESAS
	strSQL = "SELECT rangelivre(start_gen_id,end_gen_id) as next_free from tbl_usuario where id_user = '" & strID_USER & "'"
	
	icodempresa = 1
	Set objRSNextNumber = objConn.Execute(strSQL)
	If not objRSNextNumber.EOF Then
	  icodempresa = int(objRSNextNumber(0))
	End If
	FechaRecordSet objRSNextNumber
	
	strENTIDADE_CNPJ = objRS("E_ENTIDADE_CNPJ")&""
	
	'If strENTIDADE_CNPJ = "" and objRS("E_END_PAIS") <> "BRASIL" Then
	If strENTIDADE_CNPJ = "" Then
	  strENTIDADE_CNPJ = objRS("COD_EMPRESA")&""
	  strSQL = "UPDATE TBL_EMPRESAS SET ID_NUM_DOC1 = '"&objRS("COD_EMPRESA")&"' WHERE COD_EMPRESA = '"&objRS("COD_EMPRESA")&"' AND (ID_NUM_DOC1 IS NULL OR ID_NUM_DOC1 = '')"
	  objConn.Execute(strSQL)
	End If
	
	strSQL = "INSERT INTO TBL_EMPRESAS ("
	strSQL = strSQL & " COD_EMPRESA"
	strSQL = strSQL & ",CODBARRA"
	strSQL = strSQL & ",NOMECLI"
	strSQL = strSQL & ",NOMEFAN"
	strSQL = strSQL & ",END_FULL"
	strSQL = strSQL & ",END_LOGR"
	strSQL = strSQL & ",END_NUM"
	strSQL = strSQL & ",END_COMPL"
	strSQL = strSQL & ",END_BAIRRO"
	strSQL = strSQL & ",END_CIDADE"
	strSQL = strSQL & ",END_ESTADO"
	strSQL = strSQL & ",END_PAIS"
	strSQL = strSQL & ",END_CEP"
	strSQL = strSQL & ",FONE1"
	strSQL = strSQL & ",FONE2"
	strSQL = strSQL & ",FONE3"
	strSQL = strSQL & ",FONE4"
	strSQL = strSQL & ",EMAIL1"
	strSQL = strSQL & ",DT_NASC"
	strSQL = strSQL & ",ID_NUM_DOC1"
	strSQL = strSQL & ",ID_INSCR_EST"
	strSQL = strSQL & ",ENTIDADE_CARGO"
	strSQL = strSQL & ",ENTIDADE"
	strSQL = strSQL & ",ENTIDADE_CNPJ"
	strSQL = strSQL & ",ENTIDADE_FANTASIA"
	strSQL = strSQL & ",ENTIDADE_EMAIL"
	strSQL = strSQL & ",ENTIDADE_FONE"
	strSQL = strSQL & ",SYS_DATACA"
	strSQL = strSQL & ",SYS_USERCA"
	strSQL = strSQL & ",SYS_DATAAT"
	strSQL = strSQL & ",SYS_USERAT"
	strSQL = strSQL & ",CODATIV1"
	strSQL = strSQL & ",COD_STATUS_CRED"
	strSQL = strSQL & ",COD_STATUS_PRECO"
	strSQL = strSQL & ",TIPO_PESS"
	strSQL = strSQL & ") VALUES ("
	strSQL = strSQL & " '" & icodempresa & "'"
	strSQL = strSQL & ",'" & icodempresa & "010'"
	strSQL = strSQL & ","&strToSQL(objRS("NOME_COMPLETO"))
	strSQL = strSQL & ","&strToSQL(objRS("NOME_CREDENCIAL"))
	strSQL = strSQL & ","&strToSQL(objRS("ENDERECO"))
	strSQL = strSQL & ","&strToSQL(objRS("LOGRAD"))
	strSQL = strSQL & ","&strToSQL(objRS("NUMERO"))
	strSQL = strSQL & ","&strToSQL(objRS("COMPL"))
	strSQL = strSQL & ","&strToSQL(objRS("BAIRRO"))
	strSQL = strSQL & ","&strToSQL(objRS("CIDADE"))
	strSQL = strSQL & ","&strToSQL(objRS("ESTADO"))
	strSQL = strSQL & ","&strToSQL(objRS("PAIS"))
	strSQL = strSQL & ","&strToSQL(objRS("CEP"))
	strSQL = strSQL & ","&strToSQL(objRS("FONE1"))
	strSQL = strSQL & ","&strToSQL(objRS("FONE2"))
	strSQL = strSQL & ","&strToSQL(objRS("FONE3"))
	strSQL = strSQL & ","&strToSQL(objRS("FONE4"))
	strSQL = strSQL & ","&lcase(strToSQL(objRS("EMAIL")))
	strSQL = strSQL & ","&strToSQL(PrepDataIve(objRS("DT_NASC"),False,False))
	strSQL = strSQL & ","&strToSQL(objRS("ID_CPF"))
	strSQL = strSQL & ","&strToSQL(objRS("ID_RG"))
	strSQL = strSQL & ","&strToSQL(objRS("CARGO_NOME"))
	strSQL = strSQL & ","&strToSQL(objRS("E_ENTIDADE"))
	strSQL = strSQL & ","&strToSQL(strENTIDADE_CNPJ)
	strSQL = strSQL & ","&strToSQL(objRS("E_ENTIDADE_FANTASIA"))
	strSQL = strSQL & ","&lcase(strToSQL(objRS("E_ENTIDADE_EMAIL")))
	strSQL = strSQL & ","&strToSQL(objRS("E_ENTIDADE_FONE"))
	strSQL = strSQL & ","&strToSQL(PrepDataIve(objRS("SYS_DATACA"),False,False))
	strSQL = strSQL & ","&strToSQL(objRS("SYS_USERCA"))
	strSQL = strSQL & ",NOW()"
	strSQL = strSQL & ",'" & strID_USER & "'"
	strSQL = strSQL & ","&strToSQL(objRS("E_CODATIV1"))
	strSQL = strSQL & ","&strToSQL(objRS("E_COD_STATUS_CRED"))
	strSQL = strSQL & ","&strToSQL(objRS("E_COD_STATUS_PRECO"))
	strSQL = strSQL & ",'S'"
	strSQL = strSQL & ")"
	objConn.Execute(strSQL)
	'Response.Write "- " & strSQL & "<BR>"
	'Response.Write icodempresa & " - CADASTRO PF INSERIDO<BR>"
	
	strSQL = "update tbl_controle_in set cod_empresa = '" & icodempresa & "', codbarra = '" & icodempresa & "010' where COD_EMPRESA = '"& objRS("COD_EMPRESA") &"' AND CODBARRA = '"& objRS("CODBARRA") &"'"
	objConn.Execute(strSQL)
	
	strSQL = "update tbl_controle_out set cod_empresa = '" & icodempresa & "', codbarra = '" & icodempresa & "010' where COD_EMPRESA = '"& objRS("COD_EMPRESA") &"' AND CODBARRA = '"& objRS("CODBARRA") &"'"
	objConn.Execute(strSQL)

	'Deleta TBL_EMPRESAS_SUB
	strSQL = "DELETE FROM TBL_EMPRESAS_SUB WHERE COD_EMPRESA = '"& objRS("COD_EMPRESA") &"' AND CODBARRA = '"& objRS("CODBARRA") &"'"
	If lcase(Request("contatodel")) = "true" or lcase(Request("contatodel")) = "1" Then
		objConn.Execute(strSQL)
		'Response.Write "- " & strSQL & "<BR>"
		'Response.Write objRS("CODBARRA") & " - CONTATO REMOVIDO<BR>"
	End If
	 
	 
   End If
   FechaRecordSet objRSDetail
   
   objRS.MoveNext

   cont = cont + 1
   If  cont mod 100 = 0 Then
     Response.Write(cont & " - "  & now() & "<BR>")
	 Response.Flush()
   End If
 Loop
 FechaRecordSet ObjRS
 FechaDBConn ObjConn

 Response.Write "*** End  - " & now() & "<BR>"
 
 Response.Write("*** Total Records: " & cont )
 Response.Flush()
 
%>