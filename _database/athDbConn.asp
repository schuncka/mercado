<%
  Session.LCID    		= 1046
  Session.Timeout 		= 720
  Server.ScriptTimeout	= 3600 '1h

  Response.Expires		= 0 
  Response.Buffer		= True 'Para uso adequado da athMoveNext
 
  Response.CacheControl = "no-cache"
  Response.AddHeader "Content-Type","text/html; charset=iso-8859-1" 
  Response.AddHeader "Pragma","no-cache"
 
  Dim CFG_FLUSH_LIMIT, ContFlush

  ContFlush		  = 0   'Usada no controle da athMoveNext
  CFG_FLUSH_LIMIT = 500 'Limite de registros para execução do Flush no movenext


Sub AbreDBConn(byref pr_objConn, byval pr_StrDataBase)
	Dim auxmappath, strConnection, strDBUsername, strDBPassword
	Dim objFSO, strPath, aviso, arrCliFolders, auxIDSemPrefix
	Dim auxStr, auxUSERdb, auxUSERdbSufix

    On Error Resume Next
    
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


	Set pr_objConn = Server.CreateObject("ADODB.Connection")

	If instr(pr_StrDataBase,"DSN=") > 0 Then 
	   'CONEXÃO VIA DSN -----------------------------------------------------------------------------
		strConnection   = pr_StrDataBase
		strDBUsername   = ""
		strDBPassword   = ""
		pr_objConn.Open strConnection, strDBUsername, strDBPassword
	   '---------------------------------------------------------------------------------------------
	Else
		arrCliFolders  = split(GetCliFolderNames("../"),";")
		auxIDSemPrefix = LCase(replace(pr_StrDataBase,"vboss_",""))
		
		If instr(auxIDSemPrefix,"-")>0 Then
		  auxIDSemPrefix = Mid(auxIDSemPrefix,1,instr(auxIDSemPrefix,"-")-1)	
		End If
		If pr_StrDataBase <> "" Then 
			auxUSERdb = MontaDbUserName(CFG_DB_DADOS_USER, pr_StrDataBase)
			
			strConnection = "Provider=MSDASQL;driver={MySQL ODBC 5.1 Driver};server="&CFG_PATH&";uid="&CFG_DB_DADOS_USER&";pwd="&CFG_DB_DADOS_PWD&";database="&pr_StrDataBase
			'athDebug strConnection, true

			pr_objConn.Open strConnection
			
			If Err.Number <> 0 Then
				  Response.Write "<div align=""center""><font face=""Verdana"" size=""2""><br>O sistema Mercado está indisponível.<br>Tente mais tarde ou entre em contato com suporte.<br></font>"
				  Response.Write "<font face=""Verdana"" size=""1"" color='#FFFFFF'>"
				  Response.Write "<br>(" & strConnection & ")"
				  Response.Write "<br>" & err.Description & "<br>" & pr_StrDataBase
				  Response.Write "<br>" & CFG_PATH & pr_StrDataBase
				  Response.Write "</font>"
				  Response.Write "</div>"
				  Response.End
			End If
			
		Else
			Response.Write("<br><br>")
			
			If (ArrayIndexOf(arrCliFolders,auxIDSemPrefix)<0) Then
				aviso = "Identificador de grupo INVÁLIDO.<br>Se você tem alguma dúvida sobre o seu identificador de grupo, <br>usuário ou senha entre em contato com o administrador.<br><br>Identificador digitado: " & pr_StrDataBase
				Mensagem aviso, ""
			Else
				aviso = "O sistema encontra-se em manutenção.<br>Aguarde alguns instantes e tente novamente, ou entre em contato com o administrador.<br><br>MySQL: " & pr_StrDataBase
				Mensagem aviso, ""
			End if
			
			Response.End()
		End If
	End If
End Sub
 
