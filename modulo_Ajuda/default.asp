<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 Dim objConn, objRS, strSQL
 Dim strUserID, strCodUser,  strCOD_EVENTO, strNOME_EVENTO,strEMAIL,strNomeUser,numPerPage,StrMENUOld
 Dim strURL_ENTRADA, strFlagLogin, strGrpUser, strSACUSER,strUSROCULTO,StrMENUNew,strIDApp,strLink,objFolder,Local,ObjFS,Folder
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


 
 AbreDBConn objConn, CFG_DB
'------------------------------------------------------------------------------
' If strFlagLogin="True" then
'   strSQL = "SELECT URL_ENTRADA FROM tbl_USUARIO_GRUPO WHERE GRP_USER = '" & strGrpUser & "'"
'   Set objRS = objConn.Execute(strSQL)
'   If not objRS.EOF Then
'     strURL_ENTRADA = getValue(objRS,"URL_ENTRADA")
'   End If
'   FechaRecordSet objRS
'   If strURL_ENTRADA <> "" Then
'     Session("FLAGLOGIN") = "False"
'	 FechaDBConn ObjConn
'     Response.redirect(strURL_ENTRADA)
'   End If
' End If 
 
  ' ------------------------------------------------------------------------
 ' Busca dados relativos as informações do site no banco (athcsm.mdb) 
 ' para montagem na tela principal
 ' ------------------------------------------------------------------------
 MontaArrySiteInfo arrScodi, arrSdesc 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro" bgcolor="#1D1D1D">
<!-- INI: Aberturda de chamados VBOSS ------------------------------------------------------------------------------------------------------ //-->
<form id="formChamadoVBOSS" name="formChamadoVBOSS" action="http://virtualboss.proevento.com.br/proevento/default_LoginViasite.asp" target="_blank" method="post" style="display:none;">
    <input type="hidden" id='var_user'     name='var_user'     value='<%=strSACUSER%>'>
    <input type="hidden" id='var_password' name='var_password' value='athroute'>
    <input type="hidden" id='var_db'       name='var_db'       value='proevento'>
    <input type="hidden" id='var_title'    name='var_title'    value='<%=strNOME_EVENTO%>'>
    <input type="hidden" id='var_extra'    name='var_extra'    value='<%=strCOD_EVENTO & " - " & strNOME_EVENTO%>'>
</form>  
<!-- FIM: Aberturda de chamados VBOSS ------------------------------------------------------------------------------------------------------ //-->

