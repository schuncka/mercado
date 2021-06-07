<%
session.lcid = 1046
 
'-----------------------------------------------------------------------------
Public Function MesExtenso(iMes)
  Select Case iMes
    Case 1:	  MesExtenso = "Janeiro"
    Case 2:	  MesExtenso = "Fevereiro"
    Case 3:	  MesExtenso = "Março"
    Case 4:	  MesExtenso = "Abril"
    Case 5:	  MesExtenso = "Maio"
    Case 6:	  MesExtenso = "Junho"
    Case 7:	  MesExtenso = "Julho"
    Case 8:	  MesExtenso = "Agosto"
    Case 9:	  MesExtenso = "Setembro"
    Case 10:  MesExtenso = "Outubro"
    Case 11:  MesExtenso = "Novembro"
    Case 12:  MesExtenso = "Dezembro"
    Case Else:  MesExtenso = "Indefinido"
  End Select	
End Function

' ------------------------------------------------------------------------
' Faz o DECODE de uma string que estiver Encoded:
' exemplo: aux = "http%3A%2F%2Fwww%2Eissi%2Enet "
'          URLDecode(Aux)
'          => aux será igual a "http://www.issi.net"
'-------------------------------------------------------------- by Aless -

Function URLDecode(S3Decode)
Dim S3Temp(1,1)
Dim S3In, S3Out, S3Pos, S3Len, S3i

 S3In  = S3Decode
 S3Out = ""
 S3In  = Replace(S3In, "+", " ")
 S3Pos = Instr(S3In, "%")
 Do While S3Pos
	S3Len = Len(S3In)
	If S3Pos > 1 Then S3Out = S3Out & Left(S3In, S3Pos - 1)
	S3Temp(0,0) = Mid(S3In, S3Pos + 1, 1)
	S3Temp(1,0) = Mid(S3In, S3Pos + 2, 1)
	For S3i = 0 to 1
		If Asc(S3Temp(S3i,0)) > 47 And Asc(S3Temp(S3i, 0)) < 58 Then
			S3Temp(S3i, 1) = Asc(S3Temp(S3i, 0)) - 48
		Else
			S3Temp(S3i, 1) = Asc(S3Temp(S3i, 0)) - 55
		End If
	Next
	S3Out = S3Out & Chr((S3Temp(0,1) * 16) + S3Temp(1,1))
	S3In  = Right(S3In, (S3Len - (S3Pos + 2)))
	S3Pos = Instr(S3In, "%")
 Loop
 URLDecode = S3Out & S3In
End Function

Public Function MontaObjContainer(pr_ObjName, pr_strSQL )
Dim objConn_CSM, objRS_CSM
Dim auxStrScodi, auxStrSVal

  AbreDBConn objConn_CSM, CFG_DB
  Set objRS_CSM = objConn_CSM.execute(pr_strSQL)

  pr_ObjName.RemoveAll()
  Do While NOT objRS_CSM.EOF
    auxStrScodi = objRS_CSM(0)
    auxStrSVal  = objRS_CSM(1)
    if not pr_ObjName.Exists(auxStrScodi) then pr_ObjName.Add auxStrScodi, auxStrSVal 
    objRS_CSM.MoveNext
  Loop

  FechaRecordSet objRS_CSM
  FechaDBConn ObjConn_CSM
End Function


'-----------------------------------------------------------------------------
Public Function DiaSemana(iDia)
  Select Case iDia
    Case 1:
	  DiaSemana = "Domingo"
    Case 2:
	  DiaSemana = "Segunda-feira"
    Case 3:
	  DiaSemana = "Terça-feira"
    Case 4:
	  DiaSemana = "Quarta-feira"
    Case 5:
	  DiaSemana = "Quinta-feira"
    Case 6:
	  DiaSemana = "Sexta-feira"
    Case 7:
	  DiaSemana = "Sábado"
  End Select	
End Function

Public Function DiaSemanaAbreviado(iDia)
  Select Case iDia
    Case 1:
	  DiaSemanaAbreviado = "Dom"
    Case 2:
	  DiaSemanaAbreviado = "Seg"
    Case 3:
	  DiaSemanaAbreviado = "Ter"
    Case 4:
	  DiaSemanaAbreviado = "Qua"
    Case 5:
	  DiaSemanaAbreviado = "Qui"
    Case 6:
	  DiaSemanaAbreviado = "Sex"
    Case 7:
	  DiaSemanaAbreviado = "Sáb"
  End Select	
End Function

'-----------------------------------------------------------------------------
Public Function DataExtenso(strData)
  DataExtenso = Day(strData) & " de " & Lcase(MesExtenso(Month(strData))) & " de " & Year(strData)
End Function


Function DiaUtil(strData, intNroDias)
Dim strDataAlt, ok
strDataAlt = cdate(strData)+intNroDias
while not ok
	if weekDay(strDataAlt) = 1 or weekDay(strDataAlt) = 7 then
		ok = false
		strDataAlt = strDataAlt+1
	else
		ok = true
	end if 
wend
DiaUtil = strDataAlt
End Function

'-----------------------------------------------------------------------------
Public Function DataExtensoIntl(pr_DATA, pr_LCID)
Dim strLCID
  strLCID = Session.LCID
  Session.LCID = pr_LCID
  DataExtensoIntl = FormatDateTime(pr_DATA, 1)
  Session.LCID = strLCID
End Function

'-----------------------------------------------------------------------------
Public Function ShortDataExtensoIntl(pr_DATA, pr_LCID)
Dim strLCID, strDIA
  strDIA = Day(pr_DATA)
  Select Case strDIA
    Case 1	  strDIA = strDIA & "st"
	Case 2	  strDIA = strDIA & "nd"
	Case 3	  strDIA = strDIA & "rd"
	Case Else strDIA = strDIA & "th"
  End Select
  strLCID = Session.LCID
  Session.LCID = pr_LCID
  ShortDataExtensoIntl = MonthName(Month(pr_DATA)) & ", " & strDIA
  Session.LCID = strLCID
End Function

'-----------------------------------------------------------------------------
Public Function PrepData(DateToConvert, FormatoDiaMes, DataHora)

   ' Declaração para variáveis para dois métodos
   Dim strDia
   Dim strMes
   Dim strAno
   Dim strHora
   Dim strMinuto
   Dim strSegundo

   If isDate(DateToConvert) Then
     strDia     = Day(DateToConvert)
     If strDia < 10 Then
       strDia = "0" & strDia
     End If
     strMes     = Month(DateToConvert)
     If strMes < 10 Then
       strMes = "0" & strMes
     End If   
     strAno     = Year(DateToConvert)
     strHora    = Hour(DateToConvert)
     If strHora < 10 Then
       strHora = "0" & strHora
     End If
     strMinuto  = Minute(DateToConvert)
     If strMinuto < 10 Then
       strMinuto = "0" & strMinuto
     End If
     strSegundo = Second(DateToConvert)
     If strSegundo < 10 Then
       strSegundo = "0" & strSegundo
     End If


     If FormatoDiaMes Then
       PrepData = strDia & "/" & strMes & "/" & strAno
     Else
       PrepData = strMes & "-" & strDia & "-" & strAno
     End If


     If DataHora Then
       PrepData = PrepData & " " & strHora & ":" & strMinuto & ":" & strSegundo
     End If
   Else
     PrepData = ""
   End If

End Function

'-----------------------------------------------------------------------------
'Função para ano/mes/dia hora:minuto:segundo
Public Function PrepDataIve(DateToConvert, FormatoDiaMes, DataHora)

   ' Declaração para variáveis para dois métodos
   Dim strDia
   Dim strMes
   Dim strAno
   Dim strHora
   Dim strMinuto
   Dim strSegundo

   If isDate(DateToConvert) Then
     strDia     = Day(DateToConvert)
     If strDia < 10 Then
       strDia = "0" & strDia
     End If
     strMes     = Month(DateToConvert)
     If strMes < 10 Then
       strMes = "0" & strMes
     End If   
     strAno     = Year(DateToConvert)
     strHora    = Hour(DateToConvert)
     If strHora < 10 Then
       strHora = "0" & strHora
     End If
     strMinuto  = Minute(DateToConvert)
     If strMinuto < 10 Then
       strMinuto = "0" & strMinuto
     End If
     strSegundo = Second(DateToConvert)
     If strSegundo < 10 Then
       strSegundo = "0" & strSegundo
     End If


     If FormatoDiaMes Then
       PrepDataIve = strAno & "/" & strMes & "/" & strDia
     Else
       PrepDataIve = strAno & "-" & strMes & "-" & strDia
     End If


     If DataHora Then
       PrepDataIve = PrepDataIve & " " & strHora & ":" & strMinuto & ":" & strSegundo
     End If
   Else
     PrepDataIve = ""
   End If

End Function

'-----------------------------------------------------------------------------
Public Function strIsoDate ( strDate )
  If IsDate(strDate) Then
    strIsoDate = Year(strDate) & "-" & Month(strDate) & "-" & Day(strDate) & " " & Hour(strDate) & ":" & Minute(strDate) & ":" & Second(strDate)
  End If
End Function

'-----------------------------------------------------------------------------
Public Function FormatDateSQL ( olddate )
  Dim arrDate
  If IsDate (olddate) Then
'    oldDate = FormatDateTime (olddate, vbShortDate)
    arrDate = Split (olddate, "/")
'    Response.Write(arrDate(1) & "-" & arrDate(0) & "-" & arrDate(2) &"<br>")
    FormatDateSQL = arrDate(1) & "-" & arrDate(0) & "-" & arrDate(2)
  End If
End Function

'-----------------------------------------------------------------------------
' Criptografa uma string (transposição simples, chave tam da str)   by APO & KIKO
Public Function ATHCriptograf(senha)
Dim tam, i, strSenha

   tam = Len(senha)
   ' transposição
   strSenha = ""
   For i = 1 To tam
     strSenha = strSenha & Chr(Asc(Mid(senha,i,1)) + Asc(tam))
   Next

   ' inverção
   ATHCriptograf = strReverse(strSenha)
End Function

'-----------------------------------------------------------------------------
' Decriptografa uma string (transposição simples, chave tam da str) by APO & KIKO}
Public Function ATHDeCriptograf(senha)
Dim tam, i, strSenha

   tam = Len(senha)
   ' transposição
   strSenha = ""
   For i = 1 To tam
     strSenha = strSenha & Chr(Asc(Mid(senha,i,1)) - Asc(tam))
   Next

   ' inverção
   ATHDeCriptograf = StrReverse(strSenha)
End Function

'-----------------------------------------------------------------------------
' Faz a formatação de uma str no tamanho especificado                 by ALESS
public Function ATHFormataTamRight(prTEXTO,prTAM,prCARACTER)
  If Len(prTEXTO) < prTAM Then
    ATHFormataTamRight = prTEXTO & string(prTAM - Len(prTEXTO),prCARACTER)
  Else 
    ATHFormataTamRight = Left(prTEXTO,prTAM)
  End If
End Function

