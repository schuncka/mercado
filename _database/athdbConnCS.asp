<%@ LANGUAGE="VBSCRIPT" CODEPAGE="1252" %>
<% 
  Option Explicit 
  Session.LCID    	    = 1046
  Session.Timeout 	    = 900 ' 720 = 12h
  Server.ScriptTimeout  = 3600 '1h
  Response.Expires 	    = -1   'no expires
  Response.Buffer       = True 'Para uso adequado da athMoveNext
  Response.CacheControl = "no-cache"
  Response.AddHeader "Pragma", "no-cache"
  Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
  'Response.AddHeader "Expires", "Mon, 26 Jul 1997 05:00:00 GMT"  'date in the past...
  'Response.AddHeader "Last-Modified", Now & " GMT" 'always modified
  Response.AddHeader "Cache-Control", "no-cache, must-revalidate" 'HTTP/1.1 
    
  Dim CFG_DB, CFG_DIR, CFG_VERSION, CFG_BUT_PREFIX, CFG_FLUSH_LIMIT, CFG_ACTIVE_LOG, CFG_PATH_VISA
  Dim CFG_DB_USER, CFG_DB_DRIVER, CFG_DIALOG_DETAIL, CFG_EMAIL_AUDITORIA_PROEVENTO 
  Dim CFG_PRINT_ONDEMAND,CFG_DB_DADOS_PWD, CFG_NUM_PER_PAGE, CFG_WINDOW
  Dim ContFlush, auxStr
  Dim CFG_DIALOG_WITH, CFG_DIALOG_HEIGHT
  Dim CFG_MINI_WITH, CFG_MINI_HEIGHT

  ContFlush = 0  'Usada no controle da athMoveNext

  CFG_DB 						= Request.Cookies("sysMetro")("DBNAME") 'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
  CFG_DB_DRIVER     = MontaDbDriver("MySQL ODBC 5.1 Driver")
  CFG_DB_USER       = MontaDbUserName("root")     'User  (default para local, se estiver online a função muda)  
  CFG_DB_DADOS_PWD	= MontaDbUserPwd("athbbsi")'Senha (default para local, se estiver online a função muda)
  CFG_DIR           = "\_pvista"                  'Diretorio do site local
  CFG_VERSION       = "2014.MySQL"                'Versao atual do SISTEMA
  CFG_BUT_PREFIX    = "But_XPGreen_"
  CFG_FLUSH_LIMIT   = 500                         'Limite de registros para execução do Flush no movenext
  CFG_NUM_PER_PAGE  = 22       					  'Núm. Default de ítens por página	  
  CFG_ACTIVE_LOG    = "pvista_dados"			  'CFG_DB 	 - log ativo para todos os clientes;
  												  '"BD1;BB2" - log ativo somente para estes bancos listados
  												  '"" 		 - log desativado para todos
  CFG_WINDOW        = "POPUP"                     'Abre dialogs em POPUP ou NORMAL (local)

  CFG_EMAIL_AUDITORIA_PROEVENTO = "gabriel.schunck@gmail.com"
  CFG_PRINT_ONDEMAND   	 	= True   'Flag para controlar a exibição da janela/dialog de impressão nas credenciais
  CFG_PATH_VISA			 	= "c:\Inetpub\wwwroot\componentes_vbv\"

  ' Tamanhos padrão pra aberturas de MINI e DIALOGS
  CFG_MINI_WITH		= 720
  CFG_MINI_HEIGHT	= 600
  CFG_DIALOG_WITH	= 520
  CFG_DIALOG_HEIGHT	= 620

  'PROVISÓRIO
  'Substitui o código da SECURE.ASP (que era incluso em cada págiuna do sistema que desejava controle de sessão expirada
  'Foi mantida a lógica original, mas poderemos modificar esse controle posteriormente
'  If (inStr(lcase(request.servervariables("SCRIPT_NAME")),"login.asp") <= 0) then
'	 If ( (Session("ID_USER")="") OR (Session("COD_EVENTO")="") ) Then
'	 	mensagem "SESSÃO EXPIRADA<br />(para efetuar um novo login utilize o link abaixo - " & request.servervariables("SCRIPT_NAME") _
'				, "http://"&Request.ServerVariables("HTTP_HOST") & Replace(CFG_DIR,"\","/") & "' target='_top" _ 
'				, "pVISTA LOGIN" _
'				, false
'		Response.End()
'	  End If                                                                        
'  End If                                                                        
  '------------------------------------------------------------------------------------------ 09/10/2014 Aless/Eliton --
%>
<!DOCTYPE html>
<!--#include file="ADOVBS.INC"-->
<%
'------------------------------------------------------------------------ 
' Essas coisas colocadas ACIMA, não precisam mais ser colocadas em página 
' alguma do sistema, pois todas incluem, no mínimo esta aqui (athDBconn)
'------------------------------------------------------------------------

'=============================================================
'FUNÇÕES GERIAS
'=============================================================
Sub AbreDBConn(byref pr_objConn, byval pr_StrDataBase)
Dim auxmappath, strConnection, strDBUsername, strDBPassword
Dim objFSO, strPath, aviso, arrCliFolders, auxIDSemPrefix
Dim auxStr, auxUSERdb, auxUSERdbSufix

  Set pr_objConn = Server.CreateObject("ADODB.Connection")


  'INI: Bloqueio de ambiente (pasta _blocked/_bloqueado -----------------------------------------------------------------------------
  Set objFSO	= CreateObject("Scripting.FileSystemObject")
  strPath		= lcase(server.mappath("/")) & "\" & replace(pr_StrDataBase,"_dados","") & "\_BLOQUEADO\" 'SE existir essa pasta [_BLOQUEADO] dentro da pasta do ambiente, então a conexão com o banco não acontecerá, fica bloqueada
  'response.Write(strPath)
  'response.end
  if (objFSO.FolderExists(strPath)) then 
	aviso = "Neste momento as conexões para o sistema encontram-se BLOQUEADAS neste ambiente.<br>"
	Mensagem aviso, "", "", True
	Response.End
  end if
  'FIM: Bloqueio de ambiente (pasta _blocked/_bloqueado -----------------------------------------------------------------------------


  If instr(pr_StrDataBase,"DSN=") > 0 Then 
   'CONEXÃO VIA DSN -----------------------------------------------------------------------------
    strConnection   = "DSN="
    strDBUsername   = ""
    strDBPassword   = ""
    pr_objConn.Open strConnection, strDBUsername, strDBPassword
   '---------------------------------------------------------------------------------------------
  Else
    'response.Write("[" & GetCliFolderNames("../") & "]")

    arrCliFolders  = split(GetCliFolderNames("../"),";")
	auxIDSemPrefix = LCase(replace(pr_StrDataBase,"vboss_",""))
	IF instr(auxIDSemPrefix,"-")>0 then
	  auxIDSemPrefix = Mid(auxIDSemPrefix,1,instr(auxIDSemPrefix,"-")-1)	
	END IF
	If (pr_StrDataBase <> "") Then 
		auxUSERdb = MontaDbUserName(CFG_DB_USER)
		
	  	strConnection = "PROVIDER=MSDASQL;DRIVER={" & CFG_DB_DRIVER & "};SERVER=localhost;PORT=3306;DATABASE=" & pr_StrDataBase & ";USER=" & auxUSERdb & ";PASSWORD=" & CFG_DB_DADOS_PWD & ";OPTION=3;"

		'athDebug strConnection, false
	  	pr_objConn.Open strConnection
	Else
	  Response.Write("<br><br>")
	  If (ArrayIndexOf(arrCliFolders,auxIDSemPrefix)<0) Then
    	  aviso = "Identificador de grupo INVÁLIDO.<br>Se você tem alguma dúvida sobre o seu identificador de grupo, <br>usuário ou senha entre em contato com o administrador.<br><br>Identificador digitado: [" & pr_StrDataBase & "] <br>Atenção! Seu filtro de phishing/smartscreen de estar desabilitado."
          Mensagem aviso, "", "", True
      else
    	  aviso = "O sistema encontra-se em manutenção.<br>Aguarde alguns instantes e tente novamente, ou entre em contato com o administrador.<br><br>MySQL: " & pr_StrDataBase
          Mensagem aviso, "", "", True
      end if
	  Response.End()
	End If
  End If
