<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"--> 
<!--#include file="_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL

 Dim strUserID, strCodUser,  strCOD_EVENTO, strNOME_EVENTO,strEMAIL,strNomeUser,numPerPage,prTileTipo
 Dim strURL_ENTRADA, strFlagLogin, strGrpUser, strSACUSER,strUSROCULTO, flagSTRTILE_VIEW_TYPE,flagTILE_VIEW
 Dim i, j, arrScodi, arrSdesc, isessao

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
 
 'OBS: este parametro será configurado no campo PARAMETRO dentro de CFG_PAINEL(sys_painel)
 'ao setar o parâmetro ele cria o atalho no painel principal que direcionará para o novo painel genérico 
 'flagSTRTILE_VIEW_TYPE


 AbreDBConn objConn, CFG_DB

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
 
 sub MontaTileGroup (prTileClass,prTitulo, prTileTipo)
 	response.write ("<!-- INI: " & prTitulo & " grupo (" & prTileClass & ") --------------------------------------- //-->" & vbnewline)
 	response.write ("<div class='" & prTileClass & "'>" & vbnewline)
 	response.write ("<div class='tile-group-title'>" & prTitulo & "</div>" & vbnewline)
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
 	response.write ("<!-- INI: " & prTitulo & " grupo (" & prTileClass & ") --------------------------------------- //-->" & vbnewline)
 end sub 
 
  sub MontaTileSemGroup (prTileClass,prTitulo, prTileTipo)
 	response.write ("<!-- INI: " & prTitulo & " grupo (" & prTileClass & ") --------------------------------------- //-->" & vbnewline)
 	'response.write ("<div class='" & prTileClass & "'>" & vbnewline)
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
							'response.write ("<div class='tile-status'>" & vbnewline)
						 	'	response.write ("<div class='label'>" & vbnewline)
							 	if lcase(trim(GetValue(objRS,"TILE_TYPE")))<>"half"  then
							 		response.write GetValue(objRS, "ROTULO")
							 	ElseiF trim(GetValue(objRS,"TILE_ICON"))="" then
							 		response.write GetValue(objRS, "ROTULO")
							 	End if
						 	'response.write ("</div>" & vbnewline)
						 '	response.write ("</div>" & vbnewline)
			response.write ("</a>" & vbnewline)
 		END IF 
		objRS.MoveNext
	loop	
  	'response.write ("</div>" & vbnewline)
	'response.write ("</div>" & vbnewline)
 	response.write ("<!-- INI: " & prTitulo & " grupo (" & prTileClass & ") --------------------------------------- //-->" & vbnewline)
 end sub  
 
 ' ------------------------------------------------------------------------
 ' Busca dados relativos as informações do site no banco (athcsm.mdb) 
 ' para montagem na tela principal
 ' ------------------------------------------------------------------------
 MontaArrySiteInfo arrScodi, arrSdesc 
 
 ' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
 		  strSQL = " SELECT     COD_PAINEL "
 strSQL = strSQL & "		  , ROTULO "
 strSQL = strSQL & "		  , DESCRICAO "
 strSQL = strSQL & "		  , LINK " 
 strSQL = strSQL & "		  , LINK_PARAM "
 strSQL = strSQL & "		  , TILE_VIEW "
 strSQL = strSQL & "		  , TILE_TYPE " 
 strSQL = strSQL & "		  , TILE_BGCOLOR " 
 strSQL = strSQL & "		  , TILE_ICON " 
 strSQL = strSQL & "		  ,(SELECT COUNT(*) FROM sys_painel WHERE TILE_VIEW not like 'PRIVATE') as QTDE_PUBLIC "
 strSQL = strSQL & "		  ,(SELECT COUNT(*) FROM sys_painel WHERE TILE_VIEW like 'PRIVATE') as QTDE_PRIVATE " 
 strSQL = strSQL & "		  ,(SELECT COUNT(*) FROM sys_painel WHERE TILE_VIEW like 'PAINEL')  as QTDE_PAINEL "  
 strSQL = strSQL & "  FROM  sys_painel "  
 strSQL = strSQL & "  WHERE DT_INATIVO IS NULL "
 strSQL = strSQL & "  ORDER BY ORDEM"
