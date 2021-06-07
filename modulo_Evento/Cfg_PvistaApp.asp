<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_Evento",Session("ID_USER")), true %>
<%
 Const LTB = "tbl_evento"	 ' - Nome da Tabela...
 Const DKN = "ID_AUTO"    ' - Campo chave...
 Const TIT = "EVENTO"        ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

	'Relativas a conexão com DB, RecordSet e SQL
 	Dim objConn, objRS, strSQL,strSQL2,strSQL3,objRSDetail
	'Relativas a FILTRAGEM e Seleção	
 	Dim  strCOD_EVENTO,strID_AUTO,strMERCADO, strIDTBL_MERCADO, strIDTBL_EVENTO
	
	AbreDBConn objConn, CFG_DB
	
		strID_AUTO = Replace(GetParam("var_chavereg"),"'","''")
		strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")
'-----------------------------------------------------------------------------------------
			strSQL = " SELECT * " 
		strSQL = strSQL & "  FROM "& LTB 
		strSQL = strSQL & " WHERE ID_AUTO = " & strID_AUTO 
		
			
		'athDebug strSQL, true
	 
	 
'------------------------------------------------------------------------------------------
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 


%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 

<script src="../_scripts/scriptsCS.js"></script>
<script src="metro-calendar.js"></script>
<script src="metro-datepicker.js"></script>

<!-- funções para action dos botões OK, APLICAR,CANCELAR  e NOTIFICAÇÂO//-->
<script type="text/javascript" language="javascript">

