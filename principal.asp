<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"--> 
<!--#include file="_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PAINEL", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL

 Dim strUserID, strCodUser, strCOD_EVENTO, strNOME_EVENTO, strEMAIL, strNomeUser, numPerPage, prTileTipo
 Dim strURL_ENTRADA, strFlagLogin, strGrpUser, strSACUSER  
 Dim i, j, arrScodi, arrSdesc 

 strUserID		= Session("ID_USER")
 strCodUser		= Session("COD_USUARIO")
 strGrpUser     = Session("GRP_USER")
 strNomeUser	= Session("NOME_USER")
 strEMAIL       = Session("EMAIL_USER")
 
 strSACUSER     = Session("SAC_USER")
 strFlagLogin   = Session("FLAGLOGIN")

 strCOD_EVENTO	= Session("COD_EVENTO")
 strNOME_EVENTO = Session("NOME_EVENTO")
 
 strCOD_EVENTO	= "001"
 strNOME_EVENTO = "Comodities"
 
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


 ' ------------------------------------------------------------------------
 ' Busca dados relativos as informações do site no banco (athcsm.mdb) 
 ' para montagem na tela principal
 ' ------------------------------------------------------------------------
 MontaArrySiteInfo arrScodi, arrSdesc 
%>
<html>
<head>
<title>PAINEL pVISTA</title>
<!--#include file="metacssjs_root.inc"--> 
<script src="./_scripts/scriptsCS.js"></script>
</head>
<body class="metro " bgcolor="#1D1D1D">
<!-- INI: Form de aberturda de chamados PROSERVICE ------------------------------------------------------------------------------------------------------ //-->
<!--form id="formChamadoPROSERVICE" name="formChamadoPROSERVICE" action="http://proservice.proevento.com.br/proevento/default_LoginViasite.asp" target="_blank" method="post" style="display:none;">
    <input type="hidden" id='var_user'     name='var_user'     value='<%=strSACUSER%>'>
    <input type="hidden" id='var_password' name='var_password' value='athroute'>
    <input type="hidden" id='var_db'       name='var_db'       value='proevento'>
    <input type="hidden" id='var_title'    name='var_title'    value='<%=strNOME_EVENTO%>'>
    <input type="hidden" id='var_extra'    name='var_extra'    value='<%=strCOD_EVENTO & " - " & strNOME_EVENTO%>'>
</form--//>  
<!-- FIM: Form de aberturda de chamados PROSERVICE ------------------------------------------------------------------------------------------------------ //-->

