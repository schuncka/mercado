<%
Dim objRSCombo, strSQLCombo
' ===============================================================================
' Constroi um COMBO com os Corretores                                             
' ===============================================================================

    strSQLCombo =               " SELECT "
    strSQLCombo = strSQLCombo & "  tbl_Cargos.CAMPO1"
    strSQLCombo = strSQLCombo & ", tbl_Cargos.CAMPO2"
    strSQLCombo = strSQLCombo & " FROM tbl_Cargos"
    strSQLCombo = strSQLCombo & " ORDER BY tbl_Cargos.CAMPO2"
    
    Set objRSCombo = objConn.Execute(strSQLCombo)

    Do While not objRSCombo.EOF
         Response.Write "<option value=""" & objRSCombo("CAMPO2") & """>" & objRSCombo("CAMPO2") & "</option>"
        objRSCombo.MoveNext
    Loop
    objRSCombo.Close
    Set objRSCombo = Nothing
%>