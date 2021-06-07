<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_LocalCredencial",Session("ID_USER")), true %>
<%
 Const LTB = "TBL_LOCAL_CREDENCIAL" 		' - Nome da Tabela...
 Const DKN = "COD_LOCAL_CREDENCIAL" 		' - Campo chave...
 Const TIT = "LCredencial"  				' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

  'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 
 Dim  strCODLOCALCREDENCIAL, strNOME, strLOCAL, strDESCRICAO, strCODPAINEL
 
 strCODLOCALCREDENCIAL = Replace(GetParam("var_chavereg"),"'","''")
   
  'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB  

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     COD_LOCAL_CREDENCIAL "
 strSQL = strSQL & "		  , NOME"
 strSQL = strSQL & "		  , LOCAL "
 strSQL = strSQL & "		  , DESCRICAO "
 strSQL = strSQL & "    FROM " & LTB 
 strSQL = strSQL & "    WHERE COD_LOCAL_CREDENCIAL = COD_LOCAL_CREDENCIAL "
 strSQL = strSQL & "    ORDER BY COD_LOCAL_CREDENCIAL"
   
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
 
 
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_LocalCredencial/default.asp';") 
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
  document.formupdate.DEFAULT_LOCATION.value="../modulo_LocalCredencial/update.asp?var_chavereg=<%=strCODLOCALCREDENCIAL%>"; 
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
</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
	   <form name="formupdate" id="formupdate" action="../_database/athupdatetodb.asp" method="post">
                <input type="hidden" name="DEFAULT_TABLE" value="<%=LTB%>">
                <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                <input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
                <input type="hidden" name="RECORD_KEY_NAME" value="<%=DKN%>">
                <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODLOCALCREDENCIAL%>">
                <input type="hidden" name="DEFAULT_LOCATION" value="">
                <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
      <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCODLOCALCREDENCIAL%>.GERAL</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                     <div class="row">
                                <div class="span2"><p>*Nome:</p></div>
                                <div class="span8">
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_NOMEô" name="DBVAR_STR_NOMEô" type="text" placeholder="" value="<%=GetValue(objRS,"NOME")%>" maxlength="120"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div> 
                     <div class="row ">
                                <div class="span2" style=""><p>*Local:</p></div>
                                <div class="span8"> 
                                     <p class="input-control text " data-role="input-control"><input id="DBVAR_STR_LOCALô" name="DBVAR_STR_LOCALô" type="text" placeholder="" value="<%=GetValue(objRS,"LOCAL")%>" maxlength="120"></p>
                                     <span class="tertiary-text-secondary"></span>                             
                                </div>
                     </div> 
                     <div class="row">
                                <div class="span2" style=""><p>Descrição:</p></div>
                                <div class="span8">  
                                     <p class="input-control textarea " data-role="input-control"><textarea id="DBVAR_STR_DESCRICAO" name="DBVAR_STR_DESCRICAO"  placeholder="" ><%=GetValue(objRS,"DESCRICAO")%></textarea></p>
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
	
	'athDebug strSQL, true '---para testes'
%>