<%
Function CalculaSenhaBBSI(chave)
 Dim strAUX
 strAUX = 0
 If Len(chave) >= 3 Then
   strAUX = CInt(Right(chave,3)) + 555
 End If
 CalculaSenhaBBSI = strAUX
End Function
%>