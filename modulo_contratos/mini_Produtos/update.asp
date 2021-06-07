<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("mini_Produtos",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"                          ' - Default do Modulo...
 Const LTB = "TBL_CLIENTES_PRODUTOS"	                ' - Nome da Tabela...
 Const DKN = "COD_TBL_CLIENTES"                         ' - Campo chave...
 Const DLD = "../modulo_clientes/mini_Produtos/default.asp" ' "../evento/data.asp" - 'Default Location ap�s Dele��o
 Const TIT = "Produtos"  								' - Nome/Titulo sendo referencia como titulo do m�dulo no bot�o de filtro

 'Relativas a conex�o com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Pagina��o	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCodCli

'---------------carrega cachereg do pai local cred-----------------

strCodCli= Replace(GetParam("var_chavereg"),"'","''")
'------------------------------------------------------------------

'------------------------------------------------------------------

strSQL = "select IDCategoria, cod_TBL_CLIENTES_PRODUTOS, CodigoDoCliente from tbl_clientes_produtos where  cod_TBL_CLIENTES_PRODUTOS = " & strCodCli
'abertura do banco de dados e configura��es de conex�o
 AbreDBConn objConn, CFG_DB 
set objRS = objConn.execute(strSQL)

%> 
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ---------
Criando uma condi��o pois na ATHWINDOW temos duas op��es
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
bot�es est�o aptos a retornar para default location�s
corretos em cada op��o de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_clientes/mini_Produtos/default.asp';") 
	 else
  		response.write ("document.forminsert.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}
function aplicar()      {  
  document.forminsert.DEFAULT_LOCATION.value="../modulo_clientes/mini_Produtos/insert.asp?var_chavereg=<%=strCodCli%>"; 
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
/* FIM: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ------- */
</script>
</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o t�tulo do m�dulo e a��o da dialog //-->
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
                    <input type="hidden" name="RECORD_KEY_NAME" value="CodigoDoCliente">
                    <input type="hidden" name="DEFAULT_LOCATION" value="">
					<input type="hidden" name="DBVAR_str_CodigoDoCliente" value="<%=strCodCli%>">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                <li class="active"><a href="#DADOS">GERAL</a></li>
                <!--li class="#"><a href="#EXTRA">EXTRA</a></li//-->
            </ul>
            <div class="frames">
                <div class="frame" id="DADOS" style="width:100%;">
                    <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                    <div class="grid" style="border:0px solid #F00">                      
                        <div class="row">
                            <div class="span2"><p>Produtos:</p></div>
                                    <div class="span8">
                                        <div class="input-control select size2" data-role="input-control">
                                            <p>
                                            <select name="DBVAR_STR_idcategoria" id="DBVAR_STR_idcategoria" class="">
                                                <% montaCombo "STR" ,"SELECT idprod, produto from tbl_produtos order by 1", "idprod", "produto", getValue(objRS,"IDCategoria")%>
                                            </select>
                                            </p>
                                        </div> 
                                    </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="span2"><p>Ficha BBM:</p></div> 
                                    <div class="span8">
                                        <div class="input-control radio margin10" data-role="input-control">
                                            <label>
                                                Sim
                                                <input type="radio" name="fichabbm" value="1"  <%if getValue(objRS,"ficha_bbm")="1" then %>checked <% end if %> />
                                                <span class="check"></span>
                                            </label>
                                        </div>
                                        <div class="input-control radio margin10" data-role="input-control">
                                            <label>N�o                                              
                                                <input type="radio" name="fichabbm" value="0" <%if getValue(objRS,"ficha_bbm")="0" then %>checked <% end if %>  />
                                                <span class="check"></span>
                                            </label>
                                        </div>
                                    </div> 
                        </div>
                                        
                    </div> <!--FIM GRID//-->
                </div><!--fim do frame dados//-->  
                </div> <!-- claa frames -->         
        </div><!--FIM TABCONTROL //--> 
  <div style="padding-top:16px;"><!--INI: BOT�ES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e/ou (*)</strong> campos obrigat�rios</small>
        </div> 
    </div><!--FIM: BOT�ES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>                    

