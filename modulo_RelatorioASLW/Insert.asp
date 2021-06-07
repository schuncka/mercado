<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_RelatorioASLW",Session("METRO_USER_ID_USER")), true %>
<%
 
 Const MDL = "DEFAULT"                  ' - Default do Modulo...
 Const LTB = "tbl_aslw_relatorio"	    ' - Nome da Tabela...
 Const DKN = "COD_RELATORIO"            ' - Campo chave...
 Const DLD = "../modulo_RelatorioASLW"  ' "../relatorio_aslw/data.asp" 'Default Location após Deleção
 Const TIT = "Relatorio ASLW"           ' Carrega o titulo do modulo no botão filtro
 
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
	  document.forminsert.DEFAULT_LOCATION.value="../modulo_RelatorioASLW/insert.asp"; 
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
<!--
/*function Grava() {
	var form = forminsert;
	
	if (form.radExecDefault.checked) {
		form.DBVAR_STR_EXECUTOR.value = 'ExecASLW.asp';
	}
	else {
		form.DBVAR_STR_EXECUTOR.value = form.txtExecutor.value;
	}

	form.submit();
}*/

//-->
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
                        <form name="forminsert" id="forminsert" action="../_database/athInsertTODB.asp" method="POST">
                        <input type="hidden" name="DEFAULT_TABLE" value=<%=LTB%>>
                        <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                        <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                        <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                        <input type="hidden" name="DEFAULT_LOCATION" value="<%=DLD%>">
                        <input name="DBVAR_AUTODATE_DT_CRIACAO" type="hidden" value="">
                        <input name="DBVAR_STR_SYS_CRIA" type="hidden" value="<%=Session("METRO_USER_ID_USER")%>">
                        <div class="tab-control" data-effect="fade" data-role="tab-control">
                            <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                                <li class="active"><a href="#DADOS">GERAL</a></li>
                                <li class="#"><a href="#CONSULTA">CONSULTA</a></li>
                             </ul>   
                            <div class="frames">
                                <div class="frame" id="DADOS" style="width:100%;">
                                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                                    <div class="grid" style="border:0px solid #F00">
                                    <div class="row ">
                                                    <div class="span2" style=""><p>Categoria:</p></div>
                                                    <div class="span8">
                                                         <p class="input-control text select" data-role="input-control">
                                                         <select name="DBVAR_NUM_COD_CATEGORIA" id="DBVAR_NUM_COD_CATEGORIA" >
                                                       <option value="" selected>[Selecione}</option>
                                                           <%montaCombo "STR" ," SELECT COD_CATEGORIA, NOME FROM tbl_ASLW_CATEGORIA ORDER BY NOME ", "COD_CATEGORIA", "NOME", "" %>
                                                        </select>
                                                         <span class="tertiary-text-secondary"></span>  
                                                    </div> 
                                         </div>   
                                         <div class="row ">
                                                    <div class="span2" style=""><p>Nome:&nbsp;</p></div>
                                                    <div class="span8"> 
                                                         <p class="input-control text info-state" data-role="input-control"><input name="DBVAR_STR_NOME" id="DBVAR_STR_NOMEô" type="text" class="textbox250" value=""></p>
                                                         <span class="tertiary-text-secondary"></span>                             
                                                    </div>
                                         </div> 
                                         <div class="row ">
                                                    <div class="span2" style=""><p>Descrição:&nbsp;</p></div>
                                                    <div class="span8">  
                                                         <p class="input-control textarea " data-role="input-control"><textarea name="DBVAR_STR_DESCRICAO" id="DBVAR_STR_DESCRICAO" cols="40" rows="6"></textarea></p>
                                                         <span class="tertiary-text-secondary"></span>
                                                    </div> 
                                         </div>
                                    </div><!--fim grid layout//-->
                                </div><!--fim frame layout//-->
                                 <div class="frame" id="CONSULTA" style="width:100%;">
                                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                                    <div class="grid" style="border:0px solid #F00">
                                     <div class="row">
                                     	<div class="span2"><p>Executor:</p></div>
                                        <div class="span8"><p class="input-control text info-state"><input type="text" name="DBVAR_STR_EXECUTOR" id="DBVAR_STR_EXECUTORô" class="size3" value="ExecASLW.asp"></p>
                                        	<span class="tertiary-text-secundary">Executor Padrão: ExecASLW.asp</span>
                                        </div>
                                     </div>
                                          <div class="row ">
                                                    <div class="span2" ><p>Parâmetro:&nbsp;</p></div>
                                                    <div class="span8">  
                                                         <p class="input-control textarea info-state" data-role="input-control"><textarea name="DBVAR_STR_PARAMETRO" id="DBVAR_STR_PARAMETROô" cols="40" rows="6"></textarea></p>
                                                         <span class="tertiary-text-secondary">
                                                            Consulta SQL que permite a colocação de variáveis ambiente (com o uso de chaves { }) e parâmetros de filtragem (com o uso de colchetes [ ])<br> 
                                                            <b>Ex.:</b> SELECT cod_inscricao FROM tbl_inscricao WHERE cod_evento = {METRO_EVENTO_COD_EVENTO} and nomecompleto LIKE '[por_nome]'  
                                                         </span>
                                                    </div> 
                                         </div>  
                                    <div class="row ">
                                        <div class="span2"><p>Inativado em:</p></div>
                                        <div class="span8">
                                            <p>
                                                <input type="radio"   name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO1"  value="NULL"  checked/>
                                                Ativo&nbsp;
                                                <input  type="radio"  name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO2" value="<%=Date()%>"  />
                                                Inativo
                                            </p>
                                        	<span class="tertiary-text-secondary"><!--aqui comentário sobre o campo se necessario//--></span> 
                                        </div>
                                        </div> 
                                    </div><!--fim grid layout//-->
                                </div><!--fim frame layout//-->  
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
