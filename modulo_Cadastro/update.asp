<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_Cadastro",Session("ID_USER")), true %>
<%

 Const LTB = "tbl_empresas"	' - Nome da Tabela...
 Const DKN = "COD_EMPRESA" 	' - Campo chave...
 Const TIT = "Cadastro"    	' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

'Relativas a conexão com DB, RecordSet e SQL
Dim objConn, objRS, strSQL,strSQL2,strSQL3,objRSDetail
'Relativas a FILTRAGEM e Seleção	
Dim  strCOD_EMPRESA

AbreDBConn objConn, CFG_DB	
	
		strCOD_EMPRESA = Replace(GetParam("var_chavereg"),"'","''")
'-----------------------------------------------------------------------------------------
		strSQL = " SELECT     COD_EMPRESA "	
	strSQL = strSQL & "		  ,ACOMP1 "
	strSQL = strSQL & "		  ,ACOMP2 "
	strSQL = strSQL & "		  ,AUTORIZA_DIVULGACAO_DADOS "
	strSQL = strSQL & "		  ,COD_STATUS_CRED "
	strSQL = strSQL & "		  ,COD_STATUS_PRECO "
	strSQL = strSQL & "		  ,CODATIV1 "
	strSQL = strSQL & "		  ,CODATIV2 "
	strSQL = strSQL & "		  ,CODATIV3 "
	strSQL = strSQL & "		  ,CODBARRA "
	strSQL = strSQL & "		  ,COE "
	strSQL = strSQL & "		  ,COLIGADA "
	strSQL = strSQL & "		  ,DESCRICAO "
	strSQL = strSQL & "		  ,DT_ANIV "
	strSQL = strSQL & "		  ,DT_NASC "
	strSQL = strSQL & "		  ,EMAIL1 "
	strSQL = strSQL & "		  ,EMAIL2 "
	strSQL = strSQL & "		  ,END_BAIRRO "
	strSQL = strSQL & "		  ,END_CEP "
	strSQL = strSQL & "		  ,END_CIDADE "
	strSQL = strSQL & "		  ,END_COMPL "
	strSQL = strSQL & "		  ,END_ESTADO "
	strSQL = strSQL & "		  ,END_FULL "
	strSQL = strSQL & "		  ,END_LOGR "
	strSQL = strSQL & "		  ,END_NUM "
	strSQL = strSQL & "		  ,END_PAIS "
	strSQL = strSQL & "		  ,ENTIDADE "
	strSQL = strSQL & "		  ,ENTIDADE_CARGO "
	strSQL = strSQL & "		  ,ENTIDADE_CNPJ "
	strSQL = strSQL & "		  ,ENTIDADE_DEPARTAMENTO "
	strSQL = strSQL & "		  ,ENTIDADE_EMAIL "
	strSQL = strSQL & "		  ,ENTIDADE_FANTASIA "
	strSQL = strSQL & "		  ,ENTIDADE_FONE "
	strSQL = strSQL & "		  ,ENTIDADE_RESP_CREDENCIAL "
	strSQL = strSQL & "		  ,ENTIDADE_SETOR "
	strSQL = strSQL & "		  ,EXTRA_NUM_1 "
	strSQL = strSQL & "		  ,EXTRA_NUM_2 "
	strSQL = strSQL & "		  ,EXTRA_NUM_3 "
	strSQL = strSQL & "		  ,EXTRA_TXT_1 "
	strSQL = strSQL & "		  ,EXTRA_TXT_10 "
	strSQL = strSQL & "		  ,EXTRA_TXT_2 "
	strSQL = strSQL & "		  ,EXTRA_TXT_3 "
	strSQL = strSQL & "		  ,EXTRA_TXT_4 "
	strSQL = strSQL & "		  ,EXTRA_TXT_5 "
	strSQL = strSQL & "		  ,EXTRA_TXT_6 "
	strSQL = strSQL & "		  ,EXTRA_TXT_7 "
	strSQL = strSQL & "		  ,EXTRA_TXT_8 "
	strSQL = strSQL & "		  ,EXTRA_TXT_9 "
	strSQL = strSQL & "		  ,FONE1 "
	strSQL = strSQL & "		  ,FONE2 "
	strSQL = strSQL & "		  ,FONE3 "
	strSQL = strSQL & "		  ,FONE4 "
	strSQL = strSQL & "		  ,HOMEPAGE "
	strSQL = strSQL & "		  ,ID_CNPJ "
	strSQL = strSQL & "		  ,ID_CPF "
	strSQL = strSQL & "		  ,ID_INSCR_EST "
	strSQL = strSQL & "		  ,ID_INSCR_MUN "
	strSQL = strSQL & "		  ,ID_NUM_DOC1 "
	strSQL = strSQL & "		  ,ID_NUM_DOC2 "
	strSQL = strSQL & "		  ,ID_RG "
	strSQL = strSQL & "		  ,IMG_FOTO "
	strSQL = strSQL & "		  ,LOJA_SENHA "
	strSQL = strSQL & "		  ,NOMECLI "
	strSQL = strSQL & "		  ,NOMEFAN "
	strSQL = strSQL & "		  ,NRO_EVENTOS_VISITADOS "
	strSQL = strSQL & "		  ,PDV "
	strSQL = strSQL & "		  ,PORTADOR_NECESSIDADE_ESPECIAL "
	strSQL = strSQL & "		  ,PRESS_EDITORIA "
	strSQL = strSQL & "		  ,PRESS_TIPOVEICULO "
	strSQL = strSQL & "		  ,RECEBER_NEWSLETTER "
	strSQL = strSQL & "		  ,RECEBER_SMS "
	strSQL = strSQL & "		  ,REFERENCIA "
	strSQL = strSQL & "		  ,senha "
	strSQL = strSQL & "		  ,SEXO "
	strSQL = strSQL & "		  ,SINDIPROM "
	strSQL = strSQL & "		  ,SYS_DATAAT "
	strSQL = strSQL & "		  ,SYS_DATACA "
	strSQL = strSQL & "		  ,SYS_DATACRED "
	strSQL = strSQL & "		  ,SYS_INATIVO "
	strSQL = strSQL & "		  ,SYS_UPDATE "
	strSQL = strSQL & "		  ,SYS_USERAT "
	strSQL = strSQL & "		  ,SYS_USERCA "
	strSQL = strSQL & "		  ,TIPO_PESS "
	strSQL = strSQL & "		  ,TRIB_EMPRESA_MISTA "
	strSQL = strSQL & "		  ,TRIB_EMPRESA_SIMPLES "
	strSQL = strSQL & "		  ,ULTIMO_COD_EVENTO "
		strSQL = strSQL & "  FROM "& LTB 	
		strSQL = strSQL & " WHERE COD_EMPRESA = " & strCOD_EMPRESA 	
		
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
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() {
 <% 
 	if (CFG_WINDOW = "NORMAL") then 
		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Cadastro/default.asp';") 
	else
		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
 	end if
%>  
	/*document.formupdate.DEFAULT_LOCATION.value="../_database/athWindowClose.asp"; */
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}

