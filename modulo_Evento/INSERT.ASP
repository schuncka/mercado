<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_Evento",Session("ID_USER")), true %>
<%
 Const LTB = "tbl_evento"	 ' - Nome da Tabela...
 Const DKN = "ID_AUTO"    ' - Campo chave...
 Const TIT = "EVENTO"        ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 Dim strCOD_EVENTO,strID_AUTO
 
		strID_AUTO = Replace(GetParam("var_chavereg"),"'","''")
		strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")
%>
<html>
<head>
<title></title>
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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_Evento/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_Evento/insert.asp"; 
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
    conteudo = eval('document.forminsert.DBVAR_STR_' + doc + '.value');
  }
  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}
function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '	../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

/*function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}*/

</script>
<script language="javascript" type="text/javascript">
//função para ativar o date picker dos campos data
$("#datepicker").datepicker( {
	date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer já  ele modifica automaticamente para data setada dentro da função//-->
	format: "dd/mm/yyyy <%=Time%>", // set output format
	effect: "none", // none, slide, fade
	position: "bottom", // top or bottom,
	//locale: ''en, // 'ru' or 'en', default is $.Metro.currentLocale
	
});
</script>
<!-- FIM----------------------------------------- funções //-->

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
            <li class=""><a href="#CFGEMAIL">EMAIL</a></li>
            <li class=""><a href="#CFGMOEDA">MOEDA</a></li>
            <li class=""><a href="#STATUS">STATUS</a></li>
            <li class=""><a href="#HTMLTXT">HTML TXT</a></li>
            <li class=""><a href="#LOJA">LOJA</a></li>
            <li class=""><a href="#CORRESPONDENCIA">OFICIOS</a></li>
            <!-- li class=""><a href="#AJUDA">AJUDA</a></li //-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <!--//-->
                    <div class="tab-control" data-role="tab-control">
                        <ul class="tabs">
                            <li class="active"><a href="#GERAL1">CADASTRO</a></li>
                            <li><a href="#GERAL2">REGISTRO</a></li>
                            <li><a href="#GERAL3">LOCALIDADE</a></li>
                            <li><a href="#AGENCIA">AGENCIA</a></li>     
                            <li><a href="#SMS">SMS</a></li>
                            <!--li><a href="#MINI">MINI</a></li//-->   
                        </ul>
                        <div class="frames">
                            <div class="frame" id="GERAL1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2"><p>*Código/*Nome:</p></div>
                                        <div class="span8">
                                            <div class="input-control text size1 info-state" data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_COD_EVENTOô" name="DBVAR_STR_COD_EVENTOô" type="text" placeholder="<%=Session("COD_EVENTO")%>" value="" maxlength="11" class="" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                </p>
                                            </div>
                                            <div class="input-control text size5 info-state" data-role="input-control">                                        
                                                <p>                                               
                                                	<input id="DBVAR_STR_NOMEô" name="DBVAR_STR_NOMEô" type="text" placeholder="" value="" maxlength="50" class="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                    	
                                    <div class="row">
                                        <div class="span2"><p>Nome Completo/Idade Limite:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text size5" data-role="input-control">
                                                <p>
                                                <input id="DBVAR_STR_NOME_COMPLETO" name="DBVAR_STR_NOME_COMPLETO" type="text" placeholder="" value="" maxlength="100" >
                                                </p>
                                                </div>
                                            <div class="input-control text size1" data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_LIMITE_IDADE" name="DBVAR_STR_LIMITE_IDADE" type="text" placeholder="" value=""  maxlength="11" class="" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                </p>
                                            </div>

                                            <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>*Data Ini./Data Fim:</p></div><!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer. Ele modifica automaticamente para data setada dentro da função//-->
                                        <div class="span8">
                                            <div class="input-control text size3 info-state" data-role="input-control">
                                                <p class="input-control text span3 info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                	<input id="DBVAR_DATE_DT_INICIO" name="DBVAR_DATE_DT_INICIOô" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                                	<span class="btn-date"></span>
                                            	</p>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">                                        
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                	<input id="DBVAR_DATE_DT_FIM" name="DBVAR_DATE_DT_FIM" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class="">
                                                	<span class="btn-date"></span>
                                                </p>
                                            </div>    
                                            <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2"><p>Hora Inicio/Hora Término:</p></div>
                                        <div class="span8">
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3  " >
                                                	<input id="DBVAR_DATETIME_HORA_INICIO" name="DBVAR_DATETIME_HORA_INICIO" type="text" placeholder="HH:MM" value="" maxlength="8" class="">
                                            	</p>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">                                        
                                                <p class="input-control text span3" >                                                
                                                	<input id="DBVAR_DATETIME_HORA_FIM" name="DBVAR_DATETIME_HORA_FIM" type="text" placeholder="HH:MM" value="" maxlength="8" class="">
                                                </p>
                                            </div>    
                                            <span class="tertiary-text-secondary"><br></span>
                                        </div>
                                    </div>
                                </div><!--fim grid//-->  
                            </div><!--fim de frame geral1//-->
                            <div class="frame" id="GERAL2">
                                <div class="grid" style="border:0px solid #F00">
                                      <div class="row">
                                            <div class="span2" style=""><p>Site/Telefone:</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text size3" data-role="input-control">
                                                    <p class="input-control text span3" >
                                                        <input id="DBVAR_STR_SITE" name="DBVAR_STR_SITE" type="text" placeholder="EX: www.teste.com.br" value="" maxlength="50" class="size3">
                                                    </p>
                                                </div>
                                                <div class="input-control text size3" data-role="input-control">                                        
                                                    <p class="input-control text span3" >
                                                        <input id="DBVAR_STR_FONE" name="DBVAR_STR_FONE" type="text" placeholder="EX: 51 0000-0000" value="" maxlength="50" class="size3">
                                                    </p>
                                                </div>    
                                                <span class="tertiary-text-secondary"></span>
                                            </div>
                                      </div> <!--FIM row//-->
                                     <div class="row">
                                        <div class="span2" style=""><p>CNPJ/Data Material:</p></div>
                                        <div class="span8 "> 
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3">
                                                   <input id="DBVAR_STR_CNPJ" name="DBVAR_STR_CNPJ" type="text" placeholder="" value="" maxlength="50" class="">
                                                </p>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">                                        
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade" >
                                                    <input id="DBVAR_STR_DT_MATERIAL" name="DBVAR_STR_DT_MATERIAL"  type="text" placeholder="<%=Date()%>" value="" maxlength="30" class="">
                                                <span class="btn-date"></span>                                                        
                                                </p>
                                            </div> 
                                            <span class="tertiary-text-secondary"></span>                       
                                        </div>
                                     </div> <!--FIM row//-->
                                    <div class="row">
                                        <div class="span2" style=""><p>Hora Material/Pavilhão:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" >
                                                    <input id="DBVAR_STR_HR_MATERIAL" name="DBVAR_STR_HR_MATERIAL" type="text" placeholder="HH:MM" value="" maxlength="50" class="size3">
                                                </p>
                                            </div>
                                            <div class="input-control text size3" data-role="input-control">                                        
                                                <p class="input-control text span3" >                                                        
                                                    <input id="DBVAR_STR_PAVILHAO" name="DBVAR_STR_PAVILHAO" type="text" placeholder="" value="" maxlength="50" class="size3">
                                                </p>
                                            </div>    
                                            <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> <!--FIM row//-->   
                                       <div class="row">
                                            <div class="span2" style=""><p>Logomarca:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_LOGOMARCA" name="DBVAR_STR_LOGOMARCA" type="text" placeholder="" value="" maxlength="50">
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div> <!--FIM row//-->                            
                                       <div class="row">
                                            <div class="span2" style=""><p>Cod. Grupo Evento:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_COD_GRUPO_EVENTO" name="DBVAR_STR_COD_GRUPO_EVENTO" type="text" placeholder="<%=Session("COD_EVENTO")%>" value="" maxlength="5">
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div> <!--FIM row//-->                            

                                </div><!--fim grid//--> 
                            </div><!--fim do frame GERAL2//-->
                            
                             <div class="frame" id="GERAL3">
                                <div class="grid" style="border:0px solid #F00">
                                <div class="row">
                                            <div class="span2" style=""><p>Logradouro:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_LOGRADOURO" name="DBVAR_STR_LOGRADOURO" type="text" placeholder="" value="" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div> <!--FIM row//-->
                                     
                                    <div class="row">
                                            <div class="span2" style=""><p>Bairro:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_BAIRRO" name="DBVAR_STR_BAIRRO" type="text" placeholder="" value="" maxlength="250" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div><!--FIM row//-->
                                     
                                     <div class="row">
                                            <div class="span2" style=""><p>Cidade:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_CIDADE" name="DBVAR_STR_CIDADE" type="text" placeholder="" value="" maxlength="50">
                                                    </p>
                                                 </div>  
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                     </div><!--FIM row//--> 
                                     
                                     <div class="row">
                                        <div class="span2" style=""><p>Estado/País:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control select size3" data-role="input-control">
                                                 <p>
                                                    <select id="DBVAR_STR_ESTADO_EVENTO" name="DBVAR_STR_ESTADO_EVENTO" class="">
                                                    <option value=""   >[selecione]</option>
                                                    <option value="AC" >Acre - AC</option>
                                                    <option value="AL" >Alagoas - AL</option>
                                                    <option value="AP" >Amapá - AP</option>
                                                    <option value="AM" >Amazonas - AM</option>
                                                    <option value="BA" >Bahia  - BA</option>
                                                    <option value="CE" >Ceará - CE</option>
                                                    <option value="DF" >Distrito Federal  - DF</option>
                                                    <option value="ES" >Espírito Santo - ES</option>
                                                    <option value="GO" >Goiás - GO</option>
                                                    <option value="MA" >Maranhão - MA</option>
                                                    <option value="MT" >Mato Grosso - MT</option>
                                                    <option value="MS" >Mato Grosso do Sul - MS</option>
                                                    <option value="MG" >Minas Gerais - MG</option>
                                                    <option value="PA" >Pará - PA</option>
                                                    <option value="PB" >Paraíba - PB</option>
                                                    <option value="PR" >Paraná - PR</option>
                                                    <option value="PE" >Pernambuco - PE</option>
                                                    <option value="PI" >Piauí - PI</option>
                                                    <option value="RJ" >Rio de Janeiro - RJ</option>
                                                    <option value="RN" >Rio Grande do Norte - RN</option>
                                                    <option value="RS" >Rio Grande do Sul - RS</option>
                                                    <option value="RO" >Rondônia - RO</option>
                                                    <option value="RR" >Roraima - RR</option>
                                                    <option value="SC" >Santa Catarina - SC</option>
                                                    <option value="SP" >São Paulo - SP</option>
                                                    <option value="SE" >Sergipe - SE</option>
                                                    <option value="TO" >Tocantins - TO</option>
                                                    </select>
                                                </p>
                                             </div>
                                            <div class="input-control select size3" data-role="input-control">
                                                <p>
                                                    <select type="text" name="DBVAR_STR_PAIS" id="DBVAR_STR_PAIS" value=""  class="">
                                                        <option value="">Selecione...</option>
                                                            <%MontaCombo "STR","SELECT ID_PAIS, PAIS FROM TBL_PAISES  ORDER BY PAIS", "ID_PAIS","PAIS",""%>
                                                    </select>
                                                </p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                     </div><!--FIM row//-->
                                    <div class="row">
                                        <div class="span2"><p>Montadora:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_MONTADORA" name="DBVAR_STR_MONTADORA" type="text" placeholder="" value="" maxlength="100" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                </div><!--FIM GRID//-->
                            </div><!--fim do frame geral3//-->
                            <div class="frame" id="AGENCIA">
                                <div class="grid" style="border:0px solid #F00">
                                										<div class="row">
                                        <div class="span2"><p>Agencia Turismo:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_AGENCIA_TURISMO" name="DBVAR_STR_AGENCIA_TURISMO" type="text" placeholder="" value="" maxlength="255" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>Agencia Publicidade:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_AGENCIA_PUBLICIDADE" name="DBVAR_STR_AGENCIA_PUBLICIDADE" type="text" placeholder="" value="" maxlength="100" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>Agencia Bancaria:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_AGENCIA_BANCARIA" name="DBVAR_STR_AGENCIA_BANCARIA" type="text" placeholder="" value="" maxlength="255" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                </div><!--FIM GRID//-->
                            </div><!--fim do frame agencia//-->
                            <div class="frame" id="SMS">
                                <div class="grid" style="border:0px solid #F00">
									<div class="row">
                                        <div class="span2"><p>SMS User/SMS Pwd:</p></div>
                                        <div class="span8">
                                            <div class="input-control text size3" data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_SMS_USER" name="DBVAR_STR_SMS_USER" type="text" placeholder="" value="" maxlength="45" class="" onKeyPress="">
                                                </p>
                                            </div>
                                            <div class="input-control text size2" data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_SMS_PWD" name="DBVAR_STR_SMS_PWD" type="password" placeholder="" value="" maxlength="45" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>SMS Texto:</p></div>
                                        <div class="span8">
                                            <div class="input-control  textarea" data-role="input-control">
                                                <p>
                                                	<textarea id="DBVAR_STR_SMS_TEXTO" name="DBVAR_STR_SMS_TEXTO" class="" onKeyPress=""></textarea>
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div>                            
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame16//--> 
                            <!--<div class="frame" id="MINI">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Descrição:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea">
                                             	<textarea name="DBVAR_STR_DESCRICAO" id="DBVAR_STR_DESCRICAO"></textarea>
                                             </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('DESCRICAO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
                                    <div class="row">
                                        <div class="span2" style=""><p>Programação:</p></div>
                                        <div class="span8"> 

                                             <p class="input-control textarea">
                                             	<textarea name="DBVAR_STR_PROGRAMACAO" id="DBVAR_STR_PROGRAMACAO"></textarea>
                                             </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('PROGRAMACAO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
									        
                                </div> <!--FIM GRID//-->
                            <!--/div><!--fim do RESUMO//--> 
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid layout//-->
            </div><!--fim frame dados//-->
                
            <div class="frame" id="CFGEMAIL" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="tab-control" data-role="tab-control">
                    <ul class="tabs">
                        <li class="active"><a href="#_page_2_1_1">E-MAIL</a></li>
                        <li><a href="#_page_2_1_2">EMAIL EXTRA</a></li>
                        <li><a href="#_page_2_2_1">SMTP</a></li>
                    </ul>
                        <div class="frames">
                            <div class="frame" id="_page_2_1_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Oficial Evento:</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL" name="DBVAR_STR_EMAIL" type="text" placeholder="" value="" maxlength="250" >
                                                    </p>
                                                </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div>
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Remetente:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_SENDER" name="DBVAR_STR_EMAIL_SENDER" type="text" placeholder="" value="" maxlength="180">
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div> 
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Imprensa: </p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_PRESS" name="DBVAR_STR_EMAIL_PRESS" type="text" placeholder="" value="" maxlength="180" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div>
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Auditoria:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_AUDITORIA" name="DBVAR_STR_EMAIL_AUDITORIA" type="text" placeholder="" value="" maxlength="180">
                                                    </p>
                                                </div>       
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div>
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Auditoria Intl:</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_AUDITORIA_INTL" name="DBVAR_STR_EMAIL_AUDITORIA_INTL" type="text" placeholder="" value="" maxlength="180" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div>
                                    
                                </div><!--fim grid layout//-->  
                            </div><!--fim FRAME _page_2_1_1//-->
                            
                            <div class="frame" id="_page_2_1_2">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail CAEX (Reply):</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_REPLY_CAEX" name="DBVAR_STR_EMAIL_REPLY_CAEX" type="text" placeholder="" value="" maxlength="100" >
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Congressista (Reply):</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_REPLY_CONGRESSISTA" name="DBVAR_STR_EMAIL_REPLY_CONGRESSISTA" type="text" placeholder="" value="" maxlength="100">
                                                    </p>
                                                </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div> <!--FIM row//-->
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Palestrante (Reply):</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text" data-role="input-control">
                                                    <p>	
                                                        <input id="DBVAR_STR_EMAIL_REPLY_PALESTRANTE" name="DBVAR_STR_EMAIL_REPLY_PALESTRANTE" type="text" placeholder="" value="" maxlength="100" >
                                                    </p>
                                                </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Trabalho (Reply):</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_REPLY_PAPER" name="DBVAR_STR_EMAIL_REPLY_PAPER" type="text" placeholder="" value="" maxlength="100">
                                                    </p>
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                            <div class="span2" style=""><p>E-mail Visitante (Reply):</p></div>
                                            <div class="span8"> 
                                                 <div class="input-control text" data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_EMAIL_REPLY_VISITANTE" name="DBVAR_STR_EMAIL_REPLY_VISITANTE" type="text" placeholder="" value="" maxlength="100" >
                                                    </p>                                                 
                                                 </div>
                                                 <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                    </div><!--FIM row//-->
                                    
                                </div><!--fim grid EMAIL EXTRA//-->  
                            </div><!--fim FRAME _page_2_1_2//-->
                            
                            <div class="frame" id="_page_2_2_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>SMTP Server:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>                                            
                                                    <input type="text" name="DBVAR_STR_SMTP_SERVER" id="DBVAR_STR_SMTP_SERVER" value="" maxlength="120">
                                                </p>                                            
                                            </div>
                                             <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                        <div class="span2" style=""><p>SMTP Usuário:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_SMTP_USER" name="DBVAR_STR_SMTP_USER" type="text" placeholder="" value="" maxlength="120">
                                                </p>	
                                            </div>
                                             <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div> <!--FIM row//-->
                                    
                                    <div class="row">
                                        <div class="span2" style=""><p>SMTP Senha:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                                    <p>                                            
                                                        <input id="DBVAR_STR_SMTP_PWD" name="DBVAR_STR_SMTP_PWD" type="password" data-transform="input-control" placeholder="" value="" maxlength="45" >
                                                    </p>                                            
                                            </div>
                                           <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div><!--FIM row//-->
                                    
                                    <div class="row">
                                        <div class="span2" style=""><p>SMTP Porta:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_SMTP_PORT" name="DBVAR_STR_SMTP_PORT" type="text" placeholder="" value="" maxlength="45" >
                                                </p>
                                            </div>
                                           <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div><!--FIM row//-->
                                    
                                </div><!--FIM GRID//-->
                            </div><!--fim do frame _page_2_2_1//-->
                            
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid layout//-->
            </div><!--fim frame CFGEMAIL//-->  
		              
            <div class="frame" id="CFGMOEDA" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
						<h6><span class="tertiary-text-secondary">Categoria Status Credencial (Padrão)</span></h6>
                    <div class="row">
                        <div class="span2" ><p>*Status Credencial/*Status Credencial PSC:</p></div>
                        <div class="span8"> 
                             <div class="input-control select size3 info-state" data-role="input-control">
                             	<p>
                                    <select type="text" name="DBVAR_NUM_STATUS_CRED" id="DBVAR_NUM_STATUS_CREDô" class="">
                                        <option value="">Selecione...</option>
                                            <%'MontaCombo "STR","SELECT COD_STATUS_CRED, STATUS FROM TBL_STATUS_CRED ORDER BY ORDEM","COD_STATUS_CRED","STATUS",""%>
                                            <% montaCombo "STR" ,"SELECT COD_STATUS_CRED, CONCAT(CAST(COD_STATUS_CRED AS CHAR), ' - ', CAST(STATUS AS CHAR)) AS STATUS FROM TBL_STATUS_CRED ORDER BY COD_STATUS_CRED", "COD_STATUS_CRED", "STATUS",""%>
                                    </select>
                                </p>
                             </div>
                             <div class="input-control select size3 info-state" data-role="input-control">
                             	<p>                                    
                                    <select type="text" name="DBVAR_STR_PSC_STATUS_CRED" id="DBVAR_STR_PSC_STATUS_CREDô" class="">
                                        <option value="">Selecione...</option>
                                            <%'MontaCombo "STR","SELECT COD_STATUS_CRED, STATUS FROM TBL_STATUS_CRED ORDER BY STATUS","COD_STATUS_CRED","STATUS",""%>
			                                 <% montaCombo "STR" ,"SELECT COD_STATUS_CRED, CONCAT(CAST(COD_STATUS_CRED AS CHAR), ' - ', CAST(STATUS AS CHAR)) AS STATUS FROM TBL_STATUS_CRED ORDER BY COD_STATUS_CRED", "COD_STATUS_CRED", "STATUS",""%>                                            
                                    </select>
                                </p>                                
                             </div>
                             <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div> 
                    <div class="row">
                        <div class="span2"><p>Press Status Cred:</p></div>
                        <div class="span8">
                            <div class="input-control text " data-role="input-control">
                                <p>
                                    <input id="DBVAR_STR_PRESS_STATUS_CRED" name="DBVAR_STR_PRESS_STATUS_CRED" type="text" placeholder="" value="" maxlength="45" class=""  onKeyPress="Javascript:return validateNumKey(event);return false;">
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>
                        </div>
                    </div> 
                        	<h6><span class="tertiary-text-secondary">Categoria Preço (Padrão)</span></h6>                    
                     <div class="row">
                        <div class="span2" style=""><p>Categoria Preço / Categoria Preço Visitant.:</p></div>
                        <div class="span8"> 
                             <div class="input-control select size3" data-role="input-control">
                             	<p>
                                    <select type="text" name="DBVAR_STR_STATUS_PRECO" id="DBVAR_STR_STATUS_PRECO" class="">
                                        <option value="">Selecione...</option>
                                            <%MontaCombo "STR","SELECT COD_STATUS_PRECO, STATUS FROM TBL_STATUS_PRECO ORDER BY STATUS","COD_STATUS_PRECO","STATUS",""%>
                                    </select>
                                </p>
                             </div>
                              <div class="input-control select text size3" data-role="input-control">
                             	<p>
                                    <!-- input id="DBVAR_NUM_STATUS_PRECO_VISITANTE" name="DBVAR_NUM_STATUS_PRECO_VISITANTE" type="text" placeholder="" value="<%'=getValue(objRS,"STATUS_PRECO_VISITANTE")%>" maxlength="11" class=""  onKeyPress="Javascript:return validateNumKey(event);return false;" //-->
                                    <select type="text" name="DBVAR_NUM_STATUS_PRECO_VISITANTE" id="DBVAR_NUM_STATUS_PRECO_VISITANTE" class="">
                                        <option value="">Selecione...</option>
                                            <%MontaCombo "STR","SELECT COD_STATUS_PRECO, STATUS FROM TBL_STATUS_PRECO ORDER BY STATUS","COD_STATUS_PRECO","STATUS",""%>
                                    </select>
                                </p>
                             </div>                                
                             
                             <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div
                      ><h6><span class="tertiary-text-secondary">Moedas</span></h6>
                     <div class="row">
                        <div class="span2" style=""><p>Moeda Evento:</p></div>
                        <div class="span8"> 
                             <div class="input-control select " data-role="input-control">
                             	<p>
                                    <select type="text" name="DBVAR_NUM_COD_MOEDA_EVENTO" id="DBVAR_NUM_COD_MOEDA_EVENTO">
                                        <option value="">Selecione...</option>
                                            <%MontaCombo "STR","SELECT COD_MOEDA, MOEDA FROM TBL_MOEDA ORDER BY MOEDA","COD_MOEDA","MOEDA",""%>
                                    </select>
                             	</p>                             
                             </div>
                             <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div> 
                     <div class="row">
                        <div class="span2" style=""><p>Moeda Cobrança:</p></div>
                         <div class="span8"> 
                             <div class="input-control select " data-role="input-control">
                             	<p>
                                    <select type="text" name="DBVAR_NUM_COD_MOEDA_COBRANCA" id="DBVAR_NUM_COD_MOEDA_COBRANCA">
                                    <option value="">Selecione...</option>
                                        <%MontaCombo "STR","SELECT COD_MOEDA, MOEDA FROM TBL_MOEDA ORDER BY MOEDA","COD_MOEDA","MOEDA",""%>
                                    </select>
                             	</p>
                             </div>                                
                             <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div> 
                     <div class="row">
                        <div class="span2" style=""><p>Moeda Referência:</p></div>
                        <div class="span8"> 
                            <div class="input-control select " data-role="input-control">
                            	<p>    
                                <select type="text" name="DBVAR_NUM_COD_MOEDA_REFERENCIA" id="DBVAR_NUM_COD_MOEDA_REFERENCIA">
                                    <option value="">Selecione...</option>
                                        <%MontaCombo "STR","SELECT COD_MOEDA, MOEDA FROM TBL_MOEDA ORDER BY MOEDA","COD_MOEDA","MOEDA",""%>
                                </select>
                                </p>
                            </div>
                            <span class="tertiary-text-secondary"></span>                             
                        </div>
                     </div> 
                </div><!--fim grid//-->
            </div><!--fim frame CFGMOEDA//-->
            
            <div class="frame" id="STATUS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                         <div class="tab-control" data-role="tab-control">
                            <ul class="tabs">
                                <li class="active"><a href="#_page_2_1_3">Ativar Evento</a></li>
                                <li><a href="#_page_2_2_4">Imp. Controle</a></li>
                            </ul>
                            <div class="frames">
                                <div class="frame" id="_page_2_1_3">
                                    <div class="grid" style="border:0px solid #F00">
                                        <div class="row">
                                            <div class="span2" style=""><p>Evento Gratuito:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_FREE" id="DBVAR_BOOL_FREE"  type="radio" value="1" >
                                                        Sim 
                                                    <input name="DBVAR_BOOL_FREE" id="DBVAR_BOOL_FREE2"  type="radio" value="0" >
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="span2" style=""><p>Evento Ativo:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_DATE_SYS_INATIVO" id="DBVAR_DATE_SYS_INATIVO"  type="radio" value="" >
                                                        Sim 
                                                    <input name="DBVAR_DATE_SYS_INATIVO" id="DBVAR_DATE_SYS_INATIVO2" type="radio" value="<%=Now()%>" >
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="span2" style=""><p>Cupom Fiscal:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_CUPOM_FISCAL" id="DBVAR_BOOL_CUPOM_FISCAL" type="radio" value="1" >
                                                        Sim 
                                                    <input name="DBVAR_BOOL_CUPOM_FISCAL" id="DBVAR_BOOL_CUPOM_FISCAL2" type="radio" value="0" >
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="span2" style=""><p>Venda Rápida:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_VENDA_RAPIDA" id="DBVAR_BOOL_VENDA_RAPIDA" type="radio" value="1" >
                                                        Sim 
                                                    <input name="DBVAR_BOOL_VENDA_RAPIDA" id="DBVAR_BOOL_VENDA_RAPIDA2" type="radio" value="0"  >
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </DIV>
                                    </div><!--FIM DO SUB GRID//-->
                                </div><!--fim SUB FRAME//-->  
                                <div class="frame" id="_page_2_2_4">
                                    <div class="grid" style="border:0px solid #F00">
                                        <div class="row">
                                            <div class="span2" style=""><p>Retirada Material:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_RETIRADA_MATERIAL" id="DBVAR_BOOL_RETIRADA_MATERIAL"  type="radio" value="1" >
                                                        Sim 
                                                    <input name="DBVAR_BOOL_RETIRADA_MATERIAL" id="DBVAR_BOOL_RETIRADA_MATERIAL2" type="radio" value="0" >
                                                        Não 
                                                </p>
                                            <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 
                                        <div class="row">
                                            <div class="span2" style=""><p>Controle Credencial:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_CRED_PRINT_CONTROLE" id="DBVAR_BOOL_CRED_PRINT_CONTROLE"  type="radio" value="1" >
                                                        Sim 
                                                    <input name="DBVAR_BOOL_CRED_PRINT_CONTROLE" id="DBVAR_BOOL_CRED_PRINT_CONTROLE2" type="radio" value="0"  >
                                                        Não 
                                                </p>
                                            <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 
                                        <div class="row">
                                            <div class="span2" style=""><p>Imprimir Credencial Visitante:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_IMPRIMIR_VISITANTE" id="DBVAR_BOOL_IMPRIMIR_VISITANTE"  type="radio" value="1" >
                                                        Sim 
                                                    <input name="DBVAR_BOOL_IMPRIMIR_VISITANTE" id="DBVAR_BOOL_IMPRIMIR_VISITANTE2"  type="radio" value="0" >
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 
									  <div class="row">
                                            <div class="span2" style=""><p>Imprimir Credencial Congressista:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_IMPRIMIR_CONGRESSISTA" id="DBVAR_BOOL_IMPRIMIR_CONGRESSISTA"  type="radio" value="1" >
                                                        Sim 
                                                    <input name="DBVAR_BOOL_IMPRIMIR_CONGRESSISTA" id="DBVAR_BOOL_IMPRIMIR_CONGRESSISTA2"  type="radio" value="0" >
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 

                                        <div class="row">
                                            <div class="span2" style=""><p>ByPass Cortesia:</p></div>
                                            <div class="span8"> 
                                                <p>
                                                    <input name="DBVAR_BOOL_BYPASS_CORTESIA" id="DBVAR_BOOL_BYPASS_CORTESIA"  type="radio" value="1" >
                                                        Sim 
                                                    <input name="DBVAR_BOOL_BYPASS_CORTESIA" id="DBVAR_BOOL_BYPASS_CORTESIA2"  type="radio" value="0" >
                                                        Não 
                                                </p>
                                                <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div> 

                                        <div class="row">
                                            <div class="span2" style=""><p>Padrão Código Barras/Altura Código de Barras:</p></div>
                                            <div class="span8"> 
                                                <div class="input-control select size2" data-role="input-control">
                                                        <p>
                                                            <select name="DBVAR_STR_BARCODE_MODE" id="DBVAR_STR_BARCODE_MODE" class="">
                                                            <option value="code39" 	 >Code39</option>
                                                            <option value="code128b" >Code128b</option>
                                                            <option value="UPC-A" 	 >UPC-A</option>
                                                            <option value="EAN-13" 	 >EAN-13</option>
                                                            <option value="Postal"   >Postal</option>
                                                            <option value="Planet"   >Planet</option>
                                                            <option value="qrcode"   >QRCode</option>
                                                            </select>
                                                        </p>
                                                    </div>
                                                    <div class="input-control text size2" data-role="input-control">                                                    
                                                        <p>
                                                            <input type="text" name="DBVAR_NUM_BARCODE_HEIGHT" id="DBVAR_NUM_BARCODE_HEIGHT" value="" class="">
                                                        </p>
                                                    </div>
                                                    <span class="tertiary-text-secondary">(pixels)</span>                             
                                        	</div>
                                        </div>
                                        <div class="row">
                                            <div class="span2" style=""><p>Inscrição Municipal:</p></div>
                                            <div class="span8"> 
                                                <div class="input-control text" data-role="input-control">
                                                    <p>
                                                    	<input type="text" name="DBVAR_STR_INSCR_MUNICIPAL" id="DBVAR_STR_INSCR_MUNICIPAL" value="" >
                                                	</p>
                                                </div>
                                               <span class="tertiary-text-secondary"></span>                             
                                            </div>
                                        </div>
                                    </div> <!--FIM GRID//-->
                                </div><!--fim do frame14//-->
                            </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid STATUS//-->
            </div><!--fim frame STATUS//-->
            
            <div class="frame" id="HTMLTXT" style="width:100%;"><!--esta guia contem tab dentro de tab//-->
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="tab-control" data-role="tab-control">
                                <ul class="tabs">
                                    <li class="active"><a href="#RECIBO">DADOS RECIBO</a></li>
                                    <!--li><a href="#ARIEL">ARIEL</a></li//-->
                                    <li><a href="#ARM">ARM</a></li>
                                    <li><a href="#ACE">ACE</a></li>
                                    <li><a href="#CONVITE">CONVITE</a></li>
                                    <li><a href="#APE">APE</a></li>
                                    <li><a href="#ATESTADOS">ATESTADO</a></li>
                                    <li><a href="#TEXTO">CERT. TXT</a></li>
                                    <li><a href="#UPLOAD">UPLOAD</a></li>
                                    <li><a href="#PAPER">PAPER</a></li>
                                </ul>
                        <div class="frames">
                            <div class="frame" id="RECIBO">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                                <div class="span2" style=""><p>Recibo A4:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_RECIBO_TEXTO" id="DBVAR_STR_RECIBO_TEXTO"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('RECIBO_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Cabeçalho:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_CABECALHO" id="DBVAR_STR_CABECALHO"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CABECALHO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Rodapé:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_RODAPE" id="DBVAR_STR_RODAPE"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('RODAPE');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                      <div class="row">
                                                <div class="span2" style=""><p>Instrucao Insc. Existente:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_INSTRUCAO_INSC_EXISTENTE" id="DBVAR_STR_INSTRUCAO_INSC_EXISTENTE"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('INSTRUCAO_INSC_EXISTENTE');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Cabeçalho Recibo:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_CABECALHO_RECIBO" id="DBVAR_STR_CABECALHO_RECIBO"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CABECALHO_RECIBO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                </div><!--fim grid layout//-->  
                            </div><!--fim frame recibo//-->
                            <!--div class="frame" id="ARIEL">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                                <div class="span2" style=""><p>Ariel Texto:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_ARIEL_TEXTO" id="DBVAR_STR_ARIEL_TEXTO"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARIEL_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    <div class="row">
                                                <div class="span2" style=""><p>Ariel Texto Intl:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_ARIEL_TEXTO_INTL" id="DBVAR_STR_ARIEL_TEXTO_INTL"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARIEL_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    <div class="row">
                                                <div class="span2" style=""><p>Ariel Texto NPG:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_ARIEL_TEXTO_NPG" id="DBVAR_STR_ARIEL_TEXTO_NPG"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARIEL_TEXTO_NPG');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    
                                </div><!--fim grid layout//-->  
                            <!--/div//--><!--fim frame ariel//-->
                            <div class="frame" id="ARM">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ARM:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ARM_TEXTO" id="DBVAR_STR_ARM_TEXTO"></textarea>
                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ARM Intl:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ARM_TEXTO_INTL" id="DBVAR_STR_ARM_TEXTO_INTL"></textarea>
                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ARM Intl2:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ARM_TEXTO_INTL2" id="DBVAR_STR_ARM_TEXTO_INTL2"></textarea>
                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_TEXTO_INTL2');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>


                                    <div class="row">
                                        <div class="span2" style=""><p>ARM Assunto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ARM_ASSUNTO" id="DBVAR_STR_ARM_ASSUNTO" value="" maxlength="250">
                                                <!--<textarea name="DBVAR_STR_ARM_ASSUNTO" id="DBVAR_STR_ARM_ASSUNTO" ><'%=ReturnCaracterEspecial(objRS("ARM_ASSUNTO")&"") %></textarea>-->
                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_ASSUNTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ARM Assunto Intl:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ARM_ASSUNTO_INTL" id="DBVAR_STR_ARM_ASSUNTO_INTL" value="" maxlength="250">
<!--                                                <textarea name="DBVAR_STR_ARM_ASSUNTO_INTL" id="DBVAR_STR_ARM_ASSUNTO_INTL"><'%=ReturnCaracterEspecial(objRS("ARM_ASSUNTO_INTL")&"") %></textarea>
-->                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_ASSUNTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="span2" style=""><p>ARM Assunto Intl2:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ARM_ASSUNTO_INTL2" id="DBVAR_STR_ARM_ASSUNTO_INTL2" value="" maxlength="250">
<!--                                                <textarea name="DBVAR_STR_ARM_ASSUNTO_INTL" id="DBVAR_STR_ARM_ASSUNTO_INTL"><'%=ReturnCaracterEspecial(objRS("ARM_ASSUNTO_INTL")&"") %></textarea>
-->                                            </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ARM_ASSUNTO_INTL2');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                 </div><!--fim grid//--> 
                            </div><!--fim frame arm//-->
                            <div class="frame" id="ACE">
                                <div class="grid" style="border:0px solid #F00" >
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ACE:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_TEXTO" id="DBVAR_STR_ACE_TEXTO"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ACE APROVADO:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_APROVADO_TEXTO" id="DBVAR_STR_ACE_APROVADO_TEXTO"></textarea>
                                             </p>
                                             <!--span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                             <span class="tertiary-text-secondary"><a href="javascript:edithtml('ACE_TEXTO');" class=""><i class="icon-pencil"></i>&nbsp;editar HTML&nbsp;</a></span//-->                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ACE BLOQUEADO:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_BLOQUEADO_TEXTO" id="DBVAR_STR_ACE_BLOQUEADO_TEXTO"></textarea>
                                             </p>
                                             <!--span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                             <span class="tertiary-text-secondary"><a href="javascript:edithtml('ACE_TEXTO');" class=""><i class="icon-pencil"></i>&nbsp;editar HTML&nbsp;</a></span//-->                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto ACE Intl:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_TEXTO_INTL" id="DBVAR_STR_ACE_TEXTO_INTL"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Assunto:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ACE_ASSUNTO" id="DBVAR_STR_ACE_ASSUNTO" value="" maxlength="250">
<!--                                             <textarea name="DBVAR_STR_ACE_ASSUNTO" id="DBVAR_STR_ACE_ASSUNTO"><'%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO")&"") %></textarea>
-->                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_ASSUNTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Assunto INTL:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control text " data-role="input-control">
                                                <input type="text" name="DBVAR_STR_ACE_ASSUNTO_INTL" id="DBVAR_STR_ACE_ASSUNTO_INTL" value="" maxlength="250">
<!--                                             <textarea name="DBVAR_STR_ACE_ASSUNTO_INTL" id="DBVAR_STR_ACE_ASSUNTO_INTL"><'%=ReturnCaracterEspecial(objRS("ACE_ASSUNTO")&"") %></textarea>
-->                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_ASSUNTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Texto US:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_TEXTO_US" id="DBVAR_STR_ACE_TEXTO_US"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO_US');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Assunto US:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_ASSUNTO_US" id="DBVAR_STR_ACE_ASSUNTO_US"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_ASSUNTO_US');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Texto SP:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_TEXTO_SP" id="DBVAR_STR_ACE_TEXTO_SP"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_TEXTO_SP');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Assunto SP:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACE_ASSUNTO_SP" id="DBVAR_STR_ACE_ASSUNTO_SP"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACE_ASSUNTO_SP');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Imprensa:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACEPRESS_TEXTO" id="DBVAR_STR_ACEPRESS_TEXTO"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACEPRESS_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Imprensa US:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACEPRESS_TEXTO_US" id="DBVAR_STR_ACEPRESS_TEXTO_US"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACEPRESS_TEXTO_US');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>ACE Imprensa ES:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACEPRESS_TEXTO_ES" id="DBVAR_STR_ACEPRESS_TEXTO_ES"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACEPRESS_TEXTO_ES');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
									<div class="row">
                                        <div class="span2" style=""><p>ACE Imprensa Intl:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_ACEPRESS_TEXTO_INTL" id="DBVAR_STR_ACEPRESS_TEXTO_INTL"></textarea>
                                             </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ACEPRESS_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                </div><!--fim grid //--> 
                            </div><!--FIM DO FRAME ACE//-->
                            
                            <div class="frame" id="CONVITE">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto Convite: </p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_CONVITE_TEXTO" id="DBVAR_STR_CONVITE_TEXTO"></textarea>
                                                </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CONVITE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto Convite VIP:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_CONVITE_VIP_TEXTO" id="DBVAR_STR_CONVITE_VIP_TEXTO"></textarea>
                                                </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CONVITE_VIP_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto Convite Eletrônico:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_CONVITE_ELETRONICO_TEXTO" id="DBVAR_STR_CONVITE_ELETRONICO_TEXTO"></textarea>
                                                </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CONVITE_ELETRONICO_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Texto Convite Eletrônico Intl:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_CONVITE_ELETRONICO_TEXTO_INTL" id="DBVAR_STR_CONVITE_ELETRONICO_TEXTO_INTL"></textarea>
                                                </p>
                                             <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CONVITE_ELETRONICO_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                </div><!--fim grid//--> 
                            </div><!--fim FRAME CONVITE//-->
                            <div class="frame" id="APE">
                               <div class="grid" style="border:0px solid #F00">
                                     <div class="row">
                                                <div class="span2" style=""><p>Texto APE:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                        <textarea name="DBVAR_STR_APE_TEXTO" id="DBVAR_STR_APE_TEXTO"  ></textarea>
                                                            </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('APE_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Texto APE Intl:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                        <textarea name="DBVAR_STR_APE_TEXTO_INTL" id="DBVAR_STR_APE_TEXTO_INTL"  ></textarea>
                                                            </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('APE_TEXTO_INTL');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Assunto APE :</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control text " data-role="input-control">
                                                     <input id="DBVAR_STR_APE_ASSUNTO" name="DBVAR_STR_APE_ASSUNTO" type="text" placeholder="" value="" maxlength="150" class="" onKeyPress="">
                                                            </p>
                                                     <span class="tertiary-text-secondary"></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Assunto APE Intl:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control text " data-role="input-control">
                                                     <input id="DBVAR_STR_APE_ASSUNTO_INTL" name="DBVAR_STR_APE_ASSUNTO_INTL" type="text" placeholder="" value="" maxlength="150" class="" onKeyPress="">
                                                            </p>
                                                     <span class="tertiary-text-secondary"></span>                             
                                                </div>
                                     </div>
                                 </div><!--fim grid layout//--> 
                            </div><!--fim FRAME ape//-->
                            
                            <div class="frame" id="ATESTADOS">

                               <div class="grid" style="border:0px solid #F00">
                                     <div class="row">
                                                <div class="span2" style=""><p>Texto Atestado: </p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                        <textarea name="DBVAR_STR_ATESTADO_TEXTO" id="DBVAR_STR_ATESTADO_TEXTO"  ></textarea>
                                                            </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ATESTADO_TEXTO');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Atestado PDF Orientação:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control select " data-role="input-control">
                                                <select name="DBVAR_STR_ATESTADO_PDF_ORIENTACAO" id="DBVAR_STR_ATESTADO_PDF_ORIENTACAO" class="arial11">
                                                    <option value="RETRATO"	 >RETRATO</option>
                                                    <option value="PAISAGEM" >PAISAGEM</option>
                                                </select>
                                            </p>
                                            <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Atestado PDF: </p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_ATESTADO_PDF" id="DBVAR_STR_ATESTADO_PDF"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('ATESTADO_PDF');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                 </div><!--fim grid layout//--> 
                            </div><!--fim FRAME atestado//-->
                            <div class="frame" id="TEXTO">
                               <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                                <div class="span2" style=""><p>Certificado Texto1:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_CERTIFICADO_TEXTO1" id="DBVAR_STR_CERTIFICADO_TEXTO1"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CERTIFICADO_TEXTO1');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                     <div class="row">
                                                <div class="span2" style=""><p>Certificado Texto2:</p></div>
                                                <div class="span8"> 
                                                     <p class="input-control textarea " data-role="input-control">
                                                     	<textarea name="DBVAR_STR_CERTIFICADO_TEXTO2" id="DBVAR_STR_CERTIFICADO_TEXTO2"></textarea>
                                                     </p>
                                                     <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CERTIFICADO_TEXTO2');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                                </div>
                                     </div>
                                    
                                 </div><!--fim grid layout//--> 
                            </div><!--fim FRAME texto//-->
                            <div class="frame" id="UPLOAD">
                                <div class="grid" style="border:0px solid #F00">
                               <!--<div class="row">
                                        <div class="span2"><p>IMG2:</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_IMG2" name="DBVAR_STR_IMG2" type="text" placeholder="" value="" maxlength="45" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>
                                        </div>
                                    </div> //-->

                                    <div class="row">
                                        <div class="span2"><p>Upload Imagens:</p></div>
                                        <div class="span8">
                                            <div class="input-control file">
                                                <input type="text" name="var_arquivo" id="var_arquivo" />
                                                <button class="btn-file" onClick="javascript:UploadImage('formupdate','var_arquivo','\\imgdin\\');"></button>
                                                <span class="tertiary-text-secondary"></span>
                                            </div>                     
                                            <span class="tertiary-text-secondary">Atalho para upload na pasta \IMGDIN </span>                             
                                        </div>
                                    </div>
                                </div><!--fim grid layout//--> 
                            </div><!--fim FRAME upload//-->
                            <div class="frame" id="PAPER">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Cabeçalho Paper:</p></div>
                                        <div class="span8"> 
                                        <p class="input-control textarea " data-role="input-control">
                                        	<textarea name="DBVAR_STR_CABECALHO_PAPER" id="DBVAR_STR_CABECALHO_PAPER"></textarea>
                                        </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CABECALHO_PAPER');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Rodapé Paper:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                            	<textarea name="DBVAR_STR_RODAPE_PAPER" id="DBVAR_STR_RODAPE_PAPER"></textarea>
                                            </p>
                                            <span class="tertiary-text-secondary"><a href="javascript:viewdoc('RODAPE_PAPER');" class=""><i class="icon-search"></i>&nbsp;visualizar&nbsp;</a></span>    
                                        </div>                       
                                    </div>
                                </div> <!--fim grid layout//-->
                            </div><!--fim FRAME paper//-->               
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid //-->
            </div><!--fim frame HTMLTXT//-->
            
            <div class="frame" id="LOJA" style="width:100%;"><!--esta guia contem tab dentro de tab//-->
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="tab-control" data-role="tab-control">
                        <ul class="tabs">
                            <li class="active"><a href="#_page_12_1_1">GERAL</a></li>
                            <li><a href="#_page_13_2_1">EXIB.DADOS</a></li>
                            <li><a href="#_page_14_2_1">ATIV.DADOS</a></li>
                            <li><a href="#_page_15_2_1">REGRAS</a></li>
                            
                        </ul>
            
                        <div class="frames">
                            <div class="frame" id="_page_12_1_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Usuário Loja:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control select " data-role="input-control">
                                                <select name="DBVAR_STR_IDUSER_LOJA" id="DBVAR_STR_IDUSER_LOJA" class="">
                                                    <option value="">Selecione...</option>
                                                        <% MontaCombo "STR","SELECT ID_USER FROM TBL_USUARIO ORDER BY ID_USER","ID_USER","ID_USER","" %>
                                                </select>	
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2"><p>Background Loja(IMG1):</p></div>
                                        <div class="span8">
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_IMG1" name="DBVAR_STR_IMG1" type="text" placeholder="" value="" maxlength="255" class="" onKeyPress="">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">Endereço da imagem (ex.: [http://pvista.proevento.com.br/qe/imgdin/bgshop_135.jpg] ou [../imgdin/bgshop_135.jpg]</span>
                                        </div>
                                    </div>                                     
                                    <div class="row">
                                        <div class="span2" style=""><p>Cabeçalho Loja:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                            	<textarea name="DBVAR_STR_CABECALHO_LOJA" id="DBVAR_STR_CABECALHO_LOJA"></textarea>
                                            </p>
                                            <span class="tertiary-text-secondary"><a href="javascript:viewdoc('CABECALHO_LOJA');" class=""><i class="icon-search"></i> visualizar</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Rodapé Loja:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                            	<textarea name="DBVAR_STR_RODAPE_LOJA" id="DBVAR_STR_RODAPE_LOJA"></textarea>
                                            </p>
                                            <span class="tertiary-text-secondary"><a href="javascript:viewdoc('RODAPE_LOJA');" class=""><i class="icon-search"></i> visualizar</a></span>                             
                                        </div>
                                    </div>  
                                    <div class="row">
                                    <div class="span2" style=""><p>Categoria Aberta:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_STATUS_PRECO" id="DBVAR_BOOL_LOJA_STATUS_PRECO" type="radio" value="1" >
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_STATUS_PRECO" id="DBVAR_BOOL_LOJA_STATUS_PRECO2"  type="radio" value="0" >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Pixel Facebook ID:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                            	<input type="text" placeholder="" value="" maxlength="255" class="" onKeyPress="" name="DBVAR_STR_LOJA_FACEBOOK_PIXELID" id="DBVAR_STR_LOJA_FACEBOOK_PIXELID">
                                            </p>
                                            <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div> 
                                </div><!--fim grid layout//-->  
                            </div><!--fim do frame12//-->

                      <tr>
                            <div class="frame" id="_page_13_2_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir dados pessoais:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_SHOW_DADOS" id="DBVAR_BOOL_LOJA_SHOW_DADOS" type="radio" value="1" >
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_SHOW_DADOS" id="DBVAR_BOOL_LOJA_SHOW_DADOS2" type="radio" value="0" >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir entidade na loja:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_SHOW_ENTIDADE" id="DBVAR_BOOL_LOJA_SHOW_ENTIDADE"  type="radio" value="1" >
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_SHOW_ENTIDADE" id="DBVAR_BOOL_LOJA_SHOW_ENTIDADE2" type="radio" value="0"  >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir Entidade Obrigatório:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_ENTIDADE_OBRIGATORIO" id="DBVAR_BOOL_ENTIDADE_OBRIGATORIO"  type="radio" value="1" >
                                                    Sim 
                                                <input name="DBVAR_BOOL_ENTIDADE_OBRIGATORIO" id="DBVAR_BOOL_ENTIDADE_OBRIGATORIO2"  type="radio" value="0" >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir Financeiro na Loja:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_SHOW_FINANCEIRO" id="DBVAR_BOOL_LOJA_SHOW_FINANCEIRO" type="radio" value="1" >
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_SHOW_FINANCEIRO" id="DBVAR_BOOL_LOJA_SHOW_FINANCEIRO2" type="radio" value="0"  >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Exibir Faturamento na Loja:</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_SHOW_FATURAMENTO" id="DBVAR_BOOL_LOJA_SHOW_FATURAMENTO"  type="radio" value="1" >
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_SHOW_FATURAMENTO" id="DBVAR_BOOL_LOJA_SHOW_FATURAMENTO2" type="radio" value="0"  >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Pesquisa CNPJ (WebService):</p></div>
                                        <div class="span8"> 
                                            <p>
                                                <input name="DBVAR_BOOL_LOJA_PESQUISA_CNPJ" id="DBVAR_BOOL_LOJA_PESQUISA_CNPJ"  type="radio" value="1" >
                                                    Sim 
                                                <input name="DBVAR_BOOL_LOJA_PESQUISA_CNPJ" id="DBVAR_BOOL_LOJA_PESQUISA_CNPJ2"  type="radio" value="0"  >
                                                    Não 
                                            </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                </div><!--fim grid layout//-->  
                            </div><!--fim do frame13//-->
                            <div class="frame" id="_page_14_2_1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Loja Tipo Login:</p></div>
                                        <div class="span8"> 
                                        <p class="input-control select " data-role="input-control">
                                            <select name="DBVAR_STR_LOJA_TIPO_LOGIN" id="DBVAR_STR_LOJA_TIPO_LOGIN" class="size3">
                                                <option value="ID_NUM_DOC1">CPF(id_num_doc1) </option>
                                                <option value="EMAIL1">E-MAIL </option>
                                            </select>
                                        </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Loja Ativa/Loja PAPER ativa:</p></div>
                                        <div class="span8"> 
                                            <!--<div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy <'%=Time%>" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_DATETIME_LOJA_ATIVA" name="DBVAR_DATETIME_LOJA_ATIVA" type="text" placeholder="" value="" maxlength="11">
                                                <span class="btn-date"></span>
                                              </p>  
                                            </div>-->
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="input-control">
                                                <input id="DBVAR_DATETIME_LOJA_ATIVA" name="DBVAR_DATETIME_LOJA_ATIVA" type="text" placeholder="DD/MM/AAAA HH:MM" value="" maxlength="20">
                                              </p>  
                                            </div>	
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_DATETIME_SUBPAPER_ATIVA" name="DBVAR_DATETIME_SUBPAPER_ATIVA" type="text" placeholder="" value="" maxlength="11">
                                                <span class="btn-date"></span>
                                              </p>  
                                            </div>	
                                        <span class="tertiary-text-secondary">O campo Loja ativa usa [Data/Hora] no padrão  DD/MM/AAAA HH:MM:SS.</span>                         
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Modelo Loja PJ:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                            	<p>
                                                <input type="text" name="DBVAR_STR_MODELO_LOJAPJ" id="DBVAR_STR_MODELO_LOJAPJ" value="" maxlength="1">
                                            	<p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                   
                                    <div class="row">
                                        <div class="span2" style=""><p>PSC Ativa/Loja Ativa PJ:</p></div>
                                        <div class="span8">
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_DATETIME_PSC_ATIVA" name="DBVAR_DATETIME_PSC_ATIVA" type="text" placeholder="DD/MM/AAAA HH:MM" value="" maxlength="16">
                                                <span class="btn-date"></span>
                                              </p>  
                                            </div>	
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_DATETIME_LOJAPJ_ATIVA" name="DBVAR_DATETIME_LOJAPJ_ATIVA" type="text" placeholder="" value="" maxlength="11">
                                                <span class="btn-date"></span>
                                              </p>  
                                            </div>	
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>
                                    
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame14//-->
                            <div class="frame" id="_page_15_2_1">
                                <div class="grid" style="border:0px solid #F00">
									<div class="row">
                                        <div class="span2" style=""><p>Regulamento Loja:</p></div>
                                        <div class="span8"> 
                                        <p class="input-control textarea " data-role="input-control">
                                        	<textarea name="DBVAR_STR_REGULAMENTO_LOJA" id="DBVAR_STR_REGULAMENTO_LOJA" ></textarea>
                                        </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('REGULAMENTO_LOJA');" class=""><i class="icon-search"></i> visualizar</a></span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Regulamento Loja Intl:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_REGULAMENTO_LOJA_INTL" id="DBVAR_STR_REGULAMENTO_LOJA_INTL" ></textarea>
                                            </p>
                                                <span class="tertiary-text-secondary"><a href="javascript:viewdoc('REGULAMENTO_LOJA_INTL');" class=""><i class="icon-search"></i> visualizar</a></span>    
                                        </div>                       
                                    </div>   

                                     <div class="row">
                                        <div class="span2" style=""><p>Regulamento Loja Intl2:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_REGULAMENTO_LOJA_INTL2" id="DBVAR_STR_REGULAMENTO_LOJA_INTL2" ></textarea>
                                            </p>
                                                <span class="tertiary-text-secondary"><a href="javascript:viewdoc('REGULAMENTO_LOJA_INTL2');" class=""><i class="icon-search"></i> visualizar</a></span>    
                                        </div>                       
                                    </div>  

                                    <div class="row">
                                        <div class="span2" style=""><p>TP Acesso Totem:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                <input type="text" name="DBVAR_STR_TP_ACESSO_TOTEM" id="DBVAR_STR_TP_ACESSO_TOTEM" value="" > 
                                             	</p>
                                             </div>
                                            <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Aviso Loja Inativa:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_AVISO_LOJA_INATIVA" id="DBVAR_STR_AVISO_LOJA_INATIVA" rows="5" cols="50" class="arial11"></textarea></p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('AVISO_LOJA_INATIVA');" class=""><i class="icon-search"></i> visualizar</a></span>   
                                        </div>
                                    </div>                                   
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame15//-->
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid layout//-->
            </div><!--fim frame layout//-->
            
            <div class="frame" id="CORRESPONDENCIA" style="width:100%;"><!--esta guia contem tab dentro de tab//-->
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="tab-control" data-role="tab-control">
                        <ul class="tabs">
                            <li class="active"><a href="#MOD1">M1</a></li>
                            <li><a href="#MOD2">M2</a></li>
                            <li><a href="#MOD3">M3</a></li>
                            <li><a href="#MOD4">M4</a></li>
                            <li><a href="#MOD5">M5</a></li>
                            <li><a href="#MOD6">M6</a></li>
                            <li><a href="#MOD7">M7</a></li>
                            <li><a href="#MOD8">M8</a></li>
                            <li><a href="#MOD9">M9</a></li>
                            <li><a href="#MOD10">M10</a></li>                                                                                    
                        </ul>
                        <div class="frames">
                            <div class="frame" id="MOD1">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 1- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                <input type="text" name="DBVAR_STR_MOD1_TITLE" id="DBVAR_STR_MOD1_TITLE" value="" > 
                                             	</p>
                                             </div>
                                            <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 1- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD1_TEXTO" id="DBVAR_STR_MOD1_TEXTO" rows="5" cols="50" class="arial11"></textarea></p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD1_TEXTO');" class=""><i class="icon-search"></i> visualizar</a></span>   
                                        </div>
                                    </div>   
                                </div><!--fim grid layout//-->  
                            </div><!--fim FRAME MOD1//-->
                            <div class="frame" id="MOD2">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 2- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 <input type="text" name="DBVAR_STR_MOD2_TITLE" id="DBVAR_STR_MOD2_TITLE" value="" > 
                                             	</p>
                                             </div>
                                        <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 2- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD2_TEXTO" id="DBVAR_STR_MOD2_TEXTO" ></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD2_TEXTO');" class=""><i class="icon-search"></i> visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid layout//--> 
                            </div><!--fim FRAME MOD2//-->
                            <div class="frame" id="MOD3">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 3- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 <input type="text" name="DBVAR_STR_MOD3_TITLE" id="DBVAR_STR_MOD3_TITLE" value="" >
                                             	</p>
                                             </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 3- Texto:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD3_TEXTO" id="DBVAR_STR_MOD3_TEXTO"></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD3_TEXTO');" class=""><i class="icon-search"></i> visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid //--> 
                            </div><!--FIM FRAME MOD3//-->
                            <div class="frame" id="MOD4">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 4- Título:</p></div>
                                        <div class="span8">
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 <input type="text" name="DBVAR_STR_MOD4_TITLE" id="DBVAR_STR_MOD4_TITLE" value="" > 
                                             	</p>
                                             </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 4- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD4_TEXTO" id="DBVAR_STR_MOD4_TEXTO" ></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD4_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid //--> 
                            </div><!--fim frame mod4//-->
                            <div class="frame" id="MOD5">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 5- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 <input type="text" name="DBVAR_STR_MOD5_TITLE" id="DBVAR_STR_MOD5_TITLE" value="" > 
                                             	</p>
                                             </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 5- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD5_TEXTO" id="DBVAR_STR_MOD5_TEXTO" ></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD5_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid //--> 
                            </div><!--fim frame mod5//-->
                            <div class="frame" id="MOD6">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 6- Título:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text" data-role="input-control">
                                             	<p>
                                                 	<input type="text" name="DBVAR_STR_MOD6_TITLE" id="DBVAR_STR_MOD6_TITLE" value="" >
                                             	</p>
                                             </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 6- Texto:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea">
                                             	<textarea name="DBVAR_STR_MOD6_TEXTO" id="DBVAR_STR_MOD6_TEXTO"></textarea>
                                             </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD6_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>   
                                 </div><!--fim grid//--> 
                            </div><!--fim frame mod6//-->
                            <div class="frame" id="MOD7">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 7- Título:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                            	<p>
													<input type="text" name="DBVAR_STR_MOD7_TITLE" id="DBVAR_STR_MOD7_TITLE" value=""> 
                                            	</p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 7- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD7_TEXTO" id="DBVAR_STR_MOD7_TEXTO"></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD7_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame mod7 //-->

                            <div class="frame" id="MOD8">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 8- Título:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                            	<p>
													<input type="text" name="DBVAR_STR_MOD8_TITLE" id="DBVAR_STR_MOD8_TITLE" value=""> 
                                            	</p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 8- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD8_TEXTO" id="DBVAR_STR_MOD8_TEXTO"></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD8_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame mod8 //-->
                            <div class="frame" id="MOD9">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 9- Título:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                            	<p>
													<input type="text" name="DBVAR_STR_MOD9_TITLE" id="DBVAR_STR_MOD9_TITLE" value=""> 
                                            	</p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 9- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD9_TEXTO" id="DBVAR_STR_MOD9_TEXTO"></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD9_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame mod9 //-->
                            <div class="frame" id="MOD10">
                                <div class="grid" style="border:0px solid #F00">
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 10- Título:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text" data-role="input-control">
                                            	<p>
													<input type="text" name="DBVAR_STR_MOD10_TITLE" id="DBVAR_STR_MOD10_TITLE" value=""> 
                                            	</p>
                                            </div>
                                             <span class="tertiary-text-secondary"></span>   
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2" style=""><p>Mod 10- Texto:</p></div>
                                        <div class="span8"> 
                                            <p class="input-control textarea">
                                                <textarea name="DBVAR_STR_MOD10_TEXTO" id="DBVAR_STR_MOD10_TEXTO"></textarea>
                                            </p>
                                        <span class="tertiary-text-secondary"><a href="javascript:viewdoc('MOD10_TEXTO');" class=""><i class="icon-search"></i>visualizar</a></span>   
                                        </div>
                                    </div>
                                </div> <!--FIM GRID//-->
                            </div><!--fim do frame mod10 //-->
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid //-->
            </div><!--fim frame correspondencia//-->
            
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
        
    <div style="padding-top:16px; padding-bottom: 50px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
            <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e (*)</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>
