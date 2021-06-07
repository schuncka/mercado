<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% 
 ' Intruduce the url you want to visit 
 GotothisURL = "http://quimera/meuvinho/default.asp"  
 ' Create the xml object 
 Set GetConnection = CreateObject("Microsoft.XMLHTTP") 
 ' Conect to specified URL 
 GetConnection.Open "get", GotothisURL, False 
 GetConnection.Send  

 ' ResponsePage is the response we will get when visiting GotothisURL 
 ResponsePage = GetConnection.responseText 

' We will write  
 If instr(ResponsePage,"meuvinhosfdsf") Then
   Response.Write("Achei") 
 Else
   Response.Write("Deu pau")
 End If

 Set GetConnection = Nothing 
 %>

