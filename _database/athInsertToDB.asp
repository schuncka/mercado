<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="adovbs.inc"-->
<!--#include file="config.inc"-->
<!--#include file="athDbConn.asp"-->
<!--#include file="athutils.asp"--> 
<%
  'Session.LCID = 1046	

'***********************
'      VERSÃO 1.0      *
'      08/03/2004      *
'***********************

  On Error Resume Next
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
  ' **** LEGENDA ***
  ' Esta página precisa receber os seguintes valores do formulário que a chama:
  ' DEFAULT_TABLE = Tabela a ser feita a deleção
  ' DEFAULT_DB = Variável do banco de dados incluso no arquivo config.inc (CFG_DB_SITE ou CFG_DB_DADOS)
  ' FIELD_PREFIX = Prefixo do nome do campo do formulário (ex: nome: DBVAR_NUM_COD_CLI prefixo: DBVAR_)
  ' RECORD_KEY_NAME = Nome do campo chave da tabela a ser inserido o registro (usado para redirecionar para o último registro)
  ' DEFAULT_LOCATION = Página e parâmetros para o redirecionamento
  ' Obs: DEFAULT_LOCATION irá redirecionar para a página que está em seu value, para continuar na mesma página,
  ' insira o link da própria página em que está
  '
  '
  ' RECORD_KEY_SELECT = Nome de um campo extra (usado para o redirecionamento correto quando se insere imagens)
  ' RECORD_KEY_NAME_EXTRA = Nome de um campo extra se for necessário
  ' RECORD_KEY_VALUE_EXTRA = Valor de um campo chave extra se for necessário
  '*****************************************************************************************************************************

  
  Response.Expires = 0
  Dim ObjConn_InsertToDB, StrSql_InsertToDB
  'Variáveis para montar a cláusula SQL
  Dim ArrayParam, Param, MyTbFields, MyTbValues, MyFRequired, AuxField, AuxValue, AuxType, AuxStr, FlagOk, StrAviso
  'Variáveis passadas pelo formulário
  Dim DEFAULT_TABLE, FIELD_PREFIX, RECORD_KEY_NAME, DEFAULT_LOCATION, DEFAULT_DB, RECORD_KEY_NAME_EXTRA, RECORD_KEY_VALUE_EXTRA, RECORD_KEY_SELECT
  
  DEFAULT_TABLE     = Request("DEFAULT_TABLE")
  DEFAULT_DB	    = Request("DEFAULT_DB")
  FIELD_PREFIX      = Request("FIELD_PREFIX")
  RECORD_KEY_NAME   = Request("RECORD_KEY_NAME")
  DEFAULT_LOCATION  = Request("DEFAULT_LOCATION")
  
  RECORD_KEY_NAME_EXTRA  = Request("RECORD_KEY_NAME_EXTRA")
  RECORD_KEY_VALUE_EXTRA = Request("RECORD_KEY_VALUE_EXTRA")
  RECORD_KEY_SELECT      = Request("RECORD_KEY_SELECT")

  AuxStr = Request.QueryString
  If AuxStr = "" Then
	  AuxStr = Request.Form
  End If
  AuxStr = Mid(AuxStr,InStr(AuxStr,FIELD_PREFIX) + Len(FIELD_PREFIX) + 1)
 'Debug dos "fields" e seus respectivos "values" e "types" recebidos 
 'Response.Write "<BR>DEFAULT_TABLE: " &  DEFAULT_TABLE
 'Response.Write "<BR>FIELD_PREFIX: " &  FIELD_PREFIX
 'Response.Write "<BR>DEFAULT_LOCATION: " &  DEFAULT_LOCATION
 'Response.Write "<BR><BR>AUXSTR: " &  Auxstr & "<BR><BR>"

  ArrayParam = Split(AuxStr,"&")

  MyTbFields  = ""
  MyTbValues  = ""
  For Each Param in ArrayParam 
	Param = Replace(Param,"'","''")
	if InStr(Param,FIELD_PREFIX)>0 then
      Param = Replace(Param,FIELD_PREFIX,"")
      AuxField = Mid(Param,1,InStr(Param,"=")-1)
	  AuxValue = URLDecode(Mid(Param,InStr(Param,"=")+1))
	  AuxType  = Mid(AuxField,1,InStr(Param,"_")-1)
      AuxField = URLDecode(Mid(AuxField,InStr(Param,"_")+1,InStr(Param,"=")-1))

	  If Instr(AuxField,"ô")>0 then 
        AuxField = Replace(AuxField,"ô","")
	    MyFRequired = MyFRequired & "(Request(""" & FIELD_PREFIX & AuxType & "_" & AuxField & "ô"")="""")or"
	  end if
	  'Substitui todos os caracteres especiais pelo respectivo código HTML
	  'AuxValue = ReturnCodigo(AuxValue)
	  AuxValue = Replace(AuxValue, "'", "''")
	  
      select case ucase(AuxType)
        case "NUM"       If ((AuxValue = "") or (not isNumeric(AuxValue))) then
                           AuxValue = "NULL"
						 Else
						 	AuxValue = ("'" & AuxValue & "'")
                         End If
        case "STR"	     If (AuxValue = "") then
                           AuxValue = "NULL"
                 	     Else
                           AuxValue = ("'" & AuxValue & "'")
                         End if
        case "AUTODATE"  If (AuxValue = "") then
						   AuxValue = "'"&strIsoDate(NOW)&"'"
                         End if
        case "BOOL"      If (AuxValue = "") then
                           AuxValue = ("FALSE")
                         End if
        case "DATE" 	 If (AuxValue = "") then
						   AuxValue = "NULL"
						 Else
						   If isDate(AuxValue) Then 
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
						   AuxValue=replace(AuxValue,".","")
						   AuxValue=replace(AuxValue,",",".")
                         End If
      End Select	
     	'Debug dos "fields" e seus respectivos "values" e "types" recebidos 
      	'Response.Write "TYPE: "  & AuxType & "<br>"
      	'Response.Write "FIELD: " & AuxField & "<br>"
      	'Response.Write "VALUE: " & AuxValue & "<br>"
  	  MyTbFields = MyTbFields & AuxField & ","
      MyTbValues = MyTbValues & AuxValue & ","
	End if
  Next

  AbreDBConn ObjConn_InsertToDB, DEFAULT_DB

  StrAviso = ""
  MyFRequired = MyFRequired &")"
  MyFRequired = Replace(MyFRequired,"or)","")
  MyFRequired = Replace(MyFRequired,"==","=")
  Response.Write "DEBUG: Campos requeridos <BR><BR>" & (MyFRequired) & "<br><br>"

  FlagOk = (MyFRequired=")") 'Significa que não tem campos requeridos
  If NOT FlagOk then 
    If Eval(MyFRequired) Then
 	  Mensagem "Você tem que preencher todos os campos obrigatórios.", "Javascript:history.back()"
	  FlagOk = False
    Else 
	  FlagOk = True
    End If
  End If
 
  If FlagOk then
    StrSql_InsertToDB = "INSERT INTO "& DEFAULT_TABLE & "(" & MyTbFields & ") VALUES (" & MyTbValues & ")"
    StrSql_InsertToDB = Trim(Replace(StrSql_InsertToDB,",)",")"))
   	
	'Response.Write "<br> DEBUG: StrSql_InsertToDB<BR><BR>" & (StrSql_InsertToDB)
	'Response.End()	
	
    ObjConn_InsertToDB.Execute(StrSql_InsertToDB)
'	Response.End()
  End If
  
  FechaDBConn ObjConn_InsertToDB

  If FlagOk Then
    if Err.Number <> 0 Then
	  'Mensagem Err.Number & " - "& Err.Description & "<BR>" & StrSql_InsertToDB , DEFAULT_LOCATION
	  Mensagem Err.Number & " - "& Err.Description, DEFAULT_LOCATION
    Else
	  '---------------------------------------------------------------
	  'Seleciona o último inserido...
	  'e repassa para o local indicado via "var_chavereg"
	  '---------------------------------------------------------------
	  Dim strSQL, objRS, ObjConn
      Dim strCODIGO
	
      	AbreDBConn objConn, DEFAULT_DB
		'Se enviar somente o código para pesquisar o último inserido
		If RECORD_KEY_SELECT <> "" AND RECORD_KEY_NAME_EXTRA = "" AND RECORD_KEY_VALUE_EXTRA = "" Then
	  		strSQL = "SELECT  Max(" & RECORD_KEY_NAME & ") AS EXPR, Last(" & RECORD_KEY_SELECT & ") AS COD FROM " & DEFAULT_TABLE 
		    'Debug SQL:
		    'Response.Write(strSQL & "<BR>")
			Set objRS = objConn.Execute(strSQL)
	  	    strCODIGO = objRS("COD")		
		'Se enviar o código e um critério para o último inserido
		ElseIf (RECORD_KEY_NAME_EXTRA = "" AND RECORD_KEY_VALUE_EXTRA = "") OR RECORD_KEY_SELECT = "" Then 
	  	    	strSQL = "SELECT Max(" & RECORD_KEY_NAME & ") AS COD FROM " & DEFAULT_TABLE
				'Debug SQL:
				'Response.Write(strSQL & "<BR>")
				Set objRS = objConn.Execute(strSQL)
				strCODIGO = objRS("COD")
			Else'Se não for numérico o campo então executa esse SQL
				If NOT isNumeric(RECORD_KEY_VALUE_EXTRA) Then
					strSQL = "SELECT Max(" & RECORD_KEY_NAME & ") AS EXPR, Last(" & RECORD_KEY_SELECT & ") AS COD FROM " & DEFAULT_TABLE & " WHERE " & RECORD_KEY_NAME_EXTRA & " = '" & RECORD_KEY_VALUE_EXTRA & "'"
    	         	'Response.Write(strSQL & "<BR>")
        	     	Set objRS = objConn.Execute(strSQL)
            	 	strCODIGO = objRS("COD")
				Else
			 		strSQL = "SELECT Max(" & RECORD_KEY_NAME & ") AS EXPR, Last(" & RECORD_KEY_SELECT & ") AS COD FROM " & DEFAULT_TABLE & " WHERE " & RECORD_KEY_NAME_EXTRA & " = " & RECORD_KEY_VALUE_EXTRA
    	         	'Response.Write(strSQL & "<BR>")
        	     	Set objRS = objConn.Execute(strSQL)
            	 	strCODIGO = objRS("COD")
		 		End If
	  End If
	  'Debug CODIGO e REDIRECT
	  'Response.Write(strCODIGO & "<BR>")
          'Response.Write(DEFAULT_LOCATION & "?var_chavereg=" &  strCODIGO)
	  'Response.Write(strSQL & "<BR>")
	  'Response.End()
	  If InStr(DEFAULT_LOCATION,"?") <= 0 Then
	    Response.Redirect (DEFAULT_LOCATION & "?var_chavereg=" &  strCODIGO)
	  Else
	    Response.Redirect (DEFAULT_LOCATION)
	  End If
	  '---------------------------------------------------------------
	  '---------------------------------------------------------------
      FechaRecordset objRS
      FechaDBConn objConn
	End if 
  End if %>