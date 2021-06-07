<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/athdbConn.asp"-->
<!--#include file="../../_database/athutils.asp"--> 
<%
Sub GravaArquivo(prPATHNAME, prFILENAME, prCONTEUDO)
dim filesys, filetxt, getname

 Set filesys = CreateObject("Scripting.FileSystemObject")
 Set filetxt = filesys.CreateTextFile(prPATHNAME & prFILENAME, True) 
 
 filetxt.Write(prCONTEUDO) 
 filetxt.Close 

 Set filetxt = Nothing
 Set filesys = Nothing
End Sub

' ========================================================================
' Principal ==============================================================
' ========================================================================
Dim strCOD_PAPER_CADASTRO
Dim strUser, path,strDEFAULT_LOCATION

strCOD_PAPER_CADASTRO = Replace(Request("var_cod_paper_cadastro"),"'","''")
strDEFAULT_LOCATION		= getParam("DEFAULT_LOCATION")	

Dim objConn, objRS, objRSDetail, strSQL, strSQLDetail

AbreDBConn objConn, CFG_DB_DADOS

Dim strPATHNAME, strFILES
strPATHNAME = Server.MapPath("..\..\") & "\subpaper\upload\"
strFILES = ""


Dim arrPAPER_CAMPO, arrPAPER_VALOR, strCAMPO_VALOR, strCAMPO_NOME, strCAMPO_LABEL_MEMO, strCOD_EMPRESA, strCAMPO_ANTERIOR
	
	strSQL =          " SELECT PS.COD_PAPER_SUB, PS.CAMPO_TIPO, PS.CAMPO_ORDEM, PS.CAMPO_REQUERIDO, PS.CAMPO_COMBOLIST, PS.CAMPO_LABEL_MEMO, PS.CAMPO_NOME, PC.COD_EMPRESA "
	strSQL = strSQL & "   FROM TBL_PAPER_SUB PS INNER JOIN TBL_PAPER_CADASTRO PC ON PS.COD_PAPER = PC.COD_PAPER"
	strSQL = strSQL & "  WHERE PC.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
	strSQL = strSQL & "  ORDER BY CAMPO_ORDEM, COD_PAPER_SUB"
	Set objRS = objConn.Execute(strSQL)
	Do While not objRS.EOF
	  strCOD_EMPRESA = objRS("COD_EMPRESA")
	  strCAMPO_VALOR = Request("var_campo_sub_"&objRS("COD_PAPER_SUB"))
	  strCAMPO_NOME  = replace(replace(objRS("CAMPO_NOME")&"","\",""),"/","")

	  strCAMPO_LABEL_MEMO = objRS("CAMPO_LABEL_MEMO")&""
	  If strCAMPO_LABEL_MEMO = "" Then
	    strCAMPO_LABEL_MEMO = strCAMPO_NOME
	  End If

	  If objRS("CAMPO_TIPO") = "M" and strCAMPO_VALOR&"" <> "" Then
		GravaArquivo strPATHNAME, UCase(strCOD_PAPER_CADASTRO & "_" & strCAMPO_LABEL_MEMO & ".TXT"), strCAMPO_VALOR
	  End If
	  strCAMPO_VALOR = strToSQL(strCAMPO_VALOR)
	  
	  strSQL =          " SELECT TBL_PAPER_SUB_VALOR.COD_PAPER_SUB, TBL_PAPER_SUB_VALOR.CAMPO_VALOR "
	  strSQL = strSQL & " , DATE_FORMAT(NOW(), '%M-%d-%Y %H:%i:%s') AS DATACA"
	  strSQL = strSQL & "   FROM TBL_PAPER_CADASTRO, TBL_PAPER_SUB_VALOR "
	  strSQL = strSQL & "  WHERE TBL_PAPER_CADASTRO.COD_PAPER_CADASTRO = TBL_PAPER_SUB_VALOR.COD_PAPER_CADASTRO  "
	  strSQL = strSQL & "    AND TBL_PAPER_CADASTRO.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
	  strSQL = strSQL & "    AND TBL_PAPER_SUB_VALOR.COD_PAPER_SUB = " & objRS("COD_PAPER_SUB")
	  Set objRSDetail = objConn.Execute(strSQL)
	  If not objRSDetail.EOF Then
	    strCAMPO_ANTERIOR = replace(objRSDetail("CAMPO_VALOR")&"","'"," ")
		strSQL = "UPDATE TBL_PAPER_SUB_VALOR SET CAMPO_VALOR = " & strCAMPO_VALOR & " WHERE COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO & " AND COD_PAPER_SUB = " & objRS("COD_PAPER_SUB")
		'response.Write(strSQL)
		'response.End()
		strUser = Session("ID_USER")
		strUser = strUser & " Emp:" & strCOD_EMPRESA 
		
        If Trim(Request("var_campo_sub_"&objRS("COD_PAPER_SUB"))&"") <> Trim(strCAMPO_ANTERIOR) Then
			strSQLDetail = "INSERT INTO TBL_EMPRESAS_HIST (COD_EMPRESA, SYS_USERCA, SYS_DATACA, HISTORICO) VALUES ('"&strCOD_EMPRESA&"','"&strUser&"',NOW(),'"&"ALTERACAO TRABALHO CIENTIFICO - CODIGO "&strCOD_PAPER_CADASTRO&" (CAMPO : "&objRS("COD_PAPER_SUB")&" - CONTEUDO ANTERIOR: "&strCAMPO_ANTERIOR&"')"
			objConn.Execute(strSQLDetail)
		End If

	  Else
		strSQL = "INSERT INTO TBL_PAPER_SUB_VALOR (COD_PAPER_CADASTRO, COD_PAPER_SUB, CAMPO_VALOR) VALUES ("&strCOD_PAPER_CADASTRO&","&objRS("COD_PAPER_SUB")&","&strCAMPO_VALOR&")"
	  End If
	  FechaRecordSet objRSDetail
	' DEBUG
	' Response.Write(strSQL &"<BR>") 
	  objConn.Execute(strSQL)

	  objRS.MoveNext
	Loop
	FechaRecordSet objRS

'---------------------------------------

Dim strFORMA_APRESENTACAO, strDT_APRESENTACAO

strFORMA_APRESENTACAO = Replace(Request("var_forma_apresentacao"),"'","''")
strDT_APRESENTACAO = Replace(Request("var_dt_apresentacao"),"'","''")

If IsDate(strDT_APRESENTACAO) Then
  strDT_APRESENTACAO = "'" & PrepDataIve(strDT_APRESENTACAO,False,False) & "'"
Else
  strDT_APRESENTACAO = "NULL"
End If

strSQL = "UPDATE TBL_PAPER_CADASTRO SET SYS_DATAFINISH = DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'), DT_APRESENTACAO = "&strDT_APRESENTACAO&", FORMA_APRESENTACAO = "&strToSQL(strFORMA_APRESENTACAO)&" WHERE COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
'Response.Write(strSQL &"<BR>") 
objConn.Execute(strSQL)


FechaDBConn ObjConn
	
if strDEFAULT_LOCATION <> "" then 	
  Response.Redirect(strDEFAULT_LOCATION)
End if
%>