<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CLIENTES",Session("ID_USER")), true %>
<%

 Const MDL = "DEFAULT"                          ' - Default do Modulo...
 Const LTB = "TBL_CONTRATO"	                ' - Nome da Tabela...
 Const DKN = "COD_TBL_CONTRATO"                         ' - Campo chave...
 Const DLD = "../modulo_contratos/default.asp" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Contratos"                       ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_contratos/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_contratos/insert.asp"; 
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

function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}

function SetFormField(strFORMNAME,strFIELDNAME,FileName){
	document.getElementById('DBVAR_STR_IMG').value = FileName;	
}

//função para ativar o date picker dos campos data
$("#datepicker").datepicker( {
	date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer já  ele modifica automaticamente para data setada dentro da função//-->
	format: "dd/mm/yyyy <%=Time%>", // set output format
	effect: "none", // none, slide, fade
	position: "bottom", // top or bottom,
	//locale: ''en, // 'ru' or 'en', default is $.Metro.currentLocale
	
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
	<form name="forminsert" id="forminsert" action="../_database/athinserttodb.asp" method="post">
		<input type="hidden" name="DEFAULT_TABLE"	 value="<%=LTB%>">
		<input type="hidden" name="DEFAULT_DB"		 value="<%=CFG_DB%>">
		<input type="hidden" name="FIELD_PREFIX" 	 value="DBVAR_">
		<input type="hidden" name="RECORD_KEY_NAME"	 value="<%=DKN%>">
		<input type="hidden" name="DEFAULT_LOCATION" value="">
        <input type="hidden" name="DBVAR_STR_NOMEC" id="DBVAR_STR_NOMEC"  value="">
        <input type="hidden" name="DBVAR_STR_NOMEV" id="DBVAR_STR_NOMEV"  value="">

       
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#COMPRADOR">COMPRADOR</a></li>
            <li class=""><a href="#VENDEDOR">VENDEDOR</a></li>
            <li class=""><a href="#PRODUTOS">PRODUTOS</a></li>
            <li class=""><a href="#COMISSAO">COMISSÃO</a></li>
            <li class=""><a href="#PAGAMENTO_ENTREGA">PAGAMENTO/ENTREGA</a></li>
            <li class=""><a href="#INFORMACOES_BOLSA">INFO. BOLSA</a></li //-->
            <!--li class=""><a href="#EXTRA"></a></li>
            <li class=""><a href="#PLANTIO">Info.Plantio</a></li //-->
        </ul>
		<div class="frames">
            <div class="frame" id="COMPRADOR" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">

				<div class="row">
                    <div class="span2"><p>Data:</p></div>
                       <div class="span8">
                           <div class="input-control text info-state" data-role="input-control">
                                <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                    <input id="DBVAR_date_DATA_ô" name="DBVAR_date_DATA" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                    <span class="btn-date"></span>
                                </p>
                            </div>
                        </div>
                </div> 


                <div class="row">
                    <div class="span2"><p>Comprador:</p></div>
                       <div class="span8">
                            <div class="input-control select info-state" data-role="input-control">
                                   <select id="DBVAR_STR_COMPRADOR_ô" name="DBVAR_STR_COMPRADOR" onchange="buscaComprador(this.value)">
                                        <option value="">Selecione...</option>
                                            <% montaComboReturnPrint "select CODIGODOCLIENTE, if(cgccpf is null,concat(NOMEDOCLIENTE,' [---]'),concat(NOMEDOCLIENTE,' [',CGCCPF,']')) as NOME from TBL_CLIENTES where tipo in(1,2) order by 2", "CODIGODOCLIENTE", "NOME","" %>
                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 

                <div class="row">
                    <div class="span2" style=""><p>Endereço:</p></div>
                        <div class="span8"> 
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_ENDERECOC" name="DBVAR_STR_ENDERECOC" type="text" placeholder="" value="" maxlength="250"></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 

                 <div class="row">
                    <div class="span2" style=""><p>Bairro:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_BAIRROC" name="DBVAR_STR_BAIRROC" type="text" placeholder="" value="" ></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 

                <div class="row">
                    <div class="span2" style=""><p>Cidade:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CIDADEC" name="DBVAR_STR_CIDADEC" type="text" placeholder="" value="" ></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>

                 <div class="row">
                    <div class="span2" style=""><p>Estado:</p></div>
                        <div class="span8">
                                <div class="input-control select info-state" data-role="input-control">
                                <select  id="DBVAR_STR_ESTADOC" name="DBVAR_STR_ESTADOC">
                                    <option value="">Selecione...</option>

                                        <% montaComboReturnPrint "select sigla_uf, nome_uf from tbl_estados order by 1", "sigla_uf", "nome_uf","" %>
                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div> 

                <div class="row">
                    <div class="span2" style=""><p>Código Postal:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CEPC" name="DBVAR_STR_CEPC" type="text" placeholder="" value="" onblur="buscaCep(this.value,'DBVAR_STR_Enderecoô','DBVAR_STR_BAIRRO','DBVAR_STR_cidadeô','dbvar_str_estadoô','DBVAR_STR_paisô')" ></p>
                                </div>  
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div>    

                 <div class="row">
                    <div class="span2" style=""><p>CNPJ/CPF</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CGCCPFC" name="DBVAR_STR_CGCCPFC" type="text" placeholder="" value=""  onblur=""></p>
                                </div>  
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div>    

                <div class="row">
                    <div class="span2" style=""><p>N Inscri.Estadual</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_IERGC" name="DBVAR_STR_IERGC" type="text" placeholder="" value=""  onblur="b"></p>
                                </div>  
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 
                                 
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->

            <div class="frame" id="VENDEDOR" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                 
                <div class="row">
                    <div class="span2" style=""><p>Vendedor</p></div>
                        <div class="span8">
                         <div class="input-control select info-state" data-role="input-control">
                                <select  id="DBVAR_STR_VENDEDOR_ô" name="DBVAR_STR_VENDEDOR" onchange="buscaVendedor(this.value);">
                                    <option value="">Selecione...</option>

                                            <% montaComboReturnPrint "select CODIGODOCLIENTE, if(cgccpf is null,concat(NOMEDOCLIENTE,' [---]'),concat(NOMEDOCLIENTE,' [',CGCCPF,']')) as NOME from TBL_CLIENTES where tipo in(1,2) order by 2", "CODIGODOCLIENTE", "NOME","" %>
                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 

                <div class="row">
                    <div class="span2" style=""><p>Endereço Vendedor:</p></div>
                        <div class="span8"> 
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_ENDERECOV" name="DBVAR_STR_ENDERECOV" type="text" placeholder="" value="" maxlength="250"></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div>  

                <div class="row">
                    <div class="span2" style=""><p>Bairro:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_BAIRROV" name="DBVAR_STR_BAIRROV" type="text" placeholder="" value="" ></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 

                <div class="row">
                    <div class="span2" style=""><p>Cidade:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CIDADEV" name="DBVAR_STR_CIDADEV" type="text" placeholder="" value="" ></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>

                 <div class="row">
                    <div class="span2" style=""><p>Estado:</p></div>
                        <div class="span8">
                                <div class="input-control select info-state" data-role="input-control">
                                <select  id="DBVAR_STR_ESTADOV" name="DBVAR_STR_ESTADOV">
                                    <option value="">Selecione...</option>

                                        <% montaComboReturnPrint "select sigla_uf, nome_uf from tbl_estados order by 1", "sigla_uf", "nome_uf","" %>
                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div> 

                <div class="row">
                    <div class="span2" style=""><p>Código Postal:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CEPV" name="DBVAR_STR_CEPV" type="text" placeholder="" value="" onblur="buscaCep(this.value,'DBVAR_STR_Enderecoô','DBVAR_STR_BAIRRO','DBVAR_STR_cidadeô','dbvar_str_estadoô','DBVAR_STR_paisô')" ></p>
                                </div>  
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 

                  <div class="row">
                    <div class="span2" style=""><p>CNPJ/CPF</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CGCCPFV" name="DBVAR_STR_CGCCPFV" type="text" placeholder="" value=""  onblur=""></p>
                                </div>  
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div>    

                <div class="row">
                    <div class="span2" style=""><p>N Inscri.Estadual</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_IERGV" name="DBVAR_STR_IERGV" type="text" placeholder="" value="" ></p>
                                </div>  
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div>  
                
              </div> <!--FIM GRID//-->
            </div><!--fim do frame extra//-->

             <div class="frame" id="PRODUTOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
					  
                    <div class="row">
                        <div class="span2"><p>Produto/Sub-Produtio:</p></div>                                
                            <div class="span4">
                            <div class="input-control select info-state" data-role="input-control">
                                    <select  id="DBVAR_STR_PRODUTO" name="DBVAR_STR_PRODUTO" onchange="buscaSubProd(this.value,'DBVAR_STR_PRODUTOSUB');">
                                    <option value="">Selecione...</option>
                                           <% montaComboReturnPrint "select idprod, Produto from tbl_produtos where idempresa = 'MM' order by 2", "idprod", "Produto","" %>
                                     </select>
                                </div>
                            </div>

                            <div class="span4">
                                    <div class="input-control select info-state" data-role="input-control">
                                        <select  id="DBVAR_STR_PRODUTOSUB" name="DBVAR_STR_PRODUTOSUB">
                                            <option value="">Selecione...</option>
                                                
                                        </select>
                                    </div>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Variedades:</p></div>
                            <div class="span8">
                                <div class="input-control select info-state" data-role="input-control">
                                    <select  id="DBVAR_STR_VARIEDADE" name="DBVAR_STR_VARIEDADE">
                                        <option value="">Selecione...</option>
                                           <% montaComboReturnPrint "select idvar, descrvar from tbl_variedades order by 2", "idvar", "descrvar","" %>
                                    </select>
                                </div>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Safra:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_SAFRA" name="DBVAR_STR_SAFRA" type="text" placeholder="" value="" maxlength="250"></p> 
                                </div>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Embalagem:</p></div>
                            <div class="span8">
                            <div class="input-control select info-state" data-role="input-control">
                                    <select  id="DBVAR_STR_EMB" name="DBVAR_STR_EMB">
                                        <option value="">Selecione...</option>
                                           <% montaComboReturnPrint "select idemb, descremb from tbl_embalagem order by 2", "idemb", "descremb","" %>
                                    </select>
                                </div>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Quantidade:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_FLOAT_QUANTIDADE" name="DBVAR_STR_QUANTIDADE" type="text" placeholder="" value="" maxlength="250" onKeyPress="Javascript:return validateFloatKeyNew(this,event);return false;"></p> 
                                </div>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Unidade:</p></div>
                            <div class="span8">
                            <div class="input-control select info-state" data-role="input-control">
                                    <select  id="DBVAR_STR_UNIDADE" name="DBVAR_STR_UNIDADE">
                                        <option value="">Selecione...</option>
                                          <% montaComboReturnPrint "select idunid, descrunid from tbl_unidade order by 2", "idunid", "descrunid","" %>
                                    </select>
                                </div>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Defeito:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_DEFEITO" name="DBVAR_STR_DEFEITO" type="text" placeholder="" value="" maxlength="255"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Umidade Máxima:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_UmidMax" name="DBVAR_STR_UmidMax" type="text" placeholder="" value="" maxlength="250"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Impureza Máxima:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_ImpMax" name="DBVAR_STR_ImpMax" type="text" placeholder="" value="" maxlength="250"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Rendimento Mínimo:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_Rend_min" name="DBVAR_STR_Rend_min" type="text" placeholder="" value="" maxlength="250"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>PH:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_ph" name="DBVAR_STR_ph" type="text" placeholder="" value="" maxlength="250"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Classe:</p></div>
                            <div class="span8">
                            <div class="input-control select info-state" data-role="input-control">
                                    <select  id="DBVAR_STR_Classe" name="DBVAR_STR_Classe">
                                        <option value="">Selecione...</option>
                                          <% montaComboReturnPrint "SELECT idclas, descrclas FROM tbl_classe t where idempresa = 'MM' order by 2", "idclas", "descrclas","" %>
                                    </select>
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Tipo:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_tipo" name="DBVAR_STR_tipo" type="text" placeholder="" value="" maxlength="250"></p> 
                                </div>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Detalhamento:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_PROD_DETALHE" name="DBVAR_STR_PROD_DETALHE" type="text" placeholder="" value="" maxlength="250"></p> 
                                </div>
                            </div>
                    </div>

              </div> <!--FIM GRID//-->
            </div><!--fim do frame ENDERECO ADD//-->

              <div class="frame" id="COMISSAO" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">

                    <div class="row">
                        <div style="border: 1px #eeeeee solid; padding: 35px;">

                                <div class="row">
                                    <div class="span2"><p>Comissão Comprador</p></div>
                                        <div class="span8">
                                            <div class="input-control text info-state" data-role="input-control">
                                                <p><input id="DBVAR_FLOAT_COMISSAOC" name="DBVAR_STR_COMISSAOC" type="text" placeholder="" value="" maxlength="250" onKeyPress="Javascript:return validateFloatKeyNew(this,event);return false;"></p> 
                                            </div>
                                        </div>
                                </div>

                                <div class="row">
                                    <div class="span2"></p></div>
                                        <div class="span4">
                                            <span>Nota Fiscal relatório</span>
                                        </div>
                                        <div class="span4">
                                            <span>Nota Fiscal 2</span>  
                                        </div>
                                </div>


                                <div class="row">
                                    <div class="span2"><p>Data NF:</p></div>
                                        <div class="span4">
                                        <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_date_NFC_DATA" name="DBVAR_date_NFC_DATA" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                                <span class="btn-date"></span>
                                            </p>
                                        
                                        </div>
                                        <div class="span4">
                                            <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_date_NFC_DATA2" name="DBVAR_date_NFC_DATA2" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                                <span class="btn-date"></span>
                                            </p>
                                        </div>
                                </div>

                                <div class="row">
                                    <div class="span2"><p>Nro. NF:</p></div>
                                        <div class="span4">
                                            <div class="input-control text info-state" data-role="input-control">
                                                <input id="DBVAR_STR_NFC_NRO" name="DBVAR_STR_NFC_NRO" type="text" placeholder="" value="" maxlength="250"> 
                                            </div>
                                        </div>
                                        <div class="span4">
                                            <div class="input-control text info-state" data-role="input-control">
                                                <input id="DBVAR_STR_NFC_NRO2" name="DBVAR_STR_NFC_NRO2" type="text" placeholder="" value="" maxlength="250"> 
                                            </div>
                                        </div>
                                </div>

                                <div class="row">
                                    <div class="span2"><p>Valor NF:</p></div>
                                        <div class="span4">
                                            <div class="input-control text info-state" data-role="input-control">
                                                <input id="DBVAR_FLOAT_NFC_VALOR" name="DBVAR_STR_NFC_VALOR" type="text" placeholder="" value="" maxlength="250" onKeyPress="Javascript:return validateFloatKeyNew(this,event);return false;"> 
                                            </div>
                                        </div>
                                        <div class="span4">
                                            <div class="input-control text info-state" data-role="input-control">
                                                <input id="DBVAR_FLOAT_NFC_VALOR2" name="DBVAR_STR_NFC_VALOR2" type="text" placeholder="" value="" maxlength="250" onKeyPress="Javascript:return validateFloatKeyNew(this,event);return false;"> 
                                            </div>
                                        </div>
                                </div>

                                <div class="row">
                                    <div class="span2"><p>Data Pagto:</p></div>
                                    <div class="span4">
                                            <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_date_NFC_PAGTO" name="DBVAR_date_NFC_PAGTO" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                                <span class="btn-date"></span>
                                            </p>
                                            
                                        </div>
                                        <div class="span4">
                                            <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                <input id="DBVAR_date_NFC_PAGTO2" name="DBVAR_date_NFC_PAGTO2" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                                <span class="btn-date"></span>
                                            </p>
                                        </div>

                                </div>

                        </div>
                    </div><br/><br/>

                    <div class="row">
                        <div style="border: 1px #eeeeee solid; padding: 35px;">

                            <div class="row">
                                <div class="span2"><p>Comissão Vendedor</p></div>
                                    <div class="span8">
                                            <div class="input-control text info-state" data-role="input-control">
                                                <p><input id="DBVAR_FLOAT_COMISSAOV" name="DBVAR_STR_COMISSAOV" type="text" placeholder="" value="" maxlength="250" onKeyPress="Javascript:return validateFloatKeyNew(this,event);return false;"></p> 
                                            </div>
                                        </div>
                            </div>

                            <div class="row">
                                <div class="span2"></p></div>
                                    <div class="span4">
                                         <span>Nota Fiscal relatório</span>
                                    </div>
                                    <div class="span4">
                                         <span>Nota Fiscal 2</span>  
                                    </div>
                            </div>

                     
                            <div class="row">
                                <div class="span2"><p>Data NF:</p></div>
                                    <div class="span4">
                                        <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                            <input id="DBVAR_date_NFV_DATA" name="DBVAR_date_NFV_DATA" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                            <span class="btn-date"></span>
                                        </p>
                                        
                                    </div>
                                    <div class="span4">
                                        <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                            <input id="DBVAR_date_NFV_DATA2" name="DBVAR_date_NFV_DATA2" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                            <span class="btn-date"></span>
                                        </p>
                                    </div>
                            </div>
                    

                        <div class="row">
                            <div class="span2"><p>Nro. NF:</p></div>
                                <div class="span4">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <input id="DBVAR_STR_NFV_NRO" name="DBVAR_STR_NFV_NRO" type="text" placeholder="" value="" maxlength="250">
                                    </div>
                                </div>

                                <div class="span4">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <input id="DBVAR_STR_NFV_NRO2" name="DBVAR_STR_NFV_NRO2" type="text" placeholder="" value="" maxlength="250">
                                    </div>
                                </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>Valor NF:</p></div>
                                   <div class="span4">
                                        <div class="input-control text info-state" data-role="input-control">
                                            <input id="DBVAR_FLOAT_NFV_VALOR" name="DBVAR_STR_NFV_VALOR" type="text" placeholder="" value="" maxlength="250" onKeyPress="Javascript:return validateFloatKeyNew(this,event);return false;"> 
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="input-control text info-state" data-role="input-control">
                                            <input id="DBVAR_STR_FLOAT_VALOR2" name="DBVAR_STR_NFV_VALOR2" type="text" placeholder="" value="" maxlength="250" onKeyPress="Javascript:return validateFloatKeyNew(this,event);return false;">
                                        </div>
                                    </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>Data Pagto:</p></div>
                                <div class="span4">
                                    <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                        <input id="DBVAR_date_NFV_PAGTO" name="DBVAR_date_NFV_PAGTO" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                        <span class="btn-date"></span>
                                    </p>
                                            
                                </div>
                                <div class="span4">
                                    <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                        <input id="DBVAR_date_NFV_PAGTO2" name="DBVAR_date_NFV_PAGTO2" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                        <span class="btn-date"></span>
                                    </p>
                                </div>
                        </div>
                        
                        
                        </div>
                    </div>

                </div> <!--FIM GRID//-->
            </div><!--fim do frame INFO_ADICIONALtra//-->


             <div class="frame" id="PAGAMENTO_ENTREGA" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
					
                    <div class="row">
                        <div class="span2"><p>Representante:</p></div>
                            <div class="span8"><p>
                               <div class="input-control select info-state" data-role="input-control">
                                    <select id="DBVAR_STR_IDREPRE"name="DBVAR_STR_IDREPRE" >
                                     <option value="">Selecione...</option>
                                        <% montaComboReturnPrint "select CODIGODOCLIENTE, NOMEDOCLIENTE from TBL_CLIENTES where tipo in(5)  order by 2", "CODIGODOCLIENTE", "NOMEDOCLIENTE","" %>
                                    </select>
                                </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2" style="padding-top: 10px;"><p>Comissão:</p></div>
                            <div class="span4"><p>
                                <div class="input-control text info-state"data-role="input-control">

                                    <p><input id="DBVAR_FLOAT_COMISSAO"name="DBVAR_STR_COMISSAO" type="text" placeholder="" value="" maxlength="250" onKeyPress="Javascript:return validateFloatKeyNew(this,event);return false;"></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2" style="padding-top: 10px;"><p>Moeda:</p></div>
                            <div class="span4"><p>
                                <div class="input-control select info-state" data-role="input-control">
                                    <select id="DBVAR_STR_MOEDA"name="DBVAR_STR_MOEDA" >                                        
                                        <option value="R$">R$</option>
                                        <option value="US$">US$</option>
                                    </select>
                                    
                                </div>
                              <span class="tertiary-text-secondary"></span>
                            </div>

                     </div>

                     <div class="row">

                        <div class="span2" style="padding-top: 10px;"><p>Preço 1:</p></div>
                            <div class="span3"><p>
                                <div class="input-control text info-state"data-role="input-control">

                                    <p><input id="DBVAR_FLOAT_PRECO"name="DBVAR_STR_PRECO" type="text" placeholder="" value="" maxlength="250" onKeyPress="Javascript:return validateFloatKeyNew(this,event);return false;"></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>

                         <div class="span2"style="padding-top: 10px;"><p>Preço 2:</p></div>
                            <div class="span3"><p>
                                <div class="input-control text info-state"data-role="input-control">

                                    <p><input id="DBVAR_STR_PRECO2"name="DBVAR_STR_PRECO2" type="text" placeholder="" value="" maxlength="250"></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>

                     </div>

                     <div class="row">
                        <div class="span2"><p>Condições:</p></div>
                            <div class="span8"><p>
                            <div class="input-control select info-state" data-role="input-control">
                                    <select id="DBVAR_STR_CONDICOES"name="DBVAR_STR_CONDICOES" >
                                        <option value="">Selecione...</option>                                        
                                         <% montaComboReturnPrint "SELECT TBL_CONDPGTO.Condicoes FROM TBL_CONDPGTO ORDER BY TBL_CONDPGTO.Condicoes", "Condicoes", "Condicoes","" %>

                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                     </div>

                     <div class="row">
                         <div class="span2"style="padding-top: 10px;"><p>Tributo 1:</p></div>
                            <div class="span3"><p>
                            <div class="input-control select info-state" data-role="input-control">
                                    <select id="DBVAR_STR_TRIBUTO1"name="DBVAR_STR_TRIBUTO1" >
                                        <option value="">Selecione...</option>
                                        <% montaComboReturnPrint "SELECT TBL_TRIBUTOS.Tributos FROM TBL_TRIBUTOS ORDER BY TBL_TRIBUTOS.Tributos", "Tributos", "Tributos","" %>
                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                         <div class="span2"style="padding-top: 10px;"><p>Tributo 2:</p></div>
                            <div class="span3"><p>
                            <div class="input-control select info-state" data-role="input-control">
                                    <select id="DBVAR_STR_TRIBUTO2"name="DBVAR_STR_TRIBUTO2" >
                                        <option value="">Selecione...</option>
                                        <% montaComboReturnPrint "SELECT TBL_TRIBUTOS.Tributos FROM TBL_TRIBUTOS ORDER BY TBL_TRIBUTOS.Tributos", "Tributos", "Tributos","" %>
                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>

                     </div>


                    <div class="row">
                        <div class="span2"><p>Data Entrega:</p></div>
                            <div class="span8"><p>
                            <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                <input id="DBVAR_date_DATA_ENTREGA" name="DBVAR_date_DATA_ENTREGA" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                <span class="btn-date"></span>
                            </p>
                            
                            <span class="tertiary-text-secondary">Em Branco, vide observação</span>
                        </div>
                     </div>

                     <div class="row">
                        <div class="span2"style="padding-top: 10px;"><p>Origem:</p></div>
                            <div class="span3"><p>
                                <div class="input-control text info-state"data-role="input-control">
                                    <p><input id="DBVAR_STR_ORIGEM"name="DBVAR_STR_ORIGEM" type="text" placeholder="" value="End. do Vendedor" maxlength="250"></p>
                                </div>
                            
                            <span class="tertiary-text-secondary"></span>
                        </div>
                         <div class="span2"style="padding-top: 10px;"><p>Destino:</p></div>
                            <div class="span3"><p>
                                <div class="input-control text info-state"data-role="input-control">
                                    <p><input id="DBVAR_STR_DESTINO"name="DBVAR_STR_DESTINO" type="text" placeholder="" value="End. do Comprador" maxlength="250"></p>
                                </div>
                            </div>
                     </div>


                      <div class="row">
                        <div class="span2"><p>Transportadora:</p></div>
                            <div class="span8"><p>
                                <div class="input-control text info-state"data-role="input-control">
                                    <p><input id="DBVAR_STR_TRANSPORTADORA"name="DBVAR_STR_TRANSPORTADORA" type="text" placeholder="" value="" maxlength="250"></p>
                                </div>
                            
                            <span class="tertiary-text-secondary"></span>
                            </div>
                     </div>

                     <div class="row">
                        <div class="span2"><p>Data Pagamento:</p></div>
                            <div class="span8"><p>
                             <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                <input id="DBVAR_date_PRAZOPAG" name="DBVAR_date_PRAZOPAG" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                <span class="btn-date"></span>
                            </p>
    
                            <span class="tertiary-text-secondary">Em Branco, vide observação</span>
                        </div>
                     </div>

                    <div class="row">
                        <div class="span2"><p>Banco:</p></div>
                            <div class="span8">

                                 <div class="input-control select info-state" data-role="input-control">
                                    <select  id="DBVAR_STR_NROBANCO" name="DBVAR_STR_NROBANCO" onChange='setTextBanco(this, this.value)'>
                                        <option value="">Selecione...</option>
                                        <%=montaComboReturn("select cod_banco, concat( cod_banco,' - ' ,nome_banco) as nome from tbl_bancos order by 2", "cod_banco", "nome","") %>
                                    </select>
                                </div>
                                
                                    <input id="DBVAR_STR_BCO" name="DBVAR_STR_BCO" type="hidden" placeholder="" value="" maxlength="100">
                                
                            </div>
                          
                          
                            <span class="tertiary-text-secondary"></span>
                    </div>
                     

                        <div class="row">
                            <div class="span2"style="padding-top: 10px;"><p>Agência:</p></div>
                            <div class="span3">
                                <div class="input-control text info-state"data-role="input-control">
                                    <p><input id="DBVAR_STR_AGE"name="DBVAR_STR_AGE" type="text" placeholder="" value="" maxlength="250"></p>
                                </div>
                        
                            <span class="tertiary-text-secondary"></span>
                        </div>
                            <div class="span2"style="padding-top: 10px;"><p>Conta corrente:</p></div>
                            <div class="span3">
                                <div class="input-control text info-state"data-role="input-control">
                                    <p><input id="DBVAR_STR_CTA"name="DBVAR_STR_CTA" type="text" placeholder="" value="" maxlength="250"></p>
                                </div>
                        
                            <span class="tertiary-text-secondary"></span>
                        </div>
                     </div>

                      

                     <div class="row">
                        <div class="span2"><p>Observações comprador</p></div>
                            <div class="span8"><p>
                                <div class="input-control textarea"data-role="input-control">
                                    <p><textarea  id="DBVAR_STR_OBSERVACAOC"name="DBVAR_STR_OBSERVACAOC" type="text"class="" onKeyPress="">
                                        * O fornecedor deverá obedecer aos limites máximos de peso estabelecidos pela legislação de pesos e dimensões do CONTRAN, vigente a partir de 01/07/2007.
                                         <br>* O fornecedor deverá inspecionar o caminhão, e só carregar a mercadoria se o mesmo estiver limpo e higienizado (sem vestígios de carga anterior), sem riscos de contaminante. E a lona deve estar limpa e em adequadas condições (sem avaria)
                                        </textarea>
                                    <p>
                                </div>
                        
                            <span class="tertiary-text-secondary"></span>
                        </div>
                     </div>

                      <div class="row">
                        <div class="span2"><p>Observações vendedor</p></div>
                            <div class="span8"><p>
                                <div class="input-control textarea"data-role="input-control">
                                   <p><textarea  id="DBVAR_STR_OBSERVACAOV"name="DBVAR_STR_OBSERVACAOV" type="text"class="" onKeyPress="">
                                   * O fornecedor deverá obedecer aos limites máximos de peso estabelecidos pela legislação de pesos e dimensões do CONTRAN, vigente a partir de 01/07/2007.
                                   <br>* O fornecedor deverá inspecionar o caminhão, e só carregar a mercadoria se o mesmo estiver limpo e higienizado (sem vestígios de carga anterior), sem riscos de contaminante. E a lona deve estar limpa e em adequadas condições (sem avaria).</textarea><p>
                                </div>
                            
                            <span class="tertiary-text-secondary"></span>
                        </div>
                     </div>
     
              </div> <!--FIM GRID//-->
            </div><!--fim do frame PLANTIO//-->



            <div class="frame" id="INFORMACOES_BOLSA" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">

                 <div class="row">
                        <div class="span2"><p>Aviso</p></div>
                            <div class="span8"><p>
                                <div class="input-control textarea" data-role="input-control">
                                   <p><textarea  id="DBVAR_STR_AVISO"name="DBVAR_STR_AVISO" type="text"class="" onKeyPress=""></textarea><p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                     </div>

                    <div class="row">
                        <div class="span2"><p>Lote</p></div>
                            <div class="span8"><p>
                                <div class="input-control  textarea" data-role="input-control">
                                   <p><textarea  id="DBVAR_STR_LOTE"name="DBVAR_STR_LOTE" type="text"class="" onKeyPress=""></textarea><p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                     </div>

                      <div class="row">
                        <div class="span2"><p>N.Doc</p></div>
                            <div class="span8"><p>
                                <div class="input-control textarea"data-role="input-control">
                                   <p><textarea  id="DBVAR_STR_NRODOCUMENTO"name="DBVAR_STR_NRODOCUMENTO" type="text"class="" onKeyPress=""></textarea><p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                     </div>

                  <!-- <div class="row">
                        <div class="span2"><p>Comprador:</p></div>
                            <div class="span8"><p>
                            <div class="input-control select info-state" data-role="input-control">
                                    <select id="DBVAR_STR_COMPRADOR"name="DBVAR_STR_COMPRADOR" >
                                        <option value="">Selecione...</option>
                                            <%' montaComboReturnPrint "select CODIGODOCLIENTE, NOMEDOCLIENTE from TBL_CLIENTES where tipo in(1,2)  order by 1", "CODIGODOCLIENTE", "NOMEDOCLIENTE","" %>


                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                     </div>

                      <div class="row">
                        <div class="span2"><p>Vendedor:</p></div>
                            <div class="span8"><p>
                            <div class="input-control select info-state" data-role="input-control">
                                    <select id="DBVAR_STR_VENDEDOR"name="DBVAR_STR_VENDEDOR" >
                                        <option value="">Selecione...</option>
                                            <%' montaComboReturnPrint "select CODIGODOCLIENTE, NOMEDOCLIENTE from TBL_CLIENTES order by 1", "CODIGODOCLIENTE", "NOMEDOCLIENTE","" %>
                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                     </div>

                     <div class="row">
                        <div class="span2"><p>Produto/Sub-Produto:</p></div>                                
                            <div class="span4">
                            <div class="input-control select info-state" data-role="input-control">
                                    <select  id="DBVAR_STR_PRODUTO" name="DBVAR_STR_PRODUTO">
                                    <option value="">Selecione...</option>
                                           <%' montaComboReturnPrint "select idprod, Produto from tbl_produtos order by 2", "idprod", "Produto","" %>
                                     </select>
                                </div>
                            </div>

                            <div class="span4">
                                    <div class="input-control select info-state" data-role="input-control">
                                        <select  id="DBVAR_STR_PRODUTOSUB" name="DBVAR_STR_PRODUTOSUB">
                                            <option value="">Selecione...</option>
                                                <%' montaComboReturnPrint "select idsubprod, SubProduto from tbl_produtos_2 order by 2", "idsubprod", "SubProduto","" %>
                                        </select>
                                    </div>
                            </div>
                    </div>

                    <div class="row">
                        <div class="span2"><p>Quantidade:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_QUANTIDADE" name="DBVAR_STR_QUANTIDADE" type="text" placeholder="" value="" maxlength="250"></p> 
                                </div>
                            </div>
                    </div>

                      <div class="row">
                        <div class="span2"><p>Preco:</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_PRECO" name="DBVAR_STR_PRECO" type="text" placeholder="" value="" maxlength="250"></p> 
                                </div>
                            </div>
                    </div>-->
			

              </div> <!--FIM GRID//-->
            </div><!--fim do frame ENDERECO ADD//-->
    
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    
    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
            <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e/ou (*)</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
<script language=javascript>
//DBVAR_STR_ENDERECOC DBVAR_STR_BAIRROC DBVAR_STR_CIDADEC DBVAR_STR_ESTADOC DBVAR_STR_CEPC DBVAR_STR_CGCCPFC DBVAR_STR_IERGC
function buscaComprador(prValue){
        $(document).ready(function(){
                    $.ajax({url: "../ajax/pesquisacnpj.asp?codigo=" + prValue
                    , success: function(data){
                        
                        var arrData = data.split("|");
                        $("#DBVAR_STR_ENDERECOC").val(arrData[0]);
                        $("#DBVAR_STR_BAIRROC").val(arrData[1]);
                        $("#DBVAR_STR_CIDADEC").val(arrData[2]);
                        $("#DBVAR_STR_ESTADOC").val(arrData[3]);
                        $("#DBVAR_STR_CEPC").val(arrData[4]);
                        $("#DBVAR_STR_CGCCPFC").val(arrData[5]);
                        $("#DBVAR_STR_IERGC").val(arrData[6]);
                        $("#DBVAR_STR_NOMEC").val(arrData[7]);



                    }})
            })
}

function buscaVendedor(prValue){
        $(document).ready(function(){
                    $.ajax({url: "../ajax/pesquisacnpj.asp?codigo=" + prValue
                    , success: function(data){ 
                        console.log(data); 
                                            
                        var arrData = data.split("|");
                        console.log(arrData[8]);  
                        $("#DBVAR_STR_ENDERECOV").val(arrData[0]);
                        $("#DBVAR_STR_BAIRROV").val(arrData[1]);
                        $("#DBVAR_STR_CIDADEV").val(arrData[2]);
                        $("#DBVAR_STR_ESTADOV").val(arrData[3]);
                        $("#DBVAR_STR_CEPV").val(arrData[4]);
                        $("#DBVAR_STR_CGCCPFV").val(arrData[5]);
                        $("#DBVAR_STR_IERGV").val(arrData[6]);
                        $("#DBVAR_STR_NOMEV").val(arrData[7]);
                        $("#DBVAR_STR_NROBANCO").val(arrData[11]);                       
                        $("#DBVAR_STR_BCO").val(arrData[8].toUpperCase());
                        $("#DBVAR_STR_AGE").val(arrData[9]);
                        $("#DBVAR_STR_CTA").val(arrData[10]);


                    }})
            })
}

function buscaSubProd(prValue,prCampo){
        $(document).ready(function(){
                    $.ajax({url: "../ajax/pesquisasubprod.asp?codigo=" + prValue
                    , success: function(data){
                        //alert(data);
                        var arrData = data.split("|");
                        var i=0
                        for (var key in arrData) {
                            valores = arrData[i].split(":");                            
                                var newOptionsSelect = newOptionsSelect + '<option value="'+valores[0]+'">'+valores[1]+'</option>';                            
                            i++;
                        }
                        $('#'+prCampo).append( newOptionsSelect );                        
                        
                    }})
            })
}

function setTextBanco(prObj, prValue) {
                        var x = prObj;                        
                        var i;
                        for (i = 0; i < x.length; i++) {
                            if (x.options[i].value == prValue){
                            document.getElementById("DBVAR_STR_BCO").value = x.options[i].text;
                            }
                        }
}
</script>
</html>
