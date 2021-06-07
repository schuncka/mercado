<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("mini_ListaStatusCred",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "tbl_STATUS_CRED" 								    ' - Nome da Tabela...
 Const DKN = "COD_STATUS_CRED"									        ' - Campo chave...
 Const DLD = "../modulo_Evento/mini_ListaStatusCred/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Lista Tipo Credencial"									' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 
'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCOD_STATUS_CRED

strCOD_STATUS_CRED =  Replace(GetParam("var_chavereg"),"'","''")

If strCOD_STATUS_CRED <> "" Then
	
	AbreDBConn objConn, CFG_DB
	
	 strSQL = " SELECT SC.COD_STATUS_CRED "
 strSQL = strSQL & "		  , SC.STATUS "
 strSQL = strSQL & "		  ,SC.COD_STATUS_CRED "
 strSQL = strSQL & "		  ,SC.BGCOLOR "
 strSQL = strSQL & "		  ,SC.TIPOPESS "
 strSQL = strSQL & "		  ,SC.CONTATO_SHOW "
 strSQL = strSQL & "		  ,SC.CAEX_SHOW  "
 strSQL = strSQL & "		  ,SC.STATUS_INTL  "
 strSQL = strSQL & "		  ,SC.ORDEM "
 strSQL = strSQL & "		  ,SC.CAEX_LOGIN "
 strSQL = strSQL & "		  ,SC.BACKGROUND_SHOW "
 strSQL = strSQL & "		   FROM tbl_STATUS_CRED AS SC " 
 strSQL = strSQL & "		   WHERE SC.COD_STATUS_CRED = " & strCOD_STATUS_CRED
 strSQL = strSQL & "           ORDER BY SC.STATUS, SC.ORDEM " 
 
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
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_Evento/mini_ListaStatusCred/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_Evento/mini_ListaStatusCred/update.asp?var_chavereg=<%=strCOD_STATUS_CRED%>"; 
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
		 <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_STATUS_CRED%>">
        <input type="hidden" name="DEFAULT_LOCATION" value="">
        <input type="hidden" name="DEFAULT_MESSAGE" value="NOMESSAGE">
        <!--<input type="hidden" name="DBVAR_NUM_COD_EVENTO" id="DBVAR_NUM_COD_EVENTO" value="<'%=getValue(objRS,"COD_EVENTO")%>">//-->
 <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_STATUS_CRED%>.GERAL</a></li>
            <li class="#"><a href="#EXTRA">EXTRA</a></li>
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                    <div class="row">
                                <div class="span2"><p>Tipo Credencial:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_STATUS" id="DBVAR_STR_STATUS" value="<%=getValue(objRS,"STATUS")%>" maxlength="50"></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Cor(BGColor):&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_BGCOLOR" id="DBVAR_STR_BGCOLOR" value="<%=getValue(objRS,"BGCOLOR")%>" maxlength="45"></p>
                                     <span class="tertiary-text-secondary">EX.: #FFF ou #FFFFFF</span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Ordem:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_ORDEM" id="DBVAR_STR_ORDEM" value="<%=getValue(objRS,"ORDEM")%>" maxlength="10" onKeyPress="return validateNumKey(event);" class=""></p>
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Tipo Pess:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text select" data-role="input-control">
<!--                                     <input type="text" name="DBVAR_STR_TIPOPESS" id="DBVAR_STR_TIPOPESS" value="<'%=getValue(objRS,"TIPOPESS")%>" maxlength="2" onKeyPress="return validateNumKey(event);" class="size1">//-->                                     
                                        <select name="dbvar_str_TIPOPESS" id="dbvar_str_TIPOPESS" class="textbox250">
                                        <!--option value=""selected><'%=objRS("TIPOPESS")%></option//-->
                                        <option value="A" <%if objRS("TIPOPESS")="A" then response.Write("selected")%>>A(ambos)</option>
                                        <option value="F" <%if objRS("TIPOPESS")="F" then response.Write("selected")%>>F(fisico)</option>
                                        <option value="J" <%if objRS("TIPOPESS")="J" then response.Write("selected")%>>J(juridico)</option>
                                    </select>
                                     </p>
                                     
                                     <span class="tertiary-text-secondary"></span>
                                </div>
                     </div>
                      </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            <div class="frame" id="EXTRA" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                      <div class="row ">
                                <div class="span2"><p>*Contato Show:&nbsp;:</p></div>
                                <div class="span8"><p>
                                    <input type="radio"   name="DBVAR_STR_CONTATO_SHOW" id="DBVAR_STR_CONTATO_SHOWô"  value="1" <%If getValue(objRS,"CONTATO_SHOW") = "1" then response.Write("checked/") end if %>>
                                    Sim&nbsp;
                                    <input  type="radio"  name="DBVAR_STR_CONTATO_SHOW" id="DBVAR_STR_CONTATO_SHOW2ô"  value="0" <%If getValue(objRS,"CONTATO_SHOW") = "0" then response.Write("checked/") end if %>>
                                    Não
                                    </p><span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                      <div class="row ">
                                <div class="span2"><p>*CAEX Show:&nbsp;:</p></div>
                                <div class="span8"><p>
                                    <input type="radio"   name="DBVAR_STR_CAEX_SHOW" id="DBVAR_STR_CAEX_SHOWô"  value="1" <%If getValue(objRS,"CAEX_SHOW") = "1" then response.Write("checked/") end if %>>
                                    Sim&nbsp;
                                    <input  type="radio"  name="DBVAR_STR_CAEX_SHOW" id="DBVAR_STR_CAEX_SHOW2ô"  value="0" <%If getValue(objRS,"CAEX_SHOW") = "0" then response.Write("checked/") end if %>>
                                    Não
                                    </p><span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                     <div class="row ">
                                <div class="span2"><p>*CAEX Login:&nbsp;:</p></div>
                                <div class="span8"><p>
                                    <input type="radio"   name="DBVAR_STR_CAEX_LOGIN" id="DBVAR_STR_CAEX_LOGINô"  value="1" <%If getValue(objRS,"CAEX_LOGIN") = "1" then response.Write("checked/") end if %>>
                                    Sim&nbsp;
                                    <input  type="radio"  name="DBVAR_STR_CAEX_LOGIN" id="DBVAR_STR_CAEX_LOGIN2ô"  value="0" <%If getValue(objRS,"CAEX_LOGIN") = "0" then response.Write("checked/") end if %>>
                                    Não
                                    </p><span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                     <div class="row ">
                                <div class="span2"><p>*Background Show:&nbsp;</p></div>
                                <div class="span8"><p>
                                    <input type="radio"   name="DBVAR_STR_BACKGROUND_SHOW" id="DBVAR_STR_BACKGROUND_SHOWô"  value="1" <%If getValue(objRS,"BACKGROUND_SHOW") = "1" then response.Write("checked/") end if %>>
                                    Sim&nbsp;
                                    <input  type="radio"  name="DBVAR_STR_BACKGROUND_SHOW" id="DBVAR_STR_BACKGROUND_SHOW2ô"  value="0" <%If getValue(objRS,"BACKGROUND_SHOW") = "0" then response.Write("checked/") end if %>>
                                    Não
                                    </p><span class="tertiary-text-secondary"> </span>
                                </div>
                     </div>
                     <div class="row">
                                <div class="span2"><p>Status INTL:&nbsp;</p></div>
                                <div class="span8">
                                     <p class="input-control text" data-role="input-control"><input type="text" name="DBVAR_STR_STATUS_INTL" id="DBVAR_STR_STATUS_INTL" value="<%=getValue(objRS,"STATUS_INTL")%>" maxlength="50"></p>
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