<!--<div class="tile-area tile-area-dark" style="padding-top:20px;">
<h1 class="tile-area-title fg-white"></h1>//-->
<center>
<div class="" style="text-align:left;padding:20px;">

                    <div class="" style="display:inline-table;width:15%;float:left"><!--primeira coluna//-->
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
                            <div class="tile-status"><div class="label"><%="Login at " & Session("DT_LASTLOGIN")%></div>
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
                            <div class="tile-status"><div class="label"><%="Login at " & Request.ServerVariables("REMOTE_HOST")%></div></div>
                        </div>
                        </a> 
                    <!-- FIN: Tile Painel de Dados ------------------------------------------------------------------------------------//-->                 
                    </div>
                    <div class="" style="display:inline-table;width:15%; float:left"><!--segunda coluna//-->
                        <a href="../principal.asp" onClick="" class="tile double bg-silver" title="manuais...">
                            <div class="tile double bg-silver">
                                <img src="../img/painel_ilustracao_painel.png" >
                                <div class="brand">
                                        <div class="label">PAINEL </div>	
                                    </div>
                            </div> <!-- end tile -->
                         </a>
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
                    </div>                
        <!-- end small tiles ---------------------------------------------------------------------------//-->
                    
 <!-- End group -------------------------------------------------------------------------------------//-->
                <%
                      Local = server.mappath("../")
                        Set ObjFS = Server.CreateObject("Scripting.FileSystemObject")
                        Set objFolder = ObjFS.GetFolder(Local)
                        
                        'Deve exibir pastas encontradas
                        
                        For Each Folder in objFolder.Subfolders
                            If (InStr(lcase(Folder.Name),"modulo_"))>0	and  Lcase(Folder.name) <> "modulo_ajuda" and  Lcase(Folder.name) <> "modulo_dbmanager"  then
                            response.Write("<a href='../"&Folder.Name&"/help' title='"&Folder.Name&"'>")
                                response.Write("<div class='tile half' style='background:#666;'>")
                                response.Write("<div class='tile-status'>")
                                response.Write("<span class='text'>")
                                 Response.Write Replace(mid(Folder.Name,8,7),"modulo_","")
                                 response.Write("</span>")
                                 response.Write("</div>")
                                 response.Write("</div>")
                                response.Write("</a>")
                             End If
                        Next
                %>

			<div class='' style='width:100%; display:inline-table; background-color:#1D1D1D;'>
                <div class='row'>
                    <div class='' style='width:100%'>
                    <a class="tile " onClick="window.open('../../_manual/METRO_ManualDesenvDesign.pdf', 'Pagina', 'STATUS=NO, TOOLBAR=NO, LOCATION=NO, DIRECTORIES=NO, RESISABLE=NO, SCROLLBARS=YES, TOP=10, LEFT=10, WIDTH=800, HEIGHT=600');return false();"   title="Manual Desenv. pVISTA Metro" style=" background:#666;z-index:10;">
                        <div class="tile-content text" style="width:100%;background:#666;position:inherit;float:right;">
                            <div class="bg-transparent" style="float:left; position:absolute; width:100%;height:100%;z-index:6">
                            	<span style="font-size:190px;"><i class="icon-help-2 fg-gray"></i></span>
                            </div>
                            <div class="item-title fg-white" style="padding-left:10px;padding-top:20px;z-index:8; position:inherit">DESIGN STANDARDS</div>
                            <div class="brand" style="padding-left:10px;padding-bottom:20px;z-index:7;">
                            	<p class="item-title-secundary fg-white"></p>
                            	<p class="tertiary-text fg-white no-margin">Development</p>
                            </div>
                        </div>
                    </a>
                    <a class="tile" onClick="window.open('../../_manual/METRO_ManualDesenvCode.pdf', 'Pagina', 'STATUS=NO, TOOLBAR=NO, LOCATION=NO, DIRECTORIES=NO, RESISABLE=NO, SCROLLBARS=YES, TOP=10, LEFT=10, WIDTH=800, HEIGHT=600');return false();"   title="Manual Desenv. pVISTA Metro" style=" background:#666;">
                        <div class="tile-content text" style="width:100%;background:#666;position:inherit;float:right;">
                            <div class="bg-transparent" style="float:left; position:absolute; width:100%;height:100%;z-index:6">
                                <span style="font-size:190px;"><i class="icon-help-2 fg-gray"></i></span>
                            </div>
                            <div class="item-title fg-white" style="padding-left:10px;padding-top:20px;z-index:8; position:inherit">CODE STANDARDS</div>
                            <div class="brand" style="padding-left:10px;padding-bottom:20px;z-index:7;">
                                <p class="item-title-secundary fg-white"></p>
                                <p class="tertiary-text fg-white no-margin">Development</p>
                            </div>
                        </div>
                    </a>   
                    <a class="tile" onClick="window.open('../../_manual/index.html', 'Pagina', 'STATUS=NO, TOOLBAR=NO, LOCATION=NO, DIRECTORIES=NO, RESISABLE=NO, SCROLLBARS=YES, TOP=10, LEFT=10, WIDTH=800, HEIGHT=600');return false();"  title="Manual Pvista Metro Geral" style=" background:#666;">
                        <div class="tile-content text" style="width:100%;background:#666;position:inherit;float:right;">
                            <div class="bg-transparent" style="float:left; position:absolute; width:100%;height:100%;z-index:6">
                            	<span style="font-size:190px;"><i class="icon-help-2 fg-gray"></i></span>
                            </div>
                            <div class="item-title fg-white" style="padding-left:10px;padding-top:20px;z-index:8; position:inherit">OPERATION GUIDE</div>
                            <div class="brand" style="padding-left:10px;padding-bottom:20px;z-index:7;">
                            	<p class="item-title-secundary fg-white"></p>
                            	<p class="tertiary-text fg-white no-margin">Users</p>
                            </div>
                        </div>
                    </a>
                    <a class="tile" onClick="window.open('../../_manual/METRO_ManualUserInterface.pdf', 'Pagina', 'STATUS=NO, TOOLBAR=NO, LOCATION=NO, DIRECTORIES=NO, RESISABLE=NO, SCROLLBARS=YES, TOP=10, LEFT=10, WIDTH=800, HEIGHT=600');return false();"  title="Manual Pvista Metro Geral" style=" background:#666;">
                        <div class="tile-content text" style="width:100%;background:#666;position:inherit;float:right;">
                            <div class="bg-transparent" style="float:left; position:absolute; width:100%;height:100%;z-index:6">
                            	<span style="font-size:190px;"><i class="icon-help-2 fg-gray"></i></span>
                            </div>
                            <div class="item-title fg-white" style="padding-left:10px;padding-top:20px;z-index:8; position:inherit">INTERFACE GUIDE</div>
                            <div class="brand" style="padding-left:10px;padding-bottom:20px;z-index:7;">
                            	<p class="item-title-secundary fg-white"></p>
                            	<p class="tertiary-text fg-white no-margin">Users</p>
                            </div>
                        </div>	
                    </a>  
                    </div>
                </div>
			</div>
</div>
    <script src="_metroUI/js/hitua.js"></script>
</center>    
</body>
</html>
