<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="config.inc"--> 
<!--#include file="athdbConn.asp"--> 
<!--#include file="athFileTools.asp"--> 

<%
  ' **** LEGENDA ***
  ' Esta p�gina precisa receber os seguintes valores do formul�rio que a chama:
  ' DEFAULT_TABLE = Tabela a ser feita a dele��o
  ' DEFAULT_DB = Vari�vel do banco de dados incluso no arquivo config.inc (CFG_DB_SITE ou CFG_DB_DADOS)
  ' RECORD_KEY_NAME = Nome do campo chave da tabela onde ir� buscar o arquivo a ser deletado
  ' RECORD_KEY_VALUE = Valor do campo chave da tabela onde ir� buscar o arquivo a ser deletado
  ' DEFAULT_LOCATION = P�gina e par�metros para o redirecionamento
  ' Obs: DEFAULT_LOCATION ir� redirecionar para a p�gina que est� em seu value, para continuar na mesma p�gina,
  ' insira o link da pr�pria p�gina em que est�
  '*****************************************************************************************************************************


Dim ObjConn, ObjRS 
Dim ObjFSConn ,ObjFS, SiteDir
Dim DEFAULT_TABLE, DEFAULT_DB, RECORD_KEY_NAME, RECORD_KEY_VALUE, DEFAULT_LOCATION, FIELD_IMAGE, PATH_NAME
Dim strSQL, strCODIGO, strCOD_IMAGES

	DEFAULT_TABLE    = Request("DEFAULT_TABLE")
	DEFAULT_DB       = Request("DEFAULT_DB")
	RECORD_KEY_NAME  = Request("RECORD_KEY_NAME")
	RECORD_KEY_VALUE = Replace(Request("RECORD_KEY_VALUE"),"'","''")
	DEFAULT_LOCATION = Request("DEFAULT_LOCATION")
	FIELD_IMAGE      = Request("FIELD_IMAGE")
	PATH_NAME        = Request("PATH_NAME")

'response.Write(default_table & "<BR>")
'response.Write(default_db & "<BR>")
'response.Write(record_key_name & "<BR>")
'response.Write(record_key_value & "<BR>")
'response.Write(DEFAULT_LOCATION & "<BR>")
'response.Write(field_image & "<BR>")
'response.Write(path_name & "<BR>")


	AbreDBConn ObjConn, DEFAULT_DB 

	If RECORD_KEY_VALUE <> "" Then
		strSQL = "SELECT CODIGO, IMG, IMG_THUMB " &_
		         "FROM RV_IMAGES " &_
				 "WHERE " & RECORD_KEY_NAME & " IN (" & RECORD_KEY_VALUE & ")"	
		'DEBUG SQL
		'response.Write(strSQL & "<BR>")

		'Remove os arquivos de imagens ---------------------------------------------------------
		AbreFSConn ObjFSConn, SiteDir
		Set ObjRS = objConn.Execute(strSQL)

			strCODIGO = ObjRS("CODIGO")
	        While NOT ObjRS.EOF
				RemoveArquivo ObjFSConn, SiteDir & PATH_NAME & ObjRS(FIELD_IMAGE)
				ObjRS.MoveNext
	        Wend
    	    FechaFSConn ObjFSConn
 			' ---------------------------------------------------------------------------------------
	End If

	FechaRecordSet objRS
	FechaDBConn ObjConn
	Response.Redirect(DEFAULT_LOCATION & strCODIGO)
%>