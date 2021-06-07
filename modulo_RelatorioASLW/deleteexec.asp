<!--#include file="../_database/athdbConn.asp"-->
<!--#include file="../_database/athFileTools.asp"-->
<%

Function DeletaDados(DEFAULT_TABLE, DEFAULT_DB, RECORD_KEY_NAME, RECORD_KEY_VALUE, RECORD_KEY_NAME_EXTRA, RECORD_KEY_VALUE_EXTRA, DEFAULT_LOCATION, MSG)
On Error Resume Next

  Dim ObjConn_DeleteToDB, StrSql_DeleteToDB, StrSQL_DeleteImagesToDB

  AbreDBConn ObjConn_DeleteToDB, DEFAULT_DB
   StrSql_DeleteToDB = "DELETE FROM "& DEFAULT_TABLE & " WHERE " &  RECORD_KEY_NAME & " IN (" &  RECORD_KEY_VALUE & ")"
   If RECORD_KEY_NAME_EXTRA <> "" THEN
   	   StrSql_DeleteToDB = StrSql_DeleteToDB &  " AND " & RECORD_KEY_NAME_EXTRA & " = '" &  RECORD_KEY_VALUE_EXTRA & "'"
   End IF
    'Response.Write "<br> DEBUG: StrSql_DeleteToDB<BR><BR>" & (StrSql_DeleteToDB)
   ObjConn_DeleteToDB.Execute(StrSql_DeleteToDB)

   If MSG <> 0 Then
	If Err.Number<>0 Then 
      If Err.Number=-2147467259 Then
     	Mensagem "Para poder deletar um ou mais matérias você deve primeiro deletar suas sei lá o que.<br><br>", "Javascript:history.back()", 0
	  Else
	  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1
      End if
	Else
      Mensagem "O(s) registro(s) foi(ram) apagado(s) com sucesso", DEFAULT_LOCATION, 1
	End if
   Else
      Response.Redirect(DEFAULT_LOCATION)
   End If
  FechaDBConn ObjConn_DeleteToDB
End Function


	Dim strParams
	Dim strALL_PARAMS

	strParams = Request("codigo")
 	strALL_PARAMS = Request.QueryString
	If strALL_PARAMS = "" Then 
		strALL_PARAMS = Request.Form
 	End If

	DeletaDados "tbl_ASLW_RELATORIO", CFG_DB, "COD_RELATORIO", strParams, "","", "ConsDados.asp?" & strALL_PARAMS, 0
%>