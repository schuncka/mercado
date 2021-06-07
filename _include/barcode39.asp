<%
'=========================================================================
' Função para exibir direto na tela (output HMTL) o codigo de barras padrão Code39
Public Function BarCode39(prBARCODE)
Dim a, b, s, t, numNarrow, numHeight, strBarCode, strConv


redim a(44)
a(1)="1wnnwnnnnw"
a(2)="2nnwwnnnnw"
a(3)="3wnwwnnnnn"
a(4)="4nnnwwnnnw"
a(5)="5wnnwwnnnn"
a(6)="6nnwwwnnnn"
a(7)="7nnnwnnwnw"
a(8)="8wnnwnnwnn"
a(9)="9nnwwnnwnn"
a(10)="0nnnwwnwnn"
a(11)="Awnnnnwnnw"
a(12)="Bnnwnnwnnw"
a(13)="Cwnwnnwnnn"
a(14)="Dnnnnwwnnw"
a(15)="Ewnnnwwnnn"
a(16)="Fnnwnwwnnn"
a(17)="Gnnnnnwwnw"
a(18)="Hwnnnnwwnn"
a(19)="Innwnnwwnn"
a(20)="Jnnnnwwwnn"
a(21)="Kwnnnnnnww"
a(22)="Lnnwnnnnww"
a(23)="Mwnwnnnnwn"
a(24)="Nnnnnwnnww"
a(25)="Ownnnwnnwn"
a(26)="Pnnwnwnnwn"
a(27)="Qnnnnnnwww"
a(28)="Rwnnnnnwwn"
a(29)="Snnwnnnwwn"
a(30)="Tnnnnwnwwn"
a(31)="Uwwnnnnnnw"
a(32)="Vnwwnnnnnw"
a(33)="Wwwwnnnnnn"
a(34)="Xnwnnwnnnw"
a(35)="Ywwnnwnnnn"
a(36)="Znwwnwnnnn"
a(37)="-nwnnnnwnw"
a(38)=".wwnnnnwnn"
a(39)=" nwwnnnwnn"
a(40)="*nwnnwnwnn"
a(41)="$nwnwnwnnn"
a(42)="/nwnwnnnwn"
a(43)="+nwnnnwnwn"
a(44)="%nnnwnwnwn"

numNarrow=1.5
numHeight=30

strBarCode = prBARCODE
strBarCode = "*" & strBarCode & "*"
strConv = ""
' response.write strBarCode

for t=1 to len(strBarCode)
	for s=1 to 44
		if mid(strBarCode,t,1)=left(a(s),1) then
			strConv=strConv & right(a(s),9)&"s"
		end if
	next
next

' response.write strconv & "<p>"

b=1

for t=1 to len(strConv)
	if mid(strConv,t,1)="n" then
		if b=1 then response.write "<img src=../img/barcode39_shim_black.gif width=" & numNarrow & " height=" & numHeight & ">"
		if b=0 then response.write "<img src=../img/barcode39_shim.gif width=" & numNarrow & " height=" & numHeight & ">"
		b=b+1
		if b=2 then b=0
	end if

	if mid(strConv,t,1)="w" then
		if b=1 then response.write "<img src=../img/barcode39_shim_black.gif width=" & numNarrow*2 & " height=" & numHeight & ">"
		if b=0 then response.write "<img src=../img/barcode39_shim.gif width=" & numNarrow*2 & " height=" & numHeight & ">"
		b=b+1
		if b=2 then b=0
	end if

	if mid(strconv,t,1)="s" then
		response.write "<img src=../img/barcode39_shim.gif width=" & numNarrow & " height=" & numHeight & ">"
		b=1
	end if
next

End Function

'=========================================================================
' Função para exibir direto na tela (output HMTL) o codigo de barras padrão Code39, usando paramentro de altura e largura
Public Function BarCode39Size(prBARCODE, prALTURA, prLARGURA)
Dim a, b, s, t, numNarrow, numHeight, strBarCode, strConv