function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Cadastro/update.asp?var_chavereg=<%=strCOD_EMPRESA%>"; 
  if (validateRequestedFields("formupdate")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.formupdate.submit(); 
  }
}

function cancelar() { 
 <%
	if (CFG_WINDOW = "NORMAL") then 
		response.write ("window.history.back()")
	else
		response.write ("window.close();")
	end if
 %> 
}

</script>
<script language="javascript" type="text/javascript">
//função para ativar o date picker dos campos data
$("#datepicker").datepicker({
date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer já  ele modifica automaticamente para data setada dentro da função//-->
format: "dd/mm/yyyy", // set output format
effect: "none", // none, slide, fade
position: "bottom", // top or bottom,
locale: ''en, // 'ru' or 'en', default is $.Metro.currentLocale
});
</script>
<!-- FIM----------------------------------------- funções //-->
</head>
<body class="metro" id="metrotablevista">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding5 ">
<!--div class TAB CONTROL --------------------------------------------------//-->
    <form name="formupdate" id="formupdate" action="../_database/athupdatetodb.asp" method="post">
    <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
    <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
    <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">	
    <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
    <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_EMPRESA%>">
    <input type="hidden" name="DEFAULT_LOCATION" value="">
    <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
	<div class="tab-control " data-effect="fade" data-role="tab-control" >
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_EMPRESA%>.GERAL</a></li>
            <li class=""><a href="#STATUS">STATUS</a></li> 
            <li class=""><a href="#EXTRATXT">EXTRATXT</a></li>
            <li class=""><a href="#ENTIDADE">ENTIDADE</a></li>                                    
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" >
                <!--//-->
                    <div class="tab-control " data-effect="fade" data-role="tab-control">
                        <ul class="tabs">
                            <li class="active"><a href="#GERAL1">CADASTRO</a></li>
                            <li class="#"><a href="#DOCS1">DOCS</a></li>
                            <!--<li><a href="#MINI">MINI</a></li>//-->   
                        </ul>
                        <div class="frames">
                            <div class="frame" id="GERAL1">
                                <div class="grid">
                                    <div class="row">
                                        <div class="span2"><p>*Cod.Barra:</p></div>
                                        <div class="span8">
											<div class="grid">
                                            	<div class="row" style="margin:0px;">
                                                    <div class="span4 ">
                                                        <p class="input-control text" data-role="input-control">                                                                                        
                                                            <input id="DBVAR_STR_CODBARRA" name="DBVAR_STR_CODBARRA" type="text" placeholder="" value="<%=getValue(objRS,"CODBARRA")%>" maxlength="9" readonly>
                                                        </p>
                                                        <span class="tertiary-text-secondary"> Este valor representa o codigo de barra(nove digitos) de uma credencial, gerado a partir do cod_empresa.(somente leitura)</span> 
                                                    </div>
                                                    <div class="span2">
                                                        <p class="input-control select" data-role="input-control">                                    
                                                            <select type="text" name="DBVAR_STR_TIPO_PESS" id="DBVAR_STR_TIPO_PESS" class="">
                                                                <option value="S" <%if getValue(objRS,"TIPO_PESS") ="S" then response.Write("selected")%>>PF (S)</option>
                                                                <option value="N" <%if getValue(objRS,"TIPO_PESS") ="N" then response.Write("selected")%>>PJ (N)</option>
                                                            </select>
                                                        </p>
                                                        <span class="tertiary-text-secondary">(tipo_pess)</span>  
                                                    </div>                                                                                                                                         
                                            	</div>
											</div>
                                        </div>
                                    </div>                                      
                                    <div class="row ">
                                        <div class="span2"><p>Cliente:</p></div>
                                        <div class="span8"> 
                                                <p class="input-control text " data-role="input-control">
                                                    <input id="DBVAR_STR_NOMECLI" name="DBVAR_STR_NOMECLI" type="text" placeholder="" value="<%=getValue(objRS,"NOMECLI")%>" maxlength="120" >
                                                </p> 
	                                            <span class="tertiary-text-secondary">Campo que contém o nome do cliente, observando que sendo ele um cliente PJ, deverá contar a Razão Social, e sendo ele do tipo PF conterá seu nome propriamente dito (nommecli).</span>                             
                                        </div>
                                    </div>     
                                    <div class="row">
                                        <div class="span2"><p>Nome Fantasia:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_NOMEFAN" name="DBVAR_STR_NOMEFAN" type="text" placeholder="" value="<%=getValue(objRS,"NOMEFAN")%>" maxlength="100" >
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">(nomefan)</span>                             
                                        </div>
                                    </div>                                            
                                                     
                                    <div class="row">
                                        <div class="span2"><p>Endereço:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_END_FULL" name="DBVAR_STR_END_FULL" type="text" placeholder="" value="<%=getValue(objRS,"END_FULL")%>" maxlength="180" >
                                                </p>
                                            </div>
                                            <span class="tertiary-text-secondary">(end full)</span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2"><p>Nº/Complemento:</p></div>
                                        <div class="span8"> 
                                            <div class="grid">
                                                <div class="row" style="margin:0px;">                                            
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_END_NUM3" name="DBVAR_STR_END_NUM" type="text" placeholder="" value="<%=getValue(objRS,"END_NUM")%>" maxlength="50" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                        </p>
                                                        <span class="tertiary-text-secondary">(end_num)</span>
                                                    </div> 
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_END_COMPL" name="DBVAR_STR_END_COMPL" type="text" placeholder="" value="<%=getValue(objRS,"END_COMPL")%>" maxlength="100" >
                                                        </p>
                                                        <span class="tertiary-text-secondary">(end_compl)</span>
                                                    </div>
                                                </div>
                                        	</div>                                                                        
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Bairro:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_END_BAIRRO" name="DBVAR_STR_END_BAIRRO" type="text" placeholder="" value="<%=getValue(objRS,"END_BAIRRO")%>" maxlength="80" >
                                                </p>
                                            </div>
                                            <span class="tertiary-text-secondary">(end_bairro)</span>                             
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="span2"><p>End Cep/Sexo:</p></div>
                                        <div class="span8"> 
                                            <div class="grid">
                                                <div class="row" style="margin:0px;">
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_END_CEP" name="DBVAR_STR_END_CEP" type="text" placeholder="" value="<%=getValue(objRS,"END_CEP")%>" maxlength="15" >
                                                        </p>
                                                        <span class="tertiary-text-secondary">(end_cep)</span>  
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control select " data-role="input-control">
                                                            <select name="DBVAR_STR_SEXO" id="DBVAR_STR_SEXO" >
                                                                <option value="F" <% If getValue(objRS,"SEXO") = "F" Then Response.Write("selected") End If %>>Masculino</option>
                                                                <option value="M" <% If getValue(objRS,"SEXO") = "M" Then Response.Write("selected") End If %>>Feminino</option>
                                                            </select> 
                                                        </p>
                                                        <span class="tertiary-text-secondary">(sexo)</span>  
                                                    </div>
                                                </div>
                                            </div>
                                          </div>
                                    </div>                                                                                                                                                                                
                                    <div class="row">
                                        <div class="span2"><p>End. Logradouro:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_END_LOGR" name="DBVAR_STR_END_LOGR" type="text" placeholder="" value="<%=getValue(objRS,"END_LOGR")%>" maxlength="100" >
                                                </p>
                                            </div>
                                            <span class="tertiary-text-secondary">(end_logr)</span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Cidade:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_CODATIV3" name="DBVAR_STR_CODATIV3" type="text" placeholder="" value="<%=getValue(objRS,"END_CIDADE")%>" maxlength="100" >
                                                </p>
                                                <span class="tertiary-text-secondary">(end_cidade)</span>
                                            </div>                                                 
                                        </div>
                                    </div>      
                                    <div class="row">
                                        <div class="span2"><p>End Estado /End País:</p></div>
                                        <div class="span8"> 
                                            <div class="grid">
                                                <div class="row" style="margin:0px;">                        
                                                    <div class="span3">
                                                         <p class="input-control select" data-role="input-control">
                                                            <select id="DBVAR_STR_END_ESTADO" name="DBVAR_STR_ END_ESTADO" class="">
                                                            <option value=""   <%IF getValue(objRS,"END_ESTADO") = "" THEN RESPONSE.Write("selected") %>>[selecione]</option>
                                                            <option value="AC" <%IF getValue(objRS,"END_ESTADO") = "AC" THEN RESPONSE.Write("selected") %>>Acre - AC</option>
                                                            <option value="AL" <%IF getValue(objRS,"END_ESTADO") = "AL" THEN RESPONSE.Write("selected") %>>Alagoas - AL</option>
                                                            <option value="AP" <%IF getValue(objRS,"END_ESTADO") = "AP" THEN RESPONSE.Write("selected") %>>Amapá - AP</option>
                                                            <option value="AM" <%IF getValue(objRS,"END_ESTADO") = "AM" THEN RESPONSE.Write("selected") %>>Amazonas - AM</option>
                                                            <option value="BA" <%IF getValue(objRS,"END_ESTADO") = "BA" THEN RESPONSE.Write("selected") %>>Bahia  - BA</option>
                                                            <option value="CE" <%IF getValue(objRS,"END_ESTADO") = "CE" THEN RESPONSE.Write("selected") %>>Ceará - CE</option>
                                                            <option value="DF" <%IF getValue(objRS,"END_ESTADO") = "DF" THEN RESPONSE.Write("selected") %>>Distrito Federal  - DF</option>
                                                            <option value="ES" <%IF getValue(objRS,"END_ESTADO") = "ES" THEN RESPONSE.Write("selected") %>>Espírito Santo - ES</option>
                                                            <option value="GO" <%IF getValue(objRS,"END_ESTADO") = "GO" THEN RESPONSE.Write("selected") %>>Goiás - GO</option>
                                                            <option value="MA" <%IF getValue(objRS,"END_ESTADO") = "MA" THEN RESPONSE.Write("selected") %>>Maranhão - MA</option>
                                                            <option value="MT" <%IF getValue(objRS,"END_ESTADO") = "MT" THEN RESPONSE.Write("selected") %>>Mato Grosso - MT</option>
                                                            <option value="MS" <%IF getValue(objRS,"END_ESTADO") = "MS" THEN RESPONSE.Write("selected") %>>Mato Grosso do Sul - MS</option>
                                                            <option value="MG" <%IF getValue(objRS,"END_ESTADO") = "MG" THEN RESPONSE.Write("selected") %>>Minas Gerais - MG</option>
                                                            <option value="PA" <%IF getValue(objRS,"END_ESTADO") = "PA" THEN RESPONSE.Write("selected") %>>Pará - PA</option>
                                                            <option value="PB" <%IF getValue(objRS,"END_ESTADO") = "PB" THEN RESPONSE.Write("selected") %>>Paraíba - PB</option>
                                                            <option value="PR" <%IF getValue(objRS,"END_ESTADO") = "PR" THEN RESPONSE.Write("selected") %>>Paraná - PR</option>
                                                            <option value="PE" <%IF getValue(objRS,"END_ESTADO") = "PE" THEN RESPONSE.Write("selected") %>>Pernambuco - PE</option>
                                                            <option value="PI" <%IF getValue(objRS,"END_ESTADO") = "PI" THEN RESPONSE.Write("selected") %>>Piauí - PI</option>
                                                            <option value="RJ" <%IF getValue(objRS,"END_ESTADO") = "RJ" THEN RESPONSE.Write("selected") %>>Rio de Janeiro - RJ</option>
                                                            <option value="RN" <%IF getValue(objRS,"END_ESTADO") = "RN" THEN RESPONSE.Write("selected") %>>Rio Grande do Norte - RN</option>
                                                            <option value="RS" <%IF getValue(objRS,"END_ESTADO") = "RS" THEN RESPONSE.Write("selected") %>>Rio Grande do Sul - RS</option>
                                                            <option value="RO" <%IF getValue(objRS,"END_ESTADO") = "RO" THEN RESPONSE.Write("selected") %>>Rondônia - RO</option>
                                                            <option value="RR" <%IF getValue(objRS,"END_ESTADO") = "RR" THEN RESPONSE.Write("selected") %>>Roraima - RR</option>
                                                            <option value="SC" <%IF getValue(objRS,"END_ESTADO") = "SC" THEN RESPONSE.Write("selected") %>>Santa Catarina - SC</option>
                                                            <option value="SP" <%IF getValue(objRS,"END_ESTADO") = "SP" THEN RESPONSE.Write("selected") %>>São Paulo - SP</option>
                                                            <option value="SE" <%IF getValue(objRS,"END_ESTADO") = "SE" THEN RESPONSE.Write("selected") %>>Sergipe - SE</option>
                                                            <option value="TO" <%IF getValue(objRS,"END_ESTADO") = "TO" THEN RESPONSE.Write("selected") %>>Tocantins - TO</option>
                                                            </select>
                                                        </p>
                                                        <span class="tertiary-text-secondary">(end_estado)</span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control select" data-role="input-control"> 
                                                                <select name="DBVAR_STR_END_PAIS" id="DBVAR_STR_END_PAIS" >
                                                                <option value="">[selecione]</option>
                                                                <% MontaCombo "STR"," SELECT CONCAT(CAST(ID_PAIS AS CHAR), ' - ', CAST(PAIS AS CHAR)) as PAISES FROM tbl_PAISES ORDER BY PAIS", "PAISES", "PAISES",getValue(objRS,"END_PAIS")%>
                                                                </select>               
                                                        </p>
                                                        <span class="tertiary-text-secondary">(end_pais)</span>
                                                    </div>                                                 
                                                </div>
                                            </div>                                    
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Fone2/Fax:</p></div>
                                        <div class="span8">
                                            <div class="grid">
                                                <div class="row" style="margin:0px;"> 
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_FONE1" name="DBVAR_STR_FONE1" type="text" placeholder="" value="<%=getValue(objRS,"FONE1")%>" maxlength="50" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                        </p>
                                                        <span class="tertiary-text-secondary">(fone1)</span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_FONE2" name="DBVAR_STR_FONE2" type="text" placeholder="" value="<%=getValue(objRS,"FONE2")%>" maxlength="50" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                        </p>
                                                        <span class="tertiary-text-secondary">(fone2)</span>
                                                    </div> <!--fim input//-->                            
                                                </div>
                                            </div>
                                        </div> <!--fim span8//-->
                                    </div><!--fim row//-->                                 
                                    <div class="row">
                                        <div class="span2"><p>Celular/Fone:</p></div>
                                        <div class="span8">
                                            <div class="grid">
                                                <div class="row" style="margin:0px;">                                             
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_FONE3" name="DBVAR_STR_FONE3" type="text" placeholder="" value="<%=getValue(objRS,"FONE3")%>" maxlength="50" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                        </p>
                                                        <span class="tertiary-text-secondary">(fone3)</span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_FONE4" name="DBVAR_STR_FONE4" type="text" placeholder="" value="<%=getValue(objRS,"FONE4")%>" maxlength="50" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                        </p>
                                                        <span class="tertiary-text-secondary">(fone4)</span>
                                                    </div>                             
                                                </div>
                                            </div>
                                         </div>   
                                    </div>                                                               
                                    <div class="row">
                                        <div class="span2"><p>Email1:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_EMAIL1" name="DBVAR_STR_EMAIL1" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL1")%>" maxlength="100" >
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Email2:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_EMAIL2" name="DBVAR_STR_EMAIL2" type="text" placeholder="" value="<%=getValue(objRS,"EMAIL2")%>" maxlength="100" >
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Site:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_HOMEPAGE" name="DBVAR_STR_HOMEPAGE" type="text" placeholder="" value="<%=getValue(objRS,"HOMEPAGE")%>" maxlength="150" >
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">(homepage)</span>                             
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>Data Aniver./ Data Nasc.:</p></div>
                                        <div class="span8"> 
                                            <div class="grid">
                                                <div class="row" style="margin-top::0px;">                        
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control"  data-format="" data-position="" data-effect="">
                                                        	<input id="DBVAR_STR_DT_ANIV" name="DBVAR_STR_DT_ANIV" type="text" placeholder="" value="<%=getValue(objRS,"DT_ANIV")%>" maxlength="5" >
                                                        </p>
                                                        <span class="tertiary-text-secondary">Data de Aniversario DD/MM </span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                        <input id="DBVAR_DATE_DT_NASC" name="DBVAR_DATE_DT_NASC" type="text" placeholder="" value="<%=PrepData(getValue(objRS,"DT_NASC"),True,False)%> " maxlength="11" class="">
                                                        <span class="btn-date"></span>
                                                        </p>
                                                        <span class="tertiary-text-secondary">DT_NASC = Data Nascimento (PF) e DT_NASC = Data de fundação (PJ) </span>
                                                	</div>
                                            	</div>                        	                                                                                                                                    
                                        	</div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="span2"><p>Acompanhante1:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_ACOMP1" name="DBVAR_STR_ACOMP1" type="text" placeholder="" value="<%=getValue(objRS,"ACOMP1")%>" maxlength="50" >
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">(acomp1)</span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Acompanhante2:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_ACOMP2" name="DBVAR_STR_ACOMP2" type="text" placeholder="" value="<%=getValue(objRS,"ACOMP2")%>" maxlength="50" >
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">(acomp2)</span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Categoria/Tipo de Credencial:</p></div>
                                        <div class="span8">
                                            <div class="grid">
                                                <div class="row" style="margin:0px;"> 
                                                     <div class="input-control select size3" data-role="input-control">
                                                        <p>
                                                            <select type="text" name="DBVAR_STR_COD_STATUS_PRECO" id="DBVAR_STR_COD_STATUS_PRECO" class="">
                                                                <option value="">Selecione...</option>
                                                                <%MontaCombo "STR","SELECT DISTINCT COD_STATUS_PRECO, CONCAT(CAST(COD_STATUS_PRECO AS CHAR), ' - ', CAST(STATUS AS CHAR)) as STATUS FROM TBL_STATUS_PRECO", "COD_STATUS_PRECO", "STATUS", getValue(objRS,"COD_STATUS_PRECO")&""%>
                                                            </select>
                                                        </p>
                                                        <span class="tertiary-text-secondary">Cod. Status Preco</span>
                                                     </div>
                                                     <div class="input-control select size3" data-role="input-control">
                                                        <p>
                                                            <select type="text" name="DBVAR_NUM_COD_STATUS_CRED" id="DBVAR_NUM_COD_STATUS_CRED" class="">
                                                                <option value="">Selecione...</option>
                                                                <%MontaCombo "STR","SELECT DISTINCT COD_STATUS_CRED, CONCAT(CAST(COD_STATUS_CRED AS CHAR), ' - ', CAST(STATUS AS CHAR)) as STATUS FROM TBL_STATUS_CRED", "COD_STATUS_CRED", "STATUS", getValue(objRS,"COD_STATUS_CRED")&""%>                                                                    
                                                            </select>
                                                        </p>
                                                        <span class="tertiary-text-secondary">Cod Status Cred</span>
                                                     </div>
                                                </div>
                                            </div>                       
                                        </div>
                                    </div>                             
                                    <div class="row">
                                        <div class="span2"><p>Imagem Foto:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_IMG_FOTO" name="DBVAR_STR_IMG_FOTO" type="text" placeholder="" value="<%=getValue(objRS,"IMG_FOTO")%>" maxlength="50" >
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">(img_foto)Nome do arquivo usado no cadastro (pf/pj)<!-- width=340,height=385//--></span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Portador Necessidade Especial:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                	<input id="DBVAR_STR_PORTADOR_NECESSIDADE_ESPECIAL" name="DBVAR_STR_PORTADOR_NECESSIDADE_ESPECIAL" type="text" placeholder="" value="<%=getValue(objRS,"PORTADOR_NECESSIDADE_ESPECIAL")%>" maxlength="80" >
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">(portador_necessodade_especial)</span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Imprensa Editoria/Tipo Veiculo:</p></div>
                                        <div class="span8">
                                        	<div class="grid">
                                                <div class="row" style="margin:0px;">                                            
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_PRESS_EDITORIA" name="DBVAR_STR_PRESS_EDITORIA" type="text" placeholder="" value="<%=getValue(objRS,"PRESS_EDITORIA")%>" maxlength="80" >
                                                        </p>
                                                        <span class="tertiary-text-secondary">(press_editora)</span>
                                                    </div>
                                                
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_PRESS_TIPOVEICULO" name="DBVAR_STR_PRESS_TIPOVEICULO" type="text" placeholder="" value="<%=getValue(objRS,"PRESS_TIPOVEICULO")%>" maxlength="45" >
                                                        </p>
                                                        <span class="tertiary-text-secondary">(press_tipoveiculo)</span>
                                                    </div>
                                                </div>
											</div>                                        	                                            
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Sindiprom/Divulgação Dados::</p></div>
                                        <div class="span8">                                             
                                            <div class="grid">
                                                <div class="row" style="margin:0px;">
                                                    <div class="span3">
                                                        <p class="input-control text select " data-role="input-control">
                                                            <select name="DBVAR_STR_SINDIPROM" id="DBVAR_STR_SINDIPROM" >
                                                                <option value="SIM" <%If getValue(objRS,"SINDIPROM") = "SIM" Then Response.Write("selected") End If %>>SIM</option>
                                                                <option value="NÂO" <%If getValue(objRS,"SINDIPROM") = "NÂO" Then Response.Write("selected") End If %>>NÂO</option>
                                                            </select>                                                        
                                                        </p>
                                                        <span class="tertiary-text-secondary">Campo usado para saber filiado do Sinsiprom.Usados apenas por alguns cliente abup, abrh e realalliance</span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control select" data-role="input-control">
                                                            <select name="DBVAR_STR_AUTORIZA_DIVULGACAO_DADOS" id="DBVAR_STR_AUTORIZA_DIVULGACAO_DADOS" >
                                                                <option value="S" <%If getValue(objRS,"AUTORIZA_DIVULGACAO_DADOS") = "S"  Then Response.Write("selected") End If %>>SIM</option>
                                                                <option value="N" <%If getValue(objRS,"AUTORIZA_DIVULGACAO_DADOS") = "N" Then Response.Write("selected") End If %>>NÂO</option>
                                                            </select> 
                                                        </p>
                                                        <span class="tertiary-text-secondary">(autoriza_diculcacao_dados)</span>  
                                                      </div>                         
                                                </div>
                                            </div>
                                        </div>
                                    </div>                 
                                </div><!--fim grid//-->  
                            </div><!--fim de frame geral1//-->
                            <div class="frame" id="DOCS1">
                                <div class="grid" style="border:0px solid #F00">           
                                    <div class="row">
                                        <div class="span2"><p>Doc1/ Doc2:</p></div>
                                        <div class="span8">
                                            <div class="grid">
                                                <div class="row" style="margin:0px;">                                             
                                                    <div class="span3">
                                                        <p  class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_ID_NUM_DOC1" name="DBVAR_STR_ID_NUM_DOC1" type="text" placeholder="" value="<%=getValue(objRS,"ID_NUM_DOC1")%>" maxlength="50" >
                                                        </p>
                                                        <span class="tertiary-text-secondary">(id_num_doc1)CNPJ para PJ / CPF para PF</span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_ID_NUM_DOC2" name="DBVAR_STR_ID_NUM_DOC2" type="text" placeholder="" value="<%=getValue(objRS,"ID_NUM_DOC2")%>" maxlength="50" readonly>
                                                        </p>
                                                        <span class="tertiary-text-secondary">*(somente leitura)(id_num_doc2)</span>
                                                        <h6><span class="tertiary-text-secondary"></span></h6>
                                                    </div>
                                                </div>
                                            </div>                   
                                        </div>
                                    </div>                               
                                    <div class="row">
                                        <div class="span2"><p>CNPJ/CPF:</p></div>
                                        <div class="span8"> 
                                            <div class="grid">
                                                <div class="row" style="margin:0px;">                                             
                                                    <div class="span3">
                                                        <p  class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_ID_CNPJ" name="DBVAR_STR_ID_CNPJ" type="text" placeholder="" value="<%=getValue(objRS,"ID_CNPJ")%>" maxlength="20" *(somente leitura)>
                                                        </p>
                                                        <span class="tertiary-text-secondary">*(somente leitura)(id_cnpj)</span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_ID_CPF" name="DBVAR_STR_ID_CPF" type="text" placeholder="" value="<%=getValue(objRS,"ID_CPF")%>" maxlength="50" readonly>
                                                        </p>
                                                        <span class="tertiary-text-secondary">*(somente leitura)(id_cpf)</span>
                                                         <h6><span class="tertiary-text-secondary"></span></h6> 
                                                    </div>
                                                </div>
                                            </div>                   
                                        </div>
                                    </div>                               
                                    <div class="row">
                                        <div class="span2"><p>RG:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_ID_RG" name="DBVAR_STR_ID_RG" type="text" placeholder="" value="<%=getValue(objRS,"ID_RG")%>" maxlength="50" >
                                                </p>
                                            </div>
                                        	<span class="tertiary-text-secondary">ID_RG usando somente quando cadastro tipo (PF) ID_NUM_DOC1 = CPF</span>  
                                        </div>
                                    </div>                                                                                      
                                    <div class="row">
                                        <div class="span2"><p>Inscrição estadual/Inscrição Municipal:</p></div>
                                        <div class="span8">
                                            <div class="grid">
                                                <div class="row" style="margin:0px;"> 
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_ID_INSCR_EST" name="DBVAR_STR_ID_INSCR_EST" type="text" placeholder="" value="<%=getValue(objRS,"ID_INSCR_EST")%>" maxlength="20" >
                                                        </p>
                                                        <span class="tertiary-text-secondary">(id_inscr_est) quando (PF ) = RG quando (PJ) = Inscricao estadual</span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control text" data-role="input-control">
                                                            <input id="DBVAR_STR_ID_INSCR_MUN" name="DBVAR_STR_ID_INSCR_MUN" type="text" placeholder="" value="<%=getValue(objRS,"ID_INSCR_MUN")%>" maxlength="50" >
                                                        </p>
                                                        <span class="tertiary-text-secondary">(id_inscr_mun)</span>
                                                    </div>
                                                </div>
                                            </div>     
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>CodAtiv1/CodAtiv2:</p></div>
                                        <div class="span8">
                                                <div class="row" style="margin:0px;">
                                                <div class="row"> 
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_CODATIV1" name="DBVAR_STR_CODATIV1" type="text" placeholder="" value="<%=getValue(objRS,"CODATIV1")%>" maxlength="5" >
                                                        </p>
                                                        <span class="tertiary-text-secondary">"Cod de Atividade(profissão (e/ou) ramo) do Cliente"</span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_STR_CODATIV2" name="DBVAR_STR_CODATIV2" type="text" placeholder="" value="<%=getValue(objRS,"CODATIV2")%>" maxlength="50" >
                                                        </p>
                                                        <span class="tertiary-text-secondary"></span>
                                                    </div>
                                                </div> 
                                            </div>                                                                            
                                        </div>
                                    </div>                             
                                    <div class="row">
                                        <div class="span2"><p>CodAtiv3:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_CODATIV3" name="DBVAR_STR_CODATIV3" type="text" placeholder="" value="<%=getValue(objRS,"CODATIV3")%>" maxlength="50" >
                                                </p>
                                            </div>
                                            <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>COE:</p></div>
                                        <div class="span8"> 
                                             <div class="input-control text " data-role="input-control">
                                                <p class="input-control text " data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                    <input id="DBVAR_DATE_COE" name="DBVAR_DATE_COE" type="text" placeholder="" value="<%=PrepData(getValue(objRS,"COE"),True,False)%> " maxlength="11" class="">
                                                    <span class="btn-date"></span>
                                                </p>
                                            </div>                        	                                                  
                                        <span class="tertiary-text-secondary">DataCred campo para informar a última data da impressão da credencial</span>                             
                                        </div>
                                    </div>                                                                                
                                    <div class="row">
                                        <div class="span2"><p>Coligada:<h6><span class="tertiary-text-secondary">*campo especial para cfg do ambiente CM</span></h6></p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_COLIGADA" name="DBVAR_STR_COLIGADA" type="text" placeholder="" value="<%=getValue(objRS,"COLIGADA")%>" maxlength="50" >
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">*configura a caracteristica de empresa coligada campo para indicar que a empresa é vinculada a outra empresa, atibuto utilizado por ambientes como Ex:/cm </span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>PDV:<h6><span class="tertiary-text-secondary">*campo especial para cfg do ambiente CM</span></h6></p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                <p>
                                                    <input id="DBVAR_STR_PDV" name="DBVAR_STR_PDV" type="text" placeholder="" value="<%=getValue(objRS,"PDV")%>" maxlength="10" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                </p>
                                            </div>
                                        <span class="tertiary-text-secondary">campo para informar o numero de "Pontos De Venda"</span>                             
                                        </div>
                                    </div> 
                                    <div class="row">
                                        <div class="span2"><p>Referência:</p></div>
                                        <div class="span8"> 
                                            <div class="input-control text " data-role="input-control">
                                                    <p>
                                                        <input id="DBVAR_STR_REFERENCIA" name="DBVAR_STR_REFERENCIA" type="text" placeholder="" value="<%=getValue(objRS,"REFERENCIA")%>" maxlength="1024" >
                                                    </p>
                                                    <span class="tertiary-text-secondary">&nbsp;</span>
                                            </div>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Nº Eventos Visitados/Ultimo Cod. Evento:</p></div>
                                        <div class="span8"> 
                                            <div class="grid">
                                                <div class="row" style="margin:0px;">                                            
                                                    <div class="span3">
                                                        <p class="input-control text" data-role="input-control">
                                                            <input id="DBVAR_STR_NRO_EVENTOS_VISITADOS" name="DBVAR_STR_NRO_EVENTOS_VISITADOS" type="text" placeholder="" value="<%=getValue(objRS,"NRO_EVENTOS_VISITADOS")%>" maxlength="11" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                        </p>
                                                    	<span class="tertiary-text-secondary">(nro_evento_visitados)</span>
                                                    </div>
                                                    <div class="span3">
                                                        <p class="input-control select" data-role="input-control"> 
                                                            <select name="DBVAR_STR_ULTIMO_COD_EVENTO" id="DBVAR_STR_ULTIMO_COD_EVENTO" >
                                                                <option value="" <%if getValue(objRS,"ULTIMO_COD_EVENTO") ="" then response.write("selected")%>>[Selecione]</option>
                                                                <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) as NOME FROM tbl_EVENTO", "COD_EVENTO", "NOME", getValue(objRS,"ULTIMO_COD_EVENTO") %>
                                                            </select>
                                                        </p>
                                                        <span class="tertiary-text-secondary">(ultimo_evento)</span>
                                                    </div>
                                                </div>
                                            </div>                                                                 
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span2"><p>Descrição:</p></div>
                                        <div class="span8"> 
                                             <p class="input-control textarea " data-role="input-control">
                                                <textarea name="DBVAR_STR_DESCRICAO" id="DBVAR_STRDBVAR_STR_DESCRICAO_ARIEL_TEXTO"><%=ReturnCaracterEspecial(getValue(objRS,"DESCRICAO")&"")%></textarea>
                                             </p>
                                        <span class="tertiary-text-secondary"></span>                             
                                        </div>
                                    </div>                 
                                    <div class="row">
                                        <div class="span3"><p>ExtrNº1/ExtrNº2/ExtrNº3:</p></div>
                                        <div class="span7">
                                            <div class="grid">
                                                <div class="row" style="margin:0px;">                                             
                                                    <div class="span2">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_NUM_EXTRA_NUM_1" name="DBVAR_NUM_EXTRA_NUM_1" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_NUM_1")%>" maxlength="10" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                        </p>
                                                        <span class="tertiary-text-secondary">EXTRA_NUM_1</span>
                                                    </div>
                                                    <div class="span2">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_NUM_EXTRA_NUM_2" name="DBVAR_NUM_EXTRA_NUM_2" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_NUM_2")%>" maxlength="10" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                        </p>
                                                        <span class="tertiary-text-secondary">EXTRA_NUM_2</span>
                                                    </div>
                                                    <div class="span2">
                                                        <p class="input-control text " data-role="input-control">
                                                            <input id="DBVAR_NUM_EXTRA_NUM_3" name="DBVAR_NUM_EXTRA_NUM_3" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_NUM_3")%>" maxlength="10" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                                        </p>
                                                        <span class="tertiary-text-secondary">EXTRA_NUM_3</span>
                                                    </div>
                                                </div>
                                            </div>                             
                                        </div>
                                    </div>                                       
                                </div><!--fim grid//-->  
                            </div><!--fim de frame docs1//-->
                        </div><!--fim sub frames//-->
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid geral//-->
            </div><!--fim frame dados//-->