'-------------------------------------------------------------------------------
' Faz formatação de uma str pelo lado esquerdo no tamanho especificado. by MAURO 
Public Function ATHFormataTamLeft(prTEXTO,prTAM,prCARACTER)
  If Len(prTEXTO) < prTAM Then
    ATHFormataTamLeft = string(prTAM - Len(prTEXTO), prCARACTER) & prTEXTO
  Else 
    ATHFormataTamLeft = Left(prTEXTO,prTAM)
  End If
End Function


'------------------------------------------------------------------------------
' Verifica se uma imagem existe no caminho informado.            by Aless/Mauro
Function LocalizaIMAGEM(CAMINHO, IMG_PRINCIPAL)
Dim objFSO, strPath

Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
strPath = Server.MapPath(".") & "\" & Replace(CAMINHO,"/","\")
'Response.Write strPath & IMG_PRINCIPAL & "<br>"
If objFSO.FileExists(strPath & IMG_PRINCIPAL) Then
  LocalizaIMAGEM = True
Else
  LocalizaIMAGEM = False
End If
Set objFSO = Nothing

End Function

'-------------------------------------------------------------------------------
' Funcao que retorna o indice de um determinado dado em um array
' * Talvez exista algo pronto mas não encontrei nada ainda (sem internet em casa
'-------------------------------------------------------------------- by Aless -
public function ArrayIndexOf(pr_array, pr_campo)
Dim i
 ArrayIndexOf = cint(-1)
 For i=0 To UBound(pr_array)
   if cstr(pr_array(i)) = cstr(pr_campo) then
     ArrayIndexOf = cint(i)
   end if	 
 Next
end function


'-----------------------------------------------------------------------
Function stripHTML(strHTML)
   Dim objRegExp, strOutput
   Set objRegExp = New Regexp
   objRegExp.IgnoreCase = True
   objRegExp.Global = True
   objRegExp.Pattern = "<(.|\n)+?>"
   'Substitui todas as tags HTML encontradas com uma string em branco
   strOutput = objRegExp.Replace(strHTML&"", "")
   'Substitui todos < e > com &lt; e &gt;
   strOutput = Replace(strOutput, "<", "&lt;")
   strOutput = Replace(strOutput, ">", "&gt;")
   stripHTML = strOutput    'Retorna o valor de strOutput
   Set objRegExp = Nothing
End Function
'-----------------------------------------------------------------------


