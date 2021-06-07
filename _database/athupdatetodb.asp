<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="adovbs.inc"-->
<!--#include file="config.inc"-->
<!--#include file="athDbConn.asp"--> 
<!--#include file="athUtils.asp"--> 
<%
  Session.LCID = 1046
  
'***********************
'      VERSÃO 1.0      *
'      08/03/2004      *
'***********************

  '********************************* Nome de Campos de Formulários *************************************************************
  '*****************************************************************************************************************************
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
  ' Exemplo prático ...
  ' <form name="forminsert" action="_database/athInsertToDB.asp" method="POST">
  '	 <input type="hidden" name="DEFAULT_TABLE" value="RV_REVISTA">
  '	 <input type="hidden" name="DEFAULT_DB" value="[database.mdb]">
  '  <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
  '	 <input type="hidden" name="RECORD_KEY_NAME" value="COD_REVISTA">
  '	 <input type="hidden" name="DEFAULT_LOCATION" value="../_athcsm/revista/update.asp">
  '	 <input type="hidden" name="DBVAR_AUTODATE_DT_CRIACAO" value="">
  ' ...	
  '
  ' **** LEGEndA ***
  ' Esta página precisa receber os seguintes valores do formulário que a chama:
  ' DEFAULT_TABLE = Tabela a ser feita a deleção
  ' DEFAULT_DB = Variável do banco de dados incluso no arquivo config.inc (CFG_DB_SITE ou CFG_DB_DADOS)
  ' FIELD_PREFIX = Prefixo do nome do campo do formulário (ex: nome: DBVAR_NUM_COD_CLI prefixo: DBVAR_)
  ' RECORD_KEY_NAME = Nome do campo chave da tabela a ser inserido o registro (usado para redirecionar para o último registro)
  ' DEFAULT_LOCATION = Página e parâmetros para o redirecionamento
  ' Obs: DEFAULT_LOCATION irá redirecionar para a página que está em seu value, para continuar na mesma página,
  ' insira o link da própria página em que está
  '*****************************************************************************************************************************
   
  Response.Expires = 0
  Dim ObjConn_UpdateToDB, StrSql_UpdateToDB
 'Variáveis para montar a cláusula SQL
  Dim ArrayParam, Param, MyTbFields, MyTbValues, MyFRequired, AuxField, AuxValue, AuxType, AuxStr, FlagOk, StrAviso, MyTbSetFields
  'Variáveis passadas pelo formulário
  Dim DEFAULT_LOCATION, DEFAULT_TABLE, FIELD_PREFIX, RECORD_KEY_NAME, RECORD_KEY_VALUE, DEFAULT_DB, DEFAULT_MESSAGE
  
  DEFAULT_TABLE    = Request("DEFAULT_TABLE")
  DEFAULT_DB   	   = Request("DEFAULT_DB")
  FIELD_PREFIX     = Request("FIELD_PREFIX")
  RECORD_KEY_NAME  = Request("RECORD_KEY_NAME")
  RECORD_KEY_VALUE = Request("RECORD_KEY_VALUE")
  DEFAULT_LOCATION = Request("DEFAULT_LOCATION")
  DEFAULT_MESSAGE  = Request("DEFAULT_MESSAGE")

  AuxStr = Request.QueryString
  If AuxStr = "" Then
  	AuxStr = Request.Form
  End If

  AuxStr = Mid(AuxStr,InStr(AuxStr,FIELD_PREFIX) + Len(FIELD_PREFIX) + 1)
 'Debug dos "fields" e seus respectivos "values" e "types" recebidos 
  'Response.Write "<BR>DEFAULT_TABLE: " & DEFAULT_TABLE
  'Response.Write "<BR>FIELD_PREFIX: " & FIELD_PREFIX
  'Response.Write "<BR><BR>AUXSTR: " &  Auxstr & "<BR><BR>"

  ArrayParam = Split(AuxStr,"&")

  MyTbFields    = ""
  MyTbValues    = ""
  MyTbSetFields = ""
  For Each Param in ArrayParam 
	Param = Replace(Param,"'","''")
	If InStr(Param,FIELD_PREFIX)>0 then
      Param = Replace(Param,FIELD_PREFIX,"")
      AuxField = Mid(Param,1,InStr(Param,"=")-1)
	  AuxValue = URLDecode(Mid(Param,InStr(Param,"=")+1))
	  AuxType  = Mid(AuxField,1,InStr(Param,"_")-1)
      AuxField = URLDecode(Mid(AuxField,InStr(Param,"_")+1,InStr(Param,"=")-1))

	  If Instr(AuxField,"ô")>0 then 
		AuxField = Replace(AuxField,"ô","")
	    MyFRequired = MyFRequired & "(Request(""" & FIELD_PREFIX & AuxType & "_" & AuxField & "ô"")="""")or"
	  End If
	  'Substitui todos os caracteres especiais pelo respectivo código HTML
	  'AuxValue = ReturnCodigo(AuxValue)
	  AuxValue = Replace(AuxValue, "'", "''")
	  
      select case ucase(AuxType)
        case "NUM"       If ((AuxValue = "") or (NOT isNumeric(AuxValue))) then
                           AuxValue = "NULL"
						 Else
						   AuxValue = ("'" & AuxValue & "'")
                         End If
        case "STR"	     If (AuxValue = "") then
                           AuxValue = "NULL"
                 	     Else
                           AuxValue = ("'" & AuxValue & "'")
                         End If
        case "AUTODATE"  If (AuxValue = "") then
						   AuxValue = "'"&strIsoDate(NOW)&"'"
                         End If
        
		case "BOOL"      If (AuxValue = 0 OR AuxValue = "") then
                           AuxValue =0
						 Else
                           AuxValue =1
						 End If
						 
        case "DATE"      If AuxValue = "" Then
						   AuxValue = "NULL"
						 Else
						   If IsDate(AuxValue) Then
	 						   		AuxValue = "'"&strIsoDate(AuxValue)&"'"
						   Else
								AuxValue = "NULL"
						   End If
						 End If
		case "DATETIME"	 If (AuxValue = "") then
						   AuxValue = "NULL"
						 Else
						   If isDate(AuxValue) Then 
	 						   		AuxValue = "'"&strIsoDate(AuxValue)&"'"
						   Else
						   		AuxValue = "NULL"
						   End If
						 End If
		case "MOEDA"     If ((AuxValue = "") or (NOT isNumeric(AuxValue))) then
                           AuxValue = "NULL"
						 Else
						   AuxValue=FormatNumber(AuxValue,2)
						   AuxValue=replace(AuxValue,".","")
						   AuxValue=replace(AuxValue,",",".")
                         End If
		case "FLOAT"     If ((AuxValue = "") or (NOT isNumeric(AuxValue))) then
                           AuxValue = "NULL"
						 Else
'						   AuxValue=FormatNumber(AuxValue)
						   AuxValue=replace(AuxValue,".","")
						   AuxValue=replace(AuxValue,",",".")
                         End If
      End select	
      'Debug dos "fields" e seus respectivos "values" e "types" recebidos 
      'Response.Write "TYPE: "  & AuxType & "<br>"
      'Response.Write "FIELD: " & AuxField & "<br>"
      'Response.Write "VALUE: " & AuxValue & "<br>"
  	  MyTbFields = MyTbFields & AuxField & ","
      MyTbValues = MyTbValues & AuxValue & ","
	  MyTbSetFields = MyTbSetFields & "," & (AuxField & "=" & AuxValue)
	End If
  Next

  AbreDBConn ObjConn_UpdateToDB, DEFAULT_DB

  StrAviso = ""
  MyFRequired = MyFRequired &")"
  MyFRequired = Replace(MyFRequired,"or)","")
  MyFRequired = Replace(MyFRequired,"==","=")
  'Response.Write "DEBUG: Campos requeridos <BR><BR>" & (MyFRequired) & "<br><br>"
  
  FlagOk = (MyFRequired=")") 'SignIfica que não tem campos requeridos
  If NOT FlagOk then 
    If Eval(MyFRequired) then
 	  Mensagem "Você tem que preencher todos os campos obrigatórios.", "Javascript:history.back()"
	  FlagOk = False
    Else 
	  FlagOk = True
    End If
  End If
 
  If FlagOk then
    StrSql_UpdateToDB = "UPDATE "& DEFAULT_TABLE & " SET " & MyTbSetFields & " WHERE " &  RECORD_KEY_NAME & "=" &  RECORD_KEY_VALUE
    StrSql_UpdateToDB = Trim(Replace(StrSql_UpdateToDB,"SET ,","SET "))
    'StrSql_UpdateToDB = URLDecode(Trim(Replace(StrSql_UpdateToDB,"SET ,","SET ")))
  ''  Response.Write "<br> DEBUG: StrSql_UpdateToDB<BR><BR>" & (StrSql_UpdateToDB)
	'Response.End()
    ObjConn_UpdateToDB.Execute(StrSql_UpdateToDB)

	If Err.Number<>0 then 
	  Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION
	Else
	  If (ucase(DEFAULT_MESSAGE) = "NOMESSAGE") OR (ucase(DEFAULT_MESSAGE) = "NO MESSAGE") OR (ucase(DEFAULT_MESSAGE) = "NO_MESSAGE") Then
		Response.Redirect (DEFAULT_LOCATION)
	  Else
   	  	Mensagem "Dados alterados com sucesso<br>" & DEFAULT_MESSAGE, DEFAULT_LOCATION
	  End If
	End If 
  End If 

  FechaDBConn ObjConn_UpdateToDB
%>