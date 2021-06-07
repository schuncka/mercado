<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="adovbs.inc"-->
<!--#include file="config.inc"-->
<!--#include file="athDbConn.asp"--> 
<!--#include file="athUtils.asp"--> 
<%
  '********************************* Nome de Campos de Formulários ***************************************
  '*******************************************************************************************************
  ' 1° - Crie um prefixo - ex: DBVAR_
  ' 2° - Escolha o tipo de dados que a tabela recebe para este campo:
  ' STR - Texto e Memo
  ' NUM - Número
  ' AUTODATE - Data/Hora (obs: o valor para este campo deve ser vazio)
  ' BOOL - Sim/Não
  ' DATE - Data
  ' 3° - Escreva o nome do campo na tabela
  ' 4° - Se o campo for requerido adicione "ô" ao final de seu nome
  '
  'Obs: Sempre adicione _ após o Prefixo e o Tipo_campo_tabela
  '
  ' Ex:  Prefixo   Tipo_campo_Tabela    Nome_campo_Tabela   Nome_campo_formulário  É Requerido
  '       DBVAR_          STR_               TEXTO             DBVAR_STR_TEXTO         Não
  '       VAR_            NUM_               CODIGO            VAR_NUM_CODIGOô         Sim
  '
  ' Exemplo prático:
  ' 
  '*******************************************************************************************************
  '*******************************************************************************************************
  ' Esta página precisa receber os seguintes valores do formulário que a chama:
  ' DEFAULT_TABLE = Tabela a ser feita a deleção
  ' DEFAULT_DB = Variável do banco de dados incluso no arquivo config.inc (CFG_DB_SITE ou CFG_DB_DADOS)  
  ' RECORD_KEY_NAME = Nome do campo que servirá de condição para a deleção
  ' RECORD_KEY_VALUE = Valor do campo que servirá de condição para a deleção (pode ser mais de um valor)
  ' DEFAULT_LOCATION = Página e parâmetros para o redirecionamento
  '*******************************************************************************************************
   
  Response.Expires = 0
  Dim ObjConn_DeleteToDB, StrSql_DeleteToDB, StrSQL_DeleteImagesToDB
  Dim AuxStr
  'Variáveis passadas pelo formulário
  Dim DEFAULT_TABLE, RECORD_KEY_NAME, RECORD_KEY_VALUE, RECORD_KEY_NAME_EXTRA, RECORD_KEY_VALUE_EXTRA, DEFAULT_LOCATION, DEFAULT_DB

  DEFAULT_TABLE          = Request("DEFAULT_TABLE")
  DEFAULT_DB	         = Request("DEFAULT_DB")
  RECORD_KEY_NAME        = Request("RECORD_KEY_NAME")
  RECORD_KEY_VALUE       = Request("RECORD_KEY_VALUE")
  DEFAULT_LOCATION       = Request("DEFAULT_LOCATION")
  RECORD_KEY_NAME_EXTRA  = Request("RECORD_KEY_NAME_EXTRA")
  RECORD_KEY_VALUE_EXTRA = Request("RECORD_KEY_VALUE_EXTRA")

  AuxStr = Request.QueryString
  If AuxStr = "" Then
  	AuxStr = Request.Form
  End If

 'Debug dos "fields" e seus respectivos "values" e "types" recebidos 
' Response.Write "<BR>DEFAULT_TABLE: " &  DEFAULT_TABLE
 'Response.Write "<BR>RECORD_KEY_NAME: " &  RECORD_KEY_NAME
' Response.Write "<BR>RECORD_KEY_VALUE: " &  RECORD_KEY_VALUE
' Response.Write "<BR>DEFAULT_LOCATION: " &  DEFAULT_LOCATION
' Response.Write "<BR><BR>AUXSTR: " &  Auxstr & "<BR><BR>"
 'Response.End()
  
  AbreDBConn ObjConn_DeleteToDB, DEFAULT_DB

   StrSql_DeleteToDB = "DELETE FROM "& DEFAULT_TABLE & " WHERE " &  RECORD_KEY_NAME & " IN (" &  RECORD_KEY_VALUE & ")"
   
   If RECORD_KEY_NAME_EXTRA <> "" THEN
   	If NOT isNumeric(RECORD_KEY_VALUE_EXTRA) Then
   	   StrSql_DeleteToDB = StrSql_DeleteToDB &  " AND " & RECORD_KEY_NAME_EXTRA & " = '" &  RECORD_KEY_VALUE_EXTRA & "'"
	Else
	   StrSql_DeleteToDB = StrSql_DeleteToDB &  " AND " & RECORD_KEY_NAME_EXTRA & " = " &  RECORD_KEY_VALUE_EXTRA
	End If
   End IF

  'Response.Write "<br> DEBUG: StrSql_DeleteToDB<BR><BR>" & (StrSql_DeleteToDB)
  'Response.End()
	
   ObjConn_DeleteToDB.Execute(StrSql_DeleteToDB)
   
   
	If Err.Number<>0 then 
	  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION
	Else
      Mensagem "O(s) registro(s) foi(ram) apagado(s) com sucesso", DEFAULT_LOCATION
	End if 

  FechaDBConn ObjConn_DeleteToDB
%>