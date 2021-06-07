<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"--> 
<!--#include file="_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 Dim objConn, objRS, strSQL
 Dim strUserID, strCodUser,  strCOD_EVENTO, strNOME_EVENTO,strEMAIL,strNomeUser,numPerPage,StrMENUOld
 Dim strURL_ENTRADA, strFlagLogin, strGrpUser, strSACUSER,strUSROCULTO,StrMENUNew,strIDApp,strLink,objFolder,Local,ObjFS,Folder,GetCurPage
 Dim i, j, arrScodi, arrSdesc, isessao,strFields,arrFields,strINFO, controle,flagTILE_VIEW

 
 
 strUserID		= Session("ID_USER")
 strCodUser		= Session("COD_USUARIO")
 strGrpUser     = Session("GRP_USER")
 strNomeUser	= Session("NOME_USER")
 strEMAIL       = Session("EMAIL_USER")
 strUSROCULTO   = Session("USER_OCULTO")

 strSACUSER     = Session("SAC_USER")
 strFlagLogin   = Session("FLAGLOGIN")

 strCOD_EVENTO	= Session("COD_EVENTO")
 strNOME_EVENTO = Session("NOME_EVENTO")
 
 flagTILE_VIEW = Replace(GetParam("var_tileview"),"'","''")
 


 
 AbreDBConn objConn, CFG_DB
