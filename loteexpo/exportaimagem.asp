<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<%
 Server.ScriptTimeout = 2400
 Response.Expires = 0
 Response.Buffer = True
%>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%

 Dim objConn, objRS, objRSDetail, strSQL, strACAO, vFiltro, strSQLClause
 Dim NumPerPage, cont, i
 Dim strNOME, strID_NUM_DOC1, strFILENAME, strSAFIRA, strIMG_FOTO

 Dim objFile, objFSO, objCDO
 Dim objTextStream

 
 cont = 0
 i = 0

 
 AbreDBConn objConn, CFG_DB_DADOS 
 
 Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
 
 strSQL = " SELECT cod_empresa, nomecli, extra_txt_1, img_foto from tbl_empresas where img_foto is not null ORDER BY 1"
 
 Set objRS = objConn.Execute(strSQL)
 
 Response.Write("Empresas<BR>")
 
 Do While not objRS.EOF
     
   strNOME = objRS("NOMECLI")&""
   strIMG_FOTO = lcase(objRS("IMG_FOTO")&"")
   strSAFIRA = objRS("EXTRA_TXT_1")&""
	 
	 If strIMG_FOTO <> "" Then
	   
	   Response.Write(objRS("COD_EMPRESA") & ": " & strIMG_FOTO & " -> " & strSAFIRA & ".jpg")
	 
	   If strIMG_FOTO <> strSAFIRA&".jpg" And strSAFIRA <> "" Then
		 If objFSO.FileExists(Server.MapPath(".") & "\" & strIMG_FOTO) Then
		   objFSO.CopyFile Server.MapPath(".") & "\" & strIMG_FOTO, Server.MapPath(".") & "\" & strSAFIRA & ".jpg"
		 End If
		 
		 Response.Write(" ** COPIADO **")
		 
		 i = i + 1
		 
	   End If
	   
  	   Response.Write("<BR>")
	   
	 End If
 
   objRS.MoveNext
   cont = cont + 1
   if cont mod 100 = 0 then
     Response.Flush()
   end if
 Loop
 
 Response.Write("<BR>" & i & " arquivos(s) processado(s).<br>")
 
 cont = 0
 
 strSQL = " SELECT codbarra, nome_completo, NOME_PRIMEIRO, img_foto, extra_txt_1 from tbl_empresas_sub where img_foto is not null ORDER BY 1"
 
 Set objRS = objConn.Execute(strSQL)
 
 Response.Write("<br>EMPRESAS_SUB = CONTATOS<BR>")
 
 Do While not objRS.EOF
     
   strNOME = objRS("nome_completo")&""
   strIMG_FOTO = lcase(objRS("IMG_FOTO")&"")
   strSAFIRA = objRS("extra_txt_1")&""
	 
	 If strIMG_FOTO <> "" Then
	   
	   Response.Write(objRS("CODBARRA") & ": " & strIMG_FOTO & " -> " & strSAFIRA & ".jpg")
	 
	   If strIMG_FOTO <> strSAFIRA&".jpg" And strSAFIRA <> "" Then
		 If objFSO.FileExists(Server.MapPath(".") & "\" & strIMG_FOTO) Then
		   objFSO.CopyFile Server.MapPath(".") & "\" & strIMG_FOTO, Server.MapPath(".") & "\" & strSAFIRA & ".jpg"
		 End If
		 
		 Response.Write(" ** COPIADO **")
		 
		 i = i + 1
		 
	   End If
	   
  	   Response.Write("<BR>")
	   
	 End If
 
   objRS.MoveNext
   cont = cont + 1
   if cont mod 100 = 0 then
     Response.Flush()
   end if
 Loop
 
 Response.Write("<BR>" & i & " arquivos(s) processado(s).<br>")
  
 set objFSO = Nothing
 
 
 FechaRecordSet ObjRS
 FechaDBConn ObjConn
 

 

Response.Flush()
%>
