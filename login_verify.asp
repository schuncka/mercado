<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<%
Dim objConn, objRS
Dim strUserID, strUserpwd, strSessionID, strCOD_EVENTO
Dim strUserIDfromDB, strUserGRPfromDB, strUserpwdfromDB, strDtInativofromDB, strNamefromDB, strUserCOD_USUARIOfromDB
Dim strSQL, strURL, strErro, strTabela, bolFound, strEventoFlag
Dim strIO, strState, strSQLStatus
 
strUserID  		= Replace(getParam("var_userid"),"'","''")
strUserpwd  	= Replace(getParam("var_senha"),"'","''")
strCOD_EVENTO	= getParam("var_cod_evento")
CFG_DB  		= getParam("var_db")    

Session.Contents.RemoveAll()   

strSessionID	= Session.SessionID
strErro 		= ""
strURL 			= "login.asp"
Session.TimeOut = 900

AbreDBConn objConn, CFG_DB


				
' ------------------------------------------------------------------------
' Monta consulta para verificar se o usuario informado pode acessar o evento
' ------------------------------------------------------------------------
  strSQL = "SELECT NOME, DT_INICIO, DT_FIM, STATUS_PRECO, STATUS_CRED, CIDADE, ESTADO_EVENTO, COD_GRUPO_EVENTO"
  strSQL = strSQL & ", SMTP_SERVER, SMTP_USER, SMTP_PWD, SMTP_PORT "
  strSQL = strSQL & ", CRED_PRINT_CONTROLE"
  strSQL = strSQL & ", BARCODE_MODE"
  strSQL = strSQL & ", BARCODE_HEIGHT"
  strSQL = strSQL & "  FROM tbl_EVENTO "
  strSQL = strSQL & " WHERE COD_EVENTO = " & strCOD_EVENTO
  Set objRS = objConn.Execute(strSQL)
  If not objRS.EOF Then
    Session("NOME_EVENTO")      = objRS("NOME")
    Session("CIDADE_EVENTO")    = objRS("CIDADE")
    Session("ESTADO_EVENTO")    = objRS("ESTADO_EVENTO")
    Session("DT_INICIO_EVENTO") = objRS("DT_INICIO")
    Session("DT_FIM_EVENTO")    = objRS("DT_FIM")
    Session("COD_STATUS_PRECO") = objRS("STATUS_PRECO")
    Session("COD_STATUS_CRED")  = objRS("STATUS_CRED")
	Session("COD_GRUPO_EVENTO") = objRS("COD_GRUPO_EVENTO")
	Session("SMTP_SERVER")      = objRS("SMTP_SERVER")
	Session("SMTP_USER")        = objRS("SMTP_USER")
	Session("SMTP_PWD")         = objRS("SMTP_PWD")
	Session("SMTP_PORT")        = objRS("SMTP_PORT")
	Session("CRED_PRINT_CONTROLE") = objRS("CRED_PRINT_CONTROLE")
	Session("BARCODE_MODE")     = objRS("BARCODE_MODE")
	Session("BARCODE_HEIGHT")   = objRS("BARCODE_HEIGHT")
  Else
    Session("NOME_EVENTO") = "Mercado " & Year(Date())
    Session("CIDADE_EVENTO")    = ""
    Session("ESTADO_EVENTO")    = ""
    Session("DT_INICIO_EVENTO") = Date()
    Session("DT_FIM_EVENTO")    = Date()
    Session("COD_STATUS_PRECO") = 0
    Session("COD_STATUS_CRED")  = 0
	Session("COD_GRUPO_EVENTO") = 0
	Session("SMTP_SERVER")      = ""
	Session("SMTP_USER")        = ""
	Session("SMTP_PWD")         = ""
	Session("SMTP_PORT")        = ""
	Session("CRED_PRINT_CONTROLE") = ""
	Session("BARCODE_MODE")     = ""
	Session("BARCODE_HEIGHT")   = ""
  End If

  Session("COD_EVENTO") = strCOD_EVENTO
  Response.Cookies("sysMetro").Expires = DateAdd("M",1,date)
  Response.Cookies("sysMetro")("CODEVENTO") = strCOD_EVENTO
  Response.Cookies("sysMetro")("DBNAME") = CFG_DB
    
