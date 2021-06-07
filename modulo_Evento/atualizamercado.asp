<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<%
VerficaAcesso("ADMIN")

Dim objConn, objRS, objRSDetail
Dim strSQL, strCOD_EVENTO, strBASE, strEXIBE, strMERCADO, strEVENTO

strCOD_EVENTO = Replace(Request("cod_evento"),"'","''")
strBASE = Replace(Request("base"),"'","''")
strEXIBE = Replace(Request("var_exibe"),"'","''")
strMERCADO = Replace(Request("var_mercado"),"'","''")
strEVENTO = Replace(Request("var_evento"),"'","''")
'response.Write(strEXIBE&"< - <BR>")
'response.Write(strBASE&"< - <BR>")
'response.Write(strCOD_EVENTO&"< - <BR>")
'response.Write(strMERCADO&"< - <BR>")
'response.End()

AbreDBConn objConn, CFG_DB_DADOS 


If strMERCADO <> "" and strBASE <> "" and strCOD_EVENTO <> "" Then

  If cstr(strEXIBE) = "true" Then
	
	strSQL = " SELECT m.idtbl_mercado, m.mercado FROM METRO_schema.tbl_evento ev inner join METRO_schema.tbl_database db on ev.idtbl_database = db.idtbl_database"
	strSQL = strSQL & "    inner join METRO_schema.tbl_mercado m on ev.idtbl_mercado = m.idtbl_mercado"
	strSQL = strSQL & "  WHERE ev.cod_evento = " & strCOD_EVENTO
	strSQL = strSQL & "  AND db.base = '"&strBASE&"'"
	Set objRS = objConn.Execute(strSQL)
	If not objRS.EOF Then
	
		strSQL = " UPDATE METRO_schema.tbl_evento ev inner join METRO_schema.tbl_database db on ev.idtbl_database = db.idtbl_database"
		strSQL = strSQL & "    inner join METRO_schema.tbl_mercado m on ev.idtbl_mercado = m.idtbl_mercado"
		strSQL = strSQL & " SET ev.idtbl_mercado = " & strMERCADO
		strSQL = strSQL & "  WHERE ev.cod_evento = " & strCOD_EVENTO
		strSQL = strSQL & "  AND db.base = '"&strBASE&"'"
		objConn.Execute strSQL
	
	Else
	
	    strSQL = "INSERT INTO METRO_schema.TBL_EVENTO (COD_EVENTO, IDTBL_MERCADO, IDTBL_DATABASE) "
		strSQL = strSQL & " SELECT "&strCOD_EVENTO&","&strMERCADO&",IDTBL_DATABASE FROM METRO_schema.tbl_database where base = '"&strBASE&"'"
		'response.Write(strSQL)
		objConn.Execute(strSQL)
	
	
	
	End If
	FechaRecordSet objRS

  Else

	  If strEVENTO <> "" Then
	
		strSQL = " DELETE FROM METRO_schema.tbl_evento "
		strSQL = strSQL & "  WHERE idtbl_evento = " & strEVENTO
		'response.Write(strSQL)
		'response.End()
		objConn.Execute strSQL
		
	  End If
		
  End If
End If
	
  FechaDBConn objConn
  Response.Redirect("update.asp?var_chavereg="&Request("var_chavereg"))
%>