'-------------------------------------------------------------------------------
Function MontaDbUserName(prDefault, prDataBase)
	Dim auxStr, auxUSERdbSufix, auxUSERdb
	
	auxStr = lcase(Request.ServerVariables("SCRIPT_NAME")) 
   	IF (instr(auxStr,"www.") = 0) then ' SE ESTIVER NA ATHENAS 	
	  auxUSERdb = prDefault
   	ELSE
	 auxUSERdb = replace(prDataBase,"vboss_","")	
  	 auxUSERdbSufix = ""
	 IF (instr(auxUSERdb,"-") > 0) then
	   auxUSERdbSufix = Mid(auxUSERdb, instr(auxUSERdb,"-"), 3)
	   auxStr = replace(auxUSERdb,auxUSERdbSufix,"")
	 END IF	 
	 auxUSERdb = Mid(auxUSERdb, 1, 10) & replace(auxUSERdbSufix,"-","_")
	END IF
	
	MontaDbUserName = auxUSERdb
End Function
'-------------------------------------------------------------------------------

Function MontaDbDriver(prDefault)
 Dim auxStr
 
 auxStr = lcase(Request.ServerVariables("SCRIPT_NAME"))
 IF (instr(auxStr,"www.") = 0) then  
   MontaDbDriver = prDefault
 ELSE
   MontaDbDriver = "MySQL ODBC 3.51 Driver" 
 END IF
End Function