' ----------------------------------------------------------------------------------------------
' Monta consulta para localizar os dados do usuário informado
' ----------------------------------------------------------------------------------------------
' Esta consulta pesquisa se o o id, a senha e o evento estão certos
' (compatíveis) ou se o usuário está entrando com uma senha de SU              
' ----------------------------------------------------------------------------------------------
'by MAURO
 strSQL = 		   " SELECT "
 strSQL = strSQL & " 	U.COD_USUARIO, U.ID_USER, U.GRP_USER, U.SAC_USER, U.SENHA, U.DT_INATIVO, U.NOME, U.OCULTO, U.REGISTRA_LEITURA,  U.EMAIL, U.SAC_USER"
 strSQL = strSQL & "  FROM  TBL_USUARIO U "
 strSQL = strSQL & " WHERE "
 strSQL = strSQL & "       U.DT_INATIVO IS NULL "
 strSQL = strSQL & "   AND U.ID_USER = '" & strUserID & "' "
 strSQL = strSQL & "   AND "
 strSQL = strSQL & "     ( "
 strSQL = strSQL & "       (U.SENHA = '" & strUserpwd & "') "
 strSQL = strSQL & "       OR "
 strSQL = strSQL & "       ('" & strUserpwd & "' IN (SELECT SENHA FROM TBL_USUARIO WHERE OCULTO = -1))"
 strSQL = strSQL & "     ) "

 set objRS = objConn.execute(strSQL)

 If not objRS.EOF Then
     strUserCOD_USUARIOfromDB = objRS("COD_USUARIO")
     strUserIDfromDB          = objRS("ID_USER")
     strUserGRPfromDB         = objRS("GRP_USER")
     strUserpwdfromDB         = objRS("SENHA")
     strDtInativofromDB       = objRS("DT_INATIVO")
     strNamefromDB            = objRS("NOME")
     Session("ID_USER")       = strUserIDfromDB
     Session("GRP_USER")      = strUserGRPfromDB
     
     Session("NOME_USER")     = objRS("NOME")	 
     Session("COD_USUARIO")   = strUserCOD_USUARIOfromDB
	 Session("EMAIL_USER")	  = objRS("EMAIL")	  	   
	 Session("SAC_USER")	  = objRS("SAC_USER")	  	   

	 Session("USER_OCULTO")   = objRS("OCULTO")
	 Session("ID_USER_REGISTRA_LEITURA")  = objRS("REGISTRA_LEITURA")	 
   Session("FLAGLOGIN")     = "True"
'Session("METRO_USER_ID_USER") = objRS("ID_USER")
	 
     Response.Cookies("sysMetro").Expires = DateAdd("M",1,date)
     Response.Cookies("sysMetro")("CODEVENTO") = strCOD_EVENTO
	 
	 Session("DT_LASTLOGIN") = NOW()
	 'Server.Execute("ajusteSaldoProdutos.asp")
	 
	 strURL = "nucleo.asp"
	 If not IsNull(objRS("DT_INATIVO")) Then
		 strErro = "usuário sem acesso ao sistema"
	 End If
 Else
   strErro = "usuário não encontrado ou usuário inativo ou senha inválida"
 End If 

 Session("athcsmusuario") = strNamefromDB



 'NOVAS variáveis de SESSION ----------------------------------------------
 'Quandodo conseguirmos eliminar as outras variáveis de session no backend, 
 'apenas essas inicializações devem ser utilizadas. Por enquanto elas são 
 'colocadas em sessão para testarmos perfomance e comportamento do IIS,
 'em relação ao volume de dados numa SESSION
 '-------------------------------------------------- by Aless 08/04/2015 --
 IniSessionEVENTO ObjConn, strCOD_EVENTO 
 IniSessionUSER ObjConn, strUserID
 IniSessionINFO ObjConn
 ' ------------------------------------------------------------------------
 
 'Carrega na sessão o(s) modelo(s) de credencial padrão e por tipo de credencial se estiver cadastrado
 InicializaLayoutCredencialSessao( Session("COD_EVENTO") )
 '-------------------------------------------------- by Mauro 15/10/2015

strSQL = "SHOW SLAVE STATUS"				
Set objRS = objConn.Execute(strSQL) 
If not objRS.EOF Then
	strState  = objRS("Slave_IO_State")
	strIO = objRS("Slave_IO_Running")
	strSQLStatus = objRS("Slave_SQL_Running")
	'teste se o problema esta na conexao de internet strSQLStatus em YES indica q a replicacao nao foi quebrada
	If instr(strState,"Connecting") AND strIO = "No" AND strSQLStatus = "Yes" Then
		Response.Redirect "_database/athValidaReplica.asp"'
	End If	
	If strIO = "Yes" AND strSQLStatus = "Yes"  Then
		Response.Redirect "_database/athValidaReplica.asp"
	End If
End If
 

 
%>
<html>
<head>
<title></title>
</head>
<body onLoad="document.formulario.submit()">
<form name="formulario" action="<%=strUrl%>" method="post">
    <!-- quando volta pra login porque não validou o usuário (login.asp) //-->
    <input type="hidden" name="erro"        id="erro" value="<%=strErro%>">
    <input type="hidden" name="nome"        id="nome" value="<%=strUserID%>">
    <input type="hidden" name="razaosocial" id="razaosocial" value="<%=strNamefromDB%>">
	<input type="hidden" name="cod_evento"  id="cod_evento"  value="<%=strCOD_EVENTO%>">
    <!-- quando vai adiante e passa apra o sistema em si (nucleo.asp) //-->
	<input type="hidden" name="var_open"    id="var_open"  value="TRUE">
	<input type="hidden" name="cachereg"    id="cachereg"  value="<%=Session.SessionID & "_" & Replace(Time,":","") %>">
</form>
</body>
</html>