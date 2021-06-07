<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CLIENTES",Session("ID_USER")), true %>
<%

 Const MDL = "DEFAULT"                          ' - Default do Modulo...
 Const LTB = "TBL_CLIENTES"	                ' - Nome da Tabela...
 Const DKN = "COD_TBL_CLIENTES"                         ' - Campo chave...
 Const DLD = "../modulo_clientes/default.asp" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Clientes"         


 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 Dim strCOD_SERV, strGRUPO, strTITULO, strCOD_EVENTO,strLOJA,strSWFILTRO, strContatoCodStatusCred
 Dim strCOD_CLIENTE

'Antes de abir o banco já carrega as variaveis 
 strCOD_CLIENTE    = Replace(GetParam("var_chavereg"),"'","''")
 
'---------------------------------------------------------------------------------------------------------------
'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 

 strSQL = "       SELECT COD_TBL_CLIENTES " 
    strSQL = strSQL &"      , tipo " 
    strSQL = strSQL &"      , NomeDoCliente " 
    strSQL = strSQL &"      , CodigoPostal  " 
    strSQL = strSQL &"      , Endereco  " 
    strSQL = strSQL &"      , BAIRRO  " 
    strSQL = strSQL &"      , cidade  " 
    strSQL = strSQL &"      , tipo " 
    strSQL = strSQL &"      , pais " 
    strSQL = strSQL &"      , cgccpf  " 
    strSQL = strSQL &"      , ierg  " 
    strSQL = strSQL &"      , idrepre  "
    strSQL = strSQL &"      , inscr_munipal  " 
    strSQL = strSQL &"      , rg  " 
    strSQL = strSQL &"      , DataRG  " 
    strSQL = strSQL &"      , OrgaoRg  " 
    strSQL = strSQL &"      , NumeroDeTelefone   " 
    strSQL = strSQL &"      , NumeroDeTelefone1  " 
    strSQL = strSQL &"      , NumeroDeTelefone2   " 
    strSQL = strSQL &"      , NumeroDeTelefone3  " 
    strSQL = strSQL &"      , CEPCob  " 
    strSQL = strSQL &"      , BairCob  " 
    strSQL = strSQL &"      , CidCob  " 
    strSQL = strSQL &"      , EstCob  " 
    strSQL = strSQL &"      , EmailCliCob   " 
    strSQL = strSQL &"      , WebSiteCob   " 
    strSQL = strSQL &"      , EmailCliCob   " 
    strSQL = strSQL &"      , Observacoes2   " 
    strSQL = strSQL &"      , BCO   " 
    strSQL = strSQL &"      , NROBANCO   " 
    strSQL = strSQL &"      , AG   " 
    strSQL = strSQL &"      , CTA   " 
    strSQL = strSQL &"      , email_nfe   " 
    strSQL = strSQL &"      , BMRS   " 
    strSQL = strSQL &"      , CNAE   " 
    strSQL = strSQL &"      , INSS   " 
    strSQL = strSQL &"      , EMailCli   " 
    strSQL = strSQL &"      , WebSite   " 
    strSQL = strSQL &"      , FANTASIA   " 
    strSQL = strSQL &"      , DataFund   " 
    strSQL = strSQL &"      , DT_AUT_CORR   " 
    strSQL = strSQL &"      , DataCad   " 
    strSQL = strSQL &"      , observacoes   " 
    strSQL = strSQL &"      , area_plantada   " 
    strSQL = strSQL &"      , area_total   " 
    strSQL = strSQL &"      , plantel   " 
    strSQL = strSQL &"      , consumo_mensal   " 
    strSQL = strSQL &"      , latitude   " 
    strSQL = strSQL &"      , longitude   " 
    strSQL = strSQL &"      , ponto_referencia   " 
    strSQL = strSQL &"      , nirf   " 
    strSQL = strSQL &" FROM TBL_CLIENTES  "  
    strSQL = strSQL &" WHERE COD_TBL_CLIENTES = " & strCOD_CLIENTE
 
 
