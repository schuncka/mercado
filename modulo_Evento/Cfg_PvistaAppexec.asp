<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<%
VerficaAcesso("ADMIN")

Dim objConn, objRS, objRSDetail
Dim strSQL, strCOD_EVENTO, strBASE, strEXIBE, strMERCADO, strEVENTO,strID_AUTO,strDESCRICAO,strPROGRAMACAO,strIMG1,strIMG2



strID_AUTO = Replace(GetParam("var_chavereg"),"'","''")

strDESCRICAO = Replace(GetParam("DBVAR_STR_DESCRICAO"),"'","''")
strPROGRAMACAO = Replace(GetParam("DBVAR_STR_PROGRAMACAO"),"'","''")
strIMG1 = Replace(GetParam("DBVAR_STR_IMG1"),"'","''")
strIMG2 = Replace(GetParam("DBVAR_STR_IMG2"),"'","''")



strCOD_EVENTO = Replace(GetParam("cod_evento"),"'","''")
strBASE = Replace(GetParam("base"),"'","''")
strEXIBE = Replace(GetParam("RB_EXIBE_APP"),"'","''")
strMERCADO = Replace(GetParam("RB_MERCADO"),"'","''")
strEVENTO = Replace(GetParam("var_evento"),"'","''")
'response.Write(strEXIBE&"< - <BR>")
'response.Write(strBASE&"< - <BR>")
'response.Write(strCOD_EVENTO&"< - <BR>")
'response.Write(strMERCADO&"< - <BR>")
'response.End()

AbreDBConn objConn, CFG_DB_DADOS 


If strMERCADO <> "" and strBASE <> "" and strCOD_EVENTO <> "" Then

	strSQL = " UPDATE TBL_EVENTO SET "
    strSQL = strSQL & "  DESCRICAO   =  '"&strDESCRICAO&"'"
	strSQL = strSQL & " ,PROGRAMACAO = '"&strPROGRAMACAO&"'"
	strSQL = strSQL & " ,IMG1        = '"&strIMG1&"'"
	strSQL = strSQL & " ,IMG2        = '"&strIMG2&"'" 
	strSQL = strSQL & "  WHERE cod_evento = " & strCOD_EVENTO
	
	response.Write(strSQL&"<br><br>")
	objConn.Execute(strSQL)
	

  If strEXIBE ="1" Then
	
	strSQL = " SELECT m.idtbl_mercado, m.mercado "
	strSQL = strSQL & "    FROM METRO_schema.tbl_evento ev  "
	strSQL = strSQL & "    		inner join METRO_schema.tbl_database db on ev.idtbl_database = db.idtbl_database"
	strSQL = strSQL & "    		inner join METRO_schema.tbl_mercado m on ev.idtbl_mercado = m.idtbl_mercado"
	strSQL = strSQL & "  WHERE ev.cod_evento = " & strCOD_EVENTO
	strSQL = strSQL & "  AND db.base = '"&strBASE&"'"
	response.Write(strSQL&"<br><br>")
	Set objRS = objConn.Execute(strSQL)
	
	If not objRS.EOF Then
	
		strSQL = " UPDATE METRO_schema.tbl_evento ev inner join METRO_schema.tbl_database db on ev.idtbl_database = db.idtbl_database"
		strSQL = strSQL & "    inner join METRO_schema.tbl_mercado m on ev.idtbl_mercado = m.idtbl_mercado"
		strSQL = strSQL & " SET ev.idtbl_mercado = " & strMERCADO
		strSQL = strSQL & "  WHERE ev.cod_evento = " & strCOD_EVENTO
		strSQL = strSQL & "  AND db.base = '"&strBASE&"'"
		response.Write(strSQL&"<br><br>")
		objConn.Execute strSQL
	
	Else
	
	    
		
		strSQL = "SELECT idtbl_database, BASE, CLIENTE FROM METRO_schema.tbl_database WHERE BASE = '"&strBASE&"'"
		response.Write(strSQL&"<br><br>")
		Set objRS = objConn.Execute(strSQL)
		
		If not objRS.EOF Then
			strSQL = "INSERT INTO METRO_schema.TBL_EVENTO 	(cod_evento,idtbl_mercado, idtbl_database) values ("&strCOD_EVENTO&", "&strMERCADO&","&getValue(objRS,"idtbl_database")&") "
			response.Write(strSQL&"<br><br>")
			objConn.Execute(strSQL)
		ELSE
			strSQL = "INSERT INTO METRO_schema.tbl_database (BASE,CLIENTE) VALUES ('"&strBASE&"','"&SESSION("METRO_INFO_CFG_IDCLIENTE")&"')" 
			response.Write(strSQL&"<br><br>")
			objConn.Execute(strSQL)	
			
			strSQL = "SELECT idtbl_database, BASE, CLIENTE FROM METRO_schema.tbl_database WHERE BASE = '"&strBASE&"'"
			response.Write(strSQL&"<br><br>")
			Set objRS = objConn.Execute(strSQL)
			
			strSQL = "INSERT INTO METRO_schema.TBL_EVENTO 	(cod_evento,idtbl_mercado, idtbl_database) values ("&strCOD_EVENTO&", "&strMERCADO&","&getValue(objRS,"idtbl_database")&") "
			response.Write(strSQL&"<br><br>")
			objConn.Execute(strSQL)
		
		End If
				
	
	End If
	FechaRecordSet objRS

  Else

	  If strEVENTO <> "" Then
	
		strSQL = " DELETE FROM METRO_schema.tbl_evento "
		strSQL = strSQL & "  WHERE idtbl_evento = " & strEVENTO
		'response.Write(strSQL&"<br><br>")
		'response.End()
		objConn.Execute strSQL
		
	  End If
		
  End If
End If
	
  FechaDBConn objConn
  Response.Redirect("Cfg_PvistaApp.asp?var_chavereg="&Request("var_chavereg"))
%>