<!--FIM aba geral ------------------------------------------------------------------------------------------------>
<!--INI aba status ------------------------------------------------------------------------------------------------>
            <div class="frame" id="STATUS" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                 	<div class="row">
                        <div class="span2"><p>Sys DataCa:</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_DATE_SYS_DATACA" id="DBVAR_DATE_SYS_DATACA"  type="radio" value="" <% If getValue(objRS,"SYS_DATACA") = "" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_DATE_SYS_DATACA" id="DBVAR_DATE_SYS_DATACA2" type="radio" value="<%=Now()%>" <% If getValue(objRS,"SYS_DATACA") <> "" Then Response.Write("checked") End If %> >
                                    Não 
                            </p>
                        <span class="tertiary-text-secondary">Marca data de Cadastro</span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Sys DataAt.:</p></div>
                        <div class="span8">
                            <p>
                                <input name="DBVAR_DATE_SYS_DATAAT" id="DBVAR_DATE_SYS_DATAAT"  type="radio" value="" <% If getValue(objRS,"SYS_DATAAT") = "" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_DATE_SYS_DATAAT" id="DBVAR_DATE_SYS_DATAAT2" type="radio" value="<%=Now()%>" <% If getValue(objRS,"SYS_DATAAT") <> "" Then Response.Write("checked") End If %> >
                                    Não 
                            </p>                                                  	                         
                        <span class="tertiary-text-secondary">Marca data de Alteração do Cadastro</span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Sys DataCred.:</p></div>
                        <div class="span8"> 
                           <p>
                               <input name="DBVAR_DATE_SYS_DATACRED" id="DBVAR_DATE_SYS_DATACRED"  type="radio" value="" <% If getValue(objRS,"SYS_DATACRED") = "" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_DATE_SYS_DATACRED" id="DBVAR_DATE_SYS_DATACRED2" type="radio" value="<%=Now()%>" <% If getValue(objRS,"SYS_DATACRED") <> "" Then Response.Write("checked") End If %> >
                                    Não 
                            </p>
                     	
                        <span class="tertiary-text-secondary">Marca data de Credenciamento para C.O.E</span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Sys UserRat/Sys User Ca:</p></div>
                        <div class="span8"> 
                        	<div class="grid">
                        		<div class="row" style="margin:0px;">                          
                                    <div class="span3">
                                        <p class="input-control text " data-role="input-control">
                                            <input id="DBVAR_STR_SYS_USERAT" name="DBVAR_STR_SYS_USERAT" type="text" placeholder="" value="<%=getValue(objRS,"SYS_USERAT")%>" maxlength="15" >
                                        </p>
                                        <span class="tertiary-text-secondary"></span>
                                    </div>
                                    <div class="span3">
                                        <p class="input-control text " data-role="input-control">
                                            <input id="DBVAR_STR_SYS_USERCA" name="DBVAR_STR_SYS_USERCA" type="text" placeholder="" value="<%=getValue(objRS,"SYS_USERCA")%>" maxlength="5" >
                                        </p>
                                        <span class="tertiary-text-secondary"></span>
                                     </DIV>   
                                </div>
                        	</div>                        	                             
                        </div>
                    </div> 
					<div class="row">
                        <div class="span2"><p>Loja Senha/ SENHA:</p></div>
                        <div class="span8"> 
                        	<div class="grid">
                        		<div class="row" style="margin:0px;">                            
                                    <div class="span3">
                                        <p class="input-control text " data-role="input-control">
                                		<input id="DBVAR_STR_LOJA_SENHA" name="DBVAR_STR_LOJA_SENHA" type="text"  value="<%=getValue(objRS,"LOJA_SENHA")%>" maxlength="15" readonly>
                                		</p>
                        				<span class="tertiary-text-secondary">(loja_senha)/*(somente leitura) - não esta mais sendo usado</span>                             
                        			</div>
                                    <div class="span3">
                                        <p class="input-control text " data-role="input-control">
                                    	<input id="DBVAR_STR_senha" name="DBVAR_STR_senha" type="text" placeholder="" value="<%=getValue(objRS,"senha")%>" maxlength="50" >
                                 		</p>
                                        <span class="tertiary-text-secondary"></span>
                                     </DIV>   
                                </div>
                        	</div>                        	                             
                        </div>
                    </div> 
                    <div class="row">
                        <div class="span2"><p>Sys Update:</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_STR_SYS_UPDATE" id="DBVAR_STR_SYS_UPDATE" type="radio" value="1" <% If getValue(objRS,"SYS_UPDATE")= "1" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_STR_SYS_UPDATE" id="DBVAR_STR_SYS_UPDATE2" type="radio" value="0" <% If getValue(objRS,"SYS_UPDATE")= "0" Then Response.Write("checked") End If %>>
                                    Não 
                            </p>                            
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Ativos(sys_inativo):</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_DATE_SYS_INATIVO" id="DBVAR_DATE_SYS_INATIVO"  type="radio" value="" <% If getValue(objRS,"SYS_INATIVO") = "" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_DATE_SYS_INATIVO" id="DBVAR_DATE_SYS_INATIVO2" type="radio" value="<%=Now()%>" <% If getValue(objRS,"SYS_INATIVO") <> "" Then Response.Write("checked") End If %> >
                                    Não 
                            </p>
                            <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>
                    <div class="row">
                        <div class="span2"><p>Receber SMS:</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_STR_RECEBER_SMS" id="DBVAR_STR_RECEBER_SMS" type="radio" value="1" <% If getValue(objRS,"RECEBER_SMS")= "1" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_STR_RECEBER_SMS" id="DBVAR_STR_RECEBER_SMS2" type="radio" value="0" <% If getValue(objRS,"RECEBER_SMS")= "0" Then Response.Write("checked") End If %>>
                                    Não 
                            </p>                            
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Receber Newsletter:</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_STR_RECEBER_NEWSLETTER" id="DBVAR_STR_RECEBER_NEWSLETTER" type="radio" value="1" <% If getValue(objRS,"RECEBER_NEWSLETTER")= "1" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_STR_RECEBER_NEWSLETTER" id="DBVAR_STR_RECEBER_NEWSLETTER2" type="radio" value="0" <% If getValue(objRS,"RECEBER_NEWSLETTER")= "0" Then Response.Write("checked") End If %>>
                                    Não 
                            </p>                                                        
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Trib Empresa Mista:</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_STR_TRIB_EMPRESA_MISTA" id="DBVAR_STR_TRIB_EMPRESA_MISTA" type="radio" value="1" <% If getValue(objRS,"TRIB_EMPRESA_MISTA")= "1" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_STR_TRIB_EMPRESA_MISTA" id="DBVAR_STR_TRIB_EMPRESA_MISTA2" type="radio" value="0" <% If getValue(objRS,"TRIB_EMPRESA_MISTA")= "0" Then Response.Write("checked") End If %>>
                                    Não 
                            </p>                                                                                    
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Trib Empresa Simples:</p></div>
                        <div class="span8"> 
                            <p>
                                <input name="DBVAR_STR_TRIB_EMPRESA_SIMPLES" id="DBVAR_STR_TRIB_EMPRESA_SIMPLES" type="radio" value="1" <% If getValue(objRS,"TRIB_EMPRESA_SIMPLES")= "1" Then Response.Write("checked") End If %>>
                                    Sim 
                                <input name="DBVAR_STR_TRIB_EMPRESA_SIMPLES" id="DBVAR_STR_TRIB_EMPRESA_SIMPLES2" type="radio" value="0" <% If getValue(objRS,"TRIB_EMPRESA_SIMPLES")= "0" Then Response.Write("checked") End If %>>
                                    Não 
                            </p>                                                                                    
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    
                </div><!--fim grid layout//-->
            </div><!--fim frame status//-->
<!--FIM aba status ------------------------------------------------------------------------------------------------>  
<!--INI aba sextra txt ------------------------------------------------------------------------------------------------> 
			<div class="frame" id="EXTRATXT" style="width:100%;"><!--esta guia contem tab dentro de tab//-->
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="tab-control" data-role="tab-control">
                        <ul class="tabs">
                            <li class="active"><a href="#EXTRATXT1">EXTRATXT1-5</a></li>
                            <li><a href="#EXTRATXT2">EXTRATXT6-10</a></li>                                                                                   
                        </ul>
                        <div class="frames">
                            <div class="frame" id="EXTRATXT1">
                                <div class="grid" style="border:0px solid #F00">
                    <div class="row">
                        <div class="span2"><p>Extra TXT 1:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_1" name="DBVAR_STR_EXTRA_TXT_1" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_1")%>" maxlength="50" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Extra TXT 2:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_2" name="DBVAR_STR_EXTRA_TXT_2" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_2")%>" maxlength="50" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Extra TXT 3:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_3" name="DBVAR_STR_EXTRA_TXT_3" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_3")%>" maxlength="50" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Extra TXT 4:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_4" name="DBVAR_STR_EXTRA_TXT_4" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_4")%>" maxlength="50" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Extra TXT 5:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_5" name="DBVAR_STR_EXTRA_TXT_5" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_5")%>" maxlength="50" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                                </div><!--fim grid layout//-->  
                            </div><!--fim FRAME MOD1//-->
                            <div class="frame" id="EXTRATXT2">
                                <div class="grid" style="border:0px solid #F00">
                    <div class="row">
                        <div class="span2"><p>Extra TXT 6:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_6" name="DBVAR_STR_EXTRA_TXT_6" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_6")%>" maxlength="50" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Extra TXT 7:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_7" name="DBVAR_STR_EXTRA_TXT_7" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_7")%>" maxlength="150" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Extra TXT 8:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_8" name="DBVAR_STR_EXTRA_TXT_8" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_8")%>" maxlength="150" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Extra TXT 9:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_9" name="DBVAR_STR_EXTRA_TXT_9" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_9")%>" maxlength="150" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Extra TXT 10:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_EXTRA_TXT_10" name="DBVAR_STR_EXTRA_TXT_10" type="text" placeholder="" value="<%=getValue(objRS,"EXTRA_TXT_10")%>" maxlength="150" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                                </div><!--fim grid layout//-->  
                            </div><!--fim FRAME MOD1//-->
                        </div><!--fim sub frames//-->  
                    </div><!--fim do sub tabcontrol//-->
                </div><!--fim grid //-->
            </div><!--fim frame correspondencia//-->
<!--FIM aba extra txt ------------------------------------------------------------------------------------------------>
<!--INI aba ENTIDADE ------------------------------------------------------------------------------------------------>               
  
			<div class="frame" id="ENTIDADE" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="row">
                        <div class="span2"><p>&nbsp;</p></div>
                        <div class="span8"> 
                        <span class="tertiary-text-secondary">
                        	Quando este cadastro se referir a um PF (PESSOA FÍSICA) informar aqui os dados da Entidade/Empresa/Instituição de Ensino que está PF está vinculada.
                        </span>                      
                        </div>
                    </div>                 
                
                    <div class="row">
                        <div class="span2"><p>Entidade:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_ENTIDADE" name="DBVAR_STR_ENTIDADE" type="text" placeholder="" value="<%=getValue(objRS,"ENTIDADE")%>" maxlength="100" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Entidade Fantasia:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_ENTIDADE_FANTASIA" name="DBVAR_STR_ENTIDADE_FANTASIA" type="text" placeholder="" value="<%=getValue(objRS,"ENTIDADE_FANTASIA")%>" maxlength="80" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Entidade CNPJ:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_ENTIDADE_CNPJ" name="DBVAR_STR_ENTIDADE_CNPJ" type="text" placeholder="" value="<%=getValue(objRS,"ENTIDADE_CNPJ")%>" maxlength="50" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Entidade Cargo:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_ENTIDADE_CARGO" name="DBVAR_STR_ENTIDADE_CARGO" type="text" placeholder="" value="<%=getValue(objRS,"ENTIDADE_CARGO")%>" maxlength="100" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
					<div class="row">
                        <div class="span2"><p>Entidade Setor:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_ENTIDADE_SETOR" name="DBVAR_STR_ENTIDADE_SETOR" type="text" placeholder="" value="<%=getValue(objRS,"ENTIDADE_SETOR")%>" maxlength="50" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Entidade Departamento:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_ENTIDADE_DEPARTAMENTO" name="DBVAR_STR_ENTIDADE_DEPARTAMENTO" type="text" placeholder="" value="<%=getValue(objRS,"ENTIDADE_DEPARTAMENTO")%>" maxlength="50" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Entidade Fone:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_ENTIDADE_FONE" name="DBVAR_STR_ENTIDADE_FONE" type="text" placeholder="" value="<%=getValue(objRS,"ENTIDADE_FONE")%>" maxlength="45" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                 
                    <div class="row">
                        <div class="span2"><p>Entidade Email:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_ENTIDADE_EMAIL" name="DBVAR_STR_ENTIDADE_EMAIL" type="text" placeholder="" value="<%=getValue(objRS,"ENTIDADE_EMAIL")%>" maxlength="150" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>                                    
                    <div class="row">
                        <div class="span2"><p>Entidade Resp. Credencial:</p></div>
                        <div class="span8"> 
                            <div class="input-control text " data-role="input-control">
                                <p>
                                	<input id="DBVAR_STR_ENTIDADE_RESP_CREDENCIAL" name="DBVAR_STR_ENTIDADE_RESP_CREDENCIAL" type="text" placeholder="" value="<%=getValue(objRS,"ENTIDADE_RESP_CREDENCIAL")%>" maxlength="120" >
                                </p>
                            </div>
                        <span class="tertiary-text-secondary"></span>                             
                        </div>
                    </div>            
                </div><!--fim grid entidade//-->
            </div><!--fim frame ENTIDADE//-->                    
<!--INI aba entidade ------------------------------------------------------------------------------------------------>               

		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 
    
    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
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
