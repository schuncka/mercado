<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_scripts/scripts.js"-->
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athutils.asp"--> 
<%
  Dim strSQL, objRS
  Dim bolAlreadyExists, strHyperLink, strMensagem
  Dim strCOD_USUARIO, strID_USER, strSENHA, strNOME, strEMAIL, strGRP_USER, strSAC_USER
  Dim strSTART_GEN_ID, strLAST_GEN_ID, strSTART_INSC_ID, strLAST_INSC_ID, strSTART_CREDEXP_ID, strLAST_CREDEXP_ID,	strIDUSERMODELO

  strCOD_USUARIO = Replace(Request.Form("VAR_COD_USUARIO"),"'","''")
  strID_USER     = Replace(Request.Form("VAR_ID_USER"),"'","''")
  strSENHA       = Replace(Request.Form("VAR_SENHA"),"'","''")
  strEMAIL       = Replace(Request.Form("VAR_EMAIL"),"'","''")
  strNOME        = Replace(Request.Form("VAR_NOME"),"'","''")
  strGRP_USER    = UCase(Replace(Request.Form("var_grp_user"),"'","''"))
  strSAC_USER    = Replace(Request.Form("var_sac_user"),"'","''")
  	strIDUSERMODELO      = Replace(Request("var_iduser_modelo"),"'","''")


  strSTART_GEN_ID = Replace(Request.Form("VAR_START_GEN_ID"),"'","''")
  strLAST_GEN_ID = Replace(Request.Form("VAR_LAST_GEN_ID"),"'","''")
  strSTART_CREDEXP_ID = Replace(Request.Form("VAR_START_CREDEXP_ID"),"'","''")
  strLAST_CREDEXP_ID = Replace(Request.Form("VAR_LAST_CREDEXP_ID"),"'","''")
  strSTART_INSC_ID = Replace(Request.Form("VAR_START_INSC_ID"),"'","''")
  strLAST_INSC_ID = Replace(Request.Form("VAR_LAST_INSC_ID"),"'","''")


   if cint(strCOD_USUARIO) <> cint(session("COD_USUARIO")) then
     VerficaAcesso("ADMIN")
     'VerficaAcessoOculto(Session("ID_USER"))
   end if  

  Dim objConn

  AbreDBConn objConn, CFG_DB_DADOS 

        
  if strEMAIL = "" then 
	strEMAIL = " "
  end if
  
  if strIDUSERMODELO = "" then 
		strIDUSERMODELO = ""
	end if 
  
' ========================================================================
' Rotina para exibir tela de mensagem de aviso ou erro
' ========================================================================
Sub Mensagem(aviso, hyperlink)
%>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">

<p align="center">&nbsp;</p>
<p align="center"><font face="Arial, Helvetica, sans-serif" size="2"><b>&lt;&lt; 
	AVISO &gt;&gt;</b></font></p>
<p align="center"><font face="Arial, Helvetica, sans-serif" size="2"><%=aviso%></font></p>
<p align="center"><font face="Arial, Helvetica, sans-serif" size="2"><a href='<%=hyperlink%>'>Voltar</a></font></p>
</body>
</html>
<%
 Response.End
End Sub


' ========================================================================
' Faz a consistência para saber se os campos requeridos foram informados
' ========================================================================
Function CheckFields()
	Dim bolResult
	bolResult = True
	If ((strCOD_USUARIO = "") OR (strSENHA = "") OR (strNOME = "") Or (strGRP_USER = "")) Then
		strHyperLink = "Javascript:history.back()"
		strMensagem  = "Você tem que preencher todos os campos obrigatórios da ficha de usuário."
		Mensagem strMensagem, strHyperLink
		bolResult = False
	End If
	CheckFields = bolResult
End Function