End Sub

'-------------------------------------------------------------------------------
Function MontaDbUserName(prDefault)
	Dim auxStr1, auxStr2, auxUSERdbSufix, auxUSERdb
	
	auxStr1 = lcase(Request.ServerVariables("SCRIPT_NAME"))
	auxStr2 = lcase(server.mappath("/"))

   	IF (instr(auxStr1,"/_pvista/") > 0) then 
	  'NOSSO SERVIDOR LOCAL - ATHENAS/PROEVENTO 	
	  auxUSERdb = prDefault
	ELSE
	  'NOSSO SERVIDOR ONLINE PROSERVER1 (PS1)
	  auxUSERdb = "sysMetro"
	END IF
	
	MontaDbUserName = auxUSERdb
End Function
'-------------------------------------------------------------------------------

'-------------------------------------------------------------------------------
Function MontaDbUserPWD(prDefault)
	Dim auxStr1, auxStr2, auxUSERdbSufix, auxUSERpwd
	
	auxStr1 = lcase(Request.ServerVariables("SCRIPT_NAME"))
	auxStr2 = lcase(server.mappath("/"))

   	IF (instr(auxStr1,"/_pvista/") > 0) then 
	  'NOSSO SERVIDOR LOCAL - ATHENAS/PROEVENTO 	
	  auxUSERpwd = prDefault
	ELSE
	  'NOSSO SERVIDOR ONLINE PROSERVER1 (PS2)
	  auxUSERpwd = "(AT5*hBB*5si)"
	END IF
	
	MontaDbUserPWD = auxUSERpwd
End Function
'-------------------------------------------------------------------------------