'Função que transforma o código no seu respectivo caracter especial
Function ReturnCaracterEspecial(pr_string)

	pr_string = Replace(pr_string, "&amp;", "&")
	pr_string = Replace(pr_string, "&Agrave;", "À")
	pr_string = Replace(pr_string, "&agrave;", "à")
	pr_string = Replace(pr_string, "&Aacute;", "Á")
	pr_string = Replace(pr_string, "&aacute;", "á")
	pr_string = Replace(pr_string, "&Acirc;", "Â")
	pr_string = Replace(pr_string, "&acirc;", "â")
	pr_string = Replace(pr_string, "&Atilde;", "Ã")
	pr_string = Replace(pr_string, "&atilde;", "ã")
	pr_string = Replace(pr_string, "&Auml;", "Ä")
	pr_string = Replace(pr_string, "&auml;", "ä")

	pr_string = Replace(pr_string, "&Ccedil;", "Ç")
	pr_string = Replace(pr_string, "&ccedil;", "ç")

	pr_string = Replace(pr_string, "&Egrave;", "È")
	pr_string = Replace(pr_string, "&egrave;", "è")
	pr_string = Replace(pr_string, "&Eacute;", "É")
	pr_string = Replace(pr_string, "&eacute;", "é")
	pr_string = Replace(pr_string, "&Ecirc;", "Ê")
	pr_string = Replace(pr_string, "&ecirc;", "ê")
	pr_string = Replace(pr_string, "&Euml;", "Ë")
	pr_string = Replace(pr_string, "&euml;", "ë")

	pr_string = Replace(pr_string, "&Igrave;", "Ì")
	pr_string = Replace(pr_string, "&igrave;", "ì")
	pr_string = Replace(pr_string, "&Iacute;", "Í")
	pr_string = Replace(pr_string, "&iacute;", "í")
	pr_string = Replace(pr_string, "&Icirc;", "Î")
	pr_string = Replace(pr_string, "&icirc;", "î")
	pr_string = Replace(pr_string, "&Iuml;", "Ï")
	pr_string = Replace(pr_string, "&iuml;", "ï")

	pr_string = Replace(pr_string, "&Ntilde;", "Ñ")
	pr_string = Replace(pr_string, "&ntilde;", "ñ")

	pr_string = Replace(pr_string, "&Ograve;", "ò")
	pr_string = Replace(pr_string, "&ograve;", "ò")
	pr_string = Replace(pr_string, "&Oacute;", "Ó")
	pr_string = Replace(pr_string, "&oacute;", "ó")
	pr_string = Replace(pr_string, "&Ocirc;", "Ô")
	pr_string = Replace(pr_string, "&ocirc;", "ô")
	pr_string = Replace(pr_string, "&Otilde;", "Õ")
	pr_string = Replace(pr_string, "&otilde;", "õ")
	pr_string = Replace(pr_string, "&Ouml;", "Ö")
	pr_string = Replace(pr_string, "&Ouml;", "ö")
	
	pr_string = Replace(pr_string, "&Ugrave;", "Ù")
	pr_string = Replace(pr_string, "&ugrave;", "ù")
	pr_string = Replace(pr_string, "&Uacute;", "Ú")
	pr_string = Replace(pr_string, "&uacute;", "ú")
	pr_string = Replace(pr_string, "&Ucirc;", "Û")
	pr_string = Replace(pr_string, "&ucirc;", "û")
	pr_string = Replace(pr_string, "&Uuml;", "Ü")
	pr_string = Replace(pr_string, "&uuml;", "ü")

	pr_string = Replace(pr_string, "&szlig;", "ß")
	pr_string = Replace(pr_string, "&divide;", "÷")
	pr_string = Replace(pr_string, "&yuml;", "ÿ")
	pr_string = Replace(pr_string, "&lt;", "<")
	pr_string = Replace(pr_string, "&gt;", ">")
	pr_string = Replace(pr_string, "&quot;", """")
	pr_string = Replace(pr_string, "''", "'")
	pr_string = Replace(pr_string, "&deg;", "°")

	ReturnCaracterEspecial = pr_string
End Function


'----------------------------------------------------------- by Mauro --
Function FormatLikeSearch( Texto )
 dim n, NovoTexto, valorASC
 NovoTexto = ""
 for n = 1 to len( Texto )
     valorASC = asc( mid( Texto, n, 1 ) )
     select case valorASC
        case  39: NovoTexto = NovoTexto & "''"
        case  65,192,193,194,195,196: NovoTexto = NovoTexto & "[ÁÀÂÄÃA]"
        case  67: NovoTexto = NovoTexto & "[ÇC]"
        case  69,200,201,202,203: NovoTexto = NovoTexto & "[ÉÈÊËE]"
        case  73,204,205,206,207: NovoTexto = NovoTexto & "[ÍÌÎÏI]"
        case  79,210,211,212,213,214: NovoTexto = NovoTexto & "[ÓÒÔÖÕO]"
        case  85,217,218,219,220: NovoTexto = NovoTexto & "[ÚÙÛÜU]"
        case  97,224,225,226,227,228: NovoTexto = NovoTexto & "[áàâäãa]"
        case  99: NovoTexto = NovoTexto & "[çc]"
        case 101,232,233,234,235: NovoTexto = NovoTexto & "[éèêëe]"
        case 105,236,237,238,239: NovoTexto = NovoTexto & "[íìîïi]"
        case 111,242,243,244,245,246: NovoTexto = NovoTexto & "[óòôöõo]"
        case 117,249,250,251,252: NovoTexto = NovoTexto & "[úùûüu]"
        case else
'           if valorASC > 31 and valorASC < 127 then
              NovoTexto = NovoTexto & chr( valorASC )
'           else
'              NovoTexto = NovoTexto & "_"
'           end if
     end select
 next
' FormatLikeSearch = "'%" & NovoTexto & "%'"
' Response.Write(NovoTexto)
' Response.End()
 FormatLikeSearch = NovoTexto
End Function


'*************************************************
' Valida E-Mail
'*************************************************
Function Verifica_Email(StrMail)
	StrMail = trim(StrMail&"")
	' Se há espaço vazio, então...
	If InStr(1, StrMail, " ") > 0 Then
		Verifica_Email = False
		Exit Function
	End If

	' Verifica tamanho da String, pois o menor endereço válido é x@x.xx.
	If Len(StrMail) < 6 Then
		verifica_email = False
		Exit Function
	End If
	' Verifica se há um "@" no endereço.
	If InStr(StrMail, "@") = 0 Then
		verifica_email = False
		Exit Function
	End If
	' Verifica se há um "." no endereço.
	If InStr(StrMail, ".") = 0 Then
		verifica_email = False
		Exit Function
	End If
	' Verifica se há a quantidade mínima de caracteres é igual ou maior que 3.
	If Len(StrMail) - InStrRev(StrMail, ".") > 3 Then
		verifica_email = False
		Exit Function
	End If

	' Verifica se há "_" após o "@".
	If InStr(StrMail, "_") <> 0 And InStrRev(StrMail, "_") > InStrRev(StrMail, "@") Then
		verifica_email = False
		Exit Function
	Else
		Dim IntCounter
		Dim IntF
		IntCounter = 0
		For IntF = 1 To Len(StrMail)
			If Mid(StrMail, IntF, 1) = "@" Then
				IntCounter = IntCounter + 1
			End If
		Next
		If IntCounter > 1 Then
			verifica_email = True
		End If
		' Valida cada caracter do endereço.
		IntF = 0
		For IntF = 1 To Len(StrMail)
			If IsNumeric(Mid(StrMail, IntF, 1)) = False And (LCase(Mid(StrMail, IntF, 1)) < "a" Or LCase(Mid(StrMail, IntF, 1)) > "z") And _
				Mid(StrMail, IntF, 1) <> "_" And Mid(StrMail, IntF, 1) <> "." And Mid(StrMail, IntF, 1) <> "-" Then
					verifica_email = True
			End If
		Next
	End If
End Function

'-------------------------------------------------------------------- by Aless -
function AthWindowNew (link, largura, altura, texto)
Dim auxStr
  if (CFG_WINDOW = "POPUP")  then auxStr = "<a href=""javascript:AbreJanelaPAGE_NOVA('"&link&"','"&largura&"','"&altura&"')"">"&texto&"</a>"
  if (CFG_WINDOW = "NORMAL") then auxStr = "<a href='"&link&"' target='fr_principal'>"&texto&"</a>"
  AthWindowNew = auxstr
end function

'-------------------------------------------------------------------- by Aless -
function AthWindow (link, largura, altura, texto)
Dim auxStr
  if (CFG_WINDOW = "POPUP")  then auxStr = "<a href=""javascript:AbreJanelaPAGE('"&link&"','"&largura&"','"&altura&"')"">"&texto&"</a>"
  if (CFG_WINDOW = "NORMAL") then auxStr = "<a href='"&link&"' target='fr_principal'>"&texto&"</a>"
  AthWindow = auxstr
end function


'-------------------------------------------------------------------------------
' Facilita a no so dos filtros de campos código, para garantir entrada numéria 
'-------------------------------------------------------------------- by Aless -
function IfNotNumber(prStr,prDefValue)
 if NOT isNumeric(prStr) Then
   IfNotNumber = -1
 else
   IfNotNumber = prStr 
 end if
end function


Function FormataDouble(prValor,prCasas)
 Dim strValorLocal
	
  strValorLocal = FormatNumber(prValor,prCasas)
  strValorLocal = Replace(Replace(strValorLocal,".",""),",",".")
  FormataDouble = strValorLocal
End Function


Function strToSQL(pr_VALOR)
  If pr_VALOR&"" = "" Then
    strToSQL = "NULL"
  Else
    strToSQL = "'" & Replace(pr_VALOR&"","'","''") & "'"
  End If
End Function

'=====================================================================
' 04/08/2009 por Mauro
'=====================================================================
Function AthMontaLayoutCredencial(prCOD_STATUS_CRED, prCOD_EVENTO)
  Dim strSQL_Local, objRS_Local, strCREDENCIAL_LOCAL
  Dim FSO, fich, strARQUIVO, strPATH

  If IsNumeric(prCOD_STATUS_CRED) And IsNumeric(prCOD_EVENTO) Then
	strSQL_LOCAL = "SELECT MODELO_NOME, MODELO_LAYOUT FROM tbl_STATUS_CRED_MODELO WHERE COD_STATUS_CRED = " & prCOD_STATUS_CRED & " AND COD_EVENTO = " & prCOD_EVENTO
	Set objRS_Local = objConn.Execute(strSQL_Local)
	If not objRS_Local.EOF Then
	  strCREDENCIAL_LOCAL = objRS_Local("MODELO_LAYOUT")&""
	End If
	FechaRecordSet objRS_Local
  End If
	
  If strCREDENCIAL_LOCAL = "" Then
  	
	strPATH = Server.MapPath("../") & "\_database\"
	' Response.Write(strPATH & "<BR>")
	
	Set FSO = createObject("scripting.filesystemobject") 
	
	strARQUIVO = strPATH & "modelo_credencial" & "_" & Session("COD_EVENTO") & ".asp"
	If not FSO.FileExists(strARQUIVO) Then
	strARQUIVO = strPATH & "modelo_credencial.asp"
	End If
	
	' Response.Write(strARQUIVO)
	' Response.End()
	
	Set fich = FSO.OpenTextFile(strARQUIVO) 
	strCREDENCIAL_LOCAL = fich.readAll() 
	fich.close() 
	
	Set fich = Nothing
	Set FSO = Nothing
  
  End If

  AthMontaLayoutCredencial = strCREDENCIAL_LOCAL
End Function
'=====================================================================

Function ValidateValueSQL(prVal, prType, prFlagReq)
	Dim strVal, strMensagem
	
	strVal = prVal
	
	If Not IsNull(strVal) And Not IsEmpty(strVal) Then
		Select Case UCase(prType)
			Case "STR"
				strVal = "'" & Replace(strVal,"'","''") & "'"
			Case "STR_LIKE"
				strVal = "'%" & Replace(strVal,"'","''") & "'%"
			Case "STR_LIKE_E"
				strVal = "'%" & Replace(strVal,"'","''") & "'"
			Case "STR_LIKE_D"
				strVal = "'" & Replace(strVal,"'","''") & "'%"
			Case "NUM"
				If IsNumeric(strVal) And strVal <> "" Then strVal = Clng(strVal) Else strVal = "NULL"
			Case "DBL"
				If IsNumeric(strVal) And strVal <> "" Then strVal = Replace(Replace(strVal,".",""),",",".") Else strVal = "NULL"
			Case "BOOLEAN"	
				If strVal = true Then strVal = "true" Else If strVal = false Then strVal = "false" Else strVal = "NULL"
			Case "DATE"
				If IsDate(strVal) And strVal <> "" Then strVal = "'" & PrepDataIve(CDate(strVal),false,false) & "'" Else strVal = "NULL"
			Case "DATETIME"
				If IsDate(strVal) And strVal <> "" Then strVal = "'" & PrepDataIve(CDate(strVal),false,true) & "'" Else strVal = "NULL"
			Case "AUTODATETIME"
				If strVal = "" Then strVal = "current_timestamp" Else strVal = "'" & PrepDataIve(CDate(strVal),false,true) & "'" 
			Case "AUTODATE"
				If strVal = "" Then strVal = "current_date" Else strVal = "'" & PrepDataIve(CDate(strVal),false,false) & "'" 
			Case "AUTOHOUR"
				If strVal = "" Then strVal = "current_time" Else strVal = "'" & strVal & "'" 
		End Select
	Else
		If Not prFlagReq Then
			strVal = "NULL"
		Else
			strMensagem = "O campo não foi preenchido corretamente"
			Mensagem strMensagem, "Voltar"
			Response.End()
		End If
	End If 
	
	ValidateValueSQL = strVal
End Function

'---------------------------------------------------------------------
function busca_cep( cep )  
Dim url, param, xmlhttp, arr_resultado, xmlhttp_resultado

     'url = "http://republicavirtual.com.br/web_cep.php?cep="& cep &"&formato=query_string"  
	 url = "http://republicavirtual.com.br/web_cep.php?"
	 param = "cep="& cep &"&formato=query_string"  
       
     set xmlhttp = CreateObject("MSXML2.ServerXMLHTTP")   
     xmlhttp.open "POST", url, false   
	 xmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
     xmlhttp.send param
        
     xmlhttp_resultado = xmlhttp.responseText   
     set xmlhttp = nothing   
   
     arr_resultado = split( xmlhttp_resultado, "&" )  
   
     dim resultado(7), i, arr  
     for i = lbound( arr_resultado ) to ubound( arr_resultado )  
         resultado( i ) = URLDecode(arr_resultado( i ))  
     next  
   
     arr = split( join( resultado, "=" ), "=" )  
   
     dim arr_2(14)  
     for i = lbound( arr ) to ubound( arr )  
         arr_2( i ) = replace( arr( i ), "+", " " )  
     next      
       
     busca_cep = arr_2  
 end function  
'------------------------------------------------------------------  


function athBeginWinBox(prWidth, prTitle, prPath)
Dim auxStr
  auxStr = "<table width='" & prWidth & "' border='0' cellpadding='0' cellspacing='0'> " & vbnewline
  auxStr = auxStr & "  <tr> " & vbnewline
  auxStr = auxStr & "   <td height='7'> " & vbnewline
  auxStr = auxStr & "     <table width='100%' height='7' border='0' cellpadding='0' cellspacing='0'> " & vbnewline
  auxStr = auxStr & "	  <tr> " & vbnewline
  auxStr = auxStr & "	   <td><img src='" & prPath & "/moldurafiltro_lt.gif'></td> " & vbnewline
  auxStr = auxStr & "	   <td background='" & prPath & "/moldurafiltro_ct.gif' width='100%' height='7'></td> " & vbnewline
  auxStr = auxStr & "	   <td><img src='" & prPath & "/moldurafiltro_rt.gif'></td> " & vbnewline
  auxStr = auxStr & "	  </tr> " & vbnewline
  auxStr = auxStr & "	 </table> " & vbnewline
  auxStr = auxStr & "	</td> " & vbnewline
  auxStr = auxStr & "  </tr> " & vbnewline
  auxStr = auxStr & "  <tr> " & vbnewline
  auxStr = auxStr & "   <td height='99%' style='vertical-align:top;'> " & vbnewline
  auxStr = auxStr & "     <table width='100%' height='100%' border='0' cellpadding='0' cellspacing='0'> " & vbnewline
  auxStr = auxStr & "	  <tr> " & vbnewline
  auxStr = auxStr & "	   <td background='" & prPath & "/moldurafiltro_lm.gif'><img src='" & prPath & "/spacer.gif' width='7'></td> " & vbnewline
  auxStr = auxStr & "	   <td align='center' width='100%' height='100%' bgcolor='#F2F2F2'> " & vbnewline
  'INI: BODY DO BOX -------------------------------
  auxStr = auxStr & "<table width='95%' border='0' cellspacing='0' cellpadding='5'> " & vbnewline
  If prTitle <> "" Then
	  auxStr = auxStr & "		<tr><td height='20' align='left'><span class='titulo_chamada_big'>" & prTitle & "</span></td></tr> " & vbnewline
	  auxStr = auxStr & "		<tr><td height='5' valign='middle' align='center'><img src='" & prPath & "/separator.gif' width='100%' height='2' border='0'></td></tr> " & vbnewline
  End If
  auxStr = auxStr & "			<tr>  " & vbnewline
  auxStr = auxStr & "			  <td valign='top' width='190' class='texto_corpo_mdo'> " & vbnewline
			    
  athBeginWinBox = auxStr
End function


function athEndWinBox( prPath)
Dim auxstr
  auxStr = "  			  </td> " & vbnewline
  auxStr = auxStr & "			</tr> " & vbnewline
  auxStr = auxStr & "		  </table> " & vbnewline		
  'FIM: BODY DO BOX -------------------------------
  auxStr = auxStr & "	   </td> " & vbnewline
  auxStr = auxStr & "       <td background='" & prPath & "/moldurafiltro_rm.gif'><img src='" & prPath & "/spacer.gif' width='7'></td> " & vbnewline
  auxStr = auxStr & "	  </tr> " & vbnewline
  auxStr = auxStr & "	 </table> " & vbnewline
  auxStr = auxStr & "   </td> " & vbnewline
  auxStr = auxStr & "  </tr> " & vbnewline
  'FINALIZA o BOX --------------------------------
  auxStr = auxStr & "  <tr> " & vbnewline
  auxStr = auxStr & "   <td height='7' > " & vbnewline
  auxStr = auxStr & "     <table width='100%' height='7' border='0' cellpadding='0' cellspacing='0'> " & vbnewline
  auxStr = auxStr & "	  <tr> " & vbnewline
  auxStr = auxStr & "	   <td><img src='" & prPath & "/moldurafiltro_lb.gif'></td> " & vbnewline
  auxStr = auxStr & "	   <td background='" & prPath & "/moldurafiltro_cb.gif' width='100%' height='7'></td> " & vbnewline
  auxStr = auxStr & "	   <td><img src='" & prPath & "/moldurafiltro_rb.gif'></td> " & vbnewline
  auxStr = auxStr & "	  </tr> " & vbnewline
  auxStr = auxStr & "	 </table> " & vbnewline
  auxStr = auxStr & "   </td> " & vbnewline
  auxStr = auxStr & "  </tr> " & vbnewline
  auxStr = auxStr & "</table> " & vbnewline
  
  athEndWinBox = auxStr
End function


function athBeginWinBoxFilter(prWidth, prTitle, prButs, prPath)
Dim auxStr
  auxStr = "<table width='" & prWidth & "' border='0' cellpadding='0' cellspacing='0'> " & vbnewline
  auxStr = auxStr & "  <tr> " & vbnewline
  auxStr = auxStr & "   <td height='7'> " & vbnewline
  auxStr = auxStr & "     <table width='100%' height='7' border='0' cellpadding='0' cellspacing='0'> " & vbnewline
  auxStr = auxStr & "	  <tr> " & vbnewline
  auxStr = auxStr & "	   <td><img src='" & prPath & "/moldurafiltro_lt.gif'></td> " & vbnewline
  auxStr = auxStr & "	   <td background='" & prPath & "/moldurafiltro_ct.gif' width='100%' height='7'></td> " & vbnewline
  auxStr = auxStr & "	   <td><img src='" & prPath & "/moldurafiltro_rt.gif'></td> " & vbnewline
  auxStr = auxStr & "	  </tr> " & vbnewline
  auxStr = auxStr & "	 </table> " & vbnewline
  auxStr = auxStr & "	</td> " & vbnewline
  auxStr = auxStr & "  </tr> " & vbnewline
  auxStr = auxStr & "  <tr> " & vbnewline
  auxStr = auxStr & "   <td height='99%' style='vertical-align:top;'> " & vbnewline
  auxStr = auxStr & "     <table width='100%' height='100%' border='0' cellpadding='0' cellspacing='0'> " & vbnewline
  auxStr = auxStr & "	  <tr> " & vbnewline
  auxStr = auxStr & "	   <td background='" & prPath & "/moldurafiltro_lm.gif'><img src='" & prPath & "/spacer.gif' width='7'></td> " & vbnewline
  auxStr = auxStr & "	   <td align='center' width='100%' height='100%' bgcolor='#F2F2F2'> " & vbnewline
  'INI: BODY DO BOX -------------------------------
  auxStr = auxStr & "<table width='95%' border='0' cellspacing='0' cellpadding='5'> " & vbnewline
  If prTitle <> "" Then
	  auxStr = auxStr & "			<tr> " & vbnewline
	  auxStr = auxStr & "			  <td height='20'> " & vbnewline
	  'INI: CABEÇALHO DO BOX --------------------------
	  auxStr = auxStr & "				<table width='100%' border='0' cellpadding='0' cellspacing='0'> " & vbnewline
	  auxStr = auxStr & "				  <tr> " & vbnewline
	  auxStr = auxStr & "					<td height='20' valign='middle' align='left' class='titulo_chamada_big'>" & prTitle & "</td> " & vbnewline
	  auxStr = auxStr & "					<td align='right'>" & prButs & "</td> " & vbnewline
	  auxStr = auxStr & "				  </tr> " & vbnewline
	  auxStr = auxStr & "				</table> " & vbnewline	
	  'FIM:CABEÇALHO DO BOX ---------------------------
	  auxStr = auxStr & "			  </td> " & vbnewline
	  auxStr = auxStr & "			</tr> " & vbnewline
	  auxStr = auxStr & "			<tr><td height='5' valign='middle' align='center'><img src='" & prPath & "/separator.gif' width='100%' height='2' border='0'></td></tr> " & vbnewline
  End If
  auxStr = auxStr & "			<tr>  " & vbnewline
  auxStr = auxStr & "			  <td valign='top' width='190' class='texto_corpo_mdo'> " & vbnewline
			    
  athBeginWinBoxFilter = auxStr
End function


function athEndWinBoxFilter(prBut, prPath)
Dim auxstr
  'ACTION BUTTON ----------------------------------
  auxStr = "  			  </td> " & vbnewline
  auxStr = auxStr & "			</tr> " & vbnewline
  if (prBut<>"") then
	  auxStr = auxStr & "			<tr align='center' valign='middle'>  " & vbnewline
	  auxStr = auxStr & "			  <td height='50'><img src='" & prPath & "/separator.gif' width='100%' height='2' border='0' vspace='5' hspace='0'> " & vbnewline 
	  'auxStr = auxStr & "				<a href='javascript:formpesquisa.submit();'><img src='" & prPath & "/bt_search.gif' border='0'></a>"
	  auxStr = auxStr &                 prBut & vbnewline
	  auxStr = auxStr & "             </td> " & vbnewline
	  auxStr = auxStr & "			</tr> " & vbnewline
  End if 
  auxStr = auxStr & "		  </table> " & vbnewline		
  'FIM: BODY DO BOX -------------------------------
  auxStr = auxStr & "	   </td> " & vbnewline
  auxStr = auxStr & "       <td background='" & prPath & "/moldurafiltro_rm.gif'><img src='" & prPath & "/spacer.gif' width='7'></td> " & vbnewline
  auxStr = auxStr & "	  </tr> " & vbnewline
  auxStr = auxStr & "	 </table> " & vbnewline
  auxStr = auxStr & "   </td> " & vbnewline
  auxStr = auxStr & "  </tr> " & vbnewline
  'FINALIZA o BOX --------------------------------
  auxStr = auxStr & "  <tr> " & vbnewline
  auxStr = auxStr & "   <td height='7' > " & vbnewline
  auxStr = auxStr & "     <table width='100%' height='7' border='0' cellpadding='0' cellspacing='0'> " & vbnewline
  auxStr = auxStr & "	  <tr> " & vbnewline
  auxStr = auxStr & "	   <td><img src='" & prPath & "/moldurafiltro_lb.gif'></td> " & vbnewline
  auxStr = auxStr & "	   <td background='" & prPath & "/moldurafiltro_cb.gif' width='100%' height='7'></td> " & vbnewline
  auxStr = auxStr & "	   <td><img src='" & prPath & "/moldurafiltro_rb.gif'></td> " & vbnewline
  auxStr = auxStr & "	  </tr> " & vbnewline
  auxStr = auxStr & "	 </table> " & vbnewline
  auxStr = auxStr & "   </td> " & vbnewline
  auxStr = auxStr & "  </tr> " & vbnewline
  auxStr = auxStr & "</table> " & vbnewline
  
  athEndWinBoxFilter = auxStr
End function


Function exibirTamanhoArquivo(ByVal Tamanho)
    On Error Resume Next
    Dim Retorno
    Tamanho = CLng(Tamanho)
    If IsNumeric(Tamanho) Then
        If Tamanho >= 1073741824 Then
            Retorno = Round(((Tamanho/1024)/1024)/1024,1)
            Retorno = Retorno & " GB"
        ElseIf Tamanho < 1073741824 And Tamanho >= 1048576 Then
            Retorno = Round((Tamanho/1024)/1024,1)
            Retorno = Retorno & " MB"
        ElseIf Tamanho < 1048576 And Tamanho >= 1024 Then
            Retorno = Round((Tamanho/1024),1)
            Retorno = Retorno & " KB"
        Else
            Retorno = Round((Tamanho),1)
            if Retorno > 1 then s = "s"
            Retorno = Retorno &" Byte"&s
        End If
    Else
        Retorno = "n/a"
    End If
    'Retornando a função
    exibirTamanhoArquivo = Retorno
End Function


Function LimpaNomeArquivo(ByVal Texto)
    Dim ComAcentos
    Dim SemAcentos
    Dim Resultado
	Dim Cont
    'Conjunto de Caracteres com acentos
    ComAcentos = "ÁÍÓÚÉÄÏÖÜËÀÌÒÙÈÃÕÂÎÔÛÊáíóúéäïöüëàìòùèãõâîôûêÇçºª,; ?/!""#$%&'()*+,-/:;?@[]_`{}|~"
    'Conjunto de Caracteres sem acentos
    SemAcentos = "AIOUEAIOUEAIOUEAOAIOUEaioueaioueaioueaoaioueCcoa_______________________________"
    Cont = 0
    Resultado = Texto
    if Texto&"" <> "" then
		Do While Cont < Len(ComAcentos)
		Cont = Cont + 1
		Resultado = Replace(Resultado, Mid(ComAcentos,Cont,1), Mid(SemAcentos, Cont, 1))
		Loop
	end if
    LimpaNomeArquivo = Resultado

End Function


'----------------------------------------------------------
' Remove apenas acentuação e "ç"
'---------------------------------------------- by Aless --
'trouxe a função do Vboss 17/08/2015 Gabriel
Function RemoveAcento(prSTR)
    Dim strA, strB, Resultado, Cont
	
	strA = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïðñòóôõöùúûýþÿ"  
	strB = "AAAAAACEEEEIIIINOOOOOUUUUYaaaaaaceeeeiiiidnooooouuuyby" 
    Cont = 0
    Resultado = prSTR
    Do While Cont < Len(strA)
		Cont = Cont + 1
		Resultado = Replace(Resultado, Mid(strA, Cont, 1), Mid(strB, Cont, 1))
    Loop
    RemoveAcento = Resultado
End Function


Function GerarSenhaAleatoria(prTam, prOp)
	Dim xArray, strDigitos, num, chave, tamanho
	
	If prTam = "" or not IsNumeric(prTam) Then
	  tamanho = 6
	Else
	  tamanho = clng(prTam)
	End If
	
	Select Case prOp
	  Case 1    strDigitos = "0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
	  Case 2    strDigitos = "0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
	  Case 3    strDigitos = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
	  Case 4    strDigitos = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
	  Case 5    strDigitos = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
	  Case 6    strDigitos = "0,1,2,3,4,5,6,7,8,9"
	  Case Else strDigitos = "0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
	End Select
	
	xArray = Split(strDigitos,",")

	Randomize()
	Do While (Len(chave) < tamanho)
		num = xArray( Int(Ubound(xArray)*Rnd()) )
		chave = chave + num 
	Loop
	GerarSenhaAleatoria = Trim(chave)
End Function


Function isMobile()
Dim u,b,v

 set u=Request.ServerVariables("HTTP_USER_AGENT")
 set b=new RegExp
 set v=new RegExp

 b.Pattern="(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle" &_
           "|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian" &_
		   "|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino"

 v.Pattern="1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)" &_
           "|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)" &_
		   "|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u" &_
		   "|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|" &_
		   "i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|" &_
		   "lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|" &_
		   "mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)" &_
		   "|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/" &_
		   "|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )" &_
		   "|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)" &_
		   "|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-"

 b.IgnoreCase=true
 v.IgnoreCase=true

 b.Global=true
 v.Global=true

 if b.test(u) or v.test(Left(u,4)) then 
   isMobile = true
 else
   isMobile = false
 end if

End Function

'Exemplo de uso - response.write(ucwords("spider man")&"<br>")
function ucwords(strInput)
    Dim iPosition,iSpace,strOutput  
 
    iPosition = 1
    do while InStr(iPosition, strInput, " ", 1) <> 0
        iSpace = InStr(iPosition, strInput, " ", 1)
        strOutput = strOutput & UCase(Mid(strInput, iPosition, 1))
        strOutput = strOutput & LCase(Mid(strInput, iPosition + 1, iSpace - iPosition))
        iPosition = iSpace + 1
    loop
 
    strOutput = strOutput & UCase(Mid(strInput, iPosition, 1))
    strOutput = strOutput & LCase(Mid(strInput, iPosition + 1))
 
    ucwords = strOutput
end function
 
 
' Troca TAGS proprietários em comandos SQL por seus respectivos SÍMBOLOS gráficos facilitando a troca de 
' SLQ via parametros (get), session, etc...
function removeTagSQL(prParam)
	dim retValue
	retValue = prParam

	retValue = replace(retValue,"<ASLW_EXCLAMACAO>"	 ,"!")
	retValue = replace(retValue,"<ASLW_PERCENT>"	 ,"%")
	retValue = replace(retValue,"<ASLW_SHARP>"		 ,"#")
	retValue = replace(retValue,"<ASLW_APOSTROFE>"	 ,"'")
	retValue = replace(retValue,"<ASLW_ASPAS>"		 ,"""")
	retValue = replace(retValue,"<ASLW_ARROBA>"		 ,"@")
	retValue = replace(retValue,"<ASLW_INTERROGACAO>","?")
	retValue = replace(retValue,"<ASLW_ECOMERCIAL>"	 ,"&")
	retValue = replace(retValue,"<ASLW_DOISPONTOS>"	 ,":")
	retValue = replace(retValue,"<ASLW_PLUS>"		 ,"+")
	retValue = replace(retValue,"<ASLW_MINUS>"		 ,"-")

	removeTagSQL = retValue
end function


' Retorna o valor correspondente a(s) varíavel(eis) ambiente "{var}"  especificada na string recebida.
' Usada no tratamento de variáveis ambientes, permitindo que além delas sejam executadas algumas  
function replaceParametersSession(prString)
	dim retValue, mixPos, strIndex, strAuxSQL,strIndexS
	retValue = prString

    Randomize
    ' Funções específicas* ----------------------------------------------------------------------------
	retValue = replace(retValue,"{now()}"		,now()								      )
	retValue = replace(retValue,"{dateNow()}"	,date()								      )
	retValue = replace(retValue,"{timeNow()}"	,time() 								  )
	retValue = replace(retValue,"{rnd()}"	    ,Rnd	     							  )
	'retValue = replace(retValue,"{cDate()}"	,dDate(CFG_LANG,date("Y-m-d"),false)	  )
	'retValue = replace(retValue,"{dDate()}"	,dDate(CFG_LANG,date("Y-m-d H:i:s"),true) )
	' -----------------------------------------------------------------------------------------------

	mixPos = instr(retValue,"{") 
	if (mixPos>=1) then
		while (mixPos>=1) AND (not isEmpty(mixPos))
			strIndex  = mid(retValue, mixPos , instr(retValue,"}")-(mixPos)+1 )
			strIndexS = replace(replace(strIndex,"{" ,""),"}" ,"")
			strAuxSQL = replace(retValue, strIndex, session(strIndexS), 1)
			retValue  = strAuxSQL
			mixPos    = instr(retValue,"{")
		wend
	end if
	replaceParametersSession = retValue
end function


   
'======================================================
Function RetornaExtensaoUpload(prDIR, byRef prACAO)
'prDIR = string com o diretorio a ser pesquisado no arquivo de configuração
'prACAO = string com o tipo de condição do teste "ALLOW" (permitido) ou "DENY" (negado) que pode ser alterado conforme o resultado da pesquisa (altera o valor original da variavel)

Dim objFSO, objTextStream, strARQUIVO, strPATH
Dim strAux, arrLINHA
	 
 	 strPATH = Server.MapPath("/") & "\" & CFG_IDCLIENTE & "\"
	 If Right(strPATH,1) = "\" Then
	    strPATH = Left(strPATH,Len(strPATH)-1)
	 End If
	 
	 Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	 
	 'Tenta ver se tem algum arquivo de configuração especifico para o EVENTO
	 strARQUIVO = strPATH  & "\_database\" & Session("COD_EVENTO") & "_upload.inc"
	 If not objFSO.FileExists(strARQUIVO) Then
	   'Caso contrario usa o padrao
	   strARQUIVO = strPATH & "\_database\" & "upload.inc"
	 End If
	 
	 'Response.Write("-> "&prDIR& "<BR>")
	 'Response.Write("-> "&strARQUIVO&" - " & objFSO.FileExists(strARQUIVO) & "<BR>")
	 
	 If objFSO.FileExists(strARQUIVO) Then
		 Set objTextStream = objFSO.OpenTextFile(strARQUIVO)
		 
		 Do While not objTextStream.AtEndOfStream
		   strAux   = objTextStream.ReadLine & ""
		   If InStr(strAux,"'Sintaxe") = 0 or Left(strAux,1) = "'"  Then
			   'Response.Write("- "&strAux&"<BR>")
			   arrLINHA = split(strAux&":",":")
			   If UBound(arrLINHA) >= 2 Then
			     'Response.Write("- "&strPATH & arrLINHA(0)&"<BR>")
				 If Trim(Lcase(strPATH & arrLINHA(0))) = Lcase(Trim(prDIR)) Then
				   prACAO = Trim(arrLINHA(1))
				   RetornaExtensaoUpload = Trim(arrLINHA(2))
				 End If
			   End If
		   End If
		 Loop
		 objTextStream.Close
		 
		 Set objTextStream = Nothing
	 End If
	 
	 Set objFSO = Nothing

End Function
'======================================================

'======================================================
Function verificaExtensao(prARR_EXTENSAO, prEXTENSAO, prACAO)
'prARR_EXTENSAO = array com os valores possiveis de extensoes ( formato: ".PDF,.DOC,.DOCX" )
'prEXTENSAO = string com o valor da extensao a ser pesquisada ( formato: ".DOC" )
'prACAO = string com o tipo de condição do teste "ALLOW" (permitido) ou "DENY" (negado)
Dim i, strEXT
  'Teste para verificar se tem alguma extensao para validar
  verificaExtensao = (UBound(prARR_EXTENSAO) = 0)
  
  response.write ("<br>INI: verificaExtensao:<br>")
  response.write ("prACAO: [" & Trim(ucase(prACAO)) & "]<br>")
  For i = 0 To UBound(prARR_EXTENSAO)
    strEXT = Replace(Replace(prARR_EXTENSAO(i),".",""),"*","")
	response.write ("strEXT: [" & Trim(ucase(strEXT)) & "]   prEXTENSAO: [" & Trim(ucase(prEXTENSAO)) & "]<br>")
    'If ( Trim(ucase(strEXT)) = Trim(ucase(prEXTENSAO)) ) Then
	'  Select Case ucase(trim(prACAO))
	'    Case "ALLOW" verificaExtensao = True	  		  
	'    Case "DENY"  verificaExtensao = False
	'  End Select 
	'End If
	Select Case ucase(trim(prACAO))
		Case "ALLOW" 
			If ( Trim(ucase(strEXT)) = Trim(ucase(prEXTENSAO)) ) Then
				verificaExtensao = True	  		  
				Exit For
			else 
				verificaExtensao = false	  		  
			end if
		Case "DENY"  
			If ( Trim(ucase(strEXT)) = Trim(ucase(prEXTENSAO)) ) Then
				verificaExtensao = false
				Exit For				
			else 
				verificaExtensao = true 
			end if
	End Select 
  Next
  response.write ("<br>FIM: verificaExtensao = [" & verificaExtensao & "]<br>")
  response.write ("<br>")
End Function
'======================================================

Function ScrambleNum(strNum)
    Dim strA,strB,strC
    Dim Resultado
	Dim Cont
    strA = "0123456789"
    strB = "WTVPASHBFX"
    strC = "6541827390"
    Resultado = cStr(strNum)
    if Resultado <> "" then
		Cont = 0
		Do While Cont < Len(strA)
			Cont = Cont + 1
			Resultado = Replace(Resultado, Mid(strA,Cont,1), Mid(strB, Cont, 1))
		Loop
		Cont = 0
		Do While Cont < Len(strB)
			Cont = Cont + 1
			Resultado = Replace(Resultado, Mid(strB,Cont,1), Mid(strC, Cont, 1))
		Loop
	end if
    ScrambleNum = Resultado
End Function


Function unScrambleNum(strNum)
    Dim strA,strB,strC
    Dim Resultado
	Dim Cont
    strA = "6541827390"
    strB = "WTVPASHBFX"
    strC = "0123456789"
    Resultado = cStr(strNum)
    if Resultado <> "" then
		Cont = 0
		Do While Cont < Len(strA)
			Cont = Cont + 1
			Resultado = Replace(Resultado, Mid(strA,Cont,1), Mid(strB, Cont, 1))
		Loop
		Cont = 0
		Do While Cont < Len(strB)
			Cont = Cont + 1
			Resultado = Replace(Resultado, Mid(strB,Cont,1), Mid(strC, Cont, 1))
		Loop
	end if
    unScrambleNum = Resultado
End Function


Public Function RetDataTypeEnum(dtpnum)
  Select Case dtpnum
    Case 0:	  RetDataTypeEnum = "adEmpty" 			'0	No value
    Case 2:	  RetDataTypeEnum = "adSmallInt" 		'2	A 2-byte signed integer.
    Case 3:	  RetDataTypeEnum = "adInteger" 		'3	A 4-byte signed integer.
    Case 4:	  RetDataTypeEnum = "adSingle" 			'4	A single-precision floating-point value.
    Case 5:	  RetDataTypeEnum = "adDouble" 			'5	A double-precision floating-point value.
    Case 6:	  RetDataTypeEnum = "adCurrency" 		'6	A currency value
    Case 7:	  RetDataTypeEnum = "adDate" 			'7	The number of days since December 30, 1899 + the fraction of a day.
    Case 8:	  RetDataTypeEnum = "adBSTR" 			'8	A null-terminated character string.
    Case 9:	  RetDataTypeEnum = "adIDispatch" 		'9	A pointer to an IDispatch interface on a COM object. Note: Currently not supported by ADO.
    Case 10:  RetDataTypeEnum = "adError" 			'10	A 32-bit error code
    Case 11:  RetDataTypeEnum = "adBoolean" 		'11	A boolean value.
    Case 12:  RetDataTypeEnum = "adVariant" 		'12	An Automation Variant. Note: Currently not supported by ADO.
    Case 13:  RetDataTypeEnum = "adIUnknown" 		'13	A pointer to an IUnknown interface on a COM object. Note: Currently not supported by ADO.
    Case 14:  RetDataTypeEnum = "adDecimal" 		'14	An exact numeric value with a fixed precision and scale.
    Case 16:  RetDataTypeEnum = "adTinyInt" 		'16	A 1-byte signed integer.
    Case 17:  RetDataTypeEnum = "adUnsignedTinyInt" '17	A 1-byte unsigned integer.
    Case 18:  RetDataTypeEnum = "adUnsignedSmallInt" '18	A 2-byte unsigned integer.
    Case 19:  RetDataTypeEnum = "adUnsignedInt" 	'19	A 4-byte unsigned integer.
    Case 20:  RetDataTypeEnum = "adBigInt" 			'20	An 8-byte signed integer.
    Case 21:  RetDataTypeEnum = "adUnsignedBigInt" 	'21	An 8-byte unsigned integer.
    Case 64:  RetDataTypeEnum = "adFileTime" 		'64	The number of 100-nanosecond intervals since January 1,1601
    Case 72:  RetDataTypeEnum = "adGUID" 			'72	A globally unique identifier (GUID)
    Case 128: RetDataTypeEnum = "adBinary" 			'128	A binary value.
    Case 129: RetDataTypeEnum = "adChar" 			'129	A string value.
    Case 130: RetDataTypeEnum = "adWChar" 			'130	A null-terminated Unicode character string.
    Case 131: RetDataTypeEnum = "adNumeric" 		'131	An exact numeric value with a fixed precision and scale.
    Case 132: RetDataTypeEnum = "adUserDefined" 	'132	A user-defined variable.
    Case 133: RetDataTypeEnum = "adDBDate" 			'133	A date value (yyyymmdd).
    Case 134: RetDataTypeEnum = "adDBTime" 			'134	A time value (hhmmss).
    Case 135: RetDataTypeEnum = "adDBTimeStamp" 	'135	A date/time stamp (yyyymmddhhmmss plus a fraction in billionths).
    Case 136: RetDataTypeEnum = "adChapter" 		'136	A 4-byte chapter value that identifies rows in a child rowset
    Case 138: RetDataTypeEnum = "adPropVariant" 	'138	An Automation PROPVARIANT.
    Case 139: RetDataTypeEnum = "adVarNumeric" 		'139	A numeric value (Parameter object only).
    Case 200: RetDataTypeEnum = "adVarChar" 		'200	A string value (Parameter object only).
    Case 201: RetDataTypeEnum = "adLongVarChar" 	'201	A long string value.
    Case 202: RetDataTypeEnum = "adVarWChar" 		'202	A null-terminated Unicode character string.
    Case 203: RetDataTypeEnum = "adLongVarWChar" 	'203	A long null-terminated Unicode string value.
    Case 204: RetDataTypeEnum = "adVarBinary" 		'204	A binary value (Parameter object only).
    Case 205: RetDataTypeEnum = "adLongVarBinary"	'205	A long binary value.
    Case Else: RetDataTypeEnum = "adUnknow"	
  End Select	
End Function


'função experimntal, para planejamento futuro - ver com o Aless
Function pvistaSessionEvento(prEVENTO,prDB, prOBJCONN)
	Dim strSQLSchema, strSQL, strCampos
	Dim objConn, objRS
	objConn = prOBJCONN
	strSQLSchema = "SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '"& prDB &"' AND TABLE_NAME = 'tbl_evento'"
	response.write(strSQLSchema)
	Set objRS = objConn.Execute(strSQL)
	If Not objRS.EOF Then	
		While Not objRS.EOF
			strCampos = objRS("COLUMN_NAME")
			strSQL = "SELECT " & strCampos &  " FROM tbl_eventos WHERE cod_evento = " & prEVENTO
			Set objRS2 = objConn.Execute(strSQL)
			If Not objRS2.EOF Then
				session("METRO_tbl_eventos_" & strCampos) = objRS2(strCampos)
				response.Write("METRO_tbl_eventos_" & strCampos & " = " & session("METRO_tbl_eventos_" & strCampos) &"<br>")
			End If
		objRS.MoveNext
		Wend
	End If
End Function

' ------------------------------------------------------------------------
'Carrega na sessão o(s) modelo(s) de credencial padrão e por tipo de credencial se estiver cadastrado
'Mauro - 11/02/2015
Sub InicializaLayoutCredencialSessao(prCOD_EVENTO)
Dim strMODELO
Dim objRS, strSQL
Dim FSO, fich, strARQUIVO, strPATH

strPATH = Server.MapPath("/") & "\" & Session("METRO_INFO_CFG_IDCLIENTE") & "\_database\"
Set FSO = createObject("scripting.filesystemobject") 

strARQUIVO = strPATH & "modelo_credencial" & "_" & Session("COD_EVENTO") & ".asp"
If not FSO.FileExists(strARQUIVO) Then
  strARQUIVO = strPATH & "modelo_credencial.asp"
End If
if FSO.FileExists(strARQUIVO) Then
	Set fich = FSO.OpenTextFile(strARQUIVO) 
else
	exit sub
end if

Session("METRO_MODELO_CREDENCIAL_PADRAO") = fich.readAll() 

fich.close() 

Set fich = Nothing
Set FSO = Nothing

strSQL = "SELECT * FROM TBL_STATUS_CRED_MODELO WHERE COD_EVENTO = " & prCOD_EVENTO
Set objRS = objConn.Execute(strSQL)
Do While not objRS.EOF 
  Session("METRO_MODELO_CREDENCIAL_COD_STATUS_CRED_"&objRS("COD_STATUS_CRED")) = objRS("MODELO_LAYOUT")&""
  objRS.MoveNext
Loop
FechaRecordSet objRS

End Sub

' ------------------------------------------------------------------------
'Função para buscar o layout do modelo de credencial por COD_STATUS_CRED ou senao tiver pega o padrão 
'Mauro - 11/02/2015
Function MontaLayoutCredencialSessao(prCOD_STATUS_CRED)
Dim strLAYOUT

  strLAYOUT = ""

  If prCOD_STATUS_CRED&"" <> "" Then
    strLAYOUT = Session("METRO_MODELO_CREDENCIAL_COD_STATUS_CRED_"&prCOD_STATUS_CRED)
  End If
  
  If strLAYOUT&"" = "" Then
    strLAYOUT = Session("METRO_MODELO_CREDENCIAL_PADRAO")
  End If

  MontaLayoutCredencialSessao = strLAYOUT

End Function

' ------------------------------------------------------------------------
'Limpa na sessão o(s) modelo(s) de credencial padrão e por tipo de credencial se estiver cadastrado
'Mauro - 11/02/2015
Sub FechaLayoutCredencialSessao(prCOD_EVENTO)
Dim objRS, strSQL

Session("METRO_MODELO_CREDENCIAL_PADRAO") = "" 
strSQL = "SELECT * FROM TBL_STATUS_CRED_MODELO WHERE COD_EVENTO = " & prCOD_EVENTO
Set objRS = objConn.Execute(strSQL)
Do While not objRS.EOF 
  Session("METRO_MODELO_CREDENCIAL_COD_STATUS_CRED_"&objRS("COD_STATUS_CRED")) = ""
  objRS.MoveNext
Loop
FechaRecordSet objRS

End Sub
'--------------------------------------------------------------------------

' ------------------------------------------------------------------------
'Remove espaços numa estring 
'exempo: "recebi   um string   assim" fica "recebi um string assim""
Function RemoveSpaces(prStr)
  Dim i, Texto
  Texto = prStr
  
  i = InStr(Texto, "  ")
  While i <> 0
	  Texto = Replace(Texto, "  ", " ")
	  i = InStr(i, Texto, "  ")
  Wend
  RemoveSpaces =  replace(Texto,vbTab,"")
End Function


' ---------------------------------------------------------------------------------------
' SQL INJECTION ATACK
' --------------------------------------------------------------------------- by Aless --
' Boas práticas e ferramentas para ajudar na tentativa de evitar
' ataque de injeção SQL (SQL Injection)
' ---------------------------------------------------------------------------------------
' Orientações de como você pode evitar um ataque de injeção SQL :
'01 - Política de segurança rígida e criteriosa limitando o acesso dos seus usuários. 
'     Isto quer dizer que você deve dar somente os poderes necessários aos seus usuários. 
'     Não de acesso de escrita a tabelas e dê somente acesso as tabelas que o usuário 
'     vai precisar.
'02 - Faça a validação da entrada de dados no formulário e não permita os caracteres 
'     inválidos como : (') , (--) e (;)  nem de palavras maliciosas como insert , drop , 
'     delete, xp_ . Abaixo algumas funções que você pode usar:
'03 - Limite a entrada de texto para o usuário no formulário de entrada de dados. Se o 
'     campo nome deve ter somente 10 caracteres restrinja a isto a entrada de dados no 
'     formulário. O mesmo vale para a senha;
'04 - Faça o tratamento adequado de erros não permitindo que mensagens de erros exponham 
'     informações sobre a estrutura dos seus dados;
'05 - Faça um log para auditoria dos erros ocorridos e das operações mais importantes 
'     da aplicação;
'06 - Sempre valide entrada de usuário testando tipo, comprimento, formato e intervalo;
'07 - Nunca construa instruções  SQL ou Transact-SQL diretamente da entrada do usuário;
'08 - Use procedimentos armazenados (stored Procedures) para validar entrada de usuário;
'09 - Nunca concatene entrada de usuário que não seja validada. A concatenação de cadeia 
'     de caracteres é o ponto principal de entrada de injeção de script;
'10 - Teste o conteúdo de variáveis de cadeia de caracteres e só aceite valores esperados.
'     Rejeite entradas que contenham dados binários, seqüências de escape e caracteres de 
'     comentário. Isso pode ajudar a impedir injeção de script e proteger contra 
'     explorações de excesso de buffer;
' ---------------------------------------------------------------------------------------