redim a(44)
a(1)="1wnnwnnnnw"
a(2)="2nnwwnnnnw"
a(3)="3wnwwnnnnn"
a(4)="4nnnwwnnnw"
a(5)="5wnnwwnnnn"
a(6)="6nnwwwnnnn"
a(7)="7nnnwnnwnw"
a(8)="8wnnwnnwnn"
a(9)="9nnwwnnwnn"
a(10)="0nnnwwnwnn"
a(11)="Awnnnnwnnw"
a(12)="Bnnwnnwnnw"
a(13)="Cwnwnnwnnn"
a(14)="Dnnnnwwnnw"
a(15)="Ewnnnwwnnn"
a(16)="Fnnwnwwnnn"
a(17)="Gnnnnnwwnw"
a(18)="Hwnnnnwwnn"
a(19)="Innwnnwwnn"
a(20)="Jnnnnwwwnn"
a(21)="Kwnnnnnnww"
a(22)="Lnnwnnnnww"
a(23)="Mwnwnnnnwn"
a(24)="Nnnnnwnnww"
a(25)="Ownnnwnnwn"
a(26)="Pnnwnwnnwn"
a(27)="Qnnnnnnwww"
a(28)="Rwnnnnnwwn"
a(29)="Snnwnnnwwn"
a(30)="Tnnnnwnwwn"
a(31)="Uwwnnnnnnw"
a(32)="Vnwwnnnnnw"
a(33)="Wwwwnnnnnn"
a(34)="Xnwnnwnnnw"
a(35)="Ywwnnwnnnn"
a(36)="Znwwnwnnnn"
a(37)="-nwnnnnwnw"
a(38)=".wwnnnnwnn"
a(39)=" nwwnnnwnn"
a(40)="*nwnnwnwnn"
a(41)="$nwnwnwnnn"
a(42)="/nwnwnnnwn"
a(43)="+nwnnnwnwn"
a(44)="%nnnwnwnwn"

numNarrow = prLARGURA
'Response.Write(numNarrow & "<br>")
If not IsNumeric(numNarrow) Then 
  numNarrow=1.5
'Else
'  numNarrow = Cdbl(Replace(numNarrow,",","."))
End If
numHeight = prALTURA
If not IsNumeric(numHeight) Then numHeight=15

'Response.Write(numNarrow)
'Response.End()

strBarCode = prBARCODE
strBarCode = "*" & strBarCode & "*"
strConv = ""
' response.write strBarCode

for t=1 to len(strBarCode)
	for s=1 to 44
		if mid(strBarCode,t,1)=left(a(s),1) then
			strConv=strConv & right(a(s),9)&"s"
		end if
	next
next

' response.write strconv & "<p>"

b=1

for t=1 to len(strConv)
	if mid(strConv,t,1)="n" then
		if b=1 then response.write "<img src=../img/barcode39_shim_black.gif width=" & numNarrow & " height=" & numHeight & ">"
		if b=0 then response.write "<img src=../img/barcode39_shim.gif width=" & numNarrow & " height=" & numHeight & ">"
		b=b+1
		if b=2 then b=0
	end if

	if mid(strConv,t,1)="w" then
		if b=1 then response.write "<img src=../img/barcode39_shim_black.gif width=" & numNarrow*2 & " height=" & numHeight & ">"
		if b=0 then response.write "<img src=../img/barcode39_shim.gif width=" & numNarrow*2 & " height=" & numHeight & ">"
		b=b+1
		if b=2 then b=0
	end if

	if mid(strconv,t,1)="s" then
		response.write "<img src=../img/barcode39_shim.gif width=" & numNarrow & " height=" & numHeight & ">"
		b=1
	end if
next

End Function


