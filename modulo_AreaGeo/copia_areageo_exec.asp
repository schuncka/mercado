<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 

<%
Dim strCODIGO, strDESCRICAO, strSQL, objRS,  strEVENTO, objConn

AbreDBConn objConn, CFG_DB_DADOS 

strDESCRICAO = Replace(Request("var_Areageo"),"'","''")
strEVENTO    = Session("COD_EVENTO")
  
If  strDESCRICAO = "" Then
	Response.Write("<script>alert('Você deve preencher o campo Area.'); history.back();</script>")
	Response.End()
End If	

strSQL="INSERT INTO TBL_AREAGEO (NOME_AREAGEO, Cod_Evento) VALUES('"&strDESCRICAO&"',"&strEVENTO&")"
objConn.Execute(strSQL)

strSQL = "SELECT MAX(id_AreaGeo) AS Id_AreaGeo FROM tbl_Areageo ORDER BY id_AreaGeo DESC "
Set objRS = objConn.Execute(strSQL)

strCODIGO = objRS("Id_AreaGeo")	

Response.Redirect("update.asp?var_chavereg="&strCODIGO&"&var_acao=INS")
%>