'Substituindo o apóstrofe(') pelo duplo apóstrofe ('')
Function ExpurgaApostrofe(texto)
    ExpurgaApostrofe = replace(texto,"'","''")
End function

Function LimpaApostrofe(texto)
    LimpaApostrofe = replace(texto,"'","")
End function

' Substituindo os caracteres e palavras maliciosas por vazio("").
Function LimpaLixo(input)
	dim lixo, textoOK, i
	
	lixo = array ("select", "drop", ";", "--", "insert", "delete", "update", "xp_")
	textoOK = input
	for i=0 to uBound(lixo)
	  textoOK = replace( textoOK ,  lixo(i) , "")
	next
	LimpaLixo = textoOK
end Function

' Rejeitando os dados maliciosos:
Function VerifySQLMalicioso(input)
	lixo = array ("select", "insert", "update", "delete", "drop", "--", "'")
	VerifySQLMalicioso = true
	
	for i=lBound (lixo) to ubound(llixo)
		if (instr(1, input, lixo(i), vbtextcompare) <> 0 ) then
			VerifySQLMalicioso = False
			exit function
		end if
	next
end function

' Sempre que puder, rejeite entrada que contenha os caracteres a seguir.
' ;	Delimitador de consulta.
' '	Delimitador de cadeia de dados de caractere.
' --	Delimitador de comentário.
' /* ... */	Delimitadores de comentário. Texto entre / * e * / não é avaliado pelo servidor.
' xp_	Usado no início do nome de procedimentos armazenados estendidos de catálogo, como xp_cmdshell.