Function FindBDPath
  Dim auxmappath
  auxmappath = lcase(server.mappath("/"))
  If instr(auxmappath,"wwwroot")>0 then 'LOCAL - conforme o nosso servidor: ZEUS
    if instr(auxmappath,"domains")>0 then
      auxmappath = replace(auxmappath,"wwwroot", "db\") 'SOUTHTECH
	else
	  auxmappath = auxmappath & "\web_systems\virtualboss" & CFG_DIR & "\db\"  'ATHENAS
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
  Dim auxmappath
  auxmappath = lcase(server.mappath("/"))
  If instr(auxmappath,"wwwroot")>0 then 'LOCAL - conforme o nosso servidor: ZEUS
    if instr(auxmappath,"domains")>0 then
      auxmappath = auxmappath & CFG_DIR 'SOUTHTECH
	else
	  auxmappath = auxmappath & "\web_systems\virtualboss" & CFG_DIR  'ATHENAS
	end if
  else
    if instr(auxmappath,"home")>0 then
	  auxmappath = auxmappath & CFG_DIR 'LOCAWEB v1
	else 
	  if instr(auxmappath,"httpdocs")>0 then 'LOCAWEB v2
	    auxmappath = auxmappath & CFG_DIR
	  else
        auxmappath = auxmappath & CFG_DIR 'PLUGIN 
	  end if
	end if
  End If
  FindUploadPath = auxmappath
End Function

Function FindPhysicalPath(pr_pasta)
  Dim auxmappath
  auxmappath = lcase(server.mappath("/"))
  If instr(auxmappath,"wwwroot")>0 then 'LOCAL - conforme o nosso servidor: ZEUS
    if instr(auxmappath,"domains")>0 then
      auxmappath = auxmappath & CFG_DIR 'SOUTHTECH
	else
	  auxmappath = auxmappath & "\web_systems" & pr_pasta 'ATHENAS  local-mudar...
	end if
  else
  	'LOCAWEB v1 Ou LOCAWEB v2 Ou PLUGIN
  	auxmappath = auxmappath & "\" & pr_pasta 
  End If
  FindPhysicalPath = auxmappath
End Function

Function FindLogicalPath()
  Dim auxmappath
  auxmappath = lcase(server.mappath("/"))
  If instr(auxmappath,"wwwroot")>0 then 
    if instr(auxmappath,"domains")>0 then
      auxmappath = "http://servidor.clicmercado.com.br/mercado" 'SOUTHTECH
	else
	  auxmappath = "http://" & Request.ServerVariables("HTTP_HOST") & "/dropbox/mercado" 'ATHENAS
	end if
  else
  	'LOCAWEB v1 Ou LOCAWEB v2 Ou PLUGIN
  	auxmappath = "http://servidor.clicmercado.com.br/mercado"
  End If
  FindLogicalPath = auxmappath
End Function

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

'Sub AbreRecordSet(byref pr_objRS, pr_strSQL, pr_objConn, pr_cursor)
'  Set pr_objRS = Server.CreateObject("ADODB.RecordSet")
'  pr_objRS.Open pr_strSQL, pr_objConn, pr_cursor
'End Sub

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
Sub Mensagem(pr_aviso, pr_hyperlink)
  Response.Write ("<p align='center'><font face='Arial, Helvetica, sans-serIf' size='2'><b>.:: INFO ::.</b></font></p>")
  Response.Write ("<p align='center'><font face='Arial, Helvetica, sans-serIf' size='2'>" & pr_aviso & "</font></p>")
  Response.Write ("<p align='center'><font face='Arial, Helvetica, sans-serIf' size='2'>" )
  If pr_hyperlink<>"" then  
    'Response.Write ("<a href='" & pr_hyperlink & "'>Voltar</a>")
	Response.Write ("<a href='" & pr_hyperlink & "' id='click'>Voltar</a><script language=javascript>document.getElementById('click').click()</script>")
  End If
  Response.Write ("</font></p>")
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

' ===========================================================================
' Facilita a consistência para saber se os campos requeridos foram informados
' ===========================================================================
Function FiedsRequired(pr_bolFieldsRequired)
  If pr_bolFieldsRequired Then
    Mensagem "Você tem que preencher todos os campos obrigatórios.", "Javascript:history.back()"
  End If
  FiedsRequired = not pr_bolFieldsRequired
End Function

' ===========================================================================
' ===========================================================================
Function VerficaAcesso(pr_grp)
Dim FlagOk, arr_grp, str_grp
  FlagOk = False
  if (Session("ID_USER")<>"") then
    if (Session("GRP_USER")="ADMIN") then 
      FlagOk = True
    else
	  arr_grp = split(pr_grp,",")
	  For Each str_grp In arr_grp
       if (Session("GRP_USER")=str_grp) then
         FlagOk = True
       end if
	  Next
    end if
 end if
 if not FlagOk then 
   Mensagem "Você não esta autorizado a efetuar esta operação." & _ 
            "<BR><BR>GRUPO = " & Session("GRP_USER") , "Javascript:history.back()"
			response.End()
 end if
End Function

' ===========================================================================
' ===========================================================================
Function VerficaAcessoOculto(pr_user)
Dim objConn_Local, objRS_Local, strSQL_Local, FlagOk
  FlagOk = False
  AbreDBConn objConn_Local, CFG_DB_DADOS
  strSQL_Local = " SELECT OCULTO FROM tbl_USUARIO WHERE ID_USER = '" & pr_user & "' AND DT_INATIVO IS NULL"
  Set objRS_Local = objConn_Local.Execute(strSQL_Local)
  If not objRS_Local.EOF Then
    If (objRS_Local("OCULTO") = 1) Or (objRS_Local("OCULTO") = True) Then
      FlagOk = True
	End If
  End If
  FechaRecordSet objRS_Local
  FechaDBConn objConn_Local
  
  if not FlagOk then 
    Mensagem "Você não esta autorizado a acessar esta área." & _ 
             "<BR><BR><b>Acesso Restrito a Super Administrador.</b>", "Javascript:history.back()"
  end if
  VerficaAcessoOculto = FlagOk
End Function


Public Function MyConnExec(prObjConn, prStrSQL, prMSG, prContinuar)

 on error resume next
    prObjConn.Execute(prStrSQL)

 if err.number <> 0 then '80040e14   2147749396
    Response.write ("<div align='center'><br><br>")
    Response.write ("<p align='center'><font face='Arial' size='2'><b>.:: AVISO ::.</b></font></p>")
    Response.write ("<p align='center'><font face='Arial' size='2'>" & prMSG & "<BR>" & "</font></p>")
    Response.write ("<br><font face='Arial' color='#CCCCCC' size='1'>Informação técnica: " & Err.Description & "</font>")
    Response.write ("</div>")
	MyConnExec = False
    if not prContinuar then response.end
 else
  MyConnExec = True
 end if
 
End Function
'------------------------------------------------------------------------------
' 
'------------------------------------------------------------------ by Aless --
sub BuscaFields(prModulo, prTabela, byRef prRetFields, byRef prRetTam, byRef prRetOrdem)
Dim objRS_local, objConn_local, strSQL_Local, CLocal
Dim auxSTR_Field, auxSTR_Tam, auxSTR_Ordem

 AbreDBConn objConn_local, CFG_DB_DADOS

 strSQL_Local = "SELECT CAMPO,TAMANHO,ORDENACAO FROM SYS_FIELDS_QUERY WHERE TABELA = '" & prTabela & "' AND DT_INATIVO IS NULL "
 if (CStr(prModulo)<>"") then 
   strSQL_Local = strSQL_Local & " AND MODULO = '" & prModulo & "' "
 else 
   strSQL_Local = strSQL_Local & " AND MODULO = 'DEFAULT' " 
 end if
 strSQL_Local = strSQL_Local & " ORDER BY ORDEM"
 set objRS_local = objConn_local.Execute(strSQL_Local)

 auxSTR_Field = ""
 auxSTR_Tam   = ""
 auxSTR_Ordem = ","
 cLocal = 1
 while not objRS_local.EOF 
   auxSTR_Field = auxSTR_Field & "," & prTabela & "." & objRS_local("CAMPO")
   auxSTR_Tam   = auxSTR_Tam   & "," & objRS_local("TAMANHO")
   auxSTR_Ordem = auxSTR_Ordem & "," & prTabela & "." & objRS_local("CAMPO") & " " & objRS_local("ORDENACAO")
   cLocal = cLocal + 1
   objRS_local.movenext
 wend 
 'Retorna com uma vírgula na frente para facilitar a concatenação nos select 
 'que sempre terão o campo COD_ com inicia;
 prRetFields = auxSTR_Field
 prRetTam    = auxSTR_Tam
 prRetOrdem  = replace(auxSTR_Ordem,",,","")
 
 if prRetOrdem="," then prRetOrdem = " 1 "

 FechaRecordSet objRS_local 
 FechaDBConn objConn_local 
End Sub


'-----------------------------------------------------------------------------------------------------------------
' Busca os direitos no BD de um determinado módulo par aum determinado usuário
'----------------------------------------------------------------------------------------------- by Aless e Clv --
Function BuscaDireitosFromDB(prModulo, prUser)
  Dim objRS_local, objConn_local, strSQL_local, auxSTR
  auxSTR = "|"
  If (prModulo <> "") And (prUser <> "") Then
   AbreDBConn objConn_local, CFG_DB_DADOS 
   strSQL_local = "SELECT SYS_APP_DIREITO.ID_DIREITO " &_ 
                  "  FROM SYS_APP_DIREITO_USUARIO, SYS_APP_DIREITO " &_
                  " WHERE SYS_APP_DIREITO_USUARIO.COD_APP_DIREITO = SYS_APP_DIREITO.COD_APP_DIREITO " &_
				  "   AND UCase(SYS_APP_DIREITO.ID_APP) = '" & uCase(prModulo) & "'" &_
				  "   AND UCase(SYS_APP_DIREITO_USUARIO.ID_USUARIO) = '" & uCase(prUser) & "'" 
   
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
		if (Session("ID_USER") <> "") then
			Mensagem "Você não possui DIREITOS para esta aplicação/operação! <br> Ação: " & prACAO & " - Permissões: " & prPERMISSOES, "Javascript:history.back()"
		else
			Mensagem "Seu tempo de sessão expirou! Para voltar a trabalhar normalmente, efetue um novo login!", "Javascript:history.back()"
    	end if
	  response.end
    end if
 end if
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
			strVALOR = FormataDouble(strVALOR,2)
			
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
			strVALOR = FormataDouble(strVALOR,2)
			
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