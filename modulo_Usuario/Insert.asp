<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Usuario",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_usuario"	 ' - Nome da Tabela...
 Const DKN = "cod_usuario"    ' - Campo chave...
 Const TIT = "USUARIO"        ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 Dim objRS, objConn, strSQL
 Dim strCOD_EVENTO,strIDUSERMODELO


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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar() { 
  if (validateRequestedFields("forminsert")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.forminsert.submit(); 
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
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">INSERT</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
    <form name="forminsert" id="forminsert" action="insertexec.asp" method="POST">
    <input type="hidden" name="DEFAULT_LOCATION" value="INSERT.asp">    
   
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
            <li class=""><a href="#IDENTIFICA">IDENTIFICADOR</a></li>            
            <li class=""><a href="#SITUACAO">SITUAÇÂO</a></li>
            <!--li class=""><a href="#MODELO">MODELO</a></li//-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>*Usuario/*Senha:</p></div>
                                <div class="span8">
                                    	<div class="input-control text size2 info-state" data-role="input-control">                               
                                    		 <p><input class="" id="var_id_userô" name="var_id_user" type="text" placeholder=""  value=""  maxlength="50" onKeyUp="this.value = Trim( this.value )"></p>
                                    	</div>
                                    	<div class="input-control text size2 info-state" data-role="input-control">                                                                                     
                                    		 <p><input class="" id="var_senhaô" name="var_senha" type="password" placeholder="password" value=""  maxlength="50"></p>
                                    	</div>                                             
                                     <span class="tertiary-text-secondary"><br>Em USUARIO não usar espaços, mas sim underline EX: evento_user</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>Email:</p></div>
                                <div class="span8">
                                    	<div class="input-control text " data-role="input-control">                                 
                                     		<p><input id="var_email" name="var_email" type="text" placeholder="" value="" maxlength="50"></p>
                                    	</div>                                            
                                     <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Nome(Completo):</p></div>
                                <div class="span8">  
                                    	<div class="input-control text info-state" data-role="input-control">                                 
                                     		<p><input id="var_nomeô" name="var_nome" type="text" placeholder="" value="" maxlength="80"></p>
                                    	</div>
                                     <span class="tertiary-text-secondary"></span>
                                </div> 
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Grupo/Sac(user):</p></div>
                                <div class="span8">
                                    	<div class="input-control select size2 info-state" data-role="input-control">                                 
                                     		<p><select name="var_grp_user" id="var_grp_userô" class="">
                                   			<option value="" selected>[Selecione}</option>
										   <%MontaCombo "STR", "SELECT GRP_USER, NOME FROM tbl_USUARIO_GRUPO ORDER BY NOME","GRP_USER", "NOME", null%>
                                   			</select></p>
                                    	</div>
                                    	<div class="input-control text size2" data-role="input-control">                                 
                                     		<p><input class="" id="var_sac_user" name="var_sac_user" type="text" placeholder="" value="" maxlength="45"></p>
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
                                <div class="span2">
                                  <p>*StartID(credenciado)/ *StartID(incrição):</p></div>
                                <div class="span8">
                                    	<div class="input-control text size2 info-state" data-role="input-control">                                 
                                     		<p><input class="" id="var_GenIDô" name="var_GenID" type="text" placeholder="" value="100000" maxlength="6" ></p>
                                    	</div>
                                    	<div class="input-control text size2 info-state" data-role="input-control">
                                     		<p><input class="" id="var_InscIDô" name="var_InscID" type="text" placeholder="" value="800000" maxlength="6"></p>
                                    	</div>                                            
                                     <span class="tertiary-text-secondary"> Início ID (identificador) gerado (credenciamento) / (inscrito)</span>
                                </div>
                     </div> 
                      <div class="row ">
                                <div class="span2"><p>*StartID/ *LastID (800):</p></div>
                                <div class="span8">
                                    	<div class="input-control text size2" data-role="input-control"> 
                                        	<p><input class="" id="var_start_credexp_id" name="DBVAR_STR_START_CREDEXP_ID" type="text" placeholder="" maxlength="11" value=""></p>
                                    	</div>
                                    	<div class="input-control text size2" data-role="input-control"> 
                                        	<p><input class="" id="var_last_credexp_id" name="DBVAR_STR_LAST_CREDEXP_ID" type="text" placeholder=""  maxlength="11" value=""></p>
                                    	</div>
                                     <span class="tertiary-text-secondary"> Início/Final ID (identificador) gerado [credenciamento expresso]</span>
                                </div>
                     </div> 
                      <div class="row ">
                                <div class="span2"><p>*StartID(/*LastID:</p></div>
                                <div class="span8">
                                    	<div class="input-control text size2" data-role="input-control"> 
                                        	<p><input class="" id="var_start_insc_id" name="DBVAR_STR_START_INSC_ID" type="text" placeholder=""  maxlength="11" value=""></p>
                                    	</div>
                                    	<div class="input-control text size2" data-role="input-control">
                                        	<p><input class="" id="var_last_insc_id" name="DBVAR_STR_LAST_INSC_ID" type="text" placeholder=""  maxlength="11" value=""></p>
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
                                    <input name="var_status" id="var_status" type="radio" value="Ativo" checked> 
                                    Ativo&nbsp;
                                    <input name="var_status" id="var_status" type="radio" value="Inativo">
                                    Inativo
                                    </p><span class="tertiary-text-secondary"><!--aqui comentário sobre o campo se necessario//--></span> 
                                </div>
                     </div>
                      <div class="row ">
                                <div class="span2"><p>Temporário:</p></div>
                                <div class="span8"><p>
                                    <input name="var_temporario" type="radio" value="True">
                                    Sim&nbsp;
                                    <input name="var_temporario" type="radio" value="False" checked>
                                    Não
                                    </p><span class="tertiary-text-secondary"><!--aqui comentário sobre o campo se necessario//--></span> 
                                </div>
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Registra Leitura:</p></div>
                                <div class="span8"><p>
                                    <input name="var_registra_leitura" type="radio" value="1">
                                    Sim&nbsp;
                                    <input name="var_registra_leitura" type="radio" value="0" checked>
                                    Não
                                    </p><span class="tertiary-text-secondary"><!--aqui comentário sobre o campo se necessario//--></span> 
                                </div>
                     </div>
            	</div><!--fim grid layout//-->
            </div><!--fim frame layout//-->  
          <%'   <div class="frame" id="MODELO" style="width:100%;">
             '   <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
             '   <div class="grid" style="border:0px solid #F00">
             '      <div class="row ">
              '                  <div class="span2" style=""><p>ID User Modelo:</p></div>
              '                  <div class="span8">
              '                      	<div class="input-control select " data-role="input-control">                                 
              '                       		<p><select name="var_iduser_modelo" id="var_iduser_modelo" class="">
              '                                 <option value="" selected>[Selecione}</option>
              '                                     <% montaCombo "STR" ,"SELECT ID_USER, CONCAT(CAST(ID_USER AS CHAR), ' - ', CAST(COD_USUARIO AS CHAR)) AS COD_USUARIO FROM tbl_usuario WHERE DT_INATIVO IS NULL", "ID_USER", "ID_USER", strIDUSERMODELO 
              '                                  </select></p>
              '                      	</div>
              '                       <span class="tertiary-text-secondary"></span>  
              '                  </div> 
              '       </div>  
            	'</div><!--fim grid layout//-->
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
