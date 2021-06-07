<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"-->
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="aspJSON1.17.asp"-->
<%
Response.AddHeader "Expires", "Mon, 26 Jul 1997 05:00:00 GMT"
Response.AddHeader "Last-Modified", Now & " GMT"	
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
Response.AddHeader "Pragma", "no-cache"

Dim objConn, objRS, strSQL
Dim stridProd,strJson

AbreDBConn objConn, CFG_DB_DADOS

stridProd = GetParam("codigo")

strSQL = 		  " select idsubprod, subproduto from tbl_produtos_2 where idempresa = 'MM' AND  idprod = " & stridProd & " order by 2"
Set objRS = objConn.execute(strSQL)

 do while NOT objRS.EOF
	'Response.Write(GetValue(objRS,"idsubprod"))
	strJson = strJson &  GetValue(objRS,"idsubprod") &":"& GetValue(objRS,"subproduto")
	'strJson = strJson &  GetValue(objRS,"subproduto") &":"& GetValue(objRS,"idsubprod")
	objRS.movenext
	if Not objRS.EOF Then
	strJson = strJson & "|"
	end if
loop

Response.Write strJson  
FechaRecordSet objRS
FechaDBConn objConn
%>