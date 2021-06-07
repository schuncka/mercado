<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_formularios",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_formularios" 								    ' - Nome da Tabela...
 Const DKN = "cod_formulario"									        ' - Campo chave...
 Const TIT = "Cadastro Caex"									' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro
 Const DLD = "../modulo_AreaRestritaSetup/mini_formularios/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção


 Dim arrICON, arrBG , i ,strIDINFO, strSQL
 Dim objConn, objRS, strCOD_EVENTO, strLANG, strID_AUTO
 Dim objFSO, strPath, objFolder, objItem   
 Dim strFormFolder

strCOD_EVENTO = Replace(GetParam("var_chavemaster"),"'","''")


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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_AreaRestritaSetup/mini_formularios/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      {  
  document.forminsert.DEFAULT_LOCATION.value="../modulo_AreaRestritaSetup/mini_formularios/insert.asp?var_chavemaster=<%=strCOD_EVENTO%>";
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
    <input type="hidden" name="DEFAULT_LOCATION" value="">
    <input type="hidden" name="dbvar_num_cod_evento" id="dbvar_num_cod_evento" value="<%=strCOD_EVENTO%>" >
    <input type="hidden" id="dbvar_str_preenchimento_obrigatorio" name="dbvar_str_preenchimento_obrigatorio"><br>
    <input type="hidden" id="dbvar_str_cod_status_preco" name="dbvar_str_cod_status_preco"><br>


        <div class="tab-control" data-effect="fade" data-role="tab-control">
            <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                <li class="active"><a href="#DADOS">GERAL</a></li>
            </ul>
        
	    	<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">  
                        
                        <div class="row">
                            <div class="span2"><p><strong class="text-alert">Atenção <i class="icon-warning"></i></strong></p></div>
                                <div class="span8">
                                    <p>
                                        Antes de configurar os formulários verifique <br />
                                        a funcionalidade de cada um clicando <a href="javascript:AbreJanelaPAGE('info_forms.asp','1050', '750')"><strong>aqui!</strong></a>
                                    <p>
                                </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>*URL:</p></div>
                                <div class="span8">
                                    <div class="input-control select info-state">
                                        <select id="dbvar_str_link" name="dbvar_str_link">
                                            <option value="" selected="selected">Selecione...</option>
                                               <%
                                                    strFormFolder = Session("COD_EVENTO")&lcase(strLANG) 
                                                    strPath = "..\..\arearestrita\"&strFormFolder&"\" 'Tem que terminar com barra
                                                    'response.Write(strPath)
                                                    'response.End()
                                                    Set objFSO    = Server.CreateObject("Scripting.FileSystemObject")
                                                    
                                                    If not objFSO.FolderExists(Server.MapPath(strPath)) Then
                                                        'objFSO.CreateFolder(Server.MapPath(strPath))
                                                        strFormFolder = "forms"
                                                        strPath = "..\..\arearestrita\"&strFormFolder&"\" 'Tem que terminar com barra
                                                    End IF
                                                    
                                                    Set objFolder = objFSO.GetFolder(Server.MapPath(strPath))
                                                    For Each objItem In objFolder.Files
                                                        If (InStr(lcase(objItem.Name),".asp") > 0) and ( left(objItem.Name,1) <> "_" ) and (objItem.Name <> "athFormFunctions.asp" ) and (objItem.Name <> "deletepedido.asp" ) Then
                                                            %> <option value="<%=strFormFolder&"/"&objItem.Name%>"><%=objItem.Name%></option> <%
                                                        End If
                                                    Next 
                                                    Set objItem   = Nothing
                                                    Set objFolder = Nothing
                                                    Set objFSO    = Nothing
                                                 %>
                                                
                                        </select>
                                    </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                        </div>   

                        <div class="row">
                            <div class="span2"><p>Rótulo:</p></div>
                             <div class="span8">
                                 <p class="input-control text" data-role="input-control">
                                    <input id="dbvar_str_rotulo" name="dbvar_str_rotulo" type="text" placeholder="" value="" maxlength="250">
                                </p>
                                 <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>Título:</p></div>
                             <div class="span8">
                                 <p class="input-control text" data-role="input-control">
                                    <input id="dbvar_str_titulo" name="dbvar_str_titulo" type="text" placeholder="" value="" maxlength="250">
                                </p>
                                 <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>Dead Line:</p></div>
                                <div class="span8"> 
                                    <div class="input-control text data-role="input-control">                                        
                                        <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                            <input id="dbvar_date_dt_inativo" name="dbvar_date_dt_inativo" type="text" placeholder="<%=Date()%>"maxlength="11" class="">
                                            <span class="btn-date"></span>
                                        </p>
                                    </div>    
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>Área:</p></div>
                              <div class="span8">
                                <div class="input-control select ">
                                    <select id="dbvar_str_cod_status_cred" name="dbvar_str_cod_status_cred">
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

                        <div class="row">
                            <div class="span2"></div>
                                <div class="span4">
                                    <p>Categorias:</p>
                                    
                                        <% 
                                            Dim objRSCat, arrCAT, strCHECKED

                                            strSQL = " SELECT cod_status_preco, status FROM tbl_status_preco WHERE cod_evento = " & Session("COD_EVENTO") & " AND STATUS IS NOT NULL AND CAEX_SHOW = 1 ORDER BY status"
                                            
                                            Set objRSCat = objConn.execute(strSQL)
                                                
                                            Do While Not objRSCat.EOF

                                        %>                                    
                                        <div class="input-control checkbox">
                                        <label style="font-size: 11pt;">
                                            <input type="checkbox" name="dbvar_str_cod_status_preco" id="check_sp_<%=objRSCat("cod_status_preco")%>" value="<%=objRSCat("cod_status_preco")%>" onclick="concatenaDadoCheckBox('forminsert','sp_','dbvar_str_cod_status_preco');"> <%=objRSCat("status")%> 
                                            <span style="margin-top: -8px;" class="check"></span>
                                        </label>
                                        </div><br/>
                                        
                                    
                                        <%
                                            objRSCat.MoveNext
                                            Loop
                                        %>
                                    
                                </div>

                                <div class="span2"></div>
                                    <div class="span4">
                                        <p>Obrigatório para:</p>
                                            <% 

                                            strSQL = " SELECT cod_status_preco, status FROM tbl_status_preco WHERE cod_evento = " & Session("COD_EVENTO") & " AND STATUS IS NOT NULL AND CAEX_SHOW = 1 ORDER BY status"
                                            
                                            Set objRSCat = objConn.execute(strSQL)
            
                                            Do While Not objRSCat.EOF

                                            %>
                                            <div class="input-control checkbox">
                                            <label style="font-size: 11pt;">
                                                <input type="checkbox" name="dbvar_str_preenchimento_obrigatorio" id="check_obr_<%=objRSCat("cod_status_preco")%>" value="<%=objRSCat("cod_status_preco")%>" onclick="concatenaDadoCheckBox('forminsert','obr_','dbvar_str_preenchimento_obrigatorio');"> <%=objRSCat("status")%> 
                                                <span style="margin-top: -8px;" class="check"></span>
                                            </label>
                                            </div><br />

                                            <%
                                                objRSCat.MoveNext
                                                Loop
                                            %>
                                            
                                    </div>            
                        </div><!--FIM ROW CHECKBOX//-->


                       <div style="padding-top:16px; padding-bottom: 50px;"><!--INI: BOTÕES/MENSAGENS//-->
                        <div style="float:left">
                            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
                            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
                            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
                        </div>
                        <div style="float:right">
                            <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigat&oacute;rios</small>
                        </div> 
                    </div><!--FIM: BOTÕES/MENSAGENS //--> 

             </form>
        </div> <!--FIM DIV CONTAINER//-->  
</body>
</html>
