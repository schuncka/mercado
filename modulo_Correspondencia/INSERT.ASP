<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Cadastro",Session("ID_USER")), true %>
<%
 Const LTB = "TBL_EVENTO_CORRESP"	   	 ' - Nome da Tabela...
 Const DKN = "ID_AUTO"          ' - Campo chave...
 Const TIT = "Correspondencia"   		 ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

 
 
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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_Correspondencia/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_Correspondencia/insert.asp"; 
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
function viewdoc(doc) {
  var conteudo = '';
  
  if(doc!='') {
    conteudo = eval('document.forminsert.dbvar_str_' + doc + '.value');
  }
  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}
/*function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}*/

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
	<form name="forminsert" id="forminsert" action="../_database/athinserttodb.asp" method="post">
		<input type="hidden" name="DEFAULT_TABLE"	 value="<%=LTB%>">
		<input type="hidden" name="DEFAULT_DB"		 value="<%=CFG_DB%>">
		<input type="hidden" name="FIELD_PREFIX" 	 value="DBVAR_">
		<input type="hidden" name="RECORD_KEY_NAME"	 value="<%=DKN%>">
		<input type="hidden" name="DEFAULT_LOCATION" value="">
		<div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
            <li class=""><a href="#RESUMO">RESUMO</a></li>                           
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                	<div class="row ">
                        <div class="span2" style=""><p>Cód. Evento:</p></div>
                        <div class="span8">
                            <p class="input-control select text" data-role="input-control">
                                <select name="DBVAR_INT_COD_EVENTO" id="DBVAR_INT_COD_EVENTO" >
                                 <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL ORDER BY COD_EVENTO", "COD_EVENTO", "NOME", Session("COD_EVENTO")%>
                                </select>
                            </p>                                         
                             <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                        </div> 
                     </div>                	
                    <div class="row">
                        <div class="span2"><p>*Titulo:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                    <input id="DBVAR_STR_TITLEô" name="DBVAR_STR_TITLEô" type="text" placeholder="" value="" maxlength="250" >
                                </p>
                            </div>
                            <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>*Texto:</p></div>
                        <div class="span8"> 
                            <div class="input-control textarea " data-role="input-control">
                                <p>
                                    <textarea id="DBVAR_STR_TEXTOô" name="DBVAR_STR_TEXTOô" type="text" placeholder="" ></textarea>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>                                                 
                        </div>
                    </div>    
                    <div class="row">
                        <div class="span2"><p>*Tipo:</p></div>
                        <div class="span8">
                            <div class="">
                                <p class="input-control select " data-role="input-control">
                                    <select  id="DBVAR_STR_TIPO" name="DBVAR_STR_TIPO" type="text">
                                        <option value="">Todos</option>
                                        <option value="EXPOSITOR" >Expositor</option>
                                        <option value="MONTADOR"  >Montador</option>
                                        <option value="PALESTRANTE" >Palestrante</option>
                                    </select>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>                                                 
                        </div>
                    </div>         
                </div><!--fim grid geral//-->
            </div><!--fim frame dados//-->
            <div class="frame" id="RESUMO" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                   <div class="row">
                        <div class="span2"><p>Resumo:</p></div>
                        <div class="span8"> 
                            <div class="input-control textarea " data-role="input-control">
                                <p>
                                    <textarea id="DBVAR_STR_RESUMO" name="DBVAR_STR_RESUMO" type="text" placeholder="" ></textarea>
                                </p>
                                <span class="tertiary-text-secondary">(end_cidade)</span>
                            </div>                                                 
                        </div>
                    </div>   
                    <div class="row">
                        <div class="span2"><p>Cod. Empresa:</p></div>
                        <div class="span8">
                            <div class="">
                                <p class="input-control text" data-role="input-control">
                                   <input id="DBVAR_STR_COD_EMPRESA" name="DBVAR_STR_COD_EMPRESA" type="text" placeholder="" value="" maxlength="6" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>                                                 
                        </div>
                    </div>      
                    <div class="row">
                        <div class="span2"><p>Ativos(DT_INATIVO):</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO"  type="radio" value="" >
                                    Sim 
                                <input name="DBVAR_DATE_DT_INATIVO" id="DBVAR_DATE_DT_INATIVO2" type="radio" value="<%=Now()%>">
                                    Não 
                            </p>
                            <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>
                </div><!--fim grid geral//-->
            </div><!--fim frame dados//-->
  
<!--INI aba entidade ------------------------------------------------------------------------------------------------>               

		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    

    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
            <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