' ========================================================================
' Faz a consistência para saber se os campos informados ja existem
' ========================================================================
Function CheckContato()
	Dim bolResult, strSQL, objRS
	
	bolResult = True
	
	'Verifica se já não existe um cadastro com estes dados
	strSQL = " SELECT COD_USUARIO FROM tbl_USUARIO WHERE COD_USUARIO = " & strCOD_USUARIO
	
	Set objRS = Server.CreateObject("ADODB.Recordset")
	objRS.Open strSQL, objConn
	
	If (objRS.BOF and objRS.EOF) Then
		strHyperLink = "Javascript:history.back()"
		strMensagem  = "Não existe no sistema nenhuma informação sobre o usuário <b>[" & strID_USER & _
                    "]</b>, por favor tente novamente."
		Mensagem strMensagem, strHyperLink
		bolResult = False
	End If
	
	objRS.Close
	CheckContato = bolResult
End Function


' ========================================================================
' Grava o cadastro no banco de dados
' ========================================================================
Sub GravaCadastro()
	Dim strSQL, objRS, strDT_INATIVO, strTEMPORARIO, strREGISTRA_LEITURA
	
	If Request.Form("var_ativo") = "1" Then
		strDT_INATIVO = "NULL"
	Else
       strDT_INATIVO =  "'" & PrepDataIve(date, False, False) & "'"
'MDB       strDT_INATIVO = date()
	End If

	If Request.Form("var_temporario") = "1" Then
		strTEMPORARIO = "1"
	Else
       strTEMPORARIO =  "0"
	End If

	If Request.Form("var_registra_leitura") = "1" Then
		strREGISTRA_LEITURA = "1"
	Else
       strREGISTRA_LEITURA =  "0"
	End If

	
	strSQL =          " UPDATE tbl_USUARIO SET"
	strSQL = strSQL & "  SENHA = '" & strSENHA & "'"
	strSQL = strSQL & ", NOME = '" & strNOME & "'"
	strSQL = strSQL & ", EMAIL = '" & strEMAIL & "'"
	strSQL = strSQL & ", GRP_USER = '" & strGRP_USER & "'"
	strSQL = strSQL & ", SAC_USER = " & strToSQL(strSAC_USER)
		
	If Request.Form("var_ativo") <> "" Then
	  strSQL = strSQL & ", DT_INATIVO = " & strDT_INATIVO
	End If
	If Request.Form("var_temporario") <> "" Then
	  strSQL = strSQL & ", TEMPORARIO = " & strTEMPORARIO
	End If
	If Request.Form("var_registra_leitura") <> "" Then
	  strSQL = strSQL & ", REGISTRA_LEITURA = " & strREGISTRA_LEITURA
	End If
    If Session("GRP_USER") = "ADMIN" Thenz
      strSQL = strSQL & ", ID_USER = '" & strID_USER & "'"
    End If
	If strSTART_GEN_ID <> "" Then
      strSQL = strSQL & ", START_GEN_ID = '" & strSTART_GEN_ID & "'"
	End If
	If strLAST_GEN_ID <> "" Then
      strSQL = strSQL & ", LAST_GEN_ID = '" & strLAST_GEN_ID & "'"
	End If
	If strSTART_CREDEXP_ID <> "" Then
      strSQL = strSQL & ", START_CREDEXP_ID = '" & strSTART_CREDEXP_ID & "'"
	End If
	If strLAST_CREDEXP_ID <> "" Then
      strSQL = strSQL & ", LAST_CREDEXP_ID = '" & strLAST_CREDEXP_ID & "'"
	End If
	If strSTART_INSC_ID <> "" Then
      strSQL = strSQL & ", START_INSC_ID = '" & strSTART_INSC_ID & "'"
	End If
	If strLAST_INSC_ID <> "" Then
      strSQL = strSQL & ", LAST_INSC_ID = '" & strLAST_INSC_ID & "'"
	End If
	strSQL = strSQL & ", ID_USER_MODELO = '" &  strIDUSERMODELO & "'"
    strSQL = strSQL & " WHERE COD_USUARIO = " & strCOD_USUARIO
	response.Write(strSQL)
	response.End()
	Set objRS = objConn.Execute(strSQL)
End Sub


' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' Principal
' ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

If (CheckFields() And CheckContato()) Then
	GravaCadastro()
	Response.Redirect("detail.asp?var_chavereg=" & strCOD_USUARIO)
End If

objRS.Close
Set objRS = Nothing

FechaDBConn ObjConn
%>