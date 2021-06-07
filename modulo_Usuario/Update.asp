<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_Usuario",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_usuario"	 ' - Nome da Tabela...
 Const DKN = "cod_usuario"    ' - Campo chave...
 Const TIT = "USUARIO"        ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 Const DLD = "../moduloUsuario/default.asp"
 Dim objRS, objConn, strSQL
 Dim strCOD_EVENTO,strCOD_USUARIO,VerficaAcesso 
 
 strCOD_USUARIO = Replace(Request("var_chavereg"),"'","''")
 'athDebug strCOD_USUARIO, true
  'O usuário logado pode alterar dados seu registro, mas para
	'alterar dados de outros usuários ele deve ser ADMIN
    'if Cstr(strCOD_USUARIO) <> Cstr(session("COD_USUARIO")) then
    	 'athDebug VerficaAcesso, true
	'	  VerficaAcesso("METRO_GRP_USER")
      'VerficaAcessoOculto(Session("ID_USER"))
    'end if  

   
 AbreDBConn objConn, CFG_DB
 
 
' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
strSQL = "SELECT COD_USUARIO"
strSQL = strSQL & "	 ,NOME"
strSQL = strSQL & "	 ,ID_USER "
strSQL = strSQL & "	 ,SENHA "
strSQL = strSQL & "	 ,GRP_USER "
strSQL = strSQL & "	 ,EMAIL "
strSQL = strSQL & "	 ,OCULTO "
strSQL = strSQL & "	 ,TEMPORARIO "
strSQL = strSQL & "	 ,START_GEN_ID "
strSQL = strSQL & "	 ,LAST_GEN_ID "
strSQL = strSQL & "	 ,START_CREDEXP_ID "
strSQL = strSQL & "	 ,LAST_CREDEXP_ID "
strSQL = strSQL & "	 ,START_INSC_ID "
strSQL = strSQL & "	 ,LAST_INSC_ID "
strSQL = strSQL & "	 ,DT_INATIVO "
strSQL = strSQL & "	 ,END_GEN_ID "
strSQL = strSQL & "	 ,END_INSC_ID "
strSQL = strSQL & "	 ,SAC_USER "
strSQL = strSQL & "	 ,REGISTRA_LEITURA "
strSQL = strSQL & "	 ,ID_USER_MODELO "
strSQL = strSQL & "  FROM tbl_USUARIO "
strSQL = strSQL & " WHERE COD_USUARIO = " & strCOD_USUARIO
strSQL = strSQL & " ORDER BY ID_USER "


	'strSQL = "SELECT DISTINCT tbl_USUARIO.ID_USER "
'	strSQL = strSQL & "	 , tbl_USUARIO.COD_USUARIO "
'	strSQL = strSQL & " 	 , tbl_USUARIO.NOME "
'	strSQL = strSQL & " 	 , tbl_USUARIO.SENHA "
'	strSQL = strSQL & "     , tbl_USUARIO.GRP_USER "
'	strSQL = strSQL & "     , tbl_USUARIO.EMAIL "
'	strSQL = strSQL & "	 , tbl_USUARIO.LAST_GEN_ID "
'	strSQL = strSQL & "	 , tbl_USUARIO.LAST_INSC_ID "
'	strSQL = strSQL & "	 , tbl_USUARIO.DT_INATIVO "
'	strSQL = strSQL & "     , tbl_USUARIO.OCULTO " 
'	strSQL = strSQL & "     , tbl_USUARIO.TEMPORARIO " 
'	strSQL = strSQL & "     , tbl_USUARIO.START_GEN_ID "
'	strSQL = strSQL & "     , tbl_USUARIO.LAST_GEN_ID "
'	strSQL = strSQL & "     , tbl_USUARIO.START_CREDEXP_ID "
'	strSQL = strSQL & "     , tbl_USUARIO.LAST_CREDEXP_ID "
'	strSQL = strSQL & "     , tbl_USUARIO.START_INSC_ID "
'	strSQL = strSQL & "     , tbl_USUARIO.LAST_INSC_ID "
'	strSQL = strSQL & "     , tbl_USUARIO.SAC_USER "
'	strSQL = strSQL & "     , tbl_USUARIO.ID_USER_MODELO "
'	strSQL = strSQL & "  FROM (tbl_USUARIO "
'	strSQL = strSQL & "  LEFT OUTER JOIN tbl_usuario_evento ON (tbl_usuario_evento.COD_USUARIO = tbl_USUARIO.COD_USUARIO)) " 
'	strSQL = strSQL & "  LEFT OUTER JOIN tbl_evento ON (tbl_evento.COD_EVENTO = tbl_usuario_evento.COD_EVENTO AND tbl_usuario_evento.COD_EVENTO = " & Session("COD_EVENTO") & ") " 
'	'strSQL = strSQL & " WHERE tbl_USUARIO.ID_USER =" & SESSION("ID_USER") &_
'	'strSQL = strSQL & " AND tbl_USUARIO.OCULTO = 1 " & MontaWhereAdds
'	strSQL = strSQL & " WHERE tbl_USUARIO.COD_USUARIO = " & strCOD_USUARIO
'	strSQL = strSQL & " ORDER BY tbl_USUARIO.ID_USER " 
	

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
 


