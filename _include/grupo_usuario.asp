<%
Sub MontaComboGrupoUsuario(prGRUPO)
 Dim strGRUPO_TEMP, arrGRUPO_TEMP, strGRUPO_CHECKED
 
 arrGRUPO_TEMP = array("ADMIN", "NORMAL", "NORMAL-PRE", "EXPRESSO", "CAIXA", "ACESSO-FEIRA", "ACESSO-SALA")

 For Each strGRUPO_TEMP In arrGRUPO_TEMP
   strGRUPO_CHECKED = ""
   If strGRUPO_TEMP = prGRUPO Then
     strGRUPO_CHECKED = " selected"
   End If
   Response.Write "<option value=""" & UCase(strGRUPO_TEMP) & """" & strGRUPO_CHECKED & ">" & strGRUPO_TEMP & "</option>"
 Next

End Sub
%>