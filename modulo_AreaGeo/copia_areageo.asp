<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_AreaGeo",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_areageo"	 ' - Nome da Tabela...
 Const DKN = "id_areageo"    ' - Campo chave...
 Const TIT = "AREA GEO"        ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 Const DLD = "../moduloAreaGeo/default.asp"
 Dim objRS, objConn, strSQL
 Dim strCOD_EVENTO_ORIGEM, strCOD_EVENTO_DESTINO,strCOD_AREAGEO,VerficaAcesso 
 
 strCOD_AREAGEO = Replace(Request("var_chavereg"),"'","''")
 'athDebug strCOD_USUARIO, true
  'O usuário logado pode alterar dados seu registro, mas para
	'alterar dados de outros usuários ele deve ser ADMIN
    'if Cstr(strCOD_USUARIO) <> Cstr(session("COD_USUARIO")) then
    	 'athDebug VerficaAcesso, true
	'	  VerficaAcesso("METRO_GRP_USER")
      'VerficaAcessoOculto(Session("ID_USER"))
    'end if  

   
 AbreDBConn objConn, CFG_DB

 


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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_AreaGeo/default.asp';") 
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
<%response.Write("teste")%>
</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">INSERT CÓPIA</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	 <form name="formupdate" id="formupdate" action="copia_areageo_exec.asp" method="post">
     <input type="hidden" id="DEFAULT_LOCATION" name="DEFAULT_LOCATION" value="">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>           
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>*Evento origem: </p></div>
                                <div class="span8">  									
                                     <div class="input-control  select size5" data-role="input-control">                                        
                                     	<p><select name="DBVAR_COD_EVENTO_ORIGEM" id="DBVAR_COD_EVENTO_ORIGEM" class="">
                                        <% montaCombo "STR","SELECT COD_EVENTO, NOME FROM tbl_evento WHERE cod_evento IN (select cod_evento from tbl_areageo) ORDER BY NOME", "COD_EVENTO", "NOME","" %>
                                        </select></p>
                                    </div>
                                     <span class="tertiary-text-secondary"><br>Selecione o evento de origem para montar as áreas de CEP</span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2"><p>*Evento origem: </p></div>
                                <div class="span8">  									
                                     <div class="input-control  select size5" data-role="input-control">                                        
                                     	<p><select name="DBVAR_COD_EVENTO_DESTINO" id="DBVAR_COD_EVENTO_DESTINO" class="">
                                        <% montaCombo "STR","SELECT COD_EVENTO, NOME FROM tbl_evento WHERE cod_evento NOT IN (select cod_evento from tbl_areageo) ORDER BY NOME", "COD_EVENTO", "NOME","" %>
                                        </select></p>
                                    </div>
                                     <span class="tertiary-text-secondary"><br>Selecione o evento de destino para criação das áreas de CEP</span>
                                </div>
                     </div>                     
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
           
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    
     <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
                <div style="float:left">
                    <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
                    <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
                    <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false; ">    
                </div>
	            <div style="float:right">
    	        	<small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigatórios</small>
        	    </div>
            </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
<%
'FechaRecordSet ObjRS
'FechaDBConn ObjConn
%>