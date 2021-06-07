<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"-->
<!--#include file="../_database/athUtils.asp"-->

<%
Response.AddHeader "Expires", "Mon, 26 Jul 1997 05:00:00 GMT"
Response.AddHeader "Last-Modified", Now & " GMT"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
Response.AddHeader "Pragma", "no-cache"

Dim objConn, objRS, strSQL
Dim strCodigoCliente

AbreDBConn objConn, CFG_DB_DADOS

strCodigoCliente = ValidateValueSQL(GetParam("codigo"),"STR",false)

strSQL = 		  " select Endereco, Cidade, Estado, CodigoPostal, CGCCPF, IERG, bairro, nomedocliente as RAZAO_SOCIAL, bco, ag, cta,nrobanco from tbl_clientes where codigodocliente = "&strCodigoCliente
'response.write(strSQL)
Set objRS = objConn.execute(strSQL)

If Not objRS.EOF Then
	Response.Write(GetValue(objRS,"Endereco") & "|")
	Response.Write(GetValue(objRS,"Bairro") & "|")
	Response.Write(GetValue(objRS,"Cidade") & "|")
	Response.Write(GetValue(objRS,"Estado") & "|")
	Response.Write(GetValue(objRS,"CodigoPostal") & "|")
	Response.Write(GetValue(objRS,"CGCCPF") & "|")
	Response.Write(GetValue(objRS,"IERG") & "|")
	Response.Write(GetValue(objRS,"RAZAO_SOCIAL")& "|")
	Response.Write(GetValue(objRS,"bco") & "|")
	Response.Write(GetValue(objRS,"ag") & "|")
	Response.Write(GetValue(objRS,"cta") & "|" )
	Response.Write(GetValue(objRS,"nrobanco")  )
	 
End If

FechaRecordSet objRS
FechaDBConn objConn
%>