%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script type="text/javascript" language="javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() {
	 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Usuario/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %>  
	/*document.formupdate.DEFAULT_LOCATION.value="../_database/athWindowClose.asp"; */
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Usuario/update.asp?var_chavereg=<%=strCOD_USUARIO%>"; 
  if (validateRequestedFields("formupdate")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.formupdate.submit(); 
  }
}
function cancelar() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("window.history.back()")
	 else
  		response.write ("window.close();")
  	 end if
 %> 
}
/* FIM: OK, APLICAR e CANCELAR, funções para action dos botões ------- */
</script>
<script type="text/javaScript">
function Trim(str){
	return str.replace(/^\s+|\s+$/g,"");
}
</script>
</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	 <form name="formupdate" id="formupdate" action="../_database/athupdatetodb.asp" method="post">
                <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
                <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_USUARIO%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
    			<input type="hidden" name="VAR_COD_USUARIO" value="<%=getValue(objRS,"COD_USUARIO")%>">    
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_USUARIO%>.GERAL</a></li>
            <li class=""><a href="#IDENTIFICA">IDENTIFICADOR</a></li>
            <li class=""><a href="#SITUACAO">SITUAÇÃO</a></li>
            <!--li class=""><a href="#MODELO">MODELO</a></li//-->
         </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>*Usuario/*Senha: </p></div>
                                <div class="span8">
  									 <%
    									If getValue(objRS,"OCULTO") = "1" Then
                                      		auxSTR = "readonly"
                                       	End If
                                    %> 
                                    	<div class="input-control text size2 info-state" data-role="input-control">
                                            <p><input <%=auxSTR%> class="" type="text" name="DBVAR_STR_ID_USER" id="var_id_user" placeholder="" value="<%=LCase(objRS("ID_USER"))%>" maxlength="50" onKeyUp="this.value = Trim( this.value )"></p>
                                        </div>
                                    	<div class="input-control text size2" data-role="input-control">
                                            <p><input class="" id="var_senhaô" name="DBVAR_STR_SENHA" type="password" value="<%=getValue(objRS,"SENHA")%>" maxlength="50"></p>                                        
                                        </div>
                                     <span class="tertiary-text-secondary"><br>Em USUARIO não usar espaços, mas sim underline EX: evento_user</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Email:</p></div>
                                <div class="span8"> 
                                    	<div class="input-control text" data-role="input-control">                                
                                     		<p><input id="var_email" name="DBVAR_STR_EMAIL" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL")%>" maxlength="50"></p>
                                    	</div>                                     
                                     <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Nome(Completo):</p></div>
                                <div class="span8"> 
                                    	<div class="input-control text info-state" data-role="input-control">                                 
                                     		<p><input id="var_nomeô" name="DBVAR_STR_NOME" type="text" placeholder="" value="<%=getValue(objRS,"NOME")%>" maxlength="80"></p>
                                    	</div>                                            
                                     <span class="tertiary-text-secondary"></span>
                                </div> 
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Grupo/Sac(user):</p></div>
                                <div class="span8">
                                     <%
									  If UCase(Session("GRP_USER")) = "ADMIN" Or Session("USER_OCULTO") = 1 Then
									 %> 
                                     <div class="input-control  select size2 info-state" data-role="input-control">                                        
                                     	<p><select name="DBVAR_STR_GRP_USER" id="var_grp_user" class="">
                                        <%MontaCombo "STR", "SELECT GRP_USER, NOME FROM tbl_USUARIO_GRUPO ORDER BY NOME","GRP_USER", "NOME",getValue(objRS,"GRP_USER")%>
                                        </select></p>
                                    </div>
                                    <%
									  Else
										Response.Write UCase(getValue(objRS,"GRP_USER"))
										Response.Write "<input name=""var_grp_user"" type=""hidden"" value=""" & getValue(objRS,"GRP_USER") & """>"
									  End If
									%> 
                                    <div class="input-control text size2" data-role="input-control">
                                            <p><input class="" id="var_sac_user" name="DBVAR_STR_SAC_USER" type="text" placeholder="" value="<%=GetValue(objRS,"SAC_USER")%>" maxlength="45"></p>
                                    </div>
                                     <span class="tertiary-text-secondary"></span>  
                                </div> 
                     </div> 
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            <div class="frame" id="IDENTIFICA" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row ">
                                <div class="span2"><p>*StartID/*LastID:</p></div>
                                <div class="span8">
                                    	<div class="input-control text size2 info-state" data-role="input-control"> 
                                        	<p>                              	
										    <%
                                              If Session("USER_OCULTO") = 1 Then
                                                Response.Write("<input class='' id='VAR_START_GEN_ID' name='DBVAR_STR_START_GEN_ID' type='text' placeholder=''  maxlength='11' value='" & getValue(objRS,"START_GEN_ID") & "'>")
                                              Else
                                                Response.Write(getVAlue(objRS,"START_GEN_ID"))
                                              End If
                                            %>
                                        	</p>
                                    	</div>
                                    	<div class="input-control text size2 info-state" data-role="input-control"> 
                                        	<p>                              	
											<% 
                                             If Session("USER_OCULTO") = 1 Then
                                                Response.Write("<input class='' id='VAR_LAST_GEN_ID' name='DBVAR_STR_LAST_GEN_ID' type='text' placeholder=''  maxlength='11' value='" & getValue(objRS,"LAST_GEN_ID") & "'>")
                                              Else
                                                Response.Write(objRS("LAST_GEN_ID"))
                                              End If
                                            %> 
                                        	</p>
                                    	</div>
                                     <span class="tertiary-text-secondary"> Início/Final ID (identificador) gerado para [credenciamento]</span>
                                </div>
                     </div> 
                      <div class="row ">
                                <div class="span2"><p>*StartID/ *LastID (800):</p></div>
                                <div class="span8">
                                    	<div class="input-control text size2 " data-role="input-control"> 
                                        	<p>                              	                                
										   <%
                                              If Session("USER_OCULTO") = 1 Then
                                                Response.Write("<input class='' id='var_start_credexp_id' name='DBVAR_STR_START_CREDEXP_ID' type='text' placeholder='' maxlength='11' value=""" & getValue(objRS,"START_CREDEXP_ID") & """>")
                                              Else
                                                Response.Write(getVAlue(objRS,"START_CREDEXP_ID"))
                                              End If
                                            %>
                                        	</p>
                                    	</div>
                                    	<div class="input-control text size2" data-role="input-control"> 
                                        	<p>                              	                                                                    
											<% 
                                             If Session("USER_OCULTO") = 1 Then
                                                Response.Write("<input class='' id='var_last_credexp_id' name='DBVAR_STR_LAST_CREDEXP_ID' type='text' placeholder=''  maxlength='11' value=""" & getValue(objRS,"LAST_CREDEXP_ID") & """>")
                                              Else
                                                Response.Write(getValue(objRS,"LAST_CREDEXP_ID"))
                                              End If
                                            %> 
                                        	</p>
                                    	</div>
                                     <span class="tertiary-text-secondary"> Início/Final ID (identificador) gerado [credenciamento expresso]</span>
                                </div>
                     </div> 
                      <div class="row ">
                                <div class="span2"><p>*StartID(/*LastID:</p></div>
                                <div class="span8">
                                    	<div class="input-control text size2" data-role="input-control"> 
                                        	<p>                              	                                                                
											   <%
                                                  If Session("USER_OCULTO") = 1 Then
                                                    Response.Write( "<input class='' id='var_start_insc_id' name='DBVAR_STR_START_INSC_ID' type='text' placeholder=''  maxlength='11' value=""" & getValue(objRS,"START_INSC_ID") & """>")
                                                  Else
                                                    Response.Write(getVAlue(objRS,"START_INSC_ID"))
                                                  End If
                                                %>
                                        	</p>
                                    	</div>
                                    	<div class="input-control text size2" data-role="input-control">
                                        	<p>                                                                             
											<% 
                                             If Session("USER_OCULTO") = 1 Then
                                                Response.Write("<input class='' id='var_last_insc_id' name='DBVAR_STR_LAST_INSC_ID' type='text' placeholder=''  maxlength='11' value=""" & getValue(objRS,"LAST_INSC_ID") & """>")
                                              Else
                                                Response.Write(getValue(objRS,"LAST_INSC_ID"))
                                              End If
                                            %> 
                                        	</p>
                                    	</div>
                                     <span class="tertiary-text-secondary">Início/Final ID (identificador) gerado [inscrição]</span>
                                </div>
                     </div> 
                     
               	</div><!--fim grid layout//-->
            </div><!--fim frame layout//-->  
            <div class="frame" id="SITUACAO" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                   <div class="row ">
                                 <div class="span2"><p>Status:</p></div>
                                <div class="span8"><p>
                                    <input type="radio"   name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO1"  value="NULL" <%if Trim(GetValue(objRS,"DT_INATIVO")) = "" then response.Write("checked") end if %> >
                                    Ativo&nbsp;
                                    <input  type="radio"  name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO2"  value="<%=Date()%>" <%if Trim(GetValue(objRS,"DT_INATIVO")) <> "" then response.Write("checked") end if %>>
                                    Inativo
                                    </p><span class="tertiary-text-secondary"><!--aqui comentário sobre o campo se necessario//--></span>
                                </div>
                     </div>
                    <div class="row">
                        <div class="span2" style=""><p>Temporário:</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_NUM_TEMPORARIO" id="DBVAR_NUM_TEMPORARIO" type="radio" value="1" <% If getValue(objRS,"TEMPORARIO")= "1" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_NUM_TEMPORARIO" id="DBVAR_NUM_TEMPORARIO2" type="radio" value="0" <% If getValue(objRS,"TEMPORARIO")= "0" Then Response.Write("checked") End If %>>
                                    Não 
                            </p>
                            <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                  
                     <div class="row ">
                                <div class="span2"><p>Registra Leitura:</p></div>
                                <div class="span8"><p>
                                    <input name="DBVAR_NUM_REGISTRA_LEITURA" id="DBVAR_STR_REGISTRA_LEITURA" type="radio"  value="1" <%if GetValue(objRS,"REGISTRA_LEITURA") = "1" then response.Write("checked") end if %>>
                                    Sim&nbsp;
                                    <input name="DBVAR_NUM_REGISTRA_LEITURA" id="DBVAR_STR_REGISTRA_LEITURA2"  type="radio"  value="0" <%if GetValue(objRS,"REGISTRA_LEITURA") = "0" then response.Write("checked") end if %>>
                                    Não
                                    </p><span class="tertiary-text-secondary"><!--aqui comentário sobre o campo se necessario//--></span> 
                                </div>
                     </div> 
                     <!--<div class="row ">
                                <div class="span2" style=""><p>Cód. Evento:</p></div>
                                <div class="span8"><p class="input-control select text" data-role="input-control">
                                     <select name="DBVAR_INT_COD_EVENTO" id="DBVAR_INT_COD_EVENTO" >
                                         <option value="" selected="selected"></option>
                                         <'% montaCombo "STR" ,"SELECT DISTINCT SU.ID_USER, TU.GRP_USER FROM SYS_APP_DIREITO_USUARIO AS SU , TBL_USUARIO AS TU ORDER BY 1", "SU.ID_USER", "NOME", strDIRUSER %>
                                    	</select></p>                                         
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                <!--/div> 
                     </div>//-->
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            <%' <div class="frame" id="MODELO" style="width:100%;">
              '  <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
              '  <div class="grid" style="border:0px solid #F00">
              '     <div class="row ">
              '                  <div class="span2" style=""><p>*ID User Modelo:</p></div>
              '                  <div class="span8">
              '                      	<div class="input-control select" data-role="input-control">                                
              '                               <p><select name="DBVAR_STR_ID_USER_MODELO" id="DBVAR_STR_ID_USER_MODELO" class="">
              '                                <option value="" selected>[Selecione}</option>
              '                                <%montaCombo "STR" ,"SELECT ID_USER, CONCAT(CAST(ID_USER AS CHAR), ' - ', CAST(COD_USUARIO AS CHAR)) AS COD_USUARIO FROM tbl_usuario WHERE DT_INATIVO IS NULL", "ID_USER", "ID_USER", getValue(objRS,"ID_USER_MODELO") 
              '                                </select></p>
              '                      	</div>
              '                       <span class="tertiary-text-secondary"><br>Copia os DIREITO do usuario marcado no combo(EM MANUTENÇÂO).</span>  
              '                  </div> 
              '       </div>  
              '	</div><!--fim grid layout//-->
            '</div><!--fim frame layout//-->  %>
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    
    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
            <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e (*)</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
<%
FechaRecordSet ObjRS
FechaDBConn ObjConn
%>