'athdebug strSQL, true

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 


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

<!-- INI: Tile Painel de Dados ------------------------------------------------------------------------------------//-->
<div class="tile-area tile-area-dark" style="padding-top:20px;">
 <h1 class="tile-area-title fg-white"></h1>
	<div class="tile-group four">
        <div class="tile-group-title"><%=ucase(arrSdesc(ArrayIndexOf(arrScodi,"CLIENTE")))%></div>
           <a class="tile double double-vertical bg-steel live" data-role="live-tile" data-effect="slideUp">
                <div class="tile-content ">
                    <div class="padding10">
                        <h1 class="fg-white ntm"><%=strCOD_EVENTO%></h1><!--Cod Evetno //-->
                        <h2 class="fg-white no-margin"><%=ucase(strNOME_EVENTO)%></h2>
                        <h5 class="fg-white no-margin"></h5>
                        <p class="tertiary-text fg-white"></p>
                        <p class="tertiary-text fg-white"></p>
                        <p class="tertiary-text fg-white"><strong><%=lcase(strUserID)%></strong></p>
                        <p class="tertiary-text fg-white no-margin"><%=ucase(strNomeUser)%></p>
                        <p class="tertiary-text fg-white no-margin"><%'=ucase(strGrpUser)%></p>
                        <p class="tertiary-text fg-white"><%=strEMAIL%></p>
                    <div class="tile-status">
                    	<div class="label"><%="Login at " & Session("DT_LASTLOGIN")%></div>
                    </div>
                    </div>
                </div>
                <div class="tile-content ">
                    <div class="padding10">
                        <h1 class="fg-white ntm"><%="pVISTA"%></h1>
                        <h2 class="fg-white no-margin"><%= Request.ServerVariables("SERVER_SOFTWARE")%></h2>
                        <h5 class="fg-white no-margin"><%=Request.ServerVariables("SERVER_NAME")%></h5>
                        <p class="tertiary-text fg-white">&nbsp;</p>
                        <p class="tertiary-text fg-white no-margin"><%= Request.ServerVariables("SERVER_PROTOCOL")%> (<%=Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")%>)</p>
                        <p class="tertiary-text fg-white no-margin"><%="SessionID." & Session.SessionID%></p>                           
                        <p class="tertiary-text fg-white no-margin"></p>
                        <p class="tertiary-text fg-white"></p>
                    </div>
                    <div class="tile-status">
                        <div class="label"><%="Login at " & Request.ServerVariables("REMOTE_HOST")%></div>
                    </div>
                </div>
           </a> 
           
       
<!-- FIN: Tile Painel de Dados ------------------------------------------------------------------------------------//-->
              <a href="modulo_Ajuda/default.asp" onClick="" class="tile double bg-silver" title="manuais...">
                <div class="tile double bg-silver">
                    <img src="./img/painel_ilustracao_manuais.png" >
                    <div class="brand">
                    		<div class="label">MANUAIS</div>	
                    	</div>
                </div> <!-- end tile -->
			 </a>
               <!-- <div class="tile double bg-silver">
                    <img src="./img/painel_ilustracao1_tablet.jpg" >
                </div>--> <!-- end tile -->

<!-- INI Tile icon --------------------------------------------------------------------------------------------------//-->
				<%
			      If (strSACUSER <> "") Then 
					auxSTR = "formChamadoVBOSS.submit(); return false;"
				  Else 
					auxSTR = "alert('Seu usuário não tem acesso a este recurso.');"
				  End If 
                %>
                <a href="#" onClick="<%=auxSTR%>" class="tile bg-darkOrange" title="ABRIR CHAMADO (vboss: <%=lcase(strSACUSER)%>)">
                    <div class="tile-content icon" style="padding-top:40px; padding-left:5px;">
                    	<span class="icon-user-3" ></span>
                    	<div class="brand">
                    		<div class="label">SAC/VBOSS</div>	
                    	</div>
                    </div>
                </a>
<!--Fim Tile icon-----------------------------------------------------------------------------//-->

<!-- small tiles-----------------------------------------------------------------------------//-->
                <a href="#" onClick="<%=auxSTR%>" class="tile half bg-darkRed" title="dúvidas...">
                    <div class="tile-content icon">
                    	<span class="icon-info"></span>
                    </div>
                </a>
                <a href="#" onClick="<%=auxSTR%>" class="tile half bg-darkBlue" title="problemas...">
                    <div class="tile-content icon">
                    	<span class="icon-bug"></span>
                    </div>
                </a>
                <a href="#" onClick="<%=auxSTR%>" class="tile half bg-green" title="alterações...">
                    <div class="tile-content icon">
                    	<span class="icon-puzzle"></span>
                    </div>
                </a>
                <a href="#" onClick="<%=auxSTR%>" class="tile half bg-darkPink" title="sugestões...">
                    <div class="tile-content icon">
                    	<span class="icon-bookmark-3"></span>
                    </div>
                </a>
<!-- end small tiles ---------------------------------------------------------------------------//-->
                <a  onClick="window.open('VerifySSL.asp', 'Pagina', 'STATUS=NO, TOOLBAR=NO, LOCATION=NO, DIRECTORIES=NO, RESISABLE=NO, SCROLLBARS=YES, TOP=10, LEFT=10, WIDTH=300, HEIGHT=200');return false();" class="tile double bg-white" title="link para visualizar certificado">
                    <div class="tile-content image" style="padding-top:16px; padding-left:20px;">
                    <img src='img/img_certificado_ssl.jpg'>
                    </div>
                    <div class="brand" >
                    	<div class="label fg-black">Certificado SSL</div>
               		</div>
                </a>
                
                <a href="#" class="tile double bg-lightGree">
                    <div class="tile-content image">
                    	<img src="_metroUI/images/windows_8_default_13_wallpaper.jpg">
                    </div>
                    <div class="brand">
                    	<div class="label">BEM-VINDO!</div>
                    </div>
                </a>
<!-- end double tiles  ---------------------------------------------------------------------------//-->

          <!--  <a href="modulo_GenericPainel/default.asp?var_tileview=MOBILE" onClick="" class="tile half bg-silver" title="Painel Mobile...">
                <div class="tile-content icon bg-white">
                    	<span class="icon-bookmark-3 fg-black"></span>
                    </div> <!-- end tile -->
        <!--     </a//-->
     <%   
    if  (NOT objRS.eof) then
				   objRS.MoveFirst
                   if (CInt(GetValue(objRS,"QTDE_PAINEL")) > 0) then 
						MontaTileSemGroup "", "ATALHOS", "PAINEL"
                   End if
			   
	   %>   
        
        </div>
 <!-- End group -------------------------------------------------------------------------------------//-->

 
			<%'------------Laço que cria os atalhos (publicos-verdes)------------- 
				'if  (NOT objRS.eof) then
				   objRS.MoveFirst
                   if (CInt(GetValue(objRS,"QTDE_PUBLIC")) > 0) then 
						MontaTileGroup "tile-group six", "ATALHOS", "PUBLIC"
                   End if
				   
			'------------Laço que cria os atalhos (private-azul escuro)------------	   
				   If strUSROCULTO =1 then
					   objRS.MoveFirst
					   if (CInt(GetValue(objRS,"QTDE_PRIVATE")) > 0) then 
							MontaTileGroup "tile-group two", "EXTRAS", "PRIVATE"
					   End if
				   end if
	end if
			%>
	</div>
	
</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>


