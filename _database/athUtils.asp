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

'-----------------------------------------------------------------------------
Public Function DataExtenso(strData)
  DataExtenso = Day(strData) & " de " & Lcase(MesExtenso(Month(strData))) & " de " & Year(strData)
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

'-----------------------------------------------------------------------------------
' Monta a lista de valores de um combo, do SQL enviado como parametro       by Aless
Public Function montaCombo(pr_SQL, pr_colValue, pr_colText, pr_Codigo)
  Dim objRS_local, objConn_local, intCodigo
  Dim strVALOR, strTEXTO
 
  intCodigo = pr_Codigo
  If intCodigo = "" Then intCodigo = 0  End If

  'Set objRS_local = Server.CreateObject("ADODB.Recordset")
  'objRS_local.Open pr_SQL, pr_objConn
  
  AbreDBConn objConn_local, CFG_DB_DADOS 

  set objRS_local = objConn_local.execute(pr_SQL)	
  
  If not objRS_local.EOF Then
     Do While not objRS_local.EOF
	   strVALOR = objRS_local(pr_colValue)&""
	   strTEXTO = objRS_local(pr_colText)&""
	   
	   'Response.Write("<option>"&pr_colValue&"-"&pr_colText&"</option><BR>")
       If cstr(intCodigo&"") = cstr(strVALOR&"") Then
         Response.Write "<option value='" & strVALOR & "' selected>" & strTEXTO & "</option>"
       Else
         Response.Write "<option value='" & strVALOR & "'>" & strTEXTO & "</option>"
       End If
       objRS_local.MoveNext
     Loop
  End If

  FechaRecordSet objRS_local
  FechaDBConn objConn_local

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

' ------------------------------------------------------------------------
' Busca dados relativos as informações do site no banco (athcsm.mdb) 
' para montagem na tela principal
'-------------------------------------------------------------- by Aless -
public function MontaArrySiteInfo(byref pr_arrScodi,byref pr_arrSdesc )
Dim strSQL
Dim objConn_CSM, objRS_CSM
Dim auxStrScodi, auxStrSdesc

  AbreDBConn objConn_CSM, CFG_DB_DADOS

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

