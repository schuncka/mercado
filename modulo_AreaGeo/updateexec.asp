<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<%
 Dim strCODIGO, strDESCRICAO, strSQL, objRS, strCEP_INI, strCEP_FIM, strPAIS, strEVENTO, objConn, strACAO, strID_AREAGEO, strID_AREAGEO_CEP

 AbreDBConn objConn, CFG_DB_DADOS 
 strID_AREAGEO = Request("var_id_areageo")
 strID_AREAGEO_CEP = Request("var_id_areageo_cep")
 strDESCRICAO = Replace(Request("var_Areageo"),"'","''")
 strCEP_INI   = Replace(Request("var_Cep_Inicial"),"'","''")
 strCEP_FIM   = Replace(Request("var_Cep_Final"),"'","''")
 strPAIS  	  = Request("var_pais")
 strACAO	  = Request("var_acao")
 strEVENTO    = Session("COD_EVENTO")
'Response.Write(strCODIGO& " - " & strDESCRICAO & " - "& strCEP_INI &" - " & strCEP_FIM & " - " & strPAIS )
'Response.End()
 

' ========================================================================
' Altera o cadastro da areageo
' ========================================================================
Sub AlteraAreaGeo()

		strSQL="UPDATE tbl_Areageo SET Nome_AreaGeo = '"&strDESCRICAO&"' WHERE ID_Areageo ="&strID_AREAGEO
		'response.Write(strSQL)
		'Response.End()	   		
	    objConn.Execute(strSQL)
End Sub

' ========================================================================
' Altera o cadastro da areageo CEP
' ========================================================================
Sub AlteraAreaGeoCEP()

	If  strCEP_INI = "" Then
		Response.Write("<script>alert('Você deve preencher o campo CEP Inicial.'); history.back();</script>")
		Response.End()
	End If	
	If  strCEP_FIM = "" Then
		Response.Write("<script>alert('Você deve preencher o campo CEP Final.'); history.back();</script>")
		Response.End()
	End If
	
	If  strPAIS = "" Then
		Response.Write("<script>alert('Você deve preencher o campo PAÍS.'); history.back();</script>")
		Response.End()
	End If

		strSQL="UPDATE tbl_Areageo_Cep SET "&_
			   " Cep_Ini ="&strCEP_INI&", "&_
			   " Cep_Fim ="&strCEP_FIM&", "&_
			   " ID_Pais ='"&strPAIS&"'"&_
			   " WHERE ID_Areageo_Cep ="&strID_AREAGEO_CEP

		'response.Write(strSQL)
		'Response.End()	   		
	    objConn.Execute(strSQL)
End Sub

' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro()
		
	If  strCEP_INI = "" Then
		Response.Write("<script>alert('Você deve preencher o campo CEP Inicial.'); history.back();</script>")
		Response.End()
	End If	
	If  strCEP_FIM = "" Then
		Response.Write("<script>alert('Você deve preencher o campo CEP Final.'); history.back();</script>")
		Response.End()
	End If
	
	If  strPAIS = "" Then
		Response.Write("<script>alert('Você deve preencher o campo PAÍS.'); history.back();</script>")
		Response.End()
	End If

		strSQL="INSERT INTO tbl_Areageo_Cep (id_AreaGeo, Cep_Ini, Cep_Fim, ID_Pais) VALUES("&_
			   strID_AREAGEO&", "&_
			   strCEP_INI&", "&_
			   strCEP_FIM&", "&_
			   "'"&strPAIS&"')"
		'response.Write(strSQL)
		'Response.End()	   		
	    objConn.Execute(strSQL)


End Sub




If strACAO ="GEO" Then
	AlteraAreaGeo()
ElseIf strACAO="INS" Then
	GravaCadastro()
Else
	strSQL="SELECT Id_areageo_cep FROM tbl_Areageo_Cep WHERE Id_areageo ="&strID_AREAGEO
	Set objRS = objConn.Execute(strSQL)
	If NOT objRS.EOF Then
		AlteraAreaGeoCep()
	Else
		GravaCadastro()
	End If 
End If		

Response.Redirect("update.asp?var_chavereg="&strID_AREAGEO)

%>