'=========================================================================
' Função para retornar string (codigo HMTL) do codigo de barras padrão Code39, usando paramentro de altura, largura, caminho base das imagens
Public Function ReturnBarCode39_HTML(prBARCODE, prALTURA, prLARGURA, prCAMINHO)
Dim a, b, s, t, numNarrow, numHeight, strBarCode, strConv
Dim strRETORNO

strRETORNO = ""

redim a(44)
a(1)="1wnnwnnnnw"
a(2)="2nnwwnnnnw"
a(3)="3wnwwnnnnn"
a(4)="4nnnwwnnnw"
a(5)="5wnnwwnnnn"
a(6)="6nnwwwnnnn"
a(7)="7nnnwnnwnw"
a(8)="8wnnwnnwnn"
a(9)="9nnwwnnwnn"
a(10)="0nnnwwnwnn"
a(11)="Awnnnnwnnw"
a(12)="Bnnwnnwnnw"
a(13)="Cwnwnnwnnn"
a(14)="Dnnnnwwnnw"
a(15)="Ewnnnwwnnn"
a(16)="Fnnwnwwnnn"
a(17)="Gnnnnnwwnw"
a(18)="Hwnnnnwwnn"
a(19)="Innwnnwwnn"
a(20)="Jnnnnwwwnn"
a(21)="Kwnnnnnnww"
a(22)="Lnnwnnnnww"
a(23)="Mwnwnnnnwn"
a(24)="Nnnnnwnnww"
a(25)="Ownnnwnnwn"
a(26)="Pnnwnwnnwn"
a(27)="Qnnnnnnwww"
a(28)="Rwnnnnnwwn"
a(29)="Snnwnnnwwn"
a(30)="Tnnnnwnwwn"
a(31)="Uwwnnnnnnw"
a(32)="Vnwwnnnnnw"
a(33)="Wwwwnnnnnn"
a(34)="Xnwnnwnnnw"
a(35)="Ywwnnwnnnn"
a(36)="Znwwnwnnnn"
a(37)="-nwnnnnwnw"
a(38)=".wwnnnnwnn"
a(39)=" nwwnnnwnn"
a(40)="*nwnnwnwnn"
a(41)="$nwnwnwnnn"
a(42)="/nwnwnnnwn"
a(43)="+nwnnnwnwn"
a(44)="%nnnwnwnwn"

numNarrow = prLARGURA
'Response.Write(numNarrow & "<br>")
If not IsNumeric(numNarrow) Then 
  numNarrow=1.5
'Else
'  numNarrow = Cdbl(Replace(numNarrow,",","."))
End If
numHeight = prALTURA
If not IsNumeric(numHeight) Then numHeight=15

'Response.Write(numNarrow)
'Response.End()

strBarCode = prBARCODE
strBarCode = "*" & strBarCode & "*"
strConv = ""
' response.write strBarCode

for t=1 to len(strBarCode)
	for s=1 to 44
		if mid(strBarCode,t,1)=left(a(s),1) then
			strConv=strConv & right(a(s),9)&"s"
		end if
	next
next

' response.write strconv & "<p>"

b=1

for t=1 to len(strConv)
	if mid(strConv,t,1)="n" then
		if b=1 then strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim_black.gif width=" & numNarrow & " height=" & numHeight & ">"
		if b=0 then strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim.gif width=" & numNarrow & " height=" & numHeight & ">"
		b=b+1
		if b=2 then b=0
	end if

	if mid(strConv,t,1)="w" then
		if b=1 then strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim_black.gif width=" & numNarrow*2 & " height=" & numHeight & ">"
		if b=0 then strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim.gif width=" & numNarrow*2 & " height=" & numHeight & ">"
		b=b+1
		if b=2 then b=0
	end if

	if mid(strconv,t,1)="s" then
		strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim.gif width=" & numNarrow & " height=" & numHeight & ">"
		b=1
	end if
next

strRETORNO = strRETORNO & "<BR>*" & prBARCODE & "*"

ReturnBarCode39_HTML = strRETORNO

End Function