Function MontaDbDriver(prDefault)
	Dim auxStr1, auxStr2, auxUSERdbSufix, auxUSERdb
	
	auxStr1 = lcase(Request.ServerVariables("SCRIPT_NAME"))
	auxStr2 = lcase(server.mappath("/"))
	
   	IF (instr(auxStr1,"/aspSYSTEMS/") > 0) then ' SE ESTIVER NA ATHENAS 	
	    MontaDbDriver = prDefault
   	ELSE
		IF instr(auxStr2,"\vhosts\") > 0 THEN
			'SERVIDOR ONLINE LOCAWEB  (IDC)
   			MontaDbDriver = "MySQL ODBC 3.51 Driver" 
		ELSE
			'NOSSO SERVIDOR ONLINE PROSERVER (PS1/PS2)
		    MontaDbDriver = prDefault
		END IF
	END IF
End Function


Function FindBDPath
  Dim auxmappath
  auxmappath = lcase(server.mappath("/"))
  If instr(auxmappath,"wwwroot")>0 then 'LOCAL - conforme o nosso servidor: ZEUS
    if instr(auxmappath,"domains")>0 then
      auxmappath = replace(auxmappath,"wwwroot", "db\") 'SOUTHTECH
	else
	  auxmappath = auxmappath & "\aspSYSTEMS\virtualboss" & CFG_DIR & "\db\"  'ATHENAS
	end if
  else
    if instr(auxmappath,"home")>0 then
	  auxmappath = replace(auxmappath,"web", "dados\") 'LOCAWEB v1
	else 
	  if instr(auxmappath,"httpdocs")>0 then 'LOCAWEB v2
	    auxmappath = replace(auxmappath,"httpdocs", "private\db\") 
	  else
        auxmappath = replace(auxmappath,"html","") 'PLUGIN 
	    auxmappath = auxmappath & "data\"
	  end if
	end if
  End If
  FindBDPath = auxmappath
End Function

Function FindUploadPath
  Dim auxStr1, auxStr2
  auxStr1 = lcase(Request.ServerVariables("SCRIPT_NAME"))
  auxStr2 = lcase(server.mappath("/"))
  If (instr(auxStr1,"/aspsystems/") > 0) Then ' SE ESTIVER NA ATHENAS 	
    auxStr2 = auxStr2 & "\aspSYSTEMS\VirtualBoss" & CFG_DIR
  Else
    auxStr2 = auxStr2 & CFG_DIR
  End If
  FindUploadPath = auxStr2
End Function

Function FindPhysicalPath(pr_pasta)
  Dim auxStr1, auxStr2
  auxStr1 = lcase(Request.ServerVariables("SCRIPT_NAME"))
  auxStr2 = lcase(server.mappath("/"))
  If (instr(auxStr1,"/aspSYSTEMS/") > 0) Then ' SE ESTIVER NA ATHENAS 	
    auxStr2 = auxStr2 & "\aspSYSTEMS" & pr_pasta
  Else
    auxStr2 = auxStr2 & "\" & pr_pasta 
  End If
  FindPhysicalPath = auxStr2
End Function

Function FindLogicalPath()
  Dim auxmappath
  auxmappath = lcase(Request.ServerVariables("SCRIPT_NAME"))
  If (instr(auxmappath,"/aspSYSTEMS/") > 0) Then ' SE ESTIVER NA ATHENAS 	
    auxmappath = "http://" & Request.ServerVariables("HTTP_HOST") & "/aspSYSTEMS/virtualboss/virtualboss"
  Else
    auxmappath = "http://virtualboss.proevento.com.br/virtualboss/"
  End If
  FindLogicalPath = auxmappath
End Function

' ------------------------------------------------------------------------------------------------------------------
' Função para abrir a RecordSet de maneira padrão. Assim teremos duas maneiras "oficiais" de abrir um RecordSet:
' set objRS = objConn.Execute(strSQL)
' AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1 
Sub AbreRecordSet (byref prObjRS, prSQL, prObjConn, prLockType, prCursorType, prCursorLocation, prCacheEPageSize)
  set prObjRS = Server.CreateObject("ADODB.Recordset")
  prObjRS.LockType       = prLockType
  prObjRS.CursorType     = prCursorType 
  prObjRS.CursorLocation = adUseClient 'prCursorLocation  - LOCAWEB: recomenda que seja SEMPRE adUseClient 
  if prCacheEPageSize>0 then prObjRS.CacheSize = prCacheEPageSize
  prObjRS.Open prSQL,prObjConn
  if prCacheEPageSize>0 then prObjRS.PageSize = prCacheEPageSize
End Sub
' ------------------------------------------------------------------------------------------ by Aless e Cleverson --

Sub FechaRecordSet(byref pr_objRS)
  pr_objRS.close
  set pr_objRS = NOThing
End Sub

Sub FechaDBConn(byref pr_objConn)
 pr_objConn.Close()
 Set pr_objConn = NOThing
End Sub

Function GetCliFolderNames(prPath)
 Dim strPath, objFSO, objFolder, objItem   
 Dim auxStr, strFOLDER
 
 strPath = prPath  ' Tem que terminar com barra !!! Ex. .\  ..\  ou  .\algo\
 Set objFSO    = Server.CreateObject("Scripting.FileSystemObject")
 Set objFolder = objFSO.GetFolder(Server.MapPath(strPath))
 auxStr = ""
 For Each objItem In objFolder.SubFolders
    IF (InStr(objItem, "_manut")=0) and (InStr(objItem, "virtualboss")=0) Then
	  strFOLDER = lcase(objItem.Name)
	  strFOLDER = StrReverse(strFOLDER)
	  If InStr(strFOLDER, "\") > 0 Then strFOLDER = Mid(strFOLDER, InStr(strFOLDER, "\")-1)
	  strFOLDER = StrReverse(strFOLDER)
	  
      auxStr = auxStr & strFOLDER & ";"
    End IF
 Next 
 
 Set objItem   = Nothing
 Set objFolder = Nothing
 Set objFSO    = Nothing
 GetCliFolderNames = auxStr
End Function

' ------------------------------------------------------
' Rotina para exibir tela de mensagem de aviso ou erro
' ------------------------------------------- by Aless -
Sub Mensagem(pr_aviso, pr_hyperlink, pr_text, pr_flaghtml)
  If pr_flaghtml<>0 then 
    Response.Write ("<html>")
    Response.Write ("<head>")
    Response.Write ("<title></title>")
    Response.Write ("<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>")
    Response.Write ("</head>")
    Response.Write ("<body bgcolor='#FFFFFF' text='#000000'>")
  End If
	
  Response.Write ("<p align='center'><font face='Arial, Helvetica, sans-serIf' size='2'><b>.:: INFO ::.</b></font></p>")
  Response.Write ("<p align='center'><font face='Arial, Helvetica, sans-serIf' size='2'>" & pr_aviso & "</font></p>")
  Response.Write ("<p align='center'><font face='Arial, Helvetica, sans-serIf' size='2'>" )
  If pr_hyperlink<>"" then      
	Response.Write ("<a href='" & pr_hyperlink & "' id='click'>" & pr_text & "</a><script language=javascript>document.getElementById('click').click()</script>")
  End If
  Response.Write ("</font></p>")

  If pr_flaghtml<>0 then 
    Response.Write ("</body>")
    Response.Write ("</html>")
  End If
End Sub

'-------------------------------------------------------------------------------
' Funcao que retorna o indice de um determinado dado em um array
'-------------------------------------------------------------------- by Aless -
Public Function ArrayIndexOf(pr_array, pr_campo)
Dim i
	ArrayIndexOf = CInt(-1)
	For i = 0 To UBound(pr_array)
		If pr_array(i) = pr_campo then
			ArrayIndexOf = CInt(i)
		End If	 
	Next
End Function

'---------------------------------------
' Obtain database field value
'---------------- by Aless e Cleverson -
function GetValue(rs, strFieldName)
CONST bDebug = True
dim res
  on error resume next
  if rs is nothing then
  	GetValue = ""
  elseif (not rs.EOF) and (strFieldName <> "") then
    res = rs(strFieldName)
    if isnull(res) then 
      GetValue = CStr("")
    else
      select case VarType(res) 
	   case vbInteger : GetValue = CInt(res)  ' Indicates an integer 
	   case vbLong    : GetValue = CLng(res)  ' Indicates a long integer 
	   case vbSingle  : GetValue = CInt(res)  ' Indicates a single-precision floating-point number 
	   case vbDouble  : GetValue = CDbl(res)  ' Indicates a double-precision floating-point number 
	   case vbCurrency: GetValue = CDbl(res)  ' Indicates a currency 
	   case vbDate    : GetValue = CDate(res) ' Indicates a date 
	   case vbString  : GetValue = CStr(res)  ' Indicates a string 
	   case vbBoolean : if res then GetValue = "1" else GetValue = "0" ' Indicates a boolean 
	   case vbByte    : if res then GetValue = "1" else GetValue = "0" ' Indicates a byte 
	   case else: GetValue = res
     end select 
    end if
  else
    GetValue = CStr("")
  end if

  if bDebug then response.write err.Description
  on error goto 0
end function

'-------------------------------
' Obtain specific URL Parameter from URL string
'-------------------------------
function GetParam(ParamName)
Dim auxStr
  if ParamName = "" then 
    auxStr = Request.QueryString
	if auxStr = Empty or Cstr(auxStr) = "" or isNull(auxStr) then auxStr = Request.Form
  else
   if Request.QueryString(ParamName).Count > 0 then 
     auxStr = Request.QueryString(ParamName)
   elseif Request.Form(ParamName).Count > 0 then
     auxStr = Request.Form(ParamName)
   else 
     auxStr = ""
   end if
  end if
  
  if auxStr = "" then
    GetParam = Empty
  else
    auxStr = Trim(Replace(auxStr,"'","''"))
    GetParam = auxStr
  end if
end function

'-----------------------------------------------------------------------------
' Monta a lista de valores de um combo, do SQL enviado como parâmetro
'-----------------------------------------------------------------------------
Public Function montaCombo(pr_tipo, pr_SQL, pr_colValue, pr_colText, pr_Codigo)
	Dim objRS_local, objConn_local, intCodigo, strCodigo, strVAL1, strVAL2
 
	AbreDBConn objConn_local, CFG_DB 

	If pr_tipo = "INT" Then
		intCodigo = pr_Codigo
		If intCodigo = "" Then
	    	intCodigo = 0
		End If

		Set objRS_local = objConn_local.Execute(pr_SQL)	

		If NOT objRS_local.EOF Then
			Do While NOT objRS_local.EOF
       			If CInt(intCodigo) = CInt(objRS_local(pr_colValue)) Then
        	 		Response.Write "<option value=""" & objRS_local(pr_colValue) & """ selected>" & objRS_local(pr_colText) & "</option>"
       			Else
         			Response.Write "<option value=""" & objRS_local(pr_colValue) & """>" & objRS_local(pr_colText) & "</option>"
	       		End If
    	   		objRS_local.MoveNext
     		Loop
		End If
	End If
	If pr_tipo = "STR" Then
		strCodigo = pr_Codigo

		Set objRS_local = objConn_local.Execute(CStr(pr_SQL))	
  
		If NOT objRS_local.EOF Then
			Do While NOT objRS_local.EOF
				strVAL1 = CStr(strCodigo&"") 
				strVAL2 = CStr(objRS_local(CStr(pr_colValue))&"")
			
	       		If lcase(strVAL1) = lcase(strVAL2) Then
         			Response.Write "<option value=""" & objRS_local(CStr(pr_colValue)) & """ selected>" & objRS_local(CStr(pr_colText)) & "</option>"
       			Else
        	 		Response.Write "<option value=""" & objRS_local(CStr(pr_colValue)) & """>" & objRS_local(CStr(pr_colText)) & "</option>"
       			End If
       			objRS_local.MoveNext
    	 	Loop
		End If
	End If

	FechaRecordSet objRS_local
	FechaDBConn objConn_local
End Function

'------------------------------------------------
sub Session_OnEnd
 %><script>alert("Sessão expirada");</script><%
end sub
'------------------------------------------------

'---------------------------------------------------------------------------------------------------------------
'Deleta dados informados nos parâmetros, função antiga que estava específica em cada página ASP que precisava 
'----------------------------------------------------------------------------------------------------- by Clv --
Function DeletaDados(DEFAULT_DB, DEFAULT_TABLE, RECORD_KEY_NAME, RECORD_KEY_VALUE, RECORD_KEY_NAME_EXTRA, RECORD_KEY_VALUE_EXTRA, DEFAULT_LOCATION, MSG)
On Error Resume Next
  Dim ObjConn_DeleteToDB, StrSql_DeleteToDB, StrSQL_DeleteImagesToDB, objRSTs

  AbreDBConn ObjConn_DeleteToDB, DEFAULT_DB

   StrSql_DeleteToDB = "DELETE FROM "& DEFAULT_TABLE & " WHERE " &  RECORD_KEY_NAME & " IN (" &  RECORD_KEY_VALUE & ")"
   
   If RECORD_KEY_NAME_EXTRA <> "" THEN
   	   StrSql_DeleteToDB = StrSql_DeleteToDB &  " AND " & RECORD_KEY_NAME_EXTRA & " = '" &  RECORD_KEY_VALUE_EXTRA & "'"
   End IF

  'AQUI: NEW TRANSACTION
   set objRSTs  = objConn.Execute("start transaction")
   set objRSTs  = objConn.Execute("set autocommit = 0")
   ObjConn_DeleteToDB.Execute(StrSql_DeleteToDB)
   If Err.Number <> 0 Then
	  set objRSTs = objConn.Execute("rollback")
	  Mensagem "_database.athdbConn.DeletaDados: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
	  Response.End()
   else
	  set objRSTs = objConn.Execute("commit")
   End If

   If MSG <> 0 Then
	If Err.Number<>0 Then 
      If Err.Number=-2147467259 Then
     	Mensagem "Erro durante a remoção.<br><br>", "Javascript:history.back()", 0
	  Else
	  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1
      End if
	Else
      response.redirect(DEFAULT_LOCATION)
	End if 
   End If
  FechaDBConn ObjConn_DeleteToDB
End Function

'-----------------------------------------------------------------------------------------------------------------
' Busca os direitos no BD de um determinado módulo par aum determinado usuário
'----------------------------------------------------------------------------------------------- by Aless e Clv --
Function BuscaDireitosFromDB(prModulo, prUser)
  Dim objRS_local, objConn_local, strSQL_local, auxSTR
  auxSTR = "|"
  If (prModulo <> "") And (prUser <> "") Then
   AbreDBConn objConn_local, CFG_DB 
   strSQL_local = "SELECT SYS_APP_DIREITO.ID_DIREITO " &_ 
                  "  FROM SYS_APP_DIREITO_USUARIO, SYS_APP_DIREITO " &_
                  " WHERE SYS_APP_DIREITO_USUARIO.COD_APP_DIREITO = SYS_APP_DIREITO.COD_APP_DIREITO " &_
				  "   AND UCase(SYS_APP_DIREITO.ID_APP) = '" & uCase(prModulo) & "'" &_
				  "   AND UCase(SYS_APP_DIREITO_USUARIO.ID_USER) = '" & uCase(prUser) & "'" 
   
   set objRS_local = objConn_local.Execute(strSQL_local)
   while not objRS_local.EOF
     'auxSTR = auxSTR & objRS_local("ID_DIREITO") 'Não usamos a getValue apenas para ser mas rápida a leitura
     auxSTR = auxSTR & GetValue(objRS_local,"ID_DIREITO") & "|"
	 objRS_local.MoveNext
   Wend 
   FechaRecordSet objRS_local  
   FechaDBConn objConn_local
  End If
  BuscaDireitosFromDB = auxSTR
End Function

'-----------------------------------------------------------------------------------------------------------------
' Busca os direitos no BD de um determinado módulo par aum determinado usuário
'----------------------------------------------------------------------------------------------- by Aless e Clv --
function VerificaDireito (prACAO, prPERMISSOES, prSTOP)
  prACAO       = uCase(prACAO)
  prPERMISSOES = uCase(prPERMISSOES)
 'Caso a acao tenha sido passada sem os flips
 if (inSTR(1,prACAO,"|")=0)  then prACAO = "|" & prACAO 
 if (inSTRRev(prACAO,"|")=1) then prACAO = prACAO & "|" 
 '--------------------------------------------------------
 if inSTR(prPERMISSOES,prACAO)>0 then 
	  VerificaDireito = true
 else
   if prSTOP then 
		if  (Session("ID_USER") <> "") then
			Mensagem "Você não possui DIREITOS para esta aplicação/operação! <br> Ação: " & prACAO & " - Permissões: " & prPERMISSOES, "", "", true
		else
			Mensagem "Seu tempo de sessão expirou! Para voltar a trabalhar normalmente, efetue um novo login!", "", "", true
    	end if
	  response.end
    end if
 end if
 end function

'-----------------------------------------------------------------------------------------------------------------
' Efetua o Flush a cada MoveNext (buffer deve estar ligado)
'----------------------------------------------------------------------------------------------- by Aless e Clv --
Sub athMoveNext(prObjRS, byRef prCount, prLimit)
	If (prLimit > 0) Then
		prCount = prCount + 1
		If prCount >= prLimit Then
			Response.Flush()
			prCount = 0
		End If
	End If
	prObjRS.MoveNext
End Sub

function MontaLinkGrade(pr_modulo, pr_pagina, pr_cod, pr_img, pr_title)
Dim strA, strIMG
	strIMG = "<img src='../img/" & pr_img & "' border='0' title='" & pr_title & "'>"
	strA = "<a href='../" & pr_modulo & "/" & pr_pagina & "?var_chavereg=" & pr_cod & "' style='cursor:pointer; text-decoration:none; border:none; outline:none;'>" & strIMG & "</a>"
	MontaLinkGrade = strA
end function

function MontaLinkPopup(pr_modulo, pr_pagina, pr_cod, pr_img, pr_title, pr_width, pr_height, pr_scrollbars)
Dim strA, strIMG
    pr_title = replace (pr_title, " ", "_")
	strIMG = "<img src='../img/" & pr_img & "' border='0' title='" & pr_title & "' alt='" & pr_title & "'>"
	strA = "<a onclick=""Javascript:window.open('../" & pr_modulo & "/" & pr_pagina
	If pr_cod <> "" Then strA = strA & "?var_chavereg=" & pr_cod
	strA = strA & "','','width=" & pr_width & ",height=" & pr_height & ",left=30,top=30,scrollbars=" & pr_scrollbars & ",resizable=yes');"" "
	strA = strA & "style='cursor:pointer; text-decoration:none; border:none; outline:none;'>" & strIMG & "</a>"
	
	MontaLinkPopup = strA
end function

function BuscaUserEMAIL(byref pr_objConn, prUser)
Dim auxObjRS, auxStrSQL

  auxStrSQL = "SELECT EMAIL FROM USUARIO WHERE ID_USUARIO = '" & prUser & "'"
  Set auxObjRS = pr_objConn.Execute(auxStrSQL)
  if not auxObjRS.EOF then
	BuscaUserEMAIL = GetValue(auxObjRS,"EMAIL")
  else
	BuscaUserEMAIL = "ath.virtualboss@gmail.com"
  end if
  FechaRecordSet auxObjRS
end function

function BuscaManagerEMAILS(byref pr_objConn, strEMAILS_DESCARTAR)
Dim strSQL, objRS1, objRS2
Dim strEMAILS
	
	strEMAILS = ""
	
	strSQL = " SELECT AVISAR_MANAGER_BS_TODO FROM CFG_AVISO "
	Set objRS1 = pr_objConn.Execute(strSQL)
	
	If Not objRS1.Eof Then
		If GetValue(objRS1, "AVISAR_MANAGER_BS_TODO") = "1" Then
			strSQL =          " SELECT EMAIL FROM USUARIO WHERE GRP_USER LIKE 'MANAGER' "
			strSQL = strSQL & " AND DT_INATIVO IS NULL "
			strSQL = strSQL & " AND EMAIL <> '' AND EMAIL IS NOT NULL "
			
			Set objRS2 = pr_objConn.Execute(strSQL)
			
			Do While Not objRS2.Eof
				If InStr(strEMAILS_DESCARTAR, "|" & GetValue(objRS2, "EMAIL") & "|") = 0 Then
					strEMAILS = strEMAILS & ";" & GetValue(objRS2, "EMAIL")
				End If
				objRS2.MoveNext
			Loop
			strEMAILS = Mid(strEMAILS, 2)
			
			FechaRecordSet objRS2
		End If
	End If
	FechaRecordSet objRS1
	
	BuscaManagerEMAILS = strEMAILS
end function

function swapString (prStr, prStrA, prStrB)
	if prStr = prStrA then
	  swapString   = prStrB
	else
	   swapString = prStrA
	end if
end function

sub athDebug(prStr, prDie)
	response.Write(prStr)
	if prDie then response.end
end sub

Sub MudaSituacaoBS(byref pr_objConn, prCOD_BOLETIM)
	Dim strSQL,	strSITUACAO
	Dim objRS1, objRS2, objRS3, objRSCTLocal
	Dim strTOTAL1, strTOTAL2, strTOTAL3
	
	strSQL = " SELECT COUNT(COD_TODOLIST) AS TOTAL FROM TL_TODOLIST WHERE SITUACAO LIKE 'ABERTO' AND COD_BOLETIM = " & prCOD_BOLETIM
	Set objRS1 = pr_objConn.Execute(strSQL)
	
	strSQL = " SELECT COUNT(COD_TODOLIST) AS TOTAL FROM TL_TODOLIST WHERE SITUACAO LIKE 'EXECUTANDO' AND COD_BOLETIM = " & prCOD_BOLETIM
	Set objRS2 = pr_objConn.Execute(strSQL)
	
	strSQL = " SELECT COUNT(COD_TODOLIST) AS TOTAL FROM TL_TODOLIST WHERE SITUACAO LIKE 'FECHADO' AND COD_BOLETIM = " & prCOD_BOLETIM
	Set objRS3 = pr_objConn.Execute(strSQL)
	
	strTOTAL1 = 0
	strTOTAL2 = 0
	strTOTAL3 = 0
	
	If Not objRS1.Eof Then strTOTAL1 = CDbl("0" & GetValue(objRS1, "TOTAL"))
	If Not objRS2.Eof Then strTOTAL2 = CDbl("0" & GetValue(objRS2, "TOTAL"))
	If Not objRS3.Eof Then strTOTAL3 = CDbl("0" & GetValue(objRS3, "TOTAL"))
	
	FechaRecordSet objRS1
	FechaRecordSet objRS2
	FechaRecordSet objRS3
	
	strSITUACAO = "EXECUTANDO"
	If strTOTAL1 > 0 And strTOTAL2 = 0 And strTOTAL3 = 0 Then strSITUACAO = "ABERTO"
	If strTOTAL1 = 0 And strTOTAL2 > 0 And strTOTAL3 = 0 Then strSITUACAO = "EXECUTANDO"
	If strTOTAL1 = 0 And strTOTAL2 = 0 And strTOTAL3 > 0 Then strSITUACAO = "FECHADO"
	'Outros casos (tot1 e tot2 > 0, ou tot1 e tot3 > 0, ou tot2 e tot3 > 0) fica EXECUTANDO
	
	strSQL = " UPDATE BS_BOLETIM SET SITUACAO = '"& strSITUACAO &"' WHERE COD_BOLETIM = " & prCOD_BOLETIM
	'AQUI: NEW TRANSACTION
	set objRSCTLocal  = objConn.Execute("start transaction")
	set objRSCTLocal  = objConn.Execute("set autocommit = 0")
	pr_objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCTLocal = objConn.Execute("rollback")
		Mensagem "_database.athdbcon.MudaSituacaoBS: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCTLocal = objConn.Execute("commit")
	End If

End Sub


' ---------------------------------------------------------------------------------------------------------------
' Função que gera um arquivo de LOG na pasta do cliente, este log tem um nome padrão 
' Ex.: yyyy-mm-dd_hh-mm-ss_oper_user (extra).txt, onde 'oper' pode ser INS, UPD ou DEL
'      20101119_15-5-37_DEL_aless (NOTEPAD).txt
' e cada arquivo contém dados extras sobre a operação, o SQL em si e outras informações que se julgarem necessárias
' ---------------------------------------------------------------------------------------------------- by Aless --
function athSaveLog(prOper,prUser,prExtName,prStr)
 Dim strFileName, strFisPath, auxDate 
 Dim oFs, oTextFile
 
 auxDate = now()
 strFileName = DatePart("yyyy", auxDate) & DatePart("m", auxDate) & DatePart("d", auxDate) & "_" 
 strFileName = strFileName & DatePart("h", auxDate) & "-" & DatePart("n", auxDate) & "-" & DatePart("s", auxDate)
 strFileName = strFileName & "_" & ucase(prOper) & "_" & prUser 
 if (prExtName<>"") then strFileName = strFileName & " (" & prExtName & ")" end if
 strFileName = strFileName & ".txt" 

 strFisPath  = FindUploadPath & "\upload\" & Request.Cookies("VBOSS")("CLINAME") & "\_log\"
 'athDebug strFisPath & strFileName, true
 if (CFG_ACTIVE_LOG<>"") then
   if (inStr(CFG_DB,CFG_ACTIVE_LOG)>0) then
		on error resume next
		set oFs = server.createobject("Scripting.FileSystemObject")		
		set oTextFile = oFs.OpenTextFile(strFisPath & strFileName, 2, True)		
		oTextFile.Write prStr
		oTextFile.Close
		set oTextFile = nothing
		set oFS = nothing
   end if
 end if
end function


' ------------------------------------------------------------------------
' Busca dados relativos as informações do site no banco (athcsm.mdb) 
' para montagem na tela principal
'-------------------------------------------------------------- by Aless -
public function MontaArrySiteInfo(byref pr_arrScodi,byref pr_arrSdesc )
Dim strSQL
Dim objConn_CSM, objRS_CSM
Dim auxStrScodi, auxStrSdesc

  AbreDBConn objConn_CSM, CFG_DB

  strSQL = "SELECT COD_INFO, DESCRICAO FROM sys_SITE_INFO"

  set objRS_CSM = objConn_CSM.execute(strSQL)
  
  Do While not objRS_CSM.EOF
    auxStrScodi = auxStrScodi & "|" & objRS_CSM("COD_INFO")
    auxStrSdesc = auxStrSdesc & "|" & objRS_CSM("DESCRICAO")
    objRS_CSM.MoveNext
  Loop
  pr_arrScodi = Split (auxStrScodi, "|")
  pr_arrSdesc = Split (auxStrSdesc, "|")

  FechaRecordSet objRS_CSM
  FechaDBConn ObjConn_CSM
  
end function

Sub IniSessionEVENTO(prObjConn,prCodEvento)
  Dim objRS, Idx, strFIELD, strVALUE
  
  Set objRS = prObjConn.Execute("SELECT * FROM tbl_EVENTO WHERE COD_EVENTO = '" & prCodEvento & "'")
  for Idx = 0 to objRS.fields.count-1 
	strFIELD = objRS.Fields(Idx).name
	strVALUE = GetValue(objRS,strFIELD) 
	Session("METRO_EVENTO_" & strFIELD) = strVALUE
  next

  FechaRecordSet objRS
End sub


Sub IniSessionUSER(prObjConn,prIdUser)
  Dim objRS, Idx, strFIELD, strVALUE
  
  Set objRS = prObjConn.Execute("SELECT * FROM TBL_USUARIO WHERE ID_USER like '" & prIdUser & "'")
  for Idx = 0 to objRS.fields.count-1 
	strFIELD = objRS.Fields(Idx).name
	strVALUE = GetValue(objRS,strFIELD) 
	Session("METRO_USER_" & strFIELD) = strVALUE
  next

  FechaRecordSet objRS
End sub


Sub IniSessionINFO(prObjConn)
  Dim objRS, Idx, strFIELD, strVALUE
  
  Set objRS = prObjConn.Execute("SELECT COD_INFO,DESCRICAO FROM SYS_SITE_INFO")
  Do while not objRS.EOF
	Session("METRO_INFO_" & GetValue(objRS,"COD_INFO") ) = GetValue(objRS,"DESCRICAO") 
  	objRS.Movenext
  Loop

  FechaRecordSet objRS
End sub

'' ===========================================================================
'' ===========================================================================
'Function VerficaAcesso(pr_grp)
'Dim FlagOk, arr_grp, str_grp
'  FlagOk = False
'  if (Session("ID_USER")<>"") then
'    if (Session("GRP_USER")="ADMIN") then 
'      FlagOk = True
'    else
'	  arr_grp = split(pr_grp,",")
'	  For Each str_grp In arr_grp
'       if (Session("GRP_USER")=str_grp) then
'         FlagOk = True
'       end if
'	  Next
'    end if
' end if
' if not FlagOk then 
'   Mensagem "Você não esta autorizado a efetuar esta operação." & _ 
'            "<BR><BR>GRUPO = " & Session("GRP_USER") , "Javascript:history.back()"
'			response.End()
' end if
'End Function
'
'' ===========================================================================
'' ===========================================================================
'Function VerficaAcessoOculto(pr_user)
'Dim objConn, objRS, strSQL, FlagOk
'  FlagOk = False
'  AbreDBConn objConn, CFG_DB
'  strSQL = " SELECT OCULTO FROM tbl_USUARIO WHERE ID_USER = '" & pr_user & "' AND DT_INATIVO IS NULL"
'  Set objRS = objConn.Execute(strSQL)
'  If not objRS.EOF Then
'    If (objRS("OCULTO") = 1) Or (objRS("OCULTO") = True) Then
'      FlagOk = True
'	End If
'  End If
'  FechaRecordSet objRS
'  FechaDBConn objConn
'  
'  if not FlagOk then 
'    Mensagem "Você não esta autorizado a acessar esta área." & _ 
'             "<BR><BR><b>Acesso Restrito a Super Administrador.</b>", "Javascript:history.back()"
'  end if
'  VerficaAcessoOculto = FlagOk
'End Function
'
'
'Public Function MyConnExec(prObjConn, prStrSQL, prMSG, prContinuar)
'
' on error resume next
'    prObjConn.Execute(prStrSQL)
'
' if err.number <> 0 then '80040e14   2147749396
'    Response.write ("<div align='center'><br><br>")
'    Response.write ("<p align='center'><font face='Arial' size='2'><b>.:: AVISO ::.</b></font></p>")
'    Response.write ("<p align='center'><font face='Arial' size='2'>" & prMSG & "<BR>" & "</font></p>")
'    Response.write ("<br><font face='Arial' color='#CCCCCC' size='1'>Informação técnica: " & Err.Description & "</font>")
'    Response.write ("</div>")
'	MyConnExec = False
'    if not prContinuar then response.end
' else
'  MyConnExec = True
' end if
' 
'End Function
'------------------------------------------------------------------------------
' 
'------------------------------------------------------------------ by Aless --

'-----------------------------------------------------------------------------------
' Monta a lista de valores de um combo, do SQL enviado como parametro       by Aless
'Public Function montaCombo(pr_SQL, pr_colValue, pr_colText, pr_Codigo)
'  Dim objRS_local, objConn_local, intCodigo
'  Dim strVALOR, strTEXTO
' 
'  intCodigo = pr_Codigo
'  If intCodigo = "" Then intCodigo = 0  End If
'
'  'Set objRS_local = Server.CreateObject("ADODB.Recordset")
'  'objRS_local.Open pr_SQL, pr_objConn
'  
'  AbreDBConn objConn_local, CFG_DB
'
'  set objRS_local = objConn_local.execute(pr_SQL)	
'  
'  If not objRS_local.EOF Then
'     Do While not objRS_local.EOF
'	   strVALOR = objRS_local(pr_colValue)&""
'	   strTEXTO = objRS_local(pr_colText)&""
'	   
'	   'Response.Write("<option>"&pr_colValue&"-"&pr_colText&"</option><BR>")
'       If cstr(intCodigo&"") = cstr(strVALOR&"") Then
'         Response.Write "<option value='" & strVALOR & "' selected>" & strTEXTO & "</option>"
'       Else
'         Response.Write "<option value='" & strVALOR & "'>" & strTEXTO & "</option>"
'       End If
'       objRS_local.MoveNext
'     Loop
'  End If
'
'  FechaRecordSet objRS_local
'  FechaDBConn objConn_local
'
'End Function

'-----------------------------------------------------------------------------
' Armazena o saldo de cada conta em cada mês
'-----------------------------------------------------------------------------
sub AtualizaSaldo(pr_objConn, pr_cod_conta, pr_DATA, pr_VALOR, pr_RECALCULADO)
Dim objRS_local, strSQL_local, objRSTs
Dim strVALOR
Dim strMES, strANO, strMES_Ant, strANO_Ant
	
'athDebug "<br><br>=======================<br>AtualizaSaldo INI<br>=======================", False
	strMES = DatePart("M",pr_DATA)
	strANO = DatePart("YYYY",pr_DATA)
	strMES_Ant = DatePart("M",DateAdd("M", -1, pr_DATA))
	strANO_Ant = DatePart("YYYY",DateAdd("M", -1, pr_DATA))
	
	strVALOR = pr_VALOR
	
	'----------------------------------------------------------------------------
	' Faz uma consulta para ver se faz um UPDATE ou INSERT na tabela de saldos
	'----------------------------------------------------------------------------
	strSQL_local = "SELECT MES FROM FIN_SALDO_AC WHERE MES=" & strMES & " AND ANO=" & strANO & " AND COD_CONTA=" & pr_cod_conta
'athDebug "<br>strSQL 1: " & strSQL_local, False
	
	Set objRS_local = pr_objConn.Execute(strSQL_local)
	
	if GetValue(objRS_local,"MES")<>"" then
		strVALOR = FormataDecimal(strVALOR, 2)
		strVALOR = FormataDouble(strVALOR, 2)
		
		strSQL_local =                " UPDATE FIN_SALDO_AC "
		strSQL_local = strSQL_local & " SET SYS_COD_USER_ULT_LCTO='" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
		If pr_RECALCULADO = False Then
			strSQL_local = strSQL_local & "   , VALOR = VALOR + " & strVALOR 
		Else
			strSQL_local = strSQL_local & "   , VALOR = " & strVALOR
			strSQL_local = strSQL_local & "   , RECALCULADO = -1 "
		End If
		strSQL_local = strSQL_local & " WHERE MES=" & strMES & " AND ANO=" & strANO & " AND COD_CONTA=" & pr_cod_conta
'athDebug "<br>strSQL 2: " & strSQL_local, False
		
		'AQUI: NEW TRANSACTION
		set objRSTs  = objConn.Execute("start transaction")
		set objRSTs  = objConn.Execute("set autocommit = 0")
		pr_objConn.Execute(strSQL_local)
		If Err.Number <> 0 Then
			set objRSTs = objConn.Execute("rollback")
			Mensagem "_database.athdbConn.AtualizaSaldo A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSTs = objConn.Execute("commit")
		End If
		
	else
		If pr_RECALCULADO = False Then
			'--------------------------------------------------------
			' Busca saldo do mês anterior ou então o saldo inicial
			'--------------------------------------------------------
			strSQL_local =                " SELECT VALOR FROM FIN_SALDO_AC "
			strSQL_local = strSQL_local & " WHERE MES=" & strMES_Ant & " AND ANO=" & strANO_Ant & " AND COD_CONTA=" & pr_cod_conta
'athDebug "<br>strSQL 3: " & strSQL_local, False
			
			Set objRS_local = pr_objConn.Execute(strSQL_local)
			
			if GetValue(objRS_local,"VALOR")<>"" then 
				strVALOR = strVALOR + CDbl(GetValue(objRS_local,"VALOR"))
			else
				strSQL_local = " SELECT VLR_SALDO_INI AS VALOR FROM FIN_CONTA WHERE COD_CONTA=" & pr_cod_conta
'athDebug "<br>strSQL 4: " & strSQL_local, False
				
				Set objRS_local = pr_objConn.Execute(strSQL_local)
				
				if GetValue(objRS_local,"VALOR")<>"" then 
					strVALOR = strVALOR + CDbl(GetValue(objRS_local,"VALOR"))
				end if
			end if
			'FechaRecordSet objRS_local
			
			strVALOR = FormataDecimal(strVALOR, 2)
			strVALOR = FormataDouble(strVALOR, 2)
			
			strSQL_local =                " INSERT INTO FIN_SALDO_AC (COD_CONTA,MES,ANO,VALOR,SYS_COD_USER_ULT_LCTO) "
			strSQL_local = strSQL_local & " VALUES(" & pr_cod_conta & "," &	strMES & "," & strANO & "," & strVALOR & ",'" & Request.Cookies("VBOSS")("ID_USUARIO") & "')"
'athDebug "<br>strSQL 5: " & strSQL_local, False
			
			'AQUI: NEW TRANSACTION
			set objRSTs  = objConn.Execute("start transaction")
			set objRSTs  = objConn.Execute("set autocommit = 0")
			pr_objConn.Execute(strSQL_local)
			If Err.Number <> 0 Then
				set objRSTs = objConn.Execute("rollback")
				Mensagem "_database.athdbConn.AtualizaSaldo B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSTs = objConn.Execute("commit")
			End If

		Else
			strVALOR = FormataDecimal(strVALOR, 2)
			strVALOR = FormataDouble(strVALOR , 2)
			
			strSQL_local =                " INSERT INTO FIN_SALDO_AC (COD_CONTA,MES,ANO,VALOR,SYS_COD_USER_ULT_LCTO,RECALCULADO) "
			strSQL_local = strSQL_local & " VALUES(" & pr_cod_conta & "," &	strMES & "," & strANO & "," & strVALOR & ",'" & Request.Cookies("VBOSS")("ID_USUARIO") & "', -1)"
'athDebug "<br>strSQL 6: " & strSQL_local, False
			

			'AQUI: NEW TRANSACTION
			set objRSTs  = objConn.Execute("start transaction")
			set objRSTs  = objConn.Execute("set autocommit = 0")
			pr_objConn.Execute(strSQL_local)
			If Err.Number <> 0 Then
				set objRSTs = objConn.Execute("rollback")
				Mensagem "_database.athdbConn.AtualizaSaldo B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSTs = objConn.Execute("commit")
			End If

		End If
	end if
	
	FechaRecordSet objRS_local
'athDebug "<br><br>=======================<br>AtualizaSaldo FIM<br>=======================", False
end sub


'-----------------------------------------------------------------------------
' Verifica se existem meses anteriores faltando e as insere
'-----------------------------------------------------------------------------
sub PreencheLacunas(pr_objConn, pr_cod_conta, pr_DATA)
Dim objRS_local, strSQL_local
Dim strMES, strANO, strMES_Ant, strANO_Ant
Dim strDATA1, strDATA2
	
'athDebug "<br><br>=======================<br>PreencheLacunas INI<br>=======================", False
	strMES = DatePart("M",pr_DATA)
	strANO = DatePart("YYYY",pr_DATA)
	strMES_Ant = DatePart("M",DateAdd("M", -1, pr_DATA))
	strANO_Ant = DatePart("YYYY",DateAdd("M", -1, pr_DATA))
	
	'---------------------------------------------
	' Busca ANO e MÊS do último saldo inserido
	'---------------------------------------------
	strSQL_local =                " SELECT ANO, MES FROM FIN_SALDO_AC "
	strSQL_local = strSQL_local & " WHERE COD_CONTA=" & pr_cod_conta 
	strSQL_local = strSQL_local & " AND ((MES < " & strMES & " AND ANO = " & strANO & ") OR (ANO < " & strANO & "))"
	strSQL_local = strSQL_local & " ORDER BY ANO DESC, MES DESC LIMIT 1 "
'athDebug "<br><br>" & strSQL_local, False
	
	Set objRS_local = pr_objConn.Execute(strSQL_local)
	
	if (GetValue(objRS_local,"ANO")<>"") And (GetValue(objRS_local,"MES")<>"") then 
		if (strMES_Ant <> GetValue(objRS_local,"MES")) or (strANO_Ant <> GetValue(objRS_local,"ANO")) then
			'--------------------------------------------------
			' Se são diferentes é porque existe(m) lacuna(s)
			'--------------------------------------------------
			strDATA1 = DateSerial(GetValue(objRS_local,"ANO"),GetValue(objRS_local,"MES"),"01")
			strDATA2 = DateSerial(strANO_Ant,strMES_Ant,"01")
'athDebug "<br>DATA1: " & strDATA1, False
'athDebug "<br>DATA2: " & strDATA2, False
			
			while (strDATA1 < strDATA2)
				strDATA1 = DateAdd("M", 1, strDATA1)
'athDebug "<br>--->DATA: " & strDATA1, False
				AtualizaSaldo pr_objConn, pr_cod_conta, strDATA1, 0, False
			wend
		end if
	end if
	FechaRecordSet objRS_local
'athDebug "<br><br>=======================<br>PreencheLacunas FIM<br>=======================", False
end sub


'-----------------------------------------------------------------------------
' Armazena o saldo de cada conta em cada mês
'-----------------------------------------------------------------------------
sub AcumulaSaldoNovo(pr_objConn, pr_cod_conta, pr_DATA, pr_VALOR)
Dim objRS_local, strSQL_local
Dim strMES, strANO, strDATA1, strDATA2
Dim iANO_F, iMES_F, iANO, iMES
	
'athDebug "<br><br>=======================<br>AcumulaSaldoNovo INI<br>=======================", False
	strMES = DatePart("M",pr_DATA)			
	strANO = DatePart("YYYY",pr_DATA)		
	iMES = CInt(strMES)
	iANO = CInt(strANO)
	
	'------------------------------------------------------------------
	' Verifica se existe alguna lacuna entre o último mês cadastrado 
	' no saldo acumulado e o mês desse lançamento, se tiver preenche
	'------------------------------------------------------------------
	PreencheLacunas pr_objConn, pr_cod_conta, pr_DATA
	
	'-----------------------------
	' Atualiza saldo da conta
	'-----------------------------
	AtualizaSaldo pr_objConn, pr_cod_conta, pr_DATA, pr_VALOR, False
	
	'------------------------------------------------------
	' Busca maiores ANO e MES para recálculo dos saldos
	'------------------------------------------------------
	strSQL_local = 					" SELECT MAX(MES) AS MAIOR_MES, ANO "  
	strSQL_local = strSQL_local &	" FROM FIN_SALDO_AC "
	strSQL_local = strSQL_local &	" WHERE ANO = (SELECT MAX(ANO) AS MAIOR_ANO FROM FIN_SALDO_AC WHERE COD_CONTA=" & pr_cod_conta & ") AND COD_CONTA=" & pr_cod_conta
	strSQL_local = strSQL_local &	" GROUP BY ANO "
'athDebug "<br><br>" & strSQL_local, False
	
	Set objRS_local = pr_objConn.Execute(strSQL_local)
	
	iANO_F = 0
	iMES_F = 0
	if not objRS_local.eof then
		iANO_F = GetValue(objRS_local,"ANO")
		iMES_F = GetValue(objRS_local,"MAIOR_MES")
'athDebug "<br>" & iANO_F, False
'athDebug "<br>" & iMES_F, False
	end if
	FechaRecordSet objRS_local
	
	'-----------------------------------------------------
	' Monta as datas limites para efetuar os recálculos
	'-----------------------------------------------------
	strDATA1 = DateSerial(iANO,iMES,"01")
	strDATA2 = DateSerial(iANO_F,iMES_F,"01")
	
'athDebug "<br>strDATA1: " & strDATA1, False
'athDebug "<br>strDATA2: " & strDATA2, False
	while (strDATA1 < strDATA2)
		strDATA1 = DateAdd("M", 1, strDATA1)
'athDebug "<br>->strDATA1: " & strDATA1, False
		RecalculaSaldo pr_objConn, pr_cod_conta, strDATA1
	wend
'athDebug "<br><br>=======================<br>AcumulaSaldoNovo FIM<br>=======================", False
'athDebug "<br><br>", False
end sub

'-----------------------------------------------------------------------------
' Pega o saldo do mês anterior ao informado e recalcula o saldo do mês atual 
' baseado nos lançamentos do mês atual e saldo do mês anterior
'-----------------------------------------------------------------------------
sub RecalculaSaldo(pr_objConn, pr_cod_conta, pr_DATA)
Dim objRS_local, strSQL_local
Dim strMES, strANO, strMES_Ant, strANO_Ant
Dim strSALDO, strENTRADA, strSAIDA
	
'athDebug "<br><br>=======================<br>RecalculaSaldo INI<br>=======================", False
	strMES = DatePart("M",pr_DATA)
	strANO = DatePart("YYYY",pr_DATA)	
	strMES_Ant = DatePart("M",DateAdd("M", -1, pr_DATA))
	strANO_Ant = DatePart("YYYY",DateAdd("M", -1, pr_DATA))
	
	'--------------------------------------------------------
	' Busca saldo do mês anterior ou então o saldo inicial
	'--------------------------------------------------------
	strSQL_local = " SELECT VALOR FROM FIN_SALDO_AC WHERE MES=" & strMES_Ant & " AND ANO=" & strANO_Ant & " AND COD_CONTA=" & pr_cod_conta
'athDebug "<br>strSALDO: " & strSALDO, False
	Set objRS_local = pr_objConn.Execute(strSQL_local)
	
	strSALDO = 0
	if GetValue(objRS_local,"VALOR")<>"" then 
		strSALDO = strSALDO + CDbl(GetValue(objRS_local,"VALOR"))
	else
		strSQL_local = " SELECT VLR_SALDO_INI AS VALOR FROM FIN_CONTA WHERE COD_CONTA=" & pr_cod_conta
		Set objRS_local = pr_objConn.Execute(strSQL_local)
		
		if GetValue(objRS_local,"VALOR")<>"" then 
			strSALDO = strSALDO + CDbl(GetValue(objRS_local,"VALOR"))
		end if
	end if
	FechaRecordSet objRS_local
	
	'-----------------------------------------------------------------------------------------------------------
	' Busca os totais de lançamentos do mês em Lctos em Conta, de Transferência e em Contas a Pagar e Receber
	' Depois recalcula o valor da CONTA informada, através do ÚLTIMO saldo RECALCULADO + LCTOS DO MES ATUAL
	'-----------------------------------------------------------------------------------------------------------
	strSQL_local =  " SELECT 'LCTO_EM_CONTA' AS TIPO " &_
					"       ,SUM(VLR_LCTO) AS ENTRADA " &_
					"       ,(SELECT SUM(VLR_LCTO) FROM FIN_LCTO_EM_CONTA WHERE COD_CONTA=" & pr_cod_conta & " AND OPERACAO='DESPESA' AND Month(DT_LCTO)=" & strMES & " AND Year(DT_LCTO)=" & strANO & ") AS SAIDA " &_
					" FROM " &_
					"	FIN_LCTO_EM_CONTA "	&_
					" WHERE COD_CONTA=" & pr_cod_conta & " AND OPERACAO='RECEITA' AND Month(DT_LCTO)=" & strMES & " AND Year(DT_LCTO)=" & strANO
'athDebug "<br><br>SQL 1: " & strSQL_local, False
	Set objRS_local = pr_objConn.Execute(strSQL_local)
	
	if not objRS_local.eof then
'athDebug "<br><br>strSALDO antes: " & strSALDO, False
		if GetValue(objRS_local,"ENTRADA")<>"" then	strSALDO = strSALDO + CDbl(GetValue(objRS_local,"ENTRADA"))
		if GetValue(objRS_local,"SAIDA")<> ""  then	strSALDO = strSALDO - CDbl(GetValue(objRS_local,"SAIDA"))
'athDebug "<br><br>strSALDO depois: " & strSALDO, False
	end if
	FechaRecordSet objRS_local
	
	
	strSQL_local =  " SELECT 'CONTA_PAGAR_RECEBER' AS TIPO "  &_
					"       ,SUM(VLR_LCTO) AS ENTRADA " &_
					"       ,(SELECT SUM(VLR_LCTO) FROM FIN_LCTO_ORDINARIO ORD INNER JOIN FIN_CONTA_PAGAR_RECEBER PR ON (ORD.COD_CONTA_PAGAR_RECEBER=PR.COD_CONTA_PAGAR_RECEBER) WHERE PR.SYS_DT_CANCEL IS NULL AND ORD.SYS_DT_CANCEL IS NULL AND PR.PAGAR_RECEBER<>0 AND ORD.COD_CONTA=" & pr_cod_conta  &" AND Month(DT_LCTO)=" & strMES & " AND Year(DT_LCTO)=" & strANO & ") AS SAIDA " &_
					" FROM " &_
					"	FIN_LCTO_ORDINARIO ORD " &_
					" INNER JOIN " &_
					"	FIN_CONTA_PAGAR_RECEBER PR ON (ORD.COD_CONTA_PAGAR_RECEBER=PR.COD_CONTA_PAGAR_RECEBER) " &_
					" WHERE PR.SYS_DT_CANCEL IS NULL AND ORD.SYS_DT_CANCEL IS NULL AND PR.PAGAR_RECEBER=0 AND ORD.COD_CONTA= " & pr_cod_conta & " AND Month(DT_LCTO)=" & strMES & " AND Year(DT_LCTO)=" & strANO
'athDebug "<br><br>SQL 2: " & strSQL_local, False
	Set objRS_local = pr_objConn.Execute(strSQL_local)
	
	if not objRS_local.eof then
'athDebug "<br><br>strSALDO antes: " & strSALDO, False
		if GetValue(objRS_local,"ENTRADA")<>"" then	strSALDO = strSALDO + CDbl(GetValue(objRS_local,"ENTRADA"))
		if GetValue(objRS_local,"SAIDA")<> ""  then	strSALDO = strSALDO - CDbl(GetValue(objRS_local,"SAIDA"))
'athDebug "<br><br>strSALDO depois: " & strSALDO, False
	end if
	FechaRecordSet objRS_local
	
	
	strSQL_local =  " SELECT 'LCTO_TRANSF' AS TIPO " &_
					"       ,SUM(VLR_LCTO) AS ENTRADA "	&_
					"       ,(SELECT SUM(VLR_LCTO) FROM FIN_LCTO_TRANSF WHERE COD_CONTA_ORIG=" & pr_cod_conta & " AND Month(DT_LCTO)=" & strMES & " AND Year(DT_LCTO)=" & strANO & ") AS SAIDA " &_
					" FROM " &_
					"	FIN_LCTO_TRANSF " &_
					" WHERE COD_CONTA_DEST=" & pr_cod_conta & " AND Month(DT_LCTO)=" & strMES & " AND Year(DT_LCTO)=" & strANO
'athDebug "<br><br>SQL 3: " & strSQL_local, False
	Set objRS_local = pr_objConn.Execute(strSQL_local)
	
	if not objRS_local.eof then
'athDebug "<br><br>strSALDO antes: " & strSALDO, False
		if GetValue(objRS_local,"ENTRADA")<>"" then	strSALDO = strSALDO + CDbl(GetValue(objRS_local,"ENTRADA"))
		if GetValue(objRS_local,"SAIDA")<> ""  then	strSALDO = strSALDO - CDbl(GetValue(objRS_local,"SAIDA"))
'athDebug "<br><br>strSALDO depois: " & strSALDO, False
	end if
	FechaRecordSet objRS_local
	
	'-----------------------------
	' Atualiza saldo da conta
	'-----------------------------
'athDebug "<br><br>AtualizaSaldo pr_objConn, pr_cod_conta, pr_DATA, strSALDO, True", False
'athDebug "<br>strSALDO: " & strSALDO, False
	AtualizaSaldo pr_objConn, pr_cod_conta, pr_DATA, strSALDO, True
'athDebug "<br><br>=======================<br>RecalculaSaldo FIM<br>=======================", False
end sub
%>