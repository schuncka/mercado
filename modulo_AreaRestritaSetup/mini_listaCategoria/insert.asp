<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_listaCategoria",Session("METRO_USER_ID_USER")), true %>
<% 

 Const LTB = "TBL_STATUS_PRECO" 								    ' - Nome da Tabela...
 Const DKN = "COD_STATUS_PRECO"									        ' - Campo chave...
 Const DLD = "../modulo_AreaRestritaSetup/mini_listaCategoria/default.asp" 	' "../evento/data.asp" - 'Default Location ap�s Dele��o
 Const TIT = "Lista de Categorias"		


 Dim arrICON, arrBG , i ,strIDINFO, strSQL
 Dim objConn, objRS, strCOD_EVENTO, strLANG, strID_AUTO
 Dim objFSO, strPath, objFolder, objItem   
 Dim strFormFolder

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

/* INI: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ---------
Criando uma condi��o pois na ATHWINDOW temos duas op��es
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
bot�es est�o aptos a retornar para default location�s
corretos em cada op��o de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_AreaRestritaSetup/mini_listaCategoria/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}


function aplicar()      {  
  document.forminsert.DEFAULT_LOCATION.value="../modulo_AreaRestritaSetup/mini_listaCategoria/insert.asp?var_chavemaster=<%=strCOD_EVENTO%>"; 
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
/* FIM: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ------- */
</script>
<script language="javascript" type="text/javascript">
//fun��o para ativar o date picker dos campos data
$("#datepicker").datepicker( {
	date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo n�o deixa o value correto aparecer j�  ele modifica automaticamente para data setada dentro da fun��o//-->
	format: "dd/mm/yyyy", // set output format
	effect: "none", // none, slide, fade
	position: "bottom", // top or bottom,
	locale: ''en, // 'ru' or 'en', default is $.Metro.currentLocale
});

</script>

</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o t�tulo do m�dulo e a��o da dialog //-->
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
    <input type="hidden" name="dbvar_num_caex_show" value="1">


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
                            <div class="span2"><p>Categoria:</p></div>
                              <div class="span8">
                                <div class="input-control select ">
                                    <select id="dbvar_str_status" name="dbvar_str_status">
                                      <option value="" selected="selected">Selecione...</option>
                                       	<%
                                            strSQL = "SELECT cod_status_preco, status FROM tbl_status_preco ORDER BY status"
                                            MontaCombo "STR",strSQL, "cod_status_preco","status",""
                                        %>
                                   </select>
                                </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>
                          <div class="row">
                            <div class="span2"><p>Observa��o:</p></div>
                             <div class="span8">
                                 <p class="input-control text" data-role="input-control">
                                    <input id="dbvar_str_observacao" name="dbvar_str_observacao" type="text">
                                </p>
                                 <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>

                    </div> <!--FIM GRID//-->
                </div><!--fim do frame dados//-->
                
            </div><!--FIM - FRAMES//-->
        </div><!--FIM TABCONTROL //--> 

        <div style="padding-top:16px;"><!--INI: BOT�ES/MENSAGENS//-->
            <div style="float:left">
                <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
                <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
                <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
            </div>
            <div style="float:right">
                <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigat�rios</small>
            </div> 
        </div><!--FIM: BOT�ES/MENSAGENS //--> 
        </form>
    </div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>                    

