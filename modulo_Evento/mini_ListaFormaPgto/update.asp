<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("mini_ListaFormaPgto",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "TBL_EVENTO_FORMAPGTO" 								    ' - Nome da Tabela...
 Const DKN = "IDAUTO"									        ' - Campo chave...
 Const DLD = "../modulo_Evento/mini_ListaFormaPgto/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Lista FormaPgto"									' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro
 
 
 
'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCOD_EVENTO,strVALOR,strID_AUTO

'Carraga a chave do registro, porém neste caso a relação masterdetail 
'ocorre com COD_EVENTO mesmo a chave do pai sendo ID_AUTO. 
'---------------carrega cachereg do pai local cred-----------------
strCOD_EVENTO 		= Replace(GetParam("var_cod_evento"),"'","''")
strID_AUTO			= Replace(GetParam("var_chavereg"),"'","''")
'------------------------------------------------------------------
'If strCOD_EVENTO <> "" Then
	
	AbreDBConn objConn, CFG_DB
	
	' strSQL = " SELECT EFP.IDAUTO"
'	strSQL = strSQL & "		  , EFP.COD_FORMAPGTO  "
'	strSQL = strSQL & "		  , EFP.COD_EVENTO "
'	strSQL = strSQL & "		  , FP.FORMAPGTO "
'	strSQL = strSQL & "		  , EFP.EXIBIR_LOJA "
'	strSQL = strSQL & "		  , EFP.COD_PAIS "
'	strSQL = strSQL & "		  , EFP.TIPO "
'	strSQL = strSQL & "		  , ID_LOJA "
'	strSQL = strSQL & "		  , COD_CONTRATO "
'	strSQL = strSQL & "		  , CEDENTE "
'	strSQL = strSQL & "		  , CARTEIRA "
'	strSQL = strSQL & "		  , AGENCIA "
'	strSQL = strSQL & "		  , CONTA "
'	strSQL = strSQL & "		  , GERENTE "
'	strSQL = strSQL & "		  , CNPJ "
'	strSQL = strSQL & "		  , RAZAO_SOCIAL "
'	strSQL = strSQL & "		  , PARCELAS "
'	strSQL = strSQL & "		  , INSTRUCOES "
'	strSQL = strSQL & "		  , VALOR_MIN "
'	strSQL = strSQL & "		  , VALOR_MAX "
'	strSQL = strSQL & "		  , DT_LIMITE_VCTO "
'	strSQL = strSQL & "		  , DV_AGENCIA "
'	strSQL = strSQL & "		  , DV_CONTA "
'	strSQL = strSQL & "		  , ASSINATURA "
'	strSQL = strSQL & "		  , COD_MOEDA_COBRANCA "
'	strSQL = strSQL & "		  , ARIEL "
'	strSQL = strSQL & "		  , ARIEL_ASSUNTO "
'	strSQL = strSQL & "		  , ARIEL_INTL "
'	strSQL = strSQL & "		  , ARIEL_INTL_ASSUNTO "
'	strSQL = strSQL & "		  , VALOR_TAXA "
'	strSQL = strSQL & "		  , NUM_DIAS_VCTO "
'	strSQL = strSQL & "		  , CAPTURA "
'	strSQL = strSQL & "		  , PARCELA_VLR_MINIMO "
'	strSQL = strSQL & "		  , CABECALHO "
'	strSQL = strSQL & "		  , RODAPE "
'	strSQL = strSQL & "		  , ENDERECO "
'	strSQL = strSQL & "		  , CONTROLE_FINALIZAR_COMPRA "
'	strSQL = strSQL & "		   FROM TBL_EVENTO_FORMAPGTO EFP, TBL_FORMAPGTO FP " 
'	strSQL = strSQL & "		   WHERE EFP.COD_EVENTO = " & strCOD_EVENTO
'	strSQL = strSQL & "  	   AND EFP.COD_FORMAPGTO = FP.COD_FORMAPGTO "
'	strSQL = strSQL & "		   ORDER BY FP.FORMAPGTO" 

 strSQL = " SELECT EFP.IDAUTO"
	strSQL = strSQL & "		  , EFP.COD_FORMAPGTO  "
	strSQL = strSQL & "		  , EFP.COD_EVENTO "
	'strSQL = strSQL & "		  , EFP.FORMAPGTO "
	strSQL = strSQL & "		  , EFP.EXIBIR_LOJA "
	strSQL = strSQL & "		  , EFP.COD_PAIS "
	strSQL = strSQL & "		  , EFP.TIPO "
	strSQL = strSQL & "		  , EFP.ID_LOJA "
	strSQL = strSQL & "		  , EFP.COD_CONTRATO "
	strSQL = strSQL & "		  , EFP.CEDENTE "
	strSQL = strSQL & "		  , EFP.CARTEIRA "
	strSQL = strSQL & "		  , EFP.AGENCIA "
	strSQL = strSQL & "		  , EFP.CONTA "
	strSQL = strSQL & "		  , EFP.BANCO "
	strSQL = strSQL & "		  , EFP.GERENTE "
	strSQL = strSQL & "		  , EFP.CNPJ "
	strSQL = strSQL & "		  , EFP.RAZAO_SOCIAL "
	strSQL = strSQL & "		  , EFP.PARCELAS "
	strSQL = strSQL & "		  , EFP.INSTRUCOES "
	strSQL = strSQL & "		  , EFP.VALOR_MIN "
	strSQL = strSQL & "		  , EFP.VALOR_MAX "
	strSQL = strSQL & "		  , EFP.DT_LIMITE_VCTO "
	strSQL = strSQL & "		  , EFP.DV_AGENCIA "
	strSQL = strSQL & "		  , EFP.DV_CONTA "
	strSQL = strSQL & "		  , EFP.ASSINATURA "
	strSQL = strSQL & "		  , EFP.COD_MOEDA_COBRANCA "
	strSQL = strSQL & "		  , EFP.ARIEL "
	strSQL = strSQL & "		  , EFP.ARIEL_ASSUNTO "
	strSQL = strSQL & "		  , EFP.ARIEL_INTL "
	strSQL = strSQL & "		  , EFP.ARIEL_INTL_ASSUNTO "
	strSQL = strSQL & "		  , EFP.VALOR_TAXA "
	strSQL = strSQL & "		  , EFP.PERC_TAXA "
	strSQL = strSQL & "		  , EFP.NUM_DIAS_VCTO "
	strSQL = strSQL & "		  , EFP.CAPTURA "
	strSQL = strSQL & "		  , EFP.PARCELA_VLR_MINIMO "
	strSQL = strSQL & "		  , EFP.CABECALHO "
	strSQL = strSQL & "		  , EFP.RODAPE "
	strSQL = strSQL & "		  , EFP.ENDERECO "
	strSQL = strSQL & "		  , EFP.PROSHOP_TEXTO_FINAL "
	strSQL = strSQL & "		   FROM TBL_EVENTO_FORMAPGTO EFP, TBL_FORMAPGTO FP " 
	strSQL = strSQL & "		   WHERE EFP.IDAUTO = " & strID_AUTO
	strSQL = strSQL & "  	   AND EFP.COD_FORMAPGTO = FP.COD_FORMAPGTO "
	strSQL = strSQL & "		   ORDER BY FP.FORMAPGTO"
	
	'response.Write(strSQL)
	'response.End()
	
'	strSQL = " SELECT EFP.IDAUTO"
'	strSQL = strSQL & "		  , EFP.COD_FORMAPGTO  "
'	strSQL = strSQL & "		  , EFP.COD_EVENTO "
'	strSQL = strSQL & "		  , FP.FORMAPGTO "
'	strSQL = strSQL & "		  , EFP.EXIBIR_LOJA "
'	strSQL = strSQL & "		  , EFP.COD_PAIS "
'	strSQL = strSQL & "		  , EFP.TIPO "
'	strSQL = strSQL & "		   FROM TBL_EVENTO_FORMAPGTO EFP, TBL_FORMAPGTO FP " 
'	strSQL = strSQL & "		   WHERE EFP.COD_EVENTO = " & strCOD_EVENTO
'	strSQL = strSQL & "  	   AND EFP.COD_FORMAPGTO = FP.COD_FORMAPGTO "
'	strSQL = strSQL & "		   ORDER BY FP.FORMAPGTO"
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null

strVALOR = 0

%> 
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<script src="../../metro-calendar.js"></script>
<script src="../../metro-datepicker.js"></script>
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Evento/mini_ListaFormaPgto/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Evento/mini_ListaFormaPgto/update.asp?var_chavereg=<%=strID_AUTO%>&var_cod_evento=<%=strCOD_EVENTO%>"; 
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
    <input type="hidden" name="RECORD_KEY_NAME" value="IDAUTO">
     <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strID_AUTO%>">
    <input type="hidden" name="DEFAULT_LOCATION" value="">
    <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
        <!--<input type="hidden" name="DBVAR_NUM_COD_EVENTO" id="DBVAR_NUM_COD_EVENTO" value="<'%=getValue(objRS,"COD_EVENTO")%>">//-->
 <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strID_AUTO%>.GERAL</a></li>
            <li class="#"><a href="#EXTRA">EXTRA</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                   <div class="row ">
                                <div class="span2"><p>Forma de PGTO/ Cod.Pais:</p></div>
                                <div class="span8">
                                	<div class="input-control select size2" data-role="input-control">
                                    	<p>
                                        <select name="DBVAR_STR_COD_FORMAPGTO" id="DBVAR_STR_COD_FORMAPGTO" class="">
                                            <% montaCombo "STR" ,"SELECT cod_formapgto, formapgto FROM tbl_formapgto ORDER BY formapgto", "COD_FORMAPGTO", "FORMAPGTO", GetValue(objRS,"COD_FORMAPGTO") %>
                                        </select>
                                        </p>
                                	</div> 
                                	<div class="input-control select size2" data-role="input-control">
                                    	<p>                                                                           
                                        <select name="DBVAR_STR_COD_PAIS" id="DBVAR_STR_COD_PAIS" class=""> 
                                        <option value="BR" <%if getValue(objRS,"COD_PAIS")="BR" then response.Write("selected")%>>BR</option>
                                        <option value="US" <%if getValue(objRS,"COD_PAIS")="US" then response.Write("selected")%>>US</option>
                                        <option value="ES" <%if getValue(objRS,"COD_PAIS")="ES" then response.Write("selected")%>>ES</option>
                                        </select>
                                        </p>
									</div>
                                </div> 
                     </div>
                    <div class="row">
                        <div class="span2"><p>Exibe Loja</p></div>
                            <div class="span8">
                                                <p>
                                                    <input name="DBVAR_NUM_EXIBIR_LOJA" id="DBVAR_NUM_EXIBIR_LOJA"  type="radio" value="1" <% If getValue(objRS,"EXIBIR_LOJA")= "1" Then Response.Write("checked") End If %> >
                                                        Sim 
                                                    <input name="DBVAR_NUM_EXIBIR_LOJA" id="DBVAR_NUM_EXIBIR_LOJA2"  type="radio" value="0" <% If not getValue(objRS,"EXIBIR_LOJA")= "1" Then Response.Write("checked") End If %> >
                                                        Não 
                                                </p>
                            <span class="tertiary-text-secondary"></span>
                            </div>
                    </div> 
                   <div class="row ">
                            <div class="span2"><p>Id Loja/ Tipo:</p></div>
                            <div class="span8">
                                <div class="input-control select text size4" data-role="input-control">
                                	<p>                                                                                                            <!--//-->
                                      <input id="DBVAR_STR_ID_LOJA" name="DBVAR_STR_ID_LOJA" type="text" placeholder="" value="<%=GetValue(objRS,"ID_LOJA")%>" maxlength="50" class="">
                                      </p>
                                </div>
                                <div class="input-control select text size1" data-role="input-control">
                                	<p>                                                                                                            <!--//-->
                                      <input id="DBVAR_STR_TIPO" name="DBVAR_STR_TIPO" type="text" placeholder="" value="<%=GetValue(objRS,"TIPO")%>" maxlength="2" class="">
                                      </p>
                                </div>
                            <span class="tertiary-text-secondary"></span>
                            </div> 
                     </div>
                    <div class="row ">
                                <div class="span2"><p>Cedente:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_CEDENTE"  name="DBVAR_STR_CEDENTE" type="text" value="<%=GetValue(objRS,"CEDENTE")%>" maxlength="50"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Carteira:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_CARTEIRA"  name="DBVAR_STR_CARTEIRA" type="text" value="<%=GetValue(objRS,"CARTEIRA")%>" maxlength="3"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Banco:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_BANCO"  name="DBVAR_STR_BANCO" type="text" value="<%=GetValue(objRS,"BANCO")%>" maxlength="3"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Agencia:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_AGENCIA"  name="DBVAR_STR_AGENCIA" type="text"  value="<%=GetValue(objRS,"AGENCIA")%>" maxlength="50"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Conta:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_CONTA"  name="DBVAR_STR_CONTA" type="text"  value="<%=GetValue(objRS,"CONTA")%>" maxlength="50"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Gerente:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_GERENTE"  name="DBVAR_STR_GERENTE" type="text"  value="<%=GetValue(objRS,"GERENTE")%>" maxlength="80"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>CNPJ:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_CNPJ"  name="DBVAR_STR_CNPJ" type="text"  value="<%=GetValue(objRS,"CNPJ")%>" maxlength="80"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Razão Social:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_RAZAO_SOCIAL"  name="DBVAR_STR_RAZAO_SOCIAL" type="text"  value="<%=GetValue(objRS,"RAZAO_SOCIAL")%>" maxlength="255"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>*Parcelas/ Parcelas Valor Minimo:</p></div>
                                <div class="span8">
                                     <div class="input-control text size2 info-state" data-role="input-control">
                                     	<p>
                                     		<input  id="DBVAR_STR_PARCELASô"  name="DBVAR_STR_PARCELAS" type="text"  value="<%=GetValue(objRS,"PARCELAS")%>" maxlength="11" class="" onKeyPress="Javascript:return validateNumKey(event);return false;">
                                     	</p>
                                     </div>
                                     <div class="input-control text size3" data-role="input-control"> 
                                     	<p>                                           
                                     		<input  id="DBVAR_STR_PARCELA_VLR_MINIMO"  name="DBVAR_STR_PARCELA_VLR_MINIMO" type="text"  value="<%=GetValue(objRS,"PARCELA_VLR_MINIMO")%>" maxlength="7" class="">
                                     	</p>
                                     </div>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Instruções:</p></div>
                                <div class="span8">
                                     <p class="input-control textarea" data-role="input-control"><textarea  id="DBVAR_STR_INSTRUCOES"  name="DBVAR_STR_INSTRUCOES" type="text"  ><%=GetValue(objRS,"INSTRUCOES")%></textarea></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Valor Minimo/Valor Máximo:</p></div>
                                <div class="span8">
                                     <div class="input-control text size2" data-role="input-control">
                                     	<p>
                                     		<input  id="DBVAR_STR_VALOR_MIN"  name="DBVAR_STR_VALOR_MIN" type="text"  value="<%=GetValue(objRS,"VALOR_MIN")%>" maxlength="11" class="">
                                     	</p>
                                     </div>
                                     <div class="input-control text size3" data-role="input-control"> 
                                     	<p>                                           
                                     		<input  id="DBVAR_STR_VALOR_MAX"  name="DBVAR_STR_VALOR_MAX" type="text"  value="<%=GetValue(objRS,"VALOR_MAX")%>" maxlength="11" class=""></p>
                                     	</p>
                                     </div>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                            <div class="span2"><p>COD. Contrato:</p></div>
                            <div class="span8">
                                 <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_COD_CONTRATO"  name="DBVAR_STR_COD_CONTRATO" type="text"  value="<%=GetValue(objRS,"COD_CONTRATO")%>" maxlength="255" ></p>
                                 <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                            </div> 
                    </div>
                       <div class="row ">
                                <div class="span2"><p>Número Dias Vencto:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_NUM_NUM_DIAS_VCTO"  name="DBVAR_NUM_NUM_DIAS_VCTO" type="text"  value="<%=GetValue(objRS,"NUM_DIAS_VCTO")%>" maxlength="255"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                      <div class="row ">
                                <div class="span2"><p>DT.Limite Vencto:</p></div>
                                <div class="span8">
                                            <div class="input-control text size3" data-role="input-control">
                                                <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                                	<input id="DBVAR_DATE_DT_LIMITE_VCTO" name="DBVAR_DATE_DT_LIMITE_VCTO" type="text" placeholder="" value="<%=PrepData(getValue(objRS,"DT_LIMITE_VCTO"),True,False)%> " maxlength="10" class="" >
                                                	<span class="btn-date"></span>
                                            	</p>
                                            </div>
                                
<!--                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_NUM_DT_LIMITE_VCTO"  name="DBVAR_NUM_DT_LIMITE_VCTO" type="text"  value="<'%=GetValue(objRS,"DT_LIMITE_VCTO")%>" maxlength="10" onKeyPress="return FormataInputDataNew(this,event);"></p//-->
                                     <span class="tertiary-text-secondary"></span>  
                                </div> 
                     </div>
                      <div class="row ">
                        <div class="span2"><p>Dv. Agência/Dv. Conta</p></div>
                        <div class="span8">
                            <div class="input-control text size1" data-role="input-control">
                                 <p>
                                    <input  id="DBVAR_STR_DV_AGENCIA"  name="DBVAR_STR_DV_AGENCIA" type="text"  value="<%=GetValue(objRS,"DV_AGENCIA")%>" maxlength="1" class="">
                                 </p>
                             </div>
                            <div class="input-control text size1" data-role="input-control">
                                 <p>
                                     <input  id="DBVAR_STR_DV_CONTA"  name="DBVAR_STR_DV_CONTA" type="text"  value="<%=GetValue(objRS,"DV_CONTA")%>" maxlength="1" class="">
                                 </p>
                             </div>                                         
                             <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                        </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Assinatura:</p></div>
                                <div class="span8">
                                     <p class="input-control textarea" data-role="input-control"><textarea  id="DBVAR_STR_ASSINATURA"  name="DBVAR_STR_ASSINATURA" type="text"><%=GetValue(objRS,"ASSINATURA")%></textarea></p>
                                     <span class="tertiary-text-secondary">(Obs.: este campo serve como TOKEN para PagSEGURO).</span>  
                                </div> 
                     </div>
                      <div class="row ">
                        <div class="span2"><p>Moeda Cob / Valor Taxa / Percentual Taxa:</p></div>
                        <div class="span8">
                             <div class="input-control text size2" data-role="input-control">
                                <p>
                                    <input  id="DBVAR_STR_COD_MOEDA_COBRANCA"  name="DBVAR_STR_COD_MOEDA_COBRANCA" type="text"  value="<%=GetValue(objRS,"COD_MOEDA_COBRANCA")%>" maxlength="3" class="" onKeyPress="return validateNumKey(event);">
                                </p>
                            </div>                                                                            
                             <div class="input-control text size2" data-role="input-control">
                                <p>
                                    <input id="DBVAR_FLOAT_VALOR_TAXA"  name="DBVAR_FLOAT_VALOR_TAXA" type="text"  value="<%=getValue(objRS,"valor_taxa")%>" maxlength="6" class="" onKeyPress="return validateFloatKeyNew(this, event);">
                                </p>
                            </div>                                                                            
                            <div class="input-control text size2" data-role="input-control">
                                <p>
                                    <input id="DBVAR_FLOAT_PERC_TAXA"  name="DBVAR_FLOAT_PERC_TAXA" type="text"  value="<%=getValue(objRS,"perc_taxa")%>" maxlength="6" class="" onKeyPress="return validateFloatKeyNew(this, event);">
                                </p>
                            </div>                                                                            
                             <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                         </div> 
                     </div>  
                     <div class="row ">
                                <div class="span2"><p>Ariel Assunto:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_ARIEL_ASSUNTO"  name="DBVAR_STR_ARIEL_ASSUNTO" type="text"  value="<%=GetValue(objRS,"ARIEL_ASSUNTO")%>" maxlength="50"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                      <div class="row ">
                                <div class="span2"><p>Ariel:</p></div>
                                <div class="span8">
                                     <p class="input-control textarea" data-role="input-control"><textarea  id="DBVAR_STR_ARIEL"  name="DBVAR_STR_ARIEL" type="text"><%=GetValue(objRS,"ARIEL")%></textarea></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
					 
					 <div class="row ">
                                <div class="span2"><p>PROSHOP TEXTO FINAL:</p></div>
                                <div class="span8">
                                     <p class="input-control textarea" data-role="input-control"><textarea  id="DBVAR_STR_PROSHOP_TEXTO_FINAL"  name="DBVAR_STR_PROSHOP_TEXTO_FINAL" type="text"><%=GetValue(objRS,"PROSHOP_TEXTO_FINAL")%></textarea></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     
                </div> <!--FIM GRID//-->
        </div><!--fim do frame dados//-->
                <div class="frame" id="EXTRA" style="width:100%;">
                	<h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                		<div class="grid" style="border:0px solid #F00">
                      <div class="row ">
                                <div class="span2"><p>Ariel INTL :</p></div>
                                <div class="span8">
                                     <p class="input-control textarea" data-role="input-control"><textarea  id="DBVAR_STR_ARIEL_INTL"  name="DBVAR_STR_ARIEL_INTL" type="text"  ><%=GetValue(objRS,"ARIEL_INTL")%></textarea></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
    				<div class="row ">
                                <div class="span2"><p>Ariel INTL Assunto:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_ARIEL_INTL_ASSUNTO"  name="DBVAR_STR_ARIEL_INTL_ASSUNTO" type="text"  value="<%=GetValue(objRS,"ARIEL_INTL_ASSUNTO")%>" maxlength="200"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Captura:</p></div>
                                <div class="span8">
                                    <p>
                                        <input name="DBVAR_NUM_CAPTURA" id="DBVAR_NUM_CAPTURA"  type="radio" value="1" <% If getValue(objRS,"CAPTURA")= "1" Then Response.Write("checked") End If %> >
                                            Sim 
                                        <input name="DBVAR_NUM_CAPTURA" id="DBVAR_NUM_CAPTURA2"  type="radio" value="0" <% If not getValue(objRS,"CAPTURA")= "1" Then Response.Write("checked") End If %> >
                                            Não 
                                    </p>

                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>
                     <div class="row ">
                                <div class="span2"><p>Cabeçalho:</p></div>
                                <div class="span8">
                                     <p class="input-control textarea" data-role="input-control"><textarea  id="DBVAR_STR_CABECALHO"  name="DBVAR_STR_CABECALHO" type="text"  ><%=GetValue(objRS,"CABECALHO")%></textarea></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div> 
                     <div class="row ">
                                <div class="span2"><p>Rodapé:</p></div>
                                <div class="span8">
                                     <p class="input-control textarea" data-role="input-control"><textarea  id="DBVAR_STR_RODAPE"  name="DBVAR_STR_RODAPE" type="text"  ><%=GetValue(objRS,"CABECALHO")%></textarea></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>  
                      
                         <div class="row">
                        <div class="span2"><p>Controle Finalizar Compra:</p></div>
                        <div class="span8">
                            <p class="input-control select text " data-role="input-control">
                                <select name="CONTROLE_FINALIZAR_COMPRA" id="CONTROLE_FINALIZAR_COMPRA" >
                                    <option value="1" <%if getVALUE(objRS,"CONTROLE_FINALIZAR_COMPRA") ="1" then response.Write("selected") end if %> selected>Sim</option>
                                    <option value="0" <%if (getVALUE(objRS,"CONTROLE_FINALIZAR_COMPRA")) ="" or (getVALUE(objRS,"CONTROLE_FINALIZAR_COMPRA")) <> "1" then response.Write("selected") end if %>>Não</option>
                                </select>
                                <!--//-->
                            </p>
                        <span class="tertiary-text-secondary"></span>
                        </div>
                        <div class="row ">
                                <div class="span2"><p>Endereço:</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input  id="DBVAR_STR_ENDERECO"  name="DBVAR_STR_ENDERECO" type="text"  value="<%=GetValue(objRS,"ENDERECO")%>" maxlength="120"></p>
                                     <!--span class="tertiary-text-secondary">(variáveis de ambiente (session) podem ser utilizadas através de  chaves - { }).</span//-->  
                                </div> 
                     </div>

                    </div>             
                 </div> <!--FIM GRID//-->
            </div><!--fim do frame EXTRA//-->
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
'end if	
	'athDebug strSQL, true '---para testes'
%>                      