'Função que transforma o caracter especial no seu respectivo código 
Function ReturnCaracterEspecialInv(pr_string)

	pr_string = Replace(pr_string, "&", "&amp;" )
	pr_string = Replace(pr_string, "À", "&Agrave;")
	pr_string = Replace(pr_string, "à", "&agrave;")
	pr_string = Replace(pr_string, "Á", "&Aacute;")
	pr_string = Replace(pr_string, "á", "&aacute;")
	pr_string = Replace(pr_string, "Â", "&Acirc;")
	pr_string = Replace(pr_string, "â", "&acirc;")
	pr_string = Replace(pr_string, "Ã", "&Atilde;")
	pr_string = Replace(pr_string, "ã", "&atilde;")
	pr_string = Replace(pr_string, "Ä", "&Auml;")
	pr_string = Replace(pr_string, "ä", "&auml;")

	pr_string = Replace(pr_string, "Ç", "&Ccedil;")
	pr_string = Replace(pr_string, "ç", "&ccedil;")

	pr_string = Replace(pr_string, "È", "&Egrave;")
	pr_string = Replace(pr_string, "è", "&egrave;")
	pr_string = Replace(pr_string, "É", "&Eacute;")
	pr_string = Replace(pr_string, "é", "&eacute;")
	pr_string = Replace(pr_string, "Ê", "&Ecirc;")
	pr_string = Replace(pr_string, "ê", "&ecirc;")
	pr_string = Replace(pr_string, "Ë", "&Euml;")
	pr_string = Replace(pr_string, "ë", "&euml;")

	pr_string = Replace(pr_string, "Ì", "&Igrave;")
	pr_string = Replace(pr_string, "ì", "&igrave;")
	pr_string = Replace(pr_string, "Í", "&Iacute;")
	pr_string = Replace(pr_string, "í", "&iacute;")
	pr_string = Replace(pr_string, "Î", "&Icirc;")
	pr_string = Replace(pr_string, "î", "&icirc;")
	pr_string = Replace(pr_string, "Ï", "&Iuml;")
	pr_string = Replace(pr_string, "ï", "&iuml;")

	pr_string = Replace(pr_string, "Ñ", "&Ntilde;")
	pr_string = Replace(pr_string, "ñ", "&ntilde;")

	pr_string = Replace(pr_string, "ò", "&Ograve;")
	pr_string = Replace(pr_string, "ò", "&ograve;")
	pr_string = Replace(pr_string, "Ó", "&Oacute;")
	pr_string = Replace(pr_string, "ó", "&oacute;")
	pr_string = Replace(pr_string, "Ô", "&Ocirc;")
	pr_string = Replace(pr_string, "ô", "&ocirc;")
	pr_string = Replace(pr_string, "Õ", "&Otilde;")
	pr_string = Replace(pr_string, "õ", "&otilde;")
	pr_string = Replace(pr_string, "Ö", "&Ouml;")
	pr_string = Replace(pr_string, "ö", "&Ouml;")
	
	pr_string = Replace(pr_string, "Ù", "&Ugrave;")
	pr_string = Replace(pr_string, "ù", "&ugrave;")
	pr_string = Replace(pr_string, "Ú", "&Uacute;")
	pr_string = Replace(pr_string, "ú", "&uacute;")
	pr_string = Replace(pr_string, "Û", "&Ucirc;")
	pr_string = Replace(pr_string, "û", "&ucirc;")
	pr_string = Replace(pr_string, "Ü", "&Uuml;")
	pr_string = Replace(pr_string, "ü", "&uuml;")

	pr_string = Replace(pr_string, "ß", "&szlig;")
	pr_string = Replace(pr_string, "÷", "&divide;")
	pr_string = Replace(pr_string, "ÿ", "&yuml;")
	pr_string = Replace(pr_string, "<", "&lt;")
	pr_string = Replace(pr_string, ">", "&gt;")
	pr_string = Replace(pr_string, """", "&quot;")
	pr_string = Replace(pr_string, "'", "''")
	pr_string = Replace(pr_string, "°", "&deg;")

	ReturnCaracterEspecialInv = pr_string
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

Function IsEmail(strEmail)
	Dim RegEx, ResultadoHum, ResultadoDois, ResultadoTres
	
	Set regEx = New RegExp ' Cria o Objeto Expressão
	regEx.IgnoreCase = True ' Sensitivo ou não
	regEx.Global = True ' Não sei exatamente o que faz
	
	'Caracteres Excluidos
	regEx.Pattern = "[^@\-\.\w]|^[@\.\-]|[\.\-]{2}|[@\.]{2}|(@)[^@]*\1"
	ResultadoHum = RegEx.Test(strEmail)
	
	'Caracteres validos
	regEx.Pattern = "@[\w\-]+\."
	ResultadoDois = RegEx.Test(strEmail)
	
	'Caracteres de fim
	regEx.Pattern = "\.[a-zA-Z]{2,6}$"
	ResultadoTres = RegEx.Test(strEmail)
	
	Set regEx = Nothing
	
	If Not (ResultadoHum) And ResultadoDois And ResultadoTres Then
		IsEmail = True
	Else
		IsEmail = False
	End If
	
End Function




Function Verifica_Email(StrMail)
	'StrMail = trim(StrMail&"")
'	' Se há espaço vazio, então...
'	If InStr(1, StrMail, " ") > 0 Then
'		Verifica_Email = False
'		Exit Function
'	End If
'
'	' Verifica tamanho da String, pois o menor endereço válido é x@x.xx.
'	If Len(StrMail) < 6 Then
'		verifica_email = False
'		Exit Function
'	End If
'	' Verifica se há um "@" no endereço.
'	If InStr(StrMail, "@") = 0 Then
'		verifica_email = False
'		Exit Function
'	End If
'	' Verifica se há um "." no endereço.
'	If InStr(StrMail, ".") = 0 Then
'		verifica_email = False
'		Exit Function
'	End If
'	' Verifica se há a quantidade mínima de caracteres é igual ou maior que 3.
'	If Len(StrMail) - InStrRev(StrMail, ".") > 3 Then
'		verifica_email = False
'		Exit Function
'	End If
'
'	' Verifica se há "_" após o "@".
'	If InStr(StrMail, "_") <> 0 And InStrRev(StrMail, "_") > InStrRev(StrMail, "@") Then
'		verifica_email = False
'		Exit Function
'	Else
'		Dim IntCounter
'		Dim IntF
'		IntCounter = 0
'		For IntF = 1 To Len(StrMail)
'			If Mid(StrMail, IntF, 1) = "@" Then
'				IntCounter = IntCounter + 1
'			End If
'		Next
'		If IntCounter > 1 Then
'			verifica_email = True
'		End If
'		' Valida cada caracter do endereço.
'		IntF = 0
'		For IntF = 1 To Len(StrMail)
'			If IsNumeric(Mid(StrMail, IntF, 1)) = False And (LCase(Mid(StrMail, IntF, 1)) < "a" Or LCase(Mid(StrMail, IntF, 1)) > "z") And _
'				Mid(StrMail, IntF, 1) <> "_" And Mid(StrMail, IntF, 1) <> "." And Mid(StrMail, IntF, 1) <> "-" Then
'					verifica_email = True
'			End If
'		Next
'	End If	
	if StrMail&"" <> "" Then
		Verifica_Email = IsEmail(StrMail)
	Else
		Verifica_Email = False
	End If
End Function


'-------------------------------------------------------------------- by Aless -
function AthWindow (link, largura, altura, texto)
Dim auxStr
  if (CFG_WINDOW = "POPUP")  then auxStr = "<a href=javascript:AbreJanelaPAGE('"&link&"','"&largura&"','"&altura&"')>"&texto&"</a>"
  if (CFG_WINDOW = "NORMAL") then auxStr = "<a href='"&link&"' target='mainAthCSM'>"&texto&"</a>"
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
	dim retValue, mixPos, strIndex, strAuxSQL
	retValue = prString

    ' Funções específicas* ----------------------------------------------------------------------------
	retValue = replace(retValue,"{now()}"		,now()								      )
	retValue = replace(retValue,"{dateNow()}"	,date()								      )
	retValue = replace(retValue,"{timeNow()}"	,time() 								  )
	'retValue = replace(retValue,"{cDate()}"	,dDate(CFG_LANG,date("Y-m-d"),false)	  )
	'retValue = replace(retValue,"{dDate()}"	,dDate(CFG_LANG,date("Y-m-d H:i:s"),true) )
	' -----------------------------------------------------------------------------------------------
'	mixPos = instr(retValue,"{")
'	if (mixPos>0) then
'		while (mixPos>0) 
'			strIndex  = mid(retValue, mixPos , instr(retValue,"}")-(mixPos)+1 )
'			strAuxSQL = replace(retValue, replace(replace(strIndex,"{" ,""),"}" ,""), session(strIndex))
'			retValue  = strAuxSQL
'			mixPos    = instr(retValue,"{")
'		wend
'	end if
	replaceParametersSession = retValue
end function

'======================================================
Function RetornaExtensaoUpload(prDIR, byRef prACAO)
'prDIR = string com o diretorio a ser pesquisado no arquivo de configuração
'prACAO = string com o tipo de condição do teste "ALLOW" (permitido) ou "DENY" (negado) que pode ser alterado conforme o resultado da pesquisa (altera o valor original da variavel)

Dim objFSO, objTextStream, strARQUIVO, strPATH
Dim strAux, arrLINHA

     prDIR = replace(prDIR,"//","\")
	 prDIR = replace(prDIR,"/","\")
	 
 	 strPATH = Server.MapPath("/") & "\" & CFG_IDCLIENTE & "\"
	 If Right(strPATH,1) = "\" Then
	    strPATH = Left(strPATH,Len(strPATH)-1)
	 End If

	 
	 Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	 
	 'Tenta ver se tem algum arquivo de configuração especifico para o EVENTO
	 'strARQUIVO = strPATH  & "\_database\" & Session("COD_EVENTO") & "_upload.inc" 'Devaneio do Mauro trocou o padrão e colocou o codigo do evento no inicio do nome do arquivo... corrigido por Mauro...
 	 strARQUIVO = strPATH  & "\_database\upload_" & Session("COD_EVENTO") & ".inc"
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
Dim objRS
Dim FSO, fich, strARQUIVO, strPATH

strPATH = Server.MapPath("/") & "\" & Session("METRO_INFO_CFG_IDCLIENTE") & "\_database\"
Set FSO = createObject("scripting.filesystemobject") 

strARQUIVO = strPATH & "modelo_credencial" & "_" & Session("COD_EVENTO") & ".asp"
If not FSO.FileExists(strARQUIVO) Then
  strARQUIVO = strPATH & "modelo_credencial.asp"
End If

Set fich = FSO.OpenTextFile(strARQUIVO) 

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
Dim objRS

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
%>

