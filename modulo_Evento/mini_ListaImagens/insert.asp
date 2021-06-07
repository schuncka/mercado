<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_ListaImagens",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_evento_img" 								' - Nome da Tabela...
 Const DKN = "ID_AUTO"									' - Campo chave...
 Const DLD = "../modulo_Evento/mini_ListaImagens/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Lista Imagens"	
 

 Dim  strCOD_EVENTO,strIMG

strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")

%> 
<html>
<head>
<title>Mercado</title>
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Evento/mini_ListaImagens/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      {  
  document.forminsert.DEFAULT_LOCATION.value="../modulo_Evento/mini_ListaImagens/insert.asp?var_cod_evento=<%=strCOD_EVENTO%>"; 
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
function SetFormField(formname, fieldname, valor) {
  if ( (formname != "") && (fieldname != "") && (valor != "") ) {
    eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
  }
}

function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '../../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
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
</style>
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
                    <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                    <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                    <input type="hidden" name="DEFAULT_LOCATION" value="">
                    <input type="hidden" name="DBVAR_NUM_COD_EVENTO" id="DBVAR_NUM_COD_EVENTO" value="<%=strCOD_EVENTO%>" >
 <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
            <li class="#"><a href="#MEDIDAS">MEDIDAS</a></li>
            
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <!--<div class="row">
                                <div class="span2"><p>Arquivo:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_ARQUIVO" id="DBVAR_STR_ARQUIVO" value="<'%=getValue(objRS,"ARQUIVO")%>" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>-->
                      <div class="row">
                                <div class="span2"><p>UPload:</p></div>
                                <div class="span8">
                                    <p class="input-control file " data-role="input-control"> 
                                            <input type="text" name="VAR_STR_ARQUIVO" id="VAR_STR_ARQUIVO" value=""  />
                                            <button class="btn-file" onClick="javascript:UploadImage('forminsert','DBVAR_STR_ARQUIVO','\\imgdin\\');"></button>
                                            <span class="tertiary-text-secondary"></span>
                                    </p>
                                    <span class="tertiary-text-secondary">Campo que envia imagem para diretório \imgdin</span>                             
                                </div>
                     </div>
                      <div class="row">
                                <div class="span2"><p>Arquivo:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_ARQUIVO" id="DBVAR_STR_ARQUIVO" value="" maxlength="50"></p>
                                     <span class="tertiary-text-secondary">GRAVA APENAS O NOME DO ARQUIVO SALVO OU NAO NO DIRETÓRIO</span>
                                </div>
                     </div>
                    
                      </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            <div class="frame" id="MEDIDAS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
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
                      </div> <!--FIM GRID//-->
            </div><!--fim do frame medidas//-->
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