'=========================================================================
' Função para retornar string (codigo HMTL) do codigo de barras padrão Code39 na VERTICAL , usando paramentro de altura, largura, caminho base das imagens
Public Function ReturnBarCode39Vertical(prBARCODE, prALTURA, prLARGURA, prCAMINHO)
Dim a, b, s, t, numNarrow, numHeight, strBarCode, strConv
Dim strRETORNO

strRETORNO = ""

redim a(44)
a(1)="1wnnwnnnnw"
a(2)="2nnwwnnnnw"
a(3)="3wnwwnnnnn"
a(4)="4nnnwwnnnw"
a(5)="5wnnwwnnnn"
a(6)="6nnwwwnnnn"
a(7)="7nnnwnnwnw"
a(8)="8wnnwnnwnn"
a(9)="9nnwwnnwnn"
a(10)="0nnnwwnwnn"
a(11)="Awnnnnwnnw"
a(12)="Bnnwnnwnnw"
a(13)="Cwnwnnwnnn"
a(14)="Dnnnnwwnnw"
a(15)="Ewnnnwwnnn"
a(16)="Fnnwnwwnnn"
a(17)="Gnnnnnwwnw"
a(18)="Hwnnnnwwnn"
a(19)="Innwnnwwnn"
a(20)="Jnnnnwwwnn"
a(21)="Kwnnnnnnww"
a(22)="Lnnwnnnnww"
a(23)="Mwnwnnnnwn"
a(24)="Nnnnnwnnww"
a(25)="Ownnnwnnwn"
a(26)="Pnnwnwnnwn"
a(27)="Qnnnnnnwww"
a(28)="Rwnnnnnwwn"
a(29)="Snnwnnnwwn"
a(30)="Tnnnnwnwwn"
a(31)="Uwwnnnnnnw"
a(32)="Vnwwnnnnnw"
a(33)="Wwwwnnnnnn"
a(34)="Xnwnnwnnnw"
a(35)="Ywwnnwnnnn"
a(36)="Znwwnwnnnn"
a(37)="-nwnnnnwnw"
a(38)=".wwnnnnwnn"
a(39)=" nwwnnnwnn"
a(40)="*nwnnwnwnn"
a(41)="$nwnwnwnnn"
a(42)="/nwnwnnnwn"
a(43)="+nwnnnwnwn"
a(44)="%nnnwnwnwn"

numNarrow = prLARGURA
'Response.Write(numNarrow & "<br>")
If not IsNumeric(numNarrow) Then 
  numNarrow=1.5
'Else
'  numNarrow = Cdbl(Replace(numNarrow,",","."))
End If
numHeight = prALTURA
If not IsNumeric(numHeight) Then numHeight=15

'Response.Write(numNarrow)
'Response.End()

strBarCode = prBARCODE
strBarCode = "*" & strBarCode & "*"
strConv = ""
' response.write strBarCode

for t=1 to len(strBarCode)
	for s=1 to 44
		if mid(strBarCode,t,1)=left(a(s),1) then
			strConv=strConv & right(a(s),9)&"s"
		end if
	next
next

' response.write strconv & "<p>"

b=1

for t=1 to len(strConv)
	if mid(strConv,t,1)="n" then
		if b=1 then strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim_black.gif width=" & numHeight & " height=" & numNarrow & "><br>"
		if b=0 then strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim.gif width=" & numHeight & " height=" & numNarrow & "><br>"
		b=b+1
		if b=2 then b=0
	end if

	if mid(strConv,t,1)="w" then
		if b=1 then strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim_black.gif width=" & numHeight & " height=" & numNarrow*2 & "><br>"
		if b=0 then strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim.gif width=" & numHeight & " height=" & numNarrow*2 & "><br>"
		b=b+1
		if b=2 then b=0
	end if

	if mid(strconv,t,1)="s" then
		strRETORNO = strRETORNO & "<img src="&prCAMINHO&"barcode39_shim.gif width=" & numHeight & " height=" & numNarrow & "><br>"
		b=1
	end if
