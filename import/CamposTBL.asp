<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"-->
<%
 AbreDBConn objConn, CFG_DB_DADOS 


strSQL="show tables "
set objRS2 = Server.CreateObject("ADODB.Recordset")
objRS2.Open strSQL, objConn
while not objRS2.EOF

	Response.Write(objRS2("tables_in_"&CFG_DB_DADOS)&"<br>")

	objRS2.Movenext
Wend


'
'
'  For I = 0 To objConn.TableDefs.Count - 1  
'
'     '*** pega os nomes de todas as tabelas do banco
'     '
'     MsgBox MyDb.TableDefs(I).Name
'    
'    ' *** Verifica se uma tabela existe no banco de dados
'    '
'    'If UCASE$(MyDb.TableDefs(I).Name) = UCASE$("Nome da tabela que voce quer saber se existe") Then
'     '  MsgBox "A tabela ***  " & MyDb.TableDefs(I).Name & " ***  EXISTE !"
'     ''Else
'     '' MsgBox "A tabela NÃO EXISTE"
'    'End If
'
'  Next 



'Private Sub Form_Load()
strTABELA="tbl_evento"
strSQL="SELECT * FROM "&strTABELA

set objRS = Server.CreateObject("ADODB.Recordset")
objRS.Open strSQL, objConn

Function tipoCAMPO(strCAMPO,strTIPO)

	Select case Int(strTIPO)
		Case  3 :'Inteiro

				if strCAMPO <>"" Then
					tipoCAMPO = int(strCAMPO)
				else
					tipoCAMPO =NULL
				End If
				
		Case  19 :'Inteiro

				if strCAMPO <>"" Then
					tipoCAMPO = int(strCAMPO)
				else
					tipoCAMPO =NULL
				End If				

		Case 202 :'string
		
				if strCAMPO <>"" Then
					tipoCAMPO = "'"&strCAMPO&"'"
				else
					tipoCAMPO =NULL
				End If

		Case 135 :'DataTime
				
				if strCAMPO <>"" Then
					tipoCAMPO = PrepDataIve(strCAMPO, true,true)
				else
					tipoCAMPO =NULL
				End If
				
		Case 16 :'boleano

				if strCAMPO <>"" Then
					tipoCAMPO = strCAMPO
				else
					tipoCAMPO =NULL
				End If

		Case 5 :'DOUBLE
				if strCAMPO <>"" Then
					tipoCAMPO = FormataDouble(strCAMPO)
				else
					tipoCAMPO =NULL
				End If		
		Case 203 :'Text
				if strCAMPO <>"" Then
					tipoCAMPO = "'"&strCAMPO&"'"
				else
					tipoCAMPO =NULL
				End If		
	End Select	
	
End Function		

For i = 0 to objRS.fields.count - 1
  Response.Write(objRS.Fields(i).Name&" - "&objRS.Fields(i).type&"<br>")
  'Response.Write(tipoCAMPO(objRS.Fields(i),objRS.Fields(i).type)&"<br>")
Next

%>