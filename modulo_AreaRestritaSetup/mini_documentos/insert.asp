<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_documentos",Session("METRO_USER_ID_USER")), true %>
<%

 Const LTB = "tbl_documentos" 								    ' - Nome da Tabela...
 Const DKN = "id_documento"									        ' - Campo chave...
 Const DLD = "../modulo_AreaRestritaSetup/mini_documentos/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Edição de campos"									' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro


 Dim arrICON, arrBG , i ,strIDINFO, strSQL
 Dim objConn, objRS, strCOD_EVENTO, strLANG, strID_AUTO


strCOD_EVENTO = Replace(GetParam("var_chavemaster"),"'","''")


If strLANG = "" Then
  strLANG = "PT"
End If


AbreDBConn objConn, CFG_DB
 
 'strIDINFO = Replace(GetParam("var_chavereg"),"'","''")

%> 
<html>
<head>
<title>Mercado</title>
<script src="../../metro-calendar.js"></script>
<script src="../../metro-datepicker.js"></script>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript">

/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_AreaRestritaSetup/mini_documentos/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}

function UploadImage(formname,fieldname, dir_upload) {
    var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
    window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

function aplicar()      {  
  document.forminsert.DEFAULT_LOCATION.value="../modulo_AreaRestritaSetup/mini_documentos/insert.asp?var_chavemaster=<%=strCOD_EVENTO%>"; 
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
<script language="javascript" type="text/javascript">
//função para ativar o date picker dos campos data
$("#datepicker").datepicker( {
	date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer já  ele modifica automaticamente para data setada dentro da função//-->
	format: "dd/mm/yyyy", // set output format
	effect: "none", // none, slide, fade
	position: "bottom", // top or bottom,
	locale: ''en, // 'ru' or 'en', default is $.Metro.currentLocale
});

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

 <form name="forminsert" id="forminsert" action="../../_database/athinserttodb.asp" method="post">
    <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
    <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
    <input type="hidden" name="FIELD_PREFIX" value="dbvar_">
    <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
    <input type="hidden" name="dbvar_num_cod_evento" id="dbvar_num_cod_evento" value="<%=strCOD_EVENTO%>" >
    <input type="hidden" name="DEFAULT_LOCATION" value="">  


    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                <li class="active"><a href="#DADOS">GERAL</a></li>
            </ul>
            <div class="frames">
                <div class="frame" id="DADOS" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                    <div class="grid" style="border:0px solid #F00">

                    <!-- MONTA TABELA DOCUMENTOS AQUI -->
                        
                        <div class="row">
                            <div class="span2"><p>Documento:</p></div>
                                <div class="span3">                                     
                                    <p class="input-control text info-state" data-role="input-control">
                                        <input id="dbvar_str_documentoô" name="dbvar_str_documentoô" type="text" value="">      
                                    </p> 
                                </div> 
                                <div class="span5">   
                                    <a href="javascript:UploadImage('forminsert','dbvar_str_documento','\\AreaRestrita<% If strLANG <> "PT" Then Response.Write("Intl") End If %>\\download\\');">
                                        <strong>Upload de Imagens:</strong><i class="icon-upload-3" style="padding: 10px; border-radius: 50% cursor: pointer;"></i>
                                    </a>
                                    <span class="tertiary-text-secondary">
                    
                                    </span>
                                </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>Rotulo:</p></div>
                                <div class="span3">                                     
                                    <p class="input-control text" data-role="input-control">
                                        <input id="dbvar_str_rotulo" name="dbvar_str_rotulo" type="text" value="">      
                                    </p> 
                                    <span class="tertiary-text-secondary">
                    
                                    </span>
                                </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>URL:</p></div>
                                <div class="span3">                                     
                                    <p class="input-control text" data-role="input-control">
                                        <input id="dbvar_str_url" name="dbvar_str_url" type="text" value="">      
                                    </p> 
                                    <span class="tertiary-text-secondary">
                    
                                    </span>
                                </div>
                        </div>

                         <div class="row">
                            <div class="span2"><p>Área:</p></div>
                              <div class="span8">
                                <div class="input-control select ">
                                    <select id="dbvar_str_area" name="dbvar_str_area" value="">
                                      <option value="" selected="selected">Selecione...</option>
                                       	<%
                                            strSQL = "SELECT cod_status_cred, status FROM tbl_status_cred ORDER BY status"
                                            MontaCombo "STR",strSQL, "cod_status_cred","status",""
                                        %>
                                   </select>
                                </div>
                                <span class="tertiary-text-secondary"></span>
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