next

'strRETORNO = strRETORNO & "*" & prBARCODE & "*"
ReturnBarCode39Vertical = strRETORNO

End Function

'=========================================================================
' Função para retornar string (codigo HMTL) do codigo de barras padrão Code39 atraves da DLL ASPBarcode, usando paramentro de altura, largura, caminho base das imagens
Public Function DLLReturnBarCode39(prBARCODE, prALTURA, prLARGURA, prCAMINHO)

DLLReturnBarCode39 = "<img src='"&prCAMINHO&"dllbarcode.asp?barcode="&prBARCODE&"&h="&prALTURA&"' border='0'>"

End Function


'=========================================================================
' Função para retornar string (codigo HMTL) do codigo de barras usando ASP Classic BARCODE.ASP - monta imagem ON THE FLY do codigo de barra 
' O nome da Função foi mantido "ReturnBarCode39" para não precisar fazer atualização em todas as paginas que montam codigo de barras no sistema, POREM isto deve ser revisado em outro momento.
' Mauro - 15/01/2015
Public Function ReturnBarCode39(prBARCODE, prALTURA, prLARGURA, prCAMINHO)
Dim strRETORNO, strCAMINHO

strCAMINHO = Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/_include/"
If Request.ServerVariables("HTTPS") = "on" Then
  strCAMINHO = "https://" & strCAMINHO
Else
  strCAMINHO = "http://" & strCAMINHO
End If

If Session("BARCODE_HEIGHT") <> "" Then
  prALTURA = Session("BARCODE_HEIGHT")
End If

If Session("BARCODE_MODE") = "qrcode" Then
	strRETORNO = "<img src='https://chart.googleapis.com/chart?cht=qr&chs="&prALTURA&"&chl="&prBARCODE&"' border='0'>"
Else
	strRETORNO = "<img src='"&strCAMINHO&"barcode.asp?code="&prBARCODE&"&height="&prALTURA&"&width="&fix(prLARGURA)&"&mode="&Session("BARCODE_MODE")&"&text=0' border='0'>"
	strRETORNO = strRETORNO & "<BR>*" & prBARCODE & "*"
End If

'Debug/Teste do antigo codigo de barras
'strRETORNO = strRETORNO & "<BR><BR>" & ReturnBarCode39_HTML(prBARCODE, prALTURA, prLARGURA, prCAMINHO)

ReturnBarCode39 = strRETORNO

End Function

Public Function ReturnBarCode39Cli(prBARCODE, prALTURA, prLARGURA, prCAMINHO,prCliente)
Dim strRETORNO, strCAMINHO

strCAMINHO = Request.ServerVariables("SERVER_NAME") & "/" & prCliente & "/_include/"
If Request.ServerVariables("HTTPS") = "on" Then
  strCAMINHO = "https://" & strCAMINHO
Else
  strCAMINHO = "http://" & strCAMINHO
End If

If Session("BARCODE_HEIGHT") <> "" Then
  prALTURA = Session("BARCODE_HEIGHT")
End If

If Session("BARCODE_MODE") = "qrcode" Then
	strRETORNO = "<img src='https://chart.googleapis.com/chart?cht=qr&chs="&prALTURA&"&chl="&prBARCODE&"' border='0'>"
Else
	strRETORNO = "<img src='"&strCAMINHO&"barcode.asp?code="&prBARCODE&"&height="&prALTURA&"&width="&fix(prLARGURA)&"&mode="&Session("BARCODE_MODE")&"&text=0' border='0'>"
	strRETORNO = strRETORNO & "<BR>*" & prBARCODE & "*"
End If

'Debug/Teste do antigo codigo de barras
'strRETORNO = strRETORNO & "<BR><BR>" & ReturnBarCode39_HTML(prBARCODE, prALTURA, prLARGURA, prCAMINHO)

ReturnBarCode39Cli = strRETORNO

End Function

%>