set objRS = objConn.Execute(strSQL)


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
  document.forminsert.DEFAULT_LOCATION.value="../modulo_clientes/update.asp?var_chavereg=<%=strCOD_CLIENTE%>"; 
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
  conteudo = doc;
  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}


</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA  //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	<form name="forminsert" id="forminsert" action="../_database/athupdatetodb.asp" method="post">
		<input type="hidden" name="DEFAULT_TABLE"	 value="<%=LTB%>">
		<input type="hidden" name="DEFAULT_DB"		 value="<%=CFG_DB%>">
		<input type="hidden" name="FIELD_PREFIX" 	 value="DBVAR_">
		<input type="hidden" name="RECORD_KEY_NAME"	 value="<%=DKN%>">
        <input type="hidden" name="RECORD_KEY_VALUE"	 value="<%=strCOD_CLIENTE%>">
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
                                        <%=montaComboReturn("SELECT IDTIPO, TIPO FROM TBL_TIPO ORDER BY IDTIPO", "idtipo", "tipo",getValue(objRS,"tipo")) %>
                                    </select>                                        
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>  
                </div>  
                <div class="row">
                    <div class="span2"><p>Razao Social:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_NomeDoClienteô" name="DBVAR_STR_NomeDoCliente" type="text"  value="<%=getValue(objRS,"nomedocliente")%>" maxlength="250"></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div>  
                <div class="row">
                    <div class="span2" style=""><p>Cep:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_str_CodigoPostalô" name="DBVAR_str_CodigoPostal" type="text" maxlength="8" value="<%=replace(getValue(objRS,"CodigoPostal"),"-","")%>" onKeyPress="return validateNumKey(event);" onblur="buscaCep(this.value,'DBVAR_STR_enderecoô','DBVAR_STR_BAIRRO','DBVAR_STR_cidadeô','dbvar_str_estadoô','DBVAR_STR_paisô')"></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div>                     
                <div class="row">
                    <div class="span2" style=""><p>Endereço:</p></div>
                        <div class="span8"> 
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_enderecoô" name="DBVAR_STR_endereco" type="text" placeholder="" value="<%=getValue(objRS,"endereco")%>" maxlength="250"></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 
                <div class="row">
                    <div class="span2" style=""><p>Bairro:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_BAIRRO" name="DBVAR_STR_BAIRRO" type="text" placeholder="" value="<%=getValue(objRS,"bairro")%>" ></p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                </div> 
                <div class="row">
                    <div class="span2" style=""><p>Cidade:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_cidadeô" name="DBVAR_STR_cidade" type="text" placeholder="" value="<%=getValue(objRS,"cidade")%>" ></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>
                <div class="row">
                    <div class="span2" style=""><p>Estado:</p></div>
                        <div class="span8">
                                <div class="input-control select info-state" data-role="input-control">
                                <select  id="dbvar_str_estadoô" name="dbvar_str_estadoo">
                                        <option value="">Selecione...</option>
                                        <%=montaComboReturn("select sigla_uf, nome_uf from tbl_estados order by 1", "sigla_uf", "nome_uf",getValue(objRS,"estado")) %>                                        
                                    </select>
                                </div>
                            <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>
                <div class="row">
                    <div class="span2" style=""><p>País:</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_paisô" name="DBVAR_STR_pais" type="text" placeholder="" value="<%=getValue(objRS,"pais")%>" ></p>
                            </div>
                            <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>
                <div class="row">
                    <div class="span2" style=""><p>CNPJ:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_cgccpfô" name="DBVAR_STR_cgccpf" type="text" value="<%=getValue(objRS,"cgccpf")%>" ></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>   
                <div class="row">
                    <div class="span2" style=""><p>Inscrição Estadual:</p></div>
                    <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_iergô" name="DBVAR_STR_ierg" type="text" placeholder="" value="<%=getValue(objRS,"ierg")%>" ></p>
                            </div>
                            <span class="tertiary-text-secondary"></span>  
                    </div> 
                </div>                      
                <div class="row">
                    <div class="span2" style=""><p>Inscrição Municipal:</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_inscr_munipal" name="DBVAR_STR_inscr_munipal" type="text" placeholder="" value="<%=getValue(objRS,"inscr_munipal")%>" ></p>
                            </div>
                            <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>   
                <div class="row">
                        <div class="span2" style=""><p>RG:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_rg" name="DBVAR_STR_rg" type="text" placeholder="" value="<%=getValue(objRS,"rg")%>" ></p>
                                </div>
                                <span class="tertiary-text-secondary"></span>  
                        </div> 
                </div>   
                <div class="row">
                        <div class="span2" style=""><p>Data/Emissor:</p></div>
                        <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p class="span3"><input id="DBVAR_STR_DataRG" name="DBVAR_STR_DataRG" type="text" value="<%=getValue(objRS,"datarg")%>" ></p>
                                
                                    <p class="span2"><input id="DBVAR_STR_OrgaoRg" name="DBVAR_STR_OrgaoRg" type="text"  value="<%=getValue(objRS,"orgaorg")%>" ></p>
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
                                        <p><input id="DBVAR_STR_NumeroDeTelefoneô" name="DBVAR_STR_NumeroDeTelefone" type="text" placeholder="" value="<%=getValue(objRS,"NumeroDeTelefone")%>" maxlength="15"></p> 
                                    </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Telefone 2:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_NumeroDeTelefone1" name="DBVAR_STR_NumeroDeTelefone1" type="text" placeholder="" value="<%=getValue(objRS,"NumeroDeTelefone1")%>" maxlength="15"></p> 
                                     </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Telefone 3:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_NumeroDeTelefone2" name="DBVAR_STR_NumeroDeTelefone2" type="text" placeholder="" value="<%=getValue(objRS,"NumeroDeTelefone2")%>" maxlength="15"></p> 
                                     </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Telefone 4:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_NumeroDeTelefone3" name="DBVAR_STR_NumeroDeTelefone3" type="text" placeholder="" value="<%=getValue(objRS,"NumeroDeTelefone3")%>" maxlength="15"></p> 
                                    </div>
                                </div>
                     </div>
                    <!-- <div class="row">
                                <div class="span2"><p>Telefone 5:</p></div>
                                <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_NumeroDeTelefone4" name="DBVAR_STR_NumeroDeTelefone4" type="text" placeholder="" value="" maxlength="15"></p> 
                                    </div>
                                </div>
                     </div> -->

              </div> <!--FIM GRID//-->
            </div><!--fim do frame extra//-->

             <div class="frame" id="END_ADICIONAL" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
					
                    <div class="row">
                                <div class="span2"><p>Código Postal (CEP)</p></div>
                                <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_CEPCob" name="DBVAR_STR_CEPCob" type="text" placeholder="" value="<%=getValue(objRS,"cepcob")%>" maxlength="8" onblur="buscaCep(this.value,'DBVAR_STR_EndCob','DBVAR_STR_BairCob','DBVAR_STR_CidCob','DBVAR_STR_EstCob','')"></p> 
                                    </div>
                                </div>
                     </div>
                    
                    <div class="row">
                                <div class="span2"><p>Endereço:</p></div>                                
                                <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_EndCob" name="DBVAR_STR_EndCob" type="text" placeholder="" value="<%=getValue(objRS,"endcob")%>" maxlength="150"></p> 
                                    </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Bairro/Distrito:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_BairCob" name="DBVAR_STR_BairCob" type="text" placeholder="" value="<%=getValue(objRS,"baircob")%>" maxlength="150"></p> 
                                     </div>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Cidade/Município:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_CidCob" name="DBVAR_STR_CidCob" type="text" placeholder="" value="<%=getValue(objRS,"cidcob")%>" maxlength="150"></p> 
                                     </div>
                                </div>
                     </div>
                      <div class="row">
                                <div class="span2" style=""><p>Estado - Sigla UF:</p></div>
                                <div class="span8">
                                       <div class="input-control select info-state" data-role="input-control">
                                        <select  id="DBVAR_STR_EstCob" name="DBVAR_STR_EstCob">
                                                <option value="">Selecione...</option>
                                                <%=montaComboReturn("select sigla_uf, nome_uf from tbl_estados order by 1", "sigla_uf", "nome_uf",getValue(objRS,"estcob")) %>
                                            </select>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>  
                                </div> 
                    </div>
                       <div class="row">
                                <div class="span2"><p>Internet E-mail</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_EmailCliCob" name="DBVAR_STR_EmailCliCob" type="text" placeholder="" value="<%=getValue(objRS,"emailclicob")%>" maxlength="150"></p> 
                                    </div>
                                </div>
                    </div>
                    <div class="row">
                                <div class="span2"><p>Website:</p></div>
                                <div class="span8">
                                     <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_WebSiteCob" name="DBVAR_STR_WebSiteCob" type="text" placeholder="" value="<%=getValue(objRS,"websitecob")%>" maxlength="150"></p> 
                                    </div>
                                </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Observações End Adicional:</p></div>
                            <div class="span8">
                                    <div class="input-control textarea info-state" data-role="input-control">
                                    <p><textarea id="DBVAR_STR_Observacoes2" name="DBVAR_STR_Observacoes2" class="" onKeyPress=""><%=getValue(objRS,"observacoes2")%></textarea><p>
                                    

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
                                    <p><input id="DBVAR_STR_BCO" name="DBVAR_STR_BCO" type="text" placeholder="" value="<%=getValue(objRS,"bco")%>" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Número Banco:</p></div>                                
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_NROBANCO" name="DBVAR_STR_NROBANCO" type="text" placeholder="" value="<%=getValue(objRS,"nrobanco")%>" maxlength="15"></p> 
                                </div>
                            </div>
                     </div>
                     <div class="row">
                        <div class="span2"><p>Agência:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_AG" name="DBVAR_STR_AG" type="text" placeholder="" value="<%=getValue(objRS,"ag")%>" maxlength="15"></p> 
                                    </div>
                            </div>
                     </div>
                     <div class="row">
                        <div class="span2"><p>Conta Corrente:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CTA" name="DBVAR_STR_CTA" type="text" placeholder="" value="<%=getValue(objRS,"cta")%>" maxlength="15"></p> 
                                    </div>
                            </div>
                     </div>
                      <div class="row">
                        <div class="span2" style=""><p>E-mail NFE:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_email_nfe" name="DBVAR_DBVAR_STR_email_nfe" type="text" placeholder="" value="<%=getValue(objRS,"email_nfe")%>" maxlength="150"></p> 

                                    </div>
                                <span class="tertiary-text-secondary"></span>  
                            </div> 
                    </div>
                    <div class="row">
                        <div class="span2"><p>Código BBM-RS</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_bmrs" name="DBVAR_STR_bmrs" type="text" placeholder="" value="<%=getValue(objRS,"bmrs")%>" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Código CNAE</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_CNAE" name="DBVAR_STR_CNAE" type="text" placeholder="" value="<%=getValue(objRS,"cnae")%>" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Inscrição INSS</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_INSS" name="DBVAR_STR_INSS" type="text" placeholder="" value="<%=getValue(objRS,"inss")%>" maxlength="15"></p> 
                                </div>
                            </div>
                     </div>
                    <div class="row">
                        <div class="span2"><p>Internet E-mail</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_EMailCli" name="DBVAR_STR_EMailCli" type="text" placeholder="" value="<%=getValue(objRS,"emailcli")%>" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Website</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_WebSite" name="DBVAR_STR_WebSite" type="text" placeholder="" value="<%=getValue(objRS,"website")%>" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Nome Fantasia</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_FANTASIA" name="DBVAR_STR_FANTASIA" type="text" placeholder="" value="<%=getValue(objRS,"fantasia")%>" maxlength="15"></p> 
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Data Fundação</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_DataFund" name="DBVAR_STR_DataFund" type="text" placeholder="" value="<%=getValue(objRS,"datafund")%>" maxlength="15"></p> 
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Validade Auto Corretagem</p></div>
                        <div class="span8">
                            <div class="input-control text info-state" data-role="input-control">
                                <p><input id="DBVAR_STR_DT_AUT_CORR" name="DBVAR_STR_DT_AUT_CORR" type="text" placeholder="" value="<%=getValue(objRS,"dt_aut_corr")%>" maxlength="15"></p> 
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Representante</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_STR_idrepre" name="DBVAR_STR_idrepre" type="text" placeholder="" value="<%=getValue(objRS,"idrepre")%>" maxlength="15"></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Data Cadastro</p></div>
                            <div class="span8">
                                <div class="input-control text info-state" data-role="input-control">
                                    <p><input id="DBVAR_date_DataCad" name="DBVAR_date_DataCad" type="text" placeholder="" value="<%=getValue(objRS,"datacad")%>" maxlength="15" readonly></p> 
                                </div>
                            </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Observações:</p></div>
                            <div class="span8">
                                    <div class="input-control textarea info-state" data-role="input-control">
                                    <p><textarea id="DBVAR_STR_Observacoes" name="DBVAR_STR_Observacoes" class="" onKeyPress=""><%=getValue(objRS,"observacoes")%></textarea><p>

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

                                    <p><input id="DBVAR_STR_area_plantada"name="DBVAR_STR_area_plantada" type="text" placeholder="" value="<%=getValue(objRS,"area_plantada")%>" maxlength="250"></p>
                                    </div>
                                 <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Área Total:</p></div>
                                <div class="span8"><p>
                                    <div class="input-control text info-state"data-role="input-control">

                                        <p><input id="DBVAR_STR_area_total"name="DBVAR_STR_area_total" type="text" placeholder="" value="<%=getValue(objRS,"area_total")%>" maxlength="250"></p>
                                    </div>
                                 <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Plantel:</p></div>
                                <div class="span8"><p>
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_plantel"name="DBVAR_STR_plantel" type="text" placeholder="" value="<%=getValue(objRS,"plantel")%>" maxlength="250"></p>
                                    </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     
                     <div class="row">
                                <div class="span2" style=""><p>Consumo Mensal (kg):</p></div>
                                <div class="span8"> 
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_consumo_mensal" name="DBVAR_STR_consumo_mensal" type="text" placeholder="" value="<%=getValue(objRS,"consumo_mensal")%>" maxlength="250"></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row">
                                <div class="span2" style=""><p>Latitude</p></div>
                                <div class="span8">
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_latitude" name="DBVAR_STR_latitude" type="text" placeholder="" value="<%=getValue(objRS,"latitude")%>" ></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2" style=""><p>Longitude:</p></div>
                                <div class="span8">
                                    	<div class="input-control text info-state" data-role="input-control">
                                            <p><input id="DBVAR_STR_longitude" name="DBVAR_STR_longitude" type="text" placeholder="" value="<%=getValue(objRS,"longitude")%>" ></p>
                                        </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                    </div> 
                 
                     <div class="row">
                            <div class="span2" style=""><p>Ponto de Referência:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_ponto_referencia" name="DBVAR_STR_ponto_referencia" type="text" placeholder="" value="<%=getValue(objRS,"ponto_referencia")%>" ></p>
                                    </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                    </div> 
                     <div class="row">
                            <div class="span2" style=""><p>Nirf:</p></div>
                            <div class="span8">
                                    <div class="input-control text info-state" data-role="input-control">
                                        <p><input id="DBVAR_STR_nirf" name="DBVAR_STR_nirf" type="text" placeholder="" value="<%=getValue(objRS,"nirf")%>" ></p>
                                    </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                    </div>                    
              </div> <!--FIM GRID//-->
            </div><!--fim do frame PLANTIO//-->



              </div> <!--FIM GRID///-->
            </div><!--fim do frame extra//-->
            <!--
            
            <div class="frame" id="AJUDA">
                 <p>O modulo CFG_Panel esta habilitado a criar atalhos no "painel principal" do sistema PVista
                 e tem em seus campos de cadastro a descrição de como proceder na inserção ou alteração de um atalho.<br>
                 Com este módulo será possível configurar um atalho especificando o caminho do modulo até a cor .<br> Além do tamanho do atalho 
                 mas isto deve ser tratado com atenção pois ele tem padrões de cadastramento para funcionar perfeitamente.</p>
            </div >
            //-->      
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 

    
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

