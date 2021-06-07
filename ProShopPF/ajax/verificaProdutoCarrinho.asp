<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../../_database/adovbs.inc"-->
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/athDbConn.asp"--> 
<!--#include file="../../_database/athUtils.asp"-->
<!--#include file="../../_database/athSendMail.asp"--> 
<%
Dim strCOD_EVENTO, strCodigoPromo
Dim objConn, objRS, strSQL
Dim strCodProd, strQuantidade,strCategoria, strSessionId

strCodProd     = Request("var_codigo_prod")
strQuantidade  = Request("var_quantidade")
strCategoria   = Request("var_categoria")
strCOD_EVENTO  = Request("cod_evento")

strSessionId   = session.SessionID()

If strCOD_EVENTO = "" Then
  strCOD_EVENTO = Session("COD_EVENTO")
End If

'response.write("strCodEvento = "& strCOD_EVENTO)
'response.Write("<br>CodigoPromo = " & strCodigoPromo)



	
	
    AbreDBConn objConn, CFG_DB_DADOS
	
	  
		strSQL = "				SELECT count(*) as qtde "
		strSQL = strSQL & "     FROM tbl_inscricao_produto_session "
		strSQL = strSQL & "     WHERE id_session = '" & request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId") & "'"
'        response.write(strSQL)
	  
	  Set objRS = objConn.Execute(strSQL) 
  	  	If not objRS.EOF  Then
			if getValue(objRS,"qtde") <> "0" then
				response.write("true")
			else
				response.write("false")
			end if			
	 	Else
			response.write("false")
	 	End If

 
	
	FechaDBConn objConn	  

%>