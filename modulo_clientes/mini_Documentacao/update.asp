<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("mini_Documentacao",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_documentacao_cliente" 								    ' - Nome da Tabela...
 Const DKN = "IDAUTO"									        ' - Campo chave...
 Const DLD = "../modulo_clientes/mini_Documentacao/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Lista Documentos"									' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCOD_EVENTO,strCOD, strIMG

strCOD =  Replace(GetParam("var_chavereg"),"'","''")
strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")


	
	AbreDBConn objConn, CFG_DB

    strSQL = "SELECT IDAUTO "
    strSQL = strSQL & " , COD_TBL_DOCUMENTACAO_CLIENTE"
    strSQL = strSQL & " , ESPECIFICACAO "
    strSQL = strSQL & " , CODIGODOCLIENTE "
    strSQL = strSQL & " , DOCUMENTO "    
    strSQL = strSQL & " , DATE_FORMAT(DT_ENTREGA, '%d/%m/%Y') as DT_ENTREGA "
    strSQL = strSQL & " FROM tbl_documentacao_cliente "
    strSQL = strSQL & " WHERE idauto = " & strCOD
    
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null

%> 
<html>
<head>
<title>pVISTA</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_clientes/mini_Documentacao/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar(){ 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_clientes/mini_Documentacao/update.asp?var_chavereg=<%=strCOD%>";
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
function SetFormField(formname, fieldname, valor) {
  if ( (formname != "") && (fieldname != "") && (valor != "") ) {
    eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
  }
}

function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '../../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=300,top=50,left=50,scrollbars=1');
}

/*function AlteraImgVisual(prVlr,prNameImg) 
{
  	document.getElementById(prNameImg).src = '../../imgdin/' + prVlr;
}*/

</script>
<script>

function preview(input) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		
		reader.onload = function (e) {
				$('#preview_image')
	.attr('src', e.target.result)
						.Height(350)
		};
		reader.readAsDataURL(input.files[0]);
	}
}


function aumenta(obj){
    obj.height=obj.height*2;
	obj.width=obj.width*2;
}
 
function diminui(obj){
	obj.height=obj.height/2;
	obj.width=obj.width/2;
}
	
/*
	  Com ele, o usuário pode inserir zoom numa imagem bastando apenas clicar num botão
      Coloque imagens pequenas no seu site a fim de que a página carregue mais rápido
      E use esta "fórmula" para que o internauta se sinta à vontade para ampliar as imagens
      Não se esqueça de substituir "exemplo1.jpg" pela URL (endereço) da sua imagem :D
*/
	
	function Aumentar(){
		document.getElementById("preview_image").width=document.getElementById("preview_image").width + 5;
		document.getElementById("preview_image").height=document.getElementById("preview_image").height + 5;
		document.getElementById("largura").innerHTML = "Largura " + document.getElementById("preview_image").width;
		document.getElementById("altura").innerHTML = "Altura " + document.getElementById("preview_image").height;
	}
	
	function Diminuir(){
		document.getElementById("preview_image").width=document.getElementById("preview_image").width - 5;
		document.getElementById("preview_image").height=document.getElementById("preview_image").height - 5;
		document.getElementById("largura").innerHTML = "Largura " + document.getElementById("preview_image").width;
		document.getElementById("altura").innerHTML = "Altura " + document.getElementById("preview_image").height;
	}

</script>
<style>
	 img[src='']{
		display:none;
				};
</style></head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	 <form name="formupdate" id="formupdate" action="../../_database/athupdatetodb.asp" method="post">
		<input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
        <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
        <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
        <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
		<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD%>">
        <input type="hidden" name="DEFAULT_LOCATION" value="">
        <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">        
 <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD%>.GERAL</a></li>
            <!--li class="#"><a href="#MEDIDAS">MEDIDAS</a></li-->
            
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                 <div class="grid" style="border:0px solid #F00">
                    <div class="row">
                    <div class="span2"><p>Tipo</p></div>
                        <div class="span8">

                                <div class="input-control select info-state" data-role="input-control">
                                    <select id="DBVAR_STR_COD_TBL_DOCUMENTACAO_CLIENTE" name="DBVAR_STR_COD_TBL_DOCUMENTACAO_CLIENTE">
                                        <option value="">Selecione...</option>
                                        <%=montaComboReturn("select cod_doc, nome_doc from tbl_Tipo_Documentacao order by 2", "cod_doc", "nome_doc",getValue(objRS,"COD_TBL_DOCUMENTACAO_CLIENTE" )) %>
                                    </select>                                        
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>  
                </div>
                      <div class="row">
                                <div class="span2"><p>Upload</p></div>
                                <div class="span8">
                                    <p class="input-control file " data-role="input-control"> 
                                            <input type="text" name="DBVAR_STR_DOCUMENTO" id="DBVAR_STR_DOCUMENTO" value="<%=getValue(objRS,"DOCUMENTO")%>" />
                                            <button class="btn-file" onClick="javascript:UploadImage('forminsert','DBVAR_STR_DOCUMENTO','\\_documentos_cliente\\');"></button>                                           
                                    </p> 
                                    <% if GetValue(objRS,"documento")<> "" then %>
                                    <p>
                                    <span class="tertiary-text-secondary">
                                        <a href="http://servidor.clicmercado.com.br/mercado/_documentos_cliente/<%=GetValue(objRS,"documento")%>" download><%=GetValue(objRS,"documento")%></a>
                                    </span>
                                    </p>
                                    <% end if%>
                                                                 
                                </div>
                     </div>
                      <div class="row">
                                <div class="span2"><p>Especificação</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_Especificacao" id="DBVAR_STR_Especificacao" value="<%=GetValue(objRS,"especificacao")%>" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>

                     <div class="row">
                        <div class="span2"><p>Data Cadastro</p></div>
                            <div class="span8">
                                
                                <div class="input-control text size3" data-role="input-control">
                                    <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                        <input id="DBVAR_DATETIME_dt_entrega" name="DBVAR_DATETIME_dt_entrega" type="text" placeholder="" value="<%=getValue(objRS,"DT_ENTREGA")%>" maxlength="11">
                                        <span class="btn-date"></span>
                                    </p>
                                </div>  
                               
                            </div>
                    </div>
                    
                      </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            <!--div class="frame" id="MEDIDAS" style="width:100%;"-->
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <!--div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>Largura:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_NUM_LARGURA" id="DBVAR_NUM_LARGURA" value="" maxlength="11" onKeyPress="return validateNumKey(event);"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Altura:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_NUM_ALTURA" id="DBVAR_NUM_ALTURA" value="" maxlength="11" onKeyPress="return validateNumKey(event);"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Área:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_AREA" id="DBVAR_STR_AREA" value="" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                      </div--> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    
    <div style="padding-top:16px;padding-left:16px;"><!--INI: BOTÕES/MENSAGENS//-->
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
<%
	FechaRecordSet ObjRS
	FechaDBConn ObjConn
	
	'athDebug strSQL, true '---para testes'
%>                      
