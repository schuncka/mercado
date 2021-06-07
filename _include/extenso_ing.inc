<%
Dim ing_Centavos, ing_I, ing_J, ing_K, ing_Numero, ing_QtdCentenas, ing_TotCentenas, ing_TxtExtenso( 900 ), ing_TxtMoeda( 6 ), ing_ValCentena( 6 ), ing_Valor, ing_ValSoma

' Matrizes de textos
ing_TxtMoeda( 1 ) = "real"
ing_TxtMoeda( 2 ) = "thousand"
ing_TxtMoeda( 3 ) = "million"
ing_TxtMoeda( 4 ) = "billion"
ing_TxtMoeda( 5 ) = "trillion"

ing_TxtExtenso( 1 ) = "one"
ing_TxtExtenso( 2 ) = "two"
ing_TxtExtenso( 3 ) = "tree"
ing_TxtExtenso( 4 ) = "four"
ing_TxtExtenso( 5 ) = "five"
ing_TxtExtenso( 6 ) = "six"
ing_TxtExtenso( 7 ) = "seven"
ing_TxtExtenso( 8 ) = "eight"
ing_TxtExtenso( 9 ) = "nine"
ing_TxtExtenso( 10 ) = "ten"
ing_TxtExtenso( 11 ) = "eleven"
ing_TxtExtenso( 12 ) = "twelve"
ing_TxtExtenso( 13 ) = "thirten"
ing_TxtExtenso( 14 ) = "fourten"
ing_TxtExtenso( 15 ) = "fiften"
ing_TxtExtenso( 16 ) = "sixten"
ing_TxtExtenso( 17 ) = "seventen"
ing_TxtExtenso( 18 ) = "eighten"
ing_TxtExtenso( 19 ) = "nineten"
ing_TxtExtenso( 20 ) = "twenty"
ing_TxtExtenso( 30 ) = "thirty"
ing_TxtExtenso( 40 ) = "fourty"
ing_TxtExtenso( 50 ) = "fifty"
ing_TxtExtenso( 60 ) = "sixty"
ing_TxtExtenso( 70 ) = "seventy"
ing_TxtExtenso( 80 ) = "eighty"
ing_TxtExtenso( 90 ) = "ninety"
ing_TxtExtenso( 100 ) = "hundred"
ing_TxtExtenso( 200 ) = "two hundred"
ing_TxtExtenso( 300 ) = "tree hundred"
ing_TxtExtenso( 400 ) = "four hundred"
ing_TxtExtenso( 500 ) = "five hundred"
ing_TxtExtenso( 600 ) = "six hundred"
ing_TxtExtenso( 700 ) = "seven hundred"
ing_TxtExtenso( 800 ) = "eight hundred"
ing_TxtExtenso( 900 ) = "nine hundred"

' Função Principal de Conversão de Valores em Extenso
Function Extenso( ing_Numero )
ing_Numero = FormatNumber( ing_Numero , 2 )
ing_Centavos = right( ing_Numero , 2 )
ing_ValCentena( 0 ) = 0
ing_QtdCentenas = int( ( len( ing_Numero ) + 1 ) / 4 )

For ing_I = 1 to ing_QtdCentenas
ing_ValCentena( ing_I ) = "" 
Next
'
ing_I = 1
ing_J = 1
For ing_K = len( ing_Numero ) - 3 to 1 step -1
ing_ValCentena( ing_J ) = mid( ing_Numero , ing_K , 1 ) & ing_ValCentena( ing_J )
if ing_I / 3 = int( ing_I / 3 ) then
ing_J = ing_J + 1
ing_K = ing_K - 1
end if
ing_I = ing_I + 1
next
ing_TotCentenas = 0
Extenso = "" 
For ing_I = ing_QtdCentenas to 1 step -1

ing_TotCentenas = ing_TotCentenas + int( ing_ValCentena( ing_I ) )

if int( ing_ValCentena( ing_I ) ) <> 0 or ( int( ing_ValCentena( ing_I ) ) = 0 and ing_I = 1 )then
if int( ing_ValCentena( ing_I ) = 0 and int( ing_ValCentena( ing_I + 1 ) ) = 0 and ing_I = 1 )then
Extenso = Extenso & ExtCentena( ing_ValCentena( ing_I ) , ing_TotCentenas ) & " de " & ing_TxtMoeda( ing_I )
else
Extenso = Extenso & ExtCentena( ing_ValCentena( ing_I ) , ing_TotCentenas ) & " " & ing_TxtMoeda( ing_I )
end if
if int( ing_ValCentena( ing_I ) ) <> 1 or ( ing_I = 1 and ing_TotCentenas <> 1 ) then
Select Case ing_I
Case 1
Extenso = Extenso & "is"
Case 3, 4, 5
Extenso = Extenso & "ões"
End Select 
else
Select Case ing_I
Case 1
Extenso = Extenso & "l"
Case 3, 4, 5
Extenso = Extenso & "ão"
End Select 
end if
end if
if int( ing_ValCentena( ing_I - 1 ) ) = 0 then
Extenso = Extenso
else
if ( int( ing_ValCentena( ing_I + 1 ) ) = 0 and ( ing_I + 1 ) <= ing_QtdCentenas ) or ( ing_I = 2 ) then
Extenso = Extenso & " and "
else
Extenso = Extenso & ", "
end if
end if 
next

if ing_Centavos > 0 then
if int( ing_Centavos ) = 1 then
Extenso = Extenso & " and " & ExtDezena( ing_Centavos ) & " cents"
else
Extenso = Extenso & " and " & ExtDezena( ing_Centavos ) & " cents"
end if
end if
Extenso = UCase( Left( Extenso , 1 ) )&right( Extenso , len( Extenso ) - 1 )
End Function

function ExtDezena( ing_Valor )
' Retorna o Valor por Extenso referente à DEZENA recebida
ExtDezena = ""
if int( ing_Valor ) > 0 then
if int( ing_Valor ) < 20 then
ExtDezena = ing_TxtExtenso( int( ing_Valor ) )
else
ExtDezena = ing_TxtExtenso( int( int( ing_Valor ) / 10 ) * 10 )
if ( int( ing_Valor ) / 10 ) - int( int( ing_Valor ) / 10 ) <> 0 then
ExtDezena = ExtDezena & " and " & ing_TxtExtenso( int( right( ing_Valor , 1 ) ) )
end if
end if
end if
End Function

function ExtCentena( ing_Valor, ing_ValSoma )
ExtCentena = ""

if int( ing_Valor ) > 0 then

if int( ing_Valor ) = 100 then
ExtCentena = "hundred"
else
if int( ing_Valor ) < 20 then
if int( ing_Valor ) = 1 then
If ing_ValSoma - int( ing_Valor ) = 0 then
ExtCentena = "one"
else
ExtCentena = ing_TxtExtenso( int( ing_Valor ) )
end if
else
ExtCentena = ing_TxtExtenso( int( ing_Valor ) )
end if
else
if int( ing_Valor ) < 100 then
ExtCentena = ExtDezena( right( ing_Valor , 2 ) )
else 
ExtCentena = ing_TxtExtenso( int( int( ing_Valor ) / 100 )*100 )
if ( int( ing_Valor ) / 100 ) - int( int( ing_Valor ) / 100 ) <> 0 then
ExtCentena = ExtCentena & " and " & ExtDezena( right( ing_Valor , 2 ) )
end if
end if
end if
end if
end if
End Function
%>