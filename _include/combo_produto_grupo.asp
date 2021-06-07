<%
Dim objRSProdutoGrupo, strSQLProdutoGrupo
' ===============================================================================
' Constroi um ProdutoGrupo com os Corretores                                             
' ===============================================================================

    strSQLProdutoGrupo =               " SELECT "
    strSQLProdutoGrupo = strSQLProdutoGrupo & "  distinct(tbl_Produtos.GRUPO)"
    strSQLProdutoGrupo = strSQLProdutoGrupo & " FROM tbl_Produtos"
    strSQLProdutoGrupo = strSQLProdutoGrupo & " WHERE tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")
    strSQLProdutoGrupo = strSQLProdutoGrupo & " GROUP BY tbl_Produtos.GRUPO"
    strSQLProdutoGrupo = strSQLProdutoGrupo & " ORDER BY tbl_Produtos.GRUPO"
    
    Set objRSProdutoGrupo = objConn.Execute(strSQLProdutoGrupo)

    Do While not objRSProdutoGrupo.EOF
         Response.Write "<option value=""" & objRSProdutoGrupo("GRUPO") & """>" & objRSProdutoGrupo("GRUPO") & "</option>"
        objRSProdutoGrupo.MoveNext
    Loop
    objRSProdutoGrupo.Close
    Set objRSProdutoGrupo = Nothing
%>