' ---------------------------------------------------------------------------------------



' This function checks if a website is running by sending an HTTP request.
' If the website is up, the function returns True, otherwise it returns False.
' Argument: myWebsite [string] in "www.domain.tld" format, without the
' "http://" prefix.
'
' Written by Rob van der Woude
' http://www.robvanderwoude.com
Function PingSite( myWebsite )
    Dim intStatus, objHTTP
    Set objHTTP = CreateObject( "WinHttp.WinHttpRequest.5.1" )

    objHTTP.Open "GET", "http://" & myWebsite & "/", False
    objHTTP.SetRequestHeader "User-Agent", "Mozilla/4.0 (compatible; MyApp 1.0; Windows NT 5.1)"

    On Error Resume Next

    objHTTP.Send
    intStatus = objHTTP.Status

    On Error Goto 0

    If intStatus = 200 Then
        PingSite = True
    Else
        PingSite = False
    End If
    Set objHTTP = Nothing
End Function

'WRAPPER para FormatNumber
function myFormatNumber(prVlr, prNumDigAfterDec)
Dim aux, auxvlr
	On Error Resume Next
		auxvlr = CDbl(prVlr)
		aux    = FormatNumber(auxvlr, prNumDigAfterDec)
	If Err.Number = 0 Then
		myFormatNumber = aux 
	Else
		myFormatNumber = " [FormatNumberError:" & prVlr & "] "
		WScript.Echo "Error: [FormatNumberError:" & prVlr & "] "
		WScript.Echo Err.Number & " Srce: " & Err.Source & " Desc: " &  Err.Description
		Err.Clear
	End If
