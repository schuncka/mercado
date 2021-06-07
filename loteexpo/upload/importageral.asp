<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/athDbConn.asp"--> 
<!--#include file="../../_database/athUtils.asp"--> 
<html>
<head>
</head>
<body>
<div>
<b>INFORMAÇÃO:</b><br><br>Formato dos arquivos "999999_nomedoarquivo_coletor[#grupo].txt" onde:<br>
<ul>
  <li>999999 é o código do cliente no pvista/dw (obrigatorio)</li>
  <li>#grupo separação de dados por cliente (opcional)</li>
</ul>
Os arquivos de upload devem ser enviados para a pasta /loteexpo/upload/
<hr>
</div>
<%
Server.ScriptTimeout = 2400
Response.Buffer = True

Function analisaArquivo(prARQUIVO)

Dim strARQUIVO, strDT_REGISTRO, strINTERVALO, strLOCAL, strCODLOCAL, strCODBAR, strCOD_EMPRESA, strDT_INSERT, strHR_INSERT, acINTERV
Dim strSTREAM
Dim objFile, objFSO, objCDO
Dim objTextStream, strAux, arrLinha, i, strPRIMEIRA_LINHA

Dim strLAYOUT, strOFFSET
Dim arrDATA, arrHORA, strAM_PM

strARQUIVO = prARQUIVO

