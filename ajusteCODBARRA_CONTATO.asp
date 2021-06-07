<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% Option Explicit %>
<!--#include file="_database/adovbs.inc"-->
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<%
 Server.ScriptTimeout = 7600
 Response.Buffer = True
 
 Dim objConn, ObjRS, objRSDetail
 Dim strSQL, strvalor, cont, strCODBARRA, strCOD_EMPRESA

 strCOD_EMPRESA = Request("cod_empresa")
 
 cont = 0
 
 AbreDBConn objConn, CFG_DB_DADOS 

 strSQL = " SELECT DISTINCT COD_EMPRESA FROM tbl_empresas_sub where (cod_empresa <> left(codbarra,6) or CODBARRA IS NULL)"
 If strCOD_EMPRESA <> "" Then
   strSQL = strSQL & " AND COD_EMPRESA = '" & strCOD_EMPRESA & "'"
 End If
			
 Set objRS = Server.CreateObject("ADODB.Recordset")
 objRS.Open strSQL, objConn

 Do While Not objRS.EOF 
 
   Response.Write("---------------<BR>" & objRS("COD_EMPRESA") & "<BR>")
 
   strCODBARRA = objRS("COD_EMPRESA") & "011"
   
   strSQL = "SELECT MAX(CODBARRA) FROM tbl_empresas_sub WHERE COD_EMPRESA = '" & objRS("COD_EMPRESA") & "' AND COD_EMPRESA = left(CODBARRA,6)"
   Set objRSDetail = objConn.Execute(strSQL)
   If not IsNull(objRSDetail(0)) Then
     strCODBARRA = int(objRSDetail(0)) + 1
   End If
   FechaRecordSet objRSDetail

   strSQL = "SELECT CODBARRA, ID_AUTO FROM tbl_empresas_sub WHERE COD_EMPRESA = '"&objRS("COD_EMPRESA")&"' AND (COD_EMPRESA <> left(CODBARRA,6) or CODBARRA IS NULL)"
   Set objRSDetail = objConn.Execute(strSQL)
   
   Do While not objRSDetail.EOF 
	  
     strSQL = "UPDATE tbl_empresas_sub SET CODBARRA = '" & Right("000000000"&strCODBARRA,9) & "' WHERE COD_EMPRESA = '"&objRS("COD_EMPRESA")&"' AND (CODBARRA = '" & objRSDetail("CODBARRA") & "' OR ID_AUTO = " & objRSDetail("ID_AUTO") & ")"
     Response.Write(strSQL & "<BR>")
     objConn.Execute strSQL
	 objRSDetail.MoveNext
     strCODBARRA = int(strCODBARRA) + 1

   Loop
   FechaRecordSet objRSDetail
   
   objRS.MoveNext

   cont = cont + 1
   If  cont mod 100 = 0 Then
     Response.Write(cont & "<BR>")
	 Response.Flush()
   End If
 Loop
 FechaRecordSet ObjRS
 FechaDBConn ObjConn

 Response.Write("Total de registros: " & cont )
 Response.Flush()
%>