end function

function corMetroToHex (prCorMetro)
dim auxCor

	Select Case prCorMetro 
		Case "bg-black"				auxCor = "#000000"
		Case "bg-white"				auxCor = "#ffffff"
		Case "bg-lime"				auxCor = "#a4c400"
		Case "bg-green"				auxCor = "#60a917"
		Case "bg-emerald"			auxCor = "#008a00"
		Case "bg-teal"				auxCor = "#00aba9"
		Case "bg-cyan"				auxCor = "#1ba1e2"
		Case "bg-cobalt"			auxCor = "#0050ef"
		Case "bg-indigo"			auxCor = "#6a00ff"
		Case "bg-violet"			auxCor = "#aa00ff"
		Case "bg-pink"				auxCor = "#dc4fad"
		Case "bg-magenta"			auxCor = "#d80073"
		Case "bg-crimson"			auxCor = "#a20025"
		Case "bg-red"				auxCor = "#e51400"
		Case "bg-orange"			auxCor = "#fa6800"
		Case "bg-amber"				auxCor = "#f0a30a"
		Case "bg-yellow"			auxCor = "#e3c800"
		Case "bg-brown"				auxCor = "#825a2c"
		Case "bg-olive"				auxCor = "#6d8764"
		Case "bg-steel"				auxCor = "#647687"
		Case "bg-mauve"				auxCor = "#76608a"
		Case "bg-taupe"				auxCor = "#87794e"
		Case "bg-gray"				auxCor = "#555555"
		Case "bg-dark"				auxCor = "#333333"
		Case "bg-darker"			auxCor = "#222222"
		Case "bg-darkBrown"			auxCor = "#63362f"
		Case "bg-darkCrimson"		auxCor = "#640024"
		Case "bg-darkMagenta"		auxCor = "#81003c"
		Case "bg-darkIndigo"		auxCor = "#4b0096"
		Case "bg-darkCyan"			auxCor = "#1b6eae"
		Case "bg-darkCobalt"		auxCor = "#00356a"
		Case "bg-darkTeal"			auxCor = "#004050"
		Case "bg-darkEmerald"		auxCor = "#003e00"
		Case "bg-darkGreen"			auxCor = "#128023"
		Case "bg-darkOrange"		auxCor = "#bf5a15"
		Case "bg-darkRed"			auxCor = "#9a1616"
		Case "bg-darkPink"			auxCor = "#9a165a"
		Case "bg-darkViolet"		auxCor = "#57169a"
		Case "bg-darkBlue"			auxCor = "#16499a"
		Case "bg-lightBlue"			auxCor = "#4390df"
		Case "bg-lightRed"			auxCor = "#ff2d19"
		Case "bg-lightGreen"		auxCor = "#7ad61d"
		Case "bg-lighterBlue"		auxCor = "#00ccff"
		Case "bg-lightTeal"			auxCor = "#45fffd"
		Case "bg-lightOlive"		auxCor = "#78aa1c"
		Case "bg-lightOrange"		auxCor = "#c29008"
		Case "bg-lightPink"			auxCor = "#f472d0"
		Case "bg-grayDark"			auxCor = "#333333"
		Case "bg-grayDarker"		auxCor = "#222222"
		Case "bg-grayLight"			auxCor = "#999999"
		Case "bg-grayLighter"		auxCor = "#eeeeee"
		Case "bg-blue"				auxCor = "#00aff0"
	    Case else					auxCor = prCorMetro
	end Select
	corMetroToHex =   auxCor
