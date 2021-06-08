<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"--> 
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 Dim objConn, objRS
 Dim strUserID, strSessionID, strSQL
 Dim iNOTICIA, iARTIGO, iDICA, iFAQ
 Dim arrScodi, arrSdesc
 Dim strCOD_EVENTO, strLOGO, objFile
 Dim flagMobile

 strCOD_EVENTO = getParam("cod_evento")
 ' If strCOD_EVENTO = "" Then
 strCOD_EVENTO = Request.Cookies("sysMetro")("CODEVENTO")
 ' End If

 CFG_DB = Request.Cookies("pVISTA")("DBNAME") 'DataBase (a loginverify se encarrega colocar o nome do banco no cookie)
 if ( (CFG_DB = Empty) OR (Cstr(CFG_DB) = "") ) then
	auxStr = lcase(Request.ServerVariables("PATH_INFO"))   'retorna: /aspsystems/virtualboss/proevento/login.asp ou /proevento/login.asp
	auxStr = Mid(auxStr,1,inStr(auxStr,"/login.asp")-1)    'retorna: /aspsystems/virtualboss/proevento ou /proevento
	auxStr = replace(auxStr,"/aspsystems/_pvista/","")     'retorna: proevento ou /proevento
	auxStr = replace(auxStr,"/","")                        'retorna: proevento
    CFG_DB = auxStr + "_dados"
	CFG_DB = replace(CFG_DB,"_METRO_dados","METRO_dados") 'Caso especial, banco do ambiente /_pvista n�o tem o "_" no nome "	
 end if

 AbreDBConn objConn, CFG_DB
	
 ' ------------------------------------------------------------------------
 ' Monta consulta para localizar os dados do usu�rio informado             
 ' ------------------------------------------------------------------------
  strSQL = "SELECT ID_USER, GRP_USER, NOME, EMAIL, DT_INATIVO" & _
           "  FROM tbl_USUARIO" & _
           " WHERE ID_USER = '" & strUserID & "'"

  set objRS = objConn.execute(strSQL)

 ' ------------------------------------------------------------------------
 ' Busca dados relativos as informa��es do site no banco (athcsm.mdb) 
 ' para montagem na tela principal
 ' ------------------------------------------------------------------------
 MontaArrySiteInfo arrScodi, arrSdesc
 
 flagMobile = isMobile()
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="metacssjs_root.inc"--> 
<script src="./_scripts/scriptsCS.js"></script>
<style>
 .indent { height: 40px; }
</style>
</head>
<body class="metro" onLoad="ATHSetFocus('formulario','var_userid')" background="./img/bg_login.jpg">
<div style="width:100%; height:100%; <% if (IsMobile=false) then response.write("padding:1.25em;") end if %>">
<center>
    <div class="padding20 border text-center" style="<% if (flagMobile=false) then response.write("width:25em;")  end if %>background-color:#FFF; text-align:left;">
			<% 'strLOGO = arrSdesc(ArrayIndexOf(arrScodi,"LOGOMARCA"))
			   'set objFile=Server.CreateObject("Scripting.FileSystemObject")
               'if not objFile.FileExists("C:\ftpproevento\wwwroot\" & replace(CFG_DB,"_dados","") & "\img\" & strLOGO) then  strLOGO = "" end if
			
			   'if (strLOGO = "") then %>
		  		<img src="img/logomarca_mercado.png" border="0" style="padding:20px;">
			<% 'else %>
				<!--img src="img/<%=strLOGO%>" border="0" style="padding-left:20px;"//-->
			<% 'end if %>

            <p class="description" id="_general">
                teste
            </p>
            <h3 id="_heading"><i class="icon-accessibility on-left"></i>CORRETORA MERCADO</h2>
            
            <div class="description">
				<%
                 if getParam("erro")="" then 
                   response.write ("<p class='text-muted'>Bem-vindo ao sistema de gest�o da ")
                   response.write ("<br>" & arrSdesc(ArrayIndexOf(arrScodi,"CLIENTE")) & "&nbsp;<small>(" & CFG_DB & ")</small><br></p>")
                 else
                   response.write "<p class='text-alert'><strong>ERRO</strong>:&nbsp;<small>" & Request.Form("erro") & "</small></p>"
                 end if
                %>
            </div>
                    <form name="formulario" id="formulario" action="login_verify.asp" method="post">
                        <fieldset>
                            <input type="hidden" name="var_db" id="var_db" value="<%=CFG_DB%>">
                            <input type="hidden" name="var_cod_evento" id="var_cod_evento" value="101">
                           
                            <!-- label>Usu�rio</label //-->
                            <div class="input-control text" data-role="input-control">
                                <input type="text" name="var_userid" id="var_userid" placeholder="usu�rio">
                                <button class="btn-clear" tabindex="-1"></button>
                            </div>
                            <!-- label>Senha</label //-->
                            <div class="input-control password" data-role="input-control">
                                <input type="password" name="var_senha" id="var_senha" placeholder="senha" autofocus>
                                <button class="btn-reveal" tabindex="-1"></button>
                            </div>

                            <div class="form-actions">
                               <button class="button primary" onClick="javascript:document.formulario.submit();" >Ok</button>
                               <button class="button" type="button" onClick="javascript:history.back();">Cancelar</button>
							</div>
							<input type="image" name="Submit" value="enviar" src="img/transparent.gif" width="1" height="1"> <!-- Para fazer submit com o teclar de ENTEER//-->
                        </fieldset>
                    </form>

            <!--p class="tertiary-text-secondary text-center">
                Esqueceu sua senha?! <a href="javascript:AbreJanelaPAGE('solicitacao.asp','530','300');">[clique aqui]</a>
            </p//-->
                    
	</div><!--  box/dialog //-->
</center>
</div> <!-- 100% (equiv. container) //-->
</body>
</html>
<%
 FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>