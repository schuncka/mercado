<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Usuario",Session("METRO_USER_ID_USER")), true %>
<%
	'Variaveid de conexão com BD
	Dim objConn, ObjRS, icodcadastro,strSQL
	'Variaiveis da função CheckCadastro
	Dim bolResult, bolAlreadyExists, strHyperLink, strMensagem 
	'Variaveis Relativas a Filtragem e Seleção
	Dim strNOME, strID_USER, strSENHA, strEMAIL, strGRP_USER, strSAC_USER, strGenID, strInscID,strIDUSERMODELO
	Dim strDT_INATIVO, strTEMPORARIO, strREGISTRA_LEITURA, strDEFAULT_LOCATION
	
	AbreDBConn objConn, CFG_DB
	
	'strID_USER    = Replace(Request(Trim(Lcase("var_id_user"))),"'","''")
	strID_USER    = GetParam("var_id_user")
	strSENHA      = GetParam("var_senha")
	strNOME       = GetParam("var_nome")
	strEMAIL      = GetParam("var_email")
	strGRP_USER   = UCase(GetParam("var_grp_user"))
	strSAC_USER   = GetParam("var_sac_user")
    strGenID      = GetParam("var_GenID") 
    strInscID     = GetParam("var_InscID") 
	strIDUSERMODELO      = GetParam("var_iduser_modelo")
	
	strDEFAULT_LOCATION =  GetParam("DEFAULT_LOCATION")
	
	'response.Write( strIDUSERMODELO)
	'response.End()

	if strEMAIL = "" then 
	  strEMAIL = " "
	end if

	if strGenID = "" then 
	  strGenID = "0"
	end if

	if strInscID = "" then 
	  strInscID = "0"
	end if

	if strIDUSERMODELO = "" then 
		strIDUSERMODELO = ""
	end if  
		
		' ========================================================================
		' Rotina para exibir tela de mensagem de aviso ou erro
		' ========================================================================
		Sub Mensagem(aviso, hyperlink)
		%>
		
		<html>
		<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		</head>
		
		<body bgcolor="#FFFFFF" text="#000000">
		
		<p align="center">&nbsp;</p>
		<p align="center"><font face="Arial, Helvetica, sans-serif" size="2"><b>&lt;&lt; 
			AVISO &gt;&gt;</b></font></p>
		<p align="center"><font face="Arial, Helvetica, sans-serif" size="2"><%=aviso%></font></p>
		<p align="center"><font face="Arial, Helvetica, sans-serif" size="2"><a href='<%=hyperlink%>'>Voltar</a></font></p>
		</body>
		</html>
		<%
			
			Response.End
		End Sub
		
		
		' ========================================================================
		' Faz a consistência para saber se os campos requeridos foram informados
		' ========================================================================
		Function CheckCadastro()
			
			bolResult = True
			If ((strID_USER = "") Or (strSENHA = "") Or (strNOME = "") Or (strGRP_USER = "")) Then
				strHyperLink = "Javascript:history.back()"
				strMensagem  = "Você tem que preencher todos os campos obrigatórios da ficha de usuário."
				Mensagem strMensagem, strHyperLink
				bolResult = False
			End If
			CheckCadastro = bolResult
		End Function
		
		
		' ========================================================================
		' Faz a consistência para saber se os campos informados já existem
		' ========================================================================
		Function CheckContato()
			
			
			bolResult = True
			
			'Verifica se já não existe um cadastro com estes dados
			
			strSQL = " SELECT COD_USUARIO, ID_USER, NOME FROM tbl_USUARIO " &_
					 "  WHERE ID_USER = '" & strID_USER & "' "
			
			Set objRS = Server.CreateObject("ADODB.Recordset")
			objRS.Open strSQL, objConn
			
			If not (objRS.BOF and objRS.EOF) Then
			  strHyperLink = "Javascript:history.back()"
			  strMensagem  = "Já existe no sistema um usuário com o login <b>[" & strID_USER & "]</b>, por favor tente novamente."
			  Mensagem strMensagem, strHyperLink
			  bolResult = False        
			End If
			
			objRS.Close
			CheckContato = bolResult
		End Function
		
		
		' ========================================================================
		' Grava o cadastro no banco de dados
		' ========================================================================
		Sub GravaCadastro()
			
			
			If Request.Form("var_status") = "Ativo" Then
				strDT_INATIVO = "NULL"
			Else
			   strDT_INATIVO =  "'" & PrepDataIve(date, False, False) & "'"
			   'MDB  strDT_INATIVO = date()
			End If
			
			If Request.Form("var_temporario") = "True" Then
				strTEMPORARIO = "1"
			Else
			   strTEMPORARIO =  "0"
			End If
			
			If Request.Form("var_registra_leitura") = "1" Then
			   strREGISTRA_LEITURA = "1"
			Else
			   strREGISTRA_LEITURA = "0"
			End If
		
			strSQL = "INSERT INTO tbl_USUARIO (ID_USER, SENHA, EMAIL, NOME, GRP_USER, SAC_USER, DT_INATIVO, TEMPORARIO, START_GEN_ID, LAST_GEN_ID, START_INSC_ID, LAST_INSC_ID, REGISTRA_LEITURA,ID_USER_MODELO) " &_
					 "VALUES ('" & strID_USER & "','" & strSENHA & "','" & strEMAIL & _
							  "','" & strNOME & "','" & strGRP_USER & "'," & strToSQL(strSAC_USER) & "," & strDT_INATIVO & "," & strTEMPORARIO & "," & strGenID & "," & strGenID & "," & strInscID & "," & strInscID & "," & strREGISTRA_LEITURA &  ",'" & strIDUSERMODELO &  "')"
		
			objConn.Execute(strSQL)
			
			strSQL = " SELECT MAX(COD_USUARIO) AS ULTIMO_USUARIO FROM tbl_USUARIO WHERE ID_USER = '" & strID_USER & "'"	
			Set objRS = objConn.Execute(strSQL)
			If not objRS.EOF Then
			  strSQL = "INSERT INTO tbl_USUARIO_EVENTO (COD_USUARIO, COD_EVENTO) " &_
					   "VALUES (" & objRS("ULTIMO_USUARIO") & "," & Session("COD_EVENTO") & ")"
			  objConn.Execute(strSQL)
			End If
			FechaRecordSet objRS
		
		End Sub