<center>
<div class="" style="text-align:left;padding:20px;">

            <div class="" style="display:inline-table;width:15%;float:left"><!--primeira coluna//-->
               <a class="tile double double-vertical bg-steel live" data-role="live-tile" data-effect="slideUp" style="">
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
                        <div class="tile-status"><div class="label"><%="Login at " & Session("DT_LASTLOGIN")%></div></div>
                        </div>
                    </div>
                    <div class="tile-content ">
                        <div class="padding10">
                            <h1 class="fg-white ntm"><%="Corretora Mercado"%></h1>
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
               <a  onClick="window.open('VerifySSL.asp', 'Pagina', 'STATUS=NO, TOOLBAR=NO, LOCATION=NO, DIRECTORIES=NO, RESISABLE=NO, SCROLLBARS=YES, TOP=10, LEFT=10, WIDTH=300, HEIGHT=200');return false();" class="tile double bg-white" title="link para visualizar certificado">
                    <div class="tile-content image" style="padding-top:16px; padding-left:20px;">
	                    <img src='img/img_certificado_ssl.jpg' width='230'>
                    </div>
                    <div class="brand" ><div class="label fg-black">Certificado SSL</div></div>
                </a>
            </div>
            
            
            
			<% 
			' INI: Atalhos padrão, ou seja, todos do tipo/grupo PUBLIC ou do tipo/grupo que estiver configurado especificamente para o usuário logado  -----------------
			strSQL =		  " SELECT COD_PAINEL, ROTULO, DESCRICAO, LINK, LINK_PARAM,LINK_TARGET  "
			strSQL = strSQL & "		  ,TILE_VIEW, TILE_TYPE, TILE_BGCOLOR, TILE_ICON " 
			strSQL = strSQL & "   FROM sys_painel "  
			strSQL = strSQL & "  WHERE DT_INATIVO IS NULL AND TILE_VIEW LIKE 'PUBLIC' "
			strSQL = strSQL & "  ORDER BY ORDEM"
			AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 
			DO WHILE NOT objRS.EOF
				auxSTR = trim(GetValue(objRS, "LINK")) & trim(GetValue(objRS, "LINK_PARAM"))
				auxSTR = replaceParametersSession(auxSTR)
				
				if (instr(auxSTR,"javascript:")>0) then
					response.write ("<a href='#' onclick=""" & auxSTR & """") 
				Else
					response.write ("<a href='" & auxSTR & "' ")
					if GetValue(objRS,"LINK_TARGET") <> "" then
						response.write (" target='" & GetValue(objRS,"LINK_TARGET") & "'" ) 
					end if 
				End IF
		
				response.write (" class='tile " & trim(GetValue(objRS, "TILE_TYPE")) & " " & trim(GetValue(objRS, "TILE_BGCOLOR")) & " fg-white'") 
				response.write (" title='" & GetValue(objRS, "DESCRICAO") & "'>" & vbnewline)
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
				response.write ("</a>" 	 & vbnewline)
				objRS.MoveNext
			loop	
			' FIM: Atalhos padrão ------------------------------------------------------------------------------------------------------------------------


			' INI: Atalhos por TIPO, cria atalhos para todos os tipos/grupos distintos de atalhos existentes ---------------------------------------------
			'ATENÇÂO: Optamos por colocar esse MENU de PAINEIS no rodapé (na página NUCLEO)
			'desta froma esta comentado aqui pro compoeto apenas para ficar como histórico ou para uso futuro,
			'caso a utilização no rodapé apresente algum inconveniente. -------------------------- 03.03.2016
			'strSQL =          "SELECT DISTINCT tile_view"
			'strSQL = strSQL & "  FROM sys_painel "
			'strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
			'strSQL = strSQL & "   AND TILE_VIEW IS NOT NULL "
			'AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 
			'response.write ("<div class='grid ' style='width:100%; display:inline-table; background-color:#1D1D1D;'>")
			'response.write ("<div class='row' style='margin-top:0px; padding-top:0px;'>")
			'response.write ("<div class='span2' style=''>")
			'response.write ("<nav class='sidebar dark' style='width:250px;' >")
			'response.write ("<ul>")
			'response.write ("<li class='stick bg-yellow'>")
			'response.write ("<a class='dropdown-toggle' href='#'><i class='icon-tree-view'></i>Painéis de Atalho</a>")
			'response.write ("<ul class='dropdown-menu' data-role='dropdown'>")
			'DO WHILE NOT objRS.EOF
			'	auxSTR = "./principal_GenericPanel.asp?var_tileview="&getValue(objRS,"TILE_VIEW")
			'	response.write ("<li><a href='"& auxSTR & "'>" & getValue(objRS,"TILE_VIEW") & "</a></li>")
			'	objRS.MoveNext
			'Loop
			'response.write ("</ul>")
			'response.write ("</li>")
			'response.write ("</ul>")
			'response.write ("</nav>")
			'response.write ("</div>")
			'response.write ("</div>")
			'response.write ("</div>")
			' FIM: Atalhos por TIPO. ---------------------------------------------------------------------------------------------------------------------
			%>
</div>
<!--a href="modulo_Ajuda/default.asp" onClick="" class="tile double bg-silver" title="manuais...">
<div class="tile double bg-silver"> <img src="./img/painel_ilustracao_manuais.png" >
  <div class="brand">
    <div class="label">MANUAIS</div>
  </div>
</div>
<!-- end tile 
</a//-->
</center>
</body>
</html>
<% 
  FechaRecordSet ObjRS 
  FechaDBConn ObjConn 
%>