end function

'--------------------------------------------------------------------------------
' Formata uma DATA (dd/mm/aaaa) para foirmato universal (aaaa/mm/dd) para o MySQL
' Nova versão para trabalahr com MYSQL -
' UPDATE "2009-12-05"                2009-12-05 00:00:00
' UPDATE "2009-12-05 00:00"          2009-12-05 00:00:00
' UPDATE "09-12-05"                  2009-12-05 00:00:00
' UPDATE "09-12-05 00:00"            2009-12-05 00:00:00
' ** MYSQL só grava datas como string
'--------------------------------------------------------------- Aless & Madison --
Public Function PrepDataBrToUni(DateToConvert, DataHora)

   ' Declaração para variáveis para dois métodos
   Dim strDia
   Dim strMes
   Dim strAno
   Dim strHora
   Dim strMinuto
   Dim strSegundo

	If isDate(DateToConvert) Then
    	strDia     = Day(DateToConvert)
    	If strDia < 10 Then
       		strDia = "0" & strDia
     	End If
     	strMes     = Month(DateToConvert)
     	If strMes < 10 Then
       		strMes = "0" & strMes
     	End If   
     	strAno     = Year(DateToConvert)
     	strHora    = Hour(DateToConvert)
     	If strHora < 10 Then
       		strHora = "0" & strHora
     	End If
     	strMinuto  = Minute(DateToConvert)
     	If strMinuto < 10 Then
       		strMinuto = "0" & strMinuto
     	End If
     	strSegundo = Second(DateToConvert)
     	If strSegundo < 10 Then
       		strSegundo = "0" & strSegundo
     	End If

       	PrepDataBrToUni = strAno & "-" & strMes & "-" & strDia


     	If DataHora Then
       		PrepDataBrToUni = PrepDataBrToUni & " " & strHora & ":" & strMinuto & ":" & strSegundo
     	End If
	Else
    	PrepDataBrToUni = ""
	End If

End Function

Function FormataDecimal(pr_VALOR,pr_NUM_CASAS)
  If not IsNumeric(pr_VALOR) Or IsNull(pr_VALOR) Then
    pr_VALOR = FormatNumber(0,pr_NUM_CASAS)
  End If
  FormataDecimal = FormatNumber(pr_VALOR,pr_NUM_CASAS)
End Function

function GerarSenha(maxnum, par1)
Dim var_valores, xArray, chave, num
	
	If par1 = 1 Then var_valores = "0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
	If par1 = 2 Then var_valores = "0,1,2,3,4,5,6,7,8,9"
	If par1 = 3 Then var_valores = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
	
	xArray = Split(var_valores,",")
	Randomize()
	
	Do While Len(chave) < maxnum
		num = xArray(Int(Ubound(xArray) * Rnd() ))
		chave = chave + num 
	Loop
	GerarSenha = Trim(chave)
End Function


' FUNÇÃO PARA EXIBIR A PALAVAR SELECTED NUMA COMBO QUE SEJA FEITA MANUALMENTE 
' exemplo de chamada da função: validaSelect("CIENTIFIC", getValue(objRS,"TP_ROUND_NOTA"))
'	priemiro parametro é o valor da option value da combo, segundo parametro é o dado a ser comparado com o option value
' by Desirée 15/08/2018

function validaSelect(prOptValue, prDbValue)
		if(prOptValue = prDbValue)  then
				validaSelect = "SELECTED"
		end if
End function


' Função para tornar os campos obrigatorios Exemplo: tornaCampoObrigatorio(arraycampos, "var_nome_campo") '
Function tornaCampoObrigatorio(prArray, prCampo) 

	if(InStr(prArray,prCampo)) Then
		tornaCampoObrigatorio = prCampo & "_ô" 
	else
			tornaCampoObrigatorio = prCampo
	end IF
End Function


Function tornaCampoObrigatorio2(prArray, prCampo) 

	if(prArray = "S" )Then
		tornaCampoObrigatorio2 = prCampo & "_ô" 
	else
			tornaCampoObrigatorio2 = prCampo
	end IF
End Function
'-----------------------------------------------------------------------------------
' Monta a lista de valores de um combo, do SQL enviado como parametro       
' Faz o return para que seja usado em concatenação de variaveis
' by Gabriel 06/11/2018
Public Function montaComboReturn(pr_SQL, pr_colValue, pr_colText, pr_Codigo)
  Dim objRS_local, objConn_local, intCodigo
  Dim strVALOR, strTEXTO
  Dim strReturn
  intCodigo = pr_Codigo
  strReturn = ""
  
  If intCodigo = "" Then intCodigo = 0  End If

  'Set objRS_local = Server.CreateObject("ADODB.Recordset")
  'objRS_local.Open pr_SQL, pr_objConn
  
  AbreDBConn objConn_local, CFG_DB

  set objRS_local = objConn_local.execute(pr_SQL)	
  
  If not objRS_local.EOF Then
     Do While not objRS_local.EOF
	   strVALOR = objRS_local(pr_colValue)&""
	   strTEXTO = objRS_local(pr_colText)&""
	   
	   'Response.Write("<option>"&pr_colValue&"-"&pr_colText&"</option><BR>")
       If cstr(intCodigo&"") = cstr(strVALOR&"") Then
         strReturn = strReturn & "<option value='" & strVALOR & "' selected>" & strTEXTO & "</option>"&vbnewline
       Else
         strReturn = strReturn & "<option value='" & strVALOR & "'>" & strTEXTO & "</option>"&vbnewline
       End If
       objRS_local.MoveNext
     Loop
  End If
	
	
  montaComboReturn = strReturn
  
  FechaRecordSet objRS_local
  FechaDBConn objConn_local

End Function


Public Function montaComboReturnPrint(pr_SQL, pr_colValue, pr_colText, pr_Codigo)
  Dim objRS_local, objConn_local, intCodigo
  Dim strVALOR, strTEXTO
  Dim strReturn
  intCodigo = pr_Codigo
  strReturn = ""
  
  If intCodigo = "" Then intCodigo = 0  End If

  'Set objRS_local = Server.CreateObject("ADODB.Recordset")
  'objRS_local.Open pr_SQL, pr_objConn
  
  AbreDBConn objConn_local, CFG_DB
