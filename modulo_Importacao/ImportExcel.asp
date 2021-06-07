<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_database/secure.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 Const LTB = "sys_site_info"   ' - Nome da Tabela...
 Const DKN = "ID_AUTO"         ' - Campo chave...
 Const TIT = "ImportTable"     ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 Dim arrICON, arrBG , i 
 Dim objConn, objRS, objRSAux, strSQL

 AbreDBConn objConn, CFG_DB 
 
 strSQL="show tables " 
 	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 
' If Not objRS.Eof Then
 
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
 
	if (validateRequestedFields("form_principal")) { 
		document.form_principal.submit(); 
	} 
}
function aplicar()      { 
  /*document.forminsert.DEFAULT_LOCATION.value="../modulo_SiteInfo/insert.asp"; */
  if (validateRequestedFields("form_principal")) { 
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

function updateFrame(prValor){
	//alert(prValor);	
	document.getElementById("var_tables").value = prValor;
	document.getElementById("campostable").submit();
 }


function UploadImage(formname,fieldname, dir_upload) 
{
  var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
  window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

function SetFormField(formname, fieldname, valor) 
{
  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
  {
	eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
	//document.location.reload();
  }
} 
</script>
</head>
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">IMPORT</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	
    
    <form name="form_principal" id="form_principal" action="ImportExcel_exec.asp" method="post">	    
   		<input type="hidden" name="DEFAULT_LOCATION" value=''>  	
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
     <div class="row">
     <div class="span2"><p>*Tabela:</p></div>
     <div class="span8"><p class="input-control select" data-role="input-control">
               <select name="var_tabela" id="var_tabelaô" class="textbox180" onChange="updateFrame(this.value);">
                <option value="" selected>Selecione a tabela...</option>
                <%
                while not objRS.EOF
                    Response.Write("<option value="&GetValue(objRS,"tables_in_"&CFG_DB)&" >"&GetValue(objRS,"tables_in_"&CFG_DB)&"</option>")
                    objRS.Movenext
                Wend
                %>
            </select></p>
            </div>
        </div>
        
        <div class="row">
                <div class="span2"><p>Descrição:</p></div>
                <div class="span8"><iframe id="view_tables" name="view_tables" frameborder="0" style="height:100%; width:100%; "  scrolling="auto"></iframe></div>
        </div>
        
        <div class="row">
                <div class="span2"><p>*Arquivo:</p></div>
                <div class="span8">
                     <div class="input-control file">
                        <input type="text" name="var_arquivo_excel" id="var_arquivo_excelô" />
                        <button class="btn-file" onClick="javascript:UploadImage('form_principal','var_arquivo_excel','//modulo_importacao//');"></button>
                    	<span class="tertiary-text-secondary">Somente arquivos com extens&atilde;o .XLS</span>
                    </div>                     
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
        </div>
        <div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigat&oacute;rios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
    <form id="campostable" name="campostable" action="ViewTables.asp" target="view_tables">
		<input type="hidden" id="var_tables" name="var_tables">
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>























<%
' End If
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>	