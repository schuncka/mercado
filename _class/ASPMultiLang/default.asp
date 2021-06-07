<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="ASPMultiLang.asp" -->
<%
Dim objMultiLang

Set objMultiLang = New ASPMultiLang

objMultiLang.loadLang "", "./lang/" 

Response.Write("<h4>&bull; Teste de uso da classe ASPMultilang com o indice 'teste'</h4>")

Response.Write("Indice sem formatação: <strong>" & objMultiLang.searchIndex("teste",0) & "</strong><br>")
Response.Write("Indice maiúsculo: <strong>" & objMultiLang.searchIndex("teste",1) & "</strong><br>")
Response.Write("Indice minúsculo: <strong>" & objMultiLang.searchIndex("teste",2) & "</strong><br>")
Response.Write("Indice capitalizado: <strong>" & objMultiLang.searchIndex("teste",3) & "</strong><br>")
Response.Write("Indice não encontrado: <strong>" & objMultiLang.searchIndex("test",0) & "</strong><br><br><br><br>")

Response.Write("Sessão LCID: " & Session.LCID)
Response.Write("<p>" & objMultiLang.searchIndex("tipos_data",3))
Response.Write("<p>" & objMultiLang.searchIndex("data",3) & " = " & Date())
Response.Write("<br>" & objMultiLang.searchIndex("dia",3) & " = " & Day(Date()))
Response.Write("<br>" & objMultiLang.searchIndex("mes",3) & " = " & Month(Date()))
Response.Write("<br>" & objMultiLang.searchIndex("ano",3) & " = " & Year(Date()))
Response.Write("<br>" & objMultiLang.searchIndex("hora",3) & " = " & Time())
Response.Write("<br>" & objMultiLang.searchIndex("datahora",3) & " = " & Now())

Response.Write("<p>" & objMultiLang.searchIndex("tipos_numericos",3))
Response.Write("<p>" & FormatCurrency(1.05, 2))
Response.Write("<br>" & FormatNumber(1000000,2))
Response.Write("<br>" & FormatNumber(-1000000,2))

Set objMultiLang = Nothing
%>