'response.write(pr_SQL)
  set objRS_local = objConn_local.execute(pr_SQL)	
  
  If not objRS_local.EOF Then
     Do While not objRS_local.EOF
	   strVALOR = objRS_local(pr_colValue)&""
	   strTEXTO = objRS_local(pr_colText)&""
	   
	   'Response.Write("<option>"&pr_colValue&"-"&pr_colText&"</option><BR>")
       If cstr(intCodigo&"") = cstr(strVALOR&"") Then
         response.write "<option value='" & strVALOR & "' selected>" & strTEXTO & "</option>"&vbnewline
       Else
         response.write "<option value='" & strVALOR & "'>" & strTEXTO & "</option>"&vbnewline
       End If
       objRS_local.MoveNext
     Loop
  End If
	
	
  'montaComboReturn = strReturn
  
  FechaRecordSet objRS_local
  FechaDBConn objConn_local

End Function

Dim x_Centavos, x_I, x_J, x_K, x_Numero, x_QtdCentenas, x_TotCentenas, x_TxtExtenso( 900 ), x_TxtMoeda( 6 ), x_ValCentena( 6 ), x_Valor, x_ValSoma, auxIS, auxL
'' Matrizes de textos
x_TxtMoeda( 1 ) = "rea"
x_TxtMoeda( 2 ) = "mil"
x_TxtMoeda( 3 ) = "milh"
x_TxtMoeda( 4 ) = "bilh"
x_TxtMoeda( 5 ) = "trilh"
x_TxtExtenso( 1 ) = "um"
x_TxtExtenso( 2 ) = "dois"
x_TxtExtenso( 3 ) = "tres"
x_TxtExtenso( 4 ) = "quatro"
x_TxtExtenso( 5 ) = "cinco"
x_TxtExtenso( 6 ) = "seis"
x_TxtExtenso( 7 ) = "sete"
x_TxtExtenso( 8 ) = "oito"
x_TxtExtenso( 9 ) = "nove"
x_TxtExtenso( 10 ) = "dez"
x_TxtExtenso( 11 ) = "onze"
x_TxtExtenso( 12 ) = "doze"
x_TxtExtenso( 13 ) = "treze"
x_TxtExtenso( 14 ) = "quatorze"
x_TxtExtenso( 15 ) = "quinze"
x_TxtExtenso( 16 ) = "dezesseis"
x_TxtExtenso( 17 ) = "dezessete"
x_TxtExtenso( 18 ) = "dezoito"
x_TxtExtenso( 19 ) = "dezenove"
x_TxtExtenso( 20 ) = "vinte"
x_TxtExtenso( 30 ) = "trinta"
x_TxtExtenso( 40 ) = "quarenta"
x_TxtExtenso( 50 ) = "cinquenta"
x_TxtExtenso( 60 ) = "sessenta"
x_TxtExtenso( 70 ) = "setenta"
x_TxtExtenso( 80 ) = "oitenta"
x_TxtExtenso( 90 ) = "noventa"
x_TxtExtenso( 100 ) = "cento"
x_TxtExtenso( 200 ) = "duzentos"
x_TxtExtenso( 300 ) = "trezentos"
x_TxtExtenso( 400 ) = "quatrocentos"
x_TxtExtenso( 500 ) = "quinhentos"
x_TxtExtenso( 600 ) = "seiscentos"
x_TxtExtenso( 700 ) = "setentos"
x_TxtExtenso( 800 ) = "oitocentos"
x_TxtExtenso( 900 ) = "novecentos"

'' Função Principal de Conversão de Valores em Extenso
Function Extenso( x_Numero, IntIpc )	
	x_Numero = FormatNumber( x_Numero , 2 )	
	x_Centavos = right( x_Numero , 2 )	
	x_ValCentena( 0 ) = 0	
	x_QtdCentenas = Int( ( Len( x_Numero ) + 1 ) / 4 )	
	IntIpc = int("0"&IntIpc)	
	For x_I = 1 To x_QtdCentenas		
		x_ValCentena( x_I ) = ""	
	Next	
	x_I = 1	
	x_J = 1	
	For x_K = Len( x_Numero ) - 3 To 1 Step -1		
		x_ValCentena( x_J ) = mid( x_Numero , x_K , 1 ) & x_ValCentena( x_J )		
		If x_I / 3 = Int( x_I / 3 ) Then			
			x_J = x_J + 1			
			x_K = x_K - 1		
		End If		
		x_I = x_I + 1	
	Next	
	x_TotCentenas = 0	
	Extenso = ""	
	For x_I = x_QtdCentenas To 1 Step -1		
		x_TotCentenas = x_TotCentenas + Int( x_ValCentena( x_I ) )		
		If Int( x_ValCentena( x_I ) ) <> 0 Or ( Int( x_ValCentena( x_I ) ) = 0 And x_I = 1 ) Then
			If Int( x_ValCentena( x_I ) = 0 And Int( x_ValCentena( x_I + 1 ) ) = 0 And x_I = 1 ) Then
					Extenso = Extenso & ExtCentena( x_ValCentena( x_I ) , x_TotCentenas ) & " de " & x_TxtMoeda( x_I )
			Else				
				IF int("0"&IntIpc) <> "0" THEN
						Extenso = Extenso & ExtCentena( x_ValCentena( x_I ) , x_TotCentenas ) & " " & x_TxtMoeda( x_I )				
				ELSE					
					Extenso = Extenso & ExtCentena( x_ValCentena( x_I ) , x_TotCentenas )				
				END IF			
			End If			
			IF int("0"&IntIpc) <> "0" THEN				
				auxIS = "is"				
				auxL = "L"			
			END IF			
			If Int( x_ValCentena( x_I ) ) <> 1 Or ( x_I = 1 And x_TotCentenas <> 1 ) Then				
				Select Case x_I					
					Case 1						
						Extenso = Extenso & auxIS					
					Case 3, 4, 5						
						Extenso = Extenso & "ões"				
				End Select			
			Else				
				Select Case x_I					
				Case 1						
					Extenso = Extenso & auxL					
				Case 3, 4, 5						
					Extenso = Extenso & "ão"				
				End Select			
			End If		
		End If		
		If Int( x_ValCentena( x_I - 1 ) ) = 0 Then			
			Extenso = Extenso		
		Else			
			If ( Int( x_ValCentena( x_I + 1 ) ) = 0 And ( x_I + 1 ) <= x_QtdCentenas ) Or ( x_I = 2 ) Then				
				Extenso = Extenso & " e "			
			Else				
				Extenso = Extenso & ", "			
			End If		
		End If	
	Next	
	If x_Centavos > 0 Then		
		If Int( x_Centavos ) = 1 Then				
			if IntIpc = 1 then
				Extenso = Extenso & " e " & ExtDezena( x_Centavos ) & " centavo"
			else
				Extenso = Extenso & " e " & ExtDezena( x_Centavos ) 
			end if		
		Else
			if IntIpc = 1 then				
				Extenso = Extenso &  " e " & ExtDezena( x_Centavos ) & " centavos"
			else
				Extenso = Extenso & " e " & ExtDezena( x_Centavos ) 
			end if			
		End If	
	End If	
	Extenso = UCase( Left( Extenso , 1 ) )&right( Extenso , Len( Extenso ) - 1 )
End Function

Function ExtDezena( x_Valor )
	' Retorna o Valor por Extenso referente à DEZENA recebida
	ExtDezena = ""
	If Int( x_Valor ) > 0 Then	
	If Int( x_Valor ) < 20 Then		
		ExtDezena = x_TxtExtenso( Int( x_Valor ) )	
	Else		
		ExtDezena = x_TxtExtenso( Int( Int( x_Valor ) / 10 ) * 10 )		
		If ( Int( x_Valor ) / 10 ) - Int( Int( x_Valor ) / 10 ) <> 0 Then			
			ExtDezena = ExtDezena & " e " & x_TxtExtenso( Int( right( x_Valor , 1 ) ) )		
		End If	
	End If
	End If
End Function
Function ExtCentena( x_Valor, x_ValSoma )
	ExtCentena = ""
	If Int( x_Valor ) > 0 Then	
		If Int( x_Valor ) = 100 Then		
			ExtCentena = "cem"	
		Else		
		If Int( x_Valor ) < 20 Then			
			If Int( x_Valor ) = 1 Then				
				If x_ValSoma - Int( x_Valor ) = 0 Then					
					ExtCentena = "hum"				
				Else					
					ExtCentena = x_TxtExtenso( Int( x_Valor ) )				
			End If			
		Else					
			ExtCentena = x_TxtExtenso( Int( x_Valor ) )			
		End If		
	Else			
		If Int( x_Valor ) < 100 Then				
			ExtCentena = ExtDezena( right( x_Valor , 2 ) )			
		Else				
			ExtCentena = x_TxtExtenso( Int( Int( x_Valor ) / 100 )*100 )				
			If ( Int( x_Valor ) / 100 ) - Int( Int( x_Valor ) / 100 ) <> 0 Then					
				ExtCentena = ExtCentena & " e " & ExtDezena( right( x_Valor , 2 ) )				
			End If			
		End If		
	End If	
	End If
	End If
End Function

'==================================================================================
'Funções referentes aos calculos de comissão

Function calcComissaoMercado(IDREPRE          , PRECO          , Quantidade          , ComissaoV          , ComissaoC          , COMISSAO )
							'IDREPRE As String, PRECO As Double, Quantidade As Double, ComissaoV As Double, ComissaoC As Double, COMISSAO As Double
Dim valor_comissao
Dim valor1, valor2
If IDREPRE = "104835" Or IDREPRE = "108631" Then
    valor_comissao = ((PRECO * Quantidade) * ComissaoV) + ((ComissaoC * PRECO * Quantidade) * COMISSAO)
Else
    valor1 = ((PRECO * Quantidade) * ComissaoV) - ((ComissaoV * PRECO * Quantidade) * COMISSAO)
    valor2 = ((ComissaoC * PRECO * Quantidade) * COMISSAO)
    valor_comissao = valor1 + valor2
End If
calcComissaoMercado = valor_comissao

End Function




Function calcComissaoRepre(IDREPRE, ComissaoV, PRECO, Quantidade, COMISSAO, ComissaoC)
						  'IDREPRE As String, ComissaoV As Double, PRECO As Double, Quantidade As Double, COMISSAO As Double, ComissaoC As Double
Dim valor_comissao
Dim valor1, valor2
'COMISSAO_REPRE: (([COMISSAOV]*[preco]*[quantidade])*[COMISSAO])+SeImed(ÉNulo(([COMISSAOC]*[preco]*[quantidade])*[COMISSAO]);0;([COMISSAOC]*[preco]*[quantidade])*[COMISSAO])
If IDREPRE = "104835" Then
    valor_comissao = 0
Else
    valor1 = (ComissaoV * PRECO * Quantidade) * COMISSAO
    valor2 = (ComissaoC * PRECO * Quantidade) * COMISSAO
    valor_comissao = valor1 + valor2
End If
calcComissaoRepre = valor_comissao

End Function

'==================================================================================
'FIM Funções referentes aos calculos de comissão



%>