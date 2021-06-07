<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../ajax/aspJSON1.17.asp"--> 

<%
Dim objConn, objRS, objConnDetail, objRSDetail, strSQL 

Dim strCEP, strBD_CEP_SOURCE, strENDER, strBAIRRO, strCIDADE, strESTADO, i
dim sStatus, strTEXTO, cUrl, objSvrHTTP,oJSON

strCEP = Request("var_cep") 
strBD_CEP_SOURCE = Request("var_bd_cep")

if strBD_CEP_SOURCE = "" Then
	strBD_CEP_SOURCE = "MYSQL"
end if

'Response.Write(strCEP & "<BR>")
If strCEP <> "" Then
 
 strCEP = Right("00000000"&strCEP,8)
 
 Select Case UCase(strBD_CEP_SOURCE)
   Case "RV"
     'Response.Write("RV" & "<BR>")
     Dim resultado
	 resultado = busca_cep( strCEP )  
	 
	 'Debug
	 'For i = 0 To UBound(resultado)
	 '  Response.Write(i & ": " & resultado(i) & "<BR>")
	 'Next
	   
	 select case resultado( 2 )  
	       
	     case "2"   
			strENDER   = ""
			strBAIRRO  = ""
			strCIDADE  = resultado( 8 )
			strESTADO  = resultado( 6 )       
	     case "1"   
			strENDER   = resultado( 12 ) & " " & resultado( 14 )
			strBAIRRO  = resultado( 10 )
			strCIDADE  = resultado( 8 )
			strESTADO  = resultado( 6 )       
	     case else    
	 end select  
	 
   Case "MYSQL_BD_REPUBLICA_VIRTUAL"
     'Response.Write("MYSQL" & "<BR>")
     AbreDBConn objConnDetail, "BD_CEP"
	 
	 strCEP = Left(strCEP,5)&"-"&Right(strCEP,3)
	 
     strSQL = "SELECT UF FROM bd_cep.cep_log_index WHERE cep5 = '" & Left(strCEP,5) & "'" 
	 'Response.Write(strSQL&"<BR>")
	 Set objRS = objConnDetail.Execute(strSQL)
	 If not objRS.EOF Then
	    strSQL = "SELECT tp_logradouro, logradouro, BAIRRO, CIDADE FROM bd_cep." & objRS("UF") & " WHERE CEP = '" & strCEP & "'"
		'Response.Write(strSQL&"<BR>")
		Set objRSDetail = objConnDetail.Execute(strSQL)
		If not objRSDetail.EOF Then
		  strENDER   = objRSDetail("tp_logradouro") & " " & objRSDetail("logradouro")
		  strBAIRRO  = objRSDetail("BAIRRO")
		  strCIDADE  = objRSDetail("CIDADE")
		  strESTADO  = objRS("UF")
		End If
		FechaRecordSet objRSDetail 
	 End If
     FechaRecordSet objRS

	 If strCIDADE&"" = "" Then
		strSQL = "SELECT nome, uf FROM bd_cep.cep_unico WHERE CEP = '" & strCEP & "'"
		'Response.Write(strSQL&"<BR>")
		Set objRSDetail = objConnDetail.Execute(strSQL)
		If not objRSDetail.EOF Then
		  strENDER   = ""
		  strBAIRRO  = ""
		  strCIDADE  = objRSDetail("nome")
		  strESTADO  = objRSDetail("UF")
		End If
		FechaRecordSet objRSDetail 
	 End If
			 
	 FechaDBConn objConnDetail


   Case "MYSQL"
     'Response.Write("MYSQL" & "<BR>")
     AbreDBConn objConnDetail, "BDCEP"
	 
     strSQL =          " SELECT l.endereco, l.logradouro, b.bairro, c.cidade, c.uf, e.estado"
	 strSQL = strSQL & "   FROM bdcep.cepbr_endereco l left join bdcep.cepbr_bairro b on l.id_bairro = b.id_bairro"
	 strSQL = strSQL & "                         left join bdcep.cepbr_cidade c on l.id_cidade = c.id_cidade"
	 strSQL = strSQL & "                         left join bdcep.cepbr_estado e on c.uf = e.uf"
	 strSQL = strSQL & "  WHERE l.cep = '" & strCEP & "'" 
	 
	 
	 'Response.Write(strSQL&"<BR>")
	 Set objRS = objConnDetail.Execute(strSQL)
	 If not objRS.EOF Then
		  strENDER   = ucase(objRS("LOGRADOURO")&"")
		  strBAIRRO  = ucase(objRS("BAIRRO")&"")
		  strCIDADE  = ucase(objRS("CIDADE")&"")
		  strESTADO  = ucase(objRS("UF")&"")
	 End If
     FechaRecordSet objRS

	CASE "VIA_CEP"

	cUrl = "https://viacep.com.br/ws/" & strCEP & "/json/"
	'cUrl = "http://apps.widenet.com.br/busca-cep/api/cep.json?code="&strCEP
	'response.write(cUrl)
  	Set objSvrHTTP = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
	Set oJSON = New aspJSON
	objSvrHTTP.SetTimeouts 15000, 250000, 250000, 250000
	objSvrHTTP.open "GET", cUrl, false
	objSvrHTTP.setRequestHeader "Content-Type", "application/json"
	objSvrHTTP.setRequestHeader "Accept", "application/json"
	
	
	objSvrHTTP.send
	sStatus = objSvrHTTP.status
	strTEXTO = objSvrHTTP.responseText
	
	Set objSvrHTTP = Nothing
	
	'Response.Write strTEXTO
	'Response.End

	'Response.Write("<br>Status: " & sStatus&"<BR>")
	
	oJSON.loadJSON(vbnewline&strTEXTO&vbnewline)
	if sStatus = 200 Then
		oJSON.loadJSON(strTEXTO)
			'strReturn = ojSON.data("CEP")    							'0
			strENDER  = ojSON.data("logradouro") 	'1			
			strBAIRRO =  ojSON.data("bairro")			'3
			strCIDADE =  ojSON.data("localidade")		'4
			strESTADO = ojSON.data("uf")

	end if		 	 
   Case Else
      'Response.Write("MDB" & "<BR>")
				AbreDBConn objConn, "DSN=BD_CEP"
			
	  strSQL = " SELECT LOGRAD, LOCALID, BAIRRO, TIPO, UF"
	  strSQL = strSQL & " FROM CEP"
	  strSQL = strSQL & " WHERE CEP = '" & strCEP & "'"
	  Set objRS = objConn.Execute(strSQL)
	  If not objRS.EOF Then
		strENDER   = objRS("TIPO") & " " & objRS("LOGRAD")
		strBAIRRO  = objRS("BAIRRO")
		strCIDADE  = objRS("LOCALID")
		strESTADO  = objRS("UF")
	  End If
	  FechaRecordSet objRS
	  
	  FechaDBConn objConn
	  
  End Select



'                   0                 1                2                 3					4
  response.write(strENDER & "|" & strBAIRRO & "|" & strCIDADE & "|" & strESTADO & "|" & "BRASIL")
End If
%>