<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() {
	 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formdetail.DEFAULT_LOCATION.value='../modulo_Evento/Cfg_PvistaApp.asp';") 
	 else
  		response.write ("document.formdetail.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %>  
	/*document.formdetail.DEFAULT_LOCATION.value="../_database/athWindowClose.asp"; */
	if (validateRequestedFields("formdetail")) { 
		document.formdetail.submit(); 
	} 
}
function aplicar()      { 
  document.formdetail.DEFAULT_LOCATION.value="../modulo_Evento/Cfg_PvistaApp.asp?var_chavereg=<%=strID_AUTO%>&var_cod_evento=<%=strCOD_EVENTO%>"; 
  if (validateRequestedFields("formdetail")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.formdetail.submit(); 
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


function viewdoc(doc) {
  var conteudo = '';
  
  if(doc!='') {
    conteudo = eval('document.formdetail.DBVAR_STR_' + doc + '.value');
  }
  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}

function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '	../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

function atualizaMercado() {
	var_exibe = document.formdetail.RB_EXIBE_APP[0].checked;
	var_mercado = document.formdetail.RB_MERCADO.value;
	
	document.formmercado.var_exibe.value = var_exibe;
	document.formmercado.var_mercado.value = var_mercado;
	alert(var_exibe);
	//alert(var_mercado);
	document.formmercado.submit();
}
</script>
</head>
<body class="metro" id="metrotablevista">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkOrange fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">CFG APP</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
                <form name="formdetail" id="formdetail" action="Cfg_PvistaAppexec.asp" method="post">
                <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
                <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strID_AUTO%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">


	<div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strID_AUTO%>.GERAL</a></li>
            <!-- li class=""><a href="#AJUDA">AJUDA</a></li //-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;"><!--esta guia contem tab dentro de tab//-->
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="row ">
                        <div class="span2" style=""><p>Descrição:</p></div>
                        <div class="span8"> 
                            <p class="input-control textarea " data-role="input-control">
                            <textarea name="DBVAR_STR_DESCRICAO" id="DBVAR_STR_DESCRICAO"><%=ReturnCaracterEspecial(getValue(objRS,"DESCRICAO")&"")%></textarea>
                            </p>
                            <span class="tertiary-text-secondary"><a href="javascript:viewdoc('DESCRICAO');" class=""><i class="icon-search"></i> visualizar</a></span>                             
                        </div>
                    </div>
                    <div class="row ">
                        <div class="span2" style=""><p>Programação:</p></div>
                        <div class="span8"> 
                            <p class="input-control textarea " data-role="input-control">
                            <textarea name="DBVAR_STR_PROGRAMACAO" id="DBVAR_STR_PROGRAMACAO"><%=ReturnCaracterEspecial(getValue(objRS,"PROGRAMACAO")&"")%></textarea>
                            </p>
                            <span class="tertiary-text-secondary"><a href="javascript:viewdoc('PROGRAMACAO');" class=""><i class="icon-search"></i> visualizar</a></span>    
                        </div>                       
                    </div>
                    <div class="row ">
                        <div class="span2" style=""><p>Exibir no pVISTAApp:</p></div>
                        <div class="span8"> 
							<%
                            strMERCADO = ""
                            
                            strSQL2 = " SELECT ev.idtbl_evento "
                            strSQL2 = strSQL2 & "    , m.idtbl_mercado "
                            strSQL2 = strSQL2 & "    , m.mercado "
                            strSQL2 = strSQL2 & "    FROM METRO_schema.tbl_evento ev inner join METRO_schema.tbl_database db on ev.idtbl_database = db.idtbl_database "
                            strSQL2 = strSQL2 & "    		inner join METRO_schema.tbl_mercado m on ev.idtbl_mercado = m.idtbl_mercado "
                            strSQL2 = strSQL2 & "  WHERE ev.cod_evento = " & getValue(objRS,"COD_EVENTO")
                            strSQL2 = strSQL2 & "  AND db.base = '" & CFG_DB & "'"
                            'Response.Write(strSQL2)
                            'Response.End()
                            Set objRSDetail = objConn.Execute(strSQL2)
                            'AbreRecordSet objRSDetail, strSQL2, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null
                            If (not objRSDetail.BOF) and (not objRSDetail.EOF) Then                                 
                            'If not objRSDetail.EOF Then
                            strIDTBL_MERCADO 	= objRSDetail("IDTBL_MERCADO")&""
                            strMERCADO 			= objRSDetail("MERCADO")&""
                            strIDTBL_EVENTO 	= objRSDetail("IDTBL_EVENTO")&""
                            End If
                            'athDebug "<div>\"&strMERCADO&"\</div>", false
                            ' AbreRecordSet objRSDetail, strSQL2, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
                            
                            %>
                            <p>
                                <input name="RB_EXIBE_APP" id="RB_EXIBE_APP" type="radio" value="1" <% If strMERCADO <> "" Then Response.Write("checked") End If %>>
                                	Sim 
                                <input name="RB_EXIBE_APP" id="RB_EXIBE_APP2" type="radio" value="0" <% If strMERCADO = "" Then Response.Write("checked") End If %>>
                                	Não 
                            </p>
                            <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div> 
                    <div class="row ">
                        <div class="span2" style=""><p>Mercado:</p></div>
                        <div class="span8"> 
                            <p class="input-control select text " data-role="input-control">
                                <select name="RB_MERCADO" id="RB_MERCADO" class="size2">
                                    <option value="">Selecione...</option>
                                    <%
                                    'strSQL = "SELECT IDTBL_MERCADO, MERCADO FROM METRO_schema.TBL_MERCADO "
									 
                                    MontaCombo "STR","SELECT IDTBL_MERCADO, CONCAT(MERCADO,' (',CAST(IDTBL_MERCADO AS CHAR),') ') as MERC FROM METRO_schema.TBL_MERCADO ORDER BY ORDEM ", "IDTBL_MERCADO", "MERC", strIDTBL_MERCADO%>
                                </select>&nbsp;&nbsp;
                                	
                            </p>        
                            <span class="tertiary-text-secondary"></span>                             
                            </div>
                        </div>
                        <div class="row ">
                            <div class="span6" style=""><p>Imagen1 http://pvista.proevento.com.br/[cliente]_dados/imgdin/[IMG2]):</p></div>
                            <div class="span4"> 
                             <div class="input-control text " data-role="input-control">
                                <p>
                                	<input type="text" name="DBVAR_STR_IMG1" id="DBVAR_STR_IMG1" value="<%=getValue(objRS,"IMG1")%>" class="" maxlength="45" placeholder="IMG1">
                                </p>
                             </div>
                            <span class="tertiary-text-secondary">(imagens do cliente para a pVISTAAPP)</span>                             
                        </div>
                        <div class="row ">
                            <div class="span6" style=""><p>Imagen2 http://pvista.proevento.com.br/[cliente]_dados/imgdin/[IMG2]):</p></div>
                            <div class="span4"> 
                             <div class="input-control text " data-role="input-control">
                                <p>
                               	 	<input type="text" name="DBVAR_STR_IMG2" id="DBVAR_STR_IMG2" value="<%=getValue(objRS,"IMG2")%>" class="" maxlength="45" placeholder="IMG2">
                                </p>
                             </div>
                            <span class="tertiary-text-secondary">(imagens do cliente para a pVISTAAPP)</span>                             
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
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
            <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 

<input type="hidden" name="var_chavereg" value="<%=strID_AUTO%>">
<input type="hidden" name="cod_evento" value="<%=objRS("COD_EVENTO")%>">
<input type="hidden" name="base" value="<%=CFG_DB%>">
<input type="hidden" name="var_evento" value="<%=strIDTBL_EVENTO%>">

</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>


<%
	FechaRecordSet ObjRS
	FechaDBConn ObjConn
	'athDebug strSQL, true '---para testes'
%>