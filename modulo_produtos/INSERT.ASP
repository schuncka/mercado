<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CLIENTES",Session("ID_USER")), true %>
<%
 Const LTB = "tbl_clientes"	        ' - Nome da Tabela...
 Const DKN = "cod_tbl_clientes"     ' - Campo chave...
 Const TIT = "CLIENTES"             ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
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
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../modulo_clientes/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      { 
  document.forminsert.DEFAULT_LOCATION.value="../modulo_clientes/insert.asp"; 
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

       
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
            <li class=""><a href="#FONE">TELEFONES</a></li>
            <li class=""><a href="#END_ADICIONAL">END. ADICIONAL</a></li>
             <li class=""><a href="#INFO_ADICIONAL">INFO. ADICIONAL</a></li>
             <li class=""><a href="#PLANTIO">INFO. PLANTIO</a></li //-->
            <!--li class=""><a href="#EXTRA"></a></li>
            <li class=""><a href="#PLANTIO">Info.Plantio</a></li //-->
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">

				<div class="row">
                    <div class="span2"><p>Tipo Pessoa:</p></div>
                        <div class="span8">
                                <div class="input-control select info-state" data-role="input-control">
                                    <select id="dbvar_str_tipoô" name="dbvar_str_tipo">
                                        <option value="">Selecione...</option>
                                        <%=montaComboReturn("SELECT IDTIPO, TIPO FROM TBL_TIPO ORDER BY IDTIPO", "idtipo", "tipo","") %>
                                    </select>                                        
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>  
                </div>  
                <div class="row">
                    <div class="span2"><p>Razao Social:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_NomeDoClienteô" name="DBVAR_STR_NomeDoCliente" type="text" placeholder="Corretora Mercado" value="" maxlength="250"></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div>  
                <div class="row">
                    <div class="span2" style=""><p>Cep:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_str_CodigoPostalô" name="DBVAR_str_CodigoPostal" type="text" placeholder="" value="" onKeyPress="return validateNumKey(event);" onblur="buscaCep(this.value,'DBVAR_STR_Enderecoô','DBVAR_STR_BAIRRO','DBVAR_STR_cidadeô','dbvar_str_estadoô','DBVAR_STR_paisô')" ></p>
                                </div>  
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div>                     
                <div class="row">
                    <div class="span2" style=""><p>Endereço:</p></div>
                        <div class="span8"> 
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_Enderecoô" name="DBVAR_STR_Endereco" type="text" placeholder="" value="" maxlength="250"></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 
                <div class="row">
                    <div class="span2" style=""><p>Bairro:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_BAIRRO" name="DBVAR_STR_BAIRRO" type="text" placeholder="" value="" ></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 
                <div class="row">
                    <div class="span2" style=""><p>Cidade:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_cidadeô" name="DBVAR_STR_cidade" type="text" placeholder="" value="" ></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>
                <div class="row">
                    <div class="span2" style=""><p>Estado:</p></div>
                        <div class="span8">
                                <div class="input-control select info-state" data-role="input-control">
                                <select  id="dbvar_str_estadoô" name="dbvar_str_estado>
                                        <option value="">Selecione...</option>

                                        <%=montaComboReturn("select sigla_uf, nome_uf from tbl_estados order by 1", "sigla_uf", "nome_uf","") %>
                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div> 
                <div class="row">
                    <div class="span2" style=""><p>País:</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_paisô" name="DBVAR_STR_pais" type="text" placeholder="" value="Brasil" ></p>
                            </div>
                            <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>
                <div class="row">
                    <div class="span2" style=""><p>CNPJ:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_cgccpfô" name="DBVAR_STR_cgccpf" type="text" placeholder="00.000.000/0000-00" value="" ></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>   
                <div class="row">
                    <div class="span2" style=""><p>Inscrição Estadual:</p></div>
                    <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_iergô" name="DBVAR_STR_ierg" type="text" placeholder="" value="" ></p>
                            </div>
                            <span class="tertiary-text-secondary"></span>  
                    </div> 
                </div>                      
                <div class="row">
                    <div class="span2" style=""><p>Inscrição Municipal:</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_inscr_munipalô" name="DBVAR_STR_inscr_munipal" type="text" placeholder="" value="" ></p>
                            </div>
                            <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>   
                <div class="row">
                        <div class="span2" style=""><p>RG:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_rg" name="DBVAR_STR_rg" type="text" placeholder="" value="" ></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>   
                <div class="row">
                        <div class="span2" style=""><p>Data/Emissor:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p class="span3"><input id="DBVAR_STR_DataRG" name="DBVAR_STR_DataRG" type="text" placeholder="2018-10-10" value="" ></p>
                                
                                    <p class="span2"><input id="DBVAR_STR_OrgaoRg" name="DBVAR_STR_OrgaoRg" type="text" placeholder="SSP-RS" value="" ></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>                                           
                    
                                                             
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->

            <div class="frame" id="FONE" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="row">
                                <div class="span2"><p>Telefone 1:</p></div>                                
                                <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_NumeroDeTelefoneô" name="DBVAR_STR_NumeroDeTelefone" type="text" placeholder="" value="" maxlength="15"></p> 
                                    </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Telefone 2:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_NumeroDeTelefone1" name="DBVAR_STR_NumeroDeTelefone1" type="text" placeholder="" value="" maxlength="15"></p> 
                                     </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Telefone 3:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_NumeroDeTelefone2" name="DBVAR_STR_NumeroDeTelefone2" type="text" placeholder="" value="" maxlength="15"></p> 
                                     </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Telefone 4:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_NumeroDeTelefone3" name="DBVAR_STR_NumeroDeTelefone3" type="text" placeholder="" value="" maxlength="15"></p> 
                                    </div>
                                </div>
                     </div>
                  

              </div> <!--FIM GRID//-->
            </div><!--fim do frame extra//-->

             <div class="frame" id="END_ADICIONAL" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
					
                    <div class="row">
                                <div class="span2"><p>CEP</p></div>
                                <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_CEPCob" name="DBVAR_STR_CEPCob" type="text" placeholder="" value="" maxlength="15" onblur="buscaCep(this.value,'DBVAR_STR_EndCob','DBVAR_STR_BairCob','DBVAR_STR_CidCob','DBVAR_STR_EstCob','')"></p> 
                                    </div>
                                </div>
                     </div>
                    
                    <div class="row">
                                <div class="span2"><p>Endereço:</p></div>                                
                                <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_EndCob" name="DBVAR_STR_EndCobô" type="text" placeholder="" value="" maxlength="15"></p> 
                                    </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Bairro/Distrito:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_BairCob" name="DBVAR_STR_BairCob" type="text" placeholder="" value="" maxlength="15"></p> 
                                     </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Cidade/Município:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_CidCob" name="DBVAR_STR_CidCob" type="text" placeholder="" value="" maxlength="15"></p> 
                                     </div>
                                </div>
                     </div>
                      <div class="row">
                                <div class="span2" style=""><p>Estado:</p></div>
                                <div class="span8">
                                       <div class="input-control select info-state" data-role="input-control">
                                        <select  id="DBVAR_STR_EstCob" name="DBVAR_STR_EstCob">
                                                <option value="">Selecione...</option>
                                                <%=montaComboReturn("select sigla_uf, nome_uf from tbl_estados order by 1", "sigla_uf", "nome_uf","RS") %>
                                            </select>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>  
                                </div> 
                    </div>
                       <div class="row">
                                <div class="span2"><p>Internet E-mail</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_EmailCliCob" name="DBVAR_STR_EmailCliCob" type="text" placeholder="" value="" maxlength="15"></p> 
                                    </div>
                                </div>
                    </div>
                    <div class="row">
                                <div class="span2"><p>Website:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_WebSiteCob" name="DBVAR_STR_WebSiteCob" type="text" placeholder="" value="" maxlength="15"></p> 
                                    </div>
                                </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Observações End Adicional:</p></div>
                            <div class="span8">
                                    <div class="input-control textarea info-state" data-role="input-control">
                                    <p><textarea id="DBVAR_STR_Observacoes2" name="DBVAR_STR_Observacoes2" class="" onKeyPress=""></textarea><p>
                                    

                            </div>
                        </div>
                    </div>
   
   

              </div> <!--FIM GRID//-->
            </div><!--fim do frame ENDERECO ADD//-->

              <div class="frame" id="INFO_ADICIONAL" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
					
                    <div class="row">
                        <div class="span2"><p>Banco</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_BCO" name="DBVAR_STR_BCO" type="text" placeholder="" value="" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Número Banco:</p></div>                                
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_NROBANCO" name="DBVAR_STR_NROBANCO" type="text" placeholder="" value="" maxlength="15"></p> 
                                </div>
                            </div>
                     </div>
                     <div class="row">
                        <div class="span2"><p>Agência:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_AG" name="DBVAR_STR_AG" type="text" placeholder="" value="" maxlength="15"></p> 
                                    </div>
                            </div>
                     </div>
                     <div class="row">
                        <div class="span2"><p>Conta Corrente:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CTA" name="DBVAR_STR_CTA" type="text" placeholder="" value="" maxlength="15"></p> 
                                    </div>
                            </div>
                     </div>
                      <div class="row">
                        <div class="span2" style=""><p>E-mail NFE:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_email_nfe" name="DBVAR_DBVAR_STR_email_nfe" type="text" placeholder="" value="" maxlength="15"></p> 

                                    </div>
                                <span class="tertiary-text-secondary"></span>  
                            </div> 
                    </div>
                    <div class="row">
                        <div class="span2"><p>Código BBM-RS</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_BMRS" name="DBVAR_STR_BMRS" type="text" placeholder="" value="" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Código CNAE</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CNAE" name="DBVAR_STR_CNAE" type="text" placeholder="" value="" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Inscrição INSS</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_INSS" name="DBVAR_STR_INSS" type="text" placeholder="" value="" maxlength="15"></p> 
                                </div>
                            </div>
                     </div>
                    <div class="row">
                        <div class="span2"><p>Internet E-mail</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_EMailCli" name="DBVAR_STR_EMailCli" type="text" placeholder="" value="" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Website</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_WebSite" name="DBVAR_STR_WebSite" type="text" placeholder="" value="" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Nome Fantasia</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_FANTASIA" name="DBVAR_STR_FANTASIA" type="text" placeholder="" value="" maxlength="15"></p> 
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Data Fundação</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_DataFund" name="DBVAR_STR_DataFund" type="text" placeholder="" value="" maxlength="15"></p> 
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Validade Auto Corretagem</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_DT_AUT_CORR" name="DBVAR_STR_DT_AUT_CORR" type="text" placeholder="" value="" maxlength="15"></p> 
                            </div>
                        </div>
                    </div>
                   <!-- <div class="row">
                        <div class="span2"><p>Representante</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_idrepre" name="DBVAR_STR_TBL_idrepre" type="text" placeholder="" value="" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>-->
                    <div class="row">
                        <div class="span2"><p>Data Cadastro</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_DataCad" name="DBVAR_STR_DataCad" type="text" placeholder="" value="" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Observações:</p></div>
                            <div class="span8">
                                    <div class="input-control textarea info-state" data-role="input-control">
                                    <p><textarea id="DBVAR_STR_Observacoes" name="DBVAR_STR_Observacoes" class="" onKeyPress=""></textarea><p>

                            </div>
                        </div>
                    </div>
              </div> <!--FIM GRID//-->
            </div><!--fim do frame INFO_ADICIONALtra//-->


             <div class="frame" id="PLANTIO" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
					
                    <div class="row">
                                <div class="span2"><p>Área Plantada:</p></div>
                                <div class="span8"><p>
                                    <div class="input-control text info-state" data-role="input-control">

                                    <p><input id="DBVAR_STR_area_plantada"name="DBVAR_STR_area_plantada" type="text" placeholder="" value="" maxlength="250"></p>
                                    </div>
                                 <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Área Total:</p></div>
                                <div class="span8"><p>
                                    <div class="input-control text info-state"data-role="input-control">

                                        <p><input id="DBVAR_STR_area_total"name="DBVAR_STR_area_total" type="text" placeholder="" value="" maxlength="250"></p>
                                    </div>
                                 <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Plantel:</p></div>
                                <div class="span8"><p>
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_plantel"name="DBVAR_STR_plantel" type="text" placeholder="" value="" maxlength="250"></p>
                                    </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2" style=""><p>Consumo Mensal (kg):</p></div>
                                <div class="span8"> 
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_consumo_mensal" name="DBVAR_STR_consumo_mensal" type="text" placeholder="" value="" maxlength="250"></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row">
                                <div class="span2" style=""><p>Latitude</p></div>
                                <div class="span8">
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_latitude" name="DBVAR_STR_latitude" type="text" placeholder="" value="" ></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2" style=""><p>Longitude:</p></div>
                                <div class="span8">
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_longitude" name="DBVAR_STR_longitude" type="text" placeholder="" value="" ></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                    </div> 
                 
                     <div class="row">
                            <div class="span2" style=""><p>Ponto de Referência:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_ponto_referencia" name="DBVAR_STR_ponto_referencia" type="text" placeholder="" value="" ></p>
                                    </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                    </div> 
                     <div class="row">
                            <div class="span2" style=""><p>Nirf:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_nirf" name="DBVAR_STR_nirf" type="text" placeholder="" value="" ></p>
                                    </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                    </div> 
                     
              </div> <!--FIM GRID//-->
            </div><!--fim do frame PLANTIO//-->
    
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
</html>