If strARQUIVO <> "" Then 
 Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
 Set objTextStream = objFSO.OpenTextFile(Server.MapPath(".") & "\" & strARQUIVO)
 
 i = 0
 acINTERV = 0
 strPRIMEIRA_LINHA = ""
 Do While not objTextStream.AtEndOfStream 
   strAux   = objTextStream.ReadLine & "" 'linhas esperadas: 1 ;69742014 ;16/04/07; 10:15:57  OU *  
   If Left(strAux,1) <> "*" And ( InStr(strAux,";")>0 Or InStr(strAux,",")>0 ) and strPRIMEIRA_LINHA = "" Then
	  strPRIMEIRA_LINHA = strAux
   End If
   strSTREAM = strSTREAM & strAux & "<BR>"
   i = i + 1
 Loop
 objTextStream.Close
 
 strCODBAR      = ""
 strCOD_EMPRESA = ""
 strHR_INSERT   = ""
 strDT_INSERT   = ""
 
 If inStr(strPRIMEIRA_LINHA,",") > 0 Then
   arrLinha = split(strAux&",",",")
   
			'MOTOROLA
			If UBound(arrLinha) > 0 Then 
			  strDT_INSERT = Trim(arrLinha(0)) 'Formato MM/DD/AAAA
			  
			  arrDATA = split(strDT_INSERT&"/","/")
			  If Ubound(arrDATA) > 2 Then
				strDT_INSERT = arrDATA(1)&"/"&arrDATA(0)&"/"&arrDATA(2)
			  Else
				strDT_INSERT = Mid(strDT_INSERT,4,2) & "/" & Mid(strDT_INSERT,1,2) & "/" & Mid(strDT_INSERT,7,4)
			  End If
			End If

			If UBound(arrLinha) > 1 Then 
			  strHR_INSERT = Trim(arrLinha(1))
			  strHR_INSERT = Replace(strHR_INSERT," ","")
			  If InStr(Ucase(strHR_INSERT),"AM") Then
			    strAM_PM = "AM"
			  ElseIf InStr(Ucase(strHR_INSERT),"PM") Then
			    strAM_PM = "PM"
			  End If
			  arrHORA = split(strDT_INSERT&":",":")
			  If Ubound(arrHORA) > 2 Then
				strHR_INSERT = arrHORA(0)&":"&arrHORA(1)&":"&arrHORA(2)
			  End If
			  
			End If
			
			If UBound(arrLinha) > 3 Then
			  strCODBAR = Trim(Left(arrLinha(3),9))
			  strCOD_EMPRESA = Left(strCODBAR,6)
			End If
			
			If IsDate(strDT_INSERT) and Len(strCODBAR) > 6 Then
			  strLAYOUT = "MOTOROLA"
			End If
			
			
			'OPN PADRAO
			If UBound(arrLinha) > 0 Then
			  strCODBAR = Trim(Left(arrLinha(0),9))
			  strCOD_EMPRESA = Left(strCODBAR,6)
			End If
			
			If UBound(arrLinha) > 2 Then 
			  strHR_INSERT = Trim(arrLinha(2))
			  strHR_INSERT = Replace(strHR_INSERT," ","")
			  If InStr(Ucase(strHR_INSERT),"AM") Then
			    strAM_PM = "AM"
			  ElseIf InStr(Ucase(strHR_INSERT),"PM") Then
			    strAM_PM = "PM"
			  End If
			  arrHORA = split(strDT_INSERT&":",":")
			  If Ubound(arrHORA) > 2 Then
				strHR_INSERT = arrHORA(0)&":"&arrHORA(1)&":"&arrHORA(2)
			  End If

			End If
			
			If UBound(arrLinha) > 3 Then 
			  strDT_INSERT = Trim(arrLinha(3)) 'Formato MM/DD/AAAA
			  arrDATA = split(strDT_INSERT&"/","/")
			  If Ubound(arrDATA) > 2 Then
				strDT_INSERT = arrDATA(1)&"/"&arrDATA(0)&"/"&arrDATA(2)
			  Else
				strDT_INSERT = Mid(strDT_INSERT,4,2) & "/" & Mid(strDT_INSERT,1,2) & "/" & Mid(strDT_INSERT,7,4)
			  End If
			End If

			If IsDate(strDT_INSERT) and Len(strCODBAR) > 6 Then
			  If strAM_PM <> "" Then
			    strLAYOUT = "OPN_FABRICA"
			  Else
			    strLAYOUT = "OPN_FABRICA_24H"
			  End If
			End If
			
 End If
 
 If inStr(strPRIMEIRA_LINHA,";") > 0 Then
   arrLinha = split(strAux&";",";")
   
			'PROEVENTO
			If UBound(arrLinha) > 1 Then
			  strCODBAR = Left(arrLinha(1),9)
			  strCOD_EMPRESA = Left(strCODBAR,6)
			End If
			
			If UBound(arrLinha) > 2 Then
			  strDT_INSERT = arrLinha(2)
			  'Response.Write(strDT_INSERT&"<BR>")
			  arrDATA = split(strDT_INSERT&"/","/")
			  If Ubound(arrDATA) > 2 Then
				strDT_INSERT = arrDATA(0)&"/"&arrDATA(1)&"/"&arrDATA(2)
			  Else
				strDT_INSERT = Mid(strDT_INSERT,1,2) & "/" & Mid(strDT_INSERT,3,2) & "/" & Mid(strDT_INSERT,5,4)
			  End If

			End If

			If UBound(arrLinha) > 3 Then ' se tiver a hora adiciona no final
			  strHR_INSERT = arrLinha(3)
			  strHR_INSERT = Replace(strHR_INSERT," ","")
			  If InStr(Ucase(strHR_INSERT),"AM") Then
			    strAM_PM = "AM"
			  ElseIf InStr(Ucase(strHR_INSERT),"PM") Then
			    strAM_PM = "PM"
			  End If
			  arrHORA = split(strDT_INSERT&":",":")
			  If Ubound(arrHORA) > 2 Then
				strHR_INSERT = arrHORA(0)&":"&arrHORA(1)&":"&arrHORA(2)
			  End If

			End If

			If IsDate(strDT_INSERT) and Len(strCODBAR) > 6 Then
			  strLAYOUT = "sysMetro"
			End If

 End If


 If inStr(strPRIMEIRA_LINHA,"+") > 0 Then
			
			strOFFSET = Abs(Len(strAux) - 29) 'teste para checar se a DATA esta no formato DDMMYY (29 digitos) ou DDMMYYYY (31 digitos)
			
			'CATRACA
			  strHR_INSERT   = Mid(strAux,6,4) ' HHMM
			  strHR_INSERT   = Mid(strHR_INSERT,1,2) & ":" &  Mid(strHR_INSERT,3,2)
			  
			  strDT_INSERT   = Mid(strAux,10,6+strOFFSET) 'DDMMYY(YY)
			  strDT_INSERT = Mid(strDT_INSERT,1,2) & "/" & Mid(strDT_INSERT,3,2) & "/" & Mid(strDT_INSERT,5,2+strOFFSET)
			  
			  strDT_INSERT = strDT_INSERT & " " & strHR_INSERT
			  
			  strCODBAR      = Right(strAux,9)
			  strCOD_EMPRESA = Left(strCODBAR,6)

			If IsDate(strDT_INSERT) and Len(strCODBAR) > 6 Then
			  strLAYOUT = "CATRACA"
			End If

 End If

 set objTextStream = Nothing
 set objFSO = Nothing
 
 analisaArquivo = strLAYOUT
 
End If

End Function


Dim objConn, objRS, strSQL
Dim strCOD_EVENTO, strARQUIVO, strDT_REGISTRO, strINTERVALO, strLOCAL, strCODLOCAL, strCODBAR, strDT_INSERT, strHR_INSERT, acINTERV
Dim strCOD_EMPRESA, strCOD_EMPRESA_EXPOSITOR, strGRUPO

Dim strLAYOUT, strOFFSET
Dim arrDATA, arrHORA, strAM_PM

AbreDBConn objConn, CFG_DB_DADOS 

strCOD_EVENTO  = GetParam("COD_EVENTO")
strCOD_EMPRESA_EXPOSITOR = GetParam("COD_EMPRESA")
strARQUIVO     = GetParam("ARQUIVO")
strLOCAL       = GetParam("LOCAL")
strDT_REGISTRO = GetParam("DT_REGISTRO")
strINTERVALO   = GetParam("INTERVALO")

strLAYOUT      = GetParam("var_LAYOUT")

If strCOD_EVENTO = "" Then
%>
  <div>
              <table width="450" border="0" cellpadding="0" cellspacing="0" class="texto_corpo_mdo">
              <form name="formimporta" action="importageral.asp" method="post">
               <tr> 
                <td width="100" align="right">Evento:&nbsp;</td>
                <td width="350">
                   <select name="COD_EVENTO" class="textbox180">
                      <%
                        MontaCombo "SELECT COD_EVENTO, NOME AS NOME_EVENTO FROM tbl_EVENTO WHERE COD_EVENTO = " & Session("COD_EVENTO"), "COD_EVENTO", "NOME_EVENTO", ""
                   	  %>
                   </select></td>
               </tr>
               <!--
               <tr>
                <td align="right">Layout arquivo:</td>
                <td>
                <select name="var_LAYOUT" class="textbox180">
                  <option <% If request("var_LAYOUT") = "sysMetro" Then Response.Write("checked") End If %> value="sysMetro">PROEVENTO</option>
                  <option <% If request("var_LAYOUT") = "OPN_FABRICA" Then Response.Write("checked") End If %> value="OPN_FABRICA">OPN FABRICA</option>
                  <option <% If request("var_LAYOUT") = "MOTOROLA" Then Response.Write("checked") End If %> value="MOTOROLA">MOTOROLA</option>
                </select>
                </td>
              </tr>
              //-->
               <tr>
                 <td align="right">&nbsp;</td>
                 <td>&nbsp;</td>
               </tr>
               <tr>
                 <td align="right">&nbsp;</td>
                 <td><input type="submit" name="btSend" value="importar em lote"></td>
               </tr>
               </form>
             </table>
  </div>
<%
  Response.End()
End If

 'INIC: Efetua Importação -----------------------------------------------------------
Sub ImportaArquivo(prARQUIVO)

 Dim objFile, objFSO, objCDO
 Dim objTextStream, strAux, arrLinha, i, strCOD_EMPRESA_EXPOSITOR, strGRUPO

 if prARQUIVO="" then
   response.write "Indique o nome do arquivo"
   response.end
 end if
 
 Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
 Set objTextStream = objFSO.OpenTextFile(Server.MapPath(".") & "\" & prARQUIVO)
 
 strCOD_EMPRESA_EXPOSITOR = Left(prARQUIVO,6)
 strGRUPO = ""
 If inStr(prARQUIVO,"#") Then
   strGRUPO = Mid(prARQUIVO,inStr(prARQUIVO,"#")+1,len(prARQUIVO)-inStr(prARQUIVO,"#"))
   If inStr(prARQUIVO,"_") Then
     strGRUPO = Left(strGRUPO,inStr(prARQUIVO,"_")-1)
   End If
   If inStr(prARQUIVO,".") Then
     strGRUPO = Left(strGRUPO,inStr(prARQUIVO,".")-1)
   End If
   strGRUPO = Left(strGRUPO,20)
 End If
 
 i = 0
 acINTERV = 0
 Do While not objTextStream.AtEndOfStream
  strAux   = objTextStream.ReadLine & "" 'linhas esperadas: 1 ;69742014 ;16/04/07; 10:15:57  OU *  
  If Left(strAux,1) <> "*" And ( InStr(strAux,";")>0 Or InStr(strAux,",")>0 ) Then

		strCODBAR      = ""
		strCOD_EMPRESA = ""
		strHR_INSERT   = ""
		strDT_INSERT   = ""
		
		Select Case strLAYOUT
		
		  Case "MOTOROLA"
			'strAux   = Replace(strAux," ","")
			arrLinha = split(strAux&",",",")
			'Response.Write(strAux & "<br>")
		  
			If UBound(arrLinha) > 3 Then
			  strCODBAR = Trim(Left(arrLinha(3),9))
			  strCOD_EMPRESA = Left(strCODBAR,6)
			End If
			
			If UBound(arrLinha) > 1 Then 
			  strHR_INSERT = Trim(arrLinha(1))

			  strHR_INSERT = Replace(strHR_INSERT," ","")
			  If InStr(Ucase(strHR_INSERT),"AM") Then
			    strAM_PM = "AM"
			  ElseIf InStr(Ucase(strHR_INSERT),"PM") Then
			    strAM_PM = "PM"
			  End If
			  arrHORA = split(strHR_INSERT&":",":")
			  If Ubound(arrHORA) > 2 Then
				strHR_INSERT = arrHORA(0)
				If strAM_PM <> "" and cint(strHR_INSERT) = 0 Then
				  strHR_INSERT = "12"
				End If
				strHR_INSERT = strHR_INSERT&":"&arrHORA(1)&":"&arrHORA(2)
			  End If

			End If
			
			If UBound(arrLinha) > 0 Then 
			  strDT_INSERT = Trim(arrLinha(0)) 'Formato MM/DD/AAAA
			  
			  arrDATA = split(strDT_INSERT&"/","/")
			  If Ubound(arrDATA) > 2 Then
				strDT_INSERT = arrDATA(1)&"/"&arrDATA(0)&"/"&arrDATA(2)
			  Else
				strDT_INSERT = Mid(strDT_INSERT,4,2) & "/" & Mid(strDT_INSERT,1,2) & "/" & Mid(strDT_INSERT,7,4)
			  End If

			End If
			
			'Response.Write("Data="&strDT_INSERT&"<BR>")
			'Response.Write("Hora="&strHR_INSERT&"<BR>")
			
			If UBound(arrLinha) > 2  And GetParam("var_LOCAL") = "" Then
			  strLOCAL = Trim(arrLinha(2))
			End If

		
		  Case "OPN_FABRICA"

			'strAux   = Replace(strAux," ","")
			arrLinha = split(strAux&",",",")
			'Response.Write(strAux & "<br>")
		  
			If UBound(arrLinha) > 0 Then
			  strCODBAR = Trim(Left(arrLinha(0),9))
			  strCOD_EMPRESA = Left(strCODBAR,6)
			End If
			
			If UBound(arrLinha) > 2 Then 
			  strHR_INSERT = Trim(arrLinha(2))
			  
			  strHR_INSERT = Replace(strHR_INSERT," ","")
			  If InStr(Ucase(strHR_INSERT),"AM") Then
			    strAM_PM = "AM"
			  ElseIf InStr(Ucase(strHR_INSERT),"PM") Then
			    strAM_PM = "PM"
			  End If
			  arrHORA = split(strHR_INSERT&":",":")
			  If Ubound(arrHORA) > 2 Then
				strHR_INSERT = arrHORA(0)
				If strAM_PM <> "" and cint(strHR_INSERT) = 0 Then
				  strHR_INSERT = "12"
				End If
				strHR_INSERT = strHR_INSERT&":"&arrHORA(1)&":"&arrHORA(2)
			  End If

			End If
			
			If UBound(arrLinha) > 3 Then 
			  strDT_INSERT = Trim(arrLinha(3)) 'Formato MM/DD/AAAA
			  
			  arrDATA = split(strDT_INSERT&"/","/")
			  If Ubound(arrDATA) > 2 Then
				strDT_INSERT = arrDATA(1)&"/"&arrDATA(0)&"/"&arrDATA(2)
			  Else
				strDT_INSERT = Mid(strDT_INSERT,4,2) & "/" & Mid(strDT_INSERT,1,2) & "/" & Mid(strDT_INSERT,7,4)
			  End If

			End If
			
			'Response.Write("Data="&strDT_INSERT&"<BR>")
			'Response.Write("Hora="&strHR_INSERT&"<BR>")
			
			If UBound(arrLinha) > 6  And GetParam("var_LOCAL") = "" Then
			  strLOCAL = Trim(arrLinha(6))
			End If

		  Case "OPN_FABRICA_24H"

			'strAux   = Replace(strAux," ","")
			arrLinha = split(strAux&",",",")
			'Response.Write(strAux & "<br>")
		  
			If UBound(arrLinha) > 0 Then
			  strCODBAR = Trim(Left(arrLinha(0),9))
			  strCOD_EMPRESA = Left(strCODBAR,6)
			End If
			
			If UBound(arrLinha) > 2 Then 
			  strHR_INSERT = Trim(arrLinha(2))
			  
			  strHR_INSERT = Replace(strHR_INSERT," ","")
			  If InStr(Ucase(strHR_INSERT),"AM") Then
			    strAM_PM = "AM"
			  ElseIf InStr(Ucase(strHR_INSERT),"PM") Then
			    strAM_PM = "PM"
			  End If
			  arrHORA = split(strHR_INSERT&":",":")
			  If Ubound(arrHORA) > 2 Then
			    strHR_INSERT = arrHORA(0)
				If strAM_PM <> "" and cint(strHR_INSERT) = 0 Then
				  strHR_INSERT = "12"
				End If
				strHR_INSERT = strHR_INSERT&":"&arrHORA(1)&":"&arrHORA(2)
			  End If

			End If
			
			If UBound(arrLinha) > 3 Then 
			  strDT_INSERT = Trim(arrLinha(3)) 'Formato MM/DD/AAAA
			  
			  arrDATA = split(strDT_INSERT&"/","/")
			  If Ubound(arrDATA) > 2 Then
				strDT_INSERT = arrDATA(1)&"/"&arrDATA(0)&"/"&arrDATA(2)
			  Else
				strDT_INSERT = Mid(strDT_INSERT,4,2) & "/" & Mid(strDT_INSERT,1,2) & "/" & Mid(strDT_INSERT,7,4)
			  End If
			  
			End If
			
			'Response.Write("Data="&strDT_INSERT&"<BR>")
			'Response.Write("Hora="&strHR_INSERT&"<BR>")
			
			If UBound(arrLinha) > 6  And GetParam("var_LOCAL") = "" Then
			  strLOCAL = Trim(arrLinha(6))
			End If
			
		  Case "CATRACA"
			'Response.Write(strAux & "<br>")
			strOFFSET = Abs(Len(strAux) - 29) 'teste para checar se a DATA esta no formato DDMMYY (29 digitos) ou DDMMYYYY (31 digitos)
			
			'CATRACA
			  strHR_INSERT   = Mid(strAux,6,4) ' HHMM
			  strHR_INSERT   = Mid(strHR_INSERT,1,2) & ":" &  Mid(strHR_INSERT,3,2)
			  
			  strDT_INSERT   = Mid(strAux,10,6+strOFFSET) 'DDMMYY(YY)
			  strDT_INSERT = Mid(strDT_INSERT,1,2) & "/" & Mid(strDT_INSERT,3,2) & "/" & Mid(strDT_INSERT,5,2+strOFFSET)
			  
			  
			  strCODBAR      = Right(strAux,9)
			  strCOD_EMPRESA = Left(strCODBAR,6)
			  
			  If GetParam("var_LOCAL") = "" Then
			    strLOCAL = "CATRACA " & Mid(strAux,4,2)
			  End If

		  Case Else ' Default é "sysMetro"

			strAux   = Replace(strAux," ","")
			arrLinha = split(strAux&";",";")
			'Response.Write(strAux & "<br>")
	
			If UBound(arrLinha) > 0  And GetParam("var_LOCAL") = "" Then
			  strLOCAL = arrLinha(0)
			End If
	
			If UBound(arrLinha) > 1 Then
			  strCODBAR = Left(arrLinha(1),9)
			  strCOD_EMPRESA = Left(strCODBAR,6)
			End If
			
			If UBound(arrLinha) > 2 Then
			  strDT_INSERT = arrLinha(2)
			  'Response.Write(strDT_INSERT&"<BR>")
			  If inStr(strDT_INSERT,"/")=0 then
				strAux = Mid(strDT_INSERT,1,2) & "/" & Mid(strDT_INSERT,3,2) & "/" & Mid(strDT_INSERT,5,4)
				strDT_INSERT = strAux
			  End If
			End If

			If UBound(arrLinha) > 3 Then ' se tiver a hora adiciona no final
			  strHR_INSERT = arrLinha(3)
			  If inStr(strHR_INSERT,":")=0 then
				strAux = strAux & Mid(strHR_INSERT,1,2) & ":" & Mid(strHR_INSERT,3,2) & ":" & Mid(strHR_INSERT,5,2)
				strHR_INSERT = strAux
			  End If

			End If
			
		End Select


	    'Se o usr mandou um DT então gravamos ela, senão gravamos a data e hora do arquivo
		if (strDT_REGISTRO<>"") then 
		  strDT_INSERT = strDT_REGISTRO 
	      'Se o usr mandou um INTERVALO, então a cada iteração adicionamos ele aos strDT_INSERT
		  if (strINTERVALO<>"") then 
			acINTERV = acINTERV + strINTERVALO
		    strDT_INSERT = DATEADD("S",acINTERV,strDT_REGISTRO)
		  end if
		end if

        If isDate(strDT_INSERT) And strCODBAR <> "" Then
		
			If strAM_PM <> "" Then
 			  strHR_INSERT = "time_format(str_to_date('"&strHR_INSERT&"','%r'),'%T')"
			Else
			  strHR_INSERT = "'"&strHR_INSERT&"'"
			End If
		
          strSQL = " INSERT INTO tbl_Visitacao_Expositor (COD_EMPRESA_EXPOSITOR, COD_EMPRESA, CODBARRA, DT_INSERT, LOCAL, COD_EVENTO, GRUPO) VALUES ("
          strSQL = strSQL & "  '" & strCOD_EMPRESA_EXPOSITOR & "'"
		  strSQL = strSQL & ", '" & Left(strCODBAR,6) & "'"
		  strSQL = strSQL & ", '" & Right(strCODBAR,9) & "'"
		  strSQL = strSQL & ", concat('" & PrepDataIve(strDT_INSERT,False,False) & "',' ',"&strHR_INSERT&")"
          strSQL = strSQL & ", '" & strLOCAL & "'"
          strSQL = strSQL & ", " & strCOD_EVENTO
          strSQL = strSQL & ", " & strToSQL(strGRUPO) & ")"
          objConn.Execute(strSQL)
         'Response.Write(strSQL & "<br>")
          i = i + 1
		  
		End If
		  
		If i mod 100 = 0 Then
		'  Response.Write("" & i & "<br>")
		  Response.Flush()
		End If

  End If
 Loop
 Response.Write("Linhas processada(s): " & i & "<br>")

 objTextStream.Close
 objFSO.MoveFile Server.MapPath(".") & "\" & prARQUIVO, Server.MapPath(".") & "\_"&year(now)&month(now)&day(now)&"_"&hour(now)&minute(now)&"_"&prARQUIVO

 set objTextStream = Nothing
 set objFSO = Nothing

End Sub


'-------------------------------------------------------------------------------------------------
Dim objFSO, strPath, objFolder, objItem, contFile
strPath = "." 'Tem que terminar com barra
Set objFSO    = Server.CreateObject("Scripting.FileSystemObject")
Set objFolder = objFSO.GetFolder(Server.MapPath(strPath))

contFile = 0
%>
<div>
Evento: <%=strCOD_EVENTO%><br>
<!--
Layout arquivo: <%=strLAYOUT%><br>
//-->
</div>
<br>
<%

For Each objItem In objFolder.Files
  contFile = contFile + 1
  If (InStr(lcase(objItem.Name),".txt") > 0) and ( left(objItem.Name,1) <> "_" ) Then
    
	strLAYOUT = analisaArquivo(objItem.Name)
  %>
   	<br><%=contFile%> - Importando arquivo: <%=objItem.Name%> (Layout: <%=strLAYOUT%>)<br>
  <%
	ImportaArquivo objItem.Name
  End If
Next 
Set objItem   = Nothing
Set objFolder = Nothing
Set objFSO    = Nothing


FechaDBConn objConn

Response.Flush()
%>
</body>
</html>