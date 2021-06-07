<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("mini_ListaImagens",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_EVENTO_IMG" 								' - Nome da Tabela...
 Const DKN = "ID_AUTO"									' - Campo chave...
 Const TIT = "Lista Imagens"	
 
'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCOD_EVENTO,strCOD_IMAGEm, strIMG

strCOD_IMAGEM =  Replace(GetParam("var_chavereg"),"'","''")
strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")

If strCOD_IMAGEM <> "" Then
	
	AbreDBConn objConn, CFG_DB

 strSQL = " SELECT EI.ID_AUTO "
 strSQL = strSQL & "		  , EI.COD_EVENTO "
 strSQL = strSQL & "		  , EI.ARQUIVO "
 strSQL = strSQL & "		  , EI.LARGURA "
 strSQL = strSQL & "		  , EI.ALTURA "
 strSQL = strSQL & "		  , EI.AREA "
 strSQL = strSQL & "		   FROM tbl_EVENTO_IMG AS EI " 
 strSQL = strSQL & "		   WHERE EI.ID_AUTO = " & strCOD_IMAGEM
 strSQL = strSQL & "		   ORDER BY EI.AREA, EI.ARQUIVO " 
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null

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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Evento/mini_ListaImagens/update.asp?var_chavereg=<%=strCOD_IMAGEM%>&var_cod_evento=<%=strCOD_EVENTO%>"; 
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
		 <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_IMAGEM%>">
        <input type="hidden" name="DEFAULT_LOCATION" value="">
        <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
        <input type="hidden" name="DBVAR_NUM_COD_EVENTO" id="DBVAR_NUM_COD_EVENTO" value="<%=getValue(objRS,"COD_EVENTO")%>">
 <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_IMAGEM%>.GERAL</a></li>
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
                     <!--<div class="row">
                                <div class="span2"><p>Arquivo:</p></div>
                                <div class="span8">
                                 <p><span class="tertiary-text-secondary">(carregue a img para visualização...)</span>
                                 <%
                             '               strIMG = getValue(objRS,"ARQUIVO")&""
                           '                 If strIMG <> "" Then
                                 %>
                                 	<img id="preview_image" src="../../imgdin/<'%=strIMG%>" >
                                 <%
							'	 else
								 %>
                                 	<img id="preview_image" name="preview_image"  src=""  onMouseOver="aumenta(this)" onMouseOut="diminui(this)">
                                 <%
                             '    End If
                                 %>
                                  </p>
                                    <p class="input-control text" data-role="input-control">
                                         <input type="text" name="DBVAR_STR_ARQUIVOô" id="DBVAR_STR_ARQUIVO"   value="<'%=getValue(objRS,"ARQUIVO")%>" onChange="javascript:preview(this);return false;" multiple  />
                                          <button class="btn-file"  onChange="javascript:preview(this);return false;"></button>
                                    </p>
                                    <span class="tertiary-text-secondary span2">Zoom:
                                        <span class="button  bg-white" onClick="Aumentar()"><i class="icon-plus  on-right"></i></span>
                                        <span class="button  bg-white" onClick="Diminuir()"><i class="icon-minus on-left"></i></span> 
                                    </span>  
                                    <p></p>                         
                                </div>
                                <span class="tertiary-text-secondary">Campo que visualiza e salvo o nome do arquivo desejado.</span>
                     </div>
                    //-->
                     <div class="row">
                                <div class="span2"><p>Arquivo:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_ARQUIVO" id="DBVAR_STR_ARQUIVO" value="<%=getValue(objRS,"ARQUIVO")%>" maxlength="50"></p>
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
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_NUM_LARGURA" id="DBVAR_NUM_LARGURA" value="<%=getValue(objRS,"LARGURA")%>" maxlength="11" onKeyPress="return validateNumKey(event);"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Altura:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_NUM_ALTURA" id="DBVAR_NUM_ALTURA" value="<%=getValue(objRS,"ALTURA")%>" maxlength="11" onKeyPress="return validateNumKey(event);"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2"><p>Área:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_AREA" id="DBVAR_STR_AREA" value="<%=getValue(objRS,"AREA")%>" maxlength="50"></p>
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
<%
	FechaRecordSet ObjRS
	FechaDBConn ObjConn
end if	
	'athDebug strSQL, true '---para testes'
%>                      