'------------------------------------------------------------------------------------------------------------------------
'else	
'			Dim strDT_INATIVO, strTEMPORARIO, strREGISTRA_LEITURA, strSQL
'			
'			strSQL = "INSERT INTO tbl_USUARIO (NOME,ID_USER,SENHA,GRP_USER,EMAIL,OCULTO,TEMPORARIO,START_GEN_ID,LAST_GEN_ID,START_CREDEXP_ID,LAST_CREDEXP_ID,START_INSC_ID,LAST_INSC_ID,DT_INATIVO,END_GEN_ID,END_INSC_ID,SAC_USER,REGISTRA_LEITURA,ID_USER_MODELO)"
'			strSQL = strSQL & "SELECT '"& strNOME & "','" & strID_USER & "','" & strSENHA &"', GRP_USER ,'" & strEMAIL & "','" & strToSQL(strSAC_USER) & "','" & strDT_INATIVO & "','" & strTEMPORARIO & "','" & strGenID & "','" & strGenID & "','" & strInscID & "','" & strInscID & "','" & strREGISTRA_LEITURA & "','" & strIDUSERMODELO &  "'  FROM tbl_USUARIO where ID_USER = " & strIDUSERMODELO				  		
'			RESPONSE.Write(strSQL)
'			response.End()
'			'objConn.Execute(strSQL)
'			
'			strSQL = " SELECT MAX(COD_USUARIO) AS ULTIMO_USUARIO FROM tbl_USUARIO WHERE ID_USER = '" & strID_USER & "'"	
'			Set objRS = objConn.Execute(strSQL)
'			If not objRS.EOF Then
'			  strSQL = "INSERT INTO tbl_USUARIO_EVENTO (COD_USUARIO, COD_EVENTO) " &_
'					   "VALUES (" & objRS("ULTIMO_USUARIO") & "," & Session("COD_EVENTO") & ")"
'			 ' objConn.Execute(strSQL)
'			End If
'			FechaRecordSet objRS
'	
'end if

'response.Write( strIDUSERMODELO)
'response.End()

'========================================================================
' Principal
'========================================================================
If (CheckCadastro() And CheckContato()) Then
	GravaCadastro()
	Response.Redirect(strDEFAULT_LOCATION)
End If

FechaRecordSet ObjRS
FechaDBConn ObjConn
%>