'------------------------------------------------------------------------------
 If strFlagLogin="True" then
   strSQL = "SELECT URL_ENTRADA FROM tbl_USUARIO_GRUPO WHERE GRP_USER = '" & strGrpUser & "'"
   Set objRS = objConn.Execute(strSQL)
   If not objRS.EOF Then
     strURL_ENTRADA = getValue(objRS,"URL_ENTRADA")
   End If
   FechaRecordSet objRS
   If strURL_ENTRADA <> "" Then
     Session("FLAGLOGIN") = "False"
	 FechaDBConn ObjConn
     Response.redirect(strURL_ENTRADA)
   End If
 End If 
 
  ' ------------------------------------------------------------------------
 ' Busca dados relativos as informações do site no banco (athcsm.mdb) 
 ' para montagem na tela principal
 ' ------------------------------------------------------------------------
 MontaArrySiteInfo arrScodi, arrSdesc 
 
 strSQL = " SELECT     COD_PAINEL "
  strSQL = strSQL & "		  , ROTULO "
 strSQL = strSQL & "		  , DESCRICAO "
 strSQL = strSQL & "		  , LINK " 
 strSQL = strSQL & "		  , LINK_PARAM "
 strSQL = strSQL & "		  , TILE_VIEW "
 strSQL = strSQL & "		  , TILE_TYPE " 
 strSQL = strSQL & "		  , TILE_BGCOLOR " 
 strSQL = strSQL & "		  , TILE_ICON " 
 strSQL = strSQL & "		  ,(SELECT COUNT(*) FROM sys_painel WHERE TILE_VIEW like '" & flagTILE_VIEW & "') as QTDE_ITENS " 
 strSQL = strSQL & "   FROM  sys_painel "  
 strSQL = strSQL & "  WHERE DT_INATIVO IS NULL "
 strSQL = strSQL & "    AND TILE_VIEW like '" & flagTILE_VIEW & "'"
 strSQL = strSQL & "  ORDER BY ORDEM"
 

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 
 
  ' Define os campos para exibir na grade
 strFields = "ROTULO" 
 arrFields = Split(strFields,",")  
 
 sub MontaTileGroup (prTileClass,prTitulo, prTileTipo)
 	response.write ("<!-- INI: " & prTitulo & " grupo (" & prTileClass & ") --------------------------------------- //-->" & vbnewline)
 	response.write ("<div class='" & prTileClass & "'>" & vbnewline)
 	'response.write ("<div class='tile-group-title'>" & prTitulo & "</div>" & vbnewline)
	DO WHILE NOT objRS.EOF
		if  (UCASE(GetValue(objRS,"TILE_VIEW")) = prTileTipo) THEN
			auxSTR = trim(GetValue(objRS, "LINK")) & trim(GetValue(objRS, "LINK_PARAM"))
			auxSTR = replaceParametersSession(auxSTR)
			
			if (instr(auxSTR,"javascript:")>0) then
				response.write ("<a href='#' onclick=""" & auxSTR & """") 
			Else
				response.write ("<a href='" & auxSTR & "'") 
			End IF
			response.write ("	class='tile " & trim(GetValue(objRS, "TILE_TYPE")) & " " & trim(GetValue(objRS, "TILE_BGCOLOR")) & " fg-white'") 
			response.write ("   title='" & GetValue(objRS, "DESCRICAO") & "'>" & vbnewline)
							response.write ("<div class='tile-content icon'>" & vbnewline)
							response.write ("	<span class='" & trim(GetValue(objRS, "TILE_ICON")) & "' ></span>" & vbnewline)
							response.write ("</div>" & vbnewline)
							response.write ("<div class='tile-status'>" & vbnewline)
						 		response.write ("<div class='label'>" & vbnewline)
							 	if lcase(trim(GetValue(objRS,"TILE_TYPE")))<>"half"  then
							 		response.write GetValue(objRS, "ROTULO")
							 	ElseiF trim(GetValue(objRS,"TILE_ICON"))="" then
							 		response.write GetValue(objRS, "ROTULO")
							 	End if
						 	response.write ("</div>" & vbnewline)
						 	response.write ("</div>" & vbnewline)
			response.write ("</a>" & vbnewline)
 		END IF 
		objRS.MoveNext
	loop	
  	response.write ("</div>" & vbnewline)
	'response.write ("</div>" & vbnewline)
 	response.write ("<!-- INI: " & prTitulo & " grupo (" & prTileClass & ") --------------------------------------- //-->" & vbnewline)
 end sub  

 
If (not objRS.BOF) and (not objRS.EOF) Then 

%>
<html>
<head>
<title>PAINEL pVISTA</title>
<!--#include file="metacssjs_root.inc"--> 
<script src="./_scripts/scriptsCS.js"></script>
</head>
<body class="metro">
<!-- INI: Aberturda de chamados VBOSS ------------------------------------------------------------------------------------------------------ //-->
<form id="formChamadoVBOSS" name="formChamadoVBOSS" action="http://virtualboss.proevento.com.br/proevento/default_LoginViasite.asp" target="_blank" method="post" style="display:none;">
    <input type="hidden" id='var_user'     name='var_user'     value='<%=strSACUSER%>'>
    <input type="hidden" id='var_password' name='var_password' value='athroute'>
    <input type="hidden" id='var_db'       name='var_db'       value='proevento'>
    <input type="hidden" id='var_title'    name='var_title'    value='<%=strNOME_EVENTO%>'>
    <input type="hidden" id='var_extra'    name='var_extra'    value='<%=strCOD_EVENTO & " - " & strNOME_EVENTO%>'>
</form>  
<!-- FIM: Aberturda de chamados VBOSS ------------------------------------------------------------------------------------------------------ //-->
<!-- Uma coisa que descobri hoje é que ao utilizar a classe border de uma div no caso a CONTAINER ele ão alinha corretamente os div
por sugiro que sempre desabilite o teste de border para não causar desalinhamento nas div's criadas. Será relizado maiores teste para que se busque um possivel alinhamento
com bordas caso necessario   eliton 30/11/2015//-->
<div class="container padding5"> 
    <h1>
    <a href="#" class="history-back"><i class="icon-arrow-left-3 fg-darker smaller"></i></a>
    <%=flagTILE_VIEW%><small class="on-right">Painel</small>
    </h1>
    
                    <p id="_general" class="description">
                        <!--teste de uso para implementação de um painel que abrirá os atalho que hoje se encontram em _MOBILE.//-->
                    </p>
 <div class="grid">
             <%
             '------------Laço que cria os atalhos (publicos-verdes)------------- 
                    if  (NOT objRS.eof) then
                       objRS.MoveFirst
							   if (CInt(GetValue(objRS,"QTDE_ITENS")) > 0) then 
									MontaTileGroup "tile-group six", "ATALHOS", flagTILE_VIEW
							   End if
                    end if
             %>
 </div>             
   
</div>
<%
Else
  Mensagem "Não existem dados para esta consulta.<br>Informe novos critérios para efetuar a pesquisa.", "","", true 
End If
%>
</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>
